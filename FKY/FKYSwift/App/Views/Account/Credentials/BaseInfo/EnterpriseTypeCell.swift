//
//  EnterpriseTypeCell.swift
//  FKY
//
//  Created by yangyouyong on 2016/10/31.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  地址选择视图之地址项cell

import UIKit

class EnterpriseTypeCell: UICollectionViewCell {
    //MARK: - Property
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.textColor = RGBColor(0x333333)
        return label
    }()
    fileprivate lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        return label
    }()
    fileprivate lazy var indicatorView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    func setupView() {
        self.contentView.backgroundColor = bg1
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView).offset(WH(10))
            make.centerY.equalTo(self.contentView)
        })
        
        self.contentView.addSubview(self.indicatorView)
        self.indicatorView.snp.makeConstraints({ (make) in
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.centerY.equalTo(self.contentView)
        })
        
        self.contentView.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(self.indicatorView.snp.left).offset(WH(10))
            make.centerY.equalTo(self.contentView)
        })
        
        let separatorLine = UIView()
        self.contentView.addSubview(separatorLine)
        separatorLine.snp.makeConstraints({ (make) in
            make.left.equalTo(self).offset(WH(10))
            make.right.equalTo(self).offset(WH(-10))
            make.bottom.equalTo(self)
            make.height.equalTo(1)
        })
        separatorLine.backgroundColor = m2
    }
    
    //MARK: - Public
    func configCell(_ title: String, selected: Bool) {
        self.titleLabel.text = title
        if selected == true {
            titleLabel.textColor = RGBColor(0xFF394E)
            self.indicatorView.image = UIImage(named: "icon_category_selected")
        }
        else {
            self.indicatorView.image = nil
            titleLabel.textColor = RGBColor(0x333333)
        }
    }
}
