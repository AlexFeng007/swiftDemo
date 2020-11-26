//
//  FKYRuleModel.swift
//  FKY
//
//  Created by 路海涛 on 2017/4/26.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

class FKYRuleModel: NSObject {
    var downValue : Double?
    var ruleValue : Double?
    var upValue : Double?

    func initWithDic(_ dic:NSDictionary) -> () {
        self.downValue = (dic["downValue"] as AnyObject).doubleValue
        self.ruleValue = (dic["ruleValue"] as AnyObject).doubleValue
        self.upValue = (dic["upValue"] as AnyObject).doubleValue
    }
}

class FKYFreightRulesModel: FKYBaseModel{
    var supplyName : String?
    var freightRule : String?
    
    func initWithModel(_ name:String,_ rule:String) -> () {
        self.supplyName = name
        self.freightRule = rule
    }
}
class FKYNewAlertRuleModel: NSObject {
    var name : String?
    var rules : NSArray?
    
    func initWithDic(_ name:String,rules:NSArray) -> () {
        self.name = name
        self.rules = rules
    }
}

class FKYAlertRuleModel: NSObject {
    var name : String?
    var rules : [String] = [String]()

    func initWithDic(_ name:String,rules:[String]) -> () {
        self.name = name
        self.rules = rules
    }
}
