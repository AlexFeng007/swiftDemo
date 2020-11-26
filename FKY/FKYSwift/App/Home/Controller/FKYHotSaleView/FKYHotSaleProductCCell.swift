//
//  FKYHotSaleProductCCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/11.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  (首页)热销商品之单个商品ccell

import UIKit

class FKYHotSaleProductCCell: UICollectionViewCell {
    // MARK: - Property
    
    // 图片
    fileprivate lazy var imgviewPic: UIImageView! = {
        let imgview = UIImageView.init(frame: CGRect.zero)
        imgview.contentMode = .scaleAspectFit
        return imgview
    }()
    
    // 名称
    fileprivate lazy var lblName: UILabel! = {
        let view = UILabel.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.textAlignment = .left
        view.textColor = RGBColor(0x333333)
        view.font = UIFont.systemFont(ofSize: WH(14))
        return view
    }()
    
    // 规格 + 库存
    fileprivate lazy var lblSpecification: UILabel! = {
        let view = UILabel.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.textAlignment = .left
        view.textColor = RGBColor(0x666666)
        view.font = UIFont.systemFont(ofSize: WH(12))
        return view
    }()

    // 供应商
    fileprivate lazy var lblCompany: UILabel! = {
        let view = UILabel.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.textAlignment = .left
        view.textColor = RGBColor(0xC3C3C3)
        view.font = UIFont.systemFont(ofSize: WH(12))
        return view
    }()

    // 价格
    fileprivate lazy var lblPrice: UILabel! = {
        let view = UILabel.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.textAlignment = .left
        view.textColor = RGBColor(0xFF2D5C)
        view.font = UIFont.boldSystemFont(ofSize: WH(14))
        return view
    }()
    
