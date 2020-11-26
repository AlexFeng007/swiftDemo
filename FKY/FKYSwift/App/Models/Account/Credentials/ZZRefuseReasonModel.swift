//
//  ZZRefuseReasonModel.swift
//  FKY
//
//  Created by yangyouyong on 2016/12/13.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class ZZRefuseReasonModel: NSObject, JSONAbleType {
    
    var id : Int?
    var enterpriseId : Int?
    var type : Int?
    var status : Int?
    var failedReason : String?
    
    // 页面传递
    override init() {
        
    }
    
    // JSON 解析
    init(id:Int?,enterpriseId:Int?,type:Int?,status:Int?,failedReason:String?) {
        self.id = id
        self.enterpriseId = enterpriseId
        self.type = type
        self.status = status
        self.failedReason = failedReason
    }
    
    static func fromJSON(_ data: [String : AnyObject]) -> ZZRefuseReasonModel {
        let json = JSON(data)
        
        let id = json["id"].intValue
        let enterpriseId = json["enterpriseId"].intValue
        let type = json["type"].intValue
        let status = json["status"].intValue
        let failedReason = json["failedReason"].stringValue

        return ZZRefuseReasonModel(id: id, enterpriseId: enterpriseId, type: type, status: status, failedReason: failedReason)
    }
}


final class ZZAllInOneRefuseReasonModel: NSObject, JSONAbleType {
    
    var type : Int?
    var status : Int?
    var failedReason : String?
    
    // 页面传递
    override init() {
        
    }
    
    // JSON 解析
    init(type:Int?,status:Int?,failedReason:String?) {
        self.type = type
        self.status = status
        self.failedReason = failedReason
    }
    
    static func fromJSON(_ data: [String : AnyObject]) -> ZZAllInOneRefuseReasonModel {
        let json = JSON(data)

        let type = json["type"].intValue
        let status = json["status"].intValue
        let failedReason = json["failed_reason"].stringValue

        return ZZAllInOneRefuseReasonModel(type: type, status: status, failedReason: failedReason)
    }
}
