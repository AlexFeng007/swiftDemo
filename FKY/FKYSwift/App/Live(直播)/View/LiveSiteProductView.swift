//
//  LiveSiteProductView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/18.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  直播坑位商品

import UIKit

class LiveSiteProductView: UIView {
    //背景
    fileprivate lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xffffff)
        return view
    }()
    
    //商品图片
    fileprivate lazy var productImageView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        return view
    }()
    //价格背景
    fileprivate lazy var priceBgView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBAColor(0xFF3715, alpha:0.6)
        return view
    }()
    //商品价格
    fileprivate lazy var producPriceLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0xFFFFFF)
        label.font = UIFont.boldSystemFont(ofSize: WH(11))
        // label.text = "￥19.59"
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = WH(2)
        self.addSubview(bgView)
        bgView.addSubview(productImageView)
        bgView.addSubview(priceBgView)
        priceBgView.addSubview(producPriceLabel)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        productImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(bgView)
            //            make.centerX.equalTo(bgView)
            //            make.height.width.equalTo(WH(65))
        }
        priceBgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(bgView)
            make.height.equalTo(WH(19))
        }
        producPriceLabel.snp.makeConstraints { (make) in
            make.center.equalTo(priceBgView)
        }
    }
    func  configView(_ productModel:HomeCommonProductModel){
        if let strProductPicUrl = productModel.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }else{
            self.productImageView.image = UIImage.init(named: "image_default_img")
        }
        self.producPriceLabel.isHidden = true
        if productModel.statusDesc == -5 || productModel.statusDesc == -13 || productModel.statusDesc == 0{
            if(productModel.price != nil && productModel.price != 0.0){
                self.producPriceLabel.isHidden = false
                self.producPriceLabel.text = String.init(format: "¥%.2f", productModel.price!)
            }
            if (productModel.promotionPrice != nil && productModel.promotionPrice != 0.0) {
                self.producPriceLabel.text = String.init(format: "¥%.2f", (productModel.promotionPrice ?? 0))
            }
            if let _ = productModel.vipPromotionId ,let vipNum = productModel.visibleVipPrice ,vipNum > 0 {
                if let vipAvailableNum = productModel.availableVipPrice ,vipAvailableNum > 0 {
                    //会员
                    self.producPriceLabel.text = String.init(format: "¥ %.2f",vipNum)
                }
            }
            priceBgView.isHidden = false
        }else{
            priceBgView.isHidden = true
        }
    }
}
