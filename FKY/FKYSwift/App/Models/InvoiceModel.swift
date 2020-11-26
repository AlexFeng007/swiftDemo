//
//  InvoiceModel.swift
//  FKY
//
//  Created by Rabe on 17/07/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  发票model

import Foundation
import SwiftyJSON

final class InvoiceModel: NSObject, JSONAbleType, ReverseJSONType {
    var bankAccount: String? // 银行账户
    var billId: String? // 发票主键
    var billStatus: String? // 发票状态 发票状态:1待审核；2审核通过；3审核不通过
    var billType: String? // 发票类型 1-增值税专用发票 2-增值税普通发票 3-增值税电子普通发票
    var enterpriseName: String? // 单位名称
    var openingBank: String? // 开户银行
    var registeredAddress: String? // 注册地址
    var registeredTelephone: String? // 注册电话
    var taxpayerIdentificationNumber: String? // 纳税人识别号
    var message: String? // 财务审核提示信息
    var license: String? // 纳税人识别号是否必填 1-必填 2-非必填
    
    init(billType: String?) {
        self.bankAccount = ""
        self.billId = ""
        self.billStatus = ""
        self.billType = billType
        self.enterpriseName = ""
        self.openingBank = ""
        self.registeredAddress = ""
        self.registeredTelephone = ""
        self.taxpayerIdentificationNumber = ""
        self.message = ""
        self.license = ""
    }
    
    init(bankAccount: String?, billId: String?, billStatus: String?, billType: String?, enterpriseName: String?, openingBank: String?, registeredAddress: String?, registeredTelephone: String?, taxpayerIdentificationNumber: String?, message: String?, license: String?) {
        self.bankAccount = bankAccount
        self.billId = billId
        self.billStatus = billStatus
        self.billType = billType
        self.enterpriseName = enterpriseName
        self.openingBank = openingBank
        self.registeredAddress = registeredAddress
        self.registeredTelephone = registeredTelephone
        self.taxpayerIdentificationNumber = taxpayerIdentificationNumber
        self.message = message
        self.license = license
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> InvoiceModel {
        let j = JSON(json)
        let bankAccount = j["bankAccount"].stringValue
        let billId = j["billId"].stringValue
        let billStatus = j["billStatus"].stringValue
        let billType = j["billType"].stringValue
        let enterpriseName = j["enterpriseName"].stringValue
        let openingBank = j["openingBank"].stringValue
        let registeredAddress = j["registeredAddress"].stringValue
        let registeredTelephone = j["registeredTelephone"].stringValue
        let taxpayerIdentificationNumber = j["taxpayerIdentificationNumber"].stringValue
        let message = j["message"].stringValue
        let license = j["license"].stringValue
        return InvoiceModel(bankAccount: bankAccount, billId: billId, billStatus: billStatus, billType: billType, enterpriseName: enterpriseName, openingBank: openingBank, registeredAddress: registeredAddress, registeredTelephone: registeredTelephone, taxpayerIdentificationNumber: taxpayerIdentificationNumber, message: message, license:license)
    }
    
    func reverseJSON() -> [String : AnyObject] {
        var json = ["bankAccount":"",
                    "billId": "",
                    "enterpriseName": "",
                    "openingBank": "",
                    "registeredAddress": "",
                    "registeredTelephone": "",
                    "taxpayerIdentificationNumber": ""]
        if (self.bankAccount! as NSString).length > 0 {
            json["bankAccount"] = self.bankAccount
        }
        if (self.billId! as NSString).length > 0 {
            json["billId"] = self.billId
        }
        if (self.enterpriseName! as NSString).length > 0 {
            json["enterpriseName"] = self.enterpriseName
        }
        if (self.openingBank! as NSString).length > 0 {
            json["openingBank"] = self.openingBank
        }
        if (self.registeredAddress! as NSString).length > 0 {
            json["registeredAddress"] = self.registeredAddress
        }
        if (self.registeredTelephone! as NSString).length > 0 {
            json["registeredTelephone"] = self.registeredTelephone
        }
        if (self.taxpayerIdentificationNumber! as NSString).length > 0 {
            json["taxpayerIdentificationNumber"] = self.taxpayerIdentificationNumber
        }
        return json as [String : AnyObject]
    }
    
    func reverseSaveJSON() -> [String : AnyObject] {
        var json = ["bankAccount":"",
                    "id": "",
                    "businessName": "",
                    "bankName": "",
                    "registerAddress": "",
                    "registerPhone": "",
                    "taxNum": "",
                    "type": ""]
        if (self.bankAccount! as NSString).length > 0 {
            json["bankAccount"] = self.bankAccount
        }
        if (self.billId! as NSString).length > 0 {
            json["id"] = self.billId
        }
        if (self.enterpriseName! as NSString).length > 0 {
            json["businessName"] = self.enterpriseName
        }
        if (self.openingBank! as NSString).length > 0 {
            json["bankName"] = self.openingBank
        }
        if (self.registeredAddress! as NSString).length > 0 {
            json["registerAddress"] = self.registeredAddress
        }
        if (self.registeredTelephone! as NSString).length > 0 {
            json["registerPhone"] = self.registeredTelephone
        }
        if (self.taxpayerIdentificationNumber! as NSString).length > 0 {
            json["taxNum"] = self.taxpayerIdentificationNumber
        }
        if (self.billType! as NSString).length > 0 {
            json["type"] = self.billType
        }
        return json as [String : AnyObject]
    }
    
    static func changeModelWithOtherModel(_ infoModel:FKYInvoiceModel) -> InvoiceModel {
        let model = InvoiceModel(billType: "\(infoModel.billType)")
        model.bankAccount = infoModel.bankAccount
        model.billId = infoModel.billId
        model.enterpriseName = infoModel.enterpriseName
        model.openingBank = infoModel.openingBank
        model.registeredAddress = infoModel.registeredAddress
        model.registeredTelephone = infoModel.registeredTelephone
        model.taxpayerIdentificationNumber = infoModel.taxpayerIdentificationNumber
        model.billStatus = "\(infoModel.billStatus)"
        return model
    }
}
