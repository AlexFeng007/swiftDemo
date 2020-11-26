//
//  AuthCodeLoginController.swift
//  FKY
//
//  Created by 寒山 on 2019/8/15.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  短信验证码登录

import UIKit

class AuthCodeLoginController: UIViewController {
    //MARK: - Property
    
    // block
    var loginSuccessBlock: ( () -> () )?
    
    // viewmodel
    fileprivate lazy var viewModel = RegisterViewModel()
    
    // 默认未显示图形验证码输入框...<一旦显示后，后面会一直显示>
    fileprivate var imgCodeFlag = false
    
    // 当前输入框个数...<计算属性>
    fileprivate var inputNumber: CGFloat {
        get {
            return (imgCodeFlag ? 3.0 : 2.0)
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
    
    // 容器视图
    fileprivate lazy var viewScroll: UIScrollView = {
        let view = UIScrollView(frame: CGRect.zero)
        //view.delegate = self
        view.backgroundColor = bg1
        view.isScrollEnabled = true
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    // 内容视图
    fileprivate lazy var viewContent: IQPreviousNextView = {
        let view = IQPreviousNextView.init()
        view.backgroundColor = .clear
        return view
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UIView = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(24))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "短信验证码登录"
        return lbl
    }()
    
    // 手机号
    fileprivate lazy var viewPhone: RegisterPhoneView = {
        let view = RegisterPhoneView()
        //
        view.changeTextfield = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.updateSubmitBtnStatus()
        }
        //
        view.beginEditing = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.showTipForInputError(nil, .phone)
        }
        //
        view.endEditing = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.validatePhone()
        }
        return view
    }()
    
    // 短信验证码
    fileprivate lazy var viewMessageCode: RegisterMessageCodeView = {
        let view = RegisterMessageCodeView()
        // 请求短信验证码
        view.getMessageCodeClosure = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.requestForMessageCode()
        }
        //
        view.changeTextfield = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.updateSubmitBtnStatus()
        }
        //
        view.beginEditing = { [weak self] in
            guard let strongSelf = self else {
                return
            }
          //  strongSelf.showTipForInputError(nil, .msgCode)
        }
        //
        view.endEditing = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.validateMsgCode()
        }
        return view
    }()
    
    
    // 提交
    fileprivate lazy var btnSubmit: UIButton = {
        // 自定义按钮背景图片
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFF2D5C), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), size: CGSize.init(width: 2, height: 2))
        //let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xFFABBD), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        //btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.setTitleColor(UIColor.white, for: .disabled)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("登录", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.endEditing(true)
            strongSelf.submitAction()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 注册
    fileprivate lazy var btnRegister: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(RGBColor(0x666666), for: .normal)
        btn.setTitleColor(RGBColor(0x333333), for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(12))
        btn.setTitle("注册账号", for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.endEditing(true)
            strongSelf.registerAction()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 短信验证登录
    fileprivate lazy var  authCodeLoginButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(RGBColor(0x666666), for: .normal)
        btn.setTitleColor(RGBColor(0x333333), for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(12))
        btn.setTitle("账号密码登录", for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.endEditing(true)
            FKYNavigator.shared().pop()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 送券logo
    fileprivate lazy var imgCoupon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named: "img_login_coupon")
        return view
    }()
    
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        setupData()
        setupRequest()
        
        // 监控键盘
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 开启切换
        IQKeyboardManager.shared().previousNextDisplayMode = .default
        IQKeyboardManager.shared().shouldToolbarUsesTextFieldTintColor = false
        IQKeyboardManager.shared().toolbarTintColor = UIColor.init(red: 51.0/255.0, green: 123.0/255.0, blue: 246.0/255.0, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 登录界面显示时，则重置一下状态
        FKYAppDelegate!.showType = ShowLoginType.now
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 隐藏切换
        IQKeyboardManager.shared().previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared().shouldToolbarUsesTextFieldTintColor = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 登录界面消失时，则重置一下状态
        FKYAppDelegate!.showType = ShowLoginType.over
    }
    
    deinit {
        print("AuthCodeLoginController deinit~!@")
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
}


