//
//  FKYHomePageV3ProductInfoView.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  商品信息模块

import UIKit

class FKYHomePageV3ProductInfoView: UIView {

    /// 右边按钮点击事件
    static let rightBtnAction = "FKYHomePageV3ProductInfoView-rightBtnAction"
    
    /// 商品名称
    lazy var productName:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = .boldSystemFont(ofSize: WH(14))
        lb.numberOfLines = 2
        lb.sizeToFit()
        return lb
    }()
    
    var sellerTagView:FKYHomePageV3SellerTagModule = FKYHomePageV3SellerTagModule()
    
    /// 卖价
    lazy var sellPrice:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0xFF2D5C)
        lb.font = .boldSystemFont(ofSize: WH(14))
        return lb
    }()
    
    /// 划线价
    lazy var linePrice:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x999999)
        lb.font = .boldSystemFont(ofSize: WH(11))
        
        let line = UIView()
        line.backgroundColor = RGBColor(0x999999)
        lb.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.left.right.centerY.equalToSuperview()
            make.height.equalTo(1)
        }
        
        return lb
    }()
    
    /// 会员价标签
    lazy var vipPrice:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0xFFDEAE)
        lb.font = .boldSystemFont(ofSize: WH(11))
        lb.textAlignment = .center
        lb.adjustsFontSizeToFitWidth = true
        lb.minimumScaleFactor = 0.5
        return lb
    }()
    
    /// 右边按钮
    lazy var rightBtn:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named:"new_shop_car_icon"), for: .normal)
        bt.addTarget(self, action: #selector(FKYHomePageV3ProductInfoView.rightBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    var itemModel:FKYHomePageV3FlowItemModel = FKYHomePageV3FlowItemModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 数据展示
extension FKYHomePageV3ProductInfoView{
    
    /*
    func showTestData(){
        productName.text = "阿斯利康 酒石酸美托洛尔片 25mg"
//        sellerTagView.showTestText()
        sellPrice.text = "￥13.44"
        linePrice.text = "￥20.80"
//        sellerTagView.showTestColor()
    }
    */
    
    func showProductInfo(itemModel:FKYHomePageV3FlowItemModel){
        self.itemModel = itemModel
        productName.text = self.itemModel.getProductName()
        
        let contentSize = (productName.text ?? "").boundingRect(with: CGSize(width: WH(172 - 18), height: WH(35)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(14))], context: nil).size
        productName.snp_remakeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(contentSize.height + 1)
        }
        
        sellPrice.text = self.itemModel.getProductSellPrice()
        linePrice.text = self.itemModel.getProductLinePrice()
        let sellerTag = self.itemModel.getProductTagInfo()
        if itemModel.vipPromotionId.isEmpty == false,itemModel.visibleVipPrice > 0, itemModel.availableVipPrice < 0{// 要展示会员价
//            vipPrice.text = String(format: "会员价¥%.2f  ", itemModel.visibleVipPrice)
//            vipPrice.sizeToFit()
//            vipPrice.layer.cornerRadius = WH(15/2.0)
//            vipPrice.layer.masksToBounds = true
//            vipPrice.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0x566771), RGBColor(0x182F4C), vipPrice.hd_width)
            linePrice.isHidden = true
            vipPrice.isHidden = false
        }else{
            
            vipPrice.isHidden = true
            linePrice.isHidden = false
        }
        if sellerTag.0 , sellerTag.2 >= 0{// 有标签
            sellerTagView.showTag(subTitle: sellerTag.1, tagType: sellerTag.2)
            isHideSellerTagView(isHide: false)
//            sellerTagView.showText(type: sellerTag.2, typeName: sellerTag.3)
//            sellerTagView.configColor(typeColor: sellerTag.1)
        }else{
            isHideSellerTagView(isHide: true)
        }
    }
}

//MARK: - 事件响应
extension FKYHomePageV3ProductInfoView{
    
    @objc func rightBtnClicked(){
        routerEvent(withName: FKYHomePageV3ProductInfoView.rightBtnAction, userInfo: [FKYUserParameterKey:itemModel])
    }
}

//MARK: - UI
extension FKYHomePageV3ProductInfoView{
    func setupUI(){
        addSubview(productName)
        addSubview(sellerTagView)
        addSubview(sellPrice)
        addSubview(linePrice)
        addSubview(rightBtn)
        addSubview(vipPrice)
        
        sellPrice.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        sellPrice.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        
        productName.snp_makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        
        sellerTagView.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(productName.snp_bottom).offset(WH(5))
            make.height.equalTo(WH(17))
        }
        
        sellPrice.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(sellerTagView.snp_bottom).offset(WH(5))
            //make.bottom.equalToSuperview().offset(WH(-10))
        }
        
        linePrice.snp_makeConstraints { (make) in
            make.left.equalTo(sellPrice.snp_right).offset(WH(4))
            make.centerY.equalTo(sellPrice)
        }
        
        vipPrice.snp_makeConstraints { (make) in
            make.left.equalTo(sellPrice.snp_right).offset(WH(4))
            make.centerY.equalTo(sellPrice)
            make.height.equalTo(WH(15))
            make.right.equalTo(rightBtn.snp_left).offset(WH(-4))
        }
        
        rightBtn.snp_makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(WH(-10))
            make.right.equalToSuperview().offset(WH(0))
            make.width.height.equalTo(WH(30))
        }
    }
    
    func isHideSellerTagView(isHide:Bool){
        sellerTagView.isHidden = isHide
        if isHidden {
            sellerTagView.snp_remakeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalTo(productName.snp_bottom).offset(WH(5))
                make.height.equalTo(0)
            }
        }else{
            sellerTagView.snp_remakeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalTo(productName.snp_bottom).offset(WH(5))
                make.height.equalTo(17)
            }
        }
    }
    
    /// 在cell willDisplay的时候调用
    func configDisplayInfo(){
        //sellerTagView.configCorner()
    }
    @objc
    static func getContentHeight(_ itemModel:FKYHomePageV3FlowItemModel) -> CGFloat{
        var Cell = WH(0)
        //商品名字
        let contentSize = (itemModel.getProductName()).boundingRect(with: CGSize(width: WH(172 - 18), height: WH(35)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(14))], context: nil).size
        
        Cell = Cell + (contentSize.height + 1)
        //标签
        Cell = Cell + WH(5)
        let sellerTag = itemModel.getProductTagInfo()
        if sellerTag.0 , sellerTag.2 >= 0{// 有标签
            Cell = Cell + WH(17)
        }
        // 价格
        Cell = Cell + WH(5)//间隔
        Cell = Cell + WH(15) //价格
        Cell = Cell + WH(10)//距离底部
        return Cell
    }
}


