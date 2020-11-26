//
//  RCDetailModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/20.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退换货之详情接口返回model

import UIKit
import SwiftyJSON

final class RCDModel: NSObject , JSONAbleType {
    var addressId : String? //  退货地址ID    number
    var attachmentList:Array<RCAttachmentModel>?  //        array<object>    List<OcsRmaAttachmentBean> attachmentList
    var auditRemark : String? //   审核内容    string
    var createDate: String? //    申请时间    string
    var doNo: String? //    DO编号    string
    var id: String? //    在线退换货申请id    number
    var isVirtualStorage: String? //    原因类型，1虚拟入库 0 非虚拟入库    number
    var newSoNo: String? //    换货单号    string
    var orderId : String? //   父单号    string
    var paymentType: String? //    支付方式 0网上支付 1其他    number
    var popFlag: String? //    1 自营 2代售 3平台 4 寄售    number
    var reasonId : String? //   退换货原因id    number
    var reasonName: String? //    退换货原因    string
    var refundInfo : RCRefundInfoModel? //       object    com.yao.eas.api.model.vo.ocs.rma.RmaRefundInfoVO
    var rmaDetailList : Array<RCRmaDetailInfoModel>? //       array<object>    List<OcsRmaDetailBean> rmaDetailList
    var rmaNo: String? //    退换货编号    string
    var rmaRemark : String? //   备注    string
    var rmaType: Int? //    退换货类型 0 退货 1 换货    number
    var sendExpress : RCSendExpressModel? //       object    com.yao.eas.api.model.bean.ocs.OcsRmaExpressBean
    var soNo: String? //    子订单号    string
    var status: Int? //    @mock=8    number    0待审核 1审核通过 2审核不通过 3取消 4待收货 5待发货 6待退款 7待签收8 完成9 退货失败10 换货失败 11待虚拟入库审核
    var venderAdress: RCVenderAdressModel?
    var venderName: String? //    商家名称    string
    var venderSendExpress  : RCSendExpressModel? //      object
    var address: String? //
    var customerName: String? //
    var mobilePhone: String? //
    var varietiesNum : String? //   品种数量
    var goodsNumTotal: String? //    申请退换货商品总数量
    var reasonTypeOrm: String? //退货方式
    
    var backWayName: String? //退回方式名称 MIB 上门取件，MIC 顾客寄回 MIF 已拒收/快递员已带回
    var backWay: String? // 退回方式编码 MIB 上门取件，MIC 顾客寄回 MIF 已拒收/快递员已带回
    
    static func fromJSON(_ json: [String : AnyObject]) -> RCDModel {
        let json = JSON(json)
        
        let model = RCDModel()
        model.goodsNumTotal = json["goodsNumTotal"].stringValue
        model.varietiesNum  = json["varietiesNum"].stringValue
        model.mobilePhone = json["mobilePhone"].stringValue
        model.customerName = json["customerName"].stringValue
        model.address = json["address"].stringValue
        model.reasonTypeOrm = json["reasonTypeOrm"].stringValue
        model.addressId = json["addressId"].stringValue
        model.auditRemark = json["auditRemark"].stringValue
        model.doNo = json["doNo"].stringValue
        model.createDate = json["createDate"].stringValue
        model.id = json["id"].stringValue
        model.isVirtualStorage = json["isVirtualStorage"].stringValue
        model.popFlag = json["popFlag"].stringValue
        model.orderId = json["orderId"].stringValue
        model.paymentType = json["paymentType"].stringValue
        model.reasonId = json["reasonId"].stringValue
        model.reasonName = json["reasonName"].stringValue
        model.rmaNo = json["rmaNo"].stringValue
        model.rmaRemark = json["rmaRemark"].stringValue
        model.rmaType = json["rmaType"].intValue
        model.soNo = json["soNo"].stringValue
        model.status = json["status"].intValue
        model.venderName = json["venderName"].stringValue
        model.backWayName = json["backWayName"].stringValue
        model.backWay = json["backWay"].stringValue
        model.newSoNo = json["newSoNo"].stringValue
        
        let attachmentlist = json["attachmentList"].arrayObject
        var attachmentList: [RCAttachmentModel]? = []
        if let list = attachmentlist{
            attachmentList = (list as NSArray).mapToObjectArray(RCAttachmentModel.self)
        }
        model.attachmentList = attachmentList
        
        var refundInfo : RCRefundInfoModel?
        let dic = json["refundInfo"].dictionaryObject
        if let _ = dic {
            let t = dic! as NSDictionary
            refundInfo = t.mapToObject(RCRefundInfoModel.self)
        }else{
            refundInfo = nil
        }
        model.refundInfo = refundInfo
        
        let rmaDetaillist = json["rmaDetailList"].arrayObject
        var rmaDetailList: [RCRmaDetailInfoModel]? = []
        if let list = rmaDetaillist{
            rmaDetailList = (list as NSArray).mapToObjectArray(RCRmaDetailInfoModel.self)
        }
        model.rmaDetailList = rmaDetailList
        
        var sendExpress : RCSendExpressModel?
        let expressDic = json["sendExpress"].dictionaryObject
        if let _ = expressDic {
            let t = expressDic! as NSDictionary
            sendExpress = t.mapToObject(RCSendExpressModel.self)
        }else{
            sendExpress = nil
        }
        model.sendExpress = sendExpress
        
        var venderSendExpress : RCSendExpressModel?
        let venderExpressDic = json["venderSendExpress"].dictionaryObject
        if let _ = venderExpressDic {
            let t = venderExpressDic! as NSDictionary
            venderSendExpress = t.mapToObject(RCSendExpressModel.self)
        }else{
            venderSendExpress = nil
        }
        model.venderSendExpress = venderSendExpress
        
        var venderAdress : RCVenderAdressModel?
        let adressDic = json["venderAdress"].dictionaryObject
        if let _ = adressDic {
            let t = adressDic! as NSDictionary
            venderAdress = t.mapToObject(RCVenderAdressModel.self)
        }else{
           venderAdress = nil
        }
        model.venderAdress = venderAdress
        
        return model
    }
}

