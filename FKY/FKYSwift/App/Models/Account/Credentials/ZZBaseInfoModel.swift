//
//  ZZBaseInfoModel.swift
//  FKY
//
//  Created by mahui on 2016/11/29.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SwiftyJSON

final class ZZBaseInfoModel: NSObject, JSONAbleType, ReverseJSONType {
    var id : Int?
    var enterpriseId : String? //
    var roleType : Int?  // 1: 终端, 2: 生产, 3: 批发
    var enterpriseName : String? // 企业名称
    var legalPersonname : String? // 企业法人
    var province : String?          // 省id
    var city : String?              // 市id
    var district : String?          // 区id
    var provinceName : String?      // 省名称
    var cityName : String?          // 市名称
    var districtName : String?      // 区名称
    var registeredAddress : String? // 注册地址
    var enterpriseCellphone : String?
    var contactsName : String?
    var enterpriseFax : String?
    var enterpriseTelephone : String?
    var enterprisePostcode : String?
    var bankName : String? // 银行名称
    var bankCode : String? // 银行账户
    var accountName : String? // 开名名
    var createUser : String?
    var createTime : Int?
    var updateTime : Int?
    var updateUser : String?
    var orderSAmount : String?  // 起售价格
    var isUse : String? //
    var isCheck : Int? // 资质审核状态...<根据不同状态来判断资质信息是否可修改>
    var isAudit : Int? //
    var enterpriseCode : String? //
    var is3merge1 : Int? // 是否三证合一
    var isEmpty: Bool = true //
    var type_id: Int? // 用户修改后的企业类型id
    var hasLicense: Int? // 是否有营业执照（1：有营业执照，0：没有营业执照）
    var isWholesaleRetail: Int? // 是否批零一体（1：批零一体，0：非批零一体）
    
    var addressProvinceDetail: ProvinceModel? {   // 详细注册地址
        willSet {
            if let prov = newValue {
                self.province = prov.infoCode
                self.provinceName = prov.infoName
                if let cityArray = prov.secondModel, cityArray.count > 0 {
                    let city = cityArray.first!
                    self.city = city.infoCode
                    self.cityName = city.infoName
                    if let districtArray = city.secondModel, districtArray.count > 0 {
                        let district = districtArray.first!
                        self.district = district.infoCode
                        self.districtName = district.infoName
                    }
                }
            }
        }
    }
    
    var addressDetailDesc: String {
        var content = ""
        if let province = addressProvinceDetail, let pname = province.infoName {
            content = pname
            if let city = province.secondModel?.first, let cname = city.infoName {
                content = content + " " + cname
                if let district = city.secondModel?.first, let dname = district.infoName {
                    content = content + " " + dname
                }
            }
        }
        if let add = registeredAddress {
            content = content + " " + add
        }
        return content
    }
    
    var addressDetailDescForShow: String {
        var content = ""
        if let add = registeredAddress, (add as NSString).length > 0 {
            if let province = addressProvinceDetail, let pname = province.infoName {
                content = pname
                if let city = province.secondModel?.first, let cname = city.infoName {
                    content = content + " " + cname
                    if let district = city.secondModel?.first, let dname = district.infoName {
                        content = content + " " + dname
                    }
                }
            }
            if let add = registeredAddress {
                content = content + " " + add
            }
        }
        return content
    }
    
    var addressJustLocation: String {
        var content = ""
        if let province = addressProvinceDetail, let pname = province.infoName {
            content = pname
            if let city = province.secondModel?.first, let cname = city.infoName {
                content = content + " " + cname
                if let district = city.secondModel?.first, let dname = district.infoName {
                    content = content + " " + dname
                }
            }
        }
        return content
    }
    
    // 页面存储介质
    override init() {
        isEmpty = true
    }
    
