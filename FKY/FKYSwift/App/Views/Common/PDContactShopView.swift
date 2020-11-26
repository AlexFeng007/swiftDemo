//
//  PDContactShopView.swift
//  FKY
//
//  Created by 寒山 on 2019/9/23.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

@objc  class PDContactShopView: UIView {
    fileprivate var badgeView: JSBadgeView?
    //ui相关
    var buttonType:PDBottomButtonType = .ShopType
    //contact_icon
    @objc public lazy var contactIconImage : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage.init(named: "contact_shop_pic")
        iv.contentMode = .center
        return iv
    }()
    //contact_name
    fileprivate lazy var contactNameLabel : UILabel = {
        let label = UILabel()
        label.text = "联系商家"
        label.font = t26.font
        label.textColor = RGBColor(0x666666)
        label.textAlignment = .center
        return label
    }()
    var clickContactView : emptyClosure?
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.isUserInteractionEnabled = true
        self.bk_(whenTapped: { [weak self] in
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
            make.top.equalTo(self.snp.top)
            make.centerX.equalTo(self.snp.centerX)
            make.width.height.equalTo(WH(30))
        })
        
        self.addSubview(self.contactNameLabel)
        self.contactNameLabel.snp.makeConstraints ({ (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.contactIconImage.snp.bottom)
            make.height.equalTo(WH(12))
            make.width.equalTo(WH(50))
        })
        let bv = JSBadgeView(parentView: self.contactIconImage, alignment: .topRight)
        bv?.badgePositionAdjustment = CGPoint(x: WH(-5), y: WH(6))
        bv?.badgeTextFont = UIFont.systemFont(ofSize: WH(11))
        bv?.badgeBackgroundColor = RGBColor(0xFF2D5C)
        self.badgeView = bv
        self.badgeView?.isHidden = true
    }
    func setButtonType(_ type:PDBottomButtonType){
        self.buttonType = type
        self.badgeView?.isHidden = true
        if type == .ShopType{
            // 店铺按钮
            self.contactIconImage.image = UIImage.init(named: "pd_shop_icon")
            self.contactNameLabel.text = "店铺"
        }else if type == .CartType{
            // 购物车按钮
            self.contactIconImage.image = UIImage.init(named: "icon_cart_new")
            self.contactNameLabel.text = "购物车"
            self.badgeView?.isHidden = false
        }else if type == .ContactType{
            // 联系按钮
            self.contactIconImage.image = UIImage.init(named: "contact_shop_pic")
            self.contactNameLabel.text = "联系商家"
        }
    }
    // 修改购物车显示数量
    @objc
    func changeBadgeNumber(_ isdelay: Bool) {
        var deadline: DispatchTime
        if  isdelay {
            deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        }else {
            deadline = DispatchTime.now()
        }
        
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    if let badgeNumView = strongSelf.badgeView {
                        badgeNumView.badgeText = {
                            let count = FKYCartModel.shareInstance().productCount
                            if count <= 0 {
                                return ""
                            }
                            else if count > 99 {
                                return "99+"
                            }
                            return String(count)
                        }()
                    }
                }
            }
        }
    }
}
