//
//  HomeTemplateAction.swift
//  FKY
//
//  Created by Rabe on 14/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

class HomeTemplateAction: TemplateAction {
    var actionType: HomeTemplateActionType = .unknow
    var needRecord = true // 默认当前操作需要埋点
}

class TemplateAction: NSObject {
    var actionParams: Dictionary<String, Any> = [String: Any]()
    
    // 埋点字段
    var floorPosition: String = ""
    var floorCode: String = ""
    var floorName : String = ""
    var sectionCode: String = ""
    var sectionPosition: String = ""
    var sectionName: String = ""
    var itemCode: String = ""
    var itemPosition: String = ""
    var itemName: String = ""
    var itemTitle: String = ""
    var itemContent: String = ""
    var extenParams: Dictionary<String, AnyObject> = [String: AnyObject]()
}