        // JSON 解析
    init(id:Int?,enterpriseId:String?,roleType:Int?,enterpriseName:String?,legalPersonname:String?,province:String?,city:String?,district:String?,provinceName:String?,cityName:String?,districtName:String?,registeredAddress:String?,enterpriseCellphone:String?,contactsName:String?,enterpriseFax:String?,enterpriseTelephone:String?,enterprisePostcode:String?,bankName:String?,bankCode:String?,accountName:String?,createUser:String?,createTime:Int?,updateTime:Int?,updateUser:String?,orderSAmount:String?,isUse:String?,isCheck:Int?,isAudit:Int?,enterpriseCode:String?,is3merge1 : Int?, isWholesaleRetail: Int?, hasLicense: Int?) {
        isEmpty = false
        
        self.id = id
        self.enterpriseId = enterpriseId
        self.roleType = roleType
        self.enterpriseName = enterpriseName
        self.legalPersonname = legalPersonname
        self.province = province
        self.city = city
        self.district = district
        self.provinceName = provinceName
        self.cityName = cityName
        self.districtName = districtName
        self.registeredAddress = registeredAddress
        self.enterpriseCellphone = enterpriseCellphone
        self.contactsName = contactsName
        self.enterpriseFax = enterpriseFax
        self.enterpriseTelephone = enterpriseTelephone
        self.enterprisePostcode = enterprisePostcode
        self.bankName = bankName
        self.bankCode = bankCode
        self.accountName = accountName
        self.createUser = createUser
        self.createTime = createTime
        self.updateTime = updateTime
        self.updateUser = updateUser
        self.orderSAmount = orderSAmount
        self.isUse = isUse
        self.isCheck = isCheck
        self.isAudit = isAudit
        self.enterpriseCode = enterpriseCode
        self.is3merge1 = is3merge1
        self.isWholesaleRetail = isWholesaleRetail
        self.hasLicense = hasLicense
        
        let districtModel = ProvinceModel(infoCode: self.district, infoName: self.districtName, secondModel: nil)
        let cityModel = ProvinceModel(infoCode: self.city, infoName: self.cityName, secondModel: [districtModel])
        let provinceModel = ProvinceModel(infoCode: self.province, infoName: self.provinceName, secondModel: [cityModel])
        self.addressProvinceDetail = provinceModel
    }
    
    static func fromJSON(_ data: [String : AnyObject]) -> ZZBaseInfoModel {
        let json = JSON(data)
        let id = json["id"].intValue
        let enterpriseId = json["enterpriseId"].stringValue
        let roleType = json["roleType"].intValue
        let enterpriseName  = json["enterpriseName"].stringValue
        let legalPersonname  = json["legalPersonname"].stringValue
        let province  = json["province"].stringValue
        let city  = json["city"].stringValue
        let district  = json["district"].stringValue
        let provinceName  = json["provinceName"].stringValue
        let cityName  = json["cityName"].stringValue
        let districtName  = json["districtName"].stringValue
        let registeredAddress  = json["registeredAddress"].stringValue
        let enterpriseCellphone  = json["enterpriseCellphone"].stringValue
        let contactsName  = json["contactsName"].stringValue
        let enterpriseFax  = json["enterpriseFax"].stringValue
        let enterpriseTelephone  = json["enterpriseTelephone"].stringValue
        let enterprisePostcode  = json["enterprisePostcode"].stringValue
        let bankName  = json["bankName"].stringValue
        let bankCode = json["bankCode"].stringValue
        let accountName = json["accountName"].stringValue
        let createUser = json["createUser"].stringValue
        let createTime  = json["createTime"].intValue
        let updateTime = json["updateTime"].intValue
        let updateUser = json["updateUser"].stringValue
        let orderSAmount = json["orderSAmount"].stringValue
        let isUse = json["isUse"].stringValue
        let isCheck = json["isCheck"].intValue
        let isAudit = json["isAudit"].intValue
        let enterpriseCode = json["enterpriseCode"].stringValue
        let is3merge1 = json["is3merge1"].intValue
        let isWholesaleRetail = json["is_wholesale_retail"].intValue
        let hasLicense = json["has_license"].intValue
        
        return ZZBaseInfoModel.init(id: id, enterpriseId: enterpriseId, roleType: roleType, enterpriseName: enterpriseName, legalPersonname: legalPersonname, province: province, city: city, district: district, provinceName: provinceName, cityName: cityName, districtName: districtName, registeredAddress: registeredAddress, enterpriseCellphone: enterpriseCellphone, contactsName: contactsName, enterpriseFax: enterpriseFax, enterpriseTelephone: enterpriseTelephone, enterprisePostcode: enterprisePostcode, bankName: bankName, bankCode: bankCode, accountName: accountName, createUser: createUser, createTime: createTime, updateTime: updateTime, updateUser: updateUser, orderSAmount: orderSAmount, isUse: isUse, isCheck: isCheck,isAudit: isAudit, enterpriseCode: enterpriseCode, is3merge1: is3merge1, isWholesaleRetail: isWholesaleRetail, hasLicense: hasLicense)
    }
    
