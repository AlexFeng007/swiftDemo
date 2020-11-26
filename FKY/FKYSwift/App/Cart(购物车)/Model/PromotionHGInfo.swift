//
//  PromotionHGInfo.swift
//  FKY
//
//  Created by 寒山 on 2019/12/2.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class PromotionHGInfo: NSObject, JSONAbleType {
    var hgDesc:String?    //     换购促销描述    string    @mock=每满5盒,可换购商品
    // @property (nonatomic, strong) NSArray<FKYHgOptionItemModel *> *hgOptionItem;    //     换购促销子品    array<object>
    var hgText:String?      //     换购满足时展示文描    string    @mock=已满5盒,可换购商品
    var hyperLink:String?     //     超链接    string
    var iconPath:String?      //     换购图标地址    string    @mock=icon url
    var id:NSNumber?              //     换购促销ID    number    @mock=15338
    var name:String?      //     换购促销名称    string    @mock=促销测试-单品换购
    var promationDescription:String?     //      活动描述    string
    var promotionType:NSNumber?             // 活动类型;1:特价活动;2:单品满减;3:多品满减;5:单品满赠；6:多品满赠送;7:单品满送积分;8:多品满送积分;9:单品换购;11:自定义单品活动; 12:自定义多品活动'
    // <Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) ->PromotionHGInfo {
        let json = JSON(json)
        let model = PromotionHGInfo()
        model.hgDesc = json["hgDesc"].stringValue
        model.hgText = json["hgText"].stringValue
        model.hyperLink = json["hyperLink"].stringValue
        model.iconPath = json["iconPath"].stringValue
        
        model.id = json["id"].numberValue
        model.promationDescription = json["promationDescription"].stringValue
        model.name = json["name"].stringValue
        model.promotionType = json["promotionType"].numberValue
        return model
    }
}

final class ShareStockInfoModel: NSObject, JSONAbleType {
    var desc:String?//    发货文描：【该商品需从XX进行调拔，预计可发货时间：2000-01-01】    string
    var needAlert:Bool?//   是否需要弹窗    boolean
    var stockToFromWarhouseId:NSNumber?//   库存调拨仓ID
    @objc static func fromJSON(_ json: [String : AnyObject]) ->ShareStockInfoModel {
        let json = JSON(json)
        let model = ShareStockInfoModel()
        model.needAlert = json["needAlert"].boolValue
        model.desc = json["desc"].stringValue
        model.stockToFromWarhouseId = json["stockToFromWarhouseId"].numberValue
        return model
    }
}


final class PromationInfoModel: NSObject, JSONAbleType {
    var exclusiveFlag:Bool?     //是否已享受专享价    boolean
    var joinDesc:String?    //  活动文描    string
    var promationDescription:String?    //      活动描述    string
    var discountMoney:NSNumber?   //      折扣/满减金额    number    @mock=10
    var hyperLink:String?      //      超链接    string    @mock=hyper link URL
    var iconPath:String?       //      满减图标地址    string    @mock=icon path
    var id:NSNumber?  //      促销活动ID    number    @mock=15336
    var name:String?      //      促销活动名称    string    @mock=促销测试-单品满减
    var unit:String?
    var teJiaPrice:NSNumber?   //     特价价格    number    @mock=9.9
    var point:NSNumber?  //    活动积分    number    @mock=10
    //    @property (nonatomic, strong) NSArray<CartPromotionRule *> *ruleList; // 递增规则数组
    var promotionPre:NSNumber?  //活动条件 0:按金额;1:按件数
    var  shareMoney:NSNumber?
    var standard:NSNumber?
    var  state:NSNumber?
    var  method:NSNumber?
    var  limitNum:NSNumber?
    var promotionType:NSNumber?  // 活动类型;1:特价活动;2:单品满减;3:多品满减;5:单品满赠；6:多品满赠送;7:单品满送积分;8:多品满送积分;9:单品换购;11:自定义单品活动; 12:自定义多品活动'
    var isMixRebate:Bool?  //    判断是不是多品返利
    var type:Int?    //    判断是不是多品满折 还是单品满折 2单 3多
    var mutexCoupon:Int?  //  是否不可用券特价商品 (1:是 0:不是)
    @objc var stringPromotionType: String {
           get {
               if let promotionType = self.type {
                   return "\(promotionType)"
               }else {
                   return ""
               }
           }
       }
    
    @objc static func fromJSON(_ json: [String : AnyObject]) ->PromationInfoModel {
        let json = JSON(json)
        let model = PromationInfoModel()
        model.promationDescription = json["description"].stringValue
        model.hyperLink = json["hyperLink"].stringValue
        model.iconPath = json["iconPath"].stringValue
        model.name = json["name"].stringValue
        model.unit = json["unit"].stringValue
        
        model.discountMoney = json["discountMoney"].numberValue
        model.id = json["id"].numberValue
        model.teJiaPrice = json["teJiaPrice"].numberValue
        model.point = json["point"].numberValue
        model.promotionPre = json["promotionPre"].numberValue
        model.shareMoney = json["shareMoney"].numberValue
        model.standard = json["standard"].numberValue
        model.state = json["state"].numberValue
        model.method = json["method"].numberValue
        model.limitNum = json["limitNum"].numberValue
        model.promotionType = json["promotionType"].numberValue
        
        model.isMixRebate = json["isMixRebate"].boolValue
        model.type = json["type"].intValue
        model.mutexCoupon = json["mutexCoupon"].intValue
        
        model.joinDesc = json["joinDesc"].stringValue
        model.exclusiveFlag = json["exclusiveFlag"].boolValue
        return model
    }
}


