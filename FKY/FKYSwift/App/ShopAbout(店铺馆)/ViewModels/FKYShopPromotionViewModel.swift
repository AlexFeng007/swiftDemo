//
//  FKYShopPromotionViewModel.swift
//  FKY
//
//  Created by yyc on 2020/10/16.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopPromotionViewModel: NSObject {
    var hasNextPage = true  //判断是否有下一页
    var pageSize = 0  //返回的总页数
    var currentPage: Int = 1   //当前页加载页 已有的
    
    var prdArr = [FKYMedicineModel]() //请求的商品数据
    var totalProductsCount :Int = 0 //记录请求回来了多少个商品
    
    func getShopPromotionList(block: @escaping (Bool, String?)->()) {
        // 传参
        let dic = NSMutableDictionary()
        //dic["pageSize"] = self.pageSize
        dic["pageId"] = self.currentPage
        
        dic["userid"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserId()
        dic["siteCode"] = (FKYLocationService().currentLoaction.substationCode ?? "000000")
        dic["enterpriseId"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        
        FKYRequestService.sharedInstance()?.requestForProductPromotionListInShopCollection(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
            guard let selfStrong = self else {
                block(false, "请求失败")
                return
            }
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "获取失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                selfStrong.hasNextPage = false
                block(false, msg)
                return
            }
            // 请求成功
            if let data = response as? NSDictionary {
                if selfStrong.currentPage == 1{
                    //第一个清空数据
                    selfStrong.prdArr.removeAll()
                    selfStrong.totalProductsCount = 0
                }
                //总页数
                if  let rows = data.object(forKey: "pageSize") as? Int {
                    selfStrong.pageSize = rows
                    //是否有下一页
                    selfStrong.hasNextPage = (selfStrong.currentPage < selfStrong.pageSize)
                }
                // 商品列表
                if let productArr = data["templates"] as? NSArray {
                    for dic in productArr {
                        if let desDic = dic as? Dictionary<String,AnyObject> {
                            if let templateType = desDic["templateType"] as? Int {
                                if templateType == 9 {
                                    //产品
                                    if let prdDic = desDic["contents"] as? NSDictionary , let floorDic = prdDic["productFloor"] as? NSDictionary{
                                        let prdModel = floorDic.mapToObject(FKYMedicineModel.self)
                                        selfStrong.prdArr.append(prdModel)
                                        if let arr = prdModel.mpHomeProductDtos{
                                            selfStrong.totalProductsCount = selfStrong.totalProductsCount + arr.count
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                selfStrong.currentPage += 1
                block(true, "获取成功")
                return
            }
            selfStrong.hasNextPage = false
            block(false, "获取失败")
        })
    }
}
