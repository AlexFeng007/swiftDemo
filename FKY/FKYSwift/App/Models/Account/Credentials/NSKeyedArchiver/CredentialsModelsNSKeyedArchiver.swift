//
//  CredentialsModelsNSKeyedArchiver.swift
//  FKY
//
//  Created by airWen on 2017/7/26.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import Foundation


// MARK: - NSKeyedArchiver For DrugScopeModel
extension DrugScopeModel: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(drugScopeId, forKey: "drugScopeId")
        aCoder.encode(drugScopeName, forKey: "drugScopeName")
        aCoder.encode(selected, forKey: "selected")
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        let drugScopeId = aDecoder.decodeObject(forKey: "drugScopeId") as! String
        let drugScopeName = aDecoder.decodeObject(forKey: "drugScopeName") as! String
        let selected = aDecoder.decodeBool(forKey: "selected")
        self.init(drugScopeId: drugScopeId, drugScopeName: drugScopeName, selected:selected)
    }
}


// MARK: - NSKeyedArchiver For ZZReceiveAddressModel
extension ZZReceiveAddressModel: NSCoding {
    func encode(with aCoder: NSCoder) {
        if let id = self.id {
            aCoder.encode(id, forKey: "id")
        }else{
            aCoder.encode(0, forKey: "id")
        }
        
        if let enterpriseId = self.enterpriseId {
            aCoder.encode(enterpriseId, forKey: "enterpriseId")
        }else {
            aCoder.encode("", forKey: "enterpriseId")
        }
        
        if let receiverName = self.receiverName {
            aCoder.encode(receiverName, forKey: "receiverName")
        }else {
            aCoder.encode("", forKey: "receiverName")
        }
        
        if let provinceCode = self.provinceCode {
            aCoder.encode(provinceCode, forKey: "provinceCode")
        }else {
            aCoder.encode("", forKey: "provinceCode")
        }
        
        if let cityCode = self.cityCode {
            aCoder.encode(cityCode, forKey: "cityCode")
        }else {
            aCoder.encode("", forKey: "cityCode")
        }
        
        if let districtCode = self.districtCode {
            aCoder.encode(districtCode, forKey: "districtCode")
        }else {
            aCoder.encode("", forKey: "districtCode")
        }
        
        if let avenu_code = self.avenu_code {
            aCoder.encode(avenu_code, forKey: "avenu_code")
        }else {
            aCoder.encode("", forKey: "avenu_code")
        }
        
        if let provinceName = self.provinceName {
            aCoder.encode(provinceName, forKey: "provinceName")
        }else {
            aCoder.encode("", forKey: "provinceName")
        }
        
        if let cityName = self.cityName {
            aCoder.encode(cityName, forKey: "cityName")
        }else {
            aCoder.encode("", forKey: "cityName")
        }
        
        if let districtName = self.districtName {
            aCoder.encode(districtName, forKey: "districtName")
        }else {
            aCoder.encode("", forKey: "districtName")
        }
        
        if let avenu_name = self.avenu_name {
            aCoder.encode(avenu_name, forKey: "avenu_name")
        }else {
            aCoder.encode("", forKey: "avenu_name")
        }
        
        if let address = self.address {
            aCoder.encode(address, forKey: "address")
        }else {
            aCoder.encode("", forKey: "address")
        }
        
        if let print_address = self.print_address {
            aCoder.encode(print_address, forKey: "print_address")
        }else {
            aCoder.encode("", forKey: "print_address")
        }
        
        if let contactPhone = self.contactPhone {
            aCoder.encode(contactPhone, forKey: "contactPhone")
        }else {
            aCoder.encode("", forKey: "contactPhone")
        }
        
        if let defaultAddress = self.defaultAddress {
            aCoder.encode(defaultAddress, forKey: "defaultAddress")
        }else {
            aCoder.encode(0, forKey: "defaultAddress")
        }
        
        if let purchaser = self.purchaser {
            aCoder.encode(purchaser, forKey: "purchaser")
        }else {
            aCoder.encode(0, forKey: "purchaser")
        }
        
        if let purchaser_phone = self.purchaser_phone {
            aCoder.encode(purchaser_phone, forKey: "purchaser_phone")
        }else {
            aCoder.encode(0, forKey: "purchaser_phone")
        }
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        let enterpriseId = aDecoder.decodeObject(forKey: "enterpriseId") as? String
        let receiverName = aDecoder.decodeObject(forKey: "receiverName") as? String
        let provinceCode = aDecoder.decodeObject(forKey: "provinceCode") as? String
        let cityCode = aDecoder.decodeObject(forKey: "cityCode") as? String
        let districtCode = aDecoder.decodeObject(forKey: "districtCode") as? String
        let avenu_code = aDecoder.decodeObject(forKey: "avenu_code") as? String
        let provinceName = aDecoder.decodeObject(forKey: "provinceName") as? String
        let cityName = aDecoder.decodeObject(forKey: "cityName") as? String
        let districtName = aDecoder.decodeObject(forKey: "districtName") as? String
        let avenu_name = aDecoder.decodeObject(forKey: "avenu_name") as? String
        let address = aDecoder.decodeObject(forKey: "address") as? String
        let print_address = aDecoder.decodeObject(forKey: "print_address") as? String
        let contactPhone = aDecoder.decodeObject(forKey: "contactPhone") as? String
        let purchaser = aDecoder.decodeObject(forKey: "purchaser") as? String
        let purchaser_phone = aDecoder.decodeObject(forKey: "purchaser_phone") as? String
        let id = aDecoder.decodeInteger(forKey: "id")
        let defaultAddress = aDecoder.decodeInteger(forKey: "defaultAddress")
        self.init(id: id, enterpriseId: enterpriseId, receiverName: receiverName,provinceCode: provinceCode, cityCode: cityCode, districtCode: districtCode, avenu_code: avenu_code, provinceName: provinceName, cityName: cityName,districtName: districtName, avenu_name: avenu_name, address: address, print_address: print_address, contactPhone: contactPhone,defaultAddress: defaultAddress, purchaser: purchaser, purchaserPhone: purchaser_phone)
    }
}


