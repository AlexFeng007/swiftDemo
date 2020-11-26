//
//  PromotionTagLabel.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/29.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

class PromotionTagLabel: UILabel {
    
    var subLayer: CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let width = frame.width
        let finalSize = CGSize(width: width, height: WH(15))
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 0, y: finalSize.height))
        bezier.addLine(to: CGPoint(x: 0, y: 0))
        bezier.addLine(to: CGPoint(x: WH(width-7.5), y: 0))
        bezier.addArc(withCenter: CGPoint(x: WH(width-7.5), y: WH(7.5)), radius: WH(7.5), startAngle: CGFloat(Double.pi*3/2), endAngle: CGFloat(Double.pi/2), clockwise: true)
        bezier.addLine(to: CGPoint(x: 0, y: finalSize.height))
        bezier.lineCapStyle = .round
        bezier.lineJoinStyle = .round
        subLayer.path = bezier.cgPath
        self.layer.addSublayer(subLayer)
        
        self.backgroundColor = UIColor.clear
        self.font = UIFont.systemFont(ofSize: WH(10))
        self.textColor = UIColor.white
        self.textAlignment = .center
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: WH(30), height: WH(15)))
        
        let finalSize = CGSize(width: WH(30), height: WH(15))
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 0, y: finalSize.height))
        bezier.addLine(to: CGPoint(x: 0, y: 0))
        bezier.addLine(to: CGPoint(x: WH(15+7.5), y: 0))
        bezier.addArc(withCenter: CGPoint(x: WH(15+7.5), y: WH(7.5)), radius: WH(7.5), startAngle: CGFloat(Double.pi*3/2), endAngle: CGFloat(Double.pi/2), clockwise: true)
        bezier.addLine(to: CGPoint(x: 0, y: finalSize.height))
        bezier.lineCapStyle = .round
        bezier.lineJoinStyle = .round
        subLayer.path = bezier.cgPath
        subLayer.fillColor = RGBColor(0xFF2D5C).cgColor
        self.layer.addSublayer(subLayer)
        
        self.backgroundColor = UIColor.clear
        self.font = UIFont.systemFont(ofSize: WH(10))
        self.textColor = UIColor.white
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView(_ color: UIColor) {
        subLayer.fillColor = color.cgColor
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
