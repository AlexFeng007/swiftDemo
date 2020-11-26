//
//  FKYNewPrdSetModel.swift
//  FKY
//
//  Created by yyc on 2020/3/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc final class FKYNewPrdSetModel: NSObject,JSONAbleType {
    var allPages : Int? //页数总数
    var newPrdArr:[FKYNewPrdSetItemModel]? //新品列表
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYNewPrdSetModel {
        let json = JSON(json)
        let model = FKYNewPrdSetModel()
        model.allPages = json["allPages"].intValue
        if let list = json["result"].arrayObject {
            model.newPrdArr = (list as NSArray).mapToObjectArray(FKYNewPrdSetItemModel.self)
        }
        return model
    }
}
@objc final class FKYNewPrdSetItemModel: NSObject,JSONAbleType {
    var approvalResult : String? //外部审核反馈
    var avgMonthSales : Int? //月销量
    var barcode : String? //条形码
    var businessStatus : Int? //状态 价0-待采纳；1-已采纳；2-不采纳
    var createTime : String? //登记时间
    var increateId : Int? //自增id
    var imgUrl : String? //图片路径
    var imagePaths : [String]? //标品图片
    var manufacturer : String? //生产企业
    var masterId : Int? //标品主码id
    var productName : String? //商品名
    var purchasePrice : Float? //价格
    var sellerCode : String? //供应商id
    var sellerName : String? //供应商名称
    var spec : String? //规格
    var userId : String? //登记用户id
    var userPhone : String? //登记手机号
    
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYNewPrdSetItemModel {
        let json = JSON(json)
        let model = FKYNewPrdSetItemModel()
        model.approvalResult = json["approvalResult"].stringValue
        model.avgMonthSales = json["avgMonthSales"].int
        model.barcode = json["barcode"].stringValue
        model.businessStatus = json["businessStatus"].intValue
        model.createTime = json["createTime"].stringValue
        model.increateId = json["id"].intValue
        model.imgUrl = json["imgUrl"].stringValue 
        if let imgArr = json["imagePaths"].arrayObject as? [String] {
            model.imagePaths = imgArr
        }
        model.manufacturer = json["manufacturer"].stringValue
        model.masterId = json["masterId"].intValue
        model.productName = json["productName"].stringValue
        model.purchasePrice = json["purchasePrice"].float
        model.sellerCode = json["sellerCode"].stringValue
        model.sellerName = json["sellerName"].stringValue
        model.spec = json["spec"].stringValue
        model.userId = json["userId"].stringValue
        model.userPhone = json["userPhone"].stringValue
        return model
    }
}
