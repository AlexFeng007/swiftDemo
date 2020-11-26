//
//  FKYOrderPayStatusInfocell.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/16.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

/// 查看订单按钮点击事件
let FKY_OrderPayStatusCheckOrderBtnÇlicked = "OrderPayStatusCheckOrderBtnÇlicked"
/// 后台配置按钮点击事件
let FKY_OrderPayStatusBackgroundBtnClicked = "OrderPayStatusBackgroundBtnClicked"

class FKYOrderPayStatusInfocell: UITableViewCell {

    /// 订单支付状态icon
    lazy var statusIcon: UIImageView = self.creatStatusIcon()

    /// 订单支付状态文描  -支付成功 -待支付
    lazy var orderStatusLabel: UILabel = self.creatOrderStatusLabel()

    /// 订单支付金额
    lazy var orderStatusMoney: UILabel = self.creatOrderStatusMoney()

    /// 订单下方文描
    lazy var orderDesLabel: UILabel = self.creatOrderDesLabel()

    /// 查看订单按钮
    lazy var checkOrderBtn: UIButton = self.creatCheckOrderBtn()

    /// 迎解封大放价按钮  后台配置按钮，可能不展示
    lazy var backgroundConfigBtn: UIButton = self.creatBackgroundConfigBtn()

    ///背景图片
    lazy var backgroundImage: UIImageView = self.creatBackgroundImage()

    /// 分割线图片
    lazy var marginLineImg: UIImageView = self.creatMarginLineImg()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - UI
extension FKYOrderPayStatusInfocell {

    func setupUI() {

        self.selectionStyle = .none

        self.contentView.addSubview(self.backgroundImage)
        self.contentView.addSubview(self.statusIcon)
        self.contentView.addSubview(self.orderStatusLabel)
        self.contentView.addSubview(self.orderStatusMoney)
        self.contentView.addSubview(self.orderDesLabel)
        self.contentView.addSubview(self.checkOrderBtn)
        self.contentView.addSubview(self.backgroundConfigBtn)
        self.contentView.addSubview(self.marginLineImg)

        self.statusIcon.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(22))
            make.centerY.equalTo(self.orderStatusLabel.snp_bottom)
            make.width.height.equalTo(WH(26))
        }

