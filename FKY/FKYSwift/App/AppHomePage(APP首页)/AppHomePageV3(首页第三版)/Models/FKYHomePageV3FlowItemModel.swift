//
//  FKYHomePageV3FlowItemModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYHomePageV3FlowItemModel: NSObject,HandyJSON {
    required override init() {    }
    /// 两个对象合并成一个对象
    /// 不知道什么意思或代表什么或用到哪里 所有可选类型都是未知的数据类型，如果后期开发中，明确字段用法，请务必赋默认值
    /// --------------------------对象1--------------------------
    var availableVipPrice: Double = -199.0
    var batchNo: String = ""
    var bestBuyNumDesc: String = ""
    var bigPackage: String = ""
    var cityName: String = ""
    var descriptionField: String = ""
    var dinnerPromotionRule: AnyObject?
    var disCountDesc: String = ""
    var enterpriseId: String = ""
    var expiryDate: String = ""
    var factoryName: String = ""
    var frontSellerCode: Int?
    var gmv: AnyObject?
    var imgPath: String = ""
    var isZiYingFlag: Int?
    var lastOrderDate: String = ""
    var lastViewDate: String = ""
    var mainWareHouseSort: AnyObject?
    var miniPackage: String = ""
    var orderCount: AnyObject?
    var packageUnit: String = ""
    var pmCount: AnyObject?
    var price: Double = -199.0
    var productDesc: String?
    var productDescType: AnyObject?
    var productId: String = ""
    var productInventory: Int = -199
    var productName: String = ""
    var productType: Int = -199
    var productionTime: String = ""
    var promotionId: String = ""
    var promotionLimitNum: Int = -199
    var promotionPrice: Double = -199.0
    var provinceName: String = ""
    var pvCount: AnyObject?
    var sellerCount: AnyObject?
    var shareStockDTO: AnyObject?
    var shopCode: String = ""
    var shopExtendTag: String = ""
    var shopExtendType: Int = -199
    var shopName: String = ""
    var shortName: String = ""
    var shortWarehouseName: String = ""
    var showSequence: AnyObject?
    var singleCanBuy: AnyObject?
    var sortNum: AnyObject?
    var sourceFrom: String = ""
    var spec: String = ""
    var spuCode: String = ""
    var spuName: String = ""
    var statusDesc: Int?
    var statusMsg: String = ""
    var stockCountDesc: String = ""
    var supplyId: String = ""
    var supplyName: String = ""
    var surplusBuyNum: Int = -199
    var vipLimitNum: Int = -199
    var vipPromotionId: String = ""
    var visibleVipPrice: Double = -199.0
    /// 周限购
    var weeklyPurchaseLimit: Int = -199
    var wholeSaleNum: Int?
    var productSign:FKYHomePageV3ProductTagModel = FKYHomePageV3ProductTagModel()
    /// 单品包邮信息
    var singlePackage:FKYHomePageV3SinglePackageModel = FKYHomePageV3SinglePackageModel()
    /// --------------------------对象2--------------------------
    var countDownFlag: AnyObject?
    var createTime: String = ""
    var createUser: String = ""
    var downTime: String = ""
    var downTimeMillis: AnyObject?
    var enterpriseTypeList: String = ""
    var floorColor: Int?
    var floorProductDtos: [FKYHomePageV3FloorProductModel] = [FKYHomePageV3FloorProductModel]()
    var floorStyle: Int?
    var holdTime: String = ""
    var hotsaleFlag: Int?
    var iconImgDTOList: AnyObject?
    var iconImgPath: String = ""
    //var id: Int!
    var indexFloor: String = ""
    var indexMobileId: Int?
    var jumpExpandOne: String = ""
    var jumpExpandThree: String = ""
    var jumpExpandTwo: String = ""
    var jumpInfo: String = ""
    var jumpInfoMore: Int = -199
    var jumpType: AnyObject?
    var name: String = ""
    var newOrder: Int?
    var newToolFlag: AnyObject?
    var oftenBuyFlag: Int?
    var oftenViewFlag: Int?
    var originalPriceFlag: AnyObject?
    var posIndex: Int?
    var segment: Int?
    var showNum: String = ""
    var siteCode: String = ""
    var skipFlag: String = ""
    var sysTimeMillis: Int = -199
    var title: String = ""
    var togetherMark: Int = -199
    var type: Int?
    var upTime: String = ""
    var upTimeMillis: AnyObject?
    var url: String = ""
    
    // 自用属性-------
    //var itemSize:CGSize = CGSize.zero
    
    /// 是否已经上报BI埋点
    var isUPloadBI:Bool = false
    /// 是否已经更新过imge高度
    var isUpDatedHeight:Bool = false
    /// 图片高度
    var imageHeight:CGFloat = WH(172)
    /// 商品已经加入购物车的数量
    var carOfCount:Int = 0
    /// 购物车id
    var carId:Int = 0
    
}

