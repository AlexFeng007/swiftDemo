//
//  RIImageController.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  注册信息（资料管理）之图片内容...<公司资质图片>

import UIKit


// 当前界面展示模式
enum RIImageMode : Int {
    case submit = 0     // 提交（审核）...<上传并提审>
    case update = 1     // （提交审核后的）更新...<可修改>
    case show = 2       // （提交审核后的）展示...<不可修改>
}


class RIImageController: UIViewController {
    //MARK: - Property
    
    // 界面展示模式...<默认是上传图片并提交审核>
    var showMode: RIImageMode = .submit
    
    // 用户已提交的资质model...<查看or修改>
     var zzModel: ZZModel?
    
    // ViewModel
    fileprivate lazy var viewModel: RIImageViewModel = {
        let vm = RIImageViewModel()
        vm.zzImageModel = self.zzModel
        vm.showMode = self.showMode
        return vm
    }()
    
    // 企业类型切掉tab视图与界面顶部固定视图的间距
    fileprivate var topMargin: CGFloat = WH(90)
    
    // collectionView滑动偏移量...<用于判断上滑or下滑>
    //fileprivate var lastContentOffset: CGFloat = 0
    
    // 手动切换tab时禁用scrollview的滑动逻辑，避免两种滑动逻辑冲突
    fileprivate var stopScrollCalculate = false
    
    // 当前用户操作的索引项...<上传图片、查看图片、删除图片>...<资质数据源索引，而非界面数据源索引>
    fileprivate var selectedIndexPath: IndexPath?
    // 用户点击查看的图片视图
    fileprivate var selectedImageView: UIView?
    
