//
//  RIAddressModel.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/15.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  地址model

import Foundation
import SwiftyJSON

class RIAddressModel: NSObject {
    //MARK: - Property
    
    var id: String?                 // 地址id
    var provinceCode: String?       // 省id
    var cityCode: String?           // 市id
    var districtCode: String?       // 区id
    var avenu_code: String?         // 镇（街道）id (townCode)
    var provinceName: String?       // 省名称
    var cityName: String?           // 市名称
    var districtName: String?       // 区名称
    var avenu_name: String?         // 镇（街道）名称 (townName)
    var address: String?            // 详细地址
    var receiveFlag: Bool = false   // 是否为收货地址<收货地址有四级，企业地址只有三级>
    
    
    //MARK: - Init
    
    // 页面传值
//    override init() {
//        //
//    }
    
    
    //MARK: - Public
    
    // 生成地区字符串...<不带地址>
    var detailArea: String {
        var content = ""
        if let province = provinceName, province.isEmpty == false {
            content = province
        }
        if let city = cityName, city.isEmpty == false {
            content = content + " " + city
        }
        if let district = districtName, district.isEmpty == false {
            content = content + " " + district
        }
        if receiveFlag == true, let town = avenu_name, town.isEmpty == false {
            content = content + " " + town
        }
        return content
    }
    
    // 生成详细地址字符串...<带地址>
    var detailAddress: String {
        var content = ""
        if let province = provinceName, province.isEmpty == false {
            content = province
        }
        if let city = cityName, city.isEmpty == false {
            content = content + " " + city
        }
        if let district = districtName, district.isEmpty == false {
            content = content + " " + district
        }
        if receiveFlag == true, let town = avenu_name, town.isEmpty == false {
            content = content + " " + town
        }
        if let addr = address, addr.isEmpty == false {
            content = content + " " + addr
        }
        return content
    }
    
    // 企业地区是否为空
    func isValidForEnterpriseArea() -> Bool {
        guard let province = provinceName, province.isEmpty == false else {
            return false
        }
        guard let city = cityName, city.isEmpty == false else {
            return false
        }
        guard let district = districtName, district.isEmpty == false else {
            return false
        }
    
        return true
    }
    
    // 收货地区是否为空...<去掉对第四级的校验>
    func isValidForReceiveArea() -> Bool {
        guard let province = provinceName, province.isEmpty == false else {
            return false
        }
        guard let city = cityName, city.isEmpty == false else {
            return false
        }
        guard let district = districtName, district.isEmpty == false else {
            return false
        }
//        guard let town = avenu_name, town.isEmpty == false else {
//            return false
//        }
        
        return true
    }
    
    // 保存各地区字段值
    func setValue(_ model: RIAddressModel) {
        //id = model.id
        provinceCode = model.provinceCode
        cityCode = model.cityCode
        districtCode = model.districtCode
        avenu_code = model.avenu_code
        provinceName = model.provinceName
        cityName = model.cityName
        districtName = model.districtName
        avenu_name = model.avenu_name
        address = model.address
        //receiveFlag = model.receiveFlag
    }
}
