
//
//  SKZoomingScrollView.swift
//  SKViewExample
//
//  Created by suzuki_keihsi on 2015/10/01.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit

open class SKZoomingScrollView: UIScrollView {
    var captionView: SKCaptionView!
    var photo: SKPhotoProtocol! {
        didSet {
            photoImageView.image = nil
            if photo != nil && photo.underlyingImage != nil {
                displayImage(complete: true)
            }
            if photo != nil {
                displayImage(complete: false)
            }
        }
    }
    
    fileprivate(set) var photoImageView: SKDetectingImageView!
    fileprivate weak var photoBrowser: SKPhotoBrowser?
    fileprivate var tapView: SKDetectingView!
    fileprivate var indicatorView: SKIndicatorView!
    fileprivate var photoViewScale: CGFloat = 1.0
    fileprivate let minScale: CGFloat = 1.0
    fileprivate let maxScale: CGFloat = 2.5
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(frame: CGRect, browser: SKPhotoBrowser) {
        self.init(frame: frame)
        photoBrowser = browser
        setup()
    }
    
    deinit {
        photoBrowser = nil
    }
    
    func setup() {
        // tap
        tapView = SKDetectingView(frame: bounds)
        tapView.delegate = self
        tapView.backgroundColor = .clear
        tapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(tapView)
        
        // image
        photoImageView = SKDetectingImageView(frame: frame)
        photoImageView.delegate = self
        photoImageView.contentMode = .bottom
        photoImageView.backgroundColor = .clear
        addSubview(photoImageView)
        
        // indicator
        indicatorView = SKIndicatorView(frame: frame)
        addSubview(indicatorView)
        
        // self
        backgroundColor = .clear
        delegate = self
        showsHorizontalScrollIndicator = SKPhotoBrowserOptions.displayHorizontalScrollIndicator
        showsVerticalScrollIndicator = SKPhotoBrowserOptions.displayVerticalScrollIndicator
        decelerationRate = UIScrollView.DecelerationRate.fast
        autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin]
    }
    
    // MARK: - override
    
    open override func layoutSubviews() {
        tapView.frame = bounds
        indicatorView.frame = bounds
        
        super.layoutSubviews()
        
        let boundsSize = bounds.size
        var frameToCenter = photoImageView.frame
        
        // horizon
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = floor((boundsSize.width - frameToCenter.size.width) / 2)
        } else {
            frameToCenter.origin.x = 0
        }
        // vertical
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = floor((boundsSize.height - frameToCenter.size.height) / 2)
        } else {
            frameToCenter.origin.y = 0
        }
        
        // Center
        if !photoImageView.frame.equalTo(frameToCenter) {
            photoImageView.frame = frameToCenter
        }
    }
    
    open func setMaxMinZoomScalesForCurrentBounds() {
        maximumZoomScale = 1
        minimumZoomScale = 1
        zoomScale = 1
        
        guard let photoImageView = photoImageView else {
            return
        }
        
        let boundsSize = bounds.size
        let imageSize = photoImageView.frame.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale: CGFloat = min(xScale, yScale)
        var maxScale: CGFloat = 1.0
        
        let scale = max(UIScreen.main.scale, 2.0)
        let deviceScreenWidth = UIScreen.main.bounds.width * scale // width in pixels. scale needs to remove if to use the old algorithm
        let deviceScreenHeight = UIScreen.main.bounds.height * scale // height in pixels. scale needs to remove if to use the old algorithm
        
        if photoImageView.frame.width < deviceScreenWidth {
            // I think that we should to get coefficient between device screen width and image width and assign it to maxScale. I made two mode that we will get the same result for different device orientations.
            if UIApplication.shared.statusBarOrientation.isPortrait {
                maxScale = deviceScreenHeight / photoImageView.frame.width
            } else {
                maxScale = deviceScreenWidth / photoImageView.frame.width
            }
        } else if photoImageView.frame.width > deviceScreenWidth {
            maxScale = 1.0
        } else {
            // here if photoImageView.frame.width == deviceScreenWidth
            maxScale = 2.5
        }
    
//        maximumZoomScale = maxScale
//        minimumZoomScale = minScale
        zoomScale = minScale
        
        // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
        // maximum zoom scale to 0.5
        // After changing this value, we still never use more
        /*
        maxScale = maxScale / scale 
        if maxScale < minScale {
            maxScale = minScale * 2
        }
        */
        
        // reset position
        photoImageView.frame = CGRect(x: 0, y: 0, width: photoImageView.frame.size.width, height: photoImageView.frame.size.height)
        setNeedsLayout()
    }
    
    open func prepareForReuse() {
        photo = nil
        if captionView != nil {
            captionView.removeFromSuperview()
            captionView = nil 
        }
    }
    
    // MARK: - image
    open func displayImage(complete flag: Bool) {
        // reset scale
        maximumZoomScale = 1
        minimumZoomScale = 1
        zoomScale = 1
        contentSize = CGSize.zero
        
        if !flag {
            if photo.underlyingImage == nil {
                self.insertSubview(self.tapView, aboveSubview: indicatorView)
                indicatorView.startAnimating()
            }
            photo.loadUnderlyingImageAndNotify()
        } else {
            indicatorView.stopAnimating()
            self.insertSubview(self.tapView, belowSubview: self.photoImageView)
        }
        
        if let image = photo.underlyingImage {
            // image
            photoImageView.image = image
            photoImageView.contentMode = photo.contentMode
            photoImageView.backgroundColor = SKPhotoBrowserOptions.backgroundColor
            
            var photoImageViewFrame = CGRect.zero
            photoImageViewFrame.origin = CGPoint.zero
            photoImageViewFrame.size = image.size
            if image.size.width > bounds.size.width  {
                let width = bounds.size.width
                let height = image.size.height * bounds.size.width / image.size.width
                photoImageViewFrame.size = CGSize(width: width, height: height)
            }
            photoImageView.frame = photoImageViewFrame
            
            contentSize = photoImageViewFrame.size
            
            setMaxMinZoomScalesForCurrentBounds()
        }
        setNeedsLayout()
    }
    
    open func displayImageFailure() {
        indicatorView.stopAnimating()
    }
    
    // MARK: - handle tap
    open func handleDoubleTap(_ touchPoint: CGPoint) {
        if let photoBrowser = photoBrowser {
            NSObject.cancelPreviousPerformRequests(withTarget: photoBrowser)
        }
        
        guard (self.photoImageView.image != nil) else {
            return
        }
        if photoImageView.zoomScale > minScale {
            // zoom out
            
            let width = self.bounds.size.width * self.maxScale
            let height = self.photoImageView.image!.size.height * self.bounds.size.width / self.photoImageView.image!.size.width * self.maxScale
            photoImageView.layer.anchorPoint = CGPoint(x: touchPoint.x / (self.bounds.size.width * self.maxScale), y: touchPoint.y / height)
            if (photoImageView.rotationAngle > 0) {
                _ = (self.bounds.size.width - touchPoint.y) * self.maxScale / height
                _ = touchPoint.x / self.bounds.size.width
                photoImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            }
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.photoImageView.transform = strongSelf.photoImageView.transform.scaledBy(x: strongSelf.minScale / strongSelf.maxScale, y: strongSelf.minScale / strongSelf.maxScale)
            })
            
            photoImageView.zoomScale = minScale
            //            print("zoom out  \(pointX)  \(pointY)")
            print("\(touchPoint.x) \(touchPoint.y)")
            contentSize = CGSize(width: width / maxScale, height: height / maxScale)
            setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            setNeedsLayout()
            // photoView zoom
        } else {
            // zoom in
            // I think that the result should be the same after double touch or pinch
            /* var newZoom: CGFloat = zoomScale * 3.13
             if newZoom >= maximumZoomScale {
             newZoom = maximumZoomScale
             }
             */
            let width = self.bounds.size.width * self.maxScale
            let height = self.photoImageView.image!.size.height * self.bounds.size.width / self.photoImageView.image!.size.width * self.maxScale
            var offsetX = touchPoint.x * (self.maxScale-self.minScale)
            var offsetY = touchPoint.y * (self.maxScale-self.minScale)
            photoImageView.layer.anchorPoint = CGPoint(x: touchPoint.x / self.bounds.size.width, y: touchPoint.y  * self.maxScale / height)
            if (photoImageView.rotationAngle > 0) {
                let imageScale = width/height
                
                _ = (self.bounds.size.width - touchPoint.y) / self.bounds.size.width
                //                    (touchPoint.y + (self.bounds.size.width * ( 1 - imageScale))/2.0) / self.bounds.size.width
                _ = (touchPoint.x - ((height / self.maxScale) - self.bounds.size.width * imageScale)/2.0 ) * self.maxScale / height
                // 当前坐标系image 00位置
                //                let currentImageZeroPoint = CGPointMake(self.bounds.size.width, self.bounds.size.height / 2.0 - (self.bounds.size.width * imageScale/2.0))
                //                let touchPFather = CGPointMake(currentImageZeroPoint.x - touchPoint.y, currentImageZeroPoint.y - touchPoint.x)
                //                photoImageView.layer.anchorPoint = CGPointMake(touchPoint.x * imageScale / self.bounds.size.width, touchPoint.y/self.bounds.size.width)
                //                photoImageView.layer.anchorPoint = CGPointMake(touchPFather.x/self.bounds.size.width, touchPFather.y/self.bounds.size.height)
                //                photoImageView.layer.anchorPoint = CGPointMake(touchPoint.x / self.bounds.size.width , touchPoint.y * imageScale / self.bounds.size.width)
                // TODO: anchorPoint 优化
                photoImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                offsetX = (self.bounds.size.width - touchPoint.y) * (self.maxScale-self.minScale)
                offsetY = touchPoint.x * (self.maxScale-self.minScale)
            }
            
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.photoImageView.transform = strongSelf.photoImageView.transform.scaledBy(x: strongSelf.maxScale, y: strongSelf.maxScale)
            })
            
            photoImageView.zoomScale = maxScale
            
            contentSize = CGSize(width: width, height: height)
            setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: false)
            setNeedsLayout()
            // photoView zoom
        }
        
        // delay control
        photoBrowser?.hideControlsAfterDelay()
    }
    
    // MARK: - handle pinch
    public func handlePinch(touchPoint: CGPoint,scale: CGFloat) {
        guard (self.photoImageView.image != nil) else {
            return
        }
        var photoZoomScale = photoViewScale
        photoViewScale = photoImageView.zoomScale
        if (scale * photoViewScale) >= minScale && (scale * photoViewScale) <= maxScale {
            photoZoomScale = scale
            photoViewScale = scale * photoViewScale
        }
        if (scale * photoViewScale) < minScale {
            photoZoomScale = (minScale / photoViewScale)
            photoViewScale = minScale
        }
        if (scale * photoViewScale) > maxScale {
            photoZoomScale = (maxScale / photoViewScale)
            photoViewScale = maxScale
        }
        let height = self.photoImageView.image!.size.height * self.bounds.size.width / self.photoImageView.image!.size.width
        photoImageView.layer.anchorPoint = CGPoint(x: touchPoint.x / self.bounds.size.width, y: touchPoint.y / height)
        if (photoImageView.rotationAngle > 0) {
            photoImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        photoImageView.transform = photoImageView.transform.scaledBy(x: photoZoomScale, y: photoZoomScale)
        photoImageView.zoomScale = photoImageView.zoomScale * photoZoomScale
        
        contentSize = CGSize(width: photoImageView.frame.size.width * photoZoomScale, height: photoImageView.frame.size.height * photoZoomScale)
        var offsetX: CGFloat = 0.0
        var offsetY: CGFloat = 0.0
        if photoImageView.frame.size.width * photoZoomScale > bounds.size.width {
            offsetX = (photoImageView.frame.size.width * photoZoomScale - bounds.size.width) * (photoImageView.lastPoint.x / (photoImageView.frame.size.width * photoZoomScale))
            offsetX = (photoImageView.frame.size.width * photoZoomScale - bounds.size.width) * (touchPoint.x / self.bounds.size.width)
            offsetY = photoImageView.frame.size.height * photoZoomScale - bounds.size.height * (photoImageView.lastPoint.y / (photoImageView.frame.size.height * photoZoomScale))
            offsetY = (photoImageView.frame.size.height * photoZoomScale - bounds.size.height) * (touchPoint.y / height)
            
            if (photoImageView.rotationAngle > 0) {
                offsetX = (self.bounds.size.width - touchPoint.y) * (photoImageView.zoomScale-self.minScale)
                offsetY = touchPoint.x * (photoImageView.zoomScale-self.minScale)
            }
        }
        setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: false)
        setNeedsLayout()
    }
    
    // MARK: - handle rotate
    public func rotateImage() {
        photoImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        if self.photoImageView.image == nil {
            return
        }
        UIView.animate(withDuration: 0.05, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.photoImageView.transform = strongSelf.photoImageView.transform.rotated(by: CGFloat(Double.pi / 2))
            strongSelf.photoImageView.rotationAngle = strongSelf.photoImageView.rotationAngle + Double.pi / 2
            //self.photoImageView.rotationAngle = 2 * Double.pi * (self.photoImageView.rotationAngle / (Double.pi*2) - floor(Double(self.photoImageView.rotationAngle / (Double.pi*2))))
            // 修复Xcode10.2中编辑器无法识别复杂语句的问题
            let value0 = strongSelf.photoImageView.rotationAngle / (Double.pi*2)
            let value1 = floor(Double(value0))
            strongSelf.photoImageView.rotationAngle = 2 * Double.pi * (value0 - value1)
        }) {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            var photoImageViewFrame = CGRect.zero
            photoImageViewFrame.origin = CGPoint.zero
            photoImageViewFrame.size = strongSelf.photoImageView.image!.size
            if strongSelf.photoImageView.image!.size.width > strongSelf.bounds.size.width  {
                let width = strongSelf.bounds.size.width
                let height = strongSelf.photoImageView.image!.size.height * strongSelf.bounds.size.width / strongSelf.photoImageView.image!.size.width
                photoImageViewFrame.size = CGSize(width: width, height: height)
            }
            
            strongSelf.photoImageView.frame = photoImageViewFrame
            strongSelf.photoImageView.contentMode = .scaleAspectFit
            strongSelf.photoImageView.zoomScale = strongSelf.minScale
            
            strongSelf.contentSize = photoImageViewFrame.size
        }
    }
}

