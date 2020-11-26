//
//  HomeShopModel.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/30.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SwiftyJSON

final class HomeShopModel: NSObject, JSONAbleType {
    let shopId: Int?
    let shopName: String?
    let imgUrl: String?
    let shopBrandUrl: String?
    let productCount: Int?
    let shop_url : String?
    let xiaoneng_id : String?
    
    init(shopId: Int?,shopName: String?, imgUrl: String?,shopBrandUrl: String?,productCount: Int?, shop_url : String?, xiaoneng_id : String?) {
        self.shopId = shopId
        self.shopName = shopName
        self.imgUrl = imgUrl
        self.shopBrandUrl = shopBrandUrl
        self.productCount = productCount
        self.shop_url = shop_url
        self.xiaoneng_id = xiaoneng_id  
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeShopModel {
        let j = JSON(json)
        var shopId = j["enterpriseId"].intValue
        let shopName = j["shopName"].string
        let imgUrl = j["imgUrl"].string
        var shopBrandUrl = j["logo"].string
        let productCount = j["productCount"].intValue
        let shop_url = j["shop_url"].string
        let xiaoneng_id = j["xiaoneng_id"].string
        // TODO: 王赛改接口
        if shopId == 0 {
            shopId = j["enterprise_id"].intValue
        }
        if shopBrandUrl == nil {
            shopBrandUrl = j["shopBrandUrl"].string
        }
        if shop_url != nil && shop_url!.contains("enterpriseId") && shopId == 0 {
            let index = shop_url!.range(of: "enterpriseId=")
            let enterpriseId = shop_url!.substring(from: (index?.upperBound)!)
            shopId = (enterpriseId as NSString).integerValue
        }
        
        return HomeShopModel(shopId: shopId, shopName: shopName,imgUrl: imgUrl,shopBrandUrl: shopBrandUrl,productCount: productCount, shop_url: shop_url, xiaoneng_id:xiaoneng_id)
    }
}
