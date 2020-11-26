//
//  ZZAllInOneBaseInfoModel.swift
//  FKY
//
//  Created by Rabe on 26/03/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  批零一体基本信息

import Foundation
import SwiftyJSON

final class ZZAllInOneBaseInfoModel: NSObject, JSONAbleType, ReverseJSONType {
    var enterpriseName : String? // 企业名称
    var provinceName : String? // 省名称
    var cityName : String?  // 市名称
    var districtName : String? // 区名称
    var province : String? // 省编码
    var city : String?  // 市编码
    var district : String?  // 区编码
    var registeredAddress : String?  // 详细地址
    var shopNum : Int? // 门店数
    var is3merge1 : Int? // 资质证书是否3合1
    
    var isEmpty: Bool = true
    
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
        if let province = addressProvinceDetail,let pname = province.infoName {
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
            if let province = addressProvinceDetail,let pname = province.infoName {
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
    
    override init() {
        isEmpty = true
        
        self.enterpriseName = ""
        self.provinceName = ""
        self.cityName = ""
        self.districtName = ""
        self.province = ""
        self.city = ""
        self.district = ""
        self.registeredAddress = ""
        self.shopNum = 0
        self.is3merge1 = 0
    }
    
    // JSON 解析
    init(enterpriseName: String?, provinceName: String?, cityName: String?, districtName: String?, province: String?, city: String?, district: String?, registeredAddress: String?, shopNum: Int?, is3merge1: Int?) {
        self.isEmpty = false
        
        self.enterpriseName = enterpriseName
        self.provinceName = provinceName
        self.cityName = cityName
        self.districtName = districtName
        self.province = province
        self.city = city
        self.district = district
        self.registeredAddress = registeredAddress
        self.shopNum = shopNum
        self.is3merge1 = is3merge1
        
        let districtModel = ProvinceModel(infoCode: self.district, infoName: self.districtName, secondModel: nil)
        let cityModel = ProvinceModel(infoCode: self.city, infoName: self.cityName, secondModel: [districtModel])
        let provinceModel = ProvinceModel(infoCode: self.province, infoName: self.provinceName, secondModel: [cityModel])
        self.addressProvinceDetail = provinceModel
    }
    
    static func fromJSON(_ data: [String : AnyObject]) -> ZZAllInOneBaseInfoModel {
        let json = JSON(data)
        let enterpriseName = json["enterprise_name"].stringValue
        let provinceName = json["province_name"].stringValue
        let cityName = json["city_name"].stringValue
        let districtName  = json["district_name"].stringValue
        let province  = json["province"].stringValue
        let city  = json["city"].stringValue
        let district  = json["district"].stringValue
        let registeredAddress  = json["registered_address"].stringValue
        let shopNum  = json["shop_num"].intValue
        let is3merge1 = json["is_3merge1"].intValue
        
        return ZZAllInOneBaseInfoModel(enterpriseName: enterpriseName, provinceName: provinceName, cityName: cityName, districtName: districtName, province: province, city: city, district: district, registeredAddress: registeredAddress, shopNum: shopNum, is3merge1: is3merge1)
    }
    
    func reverseJSON() -> [String: AnyObject] {
        var params = ["enterprise_name" : "" ,
                      "province_name" : "" ,
                      "city_name" : "" ,
                      "district_name" : "" ,
                      "province" : "" ,
                      "city" : "" ,
                      "district" : "" ,
                      "registered_address" : "" ,
                      "shop_num" : "",
                      "is_3merge1" : ""]
        if self.enterpriseName != nil {
            params["enterprise_name"] = "\(self.enterpriseName!)"
        }
        
        if self.provinceName != nil {
            params["province_name"] = self.provinceName!
        }
        
        if self.cityName != nil {
            params["city_name"] = "\(self.cityName!)"
        }
        
        if self.districtName != nil {
            params["district_name"] = self.districtName!
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
        
        if self.registeredAddress != nil {
            params["registered_address"] = self.registeredAddress!
        }
        
        if self.shopNum != nil {
            params["shop_num"] = "\(self.shopNum!)"
        }
        
        if self.is3merge1 != nil {
            params["is_3merge1"] = "\(self.is3merge1!)"
        }
        
        return params as [String : AnyObject]
    }
}
