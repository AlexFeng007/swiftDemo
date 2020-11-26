//
//  FKYMyfavEmptyView.swift
//  FKY
//
//  Created by zhangxuewen on 2018/5/22.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  我的收藏空白页

import UIKit


class FKYMyFavEmtpyView: UIView{
    
    fileprivate var tip  : UILabel?
    fileprivate var goShopBtn : UIButton?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = bg1
    }
    
    func setupView() -> () {
   
        tip = {
            let lab = UILabel()
            self.addSubview(lab)
            lab.text = "您还没有收藏的店铺"
            lab.textAlignment = .center
            lab.contentMode = .scaleAspectFit
            lab.snp.makeConstraints({ (make) in
                make.top.equalTo(self.snp.top).offset(180)
                make.left.right.equalTo(self)
                make.height.equalTo(15)
            })
            lab.fontTuple = t42
            return lab
            
            
        }()
        
        goShopBtn = {
            let btn = UIButton()
            self.addSubview(btn)
            
            let str1 = NSMutableAttributedString(string: "去店铺馆看看")
            let range1 = NSRange(location: 0, length: str1.length)
            str1.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0xFE403B), range: range1)
            btn.setAttributedTitle(str1, for: UIControl.State())
            btn.titleLabel?.font = FKYSystemFont(WH(16))
            btn.layer.borderColor = RGBColor(0xFF394E).cgColor
            btn.layer.borderWidth = 1
            btn.snp.makeConstraints({ (make) in
                make.top.equalTo(self.tip!.snp.bottom).offset(15)
                make.centerX.equalTo(self)
                make.width.equalTo(150)
                make.height.equalTo(40)
            })
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                // 跳转店铺列表
                FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                    let v = vc as! FKY_TabBarController
                    v.index = 2
                })
//                FKYNavigator.shared().openScheme(FKY_ShopList.self, setProperty: {_ in
//                    //
//                })
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            return btn
        }()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

