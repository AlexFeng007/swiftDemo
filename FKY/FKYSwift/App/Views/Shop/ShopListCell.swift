//
//  ShopListCell.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/26.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit
import SnapKit

class ShopListCell: UICollectionViewCell {
    fileprivate var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = bg1
        return v
    }()
    fileprivate var img: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    fileprivate var icon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true;
        return iv
    }()
    fileprivate var productCountLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t9
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
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints({ (make) in
            make.left.equalTo(WH(5))
            make.right.equalTo(-WH(5))
            make.top.bottom.equalTo(self.contentView)
        })
        
        self.containerView.addSubview(img)
        img.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(self.containerView)
            make.height.equalTo(WH(102))
        })
        
        self.containerView.addSubview(icon)
        icon.snp.makeConstraints({ (make) in
            make.left.equalTo(self.img)
            make.top.equalTo(self.img.snp.bottom).offset(WH(3))
            make.height.equalTo(WH(35))
            make.width.equalTo(WH(115))
        })
        
        self.containerView.addSubview(productCountLabel)
        productCountLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(-WH(10))
            make.top.equalTo(self.img.snp.bottom)
            make.centerY.equalTo(self.icon)
        })
        
        self.backgroundColor = bg2
    }
    
    func configCell(_ shopModel: HomeShopModel?) {
        if let model = shopModel {
            let str = (model.imgUrl! as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)
            if let url = URL(string: str!) {
                self.img.sd_setImage(with: url, placeholderImage: UIImage(named: "image_placeholder_rect"))
            }
            if let bannerUrlStr = model.shopBrandUrl, let bannerUrl = URL(string: bannerUrlStr) {
                self.icon.sd_setImage(with: bannerUrl, placeholderImage: UIImage(named: "image_placeholder_rect"))
            }
            self.productCountLabel.text = "商品: \(model.productCount!)个"
            self.productCountLabel.attributedText = {
                    let name = "商品: \(model.productCount!)个" as NSString
                let str = NSMutableAttributedString(string: name as String, attributes: [NSAttributedString.Key.foregroundColor: t8.color,NSAttributedString.Key.font: t8.font])
                    let specRange = name.range(of: "\(model.productCount!)")
                str.setAttributes([NSAttributedString.Key.foregroundColor: t13.color,NSAttributedString.Key.font: t13.font], range: specRange)
                    return str
                }()
        }
    }
}