        self.orderStatusLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.statusIcon.snp_right).offset(WH(7))
            make.right.equalToSuperview().offset(WH(-21))
            make.top.equalToSuperview().offset(WH(16))
        }

        self.orderStatusMoney.snp_makeConstraints { (make) in
            make.left.equalTo(self.orderStatusLabel)
            make.right.equalToSuperview().offset(WH(-21))
            make.top.equalTo(self.orderStatusLabel.snp_bottom).offset(WH(6))
        }

        self.orderDesLabel.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(22))
            make.right.equalToSuperview().offset(WH(-21))
            make.top.equalTo(self.orderStatusMoney.snp_bottom).offset(WH(9))
        }

        self.checkOrderBtn.layer.cornerRadius = WH(42 / 2.0)
        self.checkOrderBtn.layer.masksToBounds = true
        self.checkOrderBtn.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(22))
            make.right.equalTo(self.backgroundConfigBtn.snp_left).offset(WH(-14))
            make.top.equalTo(self.orderDesLabel.snp_bottom).offset(WH(16))
            make.height.equalTo(WH(42))
        }

        self.backgroundConfigBtn.layer.cornerRadius = WH(42 / 2.0)
        self.backgroundConfigBtn.layer.masksToBounds = true
        self.backgroundConfigBtn.snp_makeConstraints { (make) in
            make.right.equalToSuperview().offset(WH(-21))
            make.top.equalTo(self.checkOrderBtn)
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(160))
        }

        self.marginLineImg.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.greaterThanOrEqualTo(self.checkOrderBtn.snp_bottom).offset(WH(20))
            make.top.greaterThanOrEqualTo(self.backgroundConfigBtn.snp_bottom).offset(WH(20))
            make.height.equalTo(1)
            make.bottom.equalTo(WH(0))
        }

        self.backgroundImage.snp_makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self.contentView)
        }
    }

    /// 只显示查看订单
    func hideConfigButtonLayout() {
        self.backgroundConfigBtn.snp_remakeConstraints { (make) in
            make.right.equalToSuperview().offset(WH(-21))
            make.top.equalTo(self.checkOrderBtn)
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(0))
        }

        self.checkOrderBtn.snp_remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.orderDesLabel.snp_bottom).offset(WH(16))
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(240))
        }
    }

    /// 显示查看订单和配置按钮
    func haveConfigButtonLayout() {
        self.backgroundConfigBtn.snp_remakeConstraints { (make) in
            make.right.equalToSuperview().offset(WH(-21))
            make.top.equalTo(self.checkOrderBtn)
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(160))
        }

        self.checkOrderBtn.snp_remakeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(22))
            make.right.equalTo(self.backgroundConfigBtn.snp_left).offset(WH(-14))
            make.top.equalTo(self.orderDesLabel.snp_bottom).offset(WH(16))
            make.height.equalTo(WH(42))
        }
    }

    /// 只显示配置的促销按钮
    func onlyShowConfigBtn() {
        self.backgroundConfigBtn.snp_remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.orderDesLabel.snp_bottom).offset(WH(16))
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(240))
        }

        self.checkOrderBtn.snp_remakeConstraints { (make) in
            make.right.equalToSuperview().offset(WH(-21))
            make.top.equalTo(self.checkOrderBtn)
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(0))
        }
    }

    /// 两个都不展示
    func hiddenOrderBtnAndConfigBtn() {
        self.backgroundConfigBtn.snp_remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.orderDesLabel.snp_bottom).offset(WH(16))
            make.height.equalTo(WH(0))
            make.width.equalTo(WH(240))
        }

        self.checkOrderBtn.snp_remakeConstraints { (make) in
            make.right.equalToSuperview().offset(WH(-21))
            make.top.equalTo(self.checkOrderBtn)
            make.height.equalTo(WH(0))
            make.width.equalTo(WH(240))
        }
    }
}

// MARK: - 事件响应
extension FKYOrderPayStatusInfocell {

    /// 查看订单按钮被点击
    @objc func checkOrderBtnClicked() {
        self.routerEvent(withName: FKY_OrderPayStatusCheckOrderBtnÇlicked, userInfo: [FKYUserParameterKey: ""])
    }

    /// 后台配置按钮点击
    @objc func configBtnClicked() {
        self.routerEvent(withName: FKY_OrderPayStatusBackgroundBtnClicked, userInfo: [FKYUserParameterKey: ""])
    }
}

