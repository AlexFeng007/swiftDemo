//
//  PDNoMoreCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/6/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商详之没有更多cell

import UIKit

class PDNoMoreCell: UITableViewCell {
    //MARK: - Property
    
    fileprivate lazy var lblTitle: UILabel! = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textAlignment = .center
        label.text = "没有更多啦!"
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
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            //make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(WH(2), WH(10), WH(2), WH(10)))
            make.center.equalTo(contentView)
        }
        
        // 左
        let viewLineLeft = UIView.init()
        viewLineLeft.backgroundColor = RGBColor(0x999999)
        contentView.addSubview(viewLineLeft)
        viewLineLeft.snp.makeConstraints { (make) in
            make.right.equalTo(lblTitle.snp.left).offset(-WH(4))
            make.centerY.equalTo(contentView)
            make.height.equalTo(WH(1))
            make.width.equalTo(WH(16))
        }
        
        // 右
        let viewLineRight = UIView.init()
        viewLineRight.backgroundColor = RGBColor(0x999999)
        contentView.addSubview(viewLineRight)
        viewLineRight.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(4))
            make.centerY.equalTo(contentView)
            make.height.equalTo(WH(1))
            make.width.equalTo(WH(16))
        }
    }
    
    // MARK: - Public
    
    func configCell(_ model: FKYProductObject?) {
        guard model != nil else {
            // 隐藏
            contentView.isHidden = true
            return
        }
        
        // 显示
        contentView.isHidden = false
    }
}
