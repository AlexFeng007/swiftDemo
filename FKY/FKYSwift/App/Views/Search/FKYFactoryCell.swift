//
//  FKYFactoryCell.swift
//  FKY
//
//  Created by airWen on 2017/5/7.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

class FKYFactoryCell: UITableViewCell {
    fileprivate lazy var lblTitle:UILabel = {
        let label:UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.fontTuple = t14
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(lblTitle)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[lblTitle]-(>=8)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["lblTitle" : lblTitle]))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: lblTitle, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1.0, constant: -0.5))
        
        let viewBottomLine:UIView = UIView()
        viewBottomLine.translatesAutoresizingMaskIntoConstraints = false
        viewBottomLine.backgroundColor = RGBColor(0xeeeeee)
        self.contentView.addSubview(viewBottomLine)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewBottomLine]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["viewBottomLine" : viewBottomLine]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewBottomLine(1)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["viewBottomLine" : viewBottomLine]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configCell(_ title: String?) {
        self.lblTitle.text = title
    }
    func configShopRemindCell(_ title: String?) {
        self.lblTitle.font = t1.font
        self.lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(10))
            make.right.equalTo(contentView.snp.right).offset(WH(-10))
            make.centerY.equalTo(contentView.snp.centerY)
        }
        self.lblTitle.text = title
    }
    
}
