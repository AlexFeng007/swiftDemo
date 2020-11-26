//
//  FKYAssCompanyModel.swift
//  FKY
//
//  Created by hui on 2019/8/20.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

//MARK:修改密码时，联想企业模型
final class FKYAssCompanyModel: NSObject,JSONAbleType {
    var enterpriseId: Int?    //企业id
    var enterpriseName: String?      //企业名称
    
    // <Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYAssCompanyModel {
        let json = JSON(json)
        let model = FKYAssCompanyModel()
        model.enterpriseId = json["enterpriseId"].intValue
        model.enterpriseName = json["enterpriseName"].stringValue
        return model
    }
}
