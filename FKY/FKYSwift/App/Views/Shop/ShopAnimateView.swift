//
//  ShopAnimateView.swift
//  FKY
//
//  Created by hui on 2018/4/19.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class ShopAnimateView: UIView {
    
    private var marqueeTitle:String?
    private var mark1:CGRect!
    private var mark2:CGRect!
    private var labArr = [UILabel]()
    var isStop = false
    private var timeInterval1: TimeInterval!
    
    var reserveTextLb :UILabel?
    var lab :UILabel?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configAnimateViewInfo(_ title : String){
        labArr.removeAll()
        for  iv in self.subviews {
            iv.removeFromSuperview()
        }
        marqueeTitle = title
        self.clipsToBounds = true
        timeInterval1 = TimeInterval((marqueeTitle?.count)!/5)
        
        let lab = UILabel()
        lab.frame = CGRect.zero
        lab.textColor = UIColor.white
        lab.font = t25.font
        lab.text = marqueeTitle
        
        //计算textLab的大小
        let sizeOfText = lab.sizeThatFits(CGSize.zero)
        mark1 = CGRect.init(x: 0, y: 0, width: sizeOfText.width+70, height: self.bounds.size.height)
        mark2 = CGRect.init(x: mark1.origin.x+mark1.size.width, y: 0, width: sizeOfText.width, height: self.bounds.size.height)
        lab.frame = mark1
        self.addSubview(lab)
        labArr.append(lab)
        
        let useReserve = sizeOfText.width > frame.size.width ? true : false
        
        self.lab = lab
        if useReserve == true {
            let reserveTextLb = UILabel(frame: mark2)
            reserveTextLb.textColor = UIColor.white
            reserveTextLb.font = t25.font
            reserveTextLb.text = marqueeTitle;
            self.addSubview(reserveTextLb)
            
            labArr.append(reserveTextLb)
            self.reserveTextLb = reserveTextLb
            self.labAnimation()
        }
    }
    //跑马灯动画
    func labAnimation() {
        if (!isStop) {
            let lbindex0 = labArr[0]
            if labArr.count > 1{
                let lbindex1 = labArr[1]
                UIView.transition(with: self, duration: timeInterval1, options: UIView.AnimationOptions.curveLinear, animations: {
                    lbindex0.frame = CGRect.init(x: -self.mark1.size.width, y: 0, width: self.mark1.size.width, height: self.mark1.size.height)
                    lbindex1.frame = CGRect.init(x: lbindex0.frame.origin.x+lbindex0.frame.size.width, y: 0, width: lbindex1.frame.size.width, height: lbindex1.frame.size.height)
                    
                }, completion: { finished in
                    lbindex0.frame = self.mark2
                    lbindex1.frame = self.mark1
                    self.labArr[0] = lbindex1
                    self.labArr[1] = lbindex0
                    self.labAnimation()
                })
            }
        } else {
            
            self.layer.removeAllAnimations()
        }
        
    }
    
    func start() {
        isStop = false
        let lbindex0 = labArr[0]
        lbindex0.frame = mark2;
        if labArr.count > 1{
            let lbindex1 = labArr[1]
            lbindex1.frame = mark1
            self.labArr[0] = lbindex1
            self.labArr[1] = lbindex0
        }
        self.labAnimation()
        
    }
    
    func stop() {
        isStop = true
        self.labAnimation()
    }
}
