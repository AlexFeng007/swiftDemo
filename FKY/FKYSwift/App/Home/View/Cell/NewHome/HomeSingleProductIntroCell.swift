//
//  HomeSingleProductIntroCell.swift
//  FKY
//
//  Created by 寒山 on 2019/7/4.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class HomeSingleProductIntroCell: UITableViewCell {

    // closure
    var updateAddProductNum: addCarClosure? //加车更新
    var toastAddProductNum : SingleStringClosure? //加车提示
    var touchItem: emptyClosure? // 商详
    var moreCallback: (()->())? // 查看更多
    // 背景
    public lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear//RGBColor(0xffffff)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        return view
    }()
    
    // 推荐背景
    public lazy var bgImgView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.moreCallback {
                closure()
            }
        }).disposed(by: disposeBag)
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    // 推荐名
    public lazy var introTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFFFFFF)
        label.font = UIFont.boldSystemFont(ofSize: WH(20))
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
       // label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
   
    // 背景
    public lazy var productView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(8)
        
//        let bgLayer1 = CAGradientLayer()
//        bgLayer1.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor, UIColor(red: 1, green: 1, blue: 0.99, alpha: 1).cgColor]
//        bgLayer1.locations = [0, 1]
//        bgLayer1.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(74), height: (SCREEN_WIDTH)*121/375.0 - WH(20))
//        bgLayer1.startPoint = CGPoint(x: 0.5, y: 1)
//        bgLayer1.endPoint = CGPoint(x: 0.02, y: 0.02)
//        bgLayer1.cornerRadius =  WH(8)
//        bgLayer1.masksToBounds = false
//
//        view.layer.addSublayer(bgLayer1)
        // shadowCode
