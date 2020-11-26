//
//  OftenBuyProductModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/14.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  常购清单之接口返回数据model

import UIKit
import SwiftyJSON
import HandyJSON

final class OftenBuyProductModel: NSObject, JSONAbleType {
    var cityHotSale: OftenBuyProductListModel?      // 热销
    var frequentlyBuy: OftenBuyProductListModel?    // 常买
    var frequentlyView: OftenBuyProductListModel?   // 常看
    
    static func fromJSON(_ json: [String : AnyObject]) -> OftenBuyProductModel {
        let json = JSON(json)
        
        var cityHotSale: OftenBuyProductListModel?
        if let dic = json["cityHotSale"].dictionary {
            cityHotSale = (dic as NSDictionary).mapToObject(OftenBuyProductListModel.self)
        }
        
        var frequentlyBuy: OftenBuyProductListModel?
        if let dic = json["frequentlyBuy"].dictionary {
            frequentlyBuy = (dic as NSDictionary).mapToObject(OftenBuyProductListModel.self)
        }
        
        var frequentlyView: OftenBuyProductListModel?
        if let dic = json["frequentlyView"].dictionary {
            frequentlyView = (dic as NSDictionary).mapToObject(OftenBuyProductListModel.self)
        }
        
        let model = OftenBuyProductModel()
        model.cityHotSale = cityHotSale
        model.frequentlyBuy = frequentlyBuy
        model.frequentlyView = frequentlyView
        return model
    }
}


final class OftenBuyProductListModel: NSObject, JSONAbleType,HandyJSON {
    required override init() {}
    var pageId: String?                     // 当前页索引
    var pageSize: String?                   // 每页条数
    var totalItemCount: String?             // 总条数
    var totalPageCount: String?             // 总页数
    var floorName: String?                  // 标题
    var list: [OftenBuyProductItemModel]?   // 商品列表
    
    static func fromJSON(_ json: [String : AnyObject]) -> OftenBuyProductListModel {
        let json = JSON(json)
        
        var list: [OftenBuyProductItemModel]?
        if let arr = json["list"].arrayObject {
            list = (arr as NSArray).mapToObjectArray(OftenBuyProductItemModel.self)
        }
        
        let model = OftenBuyProductListModel()
        model.pageId = json["pageId"].stringValue
        model.pageSize = json["pageSize"].stringValue
        model.totalItemCount = json["totalItemCount"].stringValue
        model.totalPageCount = json["totalPageCount"].stringValue
        model.floorName = json["floorName"].stringValue
        model.list = list
        return model
    }
}

final class OftenBuyProductItemModel: NSObject, JSONAbleType,HandyJSON {
    required override init() {}
    var stockCountDesc : String? // 库存描述字段
    var sortNum: String? // 序号
    var spuCode: String? // 商品编码
    var spuName: String? // 商品名称
    var spec: String? // 规格
    var productFullName: String?{ //商品全名 名字加规格
        get {
            return (spuName ?? "") + " " + (spec ?? "")
        }
    }
    var factoryName: String? // 生产厂家
    var supplyName: String? // 供应商
    var supplyId: Int? // 供应商编号
    var isZiYingFlag: Int? // 是否是自营
    var promotionPrice: Float? // 客户组活动价
    var promotionlimitNum : Int? //特价限购
    var price: Float? // 客户组原价
    var availableVipPrice : Float?         //可用会员价（会员才有这个字段）
    var visibleVipPrice : Float?           //可见会员价（非会员和会员都有）
    var vipLimitNum : Int?            //vip限购数量
    var vipPromotionId :String?            //vip活动id
    var imgPath: String? // 图片地址
    var weeklyPurchaseLimit: Int? // 周限购量
    var surplusBuyNum: Int? // 本周剩余限购数量
    var miniPackage: String? // 最小拆零包装
    var wholeSaleNum: Int? // 最小起批量
    var productInventory: String? // 库存
    var expiryDate: String? // 有效期
    var productionTime: String? // 生产日期
    var disCountDesc : String? //折后约¥6.05
    var packageUnit  : String?  //药品单位
    var statusMsg : String? //商品状态描述
    var productDescType:NSInteger? //价优类型
    var sourceFrom: String? //来源
    var productDesc: String? //价优信息
    var pmDescription: String? //本月已售数量
    var shopExtendTag : String? //店铺扩展标签（商家，xx仓，旗舰店，加盟店）
    var shopExtendType : Int? //店铺扩展类型（0普通店铺，1旗舰店 2加盟店 3自营店）
    var pmCount: Int? { // 本月已售数量
        didSet {
            detailStr = "近一月售出\(String(describing: pmCount!))份"
        }
    }
    var pvCount: Int? { // 浏览次数
        didSet {
            detailStr = "近一月浏览\(String(describing: pvCount!))次"
        }
    }
    var orderCount: Int? { // 购买次数
        didSet {
            detailStr = "采购\(String(describing: orderCount!))次"
        }
    }
    //共享库存相关字段
    var stockToFromWarhouseId : Int? //库存调拨仓ID
    var shareStockDesc :String?// 共享仓文描
    
