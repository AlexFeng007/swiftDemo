//
//  ShopProductItemModel.swift
//  FKY
//
//  Created by 寒山 on 2019/11/1.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  店铺内全部商品的model

import UIKit
import SwiftyJSON

final class ShopProductItemModel :NSObject, JSONAbleType {
    var approvalNum: String?                    //批准文号
    var auditStatus: String?                    //审核状态(0：待审核，1：审核通过，2：审核不通过，3：ERP对码完成 ,4:上架，5:下架 ,6:
    var channel: Bool?                      //是否渠道商品
    var channelId: String?                    //渠道id
    var isChannel: Bool?                      //是否渠道商品
    var channelPrice: Float?                    //渠道价
    var countOfWeekLimit: NSInteger?                 // 周限购商品购买数量
    var deadLine: String?                       // 有效期
    var availableVipPrice : Float?              // 可用会员价（会员才有这个字段）
    var visibleVipPrice : Float?                // 可见会员价（非会员和会员都有）
    var recommendPrice : Float?           //建议零售价
    var vipLimitNum :NSInteger?                 // vip限购数量
    var vipPromotionId :String?                 // vip活动id
    var discountPrice: String?                  // 折后价
    var discountPriceDesc: String?                  // 折后价
    var bestBuyNumDesc: String?                  // 折后价最优说明
    /**
     * 二级分类名和ID
     */
    var  drugSecondCategory : String?
    var  drugSecondCategoryName : String?
    
    var  drugformType: String?                    //剂型名称
    var factoryName: String?                    //厂家名字
    
    var groupCode: String?                    //
    var groupPrice: String?                    //
    var  haveDinner:Bool?                      // ture 有套餐 false 无套餐
    var  protocolRebate:Bool?                      //协议返利金
    var  idd: String?                    //产品ID
    var includeCouponTemplateIds: String?       // 优惠券(打标)...<搜索、店铺>...[字符串不为空则打标]
    var  inventory:NSInteger?                 // 库存数
    var isRebate : Int?                         // 是否有返利，0无1有
    var limitBuyDesc: String?                   // 已达限购总数时，点击按钮的提示
    var limitInfo: String?                      // 限购(打标)
    var  maxPackage:NSInteger?                 // 大包装
    var  minPackage:NSInteger?                 // 最小起批量
    
    
    var picPath: String?                    //图片
    var productName: String?                    // 商品名
    var productCode: String?                      //商品条码(本公司药品编码)
    var productPromotion: ShopProductPromotionModel?        //特价
    var productPromotionInfos: [ProductPromotionInfo]?  //
    var productStatus: Bool = true              // 商品是否能够购买 YES-可购买 NO-不可购买
    var productCodeCompany: String?             //
    var productionTime: String?                 // 生产日期
    
    
    var rebateDesc: String?                    //返利金描述
    var  sellerCode: String?                    //商家编码
    var sellerName: String?                    //卖家名称
    
    var shareStockDesc: String?              //分享库存信息
    var shortName: String?                      // 通用名
    var productFullName: String?{ //商品全名 名字加规格
        get {
            return (shortName ?? "") + " " + (spec ?? "")
        }
    }
    var showPrice : Float?                // 商品价格
    var spec: String?                           //
    var statusComplain: String?                 // 商品不可购买原因
    var statusDesc: NSInteger?                  // 采购权限相关状态
    var stockCount: NSInteger?                  //库存
    var stockDesc: String?                 // 库存描述
    
    var singleCanBuy :Int? //单品是否可购买，0-可购买，1-不可（显示套餐按钮）
    var dinnerPromotionRule :Int? // 2固定套餐 1 搭配套餐
    //分享库存
    /**
     *前端可售库存(业务计算)
     */
    var  shareStockCount: Int?
    /**
     * 是否本地仓库存
     */
    var  stockIsLocal:Bool?
    /**
     * 调拨周期（天）
     */
    var  stockToDays: String?
    
    /**
     * 库存调拨仓ID
     */
    var stockToFromWarhouseId: Int?
    
    /**
     * 库存调拨仓名称
     */
    var stockToFromWarhouseName: String?
    var surplusBuyNum: NSInteger?               // 周限购剩余购买数量
    var unit: String?                           //单位
    
