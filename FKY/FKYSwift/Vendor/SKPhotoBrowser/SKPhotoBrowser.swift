//
//  SKPhotoBrowser.swift
//  SKViewExample
//
//  Created by suzuki_keishi on 2015/10/01.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit

public let SKPHOTO_LOADING_DID_END_NOTIFICATION = "photoLoadingDidEndNotification"


// MARK: - SKPhotoBrowser

open class SKPhotoBrowser: UIViewController {
    
    let pageIndexTagOffset: Int = 1000
    
    // 自带控件...<不再使用>
    fileprivate var closeButton: SKCloseButton!
    fileprivate var deleteButton: SKDeleteButton!
    fileprivate var toolbar: SKToolbar!
    
    // 自定义btn
    fileprivate var rotationButton: UIButton!
    fileprivate var saveButton: UIButton!
    fileprivate var deleteBtn: UIButton!
    fileprivate var dismissBtn: UIButton!
    var showDeleteButton: Bool = false // 默认不显示
    var showAllBtns: Bool = true // 默认显示
    
    // actions
    fileprivate var activityViewController: UIActivityViewController!
    open var activityItemProvider: UIActivityItemProvider? = nil
    fileprivate var panGesture: UIPanGestureRecognizer!
    
    // tool for controls
    fileprivate var applicationWindow: UIWindow!
    fileprivate lazy var pagingScrollView: SKPagingScrollView = SKPagingScrollView(frame: self.view.frame, browser: self)
    var backgroundView: UIView!
    
    var initialPageIndex: Int = 0
    var currentPageIndex: Int = 0
    
    // for status check property
    fileprivate var isEndAnimationByToolBar: Bool = true
    fileprivate var isViewActive: Bool = false
    fileprivate var isPerformingLayout: Bool = false
    
    // pangesture property
    fileprivate var firstX: CGFloat = 0.0
    fileprivate var firstY: CGFloat = 0.0
    
    // timer
    fileprivate var controlVisibilityTimer: Timer!
    
    // delegate
    fileprivate let animator = SKAnimator()
    open weak var delegate: SKPhotoBrowserDelegate?
    
    // photos
    var photos: [SKPhotoProtocol] = [SKPhotoProtocol]()
    var numberOfPhotos: Int {
        return photos.count
    }
    
    // MARK - Initializer
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    public convenience init(photos: [SKPhotoProtocol]) {
        self.init(nibName: nil, bundle: nil)
        let pictures = photos.compactMap { $0 }
        for photo in pictures {
            photo.checkCache()
            self.photos.append(photo)
        }
    }
    
    public convenience init(originImage: UIImage, photos: [SKPhotoProtocol], animatedFromView: UIView) {
        self.init(nibName: nil, bundle: nil)
        animator.senderOriginImage = originImage
        animator.senderViewForAnimation = animatedFromView
        
        let pictures = photos.compactMap { $0 }
        for photo in pictures {
            photo.checkCache()
            self.photos.append(photo)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setup() {
        if let window = UIApplication.shared.delegate?.window {
            applicationWindow = window
        } else if let window = UIApplication.shared.keyWindow {
            applicationWindow = window
        } else {
            return
        }
        
        modalPresentationCapturesStatusBarAppearance = true
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleSKPhotoLoadingDidEndNotification(_:)),
                                               name: NSNotification.Name(rawValue: SKPHOTO_LOADING_DID_END_NOTIFICATION),
                                               object: nil)
    }
    
    // MARK: - override
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        
        configureCloseButton()
        configureDeleteButton()
        configureToolbar()
        
        configureRotationButton()
        configureSaveButton()
        configureDeleteBtn()
        configDismissBtn()
        
        resetAllBtnStatus()
        
        animator.willPresent(self)
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // 显示时显示状态栏
        UIApplication.shared.setStatusBarHidden(true, with: .fade)
        
        reloadData()
        
        var i = 0
        for photo: SKPhotoProtocol in photos {
            photo.index = i
            i = i + 1
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // 消失时显示状态栏
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        isPerformingLayout = true
        
        pagingScrollView.updateFrame(view.bounds, currentPageIndex: currentPageIndex)
        
        toolbar.frame = frameForToolbarAtOrientation()
        
        // where did start
        delegate?.didShowPhotoAtIndex?(currentPageIndex)
        
        isPerformingLayout = false
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        isViewActive = true
    }
    
