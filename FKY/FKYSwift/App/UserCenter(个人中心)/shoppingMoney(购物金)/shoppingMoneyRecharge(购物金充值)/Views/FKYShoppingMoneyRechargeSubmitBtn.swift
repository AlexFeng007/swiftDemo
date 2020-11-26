//
//  FKYShoppingMoneyRechargeSubmitBtn.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShoppingMoneyRechargeSubmitBtn: UIView {

    /// 当前选中的充值金额
    var rechargeModel: FKYRechargeActivityInfoModel = FKYRechargeActivityInfoModel()

    /// 充值按钮点击事件
    static let FKY_goToRecharge = "goToRecharge"

    /// 确定充值按钮
    lazy var confirmBtn: UIButton = self.creatConfirmBtn()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - 数据展示
extension FKYShoppingMoneyRechargeSubmitBtn {
    func showData(model: FKYRechargeActivityInfoModel) {
        self.rechargeModel = model
        guard self.rechargeModel.threshold > 0 else {
            self.confirmBtn.setTitle("去充值", for: .normal)
            self.confirmBtn.isUserInteractionEnabled = false
            return
        }
        let tempStr = self.rechargeModel.threshold.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self.rechargeModel.threshold) : String(format: "%.2f", self.rechargeModel.threshold)
        let str1 = NSAttributedString.getAttributedStringWith(contentStr: "￥" + tempStr, color: RGBColor(0xFFFFFF), font: UIFont.boldSystemFont(ofSize: WH(16)))
        let str2 = NSAttributedString.getAttributedStringWith(contentStr: " 立即充值", color: RGBColor(0xFFFFFF), font: UIFont.systemFont(ofSize: WH(15)))
        let str = NSMutableAttributedString()
        str.append(str1)
        str.append(str2)
        self.confirmBtn.setAttributedTitle((str.copy() as! NSAttributedString), for: .normal)
        self.confirmBtn.isUserInteractionEnabled = true
    }
}

//MARK: - 事件响应
extension FKYShoppingMoneyRechargeSubmitBtn {

    /// 充值按钮点击
    @objc func confirmBtnClicked() {
        self.routerEvent(withName: FKYShoppingMoneyRechargeSubmitBtn.FKY_goToRecharge, userInfo: [FKYUserParameterKey: ""])
    }
}

//MARK: - UI
extension FKYShoppingMoneyRechargeSubmitBtn {

    func setupUI() {
        self.backgroundColor = RGBColor(0xFFFFFF)
        self.addSubview(self.confirmBtn)

        var bottomMargin = WH(20)
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                bottomMargin += iPhoneX_SafeArea_BottomInset
            }
        }

        self.confirmBtn.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(30))
            make.right.equalToSuperview().offset(WH(-30))
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottomMargin)
            make.height.equalTo(WH(42))
        }
    }
}

//MARK: - 属性对应的生成方法
extension FKYShoppingMoneyRechargeSubmitBtn {
    func creatConfirmBtn() -> UIButton {
        let bt = UIButton()
        bt.layer.cornerRadius = WH(4)
        bt.layer.masksToBounds = true
        bt.backgroundColor = RGBColor(0xFF2D5C)
        bt.setTitle("立即充值", for: .normal)
        bt.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        bt.addTarget(self, action: #selector(FKYShoppingMoneyRechargeSubmitBtn.confirmBtnClicked), for: .touchUpInside)
        bt.isUserInteractionEnabled = false
        return bt
    }

}

