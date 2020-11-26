//
//  FKYHomePageItemType4.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/22.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  商家特惠 两个商品的样式

import UIKit

class FKYHomePageItemType4: UIView {

    
    /// 商品1点击事件
    static let productClickedAction = "FKYHomePageItemType4-productClickedAction"
    
    /// 商品2点击事件
    //static let product2ClickedAction = "FKYHomePageItemType4-product2ClickedAction"
    
    //BI埋点事件
    static let ItemBIAction = "FKYHomePageItemType4-ItemBIAction"
    
    lazy var titleLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = .boldSystemFont(ofSize: WH(15))
        return lb
    }()
    
    /// 当前豆腐块的标签
    var tagView:FKYHomePageSectionTypeTagView = FKYHomePageSectionTypeTagView()
    
    /// 商品主图1
    lazy var productImg1:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageItemType4.product1Clicked), for: .touchUpInside)
        return bt
    }()
    
    /// 商品主图2
    lazy var productImg2:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageItemType4.product2Clicked), for: .touchUpInside)
        return bt
    }()
    
    /// 商品销售价格1
    lazy var sellPrice1:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0xFF2D5C)
        lb.font = .systemFont(ofSize:WH(14))
        lb.textAlignment = .center
        return lb
    }()
    
    /// 商品销售价格2
    lazy var sellPrice2:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0xFF2D5C)
        lb.font = .systemFont(ofSize:WH(14))
        lb.textAlignment = .center
        return lb
    }()
    
    /// 商品划线价1
    var linePrice1:UILabel = {
        let label = UILabel()
        label.fontTuple = t28
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        let line = UIView()
        label.addSubview(line)
        line.snp.makeConstraints({ (make) in
            make.left.right.centerY.equalTo(label)
            make.height.equalTo(WH(1))
        })
        line.backgroundColor = t11.color
        return label
    }()
    
    /// 商品划线价2
    var linePrice2:UILabel = {
        let label = UILabel()
        label.fontTuple = t28
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        let line = UIView()
        label.addSubview(line)
        line.snp.makeConstraints({ (make) in
            make.left.right.centerY.equalTo(label)
            make.height.equalTo(WH(1))
        })
        line.backgroundColor = t11.color
        return label
    }()
    
    /// 右边分割线
    lazy var rightMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        return view
    }()
    
    var itemModel:FKYHomePageV3ItemModel = FKYHomePageV3ItemModel()
    var productImageList:[UIButton] = [UIButton]()
    var sellPriceList:[UILabel] = [UILabel]()
    var linePriceList:[UILabel] = [UILabel]()
    /*
    /// 底部分割线
    lazy var bottomMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        return view
    }()
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        productImageList = [productImg1,productImg2]
        sellPriceList = [sellPrice1,sellPrice2]
        linePriceList = [linePrice1,linePrice2]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - 数据展示
extension FKYHomePageItemType4{
    func showData(itemModel:FKYHomePageV3ItemModel){
        self.itemModel = itemModel
        titleLB.text = self.itemModel.name
        tagView.configType(iconName: "home_shop_dir", borderColor: RGBColor(0xFF2D5C), cornerRadius: WH(16/2.0), textColor: RGBColor(0xFF2D5C))
        tagView.configTitle(title: self.itemModel.title)
        for (index,product) in self.itemModel.floorProductDtos.enumerated() {
            configProductInfo(index: index, product: product)
        }
    }
    
    func configProductInfo(index:Int,product:FKYHomePageV3FloorProductModel){
        guard index < productImageList.count else {
            return
        }
        let imagebtn = productImageList[index]
        let sellPrice = sellPriceList[index]
        let linePrice = linePriceList[index]
        imagebtn.sd_setImage(with: URL(string: product.imgPath), for: .normal, placeholderImage: UIImage(named: "image_default_img"))
        if product.statusDesc == 0 {
            //商品价格相关
            linePrice.text = ""
            if product.productPrice > 0 {
                sellPrice.text = String.init(format: "¥ %.2f", product.productPrice)
            }else {
                sellPrice.text = "¥--"
            }
            if product.availableVipPrice > 0 {
                //有会员价格
                sellPrice.text = String.init(format: "¥ %.2f", product.availableVipPrice)
                if itemModel.togetherMark != 1 {
                    //一起购不显示原价
                    linePrice.text = String.init(format: "¥%.2f", product.productPrice)
                    linePrice.isHidden = false
                }
            }
            if product.specialPrice > 0 {
                //特价
                sellPrice.text = String.init(format: "¥ %.2f", product.specialPrice)
                if itemModel.togetherMark != 1 {
                    //一起购不显示原价
                    linePrice.text = String.init(format: "¥%.2f", product.productPrice)
                    linePrice.isHidden = false
                }
            }
            linePrice.isHidden = false
        }else{
            sellPrice.text = product.statusMsg
            linePrice.text = ""
        }
    }
}

//MARK: - 事件响应
extension FKYHomePageItemType4{
    
    @objc func product1Clicked(){
        guard self.itemModel.floorProductDtos.count >= 1 else{
            return
        }
        let product = self.itemModel.floorProductDtos[0]
        let param = ["itemData":self.itemModel,"product":product]
        self.routerEvent(withName: FKYHomePageItemType4.productClickedAction, userInfo: [FKYUserParameterKey:param])
        routerEvent(withName: FKYHomePageItemType4.ItemBIAction, userInfo: [FKYUserParameterKey:["view":self,"itemData":itemModel]])
    }
    
    @objc func product2Clicked(){
        guard self.itemModel.floorProductDtos.count >= 2 else{
            return
        }
        let product = self.itemModel.floorProductDtos[1]
        let param = ["itemData":self.itemModel,"product":product]
        self.routerEvent(withName: FKYHomePageItemType4.productClickedAction, userInfo: [FKYUserParameterKey:param])
        routerEvent(withName: FKYHomePageItemType4.ItemBIAction, userInfo: [FKYUserParameterKey:["view":self,"itemData":itemModel]])
    }
    
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKYHomePageSectionTypeTagView.tagClickAction {
            let product = FKYHomePageV3FloorProductModel()
            let param = ["itemData":self.itemModel,"product":product]
            self.routerEvent(withName: FKYHomePageItemType4.productClickedAction, userInfo: [FKYUserParameterKey:param])
            routerEvent(withName: FKYHomePageItemType4.ItemBIAction, userInfo: [FKYUserParameterKey:["view":self,"itemData":itemModel]])
        }else{
            super.routerEvent(withName: eventName, userInfo: userInfo)
        }
    }
}


//MARK: - UI
extension FKYHomePageItemType4{
    func setupUI(){
        addSubview(titleLB)
        addSubview(tagView)
        addSubview(productImg1)
        addSubview(productImg2)
        addSubview(sellPrice1)
        addSubview(sellPrice2)
        addSubview(linePrice1)
        addSubview(linePrice2)
        addSubview(rightMarginLine)
        
        rightMarginLine.isHidden = true
        
        titleLB.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(0))
            make.top.equalToSuperview().offset(WH(10))
        }
        
        tagView.snp_makeConstraints { (make) in
            make.left.equalTo(titleLB.snp_right).offset(WH(5))
            make.centerY.equalTo(titleLB)
            make.height.equalTo(WH(16))
        }
        
        productImg1.snp_makeConstraints { (make) in
            make.right.equalTo(self.snp_centerX).offset(WH(-5))
            make.top.equalTo(titleLB.snp_bottom).offset(WH(8))
            make.width.height.equalTo(WH(70))
        }
        
        productImg2.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_centerX).offset(WH(5))
            make.width.height.top.equalTo(productImg1)
        }
        
        sellPrice1.snp_makeConstraints { (make) in
            make.left.right.equalTo(productImg1)
            make.top.equalTo(productImg1.snp_bottom).offset(WH(5))
        }
        
        linePrice1.snp_makeConstraints { (make) in
            make.centerX.equalTo(productImg1)
            make.bottom.equalToSuperview().offset(WH(-10))
            make.top.equalTo(sellPrice1.snp_bottom).offset(WH(0))
            
        }
        
        sellPrice2.snp_makeConstraints { (make) in
            make.left.right.equalTo(productImg2)
            make.top.equalTo(productImg2.snp_bottom).offset(WH(0))
        }
        
        linePrice2.snp_makeConstraints { (make) in
            make.centerX.equalTo(productImg2)
            make.bottom.equalToSuperview().offset(WH(-10))
            make.top.equalTo(sellPrice2.snp_bottom).offset(WH(0))
        }
        
        rightMarginLine.snp_makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        
    }
}