    override open var prefersStatusBarHidden: Bool {
        get {
            return !SKPhotoBrowserOptions.displayStatusbar
        }
    }
    
    // MARK: - Notification
    @objc open func handleSKPhotoLoadingDidEndNotification(_ notification: Notification) {
        guard let photo = notification.object as? SKPhotoProtocol else {
            return
        }
        
        DispatchQueue.main.async(execute: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let page = strongSelf.pagingScrollView.pageDisplayingAtPhoto(photo), let photo = page.photo else {
                return
            }
            
            if photo.underlyingImage != nil {
                page.displayImage(complete: true)
                strongSelf.loadAdjacentPhotosIfNecessary(photo)
            } else {
                page.displayImageFailure()
            }
        })
    }
    
    open func loadAdjacentPhotosIfNecessary(_ photo: SKPhotoProtocol) {
        pagingScrollView.loadAdjacentPhotosIfNecessary(photo, currentPageIndex: currentPageIndex)
    }
    
    // MARK: - initialize / setup
    open func reloadData() {
        performLayout()
        view.setNeedsLayout()
    }
    
    open func performLayout() {
        isPerformingLayout = true
        
        toolbar.updateToolbar(currentPageIndex)
        
        // reset local cache
        pagingScrollView.reload()
        
        // reframe
        pagingScrollView.updateContentOffset(currentPageIndex)
        pagingScrollView.tilePages()
        
        delegate?.didShowPhotoAtIndex?(currentPageIndex)
        
        isPerformingLayout = false
    }
    
    open func prepareForClosePhotoBrowser() {
        cancelControlHiding()
        applicationWindow.removeGestureRecognizer(panGesture)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    open func dismissPhotoBrowser(animated: Bool, completion: (() -> Void)? = nil) {
        prepareForClosePhotoBrowser()

        if !animated {
            modalTransitionStyle = .crossDissolve
        }
        
        dismiss(animated: !animated) {
            completion?()
            self.delegate?.didDismissAtPageIndex?(self.currentPageIndex)
        }
    }

    open func determineAndClose() {
        delegate?.willDismissAtPageIndex?(currentPageIndex)
        animator.willDismiss(self)
    }
}


// MARK: - Public Function For Customizing Buttons

public extension SKPhotoBrowser {
  func updateCloseButton(_ image: UIImage, size: CGSize? = nil) {
        if closeButton == nil {
            configureCloseButton()
        }
    closeButton.setImage(image, for: UIControl.State())
    
        if let size = size {
            closeButton.setFrameSize(size)
        }
    }
  
  func updateDeleteButton(_ image: UIImage, size: CGSize? = nil) {
        if deleteButton == nil {
            configureDeleteButton()
        }
    deleteButton.setImage(image, for: UIControl.State())
    
        if let size = size {
            deleteButton.setFrameSize(size)
        }
    }
}


// MARK: - Public Function For Browser Control

public extension SKPhotoBrowser {
    func initializePageIndex(_ index: Int) {
        var i = index
        if index >= numberOfPhotos {
            i = numberOfPhotos - 1
        }
        
        initialPageIndex = i
        currentPageIndex = i
        
        if isViewLoaded {
            jumpToPageAtIndex(index)
            if !isViewActive {
                pagingScrollView.tilePages()
            }
        }
    }
    
    func jumpToPageAtIndex(_ index: Int) {
        if index < numberOfPhotos {
            if !isEndAnimationByToolBar {
                return
            }
            isEndAnimationByToolBar = false
            toolbar.updateToolbar(currentPageIndex)
            
            let pageFrame = frameForPageAtIndex(index)
            pagingScrollView.animate(pageFrame)
        }
        hideControlsAfterDelay()
    }
    
    func photoAtIndex(_ index: Int) -> SKPhotoProtocol {
        return photos[index]
    }
    
    @objc func gotoPreviousPage() {
        jumpToPageAtIndex(currentPageIndex - 1)
    }
    
    @objc func gotoNextPage() {
        jumpToPageAtIndex(currentPageIndex + 1)
    }
    
    func cancelControlHiding() {
        if controlVisibilityTimer != nil {
            controlVisibilityTimer.invalidate()
            controlVisibilityTimer = nil
        }
    }
    
