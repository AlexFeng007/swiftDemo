//
//  FKYRebateSellerTypeModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/2/25.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class FKYRebateSellerTypeModel: NSObject,JSONAbleType {
    /// 自营商家列表
    var sellerList = [FKYRebteSellerModel]()
    /// 可用金额总数
    var rebateAmount = 0.0
    /// 商家ID 非自营商家这里有值 自营商家取上方的sellerList
    var sellerId = ""
    /// 商家名称
    var sellerName = ""
    /// 是否展开
    var isUnfold = false
    /// 是否是平台返利 0-非平台返利 1-平台返利,
    var platformRebateType = ""
    /// 是否是自营商家通用 0-非自营通用 1-自营通用
    var ziyingCommonUse = ""
    /// 下方文描 非接口返回字段 是view中要用到的字段
    var subTitleText = ""
    /// 当前cell所展示的商家类型 1 自营商家通用 2平台商家通用 3单商家 默认3
    var cellType = "3"
    
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYRebateSellerTypeModel {
        let json = JSON(json)
        let model = FKYRebateSellerTypeModel()
        model.rebateAmount = json["rebateAmount"].doubleValue
        model.sellerId = json["sellerId"].stringValue
        model.sellerName = json["sellerName"].stringValue
        model.platformRebateType = json["platformRebateType"].stringValue
        model.ziyingCommonUse = json["ziyingCommonUse"].stringValue
        return model
    }
}
