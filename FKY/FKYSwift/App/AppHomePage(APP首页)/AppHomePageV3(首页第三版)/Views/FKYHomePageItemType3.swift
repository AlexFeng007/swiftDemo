//
//  FKYHomePageItemType3.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/22.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  即将售罄    新品上架    本地热卖    系统推荐 两个商品样式

import UIKit

class FKYHomePageItemType3: UIView {

    /// 商品1点击事件
    static let productClickedAction = "FKYHomePageItemType3-productClickedAction"
    
    /// 商品2点击事件
    //static let product2ClickedAction = "FKYHomePageItemType3-product2ClickedAction"
    
    static let ItemBIAction = "FKYHomePageItemType3-ItemBIAction"
    
    var itemModel:FKYHomePageV3ItemModel = FKYHomePageV3ItemModel()
    
    
    lazy var titleBtn:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageItemType3.titleBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    lazy var titleLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = .boldSystemFont(ofSize: WH(15))
        return lb
    }()
    
    lazy var subTitleLB:UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: WH(11))
        return lb
    }()
    
    /// 商品主图1
    lazy var productImg1:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageItemType3.product1Clicked), for: .touchUpInside)
        return bt
    }()
    
    /// 商品主图2
    lazy var productImg2:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageItemType3.product2Clicked), for: .touchUpInside)
        return bt
    }()
    
    /// 商品价格1
    lazy var productPrice1:UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: WH(11))
        lb.textAlignment = .center
        lb.layer.cornerRadius = WH(13/2.0)
        lb.layer.masksToBounds = true
        return lb
    }()
    
    /// 商品价格2
    lazy var productPrice2:UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: WH(11))
        lb.textAlignment = .center
        lb.layer.cornerRadius = WH(13/2.0)
        lb.layer.masksToBounds = true
        return lb
    }()
    
    /// 右边分割线
    lazy var rightMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        return view
    }()
    
    /// 图片list
    var productImageList:[UIButton] = [UIButton]()
    
    /// 价格list
    var priceList:[UILabel] = [UILabel]()
    
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
        priceList = [productPrice1,productPrice2]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 数据展示
extension FKYHomePageItemType3{
    
    /*
    func showTestData(){
        configData(titleText: "即将售罄", subTitleText: "快来抢购", product1ImgUrl: "qq_zone_share", product2ImgUrl: "qq_zone_share", product1Price: "0.00", product2Price: "0.00")
        productImg1.setBackgroundImage(UIImage(named: "qq_zone_share"), for: .normal)
        productImg2.setBackgroundImage(UIImage(named: "qq_zone_share"), for: .normal)
    }
    */
    func showData(itemModel:FKYHomePageV3ItemModel){
        self.itemModel = itemModel
        configType()
        titleLB.text = itemModel.name
        subTitleLB.text = itemModel.title
        for (index,product) in self.itemModel.floorProductDtos.enumerated(){
            guard index < priceList.count,index < productImageList.count else {
                break
            }
            
            let lb = priceList[index]
            let image = productImageList[index]
            showPrice(label: lb, model: product)
            image.sd_setImage(with: URL(string: product.imgPath), for: .normal, placeholderImage: UIImage(named: "image_default_img"))
        }
        hideProductCount(productCount: productImageList.count-itemModel.floorProductDtos.count)
    }
    
    func configType(){
        if itemModel.type == 28{// 新品上架
            configColor(subTitleTextColor: RGBColor(0x1FC7BC), priceTextColor: RGBColor(0x1FC7BC), priceBGColor: RGBColor(0xE8FFFD))
        }else if itemModel.type == 29 {//即将售罄
            configColor(subTitleTextColor: RGBColor(0xFF3E8D), priceTextColor: RGBColor(0xFF3E8D), priceBGColor: RGBColor(0xFFE8F0))
        }else if itemModel.type == 30 {//本地热卖
            configColor(subTitleTextColor: RGBColor(0xFF6247), priceTextColor: RGBColor(0xFF6247), priceBGColor: RGBColor(0xFFF2E7))
        }else if itemModel.type == 31 {//推荐标签
            configColor(subTitleTextColor: RGBColor(0xFF6247), priceTextColor: RGBColor(0xFF6247), priceBGColor: RGBColor(0xFFF2E7))
        }else{
            configColor(subTitleTextColor: RGBColor(0xFF9E27), priceTextColor: RGBColor(0xFF9E27), priceBGColor: RGBColor(0xFFF7E7))
        }
    }
    
    /// 配置样式
    func configColor(subTitleTextColor:UIColor,priceTextColor:UIColor,priceBGColor:UIColor){
        subTitleLB.textColor = subTitleTextColor
        productPrice1.textColor = priceTextColor
        productPrice1.backgroundColor = priceBGColor
        productPrice2.textColor = priceTextColor
        productPrice2.backgroundColor = priceBGColor
    }
    
