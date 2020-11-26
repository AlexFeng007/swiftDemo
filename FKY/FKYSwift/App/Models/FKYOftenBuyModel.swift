//
//  FKYOftenBuyModel.swift
//  FKY
//
//  Created by 乔羽 on 2018/8/21.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import Foundation

class FKYOftenBuyModel {
    var dataSource: Array<OftenBuyProductItemModel> = []
    var page = 1
    var pageSize = 10
    var isMore = true
    var isFirstLoad = true
    var isHaveData = true
    var isNotMoreData = true //首页常购清单判断数据
}
class FKYOftenTitleModel {
    var title:String?
    var type:FKYOftenBuyType?
}
