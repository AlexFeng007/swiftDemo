//
//  FKYSetPasswordViewController.swift
//  FKY
//
//  Created by hui on 2019/6/25.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//  重置密码 or 修改密码

import UIKit

class FKYSetPasswordViewController: UIViewController {
    //MARK: - UI属性
    
    // title
    fileprivate lazy var titleView : FKYPasswordTitleView = {
        let view = FKYPasswordTitleView()
        return view
    }()
    
    // 原密码（type为1时使用）
    fileprivate lazy var passwordOldView : FKYPhoneView = {
        let view = FKYPhoneView()
        view.type = 1
        view.phoneTxtfield.placeholder = "请输入原密码"
        view.phoneTxtfield.isSecureTextEntry = true
        view.updateLayoutForPassword()
        view.changeTextfield = { [weak self] in
            if let strongSelf = self {
                strongSelf.updateNextBtn()
            }
        }
        view.beginEditing = { [weak self] in
            if let strongSelf = self {
                strongSelf.refreshPasswordViewError(nil,strongSelf.passwordOldView)
            }
        }
        view.endEditing = { [weak self] in
            if let strongSelf = self {
                _ = strongSelf.validatePasswrodNum(strongSelf.passwordOldView,1)
            }
        }
        return view
    }()
    
    // 密码
    fileprivate lazy var passwordView : FKYPhoneView = {
        let view = FKYPhoneView()
        view.phoneTxtfield.placeholder = "请输入6~20位新密码"
        view.phoneTxtfield.isSecureTextEntry = true
        view.updateLayoutForPassword()
        view.changeTextfield = { [weak self] in
            if let strongSelf = self {
                strongSelf.updateNextBtn()
            }
        }
        view.beginEditing = { [weak self] in
            if let strongSelf = self {
                strongSelf.refreshPasswordViewError(nil,strongSelf.passwordView)
            }
        }
        view.endEditing = { [weak self] in
            if let strongSelf = self {
                if strongSelf.validatePasswrodNum(strongSelf.passwordView,1) == true {
                    _ = strongSelf.validateSamePasswrodNum(1)
                }
            }
        }
        return view
    }()
    
    // 重复输入密码
    fileprivate lazy var passwordAgainView : FKYPhoneView = {
        let view = FKYPhoneView()
        view.phoneTxtfield.placeholder = "确认新密码"
        view.phoneTxtfield.isSecureTextEntry = true
        view.updateLayoutForPassword()
        view.changeTextfield = { [weak self,weak view] in
            if let strongSelf = self {
                strongSelf.updateNextBtn()
            }
            guard let strongView = view else {
                return
            }
            
            strongView.beginEditing = { [weak self] in
                if let strongSelf = self {
                    strongSelf.refreshPasswordViewError(nil,strongSelf.passwordAgainView)
                }
            }
            strongView.endEditing = { [weak self] in
                if let strongSelf = self {
                    if strongSelf.validatePasswrodNum(strongSelf.passwordAgainView,1) == true {
                        let _ = strongSelf.validateSamePasswrodNum(1)
                    }
                }
            }
        }
        return view
    }()
    
    //下一步
    fileprivate lazy var submitButton : UIButton = {
        let btn = UIButton()
        btn.isUserInteractionEnabled = false
        btn.setTitleColor(RGBColor(0xFFFFFF), for: [.normal])
        btn.titleLabel?.font = t73.font
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.backgroundColor = RGBColor(0xFFABBD) //FF2D5D
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self]  (_) in
            if let strongSelf = self {
                if strongSelf.type == 0 {
                    strongSelf.resetPasswrod()
                }else if strongSelf.type == 1 {
                    strongSelf.changePasswrod()
                }
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    fileprivate lazy var accountLaunchLogic : FKYAccountLaunchLogic = {
        return FKYAccountLaunchLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as! FKYAccountLaunchLogic
    }()
    
    //修改密码需要参数
    var picCodeModel : FKYAccountPicCodeModel?
    
    //MARK: - 入参（重置密码 需要入参数）
    //var smsuuid : String? //
    var identityStr : String? //图像标示
    var retrieveOneModel : FKYRetrieveOneModel?
    @objc var phoneStr : String? //手机号
    
    // 0 重置密码（找回密码） 1 修改密码
    @objc var type : Int = 0
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
}

//MARK:刷新数据界面相关
extension FKYSetPasswordViewController {
    //刷新错误提示
    fileprivate func refreshPasswordViewError(_ errorStr : String?,_ refreshView:FKYPhoneView) {
        refreshView.refreshErrorLabel(errorStr)
        if  errorStr != nil {
            refreshView.snp.updateConstraints({ (make) in
                make.height.equalTo(WH(44+5+17))
            })
        }else{
            refreshView.snp.updateConstraints({ (make) in
                make.height.equalTo(WH(44))
            })
        }
    }
    
