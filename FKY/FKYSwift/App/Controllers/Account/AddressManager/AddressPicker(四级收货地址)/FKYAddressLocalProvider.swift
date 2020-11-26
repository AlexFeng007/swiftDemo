//
//  FKYAddressLocalProvider.swift
//  FKY
//
//  Created by 夏志勇 on 2018/8/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  地址数据源提供类...<查询本地数据库address.db>

import UIKit

class FKYAddressLocalProvider: NSObject, FKYAddressProviderProtocol {
    // 四级地址相关
    var provinceList: [FKYAddressItemModel] = []
    var cityList: [FKYAddressItemModel] = []
    var districtList: [FKYAddressItemModel] = []
    var townList: [FKYAddressItemModel] = []
    
    // 获取所有省份
    func getProvinceList(resultBlock: @escaping ([Any]) -> ()) {
        if provinceList.count > 0 {
            resultBlock(provinceList)
            return
        }
        
        let addressManager = FKYAddressDBManager.instance
        if addressManager.provinceList.count > 0 {
            // 已有省份数据
            provinceList = addressManager.provinceList
            resultBlock(provinceList)
            return
        }
        
        addressManager.getProvinceList { (list) in
            // 保存省份数组
            self.provinceList = list as! [FKYAddressItemModel]
            resultBlock(list)
        }
    }
    
    // 获取所有市
    func getCityList(_ provinceModel: FKYAddressItemModel, resultBlock: @escaping ([Any]) -> ()) {
        guard let code = provinceModel.code, code.isEmpty == false else {
            cityList = [FKYAddressItemModel]()
            resultBlock(cityList)
            return
        }

        let sql = String.init(format: "select * from address where level = %@ and parentCode = %@", "2", code)
        FKYAddressDBManager.instance.queryAddressDatabase(sql: sql, arguments: nil) { (list) in
            //print(list)
            self.cityList = list as! [FKYAddressItemModel]
            resultBlock(list)
        }
    }
    
    // 获取所有区
    func getDistrictList(_ cityModel: FKYAddressItemModel, resultBlock: @escaping ([Any]) -> ()) {
        guard let code = cityModel.code, code.isEmpty == false else {
            districtList = [FKYAddressItemModel]()
            resultBlock(districtList)
            return
        }
        
        let sql = String.init(format: "select * from address where level = %@ and parentCode = %@", "3", code)
        FKYAddressDBManager.instance.queryAddressDatabase(sql: sql, arguments: nil) { (list) in
            //print(list)
            self.districtList = list as! [FKYAddressItemModel]
            resultBlock(list)
        }
    }
    
    // 获取所有镇
    func getTownList(_ districtModel: FKYAddressItemModel, resultBlock: @escaping ([Any]) -> ()) {
        guard let code = districtModel.code, code.isEmpty == false else {
            townList = [FKYAddressItemModel]()
            resultBlock(townList)
            return
        }
        
        let sql = String.init(format: "select * from address where level = %@ and parentCode = %@", "4", code)
        FKYAddressDBManager.instance.queryAddressDatabase(sql: sql, arguments: nil) { (list) in
            //print(list)
//            self.townList = list as! [FKYAddressItemModel]
//            resultBlock(list)
            
            // 第四级后面加“暂不选择”逻辑
            var tList = list as! [FKYAddressItemModel]
            if tList.count > 0 {
                let obj = FKYAddressItemModel(code: "-1", name: "暂不选择", level: "4", parentCode: "-1")
                tList.append(obj)
            }
            self.townList = tList
            resultBlock(tList)
        }
    }
}


// MARK: - 通过code查对应的name
extension FKYAddressLocalProvider {
    class func queryAddressNameFromCode(_ code: String, _ level: Int, resultBlock: @escaping (FKYAddressItemModel?) -> ()) {
        guard code.isEmpty == false else {
            resultBlock(nil)
            return
        }
        guard level >= 1, level <= 4 else {
            resultBlock(nil)
            return
        }
        let sql = String.init(format: "select * from address where level = %@ and code = %@", "\(level)", code)
        FKYAddressDBManager.instance.queryAddressDatabase(sql: sql, arguments: nil) { (list) in
            let arr = list as! [FKYAddressItemModel]
            if arr.count > 0 {
                resultBlock(arr.first)
            }
            else {
                resultBlock(nil)
            }
        }
    }
}
