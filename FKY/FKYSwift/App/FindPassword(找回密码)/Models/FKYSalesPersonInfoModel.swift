//
//  FKYSalesPersonInfoModel.swift
//  FKY
//
//  Created by hui on 2019/8/21.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

//业务人员信息
final class FKYSalesPersonInfoModel: NSObject,JSONAbleType {
    var consumerHotline: String?    //客服电话
    var salesName: String?  //姓名
    var salesPhoneNumber: String? //电话
    
    // <Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYSalesPersonInfoModel {
        let json = JSON(json)
        let model = FKYSalesPersonInfoModel()
        model.consumerHotline = json["consumerHotline"].stringValue
        model.salesName = json["salesName"].stringValue
        model.salesPhoneNumber = json["salesPhoneNumber"].stringValue
        return model
    }
}