// MARK: - NSKeyedArchiver For ZZBaseInfoModel
extension ZZBaseInfoModel: NSCoding {
    func encode(with aCoder: NSCoder) {
        if let id = self.id {
            aCoder.encode(id, forKey: "id")
        }else{
            aCoder.encode(0, forKey: "id")
        }
        
        if let roleType = self.roleType {
            aCoder.encode(roleType, forKey: "roleType")
        }else{
            aCoder.encode(0, forKey: "roleType")
        }
        
        if let enterpriseName = self.enterpriseName {
            aCoder.encode(enterpriseName, forKey: "enterpriseName")
        }else {
            aCoder.encode("", forKey: "enterpriseName")
        }
        
        if let legalPersonname = self.legalPersonname {
            aCoder.encode(legalPersonname, forKey: "legalPersonname")
        }else {
            aCoder.encode("", forKey: "legalPersonname")
        }
        
        if let province = self.province {
            aCoder.encode(province, forKey: "province")
        }else {
            aCoder.encode("", forKey: "province")
        }
        
        if let city = self.city {
            aCoder.encode(city, forKey: "city")
        }else {
            aCoder.encode("", forKey: "city")
        }
        
        if let district = self.district {
            aCoder.encode(district, forKey: "district")
        }else {
            aCoder.encode("", forKey: "district")
        }
        
        if let provinceName = self.provinceName {
            aCoder.encode(provinceName, forKey: "provinceName")
        }else {
            aCoder.encode("", forKey: "provinceName")
        }
        
        if let cityName = self.cityName {
            aCoder.encode(cityName, forKey: "cityName")
        }else {
            aCoder.encode("", forKey: "cityName")
        }
        
        if let districtName = self.districtName {
            aCoder.encode(districtName, forKey: "districtName")
        }else {
            aCoder.encode("", forKey: "districtName")
        }
        
        if let registeredAddress = self.registeredAddress {
            aCoder.encode(registeredAddress, forKey: "registeredAddress")
        }else {
            aCoder.encode("", forKey: "registeredAddress")
        }
        
        if let enterpriseCellphone = self.enterpriseCellphone {
            aCoder.encode(enterpriseCellphone, forKey: "enterpriseCellphone")
        }else {
            aCoder.encode("", forKey: "enterpriseCellphone")
        }
        
        if let contactsName = self.contactsName {
            aCoder.encode(contactsName, forKey: "contactsName")
        }else {
            aCoder.encode("", forKey: "contactsName")
        }
        
        if let enterpriseFax = self.enterpriseFax {
            aCoder.encode(enterpriseFax, forKey: "enterpriseFax")
        }else {
            aCoder.encode("", forKey: "enterpriseFax")
        }
        
        if let enterpriseTelephone = self.enterpriseTelephone {
            aCoder.encode(enterpriseTelephone, forKey: "enterpriseTelephone")
        }else {
            aCoder.encode("", forKey: "enterpriseTelephone")
        }
        
        if let enterprisePostcode = self.enterprisePostcode {
            aCoder.encode(enterprisePostcode, forKey: "enterprisePostcode")
        }else {
            aCoder.encode("", forKey: "enterprisePostcode")
        }
        
        if let bankName = self.bankName {
            aCoder.encode(bankName, forKey: "bankName")
        }else {
            aCoder.encode("", forKey: "bankName")
        }
        
        if let bankCode = self.bankCode {
            aCoder.encode(bankCode, forKey: "bankCode")
        }else {
            aCoder.encode("", forKey: "bankCode")
        }
        
        if let accountName = self.accountName {
            aCoder.encode(accountName, forKey: "accountName")
        }else {
            aCoder.encode("", forKey: "accountName")
        }
        
        if let createUser = self.createUser {
            aCoder.encode(createUser, forKey: "createUser")
        }else {
            aCoder.encode("", forKey: "createUser")
        }
        
        if let updateUser = self.updateUser {
            aCoder.encode(updateUser, forKey: "updateUser")
        }else {
            aCoder.encode("", forKey: "updateUser")
        }
        
        if let orderSAmount = self.orderSAmount {
            aCoder.encode(orderSAmount, forKey: "orderSAmount")
        }else {
            aCoder.encode("", forKey: "orderSAmount")
        }
        
        if let isUse = self.isUse {
            aCoder.encode(isUse, forKey: "isUse")
        }else {
            aCoder.encode("", forKey: "isUse")
        }
        
        if let isCheck = self.isCheck {
            aCoder.encode(isCheck, forKey: "isCheck")
        }else{
            aCoder.encode(0, forKey: "isCheck")
        }
        
        if let isAudit = self.isAudit {
            aCoder.encode(isAudit, forKey: "isAudit")
        }else{
            aCoder.encode(0, forKey: "isAudit")
        }
        
        if let enterpriseCode = self.enterpriseCode {
            aCoder.encode(enterpriseCode, forKey: "enterpriseCode")
        }else {
            aCoder.encode("", forKey: "enterpriseCode")
        }
        
        if let is3merge1 = self.is3merge1 {
            aCoder.encode(is3merge1, forKey: "is3merge1")
        }
        
        if let isWholesaleRetail = self.isWholesaleRetail {
            aCoder.encode(isWholesaleRetail, forKey: "isWholesaleRetail")
        }
        
        if let hasLicense = self.hasLicense {
            aCoder.encode(hasLicense, forKey: "hasLicense")
        }
        
        //no createTime and updateTime
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
//        let enterpriseId = aDecoder.decodeObjectForKey("enterpriseId") as? String
        let roleType = aDecoder.decodeInteger(forKey: "roleType")
        let enterpriseName = aDecoder.decodeObject(forKey: "enterpriseName") as? String
        let legalPersonname = aDecoder.decodeObject(forKey: "legalPersonname") as? String
        let province = aDecoder.decodeObject(forKey: "province") as? String
        let city = aDecoder.decodeObject(forKey: "city") as? String
        let district = aDecoder.decodeObject(forKey: "district") as? String
        let provinceName = aDecoder.decodeObject(forKey: "provinceName") as? String
        let cityName = aDecoder.decodeObject(forKey: "cityName") as? String
        let districtName = aDecoder.decodeObject(forKey: "districtName") as? String
        let registeredAddress = aDecoder.decodeObject(forKey: "registeredAddress") as? String
        let enterpriseCellphone = aDecoder.decodeObject(forKey: "enterpriseCellphone") as? String
        let contactsName = aDecoder.decodeObject(forKey: "contactsName") as? String
        let enterpriseFax = aDecoder.decodeObject(forKey: "enterpriseFax") as? String
        let enterpriseTelephone = aDecoder.decodeObject(forKey: "enterpriseTelephone") as? String
        let enterprisePostcode = aDecoder.decodeObject(forKey: "enterprisePostcode") as? String
        let bankName = aDecoder.decodeObject(forKey: "bankName") as? String
        let bankCode = aDecoder.decodeObject(forKey: "bankCode") as? String
        let accountName = aDecoder.decodeObject(forKey: "accountName") as? String
        let createUser = aDecoder.decodeObject(forKey: "createUser") as? String
        
        let updateUser = aDecoder.decodeObject(forKey: "updateUser") as? String
        let orderSAmount = aDecoder.decodeObject(forKey: "orderSAmount") as? String
        let isUse = aDecoder.decodeObject(forKey: "isUse") as? String
        let isCheck = aDecoder.decodeInteger(forKey: "isCheck")
        let isAudit = aDecoder.decodeInteger(forKey: "isAudit")
        let enterpriseCode = aDecoder.decodeObject(forKey: "enterpriseCode") as? String
        let is3merge1 = aDecoder.decodeInteger(forKey: "is3merge1")
        let isWholesaleRetail = aDecoder.decodeInteger(forKey: "isWholesaleRetail")
        let hasLicense = aDecoder.decodeInteger(forKey: "hasLicense")
        self.init(id:id,enterpriseId:"",roleType:roleType,enterpriseName:enterpriseName,legalPersonname:legalPersonname,province:province,city:city,district:district,provinceName:provinceName,cityName:cityName,districtName:districtName,registeredAddress:registeredAddress,enterpriseCellphone:enterpriseCellphone,contactsName:contactsName,enterpriseFax:enterpriseFax,enterpriseTelephone:enterpriseTelephone,enterprisePostcode:enterprisePostcode,bankName:bankName,bankCode:bankCode,accountName:accountName,createUser:createUser,createTime:0,updateTime:0,updateUser:updateUser,orderSAmount:orderSAmount,isUse:isUse,isCheck:isCheck,isAudit:isAudit,enterpriseCode:enterpriseCode,is3merge1: is3merge1, isWholesaleRetail: isWholesaleRetail, hasLicense: hasLicense)
    }
    
