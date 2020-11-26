//
//  SeckillActivityPaginatorModel.swift
//  FKY
//
//  Created by Andy on 2018/11/26.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class SeckillActivityPaginatorModel: NSObject, JSONAbleType {
    // 接口返回字段
    var hasNextPage: String?
    var prePage: String?
    var nextPage: String?      //
    var firstPage: String?
    var hasPrePage: String?
    var lastPage: String?
    var page : String?
    var endRow : String?
    var limit : String?
    
    init(hasNextPage: String?,prePage: String?,nextPage : String?,firstPage : String?,hasPrePage : String?,lastPage: String?,page: String?,endRow: String?,limit: String?) {
        self.hasNextPage = hasNextPage
        self.prePage = prePage
        self.nextPage = nextPage
        self.firstPage = firstPage
        self.hasPrePage = hasPrePage
        self.lastPage = lastPage
        self.page = page
        self.endRow = endRow
        self.limit = limit
    }
    
    // 数据解析
    static func fromJSON(_ json: [String : AnyObject]) -> SeckillActivityPaginatorModel {
        let j = JSON(json)
        
        let hasNextPage = j["hasNextPage"].stringValue
        let prePage = j["prePage"].stringValue
        let nextPage = j["nextPage"].stringValue
        let firstPage = j["firstPage"].stringValue
        let hasPrePage = j["hasPrePage"].stringValue
        let lastPage = j["lastPage"].stringValue
        let page = j["page"].stringValue
        let endRow = j["endRow"].stringValue
        let limit = j["limit"].stringValue
        
        return SeckillActivityPaginatorModel(hasNextPage: hasNextPage,prePage: prePage,nextPage : nextPage,firstPage:firstPage,hasPrePage:hasPrePage,lastPage:lastPage,page:page,endRow:endRow,limit:limit)
    }
}
