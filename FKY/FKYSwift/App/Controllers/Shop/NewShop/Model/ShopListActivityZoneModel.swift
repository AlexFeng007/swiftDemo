//
//  ShopListActivityZoneModel.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/28.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  区域精选 & 诊所专供

import SwiftyJSON

final class ShopListActivityZoneModel: NSObject, JSONAbleType {
    var recommend: ShopListActivityZoneItemModel?      // 商品列表对象
    // 本地新增业务逻辑字段
    var indexMsg: Int = 0                       // 消息列表索引
    var indexItem: Int = 0                      // 当前商品索引<用于分页>
    var floorName: String?                      // 楼层名称
    var showSequence:Int = 1 // 列表中第几个活动 自定义字段
    static func fromJSON(_ json: [String : AnyObject]) -> ShopListActivityZoneModel {
        let json = JSON(json)
        
        let model = ShopListActivityZoneModel()
        
        var recommend: ShopListActivityZoneItemModel?
        if let dic = json["areaChoice"].dictionary {
            recommend = (dic as NSDictionary).mapToObject(ShopListActivityZoneItemModel.self)
        }
        if let dic = json["clinicArea"].dictionary {
            recommend = (dic as NSDictionary).mapToObject(ShopListActivityZoneItemModel.self)
        }
        model.recommend = recommend
        
        return model
    }
}

extension ShopListActivityZoneModel: ShopListModelInterface {
    func floorCellIdentifier() -> String {
        return "ShopActivitySpaceCell"
    }
}

final class ProductSignModel: NSObject, JSONAbleType {
    
    var fullGift: Bool?         // 满赠
    var purchaseLimit: Bool?    // 限购
    var packages: Bool?         // 套餐
    var fullScale: Bool?        // 满减
    var ticket: Bool?           // 优惠券
    var rebate: Bool?           // 返利
    var specialOffer: Bool?     // 特价
    var bounty:Bool?        //协议返利金
    var fullDiscount:Bool?  //满折
    var bonusTag: Bool? //是否显示奖励金标签
    var liveStreamingFlag: Bool? //代表直播价标识
    /*
      展示规则：
     仅针对MP商品
     慢必赔和保价两个标签不会同时出现，只出现一个
     这两个标签优先级排第一，优先展示
     标签不允许换行，多了不展示
     */
    //慢必赔
    var slowPay:Bool?
       //保价
    var holdPrice:Bool?
    

    static func fromJSON(_ jsonObj: [String : AnyObject]) -> ProductSignModel {
        let json = JSON(jsonObj)
        let model = ProductSignModel()
        
        model.fullGift = json["fullGift"].boolValue
        model.purchaseLimit = json["purchaseLimit"].boolValue
        model.packages = json["packages"].boolValue
        model.fullScale = json["fullScale"].boolValue
        model.ticket = json["ticket"].boolValue
        model.rebate = json["rebate"].boolValue
        model.specialOffer = json["specialOffer"].boolValue
        model.bounty = json["bounty"].boolValue
        model.fullDiscount = json["fullDiscount"].boolValue
        model.bonusTag = json["bonusTag"].boolValue
        model.slowPay = json["slowPay"].boolValue
        model.holdPrice = json["holdPrice"].boolValue
        model.liveStreamingFlag = json["liveStreamingFlag"].boolValue
        return model
    }
}

final class ShopListActivityZoneItemModel: NSObject, JSONAbleType {
    var createTime: String?
    var id: Int?
    var type: Int?
    var imgPath: String?
    var jumpInfo: String?
    var jumpType: String?
    var name: String?
    var posIndex: Int?
    var siteCode: String?
    var indexMobileId: Int?
    var jumpExpandOne: String?
    var jumpExpandTwo: String?
    var jumpExpandThree: String?
    var floorProductDtos: [HomeRecommendProductItemModel]? // 商品列表
    var jumpInfoMore: String? //更多链接
    
    init(floorProductDtos: [HomeRecommendProductItemModel]?) {
        self.floorProductDtos = floorProductDtos
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> ShopListActivityZoneItemModel {
        let json = JSON(json)
        
        let createTime = json["createTime"].stringValue
        let id = json["id"].intValue
        let type = json["type"].intValue
        let imgPath = json["imgPath"].stringValue
        let jumpInfo = json["jumpInfo"].stringValue
        let jumpType = json["jumpType"].stringValue
        let name = json["name"].stringValue
        let posIndex = json["posIndex"].intValue
        let siteCode = json["siteCode"].stringValue
        let indexMobileId = json["indexMobileId"].intValue
        let jumpExpandOne = json["jumpExpandOne"].stringValue
        let jumpExpandTwo = json["jumpExpandTwo"].stringValue
        let jumpExpandThree = json["jumpExpandThree"].stringValue
        let jumpInfoMore = json["jumpInfoMore"].stringValue
        
        var floorProductDtos: [HomeRecommendProductItemModel]?
        if let list = json["mpHomeProductDtos"].arrayObject {
            floorProductDtos = (list as NSArray).mapToObjectArray(HomeRecommendProductItemModel.self)
        }
        
        let model = ShopListActivityZoneItemModel(floorProductDtos: floorProductDtos)
        model.createTime = createTime
        model.id = id
        model.type = type
        model.imgPath = imgPath
        model.jumpInfo = jumpInfo
        model.jumpType = jumpType
        model.name = name
        model.posIndex = posIndex
        model.siteCode = siteCode
        model.indexMobileId = indexMobileId
        model.jumpExpandOne = jumpExpandOne
        model.jumpExpandTwo = jumpExpandTwo
        model.jumpExpandThree = jumpExpandThree
        model.jumpInfoMore = jumpInfoMore
        return model
    }
}

