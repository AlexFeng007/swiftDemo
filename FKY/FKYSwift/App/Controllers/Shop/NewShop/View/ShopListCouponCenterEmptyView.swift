//
//  ShopListCouponCenterEmptyView.swift
//  FKY
//
//  Created by 乔羽 on 2018/12/4.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit


enum ShopListCouponCenterEmptyType {
    case noData         // 无数据
    case noSubmitAudit  // 未提交审核
    case noAudit        // 审核未通过
    case auditing       // 审核中
}

class ShopListCouponCenterEmptyView: UIView {
    
    fileprivate var tip  : UILabel?
    fileprivate var goHomeBtn : UIButton?
    
    // 设置样式
    var type : ShopListCouponCenterEmptyType? {
        didSet {
            configView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = bg1
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        tip = {
            let lab = UILabel()
            lab.textAlignment = .center
            lab.font = UIFont.systemFont(ofSize: WH(14))
            lab.textColor = RGBColor(0x999999)
            lab.numberOfLines = 2
            lab.adjustsFontSizeToFitWidth = true
            return lab
        }()
        self.addSubview(tip!)
        
        goHomeBtn = {
            let btn = UIButton()
            btn.fontTuple = t43
            btn.contentMode = .scaleAspectFit
            btn.layer.borderColor = RGBColor(0xFF2D5C).cgColor
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 3
            btn.clipsToBounds = true
            btn.setTitleColor(RGBColor(0xFF2D5C), for: UIControl.State.normal)
            return btn
        }()
        self.addSubview(goHomeBtn!)
        
        tip?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp.centerY).offset(WH(-6))
            make.height.equalTo(40)
            make.width.equalTo(222)
        })
        
        goHomeBtn?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.snp.centerY).offset(WH(6))
            make.centerX.equalTo(self)
            make.height.equalTo(40)
            make.width.equalTo(150)
        })
    }
    
    
    // MARK: - Private
    
    fileprivate func configView() {
        switch type! {
        case .noSubmitAudit:
            goHomeBtn?.isHidden = false
            tip?.text = "您的资质审核未提交，资质审核通过后才可进入领券中心。"
            goHomeBtn?.setTitle("去资料管理提交审核", for: UIControl.State.normal)
            // 填写基本信息
            _ = goHomeBtn?.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                // 先返回个人中心
                FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                    let v = vc as! FKY_TabBarController
                    v.index = 4
                    // 再去填写基本信息
                    //FKYNavigator.shared().openScheme(FKY_CredentialsBaseInfo.self, setProperty: nil)
                    FKYNavigator.shared().openScheme(FKY_RITextController.self, setProperty: nil)
                }, isModal: false)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        case .noAudit:
            goHomeBtn?.isHidden = false
            tip?.text = "您的资质审核未通过，资质审核通过后才可进入领券中心。"
            goHomeBtn?.setTitle("去资料管理提交审核", for: UIControl.State.normal)
            // 基本资料
            _ = goHomeBtn?.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                // 先返回个人中心
                FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                    let v = vc as! FKY_TabBarController
                    v.index = 4
                    // 再去基本资料
                    FKYNavigator.shared().openScheme(FKY_QualiticationBaseInfo.self, setProperty: nil)
                }, isModal: false)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        case .auditing:
            goHomeBtn?.isHidden = true
            tip?.text = "您的资质审核中，请耐心等待资质审核通过后进入领券中心。"
        case .noData:
            goHomeBtn?.isHidden = true
            tip?.text = "暂无数据"
        }
    }
}
