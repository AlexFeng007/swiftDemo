//
//  FKYDrawModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

//MARK: -----------------------------------------------------------------
//MARK: - 抽奖对象模型
class FKYDrawModel: NSObject,HandyJSON {
    /// 抽奖活动ID
    var drawId = ""
    
    /// 抽奖活动名称
    var drawName = ""
    
    /// 抽奖活动图片
    @objc var drawPic = ""
    
    /// 抽奖记录 是个对象
    @objc var orderDrawRecordDto:FKYPrizeHistoryModel = FKYPrizeHistoryModel()
    
    ///剩余抽奖次数
    var prizeCount = ""
    
    /// 后台动态配置的按钮文描
    var promotionButton = ""
    
    /// 后台动态配置的按钮的跳转连接(网页连接)
    var promotionLink = ""
    
    /// 活动规则的跳转连接
    var ruleLink = ""
    
    /// 奖品数组
    var prizeInfo:[FKYPrizeModel] = []
    
    required override init() {}
    
}


//MARK: -----------------------------------------------------------------
//MARK: - 奖品对象模型
class FKYPrizeModel: NSObject,HandyJSON {
    
    /// 奖品等级 几等奖
    var priseLevel = ""
    
    /// 奖品图片
    var prisePicture = ""
    
    /// 奖品名称 如：一等奖   、  电视机 等
    var showName = ""
    
    required override init() {}
}

//MARK: - 奖品对象模型
class FKYPrizeHistoryModel: NSObject,HandyJSON {
    
    /// 如果中的优惠券则此对象有值
    var couponDto:FKYDrawPrizeCouponModel = FKYDrawPrizeCouponModel()
    
    /// 中奖 描述 // description
    var resultDes = ""
    
    /// 抽奖ID
    var drawId = ""
    
    /// 抽奖时间
    var drawTime = ""
    
    /// 参与抽奖的订单
    var orderNo = ""
    
    /// 奖品名称
    var priseName = ""
    
    /// 奖品图片
    var prisePic = ""
    
    /// 奖品类型
    var priseType = 0
    
    /// 中的几等奖
    var prizeLevel = "-199"
    
    /// 抽奖活动的入口图
    @objc var drawPic = ""
    
    /// 活动规则的跳转链接
    var ruleLink = ""
    
    /// 促销活动按钮文描
    var promotionButton = ""
    
    /// 促销活动跳转链接
    var promotionLink = ""
    
    /// 活动名称
    var drawName = ""
    
    required override init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &resultDes, name: "description")
    }
}
