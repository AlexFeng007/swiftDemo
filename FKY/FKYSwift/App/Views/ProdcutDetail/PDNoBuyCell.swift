//
//  PDNoBuyCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/6/26.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商详之不可购买cell

import UIKit

class PDNoBuyCell: UITableViewCell {
    //MARK: - Property
    
    fileprivate lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(19))
        label.textAlignment = .left
        label.text = "不可购买"
        return label
    }()
    
    fileprivate lazy var lblReason: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textAlignment = .left
        return label
    }()
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(10))
            make.top.equalTo(contentView).offset(WH(12))
        }
        
        contentView.addSubview(lblReason)
        lblReason.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(10))
            make.top.equalTo(lblTitle.snp.bottom).offset(WH(5))
        }
    }
    
    // MARK: - Public
    
    @objc func configCell(_ model: FKYProductObject?) {
        guard let model = model else {
            // 隐藏
            contentView.isHidden = true
            return
        }
        
        // 显示价格则不显示不可购买原因
        guard model.priceInfo.showPrice == false else {
            // 隐藏
            contentView.isHidden = true
            return
        }
        
        // 显示
        contentView.isHidden = false
        lblTitle.text = model.priceInfo.priceText
        // 判断是老版不可购买逻辑，还是新版(缺少经营范围)不可购买逻辑
        guard let statusDesc = model.priceInfo.status, statusDesc == "2" else {
            // 老版逻辑在此处理 [statusDesc != 2]
            lblReason.isHidden = true
            return
        }
        
        /*************************/
        // 二级类目
        lblReason.isHidden = true
        if let str = model.drugSecondCategoryName, str.isEmpty == false {
            lblReason.isHidden = false
            let typeName = str
            // 富文本
            let content = "您缺少\(typeName)经营范围"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: content)
            let smallFont = UIFont.systemFont(ofSize: WH(12))
            let bigFont = UIFont.systemFont(ofSize: WH(12))
            let textColor = RGBColor(0x999999)
            let typeColor = RGBColor(0xFF2D5C)
            let range: NSRange = NSMakeRange(3, typeName.count)
            attributedString.addAttribute(NSAttributedString.Key.font, value: smallFont, range: NSMakeRange(0, content.count))
            attributedString.addAttribute(NSAttributedString.Key.font, value: bigFont, range: range)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSMakeRange(0, content.count))
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: typeColor, range: range)
            lblReason.attributedText = attributedString
        }
    }
}
