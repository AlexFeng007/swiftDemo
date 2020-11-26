//
//  ComplainSellerInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2019/1/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class ComplainSellerInfoModel: NSObject , JSONAbleType {

    var orderCreateTime: String?  //订单创建时间
    var buyerMobile: String?//买家联系方式
    var complaintType: [ComplaintTypeInfoModel]? //// 投诉类型
    var sellerName: String?// 卖家名称
    var flowId: String?// 订单编号
    var buyerName: String?//买家名称
    
    var sellerMobile: String?// 买家名称
    
    static func fromJSON(_ json: [String : AnyObject]) -> ComplainSellerInfoModel {
        
        let json = JSON(json)
        
        let model = ComplainSellerInfoModel()
        model.orderCreateTime = json["orderCreateTime"].stringValue
        model.sellerName = json["sellerName"].stringValue
        model.buyerMobile = json["buyerMobile"].stringValue
        model.buyerName = json["buyerName"].stringValue
        model.orderCreateTime = json["orderCreateTime"].stringValue
        model.sellerMobile = json["sellerMobile"].stringValue
        model.flowId = json["flowId"].stringValue
        
        let types = json["complaintType"].arrayObject
        var typesList: [ComplaintTypeInfoModel]? = []
        if let list = types{
            typesList = (list as NSArray).mapToObjectArray(ComplaintTypeInfoModel.self)
        }
        model.complaintType = typesList
        return model
    }
}

final class ComplaintTypeInfoModel: NSObject , JSONAbleType {
    var typeDesc: String?
    var type: Int?
   
    static func fromJSON(_ json: [String : AnyObject]) -> ComplaintTypeInfoModel {
        let json = JSON(json)
        let model = ComplaintTypeInfoModel()
        model.typeDesc = json["typeDesc"].stringValue
        model.type = json["type"].intValue
        return model
    }
}
class ComplaintInputInfoModel: NSObject{
    var flowId: String?  // 订单编号
    var complaintUrlList = [String]()   //  Array<String>    图片URL地址
    var content: String?   // 投诉内容
    var complaintType: Int? //投诉类型，1-发货问题；2-质量问题；3-售后问题；4-其他问题
 
}
