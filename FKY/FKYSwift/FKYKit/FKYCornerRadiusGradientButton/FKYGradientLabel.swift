//
//  FKYGradientLabel.swift
//  FKY
//
//  Created by airWen on 2017/5/12.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

class FKYGradientLabel: UILabel {
    func setGradualChangingColor(_ fromHexColor: UInt, toHexColor: UInt) {
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
            gradientLayer.locations = [0, 1]
            self.layer.addSublayer(gradientLayer)
            gradientLayer.zPosition = -1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        layer.masksToBounds = true;
//        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        
        if let slayers = layer.sublayers {
            for sublayer in slayers {
                if sublayer.isKind(of: CAGradientLayer.self) {
                    sublayer.frame = layer.bounds
                    sublayer.shadowRadius = layer.cornerRadius
                    sublayer.cornerRadius = layer.cornerRadius
                    sublayer.masksToBounds = layer.masksToBounds
                    break
                }
            }
        }
    }
}

extension UILabel {
    //调整显示的价格
    func adjustPriceLabel() {
        if let priceStr = self.text,priceStr.contains("¥") {
            let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
            priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
            self.attributedText = priceMutableStr
        }
    }
    //调整内边距
    func adjustTagLabelContentInset(_ contentInsetNum:CGFloat) -> CGFloat {
        if let tagStr = self.text {
            let strMaxW = tagStr.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:self.font], context: nil).size.width + contentInsetNum
            self.snp.updateConstraints { (make) in
                make.width.equalTo(strMaxW)
            }
            return strMaxW
        }
        return 0
    }
    //调整显示的价格根据字体大小
    func adjustPriceLabelWihtFont(_ font:UIFont) {
        if let priceStr = self.text,priceStr.contains("¥") {
            let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
            priceMutableStr.addAttributes([NSAttributedString.Key.font:font], range: NSMakeRange(0, 1))
            self.attributedText = priceMutableStr
        }
    }
}
