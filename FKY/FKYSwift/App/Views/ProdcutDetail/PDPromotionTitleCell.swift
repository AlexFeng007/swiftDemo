//
//  PDPromotionTitleCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/9/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详之促销标题cell

import UIKit

class PDPromotionTitleCell: UITableViewCell {
    //MARK: - Property
    
    fileprivate lazy var lblTitle: UILabel! = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = RGBColor(0x000000)
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        label.textAlignment = .left
        label.text = "促销"
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
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xFFFFFF)
        contentView.backgroundColor = RGBColor(0xFFFFFF)
        
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(10))
            make.centerY.equalTo(contentView).offset(WH(5))
        }
    }
    
    
    //MARK: - Public
    
    @objc func configCell(_ title: String?) {
        guard let title = title, title.isEmpty == false else {
            lblTitle.text = nil
            lblTitle.isHidden = true
            return
        }
        
        lblTitle.text = title
        lblTitle.isHidden = false
    }
}
