//
//  ShopListRecommendAreaModel.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/29.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  推荐专区

import SwiftyJSON

final class ShopListRecommendAreaModel: NSObject, JSONAbleType {
    var recommend: ShopListRecommentAreaItemModel?      // 商品列表对象
    // 本地新增业务逻辑字段
    var indexMsg: Int = 0                       // 消息列表索引
    var indexItem: Int = 0                      // 当前商品索引<用于分页>
    var floorName: String?                      // 楼层名称
    var showSequence:Int = 1 // 列表中第几个活动 自定义字段
    static func fromJSON(_ json: [String : AnyObject]) -> ShopListRecommendAreaModel {
        let json = JSON(json)
        
        let model = ShopListRecommendAreaModel()
        
        var recommend: ShopListRecommentAreaItemModel?
        if let dic = json["recommendedArea"].dictionary {
            recommend = (dic as NSDictionary).mapToObject(ShopListRecommentAreaItemModel.self)
        }
        model.recommend = recommend
        
        return model
    }
}

final class ShopListRecommentAreaItemModel: NSObject, JSONAbleType {
    var createTime: String?
    var id: Int?
    var type: Int?
    var imgPath: String?
    var jumpInfo: String?
    var jumpType: String?
    var name: String?
    var posIndex: Int?
    var siteCode: String?
    var indexMobileId: Int?
    var jumpExpandOne: String?
    var jumpExpandTwo: String?
    var jumpExpandThree: String?
    var floorProductDtos: [ShopListProductItemModel]? // 商品列表
    var jumpInfoMore: String? //更多链接
    
    init(floorProductDtos: [ShopListProductItemModel]?) {
        self.floorProductDtos = floorProductDtos
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> ShopListRecommentAreaItemModel {
        let json = JSON(json)
        
        let createTime = json["createTime"].stringValue
        let id = json["id"].intValue
        let type = json["type"].intValue
        let imgPath = json["imgPath"].stringValue
        let jumpInfo = json["jumpInfo"].stringValue
        let jumpType = json["jumpType"].stringValue
        let name = json["name"].stringValue
        let posIndex = json["posIndex"].intValue
        let siteCode = json["siteCode"].stringValue
        let indexMobileId = json["indexMobileId"].intValue
        let jumpExpandOne = json["jumpExpandOne"].stringValue
        let jumpExpandTwo = json["jumpExpandTwo"].stringValue
        let jumpExpandThree = json["jumpExpandThree"].stringValue
        let jumpInfoMore = json["jumpInfoMore"].stringValue
        
        var floorProductDtos: [ShopListProductItemModel]?
        if let list = json["mpHomeProductDtos"].arrayObject {
            floorProductDtos = (list as NSArray).mapToObjectArray(ShopListProductItemModel.self)
        }
        
        let model = ShopListRecommentAreaItemModel(floorProductDtos: floorProductDtos)
        model.createTime = createTime
        model.id = id
        model.type = type
        model.imgPath = imgPath
        model.jumpInfo = jumpInfo
        model.jumpType = jumpType
        model.name = name
        model.posIndex = posIndex
        model.siteCode = siteCode
        model.indexMobileId = indexMobileId
        model.jumpExpandOne = jumpExpandOne
        model.jumpExpandTwo = jumpExpandTwo
        model.jumpExpandThree = jumpExpandThree
        model.jumpInfoMore = jumpInfoMore
        return model
    }
}

final class ShopListProductItemModel: NSObject, JSONAbleType {
    var createTime: String?         //
    var factoryId: String?          // 厂商ID
    var factoryName: String?        // 厂商名称
    var id: Int?                    //
    var imgPath: String?            // 药品图片路径
    var indexMobileFloorId: Int?    //
    var indexMobileId: Int?         //
    var inimumPacking: Int?         // 商品起批量
    var inventory: Int?             // 活动存在时为活动库存，不存在则为商品实际库存
    var isChannel: Int?             // 是否渠道商品
    var posIndex: Int?              //
    var productCode: String?        // 药品编码
    var productInventory: Int?      // 商品实际库存
    var productName: String?        // 药品名称
    var stockCountDesc: String?        // 库存描述
    var productFullName: String?{ //商品全名 名字加规格
        get {
            return (productName ?? "") + " " + (productSpec ?? "")
        }
    }
    var productPrice: Double?       // 价格...<原价>
    var productSpec: String?        // 药品规格
    var productSupplyId: String?    // 药品供应商编码
    var productSupplyName: String?  // 供应商名称
    var promotionlimitNum: Int?     // 活动限购数量《特价限购数量》
    var shortName: String?          // 商品通用名
    var siteCode: String?           //
    var specialPrice: Double?       // 优惠价...<现价>
    var statusDesc: Int?            // 购买状态
    var statusMsg: String?          // 购买值
    var unit: String?               // 单位
    var expiryDate: String?         // 有效期
    var productionTime :String?     //生产日期
    
