//
//  RCListProductModel.swift
//  FKY
//
//  Created by 寒山 on 2018/11/21.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class RCListProductModel: NSObject, JSONAbleType {
//    var goodsId: String? // 商品id    number    @mock=$order(971694,971694)
//    var goodsName: String? // 商品名称    string    @mock=$order('南国牌 维生素B1片 100片','南国牌 维生素B1片 100片')
//    var image: String? // 商品图片url    string
//    var price: String? // 价格    number    @mock=$order(1,1.1)
//    var rmaCount: String? // 退换货商品数    number    @mock=$order(5,1)
//
//    static func fromJSON(_ json: [String : AnyObject]) -> RCListProductModel {
//        let json = JSON(json)
//
//        let model = RCListProductModel()
//        model.goodsId = json["goodsId"].stringValue
//        model.goodsName = json["goodsName"].stringValue
//        model.image = json["image"].stringValue
//        model.price = json["price"].stringValue
//        model.rmaCount = json["rmaCount"].stringValue
//        return model
//    }
    
    var amount: String?
    var applyId: String?
    var expireTime: String?
    var goodsId: String?
    var goodsName: String?
    var id: String?
    var img: String?
    var listId: String?
    var lotNo: String?
    var netOrderDetailId: String?
    var otherAmount: String?
    var price: Double?
    var productNo: String?
    var promotionAmount: String?
    var rebateAmount: String?
    var refundAmount: String?
    var rmaCount: String?
    var spec: String?
    var voucherAmount: String?
    var voucherCodeAmount: String?
    var voucherShopAmount: String?
    
    static func fromJSON(_ json: [String : AnyObject]) -> RCListProductModel {
        let json = JSON(json)

        let model = RCListProductModel()
        model.applyId = json["applyId"].stringValue
        model.expireTime = json["expireTime"].stringValue
        model.amount = json["amount"].stringValue
        model.price = json["price"].doubleValue
        model.goodsId = json["goodsId"].stringValue
        model.goodsName = json["goodsName"].stringValue
        model.id = json["id"].stringValue
        model.img = json["img"].stringValue
        model.listId = json["listId"].stringValue
        model.lotNo = json["lotNo"].stringValue
        model.netOrderDetailId = json["netOrderDetailId"].stringValue
        model.otherAmount = json["otherAmount"].stringValue
        model.productNo = json["productNo"].stringValue
        model.promotionAmount = json["promotionAmount"].stringValue
        model.rebateAmount = json["rebateAmount"].stringValue
        model.refundAmount = json["refundAmount"].stringValue
        model.rmaCount = json["rmaCount"].stringValue
        model.spec = json["spec"].stringValue
        model.voucherAmount = json["voucherAmount"].stringValue
        model.voucherCodeAmount = json["voucherCodeAmount"].stringValue
        model.voucherShopAmount = json["voucherShopAmount"].stringValue
        return model
    }
}
