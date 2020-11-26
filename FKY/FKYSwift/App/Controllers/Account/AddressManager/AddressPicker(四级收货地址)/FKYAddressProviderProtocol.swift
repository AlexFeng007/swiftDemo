//
//  FKYAddressProviderProtocol.swift
//  FKY
//
//  Created by 夏志勇 on 2018/8/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  用来提供地址数据源的相关协议<接口>...[任何实现此接口的类均可作为数据源提供者]

import UIKit

protocol FKYAddressProviderProtocol {
    // 四级地址相关
    var provinceList: [FKYAddressItemModel] {get}
    var cityList: [FKYAddressItemModel] {get}
    var districtList: [FKYAddressItemModel] {get}
    var townList: [FKYAddressItemModel] {get}
    
    // 获取所有省
    func getProvinceList(resultBlock: @escaping ([Any]) -> ())
    
    // 获取所有市
    func getCityList(_ provinceModel: FKYAddressItemModel, resultBlock: @escaping ([Any]) -> ())
    
    // 获取所有区
    func getDistrictList(_ cityModel: FKYAddressItemModel, resultBlock: @escaping ([Any]) -> ())
    
    // 获取所有镇(街道)
    func getTownList(_ districtModel: FKYAddressItemModel, resultBlock: @escaping ([Any]) -> ())
}