    var singleCanBuy :Int? //单品是否可购买，0-可购买，1-不可（显示套餐按钮）
    var dinnerPromotionRule :Int? // 2固定套餐 1 搭配套餐
    // 非接口返回字段
    var limitCanBuyNumber: Int = 0 // 限购数量
    var carId: Int = 0 // 购物车id
    var carOfCount: Int = 0 // 购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
    var detailStr: String = ""
    var productSign: ProductPromationSignModel? // 促销标签
    var storage: String?{ //可购买数量 1
          get {
               var numList:[String] = []
               //本周剩余限购数量
               if vipLimitNum != nil &&  vipLimitNum! > 0 {
                  if let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0{
                    numList.append(String(vipLimitNum!))
                  }
               }
              var canBuyNum = 0
              if  surplusBuyNum != nil && surplusBuyNum! > 0 {
                 canBuyNum = surplusBuyNum!
              }
              if let count = productInventory ,NSInteger(count)!>0{
               if (canBuyNum > NSInteger(count)! || canBuyNum == 0){
                  canBuyNum = NSInteger(count)!
               }
              }
             numList.append(String(canBuyNum))
             return numList.count == 0 ? "0":numList.joined(separator: "|")
          }
    }
    var pm_price: String?{ //可购买价格  埋点专用 自定义
              get {
                var priceList:[String] = []
                if let promotionNum =  promotionPrice , promotionNum > 0  {
                    //特价
                     priceList.append(String(format: "%.2f",promotionNum))
                }else if let _ = vipPromotionId, let vipNum = visibleVipPrice, vipNum > 0 {
                    if let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0 {
//                        //会员
                        priceList.append(String(format: "%.2f",vipAvailableNum))
                    }
                }
                //原价
               if let priceStr = price, priceStr > 0 {
                   priceList.append(String(format: "%.2f",priceStr))
               }
                return priceList.count == 0 ? ((statusMsg != nil) && statusMsg?.isEmpty == false) ? statusMsg!: "不可购买":priceList.joined(separator: "|")
              }
        }
    var pm_pmtn_type: String?{ //促销类型数据  埋点专用 自定义
        get {
          var pmList:[String] = []
          //常购清单
          if let sign = productSign {
               if sign.fullScale == true{
                   pmList.append("满减")
                }
               if sign.fullGift == true{
                 pmList.append("满赠")
                }
                // 15:单品满折,16多品满折
               if sign.fullDiscount == true{
                 pmList.append("满折")
                }
               // 返利金
               if sign.rebate == true{
                 pmList.append("返利")
                }
             // 协议返利金
               if sign.bounty == true{
                pmList.append("协议奖励金")
               }
              // 套餐
               if sign.packages == true{
                pmList.append("套餐")
                }
               // 限购
               if sign.purchaseLimit == true{
                 pmList.append("限购")
               }
               //特价
               if sign.specialOffer == true{
                  pmList.append("特价")
               }
              //会员  会员才加入 有会员价的商品
              if let _ = vipPromotionId, let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0 {
                   pmList.append("会员")
              }
              // 优惠券
              if sign.ticket == true{
               pmList.append("券")
              }
            }
             return pmList.joined(separator: ",")
          }
    }
    
    
    var shortWarehouseName: String? //自营仓名
    
