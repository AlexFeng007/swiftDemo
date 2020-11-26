//
//  ShopMaterialModel.swift
//  FKY
//
//  Created by yangyouyong on 2016/9/18.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SwiftyJSON

final class ShopMaterialModel: JSONAbleType {
    var itemName: String?
    var imgUrl: String?
    
    init(itemName: String? ,imgUrl: String?) {
        self.itemName = itemName
        self.imgUrl = imgUrl
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> ShopMaterialModel {
        let j = JSON(json)
        let itemName = j["schema"].string
        let imgUrl = j["imgUrl"].string
        return ShopMaterialModel(itemName: itemName, imgUrl: imgUrl)
    }
    
}
