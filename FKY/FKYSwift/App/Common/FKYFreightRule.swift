//
//  FKYFreightRule.swift
//  FKY
//
//  Created by 路海涛 on 2017/4/26.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


// 运费模版计算模块
class FKYFreightRule: NSObject {
    fileprivate var ruleList: [FKYRuleModel] = [FKYRuleModel]()
    
    fileprivate func initWithList(_ list:[NSDictionary]) -> () {
        self.ruleList.removeAll()
        for dics:NSDictionary in list {
            let model = FKYRuleModel()
            model.initWithDic(dics)
            self.ruleList.append(model)
        }
    }

    fileprivate func AttributeString(_ freight:Double,maxFreight:Double) -> (NSMutableAttributedString) {
        let freightTmpl = NSMutableAttributedString()
        var freightStr = NSAttributedString(string:"运费:")
        freightTmpl.append(freightStr)
        freightTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: RGBColor(0x666666),
                                 range: NSMakeRange(0, freightTmpl.length))
        freightStr = NSAttributedString(string:String(format: "%.2f元",freight))
        freightTmpl.append(freightStr)
        freightTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: UIColor.red,
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        freightStr = NSAttributedString(string:",自营商品满")
        freightTmpl.append(freightStr)
        freightTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: RGBColor(0x666666),
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        freightStr = NSAttributedString(string:String(format: "%.2f元",maxFreight))
        freightTmpl.append(freightStr)
        freightTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: UIColor.red,
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        freightStr = NSAttributedString(string:"免邮")
        freightTmpl.append(freightStr)
        freightTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: RGBColor(0x666666),
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        return freightTmpl
    }
    // 送至：（用户注册地址所在省） 满xxx.xx元包邮，不满收xx.xx元运费，还差xxx.xx元
    //运费：30，满500.00包邮，还差123.45
    fileprivate func AttributeStringCommonSales(_ freight:Double,maxFreight:Double,needBuyNum:Double) -> (NSMutableAttributedString) {
        let freightTmpl = NSMutableAttributedString()
        
        var freightStr = NSAttributedString(string:"运费")
        freightTmpl.append(freightStr)
        freightTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: RGBColor(0xE8772A),
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        
        print(self .stringDisposeWithFloat(freight))
        freightStr = NSAttributedString(string:String(format: "¥%.2f", freight))
        freightTmpl.append(freightStr)
        freightTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: RGBColor(0xE8772A),
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        freightTmpl.addAttribute(NSAttributedString.Key.font,
                                 value: FKYBoldSystemFont(WH(12)),
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        
        freightStr = NSAttributedString(string:"，满")
        freightTmpl.append(freightStr)
        freightTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: RGBColor(0xE8772A),
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        
        freightStr = NSAttributedString(string:String(format: "¥%.2f",maxFreight))
        freightTmpl.append(freightStr)
        freightTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: RGBColor(0xE8772A),
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        freightTmpl.addAttribute(NSAttributedString.Key.font,
                                 value: FKYBoldSystemFont(WH(12)),
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        
        freightStr = NSAttributedString(string:"包邮，还差")
        freightTmpl.append(freightStr)
        freightTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: RGBColor(0xE8772A),
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        
       
        freightStr = NSAttributedString(string:String(format: "¥%.2f",needBuyNum))
        freightTmpl.append(freightStr)
        freightTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: RGBColor(0xE8772A),
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        freightTmpl.addAttribute(NSAttributedString.Key.font,
                                 value: FKYBoldSystemFont(WH(12)),
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        return freightTmpl
    }

    // 根据当前价格计算是否免邮
    func isFreeFreight(_ price:Double,list:[NSDictionary]) -> (Bool) {
        self.initWithList(list)
        if self.ruleList.count > 0  {
            let maxModel : FKYRuleModel = self.ruleList.last! as FKYRuleModel
            let maxFreight = maxModel.upValue
            if price >= maxFreight {
                return true
            }
        }
        return false
    }

    //去除尾数的0
    func stringDisposeWithFloat(_ floatValue:Double) -> String {
        var floatStr:String = String(format: "%.2f",floatValue)
        var len = floatStr.count
        while len > 0 {
            if floatStr .hasSuffix("0"){
                floatStr = floatStr.substring(to: floatStr.index(floatStr.startIndex, offsetBy: (floatStr.count - 1)))
            }else{
                break
            }
            len = len - 1
        }
        if floatStr .hasSuffix("."){
            floatStr = floatStr.substring(to: floatStr.index(floatStr.startIndex, offsetBy: (floatStr.count - 1)))
        }
        return floatStr
        
    }

    // 根据当前价格情况获取满足的包邮规则
    func getCurrentRule(_ freight:String,list:[NSDictionary]) -> (NSMutableAttributedString) {
        self.initWithList(list)
        if self.ruleList.count > 0{
            //            获取最大运费
            let maxModel : FKYRuleModel = self.ruleList.last! as FKYRuleModel
            let maxFreight = maxModel.upValue
            if freight.isEmpty {
                return self.AttributeString(0, maxFreight: maxFreight!)
            }else{
                return self.AttributeString(Double(freight)!, maxFreight: maxFreight!)
            }
            //            循环获取用户当前满足运费规则
//            for model:FKYRuleModel in self.ruleList {
//                if price == model.downValue && price == model.upValue {
//                    return self.AttributeString(0, maxFreight: maxFreight!)
//                }
//                if price >= model.downValue && price < model.upValue {
//                    return self.AttributeString(model.ruleValue!, maxFreight: maxFreight!)
//                }
//            }
        }
        return self.AttributeString(0, maxFreight: 0)
    }
    
    // 普通商家 根据当前价格情况获取满足的包邮规则
    @objc func getCurrentRuleForCommonSales(_ freight:String,freeFreight:Double,needBuyNum:Double) -> (NSMutableAttributedString) {
        let maxFreight = freeFreight
        if freight.isEmpty {
            return self.AttributeStringCommonSales(0, maxFreight: maxFreight,needBuyNum: needBuyNum)
        }else{
            return self.AttributeStringCommonSales(Double(freight)!, maxFreight: maxFreight,needBuyNum: needBuyNum)
        }
    }

    // 根据包邮规则返回文描信息
    @objc func freightRules(_ index:NSInteger,price:NSDictionary) -> (String) {
        let model = FKYRuleModel()
        model.initWithDic(price)
        if model.downValue == model.upValue {
            return "\(index+1)"
                + "、订单金额满"
                + String(format: "%.2f",model.downValue!)
                + "元，包邮。"
        }else{
            return "\(index+1)" + "、订单金额"
                + String(format: "%.2f",model.downValue!)
                + "—" + String(format: "%.2f",model.upValue!)
                + "元（不包含" + String(format: "%.2f",model.upValue!)
                + "元），运费" + String(format: "%.2f",model.ruleValue!)
                + "元；"
        }
    }

    // 拼装字符串
    func AttributeFreightString(_ freight:CGFloat) -> (NSMutableAttributedString) {
        let freightTmpl = NSMutableAttributedString()
        var freightStr = NSAttributedString(string:"运费: ")
        freightTmpl.append(freightStr)
        freightTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: RGBColor(0x666666),
                                 range: NSMakeRange(0, freightTmpl.length))
        freightStr = NSAttributedString(string:String(format: "¥ %.2f",freight))
        freightTmpl.append(freightStr)
        freightTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: UIColor.red,
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        return freightTmpl
    }

}
