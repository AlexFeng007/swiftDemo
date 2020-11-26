//
//  HomeSuppliersSelectModel.swift
//  FKY
//
//  Created by zengyao on 2018/2/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
 shopList:
     enterpriseId:企业编号
     logo:图标
     productCount:销售数量
     shopBannerUrl:店铺首页跳转连接
     shopName:供应商名称
 
 masterShop:
     enterpriseId:企业编号
     logo:图标
     productCount:销售数量
     shopBannerUrl:店铺首页跳转连接
     shopName:供应商名称
     products:店铺商品列表
 */

final class HomeSuppliersSelectModel: NSObject,JSONAbleType {
    // MARK: - properties
    var shopList: [HomeSuppliersShopItemModel]?
    var masterShop: HomeSuppliersShopItemModel?
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeSuppliersSelectModel {
        let json = JSON(json)
        let masterShop = (json["masterShop"].dictionaryObject! as NSDictionary).mapToObject(HomeSuppliersShopItemModel.self) as HomeSuppliersShopItemModel?
        let shopList = (json["shopList"].arrayObject! as NSArray).mapToObjectArray(HomeSuppliersShopItemModel.self) as [HomeSuppliersShopItemModel]?
        return HomeSuppliersSelectModel(shopList: shopList, masterShop: masterShop)
    }
    
    init(shopList: [HomeSuppliersShopItemModel]?, masterShop: HomeSuppliersShopItemModel?) {
        super.init()
        self.shopList = shopList
        self.masterShop = masterShop
    }
}

//extension HomeSuppliersSelectModel: HomeModelInterface {
//    func floorIdentifier() -> String {
//        return "HomeSuppliersSelectCell"
//    }
//}


final class HomeSuppliersShopItemModel: NSObject, JSONAbleType {
    // MARK: - properties
    var enterpriseId: String?
    var logo: String?
    var productCount:Int?
    var shopBannerUrl:String?
    var products:[HomeSuppliersProductItemModel]?
    var shopName:String?
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeSuppliersShopItemModel {
        let json = JSON(json)
        let enterpriseId = json["enterpriseId"].stringValue
        let logo = json["logo"].stringValue
        let shopBannerUrl = json["shopBannerUrl"].stringValue
        let shopName = json["shopName"].stringValue
        let productCount = json["productCount"].intValue
//        let products = (json["products"].arrayObject! as NSArray).mapToObjectArray(HomeSuppliersProductItemModel.self) as [HomeSuppliersProductItemModel]?
        
        var products: [HomeSuppliersProductItemModel]?
        if let list = json["products"].arrayObject {
            products = (list as NSArray).mapToObjectArray(HomeSuppliersProductItemModel.self)
        }
        
        return HomeSuppliersShopItemModel(enterpriseId: enterpriseId, logo: logo, shopBannerUrl: shopBannerUrl, shopName: shopName, productCount: productCount, products: products)
    }
    
    init(enterpriseId: String?, logo: String?, shopBannerUrl: String?, shopName: String?, productCount: Int?, products: [HomeSuppliersProductItemModel]?) {
        super.init()
        self.enterpriseId = enterpriseId
        self.logo = logo
        self.shopBannerUrl = shopBannerUrl
        self.shopName = shopName
        self.productCount = productCount
        self.products = products
    }
}

final class HomeSuppliersProductItemModel: NSObject, JSONAbleType {
    var productPicUrl: String?
    var productName: String?
    var productId: String?
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeSuppliersProductItemModel {
        let json = JSON(json)
        let productPicUrl = json["productPicUrl"].stringValue
        let productName = json["productName"].stringValue
        let productId = json["productId"].stringValue
        
        return HomeSuppliersProductItemModel(productPicUrl: productPicUrl, productName: productName, productId: productId)
    }
    
    init(productPicUrl: String?, productName: String?, productId: String?) {
        super.init()
        self.productPicUrl = productPicUrl
        self.productName = productName
        self.productId = productId
    }
}


