//
//  FKYAllAfterSaleModel.swift
//  FKY
//
//  Created by hui on 2019/8/2.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

//全部售后列表模型
@objc
final class FKYAllAfterSaleModel: NSObject,JSONAbleType {
    var easOrderSecondType: String?//一级类型<0是退货 1是换货>
    var easOrderSecondTypeStr: String?//一级类型名称
    
    var easOrderThirdType: String? //仅工单有 工单二级类型
    var easOrderThirdTypeStr: String?//仅工单有 工单二级类型名称
    
    // 退换货单 : ASWA 填写申请 ASWB 商家审核 ASWC 商家审核(不通过) ASWD 撤回申请 ASWE 商家收货 ASWF 商家发货 ASWG 换货完成 ASWH t退款完成
    
    // 工单  填写申请 AWA,商家审核AWB 单据寄出AWC 售后完成 AWD
    @objc var easOrderstatus: String?  //状态
    @objc var easOrderstatusStr: String? //申请状态文字描述
    
    var orderId : String? //订单号id
    var childOrderId : String? //子订单号
    var supplyId : String? //供应商id
    var supplyName : String? //供应商名称
    var easOrderType : String? //单据类型(1 售后 2 工单)
    var date: String? //申请时间
    var customerId : String? //客户名称
    @objc var asAndWorkOrderNo : String? //单据号
    @objc var asAndWorkOrderId : String? //单据id
    var productList:Array<FKYAllAfterSaleProductModel>? //array<object>商品列表
    var completeContent:String? //备注信息
    var backWayName : String? //退换货，商品退还方式
    var backWay : String? //退换货，商品退还方式(字母简写)
    var refundAmount : Double? //退货总费用
    @objc var popFlag : String? //3是商家 其他自营
    var rmaBizType :Int? // 1- 极速理赔 其他为null
    
    static func fromJSON(_ json: [String : AnyObject]) ->  FKYAllAfterSaleModel {
        
        let json = JSON(json)
        let model =  FKYAllAfterSaleModel()
        model.easOrderSecondType = json["easOrderSecondType"].stringValue
        model.easOrderSecondTypeStr = json["easOrderSecondTypeStr"].stringValue
        model.easOrderThirdType = json["easOrderThirdType"].stringValue
        model.easOrderThirdTypeStr = json["easOrderThirdTypeStr"].stringValue
        model.easOrderstatus = json["easOrderstatus"].stringValue
        model.easOrderstatusStr = json["easOrderstatusStr"].stringValue
        model.orderId = json["orderId"].stringValue
        model.supplyId = json["supplyId"].stringValue
        model.supplyName = json["supplyName"].stringValue
        model.easOrderType = json["easOrderType"].stringValue
        model.date = json["date"].stringValue
        model.customerId = json["customerId"].stringValue
        model.asAndWorkOrderNo = json["asAndWorkOrderNo"].stringValue
        model.asAndWorkOrderId = json["asAndWorkOrderId"].stringValue
        model.completeContent = json["completeContent"].stringValue
        if let str = model.completeContent {
            //去掉前后空格换行符号
          model.completeContent =  str.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        }
        model.backWayName = json["backWayName"].stringValue
        model.backWay = json["backWay"].stringValue
        model.refundAmount = json["refundAmount"].doubleValue
        model.childOrderId  = json["childOrderId"].stringValue
        let productList = json["asAndWorkOrderDetailDTOList"].arrayObject
        var goodsInfo: [FKYAllAfterSaleProductModel]? = []
        if let list = productList {
            goodsInfo = (list as NSArray).mapToObjectArray(FKYAllAfterSaleProductModel.self)
        }
        model.productList = goodsInfo
        let flag = json["popFlag"].intValue
        model.popFlag = "\(flag)"
        model.rmaBizType = json["rmaBizType"].intValue
        return model
    }
}

//商品模型
@objc
final class FKYAllAfterSaleProductModel: NSObject,JSONAbleType {
    var batchNumber: String? //批号
    var expiryDate : String? //效期
    var mainImgPath: String?//图片链接
    var orderDetailId: String?//前段无用
    var productCode: String?//商品编码
    var productCount: String?//商品数量
    var productName: String?//商品名称 同shortname 后端拼接
    var productPrice: Double? //商品价格
    var shortName: String?//商品名称 同productName后端拼接
    var specification: String?//规格
    var applyCount: Int?//申请数量（大于0则取否则取商品数量）
    
    static func fromJSON(_ json: [String : AnyObject]) -> FKYAllAfterSaleProductModel {
        let json = JSON(json)
        
        let model = FKYAllAfterSaleProductModel()
        model.batchNumber = json["batchNumber"].stringValue
        model.batchNumber = json["expiryDate"].stringValue
        model.mainImgPath = json["mainImgPath"].stringValue
        model.orderDetailId = json["orderDetailId"].stringValue
        model.productCode = json["productCode"].stringValue
        model.productCount = json["productCount"].stringValue
        model.productName = json["productName"].stringValue
        model.productPrice = json["productPrice"].doubleValue
        model.shortName = json["shortName"].stringValue
        model.specification = json["specification"].stringValue
        model.applyCount = json["applyCount"].intValue
        return model
    }
}
