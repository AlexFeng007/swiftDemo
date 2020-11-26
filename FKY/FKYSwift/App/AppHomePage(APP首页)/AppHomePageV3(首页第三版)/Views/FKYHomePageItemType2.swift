//
//  FKYHomePageItemType2.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  即将售罄    新品上架    本地热卖    系统推荐 1个商品样式

import UIKit

class FKYHomePageItemType2: UIView {

    /// 商品点击事件
    static let productClickedAction = "FKYHomePageItemType2-productClickedAction"
    
    static let ItemBIAction = "FKYHomePageItemType3-ItemBIAction"
    
    var itemModel:FKYHomePageV3ItemModel = FKYHomePageV3ItemModel()
    
    lazy var titleBtn:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageItemType2.titleBtnClicked), for: .touchUpInside)
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
        //lb.textColor = RGBColor(0x333333)
        lb.font = .boldSystemFont(ofSize: WH(11))
        return lb
    }()
    
    /// 商品主图
    lazy var productImg:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageItemType2.productClicked), for: .touchUpInside)
        return bt
    }()
    
    /// 商品价格
    lazy var productPrice:UILabel = {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 数据展示
extension FKYHomePageItemType2{
    /*
    func showTestData(){
        configData(title: "新品上架", subtitleText: "发现好药", productImagUrl: "QYWX_FX", sellPrice: "12.5")
        productImg.setBackgroundImage(UIImage(named: "QYWX_FX"), for: .normal)
    }
    */
    func showData(itemModel:FKYHomePageV3ItemModel){
        self.itemModel = itemModel
        configType()
        titleLB.text = itemModel.name
        subTitleLB.text = itemModel.title
        guard self.itemModel.floorProductDtos.count > 0 else{
            return
        }
        let product = self.itemModel.floorProductDtos[0]
        
        showPrice(label: productPrice, model: product)
        productImg.sd_setImage(with: URL(string: product.imgPath), for: .normal, placeholderImage: UIImage(named: "image_default_img"))
        
//        for product in self.itemModel.floorProductDtos{
//
//        }
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
    
    /// 展示数据
    func configData(title:String,subtitleText:String,productImagUrl:String,sellPrice:String){
        titleLB.text = title
        subTitleLB.text = subtitleText
        productImg.sd_setImage(with: URL(string: productImagUrl), for: .normal)
        productPrice.text = "¥\(sellPrice)"
        
    }
    
    /// 配置样式
    func configColor(subTitleTextColor:UIColor,priceTextColor:UIColor,priceBGColor:UIColor){
        subTitleLB.textColor = subTitleTextColor
        productPrice.textColor = priceTextColor
        productPrice.backgroundColor = priceBGColor
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
}

//MARK: - 事件响应
extension FKYHomePageItemType2{
    
    /// 标题按钮点击
    @objc func titleBtnClicked(){
        self.routerEvent(withName: FKYHomePageItemType2.productClickedAction, userInfo: [FKYUserParameterKey:["product":FKYHomePageV3FloorProductModel(),"itemData":itemModel]])
        self.routerEvent(withName: FKYHomePageItemType2.ItemBIAction, userInfo: [FKYUserParameterKey:itemModel])
    }
    
    @objc func productClicked(){
        //self.routerEvent(withName: FKYHomePageItemType2.productClickedAction, userInfo: [FKYUserParameterKey:""])
        guard self.itemModel.floorProductDtos.count > 0 else {
            return
        }
        let product = self.itemModel.floorProductDtos[0]
        self.routerEvent(withName: FKYHomePageItemType2.productClickedAction, userInfo: [FKYUserParameterKey:["product":product,"itemData":itemModel]])
        self.routerEvent(withName: FKYHomePageItemType2.ItemBIAction, userInfo: [FKYUserParameterKey:itemModel])
    }
}


//MARK: - UI
extension FKYHomePageItemType2{
    func setupUI(){
        addSubview(titleLB)
        addSubview(subTitleLB)
        addSubview(titleBtn)
        addSubview(productImg)
        addSubview(productPrice)
        addSubview(rightMarginLine)
        
        rightMarginLine.isHidden = true
        
        titleLB.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(12))
            make.left.equalToSuperview().offset(WH(9))
            make.right.equalToSuperview().offset(WH(-9))
        }
        
        subTitleLB.snp_makeConstraints { (make) in
            make.left.equalTo(titleLB)
            make.top.equalTo(titleLB.snp_bottom).offset(WH(3))
            make.right.equalToSuperview().offset(WH(-9))
        }
        
        titleBtn.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(titleLB)
            make.bottom.equalTo(subTitleLB.snp_bottom)
        }
        
        productImg.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(subTitleLB.snp_bottom).offset(WH(6))
            make.width.equalTo(WH(70))
            make.height.equalTo(WH(70))
        }
        
        productPrice.snp_makeConstraints { (make) in
            make.centerX.equalTo(productImg)
            make.left.right.equalTo(productImg)
            make.height.equalTo(WH(13))
            make.bottom.equalToSuperview().offset(WH(-10))
        }
        
        rightMarginLine.snp_makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        
    }
}
