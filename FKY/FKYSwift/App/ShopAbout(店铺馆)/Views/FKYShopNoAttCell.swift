//
//  FKYShopNoAttCell.swift
//  FKY
//
//  Created by yyc on 2020/10/22.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopNoAttCell: UITableViewCell {

    //MARK:ui属性
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        label.backgroundColor = RGBColor(0xffffff)
        label.layer.cornerRadius = WH(8)
        label.layer.masksToBounds = true
        label.text = "未关注任何店铺，以下为优选好店"
        label.textAlignment = .center
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView(){
        self.backgroundColor = RGBColor(0xf4f4f4)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView.snp.top);
            make.left.equalTo(contentView.snp.left).offset(WH(10))
            make.right.equalTo(contentView.snp.right).offset(-WH(10))
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(10));
        })
    }
}
