//
//  FKYHomePageV3BackImageModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/30.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYHomePageV3BackImageModel: NSObject,HandyJSON {
    required override init() {    }
    
    /// 不知道什么意思或代表什么或用到哪里 所有可选类型都是未知的数据类型，如果后期开发中，明确字段用法，请务必赋默认值
    var holdTime:String = ""
    var segment:Int = -199
    var type:Int = -199
    var id:Int = -199
    var hotsaleFlag:Int = -199
    var showNum:String = ""
    var imgPath:String = ""
    var name:String = ""
    var oftenViewFlag:Int = -199
    var floorStyle:Int = -199
    var enterpriseTypeList:String = ""
    var siteCode:String = ""
    var downTime:String = ""
    var oftenBuyFlag:Int = -199
    var newOrder:Int = -199
    var jumpInfoMore:String = ""
    var upTime:String = ""
    var floorColor:Int = -199
    var iconImgPath:String = ""
}
