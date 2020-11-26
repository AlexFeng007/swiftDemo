//
//  FKYCheckOrderMainModel.swift
//  FKY
//
//  Created by My on 2019/12/27.
//  Copyright © 2019 yiyaowang. All rights reserved.
//
//  6.3.1 为了兼容不可用码的问题接口又包了一层

import UIKit
import SwiftyJSON

final class FKYCheckOrderMainModel: NSObject, JSONAbleType {
    
    var orderModel: CheckOrderModel? //正常情况订单model
    var attachment: [COProductModel]? //不可用码商品
    var code: Int?
    var errorCode: String?
    var ext: String?
    var msg: String?
    var tip: String?
    
    static func fromJSON(_ json: [String : AnyObject]) -> FKYCheckOrderMainModel {
        let json = JSON(json)
        let model = FKYCheckOrderMainModel()
        
        let data = json["data"].dictionaryObject
        if let _ = data {
            let dataDic = data! as NSDictionary
            model.orderModel = dataDic.mapToObject(CheckOrderModel.self)
        }else{
            model.orderModel = nil
        }
        
        var attachment: [COProductModel]? = []
        let listProduct = json["attachment"].arrayObject
        if let list = listProduct {
            attachment = (list as NSArray).mapToObjectArray(COProductModel.self)
        }
        model.attachment = attachment
        
        
        model.code = json["code"].intValue
        model.errorCode = json["errorCode"].stringValue
        model.ext = json["ext"].stringValue
        model.msg = json["msg"].stringValue
        model.tip = json["tip"].stringValue
        return model
    }
}
