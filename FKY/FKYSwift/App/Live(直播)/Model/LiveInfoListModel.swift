//
//  LiveInfoListModel.swift
//  FKY
//
//  Created by 寒山 on 2020/8/28.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc final class LiveInfoListModel: NSObject ,JSONAbleType {
    var allTimes:Int?   //总人次    number    @mock=$order(300,0)
    var beginTime:String?   //开始时间    string    @mock=$order('2020-08-28 16:27:12','2020-08-28 14:44:33')
    var liveDescription :String?   //活动描述    string    @mock=$order('买好药，上1药城','错过第一场，别错过第二场')
    var hasCoupon :Bool?   //是否有优惠券。1：有，0：没有    object
    var hasRedPacket :Bool?       //是否有红包。1：有，0：没有    object
    var id:String?    //活动id    number    @mock=$order(1,15)
    var roomId : Int?    //直播间id    number    @mock=1
    var logo :String?   //直播间logo    string    @mock=$order('//test.im.yaoex.com/yaoexim/file/download4CustomerCare/pub/ycbackend/yaoexim/image/20200820/6bfc6f6c3a7b43b8b4041b1a322fc5e3.jpg:.','//test.im.yaoex.com/yaoexim/file/download4CustomerCare/pub/ycbackend/yaoexim/image/20200820/6bfc6f6c3a7b43b8b4041b1a322fc5e3.jpg:.')
    var name:String?    //活动名称    string    @mock=$order('1药城首场直播','1药城第二场直播')
    var onlineNum:Int?    //在线人数    number    @mock=$order(2,0)
    var pic :String?   //活动图    string    @mock=$order('http://p8.maiyaole.com/fky/img/test/1516699649479.jpg','http://pub.maiyaole.com/pub/ycbackend/yaoexim/image/live/202008/7ca5d748a0ca410d8117e2fadeae544f.png')
    var roomName :String?   //直播间名称    string    @mock=$order('魏庆冰的直播间12','魏庆冰的直播间12')
    var showProduct :[HomeCommonProductModel]?   //商品    array<object>
    var status :Int?    //活动状态，0：直播中，1：回放，2：预告    number    @mock=$order(0,0)
    var type :Int?       //number    @mock=$order(1,1)
    var replayUrl :String?   //回放的url
    var hasSetNotice :Int?     //开播提醒
    @objc static func fromJSON(_ json: [String : AnyObject]) -> LiveInfoListModel {
        let j = JSON(json)
        let model = LiveInfoListModel()
        model.replayUrl = j["replayUrl"].stringValue
        model.liveDescription = j["description"].stringValue
        model.beginTime = j["beginTime"].stringValue
        model.roomName = j["roomName"].stringValue
        model.id = j["id"].stringValue
        model.roomId = j["roomId"].intValue
        
        model.logo = j["logo"].stringValue
        
        model.name = j["name"].stringValue
        model.pic = j["pic"].stringValue
        
        model.roomName = j["roomName"].stringValue
        
        model.allTimes = j["allTimes"].intValue
        model.hasCoupon = j["hasCoupon"].boolValue
        model.hasRedPacket = j["hasRedPacket"].boolValue
        model.onlineNum = j["onlineNum"].intValue
        model.status = j["status"].intValue
        model.type = j["type"].intValue
        model.hasSetNotice = j["hasSetNotice"].intValue
        var liveList: [HomeCommonProductModel]?
        if let list = j["showProduct"].arrayObject {
            liveList = (list as NSArray).mapToObjectArray(HomeCommonProductModel.self)
        }
        model.showProduct = liveList
        return model
    }
}
