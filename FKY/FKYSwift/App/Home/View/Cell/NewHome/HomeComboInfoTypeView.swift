//
//  HomeComboInfoTypeView.swift
//  FKY
//
//  Created by 寒山 on 2020/7/14.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class HomeComboInfoTypeView: UIView {
    // var checkRecommendBlock: ((HomeSecdKillProductModel)->())? //查看推荐的楼层
    ///点击商品进楼层 string 商品id
    var clickProductBlock: ((HomeRecommendProductItemModel?,HomeSecdKillProductModel,String)->())? //点击商品进楼层
    var cellType:HomeCellType? //更具celltye 判断商品展示数量
    var cellModel : HomeSecdKillProductModel? //数据模型
    /// 当前页面的布局类型 1 代表1个套餐组件占一整个楼层 2代表2个套餐组件占一整个楼层
    var layoutType:Int = 0
    
    //顶部视图
    fileprivate lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    ///一级标题
    fileprivate  var proTypeNameLabel: UIButton = {
        let bt = UIButton()
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        bt.titleLabel?.adjustsFontSizeToFitWidth = true
        bt.titleLabel?.minimumScaleFactor = 0.6
        bt.setTitleColor(RGBColor(0x333333), for: .normal)
        bt.backgroundColor = .clear
        bt.addTarget(self, action: #selector(HomeComboInfoTypeView.proTypeClicked), for: .touchUpInside)
        bt.contentHorizontalAlignment = .left
        return bt
    }()
    /// 二级标题/ 副标题
    fileprivate  var subTitleBtn: UIButton = {
        let bt = UIButton()
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(11))
        bt.titleLabel?.adjustsFontSizeToFitWidth = true
        bt.titleLabel?.minimumScaleFactor = 0.6
        bt.setTitleColor(RGBColor(0x8D56EF), for: .normal)
        bt.titleLabel?.textAlignment = .left
        bt.backgroundColor = .clear
        bt.addTarget(self, action: #selector(HomeComboInfoTypeView.proTypeClicked), for: .touchUpInside)
        bt.layer.cornerRadius = WH(8)
        bt.layer.masksToBounds = true
        bt.layer.borderColor = RGBColor(0x8D56EF).cgColor
        bt.layer.borderWidth = 1
        bt.setImage(UIImage(named:"home_shop_dir_violet"), for: .normal)
        return bt
    }()
    
    
    ///套餐的商品图片
    fileprivate var firstProductImageView: UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(HomeComboInfoTypeView.firstProductClicked), for: .touchUpInside)
        return bt
    }()
    /// + 20
    fileprivate var addImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "homeComboIcon")
        return img
    }()
    ///套餐的商品图片二
    fileprivate var secondProductImageView: UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(HomeComboInfoTypeView.secondProductClicked), for: .touchUpInside)
        return bt
    }()
    
    ///商品购买价格
    fileprivate var priceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = RGBColor(0x8D56EF)
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        return label
    }()
    /// 商品原价
    fileprivate lazy var priceOriginalLabel: UILabel = {
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
    
    /// 容器视图2
    lazy var containerView2:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    ///第二容器 套餐的商品图片
    fileprivate var firstProductImageView2: UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(HomeComboInfoTypeView.thirdProductClicked), for: .touchUpInside)
        return bt
    }()
    
    //第二容器 + 20
    fileprivate var addImageView2: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "homeComboIcon")
        return img
    }()
    
    ///第二容器 套餐的商品图片二
    fileprivate var secondProductImageView2: UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(HomeComboInfoTypeView.fourthProductClicked), for: .touchUpInside)
        return bt
    }()
    
    ///第二容器 商品购买价格
    fileprivate var priceLabel2: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = RGBColor(0x8D56EF)
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        return label
    }()
    
    ///第二容器 商品原价
    fileprivate lazy var priceOriginalLabel2: UILabel = {
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
    
    /// 第二容器上的按钮
    lazy var containerView2Btn:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(HomeComboInfoTypeView.btnClicked), for: .touchUpInside)
        bt.isHidden = true
        return bt
    }()
    
    /// 商品1价格
    lazy var product1PriceLB:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize:WH(11))
        lb.textColor = RGBColor(0x8D56EF)
        lb.layer.cornerRadius = WH(13/2.0)
        lb.backgroundColor = RGBColor(0xEFE7FE)
        lb.layer.masksToBounds = true
        lb.adjustsFontSizeToFitWidth = true
        lb.minimumScaleFactor = 0.6
        return lb
    }()
    
    /// 商品2价格
    lazy var product2PriceLB:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize:WH(11))
        lb.textColor = RGBColor(0x8D56EF)
        lb.layer.cornerRadius = WH(13/2.0)
        lb.backgroundColor = RGBColor(0xEFE7FE)
        lb.layer.masksToBounds = true
        lb.adjustsFontSizeToFitWidth = true
        lb.minimumScaleFactor = 0.6
        return lb
    }()
    
    /// 商品3价格
    lazy var product3PriceLB:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize:WH(11))
        lb.textColor = RGBColor(0x8D56EF)
        lb.layer.cornerRadius = WH(13/2.0)
        lb.backgroundColor = RGBColor(0xEFE7FE)
        lb.layer.masksToBounds = true
        lb.adjustsFontSizeToFitWidth = true
        lb.minimumScaleFactor = 0.6
        return lb
    }()
    
    /// 商品4价格
    lazy var product4PriceLB:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize:WH(11))
        lb.textColor = RGBColor(0x8D56EF)
        lb.layer.cornerRadius = WH(13/2.0)
        lb.backgroundColor = RGBColor(0xEFE7FE)
        lb.layer.masksToBounds = true
        lb.adjustsFontSizeToFitWidth = true
        lb.minimumScaleFactor = 0.6
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //记得修改101 102 100 用错了的现在
//    func configHomePromotionCell(_ cellModel : HomeSecdKillProductModel,_ cellType:HomeCellType?) {
//        self.cellType = cellType
//        self.cellModel = cellModel
//        topView.isHidden = true
//        firstProductImageView.isHidden = true
//        secondProductImageView.isHidden = true
//        self.proTypeNameLabel.setTitle(cellModel.name ?? "", for: .normal)
//        //self.proTypeNameLabel.text = cellModel.name ?? ""
//        if cellType == .HomeCellTypeOnlyCombo || cellType == .HomeCellTypeSecKillAndCombo   || cellType == .HomeCellTypeComboAndShopRecomm {
//            topView.isHidden = false
//            if let model = self.cellModel ,let arr = model.floorProductDtos {
//                //套餐
//                let imgDefault = UIImage.init(named: "image_default_img")
//                for (index, model) in arr .enumerated() {
//                    if index == 0{
//                        firstProductImageView.isHidden = false
//                        firstProductImageView.setBackgroundImage(imgDefault, for: .normal)
//                        if let imgUrl = model.imgPath, let url = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
//                            firstProductImageView.sd_setImage(with: URL.init(string: url), for: .normal , placeholderImage: imgDefault)
//                        }
//                    }else if index == 1{
//                        secondProductImageView.isHidden = false
//                        secondProductImageView.setBackgroundImage(imgDefault, for: .normal)
//                        if let imgUrl = model.imgPath, let url = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
//                            secondProductImageView.sd_setImage(with: URL.init(string: url), for: .normal , placeholderImage: imgDefault)
//                        }
//                    }
//                }
//            }
//        }
//        
//    }
}

