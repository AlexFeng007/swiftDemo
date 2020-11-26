//
//  PromotionModel.swift
//  FKY
//
//  Created by yangyouyong on 2017/1/9.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

@objcMembers
final class PromotionModel: NSObject, JSONAbleType,HandyJSON {
    required override init() {}
    var limitNum : NSInteger?
    var promotionId : String?
    var promotionPrice : Float?
    var levelIncre : NSInteger?
    var promotionMethod : NSInteger?
    var promotionPre : NSInteger?
    var promotionType : NSInteger?
    var productPromotionRules: [PromotionRuleModel]?
    var promotionDesc : String?
    var promotionDescription: String {
        get {
            return self.generatePromotionDescription()
        }
    }
    
    @objc var stringPromotionType: String {
        get {
            if let promotionType = self.promotionType {
                return "\(promotionType)"
            }else {
                return ""
            }
        }
    }
    static func fromJSON(_ json: [String : AnyObject]) -> PromotionModel {
        let json = JSON(json)
        let model = PromotionModel()
        model.limitNum = json["limitNum"].intValue
        model.promotionId = json["promotionId"].stringValue
        model.promotionDesc = json["promotionDesc"].stringValue
        model.promotionPrice = json["promotionPrice"].floatValue
        model.levelIncre = json["levelIncre"].intValue
        model.promotionMethod = json["promotionMethod"].intValue
        model.promotionPre = json["promotionPre"].intValue
        model.promotionType = json["promotionType"].intValue
        
        if let j = json["productPromotionRules"].arrayObject {
            model.productPromotionRules = (j as NSArray).mapToObjectArray(PromotionRuleModel.self)
        }
        
        return model
    }
    
    func generatePromotionDescription() -> String {
            
            var promotionDes = ""
            if self.promotionType == nil {
                return promotionDes
            }
            if (self.promotionType! == 2 || self.promotionType! == 3) {
                if self.productPromotionRules == nil || self.productPromotionRules!.count <= 0 {
                    return promotionDes
                }
                
                self.productPromotionRules?.forEach({ (object) in
                    if (self.promotionPre != nil) {
                        if self.promotionPre! == 0 {
                            promotionDes = promotionDes + "满\(object.promotionSum!)元"
                        }else{
                            promotionDes = promotionDes + "满\(object.promotionSum!)件"
                        }
                    }
                    if (self.promotionMethod != nil) {
                        if self.promotionMethod! == 0 {
                            promotionDes = promotionDes + "减\(object.promotionMinu!)元;"
                        }else if self.promotionMethod! == 1 {
                            promotionDes = promotionDes + "打\(object.promotionMinu!)折;"
                        }else if self.promotionMethod! == 2 {
                            promotionDes = promotionDes + "每个减\(object.promotionMinu!)元;"
                        }
                    }
                    promotionDes = promotionDes + " "
                })
            }else if (self.promotionType! == 5 || self.promotionType! == 6) {
                self.productPromotionRules?.forEach({ (object) in
                    if (self.promotionPre != nil) {
                        if self.promotionPre! == 0 {
                            promotionDes = promotionDes + "满\(object.promotionSum!)元"
                        }else{
                            promotionDes = promotionDes + "满\(object.promotionSum!)件"
                        }
                    }
                    promotionDes = promotionDes + "送\(object.promotionMinu!);"
                    promotionDes = promotionDes + " "
                })
            }else if (self.promotionType! == 7 || self.promotionType! == 8) {
                self.productPromotionRules?.forEach({ (object) in
                    if (self.promotionPre != nil) {
                        if self.promotionPre! == 0 {
                            promotionDes = promotionDes + "满\(object.promotionSum!)元"
                        }else{
                            promotionDes = promotionDes + "满\(object.promotionSum!)件"
                        }
                    }
                    if (self.promotionMethod != nil) {
                        if self.promotionMethod! == 0 {
                            promotionDes = promotionDes + "送\(object.promotionMinu!)积分;"
                        }else {
                            promotionDes = promotionDes + "每件送\(object.promotionMinu!)积分;"
                        }
                    }
                    promotionDes = promotionDes + " "
                })
            }else{
                if let rules = self.productPromotionRules, rules.count > 0 {
                    return (rules.first?.promotionMinu)!
                }
            }
            return promotionDes
    }
    
    /* 暂时没用到
    func generateToastMessage(_ count: NSInteger, totalPrice: Float) -> String? {
        var promotionDes = ""
        if self.promotionType == nil {
            return promotionDes
        }
        if (self.promotionType! == 2 || self.promotionType! == 3) {
            if self.productPromotionRules == nil || self.productPromotionRules!.count <= 0 {
                return nil
            }
            let object = self.productPromotionRules!.first!
            
            if (self.promotionPre != nil) {
                if self.promotionPre! == 0 {
                    if totalPrice < object.promotionSum! {
                        promotionDes = "您已购买\(totalPrice), 还差\(object.promotionSum! - totalPrice)就可立"
                    }else{
                        return nil
                    }
                    promotionDes = promotionDes + "满\(object.promotionSum!)元"
                }else{
                    promotionDes = promotionDes + "满\(object.promotionSum!)件"
                    if count < NSInteger(object.promotionSum!) {
                        promotionDes = "您已购买\(totalPrice), 还差\(NSInteger(object.promotionSum!) - count)就可立"
                    }else{
                        return nil
                    }
                }
            }
            if (self.promotionMethod != nil) {
                if self.promotionMethod! == 0 {
                    promotionDes = promotionDes + ",减\(object.promotionMinu!)元"
                }else if self.promotionMethod! == 1 {
                    promotionDes = promotionDes + ",打\(object.promotionMinu!)折"
                }else if self.promotionMethod! == 2 {
                    promotionDes = promotionDes + ",每个减\(object.promotionMinu!)元"
                }
            }
            return promotionDes
        }
        
        if (self.promotionType! == 5 || self.promotionType! == 6) {
            if self.productPromotionRules == nil || self.productPromotionRules!.count <= 0 {
                return nil
            }else{
                let object = self.productPromotionRules!.first!
                if totalPrice < object.promotionSum! {
                    promotionDes = "您已购买\(totalPrice), 凑够\(object.promotionSum!)元就可以赠送\(object.promotionMinu!)"
                }else{
                    if let promotionSum = object.promotionSum, let promotionMinu = object.promotionMinu {
                        promotionDes = "您已购买\(promotionSum), 可赠送\(promotionMinu)"
                    }
                }
            }
            
            return promotionDes
        }
        
        if (self.promotionType! == 7 || self.promotionType! == 8) {
            if self.productPromotionRules == nil || self.productPromotionRules!.count <= 0 {
                return nil
            }else{
                let object = self.productPromotionRules!.first!
                if totalPrice < object.promotionSum! {
                    promotionDes = "您已购买\(totalPrice), 凑够\(object.promotionSum!)元就可以赠送\(object.promotionMinu!)积分"
                }else{
                    promotionDes = "您已购买\(totalPrice), 可赠送\(object.promotionMinu!)积分"
                }
            }
            return promotionDes
        }
        
        return nil
    }
    */
}
