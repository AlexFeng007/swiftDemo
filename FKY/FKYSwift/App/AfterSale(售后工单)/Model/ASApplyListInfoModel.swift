//
//  ASApplyListInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2019/5/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc
final class ASApplyListInfoModel: NSObject, JSONAbleType {
    //使用到的字段
    //头部描述用到字段
    var firstTypeName: String?//类型描述
    var applyTimeStr: String? //申请时间
    var statusStr: String? //申请状态文字描述
    //第一类型ID(-1:申请退换货 ,1 :随行单据（随货单/发票）2:商品错漏发 4 :药检报告 5 :商品首营资质 6 :企业首营资质)
    var firstTypeId: Int?
    
    var secondTypeId: Int? //第二类型i的(非退换货使用)
    var productList:Array<ASListProductModel>? //array<object>商品列表
    var status: Int?  //状态（1or2处理中：3处理完成<随行单据（随货单/发票）or 企业首营资质判断>  0:退换货时显示取消按钮<申请退换货>）
    var secondTypeName: String?//状态描述（商品错漏发/药检报告/商品首营资质）
    
    //随行单据（随货单/发票）or 企业首营资质 使用到
    var completeContent: String? //处理完成的描述
    var completeDateStr: String? //处理完成时间
    
    var assId: Int? //工单ID
    var rmaNo:String? //工单ID
    //退货/换货使用到字段
    var rmaType: Int? //（0:退货 else换货）
    var backWay: String? //退货or换货方式
    var refundAmount: Double? //退款金额    number
    
    var orderNo: String? //订单号
    var orderChildNo: String? //子订单号  退换货
    var provinceName: String? //
    var cityName: String? //
    
    var rmaBizType :Int? // 1- 极速理赔 其他为null
    //未使用到字段（目前）
    var applyTime: String? //申请时间
    var bdName: String?
    var customerName: String?
    var orderStatus: String?
    var serviceTypeId: Int?
    var supplyName: String? //供应商
    var address: String? //
    var mobilePhone: String? //
    var backWayName: String? //
    var completeDate: String? //
    var isSendExpress: Bool? //
    
    static func fromJSON(_ json: [String : AnyObject]) ->  ASApplyListInfoModel {
        
        let json = JSON(json)
        let model =  ASApplyListInfoModel()
        
        model.assId = json["assId"].intValue
        model.rmaNo = json["rmaNo"].string
        
        model.firstTypeId = json["firstTypeId"].intValue
        model.secondTypeId = json["secondTypeId"].intValue
        model.serviceTypeId = json["serviceTypeId"].intValue
        model.status = json["status"].intValue
        
        model.applyTime = json["applyTime"].stringValue
        model.applyTimeStr = json["applyTimeStr"].stringValue
        model.bdName = json["bdName"].stringValue
        model.customerName = json["customerName"].stringValue
        model.firstTypeName = json["firstTypeName"].stringValue
        model.orderNo = json["orderNo"].stringValue
        model.orderStatus = json["orderStatus"].stringValue
        model.secondTypeName = json["secondTypeName"].stringValue
        model.statusStr = json["statusStr"].stringValue
        model.supplyName = json["supplyName"].stringValue
        model.orderChildNo = json["orderChildNo"].stringValue
        
        model.address = json["address"].stringValue
        model.cityName = json["cityName"].stringValue
        model.mobilePhone = json["mobilePhone"].stringValue
        model.provinceName = json["provinceName"].stringValue
        model.refundAmount = json["refundAmount"].doubleValue
        model.rmaType = json["rmaType"].intValue
        model.backWay = json["backWay"].stringValue
        model.backWayName = json["backWayName"].stringValue
        model.completeDateStr = json["completeDateStr"].stringValue
        model.completeDate = json["completeDate"].stringValue
        model.completeContent = json["completeContent"].stringValue
        model.isSendExpress = json["isSendExpress"].boolValue
        model.rmaBizType = json["rmaBizType"].intValue
        let productList = json["productList"].arrayObject
        var goodsInfo: [ASListProductModel]? = []
        if let list = productList {
            goodsInfo = (list as NSArray).mapToObjectArray(ASListProductModel.self)
        }
        model.productList = goodsInfo
        
        return model
    }
}