    func reverseJSON() -> [String: AnyObject] {
        var params = ["id" : "" ,
                      "enterpriseId" : "" ,
                      "roleType" : "" ,
                      "enterpriseName" : "" ,
                      "legalPersonname" : "" ,
                      "province" : "" ,
                      "city" : "" ,
                      "district" : "" ,
                      "provinceName" : "" ,
                      "cityName" : "" ,
                      "districtName" : "" ,
                      "registeredAddress" : "" ,
                      "enterpriseCellphone" : "" ,
                      "contactsName" : "" ,
                      "enterpriseFax" : "" ,
                      "enterpriseTelephone" : "" ,
                      "enterprisePostcode" : "" ,
                      "bankName" : "" ,
                      "bankCode" : "" ,
                      "accountName" : "" ,
                      "createUser" : "" ,
                      "createTime" : "" ,
                      "updateTime" : "" ,
                      "updateUser" : "" ,
                      "orderSAmount" : "" ,
                      "isUse" : "" ,
                      "isCheck" : "" ,
                      "isAudit" : "" ,
                      "enterpriseCode" : "" ,
                      "is3merge1" : "",
                      "is_wholesale_retail" : "",
                      "has_license" : ""]
        
        if self.id != nil {
            params["id"] = "\(self.id!)"
        }
        
        if self.enterpriseId != nil {
            params["enterpriseId"] = self.enterpriseId!
        }
        
        if self.roleType != nil {
            params["roleType"] = "\(self.roleType!)"
        }
        
        if self.enterpriseName != nil {
            params["enterpriseName"] = self.enterpriseName!
        }
        
        if self.legalPersonname != nil {
            params["legalPersonname"] = self.legalPersonname!
        }
        
        if self.province != nil {
            params["province"] = self.province!
        }
        
        if self.city != nil {
            params["city"] = self.city!
        }
        
        if self.district != nil {
            params["district"] = self.district!
        }
        
        if self.provinceName != nil {
            params["provinceName"] = self.provinceName!
        }
        
        if self.cityName != nil {
            params["cityName"] = self.cityName!
        }
        
        if self.districtName != nil {
            params["districtName"] = self.districtName!
        }
        
        if self.registeredAddress != nil {
            params["registeredAddress"] = self.registeredAddress!
        }
        
        if self.enterpriseCellphone != nil {
            params["enterpriseCellphone"] = self.enterpriseCellphone!
        }
        
        if self.contactsName != nil {
            params["contactsName"] = self.contactsName!
        }
        
        if self.enterpriseFax != nil {
            params["enterpriseFax"] = self.enterpriseFax!
        }
        
        if self.enterpriseTelephone != nil {
            params["enterpriseTelephone"] = self.enterpriseTelephone!
        }
        
        if self.enterprisePostcode != nil {
            params["enterprisePostcode"] = self.enterprisePostcode!
        }
        
        if self.bankName != nil {
            params["bankName"] = self.bankName!
        }
        
        if self.bankCode != nil {
            params["bankCode"] = self.bankCode!
        }
        
        if self.accountName != nil {
            params["accountName"] = self.accountName!
        }
        
        if self.orderSAmount != nil { 
            params["orderSAmount"] = self.orderSAmount! 
        } 
        
        if self.isUse != nil { 
            params["isUse"] = self.isUse! 
        } 
        
        if self.isCheck != nil { 
            params["isCheck"] = "\(self.isCheck!)"
        }
        
        if self.isAudit != nil {
            params["isAudit"] = "\(self.isAudit!)"
        }
        
        if self.enterpriseCode != nil { 
            params["enterpriseCode"] = self.enterpriseCode! 
        } 
        
        if self.is3merge1 != nil { 
            params["is3merge1"] = "\(self.is3merge1!)"
        }
        
        if self.isWholesaleRetail != nil {
            params["is_wholesale_retail"] = "\(self.isWholesaleRetail!)"
        }
        
        if self.hasLicense != nil {
            params["has_license"] = "\(self.hasLicense!)"
        }
        
        return params as [String : AnyObject]
    }