// MARK: - UIScrollViewDelegate

extension SKZoomingScrollView: UIScrollViewDelegate {
//    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return photoImageView
//    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        photoBrowser?.cancelControlHiding()
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: - SKDetectingImageViewDelegate

extension SKZoomingScrollView: SKDetectingViewDelegate {
    // 单击
    func handleSingleTap(_ view: UIView, touch: UITouch) {
        guard let browser = photoBrowser else {
            return
        }
        guard SKPhotoBrowserOptions.enableZoomBlackArea == true else {
            return
        }
        
        if browser.areControlsHidden() == false && SKPhotoBrowserOptions.enableSingleTapDismiss == true {
            browser.determineAndClose()
        } else {
            browser.toggleControls()
        }
    }
    
    // 双击
    func handleDoubleTap(_ view: UIView, touch: UITouch) {
        if SKPhotoBrowserOptions.enableZoomBlackArea == true {
            let needPoint = getViewFramePercent(view, touch: touch)
            handleDoubleTap(needPoint)
        }
    }
    
    // 挤捏
    func handlePinch(view: UIView, touch: UITouch, scale: CGFloat) {
        if SKPhotoBrowserOptions.enableZoomBlackArea == true {
            let needPoint = getViewFramePercent(view, touch: touch)
            handlePinch(touchPoint: needPoint, scale: scale)
        }
    }
}


// MARK: - SKDetectingImageViewDelegate

extension SKZoomingScrollView: SKDetectingImageViewDelegate {
    func handleImageViewSingleTap(_ touchPoint: CGPoint) {
        guard let browser = photoBrowser else {
            return
        }
        if SKPhotoBrowserOptions.enableSingleTapDismiss {
            browser.determineAndClose()
        } else {
            browser.toggleControls()
        }
    }
    
