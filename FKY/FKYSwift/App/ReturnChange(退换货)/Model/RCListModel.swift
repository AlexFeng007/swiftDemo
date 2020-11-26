//
//  RCListModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/20.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退换货之列表接口返回model

import UIKit
import SwiftyJSON

//0待审核 1审核通过 2审核不通过 3取消 4待收货 5待发货 6待退款 7待签收8 完成9 退货失败10 换货失败 11待虚拟入库审核
enum RCStausCode: Int  {
    case Staus_Wait_Check = 0 //待审核
    case Staus_Check_Complent = 1 //审核通过
    case Staus_Check_Faile = 2 //审核不通过
    case Staus_Cancel = 3 //取消
    case Staus_Wait_Revice = 4 //待收货
    case Staus_Wait_Send = 5 //待发货
    case Staus_Wait_Money = 6 //待退款
    case Staus_Wait_Sign = 7 //待签收
    case Staus_Complent = 8  //完成
    case Staus_Back_faile = 9 //退货失败
    case Staus_Change_faile = 10 //换货失败
    case Staus_Wait_ruku = 11  //待虚拟入库审核
}

@objc
final class RCListModel: NSObject, JSONAbleType {
    var addressId: String?
    var applyTime: String?
    var applyType: String?
    var asn: String?
    var attachmentList: String?
    var auditRemark: String?
    var auditTime: String?
    var auditUserName: String?
    var backAddress: String?
    var createDate: String?
    var customerName: String?       // 卖家名称
    var doNo: String?
    var freightAmount: String?
    var goodsReturnType: String?
    var id: String?                 // 退换货申请id
    var isEditExpressFee: String?
    var isVirtualStorage: String?
    var newSoNo: String?
    var orderId: String?
    var paymentType: String?        
    var popFlag: String?
    var reasonId: String?
    var reasonName: String?
    var reasonType: String?
    var reasonTypeOrm: String?
    var refundAmount: Double?
    var refundInfo: String?
    var rmaDetailList:Array<RCListProductModel>? //array<object>
    
    var rmaExpressFee: String?
    var rmaNo: String?
    var rmaRemark: String?
    var rmaType: Int?
    var rmaTypeName: String?
    var sendExpress: String?
    var soNo: String?
    var status: String?
    var statusCode: String?
    var venderAdress: RCVenderAdressModel?
    var venderName: String?
    var venderSendExpress: String?
    
    var address: String? //卖家地址
    var mobilePhone: String? //卖家手机号
    var isSendExpress:Bool?//是否填写回寄信息
    var provinceCode: String? //省ID
    var cityCode: String? //市ID
    var provinceName: String? //省名
    var cityName: String? //市名
    var backWayName: String? //退回方式名称 MIB 上门取件，MIC 顾客寄回 MIF 已拒收/快递员已带回
    var backWay: String? // 退回方式编码 MIB 上门取件，MIC 顾客寄回 MIF 已拒收/快递员已带回
    
    static func fromJSON(_ json: [String : AnyObject]) -> RCListModel {
        let json = JSON(json)
        
        let model = RCListModel()
        model.addressId = json["addressId"].stringValue
        model.mobilePhone = json["mobilePhone"].stringValue
        model.address = json["address"].stringValue
        
        model.createDate = json["createDate"].stringValue
        model.applyTime = json["applyTime"].stringValue
        model.applyType = json["applyType"].stringValue
        model.asn = json["asn"].stringValue
        model.attachmentList = json["attachmentList"].stringValue
        
        model.auditRemark = json["auditRemark"].stringValue
        model.auditTime = json["auditTime"].stringValue
        model.auditUserName = json["auditUserName"].stringValue
        model.backAddress = json["backAddress"].stringValue
        model.customerName = json["customerName"].stringValue
        model.doNo = json["doNo"].stringValue
        
        model.freightAmount = json["freightAmount"].stringValue
        model.goodsReturnType = json["goodsReturnType"].stringValue
        model.id = json["id"].stringValue
        model.isEditExpressFee = json["isEditExpressFee"].stringValue
        model.isVirtualStorage = json["isVirtualStorage"].stringValue
        model.newSoNo = json["newSoNo"].stringValue
        model.backWayName = json["backWayName"].stringValue
        model.backWay = json["backWay"].stringValue
        
        model.orderId = json["orderId"].stringValue
        model.paymentType = json["paymentType"].stringValue
        model.popFlag = json["popFlag"].stringValue
        model.reasonId = json["reasonId"].stringValue
        model.reasonType = json["reasonType"].stringValue
        model.reasonTypeOrm = json["reasonTypeOrm"].stringValue
        model.reasonName = json["reasonName"].stringValue
        
        model.refundAmount = json["refundAmount"].doubleValue
        model.refundInfo = json["refundInfo"].stringValue
        model.rmaExpressFee = json["rmaExpressFee"].stringValue
        
        model.rmaNo = json["rmaNo"].stringValue
        model.rmaRemark = json["rmaRemark"].stringValue
        model.rmaType = json["rmaType"].intValue
        model.rmaTypeName = json["rmaTypeName "].stringValue
        model.sendExpress = json["sendExpress"].stringValue
        model.soNo = json["soNo"].stringValue
        model.status = json["status"].stringValue
        model.statusCode = json["statusCode"].stringValue
        //model.venderAdress = json["venderAdress"].stringValue
        model.venderName = json["venderName"].stringValue
        model.venderSendExpress = json["venderSendExpress"].stringValue
        model.isSendExpress = json["isSendExpress"].boolValue
        model.provinceCode = json["provinceCode"].stringValue
        model.cityCode = json["cityCode"].stringValue
        model.provinceName  = json["provinceName"].stringValue
        model.cityName = json["cityName"].stringValue
        
        let rmaDetaillist = json["rmaDetailList"].arrayObject
        var rmaDetailList: [RCListProductModel]? = []
        if let list = rmaDetaillist {
            rmaDetailList = (list as NSArray).mapToObjectArray(RCListProductModel.self)
        }
        model.rmaDetailList = rmaDetailList
        
        var venderAdress: RCVenderAdressModel?
        let dic = json["venderAdress"].dictionaryObject
        if let _ = dic {
            let t = dic! as NSDictionary
            venderAdress = t.mapToObject(RCVenderAdressModel.self)
        }else{
            venderAdress = nil
        }
        model.venderAdress = venderAdress
        
        return model
    }
}
 
