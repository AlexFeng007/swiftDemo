//
//  PDCosmeticsCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/7/24.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商详之化妆品说明cell

import UIKit

class PDCosmeticsCell: UITableViewCell {
    //MARK: - Property
    
    fileprivate lazy var lblContent: UILabel! = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = ""
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x999999)
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.numberOfLines = 0 // 最多3行
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.9
        return lbl
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
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xFFFFFF)
        contentView.backgroundColor = RGBColor(0xFFFFFF)
        
        contentView.addSubview(lblContent)
        lblContent.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: WH(0), left: WH(10), bottom: WH(8), right: WH(10)))
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    @objc func configCell(_ model: FKYProductObject?) {
        guard let model = model else {
            // 隐藏
            lblContent.isHidden = true
            return
        }
        
        // 显示
        lblContent.isHidden = false
        lblContent.text = model.cosmeticsInfo ?? ""
    }
}
