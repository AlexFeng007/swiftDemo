//
//  FKYRebateRecordModel.swift
//  FKY
//
//  Created by My on 2019/8/22.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import Foundation
import SwiftyJSON

final class RebateRecordModel: NSObject, JSONAbleType {
    var orderId: String? //订单id
    var enterpriseName: String? //商家
    var rebateTime: String? //支出或者获取时间
    var rebateMoney: Double? //支出或者获取金额
    var pendingDesc: String? //待到账描述

    var protocolName: String? //协议返利名称
    var rebateType: Int? //0.普通返利1.协议返利
    var protocolDesc: String? //"协议奖励金",
    var protocolDetailUrl: String? //协议奖励金跳转链接
    var protocolId: Int? //跳转至协议详情页所需的协议id
    var enterpriseId: Int? //跳转至协议详情页所需的商家id
    /// 返利金类型
    var statusStr = ""
    
    @objc static func fromJSON(_ json: [String : AnyObject]) -> RebateRecordModel {
        let json = JSON(json)
        let model = RebateRecordModel()
        
        model.orderId = json["orderId"].stringValue
        model.enterpriseName = json["enterpriseName"].stringValue
        model.rebateTime = json["rebateTime"].stringValue
        model.rebateMoney = json["rebateMoney"].doubleValue
        model.pendingDesc = json["pendingDesc"].stringValue
        
        model.protocolName = json["protocolName"].stringValue
        model.rebateType = json["rebateType"].intValue
        model.protocolDesc = json["protocolDesc"].stringValue
        model.protocolDetailUrl = json["protocolDetailUrl"].stringValue
        model.protocolId = json["protocolId"].intValue
        model.enterpriseId = json["enterpriseId"].intValue
        model.statusStr = json["statusStr"].stringValue
        return model
    }
}

final class FKYRebateRecordModel: NSObject, JSONAbleType {
    var total: Int?
    var totalPage: Int?
    var recordType: Int?
    var recordTypeDesc: String?
    var totalRebate: Double?//累计余额
    var pendingRebate: Double?//待到账余额
    var rebateRecord: Array<RebateRecordModel>?;//返利金记录明细
    
    // <Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYRebateRecordModel {
        let json = JSON(json)
        let model =  FKYRebateRecordModel()
        
        model.total = json["total"].intValue
        model.totalPage = json["totalPage"].intValue
        model.recordType = json["recordType"].intValue
        model.recordTypeDesc = json["recordTypeDesc"].stringValue
        model.totalRebate = json["totalRebate"].doubleValue
        model.pendingRebate = json["pendingRebate"].doubleValue
        
        var rebateRecords: [RebateRecordModel]? = []
        if let list = json["rebateRecord"].arrayObject {
            rebateRecords = (list as NSArray).mapToObjectArray(RebateRecordModel.self)
        }
        model.rebateRecord = rebateRecords
        return model
    }
}


