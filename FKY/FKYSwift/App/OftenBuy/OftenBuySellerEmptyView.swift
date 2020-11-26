//
//  OftenBuySellerEmptyView.swift
//  FKY
//
//  Created by 路海涛 on 2017/4/17.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  常购商家之无数据时的空态视图

import UIKit


class OftenBuySellerEmptyView: UIView {
    
    fileprivate var logo: UIImageView?
    fileprivate var tip: UILabel?
    fileprivate var goHomeBtn: UIButton?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = bg1
        setupView()
    }

    func setupView() {
        logo = {
            let img = UIImageView()
            self.addSubview(img)
            img.image = UIImage.init(named: "icon_often_none")
            img.contentMode = .scaleAspectFit
            img.snp.makeConstraints({ (make) in
                make.top.equalTo(self.snp.top).offset(80)
                make.centerX.equalTo(self.snp.centerX)
                make.height.width.equalTo(140)
            })
            return img
        }()

        tip = {
            let lab = UILabel()
            self.addSubview(lab)
            lab.textAlignment = .center
            lab.contentMode = .scaleAspectFit
            lab.text = "抱歉，暂无常购商家"
            lab.snp.makeConstraints({ (make) in
                make.top.equalTo(self.logo!.snp.bottom).offset(80)
                make.left.right.equalTo(self)
                make.height.equalTo(15)
            })
            lab.fontTuple = t42
            return lab
        }()

        goHomeBtn = {
            let btn = UIButton()
            self.addSubview(btn)

            let str1 = NSMutableAttributedString(string: "去首页逛逛")
            let range1 = NSRange(location: 0, length: str1.length)
            let number = NSNumber(value: NSUnderlineStyle.single.rawValue as Int)
            str1.addAttribute(NSAttributedString.Key.underlineStyle, value: number, range: range1)
            str1.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0xFE403B), range: range1)
            btn.setAttributedTitle(str1, for: UIControl.State())

            btn.fontTuple = t43
            btn.contentMode = .scaleAspectFit
            btn.snp.makeConstraints({ (make) in
                make.top.equalTo(self.tip!.snp.bottom).offset(10)
                make.left.right.equalTo(self)
                make.height.equalTo(13)
            })
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                    let v = vc as! FKY_TabBarController
                    v.index = 0
                })
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            return btn
        }()
    }
}
