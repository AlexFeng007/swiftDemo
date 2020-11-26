//
//  EnterpriseOriginTypeModel.swift
//  FKY
//
//  Created by airWen on 2017/7/17.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  企业类型model

import UIKit
import SwiftyJSON

@objcMembers
final class EnterpriseOriginTypeModel: NSObject,JSONAbleType {
    let typeId: String
    let paramCode: String
    let paramName: String
    let paramValue: String
    let remark: String
    let createUser: String?
    let createTime: String?
    let updateTime: String?
    let updateUser: String?
    var selected: Bool = false
    
    init(typeId: String, paramCode: String, paramName: String, paramValue: String, remark: String, createUser: String?, createTime: String?, updateTime: String?, updateUser: String?) {
        self.typeId = typeId
        self.paramCode = paramCode
        self.paramName = paramName
        self.paramValue = paramValue
        self.remark = remark
        self.createUser = createUser
        self.createTime = createTime
        self.updateTime = updateTime
        self.updateUser = updateUser
    }
    
    init(typeId: String, paramCode: String, paramName: String, paramValue: String, remark: String, createUser: String?, createTime: String?, updateTime: String?, updateUser: String?, selected: Bool) {
        self.typeId = typeId
        self.paramCode = paramCode
        self.paramName = paramName
        self.paramValue = paramValue
        self.remark = remark
        self.createUser = createUser
        self.createTime = createTime
        self.updateTime = updateTime
        self.updateUser = updateUser
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> EnterpriseOriginTypeModel {
        let j = JSON(json)
        let typeId = j["id"].stringValue
        let paramCode = j["paramCode"].stringValue
        let paramName = j["paramName"].stringValue
        let paramValue = j["paramValue"].stringValue
        let remark = j["remark"].stringValue
        let createUser = j["createUser"].string
        let createTime = j["createTime"].string
        let updateTime = j["updateTime"].string
        let updateUser = j["updateUser"].string
        
        return EnterpriseOriginTypeModel(typeId: typeId, paramCode: paramCode, paramName: paramName, paramValue: paramValue, remark: remark, createUser: createUser, createTime: createTime, updateTime: updateTime, updateUser: updateUser)
    }
    
    func getParamValueForAPI() -> String {
        return paramValue.replacingOccurrences(of: ";", with: ",")
    }
    
    func getEnterpriseIds() -> [Int] {
        var enterpriseIdInt: [Int] = []
        for enterpriseIds in paramValue.components(separatedBy: ";") {
            if let int = Int(enterpriseIds) {
                enterpriseIdInt.append(int)
            }
        }
        return enterpriseIdInt
    }
}
