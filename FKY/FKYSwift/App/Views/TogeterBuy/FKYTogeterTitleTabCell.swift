//
//  FKYTogeterTitleTabCell.swift
//  FKY
//
//  Created by hui on 2018/10/23.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYTogeterTitleTabCell: UITableViewCell {
    // 商品标签
    fileprivate lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.text = "近有效期"
        label.font = t31.font
        label.textColor = RGBColor(0xffffff)
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(9)
        return label
    }()
    
    // 商品名称
    fileprivate lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(17))
        label.textColor = RGBColor(0x000000)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    // 副标题
    fileprivate lazy var introllerTextLabel: UILabel = {
        let label = UILabel()
        label.font = t35.font
        label.textColor = RGBColor(0x333333)
        return label
    }()
    
    // 商品规格
    fileprivate lazy var productSpeLabel: UILabel = {
        let label = UILabel()
        label.font = t35.font
        label.textColor = RGBColor(0x333333)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupView() {
        contentView.addSubview(self.tagLabel)
        self.tagLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(15))
            make.left.equalTo(contentView.snp.left).offset(WH(17))
            make.height.equalTo(WH(18))
            make.width.equalTo(WH(63))
        }
        contentView.addSubview(self.productNameLabel)
        self.productNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.tagLabel.snp.centerY)
            make.left.equalTo(contentView.snp.left).offset(WH(87))
            make.height.equalTo(WH(18))
            make.right.equalTo(contentView.snp.right).offset(-WH(5))
        }
        contentView.addSubview(self.productSpeLabel)
        self.productSpeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.productNameLabel.snp.bottom).offset(WH(9))
            make.left.equalTo(contentView.snp.left).offset(WH(17))
            make.height.equalTo(WH(14))
            make.right.equalTo(contentView.snp.right).offset(-WH(5))
        }
        contentView.addSubview(self.introllerTextLabel)
        self.introllerTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.productSpeLabel.snp.bottom).offset(WH(9))
            make.left.equalTo(contentView.snp.left).offset(WH(17))
            make.right.equalTo(contentView.snp.right).offset(-WH(5))
          //  make.bottom.equalTo(contentView.snp.bottom).offset(-WH(11))
        }
    }
}
extension FKYTogeterTitleTabCell {
    func configCell(_ detailModel : FKYTogeterBuyDetailModel?){
        if let model = detailModel {
            if model.isNearEffect == 1 {
                self.tagLabel.isHidden = false
                self.productNameLabel.snp.updateConstraints { (make) in
                    make.left.equalTo(contentView.snp.left).offset(WH(87))
                }
            }else {
                self.tagLabel.isHidden = true
                self.productNameLabel.snp.updateConstraints { (make) in
                    make.left.equalTo(contentView.snp.left).offset(WH(17))
                }
            }
            self.productNameLabel.text = model.projectName
            self.introllerTextLabel.text = model.projectDesc
            self.productSpeLabel.text = model.spec
        }
    }
    //计算高度
    static func configCellHeight(_ detailModel : FKYTogeterBuyDetailModel?) -> CGFloat {
        var cellH = WH(15+18+9+14+17)
        if let contentStr = detailModel?.projectDesc , contentStr.count > 0 {
            let contentLabelH =  contentStr.boundingRect(with: CGSize(width: SCREEN_WIDTH-WH(17)-WH(5), height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t35.font], context: nil).height
            cellH =  cellH + ceil(contentLabelH) + WH(9+11-17)
        }
        
        return cellH
    }
}
