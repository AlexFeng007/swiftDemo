//
//  FKYAddressItemModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/8/14.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  四级地址之地址model

import UIKit
import SwiftyJSON

final class FKYAddressItemModel: NSObject, JSONAbleType {
    var code: String?
    var name: String?
    var level: String?
    var parentCode: String?
    //var id: String?
    
    init(code: String?, name: String?, level: String?, parentCode: String?) {
        self.code = code
        self.name = name
        self.level = level
        self.parentCode = parentCode
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> FKYAddressItemModel {
        let j = JSON(json)
        let code = j["code"].string
        let name = j["name"].string
        let level = j["level"].string
        let parentCode = j["parentCode"].string
        return FKYAddressItemModel.init(code: code, name: name, level: level, parentCode: parentCode)
    }
}
