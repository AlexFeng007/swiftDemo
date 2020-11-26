//
//  ComplainDetailInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2019/1/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class ComplainDetailInfoModel: NSObject , JSONAbleType {
    var complaintFilePath: String?  //投诉图片地址
    var needPlatform: Int? //是否需要平台处理，0-不需要；1-需要平台处理
    var complaintStatus: Int?//投诉处理状态，1-待处理；2-商家已处理；3-处理完成；4-已关闭
    var sellerName: String?//卖家名称
    var complaintSellerReply: String?// 卖家回复内容
    var complaintPlatformReply: String?// 平台答复内容
    var complaintTypeName: String?// 问题类型中文描述
    var orderCreateTime: String?//订单创建时间
    
    var processTime: String?// 处理时间，平台处理时间>商检处理时间>NULL
    var complaintContent: String?//投诉内容
    var complaintStatusName: String?//投诉状态中文描述
    var sellerMobile: String?//订单编号
    var flowId: String?//卖家联系方式
    
    static func fromJSON(_ json: [String : AnyObject]) -> ComplainDetailInfoModel {
        
        let json = JSON(json)
        
        let model = ComplainDetailInfoModel()
        model.complaintFilePath = json["complaintFilePath"].stringValue
        model.needPlatform = json["needPlatform"].intValue
        model.complaintStatus = json["complaintStatus"].intValue
        
        model.sellerName = json["sellerName"].stringValue
        model.complaintSellerReply = json["complaintSellerReply"].stringValue
        model.complaintPlatformReply = json["complaintPlatformReply"].stringValue
        
        model.complaintTypeName = json["complaintTypeName"].stringValue
        model.orderCreateTime = json["orderCreateTime"].stringValue
        model.processTime = json["processTime"].stringValue
        
        model.complaintContent = json["complaintContent"].stringValue
        model.complaintStatusName = json["complaintStatusName"].stringValue
        model.sellerMobile = json["sellerMobile"].stringValue
        model.flowId = json["flowId"].stringValue
        
        return model
    }
}
