//
//  RCSubmitInfoController.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/27.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退换货之提交

import UIKit

class RCSubmitInfoController: UIViewController, FKY_RCSubmitInfoController {
    // MARK: - Property
    
    // 类型：(退货 or 换货)...<上个界面传递过来>
    var returnFlag: Bool = false
    
    var paytype: Int32 = 0  //支付类型(上个界面传过来的)(支付方式 1、线上支付 2、账期支付 3、线下支付)
    var rcType = 2 //1:mp退货 2:自营退货 3:自营的极速理赔 (上个界面传过来的)
    
    // 子订单id...<上个界面传递过来>
    var orderId: String?
    
    // 商品列表...<FKYOrderProductModel>...<上个界面传递过来>
    var productList = [Any]()
    
    // viewmodel
    fileprivate lazy var viewModel: RCSubmitInfoViewModel = {
        let vm = RCSubmitInfoViewModel()
        vm.returnFlag = self.returnFlag
        vm.rcType = self.rcType
        vm.orderId = self.orderId
        vm.productList = self.productList as! [FKYOrderProductModel]
        return vm
    }()
    
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
    // 列表
    fileprivate lazy var tableview: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.tableHeaderView = self.orderView
        view.tableFooterView = self.infoView
        view.register(RCSubmitInfoReasonCell.self, forCellReuseIdentifier: "RCSubmitInfoReasonCell")
        view.register(RCSubmitInfoTypeCell.self, forCellReuseIdentifier: "RCSubmitInfoTypeCell")
        return view
    }()
    // 订单视图
    fileprivate lazy var orderView: RCSubmitInfoOrderView = {
        let view = RCSubmitInfoOrderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(42+94)))
        view.backgroundColor = .white
        view.configView(self.viewModel.orderId, self.viewModel.productList)
        // 查看更多
        view.showMoreBlock = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.showProductList()
        }
        return view
    }()
    // 输入视图
    fileprivate lazy var infoView: RCSubmitInfoView = {
        let view = RCSubmitInfoView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(40 + 58 + 130)))
        view.backgroundColor = .white
        view.configView(self.viewModel.problemDescription, self.viewModel.picList)
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
    // 提交视图
    fileprivate lazy var submitView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(64)))
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.addSubview(self.btnSubmit)
        self.btnSubmit.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(WH(11))
            make.left.equalTo(view).offset(WH(30))
            make.right.equalTo(view).offset(WH(-30))
            make.height.equalTo(WH(42))
        }
        let viewLine = UIView()
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
        btn.setTitle("提交", for: .normal)
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
    // 弹出视图对应的controller...<订单中商品列表>
    fileprivate lazy var productListPopVC: RCPopController = {
        let vc = RCPopController.init()
        vc.popType = .applyProductList              // 类型
        vc.popTitle = "申请商品列表"                  // 标题
        vc.contentHeight = SCREEN_HEIGHT - WH(78)   // 内容高度
        vc.cellHeight = WH(92)                      // cell高度
        vc.showBtn = false                          // 显示底部按钮
        vc.requestBySelf = false                    // 自已请求数据
        vc.dataList = self.productList              // 商品列表数组
        vc.viewParent = self.view                   // 父视图
        return vc
    }()
    // 弹出视图对应的controller...<退换货之申请原因列表>
    fileprivate lazy var reasonListPopVC: RCPopController = {
        let vc = RCPopController.init()
        vc.popType = .applyReason                   // 类型
        vc.popTitle = "申请原因"                      // 标题
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
            strongSelf.viewModel.applyReason = model as? RCApplyReasonModel
            strongSelf.viewModel.index4Reason = index as Int
            strongSelf.viewModel.updateSendBackShowType(strongSelf.rcType)
            // 刷新
            strongSelf.tableview.reloadData()
        }
        return vc
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
    
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("RCSubmitInfoController deinit")
    }
}

// MARK: - UI
extension RCSubmitInfoController {
    // UI绘制
    fileprivate func setupView() {
        setupNavigationBar()
        setupContentView()
    }
    
    // 导航栏
    fileprivate func setupNavigationBar() {
        // 标题
        fky_setupTitleLabel(returnFlag ? "退货" : "换货")
        // 分隔线
        fky_hiddedBottomLine(false)
        
        // 返回
        fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        //极速理赔或者退回线下转账
        if (self.paytype == 3 && self.returnFlag == true) || self.rcType == 3 {
            btnSubmit.setTitle("下一步", for: .normal)
        }else {
            btnSubmit.setTitle("提交", for: .normal)
        }
    }
    
