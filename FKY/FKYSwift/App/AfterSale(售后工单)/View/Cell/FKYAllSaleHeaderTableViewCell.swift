//
//  FKYAllSaleHeaderTableViewCell.swift
//  FKY
//
//  Created by hui on 2019/8/2.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYAllSaleHeaderTableViewCell: UITableViewCell {
    
    //图片/
    fileprivate lazy var iconImageView: UIImageView = {
        let imgview = UIImageView(image: UIImage(named: "after_sale_shop_pic"))
        return imgview
    }()
    
    //店铺名称
    fileprivate lazy var shopLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t7
        return label
    }()
    
    //订单状态
    fileprivate lazy var orderStatusLabel: UILabel = {
        let label = UILabel()
        label.font = t7.font
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = RGBColor(0xFF3563)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        contentView.backgroundColor =  RGBColor(0xffffff)
        contentView.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.height.equalTo(WH(18))
            make.left.equalTo(contentView.snp.left).offset(WH(15))
        }
        contentView.addSubview(self.orderStatusLabel)
        self.orderStatusLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(contentView.snp.right).offset(-WH(14))
            make.width.lessThanOrEqualTo(WH(100))
        }
        
        contentView.addSubview(self.shopLabel)
        self.shopLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(self.orderStatusLabel.snp.left).offset(-WH(10))
            make.left.equalTo(self.iconImageView.snp.right).offset(WH(8))
        }
    }
}
extension FKYAllSaleHeaderTableViewCell {
    func configAllSaleHeaderCell(_ model : FKYAllAfterSaleModel){
        self.shopLabel.text = model.supplyName
        self.orderStatusLabel.text = model.easOrderstatusStr
    }
}
