//
//  FKYBankVerificationCode.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/7.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  短信验证码

import UIKit

/// 获取短信验证码点击事件
let FKY_getVerificationCodeBtnClicked = "getVerificationCodeBtnClicked"

/// 确定按钮点击事件
let FKY_bandingVerificationCodeBtnClicked = "bandingVerificationCodeBtnClicked"

/// 关闭验证码界面
let FKY_closeVerificationView = "closeVerificationView"

/// 即将开始编辑
let FKY_verificationCodeShouldBeginEditing = "verificationCodeShouldBeginEditing"

/// 已经结束编辑
let FKY_verificationCodeDidEndEditing = "verificationCodeDidEndEditing"

class FKYBankVerificationCode: UIView {
    
    
    /// 倒计时的总时间 单位秒
    var countSec = 120
    
    /// 定时器
    var timerCount:Timer?
    
    /// 顶部title
    lazy var titleDesLB:UILabel = {
        let lb = UILabel()
        lb.text = "短信验证码"
        lb.textColor = RGBColor(0x000000)
        lb.textAlignment = .center
        lb.font = .boldSystemFont(ofSize: WH(18))
        return lb
    }()
    
    
    /// 关闭按钮
    lazy var closeBtn:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named:"btn_pd_group_close"), for: .normal)
        bt.addTarget(self, action: #selector(FKYBankVerificationCode.closeVerificationView), for: .touchUpInside)
        return bt
    }()
    
    /// 上方分割线
    lazy var topMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    /// 下方分割线
    lazy var bottomMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    /// 手机号
    lazy var phoneNumLabel:UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize:WH(13))
        lb.textColor = RGBColor(0x666666)
        lb.numberOfLines = 0
        return lb
    }()
    
    /// 验证码title
    lazy var codeTitleDesLB:UILabel = {
        let lb = UILabel()
        lb.text = "验证码"
        lb.font = .systemFont(ofSize:WH(14))
        lb.textColor = RGBColor(0x333333)
        return lb
    }()
    
    /// 验证码输入框
    lazy var codeInputTF:UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.attributedPlaceholder = NSAttributedString.init(string:"输入短信验证码", attributes: [.font:UIFont.systemFont(ofSize:WH(13)),.foregroundColor:RGBColor(0x999999)])
        tf.leftViewMode = .always
        tf.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: WH(13), height: 1))
        tf.font = .systemFont(ofSize: WH(14))
        tf.delegate = self
        tf.layer.cornerRadius = WH(4)
        tf.layer.masksToBounds = true
        tf.layer.borderWidth = 1
        tf.layer.borderColor = RGBColor(0xE5E5E5).cgColor
        return tf
    }()
    
    /// 获取短信验证码按钮
    lazy var getVerificationCodeBtn:UIButton = {
        let bt = UIButton()
        bt.setTitle("(\(self.countSec)S)重新获取", for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize:WH(13))
        bt.setTitleColor(RGBColor(0x999999), for: .normal)
        bt.isUserInteractionEnabled = false
        bt.layer.cornerRadius = WH(4)
        bt.layer.masksToBounds = true
        bt.layer.borderWidth = 1
        bt.layer.borderColor = RGBColor(0xE5E5E5).cgColor
        bt.addTarget(self, action: #selector(FKYBankVerificationCode.getVerificationCodeBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    //错误提示
    lazy var erroreDesLB:UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize:WH(11))
        lb.textColor = RGBColor(0xFF2D5C)
        lb.numberOfLines = 0
        return lb
    }()
    
    /// 确定按钮
    lazy var confirmBtn:UIButton = {
        let bt = UIButton()
        bt.titleLabel?.font = .boldSystemFont(ofSize: WH(15))
        bt.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        bt.setTitle("确定", for: .normal)
        bt.isUserInteractionEnabled = false
        bt.backgroundColor = RGBColor(0xFFABBD)
        bt.layer.cornerRadius = WH(4)
        bt.layer.masksToBounds = true
        bt.addTarget(self, action: #selector(FKYBankVerificationCode.bandingVerificationCodeBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

//MARK: - 数据展示
extension FKYBankVerificationCode{
    func showPhoneNumber(phoneNum:String){
        if phoneNum.count<11 {
            self.phoneNumLabel.text = ""
            return
        }
        self.phoneNumLabel.text = "已发送至手机号"+self.replacePhone(phoneNum: phoneNum)
    }
    //购物金验证时使用
    func showBuyMoneyTipStr(phoneNum:String) {
        if phoneNum.count<11 {
            self.phoneNumLabel.text = ""
            return
        }
        self.phoneNumLabel.text = "为你保障您的财产安全，需要进行短信验证，已发送至手机号"+self.replacePhone(phoneNum: phoneNum)
    }
    //购物金验证时使用
    func showErrorTip(tip:String){
        self.erroreDesLB.text = tip
    }
    
    /// 展示提示文描
    func showTipText(Tip:String){
        self.phoneNumLabel.text = Tip
    }
    
    func replacePhone(phoneNum:String) -> String {
        let start = phoneNum.index(phoneNum.startIndex, offsetBy: 3)
        let end = phoneNum.index(phoneNum.startIndex, offsetBy: 7)
        let range = Range(uncheckedBounds: (lower: start, upper: end))
        return phoneNum.replacingCharacters(in: range, with: "****")
    }
}

//MARK: - 事件响应
extension FKYBankVerificationCode{
    
    /// 获取验证码按钮点击
    @objc func getVerificationCodeBtnClicked(){
        self.routerEvent(withName: FKY_getVerificationCodeBtnClicked, userInfo: [FKYUserParameterKey:""])
    }
    
    /// 确定按钮点击
    @objc func bandingVerificationCodeBtnClicked(){
        let mobile = "^[0-9]*"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if (regextestmobile.evaluate(with: self.codeInputTF.text) == true){
            self.routerEvent(withName: FKY_bandingVerificationCodeBtnClicked, userInfo: [FKYUserParameterKey:(isCan:true,msg:self.codeInputTF.text)])
        }else{
            self.routerEvent(withName: FKY_bandingVerificationCodeBtnClicked, userInfo: [FKYUserParameterKey:(isCan:false,msg:"请填写正确的数字验证码")])
        }
    }
    
    /// 关闭验证码界面
    @objc func closeVerificationView(){
        self.routerEvent(withName: FKY_closeVerificationView, userInfo: [FKYUserParameterKey:""])
    }
    
    
}

//MARK: - UI
extension FKYBankVerificationCode{
    func setupUI(){
        self.layer.cornerRadius = WH(4)
        self.layer.masksToBounds = true
        self.backgroundColor = RGBColor(0xFFFFFF)
        self.addSubview(self.titleDesLB)
        self.addSubview(self.closeBtn)
        self.addSubview(self.topMarginLine)
        self.addSubview(self.phoneNumLabel)
        self.addSubview(self.codeTitleDesLB)
        self.addSubview(self.codeInputTF)
        self.addSubview(self.getVerificationCodeBtn)
        self.addSubview(self.erroreDesLB)
        self.addSubview(self.bottomMarginLine)
        self.addSubview(self.confirmBtn)
        
        self.titleDesLB.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(WH(16))
            make.height.equalTo(WH(25))
        }
        
        self.closeBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.titleDesLB)
            make.right.equalToSuperview().offset(WH(-18))
            make.width.height.equalTo(WH(30))
        }
        
        self.topMarginLine.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.titleDesLB.snp_bottom).offset(WH(15))
            make.height.equalTo(1)
        }
        
        self.phoneNumLabel.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(18))
            make.right.equalToSuperview().offset(WH(-18))
            make.top.equalTo(self.topMarginLine.snp_bottom).offset(WH(11))
            make.height.lessThanOrEqualTo(WH(60))
        }
        
        self.codeTitleDesLB.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(18))
            make.top.equalTo(self.phoneNumLabel.snp_bottom).offset(WH(23))
            make.width.equalTo(WH(50))
            make.height.equalTo(WH(21))
        }
        
        self.codeInputTF.snp_makeConstraints { (make) in
            make.left.equalTo(self.codeTitleDesLB.snp_right).offset(WH(5))
            make.centerY.equalTo(self.codeTitleDesLB)
            make.height.equalTo(WH(42))
            make.right.equalTo(self.getVerificationCodeBtn.snp_left).offset(WH(-10))
        }
        
        self.getVerificationCodeBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.codeTitleDesLB)
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(99))
            make.right.equalToSuperview().offset(WH(-10))
        }
        
        self.erroreDesLB.snp_makeConstraints { (make) in
            make.top.equalTo(self.codeInputTF.snp.bottom).offset(WH(5))
            make.left.equalTo(self.codeInputTF.snp.left)
            make.height.lessThanOrEqualTo(WH(60))
            make.right.equalTo(self.snp.right).offset(WH(-10))
        }
        
        
        
        self.bottomMarginLine.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.erroreDesLB.snp_bottom).offset(WH(10))
            make.height.equalTo(WH(1))
        }
        
        self.confirmBtn.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(20))
            make.right.equalToSuperview().offset(WH(-20))
            make.top.equalTo(self.bottomMarginLine.snp_bottom).offset(WH(9))
            make.height.equalTo(WH(42))
            make.bottom.equalTo(WH(-13))
        }
    }
    
    ///验证码倒计时布局和显示方案
    func countLayout(){
        self.getVerificationCodeBtn.isUserInteractionEnabled = false
        self.getVerificationCodeBtn.setTitleColor(RGBColor(0x999999), for: .normal)
        self.getVerificationCodeBtn.layer.borderColor = RGBColor(0xE5E5E5).cgColor
    }
    
    /// 倒计时结束的布局和显示方案
    func countOverLayout(){
        self.getVerificationCodeBtn.isUserInteractionEnabled = true
        self.getVerificationCodeBtn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        self.getVerificationCodeBtn.layer.borderColor = RGBColor(0xFF2D5C).cgColor
    }
    
    /// 确定按钮可以点击
    func confirmBtnCanClick(){
        self.confirmBtn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        self.confirmBtn.backgroundColor = RGBColor(0xFF2D5C)
        self.confirmBtn.isUserInteractionEnabled = true
    }
    
    /// 确定按钮不可点击
    func confirmBtnCanNotClick(){
        self.confirmBtn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        self.confirmBtn.backgroundColor = RGBColor(0xFFABBD)
        self.confirmBtn.isUserInteractionEnabled = false
    }
}


