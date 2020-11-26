//
//  ProductPriceInfoView.swift
//  FKY
//
//  Created by 寒山 on 2019/8/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商品列表 价格信息  原价 特价 会员价  折后价 

import UIKit

class ProductPriceInfoView: UIView {
    
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
    
    // 特价...<带中划线>
    fileprivate lazy var tjPrice: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = t11.font
        label.textColor = RGBColor(0x666666)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        
        let line = UIView()
        label.addSubview(line)
        line.snp.makeConstraints({ (make) in
            make.left.right.centerY.equalTo(label)
            make.height.equalTo(WH(1))
        })
        line.backgroundColor = RGBColor(0x666666)
        
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
    
    // 折后价
    fileprivate lazy var disCountLabel: UILabel  = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.isHidden = true
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
    // MARK: - Init
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
        self.addSubview(tjPrice)
        self.addSubview(vipTagLabel)
        self.addSubview(vipOriginalLabel)
        
        self.addSubview(disCountLabel)
        self.addSubview(promotionPriceIcon)
        
        
        // 价格
        self.addSubview(priceLabel)
        priceLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(self).offset(11)
            make.left.equalTo(self)
            //make.width.lessThanOrEqualTo(WH(SCREEN_WIDTH/4))
            make.width.greaterThanOrEqualTo(WH(50))
            make.height.equalTo(WH(19))
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
        // 特价标签
        self.addSubview(promotionPriceIcon)
        promotionPriceIcon.snp.makeConstraints({ (make) in
            make.left.equalTo(priceLabel.snp.right).offset(j4)
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        })
        // 特价
        self.addSubview(tjPrice)
        tjPrice.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.priceLabel.snp.centerY)
            make.left.equalTo(self.promotionPriceIcon.snp.right).offset(WH(5))
            make.width.lessThanOrEqualTo(WH(SCREEN_WIDTH/4))
        })
        
        // 折后价
        self.addSubview(disCountLabel)
        disCountLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.left.equalTo(priceLabel.snp.right).offset(j4)
            make.height.equalTo(WH(13))
        })
        
    }
    func configCell(_ product: Any) {
        // self.backgroundColor = UIColor.red
        
        priceLabel.isHidden = true
        tjPrice.isHidden = true
        vipTagLabel.isHidden = true
        vipOriginalLabel.isHidden = true
        
        disCountLabel.isHidden = true
        promotionPriceIcon.isHidden = true
        disCountLabel.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.left.equalTo(priceLabel.snp.right).offset(j4)
            make.height.equalTo(WH(13))
        })
        if let model = product as? ShopProductCellModel {
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
                    self.tjPrice.text = String.init(format: "¥ %.2f", (model.productPrice!))
                    self.tjPrice.isHidden = false
                    self.promotionPriceIcon.text = "特价"
                    self.promotionPriceIcon.isHidden = false
                }
                
                if let _ = model.vipPromotionId, let vipNum = model.visibleVipPrice, vipNum > 0 {
                    if let vipAvailableNum = model.availableVipPrice ,vipAvailableNum > 0 {
                        //会员
                        self.vipOriginalLabel.isHidden = false
                        self.priceLabel.text = String.init(format: "¥ %.2f",vipNum)
                        self.vipOriginalLabel.text = String.init(format: "¥ %.2f",model.productPrice!)
                        self.vipTagLabel.text = "会员价"
                        self.vipTagLabel.snp.remakeConstraints({ (make) in
                            make.centerY.equalTo(self.priceLabel.snp.centerY)
                            make.left.equalTo(self.priceLabel.snp.right).offset(WH(5))
                            make.width.equalTo(WH(40))
                            make.height.equalTo(WH(15))
                        })
                    }
                    else {
                        //非会员
                        self.vipOriginalLabel.isHidden = true
                        self.priceLabel.text = String.init(format: "¥ %.2f",model.productPrice!)
                        self.vipTagLabel.text = String.init(format: "会员价¥ %.2f",vipNum)
                        let maxW = self.vipTagLabel.text!.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t29.font], context: nil).width
                        vipTagLabel.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(maxW + WH(10)))
                        self.vipTagLabel.snp.remakeConstraints({ (make) in
                            make.centerY.equalTo(self.priceLabel.snp.centerY)
                            make.left.equalTo(self.priceLabel.snp.right).offset(WH(5))
                            make.width.equalTo(maxW + WH(10))
                            make.height.equalTo(WH(15))
                        })
                    }
                    //有会员价格
                    self.tjPrice.isHidden = true
                    self.vipTagLabel.isHidden = false
                }
            }
            //折扣价
            if let disCountStr = model.discountPriceDesc, disCountStr.isEmpty == false,self.priceLabel.isHidden == false {
                if let disCount = model.discountPrice,disCount.isEmpty == false{
                    let disCountPrice = NSString(string: disCount)
                    if  CGFloat(model.productPrice!) > CGFloat(disCountPrice.floatValue){
                        self.disCountLabel.isHidden = false
                        self.disCountLabel.text = disCountStr
                    }else{
                        self.disCountLabel.isHidden = true
                    }
                }else{
                    self.disCountLabel.isHidden = true
                }
            }
            else {
                self.disCountLabel.isHidden = true
            }
            
            // 对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
        }
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
                // 判断是否显示专享价
                if model.isShowExclusivePrice(){
                    self.priceLabel.text = String.init(format: "¥ %.2f", (model.exclusivePrice ?? 0))
                    self.tjPrice.text = String.init(format: "¥ %.2f", (model.referencePrice ?? 0))
                    self.tjPrice.isHidden = false
                    self.promotionPriceIcon.text = "专享价"
                    self.promotionPriceIcon.isHidden = false
                    promotionPriceIcon.snp.updateConstraints({ (make) in
                        make.width.equalTo(WH(44))
                    })
                }else{
                    if let promotionNum =  model.productPromotion?.promotionPrice , promotionNum > 0  {
                        self.priceLabel.text = String.init(format: "¥ %.2f", (model.productPromotion?.promotionPrice!)!)
                        self.tjPrice.text = String.init(format: "¥ %.2f", (model.productPrice!))
                        self.tjPrice.isHidden = false
                        if let liveTag = model.productPromotion?.liveStreamingFlag,liveTag == 1{
                            self.promotionPriceIcon.text = "直播价"
                            promotionPriceIcon.snp.updateConstraints({ (make) in
                                make.width.equalTo(WH(44))
                            })
                        }else{
                           self.promotionPriceIcon.text = "特价"
                            promotionPriceIcon.snp.updateConstraints({ (make) in
                                make.width.equalTo(WH(30))
                            })
                        }
                        self.promotionPriceIcon.isHidden = false
                    }
                    if let _ = model.vipPromotionId, let vipNum = model.visibleVipPrice, vipNum > 0 {
                        if let vipAvailableNum = model.availableVipPrice ,vipAvailableNum > 0 {
                            //会员
                            self.vipOriginalLabel.isHidden = false
                            self.priceLabel.text = String.init(format: "¥ %.2f",vipNum)
                            self.vipOriginalLabel.text = String.init(format: "¥ %.2f",model.productPrice!)
                            self.vipTagLabel.text = "会员价"
                            self.vipTagLabel.snp.remakeConstraints({ (make) in
                                make.centerY.equalTo(self.priceLabel.snp.centerY)
                                make.left.equalTo(self.priceLabel.snp.right).offset(WH(5))
                                make.width.equalTo(WH(40))
                                make.height.equalTo(WH(15))
                            })
                        }
                        else {
                            //非会员
                            self.vipOriginalLabel.isHidden = true
                            self.priceLabel.text = String.init(format: "¥ %.2f",model.productPrice!)
                            // self.vipOriginalLabel.text = String.init(format: "¥ %.2f",vipNum)
                            self.vipTagLabel.text = String.init(format: "会员价¥ %.2f",vipNum)
                            let maxW = self.vipTagLabel.text!.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t29.font], context: nil).width
                            vipTagLabel.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(maxW + WH(10)))
                            self.vipTagLabel.snp.remakeConstraints({ (make) in
                                make.centerY.equalTo(self.vipOriginalLabel.snp.centerY)
                                make.left.equalTo(priceLabel.snp.right).offset(WH(5))
                                make.width.equalTo(maxW + WH(10))
                                make.height.equalTo(WH(15))
                            })
                        }
                        //有会员价格
                        self.tjPrice.isHidden = true
                        self.vipTagLabel.isHidden = false
                    }
                }
                
            }
            // 判断是否显示专享价
            if model.isShowExclusivePrice() == false{
                //折扣价
                if let disCountStr = model.discountPriceDesc, disCountStr.isEmpty == false,self.priceLabel.isHidden == false {
                    if let disCount = model.discountPrice,disCount.isEmpty == false{
                        let disCountPrice = NSString(string: disCount)
                        if  CGFloat(model.productPrice!) > CGFloat(disCountPrice.floatValue){
                            self.disCountLabel.isHidden = false
                            self.disCountLabel.text = disCountStr
                        }else{
                            self.disCountLabel.isHidden = true
                        }
                    }else{
                        self.disCountLabel.isHidden = true
                    }
                }
                else {
                    self.disCountLabel.isHidden = true
                }
                //有底价 (与折后价可能共存)
                if let priceStr = model.productPrice, priceStr > 0  {
                    if model.isHasBasePriceKindPromotion(["17"]) == true {
                        self.promotionPriceIcon.text = "底价"
                        self.promotionPriceIcon.isHidden = false
                        if self.disCountLabel.isHidden == false {
                            disCountLabel.snp.remakeConstraints({ (make) in
                                make.centerY.equalTo(priceLabel.snp.centerY)
                                make.left.equalTo(promotionPriceIcon.snp.right).offset(j4)
                                make.height.equalTo(WH(13))
                            })
                        }
                    }
                }
            }
            
            // 对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
        }
        if let model = product as? FKYProductObject{
            if let priceStr = model.priceInfo.price, (priceStr as NSString).floatValue > 0 {
                self.priceLabel.isHidden = false
                self.priceLabel.text = "¥\(priceStr)"
            }
            else {
                self.priceLabel.text = ""
            }
            //会员价 特价 原价
            if model.priceInfo.showPrice == true {
                if let promotionNum =  model.productPromotion?.promotionPrice , promotionNum.floatValue > 0  {
                    self.priceLabel.text = NSString.init(format: "¥%.2f", promotionNum.floatValue) as String//String.init(format: "¥ %.2f", (model.productPromotion?.promotionPrice!)!)
                    if let str = model.priceInfo.price {
                        self.tjPrice.text = "¥\(str)"
                    }
                    self.tjPrice.isHidden = false
                    self.promotionPriceIcon.text = "特价"
                    self.promotionPriceIcon.isHidden = false
                }
                //let value = Float(vipNum)
                if let pVip = model.vipPromotionInfo,let _ = pVip.vipPromotionId,let _ = pVip.visibleVipPrice, let vipNum = Float(pVip.visibleVipPrice), vipNum > 0 {
                    if let _ = pVip.availableVipPrice , let vipAvailableNum = Float(pVip.availableVipPrice) ,vipAvailableNum > 0 {
                        //会员
                        self.vipOriginalLabel.isHidden = false
                        self.priceLabel.text = String.init(format: "¥ %.2f",vipNum)
                        if let str = model.priceInfo.price {
                            self.vipOriginalLabel.text = "¥\(str)"
                        }
                        self.vipTagLabel.text = "会员价"
                        self.vipTagLabel.snp.remakeConstraints({ (make) in
                            make.centerY.equalTo(self.priceLabel.snp.centerY)
                            make.left.equalTo(self.priceLabel.snp.right).offset(WH(5))
                            make.width.equalTo(WH(40))
                            make.height.equalTo(WH(15))
                        })
                    }
                    else {
                        //非会员
                        self.vipOriginalLabel.isHidden = true
                        if let str = model.priceInfo.price {
                            self.priceLabel.text = "¥\(str)"
                        }
                        // self.vipOriginalLabel.text = String.init(format: "¥ %.2f",vipNum)
                        self.vipTagLabel.text = String.init(format: "会员价¥ %.2f",vipNum)
                        let maxW = self.vipTagLabel.text!.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t29.font], context: nil).width
                        vipTagLabel.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(maxW + WH(10)))
                        self.vipTagLabel.snp.remakeConstraints({ (make) in
                            make.centerY.equalTo(self.vipOriginalLabel.snp.centerY)
                            make.left.equalTo(priceLabel.snp.right).offset(WH(5))
                            make.width.equalTo(maxW + WH(10))
                            make.height.equalTo(WH(15))
                        })
                    }
                    //有会员价格
                    self.tjPrice.isHidden = true
                    self.vipTagLabel.isHidden = false
                }
            }
            //折扣价if let obj = model.discountInfo, let price = obj.discountPrice, price.isEmpty == false
            if let obj = model.discountInfo, let price = obj.discountPrice, price.isEmpty == false,self.priceLabel.isHidden == false {
                // 显示折后价
                // app本地防呆...<保证折后价小于原价>
                let noDigits = CharacterSet.decimalDigits.inverted
                let numP = price.trimmingCharacters(in: noDigits)
                let valueP = (numP as NSString).doubleValue
                if let pPrice = model.priceInfo.price, (pPrice as NSString).doubleValue > valueP {
                    self.disCountLabel.isHidden = false
                    self.disCountLabel.text = "折后约" + price
                }else{
                    self.disCountLabel.isHidden = true
                }
            }
            else {
                self.disCountLabel.isHidden = true
            }
            //            //有底价 (与折后价可能共存)
            if let priceStr = model.priceInfo.price, (priceStr as NSString).floatValue > 0  {
                if model.hasBasePriceActivity() == true {
                    self.promotionPriceIcon.text = "底价"
                    self.promotionPriceIcon.isHidden = false
                    if self.disCountLabel.isHidden == false {
                        disCountLabel.snp.remakeConstraints({ (make) in
                            make.centerY.equalTo(priceLabel.snp.centerY)
                            make.left.equalTo(promotionPriceIcon.snp.right).offset(j4)
                            make.height.equalTo(WH(13))
                        })
                    }
                }
            }
            // 对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
        }
        if let model = product as? ShopProductItemModel{
            if let priceStr = model.showPrice, priceStr > 0 {
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
                    self.tjPrice.text = String.init(format: "¥ %.2f", (model.showPrice ?? 0))
                    self.tjPrice.isHidden = false
                    if let liveTag = model.productPromotion?.liveStreamingFlag,liveTag == 1{
                        self.promotionPriceIcon.text = "直播价"
                        promotionPriceIcon.snp.updateConstraints({ (make) in
                            make.width.equalTo(WH(44))
                        })
                    }else{
                       self.promotionPriceIcon.text = "特价"
                        promotionPriceIcon.snp.updateConstraints({ (make) in
                            make.width.equalTo(WH(30))
                        })
                    }
                    
                    self.promotionPriceIcon.isHidden = false
                }
                
                if let _ = model.vipPromotionId, let vipNum = model.visibleVipPrice, vipNum > 0 {
                    if let vipAvailableNum = model.availableVipPrice ,vipAvailableNum > 0 {
                        //会员
                        self.vipOriginalLabel.isHidden = false
                        self.priceLabel.text = String.init(format: "¥ %.2f",vipNum)
                        self.vipOriginalLabel.text = String.init(format: "¥ %.2f",(model.showPrice ?? 0))
                        self.vipTagLabel.text = "会员价"
                        self.vipTagLabel.snp.remakeConstraints({ (make) in
                            make.centerY.equalTo(self.priceLabel.snp.centerY)
                            make.left.equalTo(self.priceLabel.snp.right).offset(WH(5))
                            make.width.equalTo(WH(40))
                            make.height.equalTo(WH(15))
                        })
                    }
                    else {
                        //非会员
                        self.vipOriginalLabel.isHidden = true
                        self.priceLabel.text = String.init(format: "¥ %.2f",(model.showPrice ?? 0))
                        // self.vipOriginalLabel.text = String.init(format: "¥ %.2f",vipNum)
                        self.vipTagLabel.text = String.init(format: "会员价¥ %.2f",vipNum)
                        let maxW = self.vipTagLabel.text!.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t29.font], context: nil).width
                        vipTagLabel.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(maxW + WH(10)))
                        self.vipTagLabel.snp.remakeConstraints({ (make) in
                            make.centerY.equalTo(self.vipOriginalLabel.snp.centerY)
                            make.left.equalTo(priceLabel.snp.right).offset(WH(5))
                            make.width.equalTo(maxW + WH(10))
                            make.height.equalTo(WH(15))
                        })
                    }
                    //有会员价格
                    self.tjPrice.isHidden = true
                    self.vipTagLabel.isHidden = false
                }
            }
            //折扣价
            if let disCountStr = model.discountPriceDesc, disCountStr.isEmpty == false,self.priceLabel.isHidden == false {
                if let disCount = model.discountPrice,disCount.isEmpty == false{
                    let disCountPrice = NSString(string: disCount)
                    if  CGFloat((model.showPrice ?? 0.0)) > CGFloat(disCountPrice.floatValue){
                        self.disCountLabel.isHidden = false
                        self.disCountLabel.text = disCountStr
                    }else{
                        self.disCountLabel.isHidden = true
                    }
                }else{
                    self.disCountLabel.isHidden = true
                }
            }
            else {
                self.disCountLabel.isHidden = true
            }
            // 对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
        }
        if let model = product as? OftenBuyProductItemModel{
            //常购清单
            if let priceStr = model.price, priceStr > 0 {
                self.priceLabel.isHidden = false
                self.priceLabel.text = String.init(format: "¥ %.2f",priceStr)
            }
            else {
                self.priceLabel.text = ""
            }
            //会员价 特价 原价
            if let promotionNum =  model.promotionPrice , promotionNum > 0 {
                self.priceLabel.text = String.init(format: "¥ %.2f", (model.promotionPrice)!)
                self.tjPrice.text = String.init(format: "¥ %.2f", (model.price!))
                self.tjPrice.isHidden = false
                self.promotionPriceIcon.text = "特价"
                self.promotionPriceIcon.isHidden = false
            }
            
            if let _ = model.vipPromotionId, let vipNum = model.visibleVipPrice, vipNum > 0 {
                if let vipAvailableNum = model.availableVipPrice ,vipAvailableNum > 0 {
                    //会员
                    self.vipOriginalLabel.isHidden = false
                    self.priceLabel.text = String.init(format: "¥ %.2f",vipNum)
                    self.vipOriginalLabel.text = String.init(format: "¥ %.2f",model.price!)
                    self.vipTagLabel.text = "会员价"
                    self.vipTagLabel.snp.remakeConstraints({ (make) in
                        make.centerY.equalTo(self.priceLabel.snp.centerY)
                        make.left.equalTo(self.priceLabel.snp.right).offset(WH(5))
                        make.width.equalTo(WH(40))
                        make.height.equalTo(WH(15))
                    })
                }
                else {
                    //非会员
                    self.vipOriginalLabel.isHidden = true
                    self.priceLabel.text = String.init(format: "¥ %.2f",model.price!)
                    // self.vipOriginalLabel.text = String.init(format: "¥ %.2f",vipNum)
                    self.vipTagLabel.text = String.init(format: "会员价¥ %.2f",vipNum)
                    let maxW = self.vipTagLabel.text!.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t29.font], context: nil).width
                    vipTagLabel.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(maxW + WH(10)))
                    self.vipTagLabel.snp.remakeConstraints({ (make) in
                        make.centerY.equalTo(self.vipOriginalLabel.snp.centerY)
                        make.left.equalTo(priceLabel.snp.right).offset(WH(5))
                        make.width.equalTo(maxW + WH(10))
                        make.height.equalTo(WH(15))
                    })
                }
                //有会员价格
                self.tjPrice.isHidden = true
                self.vipTagLabel.isHidden = false
            }
            
            // 对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
            //折扣价
            if let disCountStr = model.disCountDesc,disCountStr.isEmpty == false,self.priceLabel.isHidden == false{
                let nonDigits = CharacterSet.decimalDigits.inverted
                let numStr =  disCountStr.trimmingCharacters(in: nonDigits)
                let disCountPrice = NSString(string:numStr)
                if  CGFloat(model.price!) > CGFloat(disCountPrice.floatValue){
                    self.disCountLabel.isHidden = false
                    self.disCountLabel.text = disCountStr
                }else{
                    self.disCountLabel.isHidden = true
                }
            }else{
                self.disCountLabel.isHidden = true
            }
            
        }
        if let model = product as? HomeCommonProductModel{
            if model.statusDesc == -5 || model.statusDesc == -13 || model.statusDesc == 0{
                if model.productDesc != nil && model.productDesc!.isEmpty == false{
                    //显示价优
                    priceLabel.snp.updateConstraints({ (make) in
                        make.top.equalTo(self).offset(5)
                    })
                }else{
                    priceLabel.snp.updateConstraints({ (make) in
                        make.top.equalTo(self).offset(11)
                    })
                }
                if(model.price != nil && model.price != 0.0){
                    self.priceLabel.isHidden = false
                    self.priceLabel.text = String.init(format: "¥ %.2f", model.price!)
                }
                if (model.promotionPrice != nil && model.promotionPrice != 0.0) {
                    self.priceLabel.text = String.init(format: "¥ %.2f", (model.promotionPrice ?? 0))
                    self.tjPrice.text = String.init(format: "¥ %.2f", (model.price!))
                    self.tjPrice.isHidden = false;
                    
                    self.promotionPriceIcon.isHidden = false
                    if let signModel = model.productSign, signModel.liveStreamingFlag == true {
                        self.promotionPriceIcon.text = "直播价"
                        promotionPriceIcon.snp.updateConstraints({ (make) in
                            make.width.equalTo(WH(44))
                        })
                    }else {
                        self.promotionPriceIcon.text = "特价"
                        promotionPriceIcon.snp.updateConstraints({ (make) in
                            make.width.equalTo(WH(30))
                        })
                    }
                }
                if let _ = model.vipPromotionId ,let vipNum = model.visibleVipPrice ,vipNum > 0 {
                    if let vipAvailableNum = model.availableVipPrice ,vipAvailableNum > 0 {
                        //会员
                        self.vipOriginalLabel.isHidden = false
                        self.priceLabel.text = String.init(format: "¥ %.2f",vipNum)
                        self.vipOriginalLabel.text = String.init(format: "¥ %.2f",model.price!)
                        self.vipTagLabel.text = "会员价"
                        self.vipTagLabel.snp.remakeConstraints({ (make) in
                            make.centerY.equalTo(self.priceLabel.snp.centerY)
                            make.left.equalTo(self.priceLabel.snp.right).offset(WH(5))
                            make.width.equalTo(WH(40))
                            make.height.equalTo(WH(15))
                        })
                    }else{
                        //非会员
                        self.vipOriginalLabel.isHidden = true
                        self.priceLabel.text = String.init(format: "¥ %.2f",model.price!)
                        //self.vipOriginalLabel.text = String.init(format: "会员价¥ %.2f",vipNum)
                        self.vipTagLabel.text = String.init(format: "会员价¥ %.2f",vipNum)
                        let maxW = self.vipTagLabel.text!.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t29.font], context: nil).width
                        vipTagLabel.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(maxW + WH(10)))
                        self.vipTagLabel.snp.remakeConstraints({ (make) in
                            make.centerY.equalTo(self.priceLabel.snp.centerY)
                            make.left.equalTo(self.priceLabel.snp.right).offset(WH(5))
                            make.width.equalTo(maxW + WH(10))
                            make.height.equalTo(WH(15))
                        })
                        
                    }
                    //有会员价格
                    self.tjPrice.isHidden = true
                    self.vipTagLabel.isHidden = false
                }
                
                // 对价格大小调整
                if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                    let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                    priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                    self.priceLabel.attributedText = priceMutableStr
                }
            }
            //折扣价
            if let disCountStr = model.disCountDesc,disCountStr.isEmpty == false,self.priceLabel.isHidden == false{
                let nonDigits = CharacterSet.decimalDigits.inverted
                let numStr =  disCountStr.trimmingCharacters(in: nonDigits)
                let disCountPrice = NSString(string:numStr)
                if  CGFloat(model.price!) > CGFloat(disCountPrice.floatValue){
                    self.disCountLabel.isHidden = false
                    self.disCountLabel.text = disCountStr
                }else{
                    self.disCountLabel.isHidden = true
                }
            }else{
                self.disCountLabel.isHidden = true
            }
        }
        if let model = product as? FKYFullProductModel{
            if model.statusDesc == -5 || model.statusDesc == -13 || model.statusDesc == 0{
                if(model.showPrice != nil && model.showPrice != 0.0){
                    self.priceLabel.isHidden = false
                    self.priceLabel.text = String.init(format: "¥ %.2f", (model.showPrice ?? 0))
                }
                if (model.promotionPrice != nil && model.promotionPrice != 0.0) {
                    self.priceLabel.text = String.init(format: "¥ %.2f",  (model.promotionPrice ?? 0))
                    self.tjPrice.text = String.init(format: "¥ %.2f", ((model.showPrice ?? 0)))
                    self.tjPrice.isHidden = false;
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
        if let model = product as? SeckillActivityProductsModel{
            //二级秒杀
            // if model.productStatus == -5 || model.productStatus == -13 || model.productStatus == 0{
            if(model.showPrice == "false"){
                self.priceLabel.isHidden = true
                self.tjPrice.isHidden = true
                // 特价
                promotionPriceIcon.snp.updateConstraints({ (make) in
                    make.width.equalTo(WH(30))
                })
                tjPrice.snp.updateConstraints({ (make) in
                    make.left.equalTo(self.promotionPriceIcon.snp.right).offset(WH(5))
                })
            }else{
                self.priceLabel.text = String.init(format: "¥%.2f", Float(model.seckillPrice ?? "0") ?? 0)
                self.tjPrice.isHidden = false
                self.priceLabel.isHidden = false
                self.tjPrice.text = String.init(format: "¥%.2f", Float(model.price ?? "0") ?? 0)
                // 特价
                promotionPriceIcon.snp.updateConstraints({ (make) in
                    make.left.equalTo(priceLabel.snp.right).offset(j4)
                    make.width.equalTo(WH(0))
                })
                tjPrice.snp.updateConstraints({ (make) in
                    make.left.equalTo(self.promotionPriceIcon.snp.right).offset(WH(0))
                })
            }
            //}
            // 对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
        }
        //MARK:一起购信息
        if let model = product as? FKYTogeterBuyModel{
            self.priceLabel.text = String.init(format: "¥%0.2f", model.subscribePrice ?? 0)
            self.priceLabel.isHidden = false
            //对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
        }
        if let model = product as? ShopListSecondKillProductItemModel{
            //店铺管秒杀特惠
            var priceStr = ""
            if let orginStr = model.productPrice, orginStr > 0 {
                self.priceLabel.isHidden = false
                self.priceLabel.text = String.init(format: "¥ %.2f",orginStr)
                priceStr = String.init(format: "¥ %.2f",orginStr)
            }
            
            if let tjPriceStr = model.specialPrice, tjPriceStr > 0 {
                self.tjPrice.isHidden = false
                self.priceLabel.isHidden = false
                self.priceLabel.text = String.init(format: "¥ %.2f", tjPriceStr)
                self.tjPrice.text = priceStr
                promotionPriceIcon.snp.updateConstraints({ (make) in
                    make.left.equalTo(priceLabel.snp.right).offset(j4)
                    make.width.equalTo(WH(0))
                })
                tjPrice.snp.updateConstraints({ (make) in
                    make.left.equalTo(self.promotionPriceIcon.snp.right).offset(WH(0))
                })
            } else {
                self.tjPrice.isHidden = true
                self.priceLabel.isHidden = false
                self.tjPrice.text = ""
                self.priceLabel.text = priceStr
                promotionPriceIcon.snp.updateConstraints({ (make) in
                    make.width.equalTo(WH(30))
                })
                tjPrice.snp.updateConstraints({ (make) in
                    make.left.equalTo(self.promotionPriceIcon.snp.right).offset(WH(5))
                })
            }
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
        }
        if let model = product as? ShopListProductItemModel{
            //品种汇推荐
            if let priceStr = model.productPrice, priceStr > 0 {
                self.priceLabel.isHidden = false
                self.priceLabel.text = String.init(format: "¥ %.2f",priceStr)
            }
            else {
                self.priceLabel.text = ""
            }
            if model.statusDesc == -5 || model.statusDesc == -13 ||  model.statusDesc == 0 {
                if (model.specialPrice != nil && model.specialPrice != 0) {
                    self.priceLabel.text = String.init(format: "¥ %.2f", (model.specialPrice)!)
                    self.tjPrice.text = String.init(format: "¥ %.2f", (model.productPrice!))
                    self.tjPrice.isHidden = false
                    self.promotionPriceIcon.text = "特价"
                    self.promotionPriceIcon.isHidden = false
                }
                if let _ = model.vipPromotionId, let vipNum = model.visibleVipPrice, vipNum > 0 {
                    if let vipAvailableNum = model.availableVipPrice ,vipAvailableNum > 0 {
                        //会员
                        self.vipOriginalLabel.isHidden = false
                        self.priceLabel.text = String.init(format: "¥ %.2f",vipNum)
                        self.vipOriginalLabel.text = String.init(format: "¥ %.2f",model.productPrice!)
                        self.vipTagLabel.text = "会员价"
                        self.vipTagLabel.snp.remakeConstraints({ (make) in
                            make.centerY.equalTo(self.priceLabel.snp.centerY)
                            make.left.equalTo(self.priceLabel.snp.right).offset(WH(5))
                            make.width.equalTo(WH(40))
                            make.height.equalTo(WH(15))
                        })
                    }
                    else {
                        //非会员
                        self.vipOriginalLabel.isHidden = true
                        self.priceLabel.text = String.init(format: "¥ %.2f",model.productPrice!)
                        self.vipTagLabel.text = String.init(format: "会员价¥ %.2f",vipNum)
                        let maxW = self.vipTagLabel.text!.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t29.font], context: nil).width
                        vipTagLabel.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(maxW + WH(10)))
                        self.vipTagLabel.snp.remakeConstraints({ (make) in
                            make.centerY.equalTo(self.priceLabel.snp.centerY)
                            make.left.equalTo(self.priceLabel.snp.right).offset(WH(5))
                            make.width.equalTo(maxW + WH(10))
                            make.height.equalTo(WH(15))
                        })
                    }
                    //有会员价格
                    self.tjPrice.isHidden = true
                    self.vipTagLabel.isHidden = false
                }
            }
            // 对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
            //折扣价
            if let disCountStr = model.disCountDesc,disCountStr.isEmpty == false,self.priceLabel.isHidden == false{
                let nonDigits = CharacterSet.decimalDigits.inverted
                let numStr =  disCountStr.trimmingCharacters(in: nonDigits)
                let disCountPrice = NSString(string:numStr)
                if  CGFloat(model.productPrice!) > CGFloat(disCountPrice.floatValue){
                    self.disCountLabel.isHidden = false
                    self.disCountLabel.text = disCountStr
                }else{
                    self.disCountLabel.isHidden = true
                }
            }else{
                self.disCountLabel.isHidden = true
            }
        }
        if let model = product as? FKYMedicinePrdDetModel{
            //中药材
            if let priceStr = model.productPrice, priceStr > 0 {
                self.priceLabel.isHidden = false
                self.priceLabel.text = String.init(format: "¥ %.2f",priceStr)
            }
            else {
                self.priceLabel.text = ""
            }
            if model.statusDesc == -5 || model.statusDesc == -13 ||  model.statusDesc == 0 {
                if (model.specialPrice != nil && model.specialPrice != 0) {
                    self.priceLabel.text = String.init(format: "¥ %.2f", (model.specialPrice)!)
                    self.tjPrice.text = String.init(format: "¥ %.2f", (model.productPrice!))
                    self.tjPrice.isHidden = false
                    self.promotionPriceIcon.text = "特价"
                    self.promotionPriceIcon.isHidden = false
                }
                if let _ = model.vipPromotionId, let vipNum = model.visibleVipPrice, vipNum > 0 {
                    if let vipAvailableNum = model.availableVipPrice ,vipAvailableNum > 0 {
                        //会员
                        self.vipOriginalLabel.isHidden = false
                        self.priceLabel.text = String.init(format: "¥ %.2f",vipNum)
                        self.vipOriginalLabel.text = String.init(format: "¥ %.2f",model.productPrice!)
                        self.vipTagLabel.text = "会员价"
                        self.vipTagLabel.snp.remakeConstraints({ (make) in
                            make.centerY.equalTo(self.priceLabel.snp.centerY)
                            make.left.equalTo(self.priceLabel.snp.right).offset(WH(5))
                            make.width.equalTo(WH(40))
                            make.height.equalTo(WH(15))
                        })
                    }
                    else {
                        //非会员
                        self.vipOriginalLabel.isHidden = true
                        self.priceLabel.text = String.init(format: "¥ %.2f",model.productPrice!)
                        self.vipTagLabel.text = String.init(format: "会员价¥ %.2f",vipNum)
                        let maxW = self.vipTagLabel.text!.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t29.font], context: nil).width
                        vipTagLabel.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(maxW + WH(10)))
                        self.vipTagLabel.snp.remakeConstraints({ (make) in
                            make.centerY.equalTo(self.priceLabel.snp.centerY)
                            make.left.equalTo(self.priceLabel.snp.right).offset(WH(5))
                            make.width.equalTo(maxW + WH(10))
                            make.height.equalTo(WH(15))
                        })
                    }
                    //有会员价格
                    self.tjPrice.isHidden = true
                    self.vipTagLabel.isHidden = false
                }
            }
            // 对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
            //折扣价
            if let disCountStr = model.disCountDesc,disCountStr.isEmpty == false,self.priceLabel.isHidden == false{
                let nonDigits = CharacterSet.decimalDigits.inverted
                let numStr =  disCountStr.trimmingCharacters(in: nonDigits)
                let disCountPrice = NSString(string:numStr)
                if  CGFloat(model.productPrice!) > CGFloat(disCountPrice.floatValue){
                    self.disCountLabel.isHidden = false
                    self.disCountLabel.text = disCountStr
                }else{
                    self.disCountLabel.isHidden = true
                }
            }else{
                self.disCountLabel.isHidden = true
            }
        }
        //MARK:商家特惠
        if let model = product as? FKYPreferetailModel{
            if model.priceStatus == -5 || model.priceStatus == -13 || model.priceStatus == 0{
                if let desPrice = model.price , desPrice > 0{
                    self.priceLabel.isHidden = false
                    self.priceLabel.text = String.init(format: "¥ %.2f", desPrice)
                }
                if model.tjSymbol == true , let killPrice = model.seckillPrice ,killPrice > 0{
                    self.priceLabel.text = String.init(format: "¥ %.2f",killPrice)
                    self.tjPrice.text = String.init(format: "¥ %.2f", ((model.price ?? 0)))
                    self.tjPrice.isHidden = false;
                    // self.promotionPriceIcon.text = "特价"
                    // self.promotionPriceIcon.isHidden = false
                    promotionPriceIcon.snp.updateConstraints({ (make) in
                        make.left.equalTo(priceLabel.snp.right).offset(j4)
                        make.width.equalTo(WH(0))
                    })
                    tjPrice.snp.updateConstraints({ (make) in
                        make.left.equalTo(self.promotionPriceIcon.snp.right).offset(WH(0))
                    })
                }else {
                    promotionPriceIcon.snp.updateConstraints({ (make) in
                        make.width.equalTo(WH(30))
                    })
                    tjPrice.snp.updateConstraints({ (make) in
                        make.left.equalTo(self.promotionPriceIcon.snp.right).offset(WH(5))
                    })
                }
                // 对价格大小调整
                if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                    let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                    priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                    self.priceLabel.attributedText = priceMutableStr
                }
            }
        }
        //MARK:单品包邮
        if let model = product as? FKYPackageRateModel{
            self.priceLabel.text = String.init(format: "¥%0.2f", model.price ?? 0)
            self.priceLabel.isHidden = false
            //对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
            self.promotionPriceIcon.text = "包邮价"
            self.promotionPriceIcon.isHidden = false
            promotionPriceIcon.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(44))
            })
        }
    }
    //到货通知 隐藏折后y特价 会员价
    func firstPageViewVisible(){
        tjPrice.isHidden = true
        vipTagLabel.isHidden = true
        vipOriginalLabel.isHidden = true
        
        disCountLabel.isHidden = true
        promotionPriceIcon.isHidden = true
    }
    //获取行高
    static func getContentHeight(_ product: Any) -> CGFloat{
        var Cell = WH(4)//当价格不展示的时候 供应商距上12  正常距上8 所以不展示 价格区域默认给4
        if let model = product as? HomeProductModel {
            if model.statusDesc == -5 || model.statusDesc == -13 ||  model.statusDesc == 0 {
                Cell =  Cell + WH(26)
            }
        }
        if let model = product as? ShopProductItemModel{
            if model.statusDesc == -5 || model.statusDesc == -13 ||  model.statusDesc == 0 {
                Cell =  Cell + WH(26)
            }
        }
        if let model = product as? ShopProductCellModel {
            if model.statusDesc == -5 || model.statusDesc == -13 ||  model.statusDesc == 0 {
                Cell =  Cell + WH(26)
            }
        }
        if product is OftenBuyProductItemModel{
            //常购清单
            Cell =  Cell + WH(26)
        }
        if let model = product as? HomeCommonProductModel {
            if model.statusDesc == -5 || model.statusDesc == -13 || model.statusDesc == 0{
                if model.productDesc != nil && model.productDesc!.isEmpty == false{
                    //显示价优
                    Cell =  Cell + WH(20)
                }else{
                    Cell =  Cell + WH(26)
                }
                
            }
        }
        if let model = product as? FKYFullProductModel{
            if model.statusDesc == -5 || model.statusDesc == -13 || model.statusDesc == 0{
                Cell =  Cell + WH(26)
            }
        }
        if let model = product as? SeckillActivityProductsModel{
            //二级秒杀
            //  if model.productStatus == -5 || model.productStatus == -13 || model.productStatus == 0{
            if(model.showPrice != "false"){
                Cell =  Cell + WH(26)
            }
            
            // }
        }
        //MARK:一起购信息
        if product is FKYTogeterBuyModel{
            Cell =  Cell + WH(26)
        }
        if  let model = product as? ShopListSecondKillProductItemModel{
            //店铺管秒杀特惠
            if model.statusDesc == -5 || model.statusDesc == -13 || model.statusDesc == 0{
                Cell =  Cell + WH(26)
            }
        }
        if let model = product as? ShopListProductItemModel{
            //品种汇推荐
            if model.statusDesc == -5 || model.statusDesc == -13 ||  model.statusDesc == 0 {
                Cell =  Cell + WH(26)
            }
        }
        if let model = product as?  FKYMedicinePrdDetModel{
            //中药材
            if model.statusDesc == -5 || model.statusDesc == -13 ||  model.statusDesc == 0 {
                Cell =  Cell + WH(26)
            }
        }
        if let model = product as?  FKYProductObject{
            //商详
            if model.priceInfo.showPrice == true {
                Cell =  Cell + WH(26)
            }
        }
        if let _ = product as? SearchMpHockProductModel{
            //mp钩子商品
            Cell =  Cell + WH(26)
        }
        if let _ = product as? SearchMpHockProductModel{
            //mp钩子商品
            Cell =  Cell + WH(26)
        }
        //MARK:商家特惠
        if let model = product as? FKYPreferetailModel{
            if model.priceStatus == -5 || model.priceStatus == -13 || model.priceStatus == 0{
                Cell =  Cell + WH(26)
            }
        }
        //MARK:单品包邮
        if let _ = product as? FKYPackageRateModel{
            Cell =  Cell + WH(26)
        }
        return Cell
    }
}
//价优专区
class PriceExcellentInfoView: UIView {
    
    // 价优信息
    fileprivate lazy var priceInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    // MARK: - UI
    fileprivate func setupView() {
        // 价格
        self.addSubview(priceInfoLabel)
        priceInfoLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(self).offset(17)
            make.left.equalTo(self)
            make.height.equalTo(WH(12))
        })
        
    }
    func configCell(_ product: Any) {
        // self.backgroundColor = UIColor.red
        priceInfoLabel.isHidden = true
        if let model = product as? HomeCommonProductModel{
            if model.productDesc != nil && model.productDesc!.isEmpty == false{
                priceInfoLabel.isHidden = false
                priceInfoLabel.text = model.productDesc!
            }
        }
    }
    //获取行高
    static func getContentHeight(_ product: Any) -> CGFloat{
        var Cell = WH(0)
        if let model = product as? HomeCommonProductModel {
            if model.productDesc != nil && model.productDesc!.isEmpty == false{
                Cell =  Cell + WH(17 + 12)
            }
        }
        return Cell
    }
}
