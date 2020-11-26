//
//  SerachFactorysInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2018/7/12.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class SerachFactorysInfoModel: NSObject, JSONAbleType {
    var factoryName : String?
    var factoryId : Int?
    var isSelected : Bool?
    init(factoryId: Int?, factoryName: String?) {
        super.init()
        self.factoryId = factoryId
        self.factoryName = factoryName
        self.isSelected = false
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> SerachFactorysInfoModel {
        let j = JSON(json)
        let factoryName = j["factoryName"].stringValue
        let factoryId = j["factoryId"].intValue
        return SerachFactorysInfoModel(factoryId: factoryId, factoryName: factoryName)
    }
}

final class SerachSellersInfoModel: NSObject, JSONAbleType {
    var sellerName : String?
    var sellerCode: Int?
    var isSelected : Bool?
    
    init(sellerCode: Int?, sellerName: String?) {
        super.init()
        self.sellerCode = sellerCode
        self.sellerName = sellerName
        self.isSelected = false
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> SerachSellersInfoModel {
        let j = JSON(json)
        let sellerName = j["sellerName"].stringValue
        let sellerCode = j["sellerCode"].intValue
        return SerachSellersInfoModel(sellerCode: sellerCode, sellerName: sellerName)
    }
}

final class SerachRankInfoModel: NSObject, JSONAbleType {
    var rankName : String?//规格名称
    var rankCode: String?
    var isSelected : Bool?
    
    init(rankName: String?, rankCode: String?) {
        super.init()
        self.rankName = rankName
        self.rankCode = rankCode
        self.isSelected = false
    }
    static func fromJSON(_ json: [String : AnyObject]) -> SerachRankInfoModel {
        let j = JSON(json)
        let rankName = j["name"].stringValue
        let rankCode = j["count"].stringValue
        return SerachRankInfoModel(rankName: rankName, rankCode: rankCode)
    }
}