    // 底部分隔线
    lazy var viewLine: UIView! = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
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
            //make.centerY.equalTo(contentView)
            //make.size.equalTo(CGSize.init(width: WH(80), height: WH(80)))
            make.left.equalTo(contentView).offset(WH(13))
            make.top.equalTo(contentView).offset(WH(10))
            make.bottom.equalTo(contentView).offset(-WH(10))
            make.width.equalTo(WH(80))
        }
        
        contentView.addSubview(lblName)
        lblName.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(18))
            make.left.equalTo(imgviewPic.snp.right).offset(WH(14))
            make.right.equalTo(contentView).offset(-WH(10))
            make.height.equalTo(WH(16))
        }
        
        contentView.addSubview(lblSpecification)
        lblSpecification.snp.makeConstraints { (make) in
            make.top.equalTo(lblName.snp.bottom).offset(WH(5))
            make.left.equalTo(imgviewPic.snp.right).offset(WH(14))
            make.right.equalTo(contentView).offset(-WH(10))
            make.height.equalTo(WH(14))
        }
        
        contentView.addSubview(lblCompany)
        lblCompany.snp.makeConstraints { (make) in
            make.top.equalTo(lblSpecification.snp.bottom).offset(WH(5))
            make.left.equalTo(imgviewPic.snp.right).offset(WH(14))
            make.right.equalTo(contentView).offset(-WH(10))
            make.height.equalTo(WH(14))
        }
        
        contentView.addSubview(lblPrice)
        lblPrice.snp.makeConstraints { (make) in
            //make.top.equalTo(lblCompany.snp.bottom).offset(WH(10))
            make.left.equalTo(imgviewPic.snp.right).offset(WH(14))
            make.right.equalTo(contentView).offset(-WH(10))
            make.bottom.equalTo(contentView).offset(-WH(15))
            make.height.equalTo(WH(18))
        }
        
        contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(self)
            make.left.equalTo(lblName.snp.left)
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(_ product: HomeHotSaleProductItemModel?) {
        imgviewPic.image = nil
        lblName.text = nil
        lblSpecification.text = nil
        lblCompany.text = nil
        lblPrice.text = nil
        
        if let item = product {
            // 设置名称
            let imgDefault = imgviewPic.imageWithColor(RGBColor(0xf4f4f4), "icon_home_placeholder_image_logo", CGSize(width: WH(80), height: WH(80)))
            if let url = item.imgUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                //imgviewPic.sd_setImage(with: URL.init(string: url) , placeholderImage: UIImage.init(named: "img_product_default"))
                imgviewPic.sd_setImage(with: URL.init(string: url) , placeholderImage: imgDefault)
            }
            else {
                //imgviewPic.image = UIImage.init(named: "img_product_default")
                imgviewPic.image = imgDefault
            }
            
            // 设置名称
            var shortName: String?
            if let sName = item.shortName, sName.isEmpty == false {
                shortName = sName
            }
            var productName: String?
            if let pName = item.productName, pName.isEmpty == false {
                productName = pName
            }
            if shortName != nil, productName != nil {
                lblName.text = shortName! + " " + productName!
            }
            else if shortName == nil, productName != nil {
                lblName.text = productName
            }
            else if shortName != nil, productName == nil {
                lblName.text = shortName
            }
            else {
                //
            }
            
            // 设置规格
            lblSpecification.text = item.spec
            
            // 设置厂商
            lblCompany.text = item.factory
            
            // 设置价格
            if let price = item.price, price.isEmpty == false {
//                let priceDouble = Double(price)
//                let priceStr = String(format: "￥%.2f", priceDouble!)
                lblPrice.text = "￥" + price
            }
            else {
                lblPrice.text = "￥" + "--"
            }
            updatePriceStatus(item, lblPrice.text!)
        }
    }
    
    
    // MARK: - Private
    
    // 根据商品状态判断价格是否显示
    fileprivate func updatePriceStatus(_ product: HomeHotSaleProductItemModel, _ price: String) {
        if let pStatus = product.status {
            switch pStatus {
            case -1:
                // 无任何状态...<未查询到价格>
                lblPrice.text = "￥" + "--"
                lblPrice.font = UIFont.boldSystemFont(ofSize: WH(14))
            case 0:
                lblPrice.text = "资质认证后可见"
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case 1:
                // 价格不展示 (下架)
                lblPrice.text = "下架"
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case 2:
                lblPrice.text = "加入渠道后可见"
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case 3:
                // 限时特价...<显示价格>
                lblPrice.text = price
                lblPrice.font = UIFont.boldSystemFont(ofSize: WH(14))
            case 4:
                // 正常采购价...<显示价格>
                lblPrice.text = price
                lblPrice.font = UIFont.boldSystemFont(ofSize: WH(14))
            case 5:
                lblPrice.text = "登录后可见"
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case 6:
                lblPrice.text = "资质审核后可见"
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case 7:
                lblPrice.text = "渠道待审核"
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case 8:
                lblPrice.text = "不在销售区域内"
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case 9:
                // 缺货...<显示价格>
                lblPrice.text = price
                lblPrice.font = UIFont.boldSystemFont(ofSize: WH(14))
            case 10:
                // 卖家缺货...<显示价格>
                lblPrice.text = price
                lblPrice.font = UIFont.boldSystemFont(ofSize: WH(14))
            case 11:
                lblPrice.text = "采购权限待审核"
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case 12:
                // 采购权限审核通过...<显示价格>
                lblPrice.text = price
                lblPrice.font = UIFont.boldSystemFont(ofSize: WH(14))
            case 13:
                lblPrice.text = "采购权限审核未通过"
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case 14:
                lblPrice.text = "采购权限变更待审核"
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case 15:
                lblPrice.text = "采购权限已禁用"
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            case 16:
                lblPrice.text = "申请采购权限可见"
                lblPrice.font = UIFont.systemFont(ofSize: WH(12))
            default:
                lblPrice.text = price
                lblPrice.font = UIFont.boldSystemFont(ofSize: WH(14))
            }
        }
    }
}
