//
//  FKYRebteSellerModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/2/25.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class FKYRebteSellerModel: NSObject,JSONAbleType {
    /// 商家名称
    var enterprise_name = ""
    /// 商家ID
    var seller_code = ""
    
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYRebteSellerModel {
        let json = JSON(json)
        let model = FKYRebteSellerModel()
        model.enterprise_name = json["enterprise_name"].stringValue
        model.seller_code = json["seller_code"].stringValue
        return model
    }
}
//MARK:查询药福利开店信息
final class FKYYflInfoModel: NSObject,JSONAbleType {
    //shopStoreInfo中字段(店铺信息)
    var addr : String = "" //总店，分店，单体店详细地址
    var bankCity : String = "" //开户行城市名称
    var bankCityId : Int? //开户行城市id
    var bankCode : String = "" //开户行银行编码
    var bankCodeName : String = "" //开户行编码名称
    
    var bankName : String = "" //开户行名称
    var bankNum : String = "" //开户行卡号
    var bankProvince : String = "" //开户行省份名称
    var bankProvinceId : Int? //开户行省份id
    var bankUserName : String = "" //开户户名
    
    //var employeeVOList : String? //店铺员工信息，分店或单体店bd添加的店铺店员信息
    var enterpriseId : Int? //药城企业id
    var enterpriseType : Int? //药城企业类型
    var mobilePhone : String = "" //管理员，店长手机号码
    var status : Int? //店铺状态 0 账户注册成功，1-3账户认证中 4 待审核 5审核通过 6 审核不通过 7 下架 8
    
    var statusName : String = "" //店铺状态文描
    var storeName : String = "" //用户名称，管理员名称，店长名称
    //var subStoreAccountVOList : String? //分店信息，客户类型为连锁总店时，bd添加的分店信息
    var userName : String = "" //店铺名称
    var ycSupplyId : String = "" //药城供应商id
    var ycSupplyName : String = "" //ycSupplyName
    
    // BDInfo中字段(bd信息)
    var mobile : String = "" //手机号
    var name : String = "" //名称
    
    //enterPriseInfo中字段(企业信息)
    var enterpriseName : String = "" //账户名(企业名称)
    /// 企业信息中的ID
    var enterpriseIdInEnterPriseInfo:String = ""
    
    /// 后台要回传的参数，我也不知道代表什么
    var roleTypeValue = ""
    
    //mainLocalInfo中字段 (主仓信息)
    var mainEnterpriseId : String = ""//主仓企业id
    var mainEnterpriseName : String = "" //主仓企业名称
    var virtualId : Int? //主仓药福利专区id
    
    //userInfo(用户信息)
    var infoUsername : String = "" //账户名称
    
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYYflInfoModel {
        let json = JSON(json)
        let model = FKYYflInfoModel()
        if let shopInfo = json["shopStoreInfo"].dictionary  {
            let dic = JSON(shopInfo)
            model.addr = dic["addr"].stringValue
            model.bankCity = dic["bankCity"].stringValue
            model.bankCityId = dic["bankCityId"].intValue
            model.bankCode = dic["bankCode"].stringValue
            model.bankCodeName = dic["bankCodeName"].stringValue
            
            model.bankName = dic["bankName"].stringValue
            model.bankNum = dic["bankNum"].stringValue
            model.bankProvince = dic["bankProvince"].stringValue
            model.bankProvinceId = dic["bankProvinceId"].intValue
            model.bankUserName = dic["bankUserName"].stringValue
            
            // model.employeeVOList = json["employeeVOList"].stringValue
            model.enterpriseId = dic["enterpriseId"].intValue
            model.enterpriseType = dic["enterpriseType"].intValue
            model.mobilePhone = dic["mobilePhone"].stringValue
            model.status = dic["status"].intValue
            
            model.statusName = dic["statusName"].stringValue
            model.storeName = dic["storeName"].stringValue
            //model.subStoreAccountVOList = json["subStoreAccountVOList"].stringValue
            model.userName = dic["userName"].stringValue
            model.ycSupplyId = dic["ycSupplyId"].stringValue
            model.ycSupplyName = dic["ycSupplyName"].stringValue
        }
        
        if let shopInfo = json["BDInfo"].dictionary  {
            let dic = JSON(shopInfo)
            model.mobile = dic["mobile"].stringValue
            model.name = dic["name"].stringValue
        }
        if let shopInfo = json["enterPriseInfo"].dictionary  {
            let dic = JSON(shopInfo)
            model.enterpriseName = dic["enterpriseName"].stringValue
            model.enterpriseIdInEnterPriseInfo = dic["enterpriseId"].stringValue
            model.roleTypeValue = dic["roleTypeValue"].stringValue
        }
        if let shopInfo = json["mainLocalInfo"].dictionary  {
            let dic = JSON(shopInfo)
            model.mainEnterpriseId = dic["enterpriseId"].stringValue
            model.mainEnterpriseName = dic["enterpriseName"].stringValue
            model.virtualId = dic["virtualId"].intValue
        }
        if let shopInfo = json["userInfo"].dictionary  {
            let dic = JSON(shopInfo)
            model.infoUsername = dic["username"].stringValue
        }
        return model
    }
}


