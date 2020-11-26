//
//  LiveMessageMode.swift
//  FKY
//
//  Created by yyc on 2020/8/18.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveMessageMode: NSObject {
   var groupId = ""
   var messageStr = ""
   var nickName = ""
   var nickNameColor = RGBColor(0xFF6247) //记录昵称颜色
    
    //处理后的nickname
    var dealnickName : String {
        get {
            let desStr = nickName
//            if nickName.count > 4 {
//                let preStr = (nickName as NSString).substring(to: 2)
//                let lastStr = (nickName as NSString).substring(from: nickName.count - 2)
//                desStr = "\(preStr)...\(lastStr)"
//            }
            return desStr
        }
    }
}