    // 内容视图
    fileprivate func setupContentView() {
        view.backgroundColor = RGBColor(0xF4F4F4)
        
        var margin: CGFloat = 0
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                margin = iPhoneX_SafeArea_BottomInset
            }
        }
        
        view.addSubview(submitView)
        submitView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-margin)
            make.height.equalTo(WH(64))
        }
        
        tableview.reloadData()
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(submitView.snp.top)
            make.top.equalTo(self.navBar!.snp.bottom)
        }
        
        // 上传图片弹出框
        view.addSubview(imageSourceView)
        view.sendSubviewToBack(imageSourceView)
        
        // 上传图片vc
        addChild(imageUploadController)
        view.addSubview(imageUploadController.view)
        view.sendSubviewToBack(imageUploadController.view)
    }
}

// MARK: - Private
extension RCSubmitInfoController: UIActionSheetDelegate {
    // 提交
    fileprivate func submitAction() {
        view.endEditing(true)
        
        let (status, msg) = viewModel.checkSubmitInfoStatus()
        guard status == 0 else {
            // 不合法
            toast(msg)
            return
        }
        if (self.paytype == 3 && self.returnFlag == true) || self.rcType == 3 {
            //退货并且是线下付款方式 or 极速理赔
            FKYNavigator.shared().openScheme(FKY_RCBankInfoController.self, setProperty: { [weak self] (svc) in
                if let strongSelf = self {
                    let v = svc as! RCSubmitBankViewController
                    v.viewModel = strongSelf.viewModel
                    v.rcType = strongSelf.rcType
                }
            }, isModal: false, animated: true)
        }else {
            // 合法，提交信息
            requestForSubmitInfo()
        }
        
    }
    
    // (显示)商品列表
    fileprivate func showProductList() {
        view.endEditing(true)
        
        // 显示
        productListPopVC.showOrHidePopView(true)
        // 传递之前已经选中项的索引，并滑到选中项...<无选项时默认为0>
        productListPopVC.showSelectedItem(0)
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
        
        // 系统
        //        let actionSheet = UIActionSheet.init(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "从手机相册选择")
        //        actionSheet.show(in: view)
        
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
            infoView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(40 + 58 + 130 + 66))
        }
        else {
            // 未上传图片
            infoView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(40 + 58 + 130))
        }
        infoView.updatePicList(viewModel.picList)
        tableview.reloadData()
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

// MARK: - Request
extension RCSubmitInfoController {
    // 请求申请原因列表
    fileprivate func requestForApplyReasonList() {
        //
    }
    
    // 提交退换货相关信息
    fileprivate func requestForSubmitInfo() {
        showLoading()
        let isMp = (rcType == 2 ? false : true)
        viewModel.submitRCInfo(returnFlag,isMp) { [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.tableview.reloadData()
            guard success else {
                // 失败
                strongSelf.toast(msg ?? "提交失败")
                return
            }
            //1、线上支付 2、账期支付
            // 合法，提交信息
            // 成功
            strongSelf.toast(msg ?? "提交成功")
            // 发通知...<申请记录需刷新>
            NotificationCenter.default.post(name: NSNotification.Name.FKYRCSubmitApplyInfo, object: self, userInfo: nil)
            // 提交成功，返回到申请记录列表
            FKYNavigator.shared()?.pop(toScheme: FKY_AfterSaleListController.self)
            
        }
    }
}

// MARK: - UITableViewDelegate
extension RCSubmitInfoController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 2
        if self.rcType == 3 {
            //极速理赔不显示退换货方式
            return 1
        }else {
            if viewModel.applyReason != nil {
                return 2
            }
            // 未选择申请原因时，隐藏退回方式
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(45)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            // 退回方式cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "RCSubmitInfoTypeCell", for: indexPath) as! RCSubmitInfoTypeCell
            // 配置cell
            cell.configCell(viewModel.sendShowType, viewModel.sendType)
            // 选择退回方式
            cell.selectBackType = { [weak self] type in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.viewModel.sendType = type
            }
            cell.selectionStyle = .none
            return cell
        }
        
        // 申请原因cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "RCSubmitInfoReasonCell", for: indexPath) as! RCSubmitInfoReasonCell
        // 配置cell
        cell.configCell(viewModel.applyReason)
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(10)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            // 选择申请原因
            selectApplyReason()
        }
    }
}
