//
//  FKYBankModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/9.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class FKYBankModel: NSObject,JSONAbleType {
    
    /// 银行ID
    var id = ""
    ///银行名称
    var name = ""
    
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYBankModel {
        let json = JSON(json)
        let model = FKYBankModel()
        model.id = json["id"].stringValue
        model.name = json["name"].stringValue
        return model
    }
}