    var  weekLimitNum: NSInteger?               //周限购数
    var spuCode: String?                    //
    
    /*
     展示规则：
     仅针对MP商品
     慢必赔和保价两个标签不会同时出现，只出现一个
     这两个标签优先级排第一，优先展示
     标签不允许换行，多了不展示
     */
    //慢必赔
    var slowPay:Bool?
    //保价
    var holdPrice:Bool?
    //var hotSell : HotSellDtoModel?     //热销版模型
    
    // 非接口返回字段...<限购逻辑>
    var limitCanBuyNumber: Int = 0
    
    var carId :Int = 0 //购物车id
    var carOfCount :Int = 0 //购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
    var showSequence :Int = 0 //（自定义字段，商品展示顺序）
    
    
    
    var pm_price: String?{ //可购买价格  埋点专用 自定义1
        get {
            var priceList:[String] = []
            //会员价 特价 原价
            if let promotionNum =  productPromotion?.promotionPrice , promotionNum > 0  {
                //特价
                priceList.append(String(format: "%.2f",promotionNum))
            }else if let _ = vipPromotionId, let vipNum = visibleVipPrice, vipNum > 0 {
                if let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0 {
                    //                  //会员
                    priceList.append(String(format: "%.2f",vipAvailableNum))
                }
            }
            //原价
            if let priceStr =  showPrice, priceStr > 0 {
                priceList.append(String(format: "%.2f",priceStr))
            }
            return priceList.count == 0 ?  ProductStausUntily.getProductStausDesc(statusDesc ?? 0):priceList.joined(separator: "|")
        }
    }
    var storage: String?{ //可购买数量 1
        get {
            var numList:[String] = []
            //剩余限购数量
            if productPromotion != nil && productPromotion?.limitNum != nil && (productPromotion?.limitNum!)! > 0 {
                numList.append(String(format: "%d", (productPromotion?.limitNum!)!))
            }else if vipLimitNum != nil &&  vipLimitNum! > 0 {
                if let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0{
                    numList.append(String(vipLimitNum!))
                }
            }
            var canBuyNum = 0
            if  surplusBuyNum != nil && surplusBuyNum! > 0 {
                canBuyNum = surplusBuyNum!
            }
            if let count = stockCount ,count>0{
                if (canBuyNum > count || canBuyNum == 0){
                    canBuyNum = count
                }
            }
            numList.append(String(canBuyNum))
            return numList.count == 0 ? "0":numList.joined(separator: "|")
        }
    }
    var pm_pmtn_type: String?{ //促销类型数据  埋点专用 自定义
        get {
            var pmList:[String] = []
            if self.isHasSomeKindPromotion(["2", "3"]) {
                pmList.append("满减")
            }
            if self.isHasSomeKindPromotion(["5", "6", "7", "8"]) {
                pmList.append("满赠")
            }
            // 15:单品满折,16多品满折
            if self.isHasSomeKindPromotion(["15", "16"]) {
                pmList.append("满折")
            }
            // 返利金
            if let rb = isRebate, rb == 1 {
                pmList.append("返利")
            }
            // 协议返利金
            if let rebate = protocolRebate, rebate == true {
                pmList.append("协议奖励金")
            }
            // 套餐
            if let li = haveDinner, li == true {
                pmList.append("套餐")
            }
            // 限购
            if let li = limitInfo, li.isEmpty == false {
                pmList.append("限购")
            }
            //特价
            if let promotionNum =  productPromotion?.promotionPrice , promotionNum > 0  {
                pmList.append("特价")
            }
            //会员  会员才加入 有会员价的商品
            if let _ = vipPromotionId, let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0 {
                pmList.append("会员")
            }
            // 优惠券
            if let cp = includeCouponTemplateIds, cp.isEmpty == false {
                pmList.append("券")
            }
            
            return pmList.joined(separator: ",")
        }
    }
    
    var ziyingFlag: Int? //1表示自营
    var ziyingWarehouseName: String? //自营仓名
    
