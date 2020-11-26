//
//  FKYMacthingPackageModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/24.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON
class FKYMacthingPackageModel: NSObject, HandyJSON {
    //MARK: - 未备注释的字段代表后台返回了，但是接口文档没有注释
    required override init() { }

    /// 套餐优惠多少
    var dinnerDiscountMoney: Float = 0.00
    /// 搭配品最少购买数量限制
    var dinnerMinBuyNum: Int = 0
    /// 套餐原价
    var dinnerOriginPrice: Double = 0
    /// 套餐价
    var dinnerPrice: Double = 0
    /// 此套餐内的商品列表
    var productList: [FKYProductModel] = []
    /// 活动ID
    var promotionId: Int = 0
    /// 活动名称
    var promotionName: String = ""
    /// 活动类型1:搭配套餐
    var promotionRule: Int = 0
    
    var useDesc: String!
    
    var endTime: String = ""
    
    var enterpriseId: String = ""
    
    var fixedPriceFlag: Int = -199
    
    var maxBuyNum: Int = -199
    
    var maxBuyNumPerDay: String = ""
    
    var areaType: Int = -199
    
    var beginTime: String = ""
    
    /// 前端用不到的
    //var promotionAreaList: [AnyObject]!
}
