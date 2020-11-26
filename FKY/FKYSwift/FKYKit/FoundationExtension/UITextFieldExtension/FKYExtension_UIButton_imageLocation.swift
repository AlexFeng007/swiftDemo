//
//  FKYExtension_UIButton_imageLocation.swift
//  FKY
//
//  Created by 曾维灿 on 2019/12/10.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  自定义按钮图片位置 leftimage topimage imagetop

import UIKit

class FKYExtension_UIButton_imageLocation: NSObject {

}

enum FKYButtonEdgeInsetsStyle {
    case Top
    case Left
    case Right
    case Bottom
}

extension UIButton {
    
    /// 自定义按钮的文字和图片位置
    /// - Parameters:
    ///   - style: 图片的位置
    ///   - imageTitleSpace: 图片和文字的间隔
    func layoutButton(style: FKYButtonEdgeInsetsStyle, imageTitleSpace: CGFloat) {
        //得到imageView和titleLabel的宽高
        let imageWidth = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
        let version:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
     
        if  Double(version) ?? 0.0 >= 8.0 {
            labelWidth = self.titleLabel?.intrinsicContentSize.width
            labelHeight = self.titleLabel?.intrinsicContentSize.height
        }else{
            labelWidth = self.titleLabel?.frame.size.width
            labelHeight = self.titleLabel?.frame.size.height
        }
        
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
            case .Top:
                //上 左 下 右
                imageEdgeInsets = UIEdgeInsets(top: -labelHeight-imageTitleSpace/2, left: 0, bottom: 0, right: -labelWidth)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight!-imageTitleSpace/2, right: 0)
                break;
                
            case .Left:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageTitleSpace/2, bottom: 0, right: imageTitleSpace)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: imageTitleSpace/2, bottom: 0, right: -imageTitleSpace/2)
                break;
                
            case .Bottom:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight!-imageTitleSpace/2, right: -labelWidth)
                labelEdgeInsets = UIEdgeInsets(top: -imageHeight!-imageTitleSpace/2, left: -imageWidth!, bottom: 0, right: 0)
                break;
                
            case .Right:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+imageTitleSpace/2, bottom: 0, right: -labelWidth-imageTitleSpace/2)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!-imageTitleSpace/2, bottom: 0, right: imageWidth!+imageTitleSpace/2)
                break;
                
        }
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        
    }
}


