//
//  FKYEnterQualificationModel.swift
//  FKY
//
//  Created by hui on 2019/11/4.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class FKYEnterQualificationModel : NSObject, JSONAbleType {
    // MARK: - properties
    var accountProcess : String?               //开户流程
    var businessScope : String?             //经营范围
    var introduce : String?       // 企业介绍
    var saleArea: String?    //销售区域
    var picArr :[FKYEnterQuaPicModel]? //资质文件
    
    var address : String? //注册地址
    var checkInTime : String? //入驻时间
    var enterpriseName : String? //企业（单位）名称
    var legalPersonName : String? //法定代表人
    var postalCode : String? //邮编
    var website : String? //网址
    //本地字段名称
    var titleArr = [String]()  //标题
    var contentArr = [String]() //内容
    /// 开户
    var account = ""
    /// 发票
    var invoice = ""
    /// 物流
    var deliveryInstruction = ""
    /// 售后
    var afterSale = ""
    
    // MARK: - life cycle
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYEnterQualificationModel {
        let json = JSON(json)
        
        let model = FKYEnterQualificationModel()
        model.accountProcess = json["accountProcess"].stringValue
        model.businessScope = json["businessScope"].stringValue
        model.introduce = json["introduce"].stringValue
        model.saleArea = json["saleArea"].stringValue
        model.account = json["account"].stringValue
        model.invoice = json["invoice"].stringValue
        model.deliveryInstruction = json["deliveryInstruction"].stringValue
        model.afterSale = json["afterSale"].stringValue
        
        if let list = json["files"].arrayObject {
            model.picArr = (list as NSArray).mapToObjectArray(FKYEnterQuaPicModel.self)
        }
        if let baseInfo = json["baseInfo"].dictionary {
            model.address = baseInfo["address"]?.stringValue
            model.checkInTime = baseInfo["checkInTime"]?.stringValue
            model.enterpriseName = baseInfo["enterpriseName"]?.stringValue
            model.legalPersonName = baseInfo["legalPersonName"]?.stringValue
            model.postalCode = baseInfo["postalCode"]?.stringValue
            model.website = baseInfo["website"]?.stringValue
        }
        if let str = model.enterpriseName,str.count > 0 {
            model.titleArr.append("企业名称")
            model.contentArr.append(str)
        }
        if let str = model.legalPersonName,str.count > 0 {
            model.titleArr.append("法定代表")
            model.contentArr.append(str)
        }
        if let str = model.address,str.count > 0 {
            model.titleArr.append("注册地址")
            model.contentArr.append(str)
        }
        if let str = model.postalCode,str.count > 0 {
            model.titleArr.append("邮        编")// 4个英文空格等于一个中文字符间距
            model.contentArr.append(str)
        }
        if let str = model.website,str.count > 0 {
            model.titleArr.append("企业网址")
            model.contentArr.append(str)
        }
        if let str = model.checkInTime,str.count > 0 {
            model.titleArr.append("入驻时间")
            model.contentArr.append(str)
        }
        
        return model
    }
}
//企业资质图片
final class FKYEnterQuaPicModel: NSObject, JSONAbleType {
    // MARK: - properties
    var filePath : String?            //文件路径
    var typeName : String?             //文件类型
    
    // MARK: - life cycle
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYEnterQuaPicModel {
        let json = JSON(json)
        
        let model = FKYEnterQuaPicModel()
        model.filePath = json["filePath"].stringValue
        model.typeName = json["typeName"].stringValue
        return model
    }
}
