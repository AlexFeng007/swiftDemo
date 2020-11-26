//
//  HomeRecentPurchaseModel.swift
//  FKY
//
//  Created by zengyao on 2018/2/9.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  最近采购

import UIKit
import SwiftyJSON

/*
 productInfos:
     productName:商品名称
     spec:规格
 */

final class HomeRecentPurchaseModel: NSObject, JSONAbleType {
    var productInfos:[HomeRecentPurchaseItemModel]?
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeRecentPurchaseModel {
        let json = JSON(json)
        
        let productInfos = (json["productInfos"].arrayObject! as NSArray).mapToObjectArray(HomeRecentPurchaseItemModel.self) as [HomeRecentPurchaseItemModel]?
        return HomeRecentPurchaseModel(productInfos: productInfos)
    }
    
    init(productInfos: [HomeRecentPurchaseItemModel]?) {
        super.init()
        self.productInfos = productInfos
    }
}

//extension HomeRecentPurchaseModel: HomeModelInterface {
//    func floorIdentifier() -> String {
//        return "HomeRecentPurchaseCell"
//    }
//}


final class HomeRecentPurchaseItemModel: NSObject, JSONAbleType {
    // MARK: - properties
    var productName: String?
    var spec: String?
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeRecentPurchaseItemModel {
        let json = JSON(json)
        let productName = json["productName"].stringValue
        let spec = json["spec"].stringValue
        return HomeRecentPurchaseItemModel(productName:productName, spec: spec)
    }
    
    init(productName: String?, spec: String?) {
        self.productName = productName
        self.spec = spec
    }
}
