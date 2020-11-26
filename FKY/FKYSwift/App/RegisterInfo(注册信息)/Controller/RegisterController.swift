//
//  RegisterController.swift
//  FKY
//
//  Created by 夏志勇 on 2019/7/31.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  注册

import UIKit

// 注册界面文字输入类型
enum RegisterInputType: Int {
    case name = 0       // 用户名
    case phone = 1      // 手机号
    case imgCode = 2    // 图形验证码
    case msgCode = 3    // 短信验证码
    case password = 4   // 密码
}


class RegisterController: UIViewController {
    //MARK: - Property
    
    // viewmodel
    fileprivate lazy var viewModel = RegisterViewModel()
    
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
        //let view = UIScrollView(frame: CGRect(x: 0, y: naviBarHeight(), width: SCREEN_WIDTH, height: SCREEN_HEIGHT - naviBarHeight()))
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
        lbl.text = "注册"
        return lbl
    }()
    
    // 用户名
    fileprivate lazy var viewName: RegisterNameView = {
        let view = RegisterNameView()
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
            //输入时置灰按钮，反正本来验证通过了，用户修改时未失焦校验点击登录按钮
            strongSelf.btnSubmit.isEnabled = false
            strongSelf.isSameUser = true
            strongSelf.showTipForInputError(nil, .name)
        }
        //
        view.endEditing = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.validateName() == true {
                //用户名校验正确
                strongSelf.requestForValidateUser()
            }
        }
        return view
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
    
    // 图形验证码
    fileprivate lazy var viewImageCode: RegisterImageCodeView = {
        let view = RegisterImageCodeView()
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
            strongSelf.showTipForInputError(nil, .msgCode)
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
    
    // 密码
    fileprivate lazy var viewPassword: RegisterPasswordView = {
        let view = RegisterPasswordView()
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
    
    // 协议
    fileprivate lazy var viewProtocol: RegisterProtocolView = {
        let view = RegisterProtocolView()
        // 服务协议
        view.serviceClosure = {
            FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                let controller = vc as! FKY_Web
                controller.urlPath = "http://mall.yaoex.com/cmsPage/2020c4f4ea7f0608140810/index.html"
                controller.title = "1药城服务协议"
                controller.barStyle = FKYWebBarStyle.barStyleWhite
            })
        }
        // 隐私条款
        view.privateClosure = {
            FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                let controller = vc as! FKY_Web
                controller.urlPath = "http://mall.yaoex.com/cmsPage/2020dfe570a10608111609/index.html"
                controller.title = "1药城隐私条款"
                controller.barStyle = FKYWebBarStyle.barStyleWhite
            })
        }
        
        ///销售协议
        view.sellClosure = {
            FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                let controller = vc as! FKY_Web
                controller.urlPath = "https://m.yaoex.com/web/h5/maps/index.html?pageId=101174&type=release"
            })
        }
        
        // 勾选
        view.selectClosure = { [weak self] in
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
    
    //
    var isSameUser = false //记录用户名是否已经存在
    var isBdPhoneNum = false //判断是否是bd手机号码
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 隐藏切换
        IQKeyboardManager.shared().previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared().shouldToolbarUsesTextFieldTintColor = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print("RegisterController deinit~!@")
        // 移除通知
        NotificationCenter.default.removeObserver(self)
        // 若子视图中有timer，则需要invalidate
        viewMessageCode.stopTimer()
    }
}


//MARK: - UI

extension RegisterController {
    // UI绘制
    fileprivate func setupView() {
        setupNavigationBar()
        setupContentView()
    }
    
    // 导航栏
    fileprivate func setupNavigationBar() {
        // 标题
        fky_setupTitleLabel("")
        // 分隔线
        fky_hiddedBottomLine(true)
        
        // 返回
        fky_setupLeftImage("login_back_pic") { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.endEditing(true)
            FKYNavigator.shared().pop()
        }
    }
    
