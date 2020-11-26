//
//  FKYSelfTagManager.swift
//  FKY
//
//  Created by My on 2019/11/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

//自营标签颜色
@objc enum FKYSelfTagColorType: UInt {
    case blue = 0x2D8AFF //蓝
    case red = 0xFF2D5C //红
    case purple = 0x8726E7  //紫
    case orange = 0xFF7327  //橙
}

@objc class FKYSelfTagManager: NSObject {
    
    @objc static let shareInstance = FKYSelfTagManager()
    
    //保存生成的自营仓库image
    var selfTagImages: Dictionary<String, UIImage> = [:]
    
    var selfTag = "自营"
    var tagWidth: CGFloat =  0.0
    
    @objc var tagTextFont = UIFont.boldSystemFont(ofSize: WH(11))
    let tagHeight: CGFloat = WH(15)
    
    //根据仓库名生成Image
    @objc func tagNameImage(tagName: String, colorType: FKYSelfTagColorType) -> UIImage? {
        
        guard tagName.isEmpty == false else {
            return nil
        }
        selfTag = "自营"
        //存储key
        let key = selfTag + tagName + "\(colorType.rawValue)"
        if let image = selfTagImages[key] {
            return image
        }
        
        
        if tagWidth <= 0 {
            tagWidth = textWidth(selfTag)
        }
        
        let nameWidth = textWidth(tagName)
        
        let tagView = FKYSelfTagView(frame: CGRect(x: 0, y: 0, width: tagWidth + nameWidth, height: tagHeight), tag: selfTag, tagWidth: tagWidth, tagName: tagName, tagNameWidth: nameWidth, color: RGBColor(colorType.rawValue),WH(2),tagTextFont,tagHeight)
        
        //渲染image
        UIGraphicsBeginImageContextWithOptions(tagView.frame.size, false, 0)
        if let ctx = UIGraphicsGetCurrentContext() {
            tagView.layer.render(in:ctx)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let tagImg = img else { return nil }
        selfTagImages[key] = tagImg
        return tagImg
    }
    
    //根据仓库名生成Image
    @objc func tagNameForMpImage(tagName: String, colorType: FKYSelfTagColorType) -> UIImage? {
        
        guard tagName.isEmpty == false else {
            return nil
        }
        selfTag = "药城"
        //存储key
        let key = selfTag + tagName + "\(colorType.rawValue)"
        if let image = selfTagImages[key] {
            return image
        }
        
        
        if tagWidth <= 0 {
            tagWidth = textWidth(selfTag)
        }
        
        let nameWidth = textWidth(tagName)
        
        let tagView = FKYSelfTagView(frame: CGRect(x: 0, y: 0, width: tagWidth + nameWidth, height: tagHeight), tag: selfTag, tagWidth: tagWidth, tagName: tagName, tagNameWidth: nameWidth, color: RGBColor(colorType.rawValue),WH(2),tagTextFont,tagHeight)
        
        //渲染image
        UIGraphicsBeginImageContextWithOptions(tagView.frame.size, false, 0)
        if let ctx = UIGraphicsGetCurrentContext() {
            tagView.layer.render(in:ctx)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let tagImg = img else { return nil }
        selfTagImages[key] = tagImg
        return tagImg
    }
    //根据仓库名生成Image
    @objc func tagNameImageWithBordeWidth(tagName: String, colorType: FKYSelfTagColorType) -> UIImage? {
        
        guard tagName.isEmpty == false else {
            return nil
        }
        selfTag = "自营"
        //存储key（店铺详情中专用）
        let key = tagName + "\(colorType.rawValue)" + "shopDetail"
        if let image = selfTagImages[key] {
            return image
        }
        
        
        if tagWidth <= 0 {
            tagWidth = textWidth(selfTag)
        }
        
        let nameWidth = textWidth(tagName)
        
        let tagView = FKYSelfTagView(frame: CGRect(x: 0, y: 0, width: tagWidth + nameWidth, height: tagHeight), tag: selfTag, tagWidth: tagWidth, tagName: tagName, tagNameWidth: nameWidth, color: RGBColor(colorType.rawValue),WH(1),tagTextFont,tagHeight)
        
        //渲染image
        UIGraphicsBeginImageContextWithOptions(tagView.frame.size, false, 0)
        if let ctx = UIGraphicsGetCurrentContext() {
            tagView.layer.render(in:ctx)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let tagImg = img else { return nil }
        selfTagImages[key] = tagImg
        return tagImg
    }
    
    //搜索低匹配
    @objc func tagNameImageForSearch(tagName: String, colorType: FKYSelfTagColorType,font:UIFont) -> UIImage? {
        
        guard tagName.isEmpty == false else {
            return nil
        }
        tagTextFont = font
        selfTag = "自营"
        //存储key
        let key = tagName + "\(colorType.rawValue)" + "search"
        if let image = selfTagImages[key] {
            return image
        }
        
        
        if tagWidth <= 0 {
            tagWidth = textWidth(selfTag)
        }
        
        let nameWidth = textWidth(tagName)
        
        let tagView = FKYSelfTagView(frame: CGRect(x: 0, y: 0, width: tagWidth + nameWidth, height: tagHeight), tag: selfTag, tagWidth: tagWidth, tagName: tagName, tagNameWidth: nameWidth, color: RGBColor(colorType.rawValue),WH(2),tagTextFont,tagHeight)
        
        //渲染image
        UIGraphicsBeginImageContextWithOptions(tagView.frame.size, false, 0)
        if let ctx = UIGraphicsGetCurrentContext() {
            tagView.layer.render(in:ctx)
            tagView.layer.backgroundColor = UIColor.clear.cgColor
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let tagImg = img else { return nil }
        selfTagImages[key] = tagImg
        return tagImg
    }
    func textWidth(_ text: String) -> CGFloat {
        return text.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height:tagHeight), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : tagTextFont], context: nil).width + WH(6)
    }
}
//商品详情生成标签<标签高度和字体大小自定义>
extension FKYSelfTagManager {
    @objc func creatZiyingTag() -> UIImage?{
        let key = "prdDetail_ziying"
        if let image = selfTagImages[key] {
            return image
        }
        let lbl = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: WH(36), height: WH(18)))
        lbl.text = "自营"
        lbl.textColor = RGBColor(0xffffff)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(12))
        lbl.backgroundColor = RGBColor(0x2D8AFF)
        lbl.textAlignment = .center
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = WH(18)/2.0
        UIGraphicsBeginImageContextWithOptions(lbl.bounds.size, false, UIScreen.main.scale)
        lbl.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        guard let tagImg = image else { return nil }
        selfTagImages[key] = tagImg
        return tagImg
    }
    @objc func creatMPTag() -> UIImage?{
        let key = "prdDetail_mp"
        if let image = selfTagImages[key] {
            return image
        }
        let lbl = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: WH(36), height: WH(18)))
        lbl.text = "商家"
        lbl.textColor = RGBColor(0xffffff)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(12))
        lbl.backgroundColor = RGBColor(0xF4B65C)
        lbl.textAlignment = .center
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = WH(18)/2.0
        UIGraphicsBeginImageContextWithOptions(lbl.bounds.size, false, UIScreen.main.scale)
        lbl.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        guard let tagImg = image else { return nil }
        selfTagImages[key] = tagImg
        return tagImg
    }
    
    //根据仓库名生成Image
    @objc func tagNameForMpOrZiyingDetailImage(selfTagStr:String, tagName: String, colorType: FKYSelfTagColorType) -> UIImage? {
        guard tagName.isEmpty == false else {
            return nil
        }
        //存储key
        let key = selfTagStr + tagName + "\(colorType.rawValue)" + "prdDetail"
        if let image = selfTagImages[key] {
            return image
        }
        let tagWidth = textStrWidth(selfTagStr)
        let nameWidth = textStrWidth(tagName)
        let tagView = FKYSelfTagView(frame: CGRect(x: 0, y: 0, width: tagWidth + nameWidth, height: WH(18)), tag: selfTagStr, tagWidth: tagWidth, tagName: tagName, tagNameWidth: nameWidth, color: RGBColor(colorType.rawValue),WH(2),UIFont.boldSystemFont(ofSize: WH(12)),WH(18))
        
        //渲染image
        UIGraphicsBeginImageContextWithOptions(tagView.frame.size, false, 0)
        if let ctx = UIGraphicsGetCurrentContext() {
            tagView.layer.render(in:ctx)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let tagImg = img else { return nil }
        selfTagImages[key] = tagImg
        return tagImg
    }
    func textStrWidth(_ text: String) -> CGFloat {
        return text.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height:WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(12))], context: nil).width + WH(6)
    }
}
@objc class FKYComboMainProductFlagManager: NSObject {
    
