//
//  AccountViewModel.swift
//  FKY
//
//  Created by 寒山 on 2020/6/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class AccountViewModel: NSObject {
    var userInfoModel:FKYUserInfoModel?//用户信息
    var accountInfoModel:AccountInfoModel?//账号信息
    @objc dynamic var isNotPerfectInformation:Bool = true //用户资料审核状态
    @objc dynamic var isShowEnterTreasury:Bool = false //判断是否展示一键入库蒙版
    //获取用户信息
    func getUserBaseInfo(_ block: @escaping (Bool,String)->()) {
        FKYRequestService.sharedInstance()?.requestForBaseInfo(withParam: nil, completionBlock: { [weak self] (isSuccess, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard isSuccess else {
                var msg = error?.localizedDescription ?? "获取失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                strongSelf.isNotPerfectInformation = false
                block(false,msg)
                return
            }
            // 请求成功
            if let json = response as? NSDictionary{
                // (非空)字典
                strongSelf.accountInfoModel = json.mapToObject(AccountInfoModel.self)
                let auditStatus = strongSelf.accountInfoModel?.enterpriseAuditStatus
                if let mobile = strongSelf.accountInfoModel?.mobile,mobile.isEmpty == false{
                    // 保存手机号
                    UserDefaults.standard.set(mobile, forKey: "user_mobile")
                    UserDefaults.standard.synchronize()
                }else{
                    UserDefaults.standard.set("", forKey: "user_mobile")
                    UserDefaults.standard.synchronize()
                }
                if ((-1 == auditStatus) || (11 == auditStatus) || (12 == auditStatus) || (13 == auditStatus) || (14 == auditStatus)) {
                    if UserDefaults.standard.value(forKey: "isHandelUserGuideMask") == nil {
                        UserDefaults.standard.set(false, forKey: "isHandelUserGuideMask")
                        UserDefaults.standard.synchronize()
                    }
                    strongSelf.isNotPerfectInformation = true
                }else{
                    strongSelf.isNotPerfectInformation = false
                }
                //判断是否展示一款入库的蒙版
                strongSelf.isShowEnterTreasury = false
                if UserDefaults.standard.value(forKey: "showEnterTreasury") == nil {
                    if let toolsArray = strongSelf.accountInfoModel?.tools,toolsArray.count >= 3{
                        if let stockModel:AccountToolsModel = toolsArray[2] as AccountToolsModel? ,(stockModel.toolId == "899089"||stockModel.title == "智能采购"){
                            UserDefaults.standard.set(false, forKey: "showEnterTreasury")
                            UserDefaults.standard.synchronize()
                            strongSelf.isShowEnterTreasury = true
                        }
                    }
                }
                GLCookieSyncManager.shared()?.updateAllCookies()
                block(true,"")
            }
            else {
                strongSelf.isNotPerfectInformation = false
                block(false,"")
            }
        })
        
    }
    //切换企业
    func requestForChangeUserAction(_ enterPriseName:String,_ index:Int,_ block: @escaping (Bool,String)->()) {
        // 当前登录账号...<不需要再进行切换操作>
        if index == 0{
            return
        }
        // 账号名称为空
        if  enterPriseName.isEmpty == true {
            return
        }
        let parameters = ["name": enterPriseName as Any] as [String : Any]
        FKYRequestService.sharedInstance()?.requestChangeUser(withParam: parameters, completionBlock: { [weak self] (isSuccess, error, response, model) in
            guard let _ = self else {
                return
            }
            // 请求失败
            guard isSuccess else {
                var msg = error?.localizedDescription ?? "切换企业失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false,msg)
                return
            }
            // 请求成功
            if let json = response as? NSDictionary{
                FKYAccountLaunchLogic.handleResponseData((json as! [AnyHashable : Any]) , forRequest: parameters, withFlag: true)
                block(true,"")
            }
            else {
                
                block(false,"")
            }
        })
    }
    //获取用户资质状态
    func requestForEnterpriseInfoFromErp(_ block: @escaping (Bool,String)->()) {
        if FKYLoginAPI.loginStatus() != .unlogin {
            FKYRequestService.sharedInstance()?.requestForEnterpriseInfoFromErp(withParam: nil, completionBlock: { [weak self] (isSuccess, error, response, model) in
                guard let _ = self else {
                    return
                }
                // 请求失败
                guard isSuccess else {
                    var msg = error?.localizedDescription ?? "获取失败"
                    if let err = error {
                        let e = err as NSError
                        if e.code == 2 {
                            // token过期
                            msg = "用户登录过期，请重新手动登录"
                        }
                    }
                    block(false,msg)
                    return
                }
                // 请求成功
                if let json = response as? NSDictionary{
                    // (非空)字典
                    if (json != NSNull()) && json.allKeys.isEmpty == false{
                        block(true,"")
                    }else {
                        block(false,"")
                    }
                    
                }
                else {
                    
                    block(false,"")
                }
            })
        }else{
            block(false,"未登录")
        }
    }
}

