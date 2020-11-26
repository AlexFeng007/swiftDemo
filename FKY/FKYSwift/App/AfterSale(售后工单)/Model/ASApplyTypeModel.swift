//
//  ASApplyTypeModel.swift
//  FKY
//
//  Created by 寒山 on 2019/5/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  售后工单 问题类型model

import UIKit
import SwiftyJSON

enum ASTypeECode: Int  {
    case ASType_R = -2 //mp退货
    case ASType_RC = -1 //申请退换货
    case ASType_Bill = 1 //随行单据（随货单/发票）
    case ASType_WrongNum = 2 //商品错漏发
    case ASType_DrugReport = 4 //药检报告
    case ASType_ProductReport = 5 //商品首营资质
    case ASType_EnterpriceReport = 6 //企业首营资质
    case ASType_Compensation = 7 //极速理赔
}

final class ASApplyTypeModel: JSONAbleType {
    var typeId: Int?
    var typeName: String?
    
    static func fromJSON(_ json: [String : AnyObject]) ->  ASApplyTypeModel {
        let json = JSON(json)
        let model =  ASApplyTypeModel()
        
        model.typeId = json["typeId"].intValue
        model.typeName = json["typeName"].stringValue
        
        return model
    }
}
