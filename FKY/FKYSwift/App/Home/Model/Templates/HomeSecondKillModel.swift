//
//  HomeSecondKillModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/8/19.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import SwiftyJSON

final class HomeSecondKillModel: NSObject, JSONAbleType {
    // 接口返回字段
    var id: Int?                    //
    var type: Int?                  //
    var jumpInfo: String?           //
    var jumpType: Int?              //
    var name: String?               // 楼层标题
    var siteCode: String?           //
    var downTime: String?           //
    var upTime: String?             //
    var title: String?              //
    var sysTimeMillis: Int64?       // 系统当前时间戳
    var createTime: String?         //
    var upTimeMillis: Int64?        // 起始时间戳
    var indexMobileId: Int?         //
    var promotionId: Int?           //
    var countDownFlag: Int?         // 是否显示倒计时，1-显示；0-不显示；
    var posIndex: Int?              //
    var originalPriceFlag: Int?     // 是否显示原价，1-显示；0-不显示；
    var createUser: String?         //
    var downTimeMillis: Int64?      // 截止时间戳
    var iconImgPath: String?        // 左上角图标地址...<eg:秒杀icon>
    var holdTime: String?           //
    var imgPath: String?            //
    var indexFloor: String?         //
    var skipFlag: String?           //
    var url: String?                //
    var jumpExpandOne: String?      //
    var jumpExpandTwo: String?      //
    var jumpExpandThree: String?    //
    var jumpInfoMore: String?       // 更多链接
    var floorProductDtos: [HomeRecommendProductItemModel]? // 商品列表 floorProductDtos
    
    // 自定义字段...<用于判断当前楼层数据是否是刷新后的新数据>...[false:新刷新的数据，第一次展示；true:之前就已经获取的老数据，cell重用]
    var hasShowFloor: Bool = false
    
    
    init(floorProductDtos: [HomeRecommendProductItemModel]?) {
        self.floorProductDtos = floorProductDtos
    }
    
    // 数据解析
    static func fromJSON(_ json: [String : AnyObject]) -> HomeSecondKillModel {
        let json = JSON(json)
        
        let id = json["id"].intValue
        let type = json["type"].intValue
        let jumpInfo = json["jumpInfo"].stringValue
        let jumpType = json["jumpType"].intValue
        let name = json["name"].stringValue
        let siteCode = json["siteCode"].stringValue
        let downTime = json["downTime"].stringValue
        let upTime = json["upTime"].stringValue
        let title = json["title"].stringValue
        let sysTimeMillis = json["sysTimeMillis"].int64Value
        let createTime = json["createTime"].stringValue
        let upTimeMillis = json["upTimeMillis"].int64Value
        let indexMobileId = json["indexMobileId"].intValue
        let promotionId = json["promotionId"].intValue
        let countDownFlag = json["countDownFlag"].intValue
        let posIndex = json["posIndex"].intValue
        let originalPriceFlag = json["originalPriceFlag"].intValue
        let createUser = json["createUser"].stringValue
        let downTimeMillis = json["downTimeMillis"].int64Value
        let iconImgPath = json["iconImgPath"].stringValue
        let holdTime = json["holdTime"].stringValue
        let imgPath = json["imgPath"].stringValue
        let indexFloor = json["indexFloor"].stringValue
        let skipFlag = json["skipFlag"].stringValue
        let url = json["url"].stringValue
        let jumpExpandOne = json["jumpExpandOne"].stringValue
        let jumpExpandTwo = json["jumpExpandTwo"].stringValue
        let jumpExpandThree = json["jumpExpandThree"].stringValue
        let jumpInfoMore = json["jumpInfoMore"].stringValue
        
        var floorProductDtos: [HomeRecommendProductItemModel]?
        if let list = json["floorProductDtos"].arrayObject {
            floorProductDtos = (list as NSArray).mapToObjectArray(HomeRecommendProductItemModel.self)
        }
        
        let model = HomeSecondKillModel(floorProductDtos: floorProductDtos)
        model.id = id
        model.type = type
        model.jumpInfo = jumpInfo
        model.jumpType = jumpType
        model.name = name
        model.siteCode = siteCode
        model.downTime = downTime
        model.upTime = upTime
        model.title = title
        model.sysTimeMillis = sysTimeMillis
        model.createTime = createTime
        model.upTimeMillis = upTimeMillis
        model.indexMobileId = indexMobileId
        model.promotionId = promotionId
        model.countDownFlag = countDownFlag
        model.posIndex = posIndex
        model.originalPriceFlag = originalPriceFlag
        model.createUser = createUser
        model.downTimeMillis = downTimeMillis
        model.iconImgPath = iconImgPath
        model.holdTime = holdTime
        model.imgPath = imgPath
        model.indexFloor = indexFloor
        model.skipFlag = skipFlag
        model.url = url
        model.jumpExpandOne = jumpExpandOne
        model.jumpExpandTwo = jumpExpandTwo
        model.jumpExpandThree = jumpExpandThree
        model.jumpInfoMore = jumpInfoMore
        return model
    }
}

//extension HomeSecondKillModel: HomeModelInterface {
//    func floorIdentifier() -> String {
//        return "HomeSecondKillCell"
//    }
//}
