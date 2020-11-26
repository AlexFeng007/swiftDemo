//
//  FKYComboDetailCellCollectionViewCell.swift
//  FKY
//
//  Created by Andy on 2018/10/8.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  套餐详情cell

import UIKit

let TOP_VIEW_COMBO_H = WH(45) //顶部视图高度
let BOTTOM_VIEW_COMBO_H = WH(125+29-8) //底部视图高度
let PRDOUCT_VIEW_H = WH(80) //商品cell高度
let PRDOUCT_ADD_VIEW_H = WH(30) //加号行高度

class FKYComboDetailCellCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //     MARK: - property
    //头部背景图************************************
    fileprivate lazy var topBgView : UIView = {
        let view = UIView.init()
        return view
    }()
    
    //套餐名称
    fileprivate lazy var comboNameLabel : UILabel = {
        let label = UILabel.init()
        label.fontTuple = t16
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    //底部视图相关*********************************
    fileprivate lazy var bottomView : UIView = {
        let view = UIView.init()
        return view
    }()
    
    fileprivate lazy var topBottomLineView : UIView = {
        let view = UIView.init()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    // 每天限购数量
    fileprivate lazy var limitDayBuy: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    fileprivate lazy var comboPriceDespLabel : UILabel = {
        let label = UILabel.init()
        label.text = "套餐价："
        label.textColor = t73.color
        label.font = t45.font
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    //购买价格
    fileprivate lazy var comboDiscountLabel : UILabel = {
        let label = UILabel.init()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = t73.color
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        return label
    }()
    
    //原价格
    fileprivate lazy var comboPriceLabel : UILabel = {
        let label = UILabel.init()
        label.fontTuple = t23
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        let centerLine = UIView()
        centerLine.backgroundColor = t23.color
        label.addSubview(centerLine)
        centerLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(label)
            make.height.equalTo(WH(1))
            make.left.equalTo(label.snp.left)
            make.right.equalTo(label.snp.right)
        }
        return label
    }()
    
    fileprivate lazy var cartStepperView : CartStepper = {
        let stepper = CartStepper()
        stepper.minusBtn.isEnabled = false
        stepper.comboPattern()
        stepper.toastBlock = { [weak self]
            (str) in
            if let strongSelf = self {
                if let closure = strongSelf.toastAddProductNum {
                    if let model = strongSelf.comboModel , let num = model.maxBuyNumPerDay, num > 0 {
                        let maxBuyNum = model.getAddMaxNum()
                        closure("您每天最多购买\(maxBuyNum)套，暂时无法购买")
                    }else {
                        closure(str ?? "")
                    }
                }
            }
        }
        
        stepper.updateProductBlock = { [weak self] (count : Int,typeIndex : Int) in
            if let strongSelf = self {
                strongSelf.groupCount = count
                if strongSelf.comboModel != nil {
                    strongSelf.changePriceWith(count: Float(count))
                }
                if count <= 1 {
                    stepper.minusBtn.isEnabled = false
                }else{
                    stepper.minusBtn.isEnabled = true
                }
                let maxBuyNum = strongSelf.comboModel?.getAddMaxNum() ?? 0
                if count >= maxBuyNum {
                    stepper.addBtn.isEnabled = false
                }else{
                    stepper.addBtn.isEnabled = true
                }
            }
            
        }
        return stepper
    }()
    
    fileprivate lazy var addShopButton : UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle("购买套餐", for: .normal)
        button.setTitleColor(RGBColor(0xFFFFFF), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(16))
        button.backgroundColor = RGBColor(0xFF2D5C)
        button.layer.cornerRadius = WH(4)
        button.addTarget(self, action: #selector(addShopButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    var productList : [ComboProductListModel]?
    var comboModel : ComboListModel?
    var proViewArr =  [ComboProductView]() //存放商品视图
    var groupCount : Int = 1
    typealias AddShopButtonCallBlock = (_ count: Int) -> Void
    var addShopButtonCallBlock: AddShopButtonCallBlock?
    var toastAddProductNum : SingleStringClosure? //加车提示
    
    func setupView() {
        self.layer.cornerRadius = 8
        self.backgroundColor = .white
        
        //头部相关视图************************
        contentView.addSubview(topBgView)
        topBgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(TOP_VIEW_COMBO_H)
        }
        
        topBgView.addSubview(comboNameLabel)
        comboNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topBgView.snp.left).offset(WH(14))
            make.top.equalTo(topBgView.snp.top).offset(WH(14))
            make.right.equalTo(topBgView.snp.right).offset(-WH(14))
        }
        
        //底部视图****************************
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(BOTTOM_VIEW_COMBO_H)
        }
        
        bottomView.addSubview(topBottomLineView)
        topBottomLineView.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView.snp.left).offset(WH(11))
            make.right.equalTo(bottomView.snp.right).offset(-WH(11))
            make.top.equalTo(bottomView.snp.top).offset(WH(29))
            make.height.equalTo(WH(0.5))
        }
        
        bottomView.addSubview(cartStepperView)
        cartStepperView.snp.makeConstraints { (make) in
            make.right.equalTo(bottomView.snp.right)
            make.left.equalTo(bottomView.snp.left)
            make.top.equalTo(topBottomLineView.snp.bottom).offset((WH(15)))
            make.height.equalTo(WH(32))
        }
        
        bottomView.addSubview(addShopButton)
        addShopButton.snp.makeConstraints { (make) in
            make.right.equalTo(bottomView.snp.right).offset(-WH(11))
            make.bottom.equalTo(bottomView.snp.bottom).offset(-(WH(14)))
            make.height.equalTo(WH(43))
            make.width.equalTo((WH(117)))
        }
        
        bottomView.addSubview(comboPriceLabel)
        comboPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView.snp.left).offset(WH(12))
            make.bottom.equalTo(bottomView.snp.bottom).offset((-WH(28)))
            make.height.equalTo(WH(14))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-WH(100))
        }
        
        bottomView.addSubview(comboPriceDespLabel)
        comboPriceDespLabel.snp.makeConstraints { (make) in
            make.left.equalTo(comboPriceLabel.snp.left)
            make.bottom.equalTo(comboPriceLabel.snp.top).offset((-WH(3)))
            make.height.equalTo(WH(16))
            make.width.lessThanOrEqualTo(WH(65))
        }
        
        bottomView.addSubview(comboDiscountLabel)
        comboDiscountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(comboPriceDespLabel.snp.right)
            make.centerY.equalTo(comboPriceDespLabel.snp.centerY)
            make.height.equalTo(WH(14))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-WH(155))
        }
        bottomView.addSubview(limitDayBuy)
        limitDayBuy.snp.makeConstraints { (make) in
            make.left.equalTo(comboPriceLabel.snp.left)
            make.right.equalTo(bottomView.snp.right).offset(-WH(15))
            make.height.equalTo(WH(12))
            make.bottom.equalTo(comboPriceDespLabel.snp.top).offset(-WH(16))
        }
    }
    
    
    // #MARK: - method
    @objc func addShopButtonClick(_ sender : UIButton) {
        if addShopButtonCallBlock != nil {
            addShopButtonCallBlock!(self.groupCount)
        }
    }
    
    func configCell(comboList : [ComboListModel] , index : Int) {
        self.comboModel = comboList[index]
        
        if let model =  self.comboModel {
            self.comboNameLabel.text = model.promotionName
            //原价
            if let oldPriceStr = model.originPrice, let oldPriceNum = Float(oldPriceStr) {
                comboPriceLabel.text = String.init(format: "原价 ¥%.2f",oldPriceNum)
            }else {
                comboPriceLabel.text = ""
            }
            //套餐价
            if let priceStr = model.dinnerPrice, let priceNum = Float(priceStr) {
                comboDiscountLabel.text = String.init(format: "¥%.2f",priceNum)
                comboDiscountLabel.adjustPriceLabelWihtFont(t21.font)
            }else {
                comboDiscountLabel.text = ""
            }
            //判断是否有每日限购逻辑
            if let num = model.maxBuyNumPerDay, num > 0 {
                limitDayBuy.text = "每日限购\(num)套"
                limitDayBuy.isHidden = false
                bottomView.snp.updateConstraints { (make) in
                    make.height.equalTo(BOTTOM_VIEW_COMBO_H+WH(28))
                }
            }else {
                limitDayBuy.isHidden = true
                limitDayBuy.text = ""
                bottomView.snp.updateConstraints { (make) in
                    make.height.equalTo(BOTTOM_VIEW_COMBO_H)
                }
            }
            
            //设置购物车
            let quantity : Int?
            if model.carOfCount == 0{
                quantity = 1
            }else{
                quantity = comboModel?.carOfCount
            }
            let maxBuyNum = model.getAddMaxNum()
            self.cartStepperView.configStepperBaseCount(1, stepCount: 1, stockCount: maxBuyNum, limitBuyNum: maxBuyNum, quantity: quantity! ,and:false, and:1)
            
            if quantity! <= 1 {
                self.cartStepperView.minusBtn.isEnabled = false
            }else{
                self.cartStepperView.minusBtn.isEnabled = true
            }
            
            self.productList = model.productList
            if self.productList != nil {
                addProductWithCount(productCount: self.productList!.count,index)
            }
            
            if Float(model.carOfCount) > 1 {
                self.changePriceWith(count: Float(model.carOfCount))
            }
        }
    }
    
    func addProductWithCount(productCount : Int, _ index : Int) {
        for subview in self.contentView.subviews {
            if subview.isKind(of: ComboProductView.self) || subview.isKind(of:UIImageView.self){
                subview.removeFromSuperview()
            }
        }
        
        guard let list = self.productList, list.count > 0, productCount <= list.count else {
            return
        }
        
        // 总高度
        var heightTotal: CGFloat = WH(0)
        self.proViewArr.removeAll()
        for i in 0..<productCount {
            // model
            let model: ComboProductListModel = list[i]
            let productId = model.spuCode
            let supplyId = model.supplyId
            
            // 高度
            let heightItem = ComboProductView.getCellHeight(model)
            
            // view
            let view1 = ComboProductView.init()
            self.proViewArr.append(view1)
            contentView.addSubview(view1)
            view1.snp.makeConstraints { (make) in
                make.left.right.equalTo(contentView)
                make.height.equalTo(heightItem)
                make.top.equalTo(topBgView.snp.bottom).offset(heightTotal)
            }
            view1.configComboProduct(model: model)
            view1.buttonCallBlock = {
                //点击套餐埋点
                var priceStr = ""
                
                if let dinnerPrice = model.dinnerPrice {
                    priceStr = String(format: "￥%.2f", Float(dinnerPrice) ?? 0.0)
                }
                if let orginalPrice = model.originalPrice{
                    if priceStr.isEmpty == false{
                        priceStr =  priceStr + "|"
                    }
                    priceStr =  priceStr + String(format: "￥%.2f", Float(orginalPrice) ?? 0.0)
                }
                var canBuyNum = ""
                if let doorsill = Int(model.doorsill ?? "0"),doorsill > 0{
                    let maxBuyNum = self.comboModel?.getAddMaxNum() ?? 0
                    if maxBuyNum  > 0 {
                        canBuyNum =  "\(maxBuyNum * doorsill)" + "|"
                    }
                }
                if let stockCount = model.stockCount,stockCount.isEmpty == false,Int(stockCount)! > 0{
                    canBuyNum = canBuyNum + model.stockCount!
                }
                
                
                //点击套餐商品埋点
                let extentDic:[String:AnyObject] = ["pm_price":priceStr as AnyObject,"storage": canBuyNum as AnyObject,"pm_pmtn_type":"套餐" as AnyObject]
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "套餐专区", sectionId: "S6401", sectionPosition: "\(index+1)", sectionName: self.comboModel?.promotionName, itemId: "I6421", itemPosition: "\(i+1)", itemName: "点进商详", itemContent: "\(supplyId ?? "")|\(productId ?? "")", itemTitle: nil, extendParams: extentDic, viewController: CurrentViewController.shared.item)
                // 跳转商详
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKYProductionDetailViewController
                    v.productionId = productId
                    v.vendorId = supplyId
                }, isModal: false)
            }
            
            // 加号
            if i < productCount - 1 {
                let add = UIImageView.init(image: UIImage.init(named: "combo_product_add"))
                contentView.addSubview(add)
                add.snp.makeConstraints { (make) in
                    make.left.equalTo(contentView.snp.left).offset(WH(38))
                    make.height.width.equalTo(PRDOUCT_ADD_VIEW_H)
                    make.top.equalTo(view1.snp.bottom)
                }
                heightTotal = heightTotal + PRDOUCT_ADD_VIEW_H
            }
            // 总高度
            heightTotal = heightTotal + heightItem
        } // for
    }
    
    func changePriceWith(count : Float) {
        if let model =  self.comboModel {
            //原价
            if let oldPriceStr = model.originPrice, let oldPriceNum = Double(oldPriceStr) {
                comboPriceLabel.text = String.init(format: "原价 ¥%.2f",oldPriceNum*Double(count))
            }else {
                comboPriceLabel.text = ""
            }
            //套餐价
            if let priceStr = model.dinnerPrice, let priceNum = Double(priceStr) {
                comboDiscountLabel.text = String.init(format: "¥%.2f",priceNum*Double(count))
                comboDiscountLabel.adjustPriceLabelWihtFont(t21.font)
            }else {
                comboDiscountLabel.text = ""
            }
        }
        for prdView in self.proViewArr {
            prdView.configNumLabelWith(count: Int(count))
        }
        //        for subview in self.subviews {
        //            if subview.isKind(of: ComboProductView.self) {
        //                (subview as! ComboProductView).configNumLabelWith(count:Int(count))
        //            }
        //        }
    }
    
    //
    static func getCellHeight(_ comBoModel: ComboListModel?) -> CGFloat {
        guard let model = comBoModel, let list = model.productList, list.count > 0 else {
            return 0
        }
        var cell_h = TOP_VIEW_COMBO_H+BOTTOM_VIEW_COMBO_H
        if let num = model.maxBuyNumPerDay, num > 0 {
            cell_h = cell_h + WH(28)
        }
        let count = list.count
        for i in 0..<count {
            // 高度
            let model: ComboProductListModel = list[i]
            let heightItem = ComboProductView.getCellHeight(model)
            cell_h = cell_h + heightItem
            if i < count - 1 {
                cell_h = cell_h + PRDOUCT_ADD_VIEW_H
            }
        }
        return cell_h
    }
}
