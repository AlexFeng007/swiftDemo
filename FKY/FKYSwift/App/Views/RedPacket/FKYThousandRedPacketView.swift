//
//  FKYThousandRedPacketView.swift
//  FKY
//
//  Created by yyc on 2019/12/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYThousandRedPacketView: UIView {
    @objc var redPacketInfo: FKYThousandCouponDetailModel?
    fileprivate var timer: Timer!
    fileprivate var totalCountNum : Int = 3
    
    //大背景
    fileprivate lazy var backGroundView: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0x000000)
        return view
    }()
    //千人千面红包背景图
    fileprivate lazy var bgImageView: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "thousand_red_pic"))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    //图片
    fileprivate lazy var successImageView: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "thousand_red_success_pic"))
        return imageView
    }()
    //标题
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(17))
        label.textColor = RGBColor(0x000000)
        label.textAlignment = .center
        label.text = "恭喜您，获得一张优惠券"
        return label
    }()
    
    //面板背景图
    fileprivate lazy var redImageView: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "thousand_red_money_pic"))
        return imageView
    }()
    
    //金额
    fileprivate lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(21.6))
        label.textColor = RGBColor(0xFFFFFF)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    //时间
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        label.textColor = RGBColor(0xFFFFFF)
        label.textAlignment = .right
        return label
    }()
    
    //关闭按钮
    fileprivate lazy var closeButton: UIButton! = {
        let button = UIButton()
        button.layer.cornerRadius = WH(4)
        button.isUserInteractionEnabled = false
        button.backgroundColor = RGBColor(0xF4F4F4)
        button.setTitleColor(RGBColor(0xCCCCCC), for: [.normal])
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismiss()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    @objc convenience init(_ model: FKYThousandCouponDetailModel) {
        self.init(frame: CGRect.zero)
        self.redPacketInfo = model
        setupView()
        setupData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Action
    // 开始倒计时
    fileprivate func beginCount() {
        // 取消timer
        stopAutoCount()
        // 启动timer
        let date = NSDate.init(timeIntervalSinceNow: 0)
        timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(autoCountAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        // 判断是否显示倒计时按钮
        self.closeButton.setTitle("知道了（\(self.totalCountNum)s）", for: .normal)
    }
    // 停止轮播
    fileprivate func stopAutoCount() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    // 倒计时操作
    @objc fileprivate func autoCountAction() {
        if self.totalCountNum == 0 {
            self.stopAutoCount()
            self.closeButton.isUserInteractionEnabled = true
            self.closeButton.backgroundColor = t73.color
            self.closeButton.setTitleColor(RGBColor(0xffffff), for: [.normal])
            self.closeButton.setTitle("知道了", for: .normal)
        }else {
            self.closeButton.setTitle("知道了（\(self.totalCountNum)s）", for: .normal)
        }
        self.totalCountNum = self.totalCountNum - 1
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
                strongSelf.beginCount()
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
                    strongSelf.stopAutoCount()
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
            make.centerY.equalTo(self.snp.centerY).offset(WH(23))
            make.width.equalTo(WH(260))
            make.height.equalTo(WH(301))
            
        }
        bgImageView.addSubview(successImageView)
        successImageView.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.top).offset(WH(16))
            make.centerX.equalTo(bgImageView.snp.centerX)
            make.width.equalTo(WH(34))
            make.height.equalTo(WH(34))
        }
        bgImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(successImageView.snp.bottom).offset(WH(16))
            make.height.equalTo(WH(16))
            make.left.equalTo(bgImageView.snp.left).offset(WH(5))
            make.right.equalTo(bgImageView.snp.right).offset(-WH(5))
        }
        bgImageView.addSubview(redImageView)
        redImageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(20))
            make.centerX.equalTo(bgImageView.snp.centerX)
            make.width.equalTo(WH(220))
            make.height.equalTo(WH(87))
        }
        redImageView.addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(redImageView.snp.top).offset(WH(21))
            make.left.equalTo(redImageView.snp.left).offset(WH(5))
            make.right.equalTo(redImageView.snp.right).offset(-WH(5))
        }
        redImageView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(redImageView.snp.bottom).offset(-WH(2))
            make.right.equalTo(redImageView.snp.right).offset(-WH(7))
            make.left.equalTo(redImageView.snp.left).offset(WH(5))
            make.height.equalTo(WH(16))
        }
        
        bgImageView.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgImageView.snp.bottom).offset(-WH(20))
            make.centerX.equalTo(bgImageView.snp.centerX)
            make.width.equalTo(WH(220))
            make.height.equalTo(WH(42))
        }
        
    }
    
    func setupData() {
        if let model = self.redPacketInfo {
            if let limitNum = model.limitprice ,let denoNum = model.denomination {
                self.moneyLabel.text = "满\(limitNum)减\(denoNum)"
            }
            self.dateLabel.text = "有效期\(model.beginDateStr ?? "")-\(model.endDateStr ?? "")"
            self.closeButton.setTitle("知道了（\(self.totalCountNum)s）", for: .normal)
        }
    }
    
}
