//
//  FKYProductModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/24.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYProductModel: NSObject, HandyJSON {
    //MARK: - 未备注释的字段代表后台返回了，但是接口文档没有注释
    required override init() { }
    /// 批号
    var batchNo: String = ""
    /// 库存 后台命名错误 实际库存不要用这个
    var currentBuyNum: String = ""

    var deadLine: String = ""
    
    /// 当前套餐内该商品的售卖价格（优惠价）
    var dinnerPrice:Double = 0
    /// 折扣价格
    var discountMoney: Double = 0
    /// 门槛
    var doorsill: Int = 0
    /// 效期
    var expireDate: String = ""

    var factoryId: String = ""
    /// 生产厂家
    var factoryName: String = ""
    /// 商品图片
    var filePath: String = ""
    /// 是否是主品 1是主品
    var isMainProduct: Int = 0
    /// 限购数量
    var maxBuyNum: Int = 0
    /// 每日限购数量
    var maxBuyNumPerDay:Int = 0
    /// 最小拆零包装
    var minimumPacking: Int = 0
    /// 原价
    var originalPrice: Double = 0
    
    var productId: String = ""
    /// 商品名称
    var productName: String = ""
    /// 商品编码
    var productcodeCompany: String = ""
    /// 生产日期
    var productionDate: String = ""

    var productionTime: String = ""
    /// 活动id
    var promotionId: String = ""
    
    var shareStockDesc: String = ""
    
    var shortName: String = ""
    /// 能否单独购买  0可以  1不可以
    var singleCanBuy: Int = 0
    
    var sortNum: String = ""
    /// 规格
    var spec: String = ""
    /// spuCode
    var spuCode: String = ""
    /// 库存
    var stockCount: Int = 0
    
    var stockIsLocal: String = ""
    
    var stockToDays: String = ""
    
    var stockToFromWarhouseId: String = ""
    
    var stockToFromWarhouseName: String = ""
    /// 供应商ID
    var supplyId: Int = 0
    /// 单位
    var unitName: String = ""
    /// 周限购数量
    var weekLimitNum: Int = 0
    
    //MARK: - 以下属性为本地属性，非后台返回
    /// 准备购买的数量（只是更改了数量，还未加车，也可能和加车的数量一致）
    var preBuyNum = 0
    /// 此商品是否被选中 默认全部选中
    var isSelected = true
    /// 是否已经达到了最小购买量
    var isMinimumBuyNum:Bool = false
    /// 是否已经达到了最大购买量
    var isMaximumBuyNum:Bool = false
}
