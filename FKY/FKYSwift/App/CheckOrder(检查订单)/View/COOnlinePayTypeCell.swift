//
//  COOnlinePayTypeCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  在线支付类型cell

import UIKit

// (二级)在线支付方式
enum COOnlinePayType: Int {
    case aliPay = 0         // 支付宝支付...[payTypeId: 7 or 8]
    case wechatPay = 1      // 微信支付...[payTypeId: 12 or 13 or 14]
    case loanPay = 2        // 1药贷支付...[payTypeId: 17]
    case instalmentPay = 3  // 花呗分期...[payTypeId: 20]
    case agentPay = 4       // 找人代付...[payTypeId: 100]
    case unionPay = 5       // 银联支付...[payTypeId: 9]...[当前支付方式不会返回]
    case shBankQuickPay = 6       // 上海银行快捷支付...[payTypeId: 26]
    /// 花呗支付，payTypeId = 28
    case HuaBei = 7
    case others = 8         // 其它
}


class COOnlinePayTypeCell: UITableViewCell {
    // MARK: - Property
    
    // 选择/取消选择回调
    var selectClosure: ((COOnlinePayType)->())?
    
    // 当前支付方式
    var payType: COOnlinePayType = .aliPay
    
    // 当前支付model
    var payModel: PayTypeItemModel?
    
