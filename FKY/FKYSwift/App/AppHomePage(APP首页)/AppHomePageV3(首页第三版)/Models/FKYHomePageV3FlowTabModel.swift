//
//  FKYHomePageV3FlowTabModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON
class FKYHomePageV3FlowTabModel: NSObject,HandyJSON {
    required override init() {    }
    /// 不知道什么意思或代表什么或用到哪里 所有可选类型都是未知的数据类型，如果后期开发中，明确字段用法，请务必赋默认值
    var floorName : String = ""
    /// 是否正在刷新中
    var isUPloading:Bool = false
    var hasNextPage : Bool = true
    var nextPageId : Int = 2
    var pageId : Int = 1
    var pageSize : Int?
    var totalItemCount : Int?
    var totalPageCount : Int?
    var list:[FKYHomePageV3FlowItemModel] = [FKYHomePageV3FlowItemModel]()
    
}
