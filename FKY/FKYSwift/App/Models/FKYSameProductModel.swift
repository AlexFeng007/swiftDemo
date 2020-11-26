//
//  FKYSameProductModel.swift
//  FKY
//
//  Created by hui on 2019/1/11.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

//商品详情同品推荐
final class FKYSameProductModel: NSObject ,JSONAbleType {
    var stockCount : Int?//库存
    var surplusBuyNum : Int? //限购数量
    var wholeSaleNum : Int?//最小起批
    var stepCount : Int?//加车步长
    var showPrice : Float? //商品价格特价
    var deadLine : String? //有效日期
    var factoryName : String? //厂家
    var sellerName : String? //商家
    var isCoupon: Int? //1表示优惠券
    var isRebate: Int? //1表示返利
    var limitBuy: Int? //1限购
    var productMainPic: String? // 商品主图
    var productName: String? // 商品名称
    var pruductId: String? // 商品id
    var spec: String? // 规格
    @objc var spuCode : String? //SPU编码
    @objc var supplyId : String? //企业编码
    var unit: String? //最小包装单位
    var promotionList: [PromotionModel]? //
    //购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
    var specialOffer : Int = 0 // 1 特价
    var packages : Int = 0// 1套餐
    var fullScale : Int = 0// 1满减
    var fullGift : Int = 0// 1满赠
    @objc var carId :Int = 0
    @objc var carOfCount :Int = 0
    
    static func fromJSON(_ json: [String : AnyObject]) -> FKYSameProductModel {
        
        let model = FKYSameProductModel()
        let j = JSON(json)
        model.stockCount = j["frontInventory"].intValue
        model.surplusBuyNum = j["exceedLimitNum"].intValue
        model.wholeSaleNum = j["minimumPacking"].intValue
        model.stepCount = j["stepCount"].intValue
        model.deadLine = j["deadLine"].stringValue
        model.showPrice = j["showPrice"].floatValue
        model.factoryName = j["factoryName"].stringValue
        model.sellerName = j["sellerName"].stringValue
        model.isCoupon = j["isCoupon"].intValue
        model.isRebate = j["isRebate"].intValue
        model.limitBuy = j["limitBuy"].intValue
        model.productMainPic = j["productMainPic"].stringValue
        model.productName = j["productName"].stringValue
        model.pruductId = j["pruductId"].stringValue
        model.spec = j["spec"].stringValue
        model.spuCode = j["spuCode"].stringValue
        model.supplyId = j["supplyId"].stringValue
        model.unit = j["unit"].stringValue
        if let promos = j["promotions"].arrayObject {
            model.promotionList = (promos as NSArray).mapToObjectArray(PromotionModel.self)
        }
        //满减
        if model.isHasSomeKindPromotion(["2", "3"]) {
            model.fullScale = 1
        }
        //满赠
        if model.isHasSomeKindPromotion(["5", "6", "7", "8"]) {
            model.fullGift = 1
        }
        //套餐
        if model.isHasSomeKindPromotion(["13"]) {
            model.packages = 1
        }
        //特价
        if model.isHasSomeKindPromotion(["1"]) {
            model.specialOffer = 1
        }
        
        for cartModel  in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == model.spuCode && cartOfInfoModel.supplyId.intValue == Int(model.supplyId ?? "0") {
                    model.carOfCount = cartOfInfoModel.buyNum.intValue
                    model.carId = cartOfInfoModel.cartId.intValue
                    break
                }
            }
        }
        return model
    }
    
    func isHasSomeKindPromotion(_ promotionTypeArray:[String]) -> Bool {
        if let promotonList = self.promotionList, promotonList.count > 0 {
            let predicate: NSPredicate = NSPredicate(format: "self.stringPromotionType IN %@",promotionTypeArray)
            let result = (promotonList as NSArray).filtered(using: predicate)
            if result.count > 0 {
                return true
            }else {
                return false
            }
        }else{
            return false
        }
    }
    
    //解析数据
    @objc static func getSameProducArr(_ dataArr:NSArray) ->NSArray{
        if let getArr = dataArr.mapToObjectArray(FKYSameProductModel.self){
            return getArr as NSArray
        }
        return []
    }
}
