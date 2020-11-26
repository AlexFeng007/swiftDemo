//
//  FKYStationMsgModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/9/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYStationMsgModel: NSObject ,HandyJSON{
    required override init() {    }
    
    /// 是否一周前
    var beforeWeek:Bool = false;
    
    /// 消息内容
    var content:String = ""
    
    /// 时间
    var createTime:String = ""
    
    var enterpriseId:Int = -199
    
    var hasRead:Bool = false
    
    var msgId:String = ""
    
    var imPosition:String = ""
    
    var imgUrl:String  = ""
    
    var jumpUrl:String = ""
    
    var pushTime:String = ""
    
    var title:String = ""
    
    var type:Int = -199
    
    var unreadCount = -199
    
    var userId = -199
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &msgId, name: "id")
    }
}
