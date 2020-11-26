//
//  COMoneyTypeCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  金额相关cell...<包括：商品金额、立减、使用返利金抵扣、店铺优惠券、平台优惠券、运费、订单完成后可获取返利金>

import UIKit

class COMoneyTypeCell: UITableViewCell {
    // MARK: - Property
    
    // 规则说明回调
    var detailClosure: ((FKYCOItemType)->())?
    
    // cell类型
    fileprivate var cellType: FKYCOItemType = .productAmount
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        //lbl.text = "商品金额"
        return lbl
    }()
    
    // 内容
    fileprivate lazy var lblContent: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .right
        //lbl.text = "¥ 2254.08"
        return lbl
    }()
    
    // 详情btn
    fileprivate lazy var btnDetail: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage.init(named: "img_checkorder_fright"), for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.detailClosure else {
                return
            }
            block(strongSelf.cellType)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
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
        
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblContent)
        contentView.addSubview(btnDetail)
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(11))
            make.centerY.equalTo(contentView)
        }
        lblContent.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(WH(-11))
            make.centerY.equalTo(contentView)
        }
        btnDetail.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(-WH(12))
            make.centerY.equalTo(contentView)
            make.width.equalTo(WH(50))
            make.height.equalTo(WH(30))
        }
        
        // 默认隐藏
        btnDetail.isHidden = true
    }
    
    
    // MARK: - Public
    
    func configCell(_ content: String?, _ type: FKYCOItemType, _ groupBuy: Bool) {
        layer.mask = nil
        cellType = type
        setTitle(type)
        setContent(content, type)
        setShowOrHideStatus(content, type)
        resetDetailBtnStatus(type, groupBuy)
    }
    
    
    // MARK: - Private
    
    // 标题
    fileprivate func setTitle(_ type: FKYCOItemType) {
        // 默认隐藏
        btnDetail.isHidden = true
        
        switch type {
        case .productAmount:
            lblTitle.text = "商品金额"
        case .discountAmount:
            lblTitle.text = "立减"
        case .rebateMoney:
            lblTitle.text = "店铺返利金抵扣"
        case .rebatePlatformMoney:
            lblTitle.text = "平台返利金抵扣"
        case .shopCouponMoney:
            lblTitle.text = "店铺优惠券"
        case .allShopBuyMoney:
            lblTitle.text = "使用购物金"
        case .platformCouponMoney:
            lblTitle.text = "平台优惠券"
        case .freight:
            lblTitle.text = "运费"
            btnDetail.isHidden = false
        case .getRebate:
            lblTitle.text = "订单完成后可获返利金"
            btnDetail.isHidden = false
        default:
            break
        }
    }
    
    // 内容
    fileprivate func setContent(_ content: String?, _ type: FKYCOItemType) {
        // 内容
        lblContent.text = content
        
        // 样式
        switch type {
        case .productAmount:
            // 商品金额为黑
            lblContent.textColor = RGBColor(0x000000)
            lblContent.font = UIFont.boldSystemFont(ofSize: WH(16))
        default:
            // 其它为红
            lblContent.textColor = RGBColor(0x333333)
            lblContent.font = UIFont.systemFont(ofSize: WH(14))
        }
    }
    
    // 显示or隐藏
    // 说明：【商品金额、运费、订单完成后可获返利金】这三项不管有无值需一直显示；其它项无值时不显示
    fileprivate func setShowOrHideStatus(_ content: String?, _ type: FKYCOItemType) {
        if type == .freight || type == .getRebate {
            // 运费/订单完成后可获返利金
            btnDetail.isHidden = false
        }
        else {
            // 商品金额
            btnDetail.isHidden = true
        }
    }
    
    // 一起购逻辑: 运费旁边不显示详情提示按钮
    fileprivate func resetDetailBtnStatus(_ type: FKYCOItemType, _ groupBuy: Bool) {
        switch type {
        case .freight, .getRebate:
            // 运费/订单完成后可获返利金
            if groupBuy {
                btnDetail.isHidden = true
            }
            else {
                btnDetail.isHidden = false
            }
        default:
            // 其它
            btnDetail.isHidden = true
        }
    }
    
    
    //加圆角
    func addCellCorners() {
        layoutIfNeeded()
        self.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), radius: WH(10))
    }
}
