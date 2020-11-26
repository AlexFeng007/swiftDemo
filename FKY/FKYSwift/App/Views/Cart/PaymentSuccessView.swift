//
//  PaymentSuccessView.swift
//  FKY
//
//  Created by yangyouyong on 2016/9/13.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

@objc
class PaymentSuccessView: UIView {

    fileprivate var bgView: UIView?
    fileprivate var iconView:UIImageView?
    fileprivate var titleLabel: UILabel?
    fileprivate var subTitleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        self.bgView = {
            let v = UIView()
            self.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.left.right.equalTo(self)
                make.top.equalTo(self)
                make.bottom.equalTo(self)
            })
            v.backgroundColor = bg1
            return v
        }()
        
        self.iconView = {
            let img = UIImageView()
            img.image = UIImage(named: "icon_account_register_success")
            self.bgView!.addSubview(img)
            img.snp.makeConstraints({ (make) in
                make.top.equalTo(self.bgView!.snp.top).offset(WH(41))
                make.centerX.equalTo(self.bgView!.snp.centerX)
                make.width.height.equalTo(WH(60))
            })
            return img
        }()
        
        self.titleLabel = {
            let label = UILabel()
            label.textAlignment = .center
            self.bgView!.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.top.equalTo(self.iconView!.snp.bottom).offset(j8)
                make.centerX.equalTo(self.bgView!.snp.centerX)
                make.height.equalTo(WH(25))
            })
            label.font = UIFont.systemFont(ofSize: WH(17))
            label.textColor = RGBColor(0x333333)
            label.text = "恭喜您，订单支付成功"
            return label
        }()
        
        self.subTitleLabel = {
            let label = UILabel()
            label.textAlignment = .center
            self.bgView!.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.top.equalTo(self.titleLabel!.snp.bottom).offset(WH(4))
                make.centerX.equalTo(self.bgView!.snp.centerX)
                make.width.equalTo(WH(240))
            })
            label.font = UIFont.systemFont(ofSize: WH(12))
            label.numberOfLines = 0
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = WH(5)
            paragraphStyle.alignment = .center
            label.attributedText = NSAttributedString(string: "您的订单将根据不同供应商拆成多张,详情请进入订单中心查看", attributes: [NSAttributedString.Key.foregroundColor: t16.color,NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(12)), NSAttributedString.Key.paragraphStyle: paragraphStyle])
            return label
        }()
        
        self.backgroundColor = RGBColor(0xe6e6e6)
    }
}