    func hideControlsAfterDelay() {
        // reset
        cancelControlHiding()
        // start
        controlVisibilityTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(SKPhotoBrowser.hideControls(_:)), userInfo: nil, repeats: false)
    }
    
    func hideControls() {
        setControlsHidden(true, animated: true, permanent: false)
    }
    
    @objc func hideControls(_ timer: Timer) {
        hideControls()
        delegate?.controlsVisibilityToggled?(hidden: true)
    }
    
    // sigle tap
    func toggleControls() {
//        let hidden = !areControlsHidden()
//        setControlsHidden(hidden, animated: true, permanent: false)
//        delegate?.controlsVisibilityToggled?(hidden: areControlsHidden())
        
        //
        if self.showAllBtns {
            // 已显示，则隐藏
            self.dismissBtn.isHidden = true
            self.rotationButton.isHidden = true
            self.saveButton.isHidden = true
            if self.showDeleteButton {
                self.deleteBtn.isHidden = true
            }
            self.showAllBtns = false
        }
        else {
            // 已隐藏，则显示
            self.dismissBtn.isHidden = false
            self.rotationButton.isHidden = false
            self.saveButton.isHidden = false
            if self.showDeleteButton {
                self.deleteBtn.isHidden = false
            }
            self.showAllBtns = true
        }
    }
    
    func areControlsHidden() -> Bool {
        return toolbar.alpha == 0.0
    }
    
    func popupShare(includeCaption: Bool = true) {
        let photo = photos[currentPageIndex]
        guard let underlyingImage = photo.underlyingImage else {
            return
        }
        
        var activityItems: [AnyObject] = [underlyingImage]
        if photo.caption != nil && includeCaption {
            if let shareExtraCaption = SKPhotoBrowserOptions.shareExtraCaption {
                let caption = photo.caption + shareExtraCaption
                activityItems.append(caption as AnyObject)
            } else {
                activityItems.append(photo.caption as AnyObject)
            }
        }
        
        if let activityItemProvider = activityItemProvider {
            activityItems.append(activityItemProvider)
        }
        
        activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            self.hideControlsAfterDelay()
            self.activityViewController = nil
        }
        if UI_USER_INTERFACE_IDIOM() == .phone {
            present(activityViewController, animated: true, completion: nil)
        } else {
            activityViewController.modalPresentationStyle = .popover
            let popover: UIPopoverPresentationController! = activityViewController.popoverPresentationController
            popover.barButtonItem = toolbar.toolActionButton
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func getCurrentPageIndex() -> Int {
        return currentPageIndex
    }
}


// MARK: - Internal Function

internal extension SKPhotoBrowser {
    func showButtons() {
        if SKPhotoBrowserOptions.displayCloseButton {
            closeButton.alpha = 1
            closeButton.frame = closeButton.showFrame
        }
        if SKPhotoBrowserOptions.displayDeleteButton {
            deleteButton.alpha = 1
            deleteButton.frame = deleteButton.showFrame
        }
    }
    
    func pageDisplayedAtIndex(_ index: Int) -> SKZoomingScrollView? {
        return pagingScrollView.pageDisplayedAtIndex(index)
    }
    
    func getImageFromView(_ sender: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(sender.frame.size, true, 0.0)
        sender.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}


// MARK: - Internal Function For Frame Calc

internal extension SKPhotoBrowser {
    func frameForToolbarAtOrientation() -> CGRect {
        let currentOrientation = UIApplication.shared.statusBarOrientation
        var height: CGFloat = navigationController?.navigationBar.frame.size.height ?? 44
        if currentOrientation == .landscapeLeft || currentOrientation == .landscapeRight {
            height = 32
        }
//        if UIInterfaceOrientationIsLandscape(currentOrientation) {
//            height = 32
//        }
        return CGRect(x: 0, y: view.bounds.size.height - height, width: view.bounds.size.width, height: height)
    }
    
    func frameForToolbarHideAtOrientation() -> CGRect {
        let currentOrientation = UIApplication.shared.statusBarOrientation
        var height: CGFloat = navigationController?.navigationBar.frame.size.height ?? 44
        if currentOrientation == .landscapeLeft || currentOrientation == .landscapeRight {
            height = 32
        }
//        if UIInterfaceOrientationIsLandscape(currentOrientation) {
//            height = 32
//        }
        return CGRect(x: 0, y: view.bounds.size.height + height, width: view.bounds.size.width, height: height)
    }
    