final class RCAttachmentModel: NSObject , JSONAbleType {
    var applyId : String? //       number
    var filePath: String? //    附件路径    string
    var id  : String? //      number
    var type : String? //   0退换货凭证 1客服介入凭证    string
    var uploadTime: String? //    上传时间    string
    
    static func fromJSON(_ json: [String : AnyObject]) -> RCAttachmentModel {
        let json = JSON(json)
        
        let model = RCAttachmentModel()
        model.applyId = json["applyId"].stringValue
        model.filePath = json["filePath"].stringValue
        model.id = json["id"].stringValue
        model.uploadTime = json["uploadTime"].stringValue
        return model
    }
}

final class RCRefundInfoModel: NSObject , JSONAbleType {
    var expressFee : String? //   退换货寄回运费（退至虚拟账户）    number
    var refundAmount: String? //    退款金额    number
    var refundDate : String? //   退款时间    string
    var refundExpressDate: String? //    运费退款时间    string
    var refundExpressFeeType : String? //   '您的壹药网账户'    string
    var refundType : String? //   相关单据类型:MPA(原路返回)、MPB(退至虚拟账户)    string
    
    static func fromJSON(_ json: [String : AnyObject]) -> RCRefundInfoModel {
        let json = JSON(json)
        
        let model = RCRefundInfoModel()
        model.expressFee = json["expressFee"].stringValue
        model.refundAmount = json["refundAmount"].stringValue
        model.refundDate = json["refundDate"].stringValue
        model.refundExpressDate = json["refundExpressDate"].stringValue
        model.refundExpressFeeType = json["refundExpressFeeType"].stringValue
        model.refundType = json["refundType"].stringValue
        return model
    }
}

final class RCRmaDetailInfoModel: NSObject , JSONAbleType {
    var amount : String? //   购买数量    number
    var applyId : String? //   退换货申请ID    number
    var goodsId: String? //    商品ID    number
    var goodsName: String? //    商品名称    string
    var id: String? //    在线退换货商品id    number
    var img : String? //   商品图片url    string
    var listId: String? //    订单商品列表id    number
    var price: String? //    商品单价    number
    var productNo: String? //    产品编码    string
    var rmaCount: String? //    退换货数量    number
    
    static func fromJSON(_ json: [String : AnyObject]) -> RCRmaDetailInfoModel {
        let json = JSON(json)
        
        let model = RCRmaDetailInfoModel()
        model.amount = json["amount"].stringValue
        model.applyId = json["applyId"].stringValue
        model.goodsId = json["goodsId"].stringValue
        model.goodsName = json["goodsName"].stringValue
        model.id = json["id"].stringValue
        model.listId = json["listId"].stringValue
        model.price = json["price"].stringValue
        model.productNo = json["productNo"].stringValue
        model.rmaCount = json["rmaCount"].stringValue
        model.img = json["img"].stringValue
        return model
    }
}