    fileprivate func validatePasswrodNum (_ refreshView:FKYPhoneView,_ typeIndex:Int) -> Bool {
        if let passwrodStr = refreshView.phoneTxtfield.text , passwrodStr.count > 0 {
            if refreshView.type == 1 {
                    //原始密码不需要检验 纯字母/数字/符号
                    if passwrodStr.count < 6 || passwrodStr.count > 20  {
                        if typeIndex == 1 {
                            self.refreshPasswordViewError("密码长度应为6-20位",refreshView)
                        }
                        return false
                    }
                }else {
                    //新密码验证是否是纯字母/数字/符号
                    if (passwrodStr as NSString).isValidPassword() == false {
                        if typeIndex == 1 {
                            self.refreshPasswordViewError("密码6-20位，不可是纯字母/数字/符号",refreshView)
                        }
                        return false
                    }
                }
                return true
            }
            return false
        }
        
        fileprivate func validateSamePasswrodNum(_ type:Int) -> Bool {
            if let passwrodStr = self.passwordView.phoneTxtfield.text , passwrodStr.count > 0 ,let passwrodAgainStr = self.passwordAgainView.phoneTxtfield.text , passwrodAgainStr.count > 0{
                if passwrodStr !=  passwrodAgainStr {
                    if type == 1 {
                        self.refreshPasswordViewError("2次输入的密码不一致",self.passwordView)
                        self.refreshPasswordViewError("2次输入的密码不一致",self.passwordAgainView)
                    }
                    return false
                }else{
                    if type == 1 {
                        self.refreshPasswordViewError(nil,self.passwordView)
                        self.refreshPasswordViewError(nil,self.passwordAgainView)
                    }
                    return true
                }
            }
            return false
        }
    }
    
    //MARK:网络请求相关
    extension FKYSetPasswordViewController {
        //获取图片验证码
        fileprivate func getPicCode() {
            FKYRequestService.sharedInstance()?.requestForGetImageCode(withParam: nil, completionBlock: { [weak self] (success, error, response, model) in
                guard let strongSelf = self else {
                    return
                }
                guard success else {
                    // 失败
                    let msg = error?.localizedDescription ?? "获取失败"
                    strongSelf.toast(msg)
                    return
                }
                if let picModel = model as? FKYAccountPicCodeModel {
                    strongSelf.picCodeModel = picModel
                }
            })
        }
        
        //修改密码
        fileprivate func changePasswrod() {
            //验证两次输入的密码
            if  self.validatePasswrodNum(self.passwordOldView,2) == false || self.validatePasswrodNum(self.passwordView,2) == false ||  self.validatePasswrodNum(self.passwordAgainView,2) == false {
                return
            }else{
                if self.validateSamePasswrodNum(2) == false {
                    return
                }
            }
            var params :[String : Any] = [:]
            params["current_pwd"] = self.passwordOldView.phoneTxtfield.text
            params["new_pwd"] = self.passwordView.phoneTxtfield.text
            self.showLoading()
            FKYRequestService.sharedInstance()?.resetPasswordDataInUserSet(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
                guard let strongSelf = self else {
                    return
                }
                guard success else {
                    // 失败
                    strongSelf.dismissLoading()
                    let msg = error?.localizedDescription ?? "获取失败"
                    strongSelf.toast(msg)
                    return
                }
                //修改密码成功后自动登录
                strongSelf.loginWithAtuo()
                
            })
        }
        
