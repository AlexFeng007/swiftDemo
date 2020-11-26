//
//  FKYDrawResultModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/24.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON
class FKYDrawResultModel: NSObject, HandyJSON {
    required override init() {}
    
    /// 中奖的优惠券对象
    var couponDto:FKYDrawPrizeCouponModel = FKYDrawPrizeCouponModel()
    
    /// 中奖描述
    var resultDes = ""
    
    /// 是否中奖
    var drawResult:Bool = false
    
    /// 中了几等奖  1-6为中奖  如果小于0 toast显示 resultDes字段 0未中奖
    var priseLevel = "-199"
    
    ///奖品类型 1实物 2返利金 3优惠券 4店铺券
    var priseType = 0
    
    /// ---------------------------本地字段---------------------------
    
    /// 是否可以转动动画 防止cell刷新时候 会再次转动3
    var isCanTurn = true
    
    /// 中奖后指针停止的位置
    var stopIndex = 0
    
    /// 从中奖历史model赋值的字段--------------------------------
    
    /// 抽奖ID
    var drawId = ""
    
    /// 抽奖时间
    var drawTime = ""
    
    /// 抽奖订单号
    var orderNo = ""
    
    /// 中奖图片
    var prisePic = ""
    
    /// 奖品名称
    var priseName = ""
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &resultDes, name: "description")
    }
}
