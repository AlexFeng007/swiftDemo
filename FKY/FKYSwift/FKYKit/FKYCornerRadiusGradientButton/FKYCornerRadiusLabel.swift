//
//  FKYCornerRadiusLabel.swift
//  FKY
//
//  Created by airWen on 2017/5/17.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

class FKYCornerRadiusLabel: UILabel {
    
    var MaxWidth: CGFloat?
    var isNewLabel:Bool = false //true 为页码计数器
    
    //计数器初始化一些参数
    func initBaseInfo(){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = LBLABEL_H/2.0
        self.textAlignment = .center
        self.backgroundColor = RGBAColor(0x000000, alpha: 0.7)
        self.textColor = RGBColor(0xFFFFFF)
        self.font = t7.font
        self.MaxWidth = SCREEN_WIDTH - 100
        self.isNewLabel = true
        self.isHidden = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true;
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
    
    override func drawText(in rect: CGRect) {
        var diameter = min(rect.width, rect.height)
        if (diameter - 4) > 8 {
            diameter = (diameter - 4)
        }
        if rect.width < diameter {
            super.drawText(in: rect)
        }else {
            super.drawText(in: CGRect(x: diameter/2, y: rect.origin.y, width: rect.width-diameter, height: rect.height))
        }
    }
    
    override var intrinsicContentSize : CGSize {
        let sizeOrigin: CGSize = super.intrinsicContentSize
        if let contentString = self.text, contentString != "" {
            var diameter :CGFloat = 0
            if isNewLabel {
                diameter = WH(25)
            }else{
                diameter = min(sizeOrigin.width, sizeOrigin.height)
                if (diameter - 4) > 8 {
                    diameter = (diameter - 4)
                }
            }
            let wdithMax = (nil == MaxWidth) ? SCREEN_WIDTH : MaxWidth!
            if (sizeOrigin.width + diameter) < wdithMax {
                return CGSize(width: (sizeOrigin.width + diameter), height: sizeOrigin.height)
            }else {
                let newHeight = contentString.heightForFontAndWidth(self.font, width: sizeOrigin.width - diameter, attributes: [NSAttributedString.Key.font.rawValue:self.font])
                return CGSize.init(width: sizeOrigin.width, height:  ceil(newHeight))
            }
        }else {
            return sizeOrigin
        }
    }
}
