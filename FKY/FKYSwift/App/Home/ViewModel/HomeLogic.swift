//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

final class HomeLogic: HJLogic {
    //
    func fetchHomeTemplateData(withPage pageId: Int, _ callback: @escaping (_ templates: NSArray?, _ pageId: Int, _ pageSize: Int, _ message: String?)->()) {
        let userid = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserId()
        let enterpriseid = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        let siteCodeStr = (FKYLocationService().currentLoaction.substationCode ?? "000000")
        let parameters = ["userid": userid ?? "", "siteCode": siteCodeStr, "pageId": pageId, "enterpriseId": enterpriseid as Any ] as [String : Any]
        fetchHomeData(withParams: parameters) { (responseObj, error) in
            // 仅缓存第1页数据
            if pageId == 1, responseObj != nil, let res = responseObj as? NSDictionary {
                WUCache.cacheObject(res, toFile: HomeString.HOME_TEMPLATES_CACHE_FILENAME)
            }
            
            // 请求失败时，提示语后面新增错误码
            //var tip = error?.localizedDescription ?? "网络连接失败"
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
                //callback(nil, 1, 1, error?.localizedDescription ?? "网络连接失败")
                callback(nil, 1, 1, tip)
                // <听云>自定义Event
                NBSAppAgent.trackEvent("首页数据请求失败")
                return
            }
            
            if data["templates"] != nil {
                // 有数据
                let pageId = data["pageId"] as! Int
                let pageSize = data["pageSize"] as! Int
                let datas = data["templates"] as! NSArray
                let items = datas.mapToObjectArray(HomeTemplateModel.self)! as NSArray
                callback(items, pageId, pageSize, nil)
            }
            else {
                // 无数据
                //callback(nil, pageId, pageSize, error?.localizedDescription ?? "网络连接失败")
                callback(nil, 1, 1, tip)
                // <听云>自定义Event
                NBSAppAgent.trackEvent("首页数据请求失败")
            }
        }
    }
    //
    func fetchHomeTemplateCacheData(_ callback: @escaping (_ templates: NSArray?, _ pageId: Int, _ pageSize: Int)->()) {
        guard let data = WUCache.getCachedObject(forFile: HomeString.HOME_TEMPLATES_CACHE_FILENAME) as? NSDictionary else {
            callback(nil, 1, -1)
            return
        }
        if data["templates"] != nil && data["pageId"] != nil && data["pageSize"] != nil {
            let pageId = data["pageId"] as! Int
            let pageSize = data["pageSize"] as! Int
            let datas = data["templates"] as! NSArray
            let items = datas.mapToObjectArray(HomeTemplateModel.self)! as NSArray
            callback(items, pageId, pageSize)
        } else {
            callback(nil, 1, -1)
        }
    }
}

// MARK - private
extension HomeLogic {
    func fetchHomeData(withParams params: Dictionary<String, Any>, completion: @escaping HJCompletionBlock) {
        let entity: YWSpeedUpNetworkEntity = YWSpeedUpNetworkEntity.init()
        entity.requestStartTime = YWSpeedUpManager.currentMillisecond()
        var mTask: URLSessionDataTask? = URLSessionDataTask.init()
        let param: HJOperationParam = HJOperationParam.init(businessName: "mobile/home", methodName: "newTemplate", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            entity.config(with: mTask);
            YWSpeedUpManager.sharedInstance().add(entity, endAndUpdateWith: ModuleType.fkyHome)
            if let err = error {
                // 请求失败
                let e = err as NSError
                if e.code == 2 {
                    // token过期
                    
                    // 记录退出登录时的相关信息，并上传服务器
//                    var userid: NSString? = (FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserId() as NSString?)
//                    if let uid = userid, uid.length > 0 {
//                        //
//                    }
//                    else {
//                        userid = ""
//                    }
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
                    var url: NSString? = HJOperationParam.getRequestUrl("mobile/home", methodName: "template", versionNum: "") as NSString?
                    if let url_ = url, url_.length > 0 {
                        //
                    }
                    else {
                        url = "mobile/home/template"
                    }
//                    let method = "mobile/home/template"
//                    let note = "请求首页数据时token超时退出登录"
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
                        self.fetchHomeData(withParams: parameters, completion: completion)
                    }, failure: { (reason) in
                        //
                    })
                    
                    // 加Alert来定位自动退出登录的bug
//                    let infoString = "[请求接口(mobile/home/template)时返回token过期，从而强制退出登录。]"
//                    let dataString = params.description
//                    let finalString = infoString + "\n接口名：\nmobile/home/template" + "\n入参：\n" + dataString
//                    NotificationCenter.default.post(name:NSNotification.Name(rawValue: FKYLogoutForRequestFail), object:self, userInfo:["msg":finalString])
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
        mTask = self.operationManger.request(with: param)
    }
    
    // 获取开屏广告
    func getAdvertisementData(completion: @escaping HJCompletionBlock) {
        var mTask: URLSessionDataTask? = URLSessionDataTask.init()
        let userid = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserId()
        let enterpriseid = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        var siteCodeStr = "000000"
        if FKYLoginAPI.loginStatus() != .unlogin {
            if let user: FKYUserInfoModel = FKYLoginAPI.currentUser(), let code: String = user.substationCode {
                if code.toNSNumber() != 0 {
                    siteCodeStr = code
                }
            }
        }
        let parameters = ["userid": userid ?? "", "siteCode": siteCodeStr, "enterpriseId": enterpriseid ?? ""] as [String : Any]
        let param: HJOperationParam = HJOperationParam.init(businessName: "mobile/home", methodName: "advertisement", versionNum: "", type: kRequestPost, param: parameters) { (responseObj, error) in
            if let data = responseObj as? NSDictionary, data["templates"] != nil {
                // 成功
                let templates = data["templates"] as! NSArray
                if templates.count > 0, let templateDic = templates[0] as? NSDictionary, let contents = templateDic["contents"] as? NSDictionary, let openingAd = contents["openingAd"] as? NSArray, openingAd.count > 0 {
                    completion(openingAd[0], error)
                }
            }
            else {
                // 失败
                completion(responseObj, error)
            }
        }
        mTask = self.operationManger.request(with: param)
    }
}
