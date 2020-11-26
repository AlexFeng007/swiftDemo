//
//  FKYPageControl.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/3.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  自定义UIPageControl控件

import UIKit

class FKYPageControl: UIPageControl {
    // MARK: - Property
    
    // 默认不替代小圆点
    var replaceDot = false
    
    var dotWidth: CGFloat = 12   // 图片宽度
    var dotHeight: CGFloat = 2   // 图片高度
    var dotMargin: CGFloat = 4   // 图片间距
   
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 若使用图片替代了默认的小圆点，则需要调整图片间的间距
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //print("layoutSubviews...<FKYPageControl>")
        guard replaceDot == true, checkStatusForReplaceDotByImage() else {
            return
        }
        
        let marginX = dotWidth + dotMargin
        let widthTotal = CGFloat(subviews.count) * marginX
        self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: widthTotal, height: self.frame.size.height)
        var center = self.center
        center.x = (self.superview?.center.x)!
        self.center = center
        
        for index in 0 ..< self.subviews.count {
            let dot = self.subviews[index]
            if dot.isKind(of: UIImageView.self) {
                dot.frame = CGRect.init(x: CGFloat(index) * marginX, y: dot.frame.origin.y, width: dotWidth, height: dotHeight)
            }
        }
    }
    
    
    // MARK: - Public
    
    // 使用图片替代默认的小圆点
    func setImageToReplaceDot(color: UIColor, currentColor: UIColor, size: CGSize) {
        guard replaceDot == true, checkStatusForReplaceDotByImage() else {
            return
        }
        
        let img = UIImage.imageWithColor(color, size: size)
        let currentImg = UIImage.imageWithColor(currentColor, size: size)
        
        setValue(img, forKey: "_pageImage")
        setValue(currentImg, forKey: "_currentPageImage")
    }
    
    
    // MARK: - Private
    
    // 判断是否可以通过KVC来使用图片替代小圆点
    fileprivate func checkStatusForReplaceDotByImage() -> Bool {
        // 初始化一个属性列表数组
        var ivarName_pageControl: [String] = []
        // 属性个数
        var count: uint = 0
        // 获取属性列表
        let list = class_copyIvarList(UIPageControl.classForCoder(), &count)
        
        for index in 0 ..< count {
            // 获取属性名称，ivar_getTypeEncoding 可获取属性类型
            let ivarName = ivar_getName( (list?[ Int(index) ])! )
            let name = String.init(cString: ivarName!)
            //print("property:" + name)
            ivarName_pageControl.append(name)
        }
        
        // 判断是否包含这两个属性
        if ivarName_pageControl.contains("_pageImage") && ivarName_pageControl.contains("_currentPageImage") {
            return true
        }
        
        return false
    }
}
