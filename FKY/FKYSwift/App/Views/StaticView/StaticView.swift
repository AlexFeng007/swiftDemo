//
//  StaticView.swift
//  FKY
//
//  Created by yangyouyong on 2016/9/22.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class StaticView: UIView {
    
    fileprivate var bgView: UIView?
    fileprivate var iconView:UIImageView?
    fileprivate var titleLabel: UILabel?
    fileprivate var actionBtn: UIButton?
    var actionBlock: emptyClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if self.bgView == nil {
            setupView()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.bgView == nil {
            setupView()
        }
    }
    
    func setupView() {
        
        self.bgView = {
            let v = UIView()
            self.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.edges.equalTo(self)
            })
            v.backgroundColor = bg1
            return v
        }()
        
        self.iconView = {
            let img = UIImageView()
            img.image = UIImage(named: "icon_cart_add_empty")
            self.bgView!.addSubview(img)
            img.snp.makeConstraints({[weak self] (make) in
                guard let strongSelf = self else {
                    return
                }
                make.top.equalTo(strongSelf.bgView!.snp.top).offset(WH(50))
                make.centerX.equalTo(strongSelf.bgView!.snp.centerX)
            })
            return img
        }()
        
        self.titleLabel = {
            let label = UILabel()
            label.textAlignment = .center
            self.bgView!.addSubview(label)
            label.snp.makeConstraints({[weak self] (make) in
                guard let strongSelf = self else {
                    return
                }
                make.top.equalTo(strongSelf.iconView!.snp.bottom).offset(j8)
                make.centerX.equalTo(strongSelf.bgView!.snp.centerX)
                make.height.equalTo(WH(25))
            })
            label.fontTuple = t23
            label.text = "购物车还是空的"
            return label
        }()
        
        self.actionBtn = {
            let btn = UIButton()
            btn.adjustsImageWhenHighlighted = false
            self.addSubview(btn)
            btn.snp.makeConstraints({[weak self] (make) in
                guard let strongSelf = self else {
                    return
                }
                make.top.equalTo(strongSelf.titleLabel!.snp.bottom).offset(WH(30));
                make.centerX.equalTo(strongSelf.bgView!.snp.centerX);
                make.width.equalTo(WH(80))
                make.height.equalTo(WH(28))
            })

            btn.setTitle("去首页逛逛", for: UIControl.State())
            btn.setTitleColor(btn11.title.color, for: UIControl.State())
            btn.titleLabel?.font = btn11.title.font
            btn.layer.borderColor = btn11.border.color.cgColor
            btn.layer.borderWidth = btn11.border.width
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                if let action = strongSelf.actionBlock {
                    action()
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            return btn
        }()
        
        self.backgroundColor = bg1
    }
    
    func configView(_ iconName: String, title: String, btnTitle: String) {
        self.iconView!.image = UIImage(named: iconName)
        self.titleLabel!.text = title
        self.actionBtn!.setTitle(btnTitle, for: UIControl.State())
    }
}