    static func fromJSON(_ json: [String : AnyObject]) -> ShopProductItemModel {
        let json = JSON(json)
        let model = ShopProductItemModel()
        
        model.approvalNum = json["approvalNum"].stringValue
        model.spuCode = json["spuCode"].stringValue
        
        model.picPath = json["picPath"].stringValue
        model.productName = json["productName"].stringValue
        model.shortName = json["shortName"].stringValue
        model.spec = json["spec"].stringValue
        model.unit = json["unit"].stringValue
        //vip字段
        model.availableVipPrice = 0
        if let showPrice = Float(json["showPrice"].stringValue),showPrice > 0{
            model.showPrice = showPrice
        }
        if let vipAvailablePriceNum = Float(json["availableVipPrice"].stringValue),vipAvailablePriceNum > 0{
            model.availableVipPrice = vipAvailablePriceNum
        }
        model.visibleVipPrice = 0
        if let vipPriceNum = Float(json["visibleVipPrice"].stringValue),vipPriceNum > 0{
            model.visibleVipPrice = vipPriceNum
        }
        model.vipLimitNum = 0
        if let vipNum = Int(json["vipLimitNum"].stringValue),vipNum > 0{
            model.vipLimitNum = vipNum
        }
        if let rPriceNum = Float(json["recommendPrice"].stringValue),rPriceNum > 0{
            model.recommendPrice = rPriceNum
        }
        model.vipPromotionId = json["vipPromotionId"].stringValue
        model.channelPrice = json["channelPrice"].float
        model.stockCount = json["stockCount"].intValue
        model.auditStatus = json["auditStatus"].stringValue
        model.countOfWeekLimit = json["countOfWeekLimit"].intValue
        model.maxPackage = json["maxPackage"].intValue
        model.minPackage = json["minPackage"].intValue
        model.weekLimitNum = json["weekLimitNum"].intValue
        
        model.statusDesc = json["statusDesc"].intValue
        model.rebateDesc = json["rebateDesc"].stringValue
        model.sellerCode = json["sellerCode"].stringValue
        model.factoryName = json["factoryName"].stringValue
        model.productCode = json["productCode"].stringValue
        model.sellerName = json["sellerName"].stringValue
        
        
        model.drugformType = json["drugformType"].stringValue
        model.productCodeCompany = json["productCodeCompany"].stringValue
        model.limitInfo = json["limitInfo"].stringValue   // 限购
        model.includeCouponTemplateIds = json["includeCouponTemplateIds"].stringValue   // 优惠券
        model.isRebate = json["isRebate"].intValue //返利金
        model.haveDinner = json["haveDinner"].boolValue//套餐
        model.protocolRebate = json["protocolRebate"].boolValue//协议返利金
        
        let dic = json["productPromotion"].dictionaryObject
        if let _ = dic {
            let t = dic! as NSDictionary
            model.productPromotion = t.mapToObject(ShopProductPromotionModel.self)
        }else{
            model.productPromotion = nil
        }
        
        if let promoInfos = json["productPromotionInfos"].arrayObject {
            model.productPromotionInfos = (promoInfos as NSArray).mapToObjectArray(ProductPromotionInfo.self)
        }else{
            model.productPromotionInfos = [ProductPromotionInfo]()
        }
        model.channelPrice = json["channelPrice"].float
        
        model.channel = json["channel"].boolValue
        model.channelId = json["channelId"].stringValue
        model.isChannel =  json["isChannel"].boolValue
        
        model.surplusBuyNum =  json["surplusBuyNum"].intValue
        model.inventory =  json["inventory"].intValue
        model.limitBuyDesc =  json["limitBuyDesc"].stringValue
        model.productionTime = json["productionTime"].stringValue
        // 有效期
        model.deadLine = json["deadLine"].stringValue
        
        model.slowPay = json["slowPay"].boolValue
        model.holdPrice = json["holdPrice"].boolValue
        
        
        model.statusComplain =  json["statusComplain"].stringValue
        model.discountPrice = json["discountPrice"].stringValue
        model.discountPriceDesc = json["discountPriceDesc"].stringValue
        model.bestBuyNumDesc = json["bestBuyNumDesc"].stringValue
        if let _ = json["productStatus"].bool {
            model.productStatus = json["productStatus"].boolValue
        }
        model.shareStockCount = json["shareStockCount"].intValue
        model.stockIsLocal = json["stockIsLocal"].boolValue
        model.stockToDays = json["stockToDays"].stringValue
        model.stockToFromWarhouseId = json["stockToFromWarhouseId"].intValue
        model.stockToFromWarhouseName = json["stockToFromWarhouseName"].stringValue
        model.drugSecondCategoryName = json["drugSecondCategoryName"].stringValue
        model.drugSecondCategory = json["drugSecondCategory"].stringValue
        model.shareStockDesc = json["shareStockDesc"].stringValue
        model.stockDesc = json["stockDesc"].stringValue
        model.singleCanBuy = json["singleCanBuy"].intValue
        model.dinnerPromotionRule = json["dinnerPromotionRule"].intValue
        for cartModel in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode ==  model.spuCode! && cartOfInfoModel.supplyId.intValue == Int(model.sellerCode!) {
                    model.carOfCount = cartOfInfoModel.buyNum.intValue
                    model.carId = cartOfInfoModel.cartId.intValue
                    break
                }
            }
        }
        
        if json["ziyingFlag"].int != nil {
            model.ziyingFlag = json["ziyingFlag"].intValue
        }else {
            model.ziyingFlag = 3
        }
        
        model.ziyingWarehouseName = json["ziyingWarehouseName"].stringValue
        return model
    }
    
    func checkoutIsChannel() -> Bool {
        if let strIsChannel = self.isChannel {
            if strIsChannel == true {
                return true
            }else {
                return false
            }
        }else{
            return false
        }
    }
    
    //2:单品满减;3:多品满减;5:单品满赠；6:多品满赠送;7:单品满送积分;8:多品满送积分;(数字越小，优先级越高)
    func getProducPromotionInfo() -> String? {
        if let promotionInfos = self.productPromotionInfos {
            if 2 <= promotionInfos.count {
                let sortedWithPromotionType:[ProductPromotionInfo] = promotionInfos.sorted(by: { (promotionInfosX, promotionInfosY) -> Bool in
                    return (promotionInfosX.promotionType?.compare(promotionInfosY.promotionType!) == ComparisonResult.orderedAscending)
                })
                
                return sortedWithPromotionType[0].promotionDesc
            }else if (0 < promotionInfos.count && 2 > promotionInfos.count) {
                return promotionInfos[0].promotionDesc
            }else {
                return ""
            }
        }else{
            return ""
        }
    }
    
    func isHasSomeKindPromotion(_ promotionTypeArray:[String]) -> Bool {
        if let promotonList = self.productPromotionInfos, promotonList.count > 0 {
            let predicate: NSPredicate = NSPredicate(format: "self.stringPromotionType IN %@",promotionTypeArray)
            let result = (promotonList as NSArray).filtered(using: predicate)
            if result.count > 0 {
                return true
            }else {
                return false
            }
        }else{
            return false
        }
    }
}
final class NewShopAllProductModel: NSObject, JSONAbleType {
    var totalCount: Int?
    var totalPages : Int?
    var loginFlag:Bool?   //是否登录    boolean
    var page: Int?  //当前页码    number
    var size: Int?  //每页显示个数
    var list: [ShopProductItemModel]?
    
