//
//  FKYOrderEmptyView.swift
//  FKY
//
//  Created by mahui on 16/9/6.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift

typealias OpenHomeController = ()->()

class FKYOrderEmptyView : UIView  {
    
    @objc var openHome : OpenHomeController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        let iconView = UIImageView()
        self.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(FKYWHWith2ptWH(45))
            make.centerX.equalTo(self.snp.centerX)
            make.width.height.equalTo(FKYWHWith2ptWH(100))
        }
        iconView.image = UIImage.init(named: "icon_order_none")
        
        let title = UILabel()
        self.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(iconView.snp.bottom).offset(FKYWHWith2ptWH(15))
            make.height.equalTo(FKYWHWith2ptWH(20))
        }
        
        title.text = "你还没有订单"
        title.textColor = t23.color
        title.font = t23.font
        
        let subTitle = UIButton()
        self.addSubview(subTitle)
        subTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(title.snp.bottom).offset(FKYWHWith2ptWH(30))
            make.height.equalTo(FKYWHWith2ptWH(28))
            make.width.equalTo(FKYWHWith2ptWH(80))

        }
        subTitle.setTitle("去首页逛逛", for:UIControl.State())
        subTitle.setTitleColor(btn11.title.color, for: UIControl.State())
        subTitle.titleLabel?.font = btn11.title.font
        subTitle.layer.borderColor = btn11.border.color.cgColor
        subTitle.layer.borderWidth = btn11.border.width
        
        _ = subTitle.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
               return
            }
            if strongSelf.openHome != nil {
                strongSelf.openHome!()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
