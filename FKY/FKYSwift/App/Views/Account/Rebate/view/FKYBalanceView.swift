//
//  FKYBalanceView.swift
//  FKY
//
//  Created by My on 2019/8/26.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

/*
 我的余额
 */
enum FKYBalanceType: Int {
    case FKYBalanceTypeAvaliable = 1 //可用余额
    case FKYBalanceTypeTotal = 2 //累计余额
    case FKYBalanceTypePending = 3 //待到账余额
}

class FKYBalanceView: UIView {
    
    var configLabelClosure: (UIColor, UIFont, String) -> UILabel = {
        (textColor, font, text) in
        let label = UILabel()
        label.textColor = textColor
        label.font = font
        label.text = text
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
//        label.numberOfLines = 0
        return label
    }
    var balanceType: FKYBalanceType = .FKYBalanceTypeAvaliable
    var balanceAmount: Double = 0.00
    
    var BalanceType:FKYBalanceType = .FKYBalanceTypeAvaliable
    
    //点击事件
    var didClicked: (() -> ())?
    
    /// 广告容器
    lazy var tipLabelContainer:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFCF1)
        return view
    }()
    
    /// 上方广告
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xE8772A)
        label.font = t3.font
        label.text = ""
        label.adjustsFontSizeToFitWidth = false
        label.numberOfLines = 0
        return label
    }()
    
    /// 可用余额(元)
    lazy var balanceTip: UILabel = self.configLabelClosure(RGBColor(0x666666), t3.font, "")
    
    /// 明细
    lazy var detailTip: UILabel = self.configLabelClosure(RGBColor(0xFF2C5C), t25.font, "明细 >")
    
    /// 可用余额
    lazy var balanceLabel: UILabel = self.configLabelClosure(RGBColor(0xFF2C5C), UIFont.boldSystemFont(ofSize: WH(26)), "0.00")
    
    
    init(frame: CGRect, type: FKYBalanceType) {
        super.init(frame: frame)
        balanceType = type
        setupViews(type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension FKYBalanceView {
    func setupViews(_ type: FKYBalanceType) -> Void {
        self.balanceType = type
        self.addSubview(self.tipLabelContainer)
        self.tipLabelContainer.addSubview(self.tipLabel)
        addSubview(balanceLabel)
        addSubview(balanceTip)
        
        if(type == .FKYBalanceTypeAvaliable) {
            addSubview(detailTip)
            balanceTip.text = "可用余额(元)"
//            tipLabel.text = "温馨提示：商家返利只能抵扣对应商家的订单"
        } else if(type == .FKYBalanceTypeTotal) {
            balanceTip.text = "累计余额(元)"
//            tipLabel.text = "温馨提示：商家返利只能抵扣对应商家的订单"
        } else if(type == .FKYBalanceTypePending) {
            balanceTip.text = "待到帐余额(元)"
//            tipLabel.text = "温馨提示：返利金需确认收货后3个工作日到账"
        }
        
        self.tipLabelContainer.snp_makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
        
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(WH(10))
            make.bottom.equalTo(WH(-7))
            make.left.equalTo(self.tipLabelContainer).offset(WH(15))
            make.right.equalTo(self.tipLabelContainer).offset(WH(-24))
        }
        
        if(type == .FKYBalanceTypeAvaliable) {
            
            balanceLabel.snp.makeConstraints { (make) in
                make.top.equalTo(tipLabelContainer.snp.bottom).offset(WH(14))
                make.centerX.equalToSuperview().offset(WH(-17));
            }
            
            detailTip.snp.makeConstraints { (make) in
                make.bottom.equalTo(balanceLabel.snp.bottom).offset(-6)
                make.left.equalTo(balanceLabel.snp.right).offset(WH(2))
            }
            
            let tapView = UIView()
            tapView.backgroundColor = .clear
            addSubview(tapView)
            tapView.snp.makeConstraints { (make) in
                make.bottom.equalTo(balanceTip)
                make.left.top.equalTo(balanceLabel)
                make.right.equalTo(detailTip)
            }
            
            let tapGesture = UITapGestureRecognizer()
            tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                if(strongSelf.balanceAmount > 0) {
                    strongSelf.didClicked?()
                }
            }).disposed(by: disposeBag)
            tapView.addGestureRecognizer(tapGesture)
        } else {
            balanceLabel.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(tipLabelContainer.snp.bottom).offset(WH(14))
            }
        }
        balanceTip.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(balanceLabel.snp.bottom).offset(WH(3))
        }
    }
    
    func bindBalance(_ amount: Double) {
        balanceAmount = amount 
        balanceLabel.text = String(format: "%.2f", amount)
        if(balanceType == .FKYBalanceTypeAvaliable && amount <= 0) {
            detailTip.isHidden = true
            balanceLabel.snp.updateConstraints { (make) in
                make.centerX.equalToSuperview()
            }
        }
    }
    
    /// 根据是否共享展示文描
    /// - Parameter type: 0不共享 1共享
    func showTopTipWithType(type:String){
        if(self.balanceType == .FKYBalanceTypeAvaliable) {
            if type == "1"{
                tipLabel.textAlignment = .left
                tipLabel.text = "温馨提示：自营商家返利可抵扣所有自营商家订单，平台商家共享返利金支持抵扣多商家，自营商家除外，单商家返利只能抵扣对应商家的订单"
            }else{
                tipLabel.textAlignment = .center
                tipLabel.text = "温馨提示：商家返利只能抵扣对应商家的订单"
            }
            balanceTip.text = "可用余额(元)"
        } else if(self.balanceType == .FKYBalanceTypeTotal) {
            tipLabel.textAlignment = .center
            balanceTip.text = "累计余额(元)"
            tipLabel.text = "温馨提示：商家返利只能抵扣对应商家的订单"
        } else if(self.balanceType == .FKYBalanceTypePending) {
            tipLabel.textAlignment = .center
            balanceTip.text = "待到帐余额(元)"
            tipLabel.text = "温馨提示：返利金需确认收货后3个工作日到账"
        }
    }
}
