//
//  COFollowQualificaProductInfoCell.swift
//  FKY
//
//  Created by 寒山 on 2020/11/9.
//  Copyright © 2020 yiyaowang. All rights reserved.
//。商品首营资质列表cell

import UIKit

class COFollowQualificaProductInfoCell: UITableViewCell {
    //全部按钮
    fileprivate var statusImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    ///商品图片
    fileprivate lazy var productImageView:UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    ///商品名 
    fileprivate lazy var productName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        return label
    }()
    
    //标签
    fileprivate lazy var productQualificationTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(11))
        label.textColor = RGBColor(0xFF832C)
        label.backgroundColor = RGBColor(0xFFF2E7)
        return label
    }()
    
    // 下分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        contentView.addSubview(statusImage)
        contentView.addSubview(productImageView)
        contentView.addSubview(productName)
        contentView.addSubview(productQualificationTypeLabel)
        contentView.addSubview(self.viewLine)
        statusImage.snp.makeConstraints({ (make) in
            make.centerY.equalTo(productImageView)
            make.left.equalTo(contentView).offset(WH(6))
            make.width.height.equalTo(WH(26.0))
        })
        
        productImageView.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(39))
            make.width.height.equalTo(WH(80))
        })
        
        productName.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView).offset(WH(13))
            make.left.equalTo(productImageView.snp.right).offset(WH(11))
            make.right.equalTo(contentView).offset(WH(-12))
        })
        
        productQualificationTypeLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(productImageView.snp.bottom).offset(WH(-4))
            make.left.equalTo(productImageView.snp.right).offset(WH(11))
            make.width.equalTo(WH(52))
            make.height.equalTo(WH(15))
        })
        
        self.viewLine.snp.makeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.left.right.equalTo(strongSelf.contentView)
            make.bottom.equalTo(strongSelf.contentView).offset(-0.5)
            make.height.equalTo(0.5)
        })
    }
    
    func  configCell(_ productModel:COProductModel?){
        productQualificationTypeLabel.isHidden = true
        if let model =  productModel{
             //  自定义 检查订单商品首营资质选择状态 0 枚选择 1选择批件 2选择全套
            if model.customerRequestProductType == 1{
                self.statusImage.image = UIImage.init(named: "img_pd_select_select")
                productQualificationTypeLabel.isHidden = false
                productQualificationTypeLabel.text = "批件资质"
            }else if model.customerRequestProductType == 2{
                self.statusImage.image = UIImage.init(named: "img_pd_select_select")
                productQualificationTypeLabel.isHidden = false
                productQualificationTypeLabel.text = "全套资质"
            }else{
                self.statusImage.image = UIImage.init(named: "img_pd_select_normal")
            }
            if let pUrl = model.productImageUrl, pUrl.isEmpty == false {
                if let url = pUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                    productImageView.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage(named: "image_default_img"))
                }
                else {
                    productImageView.image = UIImage(named: "image_default_img")
                }
            }
            else {
                productImageView.image = UIImage(named: "image_default_img")
            }
            var productFullName = ""
            //名
            if let name = model.productName, name.isEmpty == false {
                productFullName += name
            }
            //规格
            if let spec = model.specification, spec.isEmpty == false {
                productFullName = productFullName + " " + spec
            }
            productName.text = productFullName
        }
    }
}
