//
//  FKYRechargeActivityInfoModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYRechargeActivityInfoModel: NSObject, HandyJSON {
    required override init() { }

    /// 下方活动文描
    var desc: String = ""

    /// 金额
    var threshold: Float = 0

    /// ID
    var thresholdId: String = ""
    
    /// 1表示 只送券 2 表示送券和会员 3 表示啥都不送 0初始状态
    var type:Int = 0

}
