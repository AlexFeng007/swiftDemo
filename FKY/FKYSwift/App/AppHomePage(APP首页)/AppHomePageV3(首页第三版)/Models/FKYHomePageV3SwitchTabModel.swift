//
//  FKYHomePageV3SwitchTabModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

/*
 countDownFlag    Null    null
 createTime    String
 createUser    String
 downTime    String
 downTimeMillis    Null    null
 enterpriseTypeList    String
 floorColor    Integer    0
 floorProductDtos    Null    null
 floorStyle    Integer    0
 holdTime    String
 hotsaleFlag    Integer    1
 iconImgDTOList    Null    null
 iconImgPath    String
 id    Integer    904639
 imgPath    String
 indexFloor    String
 indexMobileId    Null    null
 jumpExpandOne    String
 jumpExpandThree    String
 jumpExpandTwo    String
 jumpInfo    String    一口价集合
 jumpInfoMore    String
 jumpType    Integer    31
 name    String    一口价药城
 newOrder    Integer    0
 newToolFlag    Null    null
 oftenBuyFlag    Integer    1
 oftenViewFlag    Integer    1
 originalPriceFlag    Null    null
 posIndex    Null    null
 promotionId    Null    null
 segment    Integer    3
 showNum    String    1
 showSequence    Null    null
 siteCode    String    000000
 skipFlag    String
 sysTimeMillis    Null    null
 title    String    科技赋能
 togetherMark    Null    null
 type    Integer    46
 upTime    String
 upTimeMillis    Null    null
 url    String

 */

import HandyJSON
import UIKit

class FKYHomePageV3SwitchTabModel: NSObject, HandyJSON {
    override required init() { }

    /// 不知道什么意思或代表什么或用到哪里 所有可选类型都是未知的数据类型，如果后期开发中，明确字段用法，请务必赋默认值
    var countDownFlag: AnyObject?
    var createTime: String = ""
    var createUser: String = ""
    var downTime: String = ""
    var downTimeMillis: AnyObject?
    var enterpriseTypeList: String = ""
    var floorColor: Int = -199
    var floorProductDtos: AnyObject?
    var floorStyle: Int = -199
    var holdTime: String = ""
    var hotsaleFlag: Int = -199
    var iconImgDTOList: AnyObject?
    var iconImgPath: String = ""
    var id: Int = -199
    var imgPath: String = ""
    var indexFloor: String = ""
    var indexMobileId: AnyObject?
    var jumpExpandOne: String = ""
    var jumpExpandThree: String = ""
    var jumpExpandTwo: String = ""
    var jumpInfo: String = ""
    var jumpInfoMore: String = ""
    var jumpType: String = ""
    var name: String = ""
    var newOrder: Int?
    var newToolFlag: AnyObject?
    var oftenBuyFlag: Int?
    var oftenViewFlag: Int?
    var originalPriceFlag: AnyObject?
    var posIndex: AnyObject?
    var promotionId: AnyObject?
    var segment: Int?
    var showNum: String = ""
    var showSequence: AnyObject?
    var siteCode: String?
    var skipFlag: String?
    var sysTimeMillis: AnyObject?
    var title: String = ""
    var togetherMark: Any?
    var type: Int?
    var upTime: String = ""
    var upTimeMillis: AnyObject?
    var url: String = ""
    
    // ------------------------------------自用属性，非后台返回------------------------------------
    var isSelected:Bool = false
    
}
