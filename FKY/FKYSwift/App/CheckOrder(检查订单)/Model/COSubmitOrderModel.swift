//
//  COSubmitOrderModel.swift
//  FKY
//
//  Created by 夏志勇 on 2019/3/12.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  提交订单接口返回model

import UIKit
import SwiftyJSON

final class COSubmitOrderModel: NSObject, JSONAbleType {
    var result: Bool?                       //
    var submitStatus: Int?                  //
    var url: String?                        //
    var orderIds: String?                   //
    var orderFlowIds: String?               // 订单号拼成的字串...<逗号,分隔>
    var orderIdList: [String]?              // 订单号数组...<最关键字段>
    var noPayCancelTime: [String: String]?  // 订单倒计时
    var payType: [String: String]?          // 支付方式...<1-线上，3-线下>
    
    // <Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) -> COSubmitOrderModel {
        let json = JSON(json)
        
        let model = COSubmitOrderModel()
        model.result = json["result"].boolValue
        model.submitStatus = json["submitStatus"].intValue
        model.url = json["url"].stringValue
        model.orderIds = json["orderIds"].stringValue
        model.orderFlowIds = json["orderFlowIds"].stringValue
        model.orderIdList = json["orderIdList"].arrayObject as? [String]
        model.noPayCancelTime = json["noPayCancelTime"].dictionaryObject as? [String: String]
        model.payType = json["payType"].dictionaryObject as? [String: String]
        return model
    }
}
