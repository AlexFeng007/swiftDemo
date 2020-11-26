//
//  FKYAddBankCardVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
// 添加银行卡

import UIKit

class FKYAddBankCardVC: UIViewController {
    
    lazy var viewModel:FKYAddBankCardViewModel = FKYAddBankCardViewModel()
    
    /// 卡编辑类型  1绑卡 2换卡 必传
    var editerType = 0
    
    /// 姓名 editerType == 2必传
    var realName = ""
    
    /// 身份证 editerType == 2必传
    var idCardNo = ""
    
    /// 主table
    lazy var mainTableView:UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 50
        tb.estimatedSectionHeaderHeight = 0
        tb.estimatedSectionFooterHeight = 0
        tb.separatorStyle = .none
        tb.register(FKYAddBankCardTipCell.self, forCellReuseIdentifier: NSStringFromClass(FKYAddBankCardTipCell.self))
        tb.register(FKYAddBankCardInputCell.self, forCellReuseIdentifier: NSStringFromClass(FKYAddBankCardInputCell.self))
        tb.register(FKYAddBankCardConfirmCell.self, forCellReuseIdentifier: NSStringFromClass(FKYAddBankCardConfirmCell.self))
        tb.backgroundColor = RGBColor(0xF4F4F4)
        return tb
    }()
    //可用银行列表弹框
    fileprivate lazy var popBankListVC : FKYBankListViewController = {
        let vc = FKYBankListViewController()
        return vc
    }()
    
    /// 导航栏
    fileprivate var navBar: UIView?
    var bankArr = [FKYBankIndeModel]() //店铺列表
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.editerType = self.editerType
        self.viewModel.submitParam["realName"] = self.realName
        self.viewModel.submitParam["idCardNo"] = self.idCardNo
        
        self.setupUI()
        self.viewModel.ProcessingData()
        self.getUseBankList(false)
        // Do any additional setup after loading the view.
    }
    
}


//MARK: - UI
extension FKYAddBankCardVC {
    
    func setupUI(){
        self.configNaviBar()
        self.view.addSubview(self.mainTableView)
        
        self.mainTableView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.navBar!.snp_bottom)
        }
    }
    
    /// 配置导航栏
    func configNaviBar() {
        self.navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            }else{
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
            }()
        if self.editerType == 1{// 绑卡
            self.fky_setupTitleLabel("添加银行卡")
        }else if self.editerType == 2{// 换卡
            self.fky_setupTitleLabel("修改银行卡")
        }
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") {[weak self] () in
            guard self != nil else {
                return
            }
            FKYNavigator.shared().pop()
        }
    }
}


//MARK: - 私有方法
extension FKYAddBankCardVC{
    
    /// 提交银行卡信息
    func submitBankCardInfo(){
        self.requestSubmitBankCardInfo()
    }
    
    /// 扫码输入银行卡信息
    func changeBankCarNumber(bankCard:String){
        let bankCard_Temp = bankCard.replacingOccurrences(of: " ", with: "")
        self.viewModel.submitParam["bankCardNo"] = bankCard_Temp
        for cell in self.viewModel.cellModelList{
            if cell.paramKey == "bankCardNo" {// 银行卡输入cell
                cell.inputText = bankCard_Temp
                cell.isNeedMSK = false
            }
        }
        self.mainTableView.reloadData()
    }
    
    /// 弹出验证码页面
    func popVerificationView(){
        let verificationVC = FKYAddBankCardVerificationCodeVC()
        verificationVC.modalPresentationStyle = .overFullScreen
        verificationVC.phoneNumber = self.viewModel.submitParam["mobile"]!
        verificationVC.fromViewType = .bandingCardView
        verificationVC.verificationResult = {[weak self] (isSuccess,inputVeridicationCode,codeRequestNo,quickPayFlowId,errorMsg) in
            guard let weakSelf = self else{
                return
            }
            weakSelf.viewModel.submitParam["codeRequestNo"] = codeRequestNo
            if weakSelf.editerType == 1{//绑卡
                weakSelf.submitBankCardInfo()
            }else if weakSelf.editerType == 2{//换卡
                weakSelf.requestUpdataBankCardInfo()
            }
        }
        self.present(verificationVC, animated: false) {}
    }
    