    @objc static let shareInstance = FKYComboMainProductFlagManager()
    
    //保存生成的自营仓库image
    var selfTagImages: Dictionary<String, UIImage> = [:]
    
    var selfTag = "主品"
    var tagWidth: CGFloat =  WH(30)
    
    @objc var tagTextFont = UIFont.boldSystemFont(ofSize: WH(11))
    let tagHeight: CGFloat = WH(14)
    
    //根据仓库名生成Image
    @objc func tagNameImage(tagName: String, colorType: FKYSelfTagColorType) -> UIImage? {
        
        guard tagName.isEmpty == false else {
            return nil
        }
        selfTag = "主品"
        //存储key
        let key = selfTag + tagName + "\(colorType.rawValue)"
        if let image = selfTagImages[key] {
            return image
        }
        let tagView = FKYComboMainProductTagView(frame: CGRect(x: 0, y: 0, width: tagWidth , height: tagHeight), tag: selfTag, tagWidth: tagWidth,color: RGBColor(colorType.rawValue),WH(1))
        
        //渲染image
        UIGraphicsBeginImageContextWithOptions(tagView.frame.size, false, 0)
        if let ctx = UIGraphicsGetCurrentContext() {
            tagView.layer.render(in:ctx)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let tagImg = img else { return nil }
        selfTagImages[key] = tagImg
        return tagImg
    }
}

//MAR:生成店铺首页标签
@objc class FKYTagFlagManager: NSObject {
    
