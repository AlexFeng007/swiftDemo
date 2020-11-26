//
//  ProvinceModel.swift
//  FKY
//
//  Created by yangyouyong on 2016/11/2.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  地址model

import UIKit
import SwiftyJSON

final class ProvinceModel: NSObject,JSONAbleType {
    var infoCode: String?
    var infoName: String?
    var secondModel: [ProvinceModel]?
    
    init(infoCode: String? ,infoName: String?, secondModel: [ProvinceModel]?) {
        self.infoCode = infoCode
        self.infoName = infoName
        self.secondModel = secondModel
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> ProvinceModel {
        let j = JSON(json)
        let infoCode = j["infoCode"].string
        let infoName = j["infoName"].string
        let secondModel = [ProvinceModel]()
        return ProvinceModel(infoCode: infoCode, infoName: infoName, secondModel: secondModel)
    }
}
