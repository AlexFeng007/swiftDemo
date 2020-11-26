//
//  FKYSearchBIModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/2/26.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSearchBIModel: NSObject {
    /// 埋点事件类型 1规格筛选 2厂家筛选 3MP商家筛选 4自营商家筛选
    var type = ""
    var floorId = ""
    var floorPosition = ""
    var floorName = ""
    var sectionId = ""
    var sectionPosition = ""
    var sectionName = ""
    var itemId = ""
    var itemPosition = ""
    var itemName = ""
    var itemContent = ""
    var itemTitle = ""
    var extendParams = [String: AnyObject]()
    var viewController:UIViewController = UIViewController()
}
