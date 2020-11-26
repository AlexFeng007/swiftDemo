//
//  FKYSecondaryComponentsModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/8/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYSecondaryComponentsModel: NSObject ,HandyJSON{
    /// 所有数值类型的属性默认值都为-199 为无意义的默认值。
    required override init() { }
    var areaType : Int = -199
    var beginTime : String = ""
    var dinnerDiscountMoney : Double = -199
    var dinnerOriginPrice : Double = -199
    var dinnerPrice : Double = -199
    var endTime : String = ""
    var fixedPriceFlag : Double = -199
    /// 套餐列表
    var productList : [FKYHomeFloorDinnerModel] = []
    var promotionId : String = ""
    var promotionName : String = ""
    var promotionRule : Int = -199
    var useDesc : String = ""
}