    // 内容视图
    fileprivate func setupContentView() {
        // 内容高度
        var contentHeight = WH(45) + WH(35) + WH(20) + WH(62) * 5 + WH(75) + WH(42) + WH(80)
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
        
        //viewContent.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: contentHeight)
        viewScroll.addSubview(viewContent)
        viewContent.snp.makeConstraints({ (make) in
            //make.left.right.top.equalTo(viewScroll)
            make.left.top.equalTo(viewScroll)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(contentHeight)
        })
        
        viewContent.addSubview(lblTitle)
        viewContent.addSubview(viewName)
        viewContent.addSubview(viewPhone)
        viewContent.addSubview(viewImageCode)
        viewContent.addSubview(viewMessageCode)
        viewContent.addSubview(viewPassword)
        viewContent.addSubview(viewProtocol)
        viewContent.addSubview(btnSubmit)
        
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
        
        viewPhone.snp.makeConstraints({ (make) in
            make.left.right.equalTo(viewContent)
            make.top.equalTo(viewName.snp.bottom).offset(WH(0))
            make.height.equalTo(WH(62))
        })
        
        viewImageCode.snp.makeConstraints({ (make) in
            make.left.right.equalTo(viewContent)
            make.top.equalTo(viewPhone.snp.bottom).offset(WH(0))
            make.height.equalTo(WH(62))
        })
        
        viewMessageCode.snp.makeConstraints({ (make) in
            make.left.right.equalTo(viewContent)
            make.top.equalTo(viewImageCode.snp.bottom).offset(WH(0))
            make.height.equalTo(WH(62))
        })
        
        viewPassword.snp.makeConstraints({ (make) in
            make.left.right.equalTo(viewContent)
            make.top.equalTo(viewMessageCode.snp.bottom).offset(WH(0))
            make.height.equalTo(WH(62))
        })
        
        viewProtocol.snp.makeConstraints({ (make) in
            make.left.right.equalTo(viewContent)
            make.top.equalTo(viewPassword.snp.bottom).offset(WH(10))
            make.height.equalTo(WH(30+30+5+5+5))
        })
        
        btnSubmit.snp.makeConstraints({ (make) in
            make.left.equalTo(viewContent).offset(WH(30))
            make.right.equalTo(viewContent).offset(-WH(30))
            make.top.equalTo(viewProtocol.snp.bottom).offset(WH(35))
            make.height.equalTo(WH(42))
        })
        
        // 默认禁用状态
        btnSubmit.isEnabled = false
    }
}


//MARK: - Request

extension RegisterController {
    //
    fileprivate func setupRequest() {
        // 进入界面后需立即请求图形验证码
        requestForImageCode()
    }
    //验证用户名是否存在
    fileprivate func requestForValidateUser() {
        guard let name = getName(), name.isEmpty == false else {
            toast("请输入用户名")
            return
        }
        var dic = Dictionary<String, Any>()
        dic["userName"] = name      // 用户名
        viewModel.requestForValidateUserName(dic){ [weak self] (success, msg,typeStr) in
            guard let strongSelf = self else {
                return
            }
            if success == true ,let str = typeStr {
                if str == "1"{
                    //用户名存在
                    strongSelf.showTipForInputError("用户名已存在，请尝试其他用户名", .name)
                    strongSelf.isSameUser = true
                }else {
                    //用户名不存在
                    strongSelf.isSameUser = false
                }
            }else {
                strongSelf.isSameUser = false
                strongSelf.toast(msg ?? "验证失败")
            }
            strongSelf.updateSubmitBtnStatus()
        }
    }
    // 获取图形验证码
    fileprivate func requestForImageCode() {
        showLoading()
        viewModel.requestForImageCode { [weak self] (success, msg, picModel) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            // 请求失败
            guard success else {
                strongSelf.toast(msg ?? "请求图形验证码失败")
                return
            }
            // 请求成功
            strongSelf.viewModel.imgCodeModel = picModel
            strongSelf.viewImageCode.setupCodeImage(picModel)
        }
    }
    
