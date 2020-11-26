//
//  UIView+Frame.swift
//  hdKuGou_Swift
//
//  Created by Darren on 16/8/6.
//  Copyright © 2016年 darren. All rights reserved.
//
import UIKit

extension UIView {
    
    ///left
    @objc var hd_left:CGFloat{
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x    = newValue
            frame                 = tempFrame
        }
    }
    
    ///right
    @objc var hd_right:CGFloat{
        get {
            return frame.origin.x+frame.size.width
        }
//        set(newValue) {
//            var tempFrame: CGRect = frame
//            tempFrame.origin.x    = newValue
//            frame                 = tempFrame
//        }
    }
    
    ///top
    @objc var hd_top: CGFloat{
        get {
            return frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.y    = newValue
            frame                 = tempFrame
        }
    }
    
    ///bottom
    @objc var hd_bottom:CGFloat{
        get {
            return frame.origin.y+frame.size.height
        }
//        set(newValue) {
//            var tempFrame: CGRect = frame
//            tempFrame.origin.y    = newValue
//            frame                 = tempFrame
//        }
    }
    
    /// x
    @objc var hd_x: CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x    = newValue
            frame                 = tempFrame
        }
    }
    
    /// y
    @objc var hd_y: CGFloat {
        get {
            return frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.y    = newValue
            frame                 = tempFrame
        }
    }
    
    /// height
    @objc var hd_height: CGFloat {
        get {
            return frame.size.height
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.height = newValue
            frame                 = tempFrame
        }
    }
    
    /// width
    @objc var hd_width: CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    /// size
    @objc var hd_size: CGSize {
        get {
            return frame.size
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
    
    /// centerX
    @objc var hd_centerX: CGFloat {
        get {
            return center.x
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
    
    /// centerY
    @objc var hd_centerY: CGFloat {
        get {
            return center.y
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.y = newValue
            center = tempCenter;
        }
    }
    
}

extension UIView {
    //切圆角
    func cornerViewWithColor(byRoundingCorners corners: UIRectCorner, radii: CGFloat, _ borderColor : CGColor?, _ borderW:CGFloat?,_ fillColor:CGColor?) {
        if let desColor = borderColor ,let desW = borderW ,let bgColor = fillColor{
            //画边框
            let borderLayer = CAShapeLayer()
            let borderPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: self.bounds.size.height, height: self.bounds.size.height))
            borderLayer.lineCap = CAShapeLayerLineCap.square
            borderLayer.lineWidth = desW
            borderLayer.strokeColor = desColor
            borderLayer.fillColor = bgColor
            borderLayer.path = borderPath.cgPath
            self.layer.addSublayer(borderLayer)
            
            let mask = CAShapeLayer(layer: borderLayer)
            mask.path = borderPath.cgPath
            self.layer.mask = mask
        }
    }
    
    //设置圆角
    func setMutiRoundingCorners(_ corner:CGFloat,_ corners: UIRectCorner){
        let maskPath = UIBezierPath.init(roundedRect: self.bounds,
                                         
                                         byRoundingCorners: corners,
                                         
                                         cornerRadii: CGSize(width: corner, height: corner))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = self.bounds
        
        maskLayer.path = maskPath.cgPath
        self.layer.shouldRasterize = true
        self.layer.mask = maskLayer
        
    }
    
}


extension UITableViewCell{
    
    @objc func configCellDisplayInfo(){
        
    }
}

extension UICollectionViewCell {
    
    @objc func configItemDisplayInfo(){
        
    }
}
