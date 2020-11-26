//
//  ShopItemProductPromotionModel.swift
//  FKY
//
//  Created by 乔羽 on 2018/4/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  店铺改版-商品 ProductPromotionModel

import UIKit
import SwiftyJSON

final class ShopItemProductPromotionModel : NSObject , JSONAbleType {
    var limitNum : Int? = nil
    var promotionId : String? = nil
    var promotionPrice : Float?
    var priceVisible: Int?
    var minimumPacking: Int?
    var promotionType: String?
     // 活动类型（14：固定套餐） 1-特价 20-闪购
    //@property (nonatomic, assign) FKYProductPromotionType promotionType; // 1-特价 20-闪购
    static func fromJSON(_ data: [String : AnyObject]) -> ShopItemProductPromotionModel {
        let model =  ShopItemProductPromotionModel.init()
        let json = JSON(data)
        model.limitNum = json["limit_num"].intValue
        model.promotionId = json["promotion_id"].stringValue
        model.promotionPrice = json["promotion_price"].floatValue
        model.priceVisible = json["price_visible"].intValue
        model.minimumPacking = json["minimum_packing"].intValue
        model.promotionType = json["promotionType"].stringValue
        return model
    }
}
extension ShopItemProductPromotionModel :NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(limitNum, forKey: "limitNum")
        aCoder.encode(promotionId, forKey: "promotionId")
        aCoder.encode(promotionPrice, forKey: "promotionPrice")
        aCoder.encode(priceVisible, forKey: "priceVisible")
        aCoder.encode(minimumPacking, forKey: "minimumPacking")
        aCoder.encode(promotionId, forKey: "promotionType")
        
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        self.init()
        limitNum = aDecoder.decodeObject(forKey: "limitNum") as? Int
        promotionId = aDecoder.decodeObject(forKey: "promotionId") as? String
        promotionPrice = aDecoder.decodeObject(forKey: "promotionPrice") as? Float
        priceVisible = aDecoder.decodeObject(forKey: "priceVisible") as? Int
        minimumPacking = aDecoder.decodeObject(forKey: "minimumPacking") as? Int
        promotionType = aDecoder.decodeObject(forKey: "promotionType") as? String

    }
}
