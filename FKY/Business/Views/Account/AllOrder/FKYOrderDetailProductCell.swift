//
//  FKYOrderDetailProductCell.swift
//  FKY
//
//  Created by My on 2019/12/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

enum OrderDetailProductTagType: Int {
    //TAG
    case VIP = 0 //会员 黑底
    case TJ = 1 //特价 红底
    case NORMAL = 2 //其他的白底
    
    //限购提示
    case TIP = 3
    
    
}

@objc class FKYOrderDetailProductCell: UITableViewCell {
    
    @objc var protocolRebateClosure: (() -> ())?
    
    //商品图
    lazy var productImg: UIImageView = {
        let imgview = UIImageView()
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    
    // 品牌名 商品名称  规格
    lazy var productNameLb: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    // 生产厂家
    lazy var factoryLb: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x666666)
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    // 有效期
    lazy var dateLb: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x333333)
        return lbl
    }()
    
    lazy var dateTipLb: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x666666)
        return lbl
    }()
    
    //标签
    lazy var tagsView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    //价格
    lazy var priceLb: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0xFF2D5C)
        return lbl
    }()
    
    //实付单价
    lazy var payLb: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        return lbl
    }()
    
    //实付单价tip
    lazy var payTipLb: UILabel = {
        let lbl = UILabel()
        lbl.text = "实付单价"
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x333333)
        return lbl
    }()
    
    //数量
    lazy var countLb: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x666666)
        return lbl
    }()
    
    lazy var sepLine: UIView = {
        // 下分隔线
        let v = UIView()
        v.backgroundColor = RGBColor(0xEBEDEC)
        return v
    }()
    
    lazy var protocolLb: UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0xFF2D5C)
        lb.font = UIFont.systemFont(ofSize: WH(10))
        lb.backgroundColor = RGBColor(0xFFEDE7)
        lb.textAlignment = .center
        lb.layer.masksToBounds = true
        lb.layer.cornerRadius = WH(9)
        lb.text = "协议奖励金 >"
        lb.isUserInteractionEnabled = true
        lb.adjustsFontSizeToFitWidth = true
        let tap = UITapGestureRecognizer()
        tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.protocolRebateClosure?()
        }).disposed(by: disposeBag)
        lb.addGestureRecognizer(tap)
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FKYOrderDetailProductCell {
    func setupUI() {
        contentView.addSubview(productImg)
        contentView.addSubview(productNameLb)
        contentView.addSubview(factoryLb)
        contentView.addSubview(dateTipLb)
        contentView.addSubview(dateLb)
        contentView.addSubview(priceLb)
        contentView.addSubview(payLb)
        contentView.addSubview(payTipLb)
        contentView.addSubview(countLb)
        contentView.addSubview(tagsView)
        contentView.addSubview(protocolLb)
        
        productImg.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(20))
            make.top.equalToSuperview().offset(WH(10))
            make.size.equalTo(CGSize(width: WH(80), height: WH(80)))
        }
        
        productNameLb.snp_makeConstraints { (make) in
            make.top.equalTo(productImg)
            make.left.equalTo(productImg.snp_right).offset(WH(5))
            make.right.equalToSuperview().offset(-WH(40))
        }
        
        factoryLb.snp_makeConstraints { (make) in
            make.top.equalTo(productNameLb.snp_bottom).offset(WH(5))
            make.left.right.equalTo(productNameLb)
        }
        
        dateTipLb.snp_makeConstraints { (make) in
            make.top.equalTo(factoryLb.snp_bottom).offset(WH(5))
            make.left.equalTo(productNameLb)
        }
        
        dateLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(dateTipLb)
            make.left.equalTo(dateTipLb.snp_right)
        }
        
        protocolLb.snp_makeConstraints { (make) in
            make.top.equalTo(dateLb.snp_bottom).offset(WH(5))
            make.left.equalTo(productNameLb)
            make.size.equalTo(CGSize(width: WH(75), height: WH(18)))
        }
        
        payTipLb.snp_makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-WH(10))
            make.left.equalTo(productNameLb)
        }
        payLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(payTipLb)
            make.left.equalTo(payTipLb.snp_right)
        }
        
        priceLb.snp_makeConstraints { (make) in
            make.bottom.equalTo(payLb.snp_top)
            make.left.equalTo(productNameLb)
        }
        
        countLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(priceLb)
            make.right.equalToSuperview().offset(-WH(15))
        }
        
        tagsView.snp_makeConstraints { (make) in
            make.centerY.equalTo(priceLb)
            make.left.equalToSuperview().offset(WH(20))
            make.right.equalTo(priceLb.snp_left).offset(-WH(4))
            make.height.equalTo(WH(15))
        }
        
        contentView.addSubview(sepLine)
        sepLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView)
            make.left.equalToSuperview().offset(WH(15))
            make.right.equalToSuperview().offset(-WH(15))
            make.height.equalTo(0.5)
        }
    }
}


