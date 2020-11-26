//
//  FKYHomePageItemType1.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  超值套餐模块 固定套餐 搭配套餐 一行2个商品的组件 2个固定套餐/2个搭配套餐沾满一整行的情况

import UIKit

class FKYHomePageItemType1: UIView {

    /// 商品1点击
    static let productClickedAction = "FKYHomePageItemType1-productClicked"
    
    /// 商品2点击
    //static let product2ClickedAction = "FKYHomePageItemType1-product2Clicked"
    
    // BI埋点事件
    static let ItemBIAction = "FKYHomePageItemType1-ItemBIAction"
    
    lazy var titleLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = .boldSystemFont(ofSize: WH(15))
        return lb
    }()
    
    /// 当前豆腐块的标签
    var tagView:FKYHomePageSectionTypeTagView = FKYHomePageSectionTypeTagView()
    
    /// 商品主图1
    lazy var productImage1:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageItemType1.product1Clicked), for: .touchUpInside)
        return bt
    }()
    
    /// 商品主图2
    lazy var productImage2:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageItemType1.product2Clicked), for: .touchUpInside)
        return bt
    }()
    
    /// 中间加号
    lazy var centerIcon:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named:"homeComboIcon")
        return icon
    }()
    
    /// 商品价格1
    lazy var product1Price:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x8D56EF)
        lb.font = .boldSystemFont(ofSize: WH(11))
        lb.textAlignment = .center
        lb.backgroundColor = RGBColor(0xEFE7FE)
        lb.layer.cornerRadius = WH(13/2.0)
        lb.layer.masksToBounds = true
        return lb
    }()
    /// 商品价格2
    lazy var product2Price:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x8D56EF)
        lb.font = .boldSystemFont(ofSize: WH(11))
        lb.textAlignment = .center
        lb.backgroundColor = RGBColor(0xEFE7FE)
        lb.layer.cornerRadius = WH(13/2.0)
        lb.layer.masksToBounds = true
        return lb
    }()
    
    /// 套餐价
    lazy var packageSellPrice:UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: WH(12))
        lb.textColor = RGBColor(0x8D56EF)
        return lb
    }()
    
    /// 套餐划线价
    lazy var packageLinePrice:UILabel = {
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
    
    /*
    /// 下方分割线
    lazy var bottomMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        return view
    }()
    */
    var itemModel:FKYHomePageV3ItemModel = FKYHomePageV3ItemModel()
    var pakcageModel:FKYHomePageV3PackageModel = FKYHomePageV3PackageModel()
    var imageList:[UIButton] = [UIButton]()
    var sellPriceList:[UILabel] = [UILabel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        imageList = [productImage1,productImage2]
        sellPriceList = [product1Price,product2Price]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


//MARK: - 数据展示
extension FKYHomePageItemType1{
    /*
    func showTestData(){
        titleLB.text = "测试测试"
        /// 
        //tagView.showTestData()
        productImage1.setBackgroundImage(UIImage(named: "qq_zone_share"), for: .normal)
        productImage2.setBackgroundImage(UIImage(named: "qq_zone_share"), for: .normal)
        product1Price.text = "¥0.00"
        product2Price.text = "¥0.00"
        packageSellPrice.text = "套餐价¥0.00"
        packageLinePrice.attributedText = NSAttributedString.init(string: "¥0.00", attributes: [ NSAttributedString.Key.foregroundColor: RGBColor(0x999999), NSAttributedString.Key.strikethroughStyle: NSNumber.init(value: Int8(NSUnderlineStyle.single.rawValue))])
    }
    */
    
    /// 控件被用在 一行两个不同模块的cell中时，调用这个方法展示数据
    
    /// 控件被用在 一行两个不同模块的cell中时，调用这个方法展示数据
    /// - Parameters:
    ///   - itemModel:
    ///   - index: 用来标识取哪个套餐的数据
    func showItemData(itemModel:FKYHomePageV3ItemModel){
        self.itemModel = itemModel
        titleLB.text = self.itemModel.name
        tagView.configType(iconName: "home_shop_dir_violet", borderColor: RGBColor(0x8D56EF), cornerRadius: WH(16/2.0), textColor: RGBColor(0x8D56EF))
        tagView.configTitle(title: itemModel.title)
        let dinner = itemModel.dinnerVOList[0]
        showProductData(pakcageModel: dinner)
    }
    
    /// 控件被用在两个组件占满整行的时候用这个方法展示数据  标题、标签在fuview中设置
    func showProductData(pakcageModel:FKYHomePageV3PackageModel){
        self.pakcageModel = pakcageModel
        for (index,product) in self.pakcageModel.productList.enumerated() {
            configProductInfo(index: index, product: product)
        }
        packageSellPrice.text = String(format: "套餐价¥%.2f", self.pakcageModel.dinnerPrice)
        packageLinePrice.text = String(format: "¥%.2f", self.pakcageModel.dinnerOriginPrice)
    }
    
    func configProductInfo(index:Int,product:FKYHomePageV3FloorProductModel){
        guard index < imageList.count else{
            return
        }
        let image = imageList[index]
        let price = sellPriceList[index]
        image.sd_setImage(with: URL(string: product.imgPath), for: .normal, placeholderImage: UIImage(named: "img_product_default"))
        price.text = String(format: "¥%.2f", product.dinnerPrice)
    }
}

//MARK: - 响应事件
extension FKYHomePageItemType1{
    @objc func product1Clicked(){
        guard pakcageModel.productList.count >= 1 else {
            return
        }
        let product = pakcageModel.productList[0]
        let param = ["itemData":self.itemModel,"product":product]
        self.routerEvent(withName: FKYHomePageItemType1.productClickedAction, userInfo: [FKYUserParameterKey:param])
        routerEvent(withName: FKYHomePageItemType1.ItemBIAction, userInfo: [FKYUserParameterKey:["view":self,"itemData":itemModel]])
    }
    
    @objc func product2Clicked(){
        guard pakcageModel.productList.count >= 2 else {
            return
        }
        let product = pakcageModel.productList[1]
        let param = ["itemData":self.itemModel,"product":product]
        self.routerEvent(withName: FKYHomePageItemType1.productClickedAction, userInfo: [FKYUserParameterKey:param])
        routerEvent(withName: FKYHomePageItemType1.ItemBIAction, userInfo: [FKYUserParameterKey:["view":self,"itemData":itemModel]])
    }
    
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKYHomePageSectionTypeTagView.tagClickAction {
            let product = FKYHomePageV3FloorProductModel()
            let param = ["itemData":self.itemModel,"product":product]
            super.routerEvent(withName: FKYHomePageItemType1.productClickedAction, userInfo: [FKYUserParameterKey:param])
            routerEvent(withName: FKYHomePageItemType1.ItemBIAction, userInfo: [FKYUserParameterKey:["view":self,"itemData":itemModel]])
        }else{
            super.routerEvent(withName: eventName, userInfo: userInfo)
        }
    }
}


//MARK: - UI
extension FKYHomePageItemType1{
    func setupUI(){
        self.addSubview(titleLB)
        self.addSubview(tagView)
        self.addSubview(productImage1)
        self.addSubview(productImage2)
        self.addSubview(product1Price)
        self.addSubview(product2Price)
        self.addSubview(centerIcon)
        self.addSubview(packageSellPrice)
        self.addSubview(packageLinePrice)
        self.addSubview(rightMarginLine)
        rightMarginLine.isHidden = true
        titleLB.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        titleLB.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        
        titleLB.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(0))
            make.top.equalToSuperview().offset(WH(11))
        }
        
        tagView.snp_makeConstraints { (make) in
            make.left.equalTo(titleLB.snp_right).offset(WH(5))
            make.centerY.equalTo(titleLB.snp_centerY)
            make.height.equalTo(WH(16))
            //make.width.equalTo(WH(100))
        }
        
        productImage1.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(0))
            make.right.equalTo(centerIcon.snp_left).offset(WH(0))
            make.top.equalTo(titleLB.snp_bottom).offset(WH(9))
            make.width.height.equalTo(WH(70))
        }
        
        product1Price.snp_makeConstraints { (make) in
            make.left.right.equalTo(productImage1)
            make.centerY.equalTo(productImage1.snp_bottom)
            make.height.equalTo(WH(13))
        }
        
        centerIcon.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(productImage1)
            make.height.width.equalTo(WH(20))
        }
        
        productImage2.snp_makeConstraints { (make) in
            make.left.equalTo(centerIcon.snp_right)
            make.top.width.height.equalTo(productImage1)
            make.right.equalToSuperview()
        }
        
        product2Price.snp_makeConstraints { (make) in
            make.left.right.equalTo(productImage2)
            make.centerY.equalTo(productImage2.snp_bottom)
        }
        
        packageSellPrice.snp_makeConstraints { (make) in
            make.left.equalTo(productImage1)
            make.top.equalTo(productImage1.snp_bottom).offset(WH(15))
            make.bottom.equalToSuperview().offset(WH(-12))
        }
        
        packageLinePrice.snp_makeConstraints { (make) in
            make.left.equalTo(packageSellPrice.snp_right).offset(WH(7))
            make.right.equalToSuperview().offset(WH(-14))
            make.centerY.equalTo(packageSellPrice)
        }
        
        rightMarginLine.snp_makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        
    }
}