    func hashString() -> String {
        var hashString = ""
        
        if let roleType = roleType {
            hashString += "\(roleType)"
        }
        if let enterpriseName = enterpriseName {
            hashString += ";\(enterpriseName)"
        }else{
            hashString += ";"
        }
        if let province = province {
            hashString += ";\(province)"
        }else{
            hashString += ";"
        }
        if let city = city {
            hashString += ";\(city)"
        }else{
            hashString += ";"
        }
        if let district = district {
            hashString += ";\(district)"
        }else{
            hashString += ";"
        }
        if let provinceName = provinceName {
            hashString += ";\(provinceName)"
        }else{
            hashString += ";"
        }
        if let cityName = cityName {
            hashString += ";\(cityName)"
        }else{
            hashString += ";"
        }
        if let districtName = districtName {
            hashString += ";\(districtName)"
        }else{
            hashString += ";"
        }
        if let registeredAddress = registeredAddress {
            hashString += ";\(registeredAddress)"
        }else{
            hashString += ";"
        }
        if let bankName = bankName {
            hashString += ";\(bankName)"
        }else{
            hashString += ";"
        }
        if let bankCode = bankCode {
            hashString += ";\(bankCode)"
        }else{
            hashString += ";"
        }
        if let accountName = accountName {
            hashString += ";\(accountName)"
        }else{
            hashString += ";"
        }
        if let orderSAmount = orderSAmount {
            hashString += ";\(orderSAmount)"
        }else{
            hashString += ";"
        }
        if let is3merge1 = is3merge1 {
            hashString += ";\(is3merge1)"
        }else{
            hashString += ";"
        }
        if let isWholesaleRetail = isWholesaleRetail {
            hashString += ";\(isWholesaleRetail)"
        }else{
            hashString += ";"
        }
        if let hasLicense = hasLicense {
            hashString += ";\(hasLicense)"
        }else{
            hashString += ";"
        }
        return hashString
    }
}


// MARK: - NSKeyedArchiver For ZZAllInOneBaseInfoModel
extension ZZAllInOneBaseInfoModel: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(enterpriseName ?? "", forKey: "enterpriseName")
        aCoder.encode(provinceName ?? "", forKey: "provinceName")
        aCoder.encode(cityName ?? "", forKey: "cityName")
        aCoder.encode(districtName ?? "", forKey: "districtName")
        aCoder.encode(province ?? "", forKey: "province")
        aCoder.encode(city ?? "", forKey: "city")
        aCoder.encode(district ?? "", forKey: "district")
        aCoder.encode(registeredAddress ?? "", forKey: "registeredAddress")
        aCoder.encode(shopNum ?? 0, forKey: "shopNum")
        aCoder.encode(is3merge1 ?? 0, forKey: "is3merge1")
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        let enterpriseName = aDecoder.decodeObject(forKey: "enterpriseName") as! String
        let provinceName = aDecoder.decodeObject(forKey: "provinceName") as! String
        let cityName = aDecoder.decodeObject(forKey: "cityName") as! String
        let districtName = aDecoder.decodeObject(forKey: "districtName") as! String
        let province = aDecoder.decodeObject(forKey: "province") as! String
        let city = aDecoder.decodeObject(forKey: "city") as! String
        let district = aDecoder.decodeObject(forKey: "district") as! String
        let registeredAddress = aDecoder.decodeObject(forKey: "registeredAddress") as! String
        let shopNum = aDecoder.decodeInteger(forKey: "shopNum")
        let is3merge1 = aDecoder.decodeInteger(forKey: "is3merge1")
        self.init(enterpriseName: enterpriseName, provinceName: provinceName, cityName: cityName, districtName: districtName, province: province, city: city, district: district, registeredAddress: registeredAddress, shopNum: shopNum, is3merge1: is3merge1)
    }
    
    func hashString() -> String {
        var hashString = ""
        
        if let enterpriseName = enterpriseName {
            hashString += "\(enterpriseName)"
        }
        if let provinceName = provinceName {
            hashString += ";\(provinceName)"
        } else {
            hashString += ";"
        }
        if let cityName = cityName {
            hashString += ";\(cityName)"
        } else {
            hashString += ";"
        }
        if let districtName = districtName {
            hashString += ";\(districtName)"
        } else {
            hashString += ";"
        }
        if let province = province {
            hashString += ";\(province)"
        } else {
            hashString += ";"
        }
        if let city = city {
            hashString += ";\(city)"
        } else {
            hashString += ";"
        }
        if let district = district {
            hashString += ";\(district)"
        } else {
            hashString += ";"
        }
        if let registeredAddress = registeredAddress {
            hashString += ";\(registeredAddress)"
        } else {
            hashString += ";"
        }
        if let shopNum = shopNum {
            hashString += ";\(shopNum)"
        } else {
            hashString += ";"
        }
        if let is3merge1 = is3merge1 {
            hashString += ";\(is3merge1)"
        } else {
            hashString += ";"
        }
        return hashString
    }
}


