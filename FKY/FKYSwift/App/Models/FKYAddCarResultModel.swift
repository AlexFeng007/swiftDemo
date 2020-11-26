//
//  FKYAddCarResultModel.swift
//  FKY
//
//  Created by hui on 2019/5/30.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

//加车成功后返回的model
final class FKYAddCarResultModel: NSObject,JSONAbleType {
    var cartResponseList: [Any]?   //
    var failCount: Int?      //标题
    var message: String?    //加车信息提示
    @objc var needAlertCartList : [FKYPostphoneProductModel]? //需延期发货的商品列表
    var productsCount: Int?    //商品数量
    @objc var shareStockDesc: String?    //预计发货提示
    var statusCode: Int?    //返回状态
    var surplusNum: Int?    //是否已读
    var totalAmount: Float?    //总价
    var supplyCartList : [FKYThousandCouponModel]? //千人千面优惠券模型
    
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYAddCarResultModel {
        let json = JSON(json)
        
        let model = FKYAddCarResultModel()
        model.failCount = json["failCount"].intValue
        model.message = json["message"].stringValue
        model.productsCount = json["productsCount"].intValue
        model.shareStockDesc = json["shareStockDesc"].stringValue
        model.statusCode = json["statusCode"].intValue
        model.surplusNum = json["surplusNum"].intValue
        model.totalAmount = json["totalAmount"].floatValue
        model.cartResponseList = json["cartResponseList"].arrayObject
        if let alertList = json["needAlertCartList"].arrayObject {
            model.needAlertCartList = (alertList as NSArray).mapToObjectArray(FKYPostphoneProductModel.self)
        }
        if let arr = json["supplyCartList"].arrayObject {
            model.supplyCartList = (arr as NSArray).mapToObjectArray(FKYThousandCouponModel.self)
        }
        
        return model
    }
}
//千人千面优惠券的model
@objc final class FKYThousandCouponModel: NSObject,JSONAbleType {
    @objc var supplyId: String?   //
    @objc var totalAmount: String?      //标题
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYThousandCouponModel {
        let json = JSON(json)
        let model = FKYThousandCouponModel()
        model.supplyId = json["supplyId"].stringValue
        model.totalAmount = json["totalAmount"].stringValue
        return model
    }
}
//千人千面优惠券详情model
@objc final class FKYThousandCouponDetailModel: NSObject,JSONAbleType {
    var couponCode: String?   //优惠券号
    var beginDate: String?      //优惠券开始时间
    var endDate: String?   //优惠券结束时间
    var denomination: Float?      // 优惠券面值
    var limitprice: Float?   //使用限制金额
    @objc var successStr: String?      //是否成功发劵,true表示成功发劵，false其他情况
    var beginDateStr: String?   //优惠券开始时间显示
    var endDateStr: String?      //优惠券结束时间显示
    var tempType: Int?   //Integer0-店铺券 1-平台券
    var title: String? //String送券弹框的title
    var text: String?  //String送券弹框的文描
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYThousandCouponDetailModel {
        let json = JSON(json)
        
        let model = FKYThousandCouponDetailModel()
        model.couponCode = json["couponCode"].stringValue
        model.beginDate = json["beginDate"].stringValue
        model.endDate = json["endDate"].stringValue
        model.denomination = json["denomination"].floatValue
        model.limitprice = json["limitprice"].floatValue
        if let desSuccess = json["success"].bool ,desSuccess == true {
            model.successStr = "1"
        }else {
            model.successStr = "0"
        }
        model.beginDateStr = json["beginDateStr"].stringValue
        model.endDateStr = json["endDateStr"].stringValue
        model.title = json["title"].stringValue
        model.text = json["text"].stringValue
        model.tempType = json["tempType"].intValue
        return model
    }
    @objc func initWithModel(_ json: NSDictionary){

        if let couponCode = json["couponCode"] as? String{
            self.couponCode = couponCode
        }
        if let beginDate = json["beginDate"] as? String{
            self.beginDate = beginDate
        }
        if let endDate = json["endDate"] as? String{
            self.endDate = endDate
        }
        if let denomination = json["denomination"] as? Float{
            self.denomination = denomination
        }
        if let success = json["success"] as? Bool{
            if success == true {
                self.successStr = "1"
            }else {
                self.successStr = "0"
            }
        }
        if let beginDateStr = json["beginDateStr"] as? String{
            self.beginDateStr = beginDateStr
        }
        if let endDateStr = json["endDateStr"] as? String{
            self.endDateStr = endDateStr
        }
        if let title = json["title"] as? String{
            self.title = title
        }
        if let text = json["text"] as? String{
            self.text = text
        }
        if let tempType = json["tempType"] as? Int{
            self.tempType = tempType
        }
        if let limitprice = json["limitprice"] as? Float{
            self.limitprice = limitprice
        }
    }
}

//延期发货商品模型
final class FKYPostphoneProductModel: NSObject,JSONAbleType {
    var batchNum: String?      //
    var canUseCouponFlag: Int?    //
    var checkStatus : Bool? //
    var createTime: String?    //
    var deadLine: String?    //
    var fixComboYiShengPrice: Int?    //
    var fromWhere: Int?    //来源
    var inChannel: Bool?    //
    var isMutexCouponCode:Int?
    var isMutexTeJia:Int?//
    
