//
//  FKYHotSaleModel.swift
//  FKY
//
//  Created by yyc on 2020/3/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

//热销榜商品
@objc final class FKYHotSaleModel: NSObject, JSONAbleType {
    var allPages : Int? //页数总数
    var newProductArr:[ShopProductCellModel]? //热销商品列表
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYHotSaleModel {
        let json = JSON(json)
        let pageInfo = json["pageInfo"]
        let model = FKYHotSaleModel()
        model.allPages = pageInfo["paginator"]["totalPages"].intValue
        if let list = pageInfo["data"].arrayObject {
            model.newProductArr = (list as NSArray).mapToObjectArray(ShopProductCellModel.self)
        }
        return model
    }
}
