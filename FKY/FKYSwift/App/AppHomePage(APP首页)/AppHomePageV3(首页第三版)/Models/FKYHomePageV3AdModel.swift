//
//  FKYHomePageV3AdModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/11.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYHomePageV3AdModel: NSObject ,HandyJSON{
    override required init() {    }
    var imgName:String = ""
    var imgPath:String = ""
    var jumpInfo:String = ""
    var jumpType:String = ""
    var name:String = ""
    var title:String = ""
}

/*
 imgName    String    高毛专区
 imgPath    String    http://p8.maiyaole.com/fky/img/print/sy2/1605002306975.jpg
 jumpInfo    String    fky://shop/shopLabel?labelId=16
 jumpType    String
 name    String
 title    String
 */
