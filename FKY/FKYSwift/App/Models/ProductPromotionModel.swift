//
//  ProductPromotionModel.swift
//  FKY
//
//  Created by mahui on 2016/11/16.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SwiftyJSON
import HandyJSON
/*
 
 "productPromotion": {
 "begin_time": 1479052800,
 "current_inventory": 90,
 "end_time": 1480435200,
 "enterprise_id": "33177",
 "group_code": "331771453051714",
 "id": "75",
 "limit_num": 20,
 "minimum_packing": 5,
 "promotion_id": "12402",
 "promotion_name": "APP促销活动01",
 "promotion_price": 0.001,
 "promotion_state": "0",
 "promotion_type": "1",
 "sort": 1,
 "spu_code": "021AAAZ40001",
 "status": "0",
 "sum_inventory": 100
 },
 */

final class ProductPromotionModel: NSObject, JSONAbleType,HandyJSON {
    required override init() {}
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &promotionId, name: "promotionId")
        mapper.specify(property: &promotionId, name: "promotion_id")
        
        mapper.specify(property: &promotionPrice, name: "promotionPrice")
        mapper.specify(property: &promotionPrice, name: "promotion_price")
        
        mapper.specify(property: &minimumPacking, name: "minimumPacking")
        mapper.specify(property: &minimumPacking, name: "minimum_packing")
        
        mapper.specify(property: &promotionType, name: "promotionType")
        mapper.specify(property: &promotionType, name: "promotion_type")
        
        mapper.specify(property: &priceVisible, name: "priceVisible")
        mapper.specify(property: &priceVisible, name: "price_visible")
        
        mapper.specify(property: &limitNum, name: "limitNum")
        mapper.specify(property: &limitNum, name: "limit_num")
    }
    var limitNum : NSInteger?
    var promotionId : String?
    var promotionPrice : Float?
    var priceVisible: NSInteger?
    var minimumPacking: NSInteger?
    var promotionType: String?
    var liveStreamingFlag: Int?               // 直播价格标啥
    static func fromJSON(_ json: [String : AnyObject]) -> ProductPromotionModel {
        let model = ProductPromotionModel()
        let json = JSON(json)
        
        if json["promotion_id"].string  != nil {
            model.promotionId = json["promotion_id"].stringValue
        }else{
            model.promotionId = json["promotionId"].stringValue
        }
        
        if json["promotion_price"].float  != nil {
            model.promotionPrice = json["promotion_price"].floatValue
        }else{
            model.promotionPrice = json["promotionPrice"].floatValue
        }
        
        if json["minimum_packing"].int  != nil {
            model.minimumPacking = json["minimum_packing"].intValue
        }else{
            model.minimumPacking = json["minimumPacking"].intValue
        }
        
        if json["promotion_type"].string  != nil {
            model.promotionType = json["promotion_type"].stringValue
        }else{
            model.promotionType = json["promotionType"].stringValue
        }
        
        
        if json["price_visible"].int  != nil {
            model.priceVisible = json["price_visible"].intValue
        }else{
            model.priceVisible = json["priceVisible"].intValue
        }
        
        
        if json["limit_num"].int  != nil {
            model.limitNum = json["limit_num"].intValue
        }else{
            model.limitNum = json["limitNum"].intValue
        }
        model.liveStreamingFlag = json["liveStreamingFlag"].intValue
        return model
    }
}
