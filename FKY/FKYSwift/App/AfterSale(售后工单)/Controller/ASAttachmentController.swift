//
//  ASAttachmentController.swift
//  FKY
//
//  Created by 夏志勇 on 2019/5/8.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  随行单据 or 企业首营资质

import UIKit

class ASAttachmentController: UIViewController, FKY_ASAttachmentController {
    // MARK: - Property
    
    // 上个界面传递过来的值~!@
    var soNo: String?       // 订单号
    var typeId: Int?        // 售后类型
    var typeName: String?   // (一级)售后名称
    var hideTxtPic = false  // 是否隐藏图文输入...<默认不隐藏>
    
    // 问题原因model数组
    fileprivate var reasonList = [ASApplyTypeModel]()
    // 选中的申请原因索引...<默认未选中>
    fileprivate var index4Reason: Int = -1
    // 问题描述
    fileprivate var problemDescription: String?
    // 上传的图片数组
    fileprivate var picList = [String]()
    // 当前最大可上传照片个数...<默认为5>
    fileprivate let maxUploadNumber = 5
    
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
        view.tableHeaderView = {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat.leastNormalMagnitude))
            view.backgroundColor = .clear
            return view
        }()
        view.tableFooterView = {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat.leastNormalMagnitude))
            view.backgroundColor = .clear
            return view
        }()
        view.register(ASProblemListCell.self, forCellReuseIdentifier: "ASProblemListCell")
        return view
    }()
    // 输入视图
    fileprivate lazy var infoView: RCSubmitInfoView = {
        let view = RCSubmitInfoView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(40 + 58 + 130)))
        view.backgroundColor = .white
        view.setupTextContent() // 文描设置
        view.configView(self.problemDescription, self.picList) // 默认文字与图片均为空...<无设置逻辑，可不调用>
        // 保存输入文字
        view.saveInput = { [weak self] (content) in
            guard let strongSelf = self else {
                return
            }
            // 保存
            strongSelf.problemDescription = content
        }
        // 删除图片
        view.deletePic = { [weak self] (index) in
            guard let strongSelf = self else {
                return
            }
            // 删除
            strongSelf.removePic(index)
            
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
        view.takePic = { [weak self] in
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
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(62)))
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.addSubview(self.btnSubmit)
        self.btnSubmit.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(WH(10))
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
        view.maxImagesCount = self.maxUploadNumber
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
            strongSelf.picList.append(contentsOf: imageUrlArr)
            strongSelf.updatePicListForException()
            
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
        updateSubviewStatus()
        requestForReasonList()
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
        print("ASAttachmentController deinit")
    }
}


// MARK: - UI
extension ASAttachmentController {
    // UI绘制
    fileprivate func setupView() {
        setupNavigationBar()
        setupContentView()
    }
    
