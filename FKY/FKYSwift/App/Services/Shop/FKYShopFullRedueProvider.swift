//
//  FKYShopFullRedueProvider.swift
//  FKY
//
//  Created by hui on 2018/11/29.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopFullRedueProvider: NSObject {
    var pageId = 1 //当前页码
    var pageSize = 1 //总页码
    
    fileprivate lazy var publicService: FKYPublicNetRequestSevice? = {
        return FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice
    }()
    // 请求mp的满减，特价
    func getFullCutOrBargainPromotionProductList(_ type:Int?,_ requestType:Int?,callback: @escaping (_ model: [FKYFullProductModel]?, _ message: String?)->()) {
        var parameters : [String:Any] = [:]
        if requestType == 1 {
            //刷新
            self.pageId = 1
            parameters["page"] = "\(self.pageId)"
        }else {
            //加载更多
            if self.hasNext() == false {
                return
            }
            self.pageId = self.pageId + 1
            parameters["page"] = "\(self.pageId)"
        }
        parameters["pageSize"] = "10"
        if type == 2 {
            //请求满减
            self.publicService?.getFullCutPromotionProductListInfoBlock(withParam: parameters, completionBlock: { (responseObj, error) in
                guard let data = responseObj as? Dictionary<String,AnyObject> else {
                    
                    if type == 2 {
                        //加载更多
                        self.pageId = self.pageId - 1
                    }
                    callback(nil,error?.localizedDescription ?? "网络连接失败")
                    return
                }
            
                if let paginatorDic = data["paginator"] as? NSDictionary {
                     self.pageSize = paginatorDic["totalPages"] as! Int
                }
                var dataArr : [FKYFullProductModel] = []
                if let getArr = data["data"] as? NSArray ,let arr = getArr.mapToObjectArray(FKYFullProductModel.self), arr.count > 0  {
                    dataArr = arr
                }
                callback(dataArr,nil)
            })
        }else {
            //请求特价
            self.publicService?.getBargainPromotionProductListInfoBlock(withParam: parameters, completionBlock: { (responseObj, error) in
                guard let data = responseObj as? Dictionary<String,AnyObject> else {
                    if type == 2 {
                        //加载更多
                        self.pageId = self.pageId - 1
                    }
                    callback(nil,error?.localizedDescription ?? "网络连接失败")
                    return
                }
                if let paginatorDic = data["paginator"] as? NSDictionary {
                    self.pageSize = paginatorDic["totalPages"] as! Int
                }
                var dataArr : [FKYFullProductModel] = []
                if let getArr = data["data"] as? NSArray ,let arr = getArr.mapToObjectArray(FKYFullProductModel.self), arr.count > 0  {
                    dataArr = arr
                }
                callback(dataArr,nil)
            })
        }
    }
    func hasNext() -> Bool {
        return self.pageSize > self.pageId
    }
}
