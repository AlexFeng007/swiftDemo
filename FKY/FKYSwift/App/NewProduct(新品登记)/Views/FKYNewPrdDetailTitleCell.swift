//
//  FKYNewPrdDetailTitleCell.swift
//  FKY
//
//  Created by yyc on 2020/3/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYNewPrdDetailTitleCell: UITableViewCell {
    
    //采纳状态
    fileprivate lazy var statusLabel : UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xE8772A)
        label.font = t61.font
        return label
    }()
    //采纳意见
    fileprivate lazy var suggestLabel : UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xE8772A)
        label.font = t62.font
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
extension FKYNewPrdDetailTitleCell {
    fileprivate func setupView(){
        self.backgroundColor = RGBColor(0xFFFCF1)
        self.contentView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left).offset(WH(15))
            make.right.equalTo(self.contentView.snp.right).offset(-WH(5))
            make.top.equalTo(self.contentView.snp.top).offset(WH(8))
            make.height.equalTo(WH(18))
        }
        self.contentView.addSubview(suggestLabel)
        suggestLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left).offset(WH(15))
            make.right.equalTo(self.contentView.snp.right).offset(-WH(16))
            make.top.equalTo(statusLabel.snp.bottom).offset(WH(8))
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-WH(10))
        }
    }
}
extension FKYNewPrdDetailTitleCell {
    func configNewPrdDetailTitleData(_ model:FKYNewPrdSetItemModel?) {
        if let desModel = model {
            if let str = desModel.approvalResult,str.count > 0 {
                suggestLabel.snp.updateConstraints { (make) in
                    make.bottom.equalTo(self.contentView.snp.bottom).offset(-WH(10))
                }
                suggestLabel.isHidden = false
                var title = ""
                if desModel.businessStatus == 0 {
                    //待采纳
                     title = "采纳意见："
                }else if desModel.businessStatus == 1 {
                     title = "采纳意见："
                }else {
                    //未采纳
                     title = "未采纳原因："
                }
                let message = str
                let allContent = "\(title)\(message)"
                let titleRange = (allContent as NSString).range(of: title)
                let attribute: NSMutableAttributedString = NSMutableAttributedString.init(string: allContent)
                attribute.addAttribute(NSAttributedString.Key.font, value: t61.font, range: titleRange)
                attribute.yy_lineSpacing = WH(5)
                suggestLabel.attributedText = attribute
            }else {
                suggestLabel.snp.updateConstraints { (make) in
                    make.bottom.equalTo(self.contentView.snp.bottom).offset(-WH(0))
                }
                suggestLabel.isHidden = true
            }
            if desModel.businessStatus == 0 {
                //待采纳
                self.statusLabel.text = "采纳状态：待采纳"
            }else if desModel.businessStatus == 1 {
                //已采纳
                self.statusLabel.text = "采纳状态：已采纳"
            }else {
                //不采纳
                self.statusLabel.text = "采纳状态：未采纳"
            }
        }
    }
}
