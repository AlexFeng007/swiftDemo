//
//  FKYAddressRequestService.swift
//  FKY
//
//  Created by 夏志勇 on 2018/8/30.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  地址数据相关网络请求类
//  wiki地址：http://wiki.yiyaowang.com/pages/viewpage.action?pageId=18785369
//  wiki地址：http://wiki.yiyaowang.com/pages/viewpage.action?pageId=18777090

import UIKit

class FKYAddressRequestService: NSObject {
    // adapter接口类
    fileprivate var logic: HJLogic = HJLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as! HJLogic
    
    override init() {
        super.init()
    }
    
    // 请求地址数据库db的更新数据
    func requestAddressDatabaseUpdateInfo(withParams params: Dictionary<String, Any>, completion: @escaping HJCompletionBlock) {
        var mTask: URLSessionDataTask? = URLSessionDataTask.init()
        let param: HJOperationParam = HJOperationParam.init(businessName: "tms/address", methodName: "getUpdatedAddress", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            if let err = error {
                // fail
                completion(nil, err)
            }
            else {
                // success
                if let data = responseObj as? NSDictionary {
                    // data
                    let model = data.mapToObject(FKYAddressUpdateModel.self)
                    completion(model, nil)
                }
                else {
                    // no data
                    completion(nil, nil)
                }
            }
        }
        mTask = logic.operationManger.request(with: param)
    }
    
    // 获取对应的省or市or区or镇列表数据...<根据上级code和level获取地址数据>
    func requestAddressList(withParams params: Dictionary<String, Any>, completion: @escaping HJCompletionBlock) {
        var mTask: URLSessionDataTask? = URLSessionDataTask.init()
        let param: HJOperationParam = HJOperationParam.init(businessName: "tms/address", methodName: "getAddressByParentCodeAndLevel", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            if let err = error {
                // fail
                completion(nil, err)
            }
            else {
                // success
                if let data = responseObj as? NSArray {
                    // data
                    let list = (data as NSArray).mapToObjectArray(FKYAddressUpdateItemModel.self)
                    completion(list, nil)
                }
                else {
                    // no data
                    completion(nil, nil)
                }
            }
        }
        mTask = logic.operationManger.request(with: param)
    }
}

// MARK: - 单独的接口来获取省...<不再使用>
extension FKYAddressRequestService {
    // 获取所有省列表数据...<根据地区级别获取地址数据>...<仅简单的用来获取省>
    func requestProvinceList(completion: @escaping HJCompletionBlock) {
        let params = ["levels": "1", "pageNum": 1, "pageSize": 100] as [String : Any]
        var mTask: URLSessionDataTask? = URLSessionDataTask.init()
        let param: HJOperationParam = HJOperationParam.init(businessName: "tms/address", methodName: "getAddressByLevels", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            if let err = error {
                // fail
                completion(nil, err)
            }
            else {
                // success
                if let data = responseObj as? NSDictionary {
                    // data
                    let model = data.mapToObject(FKYAddressUpdateModel.self)
                    completion(model, nil)
                }
                else {
                    // no data
                    completion(nil, nil)
                }
            }
        }
        mTask = logic.operationManger.request(with: param)
    }
}

// MARK: - 仅获取第四级的镇列表...<之前的方案，不再使用>
extension FKYAddressRequestService {
    // 获取镇列表数据
    func requestTownListByDistrictCode(withParams params: Dictionary<String, Any>, completion: @escaping HJCompletionBlock) {
        var mTask: URLSessionDataTask? = URLSessionDataTask.init()
        let param: HJOperationParam = HJOperationParam.init(businessName: "tms/address", methodName: "findTownsByCountyCode", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            if let err = error {
                // fail
                completion(nil, err)
            }
            else {
                // success
                if let data = responseObj as? NSDictionary, let items = data["resultList"] as? NSArray, items.count > 0 {
                    // data
                    completion(items, nil)
                }
                else {
                    // no data
                    completion([], nil)
                }
            }
        }
        mTask = logic.operationManger.request(with: param)
    }
}
