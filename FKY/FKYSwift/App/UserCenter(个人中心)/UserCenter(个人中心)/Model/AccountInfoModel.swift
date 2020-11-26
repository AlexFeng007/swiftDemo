//
//  AccountInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2020/6/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class AccountInfoModel: NSObject, JSONAbleType {
    // 用户资产     createTime
    var accountRemain:NSNumber?
    //购物金
    var gwjBalance:NSNumber?
    //购物金提示文字
    var angleSignText:String?
    /**
     优惠券
     */
    var couponCount:Int?
    /**
     创建时间
     */
    var createTime:String?
    
    /**
     待发货  数量
     */
    var deliverNumber:Int?
    
    /**
     企业审核状态
     */
    var enterpriseAuditStatus:Int?
    /**
     企业id
     */
    var enterpriseId:Int?
    /**
     企业名字
     */
    var enterpriseName:String?
    
    /**
     上次登录时间
     */
    var lastLoginTime:String?
    /**
     手机号码
     */
    var mobile:String?
    
    /**
     资质数量
     */
    var qualificationCount:Int?
    
    /**
     待收货 数量
     */
    var reciveNumber:Int?
    /**
     用户显示名称
     */
    var showName:String?
    /**
     用户id
     */
    var uid:String?
    /**
     待付款 数量
     */
    var unPayNumber:Int?
    /**
     拒收/补货 数量//5.7.0版本开始不在使用
     */
    var unRejRep:Int?
    /**
     退换货/售后数量
     */
    var rmaCount:Int?
    //     待到账金额
    //     */
    var rebatePendingAmount:NSNumber?
    //    /**
    //     用户名
    //     */
    var userName:String?
    var tools: [AccountToolsModel]? // 工具栏列表
    var vipInfo: AccountVipDetailModel? // vip模型
    var yydInfo: AccountYYDInfoModel? //医药贷模型
    var shBankModel: ShBankModel? //上海银行
    var cellTypeArr = [AccountWallteCellType]() //本地处理字段
    static func fromJSON(_ json: [String : AnyObject]) -> AccountInfoModel {
        let json = JSON(json)
        let model = AccountInfoModel()
        model.accountRemain = json["accountRemain"].numberValue
        model.createTime = json["createTime"].stringValue
        model.deliverNumber = json["deliverNumber"].intValue
        model.couponCount = json["couponCount"].intValue
        model.enterpriseAuditStatus = json["enterpriseAuditStatus"].intValue
        model.enterpriseId = json["enterpriseId"].intValue
        model.enterpriseName = json["enterpriseName"].stringValue
        model.qualificationCount = json["qualificationCount"].intValue
        model.reciveNumber = json["reciveNumber"].intValue
        model.unPayNumber = json["unPayNumber"].intValue
        model.unRejRep = json["unRejRep"].intValue
        model.rmaCount = json["rmaCount"].intValue
        model.rebatePendingAmount = json["rebatePendingAmount"].numberValue
        model.gwjBalance = json["gwjBalance"].numberValue
        model.angleSignText = json["angleSignText"].stringValue
        model.lastLoginTime = json["lastLoginTime"].stringValue
        model.mobile = json["mobile"].stringValue
        model.showName = json["showName"].stringValue
        model.uid = json["uid"].stringValue
        model.userName = json["userName"].stringValue
        var toolList: [AccountToolsModel]?
        if let list = json["tools"].arrayObject {
            toolList = (list as NSArray).mapToObjectArray(AccountToolsModel.self)
        }
        model.tools = toolList
        
        let dic = json["vipInfo"].dictionaryObject
        if let _ = dic {
            let t = dic! as NSDictionary
            model.vipInfo = t.mapToObject(AccountVipDetailModel.self)
        }else{
            model.vipInfo = nil
        }
        
        let yydDic = json["yydInfo"].dictionaryObject
        if let _ = yydDic {
            let t = yydDic! as NSDictionary
            model.yydInfo = t.mapToObject(AccountYYDInfoModel.self)
        }else{
            model.yydInfo = nil
        }
        if let shDic = json["shBank"].dictionaryObject {
            model.shBankModel = (shDic as NSDictionary).mapToObject(ShBankModel.self)
        }
        
        model.cellTypeArr.append(.AccountWallteCellTypeShoppingMoney)
        model.cellTypeArr.append(.AccountWallteCellTypeRebate)
        model.cellTypeArr.append(.AccountWallteCellTypeCounple)
        
        if let shModel = model.shBankModel ,shModel.showFlag == true {
            //显示上银金融
            model.cellTypeArr.append(.AccountWallteCellTypeBanking)
        }
        if let  yydInfo = model.yydInfo,let yydShow = yydInfo.yydShow, yydShow == 1{
            //显示1药贷
            if let _ = yydInfo.roleType{
                model.cellTypeArr.append(.AccountWallteCellTypeLoan)
            }
        }
        return model
    }
}


final class ShBankModel: NSObject,JSONAbleType{
    var auditStatus:String? // 1:表示已申请通过 需要显示额度信息 * 2：表示审核未通过，需要显示不通过原因 * 3：表示未申请 需要跳转中间页 申请
    var avaliLimitTotal:Double?  //剩余可用总额度
    var entStatus:String?  // 企业状态(0：未激活；1：已激活；2：激活失败；3：待打款认证)
    var msg:String?   // 审核不通过原因
    var showFlag:Bool? //true:显示申请按钮
    var url:String?   // 注册url
    
    static func fromJSON(_ json: [String : AnyObject]) -> ShBankModel {
        let json = JSON(json)
        let model = ShBankModel()
        model.auditStatus = json["auditStatus"].stringValue
        model.avaliLimitTotal = json["avaliLimitTotal"].doubleValue
        model.entStatus = json["entStatus"].stringValue
        model.msg = json["msg"].stringValue
        model.showFlag = json["showFlag"].boolValue
        model.url = json["url"].stringValue
        return model
    }
}
