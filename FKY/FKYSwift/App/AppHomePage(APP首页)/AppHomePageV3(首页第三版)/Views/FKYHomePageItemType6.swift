//
//  FKYHomePageItemType6.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/26.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  一行两个商品的秒杀组件


import UIKit

class FKYHomePageItemType6: UIView {
    
    /// 商品1点击事件
    static let productClickedAction = "FKYHomePageItemType6-productClickedAction"
    
    /// 商品2点击事件
    //static let product2ClickedAction = "FKYHomePageItemType6-product2ClickedAction"
    
    /// BI埋点事件
    static let ItemBIAction = "FKYHomePageItemType6-ItemBIAction"
    
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
        bt.addTarget(self, action: #selector(FKYHomePageItemType6.product1Clicked), for: .touchUpInside)
        return bt
    }()
    
    /// 商品主图2
    lazy var productImg2:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageItemType6.product2Clicked), for: .touchUpInside)
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
    
    var itemModel:FKYHomePageV3ItemModel = FKYHomePageV3ItemModel()
    var productImageList:[UIButton] = [UIButton]()
    var sellPriceList:[UILabel] = [UILabel]()
    var linePriceList:[UILabel] = [UILabel]()
    
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
extension FKYHomePageItemType6{
    
    func showData(itemModel:FKYHomePageV3ItemModel){
        self.itemModel = itemModel
        titleLB.text = self.itemModel.name
        countView.startCount(DueTime: self.itemModel.downTimeMillis/1000)
        for (index,product) in self.itemModel.floorProductDtos.enumerated() {
            configProductInfo(product: product, index: index)
        }
    }
    
    func configProductInfo(product:FKYHomePageV3FloorProductModel,index:Int){
        guard index < productImageList.count else {
            return
        }
        let imageBt = productImageList[index]
        let sellPrice = sellPriceList[index]
        let linePrice = linePriceList[index]
        imageBt.sd_setImage(with: URL(string: product.imgPath), for: .normal, placeholderImage: UIImage(named: "img_product_default"))
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
                if self.itemModel.togetherMark != 1 {
                    //一起购不显示原价
                    linePrice.text = String.init(format: "¥%.2f", product.productPrice)
                    linePrice.isHidden = false
                }
            }
            if  product.specialPrice > 0 {
                //特价
                sellPrice.text = String.init(format: "¥ %.2f", product.specialPrice)
                if self.itemModel.togetherMark != 1 {
                    //一起购不显示原价
                    linePrice.text = String.init(format: "¥%.2f", product.productPrice)
                    linePrice.isHidden = false
                }
            }
            //判断秒杀楼层是否显示原价
            linePrice.isHidden = false
        }else {
            sellPrice.text = product.statusMsg
            linePrice.text = ""
        }
    }
}

//MARK: - 事件响应
extension FKYHomePageItemType6{
    @objc func product1Clicked(){
        guard self.itemModel.floorProductDtos.count >= 1 else{
            return
        }
        let product = self.itemModel.floorProductDtos[0]
        let param = ["itemData":self.itemModel,"product":product]
        self.routerEvent(withName: FKYHomePageItemType6.productClickedAction, userInfo: [FKYUserParameterKey:param])
        routerEvent(withName: FKYHomePageItemType6.ItemBIAction, userInfo: [FKYUserParameterKey:["view":self,"itemData":itemModel]])
    }
    
    @objc func product2Clicked(){
        guard self.itemModel.floorProductDtos.count >= 2 else{
            return
        }
        let product = self.itemModel.floorProductDtos[1]
        let param = ["itemData":self.itemModel,"product":product]
        self.routerEvent(withName: FKYHomePageItemType6.productClickedAction, userInfo: [FKYUserParameterKey:param])
        routerEvent(withName: FKYHomePageItemType6.ItemBIAction, userInfo: [FKYUserParameterKey:["view":self,"itemData":itemModel]])
    }
}

//MARK: - UI
extension FKYHomePageItemType6{
    func setupUI(){
        addSubview(titleLB)
        addSubview(countView)
        addSubview(productImg1)
        addSubview(productImg2)
        addSubview(sellPrice1)
        addSubview(sellPrice2)
        addSubview(linePrice1)
        addSubview(linePrice2)
        
        sellPrice1.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        sellPrice1.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        sellPrice2.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        sellPrice2.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        
        titleLB.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(0))
            make.top.equalToSuperview().offset(WH(10))
        }
        
        countView.snp_makeConstraints { (make) in
            make.left.equalTo(titleLB.snp_right).offset(WH(5))
            make.centerY.equalTo(titleLB)
            make.height.equalTo(WH(16))
        }
        
        productImg1.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.right.equalTo(self.snp_centerX).offset(WH(-5))
            make.top.equalTo(titleLB.snp_bottom).offset(WH(8))
            make.width.height.equalTo(WH(70))
        }
        
        productImg2.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_centerX).offset(WH(5))
            make.width.height.top.equalTo(productImg1)
            make.right.equalToSuperview().offset(0)
        }
        
        sellPrice1.snp_makeConstraints { (make) in
            make.left.right.equalTo(productImg1)
            make.top.equalTo(productImg1.snp_bottom).offset(WH(5))
        }
        
        linePrice1.snp_makeConstraints { (make) in
            make.centerX.equalTo(productImg1)
            make.top.equalTo(sellPrice1.snp_bottom).offset(WH(0))
            make.bottom.equalToSuperview().offset(WH(-10))
        }
        
        sellPrice2.snp_makeConstraints { (make) in
            make.left.right.equalTo(productImg2)
            make.top.equalTo(productImg2.snp_bottom).offset(WH(5))
        }
        
        linePrice2.snp_makeConstraints { (make) in
            make.centerX.equalTo(productImg2)
            make.top.equalTo(sellPrice2.snp_bottom).offset(WH(0))
            make.bottom.equalToSuperview().offset(WH(-10))
        }
        
    }
}
