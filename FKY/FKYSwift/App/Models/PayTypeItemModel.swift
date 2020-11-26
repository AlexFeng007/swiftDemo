//
//  PayTypeItemModel.swift
//  FKY
//
//  Created by zengyao on 2018/3/15.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  支付方式model

import UIKit
import SwiftyJSON

final class PayTypeItemModel: NSObject, JSONAbleType {

    enum cellType {
        /// 正常展示的支付方式cell
        case payCell
        /// 有折叠隐藏的时候下面的点击展开cell
        case hideCell
    }
    var payTypeId: NSNumber? // 支付方式id
    var payTypeName: String? // 支付方式名称
    var payTypeDesc: String? // 支付方式描述(存储的时候，连带样式一起存)
    var payType: Int? // 1：在线支付 3：线下支付
    var picUrl: String? // 图片url
    var payTag: String? //     标签:定义数据字典对应样式
    var payTypeStatus: NSNumber? // 支付类型状态 0-可用 1-不可用
    var payTypeExcDesc: String? // 不可用支付状态描述
    var payTypeExcDescPicUrl: String? // 不可用支付状态角标
    var realName: String? // 持卡人姓名
    var idCardNo: String? // 身份证号
    var firstPay: Bool? // 是否使用过快捷支付
    /// 是否隐藏/折叠 空隐藏 1显示 0隐藏
    var showFlag: String = ""
    /// 角标文描
    var showMsgInfo: String = ""
    /// cell类型
    var cellType: cellType = .payCell
    /// 支付限额 针对银行卡支付的
    var limitDesc: String = ""

    convenience override init() {
        self.init(payTypeId: nil, payTypeName: nil, payTypeDesc: nil, payType: nil, picUrl: nil, payTag: nil, payTypeStatus: nil, payTypeExcDesc: nil, payTypeExcDescPicUrl: nil, realName: nil, idCardNo: nil, firstPay: false, showFlag: "", showMsgInfo: "",limitDesc:"")
    }

    init(payTypeId: NSNumber?, payTypeName: String?, payTypeDesc: String?, payType: Int?, picUrl: String?, payTag: String?, payTypeStatus: NSNumber?, payTypeExcDesc: String?, payTypeExcDescPicUrl: String?, realName: String?, idCardNo: String?, firstPay: Bool, showFlag: String, showMsgInfo: String, limitDesc: String) {
        super.init()
        self.payTypeId = payTypeId
        self.payTypeName = payTypeName
        self.payTypeDesc = payTypeDesc
        self.payType = payType
        self.picUrl = picUrl
        self.payTag = payTag
        self.payTypeStatus = payTypeStatus
        self.payTypeExcDesc = payTypeExcDesc
        self.payTypeExcDescPicUrl = payTypeExcDescPicUrl
        self.realName = realName
        self.idCardNo = idCardNo
        self.firstPay = firstPay
        self.showFlag = showFlag
        self.showMsgInfo = showMsgInfo
        self.limitDesc = limitDesc
    }

    // <Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String: AnyObject]) -> PayTypeItemModel {
        let j = JSON(json)
        let payTypeId = NSNumber.init(value: j["payTypeId"].intValue)
        let payTypeName = j["payTypeName"].stringValue
        let payTypeDesc = j["payTypeDesc"].stringValue
        let payType = j["payType"].intValue
        let picUrl = j["picUrl"].stringValue
        let payTag = j["payTag"].stringValue
        let payTypeStatus = NSNumber.init(value: j["payTypeStatus"].intValue)
        let payTypeExcDesc = j["payTypeExcDesc"].stringValue
        let payTypeExcDescPicUrl = j["payTypeExcDescPicUrl"].stringValue
        let realName = j["realName"].stringValue
        let idCardNo = j["idCardNo"].stringValue
        let firstPay = j["firstPay"].boolValue
        let showFlag = j["showFlag"].stringValue
        let showMsgInfo = j["showMsgInfo"].stringValue
        let limitDesc = j["limitDesc"].stringValue

        return PayTypeItemModel(payTypeId: payTypeId, payTypeName: payTypeName, payTypeDesc: payTypeDesc, payType: payType, picUrl: picUrl, payTag: payTag, payTypeStatus: payTypeStatus, payTypeExcDesc: payTypeExcDesc, payTypeExcDescPicUrl: payTypeExcDescPicUrl, realName: realName, idCardNo: idCardNo, firstPay: firstPay, showFlag: showFlag, showMsgInfo: showMsgInfo, limitDesc: limitDesc)
    }
}