    // 获取短信验证码
    fileprivate func requestForMessageCode() {
        guard let imgModel = viewModel.imgCodeModel else {
            toast("图形验证码获取失败，请重新获取")
            return
        }
        guard let pid = imgModel.identity, pid.isEmpty == false else {
            toast("图形验证码获取有误，请重新获取")
            return
        }
        
        let imgId = pid
        let phone: String? = getPhone()
        let imgCode: String? = getImageCode()
        
        guard let txtP = phone, txtP.isEmpty == false else {
            toast("请输入手机号")
            return
        }
        guard (txtP as NSString).isPhoneNumber() else {
            toast("手机号输入有误")
            return
        }
        guard let txtC = imgCode, txtC.isEmpty == false else {
            toast("请输入图形验证码")
            return
        }
        
        // 入参
        var dic = Dictionary<String, Any>()
        dic["type"] = 1             // 类型
        dic["identity"] = imgId     // 图形验证码ID
        dic["code"] = txtC          // 图形验证码内容
        dic["mobile"] = txtP        // 手机号
        
        showLoading()
        viewModel.requestForMessageCode(dic) { [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            // 请求失败
            guard success else {
                strongSelf.toast(msg ?? "请求短信验证码失败")
                strongSelf.requestForImageCode() // 更新图形验证码
                return
            }
            // 请求成功
            strongSelf.toast("验证码已发送")
            // 开始倒计时
            strongSelf.viewMessageCode.startTimer()
        }
    }
    
    // 注册
    fileprivate func requestForRegister() {
        // 名称
        guard let name = getName(), name.isEmpty == false else {
            toast("请输入用户名")
            return
        }
        guard name.count >= 6, name.count <= 20 else {
            toast("请输入6~20位用户名")
            return
        }
        
        // 手机号
        guard let phone = getPhone(), phone.isEmpty == false else {
            toast("请输入手机号")
            return
        }
        guard (phone as NSString).isPhoneNumber() else {
            toast("请输入正确的手机号")
            return
        }
        
        // 图形验证码...<注册时不传>
        guard let imgCode = getImageCode(), imgCode.isEmpty == false else {
            toast("请输入图形验证码")
            return
        }
        
        // 短信验证码
        guard let msgCode = getMessageCode(), msgCode.isEmpty == false else {
            toast("请输入短信验证码")
            return
        }
        guard NSString.validateMessageCode(msgCode) else {
            toast("短信验证码输入有误")
            return
        }
        
        // 密码
        guard let password = getPassword(), password.isEmpty == false else {
            toast("请输入密码")
            return
        }
        guard password.count >= 6, password.count <= 20 else {
            toast("请输入6~20位密码")
            return
        }
        
        // 入参...<所有输入内容均合法，可提交>
        var dic = Dictionary<String, Any>()
        dic["source"] = 4           // 类型???
        dic["username"] = name      // 用户名
        dic["mobile"] = phone       // 手机号
        dic["sms_code"] = msgCode   // 短信验证码
        dic["password"] = password  // 密码
        
        showLoading()
        viewModel.requestForRegister(dic) { [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            // 请求失败
            guard success else {
                strongSelf.toast(msg ?? "注册失败")
                strongSelf.requestForImageCode() // 更新图形验证码
                return
            }
            // 请求成功
            // 发登录成功通知
            NotificationCenter.default.post(name: NSNotification.Name.FKYLoginSuccess, object: self, userInfo: nil)
            // 登录成功，则重置token过期弹登录界面的状态
            FKYAppDelegate!.showType = ShowLoginType.over
            // 返回到个人中心
            FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                let controller = vc as! FKYTabBarController
                controller.index = 4
                //controller.toast("注册成功")
            }, isModal: false)
        }
    }
    // 注册
    fileprivate func requestverifyBdPhoneForRegister(_ phone:String, _ block: @escaping (Bool,String?)->()){
        var dic = Dictionary<String, Any>()
        dic["mobile"] = phone      // 手机号
        showLoading()
        viewModel.requestVerifyBdPhoneForRegister(dic) { [weak self] (success, msg) in
            guard let strongSelf = self else {
                block(false,"校验失败")
                return
            }
            strongSelf.dismissLoading()
            if success == false{
                block(false,msg)
                return
            }
            block(true,"")
        }
    }
}

//MARK: - Action

extension RegisterController {
    // 提交
    fileprivate func submitAction() {
        //        guard validateAllInput() else {
        //            return
        //        }
        
        // 注册请求
        requestForRegister()
    }
}


//MARK: - Notification

extension RegisterController {
    // 键盘显示
    @objc func keyboardWillShow(_ notification: Notification) {
        // 内容高度
        let contentHeight = WH(45) + WH(35) + WH(20) + WH(62) * 5 + WH(75) + WH(42) + WH(80)
        // 调整
        viewScroll.contentSize = CGSize(width: SCREEN_WIDTH, height: contentHeight)
        viewContent.snp.updateConstraints({ (make) in
            make.height.equalTo(contentHeight)
        })
        self.view.layoutIfNeeded()
    }
    
