//
//  SearchShopInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2020/3/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc final class SearchShopInfoModel: NSObject,JSONAbleType {
    var logoPic:String? // ： 店铺logo
    var enterpriseId:String? //  店铺id
    var enterpriseName:String? //  店铺名
    var sendThreshold:String? //  起送门槛
    var freeShippingThreshold:String? //  包邮门槛
    var isSelfShop: Int?   // 1 自营，0 非自营
    var storeName:String? //  仓库名称
    var shopAdList: HomeCircleBannerModel?  //
    // 接口返回字段
    //if let model = contents?.mapToObject(HomeCircleBannerModel.self)
    @objc static func fromJSON(_ json: [String : AnyObject]) ->SearchShopInfoModel {
        let model = SearchShopInfoModel()
        if let _ = json["freeShippingThreshold"]{
            if let _ = json["freeShippingThreshold"] as? String{
                model.freeShippingThreshold = (json["freeShippingThreshold"] as! String)
            }else{
                model.freeShippingThreshold = nil
            }
        }else{
            model.freeShippingThreshold = nil
        }
        let json = JSON(json)
        model.logoPic = json["logoPic"].stringValue
        model.enterpriseId = json["enterpriseId"].stringValue
        model.enterpriseName = json["enterpriseName"].stringValue
        model.sendThreshold = json["sendThreshold"].stringValue
        model.storeName = json["storeName"].stringValue
        model.isSelfShop = json["isSelfShop"].intValue
        
        let dic = json["shopAdList"].dictionaryObject
        if let _ = dic {
            let t = dic! as NSDictionary
            model.shopAdList = t.mapToObject(HomeCircleBannerModel.self)
        }else{
            model.shopAdList = nil
        }
        
        return model
    }
}
