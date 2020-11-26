//
//  FKYRecommendTitleTableViewCell.swift
//  FKY
//
//  Created by yyc on 2020/4/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYRecommendTitleTableViewCell: UITableViewCell {
    
    //标题
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.textColor = RGBColor(0xFF2D5C)
        label.text = "常购清单"
        return label
    }()
    fileprivate var rightImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "shop_red_title_right_pic")
        return img
    }()
    fileprivate var leftImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "shop_red_title_left_pic")
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = RGBColor(0xF4F4F4)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView.snp.top).offset(WH(7));
            make.height.equalTo(WH(25))
            make.width.lessThanOrEqualTo(WH(100))
        })
        contentView.addSubview(rightImageView)
        rightImageView.snp.makeConstraints({ (make) in
            make.left.equalTo(titleLabel.snp.right).offset(WH(14))
            make.centerY.equalTo(titleLabel.snp.centerY);
        })
        
        contentView.addSubview(leftImageView)
        leftImageView.snp.makeConstraints({ (make) in
            make.right.equalTo(titleLabel.snp.left).offset(-WH(14))
            make.centerY.equalTo(titleLabel.snp.centerY);
        })
    }
    
    func resetTitle() {
        titleLabel.text = "为您推荐"
    }
    
    
}