    // collectionView视图高度
    fileprivate var collectionViewHeight: CGFloat {
        get {
            var NavHeight: CGFloat = 64
            var margin: CGFloat = 0
            if #available(iOS 11, *) {
                let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
                if (insets?.bottom)! > CGFloat.init(0) {
                    // iPhone X
                    margin = iPhoneX_SafeArea_BottomInset
                    NavHeight = iPhoneX_SafeArea_TopInset
                }
            }
            return SCREEN_HEIGHT - NavHeight - margin - WH(32) - WH(62)
        }
    }
    
    // 导航栏
    fileprivate lazy var navBar: UIView? = {
        if let _ = self.NavigationBar {
            //
        }
        else {
            self.fky_setupNavBar()
        }
        self.NavigationBar?.backgroundColor = bg1
        return self.NavigationBar
    }()
    
    // 顶部提示视图...<置顶>
    fileprivate lazy var viewTip: RITopTipView = {
        let view = RITopTipView()
        view.configView("以下标“*”的为必传证件，请上传正面、清晰的照片")
        return view
    }()
    
    // collectionView(底部)背景视图
    fileprivate lazy var viewBg: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        // 需根据collectionView滑动的偏移量来动态设置高度
        view.addSubview(self.viewUpdate)
        self.viewUpdate.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(WH(0))
        }
        
        return view
    }()
    // viewBg顶部可变高度视图
    fileprivate lazy var viewUpdate: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        return view
    }()
    
    // 图片集合视图
    fileprivate lazy var collectionView: UICollectionView = {
        //let flowLayout = UICollectionViewFlowLayout()
        let flowLayout = SBCollectionViewFlowLayout()
        // 设置滚动的方向
        flowLayout.scrollDirection = .vertical
        // 设置item的大小
        flowLayout.itemSize = CGSize(width: (SCREEN_WIDTH - WH(10)) / 2, height: WH(120))
        // 设置同一组当中，行与行之间的最小行间距
        flowLayout.minimumLineSpacing = WH(0)
        // 设置同一行的cell中互相之间的最小间隔
        flowLayout.minimumInteritemSpacing = WH(0)
        // 设置section距离边距的距离
        flowLayout.sectionInset = UIEdgeInsets(top: WH(0), left: WH(5), bottom: WH(0), right: WH(5))
//        if #available(iOS 9.0, *) {
//            // header吸顶
//            flowLayout.sectionHeadersPinToVisibleBounds = true
//            flowLayout.sectionFootersPinToVisibleBounds = true
//        }
        
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.delegate = self
        view.dataSource = self
        view.isScrollEnabled = true
        view.backgroundColor = .clear
        view.backgroundView = self.viewBg
        view.showsVerticalScrollIndicator = true
        view.register(RIImageCCell.self, forCellWithReuseIdentifier: "RIImageCCell")
        view.register(RIEmptyCCell.self, forCellWithReuseIdentifier: "RIEmptyCCell")
        view.register(RIImageTitleCRView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RIImageTitleCRView")
        view.register(RIImageProgressCRView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RIImageProgressCRView")
        view.register(RIImageEmptyCRView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "RIImageEmptyCRView")
        return view
    }()
    
    // 企业类型选择视图...<分段视图>...<吸顶>
    fileprivate lazy var viewSelect: RITypeSelectView = {
        let view = RITypeSelectView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(44)))
        //view.configViewWithTitles(self.viewModel.tabTitleList)
        // 切换企业类型索引
        view.changeTypeCallback = { [weak self] (index, data) in
            guard let strongSelf = self else {
                return
            }
            // collectionview滑动到指定section处
            strongSelf.scroollToSection(index)
        }
        return view
    }()
    
    // 底部视图...<提交>
    fileprivate lazy var viewBottom: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(62)))
        view.backgroundColor = RGBColor(0xFFFFFF)
        // 按钮
        view.addSubview(self.btnSubmit)
        self.btnSubmit.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: WH(10), left: WH(20), bottom: WH(10), right: WH(20)))
        }
        // 分隔线
        let viewLine = UIView.init(frame: CGRect.zero)
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        view.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(0.5)
        }
        return view
    }()
    // 提交按钮
    fileprivate lazy var btnSubmit: UIButton = {
        // 自定义按钮背景图片
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFF2D5C), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("提交审核", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(3)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.submitAction()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 选择照片弹出视图view...<类似UIActionSheet>
    fileprivate lazy var imageSourceView: CredentialsUploadImageSourceView = {
        let view = CredentialsUploadImageSourceView()
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        // 选择类型
        view.selectSourceClosure = { [weak self] sourceType in
            guard let strongSelf = self else {
                return
            }
            if sourceType == "Album" {
                // 相册
                strongSelf.imageUploadController.pushImagePickerController()
            }
            else if (sourceType == "Camera") {
                // 相机
                strongSelf.imageUploadController.takePhoto()
            }
        }
        return view
    }()
    // 上传照片vc
    fileprivate lazy var imageUploadController: CredentialsImagePickController = {
        let view = CredentialsImagePickController()
        // 最大上传个数...<非其它资质类型默认仅可上传1张图片>
        view.maxImagesCount = 1
        // 图片上传完成
        view.uploadImageCompletionClosure = { [weak self] (imageUrlArr, filenames, errorInfo, toUploadImageCount) in
            guard let strongSelf = self else {
                return
            }
            
            // toast
            if errorInfo.count > 0 {
                // 有失败
                if (toUploadImageCount > 1) {
                    // 上传张数>1...<可能部分成功，可能全部失败>
                    var errorMsg = "上传成功了\(imageUrlArr.count)/\(toUploadImageCount):\n"
                    let failStrings = errorInfo.map({ (errorTuple) -> String in
                        return "第\(errorTuple.uploadIndex)张上传失败：\(errorTuple.errorMsg)"
                    })
                    errorMsg.append((failStrings as NSArray).componentsJoined(by: "\n"))
                    strongSelf.toast(errorMsg, delay: 1.5, numberOfLines: 0)
                }
                else {
                    // 最多上传1张...<完全失败>
                    if let errorTuple = errorInfo.first, errorTuple.errorMsg.isEmpty == false {
                        if errorTuple.errorMsg == "上传失败" {
                            strongSelf.toast("上传失败")
                        }
                        else {
                            strongSelf.toast("上传失败\n\(errorTuple.errorMsg)", delay: 1.0, numberOfLines: 0)
                        }
                    }
                    else{
                        strongSelf.toast("上传失败")
                    }
                }
            }
            else {
                // 无失败
            }
            
            guard imageUrlArr.count > 0, filenames.count > 0 else {
                return
            }
            
            guard let indexPath = strongSelf.selectedIndexPath else {
                return
            }
            
            // 保存...<增加图片>
            if imageUrlArr.count > 1 {
                // 上传多张图片...<其它资质类型>
                strongSelf.viewModel.addMultiQualificationImageForOtherType(imageUrlArr, filenames, indexPath)
            }
            else {
                // 上传单张图片...<所有类型>
                strongSelf.viewModel.updateQualificationImage(imageUrlArr[0], filenames[0], indexPath)
            }
            
            // 刷新
            strongSelf.collectionView.reloadData()
        }
        // 上传状态更新
        view.uploadStatusClosure = { [weak self] status in
            guard let strongSelf = self else {
                return
            }
            if status == .begin {
                strongSelf.showLoading()
            }
            if status == .complete {
                strongSelf.dismissLoading()
            }
        }
        return view
    }()
    
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        setupData()
        setupRequest()

        // app进后台时缓存数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveCacheData), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print("RIImageController deinit~!@")
        // 移除通知
        NotificationCenter.default.removeObserver(self)
        // 缓存
        //saveCacheData()
    }
}