    static func fromJSON(_ json: [String : AnyObject]) -> NewShopAllProductModel {
        let json = JSON(json)
        let model = NewShopAllProductModel()
        model.totalCount = json["totalCount"].intValue
        model.totalPages = json["totalPage"].intValue
        model.page = json["page"].intValue
        model.size = json["size"].intValue
        let array = json["list"].arrayObject
        var list: [ShopProductItemModel]? = []
        if let arr = array{
            list = (arr as NSArray).mapToObjectArray(ShopProductItemModel.self)
        }
        model.list = list
        return model
    }
}
//店铺内特价的model
final class ShopProductPromotionModel: NSObject, JSONAbleType {
    var  limitNum : NSInteger?
    var  promotionId : String?
    var  promotionPrice : Float?
    var  priceVisible: NSInteger?
    var  minimumPacking: NSInteger?
    var  promotionType: String?
    var liveStreamingFlag: Int?               // 直播价格标啥
    static func fromJSON(_ json: [String : AnyObject]) -> ShopProductPromotionModel {
        let json = JSON(json)
        let model = ShopProductPromotionModel()
        model.limitNum = json["limit_num"].intValue
        model.promotionId = json["promotion_id"].stringValue
        model.promotionPrice = json["promotion_price"].floatValue
        model.priceVisible = json["price_visible"].intValue
        model.minimumPacking = json["minimum_packing"].intValue
        model.promotionType = json["promotion_type"].stringValue
        model.liveStreamingFlag = json["liveStreamingFlag"].intValue
        return model
    }
}
extension ShopProductPromotionModel: NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(limitNum, forKey: "limitNum")
        aCoder.encode(promotionId, forKey: "promotionId")
        aCoder.encode(promotionPrice, forKey: "promotionPrice")
        aCoder.encode(priceVisible, forKey: "priceVisible")
        aCoder.encode(minimumPacking, forKey: "minimumPacking")
        aCoder.encode(promotionType, forKey: "promotionType")
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        self.init()
        promotionId = aDecoder.decodeObject(forKey: "promotionId") as? String
        promotionType = aDecoder.decodeObject(forKey: "promotionType") as? String
        
        promotionPrice = aDecoder.decodeObject(forKey: "promotionPrice") as? Float
        minimumPacking = aDecoder.decodeObject(forKey: "minimumPacking") as? Int
        priceVisible = aDecoder.decodeObject(forKey: "priceVisible") as? Int
        limitNum = aDecoder.decodeObject(forKey: "limitNum") as? Int
        
    }
}