// MARK:-  NSKeyedArchiver For ZZFileModel
extension ZZFileModel: NSCoding {
    func encode(with aCoder: NSCoder) {
        if let id = self.id {
            aCoder.encode(id, forKey: "id")
        }else {
            aCoder.encode(0, forKey: "id")
        }
        
        if let enterpriseId = self.enterpriseId {
            aCoder.encode(enterpriseId, forKey: "enterpriseId")
        }else {
            aCoder.encode(0, forKey: "enterpriseId")
        }
        
        aCoder.encode(typeId, forKey: "typeId")
        
        if let starttime = self.starttime {
            aCoder.encode(starttime, forKey: "starttime")
        }else {
            aCoder.encode("", forKey: "starttime")
        }
        
        if let endtime = self.endtime {
            aCoder.encode(endtime, forKey: "endtime")
        }else {
            aCoder.encode("", forKey: "endtime")
        }
        
        if let qualificationNo = self.qualificationNo {
            aCoder.encode(qualificationNo, forKey: "qualificationNo")
        }else {
            aCoder.encode("", forKey: "qualificationNo")
        }
        
        if let filePath = self.filePath {
            aCoder.encode(filePath, forKey: "filePath")
        }else {
            aCoder.encode("", forKey: "filePath")
        }
        
        if let remark = self.remark {
            aCoder.encode(remark, forKey: "remark")
        }else {
            aCoder.encode("", forKey: "remark")
        }
        
        if let createUser = self.createUser {
            aCoder.encode(createUser, forKey: "createUser")
        }else {
            aCoder.encode("", forKey: "createUser")
        }
        
        if let updateUser = self.updateUser {
            aCoder.encode(updateUser, forKey: "updateUser")
        }else {
            aCoder.encode("", forKey: "updateUser")
        }
        
        if let authOrg = self.authOrg {
            aCoder.encode(authOrg, forKey: "authOrg")
        }else {
            aCoder.encode("", forKey: "authOrg")
        }
        
        if let fileId = self.fileId {
            aCoder.encode(fileId, forKey: "fileId")
        }else {
            aCoder.encode("", forKey: "fileId")
        }
        
        if let fileName = self.fileName {
            aCoder.encode(fileName, forKey: "fileName")
        }else {
            aCoder.encode("", forKey: "fileName")
        }
        
        if let rawStartTime = self.rawStartTime {
            aCoder.encode(rawStartTime, forKey: "rawStartTime")
        }else {
            aCoder.encode("", forKey: "rawStartTime")
        }
        
        if let rawEndTime = self.rawEndTime {
            aCoder.encode(rawEndTime, forKey: "rawEndTime")
        }else {
            aCoder.encode("", forKey: "rawEndTime")
        }
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let enterpriseId = aDecoder.decodeInteger(forKey: "enterpriseId")
        let typeId = aDecoder.decodeInteger(forKey: "typeId")
        let qualificationNo = aDecoder.decodeObject(forKey: "qualificationNo") as? String
        let starttime = aDecoder.decodeObject(forKey: "starttime") as? String
        let endtime = aDecoder.decodeObject(forKey: "endtime") as? String
        let filePath = aDecoder.decodeObject(forKey: "filePath") as? String
        let remark = aDecoder.decodeObject(forKey: "remark") as? String
        let createUser = aDecoder.decodeObject(forKey: "createUser") as? String
        let updateUser = aDecoder.decodeObject(forKey: "updateUser") as? String
        let authOrg = aDecoder.decodeObject(forKey: "authOrg") as? String
        let fileId = aDecoder.decodeObject(forKey: "fileId") as? String
        let fileName = aDecoder.decodeObject(forKey: "fileName") as? String
        let rawStartTime = aDecoder.decodeObject(forKey: "rawStartTime") as? String
        let rawEndTime = aDecoder.decodeObject(forKey: "rawEndTime") as? String
        let expiredRemark = aDecoder.decodeObject(forKey: "expiredRemark") as? String
               let expiredType = aDecoder.decodeObject(forKey: "expiredType") as? String
        self.init(id:id,enterpriseId:enterpriseId,typeId:typeId,qualificationNo:qualificationNo,starttime:starttime,endtime:endtime,filePath:filePath,authOrg:authOrg,remark:remark,createUser:createUser,createTime:0,updateTime:0,updateUser:updateUser,fileId:fileId,fileName:fileName,rawStartTime:rawStartTime,rawEndTime:rawEndTime,expiredRemark:expiredRemark,expiredType:expiredType)
    }
}


