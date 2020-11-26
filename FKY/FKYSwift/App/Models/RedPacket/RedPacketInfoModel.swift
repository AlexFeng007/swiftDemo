//
//  RedPacketInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2019/1/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class RedPacketInfoModel: NSObject, JSONAbleType {
    var redPacketImage: String?    //
    var showRedPacket: Bool?      //
    var subTitle: String?    //
    
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>
    static func fromJSON(_ json: [String : AnyObject]) ->RedPacketInfoModel {
        let json = JSON(json)
        
        let model = RedPacketInfoModel()
        model.redPacketImage = json["redPacketImage"].stringValue
        model.showRedPacket = json["showRedPacket"].boolValue
        model.subTitle = json["subTitle"].stringValue
        
        return model
    }
}

final class RedPacketDetailInfoModel: NSObject, JSONAbleType {
    var losingBtnDesc : String?//未中奖按钮文描
    var losingDesc : String?//未中奖文描
    var losingJumpUrl : String?//未中奖按钮跳转地址
    var redPacketConfId: String?    //红包配置id
    var status: String?   //状态,0-未抽奖,1--已中奖,2--未中奖
    var winningBtnDesc: String?    //中奖按钮文描
    var winningJumpUrl: String?    //中奖按钮跳转地址
    var couponDto: RedPacketCouponInfoModel? //优惠券对象
    
    var showshopName: Bool = false //自定义店铺标签显示与否
    var shopNameH: CGFloat = 0.0 //自定义店铺标签的高度
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>
    static func fromJSON(_ json: [String : AnyObject]) ->RedPacketDetailInfoModel {
        let json = JSON(json)
        
        let model = RedPacketDetailInfoModel()
        model.losingBtnDesc = json["losingBtnDesc"].stringValue
        model.losingDesc = json["losingDesc"].stringValue
        model.losingJumpUrl = json["losingJumpUrl"].stringValue
        model.redPacketConfId = json["redPacketConfId"].stringValue
        model.status = json["status"].stringValue
        model.winningBtnDesc = json["winningBtnDesc"].stringValue
        model.winningJumpUrl = json["winningJumpUrl"].stringValue
        var rpCouponInfo: RedPacketCouponInfoModel?
        let dic = json["couponDto"].dictionaryObject
        if let _ = dic {
            let t = dic! as NSDictionary
            rpCouponInfo = t.mapToObject(RedPacketCouponInfoModel.self)
        }else{
            rpCouponInfo = nil
        }
        model.couponDto = rpCouponInfo
        
        return model
    }
}

final class RedPacketCouponInfoModel: NSObject, JSONAbleType {
    var denomination : Float? //优惠券面值
    var begindate: String?    //开始时间
    var couponCode: String?        //优惠券号
    var couponName: String?    //优惠券描述
    var couponSource: String?    //
    var couponTempCode: String?    //
    var couponTempId: String?    //
    var endDate: String?    //结束时间
    var enterpriseId: String?    //
    var id: String?    //
    var isLimitProduct: String?    //
    var isLimitShop: String?    //是否限制店铺0 不限 1限制
    var limitprice: Float?    //使用限制金额
    var sendStatus: String?    //
    var status: String?    //
    var tempType: String?    //
    var couponDtoShopList : Array<RedPacketCouponShopInfoModel>? //
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>
    static func fromJSON(_ json: [String : AnyObject]) ->RedPacketCouponInfoModel {
        let json = JSON(json)
        
        let model = RedPacketCouponInfoModel()
        model.denomination = json["denomination"].floatValue
        model.couponCode = json["couponCode"].stringValue
        model.couponName = json["couponName"].stringValue
        model.couponSource = json["couponSource"].stringValue
        model.couponTempCode = json["couponTempCode"].stringValue
        model.couponTempId = json["couponTempId"].stringValue
        //解析时间
        let endStr = (json["endDate"].stringValue as NSString).substring(to: 10)
        let beginStr = (json["begindate"].stringValue as NSString).substring(to: 10)
        model.endDate = (endStr as NSString).replacingOccurrences(of: "-", with: ".")
        model.begindate = (beginStr as NSString).replacingOccurrences(of: "-", with: ".")
        model.enterpriseId = json["enterpriseId"].stringValue
        model.id = json["id"].stringValue
        model.isLimitProduct = json["isLimitProduct"].stringValue
        model.isLimitShop = json["isLimitShop"].stringValue
        model.limitprice = json["limitprice"].floatValue
        model.sendStatus = json["sendStatus"].stringValue
        model.status = json["status"].stringValue
        model.tempType = json["tempType"].stringValue
        
        let couponDtoShopList = json["couponDtoShopList"].arrayObject
        var shopList: [RedPacketCouponShopInfoModel]? = []
        if let list = couponDtoShopList{
            shopList = (list as NSArray).mapToObjectArray(RedPacketCouponShopInfoModel.self)
        }
        model.couponDtoShopList = shopList
        
        return model
    }
}

final class RedPacketCouponShopInfoModel: NSObject, JSONAbleType {
    var tempEnterpriseId: String?    //
    var tempEnterpriseName: String?    //
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>
    static func fromJSON(_ json: [String : AnyObject]) ->RedPacketCouponShopInfoModel {
        let json = JSON(json)
        let model = RedPacketCouponShopInfoModel()
        model.tempEnterpriseId = json["tempEnterpriseId"].stringValue
        model.tempEnterpriseName = json["tempEnterpriseName"].stringValue
        
        return model
    }
}

