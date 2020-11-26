//
//  FKYHomeFloorDinnerModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/8/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

final class FKYHomeFloorDinnerModel: NSObject ,HandyJSON,JSONAbleType{
    /// 所有数值类型的属性默认值都为-199为无意义的默认值。
    required override init() { }
    var areaType : Int = -199
    var beginTime : String = ""
    var dinnerDiscountMoney : Double = -199
    var dinnerOriginPrice : Double = -199
    var dinnerPrice : Double = -199
    var endTime : String = ""
    var fixedPriceFlag : Int = -199
    var maxBuyNumPerDay : Int = -199
    var productList : [FKYHomeFloorProductModel] = []
    var promotionId : String = ""
    var promotionName : String = ""
    var promotionRule : Int = -199
    var useDesc : String = ""
    
    static func fromJSON(_ json: [String : AnyObject]) -> FKYHomeFloorDinnerModel{
        let json = JSON(json)
        let model = FKYHomeFloorDinnerModel()
        model.areaType = json["areaType"].intValue
        model.beginTime = json["beginTime"].stringValue
        model.dinnerDiscountMoney = json["dinnerDiscountMoney"].doubleValue
        model.dinnerOriginPrice = json["dinnerOriginPrice"].doubleValue
        model.dinnerPrice = json["dinnerPrice"].doubleValue
        model.endTime = json["endTime"].stringValue
        model.fixedPriceFlag = json["fixedPriceFlag"].intValue
        model.maxBuyNumPerDay = json["maxBuyNumPerDay"].intValue
        if let productList = json["productList"].arrayObject {
            model.productList = (productList as NSArray).mapToObjectArray(FKYHomeFloorProductModel.self) ?? [FKYHomeFloorProductModel]()
        }
        //model.productList : [FKYHomeFloorProductModel] = []
        model.promotionId = json["promotionId"].stringValue
        model.promotionName = json["promotionName"].stringValue
        model.promotionRule = json["promotionRule"].intValue
        model.useDesc = json["useDesc"].stringValue
        
        return model
    }
    
}
