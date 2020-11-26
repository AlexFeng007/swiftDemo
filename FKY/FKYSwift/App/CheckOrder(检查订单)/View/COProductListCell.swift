//
//  COProductListCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商品列表cell

import UIKit

class COProductListCell: UITableViewCell {

    lazy var arrow: UIImageView = {
        let img = UIImageView(image: UIImage(named: "img_checkorder_arrow"))
        return img
    }()
    
    // 商品数量
    fileprivate lazy var lblCount: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .right
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        contentView.addSubview(arrow)
        contentView.addSubview(lblCount)
        
        arrow.snp_makeConstraints { (make) in
            make.right.equalToSuperview().offset(-WH(11));
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: WH(7), height: WH(12)));
        }
        
        
        lblCount.snp_makeConstraints { (make) in
            make.right.equalTo(arrow.snp_left).offset(-WH(8));
            make.centerY.equalToSuperview();
        }
        
    }
    
    // MARK: - Public
    func configCell(_ shop: COSupplyOrderModel) {
        
        guard let products = shop.products, products.count > 0 else {
            return
        }
        
        let allProducts: Array<COProductModel>?
        if products.count > 3 {
            allProducts = Array(products[0...2])
        }else {
            allProducts = products
        }
        
        for subView in self.subviews {
            if subView is UIImageView, subView != arrow {
                subView.removeFromSuperview()
            }
        }
        
        var lastImg: UIImageView?
        for product in allProducts! {
            let img =  UIImageView()
            if let url = product.productImageUrl, url.isEmpty == false {
                img.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "image_default_img"))
            }else {
                img.image = UIImage(named: "image_default_img")
            }
            addSubview(img)
            
            img.snp_makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: WH(70), height: WH(70)))
                
                if let lastIV = lastImg {
                    make.left.equalTo(lastIV.snp_right).offset(WH(13))
                }else {
                    make.left.equalToSuperview().offset(WH(11))
                }
            }
            lastImg = img
        }
        
        if let types = shop.productTypes, types > 0 {
            lblCount.text = "共\(types)种"
        }else {
            lblCount.text  = ""
        }
    }
}
