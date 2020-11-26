//
//  LoginController.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  登录...<登录界面以模态视图的方式present出来>

import UIKit

// 登录界面文字输入类型
enum LoginInputType: Int {
    case name = 0       // 用户名
    case password = 1   // 密码
    case imgCode = 2    // 图形验证码
    case msgCode = 3    // 验证码
    case phone = 4   // 手机号码
}


class LoginController: UIViewController {
    //MARK: - Property
    
    // block
    @objc var loginSuccessBlock: ( () -> () )?
    
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
        lbl.text = "登录"
        return lbl
    }()
    
    // 用户名
    fileprivate lazy var viewName: RegisterNameView = {
        let view = RegisterNameView()
        view.setPlaceholder("请输入用户名或手机号")
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
            strongSelf.showTipForInputError(nil, .name)
        }
        //
        view.endEditing = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.validateName()
        }
        return view
    }()
    
    // 密码
    fileprivate lazy var viewPassword: LoginPasswordView = {
        let view = LoginPasswordView()
        view.setPlaceholder("请输入密码")
        //
        view.changeTextfield = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.updateSubmitBtnStatus()
        }
        view.forgetPassword = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.endEditing(true)
            strongSelf.passwordAction()
        }
        //
        view.beginEditing = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.showTipForInputError(nil, .password)
        }
        //
        view.endEditing = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.validatePassword()
        }
        return view
    }()
    
    // 图形验证码
    fileprivate lazy var viewImageCode: RegisterImageCodeView = {
        let view = RegisterImageCodeView()
        view.setPlaceholder("请输入图形验证码")
        // 请求图形验证码
        view.getImageCodeClosure = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.requestForImageCode()
        }
        //
        view.changeTextfield = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.updateSubmitBtnStatus()
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
        btn.setTitle("短信验证码登录", for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.endEditing(true)
            strongSelf.authCodeAction()
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
        print("LoginController deinit~!@")
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
}


//MARK: - UI

extension LoginController {
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
        viewContent.addSubview(viewName)
        viewContent.addSubview(viewPassword)
        viewContent.addSubview(viewImageCode)
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
        
        viewName.snp.makeConstraints({ (make) in
            make.left.right.equalTo(viewContent)
            make.top.equalTo(lblTitle.snp.bottom).offset(WH(20))
            make.height.equalTo(WH(62))
        })
        
        viewPassword.snp.makeConstraints({ (make) in
            make.left.right.equalTo(viewContent)
            make.top.equalTo(viewName.snp.bottom).offset(WH(0))
            make.height.equalTo(WH(62))
        })
        
        // 默认高度为0...<隐藏>
        viewImageCode.snp.makeConstraints({ (make) in
            make.left.right.equalTo(viewContent)
            make.top.equalTo(viewPassword.snp.bottom).offset(WH(0))
            //make.height.equalTo(WH(62))
            make.height.equalTo(WH(0))
        })
        
