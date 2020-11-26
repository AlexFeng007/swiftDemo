//
//  SendCoupondHotSellProductCell.swift
//  FKY
//
//  Created by 寒山 on 2020/5/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class SendCoupondHotSellProductCell: UICollectionViewCell {
    
    //商品图片
    fileprivate var productImageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    //商品名称
    fileprivate var productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = t33.font
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    //商品购买价格
    fileprivate var priceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = t73.color
        label.font = t17.font
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.backgroundColor = UIColor.white
        //self.layer.masksToBounds = true
        self.layer.cornerRadius = WH(8)
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowColor = RGBAColor(0xD9D9D9,alpha: 0.3).cgColor
        self.layer.shadowOpacity = 1;//阴影透明度，默认0
        self.layer.shadowRadius = 4;//阴影半径
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(10))
            make.height.width.equalTo(WH(70))
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        contentView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(9))
            make.right.equalTo(contentView.snp.right).offset(-WH(5))
            make.top.equalTo(self.productImageView.snp.bottom).offset(WH(8))
            make.height.equalTo(WH(12))
        }
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.top.equalTo(productNameLabel.snp.bottom).offset(WH(10))
            make.height.equalTo(WH(14))
        }
    }
    
    func configHotSellItemCell(_ productModel:Any) {
        if let model = productModel as? OftenBuyProductItemModel{
            let imgDefault = UIImage.init(named: "image_default_img")
            productImageView.image = imgDefault
            if let imgUrl = model.imgPath, let url = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                productImageView.sd_setImage(with: URL.init(string: url) , placeholderImage: imgDefault)
            }
            productNameLabel.text = model.productFullName
            let price = getShowPrice(model)
            if price.count > 0 {
                priceLabel.text = price
            }else {
                priceLabel.text = "¥--"
            }
        }
    }
}
extension SendCoupondHotSellProductCell {
    fileprivate func getShowPrice (_ model:OftenBuyProductItemModel) -> String{
        var showPrice = ""
        if let price = model.price , price > 0 {
            showPrice = String.init(format: "¥ %.2f", price)
        }
        if let price = model.promotionPrice , price > 0 {
            showPrice = String.init(format: "¥ %.2f", price)
        }
        if let _ = model.vipPromotionId ,let vipNum = model.visibleVipPrice ,vipNum > 0 {
            if let vipAvailableNum = model.availableVipPrice ,vipAvailableNum > 0 {
                //会员
                showPrice = String.init(format: "¥ %.2f",vipNum)
            }
        }
        return showPrice
    }
}