extension FKYHomePageV3FlowItemModel{
    
    /// 促销类型数据  埋点专用 自定义
    func getPm_pmtn_type() -> String{
        
        var pmList:[String] = []
        
        if productSign.fullScale == true{
            pmList.append("满减")
        }
        if productSign.fullGift == true{
            pmList.append("满赠")
        }
        // 15:单品满折,16多品满折
        if productSign.fullDiscount == true{
            pmList.append("满折")
        }
        // 返利金
        if productSign.rebate == true{
            pmList.append("返利")
        }
        // 协议返利金
        if productSign.bounty == true{
            pmList.append("协议奖励金")
        }
        // 套餐
        if productSign.packages == true{
            pmList.append("套餐")
        }
        // 限购
        if productSign.purchaseLimit == true{
            pmList.append("限购")
        }
        //特价
        if productSign.specialOffer == true{
            pmList.append("特价")
        }
        //会员  会员才加入 有会员价的商品
        if vipPromotionId.isEmpty == false, availableVipPrice > 0 {
            pmList.append("会员")
        }
        // 优惠券
        if productSign.ticket == true{
            pmList.append("券")
        }
        
        return pmList.joined(separator: ",")
        
    }
    
    /// 可购买价格  埋点专用 自定义
    func getPm_price() -> String{
        
        var priceList:[String] = []
        //会员价 特价 原价
        if promotionPrice > 0  {
            //特价
            priceList.append(String(format: "%.2f",promotionPrice))
        }else if vipPromotionId.isEmpty == false, visibleVipPrice > 0 {
            if  availableVipPrice > 0 {
                //会员
                priceList.append(String(format: "%.2f",availableVipPrice))
            }
        }
        //原价
        if price > 0 {
            priceList.append(String(format: "%.2f",price))
        }
        return priceList.count == 0 ?  ProductStausUntily.getProductStausDesc(statusDesc ?? 0):priceList.joined(separator: "|")
        
    }
    
    /// 获取可购买数量 埋点专用
    func getStorage() -> String{
        
        var numList:[String] = []
        
        //剩余限购数量
        if promotionLimitNum > 0 {
            numList.append(String(promotionLimitNum))
        }else if vipLimitNum > 0 {
            if availableVipPrice > 0{
                numList.append(String(vipLimitNum))
            }
        }
        var canBuyNum = 0
        if  surplusBuyNum > 0 {
            canBuyNum = surplusBuyNum
        }
        if productInventory > 0{
            if (canBuyNum > productInventory || canBuyNum == 0){
                canBuyNum = productInventory
            }
        }
        numList.append(String(canBuyNum))
        return numList.count == 0 ? "0":numList.joined(separator: "|")
    }
    
    /// 获取图片地址
    func getProductImageURL() -> String {
        if productType == 3 {
            guard floorProductDtos.count > 0 else {
                return ""
            }
            let product = floorProductDtos[0]
            return product.imgPath
        }else if productType == 4 {
            return imgPath
        }
        return imgPath
    }
    
    /// 获取商品名称
    func getProductName() -> String{
        if productType == 3 {
            guard floorProductDtos.count > 0 else {
                return ""
            }
            let product = floorProductDtos[0]
            return product.productName + product.productSpec
        }else if productType == 4 {
            return spuName + spec
        }
        return ""
    }
    
