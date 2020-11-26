//
//  LiveRoomBaseInfo.swift
//  FKY
//
//  Created by 寒山 on 2020/8/24.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class LiveRoomBaseInfo: NSObject ,JSONAbleType{
    var activityContent: String?     //活动内容    string    @mock=今天给大家涨工资，想要多少给多少
    var activityId: Int?    // 活动id    number    @mock=1
    var activityName: String?     //活动名称    string    @mock=今天给大家涨工资
    var activityPic: String?     //活动图    string    @mock=http://p8.maiyaole.com/fky/img/test/1516699649479.jpg
    var baseNum: NSNumber?     //直播间人数造假基数    number    @mock=23
    var beginTime: String?    //直播开始时间    number    @mock=1597729824000
    var couponPic: String?     //优惠券图标    string    @mock=
    var endTime: String?    //直播结束时间    number    @mock=1597902629000
    var groupId : String?    //聊天室群组id    string    @mock=@TGS#aLYVOTUGM
    var enterpriseName : String? //企业名称（后台逻辑，取不到取企业id）
    var userSign : String?  //签名
    var prizePic: String?    // 抽奖图标    string    @mock=
    var pullStreamUrl : String?    //拉流地址    string    @mock=http://live.yaoex.com/live/test.flv
    var replayUrl: String?    // 回放地址    string    @mock=
    var roomId : Int?    //直播间id    number    @mock=1
    var roomLogo : String?    //直播间logo    string    @mock=http://p8.maiyaole.com/fky/img/print/sy2/1586525999637.jpg
    var roomName : String?    //直播间名称    string    @mock=魏庆冰的直播间
    var shareWord: String?     //分享口令    string    @mock=~#3FRhB-x4ZqY#~
    var status: Int?    // 活动状态。0:直播中。1:已结束。2：未开始。    number    @mock=0
    var type: Int?     //1药城,2药网,3医院    number    @mock=1
    var hasSetNotice : Int? // 是否设置了提醒  1设置了  0没设置
    var onLineCountIM = 0 //本地im获取到在线人数后赋值
    // 数据解析
    @objc static func fromJSON(_ json: [String : AnyObject]) -> LiveRoomBaseInfo {
        let j = JSON(json)
        let model = LiveRoomBaseInfo()
        model.beginTime = j["beginTime"].stringValue
        model.endTime = j["endTime"].stringValue
        model.activityId = j["activityId"].intValue
        model.roomId = j["roomId"].intValue
        model.status = j["status"].intValue
        model.type = j["type"].intValue
        model.baseNum = j["baseNum"].numberValue
        model.activityContent = j["activityContent"].stringValue
        model.activityName = j["activityName"].stringValue
        model.activityPic = j["activityPic"].stringValue
        model.couponPic = j["couponPic"].stringValue
        model.groupId = j["groupId"].stringValue
        model.enterpriseName = j["enterpriseName"].stringValue
        model.userSign = j["userSign"].stringValue
        model.prizePic = j["prizePic"].stringValue
        model.pullStreamUrl = j["pullStreamUrl"].stringValue
        model.replayUrl = j["replayUrl"].stringValue
        model.roomLogo = j["roomLogo"].stringValue
        model.roomName = j["roomName"].stringValue
        model.shareWord = j["shareWord"].stringValue
        model.hasSetNotice = j["hasSetNotice"].intValue
        return model
    }
}
 
//MARK:口令红包模型
final class LiveRoomRedPacketInfo: NSObject ,JSONAbleType{
    var desc: String?     //红包描述
    var redPacketId: Int?    // 红包id
    var name: String?     //红包名称
    var redPacketPwd: String?  //口令
    var isShowTime : Int?    // 是否显示倒计时
    var leftTime : Int64?    // 倒计时时间

    // 数据解析
    @objc static func fromJSON(_ json: [String : AnyObject]) -> LiveRoomRedPacketInfo {
        let j = JSON(json)
        let model = LiveRoomRedPacketInfo()
        model.desc = j["desc"].stringValue
        model.redPacketId = j["id"].intValue
        model.name = j["name"].stringValue
        model.redPacketPwd = j["redPacketPwd"].stringValue
        model.isShowTime = j["isShowTime"].intValue
        model.leftTime = j["leftTime"].int64Value
        return model
    }
}

//MARK:im推送刷新模型
final class LiveRoomIMRefreshInfo: NSObject ,JSONAbleType{
    /*
     刷新观看人数 {"type":1}
     推送观看人数  {"type":2，value：99（人）}
     刷新左侧推荐品 {type:3}
     刷新右侧抽奖信息{type:4}
     推送关闭右侧抽奖入口{type:5}
     刷新右侧优惠券{type:6}
     刷新主推品{type:7}
     关闭直播间{type:8}
     */
    var type: Int?     //类型
    var peopleValue: Int?    // 推送人数
    var groupId: String = ""    // 群ID
    // 数据解析
    @objc static func fromJSON(_ json: [String : AnyObject]) -> LiveRoomIMRefreshInfo {
        let j = JSON(json)
        let model = LiveRoomIMRefreshInfo()
        model.type = j["type"].intValue
        model.peopleValue = j["value"].intValue
        return model
    }
}
