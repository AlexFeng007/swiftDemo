//
//  FKYHomePageV3ProductTagModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON
class FKYHomePageV3ProductTagModel: NSObject ,HandyJSON{

    required override init() {    }
    var bonusTag : Bool = false
    var bounty : Bool = false
    var diJia : Bool = false
    var fullDiscount : Bool = false
    var fullGift : Bool = false
    var fullScale : Bool = false
    var holdPrice : Bool = false
    var liveStreamingFlag : Bool = false
    var packages : Bool = false
    var purchaseLimit : Bool = false
    var rebate : Bool = false
    var slowPay : Bool = false
    var specialOffer : Bool = false
    var ticket : Bool = false

}
