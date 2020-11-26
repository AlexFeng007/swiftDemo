//
//  PDDiscountPriceItemCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/5/29.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商详折后价弹出视图之价格cell

import UIKit

class PDDiscountPriceItemCell: UITableViewCell {
    // MARK: - Property
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        //lbl.text = "商品金额"
        lbl.numberOfLines = 0 // 多行
        return lbl
    }()
    
    // 内容
    fileprivate lazy var lblContent: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x000000)
        lbl.textAlignment = .right
        //lbl.text = "¥ 2254.08"
        lbl.numberOfLines = 1
        return lbl
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
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblContent)
        
        lblContent.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(WH(-15))
            make.centerY.equalTo(contentView)
            make.width.lessThanOrEqualTo(WH(90)) // <=90
        }
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(15))
            make.right.equalTo(contentView).offset(-WH(100))
            //make.right.equalTo(lblContent.snp.left).offset(-WH(10))
            make.top.equalTo(contentView).offset(WH(6))
            make.bottom.equalTo(contentView).offset(-WH(6))
            make.height.greaterThanOrEqualTo(WH(18)) // >=18
            make.height.lessThanOrEqualTo(WH(66)) // <=66
        }
        
        // 当冲突时，lblContent不被压缩，lblTitle可以被压缩
        // 当前lbl抗压缩（不想变小）约束的优先级高
        lblContent.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗压缩（不想变小）约束的优先级低
        lblTitle.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        // 当冲突时，lblContent不被拉伸，lblTitle可以被拉伸
        // 当前lbl抗拉伸（不想变大）约束的优先级高 UILayoutPriority
        lblContent.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗拉伸（不想变大）约束的优先级低
        lblTitle.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
    }
    
    
    // MARK: - Public
    
    func configCell(_ title: String?, _ content: String?) {
        if let txt = title, txt.isEmpty == false {
            lblTitle.text = txt
        }
        else {
            lblTitle.text = nil
        }
        
        if let txt = content, txt.isEmpty == false {
            lblContent.text = txt
        }
        else {
            lblContent.text = nil
        }
    }
}
