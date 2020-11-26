//
//  OftenBuySellerModel.swift
//  FKY
//
//  Created by 路海涛 on 2017/4/21.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  常购商家之商家model

import UIKit
import SwiftyJSON

final class OftenBuySellerModel :NSObject, JSONAbleType {
    var id :String?
    var imgUrl :String?
    var logo :String?
    var orderSamount :String?
    var shopBrandUrl :String?
    var shopName :String?
    var enterpriseId :String?
    
    init(id: String?, imgUrl: String?, logo: String?, orderSamount: String?, shopBrandUrl: String?, shopName: String?, enterpriseId:String?) {
        self.id = id
        self.imgUrl = imgUrl
        self.logo = logo
        self.orderSamount = orderSamount
        self.shopBrandUrl = shopBrandUrl
        self.shopName = shopName
        self.enterpriseId = enterpriseId
    }

    static func fromJSON(_ json: [String : AnyObject]) -> OftenBuySellerModel {
        let json = JSON(json)

        let id = json["id"].stringValue
        let imgUrl = json["imgUrl"].stringValue
        let logo = json["logo"].stringValue
        let orderSamount = json["orderSamount"].stringValue
        let shopBrandUrl = json["shopBrandUrl"].stringValue
        let shopName = json["shopName"].stringValue
        let enterpriseId = json["enterpriseId"].stringValue

        return OftenBuySellerModel(id: id, imgUrl: imgUrl, logo: logo, orderSamount: orderSamount, shopBrandUrl: shopBrandUrl, shopName: shopName, enterpriseId: enterpriseId)
    }
}
