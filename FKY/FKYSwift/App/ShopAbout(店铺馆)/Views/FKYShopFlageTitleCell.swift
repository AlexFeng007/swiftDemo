//
//  FKYShopFlageTitleCell.swift
//  FKY
//
//  Created by yyc on 2020/10/22.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopFlageTitleCell: UITableViewCell {
    //MARK:ui属性
    fileprivate lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = RGBColor(0x999999)
        return label
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        label.text = "以下为优选好店"
        return label
    }()
    fileprivate lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = RGBColor(0x999999)
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
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.snp.centerX);
            make.width.lessThanOrEqualTo(WH(100))
            make.bottom.equalTo(self.snp.bottom).offset(-WH(10))
            make.height.equalTo(WH(14))
        })
        
        self.addSubview(leftLabel)
        leftLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(titleLabel.snp.left).offset(-WH(11))
            make.centerY.equalTo(titleLabel.snp.centerY);
            make.width.equalTo(WH(14))
            make.height.equalTo(WH(1))
        })
        
        self.addSubview(rightLabel)
        rightLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(titleLabel.snp.right).offset(WH(11))
            make.centerY.equalTo(titleLabel.snp.centerY);
            make.width.equalTo(WH(14))
            make.height.equalTo(WH(1))
        })
    }

}
