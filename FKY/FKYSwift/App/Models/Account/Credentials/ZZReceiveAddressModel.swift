//
//  ZZReceiveAddressModel.swift
//  FKY
//
//  Created by mahui on 2016/11/29.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  地址model

import Foundation
import SwiftyJSON

final class ZZReceiveAddressModel: NSObject,JSONAbleType,ReverseJSONType {
    //MARK: - Property
    
    var id: Int?                    // 地址id
    var enterpriseId : String?      // 企业id
    var receiverName: String?       // 收货人
    var provinceCode: String?       // 省id
    var cityCode: String?           // 市id
    var districtCode: String?       // 区id
    var avenu_code: String?         // 镇（街道）id (townCode)
    var provinceName: String?       // 省名称
    var cityName: String?           // 市名称
    var districtName: String?       // 区名称
    var avenu_name: String?         // 镇（街道）名称 (townName)
    var address: String?            // 地址
    var print_address: String?      // 销售单仓库地址(打印地址)
    var contactPhone: String?       // 联系电话
    var defaultAddress: Int?        // 是否默认收货地址 1:是 0:不是
    var purchaser: String?          // 采购员姓名
    var purchaser_phone: String?    // 采购员联系电话
    
    //MARK: - Public
    
    // 生成详情地址...<带地址>
    var addressDetailDesc: String {
        var content = ""
        if let province = provinceName {
            content = province
        }
        if let city = cityName {
            content = content + " " + city
        }
        if let district = districtName {
            content = content + " " + district
        }
        if let town = avenu_name {
            content = content + " " + town
        }
        if let add = address {
            content = content + " " + add
        }
        return content
    }
    
    // 生成详情地址...<不带地址>
    var addressDistrictDesc: String {
        var content = ""
        if let province = provinceName {
            content = province
        }
        if let city = cityName {
            content = content + " " + city
        }
        if let district = districtName {
            content = content + " " + district
        }
        if let town = avenu_name {
            content = content + " " + town
        }
        return content
    }
    
    //MARK: - Init
    
    // 页面传值
    override init() {
        //
    }
    
    // JSON
    init(id:Int?,enterpriseId:String?,receiverName:String?,
         provinceCode:String?,cityCode:String?,districtCode:String?,avenu_code:String?,
         provinceName:String?,cityName:String?,districtName:String?,avenu_name:String?,
         address:String?,print_address:String?,contactPhone:String?,defaultAddress:Int?,purchaser:String?,purchaserPhone:String?) {
        
        self.id = id
        self.enterpriseId = enterpriseId
        self.receiverName = receiverName
        self.provinceCode = provinceCode
        self.provinceName = provinceName
        self.cityCode = cityCode
        self.cityName = cityName
        self.districtCode = districtCode
        self.districtName = districtName
        self.avenu_code = avenu_code
        self.avenu_name = avenu_name
        self.address = address
        self.print_address = print_address
        self.contactPhone = contactPhone
        self.defaultAddress = defaultAddress
        self.purchaser = purchaser
        self.purchaser_phone = purchaserPhone
    }
    
    static func fromJSON(_ data: [String : AnyObject]) -> ZZReceiveAddressModel {
        let json = JSON(data)
        
        let id = json["id"].intValue
        let enterpriseId = json["enterpriseId"].stringValue
        let receiverName = json["receiverName"].stringValue
        let provinceCode  = json["provinceCode"].stringValue
        let provinceName  = json["provinceName"].stringValue
        let cityCode  = json["cityCode"].stringValue
        let cityName  = json["cityName"].stringValue
        let districtCode  = json["districtCode"].stringValue
        let districtName  = json["districtName"].stringValue
        let avenu_code = json["avenu_code"].stringValue
        let avenu_name = json["avenu_name"].stringValue
        let address  = json["address"].stringValue
        let print_address = json["print_address"].stringValue
        let contactPhone  = json["contactPhone"].stringValue
        let defaultAddress  = json["defaultAddress"].intValue
        let purchaser = json["purchaser"].stringValue
        let purchaser_phone = json["purchaser_phone"].stringValue

        return ZZReceiveAddressModel.init(id: id, enterpriseId: enterpriseId, receiverName: receiverName, provinceCode: provinceCode, cityCode: cityCode, districtCode: districtCode, avenu_code: avenu_code, provinceName: provinceName, cityName: cityName, districtName: districtName, avenu_name: avenu_name, address: address, print_address: print_address, contactPhone: contactPhone, defaultAddress: defaultAddress, purchaser: purchaser, purchaserPhone: purchaser_phone)
    }
    
