//
//  FKYMessageTableViewCell.swift
//  FKY
//
//  Created by hui on 2019/3/14.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYMessageTableViewCell: UITableViewCell {
    //图片
    fileprivate lazy var iconImageView: UIImageView! = {
        let img = UIImageView()
        return img
    }()
    //公司名称
    fileprivate lazy var titleLabel: UILabel! = {
        let lbl = UILabel()
        lbl.textColor = RGBColor(0x333333)
        lbl.font = t13.font
        lbl.textAlignment = .left
        return lbl
    }()
    //时间
    fileprivate lazy var timeLabel: UILabel! = {
        let lbl = UILabel()
        lbl.textColor = RGBColor(0x999999)
        lbl.font = t11.font
        lbl.textAlignment = .right
        return lbl
    }()
    //内容
    fileprivate lazy var contentLabel: UILabel! = {
        let lbl = UILabel()
        lbl.textColor = RGBColor(0x999999)
        lbl.font = t11.font
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    //未读消息
    fileprivate var messageBadgeView : JSBadgeView?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    func setupView() {
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints ({ (make) in
            make.left.top.equalTo(contentView).offset(WH(16))
            make.width.height.equalTo(WH(38))
        })
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints ({ (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(16))
            make.right.equalTo(contentView.snp.right).offset(-WH(16))
            make.height.equalTo(WH(20))
        })
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints ({ (make) in
            make.centerY.equalTo(timeLabel.snp.centerY)
            make.right.equalTo(timeLabel.snp.left).offset(-WH(10))
            make.left.equalTo(iconImageView.snp.right).offset(WH(12))
            make.height.equalTo(WH(20))
        })
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints ({ (make) in
        make.top.equalTo(titleLabel.snp.bottom)
        make.left.equalTo(titleLabel.snp.left)
        make.right.equalTo(contentView.snp.right).offset(-WH(16))
        make.bottom.equalTo(contentView).offset(-WH(16))
        })
        
        // 底部分隔线
        let bottomLine = UIView()
        bottomLine.backgroundColor = bg7
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints({ (make) in
            make.bottom.left.right.equalTo(contentView)
            make.height.equalTo(0.5)
        })
        messageBadgeView = {
            let cbv = JSBadgeView.init(parentView: self.iconImageView, alignment:JSBadgeViewAlignment.topRight)
            cbv?.badgePositionAdjustment = CGPoint(x: WH(-5), y: WH(2))
            cbv?.badgeTextFont = UIFont.systemFont(ofSize: WH(10))
            cbv?.badgeTextColor = RGBColor(0xFFFFFF)
            cbv?.badgeBackgroundColor = RGBColor(0xFF2D5C)
            return cbv
        }()
    }

}
extension FKYMessageTableViewCell {
    func configCell(_ model : FKYMessageModel?){
        if let messageMode = model {
            if  let urlStr = messageMode.imgUrl , let strProductPicUrl = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                iconImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "mess_icon_pic"))
            }else{
                iconImageView.image = UIImage.init(named: "mess_icon_pic")
            }
            titleLabel.text = messageMode.title
            timeLabel.text = messageMode.createTime
            contentLabel.text = messageMode.content
            if let count = messageMode.unreadCount, count > 0 {
                messageBadgeView?.isHidden = false
                messageBadgeView?.badgeText = (count>99) ? "99+" : "\(count)"
            }else {
                messageBadgeView?.isHidden = true
            }
        }
    }
    static func configCellHeight(_ model : FKYMessageModel?)-> CGFloat{
        let contentSize = (model?.content ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(82), height: WH(30)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: t11.font], context: nil)
        return contentSize.height + 1 + WH(54)
        
    }
}
