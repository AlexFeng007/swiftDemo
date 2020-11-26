//
//  SearchProductTypeView.swift
//  FKY
//
//  Created by 寒山 on 2020/3/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  搜索钩子商品状态视图

import UIKit

class SearchProductTypeView: UIView {
    
    @objc public lazy var promationImage : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage.init(named: "search_type_icon")
        iv.contentMode = .center
        return iv
    }()
    //contact_name
    fileprivate lazy var promationNameLabel : UILabel = {
        let label = UILabel()
        label.text = "特价专区"
        label.font = t33.font
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
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
        self.addSubview(self.promationImage)
        self.promationImage.snp.makeConstraints ({ (make) in
            make.left.equalTo(self)
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.equalTo(WH(20))
        })
        
        self.addSubview(self.promationNameLabel)
        self.promationNameLabel.snp.makeConstraints ({ (make) in
            make.left.equalTo(self.promationImage.snp.right).offset(WH(2))
            make.centerY.equalTo(self.snp.centerY)
        })
        
    }
    func configCell(_ product: Any) {
        if let model = product as? HomeProductModel{
            if model.productType == .MZProduct{
                promationNameLabel.text = "满折专区"
            }else if model.productType == .TJProduct{
                promationNameLabel.text = "特价专区"
            }
        }
        if let model = product as? SearchMpHockProductModel{
            if model.productType == .MZProduct{
                promationNameLabel.text = "满折专区"
            }else if model.productType == .TJProduct{
                promationNameLabel.text = "特价专区"
            }
        }
        if  let model = product as? ShopProductCellModel{
            promationNameLabel.text = model.hotRankName ?? ""
        }
        
    }
}
class SearchProductTypePriceView: UIView {
    // 价格
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(19))
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    // 特价(标签)
    fileprivate lazy var promotionPriceIcon: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = TAG_H/2.0
        label.layer.masksToBounds = true
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.textColor = RGBColor(0xFFFFFF)
        return label
    }()
    
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
    
    //显示会员价时，显示药城价
    fileprivate lazy var vipOriginalLabel: UILabel = {
        let label = UILabel()
        label.font = t11.font
        label.textColor = RGBColor(0x666666)
        let line = UIView()
        label.addSubview(line)
        line.snp.makeConstraints({ (make) in
            make.left.right.centerY.equalTo(label)
            make.height.equalTo(WH(1))
        })
        line.backgroundColor = RGBColor(0x666666)
        
        return label
    }()
    
    // 查看更多
    fileprivate lazy var checkBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.titleLabel?.font = t33.font
        btn.setTitle("查看更多", for: .normal)
        btn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        btn.backgroundColor = RGBColor(0xFFFFFF)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(13)
        btn.isEnabled = false
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    // MARK: - UI
    fileprivate func setupView() {
        self.addSubview(priceLabel)
        self.addSubview(promotionPriceIcon)
        
        self.addSubview(self.checkBtn)
        self.checkBtn.snp.makeConstraints ({ (make) in
            make.right.equalTo(self.snp.right).offset(WH(-17))
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(WH(90))
            make.height.equalTo(WH(26))
        })
        
        // 价格
        self.addSubview(priceLabel)
        priceLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self)
            make.width.lessThanOrEqualTo(WH(SCREEN_WIDTH/4))
            make.width.greaterThanOrEqualTo(WH(50))
        })
        
        // 特价标签
        self.addSubview(promotionPriceIcon)
        promotionPriceIcon.snp.makeConstraints({ (make) in
            make.left.equalTo(priceLabel.snp.right).offset(j4)
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        })
        
        // vip标签
        self.addSubview(vipTagLabel)
        vipTagLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.left.equalTo(priceLabel.snp.right).offset(WH(5))
            make.width.equalTo(WH(40))
            make.height.equalTo(WH(15))
        })
        
        // vip原价
        self.addSubview(vipOriginalLabel)
        vipOriginalLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.left.equalTo(self.vipTagLabel.snp.right).offset(j4)
            make.height.equalTo(WH(12))
        })
    }
    func configCell(_ product: Any) {
        // self.backgroundColor = UIColor.red
        vipTagLabel.isHidden = true
        vipOriginalLabel.isHidden = true
        priceLabel.isHidden = true
        promotionPriceIcon.isHidden = true
        if let model = product as? HomeProductModel{
            
            if let priceStr = model.productPrice, priceStr > 0 {
                self.priceLabel.isHidden = false
                self.priceLabel.text = String.init(format: "¥ %.2f",priceStr)
            }
            else {
                self.priceLabel.text = ""
            }
            //会员价 特价 原价
            if model.statusDesc == -5 || model.statusDesc == -13 ||  model.statusDesc == 0 {
                if let promotionNum =  model.productPromotion?.promotionPrice , promotionNum > 0  {
                    self.priceLabel.text = String.init(format: "¥ %.2f", (model.productPromotion?.promotionPrice!)!)
                    self.promotionPriceIcon.text = "特价"
                    self.promotionPriceIcon.isHidden = false
                }
                
                
                if let _ = model.vipPromotionId, let vipNum = model.visibleVipPrice, vipNum > 0 {
                    if let vipAvailableNum = model.availableVipPrice ,vipAvailableNum > 0 {
                        //会员 会员的时候，就展示个会员价的标，不展示原价，非会员不展示任何标和价格
                        self.vipOriginalLabel.isHidden = true
                        self.vipTagLabel.isHidden = false
                        self.priceLabel.text = String.init(format: "¥ %.2f",vipNum)
                        //self.vipOriginalLabel.text = String.init(format: "¥ %.2f",model.productPrice!)
                        self.vipTagLabel.text = "会员价"
                        self.vipTagLabel.snp.remakeConstraints({ (make) in
                            make.centerY.equalTo(self.priceLabel.snp.centerY)
                            make.left.equalTo(self.priceLabel.snp.right).offset(WH(5))
                            make.width.equalTo(WH(40))
                            make.height.equalTo(WH(15))
                        })
                    }
                    else {
//                        //非会员
//                        self.vipOriginalLabel.isHidden = true
//                        self.vipTagLabel.isHidden = true
//                        self.priceLabel.text = String.init(format: "¥ %.2f",model.productPrice!)
//                        // self.vipOriginalLabel.text = String.init(format: "¥ %.2f",vipNum)
//                        self.vipTagLabel.text = String.init(format: "会员价¥ %.2f",vipNum)
//                        let maxW = self.vipTagLabel.text!.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t29.font], context: nil).width
//                        vipTagLabel.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(maxW + WH(10)))
//                        self.vipTagLabel.snp.remakeConstraints({ (make) in
//                            make.centerY.equalTo(self.vipOriginalLabel.snp.centerY)
//                            make.left.equalTo(priceLabel.snp.right).offset(WH(5))
//                            make.width.equalTo(maxW + WH(10))
//                            make.height.equalTo(WH(15))
//                        })
                    }
                }
                // 对价格大小调整
                if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                    let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                    priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                    self.priceLabel.attributedText = priceMutableStr
                }
            }
        }
        if let model = product as? SearchMpHockProductModel{
            
            if let priceStr = model.price, priceStr > 0 {
                self.priceLabel.isHidden = false
                self.priceLabel.text = String.init(format: "¥ %.2f",priceStr)
            }
            else {
                self.priceLabel.text = ""
            }
            if let promotionNum =  model.productPromotion?.promotionPrice , promotionNum > 0 {
                self.priceLabel.text = String.init(format: "¥ %.2f", (model.productPromotion?.promotionPrice!)!)
                self.promotionPriceIcon.text = "特价"
                self.promotionPriceIcon.isHidden = false
            }
            // 对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
        }
        
        if let model = product as? ShopProductCellModel{
            if let priceStr = model.productPrice, priceStr > 0 {
                self.priceLabel.isHidden = false
                self.priceLabel.text = String.init(format: "¥ %.2f",priceStr)
            }
            else {
                self.priceLabel.text = ""
            }
            if let promotionNum =  model.productPromotion?.promotionPrice , promotionNum > 0 {
                self.priceLabel.text = String.init(format: "¥ %.2f", (model.productPromotion?.promotionPrice!)!)
                self.promotionPriceIcon.text = "特价"
                self.promotionPriceIcon.isHidden = false
            }
            // 对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
        }
        
    }
}
