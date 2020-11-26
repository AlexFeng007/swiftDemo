//
//  FKYStationMsgCellModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/9/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYStationMsgCellModel: NSObject {
    enum cellType {
        case notSet
        /// 头部两个固定item的cell
        case type1Cell
        /// 消息cell
        case type2Cell
    }
    
    var type:cellType = .notSet
    
    var data:FKYStationMsgModel = FKYStationMsgModel()
    
    var type1DataList:[FKYStationMsgModel] = []
    
}
