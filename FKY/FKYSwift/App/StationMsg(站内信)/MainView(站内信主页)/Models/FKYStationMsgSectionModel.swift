//
//  FKYStationMsgSectionModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/9/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYStationMsgSectionModel: NSObject {
    
    enum sectionType {
        /// 未设置
        case notSet
        /// 上方固定模块消息
        case modelSeciton
        /// 本周消息
        case currentMsg
        /// 上周消息
        case lastWeakMsg
    }
    
    var cellList:[FKYStationMsgCellModel] = []
    //var sectionType
    var sectionHeaderText:String = ""
    
    var type:sectionType = .notSet
}