    func frameForPageAtIndex(_ index: Int) -> CGRect {
        let bounds = pagingScrollView.bounds
        var pageFrame = bounds
        pageFrame.size.width -= (2 * 10)
        pageFrame.origin.x = (bounds.size.width * CGFloat(index)) + 10
        return pageFrame
    }
}


// MARK: - Internal Function For Button Pressed, UIGesture Control

internal extension SKPhotoBrowser {
    @objc func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        guard let zoomingScrollView: SKZoomingScrollView = pagingScrollView.pageDisplayedAtIndex(currentPageIndex) else {
            return
        }
        
        backgroundView.isHidden = true
        
        let viewHeight: CGFloat = zoomingScrollView.frame.size.height
        let viewHalfHeight: CGFloat = viewHeight/2
        var translatedPoint: CGPoint = sender.translation(in: self.view)
        
        // gesture began
        if sender.state == .began {
            firstX = zoomingScrollView.center.x
            firstY = zoomingScrollView.center.y
            
            hideControls()
            setNeedsStatusBarAppearanceUpdate()
        }
        
        translatedPoint = CGPoint(x: firstX, y: firstY + translatedPoint.y)
        zoomingScrollView.center = translatedPoint
        
        let minOffset: CGFloat = viewHalfHeight / 4
        let offset: CGFloat = 1 - (zoomingScrollView.center.y > viewHalfHeight
            ? zoomingScrollView.center.y - viewHalfHeight
            : -(zoomingScrollView.center.y - viewHalfHeight)) / viewHalfHeight
        
        view.backgroundColor = SKPhotoBrowserOptions.backgroundColor.withAlphaComponent(max(0.7, offset))
        
        // gesture end
        if sender.state == .ended {
            
            if zoomingScrollView.center.y > viewHalfHeight + minOffset
                || zoomingScrollView.center.y < viewHalfHeight - minOffset {
                
                backgroundView.backgroundColor = view.backgroundColor
                determineAndClose()
                
            } else {
                // Continue Showing View
                setNeedsStatusBarAppearanceUpdate()
                
                let velocityY: CGFloat = CGFloat(0.35) * sender.velocity(in: self.view).y
                let finalX: CGFloat = firstX
                let finalY: CGFloat = viewHalfHeight
                
                let animationDuration: Double = Double(abs(velocityY) * 0.0002 + 0.2)
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(animationDuration)
                UIView.setAnimationCurve(UIView.AnimationCurve.easeIn)
                view.backgroundColor = SKPhotoBrowserOptions.backgroundColor
                zoomingScrollView.center = CGPoint(x: finalX, y: finalY)
                UIView.commitAnimations()
            }
        }
    }
    
    @objc func deleteButtonPressed(_ sender: UIButton) {
        delegate?.removePhoto?(self, index: currentPageIndex) { [weak self] in
            self?.deleteImage()
        }
    }
    
    @objc func closeButtonPressed(_ sender: UIButton) {
        determineAndClose()
    }
    
    @objc func rotationButtonPressed(_ sender: UIButton) {
        rotateImage()
    }
    
    @objc func saveButtonPressed(_ sender: UIButton) {
        // URLdownload
        if self.photos[currentPageIndex] is SKPhoto {
            let photo = self.photos[currentPageIndex] as! SKPhoto
            let url = photo.photoURL
            let img = photo.underlyingImage
            // 通过url保存...<优先>
            if url != nil && url?.isEmpty == false {
                CredentialsImagePickController().savePhotoToAlbum(url!)
                return
            }
            // 直接保存img
            if img != nil {
                CredentialsImagePickController().saveImageToAlbum(img!)
                return
            }
        }
    }
    
    @objc func actionButtonPressed(ignoreAndShare: Bool) {
        delegate?.willShowActionSheet?(currentPageIndex)
        
        guard numberOfPhotos > 0 else {
            return
        }
        
        if let titles = SKPhotoBrowserOptions.actionButtonTitles {
            let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            }))
            for idx in titles.indices {
                actionSheetController.addAction(UIAlertAction(title: titles[idx], style: .default, handler: { (action) -> Void in
                    self.delegate?.didDismissActionSheetWithButtonIndex?(idx, photoIndex: self.currentPageIndex)
                }))
            }
            
            if UI_USER_INTERFACE_IDIOM() == .phone {
                present(actionSheetController, animated: true, completion: nil)
            } else {
                actionSheetController.modalPresentationStyle = .popover
                
                if let popoverController = actionSheetController.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.barButtonItem = toolbar.toolActionButton
                }
                
                present(actionSheetController, animated: true, completion: { () -> Void in
                })
            }
            
        } else {
            popupShare()
        }
    }
}


