//
//  FKYMyRebateModel.swift
//  FKY
//
//  Created by My on 2019/8/22.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import Foundation
import SwiftyJSON

final class FKYMyRebateModel: NSObject, JSONAbleType {
    var availableRebate: Double? //可用余额
    var pendingRebate: Double? //待到账余额
    var totalRebate: Double? //累计余额
    var drugWelfareFlag : Int? //1表示打开，0表示关闭
    
    // <Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYMyRebateModel {
        let json = JSON(json)
        let model =  FKYMyRebateModel()
        
        model.availableRebate = json["availableRebate"].doubleValue
        model.pendingRebate = json["pendingRebate"].doubleValue
        model.totalRebate = json["totalRebate"].doubleValue
        model.drugWelfareFlag = json["drugWelfareFlag"].intValue
        return model
    }
}