    func handleImageViewDoubleTap(_ touchPoint: CGPoint) {
        handleDoubleTap(touchPoint)
    }
    
    func handleImageViewPinch(touchPoint: CGPoint, scale: CGFloat) {
        handlePinch(touchPoint: touchPoint, scale: scale)
    }
}

private extension SKZoomingScrollView {
    func getViewFramePercent(_ view: UIView, touch: UITouch) -> CGPoint {
        let oneWidthViewPercent = view.bounds.width / 100
        let viewTouchPoint = touch.location(in: view)
        let viewWidthTouch = viewTouchPoint.x
        let viewPercentTouch = viewWidthTouch / oneWidthViewPercent
        
        let photoWidth = photoImageView.bounds.width
        let onePhotoPercent = photoWidth / 100
        let needPoint = viewPercentTouch * onePhotoPercent
        
        var Y: CGFloat!
        
        if viewTouchPoint.y < view.bounds.height / 2 {
            Y = 0
        } else {
            Y = photoImageView.bounds.height
        }
        let allPoint = CGPoint(x: needPoint, y: Y)
        return allPoint
    }
    
    func zoomRectForScrollViewWith(_ scale: CGFloat, touchPoint: CGPoint) -> CGRect {
        let w = frame.size.width / scale
        let h = frame.size.height / scale
        let x = touchPoint.x - (h / max(UIScreen.main.scale, 2.0))
        let y = touchPoint.y - (w / max(UIScreen.main.scale, 2.0))
        
        return CGRect(x: x, y: y, width: w, height: h)
    }
}
