//
//  PDViewSendCouponView.swift
//  FKY
//
//  Created by 寒山 on 2020/5/12.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class PDViewSendCouponView: UIView {
    
    @objc var couponInfo: FKYThousandCouponDetailModel?
    
    //大背景
    fileprivate lazy var backGroundView: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0x000000)
        return view
    }()
    //红包背景图
    fileprivate lazy var bgImageView: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "send_coupon_bg"))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    //取消按钮
    fileprivate lazy var canceImageView: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "pd_send_coupon_cancel"))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .center
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismiss()
        }).disposed(by: disposeBag)
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    //活动名
    fileprivate var promotionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.textAlignment = .center
        label.textColor = RGBColor(0xFFFFFF)
        // label.text = "逛药城，享优惠"
        return label
    }()
    //活动描述
    fileprivate var promotionDescLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.textAlignment = .center
        label.textColor = RGBColor(0xFFFFFF)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        // label.text = "今日逛药城已达30个商品，送您一张150元优惠券，逛的越多惊喜越多"
        return label
    }()
    
    //优惠券图片
    fileprivate lazy var couponImageView: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "pd_coupon_bg"))
        return imageView
    }()
    
    //立即使用背景图
    fileprivate lazy var btnImageView: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "pd_send_coupon_btn"))
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismiss()
        }).disposed(by: disposeBag)
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    //标签（平台券or商家券）
    fileprivate var btnTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.textAlignment = .center
        label.textColor = RGBColor(0xE93429)
        label.text = "马上使用"
        return label
    }()
    
    //标签（平台券or商家券）
    fileprivate var tagLabel: UILabel = {
        let label = UILabel()
        label.font = t28.font
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(2)
        label.textAlignment = .center
        label.layer.borderWidth = WH(0.5)
        label.layer.borderColor = RGBColor(0xFD2B5C).cgColor
        label.textColor = RGBColor(0xFD2B5C)
        //label.text = "平台券"
        return label
    }()
    //使用条件描述
    fileprivate var conditionsDesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        // label.text = "满200可用"
        label.textColor = RGBColor(0x666666)
        return label
    }()
    //使用日期
    fileprivate var dateLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        // label.text = "2020.1.31-3.31"
        label.textColor = RGBColor(0x999999)
        return label
    }()
    //金额
    fileprivate var moneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(28))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        // label.text = "￥150"
        label.textColor = RGBColor(0xFD2B5C)
        return label
    }()
    
    @objc convenience init(_ model: FKYThousandCouponDetailModel) {
        self.init(frame: CGRect.zero)
        self.couponInfo = model
        setupView()
        setupData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //展示
    @objc func show() {
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController?.view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        backGroundView.alpha = 0
        bgImageView.alpha = 0
        bgImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            if let strongSelf = self {
                strongSelf.backGroundView.alpha = 0.6
                strongSelf.bgImageView.alpha = 1
                
            }
        }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: .layoutSubviews, animations: { [weak self] in
            if let strongSelf = self {
                strongSelf.bgImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }) { (ret) in
        }
    }
    
    //消失
    @objc func dismiss() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            if let strongSelf = self {
                strongSelf.backGroundView.alpha = 0
                strongSelf.bgImageView.alpha = 0
                strongSelf.bgImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        }) { [weak self] (ret) in
            if let strongSelf = self {
                if ret {
                    strongSelf.removeFromSuperview()
                }
            }
        }
    }
    
    // MARK: - UI
    
    func setupView() {
        self.addSubview(backGroundView)
        backGroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(WH(-9))
            make.width.equalTo(WH(300))
            make.height.equalTo(WH(351))
            
        }
        bgImageView.addSubview(canceImageView)
        canceImageView.snp.makeConstraints { (make) in
            make.right.equalTo(bgImageView.snp.right).offset(WH(-7))
            make.top.equalTo(bgImageView).offset(WH(2))
            make.width.height.equalTo(WH(40))
        }
        
        bgImageView.addSubview(promotionTitleLabel)
        promotionTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.top).offset(WH(28))
            make.centerX.equalTo(bgImageView.snp.centerX)
            make.height.equalTo(WH(19))
        }
        
        bgImageView.addSubview(promotionDescLabel)
        promotionDescLabel.snp.makeConstraints { (make) in
            make.top.equalTo(promotionTitleLabel.snp.bottom).offset(WH(8))
            make.centerX.equalTo(bgImageView.snp.centerX)
            make.left.equalTo(bgImageView).offset(WH(26))
        }
        
        bgImageView.addSubview(couponImageView)
        couponImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgImageView.snp.centerY).offset(WH(1))
            make.centerX.equalTo(bgImageView.snp.centerX)
            make.width.equalTo(WH(210))
            make.height.equalTo(WH(80))
        }
        
        bgImageView.addSubview(btnImageView)
        btnImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgImageView).offset(WH(-24))
            make.centerX.equalTo(bgImageView.snp.centerX)
            make.width.equalTo(WH(287))
            make.height.equalTo(WH(64))
        }
        btnImageView.addSubview(btnTitleLabel)
        btnTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(btnImageView)
            make.centerY.equalTo(btnImageView).offset(WH(-4))
        }
        
        couponImageView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { (make) in
            make.top.equalTo(couponImageView.snp.top).offset(WH(11))
            make.left.equalTo(couponImageView.snp.left).offset(WH(21))
            make.height.equalTo(WH(15))
            make.width.equalTo(WH(35))
        }
        
        couponImageView.addSubview(conditionsDesLabel)
        conditionsDesLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tagLabel.snp.bottom).offset(WH(5))
            make.height.equalTo(WH(18))
            make.left.equalTo(tagLabel.snp.left)
            make.width.lessThanOrEqualTo(WH(92))
        }
        
        couponImageView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(conditionsDesLabel.snp.bottom).offset(WH(3))
            make.left.equalTo(conditionsDesLabel.snp.left)
            make.height.equalTo(WH(12))
            // make.width.lessThanOrEqualTo(WH(92))
        }
        couponImageView.addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(couponImageView)
            make.right.equalTo(couponImageView.snp.right).offset(-WH(23))
            make.width.lessThanOrEqualTo(WH(65))
        }
        
    }
    
    func setupData() {
        if let couponsModel = self.couponInfo {
            if let limitprice = couponsModel.limitprice {
                conditionsDesLabel.text = String.init(format: "满%.0f可用",limitprice)
            }else {
                conditionsDesLabel.text = ""
            }
            dateLabel.text = ""
            if let endStr =  couponsModel.endDate,endStr.count > 0{
                let endDate = PDViewSendCouponView.stringToDate(endStr)
                let contentEndDate = PDViewSendCouponView.dateToString(endDate,dateFormat:"MM.dd")
                if let startStr = couponsModel.beginDateStr,startStr.count > 0 ,contentEndDate.count > 0 {
                    dateLabel.text = "\(startStr)-\(contentEndDate)"
                }
            }
            if let denomination = couponsModel.denomination {
                moneyLabel.text = String.init(format: "¥%.0f",denomination)
                moneyLabel.adjustPriceLabelWihtFont(t27.font)
            }else {
                moneyLabel.text = ""
            }
            promotionTitleLabel.text = couponsModel.title ?? ""
            promotionDescLabel.text = couponsModel.text ?? ""
            if let type = couponsModel.tempType ,type==1 {
                tagLabel.text = "平台券"
            }else{
                tagLabel.text = "店铺券"
            }
        }
    }
    //字符串 -> 日期
    static func stringToDate(_ string:String, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        return date ?? Date()
    }
    //日期 -> 字符串
    static func dateToString(_ date:Date, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
}
