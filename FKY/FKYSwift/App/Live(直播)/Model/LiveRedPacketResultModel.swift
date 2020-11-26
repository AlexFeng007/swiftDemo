//
//  LiveRedPacketResultModel.swift
//  FKY
//
//  Created by yyc on 2020/8/31.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class LiveRedPacketResultModel: NSObject ,JSONAbleType {
    var drawResult:Bool?   //抽奖结果,true表示中奖,false表示没中奖
    var desStr :String?   // 抽奖结果描述
    var priseLevel:String?   //    中奖等级
    var priseType:String?   //    奖品类型：1实物、2返利金、3优惠券4店铺券
    var couponDesc:CommonCouponNewModel?  // 优惠券
    @objc static func fromJSON(_ json: [String : AnyObject]) -> LiveRedPacketResultModel {
        let j = JSON(json)
        let model = LiveRedPacketResultModel()
        
        model.drawResult = j["drawResult"].boolValue
        model.desStr = j["description"].stringValue
        model.priseLevel = j["priseLevel"].stringValue
        model.priseType = j["priseType"].stringValue
        if let dic = j["couponDesc"].dictionary {
            model.couponDesc = (dic as NSDictionary).mapToObject(CommonCouponNewModel.self)
        }
        return model
    }
}