extension ShopProductItemModel: NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(approvalNum, forKey: "approvalNum")
        aCoder.encode(channel, forKey: "channel")
        aCoder.encode(channelId, forKey: "channelId")
        aCoder.encode(isChannel, forKey: "isChannel")
        aCoder.encode(channelPrice, forKey: "channelPrice")
        aCoder.encode(countOfWeekLimit, forKey: "countOfWeekLimit")
        aCoder.encode(deadLine, forKey: "deadLine")
        aCoder.encode(availableVipPrice, forKey: "availableVipPrice")
        aCoder.encode(visibleVipPrice, forKey: "visibleVipPrice")
        aCoder.encode(vipLimitNum, forKey: "vipLimitNum")
        aCoder.encode(vipPromotionId, forKey: "vipPromotionId")
        aCoder.encode(recommendPrice, forKey: "recommendPrice")
        aCoder.encode(discountPrice, forKey: "discountPrice")
        aCoder.encode(showSequence, forKey: "showSequence")
        
        
        aCoder.encode(discountPriceDesc, forKey: "discountPriceDesc")
        aCoder.encode(drugSecondCategory, forKey: "drugSecondCategory")
        aCoder.encode(drugSecondCategoryName, forKey: "drugSecondCategoryName")
        aCoder.encode(drugformType, forKey: "drugformType")
        aCoder.encode(factoryName, forKey: "factoryName")
        aCoder.encode(groupCode, forKey: "groupCode")
        
        aCoder.encode(groupPrice, forKey: "groupPrice")
        
        aCoder.encode(haveDinner, forKey: "haveDinner")
        aCoder.encode(protocolRebate, forKey: "protocolRebate")
        aCoder.encode(isRebate, forKey: "isRebate")
        aCoder.encode(limitCanBuyNumber, forKey: "limitCanBuyNumber")
        aCoder.encode(idd, forKey: "idd")
        aCoder.encode(includeCouponTemplateIds, forKey: "includeCouponTemplateIds")
        aCoder.encode(inventory, forKey: "inventory")
        aCoder.encode(isRebate, forKey: "isRebate")
        aCoder.encode(limitBuyDesc, forKey: "limitBuyDesc")
        aCoder.encode(limitInfo, forKey: "limitInfo")
        
        aCoder.encode(maxPackage, forKey: "maxPackage")
        aCoder.encode(picPath, forKey: "picPath")
        aCoder.encode(minPackage, forKey: "minPackage")
        
        aCoder.encode(productCodeCompany, forKey: "productCodeCompany")
        aCoder.encode(productStatus, forKey: "productStatus")
        aCoder.encode(productName, forKey: "productName")
        aCoder.encode(productCode, forKey: "productCode")
        
        aCoder.encode(productPromotion, forKey: "productPromotion")
        aCoder.encode(productPromotionInfos, forKey: "productPromotionInfos")
        
        aCoder.encode(productionTime, forKey: "productionTime")
        aCoder.encode(rebateDesc, forKey: "rebateDesc")
        aCoder.encode(sellerCode, forKey: "sellerCode")
        
        aCoder.encode(sellerName, forKey: "sellerName")
        aCoder.encode(shortName, forKey: "shortName")
        aCoder.encode(productFullName, forKey: "productFullName")
        
        aCoder.encode(showPrice, forKey: "showPrice")
        aCoder.encode(spec, forKey: "spec")
        aCoder.encode(statusComplain, forKey: "statusComplain")
        
        aCoder.encode(statusDesc, forKey: "statusDesc")
        aCoder.encode(stockCount, forKey: "stockCount")
        aCoder.encode(stockDesc, forKey: "stockDesc")
        aCoder.encode(shareStockCount, forKey: "shareStockCount")
        aCoder.encode(stockIsLocal, forKey: "stockIsLocal")
        aCoder.encode(stockToDays, forKey: "stockToDays")
        aCoder.encode(carOfCount, forKey: "carOfCount")
        aCoder.encode(surplusBuyNum, forKey: "surplusBuyNum")
        aCoder.encode(unit, forKey: "unit")
        aCoder.encode(weekLimitNum, forKey: "weekLimitNum")
        aCoder.encode(spuCode, forKey: "spuCode")
        aCoder.encode(limitCanBuyNumber, forKey: "limitCanBuyNumber")
        aCoder.encode(carId, forKey: "carId")
        
        aCoder.encode(stockToFromWarhouseId, forKey: "stockToFromWarhouseId")
        aCoder.encode(stockToFromWarhouseName, forKey: "stockToFromWarhouseName")
        aCoder.encode(shareStockDesc, forKey: "shareStockDesc")
        
        
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        approvalNum = aDecoder.decodeObject(forKey: "approvalNum") as? String
        spec = aDecoder.decodeObject(forKey: "spec") as? String
        channel = aDecoder.decodeObject(forKey: "channel") as? Bool
        channelId = aDecoder.decodeObject(forKey: "channelId") as? String
        stockDesc = aDecoder.decodeObject(forKey: "stockDesc") as? String
        
        isChannel = aDecoder.decodeObject(forKey: "isChannel") as? Bool
        channelPrice = aDecoder.decodeObject(forKey: "channelPrice") as? Float
        deadLine = aDecoder.decodeObject(forKey: "deadLine") as? String
        
        visibleVipPrice = aDecoder.decodeObject(forKey: "visibleVipPrice") as? Float
        vipLimitNum = aDecoder.decodeObject(forKey: "vipLimitNum") as? Int
        vipPromotionId = aDecoder.decodeObject(forKey: "vipPromotionId") as? String
        availableVipPrice = aDecoder.decodeObject(forKey: "availableVipPrice") as? Float
        recommendPrice = aDecoder.decodeObject(forKey: "recommendPrice") as? Float
        unit = aDecoder.decodeObject(forKey: "unit") as? String
        shortName = aDecoder.decodeObject(forKey: "shortName") as? String
        productName = aDecoder.decodeObject(forKey: "productName") as? String
        statusDesc = aDecoder.decodeObject(forKey: "statusDesc") as? Int
        
        
        productPromotionInfos = aDecoder.decodeObject(forKey: "productPromotionInfos") as? [ProductPromotionInfo]
        productPromotion = aDecoder.decodeObject(forKey: "productPromotion") as? ShopProductPromotionModel
        
        limitBuyDesc = aDecoder.decodeObject(forKey: "limitBuyDesc") as? String
        
        limitInfo = aDecoder.decodeObject(forKey: "limitInfo") as? String
        includeCouponTemplateIds = aDecoder.decodeObject(forKey: "includeCouponTemplateIds") as? String
        isRebate = aDecoder.decodeObject(forKey: "isRebate") as? Int
        
        if let  limitNumber = aDecoder.decodeObject(forKey: "limitCanBuyNumber") as? Int {
            limitCanBuyNumber = limitNumber
        }
        if let count = aDecoder.decodeObject(forKey: "minPackage") as? Int {
            minPackage = count
        }
        surplusBuyNum = aDecoder.decodeObject(forKey: "surplusBuyNum") as? Int
        weekLimitNum = aDecoder.decodeObject(forKey: "weekLimitNum") as? Int
        countOfWeekLimit = aDecoder.decodeObject(forKey: "countOfWeekLimit") as? Int
        
        if let showsequence = aDecoder.decodeObject(forKey: "showSequence") as? Int {
            showSequence = showsequence
        }
        if let carid = aDecoder.decodeObject(forKey: "carId") as? Int {
            carId = carid
        }
        if let carCount = aDecoder.decodeObject(forKey: "carOfCount") as? Int {
            carOfCount = carCount
        }
        productCodeCompany = aDecoder.decodeObject(forKey: "productCodeCompany") as? String
        if let pStatus = aDecoder.decodeObject(forKey: "productStatus") as? Bool {
            productStatus = pStatus
        }
        statusComplain = aDecoder.decodeObject(forKey: "statusComplain") as? String
        
        shareStockCount = aDecoder.decodeObject(forKey: "shareStockCount") as? Int
        stockIsLocal = aDecoder.decodeObject(forKey: "stockIsLocal") as? Bool
        
        stockToFromWarhouseId = aDecoder.decodeObject(forKey: "stockToFromWarhouseId") as? Int
        stockToFromWarhouseName = aDecoder.decodeObject(forKey: "stockToFromWarhouseName") as? String
        shareStockDesc = aDecoder.decodeObject(forKey: "shareStockDesc") as? String
        discountPrice = aDecoder.decodeObject(forKey: "discountPrice") as? String
        discountPriceDesc = aDecoder.decodeObject(forKey: "discountPriceDesc") as? String
        
        
        drugformType = aDecoder.decodeObject(forKey: "drugformType") as? String
        drugSecondCategory = aDecoder.decodeObject(forKey: "drugSecondCategory") as? String
        drugSecondCategoryName = aDecoder.decodeObject(forKey: "drugSecondCategoryName") as? String
        factoryName = aDecoder.decodeObject(forKey: "factoryName") as? String
        
        
        groupCode = aDecoder.decodeObject(forKey: "groupCode") as? String
        groupPrice = aDecoder.decodeObject(forKey: "groupPrice") as? String
        idd = aDecoder.decodeObject(forKey: "idd") as? String
        picPath = aDecoder.decodeObject(forKey: "picPath") as? String
        productCode = aDecoder.decodeObject(forKey: "productCode") as? String
        rebateDesc = aDecoder.decodeObject(forKey: "rebateDesc") as? String
        sellerCode = aDecoder.decodeObject(forKey: "sellerCode") as? String
        sellerName = aDecoder.decodeObject(forKey: "sellerName") as? String
        
        spec = aDecoder.decodeObject(forKey: "spec") as? String
        stockToDays = aDecoder.decodeObject(forKey: "stockToDays") as? String
        spuCode = aDecoder.decodeObject(forKey: "spuCode") as? String
        stockCount = aDecoder.decodeObject(forKey: "stockCount") as? Int
        showPrice = aDecoder.decodeObject(forKey: "showPrice") as? Float
        haveDinner = aDecoder.decodeObject(forKey: "haveDinner") as? Bool
        protocolRebate = aDecoder.decodeObject(forKey: "protocolRebate") as? Bool
        productionTime = aDecoder.decodeObject(forKey: "productionTime") as? String
        
    }
}

//热销榜字段model
final class HotSellDtoModel: NSObject, JSONAbleType {
    var  cat3Id : String?
    var  cat3Name: String? //
    var  city : String?
    var  cityName: String?
    var  mchntSpuId : String?
    var  order: Int?
    var  orderName : String?
    var  spuCode: String?
    var  spuId: String?
    
    static func fromJSON(_ json: [String : AnyObject]) -> HotSellDtoModel {
        let json = JSON(json)
        let model = HotSellDtoModel()
        model.cat3Id = json["cat3Id"].stringValue
        model.cat3Name = json["cat3Name"].stringValue
        model.city = json["city"].stringValue
        model.cityName = json["cityName"].stringValue
        model.mchntSpuId = json["mchntSpuId"].stringValue
        model.order = json["order"].intValue
        model.orderName = json["orderName"].stringValue
        model.spuCode = json["spuCode"].stringValue
        model.spuId = json["spuId"].stringValue
        return model
    }
}
