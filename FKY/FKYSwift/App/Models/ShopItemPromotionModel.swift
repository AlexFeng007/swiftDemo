//
//  ShopItemPromotionModel.swift
//  FKY
//
//  Created by 乔羽 on 2018/4/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ShopDetailPromotionModel: JSONAbleType {
    
    var promotionId : String? // 活动id
    var promotionMethod : Int? // 满减方式;0:减总金额;1:减每件金额(打折)
    var promotionType : Int? // 活动类型;1:特价活动;2:单品满减;3:多品满减;5:单品满赠；6:多品满赠送;7:单品满送积分;8:多品满送积分;9:单品换购;11:自定义单品活动; 12:自定义多品活动'
    var promotionPre : Int? // 活动条件;0:按金额;1:按件数
    var levelIncre : Int? // 层级递增 0,不是;1,是
    var promotionDesc: String? // 优惠描述
    var productPromotionRules: [PromotionRuleModel]? // 递增规则数组
    var limitNum: Int? // 每个用户可参加次数
    var type: Int = 2 // 1 特价活动；3 满赠活动；2 满减活动 4 套餐活动
    
    static func fromJSON(_ data: [String : AnyObject]) -> ShopDetailPromotionModel {
        var model = ShopDetailPromotionModel()
        let json = JSON(data)
        model.promotionId = json["promotionId"].stringValue
        model.promotionMethod = json["promotionMethod"].intValue
        model.promotionType = json["promotionType"].intValue
        model.promotionPre = json["promotionPre"].intValue
        model.levelIncre = json["levelIncre"].intValue
        model.promotionDesc = json["promotionDesc"].stringValue
        model.limitNum = json["limitNum"].intValue
        model.type = json["type"].intValue
        
        var productPromotionRules: [PromotionRuleModel]?
        if let j = json["productPromotionRules"].arrayObject {
            productPromotionRules = (j as NSArray).mapToObjectArray(PromotionRuleModel.self)
        }
        model.productPromotionRules = productPromotionRules
        
        return model
    }
}

final class ShopItemProductPromotionRules : NSObject, JSONAbleType {
    var promotionSum : Float?
    var promotionMinu : String?
    
   static func fromJSON(_ data: [String : AnyObject]) -> ShopItemProductPromotionRules {
        let model = ShopItemProductPromotionRules.init()
        let json = JSON(data)
        model.promotionSum = json["promotion_sum"].floatValue
        model.promotionMinu = json["promotion_minu"].stringValue
        return model
    }
    
}
extension ShopItemProductPromotionRules :NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(promotionSum, forKey: "promotionSum")
        aCoder.encode(promotionMinu, forKey: "promotionMinu")
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        self.init()
        promotionSum = aDecoder.decodeObject(forKey: "promotionSum") as? Float
        promotionMinu = aDecoder.decodeObject(forKey: "promotionMinu") as? String
    }
}

final class ShopItemPromotionModel: NSObject, JSONAbleType {
//    var limitNum : Int? 没用到，暂时注释掉，新接口也没有返回该字段
    var promotionId : String?
    var levelIncre : Int?
    var promotionMethod : Int?
    var promotionPre : Int?
    var promotionType : Int?
    var productPromotionRules: [ShopItemProductPromotionRules]?
    var promotionDescription: String {
        get {
            return self.generatePromotionDescription()
        }
    }
    
    @objc var stringPromotionType: String = ""
    
    static func fromJSON(_ data: [String : AnyObject]) -> ShopItemPromotionModel {
        let model = ShopItemPromotionModel.init()
        let json = JSON(data)
        // model.limitNum = Int(json["limit_num"].stringValue)
        model.promotionId = json["promotion_id"].stringValue
        model.levelIncre = Int(json["level_incre"].stringValue)
        model.promotionMethod = Int(json["promotion_method"].stringValue)
        model.promotionPre = Int(json["promotion_pre"].stringValue)
        model.promotionType = Int(json["promotion_type"].stringValue)
        if let promotionType = model.promotionType {
            model.stringPromotionType = "\(promotionType)"
        }
        
        var productPromotionRules: [ShopItemProductPromotionRules]?
        if let j = json["productPromotionRules"].arrayObject {
            productPromotionRules = (j as NSArray).mapToObjectArray(ShopItemProductPromotionRules.self)
        }
        model.productPromotionRules = productPromotionRules
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

extension ShopItemPromotionModel : NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(promotionId, forKey: "promotionId")
        aCoder.encode(levelIncre, forKey: "levelIncre")
        aCoder.encode(promotionMethod, forKey: "promotionMethod")
        aCoder.encode(promotionPre, forKey: "promotionPre")
        aCoder.encode(promotionType, forKey: "promotionType")
        aCoder.encode(productPromotionRules, forKey: "productPromotionRules")
        aCoder.encode(stringPromotionType, forKey: "stringPromotionType")
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        self.init()
        promotionId = aDecoder.decodeObject(forKey: "promotionId") as? String
        levelIncre = aDecoder.decodeObject(forKey: "levelIncre") as? Int
        promotionMethod = aDecoder.decodeObject(forKey: "promotionMethod") as? Int
        promotionPre = aDecoder.decodeObject(forKey: "promotionPre") as? Int
        promotionType = aDecoder.decodeObject(forKey: "promotionType") as? Int
        productPromotionRules = aDecoder.decodeObject(forKey: "productPromotionRules") as? [ShopItemProductPromotionRules]
        if
            let promotionType = aDecoder.decodeObject(forKey: "stringPromotionType") as? String {
            stringPromotionType = promotionType
        }
        
    }
}
