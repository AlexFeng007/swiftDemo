//
//  ShopSingleSecKillCell.swift
//  FKY
//
//  Created by 寒山 on 2020/3/31.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  店铺内单品秒杀

import UIKit

class ShopSingleSecKillCell: UITableViewCell {
    var updateAddProductNum: addCarClosure? //加车更新
    var toastAddProductNum : SingleStringClosure? //加车提示
    var touchItem: emptyClosure? // 商详
    var moreCallback: (()->())? // 查看更多
    //背景标题视图
    fileprivate lazy var bgImageView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.alpha = 0.8
        let finalSize = CGSize(width: SCREEN_WIDTH, height:WH(130))
        let layerHeight = finalSize.height * 0.3
        let layer = CAShapeLayer()
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 0, y: finalSize.height - layerHeight))
        bezier.addLine(to: CGPoint(x: 0, y: 0))
        bezier.addLine(to: CGPoint(x: finalSize.width, y: 0))
        bezier.addLine(to: CGPoint(x: finalSize.width, y: finalSize.height - layerHeight))
        bezier.addQuadCurve(to: CGPoint(x: 0, y: finalSize.height - layerHeight),
                            controlPoint: CGPoint(x: finalSize.width / 2, y: finalSize.height))
        layer.path = bezier.cgPath
        layer.fillColor = UIColor.gradientLeftToRightColor(RGBAColor(0xFF8EB9, alpha: 1.0), RGBAColor(0xC776FF, alpha: 1.0), SCREEN_WIDTH).cgColor
        view.layer.addSublayer(layer)
        
        return view
    }()
    //商品背景
    fileprivate lazy var contentBgView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(8)
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
    
    //一级标题
    fileprivate lazy var proTypeNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = UIColor.white
        label.backgroundColor = .clear
        return label
    }()
    //左边的的图片
    fileprivate lazy  var leftTitleView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "shop_left_pic")
        return img
    }()
    //右边的的图片
    fileprivate var rightTitleView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "shop_right_pic")
        return img
    }()
    
    //抢购中文字描述
    fileprivate lazy var proTypetipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textColor = UIColor.white
        label.backgroundColor = .clear
        label.text = "查看更多"
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.moreCallback {
                closure()
            }
        }).disposed(by: disposeBag)
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    //向右的箭头
    fileprivate lazy var rightImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "home_right_pic")
        img.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.moreCallback {
                closure()
            }
        }).disposed(by: disposeBag)
        img.addGestureRecognizer(tapGesture)
        return img
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
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
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
    //    // 商品限购描述
    //    public lazy var descTitleLabel: UILabel = {
    //        let label = UILabel()
    //        label.textColor = RGBColor(0xFF2D5C)
    //        label.font = UIFont.boldSystemFont(ofSize: WH(12))
    //        label.backgroundColor = .clear
    //        return label
    //    }()
    
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
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView(){
        self.backgroundColor = RGBColor(0xF4F4F4)
        self.contentView.addSubview(bgImageView)
        self.contentView.addSubview(contentBgView)
        // contentBgView.isHidden = true
        bgImageView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
            make.height.equalTo(WH(130))
        })
        
        contentBgView.snp.makeConstraints({ (make) in
            make.right.bottom.equalTo(self.contentView).offset(WH(-10))
            make.left.equalTo(self.contentView).offset(WH(10))
            make.top.equalTo(bgImageView.snp.bottom).offset(WH(-90))
            //make.height.equalTo(WH(101))
        })
        
        bgImageView.addSubview(proTypeNameLabel)
        proTypeNameLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(bgImageView).offset(WH(9))
            make.centerX.equalTo(bgImageView.snp.centerX);
            make.width.lessThanOrEqualTo(WH(120))
        })
        bgImageView.addSubview(leftTitleView)
        bgImageView.addSubview(rightTitleView)
        leftTitleView.snp.makeConstraints({ (make) in
            make.right.equalTo(proTypeNameLabel.snp.left).offset(WH(-14))
            make.centerY.equalTo(proTypeNameLabel.snp.centerY);
        })
        rightTitleView.snp.makeConstraints({ (make) in
            make.left.equalTo(proTypeNameLabel.snp.right).offset(WH(14))
            make.centerY.equalTo(proTypeNameLabel.snp.centerY);
        })
        
        
        
        bgImageView.addSubview(rightImageView)
        rightImageView.snp.makeConstraints({ (make) in
            make.right.equalTo(bgImageView.snp.right).offset(-WH(20))
            make.centerY.equalTo(proTypeNameLabel.snp.centerY);
            make.width.height.equalTo(WH(13))
        })
        bgImageView.addSubview(proTypetipLabel)
        proTypetipLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(rightImageView.snp.left).offset(-WH(5))
            make.centerY.equalTo(proTypeNameLabel.snp.centerY);
            make.width.lessThanOrEqualTo(WH(85))
            make.height.equalTo(WH(40))
        })
        
        contentBgView.addSubview(imgView)
        contentBgView.addSubview(titleLabel)
        contentBgView.addSubview(supplyLabel)
        // contentBgView.addSubview(descTitleLabel)
        contentBgView.addSubview(priceLabel)
        contentBgView.addSubview(tjPrice)
        contentBgView.addSubview(addProductBtn)
        contentBgView.addSubview(stepper)
        
        imgView.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentBgView).offset(WH(9))
            make.top.equalTo(self.contentBgView).offset(WH(12))
            make.width.equalTo(WH(77))
            make.height.equalTo(WH(77))
        })
        
        titleLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(self.contentBgView).offset(WH(12))
            make.left.equalTo(self.imgView.snp.right).offset(WH(8))
            make.right.equalTo(self.contentBgView).offset(-WH(12))
            make.height.equalTo(WH(15))
        })
        supplyLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.imgView.snp.right).offset(WH(8))
            make.top.equalTo(self.titleLabel.snp.bottom).offset(WH(7))
            make.right.equalTo(self.contentBgView).offset(-WH(12))
            make.height.equalTo(WH(12))
        })
        
        //        descTitleLabel.snp.makeConstraints({ (make) in
        //            make.left.equalTo(self.imgView.snp.right).offset(WH(8))
        //            make.top.equalTo(self.supplyLabel.snp.bottom).offset(WH(5))
        //            make.right.equalTo(self.contentBgView).offset(-WH(12))
        //            make.height.equalTo(WH(12))
        //        })
        
        addProductBtn.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.contentBgView).offset(WH(-12))
            make.right.equalTo(self.contentBgView).offset(-WH(9))
            make.width.equalTo(WH(90))
            make.height.equalTo(WH(26))
        })
        
        stepper.snp.makeConstraints({ (make) in
            make.centerY.equalTo( self.addProductBtn.snp.centerY)
            make.right.equalTo(self.contentBgView).offset(-WH(9))
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(90))
        })
        
        priceLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(stepper.snp.bottom)
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
        self.rightImageView.isHidden = true
        self.proTypetipLabel.isHidden = true
        if  let floorProductDtos = model.floorProductDtos, floorProductDtos.isEmpty == false{
            let productmModel:HomeRecommendProductItemModel = floorProductDtos[0]
            //productmModel.productName = "天津同仁堂 脉管复天津同仁堂 脉管复天津同仁堂 脉管复天津同仁堂 脉管复"
            titleLabel.text =  productmModel.productName
            supplyLabel.text = productmModel.factoryName
            
            let contentSize = (productmModel.productName ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(126), height: WH(40)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(15))], context: nil).size
            titleLabel.snp.updateConstraints({ (make) in
                make.height.equalTo(Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1))
            })
            
            if let url = model.jumpInfoMore ,url.count > 0 {
                self.rightImageView.isHidden = false
                self.proTypetipLabel.isHidden = false
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
        proTypeNameLabel.text = model.name ?? ""
        
        
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
    static func  getCellContentHeight(_ model:HomeSecdKillProductModel) -> CGFloat{
        if  let floorProductDtos = model.floorProductDtos, floorProductDtos.isEmpty == false{
            let productmModel:HomeRecommendProductItemModel = floorProductDtos[0]
            let contentSize = (productmModel.productName ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(126), height: WH(40)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(15))], context: nil).size
            return WH(151) + (contentSize.height > WH(40) ? WH(40):contentSize.height) + 1 - WH(15)
        }
        
        return WH(151)
    }
}

