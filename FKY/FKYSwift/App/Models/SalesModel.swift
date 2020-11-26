//
//  SalesModel.swift
//  FKY
//
//  Created by mahui on 2016/11/14.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SwiftyJSON

final class SalesModel :NSObject, JSONAbleType, NSCopying {
    
    var adviserCode :String?
    var adviserName :String?
    var createTime :String?
    var createUser :String?
    var enterpriseId :String?
    var id :String?
    var isDefault :String?
    var phoneNumber :String?
    var remark :String?
    var status :String?
    var updateTime :String?
    var updateUser :String?

    init(adviserCode:String? ,adviserName: String?, createTime: String?, enterpriseId: String?, createUser: String?, id: String?, isDefault: String?, phoneNumber: String?, remark: String?, status: String?, updateTime: String?, updateUser: String?) {
        self.adviserCode = adviserCode
        self.adviserName = adviserName
        self.createTime = createTime
        self.createUser = createUser
        self.enterpriseId = enterpriseId
        self.id = id
        self.isDefault = isDefault
        self.phoneNumber = phoneNumber
        self.remark = remark
        self.status = status
        self.updateTime = updateTime
        self.updateUser = updateUser

    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> SalesModel {
        let json = JSON(json)
        
        let adviserCode = json["adviserCode"].stringValue
        let adviserName = json["adviserName"].stringValue
        let createTime = json["createTime"].stringValue
        let createUser = json["createUser"].stringValue
        let enterpriseId = json["enterpriseId"].stringValue
        let id = json["id"].stringValue
        let isDefault = json["isDefault"].stringValue
        let phoneNumber = json["phoneNumber"].stringValue
        let remark = json["remark"].stringValue
        let status = json["status"].stringValue
        let updateTime = json["updateTime"].stringValue
        let updateUser = json["updateUser"].stringValue
        
        return SalesModel(adviserCode: adviserCode, adviserName: adviserName, createTime: createTime, enterpriseId: enterpriseId, createUser: createUser, id: id, isDefault: isDefault, phoneNumber: phoneNumber, remark: remark, status: status, updateTime: updateTime, updateUser: updateUser)
    }
    
    func copy(with zone: NSZone?) -> Any {
        let model: SalesModel = SalesModel(adviserCode: self.adviserCode, adviserName: self.adviserName, createTime: self.createTime, enterpriseId: self.enterpriseId, createUser: self.createUser, id: self.id, isDefault: self.isDefault, phoneNumber: self.phoneNumber, remark: self.remark, status: self.status, updateTime: self.updateTime, updateUser: self.updateUser)
        return model;
    }
}
