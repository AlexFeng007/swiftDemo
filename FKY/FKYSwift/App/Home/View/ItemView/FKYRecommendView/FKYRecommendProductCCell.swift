//
//  FKYRecommendProductCCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/9.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  (首页)首推特价（药城精选）之商品分页列表视图中的单个商品ccell

import UIKit

class FKYRecommendProductCCell: UICollectionViewCell {
    // MARK: - Property
    
    // 商品图片
    fileprivate lazy var imgviewPic: UIImageView! = {
        let imgview = UIImageView.init(frame: CGRect.zero)
        imgview.contentMode = .scaleAspectFit
        return imgview
    }()
    
    // 名称
    fileprivate lazy var lblName: UILabel! = {
        let lbl = UILabel.init(frame: CGRect.zero)
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0x343434)
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        return lbl
    }()
    
    // 规格
    fileprivate lazy var lblSpecification: UILabel! = {
        let lbl = UILabel.init(frame: CGRect.zero)
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        return lbl
    }()
    
    // 特价(标签)
    fileprivate lazy var promotionPriceIcon: UILabel = {
        let label = UILabel()
        label.fontTuple = t28
        label.textAlignment = .center
        label.layer.cornerRadius = WH(13)/2.0
        label.layer.masksToBounds = true
        label.layer.borderColor = RGBColor(0xFFC470).cgColor
        label.layer.borderWidth = 0.5
        label.textColor = RGBColor(0xFFC470)
        label.backgroundColor = UIColor.white
        //label.text = "特价"
        return label
    }()
  
    fileprivate lazy var promotionSignBg: PromotionTagLabel = {
          let sign = PromotionTagLabel()
          sign.isHidden = true
          return sign
      }()
    
      fileprivate lazy var promotionSignL: UILabel = {
          let sign = UILabel()
          sign.isHidden = true
          sign.backgroundColor = UIColor.clear
          sign.font = UIFont.systemFont(ofSize: WH(10))
          sign.textColor = UIColor.white
          sign.textAlignment = .center
          return sign
      }()
    // 优惠券(标签)
    fileprivate lazy var couponIcon: UILabel = {
        let label = UILabel()
        label.fontTuple = t28
        label.textAlignment = .center
        label.layer.cornerRadius = WH(13)/2.0
        label.layer.masksToBounds = true
        label.layer.borderColor = RGBColor(0xFD394D).cgColor
        label.layer.borderWidth = 0.5
        label.textColor = RGBColor(0xFD394D)
        label.backgroundColor = UIColor.white
        //label.text = "领券"
        return label
    }()
    
    // 价格
    fileprivate lazy var lblPrice: UILabel! = {
        let lbl = UILabel.init(frame: CGRect.zero)
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        return lbl
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = UIColor.clear
        
        contentView.addSubview(lblPrice)
        lblPrice.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(-WH(16))
            make.left.equalTo(contentView).offset(WH(8.5))
            make.right.equalTo(contentView).offset(-WH(8.5))
            make.height.equalTo(WH(14))
        }
        
        // 特价
        contentView.addSubview(promotionPriceIcon)
        promotionPriceIcon.snp.makeConstraints({ (make) in
            make.bottom.equalTo(lblPrice.snp.top).offset(-WH(5))
            make.centerX.equalTo(contentView.snp.centerX).offset(WH(-27/2.0-2.5))
            make.width.equalTo(WH(27))
            make.height.equalTo(WH(13))
        })
        
        // 优惠券
        contentView.addSubview(couponIcon)
        couponIcon.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.promotionPriceIcon.snp.centerY)
            make.centerX.equalTo(contentView.snp.centerX).offset(WH(27/2.0+2.5))
            make.width.equalTo(WH(27))
            make.height.equalTo(WH(13))
        })
        
        contentView.addSubview(lblSpecification)
        lblSpecification.snp.makeConstraints { (make) in
        make.bottom.equalTo(promotionPriceIcon.snp.top).offset(-j4)
            make.left.equalTo(contentView).offset(WH(8.5))
            make.right.equalTo(contentView).offset(-WH(8.5))
            make.height.equalTo(WH(13))
        }
        
        contentView.addSubview(lblName)
        lblName.snp.makeConstraints { (make) in
            make.bottom.equalTo(lblSpecification.snp.top).offset(-WH(6))
            make.left.equalTo(contentView).offset(WH(8.5))
            make.right.equalTo(contentView).offset(-WH(8.5))
            make.height.equalTo(WH(12))
        }
        
        contentView.addSubview(imgviewPic)
        imgviewPic.snp.makeConstraints { (make) in
            make.bottom.equalTo(lblName.snp.top).offset(-j1)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.width.equalTo(WH(70))
        }
        
        contentView.addSubview(promotionSignBg)
        promotionSignBg.snp.makeConstraints { (make) in
            make.top.equalTo(imgviewPic.snp.top).offset(WH(4))
            make.left.equalTo(imgviewPic)
            make.width.equalTo(WH(30))
            make.height.equalTo(WH(15))
        }
        
        contentView.addSubview(promotionSignL)
        promotionSignL.snp.makeConstraints { (make) in
            make.center.equalTo(promotionSignBg.snp.center)
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(_ product: HomeRecommendProductItemModel?) {
        // 默认先隐藏所有标签
        hideAllActivityIcon()
        
        imgviewPic.image = nil
        lblName.text = nil
        lblSpecification.text = nil
        lblPrice.text = nil
        
        if let item = product {
            // 设置图片
//            let imgDefault = imgviewPic.imageWithColor(RGBColor(0xf4f4f4), "icon_home_placeholder_image_logo", CGSize(width: WH(70), height: WH(70)))
            let imgDefault = UIImage.init(named: "image_default_img")
            if let url = item.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                //imgviewPic.sd_setImage(with: URL.init(string: url) , placeholderImage: UIImage.init(named: "img_product_default"))
                imgviewPic.sd_setImage(with: URL.init(string: url) , placeholderImage: imgDefault)
            }
            else {
                //imgviewPic.image = UIImage.init(named: "img_product_default")
                imgviewPic.image = imgDefault
            }
            
            // 设置名称
//            var shortName: String?
//            if let sName = item.shortName, sName.isEmpty == false {
//                shortName = sName
//            }
//            var productName: String?
//            if let pName = item.productName, pName.isEmpty == false {
//                productName = pName
//            }
//            if shortName != nil, productName != nil {
//                lblName.text = shortName! + " " + productName!
//            }
//            else if shortName == nil, productName != nil {
//                lblName.text = productName
//            }
//            else if shortName != nil, productName == nil {
//                lblName.text = shortName
//            }
//            else {
//                //
//            }
            // 直接使用productName，前面不再拼接shortName
            if let pName = item.productName, pName.isEmpty == false {
                lblName.text = pName
            }
            
            // 设置规格
            lblSpecification.text = item.productSpec
            
            // 设置价格
            if let price = item.productPrice {
                lblPrice.text = String(format: "￥%.2f", price)
            }
            else {
                lblPrice.text = "￥" + "--"
            }
            // 防止重用字体大小
            lblPrice.font = UIFont.boldSystemFont(ofSize: WH(14))
            if let yqUrl = item.buyTogetherJumpInfo, yqUrl.isEmpty == false {
              // 一起购不处理商品状态
            }
            else {
                 updatePriceStatus(item, lblPrice.text!)
            }
            
            if let sign = item.productSign {
                // 区域精选/诊所专供样式楼层，营销标签：最多显示1个，优先级从高到低：特价、返利、套餐、满减、满赠、领券、限购，
                promotionSignL.isHidden = false
                promotionSignBg.isHidden = false
                if sign.specialOffer! {
                    //特价商品显示特价
                    if let price = item.specialPrice {
                        lblPrice.text = String(format: "￥%.2f", price)
                    }
                    else {
                        lblPrice.text = "￥" + "--"
                    }
                    promotionSignL.text = "特价"
                    return
                }
                if sign.rebate! {
                    promotionSignL.text = "返利"
                    return
                }
                if sign.packages! {
                    promotionSignL.text = "套餐"
                    return
                }
                if sign.fullScale! {
                    promotionSignL.text = "满减"
                    return
                }
                if sign.fullGift! {
                    promotionSignL.text = "满赠"
                    return
                }
//                if sign.ticket! {
//                    promotionSignL.text = "领券"
//                    return
//                }
                if sign.purchaseLimit! {
                    promotionSignL.text = "限购"
                    return
                }
                
                promotionSignL.isHidden = true
                promotionSignBg.isHidden = true
            } else {
                promotionSignL.isHidden = true
                promotionSignBg.isHidden = true
            }
        }
    }
    
    // 仅针对商详之套餐cell
    func configCell4ProductDetail(_ product: FKYProductGroupItemModel?) {
        // 默认先隐藏所有标签
        hideAllActivityIcon()
        
        imgviewPic.image = nil
        lblName.text = nil
        lblSpecification.text = nil
        lblPrice.text = nil
        
        if let item = product {
            // 商品图片
            if var imgPath = item.filePath, imgPath.isEmpty == false {
                // 有返回图片url
                if imgPath.hasPrefix("//") {
                    imgPath = imgPath.substring(from: imgPath.startIndex)
                }
                let imgUrl = "https://p8.maiyaole.com/" + imgPath
                imgviewPic.sd_setImage(with: URL.init(string: imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: "img_product_default"))
            }
            else {
                // 未返回图片url
                imgviewPic.image = UIImage.init(named: "img_product_default")
            }
            
            // 商品标题
            let pName: String! = item.productName
            let sName: String! = item.shortName
            if pName != nil, pName.isEmpty == false {
                if sName != nil, sName.isEmpty == false {
                    self.lblName.text = pName + " " + sName
                }
                else {
                    self.lblName.text = pName
                }
            }
            else {
                self.lblName.text = sName
            }
            
            // 商品规格
            lblSpecification.text = item.spec!
            
            // 价格
            var strPrice: String = "¥--"
            if item.originalPrice != nil {
                if item.discountMoney != nil {
                    // 有返回节省金额
                    let priceFinal = item.originalPrice.floatValue - item.discountMoney.floatValue
                    //strPrice = "¥\(priceFinal)"
                    strPrice = String.init(format: "¥%.2f", priceFinal)
                }
                else {
                    // 未返回节省金额
                    //strPrice = "¥\(item.originalPrice.floatValue)"
                    strPrice = String.init(format: "¥%.2f", item.originalPrice.floatValue)
                }
            }
            lblPrice.text = strPrice
        }
    }
    
    
    // MARK: - Private
    
    // 隐藏所有标签
    func hideAllActivityIcon() {
        promotionPriceIcon.isHidden = true
        couponIcon.isHidden = true
        
        // 更新约束
        promotionPriceIcon.snp.updateConstraints { (make) in
            make.height.equalTo(0)
            make.bottom.equalTo(lblPrice.snp.top).offset(-WH(3))
        }
        couponIcon.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        self.layoutIfNeeded()
    }
    
    // 根据商品状态判断价格是否显示
    fileprivate func updatePriceStatus(_ product: HomeRecommendProductItemModel, _ price: String) {
        if let pStatus = product.statusDesc {
            switch pStatus {
            case 0:
                // 正常显示价格...<显示价格>
                lblPrice.text = price
                lblPrice.font = UIFont.boldSystemFont(ofSize: WH(14))
            case -1:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    lblPrice.text = msg
                }
                else {
                    lblPrice.text = "登录后可见"
                }
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case -2:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    lblPrice.text = msg
                }
                else {
                    lblPrice.text = "控销"
                }
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case -3:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    lblPrice.text = msg
                }
                else {
                    lblPrice.text = "资质认证后可见"
                }
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case -4:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    lblPrice.text = msg
                }
                else {
                    lblPrice.text = "控销"
                }
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case -5:
                // 缺货...<显示价格>
                lblPrice.text = price
                lblPrice.font = UIFont.boldSystemFont(ofSize: WH(14))
            case -6:
                // 不显示价格
                lblPrice.text = "￥" + "--"
                lblPrice.font = UIFont.boldSystemFont(ofSize: WH(14))
            case -7:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    lblPrice.text = msg
                }
                else {
                    lblPrice.text = "下架"
                }
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case -8:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    lblPrice.text = msg
                }
                else {
                    lblPrice.text = "无采购权限"
                }
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case -9:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    lblPrice.text = msg
                }
                else {
                    lblPrice.text = "申请权限后可见"
                }
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case -10:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    lblPrice.text = msg
                }
                else {
                    lblPrice.text = "权限审核后可见"
                }
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            default:
                lblPrice.text = price
                lblPrice.font = UIFont.boldSystemFont(ofSize: WH(14))
            }
        }
    }
}
