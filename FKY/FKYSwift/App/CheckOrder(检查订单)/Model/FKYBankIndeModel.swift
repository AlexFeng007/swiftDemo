//
//  FKYBankIndeModel.swift
//  FKY
//
//  Created by yyc on 2020/5/7.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

//可用银行列表
final class FKYBankIndeModel: NSObject, JSONAbleType {
    
    var bankCode: String? //
    var bankName: String? //
    var bizType: String?
    var bankId: Int?
    var limitDesc: String?  //限额描述
    var singleLimit: NSNumber? //单笔限额
    var dailyLimit: NSNumber? //每日累计限额
   @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYBankIndeModel {
        let json = JSON(json)
        let model = FKYBankIndeModel()
        model.bankCode = json["bankCode"].stringValue
        model.bankName = json["bankName"].stringValue
        model.bizType = json["bizType"].stringValue
        model.bankId = json["id"].intValue
        model.singleLimit = json["singleLimit"].numberValue
        model.dailyLimit = json["dailyLimit"].numberValue
        model.limitDesc = json["limitDesc"].stringValue
        return model
    }
}
