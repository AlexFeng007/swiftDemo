//
//  ShopListMajorActivityModel.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/28.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  大型活动

import SwiftyJSON

final class ShopListMajorActivityModel: NSObject, JSONAbleType {
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
    var showSequence:Int = 1 // 列表中第几个活动 自定义字段
    static func fromJSON(_ json: [String : AnyObject]) -> ShopListMajorActivityModel {
        let jsonss = JSON(json)
        let jsonArr = jsonss["majorActivity"].arrayValue
        
        let model = ShopListMajorActivityModel()
        if jsonArr.count > 0 {
            let json = jsonArr[0]
            
            model.jumpInfo = json["jumpInfo"].stringValue
            model.jumpExpandOne = json["jumpExpandOne"].stringValue
            model.jumpExpandTwo = json["jumpExpandTwo"].stringValue
            model.jumpExpandThree = json["jumpExpandThree"].stringValue
            model.siteCode = json["siteCode"].stringValue
            model.id = json["id"].stringValue
            model.imgPath = json["imgPath"].stringValue
            model.name = json["name"].stringValue
            model.jumpType = json["jumpType"].intValue
            model.type = json["type"].intValue
        }
        return model
    }
}

extension ShopListMajorActivityModel: ShopListModelInterface {
    func floorCellIdentifier() -> String {
        return "ShopListMajorActivityCell"
    }
}