//MARK: - 数据展示
extension HomeComboInfoTypeView{
    
    func configCell(_ cellModel : HomeSecdKillProductModel,_ layoutType:Int){
        
        self.layoutType = layoutType
        self.cellModel = cellModel
        /*
        self.topView.isHidden = true
        self.firstProductImageView.isHidden = true
        self.secondProductImageView.isHidden = true
        
        self.containerView2.isHidden = true
        self.firstProductImageView2.isHidden = true
        self.secondProductImageView2.isHidden = true
        */
        if self.layoutType == 1{
            self.layoutType1()
            self.showType1Data(data:cellModel)
        }else if self.layoutType == 2{
            self.layoutType2()
            self.showType2Data(data:cellModel)
        }
    }
    
    func showType1Data(data:HomeSecdKillProductModel){
        if data.dinnerVOList.count >= 1{
            self.topView.isHidden = false
            let dinner1 = data.dinnerVOList[0]
            self.proTypeNameLabel.setTitle(data.name ?? "", for: .normal)
            self.proTypeNameLabel.layoutIfNeeded()
            self.proTypeNameLabel.snp_updateConstraints { (make) in
                make.height.equalTo(self.proTypeNameLabel.titleLabel?.hd_height ?? 0.0001)
            }
            if data.title?.isEmpty == false {
                self.subTitleBtn.isHidden = false
                self.subTitleBtn.setTitle(" "+data.title!+"   ", for: .normal)
                self.subTitleBtn.layoutIfNeeded()
                self.subTitleBtn.layoutButton(style: .Right, imageTitleSpace: -9)
            }else{
                self.subTitleBtn.isHidden = true
            }
            
            self.priceOriginalLabel.text = String(format: "¥%.2f", dinner1.dinnerOriginPrice)
            
            self.priceLabel.text = String(format: "套餐价¥%.2f", dinner1.dinnerPrice)
            
            for (index,product) in dinner1.productList.enumerated(){
                if index == 0{
                    if product.imgPath.isEmpty == false {
                        self.firstProductImageView.isHidden = false
                        self.firstProductImageView.sd_setImage(with: URL(string: product.imgPath), for: .normal, placeholderImage: UIImage(named: "img_product_default"))
                    }
                    self.product1PriceLB.text = String(format: "¥%.2f", product.dinnerPrice)
                }else if index == 1 {
                    if product.imgPath.isEmpty == false {
                        self.secondProductImageView.isHidden = false
                        self.secondProductImageView.sd_setImage(with: URL(string: product.imgPath), for: .normal, placeholderImage: UIImage(named: "img_product_default"))
                    }
                    self.product2PriceLB.text = String(format: "¥%.2f", product.dinnerPrice)
                }
            }
        }else{
            self.topView.isHidden = true
        }
        
        if data.dinnerVOList.count >= 2{
            self.containerView2.isHidden = false
            let dinner2 = data.dinnerVOList[1]
            self.priceLabel2.text = String(format: "套餐价¥%.2f", dinner2.dinnerPrice)
            self.priceOriginalLabel2.text = String(format: "¥%.2f", dinner2.dinnerOriginPrice)
            for (index,product) in dinner2.productList.enumerated(){
                if index == 0{
                    if product.imgPath.isEmpty == false {
                        self.firstProductImageView2.isHidden = false
                        self.firstProductImageView2.sd_setImage(with: URL(string: product.imgPath), for: .normal, placeholderImage: UIImage(named: "img_product_default"))
                    }
                    self.product3PriceLB.text = String(format: "¥%.2f", product.dinnerPrice)
                }else if index == 1{
                    if product.imgPath.isEmpty == false {
                        self.secondProductImageView2.isHidden = false
                        self.secondProductImageView2.sd_setImage(with: URL(string: product.imgPath), for: .normal, placeholderImage: UIImage(named: "img_product_default"))
                    }
                    self.product4PriceLB.text = String(format: "¥%.2f", product.dinnerPrice)
                }
            }
        }else{
            self.containerView2.isHidden = true
        }
    }
    
