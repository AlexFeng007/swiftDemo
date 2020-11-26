//
//  COPlatformCouponCell.swift
//  FKY
//
//  Created by yyc on 2020/2/16.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class COPlatformCouponCell: UITableViewCell {
    // MARK: - Property
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "平台优惠券"
        return lbl
    }()
    // coupon标题
    fileprivate lazy var lblCouponTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = t8.font
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .left
        lbl.text = "当前可用平台优惠券"
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
    
    // 无优惠券可用时的提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .right
        lbl.text = "无可用平台优惠券"
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
            guard let block = strongSelf.useCouponClosure else {
                return
            }
            block()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 下分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xEBEDEC)
        return view
    }()
    
    // 选择(使用)优惠券回调
    var useCouponClosure: (()->())?
    
    // 商家订单model
    var shopOrderModel: COSupplyOrderModel?
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
extension COPlatformCouponCell {
    fileprivate func setupView() {
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(11))
            make.right.equalTo(contentView).offset(-WH(11))
            make.top.equalTo(contentView).offset(WH(18))
            make.height.equalTo(WH(13))
        }
        contentView.addSubview(lblCouponTitle)
        lblCouponTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(11))
            make.top.equalTo(lblTitle.snp.bottom).offset(WH(10))
            make.height.equalTo(WH(13))
        }
        
        contentView.addSubview(lblCouponTip)
        lblCouponTip.snp.makeConstraints { (make) in
            make.left.equalTo(lblCouponTitle.snp.right).offset(WH(10))
            make.centerY.equalTo(lblCouponTitle)
            make.height.equalTo(WH(20))
            make.width.equalTo(WH(56)) // 初始宽度
        }
        contentView.addSubview(imgviewArrow)
        imgviewArrow.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(WH(-11))
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        contentView.addSubview(lblTip)
        lblTip.snp.makeConstraints { (make) in
            make.left.equalTo(lblCouponTitle.snp.right).offset(WH(10))
            make.right.equalTo(imgviewArrow.snp.left).offset(WH(-10)) // 右边加箭头
            make.centerY.equalTo(imgviewArrow)
        }
        
        contentView.addSubview(txtfieldContent)
        txtfieldContent.snp.makeConstraints { (make) in
            make.left.equalTo(lblCouponTip.snp.right).offset(WH(10))
            make.right.equalTo(imgviewArrow.snp.left).offset(-WH(10))
            make.centerY.equalTo(imgviewArrow)
            make.height.equalTo(WH(14))
        }
        contentView.addSubview(btnContent)
        btnContent.snp.makeConstraints { (make) in
            make.left.equalTo(lblCouponTitle.snp.right).offset(WH(20))
            make.right.top.bottom.equalTo(contentView)
        }
        // 当冲突时，lblCouponTitle不被拉伸，txtfieldContent可以被拉伸
        // 当前lbl抗压缩（不想变小）约束的优先级高
        lblCouponTitle.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        //lblCouponTip.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        // 当前lbl抗压缩（不想变小）约束的优先级低
        txtfieldContent.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView)
            make.left.equalTo(contentView.snp.left).offset(WH(10))
            make.right.equalTo(contentView.snp.right).offset(-WH(10))
            make.height.equalTo(0.8)
        }
        
    }
}
extension COPlatformCouponCell {
    func configCOPlatformCouponCellData(_ orderModel:CheckOrderModel?,_ platformCode:String?) {
        self.isHidden = true
        if let model = orderModel {
            self.isHidden = false
            //            if model.shareRebate == "1" {
            //                //有共享返利金
            //                viewLine.isHidden = false
            //                self.layoutIfNeeded()
            //                self.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), radius: WH(8))
            //            }else {
            //                viewLine.isHidden = true
            //                self.layoutIfNeeded()
            //                self.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.allCorners.rawValue), radius: WH(8))
            //            }
            if model.hasZiyingStatus == 1 || model.shareRebate == "1" {
                //有共享返利金或者购物金
                viewLine.isHidden = false
                self.layoutIfNeeded()
                self.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), radius: WH(8))
            }else {
                viewLine.isHidden = true
                self.layoutIfNeeded()
                self.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.allCorners.rawValue), radius: WH(8))
            }
            
            
            // 可用券，但无券可用
            guard let platformCouponModel = model.platformCouponInfo , let hasCoupon = platformCouponModel.hasAvailableCoupon, hasCoupon == true else {
                // 无可用平台优惠券
                lblCouponTip.isHidden = true
                lblCouponTitle.isHidden = true
                txtfieldContent.isHidden = true
                lblTip.isHidden = false
                lblTip.text = model.platformCouponInfo?.noAvailableCouponTxt ?? "无可用平台优惠券"
                return
            }
            if let str = platformCode,str.count > 0 {
                //有选中平台券
                lblCouponTip.isHidden = false
                txtfieldContent.isHidden = false
                lblCouponTitle.isHidden = false
                lblTip.isHidden = true
                lblCouponTip.text = "已选\(platformCouponModel.checkCouponNum ?? 0)张"
                let _ = lblCouponTip.adjustTagLabelContentInset(WH(8))
                var pCouponValue: Double = 0.00
                if let pCouponMoney = model.allPlatformCouponMoney, pCouponMoney.doubleValue > 0 {
                    pCouponValue = pCouponMoney.doubleValue
                }
                txtfieldContent.text = String(format: "优惠%.2f元",pCouponValue)
            }else {
                //没有选择的平台券
                lblCouponTip.isHidden = true
                txtfieldContent.isHidden = false
                txtfieldContent.text = ""
                lblTip.isHidden = true
                lblCouponTitle.isHidden = true
            }
        }
        
    }
}