    static func fromJSON(_ json: [String : AnyObject]) -> OftenBuyProductItemModel {
        let json = JSON(json)
        
        let model = OftenBuyProductItemModel()
        model.stockCountDesc = json["stockCountDesc"].stringValue
        model.sortNum = json["sortNum"].stringValue
        model.spuCode = json["spuCode"].stringValue
        model.spuName = json["spuName"].stringValue
        model.spec = json["spec"].stringValue
        model.factoryName = json["factoryName"].stringValue
        model.supplyName = json["supplyName"].stringValue
        model.supplyId = json["supplyId"].intValue
        model.isZiYingFlag = json["isZiYingFlag"].intValue
        model.promotionPrice = json["promotionPrice"].floatValue
        model.price = json["price"].floatValue
        if let vipAvailablePriceNum = Float(json["availableVipPrice"].stringValue),vipAvailablePriceNum > 0{
            model.availableVipPrice = vipAvailablePriceNum
        }
        if let vipPriceNum = Float(json["visibleVipPrice"].stringValue),vipPriceNum > 0{
            model.visibleVipPrice = vipPriceNum
        }
        if let vipNum = Int(json["vipLimitNum"].stringValue),vipNum > 0{
            model.vipLimitNum = vipNum
        }
        model.vipPromotionId = json["vipPromotionId"].stringValue
        model.imgPath = json["imgPath"].stringValue
        model.weeklyPurchaseLimit = json["weeklyPurchaseLimit"].intValue
        model.miniPackage = json["miniPackage"].stringValue
        model.wholeSaleNum = json["wholeSaleNum"].intValue
        model.productInventory = json["productInventory"].stringValue
        model.surplusBuyNum = json["surplusBuyNum"].intValue
        model.expiryDate = json["expiryDate"].stringValue
        model.productionTime = json["productionTime"].stringValue
        model.sourceFrom = json["sourceFrom"].stringValue
        model.productDesc = json["productDesc"].stringValue
        model.pmDescription = json["description"].stringValue
        if json["pmCount"].intValue != 0 {
            model.pmCount = json["pmCount"].intValue
        }
        if json["pvCount"].intValue != 0 {
            model.pvCount = json["pvCount"].intValue
        }
        if json["orderCount"].intValue != 0 {
            model.orderCount = json["orderCount"].intValue
        }
        if let shareStockDic = json["shareStockDTO"].dictionaryObject {
            if let stockToFromWarhouseId = shareStockDic["stockToFromWarhouseId"] as? Int {
                model.stockToFromWarhouseId = stockToFromWarhouseId
            }
            if let shareStockDesc = shareStockDic["shareStockDesc"] as? String {
                model.shareStockDesc = shareStockDesc
            }
        }
        model.statusMsg = json["statusMsg"].stringValue
        model.disCountDesc = json["disCountDesc"].stringValue
        model.packageUnit = json["packageUnit"].stringValue
        if let dic = json["productSign"].dictionary {
            model.productSign = (dic as NSDictionary).mapToObject(ProductPromationSignModel.self)
        }
        model.singleCanBuy = json["singleCanBuy"].intValue
        model.dinnerPromotionRule = json["dinnerPromotionRule"].intValue
        model.shopExtendTag = json["shopExtendTag"].stringValue
        model.shopExtendType = json["shopExtendType"].intValue
        //与购物车数据对比
        for cartModel  in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == model.spuCode && cartOfInfoModel.supplyId.intValue == Int(model.supplyId!) {
                model.carId = cartOfInfoModel.cartId.intValue
                model.carOfCount = cartOfInfoModel.buyNum.intValue
                break
            }
        }
        
