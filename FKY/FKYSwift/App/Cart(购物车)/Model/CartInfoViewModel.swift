//
//  CartInfoViewModel.swift
//  FKY
//
//  Created by 寒山 on 2019/12/2.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class CartInfoViewModel: NSObject, JSONAbleType {
    var allCanUsecouponAmount: NSNumber?     //所有可用卷金额
    var allTotalAmount: NSNumber?     //包含套餐优惠金额的总金额
    var discountAmount: NSNumber?               //    购物车折扣/满减金额
    var checkedProducts: Int?                  //购物车选中的商品品种总计
    var checkedProductCounts: Int?                  //购物车选中的商品数量总计
    var checkedRebateProducts: Int?  //选中的返利商品种类数
    var freight: NSNumber?  //  购物车运费
    var invalidCount: Int?                 //失效品种数
    var checkedAll: Bool?    //   是否全选    boolean    @mock=false
    var payAmount: NSNumber?          //    购物车应付金额    number    @mock=1010
    var shareStockDesc: String?                   //调货提示
    var rebateAmount: NSNumber?   //   购物车返利总金额    number    @mock=9
    var totalAmount: NSNumber?    //  购物车总金额   number    @mock=9
    var appShowMoney: NSNumber?    //  app购物车总额（未减满减金额，不包含邮费）
    var productsCount: Int?    //    购物车品种总数    number    @mock=8
    var supplyCartList: [CartMerchantInfoModel]?           // 商品数据列表
    //var needAlertCartList:[ProductGroupListInfoModel]?            //需要弹窗的商品信息 商品数据列表
    var preferetialCarList : [CartMerchantInfoModel]?  //优惠明细的商铺
    // <Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) ->CartInfoViewModel {
        let json = JSON(json)
        let model = CartInfoViewModel()
        model.discountAmount = json["discountAmount"].numberValue
        model.checkedProducts = json["checkedProducts"].intValue
        model.checkedProductCounts = json["checkedProductCounts"].intValue
        model.invalidCount = json["invalidCount"].intValue
        model.freight = json["freight"].numberValue
        model.shareStockDesc = json["shareStockDesc"].stringValue
        model.checkedAll = json["checkedAll"].boolValue
        model.payAmount = json["payAmount"].numberValue
        model.productsCount = json["productsCount"].intValue
        model.rebateAmount = json["rebateAmount"].numberValue
        model.totalAmount = json["totalAmount"].numberValue
        model.appShowMoney = json["appShowMoney"].numberValue
        model.checkedRebateProducts = json["checkedRebateProducts"].intValue
        model.allCanUsecouponAmount = json["allCanUsecouponAmount"].number
        model.allTotalAmount = json["allTotalAmount"].numberValue
        let array = json["supplyCartList"].arrayObject
        var list: [CartMerchantInfoModel]? = []
        if let arr = array{
            list = (arr as NSArray).mapToObjectArray(CartMerchantInfoModel.self)
        }
        model.supplyCartList = list
        
//         let alterArray = json["needAlertCartList"].arrayObject
//          var alterList: [ProductGroupListInfoModel]? = []
//          if let arr = alterArray{
//              alterList = (arr as NSArray).mapToObjectArray(ProductGroupListInfoModel.self)
//          }
//          model.needAlertCartList = alterList
        
        if let carArr = model.supplyCartList {
            model.preferetialCarList = carArr.filter({ (cartMerchantInfoModel) -> Bool in
                if let num = cartMerchantInfoModel.totalAmount, num.doubleValue > 0 {
                    return true
                }else {
                    return false
                }
            })
        }
        
        return model
    }
}
