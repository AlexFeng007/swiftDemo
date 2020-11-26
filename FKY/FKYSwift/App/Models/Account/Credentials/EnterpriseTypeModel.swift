//
//  EnterpriseTypeModel.swift
//  FKY
//
//  Created by yangyouyong on 2016/11/30.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  企业类型model

import UIKit
import SwiftyJSON

@objcMembers
final class EnterpriseTypeModel: NSObject,JSONAbleType {
    // MARk: - Property
    
    let paramValue: String      // type ids
    let paramName: String       // type name
    let paramCode: String       // 为空
    var selected: Bool = false  // 本地字段：表示是否已选中
    
    
    // MARK: - Init
    
    init(paramCode: String, paramName: String, paramValue: String) {
        self.paramCode = paramCode
        self.paramName = paramName
        self.paramValue = paramValue
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> EnterpriseTypeModel {
        let j = JSON(json)
        let paramCode = j["paramCode"].stringValue
        let paramName = j["paramName"].stringValue
        let paramValue = j["paramValue"].stringValue
        return EnterpriseTypeModel(paramCode: paramCode, paramName: paramName, paramValue: paramValue)
    }
    
    
    // MARK: - Publi
    
    // 合法性校验
    func isValid() -> Bool {
        guard let value = (paramValue as NSString).trimmingWhitespaceAndNewlines(), value.isEmpty == false else {
            return false
        }
        guard let name = (paramName as NSString).trimmingWhitespaceAndNewlines(), name.isEmpty == false else {
            return false
        }
        return true
    }
    
    // 字符串替换
    func getParamValueForAPI() -> String {
       return paramValue.replacingOccurrences(of: ";", with: ",")
    }
    
    // model转换
    func mapToEnterpriseOriginTypeModel() -> EnterpriseOriginTypeModel {
        var remark = "终端客户"
        if paramName == "批发企业" {
            remark = "批发企业"
        }
        let enterpriseTypeMoel = EnterpriseOriginTypeModel(typeId: self.paramValue.copy() as! String, paramCode: self.paramCode.copy() as! String, paramName: self.paramName.copy() as! String, paramValue: self.paramValue.copy() as! String, remark: remark, createUser: "", createTime: "", updateTime: "", updateUser: "")
        return enterpriseTypeMoel
    }
}


/*
"paramCode": "CLIENT_LEVEL",
"paramName": "非公立医疗机构",
"paramValue": "1",
*/

/*
{
    "data": [{
    "paramValue": "11;12;13;14",
    "paramName": "批发企业"
    }, {
    "paramValue": "1",
    "paramName": "非公立医疗机构"
    }, {
    "paramValue": "2",
    "paramName": "公立医疗机构"
    }, {
    "paramValue": "3",
    "paramName": "单体药店"
    }, {
    "paramValue": "4",
    "paramName": "连锁总店"
    }, {
    "paramValue": "5",
    "paramName": "个体诊所"
    }, {
    "paramValue": "8",
    "paramName": "连锁加盟店"
    }],
    "rtn_code": "0",
    "rtn_ext": "",
    "rtn_ftype": "0",
    "rtn_msg": "",
    "rtn_tip": ""
}
*/
