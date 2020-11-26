//
//  FKYTogeterBuyModel.swift
//  FKY
//
//  Created by hui on 2018/10/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class FKYTogeterBuyModel : NSObject , JSONAbleType {
    
    var batchNo: String? //活动批号
    var beginTime: Int64? //一起购开始时间
    var clientBaseNum: String? //
    var currentInventory: Int?//活动库存
    var deadLine: String?//有效期
    var deliveryTime: String?
    var endTime : Int64? //一起购结束时间
    var enterpriseId :String?//
    var groupType : String?//
    var h5ChannelAdImg : String? //商品图片
    var h5DetailAdImg : String? //
    var togeterBuyId : String?//活动促销Id
    var isRelate : String?//
    var isTest :String?//
    var isWholesaleRetail :String?//
    var limitNumPerOrder :Int?//每单限购
    var now : String?//
    var nowTime : Int64?   //系统当前时间
    var pcChannelAdImg : String?//
    var pcDetailAdImg : String?//
    var percentage :Int?//
    var projectBaseNum :String?//
    var projectDesc :String?//
    var projectName : String?//活动名称
    var productFullName: String?{ //商品全名 名字加规格
        get {
            return (projectName ?? "") + " " + (spec ?? "")
        }
    }
    var projectStatus : Int? //活动状态，0：活动正常； 1：活动取消； 2：确认成团失败 3:成团成功'
    var projectSum : Int?//活动总量
    var purchasePrice : Float?//原价格
    var ruleDesc :String?//认购规则
    var sort :String?//
    var spuCode :String?//
    var stockDesc :String? //库存描述
    var productionTime :String? //生产日期
    var subscribeNumPerClient : Int?//每人最多认购(已经和库存对比了)
    var surplusNum : Int? // //每人最多认购
    var subscribePrice :Float?//活动价格
    var successSubscribeNum :String?//
    var unit : Int?//最小可拆分数，/最低起售数量
    var unitName : String? //商品包装单位
    var spec : String?//商品规格
    var productDeadLine : String?
    var isNearEffect : Int? //近效期1显示 有效期标签
    var appChannelAdImg : String? //app频道广告图片地址
    var productName : String? //商品名称
    var appDetailAdImg : String? //app详情广告图片地址
    var supplyName : String? //供应闪名字
    var factoryName : String? //厂商名字
    //购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
    var carId :Int = 0
    var carOfCount :Int = 0
    var pm_price: String?{ //可购买价格  埋点专用 自定义
            get {
              var priceList:[String] = []
              //一起购价格
              if let priceStr = subscribePrice, priceStr > 0 {
                  priceList.append(String(format: "%.2f",priceStr))
              }
//              //原价
//              if let priceStr = purchasePrice, priceStr > 0 {
//                  priceList.append(String(priceStr))
//              }
               return priceList.count == 0 ? "0":priceList.joined(separator: "|")
            }
      }

    var storage: String?{ //可购买数量 埋点专用 自定义
          get {
               var numList:[String] = []
               //本周剩余限购数量
            if (surplusNum != nil && surplusNum! > 0) && (currentInventory != nil && currentInventory! > 0){
                if (surplusNum ?? 0) > (currentInventory ?? 0){
                    numList.append(String(currentInventory!))
                }else{
                      numList.append(String(surplusNum!))
                }
            }else{
                if  surplusNum != nil && surplusNum! > 0 {
                   numList.append(String(surplusNum!))
                }
                if let count = currentInventory,count>0 {
                   numList.append(String(count))
                }
             }
               
             return numList.count == 0 ? "0":numList.joined(separator: "|")
          }
    }
    var pm_pmtn_type: String?{ //促销类型数据  埋点专用 自定义
              get {
                 return "一起购"
              }
     }
    static func fromJSON(_ json: [String : AnyObject]) -> FKYTogeterBuyModel {
        let model = FKYTogeterBuyModel()
        let j = JSON(json)
        
        model.batchNo = j["batch_no"].stringValue
        //一起购活动开始时间
        let beginStr = j["begin_time"].stringValue
        //let beginStr = "2019-05-16 16:19:00"
        model.beginTime = Int64(NSDate.init(string: beginStr, format: "yyyy-MM-dd HH:mm:ss").timeIntervalSince1970)
        model.clientBaseNum = j["client_base_num"].stringValue
        model.currentInventory = j["current_inventory"].intValue
        model.deadLine = j["dead_line"].stringValue
        model.deliveryTime = j["delivery_time"].stringValue
        //一起购活动结束时间
        let endStr = j["end_time"].stringValue
        //let endStr = "2019-01-08 14:20:00"
        model.endTime = Int64(NSDate.init(string: endStr, format: "yyyy-MM-dd HH:mm:ss").timeIntervalSince1970)
        model.enterpriseId = j["enterprise_id"].stringValue
        model.groupType = j["group_type"].stringValue
        model.h5ChannelAdImg = j["h5_channel_ad_img"].stringValue
        model.h5DetailAdImg = j["h5_detail_ad_img"].stringValue
        model.togeterBuyId = j["id"].stringValue
        model.isRelate = j["is_relate"].stringValue
        model.isTest = j["is_test"].stringValue
        model.isWholesaleRetail = j["is_wholesale_retail"].stringValue
        model.limitNumPerOrder = j["limit_num_per_order"].intValue
        model.now = j["now"].stringValue
        model.stockDesc = j["stockDesc"].stringValue
        model.productionTime = j["productionTime"].stringValue
        //一起购活动系统时间
        let nowStr = j["now"].stringValue
        model.nowTime = Int64(NSDate.init(string: nowStr, format: "yyyy-MM-dd HH:mm:ss").timeIntervalSince1970 + 1) //(+1)同步一起购详情里面的倒计时误差
        model.pcChannelAdImg = j["pc_channel_ad_img"].stringValue
        model.pcDetailAdImg = j["pc_detail_ad_img"].stringValue
        model.percentage = j["percentage"].intValue
        model.projectBaseNum = j["project_base_num"].stringValue
        model.projectDesc = j["project_desc"].stringValue
        model.projectName = j["project_name"].stringValue
        model.projectStatus = j["project_status"].intValue
        model.projectSum = j["project_sum"].intValue
        model.purchasePrice = j["purchase_price"].floatValue
        model.ruleDesc = j["rule_desc"].stringValue
        model.sort = j["sort"].stringValue
        model.spuCode = j["spu_code"].stringValue
        model.subscribeNumPerClient = j["subscribe_num_per_client"].intValue
        model.surplusNum = j["surplus_num"].intValue
        model.subscribePrice = j["subscribe_price"].floatValue
        model.successSubscribeNum = j["success_subscribe_num"].stringValue
        model.unit = j["unit"].int
        model.spec = j["spec"].stringValue
        model.productDeadLine = j["product_dead_line"].stringValue
        model.isNearEffect = j["is_near_effect"].intValue
        model.appChannelAdImg = j["app_channel_ad_img"].stringValue
        model.productName = j["product_name"].stringValue
        model.appDetailAdImg = j["app_detail_ad_img"].stringValue
        model.unitName = j["unit_name"].stringValue
        model.supplyName = j["supplyName"].stringValue
        model.factoryName = j["factoryName"].stringValue
        for cartModel  in FKYCartModel.shareInstance().togeterBuyProductArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                if  cartOfInfoModel.supplyId != nil && cartOfInfoModel.promotionId != nil && cartOfInfoModel.spuCode == model.spuCode! && cartOfInfoModel.supplyId.intValue == Int(model.enterpriseId!) && cartOfInfoModel.promotionId.intValue == Int(model.togeterBuyId ?? "0") {
                    model.carOfCount = cartOfInfoModel.buyNum.intValue
                    model.carId = cartOfInfoModel.cartId.intValue
                    break
                }
            }
        }
        return model
    }
}

