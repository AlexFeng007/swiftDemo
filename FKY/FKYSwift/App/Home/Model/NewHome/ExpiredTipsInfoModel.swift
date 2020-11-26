//
//  ExpiredTipsInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2020/2/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class ExpiredTipsInfoModel: NSObject,JSONAbleType {
    var content : String? //消息内容    string
    var createTime : String? //创建时间
    // var enterpriseId : String? //企业id
    var imgUrl   : String? // 图片地址
    var title : String? //消息标题
    var type: String? //消息类型
    var url : String? // 跳转地址
    //var urlType  : String? // 跳转地址类型
    var sellerInfo : MsgSellerInfoModel? // 用户id
    var isRead : Bool? // 是否已读
    var showTime : String? // 时间
    var msgId : String? // 消息id
    var subContent : String? // 副标题
    var pushId : String? // 推送ID
    static func fromJSON(_ json: [String : AnyObject]) -> ExpiredTipsInfoModel{
        let json = JSON(json)
        let model = ExpiredTipsInfoModel()
        model.content = json["content"].stringValue
        model.showTime = json["showTime"].stringValue
        model.createTime = json["createTime"].stringValue
        model.isRead = json["isRead"].boolValue
        model.title = json["title"].stringValue
        model.imgUrl = json["imgUrl"].stringValue
        model.type = json["type"].stringValue
        model.url = json["url"].stringValue
        model.msgId  = json["id"].stringValue
        model.subContent  = json["subContent"].stringValue
        model.pushId  = json["pushId"].stringValue
        let dic = json["other"].dictionaryObject
        if let _ = dic {
            let t = dic! as NSDictionary
            model.sellerInfo = t.mapToObject(MsgSellerInfoModel.self)
        }else{
            model.sellerInfo = nil
        }
        return model
    }
}

final class MsgSellerInfoModel: NSObject,JSONAbleType {
    var logo : String?    // 物流交易的商家logo    string
    var seller_code  : String?   // 物流交易的商家id    number
    var seller_name : String?    // 物流交易的商家名称    string
    
    static func fromJSON(_ json: [String : AnyObject]) -> MsgSellerInfoModel{
        let json = JSON(json)
        let model = MsgSellerInfoModel()
        model.logo = json["logo"].stringValue
        model.seller_code = json["seller_code"].stringValue
        model.seller_name = json["seller_name"].stringValue
        return model
    }
}
