//
//  COPayAmountCell.swift
//  FKY
//
//  Created by My on 2019/12/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class COPayAmountCell: UITableViewCell {
    
    enum COPayInfoKey: String {
        case payAmountKey = "payAmountKey"
        case countKey = "countKey"
        case tipKey = "tipKey"
    }
    
    // 商品数量
    fileprivate lazy var lblCount: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x999999)
        return lbl
    }()
    
    //小计/应付总额：
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        return lbl
    }()
    
    //￥ 10000.00
    fileprivate lazy var lblPayAmount: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(16))
        lbl.textColor = RGBColor(0xFF2D5C)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        configSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension COPayAmountCell {
    func configSubViews()  {
        contentView.addSubview(lblPayAmount)
        contentView.addSubview(lblTip)
        contentView.addSubview(lblCount)
        
        lblPayAmount.snp_makeConstraints { (make) in
            make.right.equalToSuperview().offset(-WH(11))
            make.centerY.equalToSuperview()
        }
        
        lblTip.snp_makeConstraints { (make) in
            make.right.equalTo(lblPayAmount.snp_left).offset(-WH(3))
            make.centerY.equalToSuperview()
        }
        
        lblCount.snp_makeConstraints { (make) in
            make.right.equalTo(lblTip.snp_left).offset(-WH(13))
            make.centerY.equalToSuperview()
        }
    }
    
    
    func configCell(_ tips: [String: String]) {
        if let payAmount = tips[COPayInfoKey.payAmountKey.rawValue] {
            lblPayAmount.text = payAmount
        }
        
        if let tip = tips[COPayInfoKey.tipKey.rawValue] {
            lblTip.text = tip
        }
        
        if let count = tips[COPayInfoKey.countKey.rawValue] {
            lblCount.text = count
        }
        
        layoutIfNeeded()
        self.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue), radius: WH(8))
    }
    
}