final class RCSendExpressModel: NSObject , JSONAbleType {
    var applyId : String? //   退换货申请ID    number
    var expressFee : String? //   申请快递费    number
    var id  : String? //      number
    var expressName : String? //   实退运费    number
    var realExpressFee : String? //   实退运费    number
    var expressNo : String? //   实退运费    number
    var type : String? //   1用户发货物流 2卖家发货物流 3暂缓退款物流信息    number
    var expressId : String? //   承运商id  number
    
    static func fromJSON(_ json: [String : AnyObject]) -> RCSendExpressModel {
        let json = JSON(json)
        
        let model = RCSendExpressModel()
        model.applyId = json["applyId"].stringValue
        model.expressFee = json["expressFee"].stringValue
        model.id = json["id"].stringValue
        model.realExpressFee = json["realExpressFee"].stringValue
        model.type = json["type"].stringValue
        model.expressName = json["expressName"].stringValue
        model.expressNo = json["expressNo"].stringValue
        model.expressId = json["expressId"].stringValue
        return model
    }
}

final class RCVenderAdressModel: NSObject , JSONAbleType {
    var address : String? //   地址    string
    var addressId : String? //       number
    var consigneeName : String? //   收货人姓名    string
    var consigneePhone: String? //    收货人电话    string
    
    static func fromJSON(_ json: [String : AnyObject]) -> RCVenderAdressModel {
        let json = JSON(json)
        
        let model = RCVenderAdressModel()
        model.address = json["address"].stringValue
        model.addressId = json["addressId"].stringValue
        model.consigneeName = json["consigneeName"].stringValue
        model.consigneePhone = json["consigneePhone"].stringValue
        return model
    }
}

final class RCExpressListInfoModel: NSObject , JSONAbleType {
    var waybillNo: String? //
    var logs: [RCExpressInfoModel]? //
    var orderStatus: String? //
    
    static func fromJSON(_ json: [String : AnyObject]) -> RCExpressListInfoModel {
        let json = JSON(json)
        
        let model = RCExpressListInfoModel()
        model.waybillNo = json["waybillNo"].stringValue
        model.orderStatus = json["orderStatus"].stringValue
        let logs = json["logs"].arrayObject
        var logsList: [RCExpressInfoModel]? = []
        if let list = logs{
            logsList = (list as NSArray).mapToObjectArray(RCExpressInfoModel.self)
        }
        model.logs = logsList
        return model
    }
}

final class RCExpressInfoModel: NSObject , JSONAbleType {
    @objc var context: String? // 【拆单】药城商家MP订单",
    @objc var ftime: String? // 2018-02-02 14:01:53",
    @objc var time: String? // 2018-02-02 14:01:53"
    
    static func fromJSON(_ json: [String : AnyObject]) -> RCExpressInfoModel {
        let json = JSON(json)
        
        let model = RCExpressInfoModel()
        model.context = json["context"].stringValue
        model.ftime = json["ftime"].stringValue
        model.time = json["time"].stringValue
        return model
    }
}

final class RCLogistDetailInfoModel: NSObject , JSONAbleType {
    var status: String?
    var carrierId: String?
    var expressNum: String?
    var carrierName: String?
    var logs: [RCLogistInfoModel]? //
    static func fromJSON(_ json: [String : AnyObject]) -> RCLogistDetailInfoModel {
        let json = JSON(json)
        
        let model = RCLogistDetailInfoModel()
        model.carrierId = json["carrierId"].stringValue
        model.status = json["status"].stringValue
        model.carrierName = json["carrierName"].stringValue
        model.expressNum = json["expressNum"].stringValue
        let logs = json["logs"].arrayObject
        var logsList: [RCLogistInfoModel]? = []
        if let list = logs{
            logsList = (list as NSArray).mapToObjectArray(RCLogistInfoModel.self)
        }
        model.logs = logsList
        return model
    }
}

final class RCLogistInfoModel: NSObject , JSONAbleType {
    @objc var remark: String? // 【拆单】药城商家MP订单",
    @objc var createDate: String? // 2018-02-02 14:01:53",
    @objc var updateTime: String? // 2018-02-02 14:01:53"
    @objc var doOpTime: String? // 2018-02-02 14:01:53"
    
    static func fromJSON(_ json: [String : AnyObject]) -> RCLogistInfoModel {
        let json = JSON(json)
        let model = RCLogistInfoModel()
        model.remark = json["remark"].stringValue
        model.createDate = json["createDate"].stringValue
        model.doOpTime = json["doOpTime"].stringValue
        model.updateTime = json["updateTime"].stringValue
        return model
    }
}
