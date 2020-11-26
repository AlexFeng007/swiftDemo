//
//  FKYShoppingMoneyRecordCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShoppingMoneyRecordCell: UITableViewCell {


    /// 数据
    var cellModel: FKYShoppingMoneyRecordModel = FKYShoppingMoneyRecordModel()

    /// 时间
    lazy var timeLB: UILabel = self.creatTimeLB()

    /// 订单号
    lazy var orderNumLB: UILabel = self.creatOrderNumLB()

    /// 类型
    lazy var typeLB: UILabel = self.creatTypeLB()

    /// 厂家
    lazy var factoryLB: UILabel = self.creatFactoryLB()

    /// 金额
    lazy var amountLB: UILabel = self.creatAmountLB()

    /// 右箭头
    lazy var RightArrowIcon: UIImageView = self.creatRightArrowIcon()

    /// 分割线
    lazy var marginLine: UIView = self.creatMarginLine()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

//MARK: - 数据展示
extension FKYShoppingMoneyRecordCell {

    func showCellData(cellData: FKYShoppingMoneyRecordModel) {
        self.cellModel = cellData
        self.timeLB.text = self.cellModel.operateTime
        if self.cellModel.orderNo.isEmpty {
            self.orderNumLB.text = ""
            self.isHideOrderNumLB(isHide: true)
            self.isHideRightArrowIcon(true)
        } else {
            self.isHideRightArrowIcon(false)
            self.isHideOrderNumLB(isHide: false)
            self.orderNumLB.text = "订单号：" + self.cellModel.orderNo
        }

        if self.cellModel.typeName.isEmpty {
            self.typeLB.text = ""
            self.isHideTypeLB(isHide: true)
        } else {
            self.isHideTypeLB(isHide: false)
            self.typeLB.text = "类型：" + self.cellModel.typeName
        }

        self.isHideFactoryLB(self.cellModel.sellerName.isEmpty)
        self.factoryLB.text = self.cellModel.sellerName

        /// 金额
        var amountStr = ""
        if self.cellModel.incomeAmount > 0 { //此条为收入记录
            amountStr = "+" + String(format: "%.2f", self.cellModel.incomeAmount)
        } else if self.cellModel.expendAmount > 0 { // 此条为支出记录
            amountStr = "-" + String(format: "%.2f", self.cellModel.expendAmount)
        }
        self.amountLB.text = amountStr

    }
}

//MARK: - UI
extension FKYShoppingMoneyRecordCell {

    func setupUI() {
        self.selectionStyle = .none
        self.contentView.addSubview(self.timeLB)
        self.contentView.addSubview(self.orderNumLB)
        self.contentView.addSubview(self.typeLB)
        self.contentView.addSubview(self.factoryLB)
        self.contentView.addSubview(self.amountLB)
        self.contentView.addSubview(self.RightArrowIcon)
        self.contentView.addSubview(self.marginLine)

        self.timeLB.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        self.orderNumLB.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        self.typeLB.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        self.factoryLB.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        self.RightArrowIcon.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        self.RightArrowIcon.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)

        let leftMarginSpace = WH(15)

