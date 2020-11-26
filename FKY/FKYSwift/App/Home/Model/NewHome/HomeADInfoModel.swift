//
//  HomeADInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2019/3/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class HomeADInfoModel: NSObject, JSONAbleType {
    
    var countDownFlag: Int?
    var createTime: String?
    var createUser: String?
    var hotsaleFlag: Int?
    var indexMobileId: Int?
    var newOrder: Int?
    var oftenBuyFlag: Int?
    var oftenViewFlag: Int?
    var originalPriceFlag: Int?
    var posIndex: Int?
    var promotionId: Int?
    var showNum: Int?
    var iconImgPath: String?
    var id: Int?
    var type: Int?
    var imgPath: String?
    var jumpInfo: String?
    var jumpType: Int? //
    var name: String?
    var siteCode: Int?
    var indexFloor: String?
    var jumpExpandOne: String?
    var jumpExpandTwo: String?
    var jumpExpandThree: String?
    var floorProductDtos: [HomeRecommendProductItemModel]? // 商品列表
    var downTime: String?
    var upTime: String?
    var downTimeMillis:Int64?
    var upTimeMillis:Int64?
    var sysTimeMillis: Int64?       // 系统当前时间戳
    
    var title: String?
    var jumpInfoMore: String? //更多链接
    var togetherMark: Int? // 1 一起购  2一起返 一起
    var adId: Int? //
    var showSequence: Int?  //列表中第几个活动
    var iconImgDTOList : [HomeBrandDetailModel]? // 品牌的列表
    var floorStyle: Int? // 1：中通广告一行1个，2：中通广告一行2个，3：中通广告一行3个
    var pageTimeStamp: String? //首页请求时间戳
    static func fromJSON(_ json: [String : AnyObject]) -> HomeADInfoModel {
        let json = JSON(json)
        let model = HomeADInfoModel()
        model.pageTimeStamp = json["pageTimeStamp"].string
        model.adId = json["id"].intValue
        model.countDownFlag = json["countDownFlag"].intValue
        model.createTime = json["createTime"].string
        model.createUser = json["createUser"].string
        model.hotsaleFlag = json["hotsaleFlag"].intValue
        model.iconImgPath = json["iconImgPath"].string
        model.indexMobileId = json["indexMobileIde"].intValue
        model.newOrder = json["newOrder"].intValue
        model.oftenBuyFlag = json["oftenBuyFlage"].intValue
        model.oftenViewFlag = json["oftenViewFlag"].intValue
        model.originalPriceFlag = json["originalPriceFlag"].intValue
        model.posIndex = json["posIndex"].intValue
        model.promotionId = json["promotionId"].intValue
        model.showNum = json["showNum"].intValue
        model.showSequence = json["showSequence"].intValue
        
        model.floorStyle = json["floorStyle"].intValue
        model.id = json["id"].intValue
        model.type = json["type"].intValue
        model.imgPath = json["imgPath"].string
        model.jumpInfo = json["jumpInfo"].string
        
        model.togetherMark = json["togetherMark"].intValue
        model.jumpType = json["jumpType"].intValue
        model.name = json["name"].string
        model.siteCode = json["siteCode"].intValue
        model.indexFloor = json["indexFloor"].stringValue
        model.jumpExpandOne = json["jumpExpandOne"].string
        model.jumpExpandTwo = json["jumpExpandTwo"].string
        model.jumpExpandThree = json["jumpExpandThree"].string
        // let floorProductDtos: [HomeRecommendProductItemModel]?
        if let list = json["floorProductDtos"].arrayObject {
            model.floorProductDtos = (list as NSArray).mapToObjectArray(HomeRecommendProductItemModel.self)
        }
        model.downTimeMillis = json["downTimeMillis"].int64Value
        model.upTimeMillis = json["upTimeMillis"].int64Value
        model.sysTimeMillis = json["sysTimeMillis"].int64Value
        model.downTime = json["downTime"].string
        model.upTime = json["upTime"].string
        model.title = json["title"].string
        model.jumpInfoMore = json["jumpInfoMore"].string
        if let list = json["iconImgDTOList"].arrayObject {
            model.iconImgDTOList = (list as NSArray).mapToObjectArray(HomeBrandDetailModel.self)
        }
        return model
    }
}
