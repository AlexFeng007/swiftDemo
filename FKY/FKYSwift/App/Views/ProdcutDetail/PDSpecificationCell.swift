//
//  PDSpecificationCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/9/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详之规格cell...<不再使用，规格已合到商品名称cell中>

import UIKit

class PDSpecificationCell: UITableViewCell {
    //MARK: - Property
    
    fileprivate lazy var lblTitle: UILabel! = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.systemFont(ofSize: WH(13))
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
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: WH(2), left: WH(10), bottom: WH(2), right: WH(10)))
        }
    }
    
    
    //MARK: - Public
    
    func configCell(_ title: String?) {
        guard let title = title else {
            lblTitle.text = nil
            lblTitle.isHidden = true
            return
        }
        
        lblTitle.text = title
        lblTitle.isHidden = false
    }
}
