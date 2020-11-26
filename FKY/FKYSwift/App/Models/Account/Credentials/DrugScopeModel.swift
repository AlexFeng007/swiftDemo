//
//  DrugScopeModel.swift
//  FKY
//
//  Created by yangyouyong on 2016/11/29.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  （企业）经营范围model

import UIKit
import SwiftyJSON

@objcMembers
final class DrugScopeModel: NSObject , JSONAbleType, ReverseJSONType {
    
    let drugScopeId: String
    let drugScopeName: String
    var selected: Bool = false
    
    init(drugScopeId: String ,drugScopeName: String) {
        self.drugScopeId = drugScopeId
        self.drugScopeName = drugScopeName
    }
    
    //MARK: For NSKeyedArchiver aDecoder
    init(drugScopeId: String ,drugScopeName: String, selected: Bool) {
        self.drugScopeId = drugScopeId
        self.drugScopeName = drugScopeName
        self.selected = selected
    }
    
    // <Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) -> DrugScopeModel {
        let j = JSON(json)
        let drugScopeId = j["drugScopeId"].stringValue
        let drugScopeName = j["drugScopeName"].stringValue
        return DrugScopeModel(drugScopeId: drugScopeId, drugScopeName: drugScopeName)
    }
    
    func reverseJSON() -> [String : AnyObject] {
        return ["drugScopeId": self.drugScopeId as AnyObject,
                "drugScopeName": self.drugScopeName as AnyObject]
    }
}