    /// 弹出错误提示弹窗
    func popErrorView(errorText:String){
        let errorVC = FKYBandingBankCardErrorVC()
        errorVC.errorText = errorText
        errorVC.showErrorForBank()
        errorVC.modalPresentationStyle = .overFullScreen
        self.present(errorVC, animated: false) {}
    }
}

//MARK: - 事件响应
extension FKYAddBankCardVC{
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKYAddBankCardConfirmCell.FKY_LookBankListAction{ // 提示按钮点击事件
            self.view.endEditing(true)
            if self.bankArr.count > 0 {
                self.popBankListVC.configPopBankListViewController(self.bankArr)
            }else {
                self.getUseBankList(true)
            }
        }else if eventName == FKY_inputTFEndEdit { // 输入框完成编辑
            let cellModel = userInfo[FKYUserParameterKey] as! FKYAddBankCardCellModel
            self.viewModel.submitParam[cellModel.paramKey] = cellModel.inputText
        }else if eventName == FKY_confirmBtnClicked {// 绑定按钮点击
            self.view.endEditing(true)
            let isInputFull = self.viewModel.isInputFull()
            if isInputFull.isSuccess {// 填写完整
                self.requestSendVerificationCode(phoneNum: self.viewModel.submitParam["mobile"]!)
            }else{
                self.toast(isInputFull.msg)
            }
        }else if eventName == FKY_selectBtnClicked {/// 选中协议按钮点击
            self.viewModel.protocolSelectedStatus = userInfo[FKYUserParameterKey] as! Bool
        }else if eventName == FKY_lookProtocolBtnClicked{/// 查看协议按钮点击
            //(UIApplication.shared.delegate as! AppDelegate).p_openPriveteSchemeString("https://m.yaoex.com/web/h5/maps/index.html?pageId=101500&type=release") //上海银行电商资金管理业务服务协议
            (UIApplication.shared.delegate as! AppDelegate).p_openPriveteSchemeString("https://m.yaoex.com/web/h5/maps/index.html?pageId=101511&type=release")// 1药城快捷支付协议
            
        }else if eventName == FKYAddBankCardInputCell.FKY_ocrButtonClicked {//OCR识别银行卡
            /// 跳转到银行卡OCR页面
            self.jumpToBankCardOcrVC()
        }
    }
    
    /// 跳转到银行卡OCR页面
    func jumpToBankCardOcrVC(){
        //    #error 【必须！】请在 ai.baidu.com中新建App, 绑定BundleId后，在此填写授权信息
        //    #error 【必须！】上传至AppStore前，请使用lipo移除AipBase.framework、AipOcrSdk.framework的模拟器架构，参考FAQ：ai.baidu.com/docs#/OCR-iOS-SDK/top
        //        let licenseFile = Bundle.main.path(forResource: "aip", ofType: "license")
        //        let licenseFileData = NSData(contentsOfFile: licenseFile ?? "") as Data?
        //        if licenseFileData == nil {
        //            UIAlertView(title: "授权失败", message: "授权文件不存在", delegate: nil, cancelButtonTitle: "确定", otherButtonTitles: "").show()
        //        }
        //        AipOcrService.shard().auth(withLicenseFileData: licenseFileData)

        let scanVC = AipCaptureCardVC.viewController(with: .bankCard) {[weak self] (image) in
            AipOcrService.shard()?.detectBankCard(from: image, successHandler: { (successResult) in
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: {
                        
                    })
                }
                DispatchQueue.main.async {
                    guard let weakSelf = self else {
    
                        self?.toast("内存溢出")
                        return
                    }
                    
                    guard let resDic = successResult as? [String:Any] else{
                        weakSelf.toast("数据解析失败")
                        return
                    }
                    weakSelf.toast("识别成功，请核对银行卡号是否正确")
                    let tempDic1 = (resDic["result"] as? [String:Any]) ?? [String:Any]()
                    var carNum = ""
                    if let cardNUM_Temp = tempDic1["bank_card_number"] {
                        carNum = (cardNUM_Temp as? String) ?? ""
                    }
                    
                    weakSelf.changeBankCarNumber(bankCard: carNum)
                }
            }, failHandler: {[weak self] (error) in
                DispatchQueue.main.async {
                    self?.toast(error?.localizedDescription)
                }
                
            })
        }
        //scanVC?.modalPresentationStyle = .overFullScreen
        self.present(scanVC!, animated: true) {
            
        }
    }
}