    var lessMinReson: String?      //
    var manufactures: String?    //厂家
    var mdInfo : String? //
    // var messageMap: NSDictionry?    //
    var minPackingNum: String?    //
    var nearEffect: String?    //
    var outMaxReason: String?    //
    var productCodeCompany: String?    //
    var productCount: Int?    //
    var productGetRebateMoney:Int?
    var productId:Int?//
    
    var productImageUrl: String?  //商品图片
    var productLimitBuy: Int?    //
    var productMaxNum : Int? //
    var productName: String?    //商品名称
    var productPrice: Float?    //商品价格
    var productRebate: String?    //
    var productStatus: Int?    //来源
    var productType: String?    //
    var promotionCollectionId:String?
    var promotionFlashSale:String?//
    
    var promotionHG: String?  //
    var promotionId: Int?    //
    var promotionJF : String? //
    var promotionMJ: String?    //
    var promotionMZ: String?    //
    var promotionTJ: String?    //
    var promotionType: String?    //
    var promotionVipVO: String?    //
    var reachLimitNum:String?
    var saleStartNum:Int?//
    
    var settlementPrice: Float?  //
    var shareStockVO: FKYShareStockModel?    //延期日期提示
    var shoppingCartId : Int? //
    var showRebateMoneyFlag: String?    //
    var specification: String?    //规格
    var spuCode: String?    //商品spu
    var supplyId: Int?    //供应商id
    var unit: String?    //商品规格
    var wisdomBuyVersion:Int?
    
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>
    static func fromJSON(_ json: [String : AnyObject]) ->FKYPostphoneProductModel {
        let json = JSON(json)
        
        let model = FKYPostphoneProductModel()
        model.batchNum = json["batchNum"].stringValue
        model.canUseCouponFlag = json["canUseCouponFlag"].intValue
        model.checkStatus = json["checkStatus"].boolValue
        model.createTime = json["createTime"].stringValue
        model.deadLine = json["deadLine"].stringValue
        model.fixComboYiShengPrice = json["fixComboYiShengPrice"].intValue
        model.fromWhere = json["fromWhere"].intValue
        model.inChannel = json["inChannel"].boolValue
        model.isMutexCouponCode = json["isMutexCouponCode"].intValue
        model.isMutexTeJia = json["isMutexTeJia"].intValue
        
        model.lessMinReson = json["lessMinReson"].stringValue
        model.manufactures = json["manufactures"].stringValue
        model.mdInfo = json["mdInfo"].stringValue
        // model.messageMap = json["messageMap"].dictionaryObject
        model.minPackingNum = json["minPackingNum"].stringValue
        model.nearEffect = json["nearEffect"].stringValue
        model.outMaxReason = json["outMaxReason"].stringValue
        model.productCodeCompany = json["productCodeCompany"].stringValue
        model.productCount = json["productCount"].intValue
        model.productId = json["productId"].intValue
        
        model.productImageUrl = json["productImageUrl"].stringValue
        model.productLimitBuy = json["productLimitBuy"].intValue
        model.productMaxNum = json["productMaxNum"].intValue
        model.productName = json["productName"].stringValue
        model.productPrice = json["productPrice"].floatValue
        model.productRebate = json["productRebate"].stringValue
        model.productStatus = json["productStatus"].intValue
        model.productType = json["productType"].stringValue
        model.promotionCollectionId = json["promotionCollectionId"].stringValue
        model.promotionFlashSale = json["promotionFlashSale"].stringValue
        
        model.promotionHG = json["promotionHG"].stringValue
        model.promotionId = json["promotionId"].intValue
        model.promotionJF = json["promotionJF"].stringValue
        model.promotionMJ = json["promotionMJ"].stringValue
        model.promotionMZ = json["promotionMZ"].stringValue
        model.promotionTJ = json["promotionTJ"].stringValue
        model.promotionType = json["promotionType"].stringValue
        model.promotionVipVO = json["promotionVipVO"].stringValue
        model.reachLimitNum = json["reachLimitNum"].stringValue
        model.saleStartNum = json["saleStartNum"].intValue
        
        model.settlementPrice = json["settlementPrice"].floatValue
        if let detail = json["shareStockVO"].dictionaryObject {
            model.shareStockVO = (detail as NSDictionary).mapToObject(FKYShareStockModel.self)
        }
        model.shoppingCartId = json["shoppingCartId"].intValue
        model.showRebateMoneyFlag = json["showRebateMoneyFlag"].stringValue
        model.specification = json["specification"].stringValue
        model.spuCode = json["spuCode"].stringValue
        model.supplyId = json["supplyId"].intValue
        model.unit = json["unit"].stringValue
        model.wisdomBuyVersion = json["wisdomBuyVersion"].intValue
        
        return model
    }
    
    //解析数据
    @objc static func parsePostphoneProductArr(_ dataArr:NSArray) ->NSArray{
        if let getArr = dataArr.mapToObjectArray(FKYPostphoneProductModel.self){
            return getArr as NSArray
        }
        return []
    }
}
final class FKYShareStockModel: NSObject,JSONAbleType {
    var desc: String?    //秒杀提示文字
    var needAlert: Bool?      //
    var stockToFromWarhouseId: Int?    //
    
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>
    static func fromJSON(_ json: [String : AnyObject]) ->FKYShareStockModel {
        let json = JSON(json)
        
        let model = FKYShareStockModel()
        model.desc = json["desc"].stringValue
        model.needAlert = json["needAlert"].boolValue
        model.stockToFromWarhouseId = json["stockToFromWarhouseId"].intValue
        return model
    }
}
