//
//  FKYNotCouponTableViewCell.swift
//  FKY
//
//  Created by hui on 2019/1/16.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYNotCouponTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // 无优惠券图片
    fileprivate lazy var img: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    // 优惠券描述
    fileprivate lazy var desLabel: UILabel = {
        let label = UILabel()
        label.font = t23.font
        label.textColor = RGBColor(0x414142)
        label.textAlignment = .center
        return label
    }()
    // 跳转button
    fileprivate lazy var gotoBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = t3.font
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {  (_) in
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "未领到红包", itemId: "I6204", itemPosition: "1", itemName: "去【特价专区】逛逛", itemContent: nil, itemTitle: nil, extendParams: nil, viewController:CurrentViewController.shared.item)
            visitSchema(self.urlStr ?? "")
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    var urlStr:String?//跳转链接
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupView() {
        contentView.addSubview(self.img)
        self.img.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(25))
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(WH(95))
            make.height.equalTo(WH(96))
        }
        contentView.addSubview(self.desLabel)
        self.desLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.img.snp.bottom).offset(WH(11))
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(WH(20))
            make.width.equalTo(SCREEN_WIDTH-WH(30))
        }
        contentView.addSubview(self.gotoBtn)
        self.gotoBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.desLabel.snp.bottom).offset(WH(12))
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(WH(24))
            make.width.equalTo(WH(0))
        }
        // 底部分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = bg7
        contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints({ (make) in
            make.bottom.right.left.equalTo(contentView)
            make.height.equalTo(0.5)
        })
    }
    
    //数据更新
    func configCell(_ model : RedPacketDetailInfoModel) {
        img.image = UIImage.init(named: "noCouponBigPic")
        urlStr = model.losingJumpUrl
        self.desLabel.text = model.losingDesc
        self.gotoBtn.setTitle(model.losingBtnDesc, for: .normal)
        let strW = (model.losingBtnDesc ?? "").boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:t3.font], context: nil).size.width
        self.gotoBtn.snp.updateConstraints { (make) in
            make.width.equalTo(strW+WH(26))
        }
        self.gotoBtn.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFF5A9B), to: RGBColor(0xFF2D5C), withWidth: Float(strW+WH(26)))
    }
}

