//
//  HotSaleLogic.swift
//  FKY
//
//  Created by Rabe on 27/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  本周热搜、区域热销之数据请求类

import Foundation
import SwiftyJSON

final class HotSaleProvider: NSObject {
    // 获取类目列表数据
    func fetchHotSaleHeaderData(withType type: HotSaleType, _ callback: @escaping (_ items: NSArray?, _ message: String?)->()) {
        let siteCodeStr = (FKYLocationService().currentLoaction.substationCode ?? "000000")
        let parameters = ["siteCode": siteCodeStr as Any,
                          "type": type.rawValue] as [String : Any]
        let logic: HotSaleLogic = HotSaleLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as! HotSaleLogic
        logic.fetchHotSaleHeaderData(withParams: parameters) { (responseObj, error) in
            guard let data = responseObj as? NSArray else {
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        callback(nil, "用户登录过期, 请手动重新登录")
                        return
                    }
                }
                callback(nil, error?.localizedDescription ?? "网络连接失败")
                return
            }
            let items = data.mapToObjectArray(HotSaleHeaderModel.self)! as NSArray
            callback(items, nil)
        }
    }
    
    // 获取指定类目下的商品列表...<本周热搜>
    func fetchWeekHotSaleListData(withCatgoryCode catgoryCode: String?, _ callback: @escaping (_ items: NSArray?, _ message: String?)->()) {
        let userid = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserId()
        let siteCodeStr = (FKYLocationService().currentLoaction.substationCode ?? "000000")
        let parameters = ["siteCode": siteCodeStr,
                          "catgoryCode": catgoryCode ?? "",
                          "userid": userid ?? ""] as [String : Any]
        let logic: HotSaleLogic = HotSaleLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as! HotSaleLogic
        logic.fetchWeekHotSaleListData(withParams: parameters) { (responseObj, error) in
            guard let data = responseObj as? NSArray else {
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        callback(nil, "用户登录过期, 请手动重新登录")
                        return
                    }
                }
                callback(nil, error?.localizedDescription ?? "网络连接失败")
                return
            }
            let items = data.mapToObjectArray(HotSaleModel.self)! as NSArray
            callback(items, nil)
        }
    }
    
    // 获取指定类目下的商品列表...<区域热销>
    func fetchAreaHotSaleListData(withCatgoryCode catgoryCode: String?, _ callback: @escaping (_ items: NSArray?, _ message: String?)->()) {
        let userid = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserId()
        let siteCodeStr = (FKYLocationService().currentLoaction.substationCode ?? "000000")
        let parameters = ["siteCode": siteCodeStr,
                          "catgoryCode": catgoryCode ?? "",
                          "userid": userid ?? ""] as [String : Any]
        let logic: HotSaleLogic = HotSaleLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as! HotSaleLogic
        logic.fetchAreaHotSaleListData(withParams: parameters) { (responseObj, error) in
            guard let data = responseObj as? NSArray else {
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        callback(nil, "用户登录过期, 请手动重新登录")
                        return
                    }
                }
                callback(nil, error?.localizedDescription ?? "网络连接失败")
                return
            }
            let items = data.mapToObjectArray(HotSaleModel.self)! as NSArray
            callback(items, nil)
        }
    }
}

class HotSaleLogic: HJLogic {
    // 获取类目列表数据
    func fetchHotSaleHeaderData(withParams params: Dictionary<String, Any>, completion: @escaping HJCompletionBlock) {
        let param: HJOperationParam = HJOperationParam.init(businessName: "mobile", methodName: "getCategory", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            completion(responseObj, error)
        }
        self.operationManger.request(with: param)
    }
    
    // 获取指定类目下的商品列表...<本周热搜>
    func fetchWeekHotSaleListData(withParams params: Dictionary<String, Any>, completion: @escaping HJCompletionBlock) {
        let param: HJOperationParam = HJOperationParam.init(businessName: "mobile", methodName: "weekHotRank", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            completion(responseObj, error)
        }
        self.operationManger.request(with: param)
    }
    
    // 获取指定类目下的商品列表...<区域热销>
    func fetchAreaHotSaleListData(withParams params: Dictionary<String, Any>, completion: @escaping HJCompletionBlock) {
        let param: HJOperationParam = HJOperationParam.init(businessName: "mobile", methodName: "areaHotRank", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            completion(responseObj, error)
        }
        self.operationManger.request(with: param)
    }
}
