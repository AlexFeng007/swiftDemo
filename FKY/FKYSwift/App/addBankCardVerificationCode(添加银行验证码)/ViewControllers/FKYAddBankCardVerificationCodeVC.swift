//
//  FKYAddBankCardVerificationCodeVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/7.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  上海银行支付 快捷支付 短信验证码

import UIKit

class FKYAddBankCardVerificationCodeVC: UIViewController {
    
    enum fromViewType {
        case noType
        case bandingCardView
        case selectPayView
        case buyMoney //选择购物金
    }
    
    /// 验证成功的回调
    /// isSuccess是否验证成功
    /// inputVeridicationCode用户输入的验证码
    /// codeRequestNo短信验证码下发请求流水号 绑卡界面用的
    /// quickPayFlowId快捷支付流水号 选择支付方式界面用的
    /// errorMsg错误信息
    var verificationResult:((_ isSuccess:Bool,_ inputVeridicationCode:String,_ codeRequestNo:String,_ quickPayFlowId:String,_ errorMsg:String)->())?
    
    /// 绑卡界面的viewmodel
    var bandingCardViewModel = FKYAddBankCardViewModel()
    
    /// 支付方式页面的ViewModel
    var selectPayViewModel = COOnlinePayViewModel()
    
    /// 从哪个界面来的，必填
    var fromViewType:fromViewType = .noType
    
    /// 需要验证的手机号，由外部传入，必传
    lazy var phoneNumber = ""
    
    /// 订单号 从支付方式进来此参数必传
    var orderID = ""
    
    /// 验证码view
    lazy var verificationView = FKYBankVerificationCode()
    
    /// 用户输入的验证码
    lazy var inputVerificationCode = ""
    /// 获取到的验证码流水号
    var codeRequestNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        if self.fromViewType == .selectPayView {
            self.selectPayViewModel.orderId = self.orderID
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.fromViewType == .buyMoney {
            self.verificationView.showBuyMoneyTipStr(phoneNum: self.phoneNumber)
        }else {
            self.verificationView.showPhoneNumber(phoneNum: self.phoneNumber)
        }
        self.startAnimation()
        _ = self.checkInputParam()
    }
    
    deinit {
        print("FKYAddBankCardVerificationCodeVC deinit~!@")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//MARK: - 事件响应
extension FKYAddBankCardVerificationCodeVC{
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKY_getVerificationCodeBtnClicked{//获取短信验证码点击事件
            self.getVerificationCode()
        }else if eventName == FKY_bandingVerificationCodeBtnClicked {// 确定按钮点击事件
            let parameter = userInfo[FKYUserParameterKey] as! (isCan:Bool,msg:String)
            if parameter.isCan {/// 填写了正确的验证码
                self.checkCode(code: parameter.msg)
            }else{// 未填写正确的验证码
                self.toast(parameter.msg)
            }
        }else if eventName == FKY_closeVerificationView {// 关闭验证码界面
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.5, animations: {
                self.view.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0)
                self.verificationView.snp.updateConstraints { (make) in
                    make.top.equalTo(self.view.snp.bottom)
                }
                self.view.layoutIfNeeded()
            }) { (isFinished) in
                self.verificationView.stopCount()
                self.dismiss(animated: false, completion: nil)
            }
        }else if eventName == FKY_verificationCodeShouldBeginEditing {/// 开始编辑
            //self.moveUP()
        }else if eventName == FKY_verificationCodeDidEndEditing {// 结束编辑
            //self.moveDown()
        }
    }
    
    /// 获取短信验证码
    func getVerificationCode(){
        if self.fromViewType == .bandingCardView{
            self.bandingViewSendSMS(phoneNum: self.phoneNumber)
        }else if self.fromViewType == .selectPayView{
            self.selectPayWaySenSMS()
        }else if self.fromViewType == .buyMoney {
            self.getBuyMoneySendSMS(phoneNum: self.phoneNumber)
        }
    }
    
    /// 验证短信验证码
    func checkCode(code:String){
        self.inputVerificationCode = code
        if self.fromViewType == .bandingCardView{
            self.checkVerificationCode(verificationCode: self.inputVerificationCode)
        }else if self.fromViewType == .selectPayView{
            self.dismissVerificationView()
            //            if let callBackBlock = self.verificationResult {
            //                callBackBlock(true,self.inputVerificationCode,"",self.selectPayViewModel.quickPayFlowId,"")
            //            }
        }else if self.fromViewType == .buyMoney {
            self.checkBuyMoneyVerificationCode(verificationCode: code)
        }
    }
}