    @objc static let shareInstance = FKYTagFlagManager()
    
    //保存生成的自营仓库image
    var selfTagImages: Dictionary<String, UIImage> = [:]
    
    @objc var tagTextFont = UIFont.boldSystemFont(ofSize: WH(11))
    let tagHeight: CGFloat = WH(14)
    
    //根据仓库名生成Image
    @objc func tagNameShopImage(tagName: String) -> UIImage? {
        
        guard tagName.isEmpty == false else {
            return nil
        }
        var type = 0
        if tagName == "特价"{
            type = 1
        }else if tagName == "奖励金" {
            type = 2
        }else if tagName == "会员"{
            type = 3
        }else if tagName == "慢必赔" {
            type = 4
        }else if tagName == "直播价" {
            type = 2
        }
        //存储key
        let key = "shopMain" + tagName
        if let image = selfTagImages[key] {
            return image
        }
        let bgView = UIView()
        let strLabel = UILabel()
        strLabel.font = UIFont.boldSystemFont(ofSize: WH(10))
        strLabel.textAlignment = .center
        if type == 1 {
            //红色背景《特价，协议返利金》
            bgView.frame = CGRect(x: 0, y: 0, width: WH(30), height: WH(15))
            bgView.cornerViewWithColor(byRoundingCorners: [.topRight , .bottomRight], radii: WH(15)/2.0, t73.color.cgColor, WH(2),t73.color.cgColor)
            strLabel.textColor = t1.color
            bgView.addSubview(strLabel)
            strLabel.frame = CGRect(x: 0, y: 0, width: WH(30), height: WH(15))
        }else if type == 2{
            //红色背景
            bgView.frame = CGRect(x: 0, y: 0, width: WH(40), height: WH(15))
            bgView.cornerViewWithColor(byRoundingCorners: [.topRight , .bottomRight], radii: WH(15)/2.0, t73.color.cgColor, WH(2),t73.color.cgColor)
            strLabel.textColor = t1.color
            bgView.addSubview(strLabel)
            strLabel.frame = CGRect(x: 0, y: 0, width: WH(40), height: WH(15))
        }else if type == 3 {
            //会员
            bgView.frame = CGRect(x: 0, y: 0, width: WH(30), height: WH(15))
            bgView.cornerViewWithColor(byRoundingCorners: [.topRight , .bottomRight], radii: WH(15)/2.0,UIColor.clear.cgColor, WH(2), UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(WH(30))).cgColor)
            strLabel.textColor =  RGBColor(0xFFDEAE)
            bgView.addSubview(strLabel)
            strLabel.frame = CGRect(x: 0, y: 0, width: WH(30), height: WH(15))
        }else if type == 4 {
            //红色线框
            bgView.frame = CGRect(x: 0, y: 0, width: WH(40), height: WH(15))
            bgView.cornerViewWithColor(byRoundingCorners: [.topRight , .bottomRight], radii: WH(15)/2.0, t73.color.cgColor, WH(2),t1.color.cgColor)
            strLabel.textColor = t73.color
            bgView.addSubview(strLabel)
            strLabel.frame = CGRect(x: 0, y: 0, width: WH(40), height: WH(15))
        }else {
            //红色线框
            bgView.frame = CGRect(x: 0, y: 0, width: WH(30), height: WH(15))
            bgView.cornerViewWithColor(byRoundingCorners: [.topRight , .bottomRight], radii: WH(15)/2.0, t73.color.cgColor, WH(2),t1.color.cgColor)
            strLabel.textColor = t73.color
            bgView.addSubview(strLabel)
            strLabel.frame = CGRect(x: 0, y: 0, width: WH(30), height: WH(15))
        }
        strLabel.text = tagName
        
        //渲染image
        UIGraphicsBeginImageContextWithOptions(bgView.frame.size, false, 0)
        if let ctx = UIGraphicsGetCurrentContext() {
            bgView.layer.render(in:ctx)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let tagImg = img else { return nil }
        selfTagImages[key] = tagImg
        return tagImg
    }
}

