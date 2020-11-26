//
//  PDLimitCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/9/29.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详之限购cell...<包括：特价限购说明、每日/周限购数>

import UIKit

class PDLimitCell: UITableViewCell {
    //MARK: - Property
    
    // 特价限购说明
    fileprivate lazy var lblSpecial: UILabel! = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textAlignment = .center
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 2
        lbl.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        lbl.layer.borderWidth = 0.5
        //lbl.contentInsets = UIEdgeInsetsMake(0, 3, 0, 3)
        return lbl
    }()
    
    // 每日/周限购数
    fileprivate lazy var lblLimit: UILabel! = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textAlignment = .center
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 2
        lbl.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        lbl.layer.borderWidth = 0.5
        //lbl.contentInsets = UIEdgeInsetsMake(0, 3, 0, 3)
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
    
    
    //MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xFFFFFF)
        contentView.backgroundColor = RGBColor(0xFFFFFF)
        
        contentView.addSubview(lblSpecial)
        contentView.addSubview(lblLimit)
        
        lblSpecial.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(5))
            make.left.equalTo(contentView).offset(WH(10))
            //make.right.equalTo(contentView).offset(WH(-10))
            make.height.equalTo(WH(0))
            make.width.equalTo(0)
        }
        
        lblLimit.snp.makeConstraints { (make) in
            make.top.equalTo(lblSpecial.snp.bottom).offset(WH(5))
            make.left.equalTo(contentView).offset(WH(10))
            //make.right.equalTo(contentView).offset(WH(-10))
            make.width.equalTo(0)
            make.height.equalTo(WH(0))
        }
        
//        // 当冲突时，lblLimit不被压缩，lblSpecial可以被压缩
//        // 当前lbl抗压缩（不想变小）约束的优先级高 UILayoutPriority
//        lblLimit.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
//        // 当前lbl抗压缩（不想变小）约束的优先级低
//        lblSpecial.setContentCompressionResistancePriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)
    }
    
    
    //MARK: - Public
    
    @objc func configCell(_ model: FKYProductObject?) {
        guard let model = model else {
            // 隐藏
            lblLimit.isHidden = true
            lblSpecial.isHidden = true
            return
        }
        lblSpecial.isHidden = true
        lblLimit.isHidden = true
        
        var maxW = WH(0)
        // 显示
        if let promotion = model.productPromotion, let txt = promotion.limitText, txt.isEmpty == false {
            // 特价限购
            
            lblSpecial.text = " " + txt + " "
            lblSpecial.isHidden = false
            let desW = lblSpecial.text!.boundingRect(with: CGSize.init(width:  SCREEN_WIDTH - WH(24), height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t3.font], context: nil).width
            maxW = desW + WH(4)
            
            lblSpecial.snp.updateConstraints { (make) in
                make.top.equalTo(contentView).offset(WH(5))
                make.height.equalTo(WH(18))
                make.width.equalTo(maxW)
            }
        }else{
            if let vipInfo = model.vipPromotionInfo, let vipLimitText = vipInfo.vipLimitText, vipLimitText.isEmpty == false {
                // vip会员限购
                lblSpecial.text = " " + vipLimitText + " "
                lblSpecial.isHidden = false
                let desW = lblSpecial.text!.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t3.font], context: nil).width
                maxW = desW + WH(4)
                lblSpecial.snp.updateConstraints { (make) in
                    make.top.equalTo(contentView).offset(WH(5))
                    make.height.equalTo(WH(18))
                    make.width.equalTo(maxW)
                }
            }
            else {
                //
                lblSpecial.isHidden = true
                lblSpecial.snp.updateConstraints { (make) in
                    make.top.equalTo(contentView).offset(WH(0))
                    make.height.equalTo(WH(0))
                    make.width.equalTo(WH(0))
                }
            }
        }
        
        if let info = model.productLimitInfo, let limit = info.limitInfo, limit.isEmpty == false {
            lblLimit.text = " " + limit + " "
            lblLimit.isHidden = false
            
            let desW = lblLimit.text!.boundingRect(with: CGSize.init(width: SCREEN_WIDTH - WH(24), height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t3.font], context: nil).width
            if maxW == 0{
                lblLimit.snp.remakeConstraints { (make) in
                    make.top.equalTo(lblSpecial.snp.bottom).offset(WH(5))
                    make.height.equalTo(WH(18))
                    make.left.equalTo(contentView).offset(WH(10))
                    make.width.lessThanOrEqualTo(SCREEN_WIDTH - WH(20))
                }
            }else{
                if (desW + WH(10) + maxW) > (SCREEN_WIDTH - WH(20)){
                    lblLimit.snp.remakeConstraints { (make) in
                        make.top.equalTo(lblSpecial.snp.bottom).offset(WH(5))
                        make.height.equalTo(WH(18))
                        make.left.equalTo(contentView).offset(WH(10))
                        make.width.equalTo(desW + WH(4))
                    }
                }else{
                    lblLimit.snp.remakeConstraints { (make) in
                        make.centerY.equalTo(lblSpecial.snp.centerY)
                        make.height.equalTo(WH(18))
                        make.left.equalTo(lblSpecial.snp.right).offset(WH(6))
                        make.width.equalTo(desW + WH(4))
                    }
                }
            }
            
        }
        else {
            lblLimit.isHidden = true
            lblLimit.snp.remakeConstraints { (make) in
               make.top.equalTo(lblSpecial.snp.bottom).offset(WH(0))
               make.height.equalTo(WH(0))
               make.left.equalTo(contentView).offset(WH(10))
              make.width.equalTo(0)
            }
        }
        
        layoutIfNeeded()
    }
}