// MARK: - UI
extension RIImageController {
    // UI绘制
    fileprivate func setupView() {
        setupNavigationBar()
        setupContentView()
    }
    
    // 导航栏
    fileprivate func setupNavigationBar() {
        // 标题
        fky_setupTitleLabel("资料管理")
        // 分隔线
        fky_hiddedBottomLine(false)
        
        // 返回
        fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            guard let strongSelf = self else {
                return
            }
            FKYNavigator.shared().pop()
            // 缓存
            if strongSelf.showMode == .submit {
                // 提交审核...<上传流程>
                strongSelf.viewModel.saveEnterpriseInfoForCache()
            }
        }
    }
    
    // 内容视图
    fileprivate func setupContentView() {
        //view.backgroundColor = RGBColor(0xF4F4F4)
        view.backgroundColor = RGBColor(0xFFFFFF)
        
        var margin: CGFloat = 0
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                margin = iPhoneX_SafeArea_BottomInset
            }
        }
        
        view.addSubview(viewBottom)
        viewBottom.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-margin)
            make.height.equalTo(WH(62))
        }
        
        view.addSubview(viewTip)
        let heightTip = viewTip.getContentHeight()
        viewTip.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(self.navBar!.snp.bottom)
            //make.height.equalTo(WH(32))
            make.height.equalTo(heightTip)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(viewBottom.snp.top)
            make.top.equalTo(viewTip.snp.bottom)
        }
        collectionView.reloadData()
        
        view.addSubview(viewSelect)
        viewSelect.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(viewTip.snp.bottom).offset(WH(90))
            make.height.equalTo(WH(44))
        }
        viewSelect.isHidden = true // 默认隐藏
        
        // 上传图片弹出框
        view.addSubview(imageSourceView)
        view.sendSubviewToBack(imageSourceView)
        
        // 上传图片vc
        addChild(imageUploadController)
        view.addSubview(imageUploadController.view)
        view.sendSubviewToBack(imageUploadController.view)
    }
}


// MARK: - Data
extension RIImageController {
    //
    fileprivate func setupData() {
        viewModel.zzImageModel = zzModel
        viewModel.showMode = showMode
    }
}


// MARK: - Request
extension RIImageController {
    //
    fileprivate func setupRequest() {
        // 请求需要上传的资质列表
        requestForImageUploadList()
    }
    
