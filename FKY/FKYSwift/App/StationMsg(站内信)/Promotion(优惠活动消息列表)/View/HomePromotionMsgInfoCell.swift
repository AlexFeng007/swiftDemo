//
//  HomePromotionMsgInfoCell.swift
//  FKY
//
//  Created by 寒山 on 2020/9/17.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class HomePromotionMsgInfoCell: UITableViewCell {
    //背景
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFEFFFF)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(8)
        return view
    }()
    
    fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF7F8F9)
        return view
    }()
    
    // 活动固定占位图片
    fileprivate lazy var promotionIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "promotion_msg_icon")
        return iv
    }()
    
    //活动名称
    fileprivate lazy var promotionNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.textColor = RGBColor(0x333333)
        return label
    }()
    //活动时间
    fileprivate lazy var promotionTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "PingFangSC-Regular", size: WH(14))
        label.textColor = RGBColor(0x666666)
        label.textAlignment = .right
        return label
    }()
    //活动内容
    fileprivate lazy var promotionContentInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "PingFangSC-Regular", size: WH(13))
        label.textColor = RGBColor(0x666666)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    func setupView() {
        self.backgroundColor = .clear
        self.contentView.addSubview(bgView)
        bgView.addSubview(promotionNameLabel)
        bgView.addSubview(promotionTimeLabel)
        bgView.addSubview(contentBgView)
        contentBgView.addSubview(promotionIconImageView)
        contentBgView.addSubview(promotionContentInfoLabel)
        
        bgView.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView).offset(WH(10))
            make.top.equalTo(self.contentView).offset(WH(10))
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.bottom.equalTo(self.contentView)
        })
        
        contentBgView.snp.makeConstraints({ (make) in
            make.left.equalTo(bgView).offset(WH(13))
            make.height.equalTo(WH(67))
            make.right.equalTo(bgView).offset(WH(-12))
            make.bottom.equalTo(bgView).offset(WH(-11))
        })
        
        promotionTimeLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(bgView).offset(WH(-12))
            make.top.equalTo(bgView).offset(WH(12))
            make.width.equalTo(0)
        })
        
        promotionNameLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(bgView).offset(WH(12))
            make.centerY.equalTo(promotionTimeLabel.snp.centerY)
            make.right.equalTo(promotionTimeLabel.snp.left)
        })
        
        promotionIconImageView.snp.makeConstraints({ (make) in
            make.left.top.equalTo(contentBgView)
            make.width.height.equalTo(WH(67))
        })
        
        promotionContentInfoLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(contentBgView).offset(WH(-8))
            make.left.equalTo(promotionIconImageView.snp.right).offset(WH(8))
            make.centerY.equalTo(contentBgView)
        })
    }
    func configCell(_ model:ExpiredTipsInfoModel){
        promotionNameLabel.text = model.title ?? ""
        let timeStr =  model.showTime ?? ""//NSDate.timeInfo(withDateMsgString: model.showTime ?? "")
        let timesize =  timeStr.boundingRect(with: CGSize(width:WH(200), height: WH(15)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.init(name: "PingFangSC-Regular", size: WH(14)) as Any], context: nil).size
        promotionTimeLabel.snp.updateConstraints({ (make) in
            make.width.equalTo(timesize.width + 1)
        })
        promotionTimeLabel.text = timeStr
        promotionContentInfoLabel.text = (model.content ?? "") + ">>"
    }
}
