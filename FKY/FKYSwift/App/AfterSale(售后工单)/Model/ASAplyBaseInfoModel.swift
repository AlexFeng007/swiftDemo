//
//  ASAplyBaseInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2019/5/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  基本信息Model

import UIKit
import SwiftyJSON


final class ASAplyBaseInfoModel: JSONAbleType {
   var productList: Array<ASApplyBaseProductModel>? //array<object>
   var typeList: Array<ASApplyTypeModel>? //array<object>
    
    static func fromJSON(_ json: [String : AnyObject]) -> ASAplyBaseInfoModel {
        let json = JSON(json)
        
        let model = ASAplyBaseInfoModel()
        
        let productList = json["productList"].arrayObject
        var pList: [ASApplyBaseProductModel]? = []
        if let list = productList {
            pList = (list as NSArray).mapToObjectArray(ASApplyBaseProductModel.self)
        }
        model.productList = pList
        
        let tList = json["typeList"].arrayObject
        var typeList: [ASApplyTypeModel]? = []
        if let list = tList {
            typeList = (list as NSArray).mapToObjectArray(ASApplyTypeModel.self)
        }
        model.typeList = typeList
        
        return model
    }
}

final class ASApplyBaseProductModel: NSObject, JSONAbleType {
    var orderDetailId: Int?
    var productCount: Int?
    var productId: Int?
    var productName: String?
    var productPicUrl: String?
    var sellerCode: Int?
    var spuCode: String?
    var steperCount: Int?
    var checkStatus: Bool?
    var batchNo: String?
    var isSelected: Bool = false

    static func fromJSON(_ json: [String : AnyObject]) -> ASApplyBaseProductModel {
        let json = JSON(json)
        
        let model = ASApplyBaseProductModel()
        model.batchNo = json["batchNo"].stringValue
        model.orderDetailId = json["orderDetailId"].intValue
        model.productCount = json["productCount"].intValue
        model.productId = json["productId"].intValue
        model.sellerCode = json["sellerCode"].intValue
        model.productName = json["productName"].stringValue
        model.productPicUrl = json["productPicUrl"].stringValue
        model.spuCode = json["spuCode"].stringValue
        model.steperCount = json["steperCount"].intValue
        model.checkStatus = json["checkStatus"].boolValue
        return model
    }
}
