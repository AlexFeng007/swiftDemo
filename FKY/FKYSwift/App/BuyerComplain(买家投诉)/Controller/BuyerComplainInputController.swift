//
//  BuyerComplainInputController.swift
//  FKY
//
//  Created by 寒山 on 2019/1/4.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class BuyerComplainInputController: UIViewController {
    
    @objc var orderModel: FKYOrderModel?
    
    // viewmodel
    fileprivate lazy var viewModel: SellerComplainViewModel = {
        let vm = SellerComplainViewModel()
        vm.orderModel = self.orderModel
        return vm
    }()
    //滚动视图
    fileprivate lazy var bgScrollView: UIScrollView = {
        let sv = UIScrollView.init(frame: CGRect(x: 0, y:naviBarHeight(), width: SCREEN_WIDTH, height: SCREEN_HEIGHT - naviBarHeight()))
        sv.bounces = true
        sv.isScrollEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.contentSize = CGSize(width: SCREEN_WIDTH, height:SCREEN_HEIGHT + WH(44))
        //sv.showsVerticalScrollIndicator = false
        sv.backgroundColor =  RGBColor(0xf7f7f7)
        return sv
    }()
    fileprivate lazy var contentView: UIView? = {
        let view = UIView.init()
        return view
    }()
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
    //选择视图
    fileprivate lazy var selectView: SelectReasonView? = {
        let view = SelectReasonView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(44)))
        view.backgroundColor = .white
        view.selectTypeBlock = { [weak self]  in
            guard let strongSelf = self else {
                return
            }
            strongSelf.selectApplyReason()
        }
        return view
    }()
    
    // 输入视图
    fileprivate lazy var infoView: RCSubmitInfoView = {
        let view = RCSubmitInfoView.init(frame: CGRect.init(x: 0, y:  WH(44), width: SCREEN_WIDTH, height: WH(40 + 58 + 130)))
        view.backgroundColor = .white
        view.setupForBuyerComplain()
        // 保存输入文字
        view.saveInput = { [weak self] (content) in
            guard let strongSelf = self else {
                return
            }
            // 保存
            strongSelf.viewModel.problemDescription = content
        }
        // 删除图片
        view.deletePic = { [weak self] (index) in
            guard let strongSelf = self else {
                return
            }
            // 删除、更新
            strongSelf.updatePicList(index)
        }
        // 查看图片
        view.showPic = { [weak self] (index) in
            guard let strongSelf = self else {
                return
            }
            // 查看大图
           strongSelf.showPicList(index)
        }
        // 上传图片
        view.takePic = { [weak self]  in
            guard let strongSelf = self else {
                return
            }
            // 拍照
            strongSelf.takePictureAction()
        }
        return view
    }()
    //信息视图
    fileprivate lazy var orderInfoView: BCInputInfoView? = {
        let view = BCInputInfoView.init(frame: CGRect.init(x: 0, y: WH(40 + 58 + 130 + 44), width: SCREEN_WIDTH, height: WH(177)))
        view.backgroundColor = .white
        return view
    }()
    // 弹出视图对应的controller...<退换货之申请原因列表>
    fileprivate lazy var reasonListPopVC: RCPopController = {
        let vc = RCPopController.init()
        vc.popType = .complainTypeList                   // 类型
        vc.popTitle = "投诉类型"                      // 标题
        vc.contentHeight = SCREEN_HEIGHT * 2 / 3    // 内容高度
        vc.cellHeight = WH(45)                      // cell高度
        vc.showBtn = true                           // 显示底部按钮
        vc.requestBySelf = true                     // 自已请求数据
        vc.viewParent = self.view                   // 父视图
        // 选择
        vc.selectItemBlock = { [weak self] (model, index) in
            guard let strongSelf = self else {
                return
            }
            // 判断有无更新
            if strongSelf.viewModel.index4Reason == index as Int {
                return
            }
            // 保存
            strongSelf.viewModel.complainTypeModel = model as? ComplaintTypeInfoModel
            strongSelf.viewModel.index4Reason = index as Int
             // 刷新
            strongSelf.selectView!.configCell(strongSelf.viewModel.complainTypeModel!.typeDesc)
        }
        return vc
    }()
    // 上传照片vc
    fileprivate lazy var imageUploadController: CredentialsImagePickController = {
        let view = CredentialsImagePickController()
        // 最大上传个数
        view.maxImagesCount = self.viewModel.maxUploadNumber
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
                        strongSelf.toast("上传失败\n\(errorTuple.errorMsg)", delay: 1.0, numberOfLines: 0)
                    }
                    else{
                        strongSelf.toast("上传失败")
                    }
                }
            }
            else {
                // 无失败
            }
            guard imageUrlArr.count > 0 else {
                return
            }
            
            // 保存...<增加图片>
            strongSelf.viewModel.picList.append(contentsOf: imageUrlArr)
            
            strongSelf.viewModel.updatePicListForException()
            
            // 刷新
            strongSelf.updateInfoViewHeight()
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
    //提交按钮
    fileprivate lazy var bottomView:  ComplainBottomView = {
        let view = ComplainBottomView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(145)))
        view.submitBlock = { [weak self]  in
            guard let strongSelf = self else {
                return
            }
            strongSelf.submitAction()
        }
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setUpData()
        // Do any additional setup after loading the view.
    }
    fileprivate func setupView() {
        
        view.backgroundColor = RGBColor(0xf7f7f7)
        
        fky_setupTitleLabel("投诉商家")
        fky_hiddedBottomLine(false)
        fky_setupLeftImage("icon_back_new_red_normal"){
            FKYNavigator.shared().pop()
        }
        view.addSubview(bgScrollView)
        bgScrollView.addSubview(contentView!)

        contentView!.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(bgScrollView)
            if (WH(145 + 177 + 44 + 40 + 58 + 130 + 44) > SCREEN_HEIGHT){
                 make.height.equalTo(WH(145 + 177 + 44 + 40 + 58 + 130 + 44))
            }else{
                 make.height.equalTo(SCREEN_HEIGHT)
            }
        }
        self.navBar!.backgroundColor = bg1
        
        contentView!.addSubview(selectView!)
        contentView!.addSubview(infoView)
        contentView!.addSubview(orderInfoView!)
        contentView!.addSubview(bottomView)
        orderInfoView!.snp.remakeConstraints { (make) in
            make.left.right.equalTo(contentView!)
            make.top.equalTo(infoView.snp.bottom)
            make.height.equalTo(WH(177))
            make.width.equalTo(SCREEN_WIDTH)
        }
        bottomView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(contentView!)
            make.top.equalTo(orderInfoView!.snp.bottom)
            make.height.equalTo(WH(145 + 44))
            make.width.equalTo(SCREEN_WIDTH)
        }
       
        // 上传图片弹出框
        view.addSubview(imageSourceView)
        view.sendSubviewToBack(imageSourceView)

        // 上传图片vc
        addChild(imageUploadController)
        view.addSubview(imageUploadController.view)
        view.sendSubviewToBack(imageUploadController.view)
        
      
       
    }
    func setUpData(){
        showLoading()
        
        self.viewModel.sellerComplainAction(nil,3){[weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if success{
                strongSelf.reasonListPopVC.dataList = (strongSelf.viewModel.complainSellerInfo?.complaintType)!
                strongSelf.orderInfoView!.configView(strongSelf.viewModel.complainSellerInfo!)
            } else {
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
}
// MARK: - Private
extension BuyerComplainInputController: UIActionSheetDelegate {
    // 提交
    fileprivate func submitAction() {
        view.endEditing(true)
        
         let (status, msg) = viewModel.checkSubmitInfoStatus()
        guard status == 0 else {
            // 不合法
            toast(msg)
            return
        }

        // 合法，提交信息
        requestForSubmitInfo()
    }
    // 提交回寄信息
    fileprivate func requestForSubmitInfo() {
        showLoading()
        showLoading()
        self.viewModel.sellerComplainAction(nil,1){[weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                strongSelf.toast(msg ?? "提交失败")
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name.FKYRCSubmitBackInfo, object: self, userInfo: nil)
            // 提交成功，返回到订单列表界面
            strongSelf.navigationController?.popViewController(animated: true)
        }
    }
    // (显示)申请原因
    fileprivate func selectApplyReason() {
        view.endEditing(true)
        
        // 显示
        reasonListPopVC.showOrHidePopView(true)
        // 传递之前已经选中项的索引，并滑到选中项
        reasonListPopVC.showSelectedItem(viewModel.index4Reason)
    }
    
    // 拍照
    fileprivate func takePictureAction() {
        view.endEditing(true)
        
        guard viewModel.picList.count < viewModel.maxUploadNumber else {
            toast("已达最大上传个数")
            return
        }
        
        // 自定义
        view.bringSubviewToFront(imageSourceView)
        imageSourceView.showClosure!()

        // 更新当前最大可上传照片数
        imageUploadController.maxImagesCount = (viewModel.maxUploadNumber - viewModel.picList.count)
    }
    
    // 更新图片列表
    fileprivate func updatePicList(_ index: Int) {
        // 删除
        viewModel.deletePicAtIndex(index)
        // 更新
        updateInfoViewHeight()
    }
    
    // 查看图片
    fileprivate func showPicList(_ index: Int) {
        view.endEditing(true)
        
        let list: [UIImageView]? = viewModel.createImageList()
        guard let arr = list, arr.count > 0 else {
            return
        }

        let currentIndex = (arr.count > index ? index : 0)
        let imageViewer = XHImageViewer.init()
        imageViewer.showPageControl = true
        imageViewer.userPageNumber = true
        imageViewer.hideWhenOnlyOne = true
        imageViewer.show(withImageViews: arr, selectedView: arr[currentIndex])
    }
    
    // 更新信息视图高度...<根据有无上传图片来判断>
    fileprivate func updateInfoViewHeight() {
        if viewModel.picList.count > 0 {
            // 有上传图片
            infoView.frame = CGRect.init(x: 0, y: WH(44), width: SCREEN_WIDTH, height: WH(40 + 58 + 130 + 66))
            bgScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height:WH(145 + 177 + 44 + 40 + 58 + 130 + 66 + 44))
            contentView!.snp_updateConstraints { (make) -> Void in
                make.height.equalTo(WH(145 + 177 + 44 + 40 + 58 + 130 + 66 + 44))
            }
        }
        else {
            // 未上传图片
            infoView.frame = CGRect.init(x: 0, y: WH(44), width: SCREEN_WIDTH, height: WH(40 + 58 + 130))
            bgScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height:WH(145 + 177 + 44 + 40 + 58 + 130 + 44 ))
            contentView!.snp_updateConstraints { (make) -> Void in
                make.height.equalTo(WH(145 + 177 + 44 + 40 + 58 + 130  + 44))
            }
        }
        infoView.updatePicList(viewModel.picList)
    }
    
    // UIActionSheetDelegate
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            // 取消
        }
        else if buttonIndex == 1 {
            // 拍照
            imageUploadController.takePhoto()
        }
        else if buttonIndex == 2 {
            // 相册
            imageUploadController.pushImagePickerController()
        }
    }
}