// MARK: - 显示数据
extension FKYOrderPayStatusInfocell {
    func configCellData(cellData: FKYOrderPayStatusCellModel) {

        if cellData.orderInfo.isPay == 1 { // 已支付
            self.statusIcon.image = UIImage(named: "PayOrder_Status_Icon")
            self.orderStatusLabel.text = "订单支付成功"
        } else if cellData.orderInfo.isPay == 0 { // 未支付
            self.statusIcon.image = UIImage(named: "order_status_no_pay")
            self.orderStatusLabel.text = "订单待支付"
        }

        self.orderStatusMoney.text = String(format: "￥%0.2f", cellData.orderInfo.finalPay.floatValue)
        if cellData.orderInfo.childOrderBeans?.count ?? 0 > 0 { // 有子订单
            self.orderDesLabel.text = "您的订单将根据不同供应商拆成多张，详情请进入订单中心查看"
        } else {
            self.orderDesLabel.text = ""
        }

        if cellData.isShowCheckOrderBtn == false, cellData.drawModel.promotionButton.isEmpty == true, cellData.drawModel.promotionLink.isEmpty == true {
            if cellData.drawModel.orderDrawRecordDto.promotionButton.isEmpty == false, cellData.drawModel.orderDrawRecordDto.promotionLink.isEmpty == false { // 只展示后台配置按钮
                self.backgroundConfigBtn.setTitle(cellData.drawModel.orderDrawRecordDto.promotionButton, for: .normal)
                self.onlyShowConfigBtn()
            } else { // 两个都不展示
                self.hiddenOrderBtnAndConfigBtn()
            }
        } else if cellData.isShowCheckOrderBtn == false, cellData.drawModel.promotionButton.isEmpty == false, cellData.drawModel.promotionLink.isEmpty == false { // 只展示后台配置的按钮
            self.backgroundConfigBtn.setTitle(cellData.drawModel.promotionButton, for: .normal)
            self.onlyShowConfigBtn()
        } else if cellData.isShowCheckOrderBtn == true, cellData.drawModel.promotionButton.isEmpty == true, cellData.drawModel.promotionLink.isEmpty == true { // 只展示订单按钮
            self.backgroundConfigBtn.setTitle("", for: .normal)
            self.hideConfigButtonLayout()
        } else if cellData.isShowCheckOrderBtn == true, cellData.drawModel.promotionButton.isEmpty == false, cellData.drawModel.promotionLink.isEmpty == false { // 两个按钮都展示
            self.backgroundConfigBtn.setTitle(cellData.drawModel.promotionButton, for: .normal)
            self.haveConfigButtonLayout()
        } else if cellData.isShowCheckOrderBtn == true { // 只显示订单按钮
            self.hideConfigButtonLayout()
        } else if cellData.isShowCheckOrderBtn == false { // 都不显示
            self.hiddenOrderBtnAndConfigBtn()
        }
    }
}


//MARK: - 属性对应的生成方法
extension FKYOrderPayStatusInfocell {
    func creatStatusIcon() -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: "PayOrder_Status_Icon")
        return image
    }

    func creatOrderStatusLabel() -> UILabel {
        let lb = UILabel()
        lb.textColor = RGBColor(0x061B49)
        lb.font = UIFont.systemFont(ofSize: WH(17))
        lb.numberOfLines = 1
        lb.text = ""
        return lb
    }

    func creatOrderStatusMoney() -> UILabel {
        let lb = UILabel()
        lb.textColor = RGBColor(0x061B49)
        lb.font = UIFont.boldSystemFont(ofSize: WH(20))
        lb.numberOfLines = 1
        lb.text = ""
        return lb
    }

    func creatOrderDesLabel() -> UILabel {
        let lb = UILabel()
        lb.textColor = RGBColor(0x0E2A6A)
        lb.font = UIFont.systemFont(ofSize: WH(11))
        lb.numberOfLines = 0
        lb.text = ""
        return lb
    }

    func creatCheckOrderBtn() -> UIButton {
        let bt = UIButton()
        bt.setTitle("查看订单", for: .normal)
        bt.setTitleColor(RGBColor(0xFE7B41), for: .normal)
        bt.layer.borderColor = RGBColor(0xFE7B41).cgColor
        bt.layer.borderWidth = 1
        bt.addTarget(self, action: #selector(FKYOrderPayStatusInfocell.checkOrderBtnClicked), for: .touchUpInside)
        return bt
    }

    func creatBackgroundConfigBtn() -> UIButton {
        let bt = UIButton()
        bt.setTitle("迎解封大放价", for: .normal)
        bt.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        bt.layer.borderColor = RGBColor(0xFE7B41).cgColor
        bt.layer.borderWidth = 1
        bt.backgroundColor = RGBColor(0xFE7B41)
        bt.addTarget(self, action: #selector(FKYOrderPayStatusInfocell.configBtnClicked), for: .touchUpInside)
        return bt
    }

    func creatBackgroundImage() -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: "Order_PayStatus_Background_Image")
        return image
    }

    func creatMarginLineImg() -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: "dottedLine")
        return image
    }

}

