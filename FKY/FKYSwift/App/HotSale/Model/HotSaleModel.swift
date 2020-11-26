//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

import SwiftyJSON

// MARK: - HotSaleModel 对象
final class HotSaleModel: NSObject, JSONAbleType {
    
    // MARK: - properties
    var showpic : String?
    var shortName : String?
    var spec : String?
    var factoryName : String?
    var showPrice: String?
    var spuCode: String?
    var priceFlag: Int? // 区分showPrice是数字还是文字 0 数字  1 文字
    
    // MARK: - life cycle
    static func fromJSON(_ json: [String : AnyObject]) -> HotSaleModel {
        let json = JSON(json)
        
        let showpic = json["showpic"].stringValue
        let shortName = json["shortName"].stringValue
        let spec = json["spec"].stringValue
        let factoryName = json["factoryName"].stringValue
        let showPrice = json["showPrice"].stringValue
        let spuCode = json["spuCode"].stringValue
        let priceFlag = json["priceFlag"].intValue
        return HotSaleModel(showpic: showpic, shortName: shortName, spec: spec, factoryName: factoryName, showPrice: showPrice, spuCode: spuCode, priceFlag: priceFlag)
    }
    
    init(showpic: String?, shortName: String?, spec: String?, factoryName: String?, showPrice: String?, spuCode: String?, priceFlag: Int?) {
        self.showpic = showpic
        self.shortName = shortName
        self.spec = spec
        self.factoryName = factoryName
        self.showPrice = showPrice
        self.spuCode = spuCode
        self.priceFlag = priceFlag
    }
}




