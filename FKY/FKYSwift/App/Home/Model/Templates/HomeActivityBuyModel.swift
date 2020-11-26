//
//  HomeActivityBuyModel.swift
//  FKY
//
//  Created by zengyao on 2018/2/23.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

//一起系列数据模型
final class HomeActivityBuyModel: NSObject, JSONAbleType {
    // MARK: - properties
   
    
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
    var title: String?
    var jumpInfoMore: String? //更多链接
    var togetherMark: Int? // 1 一起购  2一起返 一起闪
    static func fromJSON(_ json: [String : AnyObject]) -> HomeActivityBuyModel {
        let json = JSON(json)
        let id = json["id"].intValue
        let type = json["type"].intValue
        let imgPath = json["imgPath"].string
        let jumpInfo = json["jumpInfo"].string
        
        let togetherMark = json["togetherMark"].intValue
        let jumpType = json["jumpType"].intValue
        let name = json["name"].string
        let siteCode = json["siteCode"].intValue
        let indexFloor = json["indexFloor"].string
        let jumpExpandOne = json["jumpExpandOne"].string
        let jumpExpandTwo = json["jumpExpandTwo"].string
        let jumpExpandThree = json["jumpExpandThree"].string
        var floorProductDtos: [HomeRecommendProductItemModel]?
        if let list = json["floorProductDtos"].arrayObject {
            floorProductDtos = (list as NSArray).mapToObjectArray(HomeRecommendProductItemModel.self)
        }
        let downTime = json["downTime"].string
        let upTime = json["upTime"].string
        let title = json["title"].string
        let jumpInfoMore = json["jumpInfoMore"].string
        
      
        return HomeActivityBuyModel(id: id,type: type,imgPath: imgPath,jumpInfo: jumpInfo,jumpType: jumpType,name: name,siteCode: siteCode,indexFloor: indexFloor,jumpExpandOne: jumpExpandOne,jumpExpandTwo: jumpExpandTwo,jumpExpandThree: jumpExpandThree,floorProductDtos: floorProductDtos,downTime: downTime,upTime: upTime,title:title,jumpInfoMore: jumpInfoMore,togetherMark: togetherMark)
    }
    
    init(id: Int?,type: Int?,imgPath: String?,jumpInfo: String?,jumpType: Int?,name: String?,siteCode: Int?,indexFloor: String?,jumpExpandOne: String?,jumpExpandTwo: String?,jumpExpandThree: String?,floorProductDtos: [HomeRecommendProductItemModel]?,downTime: String?,upTime: String?,title: String?,jumpInfoMore: String?,togetherMark: Int?) {
        super.init()
        self.id = id
        self.imgPath = imgPath
        self.jumpInfo = jumpInfo
        self.jumpType = jumpType
        self.name = name
        self.siteCode = siteCode
        self.indexFloor = indexFloor
        self.jumpExpandOne = jumpExpandOne
        self.jumpExpandTwo = jumpExpandTwo
        self.jumpExpandThree = jumpExpandThree
        self.floorProductDtos = floorProductDtos
        self.downTime = downTime
        self.upTime = upTime
        self.title = title
        self.jumpInfoMore = jumpInfoMore
        self.togetherMark = togetherMark
    }
}

//extension HomeActivityBuyModel: HomeModelInterface {
//    func floorIdentifier() -> String {
//        return "HomeActivityPattermCell"
//    }
//}


final class HomeActivityBuyItemModel: NSObject,JSONAbleType {
    // MARK: - properties
    var jumptype: Int?
    var floorname:String?
    var jumplink:String?
    var showpic:String?
    var showprice:String?
    var futitle:String?
    var showgood:String?
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeActivityBuyItemModel {
        let json = JSON(json)
        let floorname = json["floorname"].stringValue
        let jumplink = json["jumplink"].stringValue
        let showpic = json["showpic"].stringValue
        let showprice = json["showprice"].stringValue
        let futitle = json["futitle"].stringValue
        let showgood = json["showgood"].stringValue
        let jumpType = json["jumpType"].intValue
        
        return HomeActivityBuyItemModel(jumpType: jumpType, floorname: floorname, jumplink: jumplink, showpic: showpic, showprice: showprice, futitle: futitle, showgood: showgood)
    }
    
    init(jumpType: Int?, floorname: String?, jumplink: String?, showpic: String?, showprice: String?, futitle: String?, showgood: String?) {
        super.init()
        self.jumptype = jumpType
        self.floorname = floorname
        self.jumplink = jumplink
        self.showpic = showpic
        self.showprice = showprice
        self.futitle = futitle
        self.showgood = showgood
    }
}

