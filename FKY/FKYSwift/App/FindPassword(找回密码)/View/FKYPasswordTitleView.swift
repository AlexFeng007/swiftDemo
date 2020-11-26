//
//  FKYPasswordTitleView.swift
//  FKY
//
//  Created by hui on 2019/6/25.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

let LOGIN_ABOUT_H = naviBarHeight()-WH(64)+WH(30)+WH(24)+WH(56)+WH(33)


class FKYPasswordTitleView: UIView {
    //返回按钮
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "login_back_pic"), for: [.normal])
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {  (_) in
            FKYNavigator.shared().pop()
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 下划线
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "找回密码"
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.boldSystemFont(ofSize: WH(24))
        return label
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(self.backBtn)
        self.backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset((naviBarHeight()-WH(64)+WH(30)))
            make.left.equalTo(self.snp.left).offset(WH(10))
            make.height.width.equalTo(WH(24))
        }
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.backBtn.snp.bottom).offset(WH(56))
            make.left.equalTo(self.snp.left).offset(WH(30))
        }
    }
}
