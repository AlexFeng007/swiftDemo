//
//  RIEnterpriseNameCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/28.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  企业名称cell

import UIKit

class RIEnterpriseNameCell: UITableViewCell {
    // MARK: - Property
    
    fileprivate lazy var lblEnterpriseName: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x151515)
        lbl.font = UIFont.systemFont(ofSize: WH(16))
        lbl.numberOfLines = 0
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
    
    fileprivate func setupView() {
        backgroundColor = .white
        
        contentView.addSubview(lblEnterpriseName)
        lblEnterpriseName.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: WH(10), left: WH(15), bottom: WH(10), right: WH(12)))
            make.height.greaterThanOrEqualTo(WH(26))
        }
    }
    
    
    // MARK: - Public
    
    func configCell(_ name: String, _ keyword: String?) {
        // 无关键词
        guard let key = keyword, key.isEmpty == false else {
            let attributedString: NSMutableAttributedString = NSMutableAttributedString.init(string: name)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0x151515), range: NSMakeRange(0, name.count))
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: WH(16)), range: NSMakeRange(0, name.count))
            self.lblEnterpriseName.attributedText = attributedString
            return
        }
        
        // 完成相同
        if key == name {
            let attributedString: NSMutableAttributedString = NSMutableAttributedString.init(string: name)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0xFE403B), range: NSMakeRange(0, name.count))
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: WH(16)), range: NSMakeRange(0, name.count))
            self.lblEnterpriseName.attributedText = attributedString
            return
        }
        
        // 不完全相同
        let attributedString: NSMutableAttributedString = NSMutableAttributedString.init(string: name)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0x151515), range: NSMakeRange(0, name.count))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: WH(16)), range: NSMakeRange(0, name.count))
        for characters in key {
            let subRange: NSRange = (name as NSString).range(of: String(characters), options: .caseInsensitive)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0xFE403B), range: subRange)
        } // for
        self.lblEnterpriseName.attributedText = attributedString
    }
}