    // 导航栏
    fileprivate func setupNavigationBar() {
        // 标题
        if let tid = typeId {
            // 不为空
            if tid == ASTypeECode.ASType_Bill.rawValue {
                // 随行单据
                fky_setupTitleLabel("选择随行单据服务")
            }
            else if tid == ASTypeECode.ASType_EnterpriceReport.rawValue {
                // 企业首营资质
                fky_setupTitleLabel("选择企业首营资质服务")
            }
            else {
                // 其它
                fky_setupTitleLabel("选择服务")
            }
        }
        else {
            // 为空
            fky_setupTitleLabel("选择服务")
        }
        
        // 分隔线
        fky_hiddedBottomLine(false)
        
        // 返回
        fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
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
            make.height.equalTo(WH(62))
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


// MARK: - Request
extension ASAttachmentController {
    // 请求问题原因列表
    func requestForReasonList() {
        showLoading()
        
        // 传参
        var jsonParams = Dictionary<String, Any>()
        // 订单号
        if let oid = soNo, oid.isEmpty == false {
            jsonParams["orderNo"] = oid
        }
        // 售后类型...<服务类型id>...<有小类，则传小类id；无小类，则直接传大类id>
        if let tid = typeId {
            jsonParams["typeId"] = tid
        }
        
        // 请求
        AfterSaleViewModel().getWorkOrderBaseInfo(withParams: jsonParams) { [weak self] (success, model, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if success {
                // 成功
                if let obj = model {
                    // 有数据
                    let list: ASAplyBaseInfoModel = obj
                    if let plist = list.typeList, plist.count > 0 {
                        strongSelf.reasonList.removeAll()
                        strongSelf.reasonList.append(contentsOf: plist)
                    }
                    // 刷新table
                    strongSelf.tableview.reloadData()
                    // 更新显示状态
                    strongSelf.updateSubviewStatus()
                }
                else {
                    // 无数据
                    strongSelf.toast(msg ?? "请求失败")
                }
            }
            else {
                // 失败
                strongSelf.toast(msg ?? "请求失败")
            }
        }
    }
    
    // 提交
    func requestForSubmitInfo() {
        showLoading()
        
        // 传参
        var jsonParams = Dictionary<String, Any>()
        // 企业ID
        jsonParams["customerId"] = FKYLoginAPI.currentUser().ycenterpriseId ?? ""
        // 订单号
        if let oid = soNo, oid.isEmpty == false {
            jsonParams["soNo"] = oid
        }
        // 售后类型...<服务类型id>...<有小类，则传小类id；无小类，则直接传大类id>
        if index4Reason >= 0, index4Reason < reasonList.count {
            let item: ASApplyTypeModel = reasonList[index4Reason]
            if let tid = item.typeId {
                jsonParams["serviceTypeId"] = tid
            }
        }
        if jsonParams["serviceTypeId"] != nil {
            // 有子类id
        }
        else {
            // 无子类id...<error>
            if let tid = typeId {
                jsonParams["serviceTypeId"] = tid
            }
        }
        // 具体描述
        if let txt = problemDescription, txt.isEmpty == false {
            jsonParams["description"] = txt
        }
        // 图片路径(逗号隔开)
        if picList.count > 0 {
            jsonParams["imgPath"] = picList.joined(separator: ",")
        }
        
        // 请求
        AfterSaleViewModel.saveAsWorkOrder(withParams: jsonParams){ [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if success {
                // 成功
                let alert = COAlertView.init(frame: CGRect.zero)
                alert.configView("您申请的售后服务已提交，我们会在1-2个工作日为您处理完成并将结果反馈给您。再次感谢您的支持！", "", "", "确定", .oneBtn)
                alert.showAlertView()
                alert.doneBtnActionBlock = {
                    // 刷新工单
                    NotificationCenter.default.post(name: NSNotification.Name.FKYRefreshAS, object: self, userInfo: nil)
                    // 返回
                    FKYNavigator.shared().pop()
                }
            }
            else {
                // 失败
                strongSelf.toast(msg ?? "提交失败")
            }
        }
    }
}


// MARK: - Business
extension ASAttachmentController {
    // 有数据时显示子视图
    fileprivate func updateSubviewStatus() {
        // 未获取到子类型列表，则不可提交
        guard reasonList.count > 0 else {
            // 隐藏submit
            submitView.isHidden = true
            // 不显示footer
            tableview.tableFooterView = {
                let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat.leastNormalMagnitude))
                view.backgroundColor = .clear
                return view
            }()
            return
        }
        
        // 显示submit
        submitView.isHidden = false
        // 显示footer
        //tableview.tableFooterView = infoView
        
        // 更新图文显示状态
        updateTxtPicShowStatus()
    }
    
    // 显示or隐藏图文输入
    fileprivate func updateTxtPicShowStatus() {
        if hideTxtPic {
            // 隐藏图文
            tableview.tableFooterView = {
                let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat.leastNormalMagnitude))
                view.backgroundColor = .clear
                return view
            }()
        }
        else {
            // 显示图文
            tableview.tableFooterView = infoView
        }
    }
    
    // 更新信息视图高度...<根据有无上传图片来判断>
    fileprivate func updateInfoViewHeight() {
        if picList.count > 0 {
            // 有上传图片
            //infoView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(40 + 58 + 130 + 66))
            if picList.count < 5 {
                // 未达到最大数量，显示上传图片按钮
                infoView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(40 + 58 + 130 + 66))
            }
            else {
                // 达到最大数量，不显示上传图片按钮
                infoView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(40 + 8 + 130 + 66))
            }
        }
        else {
            // 未上传图片
            infoView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(40 + 58 + 130))
        }
        infoView.updatePicList(picList)
        infoView.updateCameraBtnShowStatus(picList.count == 5 ? false : true)
        tableview.reloadData()
    }
    
    // 判断用户输入信息是否完整
    fileprivate func checkSubmitInfoStatus() -> (status: Int, msg: String) {
        guard index4Reason >= 0, reasonList.count > 0 else {
            var tip = "请选择售后服务类型"
            if let name = typeName, name.isEmpty == false {
                tip = "请选择" + name + "售后服务类型"
            }
            return (1, tip)
        }
        //  描述与图片为非必填项
//        guard let txt = problemDescription, txt.isEmpty == false else {
//            return (2, "请输入问题描述")
//        }
//        guard txt.count > 0, txt.count <= 200 else {
//            return (3, "问题描述长度不符")
//        }
//        guard picList.count > 0 else {
//            return (4, "请上传图片")
//        }
        
        // 异常情况的特殊处理
        guard picList.count <= maxUploadNumber else {
            // 若超过5张，则取后5张图片
            let list = picList.suffix(maxUploadNumber)
            picList = Array.init(list)
            return (0, "ok")
        }
        
        // ok
        return (0, "ok")
    }
}


