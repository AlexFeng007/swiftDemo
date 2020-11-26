//
//  FKYContactShopView.swift
//  FKY
//
//  Created by hui on 2019/6/20.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYContactShopView: UIView {
    //ui相关
    //contact_icon
    fileprivate lazy var contactIconImage : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage.init(named: "contact_shop_pic")
        return iv
    }()
    //contact_name
    fileprivate lazy var contactNameLabel : UILabel = {
        let label = UILabel()
        label.text = "联系商家"
        label.font = t28.font
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
        return label
    }()
    var clickContactView : emptyClosure?
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = RGBColor(0xFFFFFF)
        self.layer.cornerRadius = WH(30)
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowColor = RGBColor(0xCFDAF0).cgColor
        self.layer.shadowOpacity = 1;//阴影透明度，默认0
        self.layer.shadowRadius = 6;//阴影半径
        self.isUserInteractionEnabled = true
        self.bk_(whenTapped: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            if let clouser = strongSelf.clickContactView {
                clouser()
            }
        })
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubview(self.contactIconImage)
        self.contactIconImage.snp.makeConstraints ({ (make) in
            make.top.equalTo(self.snp.top).offset(WH(10))
            make.centerX.equalTo(self.snp.centerX)
        })
        self.addSubview(self.contactNameLabel)
        self.contactNameLabel.snp.makeConstraints ({ (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.contactIconImage.snp.bottom).offset(WH(5))
            make.height.equalTo(WH(15))
            make.width.equalTo(WH(60))
        })
    }
    
}