        model.shortWarehouseName = json["shortWarehouseName"].stringValue
        return model
    }
}
final class OftenBuyNewProductModel: NSObject, JSONAbleType, HandyJSON{
    required override init() {}
    var sortNum: String? // 序号
    var spuCode: String? // 商品编码
    var spuName: String? // 商品名称
    var spec: String? // 规格
    var factoryName: String? // 生产厂家
    var supplyName: String? // 供应商
    var supplyId: Int? // 供应商编号
    var isZiYingFlag: Int? // 是否是自营
    var promotionPrice: Float? // 客户组活动价
    var price: Float? // 客户组原价
    var imgPath: String? // 图片地址
    var weeklyPurchaseLimit: Int? // 周限购量
    var surplusBuyNum: Int? // 本周剩余限购数量
    var miniPackage: String? // 最小拆零包装
    var wholeSaleNum: Int? // 最小起批量
    var productInventory: String? // 库存
    var productionTime: String? // 生产日期
    var productSign: ProductPromationSignModel? // 促销标签
    var pmCount: Int? { // 本月已售数量
        didSet {
            detailStr = "近一月售出\(String(describing: pmCount!))份"
        }
    }
    var pvCount: Int? { // 浏览次数
        didSet {
            detailStr = "近一月浏览\(String(describing: pvCount!))次"
        }
    }
    var orderCount: Int? { // 购买次数
        didSet {
            detailStr = "采购\(String(describing: orderCount!))次"
        }
    }
    
    // 非接口返回字段
    var limitCanBuyNumber: Int = 0 // 限购数量
    var carId: Int = 0 // 购物车id
    var carOfCount: Int = 0 // 购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
    var detailStr: String = ""
    
    static func fromJSON(_ json: [String : AnyObject]) -> OftenBuyNewProductModel {
        let json = JSON(json)
        
        let model = OftenBuyNewProductModel()
        model.sortNum = json["sortNum"].stringValue
        model.spuCode = json["spuCode"].stringValue
        model.spuName = json["spuName"].stringValue
        model.spec = json["spec"].stringValue
        model.factoryName = json["factoryName"].stringValue
        model.supplyName = json["supplyName"].stringValue
        model.supplyId = json["supplyId"].intValue
        model.isZiYingFlag = json["isZiYingFlag"].intValue
        model.promotionPrice = json["promotionPrice"].floatValue
        model.price = json["price"].floatValue
        model.imgPath = json["imgPath"].stringValue
        model.weeklyPurchaseLimit = json["weeklyPurchaseLimit"].intValue
        model.miniPackage = json["miniPackage"].stringValue
        model.wholeSaleNum = json["wholeSaleNum"].intValue
        model.productInventory = json["productInventory"].stringValue
        model.surplusBuyNum = json["surplusBuyNum"].intValue
        model.productionTime = json["productionTime"].stringValue
        if json["pmCount"].intValue != 0 {
            model.pmCount = json["pmCount"].intValue
        }
        if json["pvCount"].intValue != 0 {
            model.pvCount = json["pvCount"].intValue
        }
        if json["orderCount"].intValue != 0 {
            model.orderCount = json["orderCount"].intValue
        }
        if let dic = json["productSign"].dictionary {
            model.productSign = (dic as NSDictionary).mapToObject(ProductPromationSignModel.self)
        }
        for cartModel  in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == model.spuCode && cartOfInfoModel.supplyId.intValue == Int(model.supplyId!) {
                model.carId = cartOfInfoModel.cartId.intValue
                model.carOfCount = cartOfInfoModel.buyNum.intValue
                break
            }
        }
        
        return model
    }
}

final class ProductPromationSignModel: NSObject, JSONAbleType ,HandyJSON {
    
    required override init() {}
    var bounty:Bool?
    var fullDiscount:Bool?
    var fullGift:Bool?
    var fullScale:Bool?
    var packages:Bool?
    var purchaseLimit:Bool?
    var rebate:Bool?
    var specialOffer:Bool?
    var ticket:Bool?
    
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
    
    var liveStreamingFlag : Bool? //true 直播价

    static func fromJSON(_ json: [String : AnyObject]) -> ProductPromationSignModel {
        let json = JSON(json)
        
        let model = ProductPromationSignModel()
        model.bounty = json["bounty"].boolValue
        model.fullDiscount = json["fullDiscount"].boolValue
        model.fullGift = json["fullGift"].boolValue
        model.fullScale = json["fullScale"].boolValue
        model.purchaseLimit = json["purchaseLimit"].boolValue
        model.packages = json["packages"].boolValue
        model.rebate = json["rebate"].boolValue
        model.specialOffer = json["specialOffer"].boolValue
        model.ticket = json["ticket"].boolValue
        model.slowPay = json["slowPay"].boolValue
        model.holdPrice = json["holdPrice"].boolValue
        model.liveStreamingFlag = json["liveStreamingFlag"].boolValue
        return model
    }
    
}
