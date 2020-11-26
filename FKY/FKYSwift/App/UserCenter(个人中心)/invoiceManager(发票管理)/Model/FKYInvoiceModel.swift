//
//  FKYInvoiceModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class FKYInvoiceModel: NSObject,JSONAbleType{

    ///发票用户信息主键id
    var billId = ""
    
    ///单位名称
    var enterpriseName = ""
    
    ///纳税人识别号
    var taxpayerIdentificationNumber = ""
    
    ///注册地址
    var registeredAddress = ""
    
    ///注册电话
    var registeredTelephone = ""
    
    ///开户银行
    var openingBank = ""
    
    ///银行账户
    var bankAccount = ""
    
    ///发票类型:1专票；2普票 接口为null会解析为0
    var billType = 0
    
    ///发票状态:1待审核；2审核通过；3审核不通过 接口为null会解析为0
    var billStatus = 0
    
    ///银行总行
    var bankTypeVO = FKYBankModel()
    
    //银行开户行
//    var bankName = ""
    
    ///分店开总店开关: 0 - 关闭; 1 - 开启  接口为null会解析为0
    var branchSwitch = 0
    
    //发货审核状态: 0 - 未审核通过; 1 - 审核通过(对应PRD中的质管审核状态)
    var deliverStatus = 0
    
    ///底部tip
    var bottomMsg = ""
    
    ///中间tip
    var midMsg = ""
    
    ///头部tip
    var topMsg = ""
    
    ///审核通过/不通过原因
    var remark = ""
    
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYInvoiceModel {
        let json = JSON(json)
        let model = FKYInvoiceModel()
        model.billId = json["billId"].stringValue
        model.enterpriseName = json["enterpriseName"].stringValue
        model.taxpayerIdentificationNumber = json["taxpayerIdentificationNumber"].stringValue
        model.registeredAddress = json["registeredAddress"].stringValue
        model.registeredTelephone = json["registeredTelephone"].stringValue
        model.openingBank = json["openingBank"].stringValue
        model.bankAccount = json["bankAccount"].stringValue
        model.billType = json["billType"].intValue
        model.billStatus = json["billStatus"].intValue
        model.branchSwitch = json["branchSwitch"].intValue
        model.bottomMsg = json["bottomMsg"].stringValue
        model.midMsg = json["midMsg"].stringValue
        model.topMsg = json["topMsg"].stringValue
        model.remark = json["remark"].stringValue
        model.deliverStatus = json["deliverStatus"].intValue
        model.bankTypeVO = (json["bankTypeVO"].dictionaryValue as NSDictionary).mapToObject(FKYBankModel.self)
        return model
    }

    func reverseSaveJSON() -> [String : AnyObject] {
        var params = ["id":""]
        params["id"] = self.billId
        params["businessName"] = self.enterpriseName
        params["taxNum"] = self.taxpayerIdentificationNumber
        params["type"] = "\(self.billType)"
        //注册地址，注册电话，银行类型，开户银行，银行账号都有值，才上传
        if self.registeredAddress.count > 0 && self.registeredTelephone.count > 0 && self.bankTypeVO.id.count > 0 && self.openingBank.count > 0 && self.bankAccount.count > 0 {
                params["registerAddress"] = self.registeredAddress
                params["registerPhone"] = self.registeredTelephone
                params["bankType"] = self.bankTypeVO.id
                params["bankName"] = self.openingBank
                params["bankAccount"] = self.bankAccount
        }
        return params as [String : AnyObject]
    }
}

