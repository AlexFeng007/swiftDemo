//
//  COProductItemCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  单个商品cell

import UIKit

class COProductItemCell: UITableViewCell {
    // MARK: - Property
    
    // 商品图片
    fileprivate lazy var imgviewProduct: UIImageView = {
        let imgview = UIImageView()
        imgview.backgroundColor = .clear
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    
    // vip标签 30*15
    fileprivate lazy var vipTag: UILabel = {
        let lbl = UILabel()
        lbl.frame = CGRect(x: 0, y: WH(4), width: WH(30), height:WH(15))
        lbl.text = "会员"
        lbl.font = t28.font
        lbl.textColor = RGBColor(0xFFDEAE)
        lbl.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0x566771), RGBColor(0x182F4C), WH(30))
        lbl.textAlignment = .center
        FKYTogeterNowTabCell.cornerView(byRoundingCorners: [.topRight , .bottomRight], radii: WH(15)/2.0, lbl)
        return lbl
    }()
    
    // 特价标签 30*30
    fileprivate lazy var imgviewSpecialPrice: UIImageView = {
        let imgview = UIImageView()
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        imgview.image = UIImage.init(named: "icon_tj")
        return imgview
    }()
    
    // 换购标签 24*13
    fileprivate lazy var imgviewChangeBuy: UIImageView = {
        let imgview = UIImageView()
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        imgview.image = UIImage.init(named: "icon_increasePriceGifts")
        return imgview
    }()
    
    // 商品名称
    fileprivate lazy var lblName: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x000000)
        lbl.textAlignment = .left
        //lbl.text = "三九/999 感冒灵颗粒 三九/999 感冒灵颗粒"
        return lbl
    }()
    
    // 规格
    fileprivate lazy var lblSpec: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .left
        //lbl.text = "2000u:700u*10粒*3板"
        return lbl
    }()
    
    // 有效期
    fileprivate lazy var lblDate: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .left
        //lbl.text = "有效期：2020-05-31"
        return lbl
    }()
    
    // 价格
    fileprivate lazy var lblPrice: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x000000)
        lbl.textAlignment = .right
        //lbl.text = "¥ 33.95"
        return lbl
    }()
    
    // 实付金额
    fileprivate lazy var lblPay: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .right
        //lbl.text = "¥ 33.95"
        return lbl
    }()
    
    // 数量
    fileprivate lazy var lblNumber: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .right
        lbl.text = "x2"
        return lbl
    }()
    
    // 预计返利...<打标>
    fileprivate lazy var lblRebate: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(10))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .center
        //lbl.text = "预计返利 ￥2.4"
        lbl.layer.borderWidth = 0.5
        lbl.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = WH(2)
        return lbl
    }()
    
    // (特价商品or其它情况)不可用券...<打标>
    fileprivate lazy var lblSpecialTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(10))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .center
        lbl.text = "不可用券"
        lbl.layer.borderWidth = 0.5
        lbl.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = WH(2)
        return lbl
    }()
    
    // 需调拨发货...<打标>
    fileprivate lazy var lblShareStock: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(10))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .center
        lbl.text = "调拨中"
        lbl.layer.borderWidth = 0.5
        lbl.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = WH(2)
        return lbl
    }()
    
    // 协议返利金...<打标>
    fileprivate lazy var lblProtocolRebate: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(10))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .center
        lbl.text = "协议奖励金"
        lbl.layer.borderWidth = 0.5
        lbl.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = WH(2)
        return lbl
    }()
    
    
    // 底部分隔线
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
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xF4F4F4)
        
        contentView.addSubview(imgviewProduct)
        contentView.addSubview(imgviewSpecialPrice)
        contentView.addSubview(imgviewChangeBuy)
        contentView.addSubview(lblName)
        contentView.addSubview(lblSpec)
        contentView.addSubview(lblDate)
        contentView.addSubview(lblPrice)
        contentView.addSubview(lblPay)
        contentView.addSubview(lblNumber)
        contentView.addSubview(lblRebate)
        contentView.addSubview(lblSpecialTip)
        contentView.addSubview(lblShareStock)
        contentView.addSubview(lblProtocolRebate)
        contentView.addSubview(viewLine)
        
        imgviewProduct.addSubview(vipTag)
        
        imgviewProduct.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(15))
            make.centerY.equalTo(contentView)
            make.width.equalTo(WH(80))
            make.height.equalTo(WH(80))
        }
        imgviewSpecialPrice.snp.makeConstraints { (make) in
            make.left.top.equalTo(imgviewProduct)
            make.width.equalTo(WH(30))
            make.height.equalTo(WH(30))
        }
        imgviewChangeBuy.snp.makeConstraints { (make) in
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(10))
            make.top.equalTo(contentView).offset(WH(20))
            make.width.equalTo(WH(24))
            make.height.equalTo(WH(13))
        }
        lblPrice.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-WH(12))
            make.centerY.equalTo(imgviewChangeBuy)
            make.height.equalTo(WH(20))
            make.width.lessThanOrEqualTo(WH(80)) //
        }
        lblName.snp.makeConstraints { (make) in
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(40))
            make.right.equalTo(lblPrice.snp.left).offset(-WH(10))
            make.centerY.equalTo(imgviewChangeBuy)
            make.height.equalTo(WH(20))
        }
        lblPay.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-WH(12))
            make.top.equalTo(lblPrice.snp.bottom)
            make.height.equalTo(WH(20))
        }
        lblSpec.snp.makeConstraints { (make) in
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(10))
            make.right.equalTo(lblPay).offset(-WH(10))
            make.centerY.equalTo(lblPay)
            make.height.equalTo(WH(20))
        }
        lblDate.snp.makeConstraints { (make) in
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(10))
            make.right.equalTo(contentView).offset(-WH(10))
            make.top.equalTo(lblSpec.snp.bottom).offset(WH(10))
            make.height.equalTo(WH(15))
        }
        lblNumber.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-WH(12))
            make.centerY.equalTo(lblDate)
            make.height.equalTo(WH(20))
        }
        lblRebate.snp.makeConstraints { (make) in
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(10))
            make.top.equalTo(lblDate.snp.bottom).offset(WH(6))
            make.height.equalTo(WH(16))
            make.width.equalTo(WH(80))
        }
        lblSpecialTip.snp.makeConstraints { (make) in
            make.left.equalTo(lblRebate.snp.right).offset(WH(7))
            make.top.equalTo(lblDate.snp.bottom).offset(WH(6))
            make.height.equalTo(WH(16))
            make.width.equalTo(WH(46))
        }
        lblShareStock.snp.makeConstraints { (make) in
            make.left.equalTo(lblSpecialTip.snp.right).offset(WH(7))
            make.top.equalTo(lblDate.snp.bottom).offset(WH(6))
            make.height.equalTo(WH(16))
            make.width.equalTo(WH(36))
        }
        lblProtocolRebate.snp.makeConstraints { (make) in
            make.left.equalTo(lblShareStock.snp.right).offset(WH(7))
            make.top.equalTo(lblDate.snp.bottom).offset(WH(6))
            make.height.equalTo(WH(16))
            make.width.equalTo(WH(56))
        }
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        
        // 当冲突时，lblPrice不被压缩，lblName可以被压缩
        // 当前lbl抗拉伸（不想变大）约束的优先级高 UILayoutPriority
        lblPrice.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗拉伸（不想变大）约束的优先级低
        lblName.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        // 当冲突时，lblPrice不被拉伸，lblName可以被拉伸
        // 当前lbl抗压缩（不想变小）约束的优先级高
        lblPrice.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗压缩（不想变小）约束的优先级低
        lblName.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        // 初始状态
        vipTag.isHidden = true              // 默认隐藏
        imgviewSpecialPrice.isHidden = true // 默认隐藏
        imgviewChangeBuy.isHidden = true    // 默认隐藏
        lblRebate.isHidden = true           // 默认隐藏
        lblSpecialTip.isHidden = true       // 默认隐藏
        lblShareStock.isHidden = true       // 默认隐藏
        lblProtocolRebate.isHidden = true   // 默认隐藏
    }
    
    
    // MARK: - Public
    
    func configCell(_ product: COProductModel?) {
        guard let model = product else {
            return
        }
        
        // 判断有无换购
        //if model.promotionHG != nil {
        if let _ = model.promotionHG  {
            // 有换购
            imgviewChangeBuy.isHidden = false
            lblName.snp.updateConstraints { (make) in
                make.left.equalTo(imgviewProduct.snp.right).offset(WH(40))
            }
        }
        else {
            // 无换购
            imgviewChangeBuy.isHidden = true
            lblName.snp.updateConstraints { (make) in
                make.left.equalTo(imgviewProduct.snp.right).offset(WH(10))
            }
        }
        
        // 判断是否为特价
        //if model.promotionTJ != nil {
        if let _ = model.promotionTJ {
            // 是特价
            imgviewSpecialPrice.isHidden = false
        }
        else {
            // 非特价
            imgviewSpecialPrice.isHidden = true
        }
        
        // 判断是否为vip商品
        if model.promotionType == "90" {
            // 是vip商品
            vipTag.isHidden = false
        }
        else {
            // 非vip商品
            vipTag.isHidden = true
        }
        
        // 0.是否显示返利...<默认不显示>
        var rebateShowFlag = false
        var rebateContent: String? = nil
        if let amount = model.productGetRebateMoney, amount.doubleValue > 0, let rebateFlag = model.showRebateMoneyFlag, rebateFlag == 1 {
            // 显示返利
            rebateShowFlag = true
            // 返利金额
            rebateContent = "预计返利 " + String(format: "¥ %.2f", amount.doubleValue)
        }
        // 显示
        showRebate(rebateContent, rebateShowFlag)
        
        // 1-0.是否显示不可用券...<true:打标 flase:不打标>
        var tjFlag = false // 默认不打标
        if let tj: String = model.isMutexTeJia, let value = Int(tj), value == 1 {
            // 是特价商品，需打标
            tjFlag = true
        }
        // 1-1.其它情况是否显示不可用券逻辑
        if let canUse = model.canUseCouponFlag, canUse == 0 {
            // 不可用券，需打标
            tjFlag = true
        }
        // 显示
        showSpecialTip(tjFlag)
        
        // 2.是否显示需调拨发货
        var stockFlag = false
        if model.shareStockVO != nil {
            // obj不为空，需打标
            stockFlag = true
        }
        showShareStock(stockFlag)
        
        // 3.是否显示协议返利金...<默认不显示>
        var protocolRebateFlag = false
        if let _ = model.agreementRebate  {
            // 是协议奖励金
            protocolRebateFlag = true
        }
        showProtocolRebate(protocolRebateFlag)
        
        // 名称
        lblName.text = model.productName
        
        // 价格
        var price: Double = 0
        if let p = model.productPrice, p.doubleValue > 0 {
            price = p.doubleValue
        }
        lblPrice.text = String(format: "¥ %.2f", price)
                
        // 实付金额
        if let pay = model.realProductPrice, pay.doubleValue >= 0 {
            lblPay.text = String(format: "实付 ¥ %.2f", pay.doubleValue)
        }
        else {
            lblPay.text = nil
        }
        
        // 规格
        lblSpec.text = model.specification
        
        // 有效期
        lblDate.text = "有效期：" + (model.deadLine ?? "")
        
        // 数量
        var number: String? = nil
        if let count = model.productCount, count > 0 {
            number = "x" + "\(count)"
        }
        lblNumber.text = number
        
        // 图片
        //imgviewProduct.sd_setImage(with: URL(string: model.productImageUrl!), placeholderImage: UIImage(named: "image_default_img"))
        if let pUrl = model.productImageUrl, pUrl.isEmpty == false {
            if let url = pUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                imgviewProduct.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage(named: "image_default_img"))
            }
            else {
                imgviewProduct.image = UIImage(named: "image_default_img")
            }
        }
        else {
            imgviewProduct.image = UIImage(named: "image_default_img")
        }
    }
    
    // 重设底部分隔线的布局
    func setupLineLayout() {
        viewLine.snp.updateConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(15))
            make.right.equalTo(contentView).offset(-WH(15))
        }
    }
    
    // 底部分隔线是否显示
    func showBottomLine(_ showFlag: Bool) {
        viewLine.isHidden = !showFlag
    }
    
    
    // MARK: - Private
    
    // [显示or隐藏]底部<预计返利>
    fileprivate func showRebate(_ rebate: String?, _ showFlag: Bool) {
        // 隐藏
        guard let rebate = rebate, rebate.isEmpty == false else {
            lblRebate.text = nil
            lblRebate.isHidden = true
            // 更新约束
            lblRebate.snp.updateConstraints { (make) in
                make.width.equalTo(0)
            }
            layoutIfNeeded()
            return
        }
        
        guard showFlag else {
            lblRebate.text = nil
            lblRebate.isHidden = true
            // 更新约束
            lblRebate.snp.updateConstraints { (make) in
                make.width.equalTo(0)
            }
            layoutIfNeeded()
            return
        }
        
        // 显示
        lblRebate.text = rebate
        lblRebate.isHidden = false
        //lblRebate.insetsForContent = UIEdgeInsetsMake(0, 4, 0, 4)
        
        // 计算lbl宽度
        let width = COProductItemCell.calculateStringWidth(rebate, UIFont.systemFont(ofSize: WH(10)), WH(16))
        // 更新约束
        lblRebate.snp.updateConstraints { (make) in
            make.width.equalTo(width + WH(6))
        }
        layoutIfNeeded()
    }
    
    // [显示or隐藏]底部<不可用券>
    fileprivate func showSpecialTip(_ showFlag: Bool) {
        // 显示or隐藏
        lblSpecialTip.isHidden = !showFlag
        // 更新约束
        let offset = lblRebate.isHidden ? WH(0) : WH(7)
        let width = showFlag ? WH(46) : WH(0)
        lblSpecialTip.snp.updateConstraints { (make) in
            make.left.equalTo(lblRebate.snp.right).offset(offset)
            make.width.equalTo(width)
        }
        layoutIfNeeded()
    }
    
    // [显示or隐藏]底部<调拨中>
    fileprivate func showShareStock(_ showFlag: Bool) {
        // 显示or隐藏
        lblShareStock.isHidden = !showFlag
        // 更新约束
        let offset = lblSpecialTip.isHidden ? WH(0) : WH(7)
        let width = showFlag ? WH(36) : WH(0)
        lblShareStock.snp.updateConstraints { (make) in
            make.left.equalTo(lblSpecialTip.snp.right).offset(offset)
            make.width.equalTo(width)
        }
        layoutIfNeeded()
    }
    
    // [显示or隐藏]底部<协议返利金>
    fileprivate func showProtocolRebate(_ showFlag: Bool) {
        // 显示or隐藏
        lblProtocolRebate.isHidden = !showFlag
        // 更新约束
        let offset = lblShareStock.isHidden ? WH(0) : WH(7)
        let width = showFlag ? WH(56) : WH(0)
        lblProtocolRebate.snp.updateConstraints { (make) in
            make.left.equalTo(lblShareStock.snp.right).offset(offset)
            make.width.equalTo(width)
        }
        layoutIfNeeded()
    }
    
    
    // MARK: - Class
    
    // 计算文字宽度
    class func calculateStringWidth(_ content: String, _ font: UIFont, _ height: CGFloat) -> CGFloat {
        let dic = [NSAttributedString.Key.font: font]
        let size = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: height)
        let strSize = content.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context: nil).size
        return strSize.width
    }
}