// MARK: - Private Function

private extension SKPhotoBrowser {
    func configureAppearance() {
        view.backgroundColor = SKPhotoBrowserOptions.backgroundColor
        view.clipsToBounds = true
        view.isOpaque = false
        
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: SKMesurement.screenWidth, height: SKMesurement.screenHeight))
        backgroundView.backgroundColor = SKPhotoBrowserOptions.backgroundColor
        backgroundView.alpha = 0.0
        applicationWindow.addSubview(backgroundView)
        
        pagingScrollView.delegate = self
        view.addSubview(pagingScrollView)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(SKPhotoBrowser.panGestureRecognized(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        if !SKPhotoBrowserOptions.disableVerticalSwipe {
            view.addGestureRecognizer(panGesture)
        }
    }
    
    // 关闭按钮...<不再使用>
    func configureCloseButton() {
        closeButton = SKCloseButton(frame: .zero)
        closeButton.addTarget(self, action: #selector(closeButtonPressed(_:)), for: .touchUpInside)
        closeButton.isHidden = !SKPhotoBrowserOptions.displayCloseButton
        view.addSubview(closeButton)
        // 隐藏
        closeButton.isHidden = true
    }
    
    // 删除按钮...<不再使用>
    func configureDeleteButton() {
        deleteButton = SKDeleteButton(frame: .zero)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        deleteButton.isHidden = !SKPhotoBrowserOptions.displayDeleteButton
        view.addSubview(deleteButton)
        // 隐藏
        deleteButton.isHidden = true
    }
    
    // 底部工具栏...<不再使用>
    func configureToolbar() {
        toolbar = SKToolbar(frame: frameForToolbarAtOrientation(), browser: self)
        view.addSubview(toolbar)
        // 隐藏
        toolbar.isHidden = true
    }
    
    // 旋转按钮
    func configureRotationButton() {
        let bottomMargin = SKPhotoBrowser.getScreenBottomMargin()
        
        rotationButton = UIButton()
        rotationButton.setImage(UIImage(named: "icon_shop_rotate"), for: [.normal])
        rotationButton.backgroundColor = .black
        rotationButton.layer.cornerRadius = 4
        rotationButton.layer.masksToBounds = true
        rotationButton.alpha = 0.8
        rotationButton.frame = CGRect(x: WH(15), y: SKMesurement.screenHeight - WH(55) - bottomMargin, width: WH(40), height: WH(40))
        rotationButton.addTarget(self, action: #selector(rotationButtonPressed(_:)), for: .touchUpInside)
        rotationButton.isHidden = !SKPhotoBrowserOptions.displayRotationButton
        view.addSubview(rotationButton)
    }
    
    // 保存按钮
    func configureSaveButton() {
        let bottomMargin = SKPhotoBrowser.getScreenBottomMargin()
        
        saveButton = UIButton()
        saveButton.setImage(UIImage(named: "btn_download"), for: [.normal])
//        saveButton.setTitle("保存", for: [.normal])
//        saveButton.fontTuple = t45
        saveButton.backgroundColor = .black
        saveButton.layer.cornerRadius = 4
        saveButton.layer.masksToBounds = true
        saveButton.alpha = 0.8
        saveButton.frame = CGRect(x: SKMesurement.screenWidth - WH(55), y: SKMesurement.screenHeight - WH(55) - bottomMargin, width: WH(40), height: WH(40))
        saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        saveButton.isHidden = !SKPhotoBrowserOptions.displaySaveButton
        view.addSubview(saveButton)
    }
    
    // 删除按钮
    func configureDeleteBtn() {
        let topMargin = SKPhotoBrowser.getScreenTopMargin()
        
        deleteBtn = UIButton()
        deleteBtn.setImage(UIImage(named: "icon_credentials_delete"), for: [.normal])
        deleteBtn.backgroundColor = .black
        deleteBtn.layer.cornerRadius = 4
        deleteBtn.layer.masksToBounds = true
        deleteBtn.alpha = 0.8
        deleteBtn.frame = CGRect(x: SKMesurement.screenWidth - WH(55), y: 10 + topMargin, width: WH(40), height: WH(40))
        deleteBtn.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        deleteBtn.isHidden = !self.showDeleteButton
        view.addSubview(deleteBtn)
    }
    
    // 关闭按钮
    func configDismissBtn() {
        let topMargin = SKPhotoBrowser.getScreenTopMargin()
        
        dismissBtn = UIButton()
        dismissBtn.setImage(UIImage(named: "btn_common_close"), for: [.normal])
        dismissBtn.backgroundColor = .black
        dismissBtn.layer.cornerRadius = 4
        dismissBtn.layer.masksToBounds = true
        dismissBtn.alpha = 0.8
        dismissBtn.frame = CGRect(x: WH(15), y: 10 + topMargin, width: WH(40), height: WH(40))
        dismissBtn.addTarget(self, action: #selector(closeButtonPressed(_:)), for: .touchUpInside)
        dismissBtn.isHidden = false
        view.addSubview(dismissBtn)
    }
    
    // 初始化时默认隐藏所有btn
    func resetAllBtnStatus() {
        self.dismissBtn.isHidden = true
        self.rotationButton.isHidden = true
        self.saveButton.isHidden = true
        if self.showDeleteButton {
            self.deleteBtn.isHidden = true
        }
        self.showAllBtns = false
    }
    
    func setControlsHidden(_ hidden: Bool, animated: Bool, permanent: Bool) {
        cancelControlHiding()
        
        let captionViews = pagingScrollView.getCaptionViews()
        
        UIView.animate(withDuration: 0.35,
            animations: { () -> Void in
                let alpha: CGFloat = hidden ? 0.0 : 1.0
                self.toolbar.alpha = alpha
                self.toolbar.frame = hidden ? self.frameForToolbarHideAtOrientation() : self.frameForToolbarAtOrientation()
                
                if SKPhotoBrowserOptions.displayCloseButton {
                    self.closeButton.alpha = alpha
                    self.closeButton.frame = hidden ? self.closeButton.hideFrame : self.closeButton.showFrame
                }
                if SKPhotoBrowserOptions.displayDeleteButton {
                    self.deleteButton.alpha = alpha
                    self.deleteButton.frame = hidden ? self.deleteButton.hideFrame : self.deleteButton.showFrame
                }
                captionViews.forEach { $0.alpha = alpha }
            },
            completion: nil)
        
        if !permanent {
            hideControlsAfterDelay()
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // 删除图片
    func deleteImage() {
        defer {
            reloadData()
        }
        
        if photos.count > 1 {
            // 不止一张图片
            pagingScrollView.deleteImage()
            photos.remove(at: currentPageIndex)
            if currentPageIndex != 0 {
                gotoPreviousPage()
            }
            toolbar.updateToolbar(currentPageIndex)
        } else if photos.count == 1 {
            // 仅一张图片
            dismissPhotoBrowser(animated: true)
        }
    }
    
    // 旋转图片
    func rotateImage() {
        if photos.count > 0 {
            pagingScrollView.rotateImageView()
        }
    }
}


// MARK: -  UIScrollView Delegate

extension SKPhotoBrowser: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isViewActive else {
            return
        }
        guard !isPerformingLayout else {
            return
        }
        
        // tile page
        pagingScrollView.tilePages()
        
        // Calculate current page
        let previousCurrentPage = currentPageIndex
        let visibleBounds = pagingScrollView.bounds
        currentPageIndex = min(max(Int(floor(visibleBounds.midX / visibleBounds.width)), 0), numberOfPhotos - 1)
        
        if currentPageIndex != previousCurrentPage {
            delegate?.didShowPhotoAtIndex?(currentPageIndex)
            toolbar.updateToolbar(currentPageIndex)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        hideControlsAfterDelay()
        
        let currentIndex = pagingScrollView.contentOffset.x / pagingScrollView.frame.size.width
        delegate?.didScrollToIndex?(Int(currentIndex))
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isEndAnimationByToolBar = true
    }
}


// MARK: - Class
extension SKPhotoBrowser {
    // 屏幕底部margin...<适配iPhone X系列>
    class func getScreenBottomMargin() -> CGFloat {
        var margin: CGFloat = 0
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                margin = iPhoneX_SafeArea_BottomInset
            }
        }
        return margin
    }
    
    // 屏幕顶部margin...<适配iPhone X系列>
    class func getScreenTopMargin() -> CGFloat {
        var margin: CGFloat = 0
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                margin = 24
            }
        }
        return margin
    }
}