    // 传参
    func reverseJSON() -> [String : AnyObject] {
        var jsonBody: [String: AnyObject] = ["id": 0 as AnyObject,
                                             "enterpriseId": "" as AnyObject,
                                             "receiverName": "" as AnyObject,
                                             "provinceCode": "" as AnyObject,
                                             "provinceName": "" as AnyObject,
                                             "cityCode": "" as AnyObject,
                                             "cityName": "" as AnyObject,
                                             "districtCode": "" as AnyObject,
                                             "districtName": "" as AnyObject,
                                             "avenu_code": "" as AnyObject,
                                             "avenu_name": "" as AnyObject,
                                             "address": "" as AnyObject,
                                             "print_address": "" as AnyObject,
                                             "contactPhone": "" as AnyObject,
                                             "defaultAddress": 0 as AnyObject,
                                             "createUser": "" as AnyObject,
                                             "createTime": 0 as AnyObject,
                                             "updateTime": 0 as AnyObject,
                                             "updateUser": "" as AnyObject,
                                             "purchaser": "" as AnyObject,
                                             "purchaser_phone": "" as AnyObject
                                             ]
        if let i_d = self.id {
            jsonBody["id"] = i_d as AnyObject
        }
        if let eId = self.enterpriseId {
            jsonBody["enterpriseId"] = eId as AnyObject
        }
        if let rn = self.receiverName {
            jsonBody["receiverName"] = rn as AnyObject
        }
        if let pc = self.provinceCode {
            jsonBody["provinceCode"] = pc as AnyObject
        }
        if let pn = self.provinceName {
            jsonBody["provinceName"] = pn as AnyObject
        }
        if let cc = self.cityCode {
            jsonBody["cityCode"] = cc as AnyObject
        }
        if let cn = self.cityName {
            jsonBody["cityName"] = cn as AnyObject
        }
        if let dc = self.districtCode {
            jsonBody["districtCode"] = dc as AnyObject
        }
        if let dn = self.districtName {
            jsonBody["districtName"] = dn as AnyObject
        }
        if let dc = self.avenu_code {
            jsonBody["avenu_code"] = dc as AnyObject
        }
        if let dn = self.avenu_name {
            jsonBody["avenu_name"] = dn as AnyObject
        }
        if let ad = self.address {
            jsonBody["address"] = ad as AnyObject
        }
        if let ad = self.print_address {
            jsonBody["print_address"] = ad as AnyObject
        }
        if let cp = self.contactPhone {
            jsonBody["contactPhone"] = cp as AnyObject
        }
        if let da = self.defaultAddress {
            jsonBody["defaultAddress"] = da as AnyObject
        }
        if let pu = self.purchaser {
            jsonBody["purchaser"] = pu as AnyObject
        }
        if let puP = self.purchaser_phone {
            jsonBody["purchaser_phone"] = puP as AnyObject
        }
        
        return jsonBody
    }
    
    // 生成一个新model
    func getNewModel() -> ZZReceiveAddressModel {
        let model = ZZReceiveAddressModel.init()
        model.id = self.id
        model.enterpriseId = self.enterpriseId
        model.receiverName = self.receiverName
        model.provinceCode = self.provinceCode
        model.cityCode = self.cityCode
        model.districtCode = self.districtCode
        model.avenu_code = self.avenu_code
        model.provinceName = self.provinceName
        model.cityName = self.cityName
        model.districtName = self.districtName
        model.avenu_name = self.avenu_name
        model.address = self.address
        model.print_address = self.print_address
        model.contactPhone = self.contactPhone
        model.defaultAddress = self.defaultAddress
        model.purchaser = self.purchaser
        model.purchaser_phone = self.purchaser_phone
        return model
    }
}