    // 请求资质图片上传数组
    fileprivate func requestForImageUploadList() {
        showLoading()
        viewModel.requestForImageUploadList { [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if !success {
                // 失败
                strongSelf.toast(msg)
            }
            // 显示
            strongSelf.showQualificationList()
        }
    }
    
    // (上传资质图片)提交请求
    fileprivate func requestForSubmit() {
        showLoading()
        viewModel.requestForSubmit { [weak self] (success, msg, data) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if !success {
                // 失败
                strongSelf.toast(msg)
                return
            }
            // 提交成功
            if strongSelf.showMode == .submit {
                // 提交审核...<上传流程>
                strongSelf.requestForReview()
                // 清除缓存
                strongSelf.viewModel.deleteEnterpriseInfoInCache()
            }
            else {
                // 返回...<修改流程>
                FKYNavigator.shared().pop()
            }
        }
    }
    
    // 提交审核
    fileprivate func requestForReview() {
        showLoading()
        viewModel.requestForReview { [weak self] (success, msg, data) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if !success {
                // 失败
                strongSelf.toast(msg)
                return
            }
            // 提交审核成功...<界面跳转>
            let vc = CredentialsCompleteViewController()
            FKYNavigator.shared().topNavigationController.pushViewController(vc, animated: true, snapshotFirst: false)
        }
    }
}


// MARK: - Action
extension RIImageController {
    // 提交
    fileprivate func submitAction() {
        // 内容合法性校验
        let result: (Bool, String?) = viewModel.checkSubmitStatus()
        guard result.0 == true else {
            if let txt = result.1, txt.isEmpty == false {
                toast(txt)
            }
            return
        }
        
        // 提交请求
        requestForSubmit()
    }
    
    // 三证合一开关切换
    fileprivate func switchAction(_ status: Bool, _ section: Int) {
        viewModel.updateStatusFor3Merge1(status, section)
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    
    // 上传图片
    fileprivate func uploadImage(_ cell: RIImageCCell) {
        //view.endEditing(true)
        
        guard let indexPath = selectedIndexPath else {
            return
        }
        
        // 当前资质类型id
        let typeid: Int? = cell.typeid
        guard let tid = typeid else {
            return
        }
        
        // 当前类型资质可上传的最大图片数量...<非其它资质类型仅可传1张>
        let uploadNumber: Int = viewModel.getMaxUploadImageNeededForOtherType(indexPath, tid)
        // 更新当前可上传图片的最大数量
        imageUploadController.maxImagesCount = uploadNumber
        
        // 弹出上传图片选择视图
        view.bringSubviewToFront(imageSourceView)
        imageSourceView.showClosure!()
    }
    
    // 查看图片
    fileprivate func showImage(_ cell: RIImageCCell) {
        guard selectedIndexPath != nil else {
            return
        }
        
        // 从cell中取值
        let item: (UIView, UIImage?, String?) = cell.getQualificationImage()
        guard let url = item.2, url.isEmpty == false else {
            return
        }
        guard let img = item.1 else {
            return
        }
        
        // 保存
        //selectedImageView = item.0
        
        let rect: CGRect = getCellFrame(cell)
        let imgview: UIView = createFrameView(rect, img)
        selectedImageView = imgview
        
        // photo model
        let photo = SKPhoto.photoWithImageURL(url)
        photo.shouldCachePhotoURLImage = true
        // 弹出查看图片vc
        //let browser = SKPhotoBrowser(originImage: img, photos: [photo], animatedFromView: item.0)
        let browser = SKPhotoBrowser(originImage: img, photos: [photo], animatedFromView: selectedImageView!)
        browser.delegate = self
        browser.showDeleteButton = true // 增加删除图片功能
        browser.initializePageIndex(0)
        if #available(iOS 13, *) {
            browser.modalPresentationStyle = .fullScreen
        }
        FKYNavigator.shared().topNavigationController.present(browser, animated: true, completion: nil)
    }
    
    // 删除图片
    fileprivate func deleteImage(_ cell: RIImageCCell) {
        guard selectedIndexPath != nil else {
            return
        }
        
        // 保存...<删除图片>
        viewModel.updateQualificationImage(nil, nil, selectedIndexPath!)
        collectionView.reloadData()
    }
}


// MARK: - Private
extension RIImageController {
    // 显示资质列表
    fileprivate func showQualificationList() {
        // 更新tab
        if viewModel.tabTitleList.count > 1 {
            viewSelect.isHidden = false
        }
        else {
            viewSelect.isHidden = true
        }
        viewSelect.configViewWithTitles(viewModel.tabTitleList)
        // 刷新列表
        collectionView.reloadData()
    }
    