// MARK: - NSKeyedArchiver For ZZAllInOneFileModel
extension ZZAllInOneFileModel: NSCoding {
    func encode(with aCoder: NSCoder) {
        if let enterpriseId = self.enterpriseId {
            aCoder.encode(enterpriseId, forKey: "enterpriseId")
        }else {
            aCoder.encode(0, forKey: "enterpriseId")
        }
        
        aCoder.encode(typeId, forKey: "typeId")
        
        if let id = self.id {
            aCoder.encode(id, forKey: "id")
        }else {
            aCoder.encode(0, forKey: "id")
        }
        
        if let starttime = self.starttime {
            aCoder.encode(starttime, forKey: "starttime")
        }else {
            aCoder.encode("", forKey: "starttime")
        }
        
        if let endtime = self.endtime {
            aCoder.encode(endtime, forKey: "endtime")
        }else {
            aCoder.encode("", forKey: "endtime")
        }
        
        if let qualificationNo = self.qualificationNo {
            aCoder.encode(qualificationNo, forKey: "qualificationNo")
        }else {
            aCoder.encode("", forKey: "qualificationNo")
        }
        
        if let filePath = self.filePath {
            aCoder.encode(filePath, forKey: "filePath")
        }else {
            aCoder.encode("", forKey: "filePath")
        }

        if let fileId = self.fileId {
            aCoder.encode(fileId, forKey: "fileId")
        }else {
            aCoder.encode("", forKey: "fileId")
        }
        
        if let fileName = self.fileName {
            aCoder.encode(fileName, forKey: "fileName")
        }else {
            aCoder.encode("", forKey: "fileName")
        }
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        let enterpriseId = aDecoder.decodeInteger(forKey: "enterpriseId")
        let typeId = aDecoder.decodeInteger(forKey: "typeId")
        let id = aDecoder.decodeInteger(forKey: "id")
        let qualificationNo = aDecoder.decodeObject(forKey: "qualificationNo") as? String
        let starttime = aDecoder.decodeObject(forKey: "starttime") as? String
        let endtime = aDecoder.decodeObject(forKey: "endtime") as? String
        let filePath = aDecoder.decodeObject(forKey: "filePath") as? String
        let fileId = aDecoder.decodeObject(forKey: "fileId") as? String
        let fileName = aDecoder.decodeObject(forKey: "fileName") as? String
        let expiredRemark = aDecoder.decodeObject(forKey: "expiredRemark") as? String
        let expiredType = aDecoder.decodeObject(forKey: "expiredType") as? String
        self.init(enterpriseId: enterpriseId, typeId: typeId, filePath: filePath, fileId: fileId, fileName: fileName, qualificationNo: qualificationNo, starttime: starttime, endtime: endtime, id: id,expiredRemark:expiredRemark,expiredType:expiredType)
    }
}


// MARK: - NSKeyedArchiver For SalesDestrictModel
extension SalesDestrictModel: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(provinceName, forKey: "provinceName")
        aCoder.encode(provinceCode, forKey: "provinceCode")
        aCoder.encode(cityName, forKey: "cityName")
        aCoder.encode(cityCode, forKey: "cityCode")
        aCoder.encode(districtName, forKey: "districtName")
        aCoder.encode(districtCode, forKey: "districtCode")
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        let provinceName = aDecoder.decodeObject(forKey: "provinceName") as! String
        let provinceCode = aDecoder.decodeObject(forKey: "provinceCode") as! String
        let cityName = aDecoder.decodeObject(forKey: "cityName") as! String
        let cityCode = aDecoder.decodeObject(forKey: "cityCode") as! String
        let districtName = aDecoder.decodeObject(forKey: "districtName") as! String
        let districtCode = aDecoder.decodeObject(forKey: "districtCode") as! String
        self.init(provinceName: provinceName, provinceCode: provinceCode, cityName: cityName, cityCode: cityCode, districtName: districtName, districtCode: districtCode)
    }
}


// MARK: - NSKeyedArchiver For EnterpriseOriginTypeModel
extension EnterpriseOriginTypeModel: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(typeId, forKey: "typeId")
        aCoder.encode(paramCode, forKey: "paramCode")
        aCoder.encode(paramName, forKey: "paramName")
        aCoder.encode(paramValue, forKey: "paramValue")
        aCoder.encode(remark, forKey: "remark")
        aCoder.encode(selected, forKey: "selected")
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        let typeId = aDecoder.decodeObject(forKey: "typeId") as! String
        let paramCode = aDecoder.decodeObject(forKey: "paramCode") as! String
        let paramName = aDecoder.decodeObject(forKey: "paramName") as! String
        let paramValue = aDecoder.decodeObject(forKey: "paramValue") as! String
        let remark = aDecoder.decodeObject(forKey: "remark") as! String
        let selected = aDecoder.decodeBool(forKey: "selected")
        self.init(typeId: typeId, paramCode: paramCode, paramName: paramName, paramValue: paramValue, remark: remark, createUser: "", createTime: "", updateTime: "", updateUser: "", selected: selected)
    }
}


// MARK: - NSKeyedArchiver For ZZQualityAuditModel
extension ZZQualityAuditModel: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(shortName, forKey: "shortName")
        aCoder.encode(isAudit, forKey: "isAudit")
        aCoder.encode(isAuditfailedReason, forKey: "isAuditfailedReason")
        aCoder.encode(seller_code, forKey: "seller_code")
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        let shortName = aDecoder.decodeObject(forKey: "shortName") as! String
        let isAudit = aDecoder.decodeObject(forKey: "isAudit") as! String
        let isAuditfailedReason = aDecoder.decodeObject(forKey: "isAuditfailedReason") as! String
        let seller_code = aDecoder.decodeObject(forKey: "seller_code") as! String
        self.init(shortName: shortName, isAudit: isAudit, isAuditfailedReason: isAuditfailedReason, seller_code: seller_code)
    }
}


// MARK: - NSKeyedArchiver For EnterpriseChooseModel
extension EnterpriseChooseModel: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(typeId, forKey: "typeId")
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let typeId = aDecoder.decodeObject(forKey: "typeId") as! String
        self.init(name: name, typeId: typeId)
    }
}


