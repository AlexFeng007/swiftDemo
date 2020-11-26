//
//  CoupleProductListViewModel.swift
//  FKY
//
//  Created by 寒山 on 2019/11/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class CoupleProductListViewModel: NSObject {
    let pageSize = 10
    var hasNextPage = true  //判断是否有下一页
    var currentPosition:String = "1_0" //下一个请求页
    var currentPage: Int = 1   //当前页加载页 已有的
    var keyword:String = ""   //搜索关键字
    //首页banner 和 icon 的数据
    var dataSource = [HomeProductModel]()
    var enterpriseId:String? //企业id
    var couponTemplateId:String? //优惠券ID
    /// 后台给的上方文描
    var words = ""
    
    /// 优惠券模板编号
    var couponCode = ""
    var sourceType = "" //进入的来源（1:直播间中点击查看优惠券可用商品）
    
    
    //获取全部商品
    func getAllProductInfo(block: @escaping (Bool, String?)->()) {
        // 传参
        let dic = NSMutableDictionary()
        dic["templateCode"] =  self.couponTemplateId ?? ""
        dic["position"] = self.currentPosition
        dic["pageSize"] = self.pageSize
        dic["enterpriseId"] =  self.enterpriseId
        dic["keyword"] =  self.keyword  //搜索默认参数
        dic["couponCode"] = self.couponCode
        if sourceType.count > 0 {
            dic["source"] = self.sourceType
        }
        FKYRequestService.sharedInstance()?.getProductByCoupon(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
                if selfStrong.currentPosition == "1_0"{
                    //第一个清空数据
                    selfStrong.dataSource.removeAll()
                }
                selfStrong.currentPosition =  ((data as AnyObject).value(forKeyPath: "position") as? String)!
                // 后台提示
                if let msg = data.object(forKey:"words") as? String {
                    selfStrong.words = msg
                }
                // 商品列表
                if  let prodArray = data.object(forKey: "productList") as? NSArray {
                    prodArray.forEach({ (dic) in
                        if let jsonDic =  dic as? [String : AnyObject] {
                            selfStrong.dataSource.append(HomeProductModel.parseProfitProductArr(jsonDic))
                        }
                    })
                    if prodArray.count < selfStrong.pageSize || selfStrong.currentPosition.isEmpty == true {
                        selfStrong.hasNextPage = false
                    }else{
                        selfStrong.hasNextPage = true
                    }
                }else{
                    selfStrong.hasNextPage = false
                }
                
                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
}
//MARK: - 网络请求
extension CoupleProductListViewModel{
    
    /// 获取高毛专区商品列表
    func requestHeightGrossMarginProductList(block: @escaping (Bool, String?)->()){
        
    }
}


//MARK: - 测试数据
extension CoupleProductListViewModel{
    
    /// 获取测试数据
    func getTestData(){
        for _ in 0..<20{
            let homeModel = self.creatHomeProductModel()
            self.dataSource.append(homeModel)
        }
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
