//
//  COSectionTextView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/5/13.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  检查订单界面之发票section下的footerview

import UIKit

class COSectionTextView: UITableViewCell {
    // MARK: - Property
    fileprivate var iconView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named:"cart_rebeat_icon")
        return img
    }()
    
    // 标题
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.text = "根据国家相关法规，纸质普票改为电子发票"
        lbl.textColor = RGBColor(0x999999)
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    
    // MARK: - LifeCycle

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .clear
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(WH(20))
        }
        
        contentView.addSubview(lblTip)
        lblTip.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconView.snp.centerY)
            make.left.equalTo(iconView.snp.right)
            make.right.equalToSuperview()
        }
    }
}
