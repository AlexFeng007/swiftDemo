//
//  FKYRebateDetailInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2019/2/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final  class RebateDetailInfoModel: NSObject , JSONAbleType {
    @objc var rebateAmount: String?        //
    @objc var sellerName: String?       //
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>
    static func fromJSON(_ json: [String : AnyObject]) -> RebateDetailInfoModel {
        let json = JSON(json)
        
        let model = RebateDetailInfoModel()
        model.rebateAmount = json["rebateAmount"].stringValue
        model.sellerName = json["sellerName"].stringValue
        return model
    }
}

//customer_name: "duansea6",enterprise_id:"95142", enterprise_name:"曾某人医药批发集团",order_id:"XXD20190219133900571295",rebate_money:345;rebate_time:"2019-02-22 14:10:12",remark:"订单确认收货后 3 个工作日返还采购返利",operation_source:0
final  class DelayRebateInfoModel: NSObject , JSONAbleType {
    var rebate_money: Double?    //
    var customer_name: String?       //
    var enterprise_id: String?       //
    var enterprise_name: String?       //
    var order_id: String?       //
    var rebate_time: String?       //
    var remark: String?       //
    var operation_source: Int?       //
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>
    static func fromJSON(_ json: [String : AnyObject]) -> DelayRebateInfoModel {
        let json = JSON(json)
        
        let model = DelayRebateInfoModel()
        model.operation_source = json["operation_source"].intValue
        model.rebate_money = json["rebate_money"].doubleValue
        model.customer_name = json["customer_name"].stringValue
        model.enterprise_id = json["enterprise_id"].stringValue
        model.enterprise_name = json["enterprise_name"].stringValue
        model.order_id = json["order_id"].stringValue
        model.rebate_time = json["rebate_time"].stringValue
        model.remark = json["remark"].stringValue
        return model
    }
}
//    "rebateAmount": 4.00,
//    "sellerName": "广东壹号药业有限公司-ziying"

