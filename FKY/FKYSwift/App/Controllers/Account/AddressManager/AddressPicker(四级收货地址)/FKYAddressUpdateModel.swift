//
//  FKYAddressUpdateModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/8/30.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  四级地址之数据库db更新请求接口返回的地址更新model

import SwiftyJSON

final class FKYAddressUpdateModel: NSObject, JSONAbleType {
    // 接口返回字段
    var endRow: Int?
    var firstPage: Int?
    var hasNextPage: Bool?
    var hasPreviousPage: Bool?
    var isFirstPage: Bool?
    var isLastPage: Bool?
    var lastPage: Int?
    var navigateFirstPage: Int?
    var navigateLastPage: Int?
    var navigatePages: Int?
    var nextPage: Int?
    var pageNum: Int?
    var pageSize: Int?
    var pages: Int?
    var prePage: Int?
    var size: Int?
    var startRow: Int?
    var total: Int?
    var navigatepageNums: [Int]?
    var list: [FKYAddressUpdateItemModel]?

    // 本地新增业务逻辑字段
    var pageIndex: Int = 0  // 当前页面索引
    
    init(list: [FKYAddressUpdateItemModel]?) {
        self.list = list
    }
    
    // 数据解析
    static func fromJSON(_ json: [String : AnyObject]) -> FKYAddressUpdateModel {
        let json = JSON(json)
        
        var list: [FKYAddressUpdateItemModel]?
        if let arr = json["list"].arrayObject {
            list = (arr as NSArray).mapToObjectArray(FKYAddressUpdateItemModel.self)
        }
        
        var navigatepageNums: [Int]?
        if let arr = json["navigatepageNums"].arrayObject {
            navigatepageNums = arr as? [Int]
        }
        
        let endRow = json["endRow"].intValue
        let firstPage = json["firstPage"].intValue
        let hasNextPage = json["hasNextPage"].boolValue
        let hasPreviousPage = json["hasPreviousPage"].boolValue
        let isFirstPage = json["isFirstPage"].boolValue
        let isLastPage = json["isLastPage"].boolValue
        let lastPage = json["lastPage"].intValue
        let navigateFirstPage = json["navigateFirstPage"].intValue
        let navigateLastPage = json["navigateLastPage"].intValue
        let navigatePages = json["navigatePages"].intValue
        let nextPage = json["nextPage"].intValue
        let pageNum = json["pageNum"].intValue
        let pageSize = json["pageSize"].intValue
        let pages = json["pages"].intValue
        let prePage = json["prePage"].intValue
        let size = json["size"].intValue
        let startRow = json["startRow"].intValue
        let total = json["total"].intValue
        
        let model = FKYAddressUpdateModel(list: list)
        model.endRow = endRow
        model.firstPage = firstPage
        model.hasNextPage = hasNextPage
        model.hasPreviousPage = hasPreviousPage
        model.isFirstPage = isFirstPage
        model.isLastPage = isLastPage
        model.lastPage = lastPage
        model.navigateFirstPage = navigateFirstPage
        model.navigateLastPage = navigateLastPage
        model.navigatePages = navigatePages
        model.nextPage = nextPage
        model.pageNum = pageNum
        model.pageSize = pageSize
        model.pages = pages
        model.prePage = prePage
        model.size = size
        model.startRow = startRow
        model.total = total
        model.navigatepageNums = navigatepageNums
        return model
    }
}


final class FKYAddressUpdateItemModel: NSObject, JSONAbleType {
    var id: Int?                // id
    var code: String?           // 编码
    var name: String?           // 名称
    var level: Int?             // 地区等级 1-省 2-市 3-区 4-镇
    var isDelete: Int?          // 是否删除
    var parentCode: String?     // 父编码
    var createTime: String?     // 创建时间
    var version: Int64?         // 当前更新操作的版本号(时间戳)
    
    init(id: Int?, code: String?, name: String?, level: Int?, isDelete: Int?, parentCode: String?, createTime: String?, version: Int64?) {
        self.id = id
        self.code = code
        self.name = name
        self.level = level
        self.isDelete = isDelete
        self.parentCode = parentCode
        self.createTime = createTime
        self.version = version
    }
    
    // dic转model
    static func fromJSON(_ json: [String : AnyObject]) -> FKYAddressUpdateItemModel {
        let json = JSON(json)
        
        let id = json["id"].intValue
        let code = json["code"].stringValue
        let name = json["name"].stringValue
        let level = json["level"].intValue
        let isDelete = json["isDelete"].intValue
        let parentCode = json["parentCode"].stringValue
        let createTime = json["createTime"].stringValue
        let version = json["version"].int64Value
        
        return FKYAddressUpdateItemModel(id: id, code: code, name: name, level: level, isDelete: isDelete, parentCode: parentCode, createTime: createTime, version: version)
    }
}
