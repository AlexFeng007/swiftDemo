//
//  CartPromotionTagView.swift
//  FKY
//
//  Created by 寒山 on 2019/12/12.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class CartPromotionTagView: UIView {
    //特价 会员 返利 协议返利金 满赠
    //会员标签
    fileprivate lazy var vipTagLabel: UILabel = {
        let label = UILabel()
        label.text = "会员价"
        label.textColor = RGBColor(0xFFDEAE)
        label.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(WH(40)))
        label.font = t29.font
        label.textAlignment = .center
        label.layer.cornerRadius = WH(15)/2.0
        label.layer.masksToBounds = true
        return label
    }()
    
    // 特价(标签)
    fileprivate lazy var promotionPriceIcon: UILabel = {
        let label = UILabel()
        label.text = "特价"
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = TAG_H/2.0
        label.layer.masksToBounds = true
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.textColor = RGBColor(0xFFFFFF)
        return label
    }()
    
    //    // 底价(标签)
    //    fileprivate lazy var bottomPriceIcon: UILabel = {
    //        let label = UILabel()
    //        label.text = "底价"
    //        label.font = UIFont.boldSystemFont(ofSize: WH(10))
    //        label.textAlignment = .center
    //        label.layer.cornerRadius = TAG_H/2.0
    //        label.layer.masksToBounds = true
    //        label.backgroundColor = RGBColor(0xFF2D5C)
    //        label.textColor = RGBColor(0xFFFFFF)
    //        return label
    //    }()
    
    // 返利金协议 (标签)标签
    fileprivate lazy var protcolRebaeteLb: UILabel = {
        let label = UILabel()
        label.text = "协议返利金"
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = WH(13)/2.0
        label.layer.masksToBounds = true
        label.textColor = RGBColor(0xFF2D5C)
        label.backgroundColor = UIColor.white
        label.layer.borderWidth = 1
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        return label
    }()
    
    
    
    // 返利标签
    fileprivate lazy var profitLb: UILabel = {
        let label = UILabel()
        label.text = "返利"
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = WH(13)/2.0
        label.layer.masksToBounds = true
        label.textColor = RGBColor(0xFF2D5C)
        label.backgroundColor = UIColor.white
        label.layer.borderWidth = 1
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        return label
    }()
    
    // 满赠(标签)
    fileprivate lazy var promotionIcon: UILabel = {
        let label = UILabel()
        label.text = "满赠"
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = TAG_H/2.0
        label.layer.masksToBounds = true
        label.textColor = RGBColor(0xFF2D5C)
        label.backgroundColor = UIColor.white
        label.layer.borderWidth = 1
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = .clear
        self.addSubview(promotionPriceIcon)
        
        //特价
        promotionPriceIcon.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        }
        
        //        //底价
        //        self.addSubview(bottomPriceIcon)
        //        bottomPriceIcon.snp.makeConstraints { (make) in
        //            make.right.equalTo(self)
        //            make.top.equalTo(self)
        //            make.width.equalTo(WH(30))
        //            make.height.equalTo(TAG_H)
        //        }
        
        // 返利金协议 (标签)标签
        self.addSubview(protcolRebaeteLb)
        protcolRebaeteLb.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.width.equalTo(WH(65))
            make.height.equalTo(TAG_H)
        }
        
        // 满赠(标签)
        self.addSubview(promotionIcon)
        promotionIcon.snp.makeConstraints({ (make) in
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        })
        
        
        // 返利金(标签)
        self.addSubview(profitLb)
        profitLb.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        }
        
        
        // vip标签
        self.addSubview(vipTagLabel)
        vipTagLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.width.equalTo(WH(40))
            make.height.equalTo(TAG_H)
        })
    }
    func configTagView(_ productModel:CartProdcutnfoModel){
        //特价标签
        promotionPriceIcon.isHidden = true
        vipTagLabel.isHidden = true
        protcolRebaeteLb.isHidden = true
        profitLb.isHidden = true
        promotionIcon.isHidden = true
        // bottomPriceIcon.isHidden = true
        promotionPriceIcon.snp.updateConstraints { (make) in
            make.width.equalTo(WH(30))
        }
        if productModel.promotionTJ != nil{
            promotionPriceIcon.isHidden = false
            promotionPriceIcon.text = "特价"
        }else if  productModel.promotionVip != nil{
            //会员标签
            if let vipAvailableNum = productModel.promotionVip?.availableVipPrice ,vipAvailableNum > 0 {
                vipTagLabel.isHidden = false
            }
        }else if productModel.isHasSomeKindPromotion(["17"]){
            promotionPriceIcon.isHidden = false
            promotionPriceIcon.text = "底价"
        }else if productModel.getExclusivePromotionFlag(["2001"]){
            promotionPriceIcon.isHidden = false
            promotionPriceIcon.text = "专享价"
            promotionPriceIcon.snp.updateConstraints { (make) in
                make.width.equalTo(WH(44))
            }
        }else if productModel.isHasSomeKindPromotion(["2002"]){
            promotionPriceIcon.isHidden = false
            promotionPriceIcon.text = "直播价"
            promotionPriceIcon.snp.updateConstraints { (make) in
                make.width.equalTo(WH(44))
            }
        }
        
        if let productRebate = productModel.productRebate,productRebate.rebateTextMsg?.isEmpty == false {
            profitLb.isHidden = false
            if  promotionPriceIcon.isHidden == true && vipTagLabel.isHidden == true{
                profitLb.snp.updateConstraints { (make) in
                    make.right.equalTo(self)
                }
            }else{
                if  vipTagLabel.isHidden == false{
                    profitLb.snp.updateConstraints { (make) in
                        make.right.equalTo(self).offset(-WH(46))
                    }
                }else if productModel.getExclusivePromotionFlag(["2001"]){
                    profitLb.snp.updateConstraints { (make) in
                        make.right.equalTo(self).offset(-WH(50))
                    }
                }else if productModel.isHasSomeKindPromotion(["2002"]){
                    profitLb.snp.updateConstraints { (make) in
                        make.right.equalTo(self).offset(-WH(50))
                    }
                }else{
                    profitLb.snp.updateConstraints { (make) in
                        make.right.equalTo(self).offset(-WH(36))
                    }
                }
            }
        }else if  let agreementRebate = productModel.agreementRebate,agreementRebate.promationDescription?.isEmpty == false {
            protcolRebaeteLb.isHidden = false
            if  promotionPriceIcon.isHidden == true && vipTagLabel.isHidden == true{
                protcolRebaeteLb.snp.updateConstraints { (make) in
                    make.right.equalTo(self)
                }
            }else{
                if  vipTagLabel.isHidden == false{
                    protcolRebaeteLb.snp.updateConstraints { (make) in
                        make.right.equalTo(self).offset(-WH(46))
                    }
                }else if productModel.isHasSomeKindPromotion(["17"]){
                    protcolRebaeteLb.snp.updateConstraints { (make) in
                        make.right.equalTo(self).offset(-WH(36))
                    }
                }else if productModel.getExclusivePromotionFlag(["2001"]){
                    profitLb.snp.updateConstraints { (make) in
                        make.right.equalTo(self).offset(-WH(50))
                    }
                }else if productModel.isHasSomeKindPromotion(["2002"]){
                    profitLb.snp.updateConstraints { (make) in
                        make.right.equalTo(self).offset(-WH(50))
                    }
                }else{
                    protcolRebaeteLb.snp.updateConstraints { (make) in
                        make.right.equalTo(self).offset(-WH(36))
                    }
                }
                
            }
        }
        //满赠标签
        if productModel.promotionMZ != nil{
            if  promotionPriceIcon.isHidden == true && vipTagLabel.isHidden == true && protcolRebaeteLb.isHidden == true && profitLb.isHidden == true{
                promotionIcon.isHidden = false
                promotionIcon.snp.updateConstraints { (make) in
                    make.top.equalTo(self)
                    make.right.equalTo(self)
                }
            }else if (promotionPriceIcon.isHidden != true || vipTagLabel.isHidden != true) && (protcolRebaeteLb.isHidden != true || profitLb.isHidden != true) {
                //至多两个
                
            }else{
                promotionIcon.isHidden = false
                if protcolRebaeteLb.isHidden != true{
                    promotionIcon.snp.updateConstraints { (make) in
                        make.top.equalTo(self)
                        make.right.equalTo(self).offset(-WH(71))
                    }
                }else{
                    if  vipTagLabel.isHidden == false{
                        promotionIcon.snp.updateConstraints { (make) in
                            make.top.equalTo(self)
                            make.right.equalTo(self).offset(-WH(46))
                        }
                    }else if productModel.isHasSomeKindPromotion(["17"]){
                        promotionIcon.snp.updateConstraints { (make) in
                            make.top.equalTo(self)
                            make.right.equalTo(self).offset(-WH(36))
                        }
                    }else if productModel.getExclusivePromotionFlag(["2001"]){
                        promotionIcon.snp.updateConstraints { (make) in
                            make.top.equalTo(self)
                            make.right.equalTo(self).offset(-WH(50))
                        }
                    }else if productModel.isHasSomeKindPromotion(["2002"]){
                        promotionIcon.snp.updateConstraints { (make) in
                            make.top.equalTo(self)
                            make.right.equalTo(self).offset(-WH(50))
                        }
                    }else{
                        promotionIcon.snp.updateConstraints { (make) in
                            make.top.equalTo(self)
                            make.right.equalTo(self).offset(-WH(36))
                        }
                    }
                    
                }
                
            }
        }
    }
}