//一起购商品详情model
final class FKYTogeterBuyDetailModel : NSObject , JSONAbleType {
    
    var batchNo: String? //活动批号
    var buyTogetherId: String? //活动促销Id
    var buyerId: String? //
    var currentInventory: Int?//活动库存
    var deadLine: String?
    var productionTime :String? //生产日期
    var stockCountDesc :String? //库存描述字段
    var deliveryTime: String?
    var endTime : Int? //一起购剩余时间（时间轴毫秒）
    var enterpriseName :String?//
    var factoryName : String?//
    var formalLogoPic : String? //商品图片
    var h5ChannelAdImg : String? //
    var h5DetailAdImg : String?//
    var hasClientBuyCount : Int?//
    var hasProductSellCount :Int?//
    var nowTime :String?//当前系统时间
    var orderStatus :Int?//每单限购
    var percentage : Int?//百分比
    var productId : String? //商品id
    var productName : String?//商品名称
    var productcodeCompany : String?//
    var projectDesc :String?//
    var projectName :String?//活动名称
    var projectStatus :Int?//0 活动正常 1 活动取消 2 成团失败 3 成团成功 4 认购已结束 5 认购未开始
    var projectSum : Int?//
    var projectUnit : Int? //最小可拆分数，/最低起售数量
    var purchasePrice : Float?//
    var ruleDesc : String?//原价格
    var sellerId :String?//商家id
    var shortName :String?//
    var spec :String?//规格
    var spuCode : String?//商品编码
    var startTime :Int?//一起购开始剩余时间
    var subscribeNumPerClient :Int?//每人最多认购（已经和库存对比了）
    var surplusNum : Int? // //每人最多认购
    var subscribePrice : Float?//活动价格
    var unit : String?//商品单位
    var appChannelAdImg : String? //
    var appDetailAdImg : String? //
    var isNearEffect : Int? //近效期1显示 有效期标签
    var isCheck : String? //0：未审核 1;审核通过
    var bigPacking :String?//商品中包装单位
    var approvalNum :String? //批准文号
    
