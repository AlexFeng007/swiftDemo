//
//  ShopItemModel.swift
//  FKY
//
//  Created by 乔羽 on 2018/4/24.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

// 店铺首页图片Model
struct ShopAdModel: JSONAbleType {
    
    var ad_pic: String?
    var ad_pic_url: String?
    var id: Int?
    var shop_id: Int?
    var type: Int?
    
    static func fromJSON(_ data: [String : AnyObject]) -> ShopAdModel {
        let json = JSON(data)
        let ad_pic = json["ad_pic"].stringValue
        let ad_pic_url = json["ad_pic_url"].stringValue
        let id = json["id"].intValue
        let shop_id = json["shop_id"].intValue
        let type = json["type"].intValue
        return ShopAdModel(ad_pic: ad_pic, ad_pic_url: ad_pic_url, id: id, shop_id: shop_id, type: type)
    }
    
}

struct ShopQcModel: JSONAbleType {
    // 资质图片
    var filePath: String
    var typeName: String
    
    static func fromJSON(_ data: [String : AnyObject]) -> ShopQcModel {
        let json = JSON(data)
        let filepath = json["filePath"].stringValue
        let typename = json["typeName"].stringValue
        return ShopQcModel(filePath: filepath, typeName: typename)
    }
}

// 店铺信息Model
struct ShopDetailModel: JSONAbleType {
    //店铺头部字段
    var enterpriseName: String?//店铺名称
    var enterpriseLogoPic : String? //店铺logo
    var enterpriseCellphone: String?//店铺手机号
    var enterpriseTelephone: String?//店铺座机
    var orderSamountOut : String? //起售金额
    var orderSamount: String?
    var notice: String? //店铺公告
    //企业信息
    var address: String? //注册地址
    var enterprisePostcode: String?//邮编
    var legalPersonname :String? //法定代表人
    var enterpriseWebsite :String?//企业网站
    var checkInTime :String? //入住时间
    var formalIntroduction : String? //企业介绍
    
    var qcList: Array<ShopQcModel>? //店铺资质图片列表
    var accountProcedure: String? //开户流程说明
    var drugScope: String? // 经营范围
    var deliveryArea: String? // 销售区域
    var deliveryInstruction: String? // 物流配送
    var afterSale: String? // 售后服务
    
    static func fromJSON(_ data: [String : AnyObject]) -> ShopDetailModel {
        var model = ShopDetailModel()
        
        let json = JSON(data)
        model.enterpriseName = json["enterprise_name"].stringValue
        model.enterpriseLogoPic = json["formal_logo_pic"].stringValue
        model.enterpriseCellphone = json["enterprise_cellphone"].stringValue
        model.enterpriseTelephone = json["enterprise_telephone"].stringValue
        model.orderSamountOut = json["order_samount_out"].stringValue
        model.orderSamount = json["order_samount"].stringValue
        model.notice = json["notice"].stringValue
        
        model.address = json["address"].stringValue
        model.enterprisePostcode = json["enterprise_postcode"].stringValue
        model.legalPersonname = json["legal_personname"].stringValue
        model.enterpriseWebsite = json["enterprise_website"].stringValue
        model.checkInTime = json["checkInTime"].stringValue
        model.formalIntroduction = json["formal_introduction"].stringValue
        let qclist = json["qcList"].arrayObject
        var qcList: [ShopQcModel]? = []
        if let list = qclist{
            qcList = (list as NSArray).mapToObjectArray(ShopQcModel.self)
        }
        model.qcList = qcList
        
        model.accountProcedure = json["account_procedure"].stringValue
        model.drugScope = json["drugScope"].stringValue
        model.deliveryArea = json["deliveryArea"].stringValue
        model.deliveryInstruction = json["delivery_instruction"].stringValue
        model.afterSale = json["after_sale"].stringValue
        
        return model
    }
}

