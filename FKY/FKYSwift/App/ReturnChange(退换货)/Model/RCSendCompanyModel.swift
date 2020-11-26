//
//  RCSendCompanyModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/22.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退换货之回寄信息界面中快递公司接口返回model

import SwiftyJSON

final class RCSendCompanyModel: NSObject, JSONAbleType {
    var carrierCode: String?    //
    var carrierId: String?      //
    var carrierName: String?    //
    var carrierURL: String?     //
    var enableFlag: Int?        //
    var isYhd: Int?             //
    var shortName: String?      //
    var venderUse: Int?         //
    var yaoUse: Int?            //
    
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>...<Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) -> RCSendCompanyModel {
        let json = JSON(json)

        let model = RCSendCompanyModel()
        model.carrierCode = json["carrierCode"].stringValue
        model.carrierId = json["carrierId"].stringValue
        model.carrierName = json["carrierName"].stringValue
        model.carrierURL = json["carrierURL"].stringValue
        model.enableFlag = json["enableFlag"].intValue
        model.isYhd = json["isYhd"].intValue
        model.shortName = json["shortName"].stringValue
        model.venderUse = json["venderUse"].intValue
        model.yaoUse = json["yaoUse"].intValue
        return model
    }
}