//MARK: - UI

extension AuthCodeLoginController {
    // UI绘制
    fileprivate func setupView() {
        setupNavigationBar()
        setupContentView()
    }
    
    // 导航栏
    fileprivate func setupNavigationBar() {
        // 先隐藏系统导航栏
        self.navigationController?.isNavigationBarHidden = true
        
        // 标题
        fky_setupTitleLabel("")
        // 分隔线
        fky_hiddedBottomLine(true)
        
        // 返回
        fky_setupLeftImage("login_close_icon") { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.endEditing(true)
            FKYNavigator.shared()?.dismiss()
            FKYNavigator.shared().pop()
        }
    }
    
    // 内容视图
    fileprivate func setupContentView() {
        // 内容高度
        var contentHeight = WH(45) + WH(35) + WH(20) + WH(62) * inputNumber + WH(38) + WH(42) + WH(40) + WH(60)
        // 保证界面可上下滑动
        if contentHeight <= SCREEN_HEIGHT - naviBarHeight() {
            contentHeight = SCREEN_HEIGHT - naviBarHeight() + WH(2)
        }
        
        view.addSubview(viewScroll)
        viewScroll.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(self.navBar!.snp.bottom)
        })
        viewScroll.contentSize = CGSize(width: SCREEN_WIDTH, height: contentHeight)
        
        viewScroll.addSubview(viewContent)
        viewContent.snp.makeConstraints({ (make) in
            make.left.top.equalTo(viewScroll)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(contentHeight)
        })
        
        viewContent.addSubview(lblTitle)
        viewContent.addSubview(viewPhone)
        viewContent.addSubview(viewMessageCode)
        viewContent.addSubview(btnSubmit)
        viewContent.addSubview(btnRegister)
        // viewContent.addSubview(btnPassword)
        viewContent.addSubview(imgCoupon)
        viewContent.addSubview(authCodeLoginButton)
        
        lblTitle.snp.makeConstraints({ (make) in
            make.left.equalTo(viewContent).offset(WH(30))
            make.top.equalTo(viewContent).offset(WH(45))
            //make.height.equalTo(WH(35))
        })
        
        viewPhone.snp.makeConstraints({ (make) in
            make.left.right.equalTo(viewContent)
            make.top.equalTo(lblTitle.snp.bottom).offset(WH(20))
            make.height.equalTo(WH(62))
        })
        
        viewMessageCode.snp.makeConstraints({ (make) in
            make.left.right.equalTo(viewContent)
            make.top.equalTo(viewPhone.snp.bottom).offset(WH(0))
            make.height.equalTo(WH(62))
        })
        
        
        btnSubmit.snp.makeConstraints({ (make) in
            make.left.equalTo(viewContent).offset(WH(30))
            make.right.equalTo(viewContent).offset(-WH(30))
            make.top.equalTo(viewMessageCode.snp.bottom).offset(WH(38))
            make.height.equalTo(WH(42))
        })
        
        btnRegister.snp.makeConstraints({ (make) in
            make.right.equalTo(viewContent).offset(-WH(15 + 32))
            make.top.equalTo(btnSubmit.snp.bottom).offset(WH(20))
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(80))
            //            make.left.equalTo(viewContent).offset(WH(15))
            //            make.top.equalTo(btnSubmit.snp.bottom).offset(WH(20))
            //            make.height.equalTo(WH(30))
            //            make.width.equalTo(WH(80))
        })
        authCodeLoginButton.snp.makeConstraints({ (make) in
            make.left.equalTo(viewContent).offset(WH(15))
            make.top.equalTo(btnSubmit.snp.bottom).offset(WH(20))
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(120))
        })
        
        imgCoupon.snp.makeConstraints({ (make) in
            make.centerY.equalTo(btnRegister)
            make.left.equalTo(btnRegister.snp.right).offset(-WH(10))
            make.height.equalTo(WH(14))
            make.width.equalTo(WH(32))
        })
        
        // 默认隐藏
        imgCoupon.isHidden = true
        // 默认禁用状态
        btnSubmit.isEnabled = false
    }
}


