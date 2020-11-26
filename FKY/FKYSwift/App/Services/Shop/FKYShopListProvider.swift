//
//  FKYShopListProvider.swift
//  FKY
//
//  Created by hui on 2018/5/24.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopListProvider: NSObject {
    var logic : HJLogic? = HJLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? HJLogic
    var shopList: [Any] = [] //返回的接口
    var serviceList : [FKYShopSiftModel] = [] //服务标签筛选
    var deliveriesList : [FKYShopSiftModel] = []  //店铺快递筛选
    fileprivate var nowPage: Int = 1
    fileprivate var per: Int = 10
    var totalPage: Int = 1
    fileprivate var params:[String: AnyObject]?
    var hasBannerList :Bool = false //判断是否有轮播图
    
    //MARK: 第一加载页面的时请求，调用这个方法
    func getShopList(_ params:[String: AnyObject]?, callback:@escaping ()->(), errorCallBack:@escaping ()->()) {
        self.nowPage = 1
        self.totalPage = 1
        self.hasBannerList = false
        self.params = ["nowPage":"1" as AnyObject,"per":"5" as AnyObject,"queryAll":"yes" as AnyObject]
        if let str = params?["delivery"] as? String ,str != "" {
            self.params?["isSearch"] = "yes" as AnyObject
        }
        if let str = params?["service_label"] as? String ,str != "" {
            self.params?["isSearch"] = "yes" as AnyObject
        }
    
        self.params?["delivery"] = params?["delivery"]
        self.params?["service_label"] = params?["service_label"]

        let param: HJOperationParam = HJOperationParam.init(businessName: "druggmp/index", methodName: "shopList", versionNum: "", type: kRequestPost, param: self.params) { (responseObj, error) in
            if error != nil {
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        FKYAppDelegate!.showToast("用户登录过期，请重新手动登录")
                    }
                }
                self.shopList = []
                errorCallBack()
            }
            else {
                self.shopList.removeAll()
                self.serviceList.removeAll()
                self.deliveriesList.removeAll()
                if let json = responseObj as? NSDictionary {
                    if let bannerArray = (json as AnyObject).value(forKeyPath: "banner") as? NSArray, let bannersTemp = bannerArray.mapToObjectArray(HomeBannerModel.self), bannersTemp.count > 0 {
                        self.hasBannerList = true
                        self.shopList.append(bannersTemp)
                    }
                    if let serviceArr = (json as AnyObject).value(forKeyPath: "serviceLabels") as? NSArray, let servicesTemp = serviceArr.mapToObjectArray(FKYShopSiftModel.self), servicesTemp.count > 0 {
                        self.serviceList =  self.serviceList + servicesTemp
                    }
                    if let deliveriesArr = (json as AnyObject).value(forKeyPath: "shopDeliveries") as? NSArray, let deliveriesTemp = deliveriesArr.mapToObjectArray(FKYShopSiftModel.self), deliveriesTemp.count > 0 {
                        self.deliveriesList = self.deliveriesList+deliveriesTemp
                    }
                    //返回筛选条件才显示筛选
                    if self.serviceList.count > 0 ||  self.deliveriesList.count > 0 {
                        self.shopList.append("1")//筛选
                    }
                    if  let prodArray = (json as AnyObject).value(forKeyPath: "shopList") as? NSArray, let shopListTemp = prodArray.mapToObjectArray(FKYShopListModel.self), shopListTemp.count > 0 {
                        self.shopList = self.shopList+shopListTemp
                        if let num = (json as AnyObject).value(forKeyPath: "pageCount") as? Int {
                            self.totalPage = num
                        }
                    }
                     self.nowPage = self.nowPage + 1
                }
                callback()
            }
        }
        _ = self.logic?.operationManger.request(with: param)
    }
    
    //MARK: 上拉加载更多请求用这个方法
    func getNextShopList(_ params:[String: AnyObject]?,callback:@escaping ()->()){
        if self.hasNext() {
            if self.params != nil  {
                self.params!["nowPage"] = "\(self.nowPage)" as AnyObject
                self.params!["per"] = "\(5)" as AnyObject
                self.params!["queryAll"] = "no" as AnyObject
            }
            else {
                self.params = ["nowPage":  "\(self.nowPage)" as AnyObject,
                               "per": "\(10)" as AnyObject,
                               "queryAll": "yes" as AnyObject]
            }
            if let str = params?["delivery"] as? String ,str != "" {
                self.params?["isSearch"] = "yes" as AnyObject
            }
            if let str = params?["service_label"] as? String ,str != "" {
                self.params?["isSearch"] = "yes" as AnyObject
            }

            self.params?["delivery"] = params?["delivery"]
            self.params?["service_label"] = params?["service_label"]
            self.nowPage = self.nowPage + 1
            let param: HJOperationParam = HJOperationParam.init(businessName: "druggmp/index", methodName: "shopList", versionNum: "", type: kRequestPost, param: self.params) { (responseObj, error) in
                if error != nil {
                    //请求失败页码复原
                    self.nowPage = self.nowPage - 1
                    if let err = error {
                        let e = err as NSError
                        if e.code == 2 {
                            // token过期
                            FKYAppDelegate!.showToast("用户登录过期，请重新手动登录")
                        }
                    }
                    callback()
                }
                else {
                    if let json = responseObj as? NSDictionary {
                        if  let prodArray = (json as AnyObject).value(forKeyPath: "shopList") as? NSArray {
                            let prods:[FKYShopListModel] = prodArray.mapToObjectArray(FKYShopListModel.self)!
                            prods.forEach({ (model) in
                                self.shopList.append(model)
                            })
                        }
                    }
                    callback()
                }
            }
            _ = self.logic?.operationManger.request(with: param)
        }
        else {
            callback()
        }
    }
    
    // 搜索的店铺列表
    func getSearchShopList(_ params:[String: AnyObject]? ,callback:@escaping ()->()) {
            let param: HJOperationParam = HJOperationParam.init(businessName: "druggmp/index", methodName: "shopList", versionNum: "", type: kRequestPost, param: params) { (responseObj, error) in
                if error != nil {
                    if let err = error {
                        let e = err as NSError
                        if e.code == 2 {
                            // token过期
                            FKYAppDelegate!.showToast("用户登录过期，请重新手动登录")
                        }
                    }
                    callback()
                }
                else {
                    if let json = responseObj as? NSDictionary {
                        if  let prodArray = (json as AnyObject).value(forKeyPath: "shopList") as? NSArray {
                            let prods:[FKYShopListModel] = prodArray.mapToObjectArray(FKYShopListModel.self)!
                            prods.forEach({ (model) in
                                self.shopList.append(model)
                            })
                            if let num = (json as AnyObject).value(forKeyPath: "pageCount") as? Int {
                                self.totalPage = num
                            }
                        }
                    }
                    callback()
                }
            }
           _ = self.logic?.operationManger.request(with: param)
    }
    
    func hasNext() -> Bool {
        return self.totalPage >= self.nowPage
    }
}
