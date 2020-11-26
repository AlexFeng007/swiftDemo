//
//  PDDescriptionCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/9/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详之描述cell...<商品副标题>

import UIKit

class PDDescriptionCell: UITableViewCell {
    //MARK: - Property
    
    fileprivate lazy var lblTitle: YYLabel! = {
        let label = YYLabel()
        label.backgroundColor = UIColor.clear
        label.textAlignment = .left
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
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
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: WH(1), left: WH(10), bottom: WH(3), right: WH(10)))
        }
    }
    
    
    //MARK: - Public
    
    @objc func configCell(_ model: FKYProductObject?) {
        lblTitle.text = ""
        lblTitle.isHidden = true
        if let desModel = model {
            let oldStr = (desModel.title ?? "")+(desModel.giftLinkTxt ?? "")
            if oldStr.count > 0 {
                let mutableStr = NSMutableAttributedString.init(string: oldStr)
                mutableStr.addAttributes([NSAttributedString.Key.foregroundColor:RGBColor(0x333333),NSAttributedString.Key.font : t9.font], range: NSRange.init(location: 0, length: oldStr.count))
                mutableStr.yy_lineSpacing = WH(4)
                //有可点击的红色文字
                if let str = desModel.giftLinkTxt, str.count > 0 {
                    let gitLinkRange = (oldStr as NSString).range(of: desModel.giftLinkTxt)
                    mutableStr.addAttributes([NSAttributedString.Key.foregroundColor:t73.color,NSAttributedString.Key.font : t9.font], range: gitLinkRange)
                    if let urlStr = desModel.h5GiftLink, urlStr.count > 0 {
                        let lineValue = NSNumber.init(value: Int8(NSUnderlineStyle.single.rawValue))
                        mutableStr.addAttribute(NSAttributedString.Key.underlineStyle, value: lineValue, range: gitLinkRange)
                        mutableStr.yy_setTextHighlight(gitLinkRange, color: t73.color, backgroundColor: UIColor.clear) { (desView, mutStr, desRange, desRect) in
                            if let app = UIApplication.shared.delegate as? AppDelegate {
                                if let url = desModel.h5GiftLink, url.isEmpty == false {
                                    app.p_openPriveteSchemeString(url)
                                }
                            }
                        }
                        
                    }
                }
                lblTitle.attributedText = mutableStr
                lblTitle.isHidden = false
            }
        }
    }
}