//MARK: - Data

extension AuthCodeLoginController {
    // 自动填充已保存的手机号码
    fileprivate func setupData() {
        let phone = SAMKeychain.password(forService: "loginMobile", account: "admin")
        viewPhone.setValue(phone)
        updateSubmitBtnStatus()
    }
}


//MARK: - Request

extension AuthCodeLoginController {
    // 进入界面时需立即发起的请求
    fileprivate func setupRequest() {
        requestForCouponStatus()
    }
    
    // 请求是否有注册送券活动...<不显示loading>
    fileprivate func requestForCouponStatus() {
        viewModel.requestForCouponActivity { [weak self] (showFlag) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.imgCoupon.isHidden = !showFlag
        }
    }
    
 
    // 登录... 
    fileprivate func requestForLogin() {
        // 手机号
        guard let phone = getPhone(), phone.isEmpty == false else {
            toast("请输入手机号")
            return
        }
        guard (phone as NSString).isPhoneNumber() else {
            toast("请输入正确的手机号")
            return
        }
        
        // 短信验证码
        guard let msgCode = getMessageCode(), msgCode.isEmpty == false else {
            toast("请输入短信验证码")
            return
        }
        
        guard NSString.validateMessageCode(msgCode) else {
            toast("请输入短信验证码")
            return
        }
        
        // 入参...<所有输入内容均合法，可提交>
        var dic = Dictionary<String, Any>()
        dic["loginMobile"] = phone      // 用户名
        dic["smsCode"] = msgCode  // 密码
    
        showLoading()
        viewModel.requestForLoginBySmsCode(dic) { [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            // 请求失败
            guard success else {
                strongSelf.toast(msg ?? "登录失败")
                // 发登录失败通知
                NotificationCenter.default.post(name: NSNotification.Name.FKYLoginFailure, object: strongSelf, userInfo: nil)
                return
            }
            // 请求成功
            // 发登录成功通知
            NotificationCenter.default.post(name: NSNotification.Name.FKYLoginSuccess, object: strongSelf, userInfo: nil)
            // 登录成功，则重置token过期弹登录界面的状态
            FKYAppDelegate!.showType = ShowLoginType.over
            // 界面跳转(返回)
            FKYNavigator.shared()?.dismiss()
            FKYNavigator.shared()?.pop() // 防止有人不小心将登录界面进行push操作???
            // 回调
            if let block = strongSelf.loginSuccessBlock {
                block()
            }
        }
    }
    // 获取短信验证码
    fileprivate func requestForMessageCode() {
        let phone: String? = getPhone()
        guard let txtP = phone, txtP.isEmpty == false else {
            toast("请输入手机号")
            return
        }
        guard (txtP as NSString).isPhoneNumber() else {
            toast("手机号输入有误")
            return
        }
        // 入参
        var dic = Dictionary<String, Any>()
        dic["loginMobile"] = txtP        // 手机号
        
        showLoading()
        viewModel.requestForMessageCodeForLogin(dic) { [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            // 请求失败
            guard success else {
                strongSelf.toast(msg ?? "请求短信验证码失败")
                return
            }
            // 请求成功
            strongSelf.toast("验证码已发送")
            // 开始倒计时
            strongSelf.viewMessageCode.startTimer()
        }
    }
}


//MARK: - Action

extension AuthCodeLoginController {
    // 提交
    fileprivate func submitAction() {
        // 登录请求
        requestForLogin()
    }
    
    // 跳转注册界面
    fileprivate func registerAction() {
        FKYNavigator.shared()?.openScheme(FKY_RegisterController.self, setProperty: nil, isModal: false, animated: true)
    }
    
    // 跳转找回密码界面
    fileprivate func passwordAction() {
        FKYNavigator.shared()?.openScheme(FKY_FindPassword.self, setProperty: nil, isModal: false, animated: true)
    }
}


//MARK: - Notification

extension AuthCodeLoginController {
    // 键盘显示
    @objc func keyboardWillShow(_ notification: Notification) {
        // 内容高度
        let contentHeight = WH(45) + WH(35) + WH(20) + WH(62) * inputNumber + WH(38) + WH(42) + WH(40) + WH(60)
        // 调整
        viewScroll.contentSize = CGSize(width: SCREEN_WIDTH, height: contentHeight)
        viewContent.snp.updateConstraints({ (make) in
            make.height.equalTo(contentHeight)
        })
        self.view.layoutIfNeeded()
    }
    
    // 键盘隐藏
    @objc func keyboardWillHide(_ notification: Notification) {
        // 内容高度
        var contentHeight = WH(45) + WH(35) + WH(20) + WH(62) * inputNumber + WH(38) + WH(42) + WH(40) + WH(60)
        // 保证界面可上下滑动
        if contentHeight <= SCREEN_HEIGHT - naviBarHeight() {
            contentHeight = SCREEN_HEIGHT - naviBarHeight() + WH(2)
        }
        // 调整
        viewScroll.contentSize = CGSize(width: SCREEN_WIDTH, height: contentHeight)
        viewContent.snp.updateConstraints({ (make) in
            make.height.equalTo(contentHeight)
        })
        self.view.layoutIfNeeded()
    }
}


//MARK: - Private

extension AuthCodeLoginController {
    // 实时获取用户输入的用户名
    fileprivate func getPhone() -> String? {
        let txt = viewPhone.getInputContent()
        return txt
    }
    
    // 实时获取用户输入的密码
    fileprivate func getMessageCode() -> String? {
        let txt = viewMessageCode.getInputContent()
        return txt
    }

    // 检查手机号
    fileprivate func validatePhone() {
        // 输入为空时不检测
        guard let phone = getPhone(), phone.isEmpty == false else {
            showTipForInputError(nil, .phone)
            return
        }
        
        if (phone as NSString).isPhoneNumber() {
            // 合法
            showTipForInputError(nil, .phone)
        }
        else {
            // 非法
            showTipForInputError("请输入正确的手机号", .phone)
        }
    }
    
    // 检查短信验证码
    fileprivate func validateMsgCode() {
        // 输入为空时不检测
        guard let msgCode = getMessageCode(), msgCode.isEmpty == false else {
            showTipForInputError(nil, .msgCode)
            return
        }
        
        if NSString.validateMessageCode(msgCode) {
            // 合法
            showTipForInputError(nil, .msgCode)
        }
        else {
            // 非法
            showTipForInputError("短信验证码输入有误", .msgCode)
        }
    }
    

    // 显示/隐藏非法输入提示
    fileprivate func showTipForInputError(_ tip: String?, _ type: LoginInputType) {
        switch type {
        case .phone:
            if let txt = tip, txt.isEmpty == false {
                // 有错误提示
                viewPhone.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(62) + WH(20))
                }
            }
            else {
                // 无错误提示
                viewPhone.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(62))
                }
            }
            viewPhone.showTip(tip)
        case .msgCode:
            if let txt = tip, txt.isEmpty == false {
                // 有错误提示
                viewMessageCode.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(62) + WH(20))
                }
            }
            else {
                // 无错误提示
                viewMessageCode.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(62))
                }
            }
            viewMessageCode.showTip(tip)
        default:
            break
        }
        
        view.layoutIfNeeded()
    }
    
    // 实时更新提交按钮状态
    fileprivate func updateSubmitBtnStatus() {
        // 手机号
        guard let phone = getPhone(), phone.isEmpty == false else {
            btnSubmit.isEnabled = false
            return
        }
        guard (phone as NSString).isPhoneNumber() else {
            // 必须11位
            btnSubmit.isEnabled = false
            return
        }
        
        // 短信验证码
        guard let msgCode = getMessageCode(), msgCode.isEmpty == false else {
            btnSubmit.isEnabled = false
            return
        }
        guard NSString.validateMessageCode(msgCode) else {
            // 必须6位
            btnSubmit.isEnabled = false
            return
        }
        
        // 可点击
        btnSubmit.isEnabled = true
    }

}
