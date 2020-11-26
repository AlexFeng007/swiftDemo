//
//  FKYFilterSearchServicesModel.swift
//  FKY
//
//  Created by 寒山 on 2018/7/12.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYFilterSearchServicesModel : NSObject {
    static let shared = FKYFilterSearchServicesModel()
    fileprivate var logic: HJLogic?
    var sellerList: [SerachSellersInfoModel] = []//全部商家
    var sellerSelfList : [SerachSellersInfoModel] = []//自营商家
    var sellerBuyList : [SerachSellersInfoModel] = []//常买商家
    var sellerFavList : [SerachSellersInfoModel] = []//收藏商家
    var sellerSelectedList: [SerachSellersInfoModel] = []//被选中商家
    
    override init() {
        super.init()
        logic = HJLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? HJLogic
    }
    
    func getSellerFliterList(_ params: [String: AnyObject]?) {
        var mTask: URLSessionDataTask? = URLSessionDataTask.init()
        let param: HJOperationParam = HJOperationParam.init(businessName: "api/search", methodName: "searchSellerNames", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
            if error != nil {
                // 失败
                self.sellerList.removeAll()
                
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        FKYAppDelegate!.showToast("用户登录过期, 请手动重新登录")
                    }
                }
            }
            else {
                // 成功
                if let json = responseObj as? NSDictionary {
                    //全部商家
                    self.sellerList.removeAll()
                    if let prodArray = (json as AnyObject).value(forKeyPath: "sellerNames") as? NSArray {
                        let prods:[SerachSellersInfoModel] = prodArray.mapToObjectArray(SerachSellersInfoModel.self)!
                        prods.forEach({ (model) in
                            self.sellerList.append(model)
                        })
                    }
                    //自营商家
                    self.sellerSelfList.removeAll()
                    if let prodArray = (json as AnyObject).value(forKeyPath: "sellerNamesSelf") as? NSArray ,prodArray.count > 0 {
                        let prods:[SerachSellersInfoModel] = prodArray.mapToObjectArray(SerachSellersInfoModel.self)!
                        prods.forEach({ (model) in
                            self.sellerSelfList.append(model)
                        })
                    }
                    //常买商家
                    self.sellerBuyList.removeAll()
                    if let prodArray = (json as AnyObject).value(forKeyPath: "sellerNamesBuy") as? NSArray ,prodArray.count > 0 {
                        let prods:[SerachSellersInfoModel] = prodArray.mapToObjectArray(SerachSellersInfoModel.self)!
                        prods.forEach({ (model) in
                            self.sellerBuyList.append(model)
                        })
                    }
                    //收藏商家
                    self.sellerFavList.removeAll()
                    if let prodArray = (json as AnyObject).value(forKeyPath: "sellerNamesFav") as? NSArray ,prodArray.count > 0 {
                        let prods:[SerachSellersInfoModel] = prodArray.mapToObjectArray(SerachSellersInfoModel.self)!
                        prods.forEach({ (model) in
                            self.sellerFavList.append(model)
                        })
                    }
                    //
                    let dataArr = self.sellerList + self.sellerSelfList +  self.sellerBuyList + self.sellerFavList
                    if self.sellerSelectedList.count > 0 {
                        var currentArr = [SerachSellersInfoModel]()
                        for selectNode in self.sellerSelectedList {
                            for node in dataArr {
                                if selectNode.sellerCode == node.sellerCode {
                                    currentArr.append(selectNode)
                                    break;
                                }
                            }
                        }
                        self.sellerSelectedList = currentArr
                    }
                }
            }
        }
        mTask = self.logic?.operationManger.request(with: param)
    }
}
