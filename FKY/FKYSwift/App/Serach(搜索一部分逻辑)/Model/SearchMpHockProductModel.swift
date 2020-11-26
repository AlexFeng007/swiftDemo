//
//  SearchMpHockProductModel.swift
//  FKY
//
//  Created by 寒山 on 2020/3/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc final  class SearchMpHockProductModel: NSObject,JSONAbleType {
    var bigPacking: String?  //1
    var isChannel : String?//1
    var limitNum: String? //活动库存
    var minimumPacking: String?//1
    var price:Float?//活动价格
    var priceDesc: String?//11
    var priceStatus: String?//1
    var productId: String?//1
    var productName: String?//1
    var productFullName: String?{ //商品全名 名字加规格//
        get {
            return (productName ?? "") + " " + (spec ?? "")
        }
    }
    var isZiYingFlag = 0
    var ziyingTag = ""
    var productPicPath: String?//1
    var productStatus: Int?//1
    var productcodeCompany: String?//1
    var sellerCode: String?//1
    var showPrice: String?//1
    var spec: String?//1
    var spuCode: String?//1
    var unitName: String?//1
    var weekLimitNum: String?//
    var deadLine: String? // 有效期 1
    var stockCountDesc: String? // 库存描述字段1
    var productionTime: String? // 生产日期1
    
    var factoryName: String? // 厂家名1
    var frontSellerName: String? // 商家1
    var productPromotionInfo:ProductPromotionInfo?  //
    var productPromotion: ProductPromotionModel?
    var productType: SearchProductInfoType = .CommonProduct              // 判断搜索是否是钩子商品
    // 数据解析
    @objc static func fromJSON(_ json: [String : AnyObject]) -> SearchMpHockProductModel {
        let j = JSON(json)
        let model = SearchMpHockProductModel()
        model.bigPacking = j["bigPacking"].stringValue
        model.minimumPacking = j["minimumPacking"].stringValue
        model.price = j["price"].floatValue
        model.priceDesc = j["priceDesc"].stringValue
        model.limitNum = j["limitNum"].stringValue
        model.isChannel = j["isChannel"].stringValue
        model.priceStatus = j["priceStatus"].stringValue
        model.productId = j["productId"].stringValue
        model.productName = j["productName"].stringValue
        model.productPicPath = j["productPicPath"].stringValue
        model.productStatus = j["productStatus"].intValue
        model.productcodeCompany = j["productcodeCompany"].stringValue
        model.sellerCode = j["sellerCode"].stringValue
        model.showPrice = j["showPrice"].stringValue
        model.spec = j["spec"].stringValue
        model.spuCode = j["spuCode"].stringValue
        model.unitName = j["unitName"].stringValue
        model.weekLimitNum = j["weekLimitNum"].stringValue
        model.deadLine = j["deadLine"].stringValue
        model.factoryName = j["factoryName"].stringValue
        model.frontSellerName = j["frontSellerName"].stringValue
        model.stockCountDesc = j["stockCountDesc"].stringValue
        model.productionTime = j["productionTime"].stringValue
        
        let promoInfos = j["fullDiscountPromotion"].dictionaryObject
        if let _ = promoInfos {
            let t = promoInfos! as NSDictionary
            model.productPromotionInfo  = t.mapToObject(ProductPromotionInfo.self)
        }else{
            model.productPromotionInfo = nil
        }
        let specialDic = j["specialPromotion"].dictionaryObject
        if let _ = specialDic {
            let t = specialDic! as NSDictionary
            model.productPromotion = t.mapToObject(ProductPromotionModel.self)
        }else{
            model.productPromotion = nil
        }
        return model
    }
}
