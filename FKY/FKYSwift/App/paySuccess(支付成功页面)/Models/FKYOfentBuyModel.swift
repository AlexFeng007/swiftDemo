//
//  FKYOfentBuyModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/23.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYOfentBuyModel: NSObject,HandyJSON {
    required override init() {}
    
    /// list名称 如：常购清单
    var floorName = ""
    
    ///是否还有下一页
    var hasNextPage = true
    
    ///商品列表
    var list:[HomeCommonProductModel] = []
    
    /// 下一页的页码，请确保有下一页的情况下再取此页码
    var nextPageId = 1
    
    /// 当前页码
    var pageId = 1
    
    /// 单页大小
    var pageSize = 10
    
    /// 当前数据可获取的总条数
    var totalItemCount = 0
    
    /// 当前可获取数据的总页数
    var totalPageCount = 0
}
