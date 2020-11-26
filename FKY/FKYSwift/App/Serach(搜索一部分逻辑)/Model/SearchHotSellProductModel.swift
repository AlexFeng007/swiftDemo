//
//  SearchHotSellProductModel.swift
//  FKY
//
//  Created by 寒山 on 2020/3/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc final class SearchHotSellProductModel: NSObject,JSONAbleType {
    var logoPic:String? // ： 店铺logo
    var enterpriseId:String? //  店铺id
    var enterpriseName:String? //  店铺名
    var sendThreshold:String? //  起送门槛
    var freeShippingThreshold:String? //  包邮门槛
    var isSelfShop: Int?   // 1 自营，0 非自营
    var storeName:String? //  仓库名称
    @objc static func fromJSON(_ json: [String : AnyObject]) ->SearchHotSellProductModel {
        let json = JSON(json)
        let model = SearchHotSellProductModel()
        model.logoPic = json["logoPic"].stringValue
        model.enterpriseId = json["enterpriseId"].stringValue
        model.enterpriseName = json["enterpriseName"].stringValue
        model.sendThreshold = json["sendThreshold"].stringValue
        model.freeShippingThreshold = json["freeShippingThreshold"].stringValue
        model.storeName = json["storeName"].stringValue
        model.isSelfShop = json["isSelfShop"].intValue
        return model
    }
}