// MARK: - NSKeyedArchiver For ZZBankInfoModel
extension ZZBankInfoModel: NSCoding {
    func encode(with aCoder: NSCoder) {
        if let bankName = self.bankName {
            aCoder.encode(bankName, forKey: "bankName")
        }else{
            aCoder.encode("", forKey: "bankName")
        }
        
        if let bankCode = self.bankCode {
            aCoder.encode(bankCode, forKey: "bankCode")
        }else{
            aCoder.encode("", forKey: "bankCode")
        }
        
        if let accountName = self.accountName {
            aCoder.encode(accountName, forKey: "accountName")
        }else{
            aCoder.encode("", forKey: "accountName")
        }
        
        if let QCFile = self.QCFile {
            aCoder.encode(QCFile, forKey: "QCFile")
        }else{
            aCoder.encode(ZZFileModel(), forKey: "bankName")
        }
    }
}


// MARK: - NSKeyedArchiver For ZZRefuseReasonModel
extension ZZRefuseReasonModel: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id ?? 0, forKey: "id")
        aCoder.encode(enterpriseId ?? 0, forKey: "enterpriseId")
        aCoder.encode(type ?? 0, forKey: "type")
        aCoder.encode(status ?? 0, forKey: "status")
        aCoder.encode(failedReason ?? "", forKey: "failedReason")
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id")
        let enterpriseId = aDecoder.decodeObject(forKey: "enterpriseId")
        let type = aDecoder.decodeObject(forKey: "type")
        let status = aDecoder.decodeObject(forKey: "status")
        let failedReason = aDecoder.decodeObject(forKey: "failedReason") as! String
        self.init(id: id as? Int, enterpriseId: enterpriseId as? Int, type: type as? Int, status: status as? Int, failedReason: failedReason)
    }
}


// MARK: - NSKeyedArchiver For ZZAllInOneRefuseReasonModel
extension ZZAllInOneRefuseReasonModel: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(type ?? 0, forKey: "type")
        aCoder.encode(status ?? 0, forKey: "status")
        aCoder.encode(failedReason ?? "", forKey: "failedReason")
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        let type = aDecoder.decodeObject(forKey: "type")
        let status = aDecoder.decodeObject(forKey: "status")
        let failedReason = aDecoder.decodeObject(forKey: "failedReason") as! String
        self.init(type: type as? Int, status: status as? Int, failedReason: failedReason)
    }
}


//MARK: - 为企业基本资料的保存分开存储信息 ZZModelQCListInfoPartInfo 
class ZZModelQCListInfoPartInfo: NSObject, NSCoding {
    var qcList : [ZZFileModel]?
    var qualificationRetailList: [ZZAllInOneFileModel]?
    var isWholesaleRetail: Int?
    var is3merge1 : Int?
    var is3merge2 : Int?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(qcList, forKey: "qcList")
        aCoder.encode(qualificationRetailList, forKey: "qualificationRetailList")
        if let isWholesaleRetail = isWholesaleRetail {
            aCoder.encode(isWholesaleRetail, forKey: "isWholesaleRetail")
        }
        if let is3merge1 = is3merge1 {
            aCoder.encode(is3merge1, forKey: "is3merge1")
        }
        if let is3merge2 = is3merge2 {
            aCoder.encode(is3merge2, forKey: "is3merge2")
        }
    }
    
    init(qcList : [ZZFileModel]?, qualificationRetailList: [ZZAllInOneFileModel]?, is3merge1 : Int?, is3merge2 : Int?, isWholesaleRetail : Int?) {
        self.qcList = qcList
        self.qualificationRetailList = qualificationRetailList
        self.is3merge1 = is3merge1
        self.is3merge2 = is3merge2
        self.isWholesaleRetail = isWholesaleRetail
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let qcList = aDecoder.decodeObject(forKey: "qcList") as? [ZZFileModel]
        let qualificationRetailList = aDecoder.decodeObject(forKey: "qualificationRetailList") as? [ZZAllInOneFileModel]
        let is3merge1 = aDecoder.decodeInteger(forKey: "is3merge1")
        let is3merge2 = aDecoder.decodeInteger(forKey: "is3merge2")
        let isWholesaleRetail = aDecoder.decodeInteger(forKey: "isWholesaleRetail")
        self.init(qcList: qcList, qualificationRetailList: qualificationRetailList, is3merge1: is3merge1, is3merge2: is3merge2, isWholesaleRetail: isWholesaleRetail)
    }
    
    //MARK: qcList
    func qcListHashString() -> String {
        var hashString = ""
        
        if let qcArray = qcList, let filePaths = (qcArray as NSArray).value(forKeyPath: "filePath"){
            if let filePathsString = (filePaths as? NSArray)?.componentsJoined(by: ",") {
                hashString += ";\(filePathsString)"
            }else{
                hashString += ";"
            }
        }else{
            hashString += ";"
        }
        
        if let qrArray = qualificationRetailList, let filePaths = (qrArray as NSArray).value(forKeyPath: "filePath"){
            if let filePathsString = (filePaths as? NSArray)?.componentsJoined(by: ",") {
                hashString += ";\(filePathsString)"
            }else{
                hashString += ";"
            }
        }else{
            hashString += ";"
        }
        
        if let is3merge1 = is3merge1 {
            hashString += ";\(is3merge1)"
        }
        
        if let is3merge2 = is3merge2 {
            hashString += ";\(is3merge2)"
        }
        
        if let isWholesaleRetail = isWholesaleRetail {
            hashString += ";\(isWholesaleRetail)"
        }
        return hashString
    }
    
    static func qcListHashString(_ qcList : [ZZFileModel]?, qualificationRetailList: [ZZAllInOneFileModel]?, is3merge1 : Int?, is3merge2 : Int?, isWholesaleRetail : Int?) -> String {
        var hashString = ""
        
        if let qcList = qcList, let filePaths = (qcList as NSArray).value(forKeyPath: "filePath"){
            if let filePathsString = (filePaths as? NSArray)?.componentsJoined(by: ",") {
                hashString += ";\(filePathsString)"
            }else{
                hashString += ";"
            }
        }else{
            hashString += ";"
        }
        
        if let qrArray = qualificationRetailList, let filePaths = (qrArray as NSArray).value(forKeyPath: "filePath"){
            if let filePathsString = (filePaths as? NSArray)?.componentsJoined(by: ",") {
                hashString += ";\(filePathsString)"
            }else{
                hashString += ";"
            }
        }else{
            hashString += ";"
        }
        
        if let is3merge1 = is3merge1 {
            hashString += ";\(is3merge1)"
        }
        
        if let is3merge2 = is3merge2 {
            hashString += ";\(is3merge2)"
        }
        
        if let isWholesaleRetail = isWholesaleRetail {
            hashString += ";\(isWholesaleRetail)"
        }
        
        return hashString
    }
    
    // 缓存资质上传数据
    func saveQCList() {
        let dataKeyedArchiver = NSKeyedArchiver.archivedData(withRootObject: self)
        let userDefault = UserDefaults.standard
        userDefault.set(dataKeyedArchiver, forKey: "FKY.CredentialsQCListInfo")
        userDefault.synchronize()
    }
    
    // 清除资质上传数据
    @objc static func removeQCList() {
        DispatchQueue.global().async {
            let userDefault = UserDefaults.standard
            userDefault.removeObject(forKey: "FKY.CredentialsQCListInfo")
            userDefault.synchronize()
        }
    }
    
    // 读取资质上传数据
    @objc static func getQCListInfo() -> ZZModelQCListInfoPartInfo? {
        //反序列化：还原GameData对象
        let userDefault = UserDefaults.standard
        if let dataObject = userDefault.object(forKey: "FKY.CredentialsQCListInfo") as? Data {
            if let zzModel = NSKeyedUnarchiver.unarchiveObject(with: dataObject) as? ZZModelQCListInfoPartInfo {
                return zzModel
            }
        }
        return nil
    }
}