    func showType2Data(data:HomeSecdKillProductModel){
        guard data.dinnerVOList.count >= 1 else{
            self.topView.isHidden = true
            return
        }
        self.topView.isHidden = false
        let dinner1 = data.dinnerVOList[0]
        self.proTypeNameLabel.setTitle(data.name ?? "", for: .normal)
        self.proTypeNameLabel.layoutIfNeeded()
        self.proTypeNameLabel.snp_updateConstraints { (make) in
            make.height.equalTo(self.proTypeNameLabel.titleLabel?.hd_height ?? 0.0001)
        }
        if data.title?.isEmpty == false {
            self.subTitleBtn.isHidden = false
            self.subTitleBtn.setTitle(" "+data.title!+"   ", for: .normal)
            self.subTitleBtn.layoutIfNeeded()
            self.subTitleBtn.layoutButton(style: .Right, imageTitleSpace: -9)
        }else{
            self.subTitleBtn.isHidden = true
        }
        //self.proTypeNameLabel.text = data.name ?? ""
        self.priceOriginalLabel.text = String(format: "¥%.2f", dinner1.dinnerOriginPrice)
        self.priceLabel.text = String(format: "套餐价¥%.2f", dinner1.dinnerPrice)
        
        for (index,product) in dinner1.productList.enumerated(){
            if index == 0{
                if product.imgPath.isEmpty == false {
                    self.firstProductImageView.isHidden = false
                    self.firstProductImageView.sd_setImage(with: URL(string: product.imgPath), for: .normal, placeholderImage: UIImage(named: "img_product_default"))
                }
                self.product1PriceLB.text = "¥"+"\(product.dinnerPrice)"
            }else if index == 1 {
                if product.imgPath.isEmpty == false {
                    self.secondProductImageView.isHidden = false
                    self.secondProductImageView.sd_setImage(with: URL(string: product.imgPath), for: .normal, placeholderImage: UIImage(named: "img_product_default"))
                }
                self.product2PriceLB.text = "¥"+"\(product.dinnerPrice)"
            }
        }
    }
}

