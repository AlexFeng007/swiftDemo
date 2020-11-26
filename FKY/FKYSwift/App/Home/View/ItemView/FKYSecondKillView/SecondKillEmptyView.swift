//
//  SecondKillEmptyView.swift
//  FKY
//
//  Created by Andy on 2018/11/30.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit


class SecondKillEmptyView: UIView {
    
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
            img.snp.makeConstraints({ [weak self](make) in
                guard let strongSelf = self else {
                    return
                }
                make.top.equalTo(strongSelf.snp.top).offset(80)
                make.centerX.equalTo(strongSelf.snp.centerX)
                make.height.width.equalTo(140)
            })
            return img
        }()
        
        tip = {
            let lab = UILabel()
            self.addSubview(lab)
            lab.textAlignment = .center
            lab.contentMode = .scaleAspectFit
            lab.text = "抱歉，暂无秒杀活动"
            lab.snp.makeConstraints({ [weak self](make) in
                guard let strongSelf = self else {
                    return
                }
                make.top.equalTo(strongSelf.logo!.snp.bottom).offset(80)
                make.left.right.equalTo(strongSelf)
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
            btn.snp.makeConstraints({ [weak self](make) in
                guard let strongSelf = self else {
                    return
                }
                make.top.equalTo(strongSelf.tip!.snp.bottom).offset(10)
                make.left.right.equalTo(strongSelf)
                make.height.equalTo(13)
            })
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {(_) in
                FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                    let v = vc as! FKY_TabBarController
                    v.index = 0
                })
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            return btn
        }()
    }
}

