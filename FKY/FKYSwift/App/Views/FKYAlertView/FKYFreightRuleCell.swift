//
//  FKYFreightRuleCell.swift
//  FKY
//
//  Created by 寒山 on 2018/5/3.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import Foundation

class FKYFreightRuleCell: UITableViewCell {
    
    fileprivate var titleLabel: UILabel?    // 商家名称
    fileprivate var detailLabel: UILabel?    // 规则明细
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = bg1
        self.titleLabel = {
            let label = UILabel()
            label .sizeToFit()
            self.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(self.snp.left).offset(WH(j2))
                make.right.equalTo(self.snp.right).offset(WH(-j2))
                make.top.equalTo(self.snp.top);
                make.width.lessThanOrEqualTo(WH(190))
            })
            //label.text = "1. 商家名称："
            label.fontTuple = t9
            label.font = UIFont.boldSystemFont(ofSize: WH(13));
            return label
        }()
        
        self.detailLabel = {
            let label = UILabel()
            label.numberOfLines = 0
            contentView.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(contentView.snp.left).offset(WH(j5))
                make.right.equalTo(contentView.snp.right).offset(WH(-j5))
                make.top.equalTo(self.titleLabel!.snp.bottom).offset(WH(j4))
                make.bottom.equalTo(contentView.snp.bottom).offset(WH(-j1))
            })
            label.fontTuple = t31
            label.font = UIFont.systemFont(ofSize: WH(12))
            return label
        }()
    }
    func configCell(_ product:FKYFreightRulesModel?, index: Int) {
        if let model = product {
            self.titleLabel?.text = String(index+1) + "." + model.supplyName!
            self.detailLabel?.text = model.freightRule!
        }
        
    }
}

