//
//  ProductPromotionInfo.swift
//  FKY
//
//  Created by airWen on 2017/5/8.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

@objc final class ProductPromotionInfo: NSObject, JSONAbleType,HandyJSON {
    required override init() {}
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &beginTime, name: "begin_time")
        mapper.specify(property: &createTime, name: "create_time")
        mapper.specify(property: &endTime, name: "end_time")
        mapper.specify(property: &enterpriseId, name: "enterprise_id")
        mapper.specify(property: &groupCodes, name: "group_codes")
        mapper.specify(property: &Id, name: "id")
        mapper.specify(property: &levelIncre, name: "level_incre")
        mapper.specify(property: &limitNum, name: "limit_num")
        mapper.specify(property: &productCode, name: "product_code")
        mapper.specify(property: &promotionId, name: "promotion_id")
        mapper.specify(property: &promotionMethod, name: "promotion_method")
        mapper.specify(property: &promotionName, name: "promotion_name")
        mapper.specify(property: &promotionPre, name: "promotion_pre")
        mapper.specify(property: &promotionState, name: "promotion_state")
        mapper.specify(property: &promotionType, name: "promotion_type")
        mapper.specify(property: &spuCode, name: "spu_code")
        mapper.specify(property: &updateTime, name: "update_time")
    }
    var beginTime : NSInteger?
    var createTime : NSInteger?
    var endTime : NSInteger?
    var enterpriseId : String?
    var groupCodes : String?
    @objc var Id : String?
    var levelIncre : String?
    var limitNum : String?
    var productCode : String?
    var promotionDesc : String?
    @objc var promotionId : String?
    var promotionMethod : String?
    var promotionName : String?
    var promotionPre : String?
    var promotionState : String?
    @objc var promotionType : String?
    var spuCode : String?
    var status : String?
    var timestamp : NSInteger?
    var updateTime : NSInteger?
    var productPromotionRules: [PromotionRuleModel]?
    var singleCanBuy :Int? //单品是否可购买，0-可购买，1-不可（显示套餐按钮）
    var promotionRule: Int? //活动规则 1=搭配套餐，2=固定套餐
    
    @objc var stringPromotionType: String {
        get {
            if let promotionType = self.promotionType {
                return "\(promotionType)"
            }else {
                return ""
            }
        }
    }
    
   @objc static func fromJSON(_ json: [String : AnyObject]) -> ProductPromotionInfo {
        let model = ProductPromotionInfo()
        let json = JSON(json)
        model.beginTime = json["begin_time"].intValue
        model.createTime = json["create_time"].intValue
        model.endTime = json["end_time"].intValue
        model.enterpriseId = json["enterprise_id"].stringValue
        model.groupCodes = json["group_codes"].stringValue
        model.Id = json["id"].stringValue
        model.levelIncre = json["level_incre"].stringValue
        model.limitNum = json["limit_num"].stringValue
        model.productCode = json["product_code"].stringValue
        model.promotionDesc = json["promotionDesc"].stringValue
        model.promotionId = json["promotion_id"].stringValue
        model.promotionMethod = json["promotion_method"].stringValue
        model.promotionName = json["promotion_name"].stringValue
        model.promotionPre = json["promotion_pre"].stringValue
        model.promotionState = json["promotion_state"].stringValue
        model.promotionType = json["promotion_type"].stringValue
        model.spuCode = json["spu_code"].stringValue
        model.status = json["status"].stringValue
        model.timestamp = json["timestamp"].intValue
        model.updateTime = json["update_time"].intValue
        if let j = json["productPromotionRules"].arrayObject {
            model.productPromotionRules = (j as NSArray).mapToObjectArray(PromotionRuleModel.self)
        }
        model.singleCanBuy = json["singleCanBuy"].intValue
        model.promotionRule = json["promotionRule"].intValue
        return model
    }
}
extension ProductPromotionInfo: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(beginTime, forKey: "beginTime")
        aCoder.encode(createTime, forKey: "createTime")
        aCoder.encode(enterpriseId, forKey: "enterpriseId")
        aCoder.encode(groupCodes, forKey: "groupCodes")
        aCoder.encode(Id, forKey: "Id")
        aCoder.encode(levelIncre, forKey: "levelIncre")
        
        aCoder.encode(limitNum, forKey: "limitNum")
        aCoder.encode(productCode, forKey: "productCode")
        aCoder.encode(promotionDesc, forKey: "promotionDesc")
        aCoder.encode(promotionId, forKey: "promotionId")
        aCoder.encode(promotionMethod, forKey: "promotionMethod")
        aCoder.encode(promotionName, forKey: "promotionName")
        
        aCoder.encode(promotionPre, forKey: "promotionPre")
        aCoder.encode(promotionState, forKey: "promotionState")
        aCoder.encode(promotionType, forKey: "promotionType")
        aCoder.encode(spuCode, forKey: "spuCode")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(timestamp, forKey: "timestamp")
        aCoder.encode(updateTime, forKey: "updateTime")
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        self.init()
        enterpriseId = aDecoder.decodeObject(forKey: "enterpriseId") as? String
        groupCodes = aDecoder.decodeObject(forKey: "groupCodes") as? String
        Id = aDecoder.decodeObject(forKey: "Id") as? String
        limitNum = aDecoder.decodeObject(forKey: "limitNum") as? String
        productCode = aDecoder.decodeObject(forKey: "productCode") as? String
        promotionDesc = aDecoder.decodeObject(forKey: "promotionDesc") as? String
        promotionId = aDecoder.decodeObject(forKey: "promotionId") as? String
        promotionMethod = aDecoder.decodeObject(forKey: "promotionMethod") as? String
        promotionName = aDecoder.decodeObject(forKey: "promotionName") as? String
        promotionPre = aDecoder.decodeObject(forKey: "promotionPre") as? String
        
        promotionState = aDecoder.decodeObject(forKey: "promotionState") as? String
        promotionType = aDecoder.decodeObject(forKey: "promotionType") as? String
        spuCode = aDecoder.decodeObject(forKey: "spuCode") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        
        
        beginTime = aDecoder.decodeObject(forKey: "beginTime") as? Int
        createTime = aDecoder.decodeObject(forKey: "createTime") as? Int
        endTime = aDecoder.decodeObject(forKey: "endTime") as? Int
        timestamp = aDecoder.decodeObject(forKey: "timestamp") as? Int
        updateTime = aDecoder.decodeObject(forKey: "updateTime") as? Int
    }
}
extension ProductPromotionInfo {
    //解析数据
    @objc static func getPromotionArr(_ dataArr:NSArray) ->NSArray{
        if let getArr = dataArr.mapToObjectArray(ProductPromotionInfo.self){
            return getArr as NSArray
        }
        return []
    }
}
extension ProductPromotionInfo{
    
}