    // 支付类型图片
    fileprivate lazy var imgviewPay: UIImageView = {
        let imgview = UIImageView()
        imgview.backgroundColor = .clear
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    
    // 名称
    fileprivate lazy var lblName: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "支付宝支付"
        lbl.numberOfLines = 2
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    /// 下方提示文描
    fileprivate lazy var tipLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0xFF2D5C)
        lb.textAlignment = .center
        lb.backgroundColor = RGBColor(0xFFEDE7)
        lb.font = .systemFont(ofSize: WH(11))
        lb.layer.cornerRadius = WH(2)
        lb.layer.masksToBounds = true
        return lb
    }()
    
    // 说明
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .left
        lbl.text = "可前往【我的】申请开通，先买货后付款"
        //lbl.numberOfLines = 2
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    // 选择btn
    fileprivate lazy var btnSelect: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        btn.setImage(UIImage(named: "img_pd_select_select"), for: .selected)
        btn.setImage(UIImage(named: "img_pd_select_none"), for: .disabled)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard strongSelf.btnSelect.isSelected == false else {
                // 若已选中，则再次点击不可取消~!@
                return
            }
            strongSelf.btnSelect.isSelected = true
            guard let block = strongSelf.selectClosure else {
                return
            }
            block(strongSelf.payType)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 顶部分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xE5E5E5)
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
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xFFFFFF)
        
        contentView.addSubview(imgviewPay)
        contentView.addSubview(lblName)
        contentView.addSubview(lblTip)
        contentView.addSubview(btnSelect)
        contentView.addSubview(viewLine)
        contentView.addSubview(self.tipLB)
        
        imgviewPay.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(30))
            make.centerY.equalTo(contentView)
            make.width.equalTo(WH(36))
            make.height.equalTo(WH(36))
        }
        btnSelect.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-WH(10))
            make.centerY.equalTo(contentView)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(55))
        }
        lblName.snp.makeConstraints { (make) in
            make.left.equalTo(imgviewPay.snp.right).offset(WH(13))
            make.right.equalTo(btnSelect.snp.left).offset(-WH(2))
            //make.height.equalTo(WH(30))
            make.centerY.equalTo(contentView)
        }
        self.tipLB.snp_makeConstraints { (make) in
            make.left.equalTo(self.lblName)
            make.top.equalTo(self.lblName.snp_bottom).offset(WH(6))
        }
        lblTip.snp.makeConstraints { (make) in
            make.left.equalTo(lblName)
            make.right.equalTo(btnSelect.snp.left).offset(-WH(2))
            make.top.equalTo(lblName.snp.bottom).offset(-WH(0))
            make.height.equalTo(WH(15))
        }
        viewLine.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(30))
            make.right.equalTo(contentView).offset(-WH(30))
            make.top.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        
        // 初始状态
        lblTip.isHidden = true // 默认隐藏
    }
    
    func isHideTipLB(_ isHide:Bool){
        if isHide {
            self.lblName.snp_remakeConstraints { (make) in
                make.left.equalTo(imgviewPay.snp.right).offset(WH(13))
                make.right.equalTo(btnSelect.snp.left).offset(-WH(2))
                //make.height.equalTo(WH(30))
                make.centerY.equalTo(contentView)
            }
            self.tipLB.isHidden = true
        }else{
            self.lblName.snp_remakeConstraints { (make) in
                make.left.equalTo(imgviewPay.snp.right).offset(WH(13))
                make.right.equalTo(btnSelect.snp.left).offset(-WH(2))
                //make.height.equalTo(WH(30))
                make.top.equalTo(self.imgviewPay.snp_top)
            }
            self.tipLB.isHidden = false
        }
    }
    
    
    // MARK: - Public
    
    func configCell(_ model: PayTypeItemModel, _ selected: Bool) {
        // 保存
        payModel = model
        
        // 名称
        lblName.text = model.payTypeDesc
        
        
        
        // 图片
        if let imgurl = model.picUrl, imgurl.isEmpty == false {
//            imgviewPay.sd_setImage(with: URL.init(string: imgurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: "icon_home_placeholder_image_logo"))
            imgviewPay.sd_setImage(with: URL.init(string: imgurl), placeholderImage: UIImage.init(named: "icon_home_placeholder_image_logo"))
        }
        else {
            imgviewPay.image = UIImage.init(named: "icon_home_placeholder_image_logo")
        }
        
        // 判断是否可用...<默认可用,可点击>
        var canUse = true
        selectionStyle = .default
        if let status = model.payTypeStatus, status.intValue == 1 {
            // 不可用
            canUse = false
            selectionStyle = .none
        }
        
        // 设置勾选按按状态
        showSelectStatus(selected, canUse)
        
        // 说明...<默认不显示>
        if model.payTypeId == 26{
           //快捷支付 payTypeExcDesc用来显示银行信息
             showTipLbl("", canUse)
        }else{
            showTipLbl(model.payTypeExcDesc, canUse)
        }
        self.tipLB.text = " \(model.showMsgInfo)"
        self.isHideTipLB(model.showMsgInfo.isEmpty)
        // 保存支付类型
        guard let type = model.payTypeId else {
            payType = .others
            return
        }
        if type == 7 || type == 8 {
            payType = .aliPay
            if let name = model.payTypeDesc, name.isEmpty == false {
                //
            }
            else {
                lblName.text = "支付宝支付"
            }
        }
        else if type == 12 || type == 13 || type == 14 {
            payType = .wechatPay
            if let name = model.payTypeDesc, name.isEmpty == false {
                //
            }
            else {
                lblName.text = "微信支付"
            }
        }
        else if type == 17 {
            payType = .loanPay
            if let name = model.payTypeDesc, name.isEmpty == false {
                //
            }
            else {
                lblName.text = "1药贷支付"
            }
        }
        else if type == 20 {
            payType = .instalmentPay
            if let name = model.payTypeDesc, name.isEmpty == false {
                //
            }
            else {
                lblName.text = "花呗分期"
            }
        }
        else if type == 100 {
            payType = .agentPay
            if let name = model.payTypeDesc, name.isEmpty == false {
                //
            }
            else {
                lblName.text = "找人代付"
            }
        }
        else if type == 9 {
            payType = .unionPay
            if let name = model.payTypeDesc, name.isEmpty == false {
                //
            }
            else {
                lblName.text = "银联支付"
            }
        }
        else if type == 26 {
            payType = .shBankQuickPay
            if let name = model.payTypeDesc, name.isEmpty == false {
                //
            }
            else {
                lblName.text = "上海银行快捷支付"
            }
        }else if type == 28 {
            payType = .HuaBei
        }
        else {
            // 其它...<不能识别，显示，但不可支付>
            payType = .others
        }
    }
    
    // 花呗分期显示分期详情
    func showAlipayInstalmentInfo(_ model: COAlipayInstallmentItemModel?) {
        // 必须为花呗分期，且当前支付方式已选中
        guard payType == .instalmentPay, btnSelect.isSelected == true else {
            return
        }
        // 已选择了分期项
        guard let obj = model else {
            return
        }
        
        // 显示详情
        lblTip.isHidden = false
        lblTip.textColor = RGBColor(0xFF2D5C)
        lblTip.text = String(format: "分期总金额￥%.2f，手续费￥%.2f", (obj.totalPrinAndFee ?? 0.0), (obj.totalEachFee ?? 0.0))
        
        // 更新约束
        lblName.snp.updateConstraints { (make) in
            make.centerY.equalTo(contentView).offset(-WH(8))
        }
        layoutIfNeeded()
    }
    
    // 底部分隔线是否显示
    func showBottomLine(_ showFlag: Bool) {
        viewLine.isHidden = !showFlag
    }
    
    
    // MARK: - Private
    
    // 选中状态
    func showSelectStatus(_ selected: Bool, _ canUse: Bool) {
        guard canUse else {
            // 不可用
            btnSelect.isEnabled = false
            return
        }
        
        // 可用
        btnSelect.isEnabled = true
        btnSelect.isSelected = selected
    }
    
    // [显示or隐藏]提示文字
    func showTipLbl(_ tip: String?, _ canUse: Bool) {
        // 隐藏
        guard let tip = tip, tip.isEmpty == false else {
            lblTip.text = nil
            lblTip.isHidden = true
            // 更新约束
            self.lblName.snp_remakeConstraints { (make) in
                make.left.equalTo(imgviewPay.snp.right).offset(WH(13))
                make.right.equalTo(btnSelect.snp.left).offset(-WH(2))
                //make.height.equalTo(WH(30))
                make.centerY.equalTo(contentView)
            }
            layoutIfNeeded()
            return
        }
        
        // 显示
        lblTip.text = tip
        lblTip.isHidden = false
        
        // 字体颜色
        if canUse {
            // 可用
            lblTip.textColor = RGBColor(0xFF2D5C)
        }
        else {
            // 不可用
            lblTip.textColor = RGBColor(0x999999)
        }
        
        // 更新约束
        lblName.snp.updateConstraints { (make) in
            make.centerY.equalTo(contentView).offset(-WH(8))
        }
        layoutIfNeeded()
    }
}
