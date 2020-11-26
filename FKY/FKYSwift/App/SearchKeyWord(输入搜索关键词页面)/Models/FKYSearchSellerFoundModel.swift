//
//  FKYSearchSellerFoundModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/9/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYSearchSellerFoundModel: NSObject ,HandyJSON{
    required override init() {}
    /// 店铺ID
    var supply_id:String = ""
    /// 购买次数
    var count:String = ""
    /// 店铺名称
    var supply_name:String = ""
    
}
