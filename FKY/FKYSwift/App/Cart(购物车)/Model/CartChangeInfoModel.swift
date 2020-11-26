//
//  CartChangeInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2019/12/10.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class CartChangeInfoModel: NSObject, JSONAbleType {
    
    var shortWarehouseName:String?       //    自营仓名称简称    string    supplyType为0时存在
    var supplyName:String?       //    供应商名称    string
    var supplyType:String?       //    是否是自营商家标识0：自营，1:MP    string
    var supplyId : Int? // 供应商id
    var innoProductList: [CartChangeProductInfoModel]?
    @objc static func fromJSON(_ json: [String : AnyObject]) ->CartChangeInfoModel{
        let json = JSON(json)
        let model = CartChangeInfoModel()
        model.shortWarehouseName = json["shortWarehouseName"].stringValue
        model.supplyName = json["supplyName"].stringValue
        model.supplyType = json["supplyType"].stringValue
        model.supplyId = json["supplyId"].intValue
        var list: [CartChangeProductInfoModel]? = []
        if let arr = json["innoProductList"].arrayObject {
            list = (arr as NSArray).mapToObjectArray(CartChangeProductInfoModel.self)
        }
        model.innoProductList = list
        return model
    }
    
}
final class CartChangeProductInfoModel: NSObject, JSONAbleType {
    
    var message:String?       //单个商品处理状态    string
    var productName:String?      // 商品名称（商品名 + 通用名）    string
    var shoppingCartId :String?     // 购物车ID    number
    var specification:String?       ///商品规格    string
    var statusCode:String?       //处理状态    string
    @objc static func fromJSON(_ json: [String : AnyObject]) ->CartChangeProductInfoModel {
        let json = JSON(json)
        let model = CartChangeProductInfoModel()
        model.message = json["message"].stringValue
        model.productName = json["productName"].stringValue
        model.shoppingCartId = json["shoppingCartId"].stringValue
        model.specification = json["specification"].stringValue
        model.statusCode = json["statusCode"].stringValue
        return model
    }
}
