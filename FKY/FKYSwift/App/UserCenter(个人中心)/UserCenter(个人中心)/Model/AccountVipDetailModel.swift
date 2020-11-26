//
//  AccountVipDetailModel.swift
//  FKY
//
//  Created by 寒山 on 2020/6/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc final class AccountVipDetailModel: NSObject, JSONAbleType {
    var enterpriseId:Int?   // 客户id
    var memberLevel:String?      // 会员等级
    var levelName:String?      // 会员等级名称
    var vipSymbol:Int?    // 会员标识(0:非会员；1：会员 2:不显示会员)
    var roleTypeValue:Int? // 企业类型(1:非公立医疗机构 2:公立医疗机构 3:单体药店 4:连锁总店 5:个体诊所 6:生产企业 7:批发企业 8:连锁加盟店)
    var tips:String?            // 会员文描
    var gmvGap:String?          // 距离会员额度
    var url:String?          // 会员专区url
    
    @objc static func fromJSON(_ json: [String : AnyObject]) -> AccountVipDetailModel {
        let json = JSON(json)
        let model = AccountVipDetailModel()
        model.memberLevel = json["memberLevel"].stringValue
        model.levelName = json["levelName"].stringValue
        model.vipSymbol = json["vipSymbol"].intValue
        model.roleTypeValue = json["roleTypeValue"].intValue
        model.tips = json["tips"].stringValue
        model.enterpriseId = json["enterpriseId"].intValue
        model.gmvGap = json["gmvGap"].stringValue
        model.url = json["url"].stringValue
        return model
    }
}
