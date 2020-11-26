//
//  PDEmptyCell.swift
//  FKY
//
//  Created by 夏志勇 on 2017/12/19.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  商详之空行cell

import UIKit

class PDEmptyCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xF4F4F4)
        contentView.backgroundColor = RGBColor(0xF4F4F4)
        
        // 上分隔线
        let viewLineTop = UIView.init()
        viewLineTop.backgroundColor = RGBColor(0xE5E5E5)
        contentView.addSubview(viewLineTop)
        viewLineTop.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        
        // 下分隔线
        let viewLineBottom = UIView.init()
        viewLineBottom.backgroundColor = RGBColor(0xE5E5E5)
        contentView.addSubview(viewLineBottom)
        viewLineBottom.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Public
    
    @objc func configCell(_ model: FKYProductObject?) {
        guard model != nil else {
            // 隐藏
            contentView.isHidden = true
            return
        }
        
        // 显示
        contentView.isHidden = false
    }
}