//MARK: - ui
extension FKYAddBankCardVerificationCodeVC{
    func setupUI(){
        self.view.addSubview(self.verificationView)
        self.view.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0)
        self.verificationView.snp.makeConstraints { (make) in
            make.width.equalTo(WH(342))
            make.height.lessThanOrEqualTo(WH(323))
            make.left.equalTo(self.view.snp.left).offset((SCREEN_WIDTH-WH(342)) / 2.0)
            make.top.equalTo(self.view.snp.bottom).offset(0)
        }
        self.verificationView.layoutIfNeeded()
    }
    
    /// 开始动画
    func startAnimation(){
        self.verificationView.snp.updateConstraints { (make) in
            make.top.equalTo(self.view.snp.bottom).offset(0)
        }
        self.view.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.5)
            let ver_h = self.verificationView.hd_height
            self.verificationView.snp.updateConstraints { (make) in
                make.top.equalTo(self.view.snp.bottom).offset(-(SCREEN_HEIGHT/2.0+ver_h/2.0))
            }
            self.view.layoutIfNeeded()
        }) { (isFinished) in
            if isFinished {
                self.verificationView.installTimer()
            }
        }
    }
    
    /// 结束动画
    func dismissVerificationView(){
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0)
            self.verificationView.snp.updateConstraints { (make) in
                make.top.equalTo(self.view.snp.bottom)
            }
            self.view.layoutIfNeeded()
        }) { (isFinished) in
            self.verificationView.stopCount()
            self.dismiss(animated: false) {
                if let callBackBlock = self.verificationResult {
                    if self.fromViewType == .buyMoney {
                        callBackBlock(true,"","","","")
                    }else {
                        callBackBlock(true,self.inputVerificationCode,self.codeRequestNo,self.selectPayViewModel.quickPayFlowId,"")
                    }
                }
            }
        }
    }
    
    /// 开始编辑上移动画
    func moveUP(){
        UIView.animate(withDuration: 0.5, animations: {
            self.verificationView.hd_y = self.verificationView.hd_y - WH(50)
        }) { (isFinished) in
            
        }
    }
    
    
    /// 结束编辑下移动画
    func moveDown(){
        UIView.animate(withDuration: 0.5, animations: {
            self.verificationView.hd_y = self.verificationView.hd_y + WH(50)
        }) { (isFinished) in
            
        }
    }
}


//MARK: - 私有方法
extension FKYAddBankCardVerificationCodeVC{
    
    /// 检查必须传入的参数
    func checkInputParam() -> Bool{
        if self.fromViewType == .noType {
            self.toast("fromViewType-页面类型没有传入")
            self.dismissVerificationView()
            return false
        }
        
        if self.fromViewType != .selectPayView,self.phoneNumber.isEmpty == true {
            self.toast("phoneNumber-手机号没有传入")
            self.dismissVerificationView()
            return false
        }
        
        if self.fromViewType == .selectPayView ,self.orderID.isEmpty == true{
            self.toast("orderID-从支付方式进来，必须传")
            self.dismissVerificationView()
            return false
        }
        
        return true
    }
}


//MARK: - 网络请求
extension FKYAddBankCardVerificationCodeVC{
    
    /// 绑卡界面 - 验证验证码
    func checkVerificationCode(verificationCode:String){
        
        self.bandingCardViewModel.checkVerificationCod(phoneNum: self.phoneNumber, verificationCode: verificationCode) { [weak self] (isSuccess, msg,codeRequestNo)  in
            guard let weakSelf = self else {
                return
            }
            
            guard isSuccess else {
                weakSelf.toast(msg)
                return
            }
            weakSelf.codeRequestNo = codeRequestNo
            weakSelf.dismissVerificationView()
            
            
            
        }
    }
    
    /// 绑卡界面 - 获取短信验证码
    func bandingViewSendSMS(phoneNum:String){
        self.verificationView.countLayout()
        self.verificationView.showTipText(Tip: "正在发送短信...")
        self.bandingCardViewModel.sendVerificationCodeInBandingView(phoneNum: phoneNum) { [weak self] (isSuccess, msg) in
            
            guard let weakSelf = self else{
                self?.verificationView.countOverLayout()
                return
            }
            
            guard isSuccess else{
                weakSelf.toast(msg)
                weakSelf.verificationView.countOverLayout()
                return
            }
            weakSelf.verificationView.showPhoneNumber(phoneNum: weakSelf.phoneNumber)
            weakSelf.verificationView.installTimer()
            
        }
    }
    
    /// 选择支付方式界面 - 获取短信验证码
    func selectPayWaySenSMS(){
        self.verificationView.countLayout()
        self.selectPayViewModel.requestForBankQuickPayFlowId { [weak self] (success, message, data) in
            guard let strongSelf = self else {
                return
            }
            
            guard success else {
                // 失败
                strongSelf.toast(message ?? "请求失败")
                return
            }
            strongSelf.verificationView.installTimer()
        }
    }
}

//MARK:检查订单页，第一次使用购物金
extension FKYAddBankCardVerificationCodeVC {
    /// 购物金- 获取短信验证码
    func getBuyMoneySendSMS(phoneNum:String){
        self.verificationView.countLayout()
        self.verificationView.showTipText(Tip: "正在发送短信...")
        self.verificationView.showErrorTip(tip:"")
        var params :[String : Any] = [:]
        params["type"] = "4"
        params["mobile"] = phoneNum
        
        FKYRequestService.sharedInstance()?.requestForGetSMSCodeDataInPassword(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                strongSelf.toast(msg)
                strongSelf.verificationView.countOverLayout()
                return
            }
            strongSelf.verificationView.showBuyMoneyTipStr(phoneNum: phoneNum)
            strongSelf.verificationView.installTimer()
        })
    }
    fileprivate func checkBuyMoneyVerificationCode(verificationCode:String){
        var params :[String : Any] = [:]
        params["type"] = "4"
        params["mobile"] = self.phoneNumber
        params["code"] = verificationCode
        self.verificationView.showErrorTip(tip:"")
        FKYRequestService.sharedInstance()?.requestForValidateSMSCodeDataInPassword(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                strongSelf.verificationView.showErrorTip(tip:msg)
                return
            }
            strongSelf.verificationView.showErrorTip(tip:"")
            strongSelf.dismissVerificationView()
        })
    }
    
}
