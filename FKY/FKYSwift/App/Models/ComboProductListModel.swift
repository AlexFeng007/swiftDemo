//
//  ComboProductListModel.swift
//  FKY
//
//  Created by Andy on 2018/11/21.
//  Copyright © 2018 yiyaowang. All rights reserved.
//


//"productList": [{
//"batchNo": "0001",
//"currentBuyNum": 56305,
//"deadLine": "2019-11-15 00:00:00",
//"discountMoney": 6.000,
//"doorsill": 3,
//"factoryId": "",
//"factoryName": "36011",
//"filePath": "http://p8.maiyaole.com/img/item/201712/08/20171208084418262.jpg",
//"minimumPacking": 3,
//"originalPrice": 103.95,
//"productId": 368151,
//"productName": "欧果",
//"productcodeCompany": "1601193156",
//"promotionId": "16581",
//"shortName": "WMS康富来 小儿清咽颗粒 6g*6袋",
//"sortNum": 2,
//"spec": "6g*6袋",
//"spuCode": "8353YCZ40004",
//"supplyId": 8353,
//"unitName": "盒",
//"weekLimitNum": null
//},

import UIKit
import SwiftyJSON

final class ComboProductListModel: NSObject , JSONAbleType{
    let batchNo : String?
    let currentBuyNum : String?
    let deadLine : String?
    let discountMoney : String? //优惠金额
    let doorsill : String?
    let factoryId : String?
    let factoryName : String?
    let filePath : String?
    let minimumPacking : String?
    let originalPrice : String? //原价
    let dinnerPrice : String? //套餐购物买价格
    let productId : String?
    let productName : String?
    let productcodeCompany : String?
    let promotionId : String?
    let shortName : String?
    let sortNum : String?
    let spec : String?
    let spuCode : String?
    let supplyId : String?
    let unitName : String?
    let weekLimitNum : String?
    let shareStockDesc : String?
    let stockCount : String?
    
    
    init(batchNo : String?,currentBuyNum : String?,deadLine : String?,discountMoney : String?,doorsill : String?,factoryId : String?,factoryName : String?,filePath : String?,minimumPacking : String?,originalPrice : String?,productId : String?,productName : String?,productcodeCompany : String?,promotionId : String?,shortName : String?,sortNum : String?,spec : String?,spuCode : String?,supplyId : String?,unitName : String?,weekLimitNum : String?,shareStockDesc: String?,stockCount: String?,dinnerPrice: String?) {
        self.batchNo = batchNo
        self.currentBuyNum = currentBuyNum
        self.deadLine = deadLine
        self.discountMoney = discountMoney
        self.doorsill = doorsill
        self.factoryId = factoryId
        self.factoryName = factoryName
        self.filePath = filePath
        self.minimumPacking = minimumPacking
        self.originalPrice = originalPrice
        self.productId = productId
        self.productName = productName
        self.productcodeCompany = productcodeCompany
        self.promotionId = promotionId
        self.shortName = shortName
        self.sortNum = sortNum
        self.spec = spec
        self.spuCode = spuCode
        self.supplyId = supplyId
        self.unitName = unitName
        self.weekLimitNum = weekLimitNum
        self.shareStockDesc = shareStockDesc
        self.stockCount = stockCount
        self.dinnerPrice = dinnerPrice
    }

    static func fromJSON(_ json: [String : AnyObject]) -> ComboProductListModel {
        let json = JSON(json)
        
        let batchNo = json["batchNo"].stringValue
        let currentBuyNum = json["currentBuyNum"].stringValue
        let deadLine = json["deadLine"].stringValue
        let discountMoney = json["discountMoney"].stringValue
        let doorsill = json["doorsill"].stringValue
        let factoryId = json["factoryId"].stringValue
        let factoryName = json["factoryName"].stringValue
        let filePath = json["filePath"].stringValue
        let minimumPacking = json["minimumPacking"].stringValue
        let originalPrice = json["originalPrice"].stringValue
        let productId = json["productId"].stringValue
        let productName = json["productName"].stringValue
        let productcodeCompany = json["productcodeCompany"].stringValue
        let promotionId = json["promotionId"].stringValue
        let shortName = json["shortName"].stringValue
        let sortNum = json["sortNum"].stringValue
        let spec = json["spec"].stringValue
        let spuCode = json["spuCode"].stringValue
        let supplyId = json["supplyId"].stringValue
        let unitName = json["unitName"].stringValue
        let weekLimitNum = json["weekLimitNum"].stringValue
        let shareStockDesc = json["shareStockDesc"].stringValue
        let stockCount = json["stockCount"].stringValue
        let dinnerPrice = json["dinnerPrice"].stringValue
        
        return ComboProductListModel(batchNo: batchNo, currentBuyNum:currentBuyNum,deadLine:deadLine,discountMoney:discountMoney,doorsill:doorsill,factoryId:factoryId,factoryName:factoryName,filePath:filePath,minimumPacking:minimumPacking,originalPrice:originalPrice,productId:productId,productName:productName,productcodeCompany:productcodeCompany,promotionId:promotionId,shortName:shortName,sortNum:sortNum,spec:spec,spuCode:spuCode,supplyId:supplyId,unitName:unitName,weekLimitNum:weekLimitNum,shareStockDesc:shareStockDesc,stockCount:stockCount,dinnerPrice:dinnerPrice)
    }
}
