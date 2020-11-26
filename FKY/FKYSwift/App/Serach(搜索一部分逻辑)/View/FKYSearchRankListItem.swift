//
//  FKYSearchRankListItem.swift
//  FKY
//
//  Created by 油菜花 on 2020/2/11.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSearchRankListItem: UICollectionViewCell {
    
    
    fileprivate lazy var selectedImageview: UIImageView =  {
        let imageV = UIImageView()
        imageV.backgroundColor = UIColor.clear
        imageV.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageV)
        return imageV
    }()
    
    fileprivate lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.textColor = RGBColor(0x555555);
        label.textAlignment = .left
        label.sizeToFit()
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        return label
    }()
    
    fileprivate lazy var bottomLine: UIView =  {
        let lineV = UIView ()
        lineV.backgroundColor = RGBColor(0xE5E5E5)
        self.contentView.addSubview(lineV)
        return lineV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
            make.width.equalTo((SCREEN_WIDTH - WH(13)*3)/2.0)
        }
        
        self.titleLabel.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(13))
            make.right.equalTo(contentView).offset(-WH(18 + 20 + 14))
        })
        self.selectedImageview.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView)
            make.right.lessThanOrEqualTo(contentView).offset(WH(-18))
        })
        self.bottomLine.snp.makeConstraints({ (make) in
            make.bottom.right.left.equalTo(contentView)
            make.height.equalTo(0)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configCell(_ title: String?, isSelected: Bool) {
        self.titleLabel.text = title
        
        if isSelected {
            self.titleLabel.textColor = RGBColor(0xFF2D5C)
            self.selectedImageview.image = UIImage.init(named: "Search_Selected")
        }else {
            self.titleLabel.textColor = RGBColor(0x555555)
            self.selectedImageview.image = nil
        }
    }

}