    /// 显示价格
    func showPrice(label:UILabel,model:FKYHomePageV3FloorProductModel){
        if model.statusDesc == 0 {
            //商品价格相关
            if model.productPrice > 0 {
                label.text = String.init(format: "¥%.2f", model.productPrice)
            }else {
                label.text = "¥--"
            }
            if model.availableVipPrice  > 0 {
                //有会员价格
                label.text = String.init(format: "¥%.2f", model.availableVipPrice)
            }
            if model.specialPrice > 0 {
                //特价
                label.text = String.init(format: "¥%.2f", model.specialPrice)
            }
        }else {
            label.text = model.statusMsg
        }
    }
    
    /*
    /// 展示数据
    func configData(titleText:String,subTitleText:String,product1ImgUrl:String,product2ImgUrl:String,product1Price:String,product2Price:String){
        titleLB.text = titleText
        subTitleLB.text = subTitleText
        productImg1.sd_setImage(with: URL(string: product1ImgUrl), for: .normal)
        productPrice1.text = "¥\(product1Price)"
        productImg2.sd_setImage(with: URL(string: product2ImgUrl), for: .normal)
        productPrice2.text = "¥\(product2Price)"
    }
    */
}

//MARK: - 事件响应
extension FKYHomePageItemType3{
    
    /// 标题按钮点击
    @objc func titleBtnClicked(){
        
        self.routerEvent(withName: FKYHomePageItemType3.productClickedAction, userInfo: [FKYUserParameterKey:["product":FKYHomePageV3FloorProductModel(),"itemData":itemModel]])
        self.routerEvent(withName: FKYHomePageItemType3.ItemBIAction, userInfo: [FKYUserParameterKey:itemModel])
    }
    
    @objc func product1Clicked(){
        guard self.itemModel.floorProductDtos.count > 0 else {
            return
        }
        let product = self.itemModel.floorProductDtos[0]
        self.routerEvent(withName: FKYHomePageItemType3.productClickedAction, userInfo: [FKYUserParameterKey:["product":product,"itemData":itemModel]])
        self.routerEvent(withName: FKYHomePageItemType3.ItemBIAction, userInfo: [FKYUserParameterKey:itemModel])
    }
    
    @objc func product2Clicked(){
        guard self.itemModel.floorProductDtos.count > 1 else {
            return
        }
        let product = self.itemModel.floorProductDtos[1]
        self.routerEvent(withName: FKYHomePageItemType3.productClickedAction, userInfo: [FKYUserParameterKey:["product":product,"itemData":itemModel]])
        self.routerEvent(withName: FKYHomePageItemType3.ItemBIAction, userInfo: [FKYUserParameterKey:itemModel])
    }
}

//MARK: - UI
extension FKYHomePageItemType3{
    
    /// 隐藏多少个商品 隐藏顺序从右往左
    /// - Parameter productCount: 商品数量
    func hideProductCount(productCount:Int){
        showAll()
        guard productCount > 0 else {
            return
        }
        
        if productCount >= 1 {
            self.productImg2.isHidden = true
            self.productPrice2.isHidden = true
        }
        
        if productCount >= 2 {
            self.productImg1.isHidden = true
            self.productPrice1.isHidden = true
        }
    }
    
    /// 显示所有item
    func showAll(){
        self.productImg1.isHidden = false
        self.productPrice1.isHidden = false
        
        self.productImg2.isHidden = false
        self.productPrice2.isHidden = false
        
    }
    
    func setupUI(){
        addSubview(titleLB)
        addSubview(subTitleLB)
        addSubview(titleBtn)
        
        addSubview(productImg1)
        addSubview(productImg2)
        addSubview(productPrice1)
        addSubview(productPrice2)
        addSubview(rightMarginLine)
        
        titleLB.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(14))
            make.top.equalToSuperview().offset(WH(12))
        }
        
        subTitleLB.snp_makeConstraints { (make) in
            make.left.equalTo(titleLB)
            make.top.equalTo(titleLB.snp_bottom).offset(WH(3))
        }
        
        titleBtn.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(titleLB)
            make.bottom.equalTo(subTitleLB.snp_bottom)
        }
        
        productImg1.snp_makeConstraints { (make) in
            make.right.equalTo(self.snp_centerX).offset(WH(-5))
            make.top.equalTo(subTitleLB.snp_bottom).offset(WH(6))
            make.width.height.equalTo(WH(70))
        }
        
        productImg2.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_centerX).offset(WH(5))
            make.width.height.top.equalTo(productImg1)
        }
        
        productPrice1.snp_makeConstraints { (make) in
            make.left.equalTo(productImg1).offset(WH(5))
            make.right.equalTo(productImg1).offset(WH(-5))
            make.height.equalTo(WH(13))
            make.bottom.equalToSuperview().offset(WH(-10))
        }
        
        productPrice2.snp_makeConstraints { (make) in
            make.left.equalTo(productImg2).offset(WH(5))
            make.right.equalTo(productImg2).offset(WH(-5))
            make.height.equalTo(WH(13))
            make.bottom.equalToSuperview().offset(WH(-10))
        }
        
        rightMarginLine.snp_makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        
    }
}
