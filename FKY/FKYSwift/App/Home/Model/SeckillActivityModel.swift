//
//  SeckillActivityModel.swift
//  FKY
//
//  Created by Andy on 2018/11/26.
//  Copyright © 2018 yiyaowang. All rights reserved.
//


import UIKit
import SwiftyJSON

final class SeckillActivityModel: NSObject, JSONAbleType {
    // 接口返回字段
    var actIcon: String?
    var actName: String?
    var enterpriseId : String?
    var promotionId : String?
    var sortNum : String?
    var id: String?
    var beginTime: String?
    var currentTime: String?
    var endTime: String?
    var promotionProducts : [SeckillActivityProductsModel]?
    
    init(actIcon: String?,beginTime: String?,currentTime : String?,endTime : String?,id : String?,actName: String?,enterpriseId: String?,promotionId: String?,sortNum: String?,promotionProducts : [SeckillActivityProductsModel]?) {
        self.actIcon = actIcon
        self.beginTime = beginTime
        self.currentTime = currentTime
        self.endTime = endTime
        self.id = id
        self.actName = actName
        self.enterpriseId = enterpriseId
        self.promotionId = promotionId
        self.sortNum = sortNum
        self.promotionProducts = promotionProducts
    }
    
    // 数据解析
    static func fromJSON(_ json: [String : AnyObject]) -> SeckillActivityModel {
        let j = JSON(json)
        
        let actIcon = j["actIcon"].stringValue
        let beginTime = j["beginTime"].stringValue
        let currentTime = j["currentTime"].stringValue
        let endTime = j["endTime"].stringValue
        let id = j["id"].stringValue
        let actName = j["actName"].stringValue
        let enterpriseId = j["enterpriseId"].stringValue
        let promotionId = j["promotionId"].stringValue
        let sortNum = j["sortNum"].stringValue
        
        var promotionProducts:[SeckillActivityProductsModel]? = [SeckillActivityProductsModel]()
        if let list = j["promotionProducts"].arrayObject {
            
            promotionProducts = (list as NSArray).mapToObjectArray(SeckillActivityProductsModel.self)
            for model in promotionProducts!{
                model.enterpriseId = enterpriseId
                model.actIcon = actIcon
            }
            
        }
        
        return SeckillActivityModel(actIcon: actIcon,beginTime: beginTime,currentTime : currentTime,endTime:endTime,id:id,actName:actName,enterpriseId:enterpriseId,promotionId:promotionId,sortNum:sortNum,promotionProducts:promotionProducts)
    }
}