//MARK: -事件响应
extension HomeComboInfoTypeView{
    
    @objc func btnClicked(){
//        if let closure = self.clickProductBlock,self.cellModel != nil {
//            closure(nil,self.cellModel!,2)
//        }
    }
    
    @objc func proTypeClicked(){
        if let closure = self.clickProductBlock,self.cellModel != nil {
            closure(nil,self.cellModel!,"")
        }
    }
    
    /// 第一个商品点击
    @objc func firstProductClicked(){
        if let closure = self.clickProductBlock,self.cellModel != nil {
            closure(nil,self.cellModel!,self.getProductID(index: 1))
        }
    }
    
    /// 第二个商品点击
    @objc func secondProductClicked(){
        if let closure = self.clickProductBlock,self.cellModel != nil {
            closure(nil,self.cellModel!,self.getProductID(index: 2))
        }
    }
    
    /// 第三个商品点击
    @objc func thirdProductClicked(){
        if let closure = self.clickProductBlock,self.cellModel != nil {
            closure(nil,self.cellModel!,self.getProductID(index: 3))
        }
    }
    
    /// 第四个商品点击
    @objc func fourthProductClicked(){
        if let closure = self.clickProductBlock,self.cellModel != nil {
            closure(nil,self.cellModel!,self.getProductID(index: 4))
        }
    }
}

//MAKR: -私有方法
extension HomeComboInfoTypeView {
    
    func getProductID(index:Int) -> String{
        guard let data = self.cellModel, data.dinnerVOList.count >= 1 else{
            return ""
        }
        if data.dinnerVOList.count >= 1{
            let dinner1 = data.dinnerVOList[0]
            for (index_t,product) in dinner1.productList.enumerated(){
                if index == 1,index_t == 0{
                    return product.spuCode
                }else if index == 2,index_t == 1{
                    return product.spuCode
                }
            }
        }
            
        if data.dinnerVOList.count >= 2{
            let dinner2 = data.dinnerVOList[1]
            for (index_t,product) in dinner2.productList.enumerated(){
                if index == 3,index_t == 0{
                    return product.spuCode
                }else if index == 4,index_t == 1{
                    return product.spuCode
                }
            }
        }
        
        return ""
    }
}

