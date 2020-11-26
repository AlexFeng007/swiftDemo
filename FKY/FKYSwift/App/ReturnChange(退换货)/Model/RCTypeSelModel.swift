//
//  RCTypeSelModel.swift
//  FKY
//
//  Created by 寒山 on 2018/11/27.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class RCProductCountModel: NSObject, JSONAbleType {
    var orderDetailId: Int?            //订单明细id
    var rmaCount: Int?            //可退换货
    var orderDeliveryDetailId: Int?   //订单发货明细id
    var batchNumber :String? //批号
    static func fromJSON(_ json: [String : AnyObject]) -> RCProductCountModel {
        let json = JSON(json)
        
        let model = RCProductCountModel()
        model.orderDetailId = json["orderDetailId"].intValue
        model.rmaCount = json["rmaCount"].intValue
        return model
    }
    
    static func paraMpJSON(_ arr:NSArray) -> [RCProductCountModel] {
        var desArr = [RCProductCountModel]()
        for dic in arr{
            let json = JSON(dic)
            let model = RCProductCountModel()
            model.orderDetailId = json["orderDetailId"].intValue
            model.rmaCount = json["canReturnCount"].intValue
            model.orderDeliveryDetailId = json["orderDeliveryDetailId"].intValue
            model.batchNumber = json["batchNumber"].string
            desArr.append(model)
        }
        return desArr
    }
}

final class RCChildOrderIdModel: NSObject, JSONAbleType {
    var state: String?               //
    var childSalesOrderId: String?              //XXD2018112215415244272601",
    var sdSalesOrderId: String?          //XXD20181122154152442726",
    var orderBizType: String?           //       //
    static func fromJSON(_ json: [String : AnyObject]) -> RCChildOrderIdModel {
        let json = JSON(json)
        
        let model = RCChildOrderIdModel()
        model.state = json["state"].stringValue
        model.childSalesOrderId = json["childSalesOrderId"].stringValue
        model.sdSalesOrderId = json["sdSalesOrderId"].stringValue
        model.orderBizType = json["orderBizType"].stringValue
        return model
    }
}
