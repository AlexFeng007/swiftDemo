//
//  ASApplyDetailInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2019/5/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
"soNo": "XXD20190308164925573720", //订单号
"typeName1": "药检报告", //服务类型名称(大类)
"typeId1": "4", //服务类型id(大类)
"typeName2": "药检报告资料不全", //服务类型名称(小类)
"typeId2": "18", //服务类型id(小类)
"description": "xxx", //具体描述
"goodsInfo": [{
"specification": "2233", //规格
"shortName": "绚金黑", //通用名
"productName": "HYDRON/海昌", //商品名
"productCount": 2, //商品数量
"productCode": "34343432", //商品编码
"batchNumber": "18", //批号
"omitCount": 2, //错漏发数量 （只有服务类型为错漏发 才会有值）
}],
"imgPath"[
"http://p8.maiyaole.com/fky/saledservice/e96e6ea734d8ff5583d99f17731bab4d.jpg",
"http://p8.maiyaole.com/fky/saledservice/e96e6ea734d8ff5583d99f17731bab4d.jpg"
], //图片路径
"refundType": "0", //退款类型：0-账户余额退款 1-取消订单退款 2-其他
"refundTypeStr": "账户余额退款", //退款类型（value值）
"refundAmount": "", //退款金额
"refundAccountName": "", //退款账户名称
"refundBankName": "", //退款银行名称
"refundBankAccount": "", //退款银行账号
"refundRemarks": "", //退款备注
"mmType": "1" //商品错漏发类型: 1-错发 2-漏发
"applyTime": "", //申请时间
"completeDate": "", //处理完成时间
"completeContent": "" //处理意见  1:待分配 2:处理中 3:处理完成
*/


enum ASApplyStatus: Int {
    case ASApplyStatus_Wait = 1 //处理中
    case ASApplyStatus_Dealing = 2 //处理中
    case ASApplyStatus_Complete = 3//处理完成
}


final class ASApplyDetailInfoModel: JSONAbleType {
    var soNo: String?
    var typeName1: String?
    var typeId1: String?
    var typeName2: String?
    var typeId2: String?
    var desc: String?
    var refundType: String?
    var refundTypeStr: String?
    var refundAmount: String?
    var refundAccountName: String?
    var refundBankName: String?
    var refundBankAccount: String?
    var refundRemarks: String?
    var mmType: String?
    var applyTime: String?
    var completeDate: String?
    var completeContent: String?
    var status: Int? // @mock=8 number 0待审核 1审核通过 2审核不通过 3取消 4待收货 5待发货 6待退款 7待签收 8完成 9退货失败 10换货失败 11待虚拟入库审核
    var imgPath: Array<String>?
    var goodsInfo: Array<ASListProductModel>? //array<object>
    
    static func fromJSON(_ json: [String : AnyObject]) -> ASApplyDetailInfoModel {
        let json = JSON(json)
        
        let model = ASApplyDetailInfoModel()
        model.soNo = json["soNo"].stringValue
        model.typeName1 = json["typeName1"].stringValue
        model.typeId1 = json["typeId1"].stringValue
        model.typeName2 = json["typeName2"].stringValue
        model.typeId2 = json["typeId2"].stringValue
        model.desc = json["description"].stringValue
        model.status = json["status"].intValue
        model.refundType = json["refundType"].stringValue
        model.refundTypeStr = json["refundTypeStr"].stringValue
        model.refundAmount = json["refundAmount"].stringValue
        model.refundAccountName = json["refundAccountName"].stringValue
        model.refundBankName = json["refundBankName"].stringValue
        model.refundBankAccount = json["refundBankAccount"].stringValue
        model.refundRemarks = json["refundRemarks"].stringValue
        model.mmType = json["mmType"].stringValue
        model.applyTime = json["applyTime"].stringValue
        model.completeDate = json["completeDate"].stringValue
        model.completeContent = json["completeContent"].stringValue
        
        let productList = json["goodsInfo"].arrayObject
        var goodsInfo: [ASListProductModel]? = []
        if let list = productList {
            goodsInfo = (list as NSArray).mapToObjectArray(ASListProductModel.self)
        }
        model.goodsInfo = goodsInfo
        
        let imageList = json["imgPath"].arrayObject
        var imgPath: [String]? = []
        if let list = imageList {
            imgPath = (list as! [String])
        }
        model.imgPath = imgPath
        
        return model
    }
}

final class ASListProductModel: NSObject, JSONAbleType {
    var specification: String?//规格
    var shortName: String?
    var productName: String?//商品名称
    var productCount: String?//商品数量
    var goodsName: String?
    var productCode: String?
    var batchNumber: String?
    var omitCount: String?
    var img: String?
    var price: Double? //商品价格
    var orderDetailId: String?
    var mainImgPath: String?//图片链接
    var applyCount: Int?//申请数量（商品错漏发）
    var unit: String?
    var unitDes: String?
    var expiryDate : String? //效期
    
    static func fromJSON(_ json: [String : AnyObject]) -> ASListProductModel {
        let json = JSON(json)
        
        let model = ASListProductModel()
        model.specification = json["specification"].stringValue
        model.shortName = json["shortName"].stringValue
        model.productName = json["productName"].stringValue
        model.productCount = json["productCount"].stringValue
        model.productCode = json["productCode"].stringValue
        model.goodsName = json["goodsName"].stringValue
        model.batchNumber = json["batchNumber"].stringValue
        model.omitCount = json["omitCount"].stringValue
        model.img = json["img"].stringValue
        model.price = json["price"].doubleValue
        model.orderDetailId = json["orderDetailId"].stringValue
        model.mainImgPath = json["mainImgPath"].stringValue
        model.applyCount = json["applyCount"].intValue
        model.unit = json["unit"].stringValue
        model.unitDes = json["unitDes"].stringValue
        return model
    }
}


//"applyCount": null,
//"batchNo": "",
//"mainImgPath": "https://p8.maiyaole.com/img/201408/23/20140823222955554.jpg",
//"orderDetailId": "2928329",
//"price": null,
//"productCode": "1599376819",
//"productCount": 2,
//"productName": "绚金黑HYDRON/海昌",
//"specification": "-3.00"
