//
//  COCouponCodeCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  优惠券码cell

import UIKit

class COCouponCodeCell: UITableViewCell, UITextFieldDelegate {
    // MARK: - Property
    
    // 商品优惠券说明回调
    var couponDetailClosure: (()->())?
    // 选择/取消选择回调
    var selectClosure: ((Bool)->())?
    // 激活输入框回调
    var inputClosure: (()->())?
    
    // 商家订单model
    var shopOrderModel: COSupplyOrderModel?
    
    /*****************************************/
    
    // 顶部内容视图
    fileprivate lazy var viewTop: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "优惠码"
        return lbl
    }()
    
    // 详情btn...<商品优惠券与优惠券码不可同时使用的提示>
    fileprivate lazy var btnDetail: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage.init(named: "img_checkorder_fright"), for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.couponDetailClosure else {
                return
            }
            block()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 不可用优惠码时的提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .right
        lbl.text = "本单暂无可用优惠码"
        return lbl
    }()
    
    // 选择btn
    fileprivate lazy var btnSelect: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        btn.setImage(UIImage(named: "img_pd_select_select"), for: .selected)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.btnSelect.isSelected = !(strongSelf.btnSelect.isSelected)
            guard let block = strongSelf.selectClosure else {
                return
            }
            block(strongSelf.btnSelect.isSelected)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    /*****************************************/
    
    // 底部内容视图
    fileprivate lazy var viewBottom: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    
    // coupon标题
    fileprivate lazy var lblCouponTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "当前使用优惠码"
        return lbl
    }()
    
    
    // coupon内容
    fileprivate lazy var txtfieldContent: UITextField = {
        let txtfield = UITextField()
        txtfield.delegate = self
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.textAlignment = .right
        txtfield.keyboardType = .asciiCapable
        txtfield.returnKeyType = .done
        txtfield.font = UIFont.boldSystemFont(ofSize: WH(13))
        txtfield.textColor = RGBColor(0xFF2D5C)
        //txtfield.clearButtonMode = .whileEditing
        txtfield.autocapitalizationType = .none
        txtfield.autocorrectionType = .no
        txtfield.placeholder = "请填写优惠码"
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "请填写优惠码", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(13)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        //txtfield.isEnabled = false // 不可激活
        return txtfield
    }()
    
    //  箭头
    fileprivate lazy var imgviewArrow: UIImageView = {
        let imgview = UIImageView()
        imgview.image = UIImage.init(named: "img_checkorder_arrow")
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    
    // 内容btn...<点击弹出输入视图>
    fileprivate lazy var btnContent: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            print("点击弹出输入视图")
            strongSelf.txtfieldContent.becomeFirstResponder()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    /*****************************************/
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        addSubview(viewTop)
        addSubview(viewBottom)
        addSubview(viewLine)
        
        viewTop.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(WH(44))
        }
        viewBottom.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(viewTop.snp.bottom)
            make.height.equalTo(WH(44))
        }
        viewLine.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(11))
            make.right.equalTo(self).offset(-WH(11))
            make.bottom.equalTo(self)
            make.height.equalTo(0.8)
        }
        
        viewTop.addSubview(lblTitle)
        viewTop.addSubview(btnDetail)
        viewTop.addSubview(lblTip)
        viewTop.addSubview(btnSelect)
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(viewTop).offset(WH(11))
            make.centerY.equalTo(viewTop)
        }
        btnDetail.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(-WH(12))
            make.centerY.equalTo(viewTop)
            make.width.equalTo(WH(50))
            make.height.equalTo(WH(30))
        }
        lblTip.snp.makeConstraints { (make) in
            make.right.equalTo(viewTop).offset(WH(-11))
            make.centerY.equalTo(viewTop)
        }
        btnSelect.snp.makeConstraints { (make) in
            make.right.equalTo(viewTop).offset(WH(-10))
            make.centerY.equalTo(viewTop)
            make.size.equalTo(CGSize.init(width: WH(30), height: WH(30)))
        }
        
        viewBottom.addSubview(lblCouponTitle)
        viewBottom.addSubview(txtfieldContent)
        viewBottom.addSubview(imgviewArrow)
        viewBottom.addSubview(btnContent)
        
        lblCouponTitle.snp.makeConstraints { (make) in
            make.left.equalTo(viewBottom).offset(WH(11))
            make.centerY.equalTo(viewBottom)
        }
        imgviewArrow.snp.makeConstraints { (make) in
            make.right.equalTo(viewBottom).offset(WH(-11))
            make.centerY.equalTo(viewBottom)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        txtfieldContent.snp.makeConstraints { (make) in
            make.left.equalTo(lblCouponTitle.snp.right).offset(WH(20))
            make.right.equalTo(imgviewArrow.snp.left).offset(-WH(10))
            make.centerY.equalTo(viewBottom)
        }
        btnContent.snp.makeConstraints { (make) in
            make.left.equalTo(lblCouponTitle.snp.right).offset(WH(20))
            make.right.top.bottom.equalTo(viewBottom)
        }
        
        // 当冲突时，lblCouponTitle不被压缩，txtfieldContent可以被压缩
        // 当前lbl抗拉伸（不想变大）约束的优先级高 UILayoutPriority
        lblCouponTitle.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗拉伸（不想变大）约束的优先级低
        txtfieldContent.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        // 当冲突时，lblCouponTitle不被拉伸，txtfieldContent可以被拉伸
        // 当前lbl抗压缩（不想变小）约束的优先级高
        lblCouponTitle.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗压缩（不想变小）约束的优先级低
        txtfieldContent.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        self.clipsToBounds = true
    }
    
    
    // MARK: - Public
    
    // showFlag 当前cell是否显示
    // selected 本地保存的选中状态
    func configCell(_ shopOrder: COSupplyOrderModel, _ selected: Bool) {
        // 保存
        shopOrderModel = shopOrder
        if let supplyType  = shopOrder.supplyType , supplyType == 1 {
            //MP隐藏
            btnDetail.isHidden =  true
        }else {
            btnDetail.isHidden =  false
        }
        txtfieldContent.text = nil
        
        // 不可用券
        if let allTJ = shopOrder.isAllMutexTeJia, allTJ == 1 {
            // 订单中全部商品均为不可用券特价商品
            showStatusForNoCoupon(shopOrder.noSelectCouponCode4MutexTeJia)
            return
        }
        
        // 可用券
        showStatusForHasCoupon(selected)
    }
    
    
    // MARK: - Private
    
    // 底部视图显示or隐藏
    fileprivate func showBottomView(_ showFlag: Bool) {
        viewBottom.isHidden = !showFlag
    }
    
    // 无可用优惠码时的展示逻辑
    fileprivate func showStatusForNoCoupon(_ tip: String?) {
        lblTip.text = tip ?? "无可用优惠码"
        btnSelect.isHidden = true   // 勾选隐藏
        lblTip.isHidden = false     // 提示显示
        showBottomView(false)       // 不展开
    }
    
    // 有可用优惠码时的展示逻辑
    fileprivate func showStatusForHasCoupon(_ selected: Bool) {
        btnSelect.isHidden = false  // 勾选显示
        lblTip.isHidden = true      // 提示隐藏
        
        // 显示优惠券使用情况
        guard let model = shopOrderModel else {
            // error
            txtfieldContent.text = nil
            return
        }
        
        if let content = model.showCouponCode, content.isEmpty == false {
            // 有使用优惠码，需勾选
            
            // 展开
            showBottomView(true)
            // 必勾选
            btnSelect.isSelected = true
            
            // 满减金额
            var couponValue: Double = 0.00
            var pCouponValue: Double = 0.00
            if let couponMoney = model.couponSum, couponMoney.isEmpty == false, let value = Double(couponMoney), value > 0 {
                couponValue = value
            }
            if let pCouponMoney = model.allOrderShareCouponMoneyTotal, pCouponMoney.doubleValue > 0 {
                pCouponValue = pCouponMoney.doubleValue
            }
            if couponValue > 0, pCouponValue > 0 {
                txtfieldContent.text = String(format: "满%.2f减%.2f", couponValue, pCouponValue)
            }
            else {
                // error
                txtfieldContent.text = nil
            }
        }
        else {
            // 未使用优惠码
            
            //if model.couponCodeSelected {
            if selected {
                // 已勾选，已展开
                
                // 展开
                showBottomView(true)
                // 未勾选
                btnSelect.isSelected = true
                // 无优惠金额
                txtfieldContent.text = nil
            }
            else {
                // 未勾选，未展开
                
                // 不展开
                showBottomView(false)
                // 未勾选
                btnSelect.isSelected = false
                // 无优惠金额
                txtfieldContent.text = nil
            }
        }
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // 输入框激活，需弹出定制的输入视图
        if let closure = inputClosure {
            closure()
        }
        return false
    }
}
