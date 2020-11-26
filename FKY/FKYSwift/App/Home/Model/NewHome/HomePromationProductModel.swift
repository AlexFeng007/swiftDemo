//
//  HomePromationProductModel.swift
//  FKY
//
//  Created by 寒山 on 2019/3/22.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

final class HomeSecdKillProductModel: NSObject, JSONAbleType {
    
    var countDownFlag: Int?
    var createTime: String?
    var createUser: String?
    var hotsaleFlag: Int?
    var iconImgPath: Int?
    var indexMobileId: Int?
    var newOrder: Int?
    var oftenBuyFlag: Int?
    var oftenViewFlag: Int?
    var originalPriceFlag: Int?   //只针对秒杀楼层进行判断（1显示，）
    var posIndex: Int?
    var promotionId: Int?  //一起购使用 促销ID
    var showNum: String?  //更多类型的文描
   // var show_num: String?
    
    var floorColor : Int? //楼层头部背景颜色
    var id: Int?
    var type: Int = -199//楼层类型
    var imgPath: String?
    var jumpInfo: String?
    var jumpType: Int? //
    var name: String?  //楼层名字
    var siteCode: Int?  //站点
    var indexFloor: String?
    var jumpExpandOne: String?
    var jumpExpandTwo: String?
    var jumpExpandThree: String?
    var floorProductDtos: [HomeRecommendProductItemModel]? // 商品列表
    var downTime: String?//倒计时时间
    var upTime: String?//倒计时时间
    var downTimeMillis:Int64?//倒计时时间
    var upTimeMillis:Int64? //倒计时时间
    var sysTimeMillis: Int64?       // 系统当前时间戳
    
    var title: String?
    var jumpInfoMore: String? //更多链接
    var togetherMark: Int? // 1 一起购  2一起返 一起
    var showSequence: Int? //第几个品 或者活动
    var disCountDesc: String? //折后价
    var pageTimeStamp: String? //首页请求时间戳
    /// 新加属性
    
    /// 该组件内的套餐列表
    var dinnerVOList:[FKYHomeFloorDinnerModel] = []
    /// 套餐的商家ID
    var dinnerEnterpriseId:String = ""
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeSecdKillProductModel{
        let json = JSON(json)
        let model = HomeSecdKillProductModel()
        
        model.countDownFlag = json["countDownFlag"].intValue
        model.createTime = json["createTime"].string
        model.createUser = json["createUser"].string
        model.hotsaleFlag = json["hotsaleFlag"].intValue
        model.iconImgPath = json["iconImgPath"].intValue
        model.indexMobileId = json["indexMobileIde"].intValue
        model.newOrder = json["newOrder"].intValue
        model.oftenBuyFlag = json["oftenBuyFlage"].intValue
        model.oftenViewFlag = json["oftenViewFlag"].intValue
        model.originalPriceFlag = json["originalPriceFlag"].intValue
        model.posIndex = json["posIndex"].intValue
        model.promotionId = json["promotionId"].intValue
        model.showNum = json["showNum"].string
        //model.show_num = json["show_num"].string
        model.showSequence = json["showSequence"].intValue
        model.pageTimeStamp = json["pageTimeStamp"].string
        model.floorColor = json["floorColor"].intValue
        model.id = json["id"].intValue
        model.type = json["type"].intValue
        model.imgPath = json["imgPath"].string
        model.jumpInfo = json["jumpInfo"].string
        
        model.togetherMark = json["togetherMark"].intValue
        model.jumpType = json["jumpType"].intValue
        model.name = json["name"].string
        model.siteCode = json["siteCode"].intValue
        model.indexFloor = json["indexFloor"].string
        model.jumpExpandOne = json["jumpExpandOne"].string
        model.jumpExpandTwo = json["jumpExpandTwo"].string
        model.jumpExpandThree = json["jumpExpandThree"].string
        if let list = json["floorProductDtos"].arrayObject {
            model.floorProductDtos = (list as NSArray).mapToObjectArray(HomeRecommendProductItemModel.self)
        }
        
        //兼容店铺馆中首页的药城精选(3*2)
        if let list = json["mpHomeProductDtos"].arrayObject ,list.count > 0 {
            model.floorProductDtos = (list as NSArray).mapToObjectArray(HomeRecommendProductItemModel.self)
        }
       
        model.downTimeMillis = json["downTimeMillis"].int64Value
        model.upTimeMillis = json["upTimeMillis"].int64Value
        model.sysTimeMillis = json["sysTimeMillis"].int64Value
        model.downTime = json["downTime"].string
        model.upTime = json["upTime"].string
        model.title = json["title"].string
        model.jumpInfoMore = json["jumpInfoMore"].string
        model.disCountDesc = json["disCountDesc"].string
        model.dinnerEnterpriseId = json["dinnerEnterpriseId"].stringValue
        if let dinnerVOListList = json["dinnerVOList"].arrayObject {
            model.dinnerVOList = (dinnerVOListList as NSArray).mapToObjectArray(FKYHomeFloorDinnerModel.self) ?? [FKYHomeFloorDinnerModel]()
        }
        /*
        let dinnerVOListDic = json["dinnerVOList"].arrayObject ?? [Any]()
        model.dinnerVOList = ([FKYHomeFloorDinnerModel].deserialize(from: dinnerVOListDic) as? [FKYHomeFloorDinnerModel]) ?? [FKYHomeFloorDinnerModel]()
         */
        return model
    }
}

