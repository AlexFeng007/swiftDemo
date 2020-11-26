//
//  RegisterAddressModel.swift
//  FKY
//
//  Created by 夏志勇 on 2019/3/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  注册地址之地址model

import SwiftyJSON

// MARK: - 获取省、市、区列表数据接口返回的model
final class RegisterAddressModel: NSObject, JSONAbleType {
    var status: Int?   // 状态
    var msg: String?   // 提示
    var data: [RegisterAddressItemModel]?   // 地址项数组
    
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>...<Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) -> RegisterAddressModel {
        let json = JSON(json)
        
        let model = RegisterAddressModel()
        model.status = json["status"].intValue
        model.msg = json["msg"].stringValue
        
        var data: [RegisterAddressItemModel]? = []
        let list = json["data"].arrayObject
        if let arr = list {
            data = (arr as NSArray).mapToObjectArray(RegisterAddressItemModel.self)
        }
        model.data = data
        
        return model
    }
}


// MARK: -  通过省、市、区名称查code(或code查名称)接口返回的model
final class RegisterAddressQueryModel: NSObject, JSONAbleType {
    var status: Int?   // 状态
    var msg: String?   // 提示
    var data: RegisterAddressQueryItemModel?   // 查询结果model
    
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>
    @objc static func fromJSON(_ json: [String : AnyObject]) -> RegisterAddressQueryModel {
        let json = JSON(json)
        
        let model = RegisterAddressQueryModel()
        model.status = json["status"].intValue
        model.msg = json["msg"].stringValue
        
        var data: RegisterAddressQueryItemModel? = nil
        if let dic = json["data"].dictionaryObject {
            let obj = dic as NSDictionary
            data = obj.mapToObject(RegisterAddressQueryItemModel.self)
        }
        model.data = data
        
        return model
    }
}


// MARK: -  通过省、市、区名称查code(或code查名称)接口返回的子model
final class RegisterAddressQueryItemModel: NSObject, JSONAbleType {
    var provinceName: String?                           // 省名称
    var cityName: String?                               // 市名称
    var countryName: String?                            // 区名称
    var tAddressProvince: RegisterAddressItemModel?     // 省model
    var tAddressCity: RegisterAddressItemModel?         // 市model
    var tAddressCountry: RegisterAddressItemModel?      // 区model
    
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>
    static func fromJSON(_ json: [String : AnyObject]) -> RegisterAddressQueryItemModel {
        let json = JSON(json)
        
        let model = RegisterAddressQueryItemModel()
        model.provinceName = json["provinceName"].stringValue
        model.cityName = json["cityName"].stringValue
        model.countryName = json["countryName"].stringValue
        
        var tAddressProvince: RegisterAddressItemModel? = nil
        let dicP = json["tAddressProvince"].dictionaryObject
        if let dic = dicP {
            let data = dic as NSDictionary
            tAddressProvince = data.mapToObject(RegisterAddressItemModel.self)
        }
        model.tAddressProvince = tAddressProvince
        
        var tAddressCity: RegisterAddressItemModel? = nil
        let dicC = json["tAddressCity"].dictionaryObject
        if let dic = dicC {
            let data = dic as NSDictionary
            tAddressCity = data.mapToObject(RegisterAddressItemModel.self)
        }
        model.tAddressCity = tAddressCity
        
        var tAddressCountry: RegisterAddressItemModel? = nil
        let dicD = json["tAddressCountry"].dictionaryObject
        if let dic = dicD {
            let data = dic as NSDictionary
            tAddressCountry = data.mapToObject(RegisterAddressItemModel.self)
        }
        model.tAddressCountry = tAddressCountry
        
        return model
    }
}


// MARK: -  省、市、区model
final class RegisterAddressItemModel: NSObject, JSONAbleType {
    var name: String?           // 名称
    var code: String?           // 编码
    var provinceCode: String?   // 上级编码...<省>
    var cityCode: String?       // 上级编码...<市>
    
    init(name: String?, code: String?) {
        self.name = name
        self.code = code
    }
    
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>
    static func fromJSON(_ json: [String : AnyObject]) -> RegisterAddressItemModel {
        let json = JSON(json)
        
        let model = RegisterAddressItemModel(name: nil, code: nil)
        model.name = json["name"].stringValue
        model.code = json["code"].stringValue
        model.provinceCode = json["provinceCode"].stringValue
        model.cityCode = json["cityCode"].stringValue
        return model
    }
}
