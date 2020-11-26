//
//  FKYHomePageV3SinglePackageModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/9.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  单品包邮model

import UIKit
import HandyJSON

class FKYHomePageV3SinglePackageModel: NSObject,HandyJSON {
    override required init() {    }
    var beginTime : Int64 = -199
    var endTime : Int64 = -199
    var singlePackageId : Int = -199
    var singlePackagConsumedNum : Int = -199
    var singlePackageBaseNum : Int = -199
    var singlePackageInventoryLeft : Int = -199
    var singlePackageLimitNum : Int = -199
    var singlePackagePrice : Double = -199.0
    var singlePackageSurplusNum : Int = -199
    var systemTime : Int64 = -199
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &singlePackageId, name: "id")
    }
}