        btnSubmit.snp.makeConstraints({ (make) in
            make.left.equalTo(viewContent).offset(WH(30))
            make.right.equalTo(viewContent).offset(-WH(30))
            make.top.equalTo(viewImageCode.snp.bottom).offset(WH(38))
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
        viewImageCode.isHidden = true
        imgCoupon.isHidden = true
        // 默认禁用状态
        btnSubmit.isEnabled = false
    }
}


//MARK: - Data

extension LoginController {
    // 自动填充已保存的用户名和密码
    fileprivate func setupData() {
        let userName = SAMKeychain.password(forService: "username", account: "admin")
        let password = SAMKeychain.password(forService: "password", account: "admin")
        viewName.setValue(userName)
        viewPassword.setValue(password)
        updateSubmitBtnStatus()
    }
}


//MARK: - Request

extension LoginController {
    // 进入界面时需立即发起的请求
    fileprivate func setupRequest() {
        requestForCouponStatus()
        requestForImageCode()
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
    
    // 获取图形验证码...<不显示loading>
    fileprivate func requestForImageCode() {
        //showLoading()
        viewModel.requestForImageCode { [weak self,weak viewModel] (success, msg, picModel) in
            guard let strongSelf = self else {
                return
            }
            guard let strongViewModel = viewModel else {
                return
            }
            //strongSelf.dismissLoading()
            // 请求失败
            guard success else {
                strongSelf.toast(msg ?? "请求图形验证码失败")
                return
            }
            // 请求成功
            strongViewModel.imgCodeModel = picModel
            strongSelf.viewImageCode.setupCodeImage(picModel)
        }
    }
    
    // 登录...<图形验证码必传>
    fileprivate func requestForLogin() {
        // 名称
        guard let name = getName(), name.isEmpty == false else {
            toast("请输入用户名或手机号")
            return
        }
        guard name.count >= 6, name.count <= 20 else {
            //toast("请输入6~20位用户名")
            toast("请输入正确的用户名或手机号")
            return
        }
        
        // 密码
        guard let password = getPassword(), password.isEmpty == false else {
            toast("请输入密码")
            return
        }
        guard password.count >= 6, password.count <= 20 else {
            //toast("请输入6~20位密码")
            toast("请输入正确的密码")
            return
        }
        
        // 图形验证码
        if imgCodeFlag {
            guard let imgCode = getImageCode(), imgCode.isEmpty == false else {
                toast("请输入图形验证码")
                return
            }
        }
        
        // 入参...<所有输入内容均合法，可提交>
        var dic = Dictionary<String, Any>()
        dic["username"] = name      // 用户名
        dic["password"] = password  // 密码
        dic["code"] = getImageCode() ?? "" // 图形验证码内容<用户输入>
        dic["identity"] = viewModel.imgCodeModel?.identity ?? ""  // 图形验证码ID
        
        showLoading()
        viewModel.requestForLogin(dic) { [weak self] (success, msg, showFlag) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            // 请求失败
            guard success else {
                strongSelf.toast(msg ?? "登录失败")
                // 发登录失败通知
                NotificationCenter.default.post(name: NSNotification.Name.FKYLoginFailure, object: self, userInfo: nil)
                // 重新获取图形验证码
                strongSelf.requestForImageCode()
                // 若接口返回需要传入图形验证码，则显示
                if showFlag {
                    // 一旦显示一次，后面一直显示~!@
                    strongSelf.imgCodeFlag = true
                    strongSelf.updateImgCodeStatus()
                    strongSelf.updateSubmitBtnStatus()
                }
                return
            }
            // 请求成功
            // 发登录成功通知
            NotificationCenter.default.post(name: NSNotification.Name.FKYLoginSuccess, object: self, userInfo: nil)
            // 登录成功，则重置token过期弹登录界面的状态
            FKYAppDelegate!.showType = ShowLoginType.over
            // 界面跳转(返回)
            FKYNavigator.shared()?.dismiss({
                // 回调
                if let block = strongSelf.loginSuccessBlock {
                    block()
                }
            })
            FKYNavigator.shared()?.pop() // 防止有人不小心将登录界面进行push操作???
        }
    }
}


//MARK: - Action

extension LoginController {
    // 提交
    fileprivate func submitAction() {
        // 登录请求
        requestForLogin()
    }
    
    // 跳转注册界面
    fileprivate func registerAction() {
        FKYNavigator.shared()?.openScheme(FKY_RegisterController.self, setProperty: nil, isModal: false, animated: true)
    }
    // 跳转验证码登录
    fileprivate func authCodeAction() {
        FKYNavigator.shared()?.openScheme(FKY_AuthCodeLogin.self, setProperty: nil, isModal: false, animated: true)
    }
    
    // 跳转找回密码界面
    fileprivate func passwordAction() {
        FKYNavigator.shared()?.openScheme(FKY_FindPassword.self, setProperty: nil, isModal: false, animated: true)
    }
}


//MARK: - Notification

extension LoginController {
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

extension LoginController {
    // 实时获取用户输入的用户名
    fileprivate func getName() -> String? {
        let txt = viewName.getInputContent()
        return txt
    }
    
    // 实时获取用户输入的密码
    fileprivate func getPassword() -> String? {
        let txt = viewPassword.getInputContent()
        return txt
    }
    
    // 实时获取用户输入的图形验证码
    fileprivate func getImageCode() -> String? {
        let txt = viewImageCode.getInputContent()
        return txt
    }
    