    // 手动切换企业类型tab
    fileprivate func scroollToSection(_ section: Int) {
        guard viewModel.tabContentList.count > 0, viewModel.tabContentList.count > section else {
            return
        }
        
        // section中cell数组
        let sectionModel = viewModel.tabContentList[section]
        guard sectionModel.qualicationListShow.count > 0 else {
            return
        }
        
        // 避免两处滑动逻辑冲突
        stopScrollCalculate = true
        
        if section == 0 {
            collectionView.setContentOffset(CGPoint.init(x: 0, y: WH(80) + WH(11)), animated: true)
        }
        else {
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            // 获取collectionView内容总高度
            let contentHeight: CGFloat = collectionView.collectionViewLayout.collectionViewContentSize.height
            // 获取collectionView滑动到最底部时的最大偏移量
            let offsetY = contentHeight - collectionViewHeight
            
            // 获取collectionView滑动到指定indexpath处的内容偏移量
            let attrs = collectionView.layoutAttributesForItem(at: IndexPath.init(row: 0, section: section+1))
            // 判断当前section-header是否显示三证合一...<确定header高度>
            let showFlag = viewModel.getSwitchShowStatus(section)
            let valueY = attrs!.frame.origin.y - WH(80) - (showFlag ? WH(50) : WH(12))
            
            // 判断
            if offsetY > valueY {
                // 未滑到最底部
                collectionView.setContentOffset(CGPoint.init(x: 0, y: valueY), animated: true)
            }
            else {
                // 已滑到最底部
                collectionView.scrollToItem(at: IndexPath.init(row: 0, section: section+1), at: .top, animated: true)
            }
        }
        
        // 避免两处滑动逻辑冲突
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.stopScrollCalculate = false
        }
    }
    
    // app进后台时缓存数据
    @objc fileprivate func saveCacheData() {
        print("saveCacheData for image")
        // 缓存
        if showMode == .submit {
            // 提交审核...<上传流程>
            viewModel.saveEnterpriseInfoForCache()
        }
    }
    
    // 获取cell坐标
    fileprivate func getCellFrame(_ cell: RIImageCCell) -> CGRect {
//        let indexPath: IndexPath? = collectionView.indexPath(for: cell)
//        let layoutAttr = collectionView.layoutAttributesForItem(at: indexPath!)
//        // 坐标转换
//        let rect = layoutAttr!.frame
//        let rectFianl = collectionView.convert(rect, to: collectionView.superview)
//        return rectFianl
        
        // 坐标转换
        let rect = collectionView.convert(cell.frame, to: collectionView)
        let rectFianl = collectionView.convert(rect, to: collectionView.superview)
        return rectFianl
    }
    
    // 生成坐标视图
    fileprivate func createFrameView(_ rect: CGRect, _ img: UIImage) -> UIView {
        let xValue = rect.origin.x + WH(12)
        let yValue = rect.origin.y + WH(12)
        let widthValue = rect.size.width - WH(12) * 2
        let heightValue = rect.size.height - WH(12) * 2
        let imgview = UIImageView.init(frame: CGRect.init(x: xValue, y: yValue, width: widthValue, height: heightValue))
        imgview.layer.masksToBounds = true
        imgview.layer.cornerRadius = WH(8)
        imgview.image = img
        return imgview
    }
}


// MARK: - SKPhotoBrowserDelegate
extension RIImageController: SKPhotoBrowserDelegate {
    //
    func didDismissAtPageIndex(_ index: Int) {
        collectionView.reloadData()
    }
    
    // 删除已上传图片...<查看大图时删除图片>
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        guard let indexPath = selectedIndexPath else {
            reload()
            return
        }
        
        // 保存...<删除图片>
        viewModel.updateQualificationImage(nil, nil, indexPath)
        collectionView.reloadData()
        reload()
    }
    
    //
//    func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
//        return selectedImageView
//    }
}


