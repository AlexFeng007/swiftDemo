//
//  HomeBrandModel.swift
//  FKY
//
//  Created by hui on 2019/7/9.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

//首页品牌推荐楼层
final class HomeBrandModel: NSObject,JSONAbleType {
    var name : String? //头部标题
    var title : String? //副标题
    var showNum : String? //右边提示文字
    var jumpInfoMore : String? //头部跳转链接（更多）
    var floorColor : Int? //楼层上部分标题背景颜色
    var showSequence: Int? //第几个品 或者活动
    var pageTimeStamp: String? //首页请求时间戳
    var iconImgDTOList : [HomeBrandDetailModel]? // 品牌的列表
    static func fromJSON(_ json: [String : AnyObject]) -> HomeBrandModel{
        let json = JSON(json)
        let model = HomeBrandModel()
        model.floorColor = json["floorColor"].intValue
        model.name = json["name"].stringValue
        model.jumpInfoMore = json["jumpInfoMore"].stringValue
        model.title = json["title"].stringValue
        model.showNum = json["showNum"].stringValue
        model.showSequence = json["showSequence"].intValue
        if let list = json["iconImgDTOList"].arrayObject {
            model.iconImgDTOList = (list as NSArray).mapToObjectArray(HomeBrandDetailModel.self)
        }
        return model
    }
}
//首页品牌模型
final class HomeBrandDetailModel: NSObject,JSONAbleType {
    var imgName : String? //品牌名称
    var imgPath : String? //品牌图片
    var jumpInfo : String? //品牌跳转链接
    static func fromJSON(_ json: [String : AnyObject]) -> HomeBrandDetailModel{
        let json = JSON(json)
        let model = HomeBrandDetailModel()
        model.imgName = json["imgName"].stringValue
        model.imgPath = json["imgPath"].stringValue
        model.jumpInfo = json["jumpInfo"].stringValue
        return model
    }
}
