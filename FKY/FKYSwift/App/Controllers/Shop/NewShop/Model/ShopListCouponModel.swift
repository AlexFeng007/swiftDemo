//
//  ShopListCouponModel.swift
//  FKY
//
//  Created by 乔羽 on 2018/12/4.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import SwiftyJSON

final class ShopListCouponModel: NSObject, JSONAbleType {
    // MARK: - properties
    var id : Int?
    var enterpriseId : String?
    var couponName : String?            // 优惠券名称
    var templateCode: String?
    var couponType: Int?
    var isLimitProduct: Int?            // 0-全部商品/1-部分单品
    var couponStartTime: String?
    var couponEndTime: String?
    var denomination: Int?              // 优惠券金额
    var limitprice: Int?                // 优惠券使用门槛
    var begindate: String?              // 开始时间
    var endDate: String?                // 结束时间
    var couponTimeText : String?
    var tempEnterpriseName: String?
    var shopLogo: String?               // 商家logo
    var couponCode: String?             // 已领取的优惠券码，不为空则表示已领取过了
    var couponFullName: String?{ //优惠券名称
       get {
           return String(format: "满%.f减%.f",(limitprice ?? 0),(denomination ?? 0))
       }
    }
    // MARK: - life cycle
    static func fromJSON(_ json: [String : AnyObject]) -> ShopListCouponModel {
        let json = JSON(json)
        
        let model = ShopListCouponModel()
        model.id = json["id"].intValue
        model.enterpriseId = json["enterpriseId"].stringValue
        model.couponName = json["couponName"].stringValue
        model.templateCode = json["templateCode"].stringValue
        model.couponType = json["couponType"].intValue
        model.isLimitProduct = json["isLimitProduct"].intValue
        model.couponStartTime = json["couponStartTime"].stringValue
        model.couponEndTime = json["couponEndTime"].stringValue
        model.denomination = json["denomination"].intValue
        model.limitprice = json["limitprice"].intValue
        model.begindate = json["begindate"].stringValue.removeHHMMSS()
        model.endDate = json["endDate"].stringValue.removeHHMMSS()
        model.couponTimeText = json["couponTimeText"].stringValue
        model.tempEnterpriseName = json["tempEnterpriseName"].stringValue
        model.shopLogo = json["formal_logo_pic"].stringValue
        model.couponCode = json["couponCode"].stringValue
        return model
    }
}