        self.timeLB.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(14))
            make.left.equalToSuperview().offset(leftMarginSpace)
            make.right.equalTo(self.amountLB.snp_left)
        }

        self.orderNumLB.snp_makeConstraints { (make) in
            make.top.equalTo(self.timeLB.snp_bottom).offset(WH(10))
            make.left.equalToSuperview().offset(leftMarginSpace)
            make.right.equalTo(self.amountLB.snp_left)
        }

        self.typeLB.snp_makeConstraints { (make) in
            make.top.equalTo(self.orderNumLB.snp_bottom).offset(WH(10))
            make.left.equalToSuperview().offset(leftMarginSpace)
            make.right.equalTo(self.amountLB.snp_left)
        }

        self.factoryLB.snp_makeConstraints { (make) in
            make.top.equalTo(self.typeLB.snp_bottom).offset(WH(10))
            make.left.equalToSuperview().offset(leftMarginSpace)
            make.right.equalTo(self.amountLB.snp_left)
            //make.bottom.equalTo(self.marginLine.snp_top).offset(WH(-14))
            make.bottom.equalToSuperview().offset(WH(-14))
        }

        self.marginLine.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
        }

        self.amountLB.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.RightArrowIcon.snp_left).offset(WH(-7))
        }

        self.RightArrowIcon.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(WH(-15))
            make.width.height.equalTo(WH(12))
        }
    }

    func isHideOrderNumLB(isHide: Bool) {
        if isHide {
            self.orderNumLB.snp_updateConstraints({ (make) in
                make.top.equalTo(self.timeLB.snp_bottom).offset(WH(0))
            })
        } else {
            self.orderNumLB.snp_updateConstraints({ (make) in
                make.top.equalTo(self.timeLB.snp_bottom).offset(WH(10))
            })
        }
    }

    func isHideTypeLB(isHide: Bool) {
        if isHide {
            self.typeLB.snp_updateConstraints({ (make) in
                make.top.equalTo(self.orderNumLB.snp_bottom).offset(WH(0))
            })
        } else {
            self.typeLB.snp_updateConstraints({ (make) in
                make.top.equalTo(self.orderNumLB.snp_bottom).offset(WH(10))
            })
        }
    }

    func isHideFactoryLB(_ isHide: Bool) {
        if isHide {
            self.factoryLB.snp_updateConstraints({ (make) in
                make.top.equalTo(self.typeLB.snp_bottom).offset(WH(0))
            })
        } else {
            self.factoryLB.snp_updateConstraints({ (make) in
                make.top.equalTo(self.typeLB.snp_bottom).offset(WH(10))
            })
        }
    }

    func isHideRightArrowIcon(_ isHide: Bool) {
        if isHide {
            self.amountLB.snp_updateConstraints { (make) in
                make.right.equalTo(self.RightArrowIcon.snp_left).offset(WH(0))
            }

            self.RightArrowIcon.snp_updateConstraints { (make) in
                make.right.equalToSuperview().offset(WH(-15))
                make.width.equalTo(WH(0))
            }
        } else {
            self.amountLB.snp_updateConstraints { (make) in
                make.right.equalTo(self.RightArrowIcon.snp_left).offset(WH(-7))
            }

            self.RightArrowIcon.snp_updateConstraints { (make) in
                make.right.equalToSuperview().offset(WH(-17))
                make.width.equalTo(WH(12))
            }
        }
    }
}

//MARK: - 属性对应的生成方法
extension FKYShoppingMoneyRecordCell {
    func creatTimeLB() -> UILabel {
        let lb = UILabel()
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: WH(14))
        lb.textColor = RGBColor(0x333333)
        return lb
    }

    func creatOrderNumLB() -> UILabel {
        let lb = UILabel()
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: WH(12))
        lb.textColor = RGBColor(0x666666)
        return lb
    }

    func creatTypeLB() -> UILabel {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = RGBColor(0x999999)
        lb.font = UIFont.systemFont(ofSize: WH(12))
        return lb
    }

    func creatFactoryLB() -> UILabel {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = RGBColor(0x999999)
        lb.font = UIFont.systemFont(ofSize: WH(12))
        return lb
    }

    func creatAmountLB() -> UILabel {
        let lb = UILabel()
        lb.text = ""
        lb.textAlignment = .right
        lb.font = UIFont.boldSystemFont(ofSize: WH(18))
        lb.textColor = RGBColor(0x333333)
        return lb
    }

    func creatRightArrowIcon() -> UIImageView {
        let img = UIImageView()
        img.image = UIImage(named: "ShoppingMoneyRecordRightArrow")
        return img
    }

    func creatMarginLine() -> UIView {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }

}

