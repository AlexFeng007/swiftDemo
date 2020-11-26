//
//  HomeAdWelfareModel.swift
//  FKY
//
//  Created by zengyao on 2018/2/24.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
 name:名称
 siteCode:分站编码
 imgPath:图片
 url:url链接
 jumpInfo:根据类型1为空，2商品supcode，3类目编码，4店铺id，5活动url
 jumpExpandOne:跳转内容扩展，2商品通用名，3关键字
 jumpExpandTwo:跳转内容扩展，2商品供应商id
 jumpExpandThree:跳转内容扩展，2商品供应商名称
 jumpType:跳转类型
         1未选择
         2商品详情页 jumpInfo为商品supcode，jumpExpandOne为商品名称， jumpExpandTwo为商品供应商id，jumpExpandThree为供应商名称
         3搜索详情页 jumpInfo类目编码，jumpExpandOne为关键字，这两个属性不会同时存在
         4店铺主页 jumpInfo店铺id
         5活动链接 jumpInfo活动url
 */

final class HomeAdWelfareModel: NSObject ,JSONAbleType{
    
    // MARK: - properties
    var type: Int?
    var jumpType: Int?
    var jumpInfo:String?
    var jumpExpandOne:String?       // 跳转内容扩展 2-商品通用名 3-关键字
    var jumpExpandTwo: String?      // 跳转内容扩展 2-商品供应商id
    var jumpExpandThree: String?    // 跳转内容扩展 2-商品供应商名称
    var siteCode:String?
    var id:String?
    var imgPath:String?
    var name:String?
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeAdWelfareModel {
        let json = JSON(json)
        let jumpInfo = json["jumpInfo"].stringValue
        let jumpExpandOne = json["jumpExpandOne"].stringValue
        let jumpExpandTwo = json["jumpExpandTwo"].stringValue
        let jumpExpandThree = json["jumpExpandThree"].stringValue
        let siteCode = json["siteCode"].stringValue
        let id = json["id"].stringValue
        let imgPath = json["imgPath"].stringValue
        let name = json["name"].stringValue
        let jumpType = json["jumpType"].intValue
        let type = json["type"].intValue
        
        return HomeAdWelfareModel(type: type, jumpType: jumpType, jumpInfo: jumpInfo, jumpExpandOne: jumpExpandOne,jumpExpandTwo: jumpExpandTwo,jumpExpandThree: jumpExpandThree, siteCode: siteCode, id: id, imgPath: imgPath, name: name)
    }
    
    init(type: Int?, jumpType: Int?, jumpInfo: String?, jumpExpandOne: String?,jumpExpandTwo: String?,jumpExpandThree: String?, siteCode: String?, id: String?, imgPath: String?, name: String?) {
        super.init()
        self.type = type
        self.jumpType = jumpType
        self.jumpInfo = jumpInfo
        self.jumpExpandOne = jumpExpandOne
        self.jumpExpandTwo = jumpExpandTwo
        self.jumpExpandThree = jumpExpandThree
        self.siteCode = siteCode
        self.id = id
        self.imgPath = imgPath
        self.name = name
        
    }
}

//extension HomeAdWelfareModel: HomeModelInterface {
//    func floorIdentifier() -> String {
//        return "HomeAdWelfareCell"
//    }
//}


