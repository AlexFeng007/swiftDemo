//
//  PDFixedComboFailCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/4/3.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详(固定)套餐之套餐加车失败中单个商品cell

import UIKit

class PDFixedComboFailCell: UITableViewCell {
    // MARK: - Property
    
    fileprivate lazy var lblName: UILabel = {
        let view = UILabel()
        view.textColor = RGBColor(0x9B9B9B)
        view.font = UIFont.systemFont(ofSize: WH(13))
        view.textAlignment = .left
        return view
    }()
    
    fileprivate lazy var lblSpec: UILabel = {
        let view = UILabel()
        view.textColor = RGBColor(0x9B9B9B)
        view.font = UIFont.systemFont(ofSize: WH(13))
        view.textAlignment = .left
        return view
    }()
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        self.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(lblName)
        contentView.addSubview(lblSpec)
        
        lblName.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(20))
        }
        
        lblSpec.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(lblName.snp.right).offset(WH(5))
            make.right.lessThanOrEqualTo(contentView).offset(-WH(20))
        }
        
        // 当冲突时，lblSpec不被压缩，lblName可以被压缩
        // 当前lbl抗压缩（不想变小）约束的优先级高
        lblSpec.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        lblName.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(_ product: FKYFixedComboItemModel?) {
        lblName.text = nil
        lblSpec.text = nil
        
        if let item = product {
            lblName.text = item.productName
            lblSpec.text = item.specification
        }
    }
}
