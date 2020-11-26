//
//  FKYRetrieveOneModel.swift
//  FKY
//
//  Created by hui on 2019/8/20.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class FKYRetrieveOneModel: NSObject,JSONAbleType {
    var enterpriseId: String?    //企业id
    var mobile: String?      //企业名称
    var userNames: [String]?      //企业名称
    
    // <Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYRetrieveOneModel {
        let json = JSON(json)
        let model = FKYRetrieveOneModel()
        model.enterpriseId = json["enterpriseId"].stringValue
        model.mobile = json["mobile"].stringValue
        if let strArr = json["userNames"].arrayObject as? [String] {
            model.userNames = strArr
        }
        return model
    }
}
