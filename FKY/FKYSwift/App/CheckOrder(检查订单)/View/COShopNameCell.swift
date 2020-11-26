//
//  COShopNameCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  店铺名称cell

import UIKit

class COShopNameCell: UITableViewCell {
    // MARK: - Property
    // 店铺名称
    fileprivate lazy var lblName: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    // 自营标签
    fileprivate lazy var lblSelfIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "self_shop_icon"))
        return imageView
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
        
        contentView.addSubview(lblSelfIcon)
        contentView.addSubview(lblName)
        
        lblSelfIcon.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(11))
            make.centerY.equalTo(contentView)
            make.width.equalTo(WH(30))
            make.height.equalTo(WH(16))
        }
        
        lblName.snp.makeConstraints { (make) in
            make.left.equalTo(lblSelfIcon.snp_right).offset(WH(7))
            make.right.equalTo(contentView).offset(-WH(11))
            make.centerY.equalTo(contentView)
        }
    }
    
    
    // MARK: - Public
    
    func configCell(_ model: COSupplyOrderModel) {
        showContent(model)
    }
    
    
    fileprivate func showContent(_ model: COSupplyOrderModel) {
        
        // 商家类型标签
        if let type = model.supplyType, type == 1 {
            // MP
            lblSelfIcon.image = UIImage(named: "mp_shop_icon")
            lblSelfIcon.snp_updateConstraints { (make) in
                make.width.equalTo(WH(30))
                make.height.equalTo(WH(15))
            }
        }
        else {
            // 自营
            lblSelfIcon.isHidden = false    // 显示
            if let houseName = model.shortWarehouseName, houseName.isEmpty == false, let tagImage = FKYSelfTagManager.shareInstance.tagNameImage(tagName: houseName, colorType: .blue) {
                lblSelfIcon.image = tagImage
                lblSelfIcon.snp_updateConstraints { (make) in
                    make.width.equalTo(tagImage.size.width)
                    make.height.equalTo(tagImage.size.height)
                }
            }else {
                lblSelfIcon.image = UIImage(named: "self_shop_icon")
                lblSelfIcon.snp_updateConstraints { (make) in
                    make.width.equalTo(WH(30))
                    make.height.equalTo(WH(15))
                }
            }
        }
        
        // 商家名称
        lblName.text = model.supplyName
        layoutIfNeeded()
        self.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), radius: WH(8))
    }
}
