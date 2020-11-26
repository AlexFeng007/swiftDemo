//
//  FKYHomePageItemType7.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/26.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  一行4个商品的秒杀组件

import UIKit

class FKYHomePageItemType7: UIView {

    /// 商品1点击事件
    static let productClickedAction = "FKYHomePageItemType7-productClickedAction"
    
    /// 商品2点击事件
//    static let product2ClickedAction = "FKYHomePageItemType7-product2ClickedAction"
//
//    /// 商品3点击事件
//    static let product3ClickedAction = "FKYHomePageItemType7-product3ClickedAction"
//
//    /// 商品4点击事件
//    static let product4ClickedAction = "FKYHomePageItemType7-product4ClickedAction"
    
    lazy var titleLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = .boldSystemFont(ofSize: WH(15))
        return lb
    }()
    
    /// 倒计时
    var countView:FKYHomePageCountView = FKYHomePageCountView()
    
    /// 商品主图1
    lazy var productImg1:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageItemType7.product1Clicked), for: .touchUpInside)
        return bt
    }()
    
    /// 商品主图2
    lazy var productImg2:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageItemType7.product2Clicked), for: .touchUpInside)
        return bt
    }()
    
    /// 商品主图3
    lazy var productImg3:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageItemType7.product3Clicked), for: .touchUpInside)
        return bt
    }()
    
    /// 商品主图4
    lazy var productImg4:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageItemType7.product4Clicked), for: .touchUpInside)
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
    
    /// 商品销售价格3
    lazy var sellPrice3:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0xFF2D5C)
        lb.font = .systemFont(ofSize:WH(14))
        lb.textAlignment = .center
        return lb
    }()
    
    /// 商品销售价格4
    lazy var sellPrice4:UILabel = {
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
    
    /// 商品划线价3
    var linePrice3:UILabel = {
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
    
    /// 商品划线价4
    var linePrice4:UILabel = {
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
    
    var itemModel:FKYHomePageV3ItemModel = FKYHomePageV3ItemModel()
    
    /// 商品图片数组
    var productImageList:[UIButton] = [UIButton]()
    /// 商品售价数组
    var sellPriceList:[UILabel] = [UILabel]()
    /// 划线价数组
    var linePriceList:[UILabel] = [UILabel]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        productImageList = [productImg1,productImg2,productImg3,productImg4]
        sellPriceList = [sellPrice1,sellPrice2,sellPrice3,sellPrice4]
        linePriceList = [linePrice1,linePrice2,linePrice3,linePrice4]
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - 数据展示
extension FKYHomePageItemType7{
    func showData(itemModel:FKYHomePageV3ItemModel){
        self.itemModel = itemModel
        titleLB.text = self.itemModel.name
        countView.startCount(DueTime: self.itemModel.downTimeMillis/1000)
        // 把多余的商品隐藏
        hideProduct(count: productImageList.count - self.itemModel.floorProductDtos.count)
        
        /// 显示信息
        for (index,product) in self.itemModel.floorProductDtos.enumerated() {
            showProductInfo(index: index, product: product)
        }
        
    }
    
    /// 显示商品信息
    func showProductInfo(index:Int,product:FKYHomePageV3FloorProductModel){
        guard index < productImageList.count else {
            return
        }
        
        let imageBtn = productImageList[index]
        let sellPrice = sellPriceList[index]
        let linePrice = linePriceList[index]
        imageBtn.sd_setImage(with: URL(string: product.imgPath), for: .normal, placeholderImage: UIImage(named: "image_default_img"))
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
extension FKYHomePageItemType7{
    
    @objc func product1Clicked(){
        guard self.itemModel.floorProductDtos.count >= 1 else {
            return
        }
        let product = self.itemModel.floorProductDtos[0]
        let param = ["itemData":self.itemModel,"product":product]
        self.routerEvent(withName: FKYHomePageItemType7.productClickedAction, userInfo: [FKYUserParameterKey:param])
    }
    
    @objc func product2Clicked(){
        guard self.itemModel.floorProductDtos.count >= 2 else {
            return
        }
        let product = self.itemModel.floorProductDtos[1]
        let param = ["itemData":self.itemModel,"product":product]
        self.routerEvent(withName: FKYHomePageItemType7.productClickedAction, userInfo: [FKYUserParameterKey:param])
    }
    
    @objc func product3Clicked(){
        guard self.itemModel.floorProductDtos.count >= 3 else {
            return
        }
        let product = self.itemModel.floorProductDtos[2]
        let param = ["itemData":self.itemModel,"product":product]
        self.routerEvent(withName: FKYHomePageItemType7.productClickedAction, userInfo: [FKYUserParameterKey:param])
    }
    
    @objc func product4Clicked(){
        guard self.itemModel.floorProductDtos.count >= 4 else {
            return
        }
        let product = self.itemModel.floorProductDtos[3]
        let param = ["itemData":self.itemModel,"product":product]
        self.routerEvent(withName: FKYHomePageItemType7.productClickedAction, userInfo: [FKYUserParameterKey:param])
    }
}


//MARK: - UI
extension FKYHomePageItemType7{
    
    /// 隐藏商品
    /// - Parameter count: 隐藏的数量，从右到左
    func hideProduct(count:Int){
        showAll()
        if count > 0{
            productImg4.isHidden = true
            sellPrice4.isHidden = true
            linePrice4.isHidden = true
        }else if count > 1{
            productImg3.isHidden = true
            sellPrice3.isHidden = true
            linePrice3.isHidden = true
        }else if count > 2{
            productImg2.isHidden = true
            sellPrice2.isHidden = true
            linePrice2.isHidden = true
        }else if count > 3{
            productImg1.isHidden = true
            sellPrice1.isHidden = true
            linePrice1.isHidden = true
        }
    }
    
    /// 显示全部商品
    func showAll(){
        for image in productImageList{
            image.isHidden = false
        }
        
        for sell in sellPriceList{
            sell.isHidden = false
        }
        
        for line in linePriceList{
            line.isHidden = false
        }
    }
    
    func setupUI(){
        addSubview(titleLB)
        addSubview(countView)
        
        addSubview(productImg1)
        addSubview(productImg2)
        addSubview(productImg3)
        addSubview(productImg4)
        
        addSubview(sellPrice1)
        addSubview(sellPrice2)
        addSubview(sellPrice3)
        addSubview(sellPrice4)
        
        addSubview(linePrice1)
        addSubview(linePrice2)
        addSubview(linePrice3)
        addSubview(linePrice4)
        
        
        sellPrice1.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        sellPrice1.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        sellPrice2.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        sellPrice2.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        sellPrice3.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        sellPrice3.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        sellPrice4.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        sellPrice4.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        
        titleLB.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(14))
            make.top.equalToSuperview().offset(WH(10))
        }
        
        countView.snp_makeConstraints { (make) in
            make.left.equalTo(titleLB.snp_right).offset(WH(5))
            make.centerY.equalTo(titleLB)
            make.height.equalTo(WH(16))
        }
        
        productImg1.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalTo(productImg2.snp_left).offset(WH(-10))
            make.top.equalTo(titleLB.snp_bottom).offset(WH(8))
            make.width.height.equalTo(WH(70))
        }
        
        productImg2.snp_makeConstraints { (make) in
            make.right.equalTo(self.snp_centerX).offset(WH(-5))
            make.top.equalTo(productImg1)
            make.width.height.equalTo(WH(70))
        }
        
        productImg3.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_centerX).offset(WH(5))
            make.width.height.top.equalTo(productImg1)
        }
        
        productImg4.snp_makeConstraints { (make) in
            make.left.equalTo(productImg3.snp_right).offset(WH(5))
            make.width.height.top.equalTo(productImg1)
            make.right.equalToSuperview().offset(WH(-10))
        }
        
        sellPrice1.snp_makeConstraints { (make) in
            make.left.right.equalTo(productImg1)
            make.top.equalTo(productImg1.snp_bottom).offset(WH(0))
        }
        
        linePrice1.snp_makeConstraints { (make) in
            //make.left.right.equalTo(productImg1)
            make.centerX.equalTo(productImg1)
            make.bottom.equalToSuperview().offset(WH(-10))
            make.top.equalTo(sellPrice1.snp_bottom).offset(WH(0))
        }
        
        sellPrice2.snp_makeConstraints { (make) in
            make.left.right.equalTo(productImg2)
            make.top.equalTo(productImg2.snp_bottom).offset(WH(0))
        }
        
        linePrice2.snp_makeConstraints { (make) in
            make.centerX.equalTo(productImg1)
            make.bottom.equalToSuperview().offset(WH(-10))
            make.top.equalTo(sellPrice2.snp_bottom).offset(WH(0))
        }
        
        sellPrice3.snp_makeConstraints { (make) in
            make.left.right.equalTo(productImg3)
            make.top.equalTo(productImg3.snp_bottom).offset(WH(0))
        }
        
        linePrice3.snp_makeConstraints { (make) in
            make.centerX.equalTo(productImg1)
            make.bottom.equalToSuperview().offset(WH(-10))
            make.top.equalTo(sellPrice3.snp_bottom).offset(WH(0))
        }
        
        sellPrice4.snp_makeConstraints { (make) in
            make.left.right.equalTo(productImg4)
            make.top.equalTo(productImg4.snp_bottom).offset(WH(0))
        }
        
        linePrice4.snp_makeConstraints { (make) in
            make.centerX.equalTo(productImg1)
            make.bottom.equalToSuperview().offset(WH(-10))
            make.top.equalTo(sellPrice4.snp_bottom).offset(WH(0))
        }
    }
}
