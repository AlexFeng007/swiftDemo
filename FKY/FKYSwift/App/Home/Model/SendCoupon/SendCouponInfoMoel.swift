//
//  SendCouponInfoMoel.swift
//  FKY
//
//  Created by 寒山 on 2020/5/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

import SwiftyJSON

final class SendCouponInfoMoel: NSObject, JSONAbleType {
    var view_count: Int?
    var surplus_view_count: Int?
    var begin_time: String?
    var end_time: String?
    var headText: String?
    var footText: String?
    var ruleList: [String]?
    var hasSendCouponStatus: Bool?
    var couponTemplate:CommonCouponNewModel?
    
    static func fromJSON(_ json: [String : AnyObject]) -> SendCouponInfoMoel {
        let json = JSON(json)
        let model = SendCouponInfoMoel()
        model.view_count = json["view_count"].intValue
        model.surplus_view_count = json["surplus_view_count"].intValue
        model.begin_time = json["begin_time"].stringValue
        model.end_time = json["end_time"].stringValue
        model.headText = json["headText"].stringValue
        model.footText = json["footText"].stringValue
        if let ruleList = json["ruleList"].arrayObject as? [String] {
            model.ruleList = ruleList
        }
        model.hasSendCouponStatus = json["hasSendCouponStatus"].boolValue
        var couponTemplate : CommonCouponNewModel?
        let dic = json["couponTemplate"].dictionaryObject
        if let _ = dic {
            let t = dic! as NSDictionary
            couponTemplate = t.mapToObject(CommonCouponNewModel.self)
        }else{
            couponTemplate = nil
        }
        model.couponTemplate = couponTemplate
        return model
    }
}

