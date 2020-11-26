//
//  FKYShopPromotionProuductCell.swift
//  FKY
//
//  Created by hui on 2019/10/30.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

let SHOP_PROMOTION_ITEM_H = WH(140) // 商品item宽度
let SHOP_PROMOTION_ITEM_W = (SCREEN_WIDTH-WH(4*9))/3.0 //2*3样式商品item的宽度
//店铺中的商品
class FKYShopPromotionProuductCell: UITableViewCell {
    // 头部视图
    fileprivate lazy var promotionHeadView: FKYShopPrdTitleView = {
        let view = FKYShopPrdTitleView()
        view.clickViewBlock = { [weak self] (typeIndex) in
            if let strongSelf = self {
                if typeIndex == 1 {
                    if let block = strongSelf.clickViewBock {
                        block(3,0,strongSelf.promotionModel,nil)
                    }
                }
            }
        }
        return view
    }()
    //商品列表
    fileprivate lazy var promotionCollectionView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = WH(9)
        flowLayout.minimumInteritemSpacing = WH(9)
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(FKYShopPromotionItmeViewCell.self, forCellWithReuseIdentifier: "FKYShopPromotionItmeViewCell")
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.bounces = false
        view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        //        if #available(iOS 11, *) {
        //            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
        //            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
        //                view.contentInsetAdjustmentBehavior = .never
        //            }
        //        }
        return view
    }()
    
    //MARK:业务属性
    // 数据源
    var promotionModel : FKYShopPromotionBaseInfoModel?
    var clickViewBock : ((Int,Int?,FKYShopPromotionBaseInfoModel?,HomeRecommendProductItemModel?)->(Void))? //点击视图(1:加车)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = RGBColor(0xF4F4F4)
        contentView.addSubview(promotionHeadView)
        promotionHeadView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(contentView)
            make.height.equalTo(WH(103))
        }
        contentView.addSubview(promotionCollectionView)
        promotionCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(promotionHeadView.snp.bottom).offset(-WH(63))
            make.bottom.left.right.equalTo(contentView)
        }
    }
    
}
extension FKYShopPromotionProuductCell {
    func configShopPromotionProudctCell(_ promotionPrdModel:FKYShopPromotionBaseInfoModel){
        self.promotionModel = promotionPrdModel
        self.promotionHeadView.configShopPrdViewData(promotionPrdModel)
        self.promotionCollectionView.reloadData()
    }
    //计算高度
    static func configShopPromotionCellH(_ prdArr :[HomeRecommendProductItemModel]) -> CGFloat{
        var baseW = WH(42)
        if prdArr.count > 0 {
            let picNum = prdArr.count
            var lineNum = picNum/3
            if picNum % 3 != 0 {
                lineNum = lineNum + 1
            }
            baseW = baseW + CGFloat(lineNum)*(WH(140+9))
        }
        return baseW
        
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension FKYShopPromotionProuductCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let arr = self.promotionModel?.productList ,arr.count > 0 {
            return arr.count
        }
        return  0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //商品
        return CGSize(width:SHOP_PROMOTION_ITEM_W, height:SHOP_PROMOTION_ITEM_H)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYShopPromotionItmeViewCell", for: indexPath) as! FKYShopPromotionItmeViewCell
        if let promotionModel = self.promotionModel,let arr = promotionModel.productList {
            let model = arr[indexPath.item]
            cell.configShopPromotionItemCell(model)
            cell.addUpdateCartAction = { [weak self] in
                if let strongSelf = self {
                    if let block = strongSelf.clickViewBock {
                        block(1,indexPath.item,promotionModel,model)
                    }
                }
            }
            cell.noticeAction = { [weak self] in
                if let _ = self {
                    FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                        let controller = vc as! ArrivalProductNoticeVC
                        controller.productId = model.spuCode ?? ""
                        controller.venderId = "\(model.supplyId ?? 0)"
                        controller.productUnit = model.unit ?? ""
                    }, isModal: false)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let promotionModel = self.promotionModel,let arr = promotionModel.productList {
            if let block = self.clickViewBock {
                block(2,indexPath.item,promotionModel,arr[indexPath.item])
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets(top: WH(0), left: WH(9), bottom: WH(0), right: WH(9))
    }
}
//MARK:首页商品cell
class FKYShopPromotionItmeViewCell: UICollectionViewCell {
    //商品图片
    fileprivate var productImageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    //商品名称
    fileprivate var productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = t33.font
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    // 加车按钮
    fileprivate lazy var cartIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "new_shop_car_icon"), for: UIControl.State())
        button.imageView?.contentMode = .scaleToFill
        button.imageEdgeInsets = UIEdgeInsets(top: WH(10), left: WH(10), bottom: WH(10), right: WH(10))
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.addUpdateCartAction {
                closure()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    //抢购按钮
    var cartBadgeView : JSBadgeView?
    
    //商品购买价格
    fileprivate var priceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = t73.color
        label.font = t17.font
        return label
    }()
    //cell状态《未登录或者资质未认证》
    fileprivate var statusLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = t73.color
        label.font = t33.font
        return label
    }()
    // 到货通知按钮
    fileprivate lazy var statusBtn: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setTitle("到货通知", for: .normal)
        button.backgroundColor = bg1
        button.setTitleColor(RGBColor(0xFF2D5C), for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(14))
        button.layer.masksToBounds = true
        button.layer.cornerRadius = WH(12)
        button.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        button.layer.borderWidth = 1
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.noticeAction {
                closure()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    //标签图片1
    fileprivate var tagOneImageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    //标签图片2
    fileprivate var tagTwoImageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    //业务属性
    var addUpdateCartAction: emptyClosure?//更新加车
    var noticeAction: emptyClosure?//更新加车
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFFFFFF), to: RGBColor(0xFFFEFD), withWidth: Float(SHOP_PROMOTION_ITEM_W))
        //self.layer.masksToBounds = true
        self.layer.cornerRadius = WH(8)
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowColor = RGBAColor(0xD9D9D9,alpha: 0.3).cgColor
        self.layer.shadowOpacity = 1;//阴影透明度，默认0
        self.layer.shadowRadius = 4;//阴影半径
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(10))
            make.height.width.equalTo(WH(70))
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        contentView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(5))
            make.right.equalTo(contentView.snp.right).offset(-WH(5))
            make.top.equalTo(self.productImageView.snp.bottom).offset(WH(8))
            make.height.equalTo(WH(14))
        }
        
        contentView.addSubview(cartIcon)
        self.cartIcon.snp.makeConstraints({ (make) in
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
            make.width.height.equalTo(WH(45))
        })
        cartBadgeView = {
            let cbv = JSBadgeView.init(parentView: self.cartIcon, alignment:JSBadgeViewAlignment.topRight)
            cbv?.badgePositionAdjustment = CGPoint(x: WH(-14), y: WH(15))
            cbv?.badgeTextFont = UIFont.systemFont(ofSize: WH(12))
            cbv?.badgeTextColor =  RGBColor(0xFFFFFF)
            cbv?.badgeBackgroundColor = RGBColor(0xFF2D5C)
            return cbv
        }()
        
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel.snp.left)
            make.right.equalTo(cartIcon.snp.left).offset(-WH(2))
            make.top.equalTo(productNameLabel.snp.bottom).offset(WH(10))
            make.height.equalTo(WH(14))
        }
        
        contentView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(9))
            make.right.equalTo(contentView.snp.right).offset(-WH(2))
            make.top.equalTo(productNameLabel.snp.bottom).offset(WH(12))
            make.height.equalTo(WH(14))
        }
        contentView.addSubview(statusBtn)
        statusBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(9))
            make.height.equalTo(WH(24))
            make.width.equalTo(WH(90))
        }
        
        contentView.addSubview(tagOneImageView)
        tagOneImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left)
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(68))
            make.height.equalTo(WH(15))
            make.width.equalTo(WH(30))
        }
        contentView.addSubview(tagTwoImageView)
        tagTwoImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left)
            make.bottom.equalTo(tagOneImageView.snp.top).offset(-WH(5))
            make.height.equalTo(WH(15))
            make.width.equalTo(WH(30))
        }
    }
    
    func configShopPromotionItemCell(_ productModel:Any) {
        if let model = productModel as? FKYShopPromotionBaseProductModel{
            let imgDefault = UIImage.init(named: "image_default_img")
            productImageView.image = imgDefault
            if let imgUrl = model.productImg, let url = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                productImageView.sd_setImage(with: URL.init(string: url) , placeholderImage: imgDefault)
            }
            productNameLabel.text = model.shortName
            priceLabel.isHidden = true
            statusLabel.isHidden = true
            cartIcon.isHidden = true
            statusBtn.isHidden = true
            if let status = model.statusDesc{
                if status == "-1" {
                    //未登录
                    statusLabel.isHidden = false
                    statusLabel.text = "登录后可见"
                }else if status == "-3" {
                    //资质认证后可见
                    statusLabel.isHidden = false
                    statusLabel.text = "资质认证后可见"
                }else if status == "-5" {
                    //资质认证后可见
                    statusBtn.isHidden = false
                }else if status == "0" {
                    //正常显示价格
                    if let price = model.showPrice,price.count > 0 {
                        priceLabel.text = String.init(format: "¥ %@",price)
                        priceLabel.isHidden = false
                        cartIcon.isHidden = false
                        if  model.carOfCount > 0 && model.carId != 0 {
                            self.cartBadgeView?.isHidden = false
                            if model.carOfCount > 999 {
                                self.cartBadgeView?.badgeText = "999+"
                            }else {
                                self.cartBadgeView?.badgeText = "\(model.carOfCount)"
                            }
                            
                        }else{
                            self.cartBadgeView?.isHidden = true
                        }
                    }
                }
            }
        }else if let model = productModel as? HomeRecommendProductItemModel {
            if let strProductPicUrl = model.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.productImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
            }else{
                self.productImageView.image = UIImage.init(named: "image_default_img")
            }
            productNameLabel.text = model.productName
            priceLabel.isHidden = true
            statusLabel.isHidden = true
            cartIcon.isHidden = true
            statusBtn.isHidden = true
            if let status = model.statusDesc{
                if status == -1 {
                    //未登录
                    statusLabel.isHidden = false
                    statusLabel.text = "登录后可见"
                }else if status == -3 {
                    //资质认证后可见
                    statusLabel.isHidden = false
                    statusLabel.text = "资质认证后可见"
                }else if status == -5 {
                    //资质认证后可见
                    statusBtn.isHidden = false
                }else if status == 0 {
                    //正常显示价格
                    let price = getShowPrice(model)
                    priceLabel.isHidden = false
                    if price.count > 0 {
                        priceLabel.text = price
                    }else {
                        priceLabel.text = "¥--"
                    }
                    if let num = model.singleCanBuy, num == 1 {
                        cartIcon.isHidden = true
                        self.cartIcon.snp.updateConstraints({ (make) in
                            make.width.equalTo(0)
                        })
                    }else {
                        cartIcon.isHidden = false
                        self.cartIcon.snp.updateConstraints({ (make) in
                            make.width.equalTo(WH(45))
                        })
                        if  model.carOfCount > 0 && model.carId != 0 {
                            self.cartBadgeView?.isHidden = false
                            if model.carOfCount > 999 {
                                self.cartBadgeView?.badgeText = "999+"
                            }else {
                                self.cartBadgeView?.badgeText = "\(model.carOfCount)"
                            }
                            
                        }else{
                            self.cartBadgeView?.isHidden = true
                        }
                    }
                }
            }
            tagOneImageView.isHidden = true
            tagTwoImageView.isHidden = true
            if model.tagArr.count > 0  {
                for i in 0...model.tagArr.count-1 {
                    if i == 0 {
                        tagOneImageView.isHidden = false
                        tagOneImageView.image = FKYTagFlagManager.shareInstance.tagNameShopImage(tagName: model.tagArr[i])
                        if model.tagArr[i].count == 3 {
                            tagOneImageView.snp.updateConstraints { (make) in
                                make.width.equalTo(WH(40))
                            }
                        }else {
                            tagOneImageView.snp.updateConstraints { (make) in
                                make.width.equalTo(WH(30))
                            }
                        }
                    }else if i == 1 {
                        tagTwoImageView.isHidden = false
                        tagTwoImageView.image = FKYTagFlagManager.shareInstance.tagNameShopImage(tagName: model.tagArr[i])
                        if model.tagArr[i].count == 3 {
                            tagTwoImageView.snp.updateConstraints { (make) in
                                make.width.equalTo(WH(40))
                            }
                        }else {
                            tagTwoImageView.snp.updateConstraints { (make) in
                                make.width.equalTo(WH(30))
                            }
                        }
                    }else {
                        break
                    }
                }
            }
        }
    }
}
extension FKYShopPromotionItmeViewCell {
    fileprivate func getShowPrice (_ model:HomeRecommendProductItemModel) -> String{
        var showPrice = ""
        if let price = model.productPrice , price > 0 {
            showPrice = String.init(format: "¥ %.2f", price)
        }
        if let price = model.specialPrice , price > 0 {
            showPrice = String.init(format: "¥ %.2f", price)
        }
        if let _ = model.vipPromotionId ,let vipNum = model.visibleVipPrice ,vipNum > 0 {
            if let vipAvailableNum = model.availableVipPrice ,vipAvailableNum > 0 {
                //会员
                showPrice = String.init(format: "¥ %.2f",vipNum)
            }
        }
        return showPrice
    }
}

extension FKYShopPromotionItmeViewCell {
    
}