// MARK: - UIScrollViewDelegate
extension RIImageController: UIScrollViewDelegate {
    //
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        guard scrollView == collectionView else {
//            return
//        }
//
//        lastContentOffset = scrollView.contentOffset.y
//    }
    
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 仅针对collectionView
        guard scrollView == collectionView else {
            return
        }
        
        // collectionView下滑时，让顶部背景色与白色进行区分
        if scrollView.contentOffset.y < 0 {
            // <负>下滑
            viewUpdate.snp.updateConstraints { (make) in
                make.height.equalTo(-scrollView.contentOffset.y)
            }
        }
        
        // 单个企业
        guard viewModel.tabContentList.count > 0 else {
            return
        }
        
        /**********************************************/
        
        /*
         以下代码逻辑功能：
         根据scrollView滑动的偏移量，来动态设置界面顶层的viewSelect位置，来模拟吸顶和滑动效果
         */
        
        // 多个企业...<3个>
        let offsetY = scrollView.contentOffset.y
        if offsetY >= 0 {
            // <正>上滑
            if topMargin - offsetY >= 0 {
                viewSelect.snp.updateConstraints { (make) in
                    make.top.equalTo(viewTip.snp.bottom).offset(topMargin - offsetY)
                }
            }
            else {
                viewSelect.snp.updateConstraints { (make) in
                    make.top.equalTo(viewTip.snp.bottom).offset(0)
                }
            }
        }
        else {
            // <负>下滑
            let topValue = topMargin - offsetY
            viewSelect.snp.updateConstraints { (make) in
                make.top.equalTo(viewTip.snp.bottom).offset(topValue)
            }
        }
        //view.layoutIfNeeded()
        
        guard stopScrollCalculate == false else {
            // 更新
            //lastContentOffset = offsetY
            return
        }
        
        /*****************************************/
        
        /*
         以下代码逻辑功能：
         滑动到指定section时，设置tab中对应的选中状态；以屏幕底部为参照物
         */
        
        guard offsetY > 0 else {
            // 若<=0，则固定设置选中第1项
            viewSelect.showSelected(0)
            // 更新
            //lastContentOffset = offsetY
            return
        }
        
        // 每滑动10point才进行实时判断，优化性能
//        guard fabs(offsetY - lastContentOffset) >= 10 else {
//            // 更新
//            lastContentOffset = offsetY
//            return
//        }
        
        //
        let cellIndexPathTotal = collectionView.indexPathsForVisibleItems
        // 实时检测当前scrollView是上滑还是下滑
        //let scrollUp = (offsetY >= lastContentOffset ? true : false)
        
        if #available(iOS 9.0, *) {
            // >= 9.0
            let headerIndexPathList = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
             viewSelect.updateSelected(headerIndexPathList, cellIndexPathTotal)
        }
        else {
            // < 9.0
            viewSelect.updateSelectedType(cellIndexPathTotal)
        }
        
        // 更新
        //lastContentOffset = offsetY
    }
}


// MARK: - SBCollectionViewDelegateFlowLayout
extension RIImageController: SBCollectionViewDelegateFlowLayout {
    // 用于设置collectionView中单个section的背景色...<现在实际已经用不上了>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return .white
    }
}