    func reverseJSONFirst() -> [String: AnyObject] {
        var params = ["id" : "" ,
                      "enterpriseId" : "" ,
                      "roleType" : "" ,
                      "enterpriseName" : "" ,
                      "legalPersonname" : "" ,
                      "province" : "" ,
                      "city" : "" ,
                      "district" : "" ,
                      "provinceName" : "" ,
                      "cityName" : "" ,
                      "districtName" : "" ,
                      "registeredAddress" : "" ,
                      "enterpriseCellphone" : "" ,
                      "contactsName" : "" ,
                      "enterpriseFax" : "" ,
                      "enterpriseTelephone" : "" ,
                      "enterprisePostcode" : "" ,
                      "bankName" : "" ,
                      "bankCode" : "" ,
                      "accountName" : "" ,
                      "createUser" : "" ,
                      "createTime" : "" ,
                      "updateTime" : "" ,
                      "updateUser" : "" ,
                      "orderSAmount" : "" ,
                      "isUse" : "" ,
                      "isCheck" : "" ,
                      "isAudit" : "" ,
                      "is3merge1" : "",
                      "is_wholesale_retail" : "",
                      "has_license": ""]
        
        if self.id != nil {
            params["id"] = "\(self.id!)"
        }
        
        if self.enterpriseId != nil {
            params["enterpriseId"] = self.enterpriseId!
        }
        
        if self.roleType != nil {
            params["roleType"] = "\(self.roleType!)"
        }
        
        if self.enterpriseName != nil {
            params["enterpriseName"] = self.enterpriseName!
        }
        
        if self.legalPersonname != nil {
            params["legalPersonname"] = self.legalPersonname!
        }
        
        if self.province != nil {
            params["province"] = self.province!
        }
        
        if self.city != nil {
            params["city"] = self.city!
        }
        
        if self.district != nil {
            params["district"] = self.district!
        }
        
        if self.provinceName != nil {
            params["provinceName"] = self.provinceName!
        }
        
        if self.cityName != nil {
            params["cityName"] = self.cityName!
        }
        
        if self.districtName != nil {
            params["districtName"] = self.districtName!
        }
        
        if self.registeredAddress != nil {
            params["registeredAddress"] = self.registeredAddress!
        }
        
        if self.enterpriseCellphone != nil {
            params["enterpriseCellphone"] = self.enterpriseCellphone!
        }
        
        if self.contactsName != nil {
            params["contactsName"] = self.contactsName!
        }
        
        if self.enterpriseFax != nil {
            params["enterpriseFax"] = self.enterpriseFax!
        }
        
        if self.enterpriseTelephone != nil {
            params["enterpriseTelephone"] = self.enterpriseTelephone!
        }
        
        if self.enterprisePostcode != nil {
            params["enterprisePostcode"] = self.enterprisePostcode!
        }
        
        if self.bankName != nil {
            params["bankName"] = self.bankName!
        }
        
        if self.bankCode != nil {
            params["bankCode"] = self.bankCode!
        }
        
        if self.accountName != nil {
            params["accountName"] = self.accountName!
        }
        
        if self.orderSAmount != nil {
            params["orderSAmount"] = self.orderSAmount!
        }
        
        if self.isUse != nil {
            params["isUse"] = self.isUse!
        }
        
        if self.isCheck != nil {
            params["isCheck"] = "\(self.isCheck!)"
        }
        
        if self.isAudit != nil {
            params["isAudit"] = "\(self.isAudit!)"
        }
        
        if self.is3merge1 != nil {
            params["is3merge1"] = "\(self.is3merge1!)"
        }
        
        if self.isWholesaleRetail != nil {
            params["is_wholesale_retail"] = "\(self.isWholesaleRetail!)"
        }
        
        if self.hasLicense != nil {
            params["has_license"] = "\(self.hasLicense!)"
        }
        
        return params as [String : AnyObject]
    }
}
