//
//  PDOrderChangeInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2020/3/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
//
import UIKit
import SwiftyJSON
//message    校验提示消息（statusCode为1/2时有值）    string    @mock=满￥300.00包邮，还差￥200.00
//   shortWarehouseName    自营仓简称    string    @mock=华北仓
//   statusCode    校验结果码 0:满足包邮和起送；1:未满足起送门槛；2:未满足包邮门槛；3：无法购买    number
//   supplyName    企业名称    string    @mock=广东壹号药业有限公司
//   supplyType    供应商类型（0：自营；1：MP商家）    number
//"doorSalePrice": 100,
//"freeShippingAmount": 500.00,
//"freeShippingNeed": null,
//"message": "满¥100起送，还差¥99.00",
//"needAmount": 99.00,
//"shortWarehouseName": "",
//"statusCode": 1,
//"supplyId": 94495,
//"supplyName": "王辉测试批发企业",
//"supplyOrderFreight": 10.00,
//"supplyType": 1
@objc final class PDOrderChangeInfoModel: NSObject, JSONAbleType {
    @objc var shortWarehouseName:String?       //    自营仓名称简称    string    supplyType为0时存在
    @objc var supplyName:String?       //    供应商名称    string
    @objc var supplyType:String?       //    是否是自营商家标识0：自营，1:MP    string
    @objc var statusCode : NSNumber? // 供应商id
    @objc var doorSalePrice:NSNumber? //起售门槛
    @objc var freeShippingAmount:NSNumber? //运费
    @objc var freeShippingNeed:NSNumber? //还需多少钱达到起售门槛
    @objc var message:String?       //
    @objc var supplyId:String?       //
    @objc var supplyOrderFreight:NSNumber? //订单运费
    @objc var needAmount:NSNumber? //还需多少起送
    @objc static func fromJSON(_ json: [String : AnyObject]) ->PDOrderChangeInfoModel{
        let json = JSON(json)
        let model = PDOrderChangeInfoModel()
        model.shortWarehouseName = json["shortWarehouseName"].stringValue
        model.supplyName = json["supplyName"].stringValue
        model.supplyType = json["supplyType"].stringValue
        model.statusCode = json["statusCode"].numberValue
        
        model.message = json["message"].stringValue
        model.supplyId = json["supplyId"].stringValue
        
        model.doorSalePrice = json["doorSalePrice"].numberValue
        model.freeShippingAmount = json["freeShippingAmount"].numberValue
        model.freeShippingNeed = json["freeShippingNeed"].numberValue
        model.supplyOrderFreight = json["supplyOrderFreight"].numberValue
        model.needAmount = json["needAmount"].numberValue
        return model
    }
    
}
