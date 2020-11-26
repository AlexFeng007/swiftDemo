//
//  HomePublicNoticeModel.swift
//  FKY
//
//  Created by hui on 2018/6/29.
//  Copyright © 2018年 yiyaowang. All rights reserved.
// (首页)公告视图model

import UIKit
import SwiftyJSON

final class HomePublicNoticeModel: NSObject,JSONAbleType {
    // 接口返回字段
    var ycNotice: [HomePublicNoticeItemModel]?   // 公告列表
    // 本地新增业务逻辑字段
    var pageIndex: Int = 0                      // 当前页面索引
    
    init(ycNotice: [HomePublicNoticeItemModel]?) {
        self.ycNotice = ycNotice
    }
    
    // 数据解析
    static func fromJSON(_ json: [String : AnyObject]) -> HomePublicNoticeModel {
        let j = JSON(json)
        var ycNotice: [HomePublicNoticeItemModel]?
        if let list = j["ycNotice"].arrayObject {
            ycNotice = (list as NSArray).mapToObjectArray(HomePublicNoticeItemModel.self)
        }
        
        return HomePublicNoticeModel(ycNotice: ycNotice)
    }
}

extension HomePublicNoticeModel: HomeModelInterface {
    func floorIdentifier() -> String {
        return "HomePublicNoticeCell"
    }
}


//药城公告模型
final class HomePublicNoticeItemModel: NSObject, JSONAbleType {
    var jumpInfo: String?       // 跳转内容（根据jumpType来确定跳转操作的类型） 1-空 2-商品spucode 4-店铺id 5-活动url
    var type: Int?              // 楼层类型
    var siteCode: String?       // 分站编码
    var id: Int?              //  活动id
    var jumpType: Int?          // 跳转类型 1-未选择 2-商品详情页 4-店铺主页 5-活动链接
    var name: String?           // 活动名称
    var title: String?      // 标题
    var jumpExpandTwo: String? //供应商id
    
    init(id: Int?, jumpInfo: String?, jumpType: Int?, name: String?, siteCode: String?, type: Int?, title: String?,jumpExpandTwo: String?) {
        self.id = id
        self.jumpInfo = jumpInfo
        self.jumpType = jumpType
        self.name = name
        self.siteCode = siteCode
        self.type = type
        self.title = title
        self.jumpExpandTwo = jumpExpandTwo
    }
    
    // dic转model
    static func fromJSON(_ json: [String : AnyObject]) -> HomePublicNoticeItemModel {
        let json = JSON(json)
        
        let id = json["id"].intValue
        let jumpInfo = json["jumpInfo"].stringValue
        let jumpType = json["jumpType"].intValue
        let name = json["name"].stringValue
        let siteCode = json["siteCode"].stringValue
        let type = json["type"].intValue
        let title = json["title"].stringValue
        let jumpExpandTwo = json["jumpExpandTwo"].stringValue

        return HomePublicNoticeItemModel(id: id,jumpInfo: jumpInfo, jumpType: jumpType, name: name, siteCode: siteCode, type: type, title: title,jumpExpandTwo:jumpExpandTwo)
    }
}

