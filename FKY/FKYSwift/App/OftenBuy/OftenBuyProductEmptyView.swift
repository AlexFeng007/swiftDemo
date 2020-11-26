//
//  OftenBuyProductEmptyView.swift
//  FKY
//
//  Created by 乔羽 on 2018/8/21.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  常购清单之无数据时的空态视图

import UIKit

enum OftenBuyEmptyType {
    case hotSale        // 热销
    case oftenBuy       // 常买
    case oftenLook      // 常看
    case whole          // 混合<热销、常买、常看>
    case noSubmitAudit  // 未提交审核
    case noAudit        // 审核未通过
    case auditing       // 审核中
}


class OftenBuyProductEmptyView: UIView {

    fileprivate var logo : UIImageView?
    fileprivate var tip  : UILabel?
    fileprivate var goHomeBtn : UIButton?
    
    // 设置样式
    var type : OftenBuyEmptyType? {
        didSet {
            setupView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = bg1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        logo = {
            let img = UIImageView()
            img.image = UIImage.init(named: "icon_often_none")
            img.contentMode = .scaleAspectFit
            return img
        }()
        self.addSubview(logo!)
        
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
        
        switch type! {
        case .noSubmitAudit:
            logo?.isHidden = true
            goHomeBtn?.isHidden = false
            layout2()
            tip?.text = "您的资质审核未提交，资质审核通过后才可开启推荐药品。"
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
            logo?.isHidden = true
            goHomeBtn?.isHidden = false
            layout2()
            tip?.text = "您的资质审核未通过，资质审核通过后才可开启推荐药品。"
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
            logo?.isHidden = true
            goHomeBtn?.isHidden = true
            layout2()
            tip?.text = "您的资质审核中，请耐心等待资质审核通过后开启推荐药品。"
        case .whole:
            layout1()
            tip?.text = "抱歉，暂无药品"
        case .hotSale:
            layout1()
            tip?.text = "抱歉，暂无热销药品"
        case .oftenLook:
            layout1()
            tip?.text = "抱歉，暂无常看药品"
        case .oftenBuy:
            layout1()
            tip?.text = "抱歉，暂无常买药品"
        }
    }
    
    
    // MARK: - Private
    
    func layout1() {
        logo?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.snp.top).offset(81)
            make.centerX.equalTo(self)
            make.height.width.equalTo(89)
        })
        tip?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.logo!.snp.bottom).offset(30)
            make.centerX.equalTo(self)
            make.height.equalTo(20)
        })
        goHomeBtn?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tip!.snp.bottom).offset(24)
            make.centerX.equalTo(self)
            make.height.equalTo(40)
            make.width.equalTo(120)
        })
        
        _ = goHomeBtn?.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            // 去首页
            FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                let v = vc as! FKY_TabBarController
                v.index = 0
            })
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        logo?.isHidden = false
        goHomeBtn?.isHidden = false
        goHomeBtn?.setTitle("去首页逛逛", for: UIControl.State.normal)
    }
    
    func layout2() {
        tip?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.snp.top).offset(180)
            make.centerX.equalTo(self)
            make.height.equalTo(40)
            make.width.equalTo(222)
        })
        goHomeBtn?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tip!.snp.bottom).offset(24)
            make.centerX.equalTo(self)
            make.height.equalTo(40)
            make.width.equalTo(150)
        })
    }
}
