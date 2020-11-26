//
//  ShopProductCatagoryModel.swift
//  FKY
//
//  Created by 寒山 on 2019/11/1.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  全部商品的 活动筛选 和 商品类型 的model

import UIKit

import SwiftyJSON

final class ShopProductCatagoryTypeModel:NSObject, JSONAbleType {
    var category : [FirstShopProductCatagoryModel]?       //商品分类    array<object>
    var config: ShopProductActivityModel?  // 配置分类    object
    static func fromJSON(_ json: [String : AnyObject]) -> ShopProductCatagoryTypeModel {
        let json = JSON(json)
        let model = ShopProductCatagoryTypeModel()
        let array = json["category"].arrayObject
        var list: [FirstShopProductCatagoryModel]? = []
        if let arr = array{
            list = (arr as NSArray).mapToObjectArray(FirstShopProductCatagoryModel.self)
        }
        model.category = list
        let dic = json["config"].dictionaryObject
        if let _ = dic {
            let t = dic! as NSDictionary
            model.config = t.mapToObject(ShopProductActivityModel.self)
        }else{
            model.config = nil
        }
        return model
    }
}
final class ShopProductActivityModel:NSObject, JSONAbleType{
    var configList: [ShopProductActivityItem]?    //配置列表    array<object>
    var configName:String?     //配置名称    string
    static func fromJSON(_ json: [String : AnyObject]) -> ShopProductActivityModel {
        let json = JSON(json)
        let model = ShopProductActivityModel()
        model.configName = json["configName"].stringValue
        let array = json["configList"].arrayObject
        var list: [ShopProductActivityItem]? = []
        if let arr = array{
            list = (arr as NSArray).mapToObjectArray(ShopProductActivityItem.self)
        }
        model.configList = list
        return model
    }
}
final class ShopProductActivityItem:NSObject, JSONAbleType{
    var imgUrl:String?    //图片地址    string
    var mapsUrl:String?   // 跳转连接    string
    var theme:String?    //名称    string
    var promotionType : Int?//活动类型
    var urlType :Int? //链接类型 0：fky链接或者http跳转，1：特价
    static func fromJSON(_ json: [String : AnyObject]) -> ShopProductActivityItem {
        let json = JSON(json)
        let model = ShopProductActivityItem()
        model.imgUrl = json["imgUrl"].stringValue
        model.mapsUrl = json["mapsUrl"].stringValue
        model.theme = json["theme"].stringValue
        model.promotionType = json["promotionType"].intValue
        model.urlType = json["urlType"].intValue
        return model
    }
}
final class FirstShopProductCatagoryModel:NSObject, JSONAbleType {
    var categoryCode:String?   // 一级分类id    string
    var categoryName :String?  // 一级分类名    string
    var secondCategoryList: [ShopProductCatagoryModel]?
    static func fromJSON(_ json: [String : AnyObject]) -> FirstShopProductCatagoryModel {
        let json = JSON(json)
        let model = FirstShopProductCatagoryModel()
        model.categoryCode = json["categoryCode"].stringValue
        model.categoryName = json["categoryName"].stringValue
        let array = json["secondCategoryList"].arrayObject
        var list: [ShopProductCatagoryModel]? = []
        if let arr = array{
            list = (arr as NSArray).mapToObjectArray(ShopProductCatagoryModel.self)
        }
        model.secondCategoryList = list
        return model
    }
}
final class ShopProductCatagoryModel:NSObject, JSONAbleType {
    var categoryCode:String?   // 二级分类id    string
    var categoryName :String?  // 二级分类名    string
    var selectState :Bool = false  //自定义字段判断是否选中
    static func fromJSON(_ json: [String : AnyObject]) -> ShopProductCatagoryModel {
        let json = JSON(json)
        let model = ShopProductCatagoryModel()
        model.categoryCode = json["categoryCode"].stringValue
        model.categoryName = json["categoryName"].stringValue
        return model
    }
}