        //重置密码
        fileprivate func resetPasswrod() {
            //验证两次输入的密码
            if self.validatePasswrodNum(self.passwordView,2) == false ||  self.validatePasswrodNum(self.passwordAgainView,2) == false {
                return
            }else{
                if self.validateSamePasswrodNum(2) == false {
                    return
                }
            }
            var params :[String : Any] = [:]
            params["password"] = self.passwordView.phoneTxtfield.text
            params["mobile"] = self.phoneStr
            params["enterpriseId"] = self.retrieveOneModel?.enterpriseId
            params["identity"] = self.identityStr
            self.showLoading()
            FKYRequestService.sharedInstance()?.requestForFindPasswordThree(withParam: params , completionBlock: { [weak self] (success, error, response, model) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.dismissLoading()
                guard success else {
                    // 失败
                    let msg = error?.localizedDescription ?? "获取失败"
                    strongSelf.toast(msg)
                    return
                }
                if let dic = response as? Dictionary<String, Any> {
                    var param :[String : Any] = [:]
                    param["password"] = strongSelf.passwordView.phoneTxtfield.text
                    param["username"] = strongSelf.phoneStr
                    //重置密码成功后，返回用户登录信息
                 FKYAccountLaunchLogic.handleResponseData(dic ,forRequest:param,withFlag: false)
                    // 发登录成功通知
                    NotificationCenter.default.post(name: NSNotification.Name.FKYLoginSuccess, object: self, userInfo: nil)
                    // 登录成功，则重置token过期弹登录界面的状态
                    FKYAppDelegate!.showType = ShowLoginType.over
                    FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                        let v = vc as! FKY_TabBarController
                        v.index = 4
                        
                    }, isModal: false)
                    strongSelf.toast("密码重置成功")
                }
                //重置密码成功后自动登录
                //strongSelf.loginWithAtuo()
            })
        }
        
        fileprivate func loginWithAtuo() {
            var loginParams :[String : Any] = [:]
            if self.type == 0 {
                loginParams["code"] = ""
                loginParams["identity"] = self.identityStr
            }else{
                loginParams["code"] = ""
                loginParams["identity"] = self.picCodeModel?.identity
            }
            loginParams["username"] = self.phoneStr
            loginParams["password"] = self.passwordView.phoneTxtfield.text
            self.accountLaunchLogic.login(withParam: loginParams, completionBlock: { [weak self] (responseObj, error) in
                if let strongSelf = self {
                    strongSelf.dismissLoading()
                    if error != nil {
                        //自动登录失败回到登录界面
                        if strongSelf.type == 0 {
                            FKYNavigator.shared()?.pop(toScheme: FKY_Login.self)
                        }else{
                            FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                                let v = vc as! FKY_TabBarController
                                v.index = 4
                                FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
                            }, isModal: false)
                        }
                        let msg = error?.localizedDescription ?? "登录失败"
                        strongSelf.toast(msg)
                    }else{
                        // 发登录成功通知
                        NotificationCenter.default.post(name: NSNotification.Name.FKYLoginSuccess, object: self, userInfo: nil)
                        // 登录成功，则重置token过期弹登录界面的状态
                        FKYAppDelegate!.showType = ShowLoginType.over
                        //自动登录成功回到个人中心
                        FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                            let v = vc as! FKY_TabBarController
                            v.index = 4
                            
                        }, isModal: false)
                        if strongSelf.type == 0 {
                            strongSelf.toast("密码重置成功")
                        }else {
                            strongSelf.toast("密码修改成功")
                        }
                    }
                }
            })
        }
    }
    
    extension FKYSetPasswordViewController {
        fileprivate  func setupView() {
            self.view.backgroundColor = RGBColor(0xFFFFFF)
            
            self.view.addSubview(self.titleView)
            self.titleView.snp.makeConstraints { (make) in
                make.top.right.left.equalTo(self.view)
                make.height.equalTo(LOGIN_ABOUT_H)
            }
            if self.type == 0 {
                self.titleView.titleLabel.text = "重置密码"
                self.submitButton.setTitle("确认修改", for: [.normal])
                self.view.addSubview(self.passwordView)
                self.passwordView.snp.makeConstraints { (make) in
                    make.top.equalTo(self.titleView.snp.bottom).offset(WH(38))
                    make.left.equalTo(self.view.snp.left).offset(WH(30))
                    make.right.equalTo(self.view.snp.right).offset(-WH(30))
                    make.height.equalTo(WH(44))
                }
            }else if self.type == 1 {
                self.getPicCode()
                self.titleView.titleLabel.text = "修改密码"
                self.submitButton.setTitle("确认修改", for: [.normal])
                self.view.addSubview(self.passwordOldView)
                self.passwordOldView.snp.makeConstraints { (make) in
                    make.top.equalTo(self.titleView.snp.bottom).offset(WH(38))
                    make.left.equalTo(self.view.snp.left).offset(WH(30))
                    make.right.equalTo(self.view.snp.right).offset(-WH(30))
                    make.height.equalTo(WH(44))
                }
                self.view.addSubview(self.passwordView)
                self.passwordView.snp.makeConstraints { (make) in
                    make.top.equalTo(self.passwordOldView.snp.bottom).offset(WH(18))
                    make.left.equalTo(self.view.snp.left).offset(WH(30))
                    make.right.equalTo(self.view.snp.right).offset(-WH(30))
                    make.height.equalTo(WH(44))
                }
            }
            
            self.view.addSubview(self.passwordAgainView)
            self.passwordAgainView.snp.makeConstraints { (make) in
                make.top.equalTo(self.passwordView.snp.bottom).offset(WH(18))
                make.left.equalTo(self.view.snp.left).offset(WH(30))
                make.right.equalTo(self.view.snp.right).offset(-WH(30))
                make.height.equalTo(WH(44))
            }
            self.view.addSubview(self.submitButton)
            self.submitButton.snp.makeConstraints { (make) in
                make.top.equalTo(self.passwordAgainView.snp.bottom).offset(WH(40))
                make.left.equalTo(self.view.snp.left).offset(WH(30))
                make.right.equalTo(self.view.snp.right).offset(-WH(30))
                make.height.equalTo(WH(42))
            }
        }
        
        fileprivate func updateNextBtn() {
            if self.type == 0 {
                if let passwordStr = self.passwordView.phoneTxtfield.text,passwordStr.count > 0,let passwordAgainStr = self.passwordAgainView.phoneTxtfield.text,passwordAgainStr.count > 0 {
                    //验证两次输入的密码
                    if self.validatePasswrodNum(self.passwordView,2) == false ||  self.validatePasswrodNum(self.passwordAgainView,2) == false {
                        self.submitButton.backgroundColor = RGBColor(0xFFABBD)
                        self.submitButton.isUserInteractionEnabled = false
                    }else{
                        if self.validateSamePasswrodNum(2) == false {
                            self.submitButton.backgroundColor = RGBColor(0xFFABBD)
                            self.submitButton.isUserInteractionEnabled = false
                        }else {
                            self.submitButton.backgroundColor = RGBColor(0xFF2D5D)
                            self.submitButton.isUserInteractionEnabled = true
                        }
                    }
                }else {
                    self.submitButton.backgroundColor = RGBColor(0xFFABBD)
                    self.submitButton.isUserInteractionEnabled = false
                }
            }else if self.type == 1 {
                if let passwordOldStr = self.passwordOldView.phoneTxtfield.text,passwordOldStr.count > 0, let passwordStr = self.passwordView.phoneTxtfield.text,passwordStr.count > 0,let passwordAgainStr = self.passwordAgainView.phoneTxtfield.text,passwordAgainStr.count > 0 {
                    //验证两次输入的密码
                    if  self.validatePasswrodNum(self.passwordOldView,2) == false || self.validatePasswrodNum(self.passwordView,2) == false ||  self.validatePasswrodNum(self.passwordAgainView,2) == false {
                        self.submitButton.backgroundColor = RGBColor(0xFFABBD)
                        self.submitButton.isUserInteractionEnabled = false
                    }else{
                        if self.validateSamePasswrodNum(2) == false {
                            self.submitButton.backgroundColor = RGBColor(0xFFABBD)
                            self.submitButton.isUserInteractionEnabled = false
                        }else {
                            self.submitButton.backgroundColor = RGBColor(0xFF2D5D)
                            self.submitButton.isUserInteractionEnabled = true
                        }
                    }
                }else {
                    self.submitButton.backgroundColor = RGBColor(0xFFABBD)
                    self.submitButton.isUserInteractionEnabled = false
                }
            }
        }
}
