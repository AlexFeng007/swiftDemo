//
//  LiveRedPacketResultView.swift
//  FKY
//
//  Created by yyc on 2020/8/28.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveRedPacketResultView: UIView {
    
    //红包背景
    fileprivate lazy var rpBgView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "live_rp_bg")
        view.isUserInteractionEnabled = true
        return view
    }()
    //消失按钮
    fileprivate lazy var dismissBtn : UIButton = {
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "live_room_close"), for: [.normal])
        //backBtn.alpha = 0.2
        backBtn.backgroundColor = .clear
        _ = backBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismiss()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        backBtn.isHidden = false
        return backBtn
    }()
    //红包活动名
    fileprivate lazy var acctivityNameLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0xffffff)
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.textAlignment = .center
        return label
    }()
    
    //红包说明
    fileprivate lazy var acctivityDescLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBAColor(0xffffff,alpha: 1)
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    //优惠券背景图片
    fileprivate lazy var rpImageView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "live_rp_item_pic")
        return view
    }()
    //优惠券领取图片
    fileprivate lazy var rpGetImageView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "live_rp_item_get_pic")
        return view
    }()
    
    //优惠券标签
    fileprivate lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBAColor(0xD31A13,alpha: 1)
        label.font = t28.font
        label.textAlignment = .center
        label.layer.borderWidth = 0.5
        label.layer.borderColor = RGBColor(0xD31A13).cgColor
        label.layer.cornerRadius = WH(2)
        return label
    }()
    
    //描述
    fileprivate lazy var desLabel: UILabel = {
        let label = UILabel()
        label.textColor = t26.color
        label.font = t27.font
        return label
    }()
    
    //日期
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    //金额
    fileprivate lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xD31A13)
        label.font = UIFont.boldSystemFont(ofSize: WH(28))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textAlignment = .center
        return label
    }()
    
    /// 查看可用商品
    fileprivate lazy var seeProductLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t34
        label.textAlignment = .center
        label.text = "查看可用商品>"
        //label.attributedText = str.fky_getAttributedStringWithUnderLine()
        label.isUserInteractionEnabled = true
        label.bk_(whenTouches: 1, tapped: 1, handler: { [weak self] in
            if let strongSelf = self ,let block = strongSelf.clickTypeActionBlock {
                block(1)
            }
        })
        return label
    }()
    
    @objc var clickTypeActionBlock: ((Int)->())? //点击复制
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = RGBAColor(0x000000, alpha: 0.32)
        self.addSubview(rpBgView)
        rpBgView.addSubview(dismissBtn)
        rpBgView.addSubview(acctivityNameLabel)
        rpBgView.addSubview(acctivityDescLabel)
        rpBgView.addSubview(rpImageView)
        rpBgView.addSubview(seeProductLabel)
        
        rpBgView.snp.makeConstraints({ (make) in
            make.width.equalTo(WH(300))
            make.height.equalTo(WH(227))
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(WH(-25))
        })
        
        dismissBtn.snp.makeConstraints({ (make) in
            make.top.equalTo(rpBgView).offset(WH(3))
            make.right.equalTo(rpBgView).offset(WH(-8))
            make.height.width.equalTo(WH(30))
        })
        
        acctivityNameLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(rpBgView).offset(WH(10))
            make.centerX.equalTo(rpBgView)
            make.top.equalTo(rpBgView).offset(WH(27))
            make.height.equalTo(WH(25))
        })
        
        acctivityDescLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(rpBgView).offset(WH(10))
            make.centerX.equalTo(rpBgView)
            make.top.equalTo(acctivityNameLabel.snp.bottom).offset(WH(8))
            make.height.equalTo(WH(20))
        })
        
        rpImageView.snp.makeConstraints({ (make) in
            make.width.equalTo(WH(210))
            make.height.equalTo(WH(80))
            make.centerX.equalTo(rpBgView)
            make.top.equalTo(acctivityDescLabel.snp.bottom).offset(WH(22))
        })
        
        rpImageView.addSubview(rpGetImageView)
        rpImageView.addSubview(tagLabel)
        rpImageView.addSubview(desLabel)
        rpImageView.addSubview(timeLabel)
        rpImageView.addSubview(moneyLabel)
        
        rpGetImageView.snp.makeConstraints({ (make) in
            make.width.equalTo(WH(51))
            make.height.equalTo(WH(51))
            make.top.equalTo(rpImageView.snp.top).offset(-WH(13))
            make.left.equalTo(rpImageView.snp.left).offset(WH(88))
        })
        
        tagLabel.snp.makeConstraints({ (make) in
            make.width.equalTo(WH(35))
            make.height.equalTo(WH(15))
            make.top.equalTo(rpImageView).offset(WH(11))
            make.left.equalTo(rpImageView.snp.left).offset(WH(21))
        })
        
        desLabel.snp.makeConstraints({ (make) in
            make.width.lessThanOrEqualTo(WH(95))
            make.height.equalTo(WH(18))
            make.top.equalTo(tagLabel.snp.bottom).offset(WH(5))
            make.left.equalTo(tagLabel.snp.left)
        })
        
        moneyLabel.snp.makeConstraints({ (make) in
            make.width.equalTo(WH(76))
            make.height.equalTo(WH(28))
            make.top.equalTo(rpImageView).offset(WH(26))
            make.right.equalTo(rpImageView.snp.right).offset(-WH(15))
        })
        
        timeLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(rpImageView.snp.right).offset(-WH(20))
            make.height.equalTo(WH(12))
            make.top.equalTo(desLabel.snp.bottom).offset(WH(3))
            make.left.equalTo(tagLabel.snp.left)
        })
        
        seeProductLabel.snp.makeConstraints({ (make) in
            make.centerX.equalTo(rpBgView)
            make.height.equalTo(WH(34))
            make.top.equalTo(rpImageView.snp.bottom).offset(WH(5))
        })
    }
    //展示
    @objc func show() {
        self.isHidden = false
        self.alpha = 0
        rpBgView.alpha = 0
        rpBgView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            if let strongSelf = self {
                strongSelf.alpha = 1
                strongSelf.rpBgView.alpha = 1
            }
        }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: .layoutSubviews, animations: { [weak self] in
            if let strongSelf = self {
                strongSelf.rpBgView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }) { (ret) in
        }
    }
    
    //消失
    @objc func dismiss() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            if let strongSelf = self {
                strongSelf.alpha = 0
                strongSelf.rpBgView.alpha = 0
                strongSelf.rpBgView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        }) { [weak self] (ret) in
            if let strongSelf = self {
                if ret {
                    strongSelf.isHidden = false
                    //strongSelf.removeFromSuperview()
                }
            }
        }
    }
}
extension LiveRedPacketResultView {
    func configRpResultView(_ packetModel:CommonCouponNewModel){
        acctivityNameLabel.text = "红包活动"
        acctivityDescLabel.text = "恭喜您获得了一张\(packetModel.denomination ?? 0)元优惠券"
        
        if packetModel.tempType == 1 {
            tagLabel.text = "平台券"
            seeProductLabel.isHidden = true
        }else {
            seeProductLabel.isHidden = false
            if packetModel.isLimitProduct == 0 {
                tagLabel.text = "店铺券"
            }else {
                tagLabel.text = "店铺商品券"
            }
        }
        let _ = tagLabel.adjustTagLabelContentInset(WH(4)) //动态调整宽度
        desLabel.text = "满" + "\(packetModel.limitprice ?? 0)可用"
        
        if let beginStr = packetModel.begindate,beginStr.count > 0, let endStr = packetModel.endDate,endStr.count > 0 {
            timeLabel.text = beginStr + "-" + endStr.dateChangeToFormat("MM.dd")
        }else {
            if let showTime = packetModel.couponTimeText,showTime.count > 0 {
                 timeLabel.text = showTime
            }
        }
        moneyLabel.text = "¥\(packetModel.denomination ?? 0)"
        moneyLabel.adjustPriceLabelWihtFont(UIFont.boldSystemFont(ofSize: WH(14)))
    }
}
