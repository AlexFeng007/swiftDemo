//
//  FKYTogeterPrdIntrolCell.swift
//  FKY
//
//  Created by hui on 2018/10/24.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYTogeterPrdIntrolCell: UITableViewCell {
    fileprivate lazy var speLabel: UILabel = {
        let label = UILabel()
        label.text = "规格:"
        label.font = t31.font
        label.textColor = RGBColor(0x999999)
        return label
    }()
    fileprivate lazy var speStrLabel: UILabel = {
        let label = UILabel()
        label.font = t31.font
        label.textColor = RGBColor(0x333333)
        return label
    }()
    
    fileprivate lazy var shopNameLabel: UILabel = {
        let label = UILabel()
        label.text = "商品名:"
        label.font = t31.font
        label.textColor = RGBColor(0x999999)
        return label
    }()
    fileprivate lazy var shopNameStrLabel: UILabel = {
        let label = UILabel()
        label.font = t31.font
        label.textColor = RGBColor(0x333333)
        return label
    }()
    fileprivate lazy var factoryLabel: UILabel = {
        let label = UILabel()
        label.text = "生产企业:"
        label.font = t31.font
        label.textColor = RGBColor(0x999999)
        return label
    }()
    fileprivate lazy var factoryStrLabel: UILabel = {
        let label = UILabel()
        label.font = t31.font
        label.textColor = RGBColor(0x333333)
        return label
    }()
    fileprivate lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.text = "最小包装单位:"
        label.font = t31.font
        label.textColor = RGBColor(0x999999)
        return label
    }()
    fileprivate lazy var unitStrLabel: UILabel = {
        let label = UILabel()
        label.font = t31.font
        label.textColor = RGBColor(0x333333)
        return label
    }()
    fileprivate lazy var middleLabel: UILabel = {
        let label = UILabel()
        label.text = "大包装:"
        label.font = t31.font
        label.textColor = RGBColor(0x999999)
        return label
    }()
    fileprivate lazy var middleStrLabel: UILabel = {
        let label = UILabel()
        label.font = t31.font
        label.textColor = RGBColor(0x333333)
        return label
    }()
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "有效期至:"
        label.font = t31.font
        label.textColor = RGBColor(0x999999)
        return label
    }()
    fileprivate lazy var dateStrLabel: UILabel = {
        let label = UILabel()
        label.font = t31.font
        label.textColor = RGBColor(0x333333)
        return label
    }()
    fileprivate lazy var batchLabel: UILabel = {
        let label = UILabel()
        label.text = "批准文号:"
        label.font = t31.font
        label.textColor = RGBColor(0x999999)
        return label
    }()
    fileprivate lazy var batchStrLabel: UILabel = {
        let label = UILabel()
        label.font = t31.font
        label.textColor = RGBColor(0x333333)
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
        self.backgroundColor = RGBColor(0xFAFAFA)
        contentView.addSubview(self.speLabel)
        self.speLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(11))
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.height.equalTo(WH(12))
            make.width.equalTo(WH(86))
        }
        contentView.addSubview(self.speStrLabel)
        self.speStrLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.speLabel.snp.centerY)
            make.left.equalTo(self.speLabel.snp.right).offset(WH(5))
            make.right.equalTo(contentView.snp.right).offset(-WH(5))
        }
        
        contentView.addSubview(self.shopNameLabel)
        self.shopNameLabel.snp.makeConstraints { (make) in
        make.top.equalTo(self.speLabel.snp.bottom).offset(WH(6))
            make.left.equalTo(self.speLabel.snp.left)
            make.height.equalTo(WH(12))
            make.width.equalTo(WH(86))
        }
        contentView.addSubview(self.shopNameStrLabel)
        self.shopNameStrLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.shopNameLabel.snp.centerY)
            make.left.equalTo(self.speStrLabel.snp.left)
            make.right.equalTo(contentView.snp.right).offset(-WH(5))
        }
        
        contentView.addSubview(self.factoryLabel)
        self.factoryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.shopNameLabel.snp.bottom).offset(WH(6))
            make.left.equalTo(self.speLabel.snp.left)
            make.height.equalTo(WH(12))
            make.width.equalTo(WH(86))
        }
        contentView.addSubview(self.factoryStrLabel)
        self.factoryStrLabel.snp.makeConstraints { (make) in
        make.centerY.equalTo(self.factoryLabel.snp.centerY)
             make.left.equalTo(self.speStrLabel.snp.left)
            make.right.equalTo(contentView.snp.right).offset(-WH(5))
        }
        
        contentView.addSubview(self.unitLabel)
        self.unitLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.factoryLabel.snp.bottom).offset(WH(6))
            make.left.equalTo(self.speLabel.snp.left)
            make.height.equalTo(WH(12))
            make.width.equalTo(WH(86))
        }
        contentView.addSubview(self.unitStrLabel)
        self.unitStrLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.unitLabel.snp.centerY)
             make.left.equalTo(self.speStrLabel.snp.left)
            make.right.equalTo(contentView.snp.right).offset(-WH(5))
        }
        
        contentView.addSubview(self.middleLabel)
        self.middleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.unitLabel.snp.bottom).offset(WH(6))
            make.left.equalTo(self.speLabel.snp.left)
            make.height.equalTo(WH(12))
            make.width.equalTo(WH(86))
        }
        contentView.addSubview(self.middleStrLabel)
        self.middleStrLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.middleLabel.snp.centerY)
            make.left.equalTo(self.speStrLabel.snp.left)
            make.right.equalTo(contentView.snp.right).offset(-WH(5))
        }
        
        contentView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.middleLabel.snp.bottom).offset(WH(6))
            make.left.equalTo(self.speLabel.snp.left)
            make.height.equalTo(WH(12))
            make.width.equalTo(WH(86))
        }
        contentView.addSubview(self.dateStrLabel)
        self.dateStrLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.dateLabel.snp.centerY)
             make.left.equalTo(self.speStrLabel.snp.left)
            make.right.equalTo(contentView.snp.right).offset(-WH(5))
        }
        
        contentView.addSubview(self.batchLabel)
        self.batchLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(WH(6))
            make.left.equalTo(self.speLabel.snp.left)
            make.height.equalTo(WH(12))
            make.width.equalTo(WH(86))
        }
        contentView.addSubview(self.batchStrLabel)
        self.batchStrLabel.snp.makeConstraints { (make) in
        make.centerY.equalTo(self.batchLabel.snp.centerY)
            make.left.equalTo(self.speStrLabel.snp.left)
            make.right.equalTo(contentView.snp.right).offset(-WH(5))
        }
        
        // 底部分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = bg7
        contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints({ (make) in
            make.bottom.right.left.equalTo(contentView)
            make.height.equalTo(0.5)
        })
    }
    
}
extension FKYTogeterPrdIntrolCell {
    func configCell(_ detailModel : FKYTogeterBuyDetailModel?) {
        if let model = detailModel {
            self.speStrLabel.text = model.spec
            //后台要求拼接
            self.shopNameStrLabel.text = model.productName
            self.factoryStrLabel.text = model.factoryName
            self.unitStrLabel.text = model.unit
            self.middleStrLabel.text = model.bigPacking
            self.dateStrLabel.text = model.deadLine
            if let approvalStr = model.approvalNum ,approvalStr.count > 0 {
                self.batchStrLabel.text = approvalStr
                self.batchStrLabel.isHidden = false
                self.batchLabel.isHidden = false
            }else{
                self.batchStrLabel.isHidden = true
                self.batchLabel.isHidden = true
            }
            
        }
    }
}
