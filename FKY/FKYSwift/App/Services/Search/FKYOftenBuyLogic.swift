//
//  FKYOftenBuyLogic.swift
//  FKY
//
//  Created by 乔羽 on 2018/8/27.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYOftenBuyLogic: HJLogic {
    // 热销榜
    func fetchCityHotSaleViewData(withParams params: Dictionary<String, Any>, completion: @escaping HJCompletionBlock) {
        let param: HJOperationParam = HJOperationParam.init(businessName: "home/recommend", methodName: "cityHotSale", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            
            if let err = error {
                let e = err as NSError
                completion(responseObj, e)
            } else {
                completion(responseObj, error)
            }
        }
        self.operationManger.request(with: param)
    }
    
    // 常买列表
    func fetchFrequentlyBuyData(withParams params: Dictionary<String, Any>, completion: @escaping HJCompletionBlock) {
        let param: HJOperationParam = HJOperationParam.init(businessName: "home/recommend", methodName: "frequentlyBuy", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            
            if let err = error {
                let e = err as NSError
                completion(responseObj, e)
            } else {
                completion(responseObj, error)
            }
        }
        self.operationManger.request(with: param)
    }
    
    // 常看列表
    func fetchFrequentlyViewData(withParams params: Dictionary<String, Any>, completion: @escaping HJCompletionBlock) {
        let param: HJOperationParam = HJOperationParam.init(businessName: "home/recommend", methodName: "frequentlyView", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            
            if let err = error {
                let e = err as NSError
                completion(responseObj, e)
            } else {
                completion(responseObj, error)
            }
        }
        self.operationManger.request(with: param)
    }
}
