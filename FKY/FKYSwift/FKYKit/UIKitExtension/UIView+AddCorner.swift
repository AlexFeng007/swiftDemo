//
//  UIView+AddCorner.swift
//  FKY
//
//  Created by My on 2019/11/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit


extension UIView {
    
    func fky_addCorners(corners: UIRectCorner, radius: CGFloat){
        let bezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath;
        layer.mask = shapeLayer
    }
    
    
    func fky_addCorners(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let bezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = borderWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.frame = bounds
        shapeLayer.path = bezierPath.cgPath
        layer.addSublayer(shapeLayer)
        
        let mask = CAShapeLayer(layer: shapeLayer)
        mask.path = bezierPath.cgPath
        layer.mask = mask
    }
    
}

