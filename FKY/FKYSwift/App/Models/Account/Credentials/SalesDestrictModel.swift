//
//  SalesDestrictModel.swift
//  FKY
//
//  Created by yangyouyong on 2016/11/3.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

@objcMembers
final class SalesDestrictModel: NSObject, JSONAbleType, ReverseJSONType {
    var province: ProvinceModel?
    var city: ProvinceModel?
    var district: ProvinceModel?
    
    let provinceName: String
    let provinceCode: String
    let cityName: String
    let cityCode: String
    let districtName: String
    let districtCode: String
    
    init(province: ProvinceModel, city: ProvinceModel?, district: ProvinceModel?) {
        self.provinceName = province.infoName!
        self.provinceCode = province.infoCode!
        if let dis = city {
            self.cityName = dis.infoName!
            self.cityCode = dis.infoCode!
        }else{
            self.cityName = ""
            self.cityCode = ""
        }
        if let coun = district {
            self.districtName = coun.infoName!
            self.districtCode = coun.infoCode!
        }else{
            self.districtName = ""
            self.districtCode = ""
        }
        self.province = province
        self.city = city
        self.district = district
    }
    
    init(provinceName: String, provinceCode: String, cityName: String, cityCode: String, districtName: String, districtCode: String) {
        self.provinceName = provinceName
        self.provinceCode = provinceCode
        self.cityName = cityName
        self.cityCode = cityCode
        self.districtName = districtName
        self.districtCode = districtCode
        self.district = ProvinceModel(infoCode: districtCode, infoName: districtName, secondModel: nil)
        self.city = ProvinceModel(infoCode: cityCode, infoName: cityName, secondModel: [self.district!])
        self.province = ProvinceModel(infoCode: provinceCode, infoName: provinceName, secondModel: [self.city!])
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> SalesDestrictModel {
        let j = JSON(json)
        let provinceName = j["provinceName"].stringValue
        let provinceCode = j["province"].stringValue
        let cityName = j["cityName"].stringValue
        let cityCode = j["city"].stringValue
        let districtName = j["districtName"].stringValue
        let districtCode = j["district"].stringValue
        return SalesDestrictModel(provinceName: provinceName, provinceCode: provinceCode, cityName: cityName, cityCode: cityCode, districtName: districtName, districtCode: districtCode)
    }
    
    func reverseJSON() -> [String : AnyObject] {
        var json = ["province":"",
                    "provinceName": "",
                    "city": "",
                    "cityName": "",
                    "district": "",
                    "districtName": ""]
        if (self.provinceCode as NSString).length > 0 {
            json["province"] = self.provinceCode
            json["provinceName"] = self.provinceName
        }
        if (self.cityCode as NSString).length > 0 {
            json["city"] = self.cityCode
            json["cityName"] = self.cityName
        }
        if (self.districtCode as NSString).length > 0 {
            json["district"] = self.districtCode
            json["districtName"] = self.districtName
        }
        return json as [String : AnyObject]
    }
    
    func equalsTo(_ model: SalesDestrictModel) -> Bool {
        let provinceEqual = model.provinceCode == self.provinceCode
        let cityEqual = model.cityCode == self.cityCode
        let districtEqual = model.districtCode == self.districtCode
        let equal = (provinceEqual && cityEqual && districtEqual)
        return equal
    }
    
    func getLocaltionDes() -> String {
        return "\(provinceName) \(cityName) \(districtName)"
    }
}
