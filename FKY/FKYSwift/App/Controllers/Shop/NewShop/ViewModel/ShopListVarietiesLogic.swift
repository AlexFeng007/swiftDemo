//
//  ShopListVarietiesLogic.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/27.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

extension HJLogic {
    func fetchAddShoppingProduct(_ params: Dictionary<String, Any>, callback: @escaping (_ model: [String:AnyObject]?, _ message: String?)->()) {
        fetchShopCartData(method: "add", withParams: params) { (responseObj, error) in
            if let err = error {
                // 失败
                var errMsg = error?.localizedDescription ?? "网络连接失败"
                let e = err as NSError
                if e.code == 2 {
                    // token过期
                    errMsg = "用户登录过期, 请手动重新登录"
                }
                callback(nil, errMsg)
            }
            else {
                // 成功
                guard let model = responseObj as? [String : AnyObject] else {
                    callback(nil, "请求失败")
                    return
                }
                callback(model, nil)
            }
        }
    }
    
    func fetchShopCartData(method: String, withParams params: Dictionary<String, Any>, completion: @escaping HJCompletionBlock) {
        let param: HJOperationParam = HJOperationParam.init(businessName: "api/cart", methodName: method, versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            completion(responseObj, error)
        }
        self.operationManger.request(with: param)
    }
}

class ShopListVarietiesLogic: HJLogic {
    func fetchShopListTemplateData(withPage pageId: Int, _ callback: @escaping (_ templates: NSArray?, _ pageId: Int, _ pageSize: Int, _ message: String?)->()) {
        let userid = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserId()
        let enterpriseid = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        let siteCodeStr = (FKYLocationService().currentLoaction.substationCode ?? "000000")
        let parameters = ["userid": userid ?? "", "siteCode": siteCodeStr, "pageId": pageId, "enterpriseId": enterpriseid as Any ] as [String : Any]
        
        fetchShopListData(withParams: parameters) { (responseObj, error) in
            // 仅缓存第1页数据
            if pageId == 1, responseObj != nil, let res = responseObj as? NSDictionary {
                WUCache.cacheObject(res, toFile: ShopListString.SHOPLIST_TEMPLATES_CACHE_FILENAME)
            }
            
            // 请求失败时，提示语后面新增错误码
            var tip = "网络连接失败" // 首页提示语写死
            if let err = error {
                let e = err as NSError
                let code: NSString? = e.userInfo[HJErrorCodeKey] as? NSString
                if code != nil {
                    tip = tip + " (" + (code! as String) + ")"
                }
                else {
                    tip = tip + " (-1)"
                }
            }
            else {
                tip = tip + " (-1)"
            }
            
            if let err = error {
                let e = err as NSError
                if e.code == 2 {
                    // token过期
                    tip = "用户登录过期, 请手动重新登录"
                }
            }
            
            guard let data = responseObj as? NSDictionary else {
                callback(nil, 1, 1, tip)
                // <听云>自定义Event
                // NBSAppAgent.trackEvent("首页数据请求失败")
                return
            }
            
            if data["templates"] != nil {
                // 有数据
                let pageId = data["pageId"] as! Int
                let pageSize = data["pageSize"] as! Int
                let datas = data["templates"] as! NSArray
                let items = datas.mapToObjectArray(ShopListTemplateModel.self)! as NSArray
                callback(items, pageId, pageSize, nil)
            }
            else {
                // 无数据
                callback(nil, 1, 1, tip)
                // <听云>自定义Event
                // NBSAppAgent.trackEvent("首页数据请求失败")
            }
        }
    }
    
    //
    func fetchShopListTemplateCacheData(_ callback: @escaping (_ templates: NSArray?, _ pageId: Int, _ pageSize: Int)->()) {
        guard let data = WUCache.getCachedObject(forFile: ShopListString.SHOPLIST_TEMPLATES_CACHE_FILENAME) as? NSDictionary else {
            callback(nil, 1, -1)
            return
        }
        if data["templates"] != nil && data["pageId"] != nil && data["pageSize"] != nil {
            let pageId = data["pageId"] as! Int
            let pageSize = data["pageSize"] as! Int
            let datas = data["templates"] as! NSArray
            let items = datas.mapToObjectArray(ShopListTemplateModel.self)! as NSArray
            callback(items, pageId, pageSize)
        } else {
            callback(nil, 1, -1)
        }
    }
}

extension ShopListVarietiesLogic {
    func fetchShopListData(withParams params: Dictionary<String, Any>, completion: @escaping HJCompletionBlock) {
        let param: HJOperationParam = HJOperationParam.init(businessName: "home/mpHome", methodName: "varieties", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            if let err = error {
                // 请求失败
                let e = err as NSError
                if e.code == 2 {
                    // token过期
                    var gltoken: NSString? = HJGlobalValue.sharedInstance().token as NSString?
                    if let token = gltoken, token.length > 0 {
                        //
                    }
                    else {
                        gltoken = ""
                    }
                    var yctoken: NSString? = UserDefaults.standard.value(forKey: "user_token") as? NSString
                    if let token = yctoken, token.length > 0 {
                        //
                    }
                    else {
                        yctoken = ""
                    }
                    var param: NSString? = NSDictionary.init(dictionary: params).jsonString() as NSString?
                    if let pa = param, pa.length > 0 {
                        //
                    }
                    else {
                        param = ""
                    }
                    var url: NSString? = HJOperationParam.getRequestUrl("home/mpHome", methodName: "varieties", versionNum: "") as NSString?
                    if let url_ = url, url_.length > 0 {
                        //
                    }
                    else {
                        url = "home/mpHome/varieties"
                    }
                    let dicInfo: [NSString: Any] = ["gltoken":gltoken!, "yctoken":(yctoken ?? ""), "params":param!, "url":url!, "system":"ios"]
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue: FKYLogoutForRequestFail), object:self, userInfo:dicInfo)
                    
                    // token过期，退出登录
                    FKYLoginAPI.logoutSuccess({ (mutiplyPage) in
                        // 退出登录成功，重新请求数据
                        let userid = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserId()
                        let enterpriseid = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
                        let siteCodeStr = (FKYLocationService().currentLoaction.substationCode ?? "000000")
                        let parameters = ["userid": userid ?? "", "siteCode": siteCodeStr, "pageId": 1, "enterpriseId": enterpriseid as Any ] as [String : Any]
                        // 退出登录后，重新请求数据
                        self.fetchShopListData(withParams: parameters, completion: completion)
                    }, failure: { (reason) in
                        //
                    })
                }
                else {
                    // 其它原因
                    completion(responseObj, error)
                }
            }
            else {
                // 请求成功
                completion(responseObj, error)
            }
        }
        self.operationManger.request(with: param)
    }
}
