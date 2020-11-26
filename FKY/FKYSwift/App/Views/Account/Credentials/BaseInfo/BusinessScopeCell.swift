//
//  BusinessScopeCell.swift
//  FKY
//
//  Created by yangyouyong on 2016/11/3.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit

class BusinessScopeCell: UICollectionViewCell {
    //MARK: Property Private
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.textColor = RGBColor(0x343434)
        label.numberOfLines = 2
        return label
    }()
    
    fileprivate lazy var indicatorView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    fileprivate lazy var separatorLine: UIView = {
        let v = UIView()
        v.backgroundColor = m2
        return v
    }()
    
    fileprivate lazy var rightLine: UIView = {
        let v = UIView()
        v.backgroundColor = m2
        return v
    }()
    
    //MARK: Private Method
    fileprivate func setupView() {
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView).offset(WH(10))
            make.right.equalTo(self.contentView.snp.right).offset(WH(-40))
            make.centerY.equalTo(self.contentView)
        })
        
        self.contentView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints({ (make) in
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.centerY.equalTo(self.contentView)
        })
        
        self.contentView.addSubview(separatorLine)
        separatorLine.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.height.equalTo(1)
        })
        
        self.contentView.addSubview(rightLine)
        rightLine.snp.makeConstraints({ (make) in
            make.right.equalTo(self.contentView).offset(-1)
            make.bottom.top.equalTo(self.contentView)
            make.width.equalTo(1)
        })
        
        self.backgroundColor = bg1
    }
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public Method
    func configCell(_ title: String, selected: Bool, hidRightLine: Bool){
        titleLabel.text = title
        if selected == true {
            indicatorView.image = UIImage(named: "icon_cart_selected")
            titleLabel.textColor = RGBColor(0xe60012)
            titleLabel.font = UIFont.boldSystemFont(ofSize: WH(16))
        }else{
            indicatorView.image = nil
            titleLabel.textColor = RGBColor(0x343434)
            titleLabel.font = UIFont.systemFont(ofSize: WH(16))
        }
        rightLine.isHidden = hidRightLine
    }
}
