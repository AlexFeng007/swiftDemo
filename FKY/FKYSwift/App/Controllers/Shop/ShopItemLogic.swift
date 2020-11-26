//
//  ShopItemLogic.swift
//  FKY
//
//  Created by 乔羽 on 2018/4/24.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  店铺详情页网络请求

import UIKit

final class ShopItemLogic: HJLogic {
    var tokenOverTimeBlock: (()->())?
    
    //店铺头部信息
    func fetchShopHeaderNewDetailData(enterpriseid: String, callback: @escaping (_ model: ShopItemModel?, _ message: String?)->()) {
        let parameters = ["enterprise_id":enterpriseid]
        fetchShopData(method: "shopIndex", withParams: parameters) { (responseObj, error) in
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
                guard let data = responseObj as? Dictionary<String,AnyObject> else {
                    callback(nil, "请求失败")
                    return
                }
                let model = ShopItemModel.fromJSON(data)
                callback(model, nil)
            }
        }
    }
    
    //店铺企业信息
    func fetchShopNewDetailData(enterpriseid: String, callback: @escaping (_ model: ShopDetailModel?, _ message: String?)->()) {
        let parameters = ["enterprise_id":enterpriseid]
        fetchShopData(method: "shopDetail", withParams: parameters) { (responseObj, error) in
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
                guard let data = responseObj as? Dictionary<String,AnyObject> else {
                    callback(nil, "请求失败")
                    return
                }
                let model = ShopDetailModel.fromJSON(data)
                callback(model, nil)
                
            }
        }
    }
    
    //店铺首页相关信息
    func fetchShopFloorInfoDetailData(enterpriseid: String, callback: @escaping (_ model: ShopItemModel?, _ message: String?)->()) {
        let parameters = ["enterprise_id":enterpriseid]
        fetchShopData(method: "shopFloorInfo", withParams: parameters) { (responseObj, error) in
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
                guard let data = responseObj as? Dictionary<String,AnyObject> else {
                    callback(nil, "请求失败")
                    return
                }
                let model = ShopItemModel.fromJSON(data)
                callback(model, nil)
            }
        }
    }
    
    // 获取首页及企业信息
    func fetchShopDetailData(enterpriseid: String, callback: @escaping (_ model: ShopItemModel?, _ message: String?)->()) {
        let parameters = ["enterprise_id":enterpriseid]
        fetchShopData(method: "shopNew", withParams: parameters) { (responseObj, error) in
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
                guard let data = responseObj as? Dictionary<String,AnyObject> else {
                    callback(nil, "请求失败")
                    return
                }
                let model = ShopItemModel.fromJSON(data)
                if model.shopDetail != nil {
                    callback(model, nil)
                }
                else {
                    callback(nil, "请求失败")
                }
            }
        }
    }
    
    // 获取全部商品信息
    func fetchShopAllProductData(enterpriseid: String, page: String?, size: String?, keyword: String?, priceSeq: String, salesVolume: String, callback: @escaping (_ model: ShopAllProductModel?, _ message: String?)->()) {
        let parameters = [
            "enterprise_id":enterpriseid,
            "page":page ?? "",
            "size":size ?? "",
            "keyword": keyword ?? "",
            "price_seq": priceSeq,
            "sales_volume": salesVolume
        ]
        
        fetchShopData(method: "shopProduct", withParams: parameters) { (responseObj, error) in
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
                guard let data = responseObj as? Dictionary<String,AnyObject> else {
                    callback(nil, "请求失败")
                    return
                }
                
                let model = ShopAllProductModel.fromJSON(data)
                callback(model, nil)
            }
        }
    }
}

extension ShopItemLogic {
    func fetchShopData(method: String, withParams params: Dictionary<String, Any>, completion: @escaping HJCompletionBlock) {
        let param: HJOperationParam = HJOperationParam.init(businessName: "druggmp/index", methodName: method, versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            completion(responseObj, error)
        }
        self.operationManger.request(with: param)
    }
}
