//
//  FKYShoppingMoneyBalanceInfoModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYShoppingMoneyBalanceInfoModel: NSObject, HandyJSON {
    override required init() { }

    /// 余额
    var amount: Float = 0.0

    var createTime: String = ""

    var createUser: String = ""

    var enterpriseId: Int = -199

    var enterpriseName: String = ""

    var enterpriseType: String = ""

    var enterpriseTypeName: String = ""

    var firstChargeTime: String = ""

    var freezeAmount: Float = 0.0

    /// 不知道这个ID是干嘛的
    //var id:String = ""

    var lastChargeTime: String = ""

    var manualChargeAmount: Float = 0.0

    var manualReduceAmount: Float = 0.0

    var status: Int = -199

    var systemChargeAmount: Float = 0.0

    var updateTime: String = ""

    var updateUser: String = ""

    var usedAmount: String = ""
    
    /// 滚动提示文描
    var activityText:String = ""
}
