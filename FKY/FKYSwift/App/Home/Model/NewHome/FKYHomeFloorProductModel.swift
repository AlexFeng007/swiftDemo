//
//  FKYHomeFloorProductModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/8/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

final class FKYHomeFloorProductModel: NSObject ,HandyJSON,JSONAbleType{
    
    /// 所有数值类型的属性默认值都为-199为无意义的默认值。
    required override init() { }
    var batchNo : String = ""
    var currentBuyNum : Int = -199
    var dinnerPrice : Double = -199
    var discountMoney : Double = -199
    var doorsill : Int = -199
    var expiryDate : String = ""
    var factoryName : String = ""
    var imgPath : String = ""
    var isMainProduct : Int = -199
    var maxBuyNum : Int = -199
    var miniPackage : Int = -199
    var packageUnit : String = ""
    var price : Double = -199
    var productInventory : String = ""
    var productName : String = ""
    var productionTime : String = ""
    var promotionId : String = ""
    var shortName : String = ""
    var singleCanBuy : Int = -199
    var spec : String = ""
    var spuCode : String = ""
    var statusDesc : Int = -199
    var supplyId : String = ""
    
    static func fromJSON(_ json: [String : AnyObject]) -> FKYHomeFloorProductModel{
        let json = JSON(json)
        let model = FKYHomeFloorProductModel()
        
        model.batchNo = json["batchNo"].stringValue
        model.currentBuyNum = json["currentBuyNum"].intValue
        model.dinnerPrice = json["dinnerPrice"].doubleValue
        model.discountMoney = json["discountMoney"].doubleValue
        model.doorsill = json["doorsill"].intValue
        model.expiryDate = json["expiryDate"].stringValue
        model.factoryName = json["factoryName"].stringValue
        model.imgPath = json["imgPath"].stringValue
        model.isMainProduct = json["isMainProduct"].intValue
        model.maxBuyNum = json["maxBuyNum"].intValue
        model.miniPackage = json["miniPackage"].intValue
        model.packageUnit = json["packageUnit"].stringValue
        model.price = json["price"].doubleValue
        model.productInventory = json["productInventory"].stringValue
        model.productName = json["productName"].stringValue
        model.productionTime = json["productionTime"].stringValue
        model.promotionId = json["promotionId"].stringValue
        model.shortName = json["shortName"].stringValue
        model.singleCanBuy = json["singleCanBuy"].intValue
        model.spec = json["spec"].stringValue
        model.spuCode = json["spuCode"].stringValue
        model.statusDesc = json["statusDesc"].intValue
        model.supplyId = json["supplyId"].stringValue
        
        return model
    }
}