//        view.layer.shadowColor = UIColor(red: 0.74, green: 0.52, blue: 0.89, alpha: 0.3).cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 4)
//        view.layer.shadowOpacity = 1
//        view.layer.shadowRadius = 4
//        view.clipsToBounds = false;
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.touchItem {
                closure()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    
    // 副标题 背景
    public lazy var gradientLayer: CAGradientLayer = {
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = [UIColor(red: 1, green: 0.81, blue: 0.89, alpha: 1).cgColor, UIColor(red: 1, green: 0.96, blue: 0.97, alpha: 1).cgColor]
        bgLayer1.locations = [0, 1]
        bgLayer1.startPoint = CGPoint(x: 0.05, y: 0.5)
        bgLayer1.endPoint = CGPoint(x: 0.5, y: 0.5)
        return bgLayer1
    }()
    
    // 背景
    public lazy var descView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.masksToBounds = true
        return view
    }()
    // 名称
    public lazy var descTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        label.backgroundColor = .clear
        return label
    }()
    
    // 商品图片
    public lazy var imgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        return iv
    }()
    // 名称
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x333333)
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.boldSystemFont(ofSize: WH(15))
        label.backgroundColor = .clear
        return label
    }()
    
    //供应商
    public lazy var supplyLabel: UILabel = {
        let label = UILabel()
        label.font = t22.font
        label.textColor = RGBColor(0x666666)
        label.backgroundColor = .clear
        return label
    }()
    
    // 价格
    public lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(19))
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    // 特价...<带中划线>
    public lazy var tjPrice: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.fontTuple = t20
        
        let line = UIView()
        label.addSubview(line)
        line.snp.makeConstraints({ (make) in
            make.left.right.centerY.equalTo(label)
            make.height.equalTo(WH(1))
        })
        line.backgroundColor = t11.color
        
        return label
    }()
    
    // 抢购
    public lazy var addProductBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("立即抢购", for: .normal)
        btn.titleLabel?.font = t21.font
        btn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        btn.backgroundColor = RGBColor(0xFFFFFF)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(13)
        btn.layer.borderWidth = WH(1)
        btn.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self]  (_) in
            guard let strongSelf = self else {
                return
            }
            if FKYLoginAPI.loginStatus() == .unlogin {
                FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
                return
            }
            btn.isHidden = true
            strongSelf.stepper.isHidden = false
            strongSelf.stepper.addNumWithAuto()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 加车器
    public lazy var stepper: CartStepper = {
        let stepper = CartStepper()
        stepper.oftenBuyPattern(2)
        stepper.bgView.backgroundColor =  RGBColor(0xffffff)
        //
        stepper.toastBlock = { [weak self] (str) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.toastAddProductNum {
                closure(str!)
            }
        }
        //修改数量时候
        stepper.updateProductBlock = { [weak self] (count : Int,typeIndex : Int) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.updateAddProductNum {
                closure(count,typeIndex)
            }
        }
        return stepper
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        contentView.addSubview(bgView)
        bgView.addSubview(bgImgView)
        bgView.addSubview(introTitleLabel)
        
        bgView.addSubview(productView)
        
        productView.addSubview(descView)
        descView.layer.addSublayer(gradientLayer)
        descView.addSubview(descTitleLabel)
       
        
        productView.addSubview(imgView)
        productView.addSubview(titleLabel)
        productView.addSubview(supplyLabel)
        productView.addSubview(priceLabel)
        productView.addSubview(tjPrice)
        productView.addSubview(addProductBtn)
        productView.addSubview(stepper)
        
        bgView.snp.makeConstraints({ (make) in
            make.right.equalTo(contentView)
            make.left.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(WH(-10))
            make.top.equalTo(contentView);
        })
        bgImgView.snp.makeConstraints({ (make) in
            make.edges.equalTo(bgView);
        })
        introTitleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(bgView).offset(WH(11))
            make.top.equalTo(bgView).offset(WH(25))
            make.width.equalTo(WH(42));
            make.height.equalTo(WH(42));
        })
        productView.snp.makeConstraints({ (make) in
            make.left.equalTo(bgView).offset(WH(64))
            make.right.equalTo(bgView).offset(WH(-10))
           // make.centerY.equalTo(bgView)
            make.top.equalTo(bgView).offset(WH(10))
            make.bottom.equalTo(bgView).offset(WH(-10));
        })
        
        descView.snp.makeConstraints({ (make) in
            make.left.top.equalTo(productView)
            make.width.equalTo(WH(91))
            make.height.equalTo(WH(17))
        })
        
        descTitleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(descView).offset(WH(4))
            make.top.equalTo(descView)
            make.centerY.equalTo(descView)
        })
        
        imgView.snp.makeConstraints({ (make) in
            make.left.equalTo(self.productView).offset(WH(9))
            make.top.equalTo(self.productView).offset(WH(17))
            make.width.equalTo(WH(70))
            make.height.equalTo(WH(70))
        })
        
        titleLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(self.productView).offset(WH(19))
            make.left.equalTo(self.imgView.snp.right).offset(WH(8))
            make.right.equalTo(self.productView).offset(-WH(12))
            make.height.equalTo(WH(15))
        })
        supplyLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.imgView.snp.right).offset(WH(8))
            make.top.equalTo(self.titleLabel.snp.bottom).offset(WH(7))
            make.right.equalTo(self.productView).offset(-WH(12))
            make.height.equalTo(WH(12))
        })
       
        addProductBtn.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.productView).offset(WH(-12))
            make.right.equalTo(self.productView).offset(-WH(9))
            make.width.equalTo(WH(90))
            make.height.equalTo(WH(26))
        })
        
        stepper.snp.makeConstraints({ (make) in
            make.centerY.equalTo( self.addProductBtn.snp.centerY)
            make.right.equalTo(self.productView).offset(-WH(9))
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(90))
        })
        
        priceLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(stepper.snp.centerY)
            make.left.equalTo(self.imgView.snp.right).offset(WH(8))
            make.width.lessThanOrEqualTo(WH(SCREEN_WIDTH/4))
            make.width.greaterThanOrEqualTo(WH(50))
            make.height.equalTo(WH(19))
        })
        
        tjPrice.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.priceLabel.snp.centerY)
            make.left.equalTo(self.priceLabel.snp.right).offset(WH(3))
            make.width.lessThanOrEqualTo(WH(SCREEN_WIDTH/4))
        })
        
    }
    func configCell(_ model:HomeSecdKillProductModel) {
    
        if  let floorProductDtos = model.floorProductDtos, floorProductDtos.isEmpty == false{
            let productmModel:HomeRecommendProductItemModel = floorProductDtos[0]
            titleLabel.text =  productmModel.productName
            supplyLabel.text = productmModel.factoryName
            
            descTitleLabel.text = model.title
            if model.title != nil{
                let width = COProductItemCell.calculateStringWidth(model.title!,  UIFont.boldSystemFont(ofSize: WH(12)), WH(100))
                gradientLayer.frame = CGRect.init(x: 0, y: 0, width: width + WH(19), height: WH(17))
                descView.snp.updateConstraints({ (make) in
                    make.width.equalTo(width + WH(19))
                })
                let corner = UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.bottomRight.rawValue)
                let maskPath = UIBezierPath(roundedRect: CGRect.init(x: 0, y: 0, width: width + WH(19), height: WH(17)), byRoundingCorners: corner, cornerRadii: CGSize(width: WH(6), height:WH(6)))
                let maskLayer = CAShapeLayer()
                maskLayer.frame = CGRect.init(x: 0, y: 0, width: width + WH(19), height: WH(17))
                maskLayer.path = maskPath.cgPath
                descView.layer.mask = maskLayer
            }
         
            if let strProductPicUrl = productmModel.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.imgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
            }
            // 价格
            if productmModel.statusDesc != 0{
                self.priceLabel.text = productmModel.statusMsg
                self.priceLabel.font = UIFont.boldSystemFont(ofSize: WH(14))
                self.addProductBtn.isHidden = false
                self.stepper.isHidden = true
                self.tjPrice.isHidden = true
            }else{
                
                self.addProductBtn.isHidden = false
                self.stepper.isHidden = true
                //加车器
                if productmModel.carOfCount > 0 && productmModel.carId != 0 {
                    self.addProductBtn.isHidden = true
                    self.stepper.isHidden = false
                }
                // 加车数
                self.configStepCount(productmModel)
                self.priceLabel.font = UIFont.boldSystemFont(ofSize: WH(19))
                self.tjPrice.isHidden = true;
                
                if let specialPrice = productmModel.specialPrice,specialPrice > 0{
                    priceLabel.attributedText = self.priceTitleString(String(format: "%0.2f",specialPrice))
                    if let productPrice = productmModel.productPrice,productPrice > 0{
                        tjPrice.text = String(format: "￥%0.2f",productmModel.productPrice!)
                    }
                
                    if let originFlag = model.originalPriceFlag, originFlag == 1 {
                        // 显示
                         tjPrice.isHidden = false
                    }
                    else {
                        // 不显示
                        tjPrice.isHidden = true
                    }
                   
                }else{
                    tjPrice.isHidden = true
                    if let productPrice = productmModel.productPrice,productPrice > 0{
                        priceLabel.attributedText = self.priceTitleString(String(format: "%0.2f",productPrice))
                    }
                }
            }
        }
        bgImgView.image = UIImage.init(named:"sigle_pro_bg")
        if model.name != nil{
             introTitleLabel.attributedText = self.shoadowTitleString(model.name!)
        }
       

    }
    //初始化加车器
    func configStepCount(_ model: HomeRecommendProductItemModel) {
        
        let baseCount = model.wholeSaleNum
        let stepCount =  model.inimumPacking
        let stockCount = model.productInventory
        
        var minCount = 0
        if let co = model.wholeSaleNum {
            minCount = co
        }
        
        var quantityCount = 0
        if  model.carOfCount == 0 {
            if minCount != 0 {
                quantityCount = minCount
            }else{
                quantityCount = model.inimumPacking!
            }
        }else {
            quantityCount = model.carOfCount
        }
        
        var isTJ : Bool = false
        if (model.specialPrice != nil && model.specialPrice != 0.0) {
            isTJ = true
        }
        
        var limitBuyNum : NSInteger = 0
        if let surplusNum = model.surplusBuyNum {
            limitBuyNum = surplusNum
        } else {
            limitBuyNum = 0
        }
        self.stepper.configStepperBaseCount(baseCount!, stepCount: stepCount!, stockCount: stockCount!, limitBuyNum: limitBuyNum, quantity: quantityCount ,and:isTJ, and:minCount)
    }
    fileprivate func shoadowTitleString(_ titleStr:String) -> (NSMutableAttributedString) {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red: 0.53, green: 0.26, blue: 0.78,alpha:0.44)
        shadow.shadowBlurRadius = 4
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        let attrString = NSMutableAttributedString(string: titleStr)
        attrString.addAttribute(NSAttributedString.Key.foregroundColor,
                                value: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
                                range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedString.Key.shadow,
                                value: shadow,
                                range: NSMakeRange(0, attrString.length))
        return  attrString
    }
    fileprivate func priceTitleString(_ price:String) -> (NSMutableAttributedString) {
        let priceTmpl = NSMutableAttributedString()
        
        var priceStr = NSAttributedString(string:"￥")
        priceTmpl.append(priceStr)
        priceTmpl.addAttribute(NSAttributedString.Key.font,
                                value: FKYBoldSystemFont(WH(10)),
                                range: NSMakeRange(priceTmpl.length - priceStr.length, priceStr.length))
        
        priceStr = NSAttributedString(string:price)
        priceTmpl.append(priceStr)
        priceTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                value: RGBColor(0xFF2D5C),
                                range: NSMakeRange(priceTmpl.length - priceStr.length, priceStr.length))
        
        return priceTmpl
    }
}
