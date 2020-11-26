//
//  ProductPromationInfoView.swift
//  FKY
//
//  Created by 寒山 on 2019/8/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商品列表 标签展示优先级：限购、券、返利/协议奖励金（此两项互斥）、满减/满折/满赠/套餐（此三项互斥）  零售价  毛利 （不包含的打标）

import UIKit

class ProductPromationInfoView: UIView {
    
    //类型标签列表
    lazy var tagCollectionView: UICollectionView! = {
        let flowLayout = UICollectionViewLeftAlignedLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .vertical
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(FKYShopTypeCell.self, forCellWithReuseIdentifier: "FKYShopTypeCell")
        view.isScrollEnabled = false
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    var tagStrArr = [String]() //标签数组
    
    // 建议零售价和毛利
    fileprivate lazy var retailView: FKYRetailView = {
        let view = FKYRetailView()
        view.isHidden = true
        return view
    }()
    
    
    // 共享库存标签
    public lazy var storeLabel: UILabel = {
        let label = UILabel()
        label.font = t29.font
        label.textAlignment = .center
        label.backgroundColor = RGBColor(0xFFEDE7)
        label.textColor = RGBColor(0xFF2D5C)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(8)
        return label
    }()
    
    // 秒杀和一起购标签
    public lazy var fistLimitFlagLabel: UILabel = {
        let label = UILabel()
        label.font = t29.font
        label.textAlignment = .center
        label.backgroundColor = RGBColor(0xFFEDE7)
        label.textColor = RGBColor(0xFF2D5C)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(8)
        return label
    }()
    public lazy var secondLimitFlagLabel: UILabel = {
        let label = UILabel()
        label.font = t29.font
        label.textAlignment = .center
        label.backgroundColor = RGBColor(0xFFEDE7)
        label.textColor = RGBColor(0xFF2D5C)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(8)
        return label
    }()
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    // MARK: - UI
    fileprivate func setupView() {
        // 专享 、限购、券、返利、返利金协议 ,套餐、满减、满赠、满折
        self.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints( { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self).offset(WH(6))
            make.right.equalTo(self)
            make.height.equalTo(TAG_H)
        })
        
        // 零售价和毛利
        self.addSubview(retailView)
        retailView.snp.makeConstraints( { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(tagCollectionView.snp.bottom)
            make.height.equalTo(0)
        })
        
        // 共享库存
        self.addSubview(storeLabel)
        storeLabel.snp.makeConstraints( { (make) in
            make.left.equalTo(self)
            make.top.equalTo(retailView.snp.bottom).offset(WH(6))
            make.width.equalTo(WH(0))
            make.height.equalTo(WH(16))
        })
        
        //秒杀和一起购里的限制标签
        self.addSubview(fistLimitFlagLabel)
        fistLimitFlagLabel.snp.makeConstraints( { (make) in
            make.left.equalTo(self)
            make.top.equalTo(retailView.snp.bottom).offset(WH(6))
            make.width.equalTo(WH(0))
            make.height.equalTo(WH(16))
        })
        // 秒杀和一起购里的限制标签
        self.addSubview(secondLimitFlagLabel)
        secondLimitFlagLabel.snp.makeConstraints( { (make) in
            make.left.equalTo(fistLimitFlagLabel.snp.right).offset(WH(6))
            make.top.equalTo(retailView.snp.bottom).offset(WH(6))
            make.width.equalTo(WH(0))
            make.height.equalTo(WH(16))
        })
        
    }
    // 促销打标 & 限购打标 & 优惠券打标 ...<只有指定状态下才会显示标签>
    func showPromotionIcon(_ product: Any) {
        self.retailView.isHidden = true
        self.storeLabel.isHidden = true
        fistLimitFlagLabel.isHidden = true
        secondLimitFlagLabel.isHidden = true
        
        self.tagStrArr.removeAll()
        //MARK:HomeProductModel
        if let po = product as? HomeProductModel {
            if po.statusDesc != nil && (po.statusDesc == -2 || po.statusDesc == -3 ||  po.statusDesc == -4 || po.statusDesc == -6) {
            }else{
                if po.slowPay == true{
                    //慢必赔
                    self.tagStrArr.append("慢必赔")
                }
                if po.holdPrice == true{
                    //保价
                    self.tagStrArr.append("保价")
                }
                if po.isShowExclusivePrice() == true{
                    self.tagStrArr.append("\(po.doorsill ?? 0)\(po.unit)可享专享价")
                }
                // 限购
                if let li = po.limitInfo, li.isEmpty == false {
                    self.tagStrArr.append("限购")
                }
                // 优惠券
                if let cp = po.includeCouponTemplateIds, cp.isEmpty == false {
                    self.tagStrArr.append("券")
                }
                // 返利金
                if let rb = po.isRebate, rb == 1 {
                    self.tagStrArr.append("返利")
                }
                // 协议返利金
                if let rebate = po.protocolRebate, rebate == true {
                    self.tagStrArr.append("协议奖励金")
                }
                // 套餐
                if let li = po.haveDinner, li == true {
                    self.tagStrArr.append("套餐")
                }
                if po.isHasSomeKindPromotion(["2", "3"]) {
                    self.tagStrArr.append("满减")
                }
                if po.isHasSomeKindPromotion(["5", "6", "7", "8"]) {
                    self.tagStrArr.append("满赠")
                }
                // 15:单品满折,16多品满折
                if po.isHasSomeKindPromotion(["15", "16"]) {
                    self.tagStrArr.append("满折")
                }
            }
            
            //
            if po.statusDesc == -2 || po.statusDesc == -1 || po.statusDesc == -4 || po.isZiYingFlag != 1 {
                // 商品为控销及未登录不显示
                self.retailView.configRetailViewData(nil, nil)
                self.retailView.snp.updateConstraints({ (make) in
                    make.height.equalTo(WH(0))
                })
            }
            else {
                var priceDes : Float = 0 //最终显示价格
                if let priceStr = po.productPrice,priceStr > 0 {
                    priceDes = priceStr
                }
                if let priceStr = po.productPromotion?.promotionPrice,priceStr > 0  {
                    priceDes = priceStr
                }
                if let _ = po.vipPromotionId ,let vipNum = po.visibleVipPrice ,vipNum > 0 {
                    if let vipAvailableNum = po.availableVipPrice ,vipAvailableNum > 0 {
                        //会员
                        priceDes = vipNum
                    }
                }
                if priceDes > 0 ,let recomPrice = po.recommendPrice ,recomPrice > 0,recomPrice > priceDes {
                    // 显示毛利
                    self.retailView.isHidden = false
                    self.retailView.configRetailViewData(priceDes, recomPrice)
                    self.retailView.snp.updateConstraints({ (make) in
                        make.height.equalTo(WH(18+6))
                    })
                }
            }
            // 共享库存
            if po.stockIsLocal == false {
                self.storeLabel.isHidden = false
                if (po.shareStockDesc != nil && po.shareStockDesc!.isEmpty == false){
                    self.storeLabel.text =  po.shareStockDesc
                }else {
                    self.storeLabel.text =  "调拨中，预计一周内发货"
                }
                let maxW = self.storeLabel.text?.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t26.font], context: nil).width
                let desW = maxW!+WH(6)
                self.storeLabel.snp.remakeConstraints { (make) in
                    make.width.equalTo(desW)
                    make.height.equalTo(WH(18))
                    make.top.equalTo(retailView.snp.bottom).offset(WH(6))
                }
            }
            else {
                self.storeLabel.isHidden = true
                self.storeLabel.snp.updateConstraints { (make) in
                    make.width.height.equalTo(0)
                    make.top.equalTo(retailView.snp.bottom)
                }
            }
            // 各标签展示优化~!@
        }
        if let po = product as? SearchMpHockProductModel{
            // 16多品满折
            if  po.productPromotionInfo != nil &&  po.productPromotionInfo?.promotionType == "16"{
                self.tagStrArr.append("满折")
            }
        }
        if let po = product as? OftenBuyProductItemModel{
            //常购清单
            if let sign = po.productSign {
                if sign.purchaseLimit == true{
                    //限购
                    self.tagStrArr.append("限购")
                }
                if sign.ticket == true{
                    //券
                    self.tagStrArr.append("券")
                }
                if sign.rebate == true{
                    //返利
                    self.tagStrArr.append("返利")
                }
                if sign.bounty == true{
                    //协议奖励金
                    self.tagStrArr.append("协议奖励金")
                }
                if sign.packages == true{
                    //套餐
                    self.tagStrArr.append("套餐")
                }
                if sign.fullScale == true{
                    //满减
                    self.tagStrArr.append("满减")
                }
                if sign.fullGift == true{
                    //满赠
                    self.tagStrArr.append("满赠")
                }
                if sign.fullDiscount == true{
                    //满折
                    self.tagStrArr.append("满折")
                }
            }
            // 共享库存
            if let des = po.shareStockDesc, des.count > 0 {
                self.storeLabel.isHidden = false
                self.storeLabel.text =  po.shareStockDesc
                
                let maxW = self.storeLabel.text?.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t26.font], context: nil).width
                let desW = maxW!+WH(6)
                self.storeLabel.snp.remakeConstraints { (make) in
                    make.width.equalTo(desW)
                    make.height.equalTo(WH(18))
                    make.top.equalTo(retailView.snp.bottom).offset(WH(6))
                }
            }
            else {
                self.storeLabel.isHidden = true
                self.storeLabel.snp.updateConstraints { (make) in
                    make.width.height.equalTo(0)
                    make.top.equalTo(retailView.snp.bottom)
                }
            }
        }
        if let po = product as? ShopProductCellModel {
            if po.statusDesc != nil && (po.statusDesc == -2 || po.statusDesc == -3 ||  po.statusDesc == -4 || po.statusDesc == -6) {
            }
            else{
                // 限购
                if let li = po.limitInfo, li.isEmpty == false {
                    self.tagStrArr.append("限购")
                }
                // 优惠券
                if let cp = po.includeCouponTemplateIds, cp.isEmpty == false {
                    self.tagStrArr.append("券")
                }
                // 返利金
                if let rb = po.isRebate, rb == 1 {
                    self.tagStrArr.append("返利")
                }
                // 套餐
                if let li = po.haveDinner, li == true {
                    self.tagStrArr.append("套餐")
                }
                if po.isHasSomeKindPromotion(["2", "3"]) {
                    self.tagStrArr.append("满减")
                }
                if po.isHasSomeKindPromotion(["5", "6", "7", "8"]) {
                    self.tagStrArr.append("满赠")
                }
                // 15:单品满折,16多品满折
                if po.isHasSomeKindPromotion(["15", "16"]) {
                    self.tagStrArr.append("满折")
                }
            }
            // 共享库存
            if po.stockIsLocal == false {
                self.storeLabel.isHidden = false
                if (po.shareStockDesc != nil && po.shareStockDesc!.isEmpty == false){
                    self.storeLabel.text =  po.shareStockDesc
                }else {
                    self.storeLabel.text =  "调拨中，预计一周内发货"
                }
                let maxW = self.storeLabel.text?.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t26.font], context: nil).width
                let desW = maxW!+WH(6)
                self.storeLabel.snp.remakeConstraints { (make) in
                    make.width.equalTo(desW)
                    make.height.equalTo(WH(18))
                    make.top.equalTo(retailView.snp.bottom).offset(WH(6))
                }
            }
            else {
                self.storeLabel.isHidden = true
                self.storeLabel.snp.updateConstraints { (make) in
                    make.width.height.equalTo(0)
                    make.top.equalTo(retailView.snp.bottom)
                }
            }
        }
        if let po = product as? FKYProductObject{
            if po.priceInfo != nil && (po.priceInfo.status == "-2" || po.priceInfo.status == "-3" ||  po.priceInfo.status == "-4" || po.priceInfo.status == "-6") {
            }else{
                // 限购
                if let info = po.productLimitInfo,let li = info.limitInfo, li.isEmpty == false {
                    self.tagStrArr.append("限购")
                }
                // 优惠券
                if let cp = po.couponList, cp.isEmpty == false {
                    self.tagStrArr.append("券")
                }
                // 返利金
                if let info = po.rebateInfo, let rb = info.isRebate, rb == 1 {
                    self.tagStrArr.append("返利")
                }
                // 套餐
                if  let info = po.dinnerInfo, let li = info.dinnerList, li.isEmpty == false {
                    self.tagStrArr.append("套餐")
                }
                if po.promotionCount() > 0 {
                    self.tagStrArr.append("满减")
                }
                if po.fullGiftCount() > 0  {
                    self.tagStrArr.append("满赠")
                }
                // 15:单品满折,16多品满折
                if po.fullDiscountCount() > 0 {
                    self.tagStrArr.append("满折")
                }
            }
        }
        if let model = product as? HomeCommonProductModel{
            if let sign = model.productSign {
                if sign.slowPay == true{
                    //慢必赔
                    self.tagStrArr.append("慢必赔")
                }
                if sign.holdPrice == true{
                    //保价
                    self.tagStrArr.append("保价")
                }
                if sign.purchaseLimit == true{
                    //限购
                    self.tagStrArr.append("限购")
                }
                if sign.ticket == true{
                    //券
                    self.tagStrArr.append("券")
                }
                if sign.rebate == true{
                    //返利
                    self.tagStrArr.append("返利")
                }
                if sign.bounty == true{
                    //协议奖励金
                    self.tagStrArr.append("协议奖励金")
                }
                if sign.packages == true{
                    //套餐
                    self.tagStrArr.append("套餐")
                }
                if sign.fullScale == true{
                    //满减
                    self.tagStrArr.append("满减")
                }
                if sign.fullGift == true{
                    //满赠
                    self.tagStrArr.append("满赠")
                }
                if sign.fullDiscount == true{
                    //满折
                    self.tagStrArr.append("满折")
                }
            }
            // 共享库存
            if let shareStockModel = model.shareStockDTO , shareStockModel.shareStockDesc != nil {
                self.storeLabel.isHidden = false
                self.storeLabel.text = shareStockModel.shareStockDesc
                let maxW = self.storeLabel.text?.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t26.font], context: nil).width
                let desW = maxW!+WH(6)
                self.storeLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(self)
                    make.width.equalTo(desW)
                    make.height.equalTo(WH(18))
                    make.top.equalTo(retailView.snp.bottom).offset(WH(6))
                }
            }else{
                self.storeLabel.isHidden = true
                self.storeLabel.snp.updateConstraints { (make) in
                    make.width.height.equalTo(0)
                    make.top.equalTo(retailView.snp.bottom)
                }
            }
        }
        if let po = product as? ShopProductItemModel{
            
            if po.statusDesc != nil && (po.statusDesc == -2 || po.statusDesc == -3 ||  po.statusDesc == -4 || po.statusDesc == -6) {
            }
            else{
                if po.slowPay == true{
                    //慢必赔
                    self.tagStrArr.append("慢必赔")
                }
                if po.holdPrice == true{
                    //保价
                    self.tagStrArr.append("保价")
                }
                // 限购
                if let li = po.limitInfo, li.isEmpty == false {
                    self.tagStrArr.append("限购")
                }
                
                // 优惠券
                if let cp = po.includeCouponTemplateIds, cp.isEmpty == false {
                    self.tagStrArr.append("券")
                }
                
                // 返利金
                if let rb = po.isRebate, rb == 1 {
                    self.tagStrArr.append("返利")
                }
                
                // 套餐
                if let li = po.haveDinner, li == true {
                    self.tagStrArr.append("套餐")
                }
                if po.isHasSomeKindPromotion(["2", "3"]) {
                    self.tagStrArr.append("满减")
                }
                if po.isHasSomeKindPromotion(["5", "6", "7", "8"]) {
                    self.tagStrArr.append("满赠")
                }
                // 15:单品满折,16多品满折
                if po.isHasSomeKindPromotion(["15", "16"]) {
                    self.tagStrArr.append("满折")
                }
            }
            //
            if po.statusDesc == -2 || po.statusDesc == -1 || po.statusDesc == -4 {
                // 商品为控销及未登录不显示
                self.retailView.configRetailViewData(nil, nil)
                self.retailView.snp.updateConstraints({ (make) in
                    make.height.equalTo(WH(0))
                })
            }
            else {
                var priceDes : Float = 0 //最终显示价格
                if let priceStr = po.showPrice,priceStr > 0 {
                    priceDes = priceStr
                }
                if let priceStr = po.productPromotion?.promotionPrice,priceStr > 0  {
                    priceDes = priceStr
                }
                if let _ = po.vipPromotionId ,let vipNum = po.visibleVipPrice ,vipNum > 0 {
                    if let vipAvailableNum = po.availableVipPrice ,vipAvailableNum > 0 {
                        //会员
                        priceDes = vipNum
                    }
                }
                if priceDes > 0 ,let recomPrice = po.recommendPrice ,recomPrice > 0,recomPrice > priceDes {
                    // 显示毛利
                    self.retailView.isHidden = false
                    self.retailView.configRetailViewData(priceDes, recomPrice)
                    self.retailView.snp.updateConstraints({ (make) in
                        make.height.equalTo(WH(18+6))
                    })
                }
            }
            // 共享库存
            if po.stockIsLocal == false {
                self.storeLabel.isHidden = false
                if (po.shareStockDesc != nil && po.shareStockDesc!.isEmpty == false){
                    self.storeLabel.text =  po.shareStockDesc
                }else {
                    self.storeLabel.text =  "调拨中，预计一周内发货"
                }
                let maxW = self.storeLabel.text?.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t26.font], context: nil).width
                let desW = maxW!+WH(6)
                self.storeLabel.snp.remakeConstraints { (make) in
                    make.width.equalTo(desW)
                    make.height.equalTo(WH(18))
                    make.top.equalTo(retailView.snp.bottom).offset(WH(6))
                }
            }
            else {
                self.storeLabel.isHidden = true
                self.storeLabel.snp.updateConstraints { (make) in
                    make.width.height.equalTo(0)
                    make.top.equalTo(retailView.snp.bottom)
                }
            }
        }
        if let model = product as? SeckillActivityProductsModel{
            //二级秒杀
            if model.limitNum == "-1" || model.limitNum == "" {
                
            }else{
                self.fistLimitFlagLabel.isHidden = false
                self.fistLimitFlagLabel.text = "活动专享\(model.limitNum ?? "")\(model.unitName ?? "")"
                let limitedW = self.fistLimitFlagLabel.text?.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(16)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t29.font], context: nil).width
                let deslimitW = limitedW! + WH(12)
                self.fistLimitFlagLabel.snp.updateConstraints { (make) in
                    make.width.equalTo(deslimitW)
                }
            }
            
