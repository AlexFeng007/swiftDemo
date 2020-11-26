//
//  FKYHomePageV3ItemModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/22.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  每个楼层中的豆腐块model

import UIKit
import HandyJSON
class FKYHomePageV3ItemModel: NSObject,HandyJSON {
    override required init() {}
    /// 套餐企业ID
    var dinnerEnterpriseId:String = ""
    /// 类型
    var floorStyle:Int = -199
    /// 豆腐块名称
    var name:String = ""
    /// 搭配套餐 固定套餐的套餐列表
    var dinnerVOList:[FKYHomePageV3PackageModel] = [FKYHomePageV3PackageModel]()
    /// 当前豆腐块包含的商品
    var floorProductDtos:[FKYHomePageV3FloorProductModel] = [FKYHomePageV3FloorProductModel]()
    /// 倒计时到期时间 时间戳单位毫秒
    var downTimeMillis:Int = 0
    
    /// 中通广告list
    var iconImgDTOList:[FKYHomePageV3AdModel] = [FKYHomePageV3AdModel]()
    
    /// 不知道代表什么有什么用
    var countDownFlag:String = ""
    var createTime:String = ""
    var createUser:String = ""
    var downTime:String = ""
    
    var enterpriseTypeList:String = ""
    var floorColor:String = ""
    var holdTime:String = ""
    var iconImgPath:String = ""
    var id:String = ""
    var imgPath:String = ""
    var indexFloor:String = ""
    var indexMobileId:Int = -199
    var jumpExpandOne:String = ""
    var jumpExpandThree:String = ""
    var jumpExpandTwo:String = ""
    var jumpInfo:String = ""
    var jumpInfoMore:String = ""
    var jumpType:Int = -199
    var originalPriceFlag:String = ""
    var posIndex:Int = -199
    var promotionId:String = ""
    var showNum:String = ""
    var showSequence:Int = -199
    var siteCode:String = ""
    var skipFlag:String = ""
    var sysTimeMillis:String = ""
    var title:String = ""
    var togetherMark:Int = -199
    var type:Int = -199
    var upTime:String = ""
    var upTimeMillis:String = ""
    var url:String = ""
    var hotsaleFlag:Int = -199
    var newOrder:Int = -199
    var newToolFlag:Any?
    var oftenBuyFlag:Int = -199
    var oftenViewFlag:Int = -199
    var segment:Int = -199
    
    // 自用属性-------
    
    /// 是否已经上报BI埋点
    var isUPloadBI:Bool = false
    
}
