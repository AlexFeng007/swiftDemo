//
//  FKYHeightGrossMarginViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/8.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

class FKYHeightGrossMarginViewModel: NSObject {
    /// 商品列表
    var dataSource = [Any]()
    var labelId = "";//
    var spuCode : String? //商品编码
    var sellCode : String? //卖家编码
    /// 是否有下一页，后台返回字段，初始状态为true
    var hasNextPage = true;
    /// 下一页的页码，后台返回字段，页码不用自己计算，直接用此后台字段，起始页码为1
    var nextPage = 1;
    /// 分页大小
    var pageSize = 10
    /// 总页数
    var allPages = 0
    /// 当前专区的title 默认高毛专区
    var title = ""
}

//MARK: - 网络请求
extension FKYHeightGrossMarginViewModel{
    
    /// 获取高毛专区商品列表
    func requestHeightGrossMarginProductList(block: @escaping (Bool, String?)->()){
        let param = ["labelId":self.labelId,
                     "pageNo":self.nextPage,
                     "pageSize":self.pageSize] as [String : Any]
        FKYRequestService.sharedInstance()?.requestForGetHeightGrossMargin(withParam: param, completionBlock: { [weak self]  (success, error, response, model) in
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
            
            guard let data = response as? NSDictionary else{
                block(false,"数据解析错误")
                return
            }
            
            let responseJSON = JSON(data)
            selfStrong.allPages = responseJSON["allPages"].intValue
            selfStrong.hasNextPage = responseJSON["hasNextPage"].boolValue
            selfStrong.nextPage = responseJSON["nextPage"].intValue
            selfStrong.pageSize = responseJSON["pageSize"].intValue
            selfStrong.title = responseJSON["title"].stringValue
            let productList = responseJSON["result"].arrayValue
            for productDic in productList{
                let homeModel = HomeProductModel.transformOrderListModelToHomeProductModel((productDic.dictionaryObject ?? ["":""]) as [String:AnyObject])
                selfStrong.dataSource.append(homeModel)
            }
            block(true,"")
            
        })
    }
}
//MARK: - 测试数据
extension FKYHeightGrossMarginViewModel{
    
    /// 获取测试数据
    func getTestData(){
        for _ in 0..<20{
            let homeModel = self.creatHomeProductModel()
            self.dataSource.append(homeModel)
        }
    }
    
    /// 返回一个测试数据的list
    static func getTestDataList() -> [HomeProductModel]{
        var testList:[HomeProductModel] = []
        for _ in 0..<20{
            let homeModel = FKYHeightGrossMarginViewModel().creatHomeProductModel()
            testList.append(homeModel)
        }
        return testList
    }
    
    /// 清除测试数据
    func clearTestData(){
        self.dataSource.removeAll()
    }
    
