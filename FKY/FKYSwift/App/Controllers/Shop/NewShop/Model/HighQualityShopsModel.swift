//
//  HighQualityShopsModel.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/28.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  优质商家

import SwiftyJSON

final class HighQualityShopsModel: NSObject, JSONAbleType {
    // 接口返回字段
    var shops: [HighQualityShopsItemModel]?   // 活动列表

    init(shops: [HighQualityShopsItemModel]?) {
        self.shops = shops
    }
    
    // 数据解析
    static func fromJSON(_ json: [String : AnyObject]) -> HighQualityShopsModel {
        let json = JSON(json)
        
        var shops: [HighQualityShopsItemModel]?
        if let list = json["HighQualityShops"].arrayObject {
            shops = (list as NSArray).mapToObjectArray(HighQualityShopsItemModel.self)
        }
        
        return HighQualityShopsModel(shops: shops)
    }
}

extension HighQualityShopsModel: ShopListModelInterface {
    func floorCellIdentifier() -> String {
        return "HighQualityShopsCell"
    }
}

final class HighQualityShopsItemModel: NSObject, JSONAbleType {
    var id: Int?                // 活动id
    var imgPath: String?        // 图片url
    var jumpInfo: String?       // 跳转内容（根据jumpType来确定跳转操作的类型） 1-空 2-商品spucode 3-类目编码 4-店铺id 5-活动url
    var jumpType: Int?          // 跳转类型 1-未选择 2-商品详情页 3-搜索详情页 4-店铺主页 5-活动链接
    var jumpExpandOne:String?       // 跳转内容扩展 2-商品通用名 3-关键字
    var jumpExpandTwo: String?      // 跳转内容扩展 2-商品供应商id
    var jumpExpandThree: String?    // 跳转内容扩展 2-商品供应商名称
    var jumpInfoMore: String?   // 更多按钮跳转地址
    var name: String?           // 标题
    var siteCode: String?       // 分站编码
    var type: Int?              // 楼层类型
    var title: String?          // 副标题
    static func fromJSON(_ json: [String : AnyObject]) -> HighQualityShopsItemModel {
        let json = JSON(json)
        let model = HighQualityShopsItemModel()
        model.id = json["id"].intValue
        model.imgPath = json["imgPath"].stringValue
        model.jumpInfo = json["jumpInfo"].stringValue
        model.jumpType = json["jumpType"].intValue
        model.jumpInfoMore = json["jumpInfoMore"].stringValue
        model.name = json["name"].stringValue
        model.siteCode = json["siteCode"].stringValue
        model.type = json["type"].intValue
        model.title = json["title"].stringValue
        model.jumpExpandOne = json["jumpExpandOne"].stringValue
        model.jumpExpandTwo = json["jumpExpandTwo"].stringValue
        model.jumpExpandThree = json["jumpExpandThree"].stringValue
        return model
    }
}
