//
//  FKYShoppingMoneyAccountInfoView.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShoppingMoneyAccountInfoView: UIView {

    /// 去充值事件
    static var FKY_goToRechargeAction = "goToRechargeAction"

    /// 数据源
    var balanceInfo: FKYShoppingMoneyBalanceInfoModel = FKYShoppingMoneyBalanceInfoModel()

    /// 余额
    lazy var balanceLB: UILabel = self.creatBalanceLB()

    /// 余额文描
    lazy var balanceDesLB: UILabel = self.creatBalanceDesLB()

    /// 充值按钮
    lazy var rechargeBtn: UIButton = self.creatRechargeBtn()

    /// 滚动提示容器视图
    lazy var scrollTipsContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFCF1)
        view.layer.cornerRadius = WH(30)/2.0
        view.layer.masksToBounds = true
        return view
    }()
    
    /// 滚动提示的喇叭icon
    lazy var scrollTipsIcon:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"scroll_Tips_Icon")
        return image
    }()
    
    /// 滚动提示文字
    lazy var scrollTipsText:LMJScrollTextView = {
        let view = LMJScrollTextView.init(frame: CGRect.zero, textScrollModel: LMJTextScrollContinuous, direction: LMJTextScrollMoveLeft)
        
        return view ?? LMJScrollTextView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - 数据展示
extension FKYShoppingMoneyAccountInfoView {
    func showData(data: FKYShoppingMoneyBalanceInfoModel) {
        self.balanceInfo = data
        self.balanceLB.text = String(format: "%.2f", self.balanceInfo.amount)
        if self.balanceInfo.activityText.isEmpty {
            self.isHideScrollTips(true)
        }else{
            self.scrollTipsText.startScroll(withText: self.balanceInfo.activityText, textColor: RGBColor(0xE8772A), font: .systemFont(ofSize: WH(12)))
            self.isHideScrollTips(false)
        }
    }
}

//MARK: - 事件响应
extension FKYShoppingMoneyAccountInfoView {

    /// 去充值按钮点击
    @objc func rechargeBtnClicked() {
        self.routerEvent(withName: FKYShoppingMoneyAccountInfoView.FKY_goToRechargeAction, userInfo: [FKYUserParameterKey: ""])
    }
}

//MARK: - UI
extension FKYShoppingMoneyAccountInfoView {
    func setupUI() {
        self.backgroundColor = RGBColor(0xFFFFFF)
        self.addSubview(self.balanceLB)
        self.addSubview(self.balanceDesLB)
        self.addSubview(self.rechargeBtn)
        self.addSubview(self.scrollTipsContainerView)
        self.scrollTipsContainerView.addSubview(self.scrollTipsIcon)
        self.scrollTipsContainerView.addSubview(self.scrollTipsText)

        self.balanceLB.setContentHuggingPriority(UILayoutPriority(rawValue: 999), for: .horizontal)
        self.balanceDesLB.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)

        self.balanceLB.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(WH(22))
        }

        self.balanceDesLB.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.balanceLB.snp_bottom).offset(WH(8))
        }

        self.rechargeBtn.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.balanceDesLB.snp_bottom).offset(WH(17))
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(160))
        }
        
        self.scrollTipsContainerView.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(341))
            make.top.equalTo(self.rechargeBtn.snp_bottom).offset(WH(10))
            make.bottom.equalToSuperview().offset(WH(-16))
        }
        
        self.scrollTipsIcon.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(7))
            make.centerY.equalToSuperview().offset(WH(0))
            make.width.height.equalTo(WH(14))
        }
        
        self.scrollTipsText.snp_makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.scrollTipsIcon.snp_right).offset(WH(3))
        }
        
        self.hideRechargeBtn(true)
        self.isHideScrollTips(true)
    }

    /// 隐藏去充值按钮
    func hideRechargeBtn(_ isHide: Bool) {
        if isHide {
            self.rechargeBtn.snp_updateConstraints { (make) in
                make.top.equalTo(self.balanceDesLB.snp_bottom).offset(WH(0))
                make.height.equalTo(WH(0))
            }
        } else {
            self.rechargeBtn.snp_updateConstraints { (make) in
                make.top.equalTo(self.balanceDesLB.snp_bottom).offset(WH(17))
                make.height.equalTo(WH(42))
            }
        }
    }
    
    /// 是否隐藏滚动提示
    func isHideScrollTips(_ isHide:Bool){
        if isHide {
            self.scrollTipsContainerView.snp_updateConstraints { (make) in
                make.height.equalTo(WH(0))
                make.top.equalTo(self.rechargeBtn.snp_bottom).offset(WH(0))
                make.bottom.equalToSuperview().offset(WH(-16))
            }
        }else{
            self.scrollTipsContainerView.snp_updateConstraints { (make) in
                make.height.equalTo(WH(30))
                make.top.equalTo(self.rechargeBtn.snp_bottom).offset(WH(10))
                make.bottom.equalToSuperview().offset(WH(-16))
            }
        }
    }
}

//MARK: - 属性对应的生成方法
extension FKYShoppingMoneyAccountInfoView {
    func creatBalanceLB() -> UILabel { let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = RGBColor(0xFF2C5C)
        lb.font = UIFont.boldSystemFont(ofSize: WH(26))
        lb.text = ""
        return lb
    }

    func creatBalanceDesLB() -> UILabel { let lb = UILabel()
        lb.text = "可用余额(元)"
        lb.textAlignment = .center
        lb.textColor = RGBColor(0x999999)
        lb.font = UIFont.systemFont(ofSize: WH(12))
        return lb
    }

    func creatRechargeBtn() -> UIButton { let bt = UIButton()
        bt.layer.cornerRadius = WH(4)
        bt.layer.masksToBounds = true
        bt.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        bt.layer.borderWidth = 1
        bt.setTitle("去充值", for: .normal)
        bt.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        bt.addTarget(self, action: #selector(FKYShoppingMoneyAccountInfoView.rechargeBtnClicked), for: .touchUpInside)
        bt.backgroundColor = RGBColor(0xFFEDE7)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        return bt
    }

}

