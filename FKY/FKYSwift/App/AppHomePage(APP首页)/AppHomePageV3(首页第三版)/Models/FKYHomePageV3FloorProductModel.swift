//
//  FKYHomePageV3FloorProductModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/22.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  豆腐块中的商品model

import UIKit
import HandyJSON
class FKYHomePageV3FloorProductModel: NSObject,HandyJSON {

    override required init() {    }
    
    /// 生产厂家
    var factoryName:String = ""
    /// 商品主图
    var imgPath:String = ""
    /// 商品ID
    var productId:String = ""
    /// 商品名称
    var productName:String = ""
    /// 商品价格
    var productPrice:Double = -199.0
    /// 商品规格
    var productSpec:String = ""
    /// 供应商ID
    var productSupplyId:String = ""
    /// 供应商名称
    var productSupplyName:String = ""
    /// 商品简称
    var shortName:String = ""
    /// 商品单位 一盒，一箱，一斤
    var unit:String = ""
    /// 会员价格
    var availableVipPrice:Double = -199.0
    /// 特价
    var specialPrice:Double = -199.0
    /// 未登录显示这个文描
    var statusMsg:String = ""
    
    /// 不知道什么意思或代表什么或用到哪里 所有可选类型都是未知的数据类型，如果后期开发中，明确字段用法，请务必赋默认值
    var buyTogetherId:Any?
    var buyTogetherJumpInfo:String = ""
    var buyTogetherSum:Any?
    var buyTogetherWholeSale:Any?
    var createTime:String = ""
    var createUser:String = ""
    var dinnerPromotionRule:Any?
    var disCountDesc:String = ""
    var downTime:String = ""
    var expiryDate:String = ""
    var factoryId:String = ""
    var id:Any?
    var indexMobileFloorId:Any?
    var indexMobileId:Any?
    var inimumPacking:Int = -199
    var inventory:Int = -199
    var isChannel:Any?
    /// *0:*非自营，*1*：自营
    var isZiYingFlag:Int = -199
    var orderNum:Any?
    var posIndex:Any?
    var productCode:String = ""
    var productCodeCompany:String = ""
    var productInventory:Int = -199
    var productSign:Any?
    var productionTime:String = ""
    var promotionCollectionId:String = ""
    var promotionId:String = ""
    var promotionTotalInventory:String = ""
    var promotionlimitNum:Int = -199
    var purchaseQuantity:Any?
    var shareStock:Any?
    var showPrice:String = ""
    var showSequence:Any?
    var singleCanBuy:Any?
    var siteCode:String = ""
    var soldPercent:Any?
    var statusDesc:Int = -199
    var stockCountDesc:String = ""
    var surplusBuyNum:Any?
    var upTime:Any?
    var vipLimitNum:Any?
    var vipPromotionId:Any?
    var visibleVipPrice:Any?
    var weeklyPurchaseLimit:Any?
    var wholeSaleNum:Int = -199
    
    
    var batchNo : String = ""
    var currentBuyNum : Int = -199
    var dinnerPrice : Double = -199
    var discountMoney : Double = -199
    var doorsill : Int = -199
//    var expiryDate : String = ""
//    var factoryName : String = ""
//    var imgPath : String = ""
    var isMainProduct : Int = -199
    var maxBuyNum : Int = -199
    var miniPackage : Int = -199
    var packageUnit : String = ""
    var price : Double = -199
//    var productInventory : String = ""
//    var productName : String = ""
//    var productionTime : String = ""
//    var promotionId : String = ""
//    var shortName : String = ""
//    var singleCanBuy : Int = -199
    var spec : String = ""
    var spuCode : String = ""
//    var statusDesc : Int = -199
    var supplyId : String = ""
    
}
