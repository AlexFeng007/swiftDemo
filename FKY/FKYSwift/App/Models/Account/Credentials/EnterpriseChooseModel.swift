//
//  EnterpriseChooseModel.swift
//  FKY
//
//  Created by 夏志勇 on 2017/9/21.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  用户可重新修改(选择)的企业类型model

import UIKit
import SwiftyJSON

final class EnterpriseChooseModel: NSObject, JSONAbleType {
    let name: String
    let typeId: String
    
    init(name: String, typeId: String) {
        self.name = name
        self.typeId = typeId
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> EnterpriseChooseModel {
        let j = JSON(json)
        let name = j["name"].stringValue
        let typeId = j["typeId"].stringValue
        
        return EnterpriseChooseModel(name: name, typeId: typeId)
    }
    
    func mapToEnterpriseTypeModel() -> EnterpriseTypeModel {
        let enterpriseTypeMoel = EnterpriseTypeModel(paramCode: "", paramName: name, paramValue: typeId)
        return enterpriseTypeMoel
    }
}

/*
非公立医疗机构 type_id=1
公立医疗机构   type_id=2
单体药店      type_id=3
连锁总店      type_id=4
个体诊所      type_id=5
*/
