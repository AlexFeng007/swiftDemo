//
//  SendCouponInfoViewModel.swift
//  FKY
//
//  Created by 寒山 on 2020/5/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class SendCouponInfoViewModel: NSObject {
    let pageSize = 9
    var hasNextPage = true  //判断是否有下一页
    var currentPage: Int = 1   //当前页加载页 已有的
    //首页banner 和 icon 的数据
    var dataSource = [OftenBuyProductItemModel]()//商品数组
    var sendCouponInfoMoel:SendCouponInfoMoel? //送券信息
    fileprivate lazy var logic: FKYOftenBuyLogic = { [weak self] in
        let logic = FKYOftenBuyLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYOftenBuyLogic
        return logic!
        }()
    //获取全部商品
    func getAllHotSellProductInfo(callback: @escaping ()->(), fail: @escaping (_ reason : String)->()) {
        // 传参
        let dic: [String: Any] = [
            "pageId":self.currentPage,
            "pageSize":self.pageSize,
            "enterpriseId":FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid() // 企业id
        ]
        logic.fetchCityHotSaleViewData(withParams: dic) {[weak self] (response, error) in
            if let strongSelf = self {
                strongSelf.dealData(response: response, error: error, callback: callback, fail: fail)
            }
        }
        
    }
    func dealData(response: Any?, error: Error?, callback: @escaping ()->(), fail: @escaping (_ reason : String)->()) {
        var dataSource: Array<OftenBuyProductItemModel> = []
        if self.currentPage != 1 && self.dataSource.count > 0 {
            dataSource = self.dataSource
        } else {
            dataSource = []
        }
        
        var tip = "访问失败"
        if let err = error {
            let e = err as NSError
            let code: NSString? = e.userInfo[HJErrorCodeKey] as? NSString
            if code != nil {
                tip = tip + " (" + (code! as String) + ")"
            }
            fail(tip)
        } else {
            tip = "暂无数据"
            guard let data = response as? NSDictionary else {
                self.hasNextPage = false
                fail(tip)
                return
            }
            if let list = data["list"] as? NSArray {
                // 有数据
                let datas = list
                let items = datas.mapToObjectArray(OftenBuyProductItemModel.self)!
                dataSource.append(contentsOf: items)
                // < self.currentModel.pageSize
                if items.count < self.pageSize {
                    self.hasNextPage = false
                } else {
                    self.hasNextPage = true
                }
                self.currentPage += 1
                self.dataSource = dataSource
                callback()
            } else {
                // 无数据
                self.hasNextPage = false
                fail(tip)
            }
        }
    }
    
    func getSendCouponInfo(block: @escaping (Bool, String?)->()) {
        // 传参
        FKYRequestService.sharedInstance()?.requestProductSendCouponInfo(withParam: nil, completionBlock: {[weak self]  (success, error, response, model) in
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
            if let data = response as? NSDictionary {
                let model = data.mapToObject(SendCouponInfoMoel.self)
                selfStrong.sendCouponInfoMoel = model
                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
}
