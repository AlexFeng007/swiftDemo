//
//  FKYAddressRemoteProvider.swift
//  FKY
//
//  Created by 夏志勇 on 2018/8/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  地址数据源提供类...<实时网络请求各级地址列表数据>

import UIKit

class FKYAddressRemoteProvider: NSObject, FKYAddressProviderProtocol {
    // 四级地址相关
    var provinceList: [FKYAddressItemModel] = []
    var cityList: [FKYAddressItemModel] = []
    var districtList: [FKYAddressItemModel] = []
    var townList: [FKYAddressItemModel] = []
    
    // 接口请求相关
    var requestService = FKYAddressRequestService()
    
    // 获取所有省份
    func getProvinceList(resultBlock: @escaping ([Any]) -> ()) {
        if provinceList.count > 0 {
            resultBlock(provinceList)
            return
        }
        
        let parameters = ["level": 1, "pCode": "0"] as [String : Any]
        requestService.requestAddressList(withParams: parameters) { (responseObj, error) in
            // 请求失败or无数据返回
            guard let list = responseObj as? [FKYAddressUpdateItemModel], list.count > 0 else {
                resultBlock([FKYAddressItemModel]())
                return
            }
            
            // 请求成功且有数据返回
            self.getAllProvinceItems(list)
            resultBlock(self.provinceList)
        }
    }
    
    // 获取所有市
    func getCityList(_ provinceModel: FKYAddressItemModel, resultBlock: @escaping ([Any]) -> ()) {
        cityList.removeAll()
        
        guard let code = provinceModel.code, code.isEmpty == false else {
            cityList = [FKYAddressItemModel]()
            resultBlock(cityList)
            return
        }
        
        let parameters = ["level": 2, "pCode": code] as [String : Any]
        requestService.requestAddressList(withParams: parameters) { (responseObj, error) in
            // 请求失败or无数据返回
            guard let list = responseObj as? [FKYAddressUpdateItemModel], list.count > 0 else {
                resultBlock([FKYAddressItemModel]())
                return
            }
            
            // 请求成功且有数据返回
            self.getAllCityItems(list)
            resultBlock(self.cityList)
        }
    }
    
    // 获取所有区
    func getDistrictList(_ cityModel: FKYAddressItemModel, resultBlock: @escaping ([Any]) -> ()) {
        districtList.removeAll()
        
        guard let code = cityModel.code, code.isEmpty == false else {
            districtList = [FKYAddressItemModel]()
            resultBlock(districtList)
            return
        }
        
        let parameters = ["level": 3, "pCode": code] as [String : Any]
        requestService.requestAddressList(withParams: parameters) { (responseObj, error) in
            // 请求失败or无数据返回
            guard let list = responseObj as? [FKYAddressUpdateItemModel], list.count > 0 else {
                resultBlock([FKYAddressItemModel]())
                return
            }
            
            // 请求成功且有数据返回
            self.getAllDistrictItems(list)
            resultBlock(self.districtList)
        }
    }
    
    // 获取所有镇
    func getTownList(_ districtModel: FKYAddressItemModel, resultBlock: @escaping ([Any]) -> ()) {
        townList.removeAll()
        
        guard let code = districtModel.code, code.isEmpty == false else {
            townList = [FKYAddressItemModel]()
            resultBlock(townList)
            return
        }
        
        let parameters = ["level": 4, "pCode": code] as [String : Any]
        requestService.requestAddressList(withParams: parameters) { (responseObj, error) in
            // 请求失败or无数据返回
            guard let list = responseObj as? [FKYAddressUpdateItemModel], list.count > 0 else {
                resultBlock([FKYAddressItemModel]())
                return
            }
            
            // 请求成功且有数据返回
            self.getAllTownItems(list)
            resultBlock(self.townList)
        }
    }
}

extension FKYAddressRemoteProvider {
    //
    @discardableResult fileprivate func getAllProvinceItems(_ arr: [FKYAddressUpdateItemModel]) -> [FKYAddressItemModel] {
        provinceList.removeAll()
        
        for addr in arr {
            let obj = FKYAddressItemModel(code: addr.code, name: addr.name, level: "\(addr.level ?? 1)", parentCode: addr.parentCode)
            provinceList.append(obj)
        } // for
        
        return provinceList
    }
    
    //
    @discardableResult fileprivate func getAllCityItems(_ arr: [FKYAddressUpdateItemModel]) -> [FKYAddressItemModel] {
        cityList.removeAll()

        for addr in arr {
            let obj = FKYAddressItemModel(code: addr.code, name: addr.name, level: "\(addr.level ?? 2)", parentCode: addr.parentCode)
            cityList.append(obj)
        } // for
        
        return cityList
    }
    
    //
    @discardableResult fileprivate func getAllDistrictItems(_ arr: [FKYAddressUpdateItemModel]) -> [FKYAddressItemModel] {
        districtList.removeAll()
        
        for addr in arr {
            let obj = FKYAddressItemModel(code: addr.code, name: addr.name, level: "\(addr.level ?? 3)", parentCode: addr.parentCode)
            districtList.append(obj)
        } // for
        
        return districtList
    }
    
    //
    @discardableResult fileprivate func getAllTownItems(_ arr: [FKYAddressUpdateItemModel]) -> [FKYAddressItemModel] {
        townList.removeAll()
        
        for addr in arr {
            let obj = FKYAddressItemModel(code: addr.code, name: addr.name, level: "\(addr.level ?? 4)", parentCode: addr.parentCode)
            townList.append(obj)
        } // for
        
        return townList
    }
}
