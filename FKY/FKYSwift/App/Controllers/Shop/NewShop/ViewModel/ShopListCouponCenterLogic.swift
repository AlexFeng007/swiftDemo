//
//  ShopListCouponCenterLogic.swift
//  FKY
//
//  Created by 乔羽 on 2018/12/4.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

class ShopListCouponCenterLogic: HJLogic {
    
    func fetchCouponListData(withParams params: Dictionary<String, Any>, callback:@escaping (_ couponItems : NSArray?, _ message: String?)->()) {
        let param: HJOperationParam = HJOperationParam.init(businessName: "promotion/coupon", methodName: "getShopCouponByCustId", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            if let err = error {
                let e = err as NSError
                if e.code == 2 {
                    // token过期
                    callback(nil, "用户登录过期, 请手动重新登录")
                    return
                }
                callback(nil, error?.localizedDescription ?? CouponProvider.DEFAULT_NETWORK_ERRMSG)
            } else {
                
                if let data = responseObj as? NSDictionary, let list = data["data"] as? NSArray {
                    let items = list.mapToObjectArray(ShopListCouponModel.self)! as NSArray
                    callback(items, nil)
                } else {
                    callback(nil, nil)
                }
            }
        }
        self.operationManger.request(with: param)
    }
    
    func receiveCoupon(byTemplateCode templateCode: String, callback:@escaping (_ couponItem : CouponModel?, _ message: String?, _ status: Bool)->()) {
        let parameters = [ "template_code": templateCode ] as [String : Any]
        let param: HJOperationParam = HJOperationParam.init(businessName: "promotion/coupon", methodName: "couponReceiveByTemplateCode", versionNum: "", type: kRequestPost, param: parameters) { (responseObj, error) in
            if let err = error {
                let e = err as NSError
                if e.code == 2 {
                    // token过期
                    callback(nil, "用户登录过期, 请手动重新登录", false)
                    return
                }
                callback(nil, error?.localizedDescription ?? CouponProvider.DEFAULT_NETWORK_ERRMSG, false)
            } else {
                if let data = responseObj as? NSDictionary {
                    let item = data.mapToObject(CouponModel.self)
                    callback(item, "领取成功", true)
                } else {
                    callback(nil, CouponProvider.DEFAULT_NETWORK_ERRMSG, false)
                }
            }
        }
        self.operationManger!.request(with: param)
    }
}
