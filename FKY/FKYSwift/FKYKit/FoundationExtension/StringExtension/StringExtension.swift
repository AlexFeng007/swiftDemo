//
//  StringExtension.swift
//  FKY
//
//  Created by Rabe on 11/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import Foundation

extension String {
    /// 在string之间添加行间距
    ///
    /// - Parameter lineSpace: 行间距
    /// - Returns: 转化后的值
    func fky_getAttributedStringWithLineSpace(_ lineSpace:CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let paragraphStye = NSMutableParagraphStyle()
        paragraphStye.lineSpacing = lineSpace
        let range = NSMakeRange(0, CFStringGetLength(self as CFString?))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStye, range: range)
        return attributedString
    }
    
    //设置富文本
    func fky_getAttributedHTMLStringWithLineSpace(_ lineSpace:CGFloat) -> NSMutableAttributedString? {
        var contentStr = self.replacingOccurrences(of:"&quot;", with: "\"")
        contentStr = contentStr.replacingOccurrences(of:"&apos;", with: "'")
        contentStr = contentStr.replacingOccurrences(of:"&lt;", with: "<")
        contentStr = contentStr.replacingOccurrences(of:"&gt;", with: ">")
        contentStr = contentStr.replacingOccurrences(of:"&amp;", with: "&")
        let data:NSData? = contentStr.data(using: String.Encoding.unicode, allowLossyConversion: true) as NSData?
        do {
            let attributedString = try NSMutableAttributedString(data: data! as Data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
//            let paragraphStye = NSMutableParagraphStyle()
//            paragraphStye.lineSpacing = lineSpace
//            let range = NSMakeRange(0, CFStringGetLength(self as CFString?))
//            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStye, range: range)
             return attributedString
        } catch  {
            
        }
        return nil
    }
    
    /// 在string的下方添加下划线
    ///
    /// - Returns: 转化后的值
    func fky_getAttributedStringWithUnderLine() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let range = NSMakeRange(0, CFStringGetLength(self as CFString?))
        let value = NSNumber.init(value: Int8(NSUnderlineStyle.single.rawValue))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: value, range: range)
        return attributedString
    }
}

extension String {
    /// 针对yyyy-mm-dd HH:MM:SS格式转化成 yyyy-mm-dd
    ///
    /// - Returns: 转化后的值
    func removeHHMMSS() -> String {
        if self.contains(":") {
            let arr = self.components(separatedBy: " ")
            if arr.count == 2 {
                var ret = arr[0]
                ret = ret.replacingOccurrences(of: "-", with: ".")
                return ret
            }
        }
        return self
    }
    func dateChangeToFormat(_ formatStr:String)->(String){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        if  let date = formatter.date(from: self) {
            let chineseFormatter = DateFormatter()
            chineseFormatter.dateFormat = formatStr
            return chineseFormatter.string(from: date)
        }
        return ""
    }
}

extension String {
    /// 将String转成NSNumber，若转化识别，默认返回@(0)
    ///
    /// - Returns: 转化后的值
    func toNSNumber() -> NSNumber {
        var number = NSNumber(value: 0)
        if let integerValue = Int(self) {
            number = NSNumber(value: integerValue)
        }else if let floatValue = Float(self) {
            number = NSNumber(value: floatValue)
        }
        return number
    }
}


