//
//  CORebateInputCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  返利金抵扣输入cell

import UIKit

class CORebateInputCell: UITableViewCell {
    // MARK: - Property
    
    // 运费说明回调
    var frightDetailClosure: (()->())?
    // 激活输入框回调
    var inputClosure: (()->())?
    // 返利金开关回调
    var changeClosure: ((Bool)->())?
    
    // 商家订单model
    var shopOrderModel: COSupplyOrderModel?
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    // 无返利金可用时的提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .right
        lbl.text = "本单暂无返利金可用"
        return lbl
    }()
    
    // 最高可用
    fileprivate var lblUse: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        //lbl.text = "共638210.00无，可用9268.00元"
        lbl.numberOfLines = 2
        lbl.isUserInteractionEnabled = true
        return lbl
    }()
    
    // 返利金使用开关btn
    fileprivate lazy var btnSwitch: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setBackgroundImage(UIImage.init(named: "btn_co_rebate_close"), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: "btn_co_rebate_open"), for: .selected)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.changeClosure else {
                return
            }
            block(!strongSelf.btnSwitch.isSelected)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 下分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xEBEDEC)
        return view
    }()
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
        setupAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        clipsToBounds = true
        
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblTip)
        contentView.addSubview(lblUse)
        contentView.addSubview(btnSwitch)
        contentView.addSubview(viewLine)
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(11))
            make.centerY.equalTo(contentView)
            make.width.equalTo(WH(95))
        }
        lblTip.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-WH(11))
            make.centerY.equalTo(contentView)
        }
        btnSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-WH(10))
            make.centerY.equalTo(contentView)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(40))
        }
        lblUse.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(12))
            make.right.equalTo(btnSwitch.snp.left).offset(-WH(10))
            make.centerY.equalTo(contentView)
        }
        viewLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView)
            make.height.equalTo(0.8)
            make.right.equalTo(contentView.snp.right).offset(0)
            make.left.equalTo(contentView.snp.left).offset(0)
        }
        
        // 默认隐藏
        lblTip.isHidden = true
        // 默认不使用返利金
        btnSwitch.isSelected = false
    }
    
    
    // MARK: - Action
    
    // 设置事件
    fileprivate func setupAction() {
        // 隐藏
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            guard strongSelf.btnSwitch.isSelected else {
                return
            }
            guard let block = strongSelf.inputClosure else {
                return
            }
            block()
        }).disposed(by: disposeBag)
        lblUse.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Public
    
    func configCell(_ anyModel: Any?) {
        if let checkModel = anyModel as? CheckOrderModel{
            lblTitle.text = "使用返利抵扣"
            lblTitle.snp.remakeConstraints { (make) in
                make.left.equalTo(contentView).offset(WH(11))
                make.centerY.equalTo(contentView)
                make.width.equalTo(WH(90))
            }
            btnSwitch.snp.remakeConstraints { (make) in
                make.right.equalTo(contentView).offset(-WH(10))
                make.centerY.equalTo(contentView)
                make.height.equalTo(WH(30))
                make.width.equalTo(WH(40))
            }
            viewLine.snp.updateConstraints() { (make) in
                make.right.equalTo(contentView.snp.right).offset(-WH(10))
                make.left.equalTo(contentView.snp.left).offset(WH(10))
            }
            if let allRebateMoney = checkModel.allOrderCanUseRebateMoney,allRebateMoney.doubleValue > 0 {
                //有可用返利金
                lblTitle.isHidden = false
                lblTip.isHidden = true
                var lblStr = ""
                if let allrebateUse = checkModel.allOrdersUseRebateMoney,allrebateUse.doubleValue > 0 {
                    // 用户有输入返利金抵扣...<显示修改>
                    lblUse.isHidden = false
                    btnSwitch.isHidden = false  // 开关显示
                    btnSwitch.isSelected = true // 开关打开
                    if let allValueTotal = checkModel.allOrderRebateBalance,allValueTotal.doubleValue > 0 {
                        lblUse.text = String(format: "共%.2f元，已用%.2f元", allValueTotal.doubleValue, allrebateUse.doubleValue)
                    }else {
                        // 未返回返利金总额
                        lblUse.text = String(format: "已用%.2f元", allrebateUse.doubleValue)
                    }
                    let txtMoney: String = lblUse.text!
                    let txtAll = txtMoney + "  " + "修改"
                    lblStr = txtAll
                    let attributedString = NSMutableAttributedString(string: txtAll)
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                  value: RGBColor(0xFF2D5C),
                                                  range: NSMakeRange(0, txtAll.count))
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                  value: RGBColor(0x333333),
                                                  range: NSMakeRange(0, txtMoney.count))
                    lblUse.attributedText = attributedString
                }else {
                    // 用户未输入返利金抵扣...<隐藏修改>
                    lblUse.isHidden = false
                    btnSwitch.isHidden = false      // 开关显示
                    btnSwitch.isSelected = false    // 开关关闭
                    if let allValueTotal = checkModel.allOrderRebateBalance,allValueTotal.doubleValue > 0 {
                        lblUse.text = String(format: "共%.2f元，可用%.2f元", allValueTotal.doubleValue, allRebateMoney.doubleValue)
                    }else {
                        // 未返回返利金总额
                        lblUse.text = String(format: "可用%.2f元", allRebateMoney.doubleValue)
                    }
                    let txtMoney: String = lblUse.text!
                    lblStr = txtMoney
                    let attributedString = NSMutableAttributedString(string: txtMoney)
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                  value: RGBColor(0x333333),
                                                  range: NSMakeRange(0, txtMoney.count))
                    lblUse.attributedText = attributedString
                }
                //两行时修改ui布局
                let str_h = lblStr.heightForFontAndWidth(UIFont.systemFont(ofSize: WH(12)), width: SCREEN_WIDTH-WH(193), attributes: [NSAttributedString.Key.font.rawValue : UIFont.systemFont(ofSize: WH(12))])
                if str_h > WH(18) {
                    //两行
                    lblTitle.snp.remakeConstraints { (make) in
                        make.left.equalTo(contentView).offset(WH(11))
                        make.top.equalTo(contentView).offset(WH(17))
                        make.width.equalTo(WH(90))
                    }
                    btnSwitch.snp.remakeConstraints { (make) in
                        make.right.equalTo(contentView).offset(-WH(10))
                        make.top.equalTo(contentView).offset(WH(9))
                        make.height.equalTo(WH(30))
                        make.width.equalTo(WH(40))
                    }
                }
            }else {
                // 无可用返利金
                lblTitle.isHidden = false
                lblTip.isHidden = false
                lblUse.isHidden = true
                btnSwitch.isHidden = true
                lblTip.text = "暂无返利金可用"
            }
            //self.layoutIfNeeded()
            if checkModel.hasZiyingStatus == 1 {
                self.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.allCorners.rawValue), radius: WH(0))
                viewLine.isHidden = false
            }else {
                self.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue), radius: WH(8))
                viewLine.isHidden = true
            }
        }else if let shopOrder = anyModel as? COSupplyOrderModel {
            // 保存
            shopOrderModel = shopOrder
            // 显示
            lblTitle.text = "使用返利金抵扣"
            lblTitle.snp.remakeConstraints { (make) in
                make.left.equalTo(contentView).offset(WH(11))
                make.centerY.equalTo(contentView)
                make.width.equalTo(WH(95))
            }
            viewLine.snp.updateConstraints() { (make) in
                make.right.equalTo(contentView.snp.right).offset(0)
                make.left.equalTo(contentView.snp.left).offset(0)
            }
            if let rebateMoney = shopOrder.rebateMoney, rebateMoney.doubleValue > 0 {
                // 有可用返利金
                lblTitle.isHidden = false
                lblTip.isHidden = true
                viewLine.isHidden = false
                
                if let rebateUse = shopOrder.useRebateMoney, rebateUse.doubleValue > 0 {
                    // 用户有输入返利金抵扣...<显示修改>
                    lblUse.isHidden = false
                    btnSwitch.isHidden = false  // 开关显示
                    btnSwitch.isSelected = true // 开关打开
                    //
                    if let valueTotal = shopOrder.rebateBalance, valueTotal.doubleValue > 0 {
                        // 有返回返利金总额
                        lblUse.text = String(format: "共%.2f元，已用%.2f元", valueTotal.doubleValue, rebateUse.doubleValue)
                    }
                    else {
                        // 未返回返利金总额
                        lblUse.text = String(format: "已用%.2f元", rebateUse.doubleValue)
                    }
                    //
                    let txtMoney: String = lblUse.text!
                    let txtAll = txtMoney + "  " + "修改"
                    let attributedString = NSMutableAttributedString(string: txtAll)
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                  value: RGBColor(0xFF2D5C),
                                                  range: NSMakeRange(0, txtAll.count))
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                  value: RGBColor(0x333333),
                                                  range: NSMakeRange(0, txtMoney.count))
                    lblUse.attributedText = attributedString
                }
                else {
                    // 用户未输入返利金抵扣...<隐藏修改>
                    lblUse.isHidden = false
                    btnSwitch.isHidden = false      // 开关显示
                    btnSwitch.isSelected = false    // 开关关闭
                    //
                    if let valueTotal = shopOrder.rebateBalance, valueTotal.doubleValue > 0 {
                        // 有返回返利金总额
                        lblUse.text = String(format: "共%.2f元，可用%.2f元", valueTotal.doubleValue, rebateMoney.doubleValue)
                    }
                    else {
                        // 未返回返利金总额
                        lblUse.text = String(format: "可用%.2f元", rebateMoney.doubleValue)
                    }
                    //
                    let txtMoney: String = lblUse.text!
                    let attributedString = NSMutableAttributedString(string: txtMoney)
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                  value: RGBColor(0x333333),
                                                  range: NSMakeRange(0, txtMoney.count))
                    lblUse.attributedText = attributedString
                }
            }
            else {
                // 无可用返利金
                lblTitle.isHidden = false
                lblTip.isHidden = false
                lblUse.isHidden = true
                btnSwitch.isHidden = true
                viewLine.isHidden = false
                lblTip.text = "本单暂无返利金可用"
            }
            self.layoutIfNeeded()
            self.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.allCorners.rawValue), radius: WH(0))
        }
    }
    //计算高度
    class func calculateRebateViewsHeight(_ model:CheckOrderModel?) -> CGFloat {
        if let desModel = model , desModel.shareRebate == "1" {
            if let allRebateMoney = desModel.allOrderCanUseRebateMoney,allRebateMoney.doubleValue > 0 {
                var lblStr = ""
                if let allrebateUse = desModel.allOrdersUseRebateMoney,allrebateUse.doubleValue > 0 {
                    // 用户有输入返利金抵扣...<显示修改>
                    if let allValueTotal = desModel.allOrderRebateBalance,allValueTotal.doubleValue > 0 {
                        lblStr = String(format: "共%.2f元，已用%.2f元", allValueTotal.doubleValue, allrebateUse.doubleValue) + "  " + "修改"
                    }else {
                        // 未返回返利金总额
                        lblStr = String(format: "已用%.2f元", allrebateUse.doubleValue) + "  " + "修改"
                    }
                }else {
                    // 用户未输入返利金抵扣...<隐藏修改>
                    if let allValueTotal = desModel.allOrderRebateBalance,allValueTotal.doubleValue > 0 {
                        lblStr = String(format: "共%.2f元，可用%.2f元", allValueTotal.doubleValue, allRebateMoney.doubleValue)
                    }else {
                        // 未返回返利金总额
                        lblStr = String(format: "可用%.2f元", allRebateMoney.doubleValue)
                    }
                }
                let str_h = lblStr.heightForFontAndWidth(UIFont.systemFont(ofSize: WH(12)), width: SCREEN_WIDTH-WH(193), attributes: [NSAttributedString.Key.font.rawValue : UIFont.systemFont(ofSize: WH(12))])
                if str_h > WH(18) {
                    //两行
                    return WH(62)
                }
                return WH(48)
            }else {
                return WH(48)
            }
        }else {
            return WH(44)
        }
    }
}
//MARK:购物金相关逻辑
extension CORebateInputCell {
    func configShopBuyMoneyCell(_ anyModel: Any?, _ isGroupBuy: Bool ,_ fromWhere:Int) {
        if let checkModel = anyModel as? CheckOrderModel{
            lblTitle.text = "使用购物金"
            lblTitle.snp.remakeConstraints { (make) in
                make.left.equalTo(contentView).offset(WH(11))
                make.centerY.equalTo(contentView)
                make.width.equalTo(WH(90))
            }
            btnSwitch.snp.remakeConstraints { (make) in
                make.right.equalTo(contentView).offset(-WH(10))
                make.centerY.equalTo(contentView)
                make.height.equalTo(WH(30))
                make.width.equalTo(WH(40))
            }
            if let allRebateMoney = checkModel.allCanUseGwjBalance,allRebateMoney.doubleValue > 0 {
                //有可用购物金
                lblTitle.isHidden = false
                lblTip.isHidden = true
                var lblStr = ""
                if let allrebateUse = checkModel.allUseGwjBalance,allrebateUse.doubleValue > 0 {
                    // 用户有输入购物金抵扣...<显示修改>
                    lblUse.isHidden = false
                    btnSwitch.isHidden = false  // 开关显示
                    btnSwitch.isSelected = true // 开关打开
                    if let allValueTotal = checkModel.allGwjBalance,allValueTotal.doubleValue > 0 {
                        lblUse.text = String(format: "共%.2f元，已用%.2f元", allValueTotal.doubleValue, allrebateUse.doubleValue)
                    }else {
                        // 未返回购物金总额
                        lblUse.text = String(format: "已用%.2f元", allrebateUse.doubleValue)
                    }
                    let txtMoney: String = lblUse.text!
                    let txtAll = txtMoney + "  " + "修改"
                    lblStr = txtAll
                    let attributedString = NSMutableAttributedString(string: txtAll)
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                  value: RGBColor(0xFF2D5C),
                                                  range: NSMakeRange(0, txtAll.count))
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                  value: RGBColor(0x333333),
                                                  range: NSMakeRange(0, txtMoney.count))
                    lblUse.attributedText = attributedString
                }else {
                    // 用户未输入购物金抵扣...<隐藏修改>
                    lblUse.isHidden = false
                    btnSwitch.isHidden = false      // 开关显示
                    btnSwitch.isSelected = false    // 开关关闭
                    if let allValueTotal = checkModel.allGwjBalance,allValueTotal.doubleValue > 0 {
                        lblUse.text = String(format: "共%.2f元，可用%.2f元", allValueTotal.doubleValue, allRebateMoney.doubleValue)
                    }else {
                        // 未返回购物金总额
                        lblUse.text = String(format: "可用%.2f元", allRebateMoney.doubleValue)
                    }
                    let txtMoney: String = lblUse.text!
                    lblStr = txtMoney
                    let attributedString = NSMutableAttributedString(string: txtMoney)
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                  value: RGBColor(0x333333),
                                                  range: NSMakeRange(0, txtMoney.count))
                    lblUse.attributedText = attributedString
                }
                //两行时修改ui布局
                let str_h = lblStr.heightForFontAndWidth(UIFont.systemFont(ofSize: WH(12)), width: SCREEN_WIDTH-WH(193), attributes: [NSAttributedString.Key.font.rawValue : UIFont.systemFont(ofSize: WH(12))])
                if str_h > WH(18) {
                    //两行
                    lblTitle.snp.remakeConstraints { (make) in
                        make.left.equalTo(contentView).offset(WH(11))
                        make.top.equalTo(contentView).offset(WH(17))
                        make.width.equalTo(WH(90))
                    }
                    btnSwitch.snp.remakeConstraints { (make) in
                        make.right.equalTo(contentView).offset(-WH(10))
                        make.top.equalTo(contentView).offset(WH(9))
                        make.height.equalTo(WH(30))
                        make.width.equalTo(WH(40))
                    }
                }
            }else {
                // 无可用返利金
                lblTitle.isHidden = false
                lblTip.isHidden = false
                lblUse.isHidden = true
                btnSwitch.isHidden = true
                lblTip.text = "暂无购物金可用"
            }
            self.layoutIfNeeded()
            if isGroupBuy == true || fromWhere == 5 {
                self.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.allCorners.rawValue), radius: WH(8))
            }else {
                self.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue), radius: WH(8))
            }
            viewLine.isHidden = true
        }
    }
    //计算高度
    class func calculateSopBuyMoneyViewsHeight(_ model:CheckOrderModel?) -> CGFloat {
        if let desModel = model {
            if let allRebateMoney = desModel.allCanUseGwjBalance,allRebateMoney.doubleValue > 0 {
                var lblStr = ""
                if let allrebateUse = desModel.allUseGwjBalance,allrebateUse.doubleValue > 0 {
                    // 用户有输入购物金抵扣...<显示修改>
                    if let allValueTotal = desModel.allGwjBalance,allValueTotal.doubleValue > 0 {
                        lblStr = String(format: "共%.2f元，已用%.2f元", allValueTotal.doubleValue, allrebateUse.doubleValue) + "  " + "修改"
                    }else {
                        // 未返回购物金总额
                        lblStr = String(format: "已用%.2f元", allrebateUse.doubleValue) + "  " + "修改"
                    }
                }else {
                    // 用户未输入购物金抵扣...<隐藏修改>
                    if let allValueTotal = desModel.allGwjBalance,allValueTotal.doubleValue > 0 {
                        lblStr = String(format: "共%.2f元，可用%.2f元", allValueTotal.doubleValue, allRebateMoney.doubleValue)
                    }else {
                        // 未返回购物金总额
                        lblStr = String(format: "可用%.2f元", allRebateMoney.doubleValue)
                    }
                }
                let str_h = lblStr.heightForFontAndWidth(UIFont.systemFont(ofSize: WH(12)), width: SCREEN_WIDTH-WH(193), attributes: [NSAttributedString.Key.font.rawValue : UIFont.systemFont(ofSize: WH(12))])
                if str_h > WH(18) {
                    //两行
                    return WH(62)
                }
                return WH(48)
            }else {
                return WH(48)
            }
        }
        return 0
    }
}
