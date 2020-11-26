//
//  PaginatorModel.swift
//  FKY
//
//  Created by Rabe on 13/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import Foundation
import SwiftyJSON

/// 列表页页数信息对象，对应接口文档的Paginator对象
/// 文档地址：http://wiki.yiyaowang.com/pages/viewpage.action?pageId=16197053

// MARK: - CouponTempModel 对象
final class PaginatorModel: NSObject, JSONAbleType {
    
    // MARK: - properties
    var endRow: Int?
    var firstPage: Bool?
    var hasNextPage: Bool?
    var hasPrePage: Bool?
    var lastPage: Bool?
    var limit: Int?
    var nextPage: Int?
    var offset: Int?
    var page: Int?
    var prePage: Int?
    var slider: [Int]?
    var startRow: Int?
    var totalCount: Int?
    var totalPages: Int?
    
    // MARK: - life cycle
    static func fromJSON(_ json: [String : AnyObject]) -> PaginatorModel {
        let json = JSON(json)
        
        let endRow = json["endRow"].intValue
        let firstPage = json["firstPage"].boolValue
        let hasNextPage = json["hasNextPage"].boolValue
        let hasPrePage = json["hasPrePage"].boolValue
        let lastPage = json["lastPage"].boolValue
        let limit = json["limit"].intValue
        let nextPage = json["nextPage"].intValue
        let offset = json["offset"].intValue
        let page = json["page"].intValue
        let prePage = json["prePage"].intValue
        let slider = json["slider"].arrayObject as! [Int]
        let startRow = json["startRow"].intValue
        let totalCount = json["totalCount"].intValue
        let totalPages = json["totalPages"].intValue
        
        return PaginatorModel(endRow: endRow, firstPage: firstPage, hasNextPage: hasNextPage, hasPrePage: hasPrePage, lastPage: lastPage, limit: limit, nextPage: nextPage, offset: offset, page: page, prePage: prePage, slider: slider, startRow: startRow, totalCount: totalCount, totalPages: totalPages)
    }
    
    init(endRow: Int?, firstPage: Bool?, hasNextPage: Bool?, hasPrePage: Bool?, lastPage: Bool?, limit: Int?, nextPage: Int?, offset: Int?, page: Int?, prePage: Int?, slider: [Int]?, startRow: Int?, totalCount: Int?, totalPages: Int?) {
        self.endRow = endRow
        self.firstPage = firstPage
        self.hasNextPage = hasNextPage
        self.hasPrePage = hasPrePage
        self.lastPage = lastPage
        self.limit = limit
        self.nextPage = nextPage
        self.offset = offset
        self.page = page
        self.prePage = prePage
        self.slider = slider
        self.startRow = startRow
        self.totalCount = totalCount
        self.totalPages = totalPages
    }
    
    static func defaultPaginator() -> PaginatorModel {
        return PaginatorModel(endRow: 0, firstPage: true, hasNextPage: false, hasPrePage: false, lastPage: true, limit: 0, nextPage: 1, offset: 1, page: 1, prePage: 1, slider: [1], startRow: 1, totalCount: 0, totalPages: 1)
    }
}
