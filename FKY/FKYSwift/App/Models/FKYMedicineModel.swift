//
//  FKYMedicineModel.swift
//  FKY
//
//  Created by hui on 2018/11/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

//中药材列表接口
final class FKYMedicineModel: NSObject ,JSONAbleType {
    
    var jumpType: Int?
    var name: String? //一起购开始时间
    var title: String? //
    var tabName: Int?//活动库存
    var jumpInfoMore: String?//有效期
    var mpHomeProductDtos : Array<FKYMedicinePrdDetModel>? //楼层下的商品
    
    static func fromJSON(_ json: [String : AnyObject]) -> FKYMedicineModel {
        
        let model = FKYMedicineModel()
        let j = JSON(json)
        
        model.jumpType = j["jumpType"].intValue
        model.name = j["name"].stringValue
        model.title = j["title"].stringValue
        model.tabName = j["tabName"].intValue
        model.jumpInfoMore = j["jumpInfoMore"].stringValue
        
        let prdArr = j["mpHomeProductDtos"].arrayObject
        var shopPromotions: [FKYMedicinePrdDetModel]? = []
        if let list = prdArr {
            shopPromotions = (list as NSArray).mapToObjectArray(FKYMedicinePrdDetModel.self)
        }
        model.mpHomeProductDtos = shopPromotions
        return model
    }
}
//中药材列表接口
final class FKYMedicinePrdDetModel: NSObject ,JSONAbleType {
    
    var factoryId : String? //厂家id
    var factoryName : String? //厂家名称
    var medicinePrdDetId: Int? //
    var imgPath: String? //图片
    var wholeSaleNum: Int? //最小起批数量
    var inventory: Int? //
    var isChannel: Int? //
    var mpHomeFloorId: Int? //
    var posIndex: Int? //
    var productCode : String? //商品编号
    var productCodeCompany : String? //
    var productId: String? // 商品id
    var productInventory : String? //
    var productName : String? //商品名称
    var stockCountDesc : String? //库存描述
    var productionTime : String? //生产日期
    
    var productFullName: String?{ //商品全名 名字加规格
        get {
            return (productName ?? "") + " " + (productSpec ?? "")
        }
    }
    var productPrice: Float? // 商品原价价格
    var productSign : FKYMedicineTagModel?//标签
    var productSpec : String? //规格
    var productSupplyId : String? //供应商id
    var productSupplyName : String? //供应商名称
    var promotionCollectionId : String? //
    var promotionId : String? //
    var promotionlimitNum : Int? //特价限购
    var shortName : String? //短名称
    var showPrice : String? //
    var specialPrice : Float? //商品特价
    var statusDesc : Int? //商品状态 （0:正常显示价格-1:登录后可见-3:资质认证）
    var statusMsg : String? //状态描述
    var unit : String? //单位
    var expiryDate : String? //有效日期
    
    var stockCount : Int? //实际库存
    var surplusBuyNum : Int? //本周剩余限购数量
    var stepCount : Int?  // 最小拆零包装数
    
    //购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
    var carId :Int = 0
    var carOfCount :Int = 0
    
