//
//  FKYShopAttViewModel.swift
//  FKY
//
//  Created by yyc on 2020/10/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopAttViewModel: NSObject {
    var hasNextPage = true  //判断是否有下一页
    var pageSize = 5  //返回的总页数
    var currentPage: Int = 1   //当前页加载页
    var shopList = [FKYShopListModel]() //关注店铺
    var ultimateShops = [FKYShopListModel]() //旗舰店铺
    
    //全部店铺列表
    var allShopList = [FKYShopListModel]()
    var offset = 0
    
    var flagShipShopArr = [FKYUltimateShopModel]() //返回的全部旗舰店icon
    
    func getMainShopList(block: @escaping (Bool, String?)->()) {
        // 传参
        let dic = NSMutableDictionary()
        dic["pageSize"] = self.pageSize
        dic["page"] = self.currentPage
        //dic["queryAll"] = "yes"
        
        var siteCodeStr = "000000"
        if FKYLoginAPI.loginStatus() != .unlogin {
            if let user: FKYUserInfoModel = FKYLoginAPI.currentUser(), let code = user.substationCode {
                if code.toNSNumber().intValue != 0 {
                    siteCodeStr = code
                }
            }
        }
        dic["provinceId"] = siteCodeStr
        dic["enterpriseId"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        
        FKYRequestService.sharedInstance()?.requestForMainShopListInShopCollection(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
                    selfStrong.shopList.removeAll()
                    selfStrong.ultimateShops.removeAll()
                }
                //关注店铺列表
                if  let prodArray = data.object(forKey: "shopList") as? NSArray, let shopListTemp = prodArray.mapToObjectArray(FKYShopListModel.self), shopListTemp.count > 0 {
                    for item in shopListTemp {
                        if item.follow == "1" {
                            //关注店铺
                            selfStrong.shopList.append(item)
                        }else {
                            //优选店铺列表（一次性返回）
                            selfStrong.hasNextPage = false
                            selfStrong.ultimateShops.append(item)
                        }
                    }
                }else {
                    selfStrong.hasNextPage = false
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

//MARK:获取旗舰店icon
extension FKYShopAttViewModel{
    func getFlagShipShopList(block: @escaping (Bool, String?)->()) {
        let dic = NSMutableDictionary()
        dic["enterpriseId"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        
        FKYRequestService.sharedInstance()?.requestForFlagShipShopListInShopCollection(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
                block(false, msg)
                return
            }
            // 请求成功
            if let arr = response as? NSArray {
                //店铺列表
                if let ultimateArr = arr.mapToObjectArray(FKYUltimateShopModel.self), ultimateArr.count > 0 {
                    selfStrong.flagShipShopArr = ultimateArr
                }
                block(true, "获取成功")
                return
            }
            selfStrong.hasNextPage = false
            block(false, "获取失败")
        })
    }
}
//MARK:全部店铺列表
extension FKYShopAttViewModel {
    func getAllShopList(block: @escaping (Bool, String?)->()) {
        // 传参
        let dic = NSMutableDictionary()
        dic["pageSize"] = self.pageSize
        dic["offset"] = self.offset
        dic["enterpriseId"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        FKYRequestService.sharedInstance()?.requestForAllShopListInShopCollection(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
                    selfStrong.allShopList.removeAll()
                }
                //总页数
                if  let num = data.object(forKey: "offset") as? Int {
                    selfStrong.offset = num
                }
                //关注店铺列表
                if  let prodArray = data.object(forKey: "shopList") as? NSArray, let shopListTemp = prodArray.mapToObjectArray(FKYShopListModel.self), shopListTemp.count > 0 {
                    selfStrong.allShopList.append(contentsOf: shopListTemp)
                }else {
                    selfStrong.hasNextPage = false
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
