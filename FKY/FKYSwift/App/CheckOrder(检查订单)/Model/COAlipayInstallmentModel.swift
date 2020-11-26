//
//  COAlipayInstallmentModel.swift
//  FKY
//
//  Created by 夏志勇 on 2019/3/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON


class COAlipayInstallmentModel: NSObject {
    var position: Int?                                              //
    var orderMoney: String?                                         //
    var hbInstalmentInfoDtoList: [COAlipayInstallmentItemModel]?    // 花呗分期费率列表
    
    // <Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) -> COAlipayInstallmentModel {
        let json = JSON(json)
        
        let model = COAlipayInstallmentModel()
        model.position = json["position"].intValue
        model.orderMoney = json["orderMoney"].stringValue
        
        var hbInstalmentInfoDtoList: [COAlipayInstallmentItemModel]? = []
        let listInstallment = json["hbInstalmentInfoDtoList"].arrayObject
        if let list = listInstallment {
            hbInstalmentInfoDtoList = (list as NSArray).mapToObjectArray(COAlipayInstallmentItemModel.self)
        }
        model.hbInstalmentInfoDtoList = hbInstalmentInfoDtoList
        
        return model
    }
}


// MARK: - 订单之供应商销售信息model
final class COAlipayInstallmentItemModel: NSObject, JSONAbleType {
    var hbFqNum: Int?               // 分期数
    var eachFee: Double?             // 每期手续费
    var eachPrin: Double?            // 每期本金
    var payAmount: Double?           // 订单金额
    var prinAndFee: Double?          // 每期总费用
    var totalEachFee: Double?        // 分期总手续费
    var totalPrinAndFee: Double?     // 分期付款总费用
    var feeRate: String?            // 费率
    
    static func fromJSON(_ json: [String : AnyObject]) -> COAlipayInstallmentItemModel {
        let json = JSON(json)
        
        let model = COAlipayInstallmentItemModel()
        model.hbFqNum = json["hbFqNum"].intValue
        model.eachFee = json["eachFee"].doubleValue
        model.eachPrin = json["eachPrin"].doubleValue
        model.payAmount = json["payAmount"].doubleValue
        model.prinAndFee = json["prinAndFee"].doubleValue
        model.totalEachFee = json["totalEachFee"].doubleValue
        model.totalPrinAndFee = json["totalPrinAndFee"].doubleValue
        model.feeRate = json["feeRate"].stringValue
        return model
    }
}