    /// 创建一个测试homeModel
    func creatHomeProductModel() -> HomeProductModel{
        let model = HomeProductModel()
        model.baseCount = 1
        model.channelPrice = 11
        model.factoryId = 57003
        model.factoryName = "华润三九医药股份有限公司委托华润三九（枣庄）药业有限公司"
        model.isChannel = "1"
        model.limitInfo = ""
        model.includeCouponTemplateIds = ""
        model.isRebate = 0
        model.haveDinner = false
        model.couponFlag = 0
        model.productCodeCompany = "0009724190"
        model.productId = "118160"
        model.productName = "999 感冒灵颗粒"
        model.productPicUrl = "https://p8.maiyaole.com//img/item/201808/10/20180810095613128.jpg"
        model.productPrice = 11.22
        model.availableVipPrice = 0
        model.visibleVipPrice = 0
        model.vipLimitNum = 0
        model.vipPromotionId = ""
        model.shortName = "999 感冒灵颗粒"
        model.spec = "10g*9袋"
        model.statusDesc = 0
        model.stepCount = 1
        model.stockCount = 25505
        model.unit = "盒"
        model.vendorId = 8353
        model.isZiYingFlag = 1
        model.vendorName = "广东壹号药业有限公司"
        model.limitBuyDesc = ""
        model.stockCountDesc = "有货"
        model.surplusBuyNum = 0
        model.limitBuyNum = 0
        model.spuCode = "118160"
        model.deadLine = "2021-04-30 00:00:00"
        model.productionTime = "2019-05-17 00:00:00"
        model.discountPrice = ""
        model.discountPriceDesc = ""
        model.promotionList = [PromotionModel]()
        let promotion = ProductPromotionModel()
        //        promotion.promotionType = "1"
        //        promotion.minimumPacking = 1
        promotion.limitNum = 10
        promotion.promotionId = "33427"
        promotion.promotionPrice = 9.9
        promotion.priceVisible = 0
        promotion.minimumPacking = 1
        promotion.promotionType = "1"
        model.productPromotion = promotion
        model.productPromotionInfos = [ProductPromotionInfo]()
        model.productPrimeryKey = 40074
        model.recommendPrice = 0.00
        model.activityDescription = ""
        model.productStatus = false
        //        model.productType =
        model.statusComplain = ""
        model.stockToFromWarhouseName = ""
        //        model.limitCanBuyNumber =
        //        model.carId =
        //        model.carOfCount =
        //        model.showSequence =
        model.shareStockCount = 0
        model.stockIsLocal = true
        model.protocolRebate = false
        model.stockToDate = ""
        model.stockToFromWarhouseId = 0
        model.drugSecondCategory = "250"
        model.drugSecondCategoryName = "中成药"
        model.shareStockDesc = ""
        model.shopName = ""
        model.ziyingTag = "华南仓"
        for cartModel in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode ==  model.productId && cartOfInfoModel.supplyId.intValue == Int(model.vendorId) {
                    model.carOfCount = cartOfInfoModel.buyNum.intValue
                    model.carId = cartOfInfoModel.cartId.intValue
                    break
                }
            }
        }
        return model
    }
}
extension FKYHeightGrossMarginViewModel {
    //MARK:获取降价专区商品列表
    func requestCutPriceProductList(type:String,spuCode:String,sellerCode:String ,block: @escaping (Bool, String?)->()){
        let param = ["type":type,
        "page":self.nextPage,
        "pageSize":self.pageSize,
        "spuCode":spuCode,
        "sellerCode":sellerCode] as [String : Any]
        FKYRequestService.sharedInstance()?.fetchCutPriceProductList(param, completionBlock: {  [weak self]  (success, error, response, model) in
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
            guard let data = response as? NSDictionary else{
                block(false,"数据解析错误")
                return
            }
            let responseJSON = JSON(data)
            selfStrong.allPages = responseJSON["totalPageCount"].intValue
            selfStrong.hasNextPage = responseJSON["hasNextPage"].boolValue
            selfStrong.nextPage = responseJSON["nextPageId"].intValue
            selfStrong.pageSize = responseJSON["pageSize"].intValue
            if selfStrong.title.count == 0 {
                if let str = responseJSON["title"].string ,str.count > 0 {
                    selfStrong.title = str
                }
            }
            
            if let productList = responseJSON["result"].arrayObject , productList.count > 0 {
                for productDic in productList{
                    let homeModel = HomeCommonProductModel.fromJSON(productDic as! [String : AnyObject])
                    //不显示本月已售数量
                    homeModel.pmDescription = ""
                    selfStrong.dataSource.append(homeModel)
                }
            }
            block(true,"")
        })
    }
    //MARK:获取城市热销商品列表
    func requestCityHotSaleProductList(block: @escaping (Bool, String?)->()){
        let param = ["spuCode":self.spuCode ?? "",
                     "sellerCode":self.sellCode ?? "",
                     "pageId":self.nextPage,
                     "pageSize":self.pageSize] as [String : Any]
        FKYRequestService.sharedInstance()?.fetchHomeCityHotSalHotSaleProuctList(withParam: param, completionBlock: { [weak self]  (success, error, response, model) in
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
            
            guard let data = response as? NSDictionary else{
                block(false,"数据解析错误")
                return
            }
            let responseJSON = JSON(data)
            selfStrong.allPages = responseJSON["totalPageCount"].intValue
            selfStrong.hasNextPage = responseJSON["hasNextPage"].boolValue
            selfStrong.nextPage = responseJSON["nextPageId"].intValue
            selfStrong.pageSize = responseJSON["pageSize"].intValue
            if selfStrong.title.count == 0 {
                if let str = responseJSON["floorName"].string ,str.count > 0 {
                    selfStrong.title = str
                }
            }
            if let productList = responseJSON["list"].arrayObject , productList.count > 0 {
                for productDic in productList{
                    let homeModel = HomeCommonProductModel.fromJSON(productDic as! [String : AnyObject])
                    //不显示本月已售数量
                    homeModel.pmDescription = ""
                    selfStrong.dataSource.append(homeModel)
                }
            }
            block(true,"")
        })
    }
    