    // 检查用户名
    fileprivate func validateName() {
        // 输入为空时不检测
        guard let name = getName(), name.isEmpty == false else {
            showTipForInputError(nil, .name)
            return
        }
        
        if name.count >= 6, name.count <= 20 {
            // 合法
            showTipForInputError(nil, .name)
        }
        else {
            // 非法
            //showTipForInputError("请输入6~20用户名", .name)
            showTipForInputError("请输入正确的用户名或手机号", .name)
        }
    }
    
    // 检查密码
    fileprivate func validatePassword() {
        // 输入为空时不检测
        guard let password = getPassword(), password.isEmpty == false else {
            showTipForInputError(nil, .password)
            return
        }
        
        if password.count >= 6, password.count <= 20 {
            // 合法
            showTipForInputError(nil, .password)
        }
        else {
            // 非法
            //showTipForInputError("请输入6~20位密码", .password)
            showTipForInputError("请输入正确的密码", .password)
        }
    }
    
    // 检查图形验证码
    fileprivate func validateImgCode() {
        // 有显示图形验证码输入框
        if imgCodeFlag {
            // 输入为空时不检测
            guard let imgCode = getImageCode(), imgCode.isEmpty == false else {
                showTipForInputError(nil, .imgCode)
                return
            }
        }
        
        // 图形验证码无限制
    }
    
    // 显示/隐藏非法输入提示
    fileprivate func showTipForInputError(_ tip: String?, _ type: LoginInputType) {
        switch type {
        case .name:
            if let txt = tip, txt.isEmpty == false {
                // 有错误提示
                viewName.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(62) + WH(20))
                }
            }
            else {
                // 无错误提示
                viewName.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(62))
                }
            }
            viewName.showTip(tip)
        case .password:
            if let txt = tip, txt.isEmpty == false {
                // 有错误提示
                viewPassword.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(62) + WH(20))
                }
            }
            else {
                // 无错误提示
                viewPassword.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(62))
                }
            }
            viewPassword.showTip(tip)
        case .imgCode:
            if imgCodeFlag {
                // 显示图形验证码输入框
                if let txt = tip, txt.isEmpty == false {
                    // 有错误提示
                    viewImageCode.snp.updateConstraints { (make) in
                        make.height.equalTo(WH(62) + WH(20))
                    }
                }
                else {
                    // 无错误提示
                    viewImageCode.snp.updateConstraints { (make) in
                        make.height.equalTo(WH(62))
                    }
                }
                // 显示
                viewImageCode.isHidden = false
            }
            else {
                // 不显示图形验证码输入框
                viewImageCode.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(0))
                }
                // 隐藏
                viewImageCode.isHidden = true
            }
            viewImageCode.showTip(tip)
        default:
            break
        }
        
        view.layoutIfNeeded()
    }
    
    // 实时更新提交按钮状态
    fileprivate func updateSubmitBtnStatus() {
        // 名称
        guard let name = getName(), name.isEmpty == false else {
            btnSubmit.isEnabled = false
            return
        }
        guard name.count >= 6, name.count <= 20 else {
            btnSubmit.isEnabled = false
            return
        }
        
        // 密码
        guard let password = getPassword(), password.isEmpty == false else {
            btnSubmit.isEnabled = false
            return
        }
        guard password.count >= 6, password.count <= 20 else {
            btnSubmit.isEnabled = false
            return
        }
        
        // 有显示图形验证码输入框
        if imgCodeFlag {
            // 图形验证码
            guard let imgCode = getImageCode(), imgCode.isEmpty == false else {
                btnSubmit.isEnabled = false
                return
            }
        }
        
        // 可点击
        btnSubmit.isEnabled = true
    }
    
    // 实时更新图形验证码输入框
    fileprivate func updateImgCodeStatus() {
        if imgCodeFlag {
            // 显示
            viewImageCode.snp.updateConstraints { (make) in
                make.height.equalTo(WH(62))
            }
            viewImageCode.isHidden = false
        }
        else {
            // 隐藏
            viewImageCode.snp.updateConstraints { (make) in
                make.height.equalTo(WH(0))
            }
            viewImageCode.isHidden = true
        }
        view.layoutIfNeeded()
    }
}
