//
//  ShopAllProducViewModel.swift
//  FKY
//
//  Created by 寒山 on 2019/11/1.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class ShopAllProducViewModel: NSObject {
    let pageSize = 10
    var hasNextPage = true  //判断是否有下一页
    var currentIndex: Int = 1 //下一个请求页
    var currentPage: Int = 1   //当前页加载页 已有的
    var totalCount: Int = 0    //总数    number
    var totalPage : Int = 1   //总页数    number
    var enterpriseId:String? //企业id
    var product2ndLM:String? //二级类目
    var sortType:ProdcutSortType = ProdcutSortType.ProdcutSortType_None //商品排序
    //首页banner 和 icon 的数据
    var dataSource = [ShopProductItemModel]()
    var produftCategory : [FirstShopProductCatagoryModel] = []       //商品分类    array<object>
    var activityConfig: ShopProductActivityModel?  // 配置分类    object
    //    enterpriseId    企业id    number
    //    keyword    关键字    string
    //    page    当前页码    number    1开始
    //    product2ndLM    二级类目    string
    //    size    每页显示个数    number    最大20
    //    sort    排序    number    0：默认，1：销量，2：月店数


    //获取全部商品
    func getAllProductInfo(block: @escaping (Bool, String?)->()) {
        // 传参
        let parameters = ["page": self.currentIndex, "size": self.pageSize, "enterpriseId": self.enterpriseId as Any ,"product2ndLM":product2ndLM ?? "","sort":self.sortType.rawValue] as [String : Any]
        FKYRequestService.sharedInstance()?.requestForAllProducInShop(withParam: parameters, completionBlock: {[weak self]  (success, error, response, model) in
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
                let model = data.mapToObject(NewShopAllProductModel.self)
                selfStrong.totalCount = model.totalCount ?? 1
                selfStrong.totalPage = model.totalPages ?? 1
                selfStrong.currentPage = model.page ?? selfStrong.currentIndex
                if selfStrong.currentPage == 1{
                    //第一个清空数据
                    selfStrong.dataSource.removeAll()
                }
                if selfStrong.currentPage >= selfStrong.totalPage{
                    selfStrong.hasNextPage = false
                }else{
                    selfStrong.hasNextPage = true
                    selfStrong.currentIndex = (model.page != nil) ? (model.page! + 1):selfStrong.currentIndex + 1
                }
                if let list = model.list,list.count > 0{
                    selfStrong.dataSource.append(contentsOf: list)
                }
                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
    //获取商家商品分类
    func getShopProductCatagoryInfo(block: @escaping (Bool, String?)->()) {
        // 传参
        let parameters = ["enterpriseId": self.enterpriseId as Any] as [String : Any]
        FKYRequestService.sharedInstance()?.requestForProductCategoryInShop(withParam: parameters, completionBlock: {[weak self]  (success, error, response, model) in
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
                let model = data.mapToObject(ShopProductCatagoryTypeModel.self)
                selfStrong.activityConfig = model.config
                if let category = model.category{
                    selfStrong.produftCategory = category
                }
                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
    //判断是不是已经筛选过
    func contentIsAllProduct() ->(Bool){
        if let type = self.product2ndLM,type.isEmpty == false{
            return false
        }
        if self.sortType != ProdcutSortType.ProdcutSortType_None{
            return false
        }
       return true
    }
}