//MARK: UI
extension HomeComboInfoTypeView {
    // MARK: - UI
    func setupView() {
        backgroundColor = UIColor.white
        self.addSubview(topView)
        topView.addSubview(proTypeNameLabel)
        topView.addSubview(subTitleBtn)
        topView.addSubview(firstProductImageView)
        topView.addSubview(product1PriceLB)
        topView.addSubview(addImageView)
        topView.addSubview(secondProductImageView)
        topView.addSubview(product2PriceLB)
        topView.addSubview(priceLabel)
        topView.addSubview(priceOriginalLabel)
        
        self.addSubview(containerView2)
        containerView2.addSubview(firstProductImageView2)
        containerView2.addSubview(product3PriceLB)
        containerView2.addSubview(addImageView2)
        containerView2.addSubview(secondProductImageView2)
        containerView2.addSubview(product4PriceLB)
        containerView2.addSubview(priceLabel2)
        containerView2.addSubview(priceOriginalLabel2)
        containerView2.addSubview(containerView2Btn)
        
        topView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        proTypeNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topView).offset(WH(13))
            make.left.equalTo(topView).offset(WH(14))
            make.width.lessThanOrEqualTo(WH(72))
            make.height.equalTo(0)
        }
        
        self.subTitleBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.proTypeNameLabel)
            make.left.equalTo(self.proTypeNameLabel.snp_right).offset(WH(5))
            make.height.equalTo(WH(16))
        }
        
        addImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(topView)
            make.top.equalTo(topView).offset(WH(66))
            make.height.equalTo(WH(20))
            make.width.equalTo(WH(20))
        }
        
        
        
        firstProductImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(addImageView.snp.centerY)
            make.right.equalTo(addImageView.snp.left)
            make.height.width.equalTo(WH(60))
        }
        
        self.product1PriceLB.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.firstProductImageView)
            make.centerY.equalTo(self.firstProductImageView.snp_bottom)
            make.height.equalTo(WH(13))
        }
        
        secondProductImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(addImageView.snp.centerY)
            make.left.equalTo(addImageView.snp.right)
            make.height.width.equalTo(WH(60))
        }
        
        self.product2PriceLB.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.secondProductImageView)
            make.centerY.equalTo(self.secondProductImageView.snp_bottom)
            make.height.equalTo(WH(13))
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstProductImageView.snp.bottom).offset(WH(13))
            make.left.equalTo(topView).offset(WH(14))
        }
        
        priceOriginalLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.left.equalTo(priceLabel.snp.right).offset(WH(7))
        }
        
        //--------------------
        addImageView2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(containerView2).offset(WH(66))
            make.height.equalTo(WH(20))
            make.width.equalTo(WH(20))
        }
        
        firstProductImageView2.snp.makeConstraints { (make) in
            make.centerY.equalTo(addImageView2.snp.centerY)
            make.right.equalTo(addImageView2.snp.left)
            make.height.width.equalTo(WH(60))
        }
        
        self.product3PriceLB.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.firstProductImageView2)
            make.centerY.equalTo(self.firstProductImageView2.snp_bottom)
            make.height.equalTo(WH(13))
        }
        
        secondProductImageView2.snp.makeConstraints { (make) in
            make.centerY.equalTo(addImageView2.snp.centerY)
            make.left.equalTo(addImageView2.snp.right)
            make.height.width.equalTo(WH(60))
        }
        
        self.product4PriceLB.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.secondProductImageView2)
            make.centerY.equalTo(self.secondProductImageView2.snp_bottom)
            make.height.equalTo(WH(13))
        }
        
        priceLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(firstProductImageView2.snp.bottom).offset(WH(13))
            make.left.equalTo(containerView2).offset(WH(14))
        }
        
        priceOriginalLabel2.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceLabel2.snp.centerY)
            make.left.equalTo(priceLabel2.snp.right).offset(WH(7))
        }
        
        containerView2Btn.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
    }
    
    /// 1个套餐组件占满一整行
    func layoutType1(){
        self.topView.isHidden = false
        self.containerView2.isHidden = false
        self.containerView2.snp_remakeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(self.topView)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        self.topView.snp_remakeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    /// 2个套餐组件占满一整行
    func layoutType2(){
        self.topView.isHidden = false
        self.containerView2.isHidden = true
        self.topView.snp_remakeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        self.containerView2.snp_remakeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(0)
        }
    }
}
