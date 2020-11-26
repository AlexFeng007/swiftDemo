//
//  FKYHomePageV3SectionModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePageV3SectionModel: NSObject {

    enum SectionType {
        /// 无意义默认值
        case notSet
        /// 上方楼层section
        case floorSection
        /// 下方切换tab的section
        case switchTabSection
    }
    
    var sectionType:SectionType = .notSet
    /// section中的cell列表
    var cellList:[FKYHomePageV3CellModel] = [FKYHomePageV3CellModel]()
    var switchTabHeaderData:[FKYHomePageV3SwitchTabModel] = [FKYHomePageV3SwitchTabModel]()
    
}
