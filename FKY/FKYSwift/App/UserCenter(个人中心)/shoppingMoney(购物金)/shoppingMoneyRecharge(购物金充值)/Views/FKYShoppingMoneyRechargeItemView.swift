//
//  FKYShoppingMoneyRechargeItemView.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShoppingMoneyRechargeItemView: UIView {

    /// 数据
    var cellData: FKYShoppingMoneyRechargeCellModel = FKYShoppingMoneyRechargeCellModel()

    /// 金额
    lazy var amountLB: UILabel = self.creatAmountLB()

    /// 活动描述
    lazy var activityDesLB: UILabel = self.creatActivityDesLB()

    /// 选中状态下的icon
    lazy var selectedIcon: UIImageView = self.creatSelectedIcon()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - 数据展示
extension FKYShoppingMoneyRechargeItemView {

    func showData(data: FKYShoppingMoneyRechargeCellModel) {
        self.cellData = data

        /// 金额
        let tempStr = self.cellData.rechargeModel.threshold.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self.cellData.rechargeModel.threshold) : String(format: "%.2f", self.cellData.rechargeModel.threshold)
        let str1 = NSAttributedString.getAttributedStringWith(contentStr: tempStr, color: RGBColor(0xFF2D5C), font: UIFont.boldSystemFont(ofSize: WH(18)))
        let str2 = NSAttributedString.getAttributedStringWith(contentStr: "元", color: RGBColor(0xFF2D5C), font: UIFont.systemFont(ofSize: WH(12)))
        let str = NSMutableAttributedString()
        str.append(str1)
        str.append(str2)
        self.amountLB.attributedText = str

        // 描述
        self.activityDesLB.text = self.cellData.rechargeModel.desc
        self.isSelectedItem(isSelected: self.cellData.isSelected)
        self.hideActivityDesLB(isHide: self.cellData.rechargeModel.desc.isEmpty)
    }
}

//MARK: - UI
extension FKYShoppingMoneyRechargeItemView {

    func setupUI() {

        self.isSelectedItem(isSelected: true)

        self.addSubview(self.amountLB)
        self.addSubview(self.activityDesLB)
        self.addSubview(self.selectedIcon)

        self.amountLB.snp_makeConstraints { (make) in
            //make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.equalTo(WH(152))
            make.top.equalTo(WH(11))
        }

        self.activityDesLB.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.amountLB.snp_bottom)
            make.width.equalTo(WH(140))
        }

        self.selectedIcon.snp_makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(WH(40))
            make.width.height.equalTo(WH(23))
        }
    }

    /// 是否选中了此item
    func isSelectedItem(isSelected: Bool) {
        if isSelected {
            self.layer.cornerRadius = WH(4)
            self.layer.masksToBounds = true
            self.layer.borderWidth = 1
            self.layer.borderColor = RGBColor(0xFF2D5C).cgColor
            self.backgroundColor = RGBColor(0xFFEDE7)

            self.amountLB.textColor = RGBColor(0xFF2D5C)
            self.activityDesLB.textColor = RGBColor(0xFF2D5C)
            self.selectedIcon.isHidden = false
        } else {
            self.layer.cornerRadius = WH(4)
            self.layer.masksToBounds = true
            self.layer.borderWidth = 1
            self.layer.borderColor = RGBColor(0xF4F4F4).cgColor
            self.backgroundColor = RGBColor(0xF4F4F4)

            self.amountLB.textColor = RGBColor(0x333333)
            self.activityDesLB.textColor = RGBColor(0x999999)
            self.selectedIcon.isHidden = true
        }
    }

    /// 隐藏下方的文描
    func hideActivityDesLB(isHide: Bool) {
        if isHide {
            self.activityDesLB.snp_remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(self.amountLB.snp_bottom)
                make.width.equalTo(WH(140))
                make.height.equalTo(0)
            }

            self.amountLB.snp_remakeConstraints { (make) in
                //make.top.equalTo(WH(11))
                make.center.equalToSuperview()
            }
        } else {
            self.amountLB.snp_remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(WH(11))
            }

            self.activityDesLB.snp_remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(self.amountLB.snp_bottom)
                make.width.equalTo(WH(140))
            }
        }

    }
}

//MARK: - 属性对应的生成方法
extension FKYShoppingMoneyRechargeItemView {
    func creatAmountLB() -> UILabel {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = RGBColor(0xFF2D5C)
        lb.font = UIFont.boldSystemFont(ofSize: WH(18))
        lb.textAlignment = .center
        return lb
    }

    func creatActivityDesLB() -> UILabel {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = RGBColor(0xFF2D5C)
        lb.font = UIFont.systemFont(ofSize: WH(12))
        lb.textAlignment = .center
        lb.adjustsFontSizeToFitWidth = true
        lb.minimumScaleFactor = 0.833
        return lb
    }

    func creatSelectedIcon() -> UIImageView {
        let img = UIImageView()
        img.image = UIImage(named: "ShoppingMoneyRechargeSelectedIcon")
        return img
    }

}