//商店首页模型
struct ShopFloorInfoModel : JSONAbleType {
    var theme : String? //类型
    var shopProList : Array<ShopProductCellModel>?
    static func fromJSON(_ data: [String : AnyObject]) -> ShopFloorInfoModel {
        let json = JSON(data)
        let theme = json["theme"].stringValue
        let dataList = json["proList"].arrayObject
        var shopProList: [ShopProductCellModel]? = []
        if let list = dataList {
            shopProList = (list as NSArray).mapToObjectArray(ShopProductCellModel.self)
        }
        return ShopFloorInfoModel.init(theme: theme, shopProList: shopProList)
    }
    
}

//商品列表cell模型
final class ShopProductCellModel : NSObject, JSONAbleType {
    var prdPic : String? //商品图片
    var spec : String? //规格
    var stockAmount : Int? //库存数量
    var stockCountDesc: String? //库存描述 有货？库存紧张
    var stockDesc : String? //库存描述
    var factoryNameCn : String? //生产厂家
    var factoryId: String? //生产厂家id
    var productPrice : Float? //价格
    var availableVipPrice : Float?         //可用会员价（会员才有这个字段）
    var visibleVipPrice : Float?           //可见会员价（非会员和会员都有）
    var vipLimitNum : Int?            //vip限购数量
    var vipPromotionId :String?            //vip活动id
    var unit : String? //单位
    var shortName : String? //产品名+规格
    var productFullName: String?{ //商品全名 名字加规格
        get {
            return (shortName ?? "") + " " + (spec ?? "")
        }
    }
    var productName : String? //产品名
    var statusDesc : Int? //采购权限
    var productPromotion: ShopItemProductPromotionModel?
    var productId :String?//产品id
    var limitBuyDesc : String? //限购提示文案
    var promotionList: [ShopItemPromotionModel]? //
    var limitInfo: String?     // 限购(打标)
    var includeCouponTemplateIds :String? //优惠券(打标)...<搜索、店铺>...[字符串不为空则打标]
    var isRebate : Int?//是否有返利，0无1有
    var haveDinner : Bool? //ture 有套餐 false 无套餐
    var limitCanBuyNumber : Int=0 //限购数量
    var stepCount: Int = 1 //最小加车数量
    var surplusBuyNum: Int? //剩余购买数量
    var weekLimitNum : Int? //周限购数量
    var countOfWeekLimit : Int?//已经使用的数量
    var deadLine: String? // 有效期
    var productionTime: String? // 生产日期
    
    var vendorId : Int?//供应商id
    var vendorName : String?//供应商名称
    
    var discountPrice: String?                  // 折后价
    var discountPriceDesc: String?                  // 折后价
    
    var hotSell : HotSellDtoModel?     //热销版模型
    
    //购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
    var carId :Int = 0
    var carOfCount :Int = 0
    
    // 无用字段
    // var activityDescription : String? // 与供应商相关，去掉
    var productPrimeryKey : String? //不确定字段(源代码取产品id)
    var productCodeCompany : String? //
    
    // 不可购买增加解释说明
    var productStatus: Bool = true              // 商品是否能够购买 YES-可购买 NO-不可购买
    var statusComplain: String?                 // 商品不可购买原因
    
    //分享库存
    /**
     *前端可售库存(业务计算)
     */
    var   shareStockCount: Int?
    
    /**
     * 是否本地仓库存
     */
    var   stockIsLocal:Bool?
    
    /**
     * 调拨周期（天）
     */
    var  stockToDays: Int?
    
    /**
     * 库存调拨仓ID
     */
    var  stockToFromWarhouseId: Int?
    
    /**
     * 二级分类类名
     */
    var drugSecondCategoryName: String?
    
    /**
     * 库存调拨仓名称
     */
    var stockToFromWarhouseName: String?
    
    //搜索热销增加字段
    
    /**
        * 库存调拨仓名称
        */
    var bigPacking: Int?
    /**
     * 热销排名
     * @return
     */
    var hotRank: Int?
    /**
     * 热销排行榜名称
     * @return
     */
    var hotRankName: String?
    