    // 一起系列增加的数据
    var showPrice: String?              //
    var buyTogetherJumpInfo: String?    // 一起购商品详情链接
    var buyTogetherId: Int?             // 一起购商品活动id
    
    // 秒杀专区新增字段
    var promotionId: String?            // 活动id
    var productCodeCompany: String?     // 本公司编码
    var downTime: String?               //
    var upTime: String?                 //
    var productId: String?              // 商品ID
    var promotionCollectionId: String?  //
    var showSequence:Int = 1 // 列表中第几个活动 自定义字段
    // 店铺馆列表页改版-促销标签打标
    var productSign: ProductSignModel?
    var brandLable: Int? // 商品标签：1.无 2.专供 3.限量 4.独家
    
    // 非接口返回字段
    var carId: Int = 0 // 购物车id
    var carOfCount: Int = 0 // 购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
    
    var weeklyPurchaseLimit: Int?   // 周限购量
    var surplusBuyNum: Int?         // 本周剩余限购数量
    var miniPackage: Int?           // 最小拆零包装
    var wholeSaleNum: Int?          // 最小起批量
   // var productSign: ProductPromationSignModel? // 促销标签
    var availableVipPrice : Float?              // 可用会员价（会员才有这个字段）
    var visibleVipPrice : Float?                // 可见会员价（非会员和会员都有）
    var vipLimitNum :NSInteger?                 // vip限购数量
    var vipPromotionId :String?                 // vip活动id
    var isZiYingFlag: Int? // 是否是自营
    var disCountDesc: String?  // 折后价
    var floorName: String?  //楼层名称 埋点专用从上级传来
    var storage: String?{ //可购买数量 埋点专用 自定义 1
         get {
              var numList:[String] = []
              //本周剩余限购数量
              if promotionlimitNum != nil &&  promotionlimitNum! > 0 {
                 numList.append(String(promotionlimitNum!))
              }else if vipLimitNum != nil &&  vipLimitNum! > 0 {
                if let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0{
                    numList.append(String(vipLimitNum!))
                }
              }
            var canBuyNum = 0
            if  surplusBuyNum != nil && surplusBuyNum! > 0 {
               canBuyNum = surplusBuyNum!
             }
             if let count =  inventory ,count>0{
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
               if let promotionNum =  specialPrice , promotionNum > 0  {
                   //特价
                    priceList.append(String(format: "%.2f",promotionNum))
               }else if let _ = vipPromotionId, let vipNum = visibleVipPrice, vipNum > 0 {
                   if let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0 {
                   //会员
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
    
    // 界面展示所需的必要字段
    init(id: Int?, imgPath: String?, productName: String?, productSpec: String?, productPrice: Double?) {
        self.id = id
        self.imgPath = imgPath
        self.productName = productName
        self.productSpec = productSpec
        self.productPrice = productPrice
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> ShopListProductItemModel {
        let json = JSON(json)
        
        let createTime = json["createTime"].stringValue
        let factoryId = json["factoryId"].stringValue
        let factoryName = json["factoryName"].stringValue
        let id = json["id"].intValue
        let imgPath = json["imgPath"].stringValue
        let indexMobileFloorId = json["indexMobileFloorId"].intValue
        let indexMobileId = json["indexMobileId"].intValue
        let inimumPacking = json["inimumPacking"].intValue
        let inventory = json["inventory"].intValue
        let isChannel = json["isChannel"].intValue
        let posIndex = json["posIndex"].intValue
        let productCode = json["productCode"].stringValue
        let productInventory = json["productInventory"].intValue
        let productName = json["productName"].stringValue
        let productPrice = json["productPrice"].doubleValue
        let productSpec = json["productSpec"].stringValue
        let productSupplyId = json["productSupplyId"].stringValue
        let productSupplyName = json["productSupplyName"].stringValue
        let promotionlimitNum = json["promotionlimitNum"].intValue
        let shortName = json["shortName"].stringValue
        let siteCode = json["siteCode"].stringValue
        let specialPrice = json["specialPrice"].doubleValue
        let statusDesc = json["statusDesc"].intValue
        let statusMsg = json["statusMsg"].stringValue
        let unit = json["unit"].stringValue
        
        let showPrice = json["showPrice"].stringValue
        let buyTogetherJumpInfo = json["buyTogetherJumpInfo"].stringValue
        let buyTogetherId = json["buyTogetherId"].intValue
        
        let promotionId = json["promotionId"].stringValue
        let productCodeCompany = json["productCodeCompany"].stringValue
        let downTime = json["downTime"].stringValue
        let upTime = json["upTime"].stringValue
        let productId = json["productId"].stringValue
        let promotionCollectionId = json["promotionCollectionId"].stringValue
        
        var productSign: ProductSignModel?
        if let dic = json["productSign"].dictionary {
            productSign = (dic as NSDictionary).mapToObject(ProductSignModel.self)
        }
        let brandLable = json["brandLable"].intValue
        
        let weeklyPurchaseLimit = json["weeklyPurchaseLimit"].intValue
        let surplusBuyNum = json["surplusBuyNum"].intValue
        let miniPackage = json["miniPackage"].intValue
        let wholeSaleNum = json["wholeSaleNum"].intValue
        let expiryDate = json["expiryDate"].stringValue
        let productionTime = json["productionTime"].stringValue
        let stockCountDesc = json["stockCountDesc"].stringValue
        
        let model = ShopListProductItemModel(id: id, imgPath: imgPath, productName: productName, productSpec: productSpec, productPrice: productPrice)
        model.createTime = createTime
        model.factoryId = factoryId
        model.factoryName = factoryName
        model.indexMobileFloorId = indexMobileFloorId
        model.indexMobileId = indexMobileId
        model.inimumPacking = inimumPacking
        model.inventory = inventory
        model.isChannel = isChannel
        model.posIndex = posIndex
        model.productCode = productCode
        model.productInventory = productInventory
        model.productSupplyId = productSupplyId
        model.productSupplyName = productSupplyName
        model.promotionlimitNum = promotionlimitNum
        model.shortName = shortName
        model.siteCode = siteCode
        model.specialPrice = specialPrice
        model.statusDesc = statusDesc
        model.statusMsg = statusMsg
        model.unit = unit
        model.showPrice = showPrice
        model.buyTogetherJumpInfo = buyTogetherJumpInfo
        model.buyTogetherId = buyTogetherId
        model.promotionId = promotionId
        model.productCodeCompany = productCodeCompany
        model.downTime = downTime
        model.upTime = upTime
        model.productId = productId
        model.promotionCollectionId = promotionCollectionId
        model.productSign = productSign
        model.brandLable = brandLable
        model.weeklyPurchaseLimit = weeklyPurchaseLimit
        model.surplusBuyNum = surplusBuyNum
        model.miniPackage = miniPackage
        model.wholeSaleNum = wholeSaleNum
        model.expiryDate = expiryDate
        model.productionTime = productionTime
        model.stockCountDesc = stockCountDesc
        
        
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
        model.disCountDesc = json["disCountDesc"].stringValue
        model.isZiYingFlag = json["isZiYingFlag"].intValue
        model.shortWarehouseName = json["shortWarehouseName"].stringValue
        return model
    }
}

extension ShopListProductItemModel: ShopListModelInterface {
    func floorCellIdentifier() -> String {
        return "ShopRecommendListCell"
    }
}
