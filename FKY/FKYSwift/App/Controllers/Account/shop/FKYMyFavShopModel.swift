//
//  FKYMyFavShopModel.swift
//  FKY
//
//  Created by zhangxuewen on 2018/5/23.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class FKYMyFavShopModel :NSObject, JSONAbleType{
 
    var logo :String?
    var shopName :String?
    var enterpriseId :String?
    var type :String? //0普通店铺，1聚宝盘自由市场店铺
    
    init(logo :String?,shopName :String?,enterpriseId :String?,type :String?){
        self.logo  = logo
        self.shopName  = shopName
        self.enterpriseId  = enterpriseId
        self.type = type
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> FKYMyFavShopModel {
        let json = JSON(json)
        let logo  = json["logo"].stringValue
        let shopName  = json["shopName"].stringValue
        let enterpriseId  = json["enterpriseId"].stringValue
        let type = json["type"].stringValue
        
        return FKYMyFavShopModel(logo  : logo  ,shopName  : shopName  ,enterpriseId  : enterpriseId ,type:type)
    }
    
}
