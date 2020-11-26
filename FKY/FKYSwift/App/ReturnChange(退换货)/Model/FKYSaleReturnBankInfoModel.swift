//
//  FKYSaleReturnBankInfoModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class FKYSaleReturnBankInfoModel: NSObject ,JSONAbleType{
    ///银行卡户名
    var accountName = ""
    ///银行卡号
    var bankCardNo = ""
    ///开户行
    var bankName = ""
    ///银行类型
    var bankTypeVO = FKYBankModel()
    ///银行类型列表
    var bankTypes = [FKYBankModel]()
    
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYSaleReturnBankInfoModel {
        let json = JSON(json)
        let model = FKYSaleReturnBankInfoModel()
        model.accountName = json["accountName"].stringValue
        model.bankCardNo = json["bankCardNo"].stringValue
        model.bankName = json["bankName"].stringValue
        model.bankTypeVO = (json["bankTypeVO"].dictionaryValue as NSDictionary).mapToObject(FKYBankModel.self)
        let list = json["bankTypes"].arrayValue as NSArray
        model.bankTypes = list.mapToObjectArray(FKYBankModel.self) ?? [FKYBankModel]()
        return model
    }
}
