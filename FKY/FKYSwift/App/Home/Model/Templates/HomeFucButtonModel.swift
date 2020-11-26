//
//  HomeFucButtonModel.swift
//  FKY
//
//  Created by hui on 2018/6/29.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  (首页)8个按钮model

import UIKit
import SwiftyJSON

final class HomeFucButtonModel: NSObject,JSONAbleType {
    // 接口返回字段
    var navigations: [HomeFucButtonItemModel]?   // 功能按钮
    // 本地新增业务逻辑字段
    var pageIndex: Int = 0                      // 当前页面索引
    
    init(navigations: [HomeFucButtonItemModel]?) {
        self.navigations = navigations
    }
    
    // 数据解析
    static func fromJSON(_ json: [String : AnyObject]) -> HomeFucButtonModel {
        
        let j = JSON(json)
        var navigations = [HomeFucButtonItemModel]()
        if let list = j["Navigation"].arrayObject {
            let desArr = (list as NSArray).mapToObjectArray(HomeFucButtonItemModel.self)
            if let arr = desArr,arr.count > 0 {
                navigations.append(contentsOf: arr)
            }
        }
        return HomeFucButtonModel(navigations: navigations)
    }
}

extension HomeFucButtonModel: HomeModelInterface {
    func floorIdentifier() -> String {
        return "HomeFucButtonCell"
    }
}


//药城导航按钮
final class HomeFucButtonItemModel: NSObject, JSONAbleType {
    var jumpInfo: String?       // 跳转内容（根据jumpType来确定跳转操作的类型） 1-空 2-商品spucode 3-类目编码 4-店铺id 5-活动url
    var jumpType: Int?          // 跳转类型 1-未选择 2-商品详情页 3-搜索详情页 4-店铺主页 5-活动链接
    var imgPath: String?        //图片链接
    var type: Int?              // 楼层类型
    var siteCode: String?       // 分站编码
    var id: Int?              //  活动id
    var name: String?           // 活动名称
    var title: String?      // 标题
    var jumpExpandOne: String?      // 跳转内容扩展 2-商品通用名 3-关键字
    var jumpExpandTwo: String?      // 跳转内容扩展 2-商品供应商id
    var jumpExpandThree: String?    // 跳转内容扩展 2-商品供应商名称
    
    var indexNum = 0 //本地自定义字段
    
    init(id: Int?, jumpInfo: String?, imgPath: String?, name: String?, siteCode: String?, type: Int?, title: String?) {
        self.id = id
        self.jumpInfo = jumpInfo
        self.imgPath = imgPath
        self.name = name
        self.siteCode = siteCode
        self.type = type
        self.title = title
    }
    
    // dic转model
    static func fromJSON(_ json: [String : AnyObject]) -> HomeFucButtonItemModel {
        let json = JSON(json)
        
        let id = json["id"].intValue
        let jumpInfo = json["jumpInfo"].stringValue
        let imgPath = json["imgPath"].string
        let name = json["name"].stringValue
        let siteCode = json["siteCode"].stringValue
        let type = json["type"].intValue
        let title = json["title"].stringValue
        
        let model = HomeFucButtonItemModel(id: id,jumpInfo: jumpInfo, imgPath: imgPath, name: name, siteCode: siteCode, type: type, title: title)
        model.jumpType = json["jumpType"].intValue
        model.jumpExpandOne = json["jumpExpandOne"].stringValue
        model.jumpExpandTwo = json["jumpExpandTwo"].stringValue
        model.jumpExpandThree = json["jumpExpandThree"].stringValue
        return model
    }
}
