//
//  AccountYYYDInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2020/6/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class AccountYYDInfoModel: NSObject, JSONAbleType {
    ///**
    // *  质管审核状态（0：未审核，1：审核通过，2：审核未通过，3：待发货审核，4：变更待发货审核，5：资质过期）
    // */
    var isAudit:Int?
    ///**
    // *  BD审核状态 （0:待电子审核,1:审核通过,2:审核不通过,3:变更,5:变更待电子审核,7:变更审核不通过）
    // */
    var isCheck:Int?
    ///**
    // 1药贷是否过期
    // 1：过期 0：没过期
    // */
    var limitOverdue:Int?
    ///**
    // 跳转到h5或复兴的ur
    // */
    var returnUrl:String?
    ///**
    // *  企业类型
    // */
    var roleType:String?
    ///**
    // 1药贷申请状态
    // 01未开通 02审批中 05审核通过 03审核不通过 -1异常
    // */
    var status:String?
    ///**
    // 1药贷状态描述 本地字段
    // */
    var loanDesc:String?{
        get {
            if let isAuditIng = self.isAudit ,(isAuditIng == 1 || isAuditIng == 5) { //质管审核通过或资质过期
                if let isCheckIng = self.isCheck, (isCheckIng == 1 || isCheckIng == 3) {
                    // BD状态为审核通过或变更 / 用户不是单体药店/个体诊所 或 连锁总店/批发企业/非公立医疗机构(1药贷-对公)
                    if self.yydShow == 1 {
                        if let checkStatus = self.status{
                            if let limitOverdue = self.limitOverdue,limitOverdue == 1{
                                 return "额度过期"
                            }else{
                                if checkStatus == "01"{
                                    return "暂停申请" //"申请开通";
                                }else if checkStatus == "02"{
                                    return "审核中"
                                }else if checkStatus == "03"{
                                    return "审核不通过"
                                }else if checkStatus == "-1"{
                                    return "****"
                                }else if checkStatus == "05"{
                                    return String(format:"¥%.2f",(self.remainAmount?.doubleValue ?? 0.0))//"¥\(self.remainAmount?.floatValue ?? 0)"
                                }
                            }
                        }
                    }
                }
            }
            return "****"
        }
    }
    ///**
    // 本地字段判断是否显示提示new
    // */
    var hideTag:Bool?{
        if let isAuditIng = self.isAudit ,(isAuditIng == 1 || isAuditIng == 5) { //质管审核通过或资质过期
            if let isCheckIng = self.isCheck, (isCheckIng == 1 || isCheckIng == 3) {
                // BD状态为审核通过或变更
                if self.yydShow == 1 {
                    // 用户不是单体药店/个体诊所 或 连锁总店/批发企业/非公立医疗机构(1药贷-对公)
                    if let checkStatus = self.status,checkStatus == "01"{
                        return true// 现在暂停申请不显示new
                    }
                }
            }
        }
        return true
    }
    //
    ///**
    // 1药贷可用余额
    // */
    var remainAmount:NSNumber?
    ///**
    // 接口返回 0不显示，1显示
    // */
    var yydShow:Int?
    ///**
    //显示1药贷还是1药贷对公 接口返回
    // */
    var yydTitle:String?
    ///**
    // 1药贷标签
    // 1即将过期，0距离过期一月以上
    // */
    var aboutToExpire:Int?
    static func fromJSON(_ json: [String : AnyObject]) -> AccountYYDInfoModel {
        let json = JSON(json)
        let model = AccountYYDInfoModel()
        model.returnUrl = json["returnUrl"].stringValue
        model.isAudit = json["isAudit"].intValue
        model.isCheck = json["isCheck"].intValue
        model.aboutToExpire = json["aboutToExpire"].intValue
        model.limitOverdue = json["limitOverdue"].intValue
        model.remainAmount = json["remainAmount"].numberValue
        model.yydTitle = json["yydTitle"].stringValue
        
        model.yydShow = json["yydShow"].intValue
        model.status = json["status"].stringValue
        model.roleType = json["roleType"].stringValue
        return model
    }
}