    /// 获取商品卖价
    func getProductSellPrice () -> String {
        var linePrice = ""
        var sellPrice = ""
        
        if productType == 3{
            guard floorProductDtos.count > 0 else {
                return ""
            }
            let product = floorProductDtos[0]
            if product.productPrice > 0 {
                sellPrice = String.init(format: "¥ %.2f", product.productPrice)
            }else {
                sellPrice = "¥--"
            }
            
            if  product.specialPrice > 0 {
                //特价
                sellPrice = String.init(format: "¥ %.2f", product.specialPrice)
                if togetherMark != 1 {
                    //一起购不显示原价
                    linePrice = String.init(format: "¥%.2f", product.productPrice)
                }
            }
            if product.availableVipPrice > 0 {
                //有会员价格
                sellPrice = String.init(format: "¥ %.2f", product.availableVipPrice)
                if togetherMark != 1 {
                    //一起购不显示原价
                    linePrice = String.init(format: "¥%.2f", product.productPrice)
                }
            }
        }else if productType == 4 {
            if price > 0 {
                sellPrice = String.init(format: "¥ %.2f", price)
            }else {
                sellPrice = "¥--"
            }
            if visibleVipPrice > 0 {
                if vipPromotionId.isEmpty == false,visibleVipPrice > 0, availableVipPrice < 0{// 要展示会员价标签 则卖价展示原价
                    sellPrice = String.init(format: "¥ %.2f", price)
                }else{
                    //有会员价格
                    sellPrice = String.init(format: "¥ %.2f", visibleVipPrice)
                }
                
                if togetherMark != 1 {
                    //一起购不显示原价
                    linePrice = String.init(format: "¥%.2f", price)
                }
            }
            if  promotionPrice > 0 {
                //特价
                sellPrice = String.init(format: "¥ %.2f", promotionPrice)
                if togetherMark != 1 {
                    //一起购不显示原价
                    linePrice = String.init(format: "¥%.2f", promotionPrice)
                }
            }
            
            if singlePackage.singlePackageId > 0 {// 单品包邮
                sellPrice = String.init(format: "¥ %.2f", singlePackage.singlePackagePrice)
                linePrice = ""
            }
        }
        
        return sellPrice
    }
    
    /// 获取商品划线价
    func getProductLinePrice() -> String{
        var linePrice = ""
        var sellPrice = ""
        
        if productType == 3{
            guard floorProductDtos.count > 0 else {
                return ""
            }
            let product = floorProductDtos[0]
            if product.productPrice > 0 {
                sellPrice = String.init(format: "¥ %.2f", product.productPrice)
            }else {
                sellPrice = "¥--"
            }
            if product.availableVipPrice > 0 {
                //有会员价格
                sellPrice = String.init(format: "¥ %.2f", product.availableVipPrice)
                if togetherMark != 1 {
                    //一起购不显示原价
                    linePrice = String.init(format: "¥%.2f", product.productPrice)
                }
            }
            if  product.specialPrice > 0 {
                //特价
                sellPrice = String.init(format: "¥ %.2f", product.specialPrice)
                if togetherMark != 1 {
                    //一起购不显示原价
                    linePrice = String.init(format: "¥%.2f", product.productPrice)
                }
            }
        }else if productType == 4 {
            if price > 0 {
                sellPrice = String.init(format: "¥ %.2f", price)
            }else {
                sellPrice = "¥--"
            }
            if visibleVipPrice > 0 {
                //有会员价格
                sellPrice = String.init(format: "¥ %.2f", visibleVipPrice)
                if togetherMark != 1 {
                    //一起购不显示原价
                    linePrice = String.init(format: "¥%.2f", price)
                }
            }
            if  promotionPrice > 0 {
                //特价
                sellPrice = String.init(format: "¥ %.2f", promotionPrice)
                if togetherMark != 1 {
                    //一起购不显示原价
                    linePrice = String.init(format: "¥%.2f", price)
                }
            }
        }
        
        if togetherMark == 1 {// 一起购没有划线价
            linePrice = ""
        }else if singlePackage.singlePackageId > 0 {// 单品包邮没有划线价
            linePrice = ""
        }
        
        return linePrice
    }
    