//            if model.seckillInventory == "-1" || model.seckillInventory == "" {
//
//            }else{
//                if self.fistLimitFlagLabel.isHidden{
//                    self.fistLimitFlagLabel.isHidden = false
//                    self.fistLimitFlagLabel.text = "活动总量\(model.seckillInventory ?? "")\(model.unitName ?? "")"
//                    let limitedW = self.fistLimitFlagLabel.text?.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(16)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t29.font], context: nil).width
//                    let deslimitW = limitedW! + WH(12)
//                    self.fistLimitFlagLabel.snp.updateConstraints { (make) in
//                        make.width.equalTo(deslimitW)
//                    }
//                }else{
//                    //                    self.secondLimitFlagLabel.isHidden = false
//                    //                    self.secondLimitFlagLabel.text = "活动总量\(model.seckillInventory ?? "")\(model.unitName ?? "")"
//                    //                    let limitedW = self.secondLimitFlagLabel.text?.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(16)), options: .usesLineFragmentOrigin, attributes:  [NSFontAttributeName : t29.font], context: nil).width
//                    //                    let deslimitW = limitedW! + WH(12)
//                    //                    self.secondLimitFlagLabel.snp.updateConstraints { (make) in
//                    //                        make.width.equalTo(deslimitW)
//                    //                    }
//                }
//            }
        }
        if let model = product as? FKYTogeterBuyModel{
            //MARK:一起购信息
            //标签1
            self.fistLimitFlagLabel.isHidden = false
            self.secondLimitFlagLabel.isHidden = false
            
            self.fistLimitFlagLabel.text = "起订量\(model.unit ?? 1)\(model.unitName ?? "盒")"
            let strW = self.fistLimitFlagLabel.text!.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:t29.font], context: nil).size.width + WH(12)
            self.fistLimitFlagLabel.snp.updateConstraints { (make) in
                make.width.equalTo(strW)
            }
            //标签2
            self.secondLimitFlagLabel.text = "最多认购\(model.subscribeNumPerClient ?? 0)\(model.unitName ?? "盒")"
            let strMaxW = self.secondLimitFlagLabel.text!.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:t29.font], context: nil).size.width  + WH(12)
            self.secondLimitFlagLabel.snp.updateConstraints { (make) in
                make.width.equalTo(strMaxW)
            }
        }
        if let po = product as? FKYFullProductModel{
            if po.statusDesc != nil && (po.statusDesc == -2 || po.statusDesc == -3 ||  po.statusDesc == -4 || po.statusDesc == -6) {
            }else{
                // 限购
                if  po.symbolLimitBuy == true {
                    self.tagStrArr.append("限购")
                }
                if let type = po.promationType,type == 2{
                    self.tagStrArr.append("满减")
                }
            }
            
        }
        if product is ShopListSecondKillProductItemModel{
            //店铺管秒杀特惠
        }
        if let  po = product as?  ShopListProductItemModel{
            //品种汇推荐
            if po.statusDesc != nil && (po.statusDesc == -2 || po.statusDesc == -3 ||  po.statusDesc == -4 || po.statusDesc == -6) {
            }else{
                self.showShopPromotionIcon(po.productSign as Any)
            }
        }
        if let po = product as?  FKYMedicinePrdDetModel{
            //中药材
            if po.statusDesc != nil && (po.statusDesc == -2 || po.statusDesc == -3 ||  po.statusDesc == -4 || po.statusDesc == -6) {
            }else{
                self.showShopPromotionIcon(po.productSign as Any)
            }
        }
        //MARK:商家特惠列表
        if let po = product as? FKYPreferetailModel {
            if po.priceStatus != nil && (po.priceStatus == -2 || po.priceStatus == -3 ||  po.priceStatus == -4 || po.priceStatus == -6) {
            }else{
                if let limitNumSign = Int(po.weekLimitNum ?? "0"),limitNumSign > 0{
                    self.tagStrArr.append("限购")
                }
                if po.tcSymbol == true {
                    self.tagStrArr.append("套餐")
                }
                if po.mjSymbol == true {
                    self.tagStrArr.append("满减")
                }
                if po.mzSymbol == true {
                    self.tagStrArr.append("满赠")
                }
            }
            
            // 共享库存
            if po.stockIsLocal == false {
                self.storeLabel.isHidden = false
                if (po.shareStockDesc != nil && po.shareStockDesc!.isEmpty == false){
                    self.storeLabel.text =  po.shareStockDesc
                }else {
                    self.storeLabel.text =  "调拨中，预计一周内发货"
                }
                let maxW = self.storeLabel.text?.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t26.font], context: nil).width
                let desW = maxW!+WH(6)
                self.storeLabel.snp.remakeConstraints { (make) in
                    make.width.equalTo(desW)
                    make.height.equalTo(WH(18))
                    make.top.equalTo(retailView.snp.bottom).offset(WH(6))
                }
            }
            else {
                self.storeLabel.isHidden = true
                self.storeLabel.snp.updateConstraints { (make) in
                    make.width.height.equalTo(0)
                    make.top.equalTo(retailView.snp.bottom)
                }
            }
            // 各标签展示优化~!@
        }
        //MARK:单品包邮
        if let model = product as? FKYPackageRateModel{
            //标签1
            self.fistLimitFlagLabel.isHidden = false
            self.secondLimitFlagLabel.isHidden = false
            
            self.fistLimitFlagLabel.text = "\(model.baseNum ?? 1)\(model.unitName ?? "盒")包邮"
            let strW = self.fistLimitFlagLabel.text!.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:t29.font], context: nil).size.width + WH(12)
            self.fistLimitFlagLabel.snp.updateConstraints { (make) in
                make.width.equalTo(strW)
            }
            //标签2
            if let limitNum = model.limitNum , let ynum = model.consumedNum, (limitNum-ynum) == 0 ,model.percentage != 100 {
                self.secondLimitFlagLabel.text = "已达本周可购上限"
            }else {
                self.secondLimitFlagLabel.text = "本周最多认购\(model.limitNum ?? 0)\(model.unitName ?? "盒")"
            }
            let strMaxW = self.secondLimitFlagLabel.text!.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:t29.font], context: nil).size.width  + WH(12)
            self.secondLimitFlagLabel.snp.updateConstraints { (make) in
                make.width.equalTo(strMaxW)
            }
        }
        if self.tagStrArr.count > 0 {
            tagCollectionView.snp.updateConstraints( { (make) in
                make.height.equalTo(TAG_H)
            })
            tagCollectionView.isHidden = false
        }else {
            tagCollectionView.snp.updateConstraints( { (make) in
                make.height.equalTo(0)
            })
            tagCollectionView.isHidden = true
        }
        self.tagCollectionView.reloadData()
    }
    // 促销打标 & 限购打标 & 优惠券打标
    func showShopPromotionIcon(_ product: Any) {
        if let sign = product as? ProductSignModel{
            if sign.purchaseLimit! {
                self.tagStrArr.append("限购")
            }
            if sign.ticket! {
                self.tagStrArr.append("券")
            }
            if sign.rebate! {
                self.tagStrArr.append("返利")
            }
            if sign.bounty == true{
                //协议奖励金
                self.tagStrArr.append("协议奖励金")
            }
            if sign.packages! {
                self.tagStrArr.append("套餐")
            }
            if sign.fullScale! {
                self.tagStrArr.append("满减")
            }
            if sign.fullGift! {
                self.tagStrArr.append("满赠")
            }
            if sign.fullDiscount == true{
                //满折
                self.tagStrArr.append("满折")
            }
        }
        if let sign = product as? FKYMedicineTagModel{
            if sign.purchaseLimit! {
                self.tagStrArr.append("限购")
            }
            if sign.ticket! {
                self.tagStrArr.append("券")
            }
            if sign.rebate! {
                self.tagStrArr.append("返利")
            }
            if sign.bounty == true{
                //协议奖励金
                self.tagStrArr.append("协议奖励金")
            }
            if sign.packages! {
                self.tagStrArr.append("套餐")
            }
            if sign.fullScale! {
                self.tagStrArr.append("满减")
            }
            if sign.fullGift! {
                self.tagStrArr.append("满赠")
            }
            if sign.fullDiscount == true{
                //满折
                self.tagStrArr.append("满折")
            }
        }
        
    }
    
    //获取行高
    static func getContentHeight(_ product: Any) -> CGFloat{
        var Cell = WH(0)
        if let model = product as? HomeProductModel {
            if model.statusDesc != nil && (model.statusDesc == -2 || model.statusDesc == -3 ||  model.statusDesc == -4 || model.statusDesc == -6) {
            }
            else {
                // 判断是否有活动
                var hasTag = false
                if model.slowPay == true{
                    //慢必赔
                     hasTag = true
                }
                if model.holdPrice == true{
                    //保价
                     hasTag = true
                }
                //判断是否显示专享价
                if model.isShowExclusivePrice(){
                    // 隐藏
                    hasTag = true
                }
                // 0.限购
                if let li = model.limitInfo, li.isEmpty == false {
                    hasTag = true
                }
                // 1.优惠券
                if let cp = model.includeCouponTemplateIds, cp.isEmpty == false{
                    hasTag = true
                }
                // 2.返利金
                if let rb = model.isRebate, rb == 1 {
                    hasTag = true
                }
                // 3.套餐
                if let li = model.haveDinner, li == true {
                    hasTag = true
                }
                // 协议返利金
                if let rebate = model.protocolRebate, rebate == true {
                    hasTag = true
                }
                var aryPromotionDes: [[String:UIColor]] = []
                if model.isHasSomeKindPromotion(["2", "3"]) {
                    // 4.满减
                    aryPromotionDes.append(["满减": RGBColor(0xFFA083)])
                }
                if model.isHasSomeKindPromotion(["5", "6", "7", "8"]) {
                    // 5.满赠
                    aryPromotionDes.append(["满赠": RGBColor(0xFFC470)])
                }
                if model.isHasSomeKindPromotion(["15", "16"]) {
                    // 5.满赠
                    aryPromotionDes.append(["满折": RGBColor(0xFFC470)])
                }
                if aryPromotionDes.count > 0 {
                    hasTag = true
                }
                if hasTag == true {
                    Cell = Cell + WH(22)
                }
            }
            
            //商品为控销及未登录不显示
            if model.statusDesc == -2 || model.statusDesc == -1 || model.statusDesc == -4  {
                // 不显示
            }
            else {
                var priceDes : Float = 0 //最终显示价格
                if let priceStr = model.productPrice,priceStr > 0 {
                    priceDes = priceStr
                }
                if let priceStr = model.productPromotion?.promotionPrice,priceStr > 0  {
                    priceDes = priceStr
                }
                if let _ = model.vipPromotionId ,let vipNum = model.visibleVipPrice ,vipNum > 0  {
                    priceDes = vipNum
                }
                if priceDes > 0 ,let recomPrice = model.recommendPrice ,recomPrice > 0 ,recomPrice > priceDes {
                    //显示毛利
                    Cell = Cell + WH(24)
                }
            }
            
            //分享库存
            var hasShareStock = false
            if model.stockIsLocal == false {
                hasShareStock = true
            }
            if hasShareStock == true {
                Cell = Cell + WH(22)
            }
        }
        if let model = product as? FKYProductObject{
            if model.priceInfo != nil && (model.priceInfo.status == "-2" || model.priceInfo.status == "-3" ||  model.priceInfo.status == "-4" || model.priceInfo.status == "-6") {
            }
            else {
                // 判断是否有活动
                var hasTag = false
                
                // 0.限购
                if let info = model.productLimitInfo,let li = info.limitInfo,li.isEmpty == false {
                    hasTag = true
                }
                // 1.优惠券
                if let cp = model.couponList, cp.isEmpty == false{
                    hasTag = true
                }
                // 2.返利金
                if let info = model.rebateInfo, let rb = info.isRebate, rb == 1 {
                    hasTag = true
                }
                // 3.套餐
                if let info = model.dinnerInfo , let li = info.dinnerList, li.isEmpty == false {
                    hasTag = true
                }
                // 协议返利金
                if let rebateProtocol = model.rebateProtocol,rebateProtocol.protocolRebate == true {
                    hasTag = true
                }
                var aryPromotionDes: [[String:UIColor]] = []
                if model.promotionCount() > 0{
                    // 4.满减
                    aryPromotionDes.append(["满减": RGBColor(0xFFA083)])
                }
                if model.fullGiftCount() > 0 {
                    // 5.满赠
                    aryPromotionDes.append(["满赠": RGBColor(0xFFC470)])
                }
                if model.fullDiscountCount() > 0{
                    // 5.满赠
                    aryPromotionDes.append(["满折": RGBColor(0xFFC470)])
                }
                if aryPromotionDes.count > 0 {
                    hasTag = true
                }
                if hasTag == true {
                    Cell = Cell + WH(22)
                }
            }
            
            //商品为控销及未登录不显示
            if model.priceInfo.status == "-2" || model.priceInfo.status == "-1" || model.priceInfo.status == "-4"  {
                // 不显示
            }
            else {
                var priceDes : Float = 0 //最终显示价格
                if let priceStr = model.priceInfo.price,(priceStr as NSString).floatValue > 0 {
                    priceDes = (priceStr as NSString).floatValue
                }
                if let priceStr = model.productPromotion?.promotionPrice,priceStr.floatValue  > 0  {
                    priceDes = priceStr.floatValue
                }
                if let pVip = model.vipPromotionInfo,let _ = pVip.vipPromotionId,let _ = pVip.visibleVipPrice, let vipNum = Float(pVip.visibleVipPrice), vipNum > 0  {
                    priceDes = vipNum
                }
                if priceDes > 0 , let recomPrice = model.priceInfo.recommendPrice, (recomPrice as NSString).floatValue > 0, (recomPrice as NSString).floatValue > priceDes, model.isZiYingFlag == 1 {
                    //显示毛利
                    Cell = Cell + WH(24)
                }
            }
        }
        if let model = product as? SearchMpHockProductModel{
            // 16多品满折
            if  model.productPromotionInfo != nil &&  model.productPromotionInfo?.promotionType == "16"{
                Cell = Cell + WH(22)
            }
            
        }
        if let model = product as? OftenBuyProductItemModel{
            //常购清单
            var hasTag = false
            if let sign = model.productSign {
                if sign.bounty == true{
                    //协议奖励金
                    hasTag = true
                }
                if sign.fullDiscount == true{
                    //满折
                    hasTag = true
                }
                if sign.fullGift == true{
                    //满赠
                    hasTag = true
                }
                if sign.fullScale == true{
                    //满减
                    hasTag = true
                }
                if sign.packages == true{
                    //套餐
                    hasTag = true
                }
                if sign.purchaseLimit == true{
                    //限购
                    hasTag = true
                }
                if sign.rebate == true{
                    //返利
                    hasTag = true
                }
                if sign.ticket == true{
                    //券
                    hasTag = true
                }
                if hasTag == true {
                    Cell = Cell + WH(22)
                }
            }
            //分享库存
            var hasShareStock = false
            if  model.shareStockDesc != nil && model.shareStockDesc!.isEmpty == false {
                hasShareStock = true
            }
            if hasShareStock == true {
                Cell = Cell + WH(22)
            }
        }
        if let model = product as? ShopProductCellModel {
            if model.statusDesc != nil && (model.statusDesc == -2 || model.statusDesc == -3 ||  model.statusDesc == -4 || model.statusDesc == -6) {
            }
            else {
                // 判断是否有活动
                var hasTag = false
                
                // 0.限购
                if let li = model.limitInfo, li.isEmpty == false {
                    hasTag = true
                }
                // 1.优惠券
                if let cp = model.includeCouponTemplateIds, cp.isEmpty == false{
                    hasTag = true
                }
                // 2.返利金
                if let rb = model.isRebate, rb == 1 {
                    hasTag = true
                }
                // 3.套餐
                if let li = model.haveDinner, li == true {
                    hasTag = true
                }
                
                var aryPromotionDes: [[String:UIColor]] = []
                if model.isHasSomeKindPromotion(["2", "3"]) {
                    // 4.满减
                    aryPromotionDes.append(["满减": RGBColor(0xFFA083)])
                }
                if model.isHasSomeKindPromotion(["5", "6", "7", "8"]) {
                    // 5.满赠
                    aryPromotionDes.append(["满赠": RGBColor(0xFFC470)])
                }
                if model.isHasSomeKindPromotion(["15", "16"]) {
                    // 5.满赠
                    aryPromotionDes.append(["满折": RGBColor(0xFFC470)])
                }
                if aryPromotionDes.count > 0 {
                    hasTag = true
                }
                if hasTag == true {
                    Cell = Cell + WH(22)
                }
            }
            //分享库存
            var hasShareStock = false
            if model.stockIsLocal == false  {
                hasShareStock = true
            }
            if hasShareStock == true {
                Cell = Cell + WH(22)
            }
            
        }
        if let model = product as? HomeCommonProductModel {
            var hasTag = false
            if let sign = model.productSign {
                if sign.slowPay == true{
                    //慢必赔
                    hasTag = true
                }
                if sign.holdPrice == true{
                    //保价
                    hasTag = true
                }
                if sign.bounty == true{
                    //协议奖励金
                    hasTag = true
                }
                if sign.fullDiscount == true{
                    //满折
                    hasTag = true
                }
                if sign.fullGift == true{
                    //满赠
                    hasTag = true
                }
                if sign.fullScale == true{
                    //满减
                    hasTag = true
                }
                if sign.packages == true{
                    //套餐
                    hasTag = true
                }
                if sign.purchaseLimit == true{
                    //限购
                    hasTag = true
                }
                if sign.rebate == true{
                    //返利
                    hasTag = true
                }
                if sign.ticket == true{
                    //券
                    hasTag = true
                }
                if hasTag == true {
                    Cell = Cell + WH(22)
                }
            }
            //加共享库存标签
            if let shareStockModel = model.shareStockDTO , shareStockModel.shareStockDesc != nil{
                Cell += WH(22)
            }
        }
        if let model = product as? FKYFullProductModel{
            if model.statusDesc != nil && (model.statusDesc == -2 || model.statusDesc == -3 ||  model.statusDesc == -4 || model.statusDesc == -6) {
            }
            else {
                // 判断是否有活动
                var hasTag = false
                
                // 0.限购
                if  model.symbolLimitBuy == true{
                    hasTag = true
                }
                if  model.promationType == 2{
                    //满减
                    hasTag = true
                }
                if hasTag == true {
                    Cell = Cell + WH(22)
                }
            }
            
        }
        if let model = product as? SeckillActivityProductsModel{
            if model.limitNum == "-1" || model.limitNum == "" {
               // if model.seckillInventory == "-1" || model.seckillInventory == "" {
                    Cell = Cell + WH(0)
//                }else{
//                    Cell = Cell + WH(22)
//                }
            }else{
                Cell = Cell + WH(22)
            }
        }
        //MARK:一起购信息
        if product is FKYTogeterBuyModel{
            Cell = Cell + WH(22)
        }
        if let model = product as?  ShopListProductItemModel{
            //品种汇推荐
            var hasTag = false
            if let sign = model.productSign {
                if sign.rebate! {
                    hasTag = true
                }
                if sign.packages! {
                    hasTag = true
                }
                if sign.fullScale! {
                    hasTag = true
                }
                if sign.fullGift! {
                    hasTag = true
                }
                if sign.ticket! {
                    hasTag = true
                }
                if sign.purchaseLimit! {
                    hasTag = true
                }
                if sign.bounty == true{
                    //协议奖励金
                    hasTag = true
                }
                if sign.fullDiscount == true{
                    //满折
                    hasTag = true
                }
            }
            if hasTag == true {
                Cell = Cell + WH(22)
            }
        }
        if let model = product as?  FKYMedicinePrdDetModel{
            //中药材
            var hasTag = false
            if let sign = model.productSign {
                if sign.rebate! {
                    hasTag = true
                }
                if sign.packages! {
                    hasTag = true
                }
                if sign.fullScale! {
                    hasTag = true
                }
                if sign.fullGift! {
                    hasTag = true
                }
                if sign.ticket! {
                    hasTag = true
                }
                if sign.purchaseLimit! {
                    hasTag = true
                }
                if sign.bounty == true{
                    //协议奖励金
                    hasTag = true
                }
                if sign.fullDiscount == true{
                    //满折
                    hasTag = true
                }
            }
            if hasTag == true {
                Cell = Cell + WH(22)
            }
        }
        if let model = product as? ShopProductItemModel{
            if model.statusDesc != nil && (model.statusDesc == -2 || model.statusDesc == -3 ||  model.statusDesc == -4 || model.statusDesc == -6) {
            }
            else {
                // 判断是否有活动
                var hasTag = false
                
                if model.slowPay == true {
                    //慢必赔
                    hasTag = true
                }
                if model.holdPrice == true {
                    //保价
                    hasTag = true
                }
                // 0.限购
                if let li = model.limitInfo, li.isEmpty == false {
                    hasTag = true
                }
                // 1.优惠券
                if let cp = model.includeCouponTemplateIds, cp.isEmpty == false{
                    hasTag = true
                }
                // 2.返利金
                if let rb = model.isRebate, rb == 1 {
                    hasTag = true
                }
                // 3.套餐
                if let li = model.haveDinner, li == true {
                    hasTag = true
                }
                // 协议返利金
                if let rebate = model.protocolRebate, rebate == true {
                    hasTag = true
                }
                var aryPromotionDes: [[String:UIColor]] = []
                if model.isHasSomeKindPromotion(["2", "3"]) {
                    // 4.满减
                    aryPromotionDes.append(["满减": RGBColor(0xFFA083)])
                }
                if model.isHasSomeKindPromotion(["5", "6", "7", "8"]) {
                    // 5.满赠
                    aryPromotionDes.append(["满赠": RGBColor(0xFFC470)])
                }
                if model.isHasSomeKindPromotion(["15", "16"]) {
                    // 5.满赠
                    aryPromotionDes.append(["满折": RGBColor(0xFFC470)])
                }
                if aryPromotionDes.count > 0 {
                    hasTag = true
                }
                if hasTag == true {
                    Cell = Cell + WH(22)
                }
            }
            //商品为控销及未登录不显示
            if model.statusDesc == -2 || model.statusDesc == -1 || model.statusDesc == -4  {
                // 不显示
            }
            else {
                var priceDes : Float = 0 //最终显示价格
                if let priceStr = model.showPrice,priceStr > 0 {
                    priceDes = priceStr
                }
                if let priceStr = model.productPromotion?.promotionPrice,priceStr > 0  {
                    priceDes = priceStr
                }
                if let _ = model.vipPromotionId ,let vipNum = model.visibleVipPrice ,vipNum > 0  {
                    priceDes = vipNum
                }
                if priceDes > 0 ,let recomPrice = model.recommendPrice ,recomPrice > 0 ,recomPrice > priceDes {
                    //显示毛利
                    Cell = Cell + WH(24)
                }
            }
            //分享库存
            var hasShareStock = false
            if model.stockIsLocal == false {
                hasShareStock = true
            }
            if hasShareStock == true {
                Cell = Cell + WH(22)
            }
        }
        //MARK:商家特惠
        if let model = product as? FKYPreferetailModel {
            if model.priceStatus != nil && (model.priceStatus == -2 || model.priceStatus == -3 ||  model.priceStatus == -4 || model.priceStatus == -6) {
            }
            else {
                // 判断是否有活动
                var hasTag = false
                // 满减 / 满赠 / 满折 / 限购 / 券 / 返利 / 套餐 / 协议奖励金
                if model.mjSymbol == true {
                    hasTag = true
                }
                if model.mzSymbol == true {
                    hasTag = true
                }
                if let limitNumSign = Int(model.weekLimitNum ?? "0"),limitNumSign > 0{
                    hasTag = true
                }
                if model.tcSymbol == true {
                    hasTag = true
                }
                
                if hasTag == true {
                    Cell = Cell + WH(22)
                }
            }
            //分享库存
            var hasShareStock = false
            if model.stockIsLocal == false {
                hasShareStock = true
            }
            if hasShareStock == true {
                Cell = Cell + WH(22)
            }
        }
        //MARK:单品包邮
        if let _ = product as? FKYPackageRateModel{
            Cell = Cell + WH(22)
        }
        return Cell
    }
}

extension ProductPromationInfoView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagStrArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let str = self.tagStrArr[indexPath.row]
        let strW = str.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], context: nil).size.width
        if strW < WH(30) {
            return CGSize(width:WH(30), height:TAG_H)
        }else {
            return CGSize(width:(strW + WH(8)), height:TAG_H)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return WH(6)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYShopTypeCell", for: indexPath) as! FKYShopTypeCell
        cell.configTagData(tagStrArr[indexPath.row])
        return cell
    }
}
