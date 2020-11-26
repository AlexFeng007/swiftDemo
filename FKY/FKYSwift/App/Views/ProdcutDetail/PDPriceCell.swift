//
//  PDPriceCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/9/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详之价格cell

import UIKit

class PDPriceCell: UITableViewCell {
    //MARK: - Property
    
    // closure
    @objc var showDetailBlock: (()->())? // 查看折后价说明
    // closure
    @objc var lowPriceNoticeBlock: (()->())? // 查看折后价说明
    
    var hasSpecial = false
    var hasVipPrice = false
    
    // 现价
    fileprivate lazy var lblPrice: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = ""
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(19))
        return lbl
    }()
    
    // 单位
    fileprivate lazy var lblUnit: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = ""
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x666666)
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        return lbl
    }()
    
    // 原价
    fileprivate lazy var lblPriceOrigin: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = ""
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x999999)
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        return lbl
    }()
    
    // 折后价
    fileprivate lazy var lblPriceDiscount: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        //lbl.text = "折后约￥36.10"
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x666666)
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        return lbl
    }()
    // 折后价i按钮
    fileprivate lazy var btnPriceDiscount: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage.init(named: "img_checkorder_fright"), for: .normal)
        btn.bk_addEventHandler({ [weak self] (btn) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.showDetailBlock {
                closure()
            }
            }, for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    // 不显示价格时，需显示提示文描
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = ""
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.font = UIFont.systemFont(ofSize: WH(18))
        return lbl
    }()
    
    // 打标...<特价 or 会员价>
    fileprivate lazy var lblTag: UILabel = {
        let label = UILabel()
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = WH(18/2.0)
        label.layer.masksToBounds = true
        return label
    }()
    
    // 降价通知标签
    fileprivate lazy var lowPriceImage: UIView = {
        let bgview = UIView()
        let image = UIImageView()
        image.image = UIImage.init(named: "low_price_icon")
        image.contentMode = .center
        bgview.addSubview(image)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(11))
        label.textColor = RGBColor(0x666666)
        label.textAlignment = .center
        label.text = "降价通知"
        bgview.addSubview(label)
        
        bgview .isUserInteractionEnabled = true
        let tapGestureMsg = UITapGestureRecognizer()
        tapGestureMsg.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.lowPriceNoticeBlock {
                closure()
            }
        }).disposed(by: disposeBag)
        bgview .addGestureRecognizer(tapGestureMsg)
        
        image.snp.makeConstraints( { (make) in
            make.top.left.right.centerX.equalTo(bgview)
            
            make.height.equalTo(WH(24))
        })
        
        label.snp.makeConstraints( { (make) in
            make.bottom.left.right.centerX.equalTo(bgview)
        })
        return bgview
    }()
    
    
    // 建议零售价和毛利
    fileprivate lazy var retailView: FKYRetailView = {
        let view = FKYRetailView()
        return view
    }()
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xFFFFFF)
        contentView.backgroundColor = RGBColor(0xFFFFFF)
        
        contentView.addSubview(lblPrice)
        contentView.addSubview(lblUnit)
        contentView.addSubview(lblPriceOrigin)
        contentView.addSubview(lblTip)
        contentView.addSubview(lblTag)
        contentView.addSubview(lowPriceImage)
        lblTag.isHidden = true
        // lowPriceImage.isHidden = true
        
        contentView.addSubview(retailView)
        retailView.snp.makeConstraints( { (make) in
            make.left.equalTo(contentView).offset(WH(10))
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(WH(-4))
            make.height.equalTo(WH(0))
        })
        
        lblPrice.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(10))
            make.left.equalTo(contentView).offset(WH(10))
        }
        
        lblUnit.snp.makeConstraints { (make) in
            make.centerY.equalTo(lblPrice.snp.centerY)
            make.left.equalTo(lblPrice.snp.right).offset(WH(4))
        }
        
        lblPriceOrigin.snp.makeConstraints { (make) in
            make.centerY.equalTo(lblPrice.snp.centerY)
            make.left.equalTo(lblUnit.snp.right).offset(WH(15))
        }
        
        lblTag.snp.makeConstraints { (make) in
            make.centerY.equalTo(lblPrice.snp.centerY)
            make.left.equalTo(contentView).offset(WH(10))
            make.width.equalTo(WH(50))
            make.height.equalTo(WH(18))
        }
        
        lblTip.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(WH(-7))
            make.left.equalTo(contentView).offset(WH(10))
        }
        
        // 折后价相关...<默认隐藏>
        contentView.addSubview(lblPriceDiscount)
        contentView.addSubview(btnPriceDiscount)
        lblPriceDiscount.isHidden = true
        btnPriceDiscount.isHidden = true
        
        lblPriceDiscount.snp.makeConstraints { (make) in
            make.centerY.equalTo(lblPrice.snp.centerY)
            make.left.equalTo(lblUnit.snp.right).offset(WH(11))
        }
        btnPriceDiscount.snp.makeConstraints { (make) in
            make.centerY.equalTo(lblPrice.snp.centerY)
            make.left.equalTo(lblPriceDiscount.snp.right).offset(-WH(5))
            make.width.equalTo(WH(32))
            make.height.equalTo(WH(32))
        }
        
        lowPriceImage.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(5))
            make.right.equalTo(contentView)
            make.width.equalTo(WH(60))
            make.height.equalTo(WH(35))
        }
    }
    
    
    // MARK: - Public
    
    /*
     statusDesc
     0:正常显示价格,
     -1:登录后可见,
     -2:加入渠道后可见,
     -3:资质认证后可见,
     -4:渠道待审核,
     -5:缺货,
     -6:不显示,
     -9:无采购权限
     -10:采购权限待审核
     -11:采购权限不通过
     -12:采购权限已禁用
     */
    
    // 配置cell
    @objc func configCell(_ model: FKYProductObject?) {
        // 默认隐藏
        lblPrice.isHidden = true
        lblUnit.isHidden = true
        lblPriceOrigin.isHidden = true
        lblTip.isHidden = true
        lblTag.isHidden = true
        lblPriceDiscount.isHidden = true
        btnPriceDiscount.isHidden = true
        lblTag.text = ""
        hasSpecial = false
        hasVipPrice = false
        lowPriceImage.isHidden = false
        retailView.snp.updateConstraints({ (make) in
            make.height.equalTo(WH(0))
        })
        retailView.configRetailViewData(nil, nil)
        
        guard let model = model else {
            // 隐藏
            contentView.isHidden = true
            return
        }
        
        // 显示价格
        if model.priceInfo.showPrice == false {
            // 隐藏
            contentView.isHidden = true
            return
        }
        
        // 显示
        contentView.isHidden = false
        showPrice(model)
        changePriceStyle()
    }
    
    
    // MARK: - Private
    
    // 调整价格展示方式
    fileprivate func changePriceStyle() {
        // 现价
        if let content = lblPrice.text, content.isEmpty == false {
            let attributedString = NSMutableAttributedString(string: content)
            attributedString.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(19)), NSAttributedString.Key.foregroundColor:RGBColor(0xFF2D5C)], range: NSRange.init(location: 0, length: content.count))
            attributedString.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(12)), NSAttributedString.Key.foregroundColor:RGBColor(0xFF2D5C)], range: NSRange.init(location: 0, length: 1))
            lblPrice.attributedText = attributedString
        }
        
        // 原价
        if let content = lblPriceOrigin.text, content.isEmpty == false, hasSpecial == true {
            let attributedString = NSMutableAttributedString.init(string: content)
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: content.count))
            lblPriceOrigin.attributedText = attributedString
        }
    }
    // 需展示价格的显示逻辑
    fileprivate func showPrice(_ model: FKYProductObject) {
        // 默认隐藏
        lblTag.isHidden = true
        lblPrice.isHidden = true
        lblUnit.isHidden = true
        lblPriceOrigin.isHidden = true
        lblTip.isHidden = true
        lblPriceDiscount.isHidden = true
        btnPriceDiscount.isHidden = true
        
        // 现价
        lblPrice.text = nil
        // 单位
        lblUnit.text = nil
        // 原价
        lblPriceOrigin.text = nil
        // 折后价
        lblPriceDiscount.text = nil
        
        // 展示价格(现价/最终价格)
        var priceFinal: Float = 0
        
        if let promotion = model.productPromotion, let promotionPrice = promotion.promotionPrice {
            // 有特价...<特价为现价/最终价格，商品价格为原价>
            
            // 现价
            lblPrice.text = NSString.init(format: "¥%.2f", promotionPrice.floatValue) as String
            priceFinal = promotionPrice.floatValue // 保存最终价
            // 单位
            if let unit = model.unit, unit.isEmpty == false {
                lblUnit.text = "/" + unit
            }
            // 原价
            if let price = model.priceInfo.price {
                lblPriceOrigin.text = "¥\(price)"
            }
            hasSpecial = true
            lblPrice.isHidden = false
            lblUnit.isHidden = false
            lblPriceOrigin.isHidden = false
        }
        else if let pVip = model.vipPromotionInfo,
            let pid = pVip.vipPromotionId, pid.isEmpty == false,
            let vipNum = pVip.visibleVipPrice, vipNum.isEmpty == false, let value = Float(vipNum), value > 0,
            let mVip = model.vipModel, mVip.vipSymbol != 2 {
            // 有vip价...<会员：vip价为现价/最终价格，商品价格为原价>
            
            // 单位
            if let unit = model.unit, unit.isEmpty == false {
                lblUnit.text = "/" + unit
            }
            // 价格
            if mVip.vipSymbol == 1 {
                // 会员...<vip价格为现价，商品价格为原价>
                
                // vip价格...<现价>
                lblPrice.text = NSString.init(format: "¥%.2f", value) as String
                priceFinal = value // 保存最终价
                // 原价
                if let price = model.priceInfo.price {
                    lblPriceOrigin.text = "药城价¥\(price)"
                }
            }
            else {
                // 非会员...<商品价格为现价，vip价为原价>
                
                // 非vip价格...<现价>
                if let price = model.priceInfo.price {
                    lblPrice.text = "¥\(price)"
                    priceFinal = (price as NSString).floatValue // 保存最终价
                }
                // 原价
                lblPriceOrigin.text = NSString.init(format: "¥%.2f", value) as String
            }
            
            lblPrice.isHidden = false
            lblUnit.isHidden = false
            lblPriceOrigin.isHidden = false
            hasVipPrice = true
        }
        else {
            // 无特价&无vip价...<仅一个商品价格，直接作为现价/最终价格>
            
            // 现价
            if let price = model.priceInfo.price {
                lblPrice.text = "¥\(price)"
                priceFinal = (price as NSString).floatValue // 保存最终价
            }
            else {
                lblPrice.text = "¥--"
            }
            // 单位
            if let unit = model.unit, unit.isEmpty == false {
                lblUnit.text = "/" + unit
            }
            
            lblPrice.isHidden = false
            lblUnit.isHidden = false
            
            // 折后价是否展示逻辑
            if let obj = model.discountInfo, let price = obj.discountPrice, price.isEmpty == false {
                // 显示折后价
                
                // app本地防呆...<保证折后价小于原价>
               // let noDigits = CharacterSet.decimalDigits.inverted
               // let numP = price.trimmingCharacters(in: noDigits)
               // let valueP = (numP as NSString).doubleValue
                //if let pPrice = model.priceInfo.price, (pPrice as NSString).doubleValue > valueP {
                    lblPriceDiscount.isHidden = false
                    btnPriceDiscount.isHidden = false
                    lblPriceDiscount.text = "折后约" + price
                //}
                
                //                lblPriceDiscount.isHidden = false
                //                btnPriceDiscount.isHidden = false
                //                lblPriceDiscount.text = "折后约" + price
            }
        }
        
        // 初始化标签约束和现价约束
        lblTag.snp.remakeConstraints { (make) in
            make.centerY.equalTo(lblPrice.snp.centerY)
            make.left.equalTo(contentView).offset(WH(10))
            make.width.equalTo(WH(36))
            make.height.equalTo(WH(18))
        }
        lblPrice.snp.remakeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(10))
            make.left.equalTo(contentView).offset(WH(10))
        }
        
        if hasSpecial {
            // 特价
            lblTag.isHidden = false
            
            if model.productPromotion.liveStreamingFlag == 1 {
                lblTag.text = "直播价"
                lblTag.snp.updateConstraints { (make) in
                    make.width.equalTo(WH(55))
                }
            }else {
                lblTag.snp.updateConstraints { (make) in
                    make.width.equalTo(WH(50))
                }
                lblTag.text = "特价"
            }
            lblTag.layer.cornerRadius = WH(18/2.0)
            lblTag.font = UIFont.boldSystemFont(ofSize: WH(12))
            lblTag.textColor = .white
            lblTag.backgroundColor = RGBColor(0xFF2D5C)
            if priceFinal > 0, let recomPrice = model.priceInfo.recommendPrice, (recomPrice as NSString).floatValue > 0, (recomPrice as NSString).floatValue > priceFinal, model.isZiYingFlag == 1 {
                lblPrice.snp.remakeConstraints { (make) in
                    make.top.equalTo(contentView).offset(WH(10))
                    make.left.equalTo(lblTag.snp.right).offset(WH(5))
                }
            }else{
                lblPrice.snp.remakeConstraints { (make) in
                    make.top.equalTo(contentView).offset(WH(13))
                    make.left.equalTo(lblTag.snp.right).offset(WH(5))
                }
            }
        }
        //有底价
        if model.hasBasePriceActivity() == true {
            lblTag.isHidden = false
            lblTag.text = "底价"
            lblTag.layer.cornerRadius = WH(18/2.0)
            lblTag.font = UIFont.boldSystemFont(ofSize: WH(12))
            lblTag.textColor = .white
            lblTag.backgroundColor = RGBColor(0xFF2D5C)
            if priceFinal > 0, let recomPrice = model.priceInfo.recommendPrice, (recomPrice as NSString).floatValue > 0, (recomPrice as NSString).floatValue > priceFinal, model.isZiYingFlag == 1 {
                lblPrice.snp.remakeConstraints { (make) in
                    make.top.equalTo(contentView).offset(WH(10))
                    make.left.equalTo(lblTag.snp.right).offset(WH(5))
                }
            }else{
                lblPrice.snp.remakeConstraints { (make) in
                    make.top.equalTo(contentView).offset(WH(13))
                    make.left.equalTo(lblTag.snp.right).offset(WH(5))
                }
            }
            
        }
        
        if hasVipPrice {
            // vip价格
            lblTag.isHidden = false
            lblTag.text = "会员价"
            lblTag.layer.cornerRadius = WH(18/2.0)
            lblTag.textColor = RGBColor(0xFFDEAE)
            
            // 确定显示位置
            if let mVip = model.vipModel, mVip.vipSymbol == 1 {
                // 会员...<显示在前>
                lblTag.font = t11.font
                lblTag.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(WH(50)))
                lblTag.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(lblPrice.snp.centerY)
                    make.left.equalTo(contentView).offset(WH(10))
                    make.width.equalTo(WH(50))
                    make.height.equalTo(WH(18))
                }
                if priceFinal > 0, let recomPrice = model.priceInfo.recommendPrice, (recomPrice as NSString).floatValue > 0, (recomPrice as NSString).floatValue > priceFinal, model.isZiYingFlag == 1 {
                    lblPrice.snp.remakeConstraints { (make) in
                        make.top.equalTo(contentView).offset(WH(10))
                        make.left.equalTo(lblTag.snp.right).offset(WH(5))
                    }
                }else{
                    lblPrice.snp.remakeConstraints { (make) in
                        make.top.equalTo(contentView).offset(WH(13))
                        make.left.equalTo(lblTag.snp.right).offset(WH(5))
                    }
                }
            }
            else {
                // 非会员...<显示在后>
                lblTag.font = t28.font
                lblTag.layer.cornerRadius = WH(15/2.0)
                lblTag.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(WH(38)))
                lblTag.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(lblPrice.snp.centerY)
                    make.left.equalTo(lblPriceOrigin.snp.right).offset(WH(4))
                    make.width.equalTo(WH(38))
                    make.height.equalTo(WH(15))
                }
            }
        }
        
        if model.isZiYingFlag == 1, priceFinal > 0, let recomPrice = model.priceInfo.recommendPrice, (recomPrice as NSString).floatValue > 0, (recomPrice as NSString).floatValue > priceFinal {
            // 显示建议零售价和毛利
            retailView.snp.updateConstraints({ (make) in
                make.height.equalTo(WH(17+9))
            })
            self.retailView.configRetailViewData(priceFinal, (recomPrice as NSString).floatValue)
        }
    }
}
