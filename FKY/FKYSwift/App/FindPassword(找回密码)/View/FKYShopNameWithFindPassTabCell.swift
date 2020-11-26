//
//  FKYShopNameWithFindPassTabCell.swift
//  FKY
//
//  Created by hui on 2019/8/16.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopNameWithFindPassTabCell: UITableViewCell {
    //店铺名称
    fileprivate lazy var shopName: UILabel = {
        let label = UILabel()
        label.fontTuple = t8
        label.textAlignment = .left
        return label
    }()
    // 下划线
    fileprivate lazy var viewLine : UIView = {
        let iv = UIView()
        iv.backgroundColor = RGBColor(0xDBDBDB)
        return iv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    func setupView() {
        self.backgroundColor = RGBColor(0xF8F8F8)
        // 选择商品btn
        contentView.addSubview(shopName)
        shopName.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView.snp.right).offset(-WH(30))
            make.left.equalTo(contentView.snp.left).offset(WH(30))
        })
        contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentView)
            make.right.equalTo(contentView.snp.right).offset(-WH(30))
            make.left.equalTo(contentView.snp.left).offset(WH(30))
            make.height.equalTo(WH(1))
        })
    }
    func configData(_ shopStr:String?){
       shopName.text = shopStr
    }
}
