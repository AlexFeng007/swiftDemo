//
//  PromotionRuleModel.swift
//  FKY
//
//  Created by yangyouyong on 2017/1/9.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

@objc final class PromotionRuleModel: NSObject, JSONAbleType ,HandyJSON{
    required override init() {}
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &promotionSum, name: "promotion_sum")
        mapper.specify(property: &promotionSum, name: "promotionSum")
        mapper.specify(property: &promotionMinu, name: "promotion_minu")
        mapper.specify(property: &promotionSum, name: "promotionMinu")
        mapper.specify(property: &promotionid, name: "id")
    }
    
    var promotionSum : Float?
    var promotionMinu : String?
    var promotionid : String?
    // var productPromotionChange : String?
    var productPromotionChangeStr : String?
    var promotion_id : String?
    var status : String?
    var timestamp : String?
    
    static func fromJSON(_ json: [String : AnyObject]) -> PromotionRuleModel {
        let json = JSON(json)
        let model = PromotionRuleModel()
        if json["promotionSum"].float != nil {
            model.promotionSum  = json["promotionSum"].float
        }else{
            model.promotionSum  = json["promotion_sum"].float
        }
        if json["promotionMinu"].string != nil {
            model.promotionMinu  = json["promotionMinu"].string
        }else{
            model.promotionMinu  = json["promotion_minu"].string
        }
        //        model.promotionSum = json["promotionSum"].float
        //        model.promotionMinu = json["promotionMinu"].string
        model.promotionid = json["id"].string
        model.productPromotionChangeStr = json["productPromotionChangeStr"].string
        model.status = json["status"].string
        model.timestamp = json["timestamp"].string
        return model
    }
}
