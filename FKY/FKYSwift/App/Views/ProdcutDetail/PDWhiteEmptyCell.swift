//
//  PDWhiteEmptyCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/9/20.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详之白底空行cell

import UIKit

class PDWhiteEmptyCell: UITableViewCell {

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
        backgroundColor = UIColor.white
        backgroundView?.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Public
    
    @objc func configCell(_ model: FKYProductObject?) {
        guard model != nil else {
            // 隐藏
            backgroundColor = RGBColor(0xF4F4F4)
            backgroundView?.backgroundColor = RGBColor(0xF4F4F4)
            return
        }
        
        // 显示
        backgroundColor = UIColor.white
        backgroundView?.backgroundColor = UIColor.white
    }
}
