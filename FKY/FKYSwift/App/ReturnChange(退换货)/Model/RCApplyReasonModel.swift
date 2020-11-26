//
//  RCApplyReasonModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/29.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退换货之提交信息界面中申请原因接口返回model

import SwiftyJSON

final class RCApplyReasonModel: NSObject, JSONAbleType {
    var createDate: String?     //
    var createStaff: String?    //
    var delFlag: Int?           //
    var id: Int?                //
    var name: String?           //
    var priority: Int?          //
    var type: Int?              //
    var updateDate: String?     //
    var updateStaff: String?    //
    
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>...<Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) -> RCApplyReasonModel {
        let json = JSON(json)
        
        let model = RCApplyReasonModel()
        model.createDate = json["createDate"].stringValue
        model.createStaff = json["createStaff"].stringValue
        model.delFlag = json["delFlag"].intValue
        model.id = json["id"].intValue
        model.name = json["name"].stringValue
        model.priority = json["priority"].intValue
        model.type = json["type"].intValue
        model.updateDate = json["updateDate"].stringValue
        model.updateStaff = json["updateStaff"].stringValue
        return model
    }
}
