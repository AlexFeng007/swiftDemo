//
//  FKYHomeProductModel.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/30.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  商品信息model

import Foundation
import SwiftyJSON
import HandyJSON

/*
 statusDesc字段说明：
 -9: 无采购权限
 -10: 采购权限待审核
 -11: 采购权限审核不通过
 -12: 采购权限已禁用
 */

//商品列表基础类型

final class HomeProductModel :NSObject, JSONAbleType,HandyJSON {
    required override init() {}
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &deadLine, name: "dead_line")
        mapper.specify(property: &deadLine, name: "deadline")
        
        mapper.specify(property: &productId, name: "productId")
        mapper.specify(property: &productId, name: "spuCode")
    }
    /// cellType 1是订单类型 2是商品类型 此值目前只在订单列表推荐品中用到 非后台返回字段 3 空视图
    @objc var cellType:NSInteger = 2
    
    var baseCount: NSInteger?                   //
    var channelPrice: Float?                    //
    var factoryId: NSInteger?                   //
    var factoryName: String?                    //
    var isChannel: String?                      //
    var limitInfo: String?                      // 限购(打标)
    var includeCouponTemplateIds: String?       // 优惠券(打标)...<搜索、店铺>...[字符串不为空则打标]
    var isRebate : Int?                         // 是否有返利，0无1有
    var haveDinner : Bool?                      // ture 有套餐 false 无套餐
    var couponFlag: NSInteger?                  // 优惠券(打标)...<常购清单>...[1:打标 0:不打标]
    var productCodeCompany: String?             //
    var ext_type : Int?                         // 店铺扩展类型（0 普通店铺 1 旗舰店 2 加盟店 3 自营店）
    var ext_shop_tag: String?                    // 店铺扩展标签（商家、xx仓、旗舰店、加盟店）
    //    var productId: String?                      //
    @objc var productId: String = ""
    var productName: String?                    // 商品名
    var productFullName: String?{ //商品全名 名字加规格
        get {
            return (shortName ?? "") + " " + (spec ?? "")
        }
    }
    var productPicUrl: String?                  //
    var productPrice: Float?                    //
    var availableVipPrice : Float?              // 可用会员价（会员才有这个字段）
    var visibleVipPrice : Float?                // 可见会员价（非会员和会员都有）
    var vipLimitNum :NSInteger?                 // vip限购数量
    var vipPromotionId :String?                 // vip活动id
    var shortName: String?                      // 通用名
    var spec: String?                           //
    var statusDesc: NSInteger?                  // 采购权限相关状态
    var stepCount: NSInteger?                   //最小加车步数
    var stockCount: NSInteger?                  //库存
    //    var unit: String?                           //
    @objc var unit: String = ""
    //    var vendorId: NSInteger?                    //
    @objc var vendorId: NSInteger = 0
    var isZiYingFlag: NSInteger?                //
    var vendorName: String?                     //
    var limitBuyDesc: String?                   // 已达限购总数时，点击按钮的提示
    var stockCountDesc: String?                 // 库存信息展示信息
    var surplusBuyNum: NSInteger?               // 本周剩余限购数量
    var limitBuyNum: NSInteger?                 // 本周限购数量
    var deadLine: String?                       // 有效期
    var productionTime: String?                 // 生产日期
    var discountPrice: String?                  // 折后价
    var discountPriceDesc: String?                  // 折后价
    var buyQtDesc: String?                  // 折后最优文描
    //let dead_line: String?                    // 有效期
    
    // model
    var promotionList: [PromotionModel]?                //判断满减满赠标签
    var productPromotion: ProductPromotionModel?        //
    var productPromotionInfos: [ProductPromotionInfo]?  //
    // productPromotionGifts    Null    null
    
    //let drugformType: String?                   // 未使用
    //    @objc var sellerCode: String = ""
    //    @objc var spuCode: String = ""
    
    // 未找到当前字段...<非api返回字段?>
    var productPrimeryKey: Int?                 // 对应productId?
    var recommendPrice: Float?                  // 建议价格
    var activityDescription : String?           //
    
    // 不可购买增加解释说明
    var productStatus: Bool = true              // 商品是否能够购买 YES-可购买 NO-不可购买
    var productType: SearchProductInfoType = .CommonProduct              // 判断搜索是否是钩子商品
    var statusComplain: String?                 // 商品不可购买原因
    
    var singleCanBuy :Int? //单品是否可购买，0-可购买，1-不可（显示套餐按钮）
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
    // 非接口返回字段...<限购逻辑>
    var limitCanBuyNumber: Int = 0
    
    @objc var carId :Int = 0 //购物车id
    @objc var carOfCount :Int = 0 //购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
    @objc var showSequence :Int = 0 // （自定义字段，商品顺序）
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
     *是否协议返利品
     */
    var  protocolRebate:Bool?
    /**
     * 调拨周期（天）
     */
    var stockToDate: String?
    
    /**
     * 库存调拨仓ID
     */
    var stockToFromWarhouseId: Int?
    
    /**
     * 二级分类名和ID
     */
    var  drugSecondCategory : String?
    var  drugSecondCategoryName : String?
    
    /**
     * 库存调拨仓名称
     */
    var stockToFromWarhouseName: String?
    /**
     * cps 分享商品信息 新增字段
     */
    var exclusivePrice: Double?  //BigDecimal专享价
    var doorsill: Int? //起售盒数
    var referencePrice: Double? //划线价
    
    //分享库存信息
    var shareStockDesc: String?
    //专区名
    var shopName: String?
    var ziyingTag: String? //自营仓名
    var spuCode: String? //
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
            if let priceStr = productPrice, priceStr > 0 {
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
    
    /// 获取可购买价格的埋点值
    @objc func getPm_priceValue() -> String {
        return self.pm_price ?? ""
    }
    
    /// 获取可购买数量的埋点值
    @objc func getStorageValue() -> String {
        return self.storage ?? ""
    }
    
    /// 获取促销的埋点值
    @objc func getPm_pmtn_typeValue() -> String{
        return self.pm_pmtn_type ?? ""
    }
    
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeProductModel {
        let json = JSON(json)
        let model = HomeProductModel()
        
        model.productPrimeryKey = json["productId"].intValue
        if json["spuCode"].string != nil {
            model.productId = json["spuCode"].stringValue
        }else{
            model.productId = json["productId"].stringValue
        }
        model.productPicUrl = json["productPicUrl"].stringValue
        model.productName = json["productName"].stringValue
        model.shortName = json["shortName"].stringValue
        model.spec = json["spec"].stringValue
        model.unit = json["unit"].stringValue
        model.productPrice = json["productPrice"].float
        //vip字段
        model.availableVipPrice = 0
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
        model.vipPromotionId = json["vipPromotionId"].stringValue
        model.recommendPrice = Float(json["recommendPrice"].stringValue)
        model.stockCount = json["stockCount"].intValue
        model.baseCount = json["baseCount"].intValue
        model.stepCount = json["stepCount"].intValue
        if json["stepCount"].int != nil && json["stepCount"].int != 0 {
            model.stepCount = json["stepCount"].intValue
        }else{
            model.stepCount = 1
        }
        model.ext_type = json["ext_type"].intValue
        model.ext_shop_tag = json["ext_shop_tag"].stringValue
        model.statusDesc = json["statusDesc"].intValue
        model.factoryName = json["factoryName"].stringValue
        model.factoryId = json["factoryId"].intValue
        model.vendorName = json["vendorName"].stringValue
        model.vendorId = json["vendorId"].intValue
        if json["isZiYingFlag"].int != nil  {
            model.isZiYingFlag = json["isZiYingFlag"].intValue
        }else{
            model.isZiYingFlag = 3// 没返回的赋值
        }
        
        model.activityDescription = json["description"].stringValue
        model.productCodeCompany = json["productCodeCompany"].stringValue
        model.limitInfo = json["limitInfo"].stringValue   // 限购
        model.includeCouponTemplateIds = json["includeCouponTemplateIds"].stringValue   // 优惠券
        model.isRebate = json["isRebate"].intValue //返利金
        model.haveDinner = json["haveDinner"].boolValue//套餐
        model.protocolRebate = json["protocolRebate"].boolValue//协议返利金
        model.couponFlag = json["couponFlag"].intValue
        
        let dic = json["productPromotion"].dictionaryObject
        if let _ = dic {
            let t = dic! as NSDictionary
            model.productPromotion = t.mapToObject(ProductPromotionModel.self)
        }else{
            model.productPromotion = nil
        }
        
        if let promos = json["promotionList"].arrayObject {
            model.promotionList = (promos as NSArray).mapToObjectArray(PromotionModel.self)
        }else{
            model.promotionList = [PromotionModel]()
        }
        
        if let promoInfos = json["productPromotionInfos"].arrayObject {
            model.productPromotionInfos = (promoInfos as NSArray).mapToObjectArray(ProductPromotionInfo.self)
            if let arr =  model.productPromotionInfos, arr.count > 0 {
                let infoModel = arr[0]
                model.singleCanBuy = infoModel.singleCanBuy
            }
        }else{
            model.productPromotionInfos = [ProductPromotionInfo]()
        }
        
        //处理没返回haveDinner情况
        if model.haveDinner == false && model.isHasBasePriceKindPromotion(["13"]) == true {
            model.haveDinner = true
        }
        
        model.channelPrice = json["channelPrice"].float
        
        model.isChannel = json["isChannel"].stringValue
        model.stockCountDesc =  json["stockCountDesc"].stringValue
        model.surplusBuyNum =  json["surplusBuyNum"].intValue
        model.limitBuyNum =  json["limitBuyNum"].intValue
        model.limitBuyDesc =  json["limitBuyDesc"].stringValue
        model.productionTime = json["productionTime"].stringValue
        model.spuCode = json["spuCode"].stringValue
        // 有效期
        model.deadLine = json["deadLine"].stringValue
        if let dealStr = model.deadLine , dealStr.isEmpty == false {
        }else {
            // 无值...<兼容店铺馆促销接口返回key>
            model.deadLine = json["dead_line"].stringValue
        }
        
        model.slowPay = json["slowPay"].boolValue
        model.holdPrice = json["holdPrice"].boolValue
        
        model.statusComplain =  json["statusComplain"].stringValue
        model.discountPrice = json["discountPrice"].stringValue
        model.discountPriceDesc = json["discountPriceDesc"].stringValue
        model.buyQtDesc = json["buyQtDesc"].stringValue
        if let _ = json["productStatus"].bool {
            model.productStatus = json["productStatus"].boolValue
        }
        model.shareStockCount = json["shareStockCount"].intValue
        model.stockIsLocal = json["stockIsLocal"].boolValue
        model.stockToDate = json["stockToDate"].stringValue
        model.stockToFromWarhouseId = json["stockToFromWarhouseId"].intValue
        model.stockToFromWarhouseName = json["stockToFromWarhouseName"].stringValue
        model.drugSecondCategoryName = json["drugSecondCategoryName"].stringValue
        model.drugSecondCategory = json["drugSecondCategory"].stringValue
        model.shareStockDesc = json["shareStockDesc"].stringValue
        model.shopName = json["shopName"].stringValue
        for cartModel in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode ==  model.productId && cartOfInfoModel.supplyId.intValue == Int(model.vendorId) {
                    model.carOfCount = cartOfInfoModel.buyNum.intValue
                    model.carId = cartOfInfoModel.cartId.intValue
                    break
                }
            }
        }
        model.ziyingTag = json["ziyingTag"].stringValue
        if let app_short_name = json["app_short_name"].string, app_short_name.isEmpty == false {
            model.ziyingTag = app_short_name
        }
        model.exclusivePrice = json["exclusivePrice"].doubleValue
        model.doorsill = json["doorsill"].intValue
        model.referencePrice = json["referencePrice"].doubleValue
        return model
    }
    
    func checkoutIsChannel() -> Bool {
        if let strIsChannel = self.isChannel {
            if strIsChannel == "1" {
                return true
            }else {
                return false
            }
        }else{
            return false
        }
    }
    //判断显示不显示专享价
    func isShowExclusivePrice() -> Bool {
        if let exclusivePrice = self.exclusivePrice,exclusivePrice > 0{
            if let promotionNum =  productPromotion?.promotionPrice , promotionNum > 0  {
                //特价
                if  promotionNum > Float(exclusivePrice){
                    return true
                }else{
                    return false
                }
            }else if let _ = vipPromotionId, let vipNum = visibleVipPrice, vipNum > 0 {
                if let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0 {
                    //会员
                    if  vipAvailableNum > Float(exclusivePrice){
                        return true
                    }else{
                        return false
                    }
                }
            }else if let orginPrice = productPrice, orginPrice > 0 {
                //原价
                if  orginPrice > Float(exclusivePrice){
                    return true
                }else{
                    return false
                }
            }else{
                return true
            }
        }
        return false
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
    //获取多品满折的活动
    func getMZPromotionInfo() -> PromotionModel? {
        if self.promotionList != nil{
            for model in self.promotionList!{
                let promotionModel = model as  PromotionModel
                if  promotionModel.promotionType == 16{
                    return promotionModel
                }
            }
        }
        return nil
    }
    //获取满减文字描述
    func getMJPromotionDes() -> String {
        var des = ""
        if let promotonList = self.promotionList, promotonList.count > 0 {
            let predicate: NSPredicate = NSPredicate(format: "self.stringPromotionType IN %@",["2","3"])
            let result = (promotonList as NSArray).filtered(using: predicate)
            if result.count > 0 {
                for promotionModel in result {
                    if let model =  promotionModel as? PromotionModel {
                        des = des + (model.promotionDesc ?? "")
                    }
                }
            }
        }
        return des
    }
    
    func isHasSomeKindPromotion(_ promotionTypeArray:[String]) -> Bool {
        if let promotonList = self.promotionList, promotonList.count > 0 {
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
    //判断是否有底价活动
    func isHasBasePriceKindPromotion(_ promotionTypeArray:[String]) -> Bool {
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
    
    //MARK:判断是搭配套餐还是固定套餐(true 固定 false：搭配)
    func isComboProudct() -> Bool {
        if let arr = self.productPromotionInfos,arr.count > 0 {
            for infoModel in arr {
                if infoModel.promotionRule == 2 {
                    return true
                }
            }
        }
        return false
    }
    
    
}

//手动解析返利专区列表
extension HomeProductModel {
    //解析数据
    static func parseProfitProductArr(_ dic:[String : AnyObject]) -> HomeProductModel{
        let json = JSON(dic)
        let model = HomeProductModel()
        
        model.productPrimeryKey = json["productId"].intValue
        if json["spuCode"].string != nil {
            model.productId = json["spuCode"].stringValue
        }else{
            model.productId = json["productId"].stringValue
        }
        model.productPicUrl = json["mainImg"].stringValue
        model.productName = json["productName"].stringValue
        model.shortName = json["shortName"].stringValue
        model.spec = json["spec"].stringValue
        model.unit = json["unit"].stringValue
        model.factoryName = json["factoryName"].stringValue
        model.factoryId = json["factoryId"].intValue
        model.vendorName = json["sellerName"].stringValue
        model.vendorId = json["sellerCode"].intValue
        
        if json["ziyingFlag"].int != nil  {
            model.isZiYingFlag = json["ziyingFlag"].intValue
        }else{
            model.isZiYingFlag = 3// 没返回的赋值
        }
        // 有效期
        model.deadLine = json["deadline"].stringValue
        if let dealStr = model.deadLine , dealStr.isEmpty == false {
        }else {
            // 无值...<兼容店铺馆促销接口返回key>
            model.deadLine = json["dead_line"].stringValue
        }
        model.productionTime = json["producedTime"].stringValue
        
        model.limitBuyNum =  json["weekLimitNum"].intValue
        let dic = json["promotionInfo"].dictionaryObject
        if let _ = dic {
            let t = dic! as NSDictionary
            model.productPromotion = t.mapToObject(ProductPromotionModel.self)
        }else{
            model.productPromotion = nil
        }
        
        model.stockCount = json["inventoryNum"].intValue
        model.stepCount = json["minPackage"].intValue
        if json["minPackage"].int != nil && json["minPackage"].int != 0 {
            model.stepCount = json["minPackage"].intValue
        }else{
            model.stepCount = 1
        }
        
        //共享库存相关
        model.stockIsLocal = json["stockIsLocal"].boolValue
        model.surplusBuyNum =  json["surplusBuyNum"].intValue //限购剩余数量
        model.limitInfo = json["limitInfo"].stringValue   // 限购标签
        model.includeCouponTemplateIds = json["includeCouponTemplateIds"].stringValue   // 优惠券标签
        model.isRebate = json["isRebate"].intValue //返利金标签
        model.haveDinner = json["haveDinner"].boolValue//套餐标签
        model.protocolRebate = json["protocolRebate"].boolValue//协议返利金
        //判断满减满赠标签
        model.promotionList = [PromotionModel]()
        if let promos = json["promotionList"].arrayObject {
            promos.forEach({ (dic) in
                if let jsonDic =  dic as? [String : AnyObject] {
                    let jsonList = JSON(jsonDic)
                    let promotionModel = PromotionModel()
                    //未使用
                    promotionModel.limitNum = Int(jsonList["limit_num"].stringValue)
                    promotionModel.promotionId = jsonList["promotion_id"].stringValue
                    promotionModel.levelIncre = Int(jsonList["level_incre"].stringValue)
                    promotionModel.promotionMethod = Int(jsonList["promotion_method"].stringValue)
                    promotionModel.promotionPre = Int(jsonList["promotion_pre"].stringValue)
                    //判断类型
                    promotionModel.promotionType = Int(jsonList["promotion_type"].stringValue)
                    model.promotionList?.append(promotionModel)
                }
            })
        }
        model.limitBuyDesc =  json["limitBuyDesc"].stringValue // 已达限购总数时，点击按钮的提示
        //二级分类名
        model.drugSecondCategoryName = json["drugSecondCategoryName"].stringValue
        //分享库存信息
        model.shareStockDesc = json["shareStockDesc"].stringValue
        
        //价格相关------------------------------------------------------------
        let priceInfo = json["priceInfo"].dictionaryValue
        let priceInfoJson = JSON(priceInfo)
        model.productPrice = Float(priceInfoJson["price"].stringValue)
        model.recommendPrice = Float(priceInfoJson["recommendPrice"].stringValue)
        model.statusDesc = Int(priceInfoJson["status"].stringValue)
        model.channelPrice =  Float(priceInfoJson["channelPrice"].stringValue)
        model.discountPrice =  priceInfoJson["discountPrice"].stringValue
        model.discountPriceDesc = priceInfoJson["discountPriceDesc"].stringValue
        
        //vip相关字段---------------------------------------------------------
        let vipPromotionInfo = json["vipPromotionInfo"].dictionaryValue
        let vipPromotionInfoJson = JSON(vipPromotionInfo)
        //vip字段
        model.availableVipPrice = 0
        if let vipAvailablePriceNum = Float(vipPromotionInfoJson["availableVipPrice"].stringValue),vipAvailablePriceNum > 0{
            model.availableVipPrice = vipAvailablePriceNum
        }
        model.visibleVipPrice = 0
        if let vipPriceNum = Float(vipPromotionInfoJson["visibleVipPrice"].stringValue),vipPriceNum > 0{
            model.visibleVipPrice = vipPriceNum
        }
        model.vipLimitNum = 0
        if let vipNum = Int(vipPromotionInfoJson["vipLimitNum"].stringValue),vipNum > 0{
            model.vipLimitNum = vipNum
        }
        model.vipPromotionId = vipPromotionInfoJson["vipPromotionId"].stringValue
        model.drugSecondCategory = json["drugSecondCategory"].stringValue
        model.stockCountDesc =  json["stockDesc"].stringValue
        //未使用
        //返回了
        model.productCodeCompany = json["productCodeCompany"].stringValue
        model.shopName = json["shopName"].stringValue
        
        let specialDic = json["specialPromotion"].dictionaryObject
        if let _ = specialDic {
            let t = specialDic! as NSDictionary
            model.productPromotion = t.mapToObject(ProductPromotionModel.self)
        }else{
            model.productPromotion = nil
        }
        //未返回
        //        model.baseCount = json["baseCount"].intValue
        //        model.couponFlag = json["couponFlag"].intValue
        //        if let promoInfos = json["productPromotionInfos"].arrayObject {
        //            model.productPromotionInfos = (promoInfos as NSArray).mapToObjectArray(ProductPromotionInfo.self)
        //        }else{
        //            model.productPromotionInfos = [ProductPromotionInfo]()
        //        }
        //        model.isChannel = json["isChannel"].stringValue
        
        //        model.statusComplain =  json["statusComplain"].stringValue
        //        if let _ = json["productStatus"].bool {
        //            model.productStatus = json["productStatus"].boolValue
        //        }
        //        model.shareStockCount = json["shareStockCount"].intValue
        //        model.stockToFromWarhouseId = json["stockToFromWarhouseId"].intValue
        //        model.stockToFromWarhouseName = json["stockToFromWarhouseName"].stringValue
        //        model.stockToDate = json["stockToDate"].stringValue //调拨周期（天）
        //        model.activityDescription = json["description"].stringValue
        
        for cartModel in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode ==  model.productId && cartOfInfoModel.supplyId.intValue == Int(model.vendorId) {
                    model.carOfCount = cartOfInfoModel.buyNum.intValue
                    model.carId = cartOfInfoModel.cartId.intValue
                    break
                }
            }
        }
        
        model.ziyingTag = json["ziyingWarehouseName"].stringValue
        
        return  model
    }
}

//MARK: - 手动解析订单列表的推荐品商品对象
extension HomeProductModel {
    /// 手动解析订单列表的推荐品商品对象
    @objc static func transformOrderListModelToHomeProductModel(_ dic:[String : AnyObject]) -> HomeProductModel{
        let json = JSON(dic)
        let model = HomeProductModel()
        model.cellType = 2
        model.productPrimeryKey = json["productId"].intValue
        if json["spuCode"].string != nil {
            model.productId = json["spuCode"].stringValue
        }else{
            model.productId = json["productId"].stringValue
        }
        model.productPicUrl = json["mainImg"].stringValue
        model.productName = json["productName"].stringValue
        model.shortName = json["shortName"].stringValue
        model.spec = json["spec"].stringValue
        model.unit = json["unit"].stringValue
        model.factoryName = json["factoryName"].stringValue
        model.factoryId = json["factoryId"].intValue
        model.vendorName = json["sellerName"].stringValue
        model.vendorId = json["sellerCode"].intValue
        
        if json["ziyingFlag"].int != nil  {
            model.isZiYingFlag = json["ziyingFlag"].intValue
        }else{
            model.isZiYingFlag = 3// 没返回的赋值
        }
        // 有效期
        model.deadLine = json["deadline"].stringValue
        if let dealStr = model.deadLine , dealStr.isEmpty == false {
        }else {
            // 无值...<兼容店铺馆促销接口返回key>
            model.deadLine = json["dead_line"].stringValue
        }
        model.productionTime = json["producedTime"].stringValue
        
        model.limitBuyNum =  json["weekLimitNum"].intValue
        let dic = json["promotionInfo"].dictionaryObject
        if let _ = dic {
            let t = dic! as NSDictionary
            model.productPromotion = t.mapToObject(ProductPromotionModel.self)
        }else{
            model.productPromotion = nil
        }
        
        model.stockCount = json["inventoryNum"].intValue
        model.stepCount = json["minPackage"].intValue
        if json["minPackage"].int != nil && json["minPackage"].int != 0 {
            model.stepCount = json["minPackage"].intValue
        }else{
            model.stepCount = 1
        }
        
        //共享库存相关
        model.stockIsLocal = json["stockIsLocal"].boolValue
        model.surplusBuyNum =  json["surplusBuyNum"].intValue //限购剩余数量
        model.limitInfo = json["limitInfo"].stringValue   // 限购标签
        model.includeCouponTemplateIds = json["includeCouponTemplateIds"].stringValue   // 优惠券标签
        model.isRebate = json["isRebate"].intValue //返利金标签
        model.haveDinner = json["haveDinner"].boolValue//套餐标签
        model.protocolRebate = json["protocolRebate"].boolValue//协议返利金
        //判断满减满赠标签
        model.promotionList = [PromotionModel]()
        if let promos = json["promotionList"].arrayObject {
            promos.forEach({ (dic) in
                if let jsonDic =  dic as? [String : AnyObject] {
                    let jsonList = JSON(jsonDic)
                    let promotionModel = PromotionModel()
                    //未使用
                    promotionModel.limitNum = Int(jsonList["limit_num"].stringValue)
                    promotionModel.promotionId = jsonList["promotion_id"].stringValue
                    promotionModel.levelIncre = Int(jsonList["level_incre"].stringValue)
                    promotionModel.promotionMethod = Int(jsonList["promotion_method"].stringValue)
                    promotionModel.promotionPre = Int(jsonList["promotion_pre"].stringValue)
                    //判断类型
                    promotionModel.promotionType = Int(jsonList["promotion_type"].stringValue)
                    model.promotionList?.append(promotionModel)
                }
            })
        }
        model.limitBuyDesc =  json["limitBuyDesc"].stringValue // 已达限购总数时，点击按钮的提示
        //二级分类名
        model.drugSecondCategoryName = json["drugSecondCategoryName"].stringValue
        //分享库存信息
        model.shareStockDesc = json["shareStockDesc"].stringValue
        
        //价格相关------------------------------------------------------------
        let priceInfo = json["priceInfo"].dictionaryValue
        let priceInfoJson = JSON(priceInfo)
        model.productPrice = Float(priceInfoJson["price"].stringValue)
        model.recommendPrice = Float(priceInfoJson["recommendPrice"].stringValue)
        model.statusDesc = Int(priceInfoJson["status"].stringValue)
        model.channelPrice =  Float(priceInfoJson["channelPrice"].stringValue)
        model.discountPrice =  priceInfoJson["discountPrice"].stringValue
        model.discountPriceDesc = priceInfoJson["discountPriceDesc"].stringValue
        
        //vip相关字段---------------------------------------------------------
        let vipPromotionInfo = json["vipPromotionInfo"].dictionaryValue
        let vipPromotionInfoJson = JSON(vipPromotionInfo)
        //vip字段
        model.availableVipPrice = 0
        if let vipAvailablePriceNum = Float(vipPromotionInfoJson["availableVipPrice"].stringValue),vipAvailablePriceNum > 0{
            model.availableVipPrice = vipAvailablePriceNum
        }
        model.visibleVipPrice = 0
        if let vipPriceNum = Float(vipPromotionInfoJson["visibleVipPrice"].stringValue),vipPriceNum > 0{
            model.visibleVipPrice = vipPriceNum
        }
        model.vipLimitNum = 0
        if let vipNum = Int(vipPromotionInfoJson["vipLimitNum"].stringValue),vipNum > 0{
            model.vipLimitNum = vipNum
        }
        model.vipPromotionId = vipPromotionInfoJson["vipPromotionId"].stringValue
        model.drugSecondCategory = json["drugSecondCategory"].stringValue
        model.stockCountDesc =  json["stockDesc"].stringValue
        //未使用
        //返回了
        model.productCodeCompany = json["productCodeCompany"].stringValue
        model.shopName = json["shopName"].stringValue
        
        let specialDic = json["specialPromotion"].dictionaryObject
        if let _ = specialDic {
            let t = specialDic! as NSDictionary
            model.productPromotion = t.mapToObject(ProductPromotionModel.self)
        }else{
            model.productPromotion = nil
        }
        //未返回
        //        model.baseCount = json["baseCount"].intValue
        //        model.couponFlag = json["couponFlag"].intValue
        //        if let promoInfos = json["productPromotionInfos"].arrayObject {
        //            model.productPromotionInfos = (promoInfos as NSArray).mapToObjectArray(ProductPromotionInfo.self)
        //        }else{
        //            model.productPromotionInfos = [ProductPromotionInfo]()
        //        }
        //        model.isChannel = json["isChannel"].stringValue
        
        //        model.statusComplain =  json["statusComplain"].stringValue
        //        if let _ = json["productStatus"].bool {
        //            model.productStatus = json["productStatus"].boolValue
        //        }
        //        model.shareStockCount = json["shareStockCount"].intValue
        //        model.stockToFromWarhouseId = json["stockToFromWarhouseId"].intValue
        //        model.stockToFromWarhouseName = json["stockToFromWarhouseName"].stringValue
        //        model.stockToDate = json["stockToDate"].stringValue //调拨周期（天）
        //        model.activityDescription = json["description"].stringValue
        
        for cartModel in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode ==  model.productId && cartOfInfoModel.supplyId.intValue == Int(model.vendorId) {
                    model.carOfCount = cartOfInfoModel.buyNum.intValue
                    model.carId = cartOfInfoModel.cartId.intValue
                    break
                }
            }
        }
        
        model.ziyingTag = json["ziyingWarehouseName"].stringValue
        
        return  model
    }
}
extension HomeProductModel{
    //解析数据把mp 商品转成搜索model
    static func parseMPHockProduct(_ dic:[String : AnyObject]) -> HomeProductModel{
        let j = JSON(dic)
        let model = HomeProductModel()
        
        // model.bigPacking = j["bigPacking"].stringValue
        model.stepCount = j["minimumPacking"].intValue
        model.productPrice = j["price"].floatValue
        //   model.priceDesc = j["priceDesc"].stringValue
        // model.limitNum = j["limitNum"].stringValue
        model.isChannel = j["isChannel"].stringValue
        //  model.priceStatus = j["priceStatus"].stringValue
        
        if j["spuCode"].string != nil {
            model.productId = j["spuCode"].stringValue
        }else{
            model.productId = j["productId"].stringValue
        }
        model.productName = j["productName"].stringValue
        model.shortName = j["productName"].stringValue
        if model.shortName == nil {
            model.shortName = model.productName
        }
        model.productPicUrl = j["productPicPath"].stringValue
        model.statusDesc = j["priceStatus"].intValue
        model.productCodeCompany  = j["productcodeCompany"].stringValue
        model.vendorId = j["sellerCode"].intValue
        //model.showPrice = j["showPrice"].stringValue
        model.spec = j["spec"].stringValue
        model.spuCode = j["spuCode"].stringValue
        model.unit = j["unitName"].stringValue
        model.limitBuyNum  = j["weekLimitNum"].intValue
        model.deadLine = j["deadLine"].stringValue
        model.factoryName = j["factoryName"].stringValue
        model.vendorName = j["frontSellerName"].stringValue
        model.stockCountDesc = j["stockCountDesc"].stringValue
        model.productionTime = j["productionTime"].stringValue
        model.stockCount =  j["stockCount"].intValue
        
        model.promotionList = [PromotionModel]()
        if let promos = j["fullDiscountPromotion"].dictionaryObject {
            let jsonList = JSON(promos)
            let promotionModel = PromotionModel()
            //未使用
            promotionModel.limitNum = Int(jsonList["limit_num"].stringValue)
            promotionModel.promotionId = jsonList["promotion_id"].stringValue
            promotionModel.levelIncre = Int(jsonList["level_incre"].stringValue)
            promotionModel.promotionMethod = Int(jsonList["promotion_method"].stringValue)
            promotionModel.promotionPre = Int(jsonList["promotion_pre"].stringValue)
            //判断类型
            promotionModel.promotionType = Int(jsonList["promotion_type"].stringValue)
            model.promotionList?.append(promotionModel)
            
        }
        
        let specialDic = j["specialPromotion"].dictionaryObject
        if let _ = specialDic {
            let t = specialDic! as NSDictionary
            model.productPromotion = t.mapToObject(ProductPromotionModel.self)
        }else{
            model.productPromotion = nil
        }
        model.surplusBuyNum =  j["surplusBuyNum"].intValue //限购剩余数量
        //
        //model.isZiYingFlag = 3
        
        for cartModel in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode ==  model.productId && cartOfInfoModel.supplyId.intValue == Int(model.vendorId) {
                    model.carOfCount = cartOfInfoModel.buyNum.intValue
                    model.carId = cartOfInfoModel.cartId.intValue
                    break
                }
            }
        }
        
        return  model
    }
    //    func initModelWithMpHockModel(_ orginModel:  SearchMpHockProductModel) {
    //        self.productPrimeryKey = orginModel.productPrimeryKey
    //
    //        self.productId = orginModel.productId
    //
    //        self.productPicUrl = orginModel.productPicUrl
    //        self.productName =  orginModel.productName
    //        self.shortName = orginModel.shortName
    //        self.spec = orginModel.spec
    //        self.unit = orginModel.unit
    //        self.productPrice = orginModel.productPrice
    //        //vip字段
    //
    //        self.availableVipPrice = orginModel.availableVipPrice
    //
    //
    //        self.visibleVipPrice = orginModel.visibleVipPrice
    //
    //        self.vipLimitNum = orginModel.vipLimitNum
    //
    //        self.vipPromotionId = orginModel.vipPromotionId
    //        self.recommendPrice = orginModel.recommendPrice
    //        self.stockCount = orginModel.stockCount
    //        self.baseCount =  orginModel.baseCount
    //        self.stepCount = orginModel.stepCount
    //
    //        self.stepCount = orginModel.stepCount
    //
    //        self.statusDesc =  orginModel.statusDesc
    //        self.factoryName = orginModel.factoryName
    //        self.factoryId = orginModel.factoryId
    //        self.vendorName =  orginModel.vendorName
    //        self.vendorId = orginModel.vendorId
    //
    //        self.isZiYingFlag =  orginModel.isZiYingFlag
    //
    //
    //        self.activityDescription = orginModel.productCodeCompany
    //        self.productCodeCompany = orginModel.productCodeCompany
    //        self.limitInfo =   orginModel.limitInfo // 限购
    //        self.includeCouponTemplateIds =  orginModel.includeCouponTemplateIds  // 优惠券
    //        self.isRebate =   orginModel.isRebate//返利金
    //        self.haveDinner =  orginModel.haveDinner//套餐
    //        self.protocolRebate = orginModel.protocolRebate//协议返利金
    //        self.couponFlag = orginModel.couponFlag
    //
    //
    //        self.productPromotion =  orginModel.productPromotion
    //
    //        self.promotionList = orginModel.promotionList
    //
    //
    //        self.productPromotionInfos =  orginModel.productPromotionInfos
    //
    //        self.channelPrice = orginModel.channelPrice
    //
    //        self.isChannel = orginModel.isChannel
    //        self.stockCountDesc = orginModel.stockCountDesc
    //        self.surplusBuyNum = orginModel.surplusBuyNum
    //        self.limitBuyNum = orginModel.limitBuyNum
    //        self.limitBuyDesc = orginModel.limitBuyDesc
    //        self.productionTime =  orginModel.productionTime
    //        // 有效期
    //        self.deadLine = orginModel.deadLine
    //
    //
    //        self.statusComplain =   orginModel.statusComplain
    //        self.discountPrice =  orginModel.discountPrice
    //        self.discountPriceDesc =  orginModel.discountPriceDesc
    //
    //        self.productStatus =   orginModel.productStatus
    //
    //        self.shareStockCount =  orginModel.shareStockCount
    //        self.stockIsLocal =  orginModel.stockIsLocal
    //        self.stockToDate =  orginModel.stockToDate
    //        self.stockToFromWarhouseId = orginModel.stockToFromWarhouseId
    //        self.stockToFromWarhouseName = orginModel.stockToFromWarhouseName
    //        self.drugSecondCategoryName = orginModel.drugSecondCategoryName
    //        self.drugSecondCategory =  orginModel.drugSecondCategory
    //        self.shareStockDesc =  orginModel.shareStockDesc
    //        self.shopName = orginModel.shopName
    //
    //        self.ziyingTag =  orginModel.ziyingTag
    //    }
    
}
