//
//  FKYStandardProductModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/3/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc final class FKYStandardProductModel: NSObject,JSONAbleType {
    /// 国药准字
    var approval = ""
    /// 条形码
    var barcode = ""
    /// 标品图片
    var imgUrl = ""
    /// 生产企业
    var manufacturer = ""
    /// 标品主码id
    var masterId = 0
    /// 商品名
    var productName = ""
    /// 规格
    var spec = ""
    
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYStandardProductModel {
        let json = JSON(json)
        let model = FKYStandardProductModel()
        model.approval = json["approval"].stringValue
        model.barcode = json["barcode"].stringValue
        model.imgUrl = json["imgUrl"].stringValue
        model.manufacturer = json["manufacturer"].stringValue
        model.productName = json["productName"].stringValue
        model.spec = json["spec"].stringValue
        model.masterId = json["masterId"].intValue
        return model
    }
    
}
