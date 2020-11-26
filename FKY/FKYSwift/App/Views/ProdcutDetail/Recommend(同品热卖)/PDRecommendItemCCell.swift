//
//  PDRecommendItemCCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/6/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商详之同品热卖cell中的单个商品ccell

import UIKit

class PDRecommendItemCCell: UICollectionViewCell {
    // MARK: - Property
    
    // 商品图片
    fileprivate lazy var imgviewPic: UIImageView = {
        let imgview = UIImageView.init(frame: CGRect.zero)
        imgview.contentMode = .scaleAspectFit
        return imgview
    }()
    
    // 名称
    fileprivate lazy var lblName: UILabel = {
        let lbl = UILabel.init(frame: CGRect.zero)
        lbl.backgroundColor = .clear
        lbl.textColor = RGBColor(0x343434)
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        return lbl
    }()
    
    // 规格
    fileprivate lazy var lblSpecification: UILabel = {
        let lbl = UILabel.init(frame: CGRect.zero)
        lbl.backgroundColor = .clear
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        return lbl
    }()
    
    // 价格
    fileprivate lazy var lblPrice: UILabel = {
        let lbl = UILabel.init(frame: CGRect.zero)
        lbl.backgroundColor = .clear
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
        
        contentView.addSubview(imgviewPic)
        imgviewPic.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(10))
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.width.equalTo(WH(70))
        }
        
        contentView.addSubview(lblName)
        lblName.snp.makeConstraints { (make) in
            make.top.equalTo(imgviewPic.snp.bottom).offset(WH(8))
            make.left.equalTo(contentView).offset(WH(5))
            make.right.equalTo(contentView).offset(-WH(5))
            make.height.equalTo(WH(16))
        }
        
        contentView.addSubview(lblSpecification)
        lblSpecification.snp.makeConstraints { (make) in
            make.top.equalTo(lblName.snp.bottom).offset(WH(2))
            make.left.equalTo(contentView).offset(WH(5))
            make.right.equalTo(contentView).offset(-WH(5))
            make.height.equalTo(WH(14))
        }
        
        contentView.addSubview(lblPrice)
        lblPrice.snp.makeConstraints { (make) in
            make.top.equalTo(lblSpecification.snp.bottom).offset(WH(10))
            make.left.equalTo(contentView).offset(WH(5))
            make.right.equalTo(contentView).offset(-WH(5))
            make.height.equalTo(WH(16))
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(_ product: FKYProductItemModel?) {
        imgviewPic.image = nil
        lblName.text = nil
        lblSpecification.text = nil
        lblPrice.text = nil

        guard let item = product else {
            return
        }

        // 设置图片
        let imgDefault = UIImage.init(named: "image_default_img")
        if let imgUrl = item.productImg, let url = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
            imgviewPic.sd_setImage(with: URL.init(string: url) , placeholderImage: imgDefault)
        }
        else {
            imgviewPic.image = imgDefault
        }

        // 设置名称
        if let pName = item.productName, pName.isEmpty == false {
            lblName.text = pName
        }

        // 设置规格
        lblSpecification.text = item.spec

        // 设置价格
        if let price = item.showPrice, price.isEmpty == false {
            //lblPrice.text = String(format: "￥%.2f", price)
            lblPrice.text = "￥\(price)"
        }
        else {
            lblPrice.text = "￥" + "--"
        }

        // 判断价格是否显示
        if item.flag == true {
            // 显示价格
        }
        else {
            // 不显示价格
            if let text = item.priceDesc, text.isEmpty == false {
                lblPrice.text = text
            }
            else {
                lblPrice.text = nil
            }
        }
    }
}