    var availableVipPrice : Float?              // 可用会员价（会员才有这个字段）
    var visibleVipPrice : Float?                // 可见会员价（非会员和会员都有）
    var vipLimitNum :NSInteger?                 // vip限购数量
    var vipPromotionId :String?                 // vip活动id
    var isZiYingFlag: Int? // 是否是自营
    var disCountDesc: String?  // 折后价
    var indexPath: IndexPath?  // 埋点专用 记录当前位置
    var storage: String?{ //可购买数量 1
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
                if let count = stockCount ,count>0{
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
            }else if let promotionNum =  specialPrice , promotionNum > 0  {
                //特价
                pmList.append("特价")
            }
             return pmList.joined(separator: ",")
          }
    }
    
    var shortWarehouseName: String? //自营仓名
    
    static func fromJSON(_ json: [String : AnyObject]) -> FKYMedicinePrdDetModel {
        
        let model = FKYMedicinePrdDetModel()
        let j = JSON(json)
        
        model.factoryId = j["factoryId"].stringValue
        model.factoryName = j["factoryName"].stringValue
        model.medicinePrdDetId = j["medicinePrdDetId"].intValue
        model.imgPath = j["imgPath"].stringValue
        model.wholeSaleNum = j["wholeSaleNum"].intValue
        model.inventory = j["inventory"].intValue
        model.isChannel = j["isChannel"].intValue
        model.mpHomeFloorId = j["mpHomeFloorId"].intValue
        model.posIndex = j["posIndex"].intValue
        model.productCode = j["productCode"].stringValue
        model.productCodeCompany = j["productCodeCompany"].stringValue
        model.productId = j["productId"].stringValue
        model.productInventory = j["productInventory"].stringValue
        model.productName = j["productName"].stringValue
        model.productPrice = j["productPrice"].floatValue
        
        let tagdic = j["productSign"].dictionaryObject
        var tagModel: FKYMedicineTagModel? = nil
        if let d = tagdic {
            tagModel = (d as NSDictionary).mapToObject(FKYMedicineTagModel.self)
        }
        model.productSign = tagModel
        
        model.productSpec = j["productSpec"].stringValue
        model.productSupplyId = j["productSupplyId"].stringValue
        model.productSupplyName = j["productSupplyName"].stringValue
        model.promotionCollectionId = j["promotionCollectionId"].stringValue
        model.promotionId = j["promotionId"].stringValue
        model.promotionlimitNum = j["promotionlimitNum"].intValue
        model.shortName = j["shortName"].stringValue
        model.showPrice = j["showPrice"].stringValue
        model.specialPrice = j["specialPrice"].floatValue
        model.statusDesc = j["statusDesc"].intValue
        model.statusMsg = j["statusMsg"].stringValue
        model.unit = j["unit"].stringValue
        model.expiryDate = j["expiryDate"].stringValue
        model.stockCountDesc = j["stockCountDesc"].stringValue
        model.productionTime = j["productionTime"].stringValue
        
        model.stockCount = j["productInventory"].intValue
        model.surplusBuyNum = j["surplusBuyNum"].intValue
        model.stepCount = j["miniPackage"].intValue
        
        //vip字段
        model.availableVipPrice = 0
        if let vipAvailablePriceNum = Float(j["availableVipPrice"].stringValue),vipAvailablePriceNum > 0{
            model.availableVipPrice = vipAvailablePriceNum
        }
        model.visibleVipPrice = 0
        if let vipPriceNum = Float(j["visibleVipPrice"].stringValue),vipPriceNum > 0{
            model.visibleVipPrice = vipPriceNum
        }
        model.vipLimitNum = 0
        if let vipNum = Int(j["vipLimitNum"].stringValue),vipNum > 0{
            model.vipLimitNum = vipNum
        }
        model.vipPromotionId = j["vipPromotionId"].stringValue
        model.isZiYingFlag = j["isZiYingFlag"].intValue
        model.disCountDesc = j["disCountDesc"].stringValue
        
        for cartModel  in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == model.productCode && cartOfInfoModel.supplyId.intValue == Int(model.productSupplyId ?? "0") {
                model.carOfCount = cartOfInfoModel.buyNum.intValue
                model.carId = cartOfInfoModel.cartId.intValue
                break
            }
        }
        
        model.shortWarehouseName = j["shortWarehouseName"].stringValue
        return model
    }
}
//判断标签显示与否
final class FKYMedicineTagModel : NSObject , JSONAbleType {
    
    var fullGift: Bool?//满赠
    var fullScale: Bool? //满减
    var packages: Bool? //套餐
    var purchaseLimit: Bool?//限购
    var rebate: Bool?//返利
    var specialOffer :Bool?//特价
    var ticket :Bool? //领劵
    var bounty:Bool?        //协议返利金
    var fullDiscount:Bool?  //满折
    
    static func fromJSON(_ json: [String : AnyObject]) -> FKYMedicineTagModel {
        
        let model = FKYMedicineTagModel()
        let j = JSON(json)
        
        model.fullGift = j["fullGift"].boolValue
        model.fullScale = j["fullScale"].boolValue
        model.packages = j["packages"].boolValue
        model.purchaseLimit = j["purchaseLimit"].boolValue
        model.rebate = j["rebate"].boolValue
        model.specialOffer = j["specialOffer"].boolValue
        model.ticket = j["ticket"].boolValue
        model.bounty = j["bounty"].boolValue
        model.fullDiscount = j["fullDiscount"].boolValue
        return model
    }
}