// MARK: - Event
extension ASAttachmentController {
    // 提交
    fileprivate func submitAction() {
        view.endEditing(true)
        
        let (status, msg) = checkSubmitInfoStatus()
        guard status == 0 else {
            // 不合法
            toast(msg)
            return
        }

        // 合法，提交信息
        requestForSubmitInfo()
    }
    
    // 拍照
    fileprivate func takePictureAction() {
        view.endEditing(true)
        
        guard picList.count < maxUploadNumber else {
            toast("已达最大上传个数")
            return
        }
        
        // 自定义
        view.bringSubviewToFront(imageSourceView)
        imageSourceView.showClosure!()

        // 更新当前最大可上传照片数
        imageUploadController.maxImagesCount = (maxUploadNumber - picList.count)
    }
    
    // 删除(指定索引处的)图片
    fileprivate func removePic(_ index: Int) {
        deletePicAtIndex(index)
        updateInfoViewHeight()
    }
    
    // 查看图片
    fileprivate func showPicList(_ index: Int) {
        view.endEditing(true)
        
        let list: [UIImageView]? = createImageList()
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
}


// MARK: - Pic
extension ASAttachmentController {
    // (删除)更新上传图片数据内容
    fileprivate func deletePicAtIndex(_ index: Int) {
        guard picList.count > 0, index >= 0, index < picList.count else {
            return
        }
        picList.remove(at: index)
    }
    
    // 若上传图片超过最大数量，则自动移除前面的
    fileprivate func updatePicListForException() {
        if picList.count > maxUploadNumber {
            let list = picList.suffix(maxUploadNumber)
            picList = Array.init(list)
        }
    }
    
    // 创建临时用于查看大图的图片数组
    fileprivate func createImageList() -> [UIImageView]? {
        guard picList.count > 0 else {
            return nil
        }
        
        var list = [UIImageView]()
        for index in 0..<picList.count {
            let url = picList[index]
            let x = WH(17) + (WH(60) + WH(5)) * CGFloat(index) + WH(8)
            var y = WH(10) * 2 + WH(44) * CGFloat(reasonList.count) + WH(40) + WH(130) + WH(3) + WH(8)
            
            // 适配iPhoneX
            var top = WH(20) + WH(44)
            if #available(iOS 11, *) {
                let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
                if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                    top = iPhoneX_SafeArea_TopInset
                }
            }
            y += top
            
            // 减去tableview的偏移量
            y -= tableview.contentOffset.y
            
            let imgview = UIImageView.init(frame: CGRect.init(x: x, y: y, width: WH(44), height: WH(44)))
            imgview.backgroundColor = .clear
            imgview.contentMode = .scaleAspectFit
            imgview.clipsToBounds = true
            imgview.isUserInteractionEnabled = true
            imgview.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "image_default_img"))
            list.append(imgview)
        } // for
        return list
    }
}


// MARK: - UITableViewDelegate
extension ASAttachmentController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasonList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(44)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ASProblemListCell", for: indexPath) as! ASProblemListCell
        // 配置cell
        let item: ASApplyTypeModel = reasonList[indexPath.row]
        cell.configCell(item.typeName)
        // 选择
        cell.selectBlock = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.index4Reason = indexPath.row
            strongSelf.tableview.reloadData()
        }
        cell.setSelectedStatus(indexPath.row == index4Reason ? true : false)
        cell.showBottomLine(indexPath.row == (reasonList.count - 1) ? false : true)
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
        //return CGFloat.leastNormalMagnitude
        return WH(10)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 保存
        index4Reason = indexPath.row
        tableview.reloadData()
    }
}
