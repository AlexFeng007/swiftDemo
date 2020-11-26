//
//  FKYHomePageV3PackageModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/27.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  套餐 搭配套餐 固定套餐

import UIKit
import HandyJSON
class FKYHomePageV3PackageModel: NSObject,HandyJSON {
    override required init() {}
    
    /// 当前套餐中的商品列表
    var productList:[FKYHomePageV3FloorProductModel] = [FKYHomePageV3FloorProductModel]()
    
    /// 不知道什么意思或代表什么或用到哪里 所有可选类型都是未知的数据类型，如果后期开发中，明确字段用法，请务必赋默认值
    var areaType:Int = -199
    var beginTime:String = ""
    var dinnerDiscountMoney:Double = -199.0
    var dinnerMinBuyNum:Int = -199
    var dinnerOriginPrice:Double = -199.0
    var dinnerPrice:Double = -199.0
    var endTime:String = ""
    var enterpriseId:String = ""
    var fixedPriceFlag:Int = -199
    var maxBuyNum:Int = -199
    var maxBuyNumPerDay:Int = -199
    var promotionId:Int = -199
    var promotionName:String = ""
    var promotionRule:Int = -199
    var useDesc:String = ""
}
