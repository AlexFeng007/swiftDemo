//
//  FKYJBPSearchViewModel.swift
//  FKY
//
//  Created by 寒山 on 2019/11/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  专区搜索无结果

import UIKit

class FKYJBPSearchViewModel: NSObject {
    let pageSize = 10
    var hasNextPage = true  //判断是否有下一页
    var currentIndex: Int = 1 //下一个请求页
    var currentPage: Int = 1   //当前页加载页 已有的
    var totalCount: Int = 0    //总数    number
    var totalPage : Int = 1   //总页数    number
    //首页banner 和 icon 的数据
    var dataSource = [HomeProductModel]()
    var enterpriseId:String? //专区id
    var keyWord:String? //关键词
    //获取全部商品
    func getAllProductInfo(block: @escaping (Bool, String?)->()) {
        // 传参
        let dic = NSMutableDictionary()
        dic["keyword"] =  self.keyWord ?? ""
        dic["buyerCode"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        dic["roleId"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentRoleId()
        dic["nowPage"] = self.currentIndex
        dic["per"] = self.pageSize
        dic["sellerCode"] =  self.enterpriseId
        dic["sortColumn"] =  "default"  //搜索默认参数
        dic["sortMode"] =  "default"//搜索默认参数
        dic["stock_mode"] =  "1"//搜索默认参数
        dic["sellerFilterMode"] =  "0"//搜索默认参数
        dic["haveGoodsTag"] =  false//搜索默认参数
        dic["userType"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserType()
        FKYRequestService.sharedInstance()?.requestSearchProduct(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
                selfStrong.totalCount = ((data as AnyObject).value(forKeyPath: "totalCount") as? NSInteger)!
                selfStrong.totalPage =  ((data as AnyObject).value(forKeyPath: "pageCount") as? NSInteger)!
                if selfStrong.currentIndex == 1{
                    //第一个清空数据
                    selfStrong.dataSource.removeAll()
                }
                if selfStrong.currentIndex == selfStrong.totalPage {
                    selfStrong.hasNextPage = false
                }else{
                    selfStrong.hasNextPage = true
                    selfStrong.currentIndex =  selfStrong.currentIndex + 1
                }
                // 商品列表
                if  let prodArray = (data as AnyObject).value(forKeyPath: "shopProducts") as? NSArray {
                    selfStrong.dataSource.append(contentsOf: prodArray.mapToObjectArray(HomeProductModel.self)!)
                }
                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
}
