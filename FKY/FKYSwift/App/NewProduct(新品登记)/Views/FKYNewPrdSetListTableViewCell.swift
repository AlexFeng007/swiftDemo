//
//  FKYNewPrdSetListTableViewCell.swift
//  FKY
//
//  Created by yyc on 2020/3/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYNewPrdSetListTableViewCell: UITableViewCell {
    
    //ui
    //
    fileprivate lazy var cellBgView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        view.layer.cornerRadius = WH(8)
        view.layer.masksToBounds = true
        return view
    }()
    //信息状态视图
    fileprivate lazy var infoView : FKYNewPrdSetInfoVIew = {
        let view = FKYNewPrdSetInfoVIew()
        return view
    }()
    //底部视图******************************************
    fileprivate lazy var bottomBgView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    //建议
    fileprivate lazy var suggestLabel : UILabel = {
        let label = UILabel()
        label.fontTuple = t8
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
extension FKYNewPrdSetListTableViewCell {
    fileprivate func setupView() {
        self.backgroundColor = RGBColor(0xF4F4F4)
        contentView.addSubview(cellBgView)
        cellBgView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(contentView.snp.right).offset(-WH(10))
            make.left.equalTo(contentView.snp.left).offset(WH(10))
        }
        cellBgView.addSubview(infoView)
        infoView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(cellBgView)
            make.height.greaterThanOrEqualTo(WH(44+100))
        }
        cellBgView.addSubview(bottomBgView)
        bottomBgView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(cellBgView)
            make.top.equalTo(infoView.snp.bottom)
        }
        bottomBgView.addSubview(suggestLabel)
        suggestLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bottomBgView.snp.left).offset(WH(15))
            make.right.equalTo(bottomBgView.snp.right).offset(-WH(16))
            make.top.equalTo(bottomBgView.snp.top).offset(WH(6))
            make.bottom.equalTo(bottomBgView.snp.bottom).offset(-WH(12))
        }
        
    }
}
extension FKYNewPrdSetListTableViewCell {
    func configNewPrdSetListTableViewCellData(_ model:FKYNewPrdSetItemModel?) {
        if let desModel = model {
            infoView.configNewPrdSetInfoViewData(model,1)
            if let str = desModel.approvalResult,str.count > 0 {
                suggestLabel.snp.updateConstraints { (make) in
                    make.top.equalTo(bottomBgView.snp.top).offset(WH(6))
                    make.bottom.equalTo(bottomBgView.snp.bottom).offset(-WH(12))
                }
                bottomBgView.isHidden = false
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
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: t44.color, range: titleRange)
                attribute.yy_lineSpacing = WH(5)
                suggestLabel.attributedText = attribute
                infoView.resetBottomLineView(false)
            }else {
                suggestLabel.snp.updateConstraints { (make) in
                    make.top.equalTo(bottomBgView.snp.top).offset(WH(0))
                    make.bottom.equalTo(bottomBgView.snp.bottom).offset(-WH(0))
                }
                suggestLabel.text = ""
                bottomBgView.isHidden = true
                infoView.resetBottomLineView(true)
            }
        }
    }
}
