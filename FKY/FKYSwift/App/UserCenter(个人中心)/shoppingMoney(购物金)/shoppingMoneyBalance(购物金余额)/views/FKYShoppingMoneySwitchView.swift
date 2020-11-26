//
//  FKYShoppingMoneySwitchView.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShoppingMoneySwitchView: UIView {

    /// 全部记录响应事件
    static let FKY_allRecordAction = "allRecordAction"

    /// 收入记录事件
    static let FKY_incomeRecordAction = "incomeRecordAction"

    /// 支出记录事件
    static let FKY_expenditureRecordAction = "expenditureRecordAction"

    /// 全部记录按钮
    lazy var allRecordBtn: UIButton = self.creatAllRecordBtn()

    /// 收入记录按钮
    lazy var incomeBtn: UIButton = self.creatIncomeBtn()

    /// 支出记录按钮
    lazy var expenditureBtn: UIButton = self.creatExpenditureBtn()

    /// 下方选中的状态线
    lazy var selectedLine: UIView = self.creatSelectedLine()

    /// 下方灰色分割线
    lazy var marginLine: UIView = self.creatMarginLine()

    /// 按钮数组
    var btnArrary: [UIButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.btnArrary = [self.allRecordBtn, self.incomeBtn, self.expenditureBtn]
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension FKYShoppingMoneySwitchView {
    func setupUI() {
        self.backgroundColor = RGBColor(0xFFFFFF)
        self.addSubview(self.allRecordBtn)
        self.addSubview(self.incomeBtn)
        self.addSubview(self.expenditureBtn)
        self.addSubview(self.selectedLine)
        self.addSubview(self.marginLine)

        /// 按钮宽度
        let btnWidth: CGFloat = WH(65)
        /// 下方选中分割线的宽度
        let selectedLineWidth: CGFloat = WH(72)
        /// 左右两边的空白距离
        let leftRightSpace: CGFloat = WH(60)
        /// 按钮之间的间距
        var btnMarginSpace: CGFloat = 0
        if self.btnArrary.count > 1 {
            let a = (SCREEN_WIDTH - (btnWidth * 3) - (leftRightSpace * 2))
            let b = CGFloat(self.btnArrary.count - 1)
            btnMarginSpace = a / b
        } else {
            btnMarginSpace = 0
        }

        self.allRecordBtn.snp_makeConstraints { (make) in
            //make.top.equalToSuperview().offset(WH(15))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(leftRightSpace)
            make.width.equalTo(btnWidth)
        }

        self.incomeBtn.snp_makeConstraints { (make) in
            //make.top.equalToSuperview().offset(WH(15))
            make.centerY.equalToSuperview()
            make.left.equalTo(self.allRecordBtn.snp_right).offset(btnMarginSpace)
            make.width.equalTo(btnWidth)
        }

        self.expenditureBtn.snp_makeConstraints { (make) in
            //make.top.equalToSuperview().offset(WH(15))
            make.centerY.equalToSuperview()
            make.left.equalTo(self.incomeBtn.snp_right).offset(btnMarginSpace)
            make.width.equalTo(btnWidth)
        }

        self.selectedLine.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.allRecordBtn)
            //make.top.equalTo(self.allRecordBtn.snp_bottom).offset(WH(11))
            make.bottom.equalTo(self.marginLine.snp_top).offset(WH(-2))
            make.width.equalTo(selectedLineWidth)
            make.height.equalTo(WH(1))
        }

        self.marginLine.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

    /// 将下方的红色标记移动到对应的按钮下
    func moveSelectedLineToBtn(_ index: Int) {
        if index > self.btnArrary.count - 1, index < 0 {
            return
        }

        let bt = self.btnArrary[index]
        UIView.animate(withDuration: 0.5) {
            self.selectedLine.hd_centerX = bt.hd_centerX
        }
    }
}


//MARK: - 响应事件
extension FKYShoppingMoneySwitchView {

    /// 所有记录按钮点击
    @objc func allRecordBtnClicked() {
        self.selectedBtnWithIndex(0)
        self.routerEvent(withName: FKYShoppingMoneySwitchView.FKY_allRecordAction, userInfo: [FKYUserParameterKey: ""])
    }

    /// 收入记录按钮点击
    @objc func incomeBtnClicked() {
        self.selectedBtnWithIndex(1)
        self.routerEvent(withName: FKYShoppingMoneySwitchView.FKY_incomeRecordAction, userInfo: [FKYUserParameterKey: ""])
    }

    /// 支出记录按钮点击
    @objc func expenditureBtnClicked() {
        self.selectedBtnWithIndex(2)
        self.routerEvent(withName: FKYShoppingMoneySwitchView.FKY_expenditureRecordAction, userInfo: [FKYUserParameterKey: ""])
    }
}


//MARK: - 私有方法
extension FKYShoppingMoneySwitchView {

    /// 改变某一按钮的选中状态 0 全部记录 1收入记录 2支出记录
    func selectedBtnWithIndex(_ index: Int) {

        for (indexInArray, btn) in btnArrary.enumerated() {
            if indexInArray == index {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
        self.moveSelectedLineToBtn(index)
    }
}

//MARK: - 属性对应的生成方法
extension FKYShoppingMoneySwitchView {
    func creatAllRecordBtn() -> UIButton {
        let bt = UIButton()
        bt.setTitle("全部记录", for: .normal)
        bt.setTitleColor(RGBColor(0xFF2D5C), for: .selected)
        bt.setTitleColor(RGBColor(0x333333), for: .normal)
        bt.addTarget(self, action: #selector(FKYShoppingMoneySwitchView.allRecordBtnClicked), for: .touchUpInside)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: WH(15))
        return bt
    }

    func creatIncomeBtn() -> UIButton {
        let bt = UIButton()
        bt.setTitle("收入记录", for: .normal)
        bt.setTitleColor(RGBColor(0xFF2D5C), for: .selected)
        bt.setTitleColor(RGBColor(0x333333), for: .normal)
        bt.addTarget(self, action: #selector(FKYShoppingMoneySwitchView.incomeBtnClicked), for: .touchUpInside)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: WH(15))
        return bt
    }

    func creatExpenditureBtn() -> UIButton {
        let bt = UIButton()
        bt.setTitle("支出记录", for: .normal)
        bt.setTitleColor(RGBColor(0xFF2D5C), for: .selected)
        bt.setTitleColor(RGBColor(0x333333), for: .normal)
        bt.addTarget(self, action: #selector(FKYShoppingMoneySwitchView.expenditureBtnClicked), for: .touchUpInside)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: WH(15))
        return bt
    }

    func creatSelectedLine() -> UIView {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFF2D5C)
        return view
    }

    func creatMarginLine() -> UIView {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }

}

