//
//  CartVipInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2019/12/2.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON
//商品vip信息model
final class CartVipInfoModel: NSObject, JSONAbleType {
    var availableVipPrice : Float?         //可用会员价（会员才有这个字段）
    var visibleVipPrice : Float?           //可见会员价（非会员和会员都有）
    var vipLimitNum :NSInteger?            //vip限购数量
    var vipPromotionId :String?            //vip活动id
    var reachVipLimitNum:Bool?   //是否达到了会员限购数量
    @objc static func fromJSON(_ json: [String : AnyObject]) ->CartVipInfoModel {
        let json = JSON(json)
        let model = CartVipInfoModel()
        if let vipAvailablePriceNum = Float(json["availableVipPrice"].stringValue), vipAvailablePriceNum > 0 {
            model.availableVipPrice = vipAvailablePriceNum
        }
        if let vipPriceNum = Float(json["visibleVipPrice"].stringValue), vipPriceNum > 0 {
            model.visibleVipPrice = vipPriceNum
        }
        if let vipNum = Int(json["vipLimitNum"].stringValue),vipNum > 0{
            model.vipLimitNum = vipNum
        }
        model.vipPromotionId = json["vipPromotionId"].stringValue
        model.reachVipLimitNum = json["reachVipLimitNum"].boolValue
        return model
    }
}
//商品限购信息model
final class ProductLimitBuyInfoModel: NSObject, JSONAbleType {
    var cycleType:Int?    //商品限购周期类型：（不限：1；周限购：2；月限购：3）    number
    var historyBuyCount:NSNumber?    //限购品历史购买量    number
    var limitNum:Int?    //商品限购数量    number
    var limitTextMsg:String?    //商品限购展示消息    string
    var surplusMaxNum:Int?    //剩余可购买的最大限购数量    number
    
    @objc static func fromJSON(_ json: [String : AnyObject]) ->ProductLimitBuyInfoModel {
        let json = JSON(json)
        let model = ProductLimitBuyInfoModel()
        model.limitTextMsg = json["limitTextMsg"].stringValue
        model.cycleType = json["cycleType"].intValue
        model.limitNum = json["limitNum"].intValue
        model.surplusMaxNum = json["surplusMaxNum"].intValue
        model.historyBuyCount = json["historyBuyCount"].numberValue
        return model
    }
}

//商品返利信息model
final class ProductRebateInfoModel: NSObject, JSONAbleType {
    var rebateAmount:NSNumber?    //商品返利金额
    var rebateTextMsg:String?    //商品返利展示消息
    
    @objc static func fromJSON(_ json: [String : AnyObject]) ->ProductRebateInfoModel {
        let json = JSON(json)
        let model = ProductRebateInfoModel()
        model.rebateTextMsg = json["rebateTextMsg"].stringValue
        model.rebateAmount = json["rebateAmount"].numberValue
        return model
    }
}

//商品库存信息model
final class ProductInventoryInfoModel: NSObject, JSONAbleType {
    var productInventory:String?    //实际库存提示
    @objc static func fromJSON(_ json: [String : AnyObject]) ->ProductInventoryInfoModel {
        let json = JSON(json)
        let model = ProductInventoryInfoModel()
        model.productInventory = json["productInventory"].stringValue
        return model
    }
}
