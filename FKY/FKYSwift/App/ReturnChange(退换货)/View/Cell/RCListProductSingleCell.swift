//
//  RCListProductSingleCell.swift
//  FKY
//
//  Created by 乔羽 on 2018/10/30.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

class RCListProductSingleCell: UITableViewCell {
    
    fileprivate lazy var imageV: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "image_default_img"))
        return imgV
    }()
    
    fileprivate lazy var titleL: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        label.textColor = UIColor.black
        return label
    }()
    
    fileprivate lazy var specificationsL: UILabel = {
        let label = UILabel()
        label.fontTuple = t3
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    fileprivate lazy var numL: UILabel = {
        let label = UILabel()
        label.fontTuple = t20
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    fileprivate lazy var amountL: UILabel = {
        let label = UILabel()
        label.fontTuple = t64
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var peroidL: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        return label
    }()
    
    fileprivate lazy var batchNumberL: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    
    func setupView() {
        contentView.backgroundColor = RGBColor(0xf7f7f7)
        contentView.addSubview(imageV)
        contentView.addSubview(titleL)
        contentView.addSubview(amountL)
        contentView.addSubview(specificationsL)
        contentView.addSubview(numL)
        contentView.addSubview(peroidL)
        contentView.addSubview(batchNumberL)
        
        batchNumberL.isHidden = true
        peroidL.isHidden = true
        
        imageV.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(20))
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(WH(80))
        }
        
        amountL.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-WH(14))
            make.top.equalTo(contentView.snp.top).offset(WH(19))
            make.height.equalTo(WH(14))
        }
        
        
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(imageV.snp.right).offset(WH(12))
            make.top.equalTo(contentView.snp.top).offset(WH(19))
            make.height.equalTo(WH(14))
            make.right.equalTo(amountL.snp.left).offset(-WH(25))
        }
        amountL.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        
        
        numL.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-WH(14))
            make.top.equalTo(amountL.snp.bottom).offset(WH(6))
            make.height.equalTo(WH(13))
            make.width.lessThanOrEqualTo(WH(50))
        }
        
        specificationsL.snp.makeConstraints { (make) in
            make.left.equalTo(imageV.snp.right).offset(WH(12))
            make.top.equalTo(titleL.snp.bottom).offset(WH(6))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-WH(20+80+12+5+50+14))
        }
        
        
        peroidL.snp.makeConstraints { (make) in
            make.left.equalTo(imageV.snp.right).offset(WH(12))
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(18))
            make.height.equalTo(WH(12))
        }
        
        batchNumberL.snp.makeConstraints { (make) in
            make.left.equalTo(peroidL.snp.right).offset(WH(10))
            make.centerY.equalTo(peroidL.snp.centerY)
            make.height.equalTo(WH(12))
        }
    }
    
    func configView(_ model: RCListProductModel?) {
        amountL.text =  String(format: "￥%.2f", (model?.price)!)
        titleL.text = model?.goodsName
        specificationsL.text = model?.spec
        let amount = model?.rmaCount
        numL.text = "x" + amount!
        imageV.sd_setImage(with: URL(string: (model?.img)!), placeholderImage: UIImage(named: "image_default_img"))
    }
    //单个订单的售后列表
    func configASView(_ model: ASListProductModel?) {
        amountL.text =  String(format: "￥%.2f", (model?.price)!)
        titleL.text = model?.productName
        specificationsL.text = model?.specification
        var amount = model?.productCount
        if let count = model?.applyCount,count>0 {
            amount = "\(count)"
        }
        numL.text = "x" + amount!
        imageV.sd_setImage(with: URL(string: (model?.mainImgPath)!), placeholderImage: UIImage(named: "image_default_img"))
    }
    func configWrongNumView(_ model: ASListProductModel?) {
        amountL.text =  String(format: "￥%.2f", (model?.price)!)
        titleL.text = model?.productName
        specificationsL.text = model?.specification
        let amount = String(format: "%d", (model?.applyCount)!)
        numL.text = "x" + amount
        imageV.sd_setImage(with: URL(string: (model?.mainImgPath)!), placeholderImage: UIImage(named: "image_default_img"))
    }
    
    //全部订单的售后列表中的商品
    func configAllSaleProduct(_ model:FKYAllAfterSaleProductModel) {
        let defalutImage = UIImage(named: "image_default_img")
        imageV.image = defalutImage
        if  let urlStr = model.mainImgPath , let strProductPicUrl = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            imageV.sd_setImage(with: urlProductPic , placeholderImage: defalutImage)
        }
        titleL.text = model.productName
        if let price = model.productPrice {
            amountL.text =  String(format: "￥%.2f", price)
        }else {
             amountL.text = ""
        }
        specificationsL.text = model.specification
        //数量
        if let num = model.productCount {
             numL.text = "x" + num
        }else {
            numL.text = ""
        }
        peroidL.isHidden = false
        if let str = model.expiryDate {
            peroidL.text = "有效期: \(str)"
        }else {
            peroidL.text = ""
        }
    }
}