    // 键盘隐藏@objc 
    @objc func keyboardWillHide(_ notification: Notification) {
        // 内容高度
        var contentHeight = WH(45) + WH(35) + WH(20) + WH(62) * 5 + WH(75) + WH(42) + WH(80)
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

extension RegisterController {
    //
    fileprivate func getName() -> String? {
        let txt = viewName.getInputContent()
        return txt
    }
    
    //
    fileprivate func getPhone() -> String? {
        let txt = viewPhone.getInputContent()
        return txt
    }
    
    //
    fileprivate func getImageCode() -> String? {
        let txt = viewImageCode.getInputContent()
        return txt
    }
    
    //
    fileprivate func getMessageCode() -> String? {
        let txt = viewMessageCode.getInputContent()
        return txt
    }
    
    //
    fileprivate func getPassword() -> String? {
        let txt = viewPassword.getInputContent()
        return txt
    }
    
    // 检查用户名<返回true时表示用户名校验正确>
    fileprivate func validateName() -> Bool {
        // 输入为空时不检测
        guard let name = getName(), name.isEmpty == false else {
            showTipForInputError(nil, .name)
            return false
        }
        
        if name.count >= 6, name.count <= 20 {
            // 合法
            showTipForInputError(nil, .name)
            return true
        }
        else {
            // 非法
            showTipForInputError("请输入6~20用户名", .name)
            return false
        }
    }
    
    // 检查手机号
    fileprivate func validatePhone() {
        self.isBdPhoneNum = false
        viewMessageCode.setMessageBtnValid(true)
        // 输入为空时不检测
        guard let phone = getPhone(), phone.isEmpty == false else {
            showTipForInputError(nil, .phone)
            return
        }
        
        if (phone as NSString).isPhoneNumber() {
            // 合法
            showTipForInputError(nil, .phone)
            self.requestverifyBdPhoneForRegister(phone,  { [weak self] (success,msg) in
                   guard let strongSelf = self else {
                       return
                   }
                if success == false{
                    strongSelf.showTipForInputError(msg, .phone)
                    strongSelf.isBdPhoneNum = true
                    strongSelf.viewMessageCode.setMessageBtnValid(false)
                }else{
                    strongSelf.showTipForInputError(nil, .phone)
                }
            })
        }
        else {
            // 非法
            showTipForInputError("请输入正确的手机号", .phone)
        }
        
    }
    
    // 检查图形验证码...<图形验证码仅用于获取短信验证码，与注册无关~!@>
    fileprivate func validateImgCode() {
        // 输入为空时不检测
        guard let imgCode = getImageCode(), imgCode.isEmpty == false else {
            showTipForInputError(nil, .imgCode)
            return
        }
        
        // 图形验证码无限制
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
    
    // 检查密码
    fileprivate func validatePassword() {
        // 输入为空时不检测
        guard let password = getPassword(), password.isEmpty == false else {
            showTipForInputError(nil, .password)
            return
        }
        
        if password.count >= 6, password.count <= 20 {
            // 长度合法
            //showTipForInputError(nil, .password)
            
            if (password as NSString).isValidPassword() {
                // 内容合法
                showTipForInputError(nil, .password)
            }
            else {
                // 内容非法
                showTipForInputError("请输入6~20位密码，不可是纯字母/数字/符号", .password)
            }
        }
        else {
            // 长度非法
            showTipForInputError("请输入6~20位密码", .password)
        }
    }
    
    // 显示/隐藏非法输入提示
    fileprivate func showTipForInputError(_ tip: String?, _ type: RegisterInputType) {
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
        case .imgCode:
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
            viewImageCode.showTip(tip)
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
        guard self.isSameUser == false else {
            btnSubmit.isEnabled = false
            return
        }
        
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
        
        // 图形验证码
        guard let imgCode = getImageCode(), imgCode.isEmpty == false else {
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
        
        // 密码
        guard let password = getPassword(), password.isEmpty == false else {
            btnSubmit.isEnabled = false
            return
        }
        guard password.count >= 6, password.count <= 20 else {
            btnSubmit.isEnabled = false
            return
        }
        guard (password as NSString).isValidPassword() else {
            btnSubmit.isEnabled = false
            return
        }
        
        // 协议勾选
        guard viewProtocol.agreeFlag else {
            btnSubmit.isEnabled = false
            return
        }
        
        // 可点击
        btnSubmit.isEnabled = true
    }
    
    // 检测所有输入内容的合法性...<未使用>
    fileprivate func validateAllInput() -> Bool {
        // 名称
        guard let name = getName(), name.isEmpty == false else {
            toast("请输入用户名")
            return false
        }
        
        // 手机号
        guard let phone = getPhone(), phone.isEmpty == false else {
            toast("请输入手机号")
            return false
        }
        guard (phone as NSString).isPhoneNumber() else {
            toast("请输入正确的手机号")
            return false
        }
        
        // 图形验证码
        guard let imgCode = getImageCode(), imgCode.isEmpty == false else {
            toast("请输入图形验证码")
            return false
        }
        
        // 短信验证码
        guard let msgCode = getMessageCode(), msgCode.isEmpty == false else {
            toast("请输入短信验证码")
            return false
        }
        guard NSString.validateMessageCode(msgCode) else {
            toast("短信验证码输入有误")
            return false
        }
        
        // 密码
        guard let password = getPassword(), password.isEmpty == false else {
            toast("请输入密码")
            return false
        }
        guard password.count >= 6, password.count <= 20 else {
            toast("请输入6~20位密码")
            return false
        }
        guard (password as NSString).isValidPassword() else {
            toast("请输入6~20位密码，不可是纯字母/数字/符号")
            return false
        }
        
        return true
    }
}
