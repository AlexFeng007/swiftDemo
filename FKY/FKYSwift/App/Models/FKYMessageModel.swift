//
//  FKYMessageModel.swift
//  FKY
//
//  Created by hui on 2019/3/14.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON
//消息模型
final class FKYMessageModel: NSObject,JSONAbleType {
    var messageId: Double?    //消息id
    var title: String?      //标题
    var content: String?    //消息体
    var iconUrl: String?    //图片地址
    var jumpUrl: String?    //点击跳转链接
    var messageType: Int?    //通知类型
    var hasRead: Bool?    //是否已读
    var sendTime: String?    //发送时间
    var validTime: String?    //截止有效时间
    var unreadCount: Int?    //未读消息数量
    //新版本信息
    var createTime: String?    //创建时间    string    @mock=2020-01-16 14:43:06
    var enterpriseId: String?    //    企业id    number    @mock=95617
    var imgUrl: String?    //    图片地址    string    @mock=XXX
    
    var type: String?    //    类型    number    @mock=8
    var userId: String?    //    用户id    number    @mock=95617
    var imPosition: String?    //    im消息顺序   number    @mock=95617
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>
    static func fromJSON(_ json: [String : AnyObject]) ->FKYMessageModel {
        let json = JSON(json)
        
        let model = FKYMessageModel()
        model.messageId = json["id"].doubleValue
        model.title = json["title"].stringValue
        model.content = json["content"].stringValue
        model.iconUrl = json["image"].stringValue
        model.jumpUrl = json["jumpUrl"].stringValue
        model.messageType = json["type"].intValue
        model.hasRead = json["hasRead"].boolValue
        model.sendTime = json["sendTime"].stringValue
        model.validTime = json["validTime"].stringValue
        model.unreadCount = json["unreadCount"].intValue
        
        model.createTime = json["createTime"].stringValue
        model.enterpriseId = json["enterpriseId"].stringValue
        model.imgUrl = json["imgUrl"].stringValue
        model.type = json["type"].stringValue
        model.userId = json["userId"].stringValue
        model.imPosition = json["imPosition"].stringValue
        return model
    }
}
