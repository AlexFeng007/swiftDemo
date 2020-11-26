//
//  COOfflinePaySuccessView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/25.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  线下支付详情之顶部提交订单成功视图

import UIKit

class COOfflinePaySuccessView: UIView {
    // MARK: - Property
    
    // 查看订单回调
    var showOrder: (()->())?
    // 继续购买回调
    var buyAgain: (()->())?
    
    // 标签
    fileprivate lazy var imgviewIcon: UIImageView = {
        let imgview = UIImageView()
        imgview.image = UIImage.init(named: "img_checkorder_offline_success")
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(17))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "提交订单成功"
        return lbl
    }()
    
    // 提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.text = "请根据下面商家银行账户进行线下打款\n商家确认后将会为您发货"
        return lbl
    }()
    
    // 查看订单btn
    fileprivate lazy var btnInfo: UIButton = {
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFFEDE7), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(RGBColor(0xFFEDE7).withAlphaComponent(0.5), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("查看订单", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        btn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        btn.setTitleColor(RGBColor(0xFF2D5C).withAlphaComponent(0.5), for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        //btn.setBackgroundImage(UIImage.init(named: "test"), for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.showOrder else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 继续购买btn
    fileprivate lazy var btnBuy: UIButton = {
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFF2D5C), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("继续购买", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.buyAgain else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        addSubview(imgviewIcon)
        addSubview(lblTitle)
        addSubview(lblTip)
        addSubview(btnInfo)
        addSubview(btnBuy)
        
        btnInfo.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(20))
            make.bottom.equalTo(self).offset(-WH(20))
            make.height.equalTo(WH(42))
            make.right.equalTo(self.snp.centerX).offset(-WH(8))
        }
        btnBuy.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-WH(20))
            make.bottom.equalTo(self).offset(-WH(20))
            make.height.equalTo(WH(42))
            make.left.equalTo(self.snp.centerX).offset(WH(8))
        }
        lblTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(WH(20))
            make.centerX.equalTo(self).offset(WH(16))
            make.height.equalTo(WH(25))
        }
        imgviewIcon.snp.makeConstraints { (make) in
            make.right.equalTo(lblTitle.snp.left).offset(-WH(3))
            make.centerY.equalTo(lblTitle)
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(26))
        }
        lblTip.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(30))
            make.right.equalTo(self).offset(-WH(30))
            make.top.equalTo(lblTitle.snp.bottom).offset(WH(7))
        }
    }
    
    
    // MARK: - Public
    
    func configView() {
        
    }
}
