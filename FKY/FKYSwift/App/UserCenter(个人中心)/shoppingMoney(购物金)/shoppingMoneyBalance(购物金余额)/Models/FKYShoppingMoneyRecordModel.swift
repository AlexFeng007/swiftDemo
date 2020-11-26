//
//  FKYShoppingMoneyRecordModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

/*
"accountEnterprise": 95617,
"accountId": 9,
"expendAmount": null,
"id": 171,
"incomeAmount": 44.65,
"operateTime": "2020-06-05 10:37:22",
"orderNo": "ZXD202006051036222954958",
"sellerCode": "125476",
"sellerName": "重庆亿昊药业有限公司",
"type": "C001",
"typeName": "取消订单解冻"
*/

import UIKit
import HandyJSON

class FKYShoppingMoneyRecordModel: NSObject, HandyJSON {
    override required init() { }

    var accountEnterprise: Int = 0

    var accountId: Int = 0

    /// 支出记录
    var expendAmount: Float = 0.0

    /// 当前记录的ID 对应接口返回的id
    var recordID: Float = 0.0

    /// 收入记录
    var incomeAmount: Float = 0.0

    var operateTime: String = ""

    /// 订单编号
    var orderNo: String = ""

    var sellerCode: String = ""

    var sellerName: String = ""

    var type: String = ""

    var typeName: String = ""

    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &recordID, name: "id")
    }

}