    //购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
    var carId :Int = 0
    var carOfCount :Int = 0
    var pm_price: String?{ //可购买价格  埋点专用 自定义
            get {
              var priceList:[String] = []
              //一起购价格
              if let priceStr = subscribePrice, priceStr > 0 {
                  priceList.append(String(format: "%.2f",priceStr))
              }
               return priceList.count == 0 ? "":priceList.joined(separator: "|")
            }
      }

    var storage: String?{ //可购买数量 埋点专用 自定义
          get {
            if surplusNum != nil && projectStatus == 5{
                //{最大可购买数量}
               // 活动未开始则传未开始
                return "未开始"
            }
               var numList:[String] = []
               if (surplusNum != nil && surplusNum! > 0) && (currentInventory != nil && currentInventory! > 0){
                  if (surplusNum ?? 0) > (currentInventory ?? 0){
                     numList.append(String(currentInventory!))
                  }else{
                    numList.append(String(surplusNum!))
                  }
              }else{
                  if  surplusNum != nil && surplusNum! > 0 {
                     numList.append(String(surplusNum!))
                  }
                  if let count = currentInventory,count>0 {
                     numList.append(String(count))
                  }
               }
             return numList.count == 0 ? "0":numList.joined(separator: "|")
          }
    }
    var pm_pmtn_type: String?{ //促销类型数据  埋点专用 自定义
                 get {
                    return "一起购"
                 }
        }
    static func fromJSON(_ json: [String : AnyObject]) -> FKYTogeterBuyDetailModel {
        let model = FKYTogeterBuyDetailModel()
        let j = JSON(json)
        
        model.batchNo = j["batch_no"].stringValue
        model.buyTogetherId = j["buy_together_id"].stringValue
        model.buyerId = j["buyer_id"].stringValue
        model.currentInventory = j["currentInventory"].intValue
        model.deadLine = j["dead_line"].stringValue
        model.productionTime = j["productionTime"].stringValue
        model.stockCountDesc = j["stockCountDesc"].stringValue
        model.deliveryTime = j["delivery_time"].stringValue
        model.endTime = j["endTime"].intValue //结束剩余时间
        //model.endTime = 40*1000
        model.enterpriseName = j["enterprise_name"].stringValue
        model.factoryName = j["factory_name"].stringValue
        model.formalLogoPic = j["formal_logo_pic"].stringValue
        model.h5DetailAdImg = j["h5_channel_ad_img"].stringValue
        model.h5DetailAdImg = j["h5_detail_ad_img"].stringValue
        model.hasClientBuyCount = j["hasClientBuyCount"].intValue
        model.hasProductSellCount = j["hasProductSellCount"].intValue
        model.nowTime = j["now_time"].stringValue
        model.orderStatus = j["orderStatus"].intValue
        model.percentage = j["percentage"].intValue
        model.productId = j["product_id"].stringValue
        model.productName = j["product_name"].stringValue
        model.productcodeCompany = j["productcode_company"].stringValue
        model.projectDesc = j["project_desc"].stringValue
        model.projectName = j["project_name"].stringValue
        model.projectStatus = j["project_status"].intValue
        model.projectSum = j["project_sum"].intValue
        model.projectUnit = j["project_unit"].intValue
        model.purchasePrice = j["purchase_price"].floatValue
        model.ruleDesc = j["rule_desc"].stringValue
        model.sellerId = j["seller_id"].stringValue
        model.shortName = j["short_name"].stringValue
        model.spec = j["spec"].stringValue
        model.spuCode = j["spuCode"].stringValue
        //model.startTime = 20*1000
        model.startTime = j["startTime"].intValue //开始剩余时间
        model.subscribeNumPerClient = j["subscribe_num_per_client"].intValue
        model.surplusNum = j["surplus_num"].intValue
        model.subscribePrice = j["subscribe_price"].floatValue
        model.unit = j["unit"].stringValue
        model.appChannelAdImg = j["app_channel_ad_img"].stringValue
        model.isNearEffect = j["is_near_effect"].intValue
        model.appDetailAdImg = j["app_detail_ad_img"].stringValue
        model.isCheck = j["isCheck"].stringValue
        model.bigPacking = j["bigPacking"].stringValue
        model.approvalNum = j["approvalNum"].stringValue
        return model
    }
}
