//
//  COProductCouponCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商品优惠券cell

import UIKit

class COProductCouponCell: UITableViewCell {
    // MARK: - Property
    
    // 选择/取消选择回调
    var selectClosure: ((Bool)->())?
    // 选择(使用)优惠券回调
    var useCouponClosure: (()->())?
    // (无可用优惠券时)跳转优惠券列表回调
    var seeCouponDetailClosure: (()->())?
    
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
        lbl.text = "店铺优惠券"
        return lbl
    }()
    
    // (无可用优惠券时)查看优惠券btn
    fileprivate lazy var btnCoupon: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.seeCouponDetailClosure else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    //  箭头
    fileprivate lazy var imgviewArrowTop: UIImageView = {
        let imgview = UIImageView()
        imgview.image = UIImage.init(named: "img_checkorder_arrow")
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    
    // 无优惠券可用时的提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .right
        lbl.text = "无可用店铺优惠券"
        return lbl
    }()
    
    // 选择btn
    fileprivate lazy var btnSelect: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        btn.setImage(UIImage(named: "img_pd_select_select"), for: .selected)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            print("优惠券btn")
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
        lbl.font = t8.font
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .left
        lbl.text = "当前可用店铺优惠券"
        return lbl
    }()
    
    // coupon提示
    fileprivate lazy var lblCouponTip: UILabel = {
        let lbl = UILabel()
        lbl.font = t27.font
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .center
        //lbl.text = " 已选1张 "
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = WH(3)
        lbl.layer.borderWidth = WH(1)
        lbl.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        return lbl
    }()
    

    
    // coupon内容
    fileprivate lazy var txtfieldContent: UITextField = {
        let txtfield = UITextField()
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.textAlignment = .right
        txtfield.font = UIFont.boldSystemFont(ofSize: WH(13))
        txtfield.textColor = RGBColor(0xFF2D5C)
        txtfield.placeholder = "请选择优惠券" 
        //txtfield.setValue(RGBColor(0x999999), forKeyPath: "_placeholderLabel.textColor")
        //txtfield.setValue(UIFont.systemFont(ofSize: WH(13)), forKeyPath: "_placeholderLabel.font")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "请选择优惠券", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(13)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        txtfield.isEnabled = false // 不可激活
        return txtfield
    }()
    
    //  箭头
    fileprivate lazy var imgviewArrow: UIImageView = {
        let imgview = UIImageView()
        imgview.image = UIImage.init(named: "img_checkorder_arrow")
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    
    // 内容btn...<点击进入优惠券选择界面>
    fileprivate lazy var btnContent: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            print("点击进入优惠券选择界面")
            guard let block = strongSelf.useCouponClosure else {
                return
            }
            block()
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
        
        contentView.addSubview(viewTop)
        contentView.addSubview(viewBottom)
        contentView.addSubview(viewLine)
        
        viewTop.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(WH(44))
        }
        viewBottom.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(viewTop.snp.bottom)
            make.height.equalTo(WH(44))
        }
        viewLine.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(11))
            make.right.equalTo(contentView).offset(-WH(11))
            make.bottom.equalTo(contentView)
            make.height.equalTo(0.8)
        }
        
        viewTop.addSubview(lblTitle)
        viewTop.addSubview(btnCoupon)
        viewTop.addSubview(imgviewArrowTop)
        viewTop.addSubview(lblTip)
        viewTop.addSubview(btnSelect)
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(viewTop).offset(WH(11))
            make.centerY.equalTo(viewTop)
        }
        btnCoupon.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(viewTop)
            make.left.equalTo(lblTitle.snp.right).offset(WH(80))
        }
        imgviewArrowTop.snp.makeConstraints { (make) in
            make.right.equalTo(viewTop).offset(WH(-11))
            make.centerY.equalTo(viewTop)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        lblTip.snp.makeConstraints { (make) in
            //make.right.equalTo(viewTop).offset(WH(-10))
            make.right.equalTo(imgviewArrowTop.snp.left).offset(WH(-10)) // 右边加箭头
            make.centerY.equalTo(viewTop)
        }
        btnSelect.snp.makeConstraints { (make) in
            make.right.equalTo(viewTop).offset(WH(-10))
            make.centerY.equalTo(viewTop)
            make.size.equalTo(CGSize.init(width: WH(30), height: WH(30)))
        }
        
        // 当冲突时，lblTitle不被拉伸，btnCoupon可以被拉伸
        // 当前lbl抗压缩（不想变小）约束的优先级高
        lblTitle.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗压缩（不想变小）约束的优先级低
        btnCoupon.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        // 当冲突时，lblTitle不被拉伸，btnCoupon可以被拉伸
        // 当前lbl抗压缩（不想变小）约束的优先级高
        lblTitle.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗压缩（不想变小）约束的优先级低
        btnCoupon.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        viewBottom.addSubview(lblCouponTitle)
        viewBottom.addSubview(lblCouponTip)
        viewBottom.addSubview(txtfieldContent)
        viewBottom.addSubview(imgviewArrow)
        viewBottom.addSubview(btnContent)
        
        lblCouponTitle.snp.makeConstraints { (make) in
            make.left.equalTo(viewBottom).offset(WH(11))
            make.centerY.equalTo(viewBottom)
        }
        lblCouponTip.snp.makeConstraints { (make) in
            make.left.equalTo(lblCouponTitle.snp.right).offset(WH(10))
            make.centerY.equalTo(viewBottom)
            make.height.equalTo(WH(20))
            make.width.equalTo(WH(56)) // 初始宽度
        }
        imgviewArrow.snp.makeConstraints { (make) in
            make.right.equalTo(viewBottom).offset(WH(-11))
            make.centerY.equalTo(viewBottom)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        txtfieldContent.snp.makeConstraints { (make) in
            make.left.equalTo(lblCouponTip.snp.right).offset(WH(10))
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
        //lblCouponTip.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        // 当前lbl抗拉伸（不想变大）约束的优先级低
        txtfieldContent.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        // 当冲突时，lblCouponTitle不被拉伸，txtfieldContent可以被拉伸
        // 当前lbl抗压缩（不想变小）约束的优先级高
        lblCouponTitle.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        //lblCouponTip.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        // 当前lbl抗压缩（不想变小）约束的优先级低
        txtfieldContent.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        // 默认隐藏
        lblTip.isHidden = true
        imgviewArrowTop.isHidden = true
        btnCoupon.isHidden = true
        
        self.clipsToBounds = true
    }
    
    
    // MARK: - Public
    
    // isGroupBuy 一起购标识
    // selected 本地保存的选中状态
    func configCell(_ shopOrder: COSupplyOrderModel, _ selected: Bool) {
        // 保存
        shopOrderModel = shopOrder
        
        // 不可用券
        if let allTJ = shopOrder.isAllMutexTeJia, allTJ == 1 {
            // 订单中全部商品均为不可用券特价商品
            showStatusForNoCoupon(shopOrder.noSelectCoupon4MutexTeJia)
            return
        }
        
        // 可用券，但无券可用
        guard let shopCouponModel = shopOrder.shopCouponInfoVO , let hasCoupon = shopCouponModel.hasAvailableCoupon, hasCoupon == true else {
            // 无可用优惠券
            showStatusForNoCoupon(shopOrder.shopCouponInfoVO?.noAvailableCouponTxt)
            return
        }
        
        // 有可用优惠券
        showStatusForHasCoupon(selected)
    }
    
    
    // MARK: - Private
    
    // 底部视图显示or隐藏
    func showBottomView(_ showFlag: Bool) {
        viewBottom.isHidden = !showFlag
    }
    
    // [显示or隐藏]优惠券已选提示标签
    func showCouponTip(_ content: String?, _ showFlag: Bool) {
        // 隐藏
        guard let content = content, content.isEmpty == false else {
            lblCouponTip.text = nil
            lblCouponTip.isHidden = true
            // 更新约束
            lblCouponTip.snp.updateConstraints { (make) in
                make.width.equalTo(0)
            }
            layoutIfNeeded()
            return
        }
        
        guard showFlag else {
            lblCouponTip.text = nil
            lblCouponTip.isHidden = true
            // 更新约束
            lblCouponTip.snp.updateConstraints { (make) in
                make.width.equalTo(0)
            }
            layoutIfNeeded()
            return
        }
        
        // 显示
        lblCouponTip.text = content
        lblCouponTip.isHidden = false
        
        // 计算lbl宽度
        let width = COProductItemCell.calculateStringWidth(content, UIFont.systemFont(ofSize: WH(12)), WH(18))
        // 更新约束
        lblCouponTip.snp.updateConstraints { (make) in
            make.width.equalTo(width + WH(8))
        }
        layoutIfNeeded()
    }
    
    // 无可用优惠券时的展示逻辑
    fileprivate func showStatusForNoCoupon(_ tip: String?) {
        lblTip.text = tip ?? "无可用店铺优惠券"
        btnSelect.isHidden = true           // 勾选隐藏
        lblTip.isHidden = false             // 提示显示
        imgviewArrowTop.isHidden = false    // 箭头显示
        btnCoupon.isHidden = false          // btn显示
        showBottomView(false)               // 不展开
    }
    
    // 有可用优惠券时的展示逻辑
    fileprivate func showStatusForHasCoupon(_ selected: Bool) {
        btnSelect.isHidden = false      // 勾选显示
        lblTip.isHidden = true          // 提示隐藏
        imgviewArrowTop.isHidden = true // 箭头隐藏
        btnCoupon.isHidden = true       // btn隐藏
        
        // 显示优惠券使用情况
        guard let model = shopOrderModel,let couponModel = model.shopCouponInfoVO else {
            // error
            showCouponTip(nil, false)
            txtfieldContent.text = nil
            return
        }
        
        //if let number = model.checkCouponNum, number > 0 {
        if let code = model.checkCouponCodeStr, code.isEmpty == false {
            // 有使用优惠券，需勾选
            
            // 展开
            showBottomView(true)
            // 必勾选
            btnSelect.isSelected = true
            
            // 优惠券已选个数
            if let couponUseNumber = couponModel.checkCouponNum, couponUseNumber > 0 {
                let content = String(format: "已选%d张", couponUseNumber)
                showCouponTip(content, true)
            }
            else {
                showCouponTip(nil, false)
            }
            
            // 优惠金额
            var couponValue: Double = 0.00
           // var pCouponValue: Double = 0.00
            if let couponMoney = model.orderCouponMoney, couponMoney.doubleValue > 0 {
                couponValue = couponMoney.doubleValue
            }
//            if let pCouponMoney = model.orderPlatformCouponMoney, pCouponMoney.doubleValue > 0 {
//                pCouponValue = pCouponMoney.doubleValue
//            }
            txtfieldContent.text = String(format: "优惠%.2f元", couponValue)
        }
        else {
            // 未使用优惠券
            
            //if model.productCouponSelected {
            if selected {
                // 已勾选，已展开
                
                // 展开
                showBottomView(true)
                // 已勾选
                btnSelect.isSelected = true
                // 优惠券已选个数为0...<不显示>
                showCouponTip(nil, false)
                // 无优惠金额
                txtfieldContent.text = nil
            }
            else {
                // 未勾选，未展开
                
                // 不展开
                showBottomView(false)
                // 未勾选
                btnSelect.isSelected = false
                // 优惠券已选个数为0...<不显示>
                showCouponTip(nil, false)
                // 无优惠金额
                txtfieldContent.text = nil
            }
        }
    }
}

