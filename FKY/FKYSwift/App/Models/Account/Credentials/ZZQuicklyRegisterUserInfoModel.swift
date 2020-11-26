//
//  ZZQuicklyRegisterUserInfoModel.swift
//  FKY
//
//  Created by airWen on 2017/5/12.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class ZZQuicklyRegisterUserInfoModel: NSObject,JSONAbleType,ReverseJSONType {
    
    var districtName: String?
    var district: String?
    var inviteCode: String?
    var provinceName: String?
    var province: String?
    var enterpriseName: String?
    var status: NSNumber?
    var enterpriseId: String?
    var cityName: String?
    var city: String?
    var enterpriseType: Int?
    
    
    init(districtName: String,district: String?,inviteCode: String?,provinceName: String?,province: String?,enterpriseName: String?,status: NSNumber?,enterpriseId: String?,cityName:String?,city: String?,enterpriseType: Int?) {
        
        self.districtName = districtName
        self.district = district
        self.inviteCode = inviteCode
        self.provinceName = provinceName
        self.province = province
        self.enterpriseName = enterpriseName
        self.status = status
        self.enterpriseId = enterpriseId
        self.cityName = cityName
        self.city = city
        self.enterpriseType = enterpriseType
        
    }
    
    override init() {
        super.init()
        self.districtName = ""
        self.district = ""
        self.inviteCode = ""
        self.provinceName = ""
        self.province = ""
        self.enterpriseName = ""
        self.status = NSNumber(value: 0 as Int32)
        self.enterpriseId = ""
        self.cityName = ""
        self.city = ""
        self.enterpriseType = 0
    }
    
    static func fromJSON(_ data: [String : AnyObject]) -> ZZQuicklyRegisterUserInfoModel {
        let json = JSON(data)
        
        let districtName = json["districtName"].stringValue
        let district = json["district"].stringValue
        let inviteCode = json["inviteCode"].stringValue
        let provinceName = json["provinceName"].stringValue
        let province = json["province"].stringValue
        let enterpriseName = json["enterpriseName"].stringValue
        let status = json["status"].numberValue
        let enterpriseId = json["enterpriseId"].stringValue
        let cityName = json["cityName"].stringValue
        let city = json["city"].stringValue
        let enterpriseType = json["enterpriseType"].intValue
        
        
        return ZZQuicklyRegisterUserInfoModel.init(districtName: districtName, district: district, inviteCode: inviteCode, provinceName: provinceName, province: province, enterpriseName: enterpriseName, status: status, enterpriseId: enterpriseId, cityName: cityName, city: city, enterpriseType: enterpriseType)
    }
    
    func reverseJSON() -> [String : AnyObject] {
        var jsonBody: [String: AnyObject] = ["enterpriseId": "" as AnyObject,
                                             "enterpriseName": "" as AnyObject,
                                             "province": "" as AnyObject,
                                             "city": "" as AnyObject,
                                             "district": "" as AnyObject,
                                             "provinceName": "" as AnyObject,
                                             "cityName": "" as AnyObject,
                                             "districtName": "" as AnyObject,
                                             "inviteCode": "" as AnyObject
        ]
        
        if let eId = self.enterpriseId {
            jsonBody["enterpriseId"] = eId as AnyObject
        }
        if let eName = self.enterpriseName {
            jsonBody["enterpriseName"] = eName as AnyObject
        }
        if let pc = self.province {
            jsonBody["province"] = pc as AnyObject
        }
        if let cy = self.city {
            jsonBody["city"] = cy as AnyObject
        }
        if let dt = self.district {
            jsonBody["district"] = dt as AnyObject
        }
        if let prn = self.provinceName {
            jsonBody["provinceName"] = prn as AnyObject
        }
        if let cn = self.cityName {
            jsonBody["cityName"] = cn as AnyObject
        }
        if let dtn = self.districtName {
            jsonBody["districtName"] = dtn as AnyObject
        }
        if let ic = self.inviteCode {
            jsonBody["inviteCode"] = ic as AnyObject
        }
        if self.isLegalEnterpriseType() {
            jsonBody["enterpriseType"] = self.enterpriseType as AnyObject
        }
        return jsonBody
    }
    
    func getInviteCodeForShow() -> String {
        if let inviteCode = self.inviteCode {
            if 0 < inviteCode.count {
                return inviteCode
            }else{
                return "无"
            }
        }else{
            return "无"
        }
    }
    
    func isHaveAdress() -> Bool {
        var haveProvince: Bool = false
        if let province = self.provinceName {
            if 0 < province.count {
                haveProvince = true
            }
        }
        
        var haveCity: Bool = false
        if let city = self.cityName {
            if 0 < city.count {
                haveCity = true
            }
        }
        
        var haveDistrict: Bool = false
        if let district = self.districtName {
            if 0 < district.count {
                haveDistrict = true
            }
        }
        
        return (haveProvince && haveCity && haveDistrict)
    }
    
    func isLegalEnterpriseType() -> Bool {
        if let enterpriseType = self.enterpriseType, let enterprise_type = EnterpriseTypeForQuiclyRegister(rawValue: enterpriseType)  {
            if enterprise_type.description.count > 0 {
                return true
            }else {
                return false
            }
        }else{
            return false
        }
    }
    
    func updateWithEnterpriseModel(_ enterpriseModel: FKYEnterpriseModel) {
        self.enterpriseName = enterpriseModel.enterpriseName
        self.cityName = enterpriseModel.cityName
        self.provinceName = enterpriseModel.provinceName
        self.districtName = enterpriseModel.districtName
        self.province = enterpriseModel.province
        self.enterpriseId = enterpriseModel.enterpriseId
        self.district = enterpriseModel.district
        self.city = enterpriseModel.city
        self.enterpriseType = enterpriseModel.enterpriseType
    }
    
    func updateWithAnotherQuicklyRegisterModel(_ quicklyRegister: ZZQuicklyRegisterUserInfoModel) {
        self.districtName = quicklyRegister.districtName
        self.district = quicklyRegister.district
        self.inviteCode = quicklyRegister.inviteCode
        self.provinceName = quicklyRegister.provinceName
        self.province = quicklyRegister.province
        self.enterpriseName = quicklyRegister.enterpriseName
        self.status = quicklyRegister.status
        self.enterpriseId = quicklyRegister.enterpriseId
        self.cityName = quicklyRegister.cityName
        self.city = quicklyRegister.city
        self.enterpriseType = quicklyRegister.enterpriseType
    }
    
    func isEqualTo(_ quicklyRegister: ZZQuicklyRegisterUserInfoModel) -> Bool {
        let isEqualDistrictName: Bool = (self.districtName == quicklyRegister.districtName)
        let isEqualDistrict: Bool = (self.district == quicklyRegister.district)
        let isEqualInviteCode: Bool = (self.inviteCode == quicklyRegister.inviteCode)
        let isEqualProvinceName: Bool = (self.provinceName == quicklyRegister.provinceName)
        let isEqualProvince: Bool = (self.province == quicklyRegister.province)
        let isEqualEnterpriseName: Bool = (self.enterpriseName == quicklyRegister.enterpriseName)
        let isEqualEnterpriseId: Bool = (self.enterpriseId == quicklyRegister.enterpriseId)
        let isEqualCityName: Bool = (self.cityName == quicklyRegister.cityName)
        let isEqualCity: Bool = (self.city == quicklyRegister.city)
        let isEqualEnterpriseType: Bool = (self.enterpriseType == quicklyRegister.enterpriseType)
        
        return (isEqualDistrictName && isEqualDistrict && isEqualInviteCode && isEqualProvinceName && isEqualProvince && isEqualEnterpriseName && isEqualEnterpriseId && isEqualCityName && isEqualCity && isEqualEnterpriseId && isEqualEnterpriseType)
    }
    
    func getEnterpriseTypeString() -> String? {
        if let enterpriseType = self.enterpriseType, let enterprise_type = EnterpriseTypeForQuiclyRegister(rawValue: enterpriseType){
            return enterprise_type.description
        }
        return nil
    }
}