//MARK: - table代理
extension FKYAddBankCardVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.cellModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = self.viewModel.cellModelList[indexPath.row]
        
        if cellModel.cellType == .tipCell{/// 提示cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYAddBankCardTipCell.self)) as! FKYAddBankCardTipCell
            return cell
        }else if cellModel.cellType == .inputCell{///信息输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYAddBankCardInputCell.self)) as! FKYAddBankCardInputCell
            
            cell.configCell(cellModel: cellModel)
            return cell
        }else if cellModel.cellType == .confirmCell{/// 确定绑卡cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYAddBankCardConfirmCell.self)) as! FKYAddBankCardConfirmCell
            if self.editerType == 2{// 换卡不显示协议
                cell.isShowProtocol(false)
            }
            return cell
        }
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "error")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
}


//MARK: -网络请求
extension FKYAddBankCardVC{
    
    /// 更新银行卡信息
    func requestUpdataBankCardInfo(){
        self.viewModel.updataBankCardInfo(bankcardNo: self.viewModel.submitParam["bankCardNo"]!, moblie: self.viewModel.submitParam["mobile"]!) {[weak self] (isSuccess, msg) in
            guard let weakSelf = self else{
                return
            }
            
            guard isSuccess else{
                weakSelf.popErrorView(errorText: msg ?? "")
                return
            }
            weakSelf.toast("修改成功")
            FKYNavigator.shared()?.pop()
        }
    }
    
    /// 发送验证码
    func requestSendVerificationCode(phoneNum:String){
        self.viewModel.sendVerificationCodeInBandingView(phoneNum: phoneNum) {[weak self] (isSuccess, msg) in
            guard let weakSelf = self else {
                return
            }
            
            guard isSuccess else {
                weakSelf.toast(msg)
                return
            }
            
            weakSelf.popVerificationView()
        }
    }
    
    /// 提交绑定银行卡信息
    func requestSubmitBankCardInfo(){
        self.viewModel.submitBankCardInfo {[weak self] (isSuccess, msg) in
            guard let weakSelf = self else{
                return
            }
            
            guard isSuccess else {
                /// 这里要用UI弹窗 待会接入
                weakSelf.popErrorView(errorText: msg ?? "")
                return
            }
            weakSelf.toast("绑定成功")
            FKYNavigator.shared()?.pop()
        }
    }
    
    //获取可用银行卡列表
    fileprivate func getUseBankList(_ isClick:Bool) {
        var params = [String : Any]()
        params["bizType"] = "SHBK"
        FKYRequestService.sharedInstance()?.requestForUseBankList(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else{
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                self?.toast(msg)
                return
            }
            if let bankArr = response as? NSArray  ,bankArr.count > 0{
                if let arr = bankArr.mapToObjectArray(FKYBankIndeModel.self) {
                    strongSelf.bankArr = arr
                    if isClick == true {
                        strongSelf.popBankListVC.configPopBankListViewController(strongSelf.bankArr)
                    }
                }
            }
        })
    }
}
