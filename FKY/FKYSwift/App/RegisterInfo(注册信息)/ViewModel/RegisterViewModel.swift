//
//  RegisterViewModel.swift
//  FKY
//
//  Created by 夏志勇 on 2019/7/31.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  注册/登录viewmodel

import UIKit

class RegisterViewModel: NSObject {
    // MARK: - Property
    
    // 图形验证码model
    var imgCodeModel: FKYAccountPicCodeModel?
}


// MARK: - Request

extension RegisterViewModel {
    //校验用户名是否存在
    func requestForValidateUserName(_ params: Dictionary<String, Any>?,_ block: @escaping (Bool, String?,String?)->()){
        FKYRequestService.sharedInstance()?.requestForValidateUserName(withParam: params, completionBlock: { [weak self] (isSuccess, error, response, model) in
            guard let _ = self else {
                return
            }
            // 请求失败
            guard isSuccess else {
                let msg = error?.localizedDescription ?? "验证失败"
                block(false, msg,nil)
                return
            }
            // 请求成功
            if let typeStr = response as? String{
                block(true, nil,typeStr)
            }else{
                block(false, "验证失败",nil)
            }
            
        })
    }
    // 获取图形验证码
    func requestForImageCode(_ block: @escaping (Bool, String?, FKYAccountPicCodeModel?)->()) {
        FKYRequestService.sharedInstance()?.requestForGetImageCode(withParam: nil, completionBlock: { [weak self] (isSuccess, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard isSuccess else {
                var msg = "请求图形验证码失败"
                if let txt = error?.localizedDescription, txt.isEmpty == false {
                    msg = txt
                }
                block(false, msg, nil)
                return
            }
            // 请求成功
            if let obj = model, obj is FKYAccountPicCodeModel {
                // 数据ok
                let code: FKYAccountPicCodeModel = obj as! FKYAccountPicCodeModel
                strongSelf.imgCodeModel = code // 保存
                block(true, nil, code)
            }
            else {
                // error
                block(false, "请求图形验证码失败", nil)
            }
        })
    }
    
    // 获取短信验证码
    func requestForMessageCode(_ params: Dictionary<String, Any>? , _ block: @escaping (Bool, String?)->()) {
        FKYRequestService.sharedInstance()?.requestForGetRegisterMessageCode(withParam: params, completionBlock: { (isSuccess, error, response, model) in
            // 请求失败
            guard isSuccess else {
                print("获取短信验证码失败")
                var msg = "请求短信验证码失败"
                if let txt = error?.localizedDescription, txt.isEmpty == false {
                    msg = txt
                }
                block(false, msg)
                return
            }
            // 请求成功
            block(true, nil)
        })
    }
    
    // 注册
    func requestForRegister(_ params: Dictionary<String, Any>? , _ block: @escaping (Bool, String?)->()) {
        FKYRequestService.sharedInstance()?.requestForRegister(withParam: params, completionBlock: { (isSuccess, error, response, model) in
            // 请求失败
            guard isSuccess else {
                print("注册失败")
                var msg = "注册失败"
                if let txt = error?.localizedDescription, txt.isEmpty == false {
                    msg = txt
                }
                block(false, msg)
                return
            }
            // 请求成功
            if let dic = response, dic is Dictionary<AnyHashable, Any> {
                FKYAccountLaunchLogic.handleResponseData(dic as? [AnyHashable : Any], forRequest: params, withFlag: false)
            }
            block(true, nil)
        })
    }
    
    // 登录
    func requestForLogin(_ params: Dictionary<String, Any>? , _ block: @escaping (Bool, String?, Bool)->()) {
        FKYRequestService.sharedInstance()?.requestForLogin(withParam: params, completionBlock: { (isSuccess, error, response, model) in
            // 请求失败
            guard isSuccess else {
                print("登录失败")
                var msg = "登录失败"
                if let txt = error?.localizedDescription, txt.isEmpty == false {
                    msg = txt
                }
                var showImgCode = false // 默认不显示图形验证码
                if let errMsg: String = error?._userInfo?[HJErrorCodeKey] as? String, errMsg == "001111000123" {
                    // 用户登录错误次数达到限制，需显示验证码输入框
                    showImgCode = true
                }
                //                if let err = error {
                //                    let e = err as NSError
                //                    // 接口返回不同的错误码，需进行不同的处理
                //                    if let rtncode = e.userInfo[HJErrorCodeKey] as? NSString, rtncode == "001111000123" {
                //                        // 用户登录错误次数达到限制，需显示验证码输入框
                //                        showImgCode = true
                //                    }
                //                }
                block(false, msg, showImgCode)
                return
            }
            // 请求成功
            if let dic = response, dic is Dictionary<AnyHashable, Any> {
                FKYAccountLaunchLogic.handleResponseData(dic as? [AnyHashable : Any], forRequest: params, withFlag: false)
            }
            block(true, nil, false)
        })
    }
    
    // 登录使用验证码
    func requestForLoginBySmsCode(_ params: Dictionary<String, Any>? , _ block: @escaping (Bool, String?)->()) {
        FKYRequestService.sharedInstance()?.requestForLoginBySMS(withParam: params, completionBlock: { (isSuccess, error, response, model) in
            // 请求失败
            guard isSuccess else {
                print("登录失败")
                var msg = "登录失败"
                if let txt = error?.localizedDescription, txt.isEmpty == false {
                    msg = txt
                }
                block(false, msg)
                return
            }
            // 请求成功
            if let dic = response, dic is Dictionary<AnyHashable, Any> {
                FKYAccountLaunchLogic.handleResponseData(dic as? [AnyHashable : Any], forRequest: params, withFlag: false)
            }
            block(true, nil)
        })
    }
    
    // 获取登录短信验证码
    func requestForMessageCodeForLogin(_ params: Dictionary<String, Any>? , _ block: @escaping (Bool, String?)->()) {
        FKYRequestService.sharedInstance()?.requestForGetLoginSMSCodeData(withParam: params, completionBlock: { (isSuccess, error, response, model) in
            // 请求失败
            guard isSuccess else {
                print("获取短信验证码失败")
                var msg = "请求短信验证码失败"
                if let txt = error?.localizedDescription, txt.isEmpty == false {
                    msg = txt
                }
                block(false, msg)
                return
            }
            // 请求成功
            block(true, nil)
        })
    }
    
    // 请求是否有注册送券活动
    func requestForCouponActivity(_ block: @escaping (Bool)->()) {
        FKYRequestService.sharedInstance()?.requestForRegisterCoupon(withParam: nil, completionBlock: { (isSuccess, error, response, model) in
            // 请求失败
            guard isSuccess else {
                block(false)
                return
            }
            // 请求成功 {"data":1}
            var showFlag = false // 默认无活动
            if let data = response as? Int {
                showFlag = (data == 1 ? true : false)
            }
            block(showFlag)
        })
    }
    
    // 注册校验bd号码
    func requestVerifyBdPhoneForRegister(_ params: Dictionary<String, Any>? , _ block: @escaping (Bool, String?)->()) {
        FKYRequestService.sharedInstance()?.requestForValidateBdMobile(withParam: params, completionBlock: { (isSuccess, error, response, model) in
            // 请求失败
            guard isSuccess else {
                print("校验失败")
                var msg = "校验失败"
                if let txt = error?.localizedDescription, txt.isEmpty == false {
                    msg = txt
                }
                block(false, msg)
                return
            }
            // 请求成功
            if let data = response as? NSDictionary {
                // 获取在线支付方式成功
                if let data = data["data"] as? Bool, data == true {
                    block(false, "注册手机号不可为业务员手机号，请更换手机号")
                    return
                }
            }
            block(true, nil)
        })
    }
}
