//
//  FKYRebateRecordInfoCell.swift
//  FKY
//
//  Created by My on 2019/8/26.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYRebateRecordInfoCell: UITableViewCell, FKYRegisterCellProtocol {
    var configLabelClosure: (UIColor, UIFont, String) -> UILabel = {
        (textColor, font, text) in
        let label = UILabel()
        label.textColor = textColor
        label.font = font
        label.text = text
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    lazy var timeLabel = self.configLabelClosure(RGBColor(0x333333), UIFont.boldSystemFont(ofSize: WH(14)), "")
    lazy var orderIdLabel = self.configLabelClosure(RGBColor(0x666666), t3.font, "")
    lazy var venderLabel = self.configLabelClosure(RGBColor(0x666666), t3.font, "")
    /// 类型 直接取字段
    lazy var typeLabel = self.configLabelClosure(RGBColor(0x666666), t3.font, "类型")
    lazy var amountLabel = self.configLabelClosure(RGBColor(0x333333), UIFont.boldSystemFont(ofSize: WH(18)), "")
    lazy var arrowImg: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "rebaterecord_arrow")
        return icon
    }()
    
    
    lazy var rependingTagLabel = self.configLabelClosure(RGBColor(0xFF2D5C), t3.font, "")
    lazy var protocolTagLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = t28.font
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 2
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.layer.borderWidth = 1
        label.isHidden = true
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = bg1
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


extension FKYRebateRecordInfoCell {
    func setupViews() {
        amountLabel.textAlignment = .right
        contentView.addSubview(rependingTagLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(orderIdLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(venderLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(arrowImg)
        contentView.addSubview(protocolTagLabel)
        let line = UIView()
        line.backgroundColor = RGBColor(0xE5E5E5)
        contentView.addSubview(line)
        
//        rependingTagLabel.backgroundColor = .red
//        timeLabel.backgroundColor = .yellow
//        orderIdLabel.backgroundColor = .blue
//        venderLabel.backgroundColor = .green
//        amountLabel.backgroundColor = .gray
//        arrowImg.backgroundColor = .black
//        protocolTagLabel.backgroundColor = .red
        
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.bottom.equalTo(venderLabel.snp.top).offset(WH(-6))
        }
        
        venderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.right.equalTo(contentView.snp.right).offset(WH(-15))
            make.bottom.equalTo(contentView.snp.bottom).offset(WH(-15))
        }
        
        orderIdLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.bottom.equalTo(typeLabel.snp.top).offset(WH(-6))
        }
        typeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.right.equalTo(contentView.snp.right).offset(WH(-15))
        }
        
        rependingTagLabel.snp.makeConstraints { (make) in
            make.right.equalTo(amountLabel)
            make.top.equalTo(amountLabel.snp.bottom).offset(2)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.right.equalTo(contentView.snp.right).offset(WH(-15))
            make.bottom.equalTo(orderIdLabel.snp.top).offset(WH(-6))
        }
        
        arrowImg.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(WH(-15))
            make.size.equalTo(CGSize(width: WH(12), height: WH(12)))
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        amountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImg.snp.left).offset(WH(-7))
            make.centerY.equalTo(arrowImg)
        }
        
        protocolTagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.bottom.equalTo(contentView.snp.bottom).offset(WH(-15))
            make.size.equalTo(CGSize(width: WH(56), height: WH(16)))
        }
        
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    
    func bindRebateRecordModel(_ model: RebateRecordModel?) -> Void {
        guard model != nil else {
            return
        }
        
        self.typeLabel.text = "类型：" + (model?.statusStr ?? "")
        
        if let pendingDesc = model!.pendingDesc, pendingDesc.isEmpty == false {
            rependingTagLabel.isHidden = false
            rependingTagLabel.text = pendingDesc
            amountLabel.snp.updateConstraints { (make) in
                make.centerY.equalTo(arrowImg).offset(WH(-10))
            }
        }else {
            rependingTagLabel.isHidden = true
            amountLabel.snp.updateConstraints { (make) in
                make.centerY.equalTo(arrowImg)
            }
        }
        
        timeLabel.text = model!.rebateTime
        
        if let type = model!.rebateType, type == 1 {
            orderIdLabel.text = "协议: " + (model!.protocolName ?? "")
            protocolTagLabel.isHidden = false
//            if let desc = model!.protocolDesc, desc.isEmpty == false {
//                protocolTagLabel.text = desc
//            }else {
                protocolTagLabel.text = "协议奖励金"
//            }
            
            venderLabel.snp.updateConstraints { (make) in
                make.bottom.equalTo(contentView.snp.bottom).offset(WH(-37))
            }
        }else {
            orderIdLabel.text = "订单号: " + (model!.orderId ?? "")
            protocolTagLabel.isHidden = true
            venderLabel.snp.updateConstraints { (make) in
                make.bottom.equalTo(contentView.snp.bottom).offset(WH(-15))
            }
        }
        
        venderLabel.text = model!.enterpriseName
        if let amount = model!.rebateMoney {
            amountLabel.textColor = RGBColor(0x333333)
            if (amount > 0) {
                amountLabel.text  = String(format: "+%.2f", amount)
//                amountLabel.textColor = RGBColor(0xFF2D5D)
            } else {
                amountLabel.text  = String(format: "%.2f", amount)
//                amountLabel.textColor = RGBColor(0x333333)
            }
        }
    }
}

