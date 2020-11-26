//
//  FKYCornerRadiusGradientButton.swift
//  FKY
//
//  Created by airWen on 2017/5/12.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

class FKYCornerRadiusGradientButton: UIButton {
    fileprivate var shadowColor: UIColor?
    
    func setGradualChangingColor(_ fromHexColor: UInt, toHexColor: UInt, shadowColor: UInt) {
        var gLayer: CAGradientLayer?
        
        if let slayers = layer.sublayers {
            for sublayer in slayers {
                if sublayer.isKind(of: CAGradientLayer.self) {
                    gLayer = (sublayer as! CAGradientLayer)
                }
                break
            }
        }
        if nil == gLayer {
            gLayer = CAGradientLayer()
        }
        
        if let gradientLayer = gLayer {
            gradientLayer.frame = bounds
            gradientLayer.colors = [RGBColor(fromHexColor).cgColor, RGBColor(toHexColor).cgColor]
            gradientLayer.cornerRadius = layer.cornerRadius
            gradientLayer.masksToBounds = layer.masksToBounds
            //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
            gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
            //  设置颜色变化点，取值范围 0.0~1.0
            gradientLayer.locations = [NSNumber.init(value: 0 as Int32), NSNumber.init(value: 1 as Int32)]
            
            // Shadow
            self.shadowColor = RGBColor(shadowColor)
            self.layer.shadowOffset = CGSize.init(width: 3, height: 3)
            self.layer.shadowColor = self.shadowColor!.cgColor
            self.layer.shadowOpacity = 0.6
            self.layer.addSublayer(gradientLayer)
            gradientLayer.zPosition = -1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        
        if let slayers = layer.sublayers {
            for sublayer in slayers {
                if sublayer.isKind(of: CAGradientLayer.self) {
                    sublayer.frame = layer.bounds
                    sublayer.shadowRadius = layer.cornerRadius
                    sublayer.cornerRadius = layer.cornerRadius
                    sublayer.masksToBounds = layer.masksToBounds
                    if nil != shadowColor {
                        let path: UIBezierPath = UIBezierPath(roundedRect: self.layer.bounds.insetBy(dx: 3, dy: 3), byRoundingCorners: [UIRectCorner.bottomRight], cornerRadii: CGSize.init(width: layer.cornerRadius, height: layer.cornerRadius))
                        layer.shadowPath = path.cgPath
                    }
                    
                    break
                }
                
            }
        }
    }
}
