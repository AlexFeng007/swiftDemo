//
//  FKYMyRebateView.swift
//  FKY
//
//  Created by My on 2019/8/23.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYMyRebateView: UIView {
    
    var myRebateViewClicked: ((FKYRebateRecordType) -> ())?
    
    var model: FKYMyRebateModel?
    
    var configLabelClosure: (UIColor, UIFont, String) -> UILabel = {
        (textColor, font, text) in
        let label = UILabel()
        label.textColor = textColor
        label.font = font
        label.text = text
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = true
        return label
    }
    
    lazy var pendingTip: UILabel = self.configLabelClosure(RGBColor(0x666666), t3.font, "待到帐余额(元)")
    lazy var totalTip: UILabel = self.configLabelClosure(RGBColor(0x666666), t3.font, "累计余额(元)")
    //待到账余额
    lazy var pendingLabel: UILabel = self.configLabelClosure(RGBColor(0x333333), UIFont.systemFont(ofSize: WH(20)), "0.00")
    //累计余额
    lazy var totalLabel: UILabel = self.configLabelClosure(RGBColor(0x333333), UIFont.systemFont(ofSize: WH(20)), "0.00")
    
    lazy var balanceView: FKYBalanceView = {
        let view = FKYBalanceView.init(frame: CGRect.zero, type: .FKYBalanceTypeAvaliable)
        view.didClicked = { [weak self] in
            if let strongSelf = self {
                strongSelf.myRebateViewClicked?(.FKYRebateRecordTypeAvaliable)
            }
        }
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        configClicked()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FKYMyRebateView {
    func setupViews() {
        addSubview(balanceView)
        addSubview(pendingTip)
        addSubview(totalTip)
        addSubview(pendingLabel)
        addSubview(totalLabel)
        
        let singleLine = UIView()
        singleLine.backgroundColor = RGBColor(0xE5E5E5)
        addSubview(singleLine)
        
        let verticalLine = UIView()
        verticalLine.backgroundColor = RGBColor(0xE5E5E5)
        addSubview(verticalLine)
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = RGBColor(0xF2F2F2)
        addSubview(bottomLine)
        
        balanceView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(WH(122))
        }

        singleLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(balanceView.snp.bottom).offset(WH(14))
            make.height.equalTo(1)
        }
        
        verticalLine.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(singleLine.snp.bottom).offset(WH(11))
            make.size.equalTo(CGSize(width: 1, height: WH(41)))
        }
        
        totalLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalTo(verticalLine.snp.left).offset(-5)
            make.bottom.equalTo(verticalLine.snp.centerY).offset(1)
        }
        
        totalTip.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalTo(verticalLine.snp.left).offset(-5)
            make.top.equalTo(verticalLine.snp.centerY).offset(WH(3))
        }
        
        pendingLabel.snp.makeConstraints { (make) in
            make.left.equalTo(verticalLine.snp.right).offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalTo(verticalLine.snp.centerY).offset(1)
        }
        
        pendingTip.snp.makeConstraints { (make) in
            make.left.equalTo(verticalLine.snp.right).offset(5)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(verticalLine.snp.centerY).offset(WH(3))
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(WH(10))
        }
    }
    
    func configClicked() -> Void {
        
        let totalTapView = UIView()
        totalTapView.backgroundColor = .clear
        addSubview(totalTapView)
        totalTapView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(totalTip)
            make.top.equalTo(totalLabel)
        }
        
        
        let totalTap = UITapGestureRecognizer()
        totalTap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let amount = strongSelf.model?.totalRebate, amount > 0 {
                strongSelf.myRebateViewClicked?(.FKYRebateRecordTypeTotal)
            }
        }).disposed(by: disposeBag)
        totalTapView.addGestureRecognizer(totalTap)
     
        
        let pendingTap = UITapGestureRecognizer()
        pendingTap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let amount = strongSelf.model?.pendingRebate, amount > 0 {
                strongSelf.myRebateViewClicked?(.FKYRebateRecordTypePending)
            }
        }).disposed(by: disposeBag)

        let pendingTapView = UIView()
        pendingTapView.backgroundColor = .clear
        addSubview(pendingTapView)
        pendingTapView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(pendingTip)
            make.top.equalTo(pendingLabel)
        }
        pendingTapView.addGestureRecognizer(pendingTap)
    }
    
    func configData(_ myRebate: FKYMyRebateModel?) {
        if let rebate = myRebate {
            model = myRebate
            balanceView.bindBalance(rebate.availableRebate ?? 0)
            totalLabel.text = String(format: "%.2f", rebate.totalRebate ?? 0)
            pendingLabel.text = String(format: "%.2f", rebate.pendingRebate ?? 0)
        }
    }
}
