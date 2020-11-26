//
//  SearchFactoryName.swift
//  FKY
//
//  Created by airWen on 2017/5/5.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

class SearchFactoryName: NSObject {
    fileprivate var logic: HJLogic?
    static let shared = SearchFactoryName()
    var factoryList: [SerachFactorysInfoModel] = []//生产厂家原数据列表
    var rankList:[SerachRankInfoModel] = []//商品规格原数据列表
    override  init() {
        super.init()
        logic = HJLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? HJLogic
    }
    
    func getFactoryFliterList(_ params:[String: String]? ,callback:@escaping (_ factoryList: NSArray)->(), errorCallBack:@escaping ()->()) {
        var mTask: URLSessionDataTask? = URLSessionDataTask.init()
        let param: HJOperationParam = HJOperationParam.init(businessName: "api/search", methodName: "searchFactoryNames", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            if let err = error {
                // 失败
                callback(self.factoryList as NSArray)
                
                let e = err as NSError
                if e.code == 2 {
                    // token过期
                    FKYAppDelegate!.showToast("用户登录过期, 请手动重新登录")
                }
            }
            else {
                // 成功
                if let json =  responseObj as? NSDictionary {
                    self.factoryList.removeAll()
                    if  let prodArray = (json as AnyObject).value(forKeyPath: "factoryNames") as? NSArray {
                        let prods:[SerachFactorysInfoModel] = prodArray.mapToObjectArray(SerachFactorysInfoModel.self)!
                        prods.forEach({ (model) in
                            self.factoryList.append(model)
                        })
                    }
                }
                callback(self.factoryList as NSArray)
            }
        }
        mTask = self.logic?.operationManger.request(with: param)
    }
    //获取商品规格
    func getProductRanksList(_ params:[String: String]?,callback:@escaping (_ rankList: [SerachRankInfoModel]?,_ msg:String?)->()) {
        FKYRequestService.sharedInstance()?.getProductRankData(withParam: params, completionBlock: {[weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                var msg = error?.localizedDescription ?? "请求失败"
                if let err = error {
                    let e = err as NSError
                    // token过期
                    if e.code == 2 {
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                // 失败回调
                callback(nil, msg)
                return
            }
            
            // 成功
            if let json =  response as? NSDictionary {
                strongSelf.rankList.removeAll()
                if  let prodArray = (json as AnyObject).value(forKeyPath: "specs") as? NSArray {
                    let prods:[SerachRankInfoModel] = prodArray.mapToObjectArray(SerachRankInfoModel.self)!
                    prods.forEach({ (model) in
                        strongSelf.rankList.append(model)
                        callback(strongSelf.rankList,nil)
                    })
                }
            }
            
            
//            if let data = response as? NSDictionary,let specsArr = data["specs"] as? NSArray {
//                let rankArr :[SerachRankInfoModel] = specsArr.mapToObjectArray(SerachRankInfoModel.self)!
//                strongSelf.rankList = rankArr
//                callback(strongSelf.rankList,nil)
//            }
        })
    }
}