    //MARK: 获取即将售罄商品列表
    func requestSaleOutProductList(block: @escaping (Bool, String?)->()){
        let param = ["spuCode":self.spuCode ?? "",
                     "sellerCode":self.sellCode ?? "",
                     "pageId":self.nextPage,
                     "pageSize":self.pageSize] as [String : Any]
        FKYRequestService.sharedInstance()?.fetchHomeWillSaleOut(withParam: param, completionBlock: { [weak self]  (success, error, response, model) in
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
            
            guard let data = response as? NSDictionary else{
                block(false,"数据解析错误")
                return
            }
            let responseJSON = JSON(data)
            selfStrong.allPages = responseJSON["totalPageCount"].intValue
            selfStrong.hasNextPage = responseJSON["hasNextPage"].boolValue
            selfStrong.nextPage = responseJSON["nextPageId"].intValue
            selfStrong.pageSize = responseJSON["pageSize"].intValue
            if selfStrong.title.count == 0 {
                if let str = responseJSON["floorName"].string ,str.count > 0 {
                    selfStrong.title = str
                }
            }
            if let productList = responseJSON["list"].arrayObject , productList.count > 0 {
                for productDic in productList{
                    let homeModel = HomeCommonProductModel.fromJSON(productDic as! [String : AnyObject])
                    //不显示本月已售数量
                    homeModel.pmDescription = ""
                    selfStrong.dataSource.append(homeModel)
                }
            }
            block(true,"")
        })
    }
    //MARK:获取一品多商商品列表
    func requestSameProductMoreProductList(block: @escaping (Bool, String?)->()){
        let param = ["spuCode":self.spuCode ?? "",
                     "pageId":self.nextPage,
                     "pageSize":self.pageSize] as [String : Any]
        FKYRequestService.sharedInstance()?.fetchHomeSameProductMoreSellersProuctList(withParam: param, completionBlock: { [weak self]  (success, error, response, model) in
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
            
            guard let data = response as? NSDictionary else{
                block(false,"数据解析错误")
                return
            }
            let responseJSON = JSON(data)
            selfStrong.allPages = responseJSON["totalPageCount"].intValue
            selfStrong.hasNextPage = responseJSON["hasNextPage"].boolValue
            selfStrong.nextPage = responseJSON["nextPageId"].intValue
            selfStrong.pageSize = responseJSON["pageSize"].intValue
            if let str = responseJSON["floorName"].string ,str.count > 0 {
                selfStrong.title = str
            }
            if let productList = responseJSON["list"].arrayObject , productList.count > 0 {
                for productDic in productList{
                    let homeModel = HomeCommonProductModel.fromJSON(productDic as! [String : AnyObject])
                    //不显示本月已售数量
                    homeModel.pmDescription = ""
                    selfStrong.dataSource.append(homeModel)
                }
            }
            block(true,"")
        })
    }
    //MARK:获取新品上架商品列表
    func requestNewGoodsOnSaleProductList(block: @escaping (Bool, String?)->()){
        let param = ["spuCode":self.spuCode ?? "",
                     "sellerCode":self.sellCode ?? "",
                     "pageId":self.nextPage,
                     "pageSize":self.pageSize] as [String : Any]
        FKYRequestService.sharedInstance()?.fetchHomenewGoodsOnSaleProuctList(withParam: param, completionBlock: { [weak self]  (success, error, response, model) in
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
            
            guard let data = response as? NSDictionary else{
                block(false,"数据解析错误")
                return
            }
            let responseJSON = JSON(data)
            selfStrong.allPages = responseJSON["totalPageCount"].intValue
            selfStrong.hasNextPage = responseJSON["hasNextPage"].boolValue
            selfStrong.nextPage = responseJSON["nextPageId"].intValue
            selfStrong.pageSize = responseJSON["pageSize"].intValue
            if selfStrong.title.count == 0 {
                if let str = responseJSON["floorName"].string ,str.count > 0 {
                    selfStrong.title = str
                }
            }
            
            if let productList = responseJSON["list"].arrayObject , productList.count > 0 {
                for productDic in productList{
                    let homeModel = HomeCommonProductModel.fromJSON(productDic as! [String : AnyObject])
                    //不显示本月已售数量
                    homeModel.pmDescription = ""
                    selfStrong.dataSource.append(homeModel)
                }
            }
            block(true,"")
        })
    }
}
