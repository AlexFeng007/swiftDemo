//
//  FKYFullProductModel.swift
//  FKY
//
//  Created by hui on 2018/11/29.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

//满减，特价模型
final class FKYFullProductModel: NSObject, JSONAbleType {
    var brandName : String? //品牌
    var canBuyNum : Int? //可以购买的限购数量
    var channelPrice: Float? ////公开价
    var createTime: String? //
    var createUser: String? //
    var currentInventory: Int? ////活动实时库存
    var discountMoney: Int? //
    var doorsill: Int? //
    var enterpriseId: String? ////供应商ID
    var enterpriseName : String? //商家名称
    var factoryName : String? ////厂商
    var groupCode: String? // //客户组
    var groupName : String? //
    var id : Int?
    var limitNum: Int? //单用户限购量
    ///活动商品最小起批量
    var minimumPacking : Int?
    var productBigPacking : Int? //商品大包装
    var productFrontInventory : Int? ////商品前端可售库存
    var productImgUrl : String? //商品的图片
    ///最小拆零包装
    var productMiniPacking : Int?
    var productcodeCompany : String? ////商品编码
    var promotionId : Int? ////促销id
    var promotionPrice : Float? ////活动价格
    //var promotionProductGroupList : String? ////客户组特价设置
    //var promotionRuleList : Float? //满赠返回阶梯信息和赠品信息
    var settingState : Int? //商品状态 （0:正常显示价格-1:登录后可见-3:资质认证）
    var short_name : String? //spu名称
    var productFullName: String?{ //商品全名 名字加规格
        get {
            return (short_name ?? "") + " " + (spec ?? "")
        }
    }
    var showPrice : Float? ////销售价（显示价）
    var sort : String?//优先级
    var sortNum : String?//排序
    var spec : String?//规格
    var spuCode : String?//spu编码
    var status : Int?
    var statusDesc : Int?//价格状态【0:成功，1：不在配送区域内，2：不在药品经营范围内，-3：资质未认证，-4:渠道待审核，-2：加入渠道后可见，-7：下架，-6：不显示（针对价格为null的脏数据）,4:客户类型不在配送区域类】
    var stockDesc : String?
    var sumInventory : Int?//活动总库存
    var symbolLimitBuy : Bool?//是否限购标
    var unit : String? //单位
    var expiryDate : String? //有效日期
    var productionTime: String?                       // 生产日期
    var promationType: Int?                       //自定义字段  分是特价nil 还是满减 1
    //购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
    var carId :Int = 0
    var carOfCount :Int = 0
    var storage: String?{ //可购买数量
         get {
              var numList:[String] = []
              //本周剩余限购数量
              if  canBuyNum != nil && canBuyNum! > 0 {
                   numList.append(String(canBuyNum!))
              }
             if let count = productFrontInventory ,count>0{
                 numList.append(String(count))
              }
            return numList.count == 0 ? "0":numList.joined(separator: "|")
         }
       }
    var pm_price: String?{ //可购买价格  埋点专用 自定义
         get {
           var priceList:[String] = []
            if let promotionNum = promotionPrice , promotionNum > 0  {
               //特价
               priceList.append(String(format: "%.2f",promotionNum))
            }
            //原价
            if let priceStr = showPrice, priceStr > 0 {
                priceList.append(String(format: "%.2f",priceStr))
            }
             
            return priceList.count == 0 ?  ProductStausUntily.getProductStausDesc(statusDesc ?? 0):priceList.joined(separator: "|")
         }
   }
    var pm_pmtn_type: String?{ //促销类型数据  埋点专用 自定义
          get {
            var pmList:[String] = []
            if let type = promationType,type == 2{
               pmList.append("满减")
            }
            // 限购
            if  symbolLimitBuy == true {
               pmList.append("限购")
            }
              return pmList.joined(separator: ",")
            }
      }
    static func fromJSON(_ json: [String : AnyObject]) -> FKYFullProductModel {
        
        let model = FKYFullProductModel()
        let j = JSON(json)
        
        model.brandName = j["brandName"].stringValue
        model.canBuyNum = j["canBuyNum"].intValue
        model.channelPrice = j["channelPrice"].floatValue
        model.createTime = j["createTime"].stringValue
        model.createUser = j["createUser"].stringValue
        model.currentInventory = j["currentInventory"].intValue
        model.discountMoney = j["discountMoney"].intValue
        model.doorsill = j["doorsill"].intValue
        model.enterpriseId = j["enterpriseId"].stringValue
        model.enterpriseName = j["enterpriseName"].stringValue
        model.factoryName = j["factoryName"].stringValue
        model.groupCode = j["groupCode"].stringValue
        model.groupName = j["groupName"].stringValue
        model.id = j["id"].intValue
        model.limitNum = j["limitNum"].intValue
        
        model.minimumPacking = j["minimumPacking"].intValue
        model.productBigPacking = j["productBigPacking"].intValue
        model.productFrontInventory = j["productFrontInventory"].intValue
        model.productImgUrl = j["productImgUrl"].stringValue
        model.productMiniPacking = j["productMiniPacking"].intValue
        model.productcodeCompany = j["productcodeCompany"].stringValue
        model.promotionId = j["promotionId"].intValue
        model.promotionPrice = j["promotionPrice"].floatValue
        //model.promotionProductGroupList = j["promotionProductGroupList"].stringValue
        //model.promotionRuleList = j["promotionRuleList"].floatValue
        model.settingState = j["statusMsg"].intValue
        model.short_name = j["short_name"].stringValue
        model.showPrice = j["showPrice"].floatValue
        model.sort = j["sort"].stringValue
        model.sortNum = j["stepCount"].stringValue
        model.spec = j["spec"].stringValue
        model.spuCode = j["spuCode"].stringValue
        model.status = j["status"].intValue
        model.statusDesc = j["statusDesc"].intValue
        model.stockDesc = j["stockDesc"].stringValue
        model.sumInventory = j["sumInventory"].intValue
        model.symbolLimitBuy = j["symbolLimitBuy"].boolValue
        model.unit = j["unit"].stringValue
        model.expiryDate = j["deadLine"].stringValue
        model.productionTime = j["productionTime"].stringValue
        
        for cartModel  in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == model.spuCode && cartOfInfoModel.supplyId.intValue == Int(model.enterpriseId ?? "0") {
                    model.carOfCount = cartOfInfoModel.buyNum.intValue
                    model.carId = cartOfInfoModel.cartId.intValue
                    break
                }
            }
        }
        return model
    }
    
}
