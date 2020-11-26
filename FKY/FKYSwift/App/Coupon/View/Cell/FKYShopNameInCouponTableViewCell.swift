//
//  FKYShopNameInCouponTableViewCell.swift
//  FKY
//
//  Created by hui on 2019/8/26.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopNameInCouponTableViewCell: UITableViewCell {

    // MARK: - Properties
    public lazy var shopNameLabel: UILabel! = {
        let label = UILabel()
        label.font = t3.font
        label.textColor = RGBColor(0x666666)
        return label
    }()
    fileprivate lazy var imgviewArrow: UIImageView! = {
        let imgview = UIImageView()
        imgview.image = UIImage.init(named: "img_pd_arrow_gray")
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = RGBColor(0xFBFBFB)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Action
    // MARK: - UI
    
    func setupView() {
        
        contentView.addSubview(shopNameLabel)
        shopNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(13))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-WH(70))
            make.centerY.equalTo(contentView.snp.centerY)
        }
        contentView.addSubview(imgviewArrow)
        imgviewArrow.snp.makeConstraints { (make) in
            make.left.equalTo(shopNameLabel.snp.right)
            make.size.equalTo(CGSize.init(width: WH(20), height: WH(20)))
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    // MARK: - Private Method
    func configshopNameViewCell(_ shopNameStr :String) {
        shopNameLabel.text = shopNameStr
    }
}