    /// 获取商品的标签信息 自营 MP 旗舰店等
    /// - Returns: (是否有标签,标签颜色,标签类型如自营，标签名称如华东仓)
    func getProductTagInfo() -> (Bool,String,Int){
        if productType == 3 {
            return getFlowProductTag()
        }else if productType == 4{
            return getNormalProductTag()
        }
        return (false,"",-199)
    }
    
    /// 获取楼层品的打标信息 productType == 3的时候没有打标信息
    func getFlowProductTag() -> (Bool,String,Int){
        return (false,"",-199)
        /*
        guard floorProductDtos.count > 0 else {
            return (false,UIColor.white,"","")
        }
        let product = floorProductDtos[0]
        if product.isZiYingFlag == 1 {// 有自营标签
            return (true,RGBColor(0x008EFF),"自营","")
        }
        */
    }
    
    /// 获取常规品的打标信息
    func getNormalProductTag() -> (Bool,String,Int){
        // 0* 普通店铺 *1* 旗舰店 *2* 加盟店 *3* 自营店
        if  isZiYingFlag == 1 {
            return (true,shopExtendTag,3)
        }else if shopExtendType == 2{
            return (true,shopExtendTag,shopExtendType)
        }else if shopExtendType == 3{
            return (true,shopExtendTag,shopExtendType)
        }else if shopExtendType == 1{
            return (true,shopExtendTag,shopExtendType)
        }else {
            return (true,"",0)
        }
        
    }
    
    /// 获取商品的打标信息 特价 满减 满赠等营销标签
    /// - Returns: 标签列表 (样式类型,标签文字)
    func getMarketTagList() -> [(Int,String)]{
        var tagList:[(Int,String)] = [(Int,String)]()
        
        // TJ-1  VIP-2  TIP-3 其他-4
        if productSign.slowPay {// 慢必赔
            tagList.append((4,"慢必赔"))
        }
        
        if productSign.holdPrice {// 保价
            tagList.append((4,"保价"))
        }
        
        if productSign.purchaseLimit {// 是否限购
            tagList.append((4,"限购"))
        }
        
        if productSign.ticket {// 是否领券
            tagList.append((4,"券"))
        }
        
        if productSign.specialOffer {// 是否特价
            tagList.append((1,"特价"))
        }
        
        if productSign.liveStreamingFlag {// 直播价标
            tagList.append((4,"直播价"))
        }
        
        // 会员价格标
        if vipPromotionId.isEmpty == false,visibleVipPrice > 0, availableVipPrice < 0{// 要展示会员价
            let tag = String(format: "会员价¥%.2f  ", visibleVipPrice)
            tagList.append((2,tag))
        }
        
        if vipPromotionId.isEmpty == false,availableVipPrice > 0{
            tagList.append((2,"会员价"))
        }
        
        if productSign.diJia {// 是否底价
            tagList.append((1,"底价"))
        }
        
        if productSign.rebate {// 是否返利
            tagList.append((4,"返利"))
        }
        
        if productSign.bounty {// 是否有奖励金*(*协议返利金*)*
            tagList.append((4,"协议奖励金"))
        }
        
        if productSign.packages {// 是否套餐
            tagList.append((4,"套餐"))
        }
        
        if productSign.fullScale {// 是否满减
            tagList.append((4,"满减"))
        }
        
        if productSign.fullGift {// 是否满赠
            tagList.append((4,"满赠"))
        }
        
        
        if productSign.fullDiscount {// 是否满折
            tagList.append((4,"满折"))
        }
        
        if weeklyPurchaseLimit > 0 {
            tagList.append((3,"本周限购\(weeklyPurchaseLimit)"+packageUnit))
        }
        
        if singlePackage.singlePackageId > 0 {
            tagList.removeAll()
            tagList.append((1,"单品包邮"))
            tagList.append((3,"本周剩余可购\(singlePackage.singlePackageSurplusNum)"+packageUnit))
        }
        
        if productSign.bonusTag {// 患教补贴返利金
            tagList.append((4,"奖励金"))
        }
        
        return tagList
    }
}
