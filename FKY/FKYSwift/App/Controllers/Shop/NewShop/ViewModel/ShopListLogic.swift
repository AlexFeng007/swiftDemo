//
//  ShopListLogic.swift
//  FKY
//
//  Created by 乔羽 on 2018/12/10.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

class ShopListLogic: HJLogic {

    func fetchShopListTitleData(callback:@escaping (_ couponItems : Array<String>?, _ message: String?)->()) {
        var siteCodeStr = "000000"
        if FKYLoginAPI.loginStatus() != .unlogin {
            if let user: FKYUserInfoModel = FKYLoginAPI.currentUser(), let code = user.substationCode {
                if code.toNSNumber().intValue != 0 {
                    siteCodeStr = code
                }
            }
        }
        
        let dict = ["siteCode" : siteCodeStr]
        
        let param: HJOperationParam = HJOperationParam.init(businessName: "ycapp/shop", methodName: "homeTabNameList", versionNum: "", type: kRequestPost, param: dict) { (responseObj, error) in
            if let err = error {
                let e = err as NSError
                if e.code == 2 {
                    // token过期
                    callback(nil, "用户登录过期, 请手动重新登录")
                    return
                }
                callback(nil, error?.localizedDescription ?? CouponProvider.DEFAULT_NETWORK_ERRMSG)
            } else {
                if let data = responseObj as? NSDictionary {
                    var items: Array<String> = []
                    if let tab = data["tabName1"] as? String {
                        items.append(tab)
                    }
                    if let tab = data["tabName2"] as? String {
                        items.append(tab)
                    }
                    if let tab = data["tabName3"] as? String {
                        items.append(tab)
                    }
                    callback(items, nil)
                } else {
                    callback(nil, nil)
                }
            }
        }
        self.operationManger.request(with: param)
    }
    
}