extension FKYOrderDetailProductCell {
    @objc func configCell(model: FKYOrderProductModel?) {
        guard let product = model else {
            return
        }
        if let  picUrl = product.productPicUrl, picUrl.isEmpty == false {
            productImg.sd_setImage(with: URL.init(string: picUrl), placeholderImage: UIImage(named: "image_default_img"))
        }else {
            productImg.image = UIImage(named: "image_default_img")
        }
        
        var productName = ""
        //名
        if let name = product.productName, name.isEmpty == false {
            productName += name
        }
        //规格
        if let spec = product.spec, spec.isEmpty == false {
            productName = productName + " " + spec
        }
        productNameLb.text = productName
        
        //生产厂家
        if let factory = product.factoryName, factory.isEmpty == false {
            factoryLb.text = factory
        }else {
            factoryLb.text = ""
        }
        
        
        var hasDate = false
        //有效期
        if let batchList = product.batchList, batchList.count > 0 {
            if let batch = product.batchList.first as? FKYBatchModel {
                if let date = batch.validUntil, date.isEmpty == false {
                    dateLb.text = date
                    dateTipLb.text = "效期  "
                    hasDate = true
                }
            }
        }
        if hasDate ==  false {
            dateLb.text = ""
            dateTipLb.text = ""
        }
        
        
        //协议奖励金
        if let protocolUrl = product.agreementRebateDetailUrl, protocolUrl.isEmpty == false {
            protocolLb.isHidden = false
        }else {
            protocolLb.isHidden = true
        }
        
        //实付单价
        if let pay = product.payPrice, pay.doubleValue >= 0 {
            payLb.text = String(format: "¥ %.2f", pay.doubleValue)
            payTipLb.text = "实付单价 "
        }else {
            payLb.text = ""
            payTipLb.text = ""
        }
        
        
        //单价
        if let price = product.productPrice, price.doubleValue >= 0 {
            priceLb.text = String(format: "¥ %.2f", price.doubleValue)
        }else {
            priceLb.text = ""
        }
        
        //数量
        if let count = product.quantity, count.intValue > 0 {
            countLb.text = "x" + "\(count.intValue)"
        }else {
            countLb.text = ""
        }
        
        //标签
        for sub in tagsView.subviews {
            sub.removeFromSuperview()
        }
        //
        var tagLabels = [UILabel]()
        //特价 会员
        if let type = product.isSpecialOffer, type.intValue == 0 {
            let tjLb = COProductInfoCell.getProductTageLabels("特价", .TJ, false)
            tagLabels.append(tjLb)
        } else if let type = product.isVip, type.intValue == 0 {
            let vipLb = COProductInfoCell.getProductTageLabels("会员价", .VIP, false)
            tagLabels.append(vipLb)
        }
        
        if let type = product.isRebate, type.intValue == 0 {
            let FLLb = COProductInfoCell.getProductTageLabels("返利", .NORMAL, false)
            tagLabels.append(FLLb)
        }
        
        if let type = product.isFullGift, type.intValue == 0 , tagLabels.count < 2 {
            let mzLb = COProductInfoCell.getProductTageLabels("满赠", .NORMAL, false)
            tagLabels.append(mzLb)
        }
        
        
        var lastTagLb: UILabel? = nil
        for item in tagLabels {
            let size = COProductInfoCell.getProductTagSize(item.text ?? "", UIFont.boldSystemFont(ofSize: WH(10)))
            tagsView.addSubview(item)
            item.snp_updateConstraints { (make) in
                make.centerY.equalToSuperview()
                make.height.equalToSuperview()
                make.width.equalTo(size.width + WH(10))
                if let lastLb = lastTagLb {
                    make.right.equalTo(lastLb.snp_left).offset(-WH(5))
                }else {
                    make.right.equalToSuperview()
                }
            }
            lastTagLb = item
        }
    }
    
    
    //获取高度
    @objc static func getContentHeight(_ model: FKYOrderProductModel?) -> CGFloat {
        guard let product = model else {
            return 0
        }
        
        var height: CGFloat = 0
        
        var productName = ""
        //名
        if let name = product.productName, name.isEmpty == false {
            productName += name
        }
        //规格
        if let spec = product.spec, spec.isEmpty == false {
            productName = productName + " " + spec
        }
        
        var contentSize = CGSize.zero
        if productName.isEmpty == false {
            contentSize = FKYOrderDetailProductCell.getProductTagSize(productName, UIFont.boldSystemFont(ofSize: WH(14)))
            height += (contentSize.height > WH(40) ? WH(40) : contentSize.height + 1) + WH(5)
        }
        
        //生产厂家
        if let factory = product.factoryName, factory.isEmpty == false {
            height += WH(14) + WH(5)
        }
        
        //有效期
        if let batchList = product.batchList, batchList.count > 0 {
            if let batch = product.batchList.first as? FKYBatchModel {
                if let date = batch.validUntil, date.isEmpty == false {
                    height += WH(14) + WH(5)
                }
            }
        }
        
        var hasProtocol = false
        if let protocolUrl = product.agreementRebateDetailUrl, protocolUrl.isEmpty == false {
            hasProtocol = true
            height += WH(18) + WH(12)
        }
        
        var hasRealProductPrice = false
        if let pay = product.payPrice, pay.doubleValue >= 0 {
            height += WH(14)
            hasRealProductPrice = true
        }
        
        //单价
        if let price = product.productPrice, price.doubleValue >= 0 {
            height += WH(14)
        }
        
        height += WH(20)
        if height < WH(140) {
            if hasRealProductPrice {
                height = WH(140)
            }else {
                height = WH(130)
            }
            
            var hasLeftTag = false
            //特价 会员 返利 协议奖励金  满赠
            if let type = product.isSpecialOffer, type.intValue == 0 {
                hasLeftTag = true
            }else if let type = product.isVip, type.intValue == 0 {
                hasLeftTag = true
            }else if let type = product.isRebate, type.intValue == 0 {
                hasLeftTag = true
            }else if let type = product.isFullGift, type.intValue == 0 {
                hasLeftTag = true
            }
            
            if !hasProtocol && (contentSize.height < WH(23)) {
                if hasLeftTag {
                    height -= WH(9)
                }else {
                    height -= WH(15)
                }
            }
        }
        
        return height
    }
    
    
    static func getProductTageLabels(_ text: String, _ type: OrderDetailProductTagType, _ isProtocolRebate: Bool) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(15.0/2)
        label.textAlignment = .center
        if type == .VIP {
            label.textColor = RGBColor(0xFFDEAE)
            label.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0x566771), RGBColor(0x182F4C), WH(40))
        }else if type == .TJ {
            label.textColor = RGBColor(0xFFFFFF)
            label.backgroundColor = RGBColor(0xFF2D5C)
        }else if type == .NORMAL {
            label.textColor = RGBColor(0xFF2D5C)
            label.backgroundColor = .white
            label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
            label.layer.borderWidth = WH(1)
        }else if type == .TIP {
            label.textColor = RGBColor(0xFF2D5C)
            label.font = UIFont.systemFont(ofSize: WH(12))
            label.backgroundColor = RGBColor(0xFFEDE7)
            label.layer.cornerRadius = WH(9)
        }
        return label
    }
    
    static func getProductTagSize(_ text: String, _ font: UIFont) -> CGSize {
        return text.boundingRect(with: CGSize.init(width: SCREEN_WIDTH - WH(145), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:font], context: nil).size
    }
}
