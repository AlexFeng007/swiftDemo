//
//  FKYAttributedStringExtension.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    /// 快速创建一个富文本
    static func getAttributedStringWith(contentStr:String,color:UIColor,font:UIFont) -> NSAttributedString{
        var tempStr = contentStr
        if tempStr.isEmpty == true{
            tempStr = "请不要传入一个空字符串"
        }
        let attriString = NSMutableAttributedString(string: tempStr)
        attriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color, range:NSRange.init(location:0, length: contentStr.count))
        attriString.addAttribute(NSAttributedString.Key.font, value:font, range:NSRange.init(location:0, length: contentStr.count))
        return attriString.copy() as! NSAttributedString
    }
}
