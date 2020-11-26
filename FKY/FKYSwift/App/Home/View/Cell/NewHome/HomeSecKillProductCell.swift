//
//  HomeSecKillProductCell.swift
//  FKY
//
//  Created by 寒山 on 2020/4/22.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class HomeSecKillProductCell: UICollectionViewCell {
    
    //商品图片
    fileprivate var productImageView: UIImageView = {
        let img = UIImageView()
        //img.contentMode = .center
        return img
    }()
    
    //商品购买价格
    fileprivate var priceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = RGBColor(0xFF2D5C)
        label.font = t21.font
        return label
    }()
    // 商品原价
    fileprivate lazy var priceOriginalLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t28
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        let line = UIView()
        label.addSubview(line)
        line.snp.makeConstraints({ (make) in
            make.left.right.centerY.equalTo(label)
            make.height.equalTo(WH(1))
        })
        line.backgroundColor = t11.color
        
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.height.width.equalTo(WH(70))
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(productImageView.snp.bottom)
            make.width.lessThanOrEqualTo(WH(68))
        }
        contentView.addSubview(priceOriginalLabel)
        priceOriginalLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(priceLabel.snp.bottom).offset(WH(1))
            make.width.lessThanOrEqualTo(WH(68))
        }
        
        
    }
    
    func configCell(_ productModel : HomeRecommendProductItemModel?,_ killModel:HomeSecdKillProductModel?) {
        // 设置图片
        if let model = productModel {
            
            priceOriginalLabel.isHidden = true
            let imgDefault = UIImage.init(named: "image_default_img")
            productImageView.image = imgDefault
            if let imgUrl = model.imgPath, let url = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                productImageView.sd_setImage(with: URL.init(string: url) , placeholderImage: imgDefault)
            }
            
            if model.statusDesc == 0 {
                //商品价格相关
                priceOriginalLabel.text = ""
                if let price = model.productPrice , price > 0 {
                    priceLabel.text = String.init(format: "¥ %.2f", price)
                }else {
                    priceLabel.text = "¥--"
                }
                if let vipPrice = model.availableVipPrice , vipPrice > 0 {
                    //有会员价格
                    priceLabel.text = String.init(format: "¥ %.2f", vipPrice)
                    if let flagModel = killModel, flagModel.togetherMark != 1 {
                        //一起购不显示原价
                        priceOriginalLabel.text = String.init(format: "¥%.2f", model.productPrice ?? 0.0)
                        priceOriginalLabel.isHidden = false
                    }
                }
                if let tjPrice = model.specialPrice ,tjPrice > 0 {
                    //特价
                    priceLabel.text = String.init(format: "¥ %.2f", tjPrice)
                    if let flagModel = killModel, flagModel.togetherMark != 1 {
                        //一起购不显示原价
                        priceOriginalLabel.text = String.init(format: "¥%.2f", model.productPrice ?? 0.0)
                        priceOriginalLabel.isHidden = false
                    }
                }
                //判断秒杀楼层是否显示原价
                //if let flagModel = killModel, flagModel.originalPriceFlag == 1 {
                priceOriginalLabel.isHidden = false
                //                }else{
                //                    priceOriginalLabel.isHidden = true
                //                    priceOriginalLabel.text = ""
                //                }
            }else {
                priceLabel.text = model.statusMsg
                priceOriginalLabel.text = ""
            }
        }
    }
}
//一行只有一个秒杀品
class HomeSingleSecKillProductCell: UICollectionViewCell {
    
    //商品图片
    fileprivate var productImageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    //商品购买价格
    fileprivate var productNameLabel: UILabel = {
        let label = UILabel()
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.8
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.systemFont(ofSize: WH(11))
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    
    //商品厂家
    fileprivate var factoryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.systemFont(ofSize: WH(10))
        return label
    }()
    
    //商品购买价格
    fileprivate var priceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = RGBColor(0xFF2D5C)
        label.font = t21.font
        return label
    }()
    // 商品原价
    fileprivate lazy var priceOriginalLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t28
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        let line = UIView()
        label.addSubview(line)
        line.snp.makeConstraints({ (make) in
            make.left.right.centerY.equalTo(label)
            make.height.equalTo(WH(1))
        })
        line.backgroundColor = t11.color
        
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(0))
            make.height.width.equalTo(WH(70))
            make.right.equalTo(contentView.snp.centerX).offset(WH(-5))
        }
        
        contentView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.centerX).offset(WH(5))
            make.right.equalTo(contentView)
        }
        
        contentView.addSubview(factoryNameLabel)
        factoryNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productNameLabel.snp.bottom).offset(WH(6))
            make.left.equalTo(contentView.snp.centerX).offset(WH(5))
            make.right.equalTo(contentView)
        }
        
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.centerX).offset(WH(5))
            make.top.equalTo(contentView).offset(WH(52))
            make.right.equalTo(contentView)
        }
        
        contentView.addSubview(priceOriginalLabel)
        priceOriginalLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.centerX).offset(WH(5))
            make.top.equalTo(priceLabel.snp.bottom).offset(WH(1))
            // make.right.equalTo(priceLabel.snp.right)
        }
        
        
    }
    
    func configCell(_ productModel : HomeRecommendProductItemModel?,_ killModel:HomeSecdKillProductModel?) {
        // 设置图片
        if let model = productModel {
            
            priceOriginalLabel.isHidden = true
            let imgDefault = UIImage.init(named: "image_default_img")
            productImageView.image = imgDefault
            if let imgUrl = model.imgPath, let url = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                productImageView.sd_setImage(with: URL.init(string: url) , placeholderImage: imgDefault)
            }
            productNameLabel.text = model.productName
            factoryNameLabel.text = model.factoryName ?? ""
            if model.statusDesc == 0 {
                //商品价格相关
                priceOriginalLabel.text = ""
                if let price = model.productPrice , price > 0 {
                    priceLabel.text = String.init(format: "¥ %.2f", price)
                }else {
                    priceLabel.text = "¥--"
                }
                if let vipPrice = model.availableVipPrice , vipPrice > 0 {
                    //有会员价格
                    priceLabel.text = String.init(format: "¥ %.2f", vipPrice)
                    if let flagModel = killModel, flagModel.togetherMark != 1 {
                        //一起购不显示原价
                        priceOriginalLabel.text = String.init(format: "¥%.2f", model.productPrice ?? 0.0)
                        priceOriginalLabel.isHidden = false
                    }
                }
                if let tjPrice = model.specialPrice ,tjPrice > 0 {
                    //特价
                    priceLabel.text = String.init(format: "¥ %.2f", tjPrice)
                    if let flagModel = killModel, flagModel.togetherMark != 1 {
                        //一起购不显示原价
                        priceOriginalLabel.text = String.init(format: "¥%.2f", model.productPrice ?? 0.0)
                        priceOriginalLabel.isHidden = false
                    }
                }
                //判断秒杀楼层是否显示原价
                //if let flagModel = killModel, flagModel.originalPriceFlag == 1 {
                priceOriginalLabel.isHidden = false
                //                }else{
                //                    priceOriginalLabel.isHidden = true
                //                    priceOriginalLabel.text = ""
                //                }
            }else {
                priceLabel.text = model.statusMsg
                priceOriginalLabel.text = ""
            }
        }
    }
}
