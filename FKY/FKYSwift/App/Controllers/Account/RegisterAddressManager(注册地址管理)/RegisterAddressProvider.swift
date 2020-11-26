//
//  RegisterAddressProvider.swift
//  FKY
//
//  Created by 夏志勇 on 2019/3/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  注册(三级)地址数据提供类
//  rap地址：http://rap.yiyaowang.com/workspace/myWorkspace.do?projectId=293#3090

import UIKit

class RegisterAddressProvider: NSObject {
    // 三级地址相关
    var provinceList: [RegisterAddressItemModel] = []
    var cityList: [RegisterAddressItemModel] = []
    var districtList: [RegisterAddressItemModel] = []
    
    // 获取所有省
    func getProvinceList(resultBlock: @escaping ([Any], String?) -> ()) {
        if provinceList.count > 0 {
            resultBlock(provinceList, nil)
            return
        }
        
        // 请求
        FKYRequestService.sharedInstance()?.requestForGetProvince(withParam: nil, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard success else {
                let msg = error?.localizedDescription ?? "查询失败"
                resultBlock([RegisterAddressItemModel](), msg)
                return
            }
            // 请求成功
            if let data: RegisterAddressModel = model as? RegisterAddressModel, let list = data.data, list.count > 0 {
                // 请求成功且有数据返回
                strongSelf.provinceList.removeAll()
                strongSelf.provinceList.append(contentsOf: list)
                resultBlock(strongSelf.provinceList, nil)
                return
            }
            // 请求成功且无数据返回
            resultBlock([RegisterAddressModel](), "无数据")
            return
        })
    }
    
    // 获取所有市
    func getCityList(_ provinceModel: RegisterAddressItemModel, resultBlock: @escaping ([Any], String?) -> ()) {
        cityList.removeAll()
        
        guard let code = provinceModel.code, code.isEmpty == false else {
            cityList = [RegisterAddressItemModel]()
            resultBlock(cityList, nil)
            return
        }
        
        // 请求
        FKYRequestService.sharedInstance()?.requestForGetCity(withParam: ["provinceCode": code], completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard success else {
                let msg = error?.localizedDescription ?? "查询失败"
                resultBlock([RegisterAddressItemModel](), msg)
                return
            }
            // 请求成功
            if let data: RegisterAddressModel = model as? RegisterAddressModel, let list = data.data, list.count > 0 {
                // 请求成功且有数据返回
                strongSelf.cityList.append(contentsOf: list)
                resultBlock(strongSelf.cityList, nil)
                return
            }
            // 请求成功且无数据返回
            resultBlock([RegisterAddressModel](), "无数据")
            return
        })
    }
    
    // 获取所有区
    func getDistrictList(_ cityModel: RegisterAddressItemModel, resultBlock: @escaping ([Any], String?) -> ()) {
        districtList.removeAll()
        
        guard let code = cityModel.code, code.isEmpty == false else {
            districtList = [RegisterAddressItemModel]()
            resultBlock(districtList, nil)
            return
        }
        
        // 请求
        FKYRequestService.sharedInstance()?.requestForGetDistrict(withParam: ["cityCode": code], completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard success else {
                let msg = error?.localizedDescription ?? "查询失败"
                resultBlock([RegisterAddressItemModel](), msg)
                return
            }
            // 请求成功
            if let data: RegisterAddressModel = model as? RegisterAddressModel, let list = data.data, list.count > 0 {
                // 请求成功且有数据返回
                strongSelf.districtList.append(contentsOf: list)
                resultBlock(strongSelf.districtList, nil)
                return
            }
            // 请求成功且无数据返回
            resultBlock([RegisterAddressModel](), "无数据")
            return
        })
    }
}


extension RegisterAddressProvider {
    // 通过省、市、区名称查对应code；若反之通过code查name
    class func queryAreaNameOrCode(_ province: String?, _ city: String?, _ district: String?, resultBlock: @escaping (RegisterAddressQueryItemModel?, String?) -> ()) {
        // 入参
        var param = Dictionary<String, Any>()
        param["provinceCodeOrName"] = (province ?? "")
        param["cityCodeOrName"] = (city ?? "")
        param["countryCodeOrName"] = (district ?? "")
        // 请求
        FKYRequestService.sharedInstance()?.requestForQueryNameOrCode(withParam: param, completionBlock: { (success, error, response, model) in
            // 请求失败
            guard success else {
                let msg = error?.localizedDescription ?? "查询失败"
                resultBlock(nil, msg)
                return
            }
            // 请求成功
            if let data: RegisterAddressQueryModel = model as? RegisterAddressQueryModel, let obj: RegisterAddressQueryItemModel = data.data {
                // 请求成功且有数据返回
                resultBlock(obj, nil)
                return
            }
            // 请求成功且无数据返回
            resultBlock(nil, "无数据")
            return
        })
    }
}