    var shareStockDesc: String?//分享库存描述
    var ziyingTag: String?//仓名
    var isZiYingFlag: Int = 0//  自营判断
    var storage: String?{ //可购买数量 1
           get {
             var numList:[String] = []
            //剩余限购数量
              if productPromotion != nil && productPromotion!.limitNum != nil && productPromotion!.limitNum! > 0{
                   numList.append(String(productPromotion!.limitNum!))
              }else if vipLimitNum != nil &&  vipLimitNum! > 0 {
                  if let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0{
                     numList.append(String(vipLimitNum!))
                 }
               }
            var canBuyNum = 0
            if (limitInfo != nil) &&  limitInfo?.isEmpty == false {
                 if let weekLimitNum =  weekLimitNum,let weekNum =  countOfWeekLimit,weekLimitNum - weekNum > 0  {
                   canBuyNum = weekLimitNum - weekNum
                 }else if  surplusBuyNum != nil &&  surplusBuyNum! > 0 {
                    canBuyNum = surplusBuyNum!
                 }
             }
              if let count = stockAmount ,count>0{
                  if (canBuyNum > count || canBuyNum == 0){
                     canBuyNum = count
                  }
              }
              numList.append(String(canBuyNum))
              return numList.count == 0 ? "0":numList.joined(separator: "|")
           }
     }
    var pm_price: String?{ //可购买价格  埋点专用 自定义
          get {
            var priceList:[String] = []
            //会员价 特价 原价
            if let promotionNum =  productPromotion?.promotionPrice , promotionNum > 0  {
                //特价
                 priceList.append(String(format: "%.2f",promotionNum))
            }else if let _ = vipPromotionId, let vipNum = visibleVipPrice, vipNum > 0 {
                if let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0 {
//                   //会员
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
//                          // 协议返利金
//                           if let rebate = protocolRebate, rebate == true {
//                             pmList.append("协议奖励金")
//                           }
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
    
    static func fromJSON(_ data: [String : AnyObject]) -> ShopProductCellModel {
        let json = JSON(data)
        
        let model =  ShopProductCellModel.init()
        model.hotRankName = json["hotRankName"].stringValue
        model.hotRank = json["hotRank"].intValue
        model.bigPacking = json["bigPacking"].intValue
        model.prdPic = json["pic_path"].stringValue
        model.spec = json["spec"].stringValue
        model.stockAmount = Int(json["stock_amount"].stringValue) ?? 0
        model.factoryNameCn = json["factory_name_cn"].stringValue
        model.factoryId = json["factory_name"].stringValue
        model.productPrice = json["channel_price"].floatValue
        if let vipAvailablePriceNum = Float(json["availableVipPrice"].stringValue),vipAvailablePriceNum > 0{
            model.availableVipPrice = vipAvailablePriceNum
        }
        if let vipPriceNum = Float(json["visibleVipPrice"].stringValue),vipPriceNum > 0{
            model.visibleVipPrice = vipPriceNum
        }
        if let vipNum = Int(json["vipLimitNum"].stringValue),vipNum > 0{
            model.vipLimitNum = vipNum
        }
        if let dic = json["hotSell"].dictionaryObject{
            model.hotSell = (dic as NSDictionary).mapToObject(HotSellDtoModel.self)
        }
        model.vipPromotionId = json["vipPromotionId"].stringValue
        model.unit = json["unit_cn"].stringValue
        model.shortName = json["short_name"].stringValue
        model.productName = json["product_name"].stringValue
        model.ziyingTag = json["ziyingTag"].stringValue
        if let tagStr = model.ziyingTag ,tagStr.count > 0 {
            model.isZiYingFlag = 1
        }else {
            model.isZiYingFlag = 0
        }
        model.statusDesc = json["statusDesc"].intValue
        let dic = json["productPromotion"].dictionaryObject
        if let _ = dic {
            let t = dic! as NSDictionary
            model.productPromotion = t.mapToObject(ShopItemProductPromotionModel.self)
        }
        if json["spu_code"].string != nil {
            model.productId = json["spu_code"].stringValue
        }else{
            model.productId = json["idd"].stringValue
        }
        model.limitBuyDesc = json["limitBuyDesc"].stringValue
        model.vendorId = json["seller_code"].intValue
        model.deadLine = json["dead_line"].stringValue
        model.productionTime = json["productionTime"].stringValue
        
        if let promos = json["productPromotionInfos"].arrayObject {
            model.promotionList = (promos as NSArray).mapToObjectArray(ShopItemPromotionModel.self)
        }
        model.limitInfo = json["limitInfo"].stringValue
        model.includeCouponTemplateIds = json["includeCouponTemplateIds"].stringValue
        model.isRebate = json["isRebate"].intValue
        model.haveDinner = json["haveDinner"].boolValue
        model.vendorName = json["seller_name"].stringValue
        model.limitCanBuyNumber = json["limitBuyNum"].intValue
        model.stockCountDesc = json["stockCountDesc"].stringValue
        model.stockDesc = json["stockDesc"].stringValue
        model.surplusBuyNum = json["surplusBuyNum"].intValue
        model.weekLimitNum = json["weekLimitNum"].intValue
        model.countOfWeekLimit = json["countOfWeekLimit"].intValue
        var stepCount = json["minimumBatch"].intValue
        if json["minimumBatch"].int != nil && json["minimumBatch"].int != 0 {
            stepCount = json["minimumBatch"].intValue
        }else{
            stepCount = 1
        }
        model.stepCount = stepCount
        
        model.productPrimeryKey = json["idd"].stringValue
        model.productCodeCompany = json["productcode_company"].stringValue
        model.drugSecondCategoryName = json["drugSecondCategoryName"].stringValue
        
        model.statusComplain = json["statusComplain"].stringValue
        var productStatus = true // 默认为true
        if json["productStatus"] != nil {
            // 若接口有返回当前字段，则取实际值
            productStatus = json["productStatus"].boolValue
        }
        model.productStatus = productStatus
        
        model.shareStockCount = json["shareStockCount"].intValue
        model.stockIsLocal = json["stockIsLocal"].boolValue
        model.stockToDays = json["stockToDays"].intValue
        model.stockToFromWarhouseId = json["stockToFromWarhouseId"].intValue
        model.stockToFromWarhouseName = json["stockToFromWarhouseName"].stringValue
        model.shareStockDesc = json["shareStockDesc"].stringValue
        
        model.discountPrice = json["discountPrice"].stringValue
        model.discountPriceDesc = json["discountPriceDesc"].stringValue
        
        for cartModel in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == model.productId && cartOfInfoModel.supplyId.intValue == model.vendorId {
                model.carOfCount = cartOfInfoModel.buyNum.intValue
                model.carId = cartOfInfoModel.cartId.intValue
                break
            }
        }
        
        return model
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
}

extension ShopProductCellModel: NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(prdPic, forKey: "prdPic")
        aCoder.encode(spec, forKey: "spec")
        aCoder.encode(stockAmount, forKey: "stockAmount")
        aCoder.encode(stockCountDesc, forKey: "stockCountDesc")
        aCoder.encode(stockDesc, forKey: "stockDesc")
        aCoder.encode(factoryNameCn, forKey: "factoryNameCn")
        aCoder.encode(factoryId, forKey: "factoryId")
        aCoder.encode(productPrice, forKey: "productPrice")
        aCoder.encode(visibleVipPrice, forKey: "visibleVipPrice")
        aCoder.encode(vipLimitNum, forKey: "vipLimitNum")
        aCoder.encode(vipPromotionId, forKey: "vipPromotionId")
        
        aCoder.encode(unit, forKey: "unit")
        aCoder.encode(shortName, forKey: "shortName")
        aCoder.encode(productName, forKey: "productName")
        aCoder.encode(statusDesc, forKey: "statusDesc")
        aCoder.encode(productPromotion, forKey: "productPromotion")
        aCoder.encode(productId, forKey: "productId")
        aCoder.encode(limitBuyDesc, forKey: "limitBuyDesc")
        
        aCoder.encode(promotionList, forKey: "promotionList")
        aCoder.encode(limitInfo, forKey: "limitInfo")
        aCoder.encode(includeCouponTemplateIds, forKey: "includeCouponTemplateIds")
        aCoder.encode(isRebate, forKey: "isRebate")
        aCoder.encode(limitCanBuyNumber, forKey: "limitCanBuyNumber")
        aCoder.encode(stepCount, forKey: "stepCount")
        aCoder.encode(surplusBuyNum, forKey: "surplusBuyNum")
        aCoder.encode(weekLimitNum, forKey: "weekLimitNum")
        aCoder.encode(countOfWeekLimit, forKey: "countOfWeekLimit")
        aCoder.encode(vendorId, forKey: "vendorId")
        aCoder.encode(vendorName, forKey: "vendorName")
        aCoder.encode(carId, forKey: "carId")
        aCoder.encode(carOfCount, forKey: "carOfCount")
        aCoder.encode(productPrimeryKey, forKey: "productPrimeryKey")
        aCoder.encode(productCodeCompany, forKey: "productCodeCompany")
        aCoder.encode(productStatus, forKey: "productStatus")
        aCoder.encode(statusComplain, forKey: "statusComplain")
        aCoder.encode(deadLine, forKey: "deadLine")
        
        aCoder.encode(shareStockCount, forKey: "shareStockCount")
        aCoder.encode(stockIsLocal, forKey: "stockIsLocal")
        aCoder.encode(stockToDays, forKey: "stockToDays")
        aCoder.encode(stockToFromWarhouseId, forKey: "stockToFromWarhouseId")
        aCoder.encode(stockToFromWarhouseName, forKey: "stockToFromWarhouseName")
        aCoder.encode(shareStockDesc, forKey: "shareStockDesc")
        aCoder.encode(discountPrice, forKey: "discountPrice")
        aCoder.encode(discountPriceDesc, forKey: "discountPriceDesc")
        
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        prdPic = aDecoder.decodeObject(forKey: "prdPic") as? String
        spec = aDecoder.decodeObject(forKey: "spec") as? String
        stockAmount = aDecoder.decodeObject(forKey: "stockAmount") as? Int
        stockCountDesc = aDecoder.decodeObject(forKey: "stockCountDesc") as? String
        stockDesc = aDecoder.decodeObject(forKey: "stockDesc") as? String
        factoryNameCn = aDecoder.decodeObject(forKey: "factoryNameCn") as? String
        factoryId = aDecoder.decodeObject(forKey: "factoryId") as? String
        productPrice = aDecoder.decodeObject(forKey: "productPrice") as? Float
        visibleVipPrice = aDecoder.decodeObject(forKey: "visibleVipPrice") as? Float
        vipLimitNum = aDecoder.decodeObject(forKey: "vipLimitNum") as? Int
        vipPromotionId = aDecoder.decodeObject(forKey: "vipPromotionId") as? String
        unit = aDecoder.decodeObject(forKey: "unit") as? String
        shortName = aDecoder.decodeObject(forKey: "shortName") as? String
        productName = aDecoder.decodeObject(forKey: "productName") as? String
        statusDesc = aDecoder.decodeObject(forKey: "statusDesc") as? Int
        productPromotion = aDecoder.decodeObject(forKey: "productPromotion") as? ShopItemProductPromotionModel
        productId = aDecoder.decodeObject(forKey: "productId") as? String
        limitBuyDesc = aDecoder.decodeObject(forKey: "limitBuyDesc") as? String
        promotionList = aDecoder.decodeObject(forKey: "promotionList") as? [ShopItemPromotionModel]
        limitInfo = aDecoder.decodeObject(forKey: "limitInfo") as? String
        includeCouponTemplateIds = aDecoder.decodeObject(forKey: "includeCouponTemplateIds") as? String
        isRebate = aDecoder.decodeObject(forKey: "isRebate") as? Int
        deadLine = aDecoder.decodeObject(forKey: "deadLine") as? String
        
        if let  limitNumber = aDecoder.decodeObject(forKey: "limitCanBuyNumber") as? Int {
            limitCanBuyNumber = limitNumber
        }
        if let count = aDecoder.decodeObject(forKey: "stepCount") as? Int {
            stepCount = count
        }
        
        surplusBuyNum = aDecoder.decodeObject(forKey: "surplusBuyNum") as? Int
        weekLimitNum = aDecoder.decodeObject(forKey: "weekLimitNum") as? Int
        countOfWeekLimit = aDecoder.decodeObject(forKey: "countOfWeekLimit") as? Int
        vendorId = aDecoder.decodeObject(forKey: "vendorId") as? Int
        vendorName = aDecoder.decodeObject(forKey: "vendorName") as? String
        if let carid = aDecoder.decodeObject(forKey: "carId") as? Int {
            carId = carid
        }
        if let carCount = aDecoder.decodeObject(forKey: "carOfCount") as? Int {
            carOfCount = carCount
        }
        productPrimeryKey = aDecoder.decodeObject(forKey: "productPrimeryKey") as? String
        productCodeCompany = aDecoder.decodeObject(forKey: "productCodeCompany") as? String
        if let pStatus = aDecoder.decodeObject(forKey: "productStatus") as? Bool {
            productStatus = pStatus
        }
        statusComplain = aDecoder.decodeObject(forKey: "statusComplain") as? String
        
        shareStockCount = aDecoder.decodeObject(forKey: "shareStockCount") as? Int
        stockIsLocal = aDecoder.decodeObject(forKey: "stockIsLocal") as? Bool
        stockToDays = aDecoder.decodeObject(forKey: "stockToDays") as? Int
        stockToFromWarhouseId = aDecoder.decodeObject(forKey: "stockToFromWarhouseId") as? Int
        stockToFromWarhouseName = aDecoder.decodeObject(forKey: "stockToFromWarhouseName") as? String
        shareStockDesc = aDecoder.decodeObject(forKey: "shareStockDesc") as? String
        discountPrice = aDecoder.decodeObject(forKey: "discountPrice") as? String
        discountPriceDesc = aDecoder.decodeObject(forKey: "discountPriceDesc") as? String
        
    }
}

struct ShopAllProductModel: JSONAbleType {
    var totalCount: Int?
    var totalPages : Int?
    var allProduct: Array<ShopProductCellModel>? = []
    
    static func fromJSON(_ data: [String : AnyObject]) -> ShopAllProductModel {
        let json = JSON(data)
        let pageInfo = json["pageInfo"]
        let totalCount = pageInfo["paginator"]["totalCount"].intValue
        let totalPages = pageInfo["paginator"]["totalPages"].intValue
        let array = pageInfo["data"].arrayObject
        var list: [ShopProductCellModel]? = []
        if let arr = array{
            list = (arr as NSArray).mapToObjectArray(ShopProductCellModel.self)
        }
        return ShopAllProductModel(totalCount: totalCount,totalPages: totalPages, allProduct: list)
    }
}

// 店铺首页及店铺信息Model
struct ShopItemModel: JSONAbleType {
    var shopAdList: Array<ShopAdModel>?
    var shopDetail: ShopDetailModel?
    var shopFloorInfo: Array<ShopFloorInfoModel>?
    var shopPromotions: Array<ShopDetailPromotionModel>?
    var xiaonengId: String?//小能id
    
    static func fromJSON(_ data: [String : AnyObject]) -> ShopItemModel {
        var model = ShopItemModel()
        
        let json = JSON(data)
        
        let adList = json["tShopAdList"].arrayObject
        var shopAdList: [ShopAdModel]? = []
        if let list = adList{
            shopAdList = (list as NSArray).mapToObjectArray(ShopAdModel.self)
        }
        model.shopAdList = shopAdList
        
        let detail = json["tShop"].dictionaryObject
        var shopdetail: ShopDetailModel? = nil
        if let _ = detail {
            let d = detail! as NSDictionary
            shopdetail = d.mapToObject(ShopDetailModel.self)
        }
        model.shopDetail = shopdetail
        
        let floorList = json["floorInfo"].arrayObject
        var shopFloorList: [ShopFloorInfoModel]? = []
        if let list = floorList {
            shopFloorList = (list as NSArray).mapToObjectArray(ShopFloorInfoModel.self)
        }
        model.shopFloorInfo = shopFloorList
        
        model.xiaonengId = json["xiaoneng_id"].stringValue
        
        let promotions = json["promotionInfo"].arrayObject
        var shopPromotions: [ShopDetailPromotionModel]? = []
        if let list = promotions {
            shopPromotions = (list as NSArray).mapToObjectArray(ShopDetailPromotionModel.self)
        }
        model.shopPromotions = shopPromotions
        
        return model
    }
}