// MARK: - UICollectionViewDelegate
extension RIImageController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 顶部进度视图占用一个section
        return viewModel.tabContentList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard viewModel.tabContentList.count >= section else {
            return 0
        }
        
        if section == 0 {
            // 进度视图section
            return 1
        }
        else {
            // 图片列表section
            let sectionModel: RIQualificationModel = viewModel.tabContentList[section-1]
            let list = sectionModel.qualicationListShow
            if list.count > 0 {
                return list.count
            }
            else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard viewModel.tabContentList.count >= indexPath.section else {
            return CGSize.zero
        }
        
        if indexPath.section == 0 {
            // 进度视图section
            //return CGSize(width: SCREEN_WIDTH, height: WH(55))
            
            if viewModel.tabContentList.count > 1 {
                return CGSize(width: SCREEN_WIDTH, height: WH(55))
            }
            else {
                return CGSize(width: SCREEN_WIDTH, height: WH(11))
            }
        }
        else {
            // 图片列表section
            //return CGSize(width: ((SCREEN_WIDTH - WH(10)) / 2), height: WH(120))
            
            let sectionModel: RIQualificationModel = viewModel.tabContentList[indexPath.section-1]
            let list = sectionModel.qualicationListShow
            if list.count > 0 {
                let item: RIQualificationItemModel = list[indexPath.row]
                if item.showFlag {
                    // 显示
                    return CGSize(width: ((SCREEN_WIDTH - WH(10)) / 2), height: WH(142))
                }
                else {
                    // 不显示
                    return CGSize.zero
                    //return CGSize(width: 0.001, height: 0.001)
                }
            }
            else {
                return CGSize.zero
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(5), bottom: WH(0), right: WH(5))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return WH(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard viewModel.tabContentList.count >= indexPath.section else {
            return UICollectionViewCell.init(frame: CGRect.zero)
        }
        
        if indexPath.section == 0 {
            // 进度视图section
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RIEmptyCCell", for: indexPath) as! RIEmptyCCell
            return cell
        }
        else {
            // 图片列表section
            let sectionModel: RIQualificationModel = viewModel.tabContentList[indexPath.section-1]
            let list = sectionModel.qualicationListShow
            if list.count > 0 {
                // 有数据
                let item: RIQualificationItemModel = list[indexPath.row]
                // cell
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RIImageCCell", for: indexPath) as! RIImageCCell
                cell.configCell(item, indexPath.section-1, indexPath.row)
                // 上传图片
                cell.uploadImageClosure = { [weak self,weak cell] (index) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.selectedIndexPath = index
                    if let strongCell = cell{
                         strongSelf.uploadImage(strongCell)
                    }
                }
                // 查看图片
                cell.showImageClosure = { [weak self,weak cell] (index) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.selectedIndexPath = index
                    if let strongCell = cell{
                        strongSelf.showImage(strongCell)
                    }
                    
                }
                // 删除图片
                cell.deleteImageClosure = { [weak self,weak cell] (index) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.selectedIndexPath = index
                    if let strongCell = cell{
                        strongSelf.deleteImage(strongCell)
                    }
                    
                }
                return cell
            }
            else {
                // 无数据
                return UICollectionViewCell.init(frame: CGRect.zero)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard viewModel.tabContentList.count >= section else {
            return CGSize.zero
        }
        
        if section == 0 {
            // 进度视图section
            return CGSize(width: SCREEN_WIDTH, height: WH(80))
        }
        else {
            // 图片列表section
            let showFlag = viewModel.getSwitchShowStatus(section-1)
            //return CGSize(width: SCREEN_WIDTH, height: (showFlag ? WH(88) : WH(48)))
            return CGSize(width: SCREEN_WIDTH, height: (showFlag ? WH(63) : WH(23)))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        //return CGSize.zero
        return CGSize(width: SCREEN_WIDTH, height: WH(25))
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard viewModel.tabContentList.count >= indexPath.section else {
            return UICollectionReusableView()
        }

        if (kind == UICollectionView.elementKindSectionHeader) {
            if indexPath.section == 0 {
                // header
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RIImageProgressCRView", for: indexPath) as! RIImageProgressCRView
                
                return view
            }
            else {
                // 是否显示三证合一开关
                let showFlag = viewModel.getSwitchShowStatus(indexPath.section-1)
                // 若显示三证合一，则进一步获取三证合一的开关状态
                let switchFlag = viewModel.getSwitchValue(indexPath.section-1)
                // 企业类型
                let typeName = viewModel.getSectionTitle(indexPath.section-1)
                
                // header
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RIImageTitleCRView", for: indexPath) as! RIImageTitleCRView
                view.configView(typeName, showFlag, switchFlag)
                view.typeIndex = indexPath.section-1
                // 开关操作block
                view.callback = { [weak self] (status) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.switchAction(status, indexPath.section-1)
                }
                return view
            }
        }
        else if (kind == UICollectionView.elementKindSectionFooter) {
            // footer
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "RIImageEmptyCRView", for: indexPath) as! RIImageEmptyCRView
            return view
        }

        return UICollectionReusableView()
    }
    
    // 解决HeaderView遮挡滚动条的问题
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        view.layer.zPosition = 0.0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //
    }
}

