//
//  WXPayInfoModel.swift
//  FKY
//
//  Created by mahui on 2017/3/27.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class WXPayInfoModel: NSObject, JSONAbleType {
    @objc let appId : String?
    @objc let nonceStr : String?
    @objc let packageValue : String?
    @objc let partnerId : String?
    @objc let prepayId : String?
    @objc let sign : String?
    @objc let timeStamp : String?
    
    init(appId: String?,nonceStr: String?,packageValue: String?,partnerId: String?,prepayId: String?,sign: String?,timeStamp: String?) {
        self.appId = appId
        self.nonceStr = nonceStr
        self.packageValue = packageValue
        self.partnerId = partnerId
        self.prepayId = prepayId
        self.sign = sign
        self.timeStamp = timeStamp
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> WXPayInfoModel {
        let json = JSON(json)
        let appId = json["appId"].string
        let nonceStr = json["nonceStr"].string
        let packageValue = json["packageValue"].string
        let partnerId = json["partnerId"].string
        let prepayId = json["prepayId"].string
        let sign = json["sign"].string
        let timeStamp = json["timeStamp"].string
        
        return WXPayInfoModel(appId: appId, nonceStr: nonceStr, packageValue: packageValue, partnerId: partnerId, prepayId: prepayId, sign: sign, timeStamp: timeStamp)
    }
}