// MARK: - NSKeyedArchiver For ZZModel
extension ZZModel: NSCoding {
    // 编码
    func encode(with aCoder: NSCoder) {
        aCoder.encode(drugScopeList, forKey: "drugScopeList")
        aCoder.encode(receiverAddressList, forKey: "receiverAddressList")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(enterprise, forKey: "enterprise")
        aCoder.encode(enterpriseRetail, forKey: "enterpriseRetail")
        aCoder.encode(qcList, forKey: "qcList")
        aCoder.encode(qualification, forKey: "qualification")
        aCoder.encode(qualificationRetailList, forKey: "qualificationRetailList")
        aCoder.encode(deliveryAreaList, forKey: "deliveryAreaList")
        aCoder.encode(listTypeInfo, forKey: "listTypeInfo")
        aCoder.encode(qualityAuditList, forKey: "qualityAuditList")
        aCoder.encode(enterpriseTypeList, forKey: "enterpriseTypeList")
        aCoder.encode(bankInfoModel, forKey: "bankInfoModel")
        aCoder.encode(canModifyName, forKey: "canModifyName")
        aCoder.encode(inviteCode, forKey: "inviteCode")
        aCoder.encode(userName, forKey: "userName")
        aCoder.encode(isAuditfailedReason, forKey: "isAuditfailedReason")
    }
    
    // 解码
    convenience init?(coder aDecoder: NSCoder) {
        let drugScopeList = aDecoder.decodeObject(forKey: "drugScopeList") as? [DrugScopeModel]
        let receiverAddressList = aDecoder.decodeObject(forKey: "receiverAddressList") as? [ZZReceiveAddressModel]
        let rulesAddressList = aDecoder.decodeObject(forKey: "address") as? [ZZReceiveAddressModel]
        let enterprise = aDecoder.decodeObject(forKey: "enterprise") as? ZZBaseInfoModel
        let enterpriseRetail = aDecoder.decodeObject(forKey: "enterpriseRetail") as? ZZAllInOneBaseInfoModel
        let qcList = aDecoder.decodeObject(forKey: "qcList") as? [ZZFileModel]
        let qualification = aDecoder.decodeObject(forKey: "qualification") as? [ZZFileModel]
        let qualificationRetailList = aDecoder.decodeObject(forKey: "qualificationRetailList") as? [ZZAllInOneFileModel]
        let deliveryAreaList = aDecoder.decodeObject(forKey: "deliveryAreaList") as? [SalesDestrictModel]
        let listTypeInfo = aDecoder.decodeObject(forKey: "listTypeInfo") as? [EnterpriseOriginTypeModel]
        let qualityAuditList = aDecoder.decodeObject(forKey: "qualityAuditList") as? [ZZQualityAuditModel]
        let enterpriseTypeList = aDecoder.decodeObject(forKey: "enterpriseTypeList") as? [EnterpriseChooseModel]
        let bankInfoModel = aDecoder.decodeObject(forKey: "bankInfoModel") as? ZZBankInfoModel
        let canModifyName = aDecoder.decodeObject(forKey: "canModifyName") as? Bool
        let inviteCode = aDecoder.decodeObject(forKey: "inviteCode") as? String
        let userName = aDecoder.decodeObject(forKey: "userName") as? String
        let isAuditfailedReason = aDecoder.decodeObject(forKey: "isAuditfailedReason") as? String
        
        self.init(drugScopeList: drugScopeList, receiverAddressList: receiverAddressList, enterprise: enterprise, enterpriseRetail: enterpriseRetail, qcList: qcList, qualificationRetailList: qualificationRetailList, deliveryAreaList: deliveryAreaList, listTypeInfo: listTypeInfo, qualityAuditList: qualityAuditList, enterpriseTypeList: enterpriseTypeList, usermanageAuditStatus: nil, canModifyName: canModifyName, inviteCode: inviteCode, userName: userName, isAuditfailedReason: isAuditfailedReason, bankInfoModel: bankInfoModel, retailAuditDetailList: nil, qualification: qualification, rulesAddressList: rulesAddressList)
    }
    
    
    // MARK: - Save...<新版缓存方式，与用户有关>
    
    // 保存
    func saveHistoryData(_ enterpriseId: String?) {
        // key
        var key = "FKY.CredentialsInfo"
        if let eid = enterpriseId, eid.isEmpty == false {
            key = "FKY.CredentialsInfo" + "." + eid
        }
        print("cache key: \(key)")
        // save
        DispatchQueue.global().async {
            // 序列化
            let dataKeyedArchiver = NSKeyedArchiver.archivedData(withRootObject: self)
            let userDefault = UserDefaults.standard
            userDefault.set(dataKeyedArchiver, forKey: key)
            userDefault.synchronize()
        }
    }
    