//MARK: - 倒计时
extension FKYBankVerificationCode{
    /// 初始化定时器并开始倒计时
    func installTimer(){
        self.countSec = 120
        self.timerCount = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector( FKYBankVerificationCode.startCountDown), userInfo: nil, repeats: true)
        self.countLayout()
    }
    
    /// 开始倒计时
    @objc fileprivate func startCountDown(){
        self.countSec -= 1
        self.getVerificationCodeBtn.setTitle("(\(self.countSec)S)重新获取", for: .normal)
        self.countLayout()
        if self.countSec <= 0{
            self.countOverLayout()
            self.getVerificationCodeBtn.setTitle("获取验证码", for: .normal)
            self.timerCount?.invalidate()
            self.timerCount = nil
        }
    }
    
    /// 关闭倒计时
    func stopCount(){
        self.timerCount?.invalidate()
        self.timerCount = nil
    }
}



//MARK: - UITextField代理
extension FKYBankVerificationCode:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if #available(iOS 13.0, *){
            return true
        }
        if textField.text?.count ?? 0 >= 4 {
            self.confirmBtnCanClick()
        }else{
            self.confirmBtnCanNotClick()
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.count ?? 0 >= 4 {
            self.confirmBtnCanClick()
        }else{
            self.confirmBtnCanNotClick()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.routerEvent(withName: FKY_verificationCodeShouldBeginEditing, userInfo: [FKYUserParameterKey:""])
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.routerEvent(withName: FKY_verificationCodeDidEndEditing, userInfo: [FKYUserParameterKey:""])
        return true
    }
}
