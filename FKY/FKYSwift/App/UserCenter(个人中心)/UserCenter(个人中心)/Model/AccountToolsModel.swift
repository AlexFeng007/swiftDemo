//
//  AccountToolsModel.swift
//  FKY
//
//  Created by 寒山 on 2020/6/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class AccountToolsModel: NSObject,JSONAbleType{
    var imgPath:String? // 工具图标地址
    var title:String?  // 工具名称
    var toolId:String?  // 工具唯一编号
    var jumpInfo:String?   // 跳转页面url
    var newToolFlag:Int?
    // 是否新增 <1：新增；0：原有 新增的显示new角标>
    ///**
    // 资质过期提示
    // */
    var qualificationExpiredDesc:String?
    
    static func fromJSON(_ json: [String : AnyObject]) -> AccountToolsModel {
        let json = JSON(json)
        let model = AccountToolsModel()
        model.imgPath = json["imgPath"].stringValue
        model.title = json["title"].stringValue
        model.toolId = json["id"].stringValue
        model.jumpInfo = json["jumpInfo"].stringValue
        model.qualificationExpiredDesc = json["qualificationExpiredDesc"].stringValue
        model.newToolFlag = json["newToolFlag"].intValue
        return model
    }
}
