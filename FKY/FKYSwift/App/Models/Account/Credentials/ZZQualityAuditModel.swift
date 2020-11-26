//
//  ZZQualityAuditModel.swift
//  FKY
//
//  Created by Andy on 2018/12/24.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

//"qualityAuditList": [{
//"seller_code": 8353,
//"isAudit": "1",
//"isAuditfailedReason": "你好啊哈哈哈求求求啊你好啊哈哈哈求求求啊",
//"shortName": "广东"
//}, {
//"seller_code": 104169,
//"isAudit": "5",
//"isAuditfailedReason": "资质授权证书未上传",
//"shortName": "安徽"
//}, {
//"seller_code": 125476,
//"isAudit": "5",
//"isAuditfailedReason": "资质授权证书未上传",
//"shortName": "重庆"
//}, {
//"seller_code": 95859,
//"isAudit": "0",
//"isAuditfailedReason": null,
//"shortName": "四川"
//}, {
//"seller_code": 134428,
//"isAudit": "0",
//"isAuditfailedReason": null,
//"shortName": "昆山"
//}],

import UIKit
import SwiftyJSON

final class ZZQualityAuditModel: NSObject,JSONAbleType {
    let shortName: String
    let isAudit: String
    let isAuditfailedReason: String
    let seller_code: String
    
    init(shortName: String, isAudit: String, isAuditfailedReason: String, seller_code:String) {
        self.shortName = shortName
        self.isAudit = isAudit
        self.isAuditfailedReason = isAuditfailedReason
        self.seller_code = seller_code
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> ZZQualityAuditModel {
        let j = JSON(json)
        let shortName = j["shortName"].stringValue
        let isAudit = j["isAudit"].stringValue
        let isAuditfailedReason = j["isAuditfailedReason"].stringValue
        let seller_code = j["seller_code"].stringValue
        return ZZQualityAuditModel(shortName: shortName, isAudit: isAudit, isAuditfailedReason: isAuditfailedReason, seller_code: seller_code)
    }
}
