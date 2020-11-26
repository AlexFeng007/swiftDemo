//
//  ComboListModel.swift
//  FKY
//
//  Created by Andy on 2018/11/20.
//  Copyright © 2018 yiyaowang. All rights reserved.
//


//{
//    "data": [{
//    "areaType": 1,
//    "beginTime": "2018-10-24 00:00:00",
//    "dinnerDiscountMoney": 28.00,
//    "dinnerPrice": 105.00,
//    "endTime": "2020-10-25 00:00:00",
//    "enterpriseId": null,
//    "maxBuyNum": 5175,
//    "productList": [{
//    "batchNo": "0001",
//    "currentBuyNum": 56326,
//    "deadLine": "2019-11-15 00:00:00",
//    "discountMoney": 6.000,
//    "doorsill": 3,
//    "factoryId": "",
//    "factoryName": "36011",
//    "filePath": "http://p8.maiyaole.com/img/item/201712/08/20171208084418262.jpg",
//    "minimumPacking": 3,
//    "originalPrice": 21.0,
//    "productId": 368151,
//    "productName": "欧果",
//    "productcodeCompany": "1601193156",
//    "promotionId": "16581",
//    "shortName": "WMS康富来 小儿清咽颗粒 6g*6袋",
//    "sortNum": 2,
//    "spec": "6g*6袋",
//    "spuCode": "8353YCZ40004",
//    "supplyId": 8353,
//    "unitName": "盒",
//    "weekLimitNum": null
//    }, {
//    "batchNo": "Auto20180409",
//    "currentBuyNum": 10350,
//    "deadLine": "2023-04-08 00:00:00",
//    "discountMoney": 5.000,
//    "doorsill": 2,
//    "factoryId": "",
//    "factoryName": "36071",
//    "filePath": "http://p8.maiyaole.com/img/201411/10/20141110174831744.jpg",
//    "minimumPacking": 1,
//    "originalPrice": 21.0,
//    "productId": 368527,
//    "productName": "东阿阿胶",
//    "productcodeCompany": "1600965614",
//    "promotionId": "16581",
//    "shortName": "WMS东阿数据对接 500g",
//    "sortNum": null,
//    "spec": "500g",
//    "spuCode": "8353YCZ370010",
//    "supplyId": 8353,
//    "unitName": "盒",
//    "weekLimitNum": null
//    }],
//    "promotionAreaList": [],
//    "promotionId": 16581,
//    "promotionName": "WMS金蓓贝",
//    "promotionRule": 2,
//    "useDesc": ""
//    }],
//    "rtn_code": "0",
//    "rtn_ext": "",
//    "rtn_ftype": "0",
//    "rtn_msg": "",
//    "rtn_tip": ""
//}

import UIKit
import SwiftyJSON

final class ComboListModel: NSObject, JSONAbleType {
    let areaType : String?
    let beginTime : String?
    let dinnerDiscountMoney : String?
    let dinnerPrice : String?
    let endTime : String?
    let enterpriseId : String?
    let maxBuyNum : Int?
    let promotionId : String?
    let promotionName : String?
    let promotionRule : String?
    let useDesc : String?
    let originPrice : String? //原价
    let maxBuyNumPerDay : Int? //每日购买数量
    
    // model
    let productList : [ComboProductListModel]?
//    let promotionAreaList : NSArray?
    
    //购物车中数量（自定义字段，需匹配购物车接口中商品promotionId获取）
    var carOfCount :Int = 0

    init(areaType : String?,beginTime : String?,dinnerDiscountMoney : String?,dinnerPrice : String?,endTime : String?,enterpriseId : String?,maxBuyNum : Int?,promotionId : String?,promotionName : String?,promotionRule : String?,useDesc : String?,productList:[ComboProductListModel]?,carOfCount:Int,originPrice:String?,maxBuyNumPerDay:Int?) {
        self.areaType = areaType
        self.beginTime = beginTime
        self.dinnerDiscountMoney = dinnerDiscountMoney
        self.dinnerPrice = dinnerPrice
        self.endTime = endTime
        self.enterpriseId = enterpriseId
        self.maxBuyNum = maxBuyNum
        self.promotionId = promotionId
        self.promotionName = promotionName
        self.promotionRule = promotionRule
        self.useDesc = useDesc
        self.productList = productList
        self.carOfCount = carOfCount
        self.originPrice = originPrice
        self.maxBuyNumPerDay = maxBuyNumPerDay
//        self.promotionAreaList = promotionAreaList
    }
    
    
    static func fromJSON(_ json: [String : AnyObject]) -> ComboListModel {
        let json = JSON(json)
        
        let areaType = json["areaType"].stringValue
        let beginTime = json["beginTime"].stringValue
        let dinnerDiscountMoney = json["dinnerDiscountMoney"].stringValue
        let dinnerPrice = json["dinnerPrice"].stringValue
        let endTime = json["endTime"].stringValue
        let enterpriseId = json["enterpriseId"].stringValue
        let maxBuyNum = json["maxBuyNum"].intValue
        let promotionId = json["promotionId"].stringValue
        let promotionName = json["promotionName"].stringValue
        let promotionRule = json["promotionRule"].stringValue
        let useDesc = json["useDesc"].stringValue
        let originPrice = json["dinnerOriginPrice"].stringValue
        let maxBuyNumPerDay = json["maxBuyNumPerDay"].intValue
        
        
        var productList:[ComboProductListModel]? = [ComboProductListModel]()
        if let list = json["productList"].arrayObject {
            productList = (list as NSArray).mapToObjectArray(ComboProductListModel.self)
        }
        
//        let promotionAreaList = []
        var carOfCount : Int?
        for cartModel in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.promotionId != nil,cartOfInfoModel.promotionId.intValue == Int(promotionId)!{
                carOfCount = cartOfInfoModel.buyNum.intValue
                break
            }
        }
        
        return ComboListModel(areaType: areaType, beginTime: beginTime, dinnerDiscountMoney: dinnerDiscountMoney, dinnerPrice: dinnerPrice, endTime: endTime, enterpriseId: enterpriseId, maxBuyNum: maxBuyNum, promotionId: promotionId, promotionName: promotionName, promotionRule: promotionRule, useDesc: useDesc, productList: productList,carOfCount:carOfCount ?? 0,originPrice:originPrice,maxBuyNumPerDay:maxBuyNumPerDay)
        
        
    }
    
    //获取加车数量最大值
    func getAddMaxNum() -> Int {
        var addNum = 1
        var hasNum = false
        if let num = self.maxBuyNum, num > 0{
            addNum = num
            hasNum = true
        }
        if let num = self.maxBuyNumPerDay, num > 0 {
            if hasNum {
                if  num < addNum {
                    addNum = num
                }
            }else {
                addNum = num
            }
        }
        return addNum
    }
    
    
    
    
    
    
    
    
    
    
}