    // 清除
    @objc static func removeHistoryData(_ enterpriseId: String?) {
        // key
        var key = "FKY.CredentialsInfo"
        if let eid = enterpriseId, eid.isEmpty == false {
            key = "FKY.CredentialsInfo" + "." + eid
        }
        print("cache key: \(key)")
        // delete
        DispatchQueue.global().async {
            let userDefault = UserDefaults.standard
            userDefault.removeObject(forKey: key)
            userDefault.synchronize()
        }
    }
    
    // 获取
    @objc static func getHistoryData(_ enterpriseId: String?, _ callBack: @escaping ((ZZModel?)->())) {
        // key
        var key = "FKY.CredentialsInfo"
        if let eid = enterpriseId, eid.isEmpty == false {
            key = "FKY.CredentialsInfo" + "." + eid
        }
        print("cache key: \(key)")
        // get
        DispatchQueue.global().async {
            let userDefault = UserDefaults.standard
            var navtiveZZModel: ZZModel? = nil
            if let dataObject = userDefault.object(forKey: key) as? Data {
                // 反序列化
                if let zzModel = NSKeyedUnarchiver.unarchiveObject(with: dataObject) as? ZZModel {
                    navtiveZZModel = zzModel
                }
            }
            DispatchQueue.main.async {
                callBack(navtiveZZModel)
            }
        }
    }
    
    
    // MARK: - Save...<老版缓存方式，与用户无关>
    
    // 保存
    func saveHistoryData() {
        let dataKeyedArchiver = NSKeyedArchiver.archivedData(withRootObject: self)
        let userDefault = UserDefaults.standard
        userDefault.set(dataKeyedArchiver, forKey: "FKY.CredentialsInfo")
        userDefault.synchronize()
    }
    
    // 清除
    @objc static func removeHistoryData() {
        DispatchQueue.global().async {
            let userDefault = UserDefaults.standard
            userDefault.removeObject(forKey: "FKY.CredentialsInfo")
            userDefault.synchronize()
        }
    }
    
    @objc static func getHistoryData(_ callBack: @escaping ((ZZModel?)->())) {
        //反序列化：还原GameData对象
        DispatchQueue.global().async {
            let userDefault = UserDefaults.standard
            var navtiveZZModel: ZZModel? = nil
            if let dataObject = userDefault.object(forKey: "FKY.CredentialsInfo") as? Data {
                if let zzModel = NSKeyedUnarchiver.unarchiveObject(with: dataObject) as? ZZModel {
                    navtiveZZModel = zzModel
                }
            }
            DispatchQueue.main.async {
                callBack(navtiveZZModel)
            }
        }
    }
    
    
    // MARK: -
    
    func hashString() -> String {
        var hashString = ""
        
        if let drugScopeList = drugScopeList, let durgScoprIds = (drugScopeList as NSArray).value(forKeyPath: "drugScopeId"){
            if let durgScoprIdsString = (durgScoprIds as? NSArray)?.componentsJoined(by: ",") {
                hashString += "\(durgScoprIdsString)"
            }
        }
        
        if let enterpriseHashString = enterprise?.hashString() {
            hashString += ";\(enterpriseHashString)"
        }else{
            hashString += ";"
        }
        
        if let enterpriseRetailHashString = enterpriseRetail?.hashString() {
            hashString += ";\(enterpriseRetailHashString)"
        }else{
            hashString += ";"
        }
        
        if let qcArray = qcList, let filePaths = (qcArray as NSArray).value(forKeyPath: "filePath"){
            if let filePathsString = (filePaths as? NSArray)?.componentsJoined(by: ",") {
                hashString += ";\(filePathsString)"
            }else{
                hashString += ";"
            }
        }else{
            hashString += ";"
        }
        
        if let qArray = qualification, let filePaths = (qArray as NSArray).value(forKeyPath: "filePath"){
            if let filePathsString = (filePaths as? NSArray)?.componentsJoined(by: ",") {
                hashString += ";\(filePathsString)"
            }else{
                hashString += ";"
            }
        }else{
            hashString += ";"
        }
        
        if let qrArray = qualificationRetailList, let filePaths = (qrArray as NSArray).value(forKeyPath: "filePath"){
            if let filePathsString = (filePaths as? NSArray)?.componentsJoined(by: ",") {
                hashString += ";\(filePathsString)"
            }else{
                hashString += ";"
            }
        }else{
            hashString += ";"
        }
        
        if let deliveryAreaArray = deliveryAreaList, let provinceCodes = (deliveryAreaArray as NSArray).value(forKeyPath: "provinceCode"){
            if let provinceCodesString = (provinceCodes as? NSArray)?.componentsJoined(by: ",") {
                hashString += ";\(provinceCodesString)"
            }else{
                hashString += ";"
            }
        }else{
            hashString += ";"
        }
        
        if let listTypeArray = listTypeInfo, let typeIds = (listTypeArray as NSArray).value(forKeyPath: "paramValue"){
            if let typeIdsString = (typeIds as? NSArray)?.componentsJoined(by: ",") {
                hashString += ";\(typeIdsString)"
            }else{
                hashString += ";"
            }
        }else{
            hashString += ";"
        }
        
        if let enterpriseTypeArray = enterpriseTypeList, let typeIds = (enterpriseTypeArray as NSArray).value(forKeyPath: "typeId"){
            if let typeIdsString = (typeIds as? NSArray)?.componentsJoined(by: ",") {
                hashString += ";\(typeIdsString)"
            }else{
                hashString += ";"
            }
        }else{
            hashString += ";"
        }
        
        if let bankInfoHashString = bankInfoModel?.hashString() {
            hashString += ";\(bankInfoHashString)"
        }else{
            hashString += ";"
        }
        
        if let inviteCodeString = self.inviteCode {
            hashString += ";\(inviteCodeString)"
        }else{
            hashString += ";"
        }
        
        if let userNameString = self.userName {
            hashString += ";\(userNameString)"
        }else{
            hashString += ";"
        }
        
        if let isAuditfailedReasonString = self.isAuditfailedReason {
            hashString += ";\(isAuditfailedReasonString)"
        }else{
            hashString += ";"
        }
        
        return hashString
    }
}


