//
//  LiveCommandInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2020/8/28.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class LiveCommandInfoModel:NSObject ,JSONAbleType{
    var activityId:String?   //活动id    number
    var activityName :String?   //   活动名称    string
    var roomLogo:String?   //    直播间logo    string
    var roomName:String?   //    直播间名称    string
    var activityContent:String?
    @objc static func fromJSON(_ json: [String : AnyObject]) -> LiveCommandInfoModel {
        let j = JSON(json)
        let model = LiveCommandInfoModel()
        
        model.activityId = j["activityId"].stringValue
        model.roomLogo = j["roomLogo"].stringValue
        model.roomName = j["roomName"].stringValue
        model.activityName = j["activityName"].stringValue
        model.activityContent = j["activityContent"].stringValue
        return model
    }
}
