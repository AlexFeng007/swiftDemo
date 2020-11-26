//
//  FKYHomePageV3FloorModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/22.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYHomePageV3FloorModel: NSObject,HandyJSON {
    
    override required init() {}
    
    /// 当前楼层描述
    var floorDescription:String = ""
    /// 当前楼层名称
    var floorName:String = ""
    /// 楼层类型
    var floorStyle:String = ""
    /// 页码和时间戳
    var pageTimeStamp:String = ""
    /// 楼层id
    var templateId:Int = -199
    /// 楼层类型/楼层模板id
    var templateType:Int = -199
    /// 当前楼层中的内容
    var contents:FKYHomePageV3ContentsModel = FKYHomePageV3ContentsModel()
    
    /// 不知道啥意思
    var disableDivider:Bool = false
    var showSequence:String = ""
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &floorDescription, name: "description")
    }
}
