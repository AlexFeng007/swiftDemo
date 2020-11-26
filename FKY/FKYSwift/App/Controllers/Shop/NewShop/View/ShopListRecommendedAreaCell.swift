//
//  ShopListRecommendedAreaCell.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/29.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  推荐专区

import UIKit

class ShopListRecommendedAreaCell: UITableViewCell {

    //MARK: - Property
    
    // 商品图片
    lazy var img: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // 名称
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = t21.font
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        return label
    }()
    
    // 规格
    fileprivate lazy var specLabel: UILabel = {
        let label = UILabel()
        label.font = t22.font
        label.textColor = RGBColor(0x666666)
        label.backgroundColor = .clear
        return label
    }()
    
    // 有效期
    fileprivate lazy var expiryDateLabel: UILabel = {
        let label = UILabel()
        label.font = t22.font
        label.textColor = RGBColor(0x666666)
        label.backgroundColor = .clear
        return label
    }()
    
    // 单位
    fileprivate lazy var unitLabel : UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.backgroundColor = .clear
        return label
    }()
    
    // 价格
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    // 特价...<带中划线>
    fileprivate lazy var tjPrice: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.fontTuple = t11
        
        let line = UIView()
        label.addSubview(line)
        line.snp.makeConstraints({ (make) in
            make.left.right.centerY.equalTo(label)
            make.height.equalTo(WH(1))
        })
        line.backgroundColor = t11.color
        
        return label
    }()
    
    // 满减(标签)
    fileprivate lazy var minusIcon: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = TAG_H/2.0
        label.layer.masksToBounds = true
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.textColor = RGBColor(0xFFFFFF)
        return label
    }()
    
    // 满赠(标签)
    fileprivate lazy var promotionIcon: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = TAG_H/2.0
        label.layer.masksToBounds = true
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.textColor = RGBColor(0xFFFFFF)
        return label
    }()
    
    // 特价(标签)
    fileprivate lazy var promotionPriceIcon: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = TAG_H/2.0
        label.layer.masksToBounds = true
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.textColor = RGBColor(0xFFFFFF)
        return label
    }()
    
    // 限购(标签)
    fileprivate lazy var limitBuy: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = TAG_H/2.0
        label.layer.masksToBounds = true
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.layer.borderWidth = 0.5
        label.textColor = RGBColor(0xFF2D5C)
        label.backgroundColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        return label
    }()
    
    // 优惠券(标签)
    fileprivate lazy var coupon: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = TAG_H/2.0
        label.layer.masksToBounds = true
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.layer.borderWidth = 0.5
        label.textColor = RGBColor(0xFF2D5C)
        label.backgroundColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        return label
    }()
    
    // 返利金(标签)
    fileprivate lazy var profitLb: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = WH(13)/2.0
        label.layer.masksToBounds = true
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.textColor = RGBColor(0xFFFFFF)
        return label
    }()
    
    // 套餐(标签)
    fileprivate lazy var groupIcon: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = WH(13)/2.0
        label.layer.masksToBounds = true
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.textColor = RGBColor(0xFFFFFF)
        return label
    }()
    
    // 生产商图标
    fileprivate lazy var factoryTagLabel: UILabel = {
        let label = UILabel()
        label.font = t71.font
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
        label.layer.cornerRadius = WH(1)
        label.layer.masksToBounds = true
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.layer.borderWidth = WH(0.5)
        label.text = "厂"
        return label
    }()
    
    // 生产商
    fileprivate lazy var factoryLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        return label
    }()
    
    // 供应商图标
    fileprivate lazy var vendorTagLabel: UILabel = {
        let label = UILabel()
        label.font = t71.font
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
        label.layer.cornerRadius = WH(1)
        label.layer.masksToBounds = true
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.layer.borderWidth = WH(0.5)
        label.text = "供"
        return label
    }()
    
    // 供应商
    fileprivate lazy var vendorLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        return label
    }()
    
    // 加车按钮
    fileprivate lazy var cartIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "shop_add_icon"), for: UIControl.State())
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "", sectionPosition: "", sectionName: nil, itemId: "I9999", itemPosition: "", itemName: nil, itemContent: "\(strongSelf.model!.productSupplyId ?? "0")|\(strongSelf.model!.productCode ?? "0")", itemTitle: nil, extendParams: nil, viewController: NewShopListItemVC1())
            
            strongSelf.stepper.addNumWithAuto()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // 状态按钮
    fileprivate lazy var statusBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(btn4.title.color, for: UIControl.State())
        button.titleLabel?.font = UIFont.systemFont(ofSize: WH(12))
        button.layer.masksToBounds = true
        button.layer.cornerRadius = WH(13)
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 1
        button.isHidden = true
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.statusClosure {
                closure()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // 加车器
    fileprivate lazy var stepper: CartStepper = {
        let stepper = CartStepper()
        stepper.oftenBuyPattern(2)
        // 提示框
        stepper.toastBlock = { (str) in
            if let window: UIWindow = UIApplication.shared.windows.last {
                window.rootViewController?.toast(str)
            }
        }
        // 更新加车数量
        stepper.updateProductBlock = { [weak self] (count : Int,typeIndex : Int) in
            if let closure = self?.updateAddProductNum {
                if count > 0 {
                    self?.cartIcon.isHidden = true
                    self?.stepper.isHidden = false
                    // 加车按钮隐藏，显示数量输入控件~!@
                    self!.tjPrice.isHidden = true
                    self!.vendorLabel.snp.updateConstraints { (make) in
                        make.right.equalTo(self!.cartIcon.snp.left).offset(WH(-52))
                    }
                }else if count == 0 && typeIndex == 1 {
                    self?.cartIcon.isHidden = false
                    self?.stepper.isHidden = true
                    // 加车按钮显示，隐藏数量输入控件~!@
                    self!.vendorLabel.snp.updateConstraints { (make) in
                        make.right.equalTo(self!.cartIcon.snp.left).offset(WH(-2))
                    }
                }
                closure(count,typeIndex)
            }
        }
        // 点击+号埋点
        stepper.addBlock = {
        }
        // 购物车数量改变埋点
        stepper.numChangedBlock = {
        }
        return stepper
    }()
    
    fileprivate lazy var promotionSignL: PromotionTagLabel = {
        let sign = PromotionTagLabel()
        sign.isHidden = true
        return sign
    }()
    
    var updateAddProductNum: addCarClosure? //加车更新
    fileprivate var statusClosure: emptyClosure?
    
    fileprivate var callback: ShopListCellActionCallback?
    
    fileprivate var model: ShopListProductItemModel?
    
    //MARK: - init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - setupView
    
    func setupView() {
        self.backgroundColor = bg1
        self.clipsToBounds = true
        
        // 图片
        contentView.addSubview(img)
        img.snp.makeConstraints({ (make) in
            make.left.equalTo(contentView).offset(WH(17))
            make.top.equalTo(contentView).offset(WH(17))
            make.width.equalTo(WH(80))
            make.height.equalTo(WH(80))
        })
        
        contentView.addSubview(promotionSignL)
        promotionSignL.snp.makeConstraints { (make) in
            make.top.equalTo(img.snp.top).offset(WH(4))
            make.left.equalTo(img)
            make.width.equalTo(WH(30))
            make.height.equalTo(WH(15))
        }
        
        // 价格
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentView).offset(-WH(15))
            make.height.equalTo(WH(15))
            make.left.equalTo(self.img.snp.right).offset(WH(12))
        })
        
        // 单位
        contentView.addSubview(unitLabel)
        unitLabel.snp.makeConstraints { (make) in
            make.left.equalTo(priceLabel.snp.right).offset(WH(4))
            make.bottom.equalTo(self.priceLabel)
            make.height.equalTo(WH(14))
        }
        
        // 名称
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView).offset(WH(13))
            make.left.equalTo(self.img.snp.right).offset(WH(12))
            make.right.equalTo(contentView).offset(-WH(12))
            make.height.equalTo(WH(14))
        })
        
        // 规格
        contentView.addSubview(specLabel)
        specLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.titleLabel.snp.left)
            make.height.equalTo(WH(14))
            make.top.equalTo(self.titleLabel.snp.bottom).offset(WH(5))
            make.right.equalTo(contentView).offset(-WH(12))
        })
        
        // 有效期
        contentView.addSubview(expiryDateLabel)
        expiryDateLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.specLabel)
            make.top.equalTo(self.specLabel.snp.bottom).offset(WH(6))
            make.height.equalTo(WH(13))
        })
        
        /*************************************************************/
        
        // 特价(标签)
        contentView.addSubview(promotionPriceIcon)
        promotionPriceIcon.snp.makeConstraints({ (make) in
            make.left.equalTo(self.img.snp.right).offset(WH(12))
            make.top.equalTo(self.expiryDateLabel.snp.bottom).offset(WH(6))
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        })
        
        // 返利金(标签)
        contentView.addSubview(profitLb)
        profitLb.snp.makeConstraints { (make) in
            make.left.equalTo(self.promotionPriceIcon.snp.right).offset(WH(6))
            make.centerY.equalTo(self.promotionPriceIcon.snp.centerY)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        }
        
        // 套餐(标签)
        contentView.addSubview(groupIcon)
        groupIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self.profitLb.snp.right).offset(WH(6))
            make.centerY.equalTo(self.promotionPriceIcon.snp.centerY)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        }
        
        // 满减(标签)
        contentView.addSubview(minusIcon)
        minusIcon.snp.makeConstraints({ (make) in
            make.left.equalTo(self.groupIcon.snp.right).offset(WH(6))
            make.centerY.equalTo(self.promotionPriceIcon.snp.centerY)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        })
        // 满赠(标签)
        contentView.addSubview(promotionIcon)
        promotionIcon.snp.makeConstraints({ (make) in
            make.left.equalTo(self.minusIcon.snp.right).offset(WH(6))
            make.centerY.equalTo(self.promotionPriceIcon.snp.centerY)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        })
        // 优惠券(标签)
        contentView.addSubview(coupon)
        coupon.snp.makeConstraints({ (make) in
            make.left.equalTo(self.promotionIcon.snp.right).offset(WH(6))
            make.centerY.equalTo(self.promotionPriceIcon.snp.centerY)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        })
        // 限购(标签)
        contentView.addSubview(limitBuy)
        limitBuy.snp.makeConstraints({ (make) in
            make.left.equalTo(self.coupon.snp.right).offset(WH(6))
            make.centerY.equalTo(self.promotionPriceIcon.snp.centerY)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        })
        
        /*************************************************************/
        
        // 底部分隔线
        let v = UIView()
        v.backgroundColor = m1
        contentView.addSubview(v)
        v.snp.makeConstraints({ (make) in
            make.right.equalTo(contentView)
            make.left.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.height.equalTo(1)
        })
        
        self.clipsToBounds = true
        
        /*************************************************************/
        
        // 加车btn
        contentView.addSubview(cartIcon)
        cartIcon.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentView.snp.bottom).offset(WH(-15))
            make.right.equalTo(contentView.snp.right).offset(WH(-17))
            make.width.equalTo(WH(30))
            make.height.equalTo(WH(30))
        })
        
        // 特价
        contentView.addSubview(tjPrice)
        tjPrice.snp.makeConstraints({ (make) in
            make.left.equalTo(self.unitLabel.snp.right).offset(WH(10))
            make.bottom.equalTo(self.priceLabel)
        })
        
        // 商品状态btn
        contentView.addSubview(statusBtn)
        statusBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.priceLabel)
            make.left.equalTo(self.img.snp.right).offset(WH(12))
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(62)) // 最小宽度
        })
        
        // 数量输入框
        contentView.addSubview(stepper)
        stepper.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentView.snp.bottom).offset(WH(-15))
            make.right.equalTo(contentView.snp.right).offset(WH(-17))
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(90))
        })
        
        /*************************************************************/
        
        // 供应商图片
        contentView.addSubview(vendorTagLabel)
        vendorTagLabel.snp.makeConstraints( { (make) in
            make.left.equalTo(self.titleLabel.snp.left)
            make.bottom.equalTo(self.priceLabel.snp.top).offset(-WH(14))
            make.width.height.equalTo(WH(11))
        })
        
        // 供应商
        contentView.addSubview(vendorLabel)
        vendorLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.vendorTagLabel.snp.right).offset(WH(4))
            make.centerY.equalTo(self.vendorTagLabel.snp.centerY)
            make.right.equalTo(self.cartIcon.snp.left).offset(WH(-2))
        })
        // 生产商图片
        contentView.addSubview(factoryTagLabel)
        factoryTagLabel.snp.makeConstraints( { (make) in
            make.left.equalTo(self.titleLabel)
            make.bottom.equalTo(self.vendorTagLabel.snp.top).offset(-WH(7))
            make.width.height.equalTo(WH(11))
        })
        
        // 生产商
        contentView.addSubview(factoryLabel)
        factoryLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.factoryTagLabel.snp.right).offset(WH(4))
            make.centerY.equalTo(self.factoryTagLabel.snp.centerY)
            make.right.equalTo(self.snp.right).offset(WH(-17))
        })
    }
    
    
    //MARK: - config
    
    func configCell(_ product: ShopListProductItemModel?) {
        self.model = product
        
        // 所有打标的标签先隐藏
        self.promotionIcon.isHidden = true
        self.promotionPriceIcon.isHidden = true
        self.minusIcon.isHidden = true
        self.limitBuy.isHidden = true
        self.coupon.isHidden = true
        self.profitLb.isHidden = true
        self.groupIcon.isHidden = true
        
        if let model = product {
            if let strProductPicUrl = model.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.img.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
            }
            
            self.titleLabel.text = model.productName
            
            self.specLabel.text = model.productSpec
            
            if let expiryDate = model.expiryDate, expiryDate.count > 0 {
                self.expiryDateLabel.text = "有效期至：\(expiryDate)"
                self.expiryDateLabel.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(13))
                    make.top.equalTo(self.specLabel.snp.bottom).offset(WH(6))
                }
            } else {
                self.expiryDateLabel.text = ""
                self.expiryDateLabel.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(0))
                    make.top.equalTo(self.specLabel.snp.bottom).offset(WH(0))
                }
            }

            if let unit = model.unit {
                self.unitLabel.text = "/\(unit)"
            } else {
                self.unitLabel.text = "/件"
            }
            
            var priceStr: String = ""
            if let price = model.productPrice {
                priceStr = String.init(format: "¥ %.2f", price)
            }
            self.priceLabel.text = priceStr
            
            if let tjPrice = model.specialPrice, tjPrice > 0 {
                self.priceLabel.text = String.init(format: "¥ %.2f", tjPrice)
                self.tjPrice.text = priceStr
            } else {
                self.tjPrice.text = ""
                self.priceLabel.text = priceStr
            }
            
            self.factoryLabel.text = model.factoryName
            self.vendorLabel.text = model.productSupplyName

            // 更新商品状态
            self.stepper.isHidden = true
            self.cartIcon.isHidden = true
            self.statusBtn.isHidden = false
            self.priceLabel.isHidden = true
            self.unitLabel.isHidden = true
            self.tjPrice.isHidden = true
            
            // 无背景色，故字体不可为white
            self.statusBtn.setTitleColor(.gray, for: UIControl.State())
            self.statusBtn.titleLabel?.font = UIFont.systemFont(ofSize: WH(12))
            // 默认无边框
            self.statusBtn.layer.borderColor = UIColor.clear.cgColor

            // 商品状态
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case -1: // 登录后可见
                    self.showPromotionIcon(model.productSign)
                    self.statusBtn.setTitle("登录后可见", for: UIControl.State.normal)
                    self.statusBtn.setTitleColor(RGBColor(0xFF2D5C), for: UIControl.State())
                    break
                case -3:
                    self.statusBtn.setTitle("资质未认证", for: UIControl.State())
                    self.statusBtn.setTitleColor(RGBColor(0xFF2D5C), for: UIControl.State())
                    
                    self.statusClosure = {
                        if let window: UIWindow = UIApplication.shared.windows.last {
                            window.rootViewController?.toast("您可以去电脑上完善资质，认证成功即可购买！")
                        }
                    }
                    break
                default:
                    self.showPromotionIcon(model.productSign)
                    self.cartIcon.isHidden = false
                    self.cartIcon.tag = 0
                    self.statusBtn.isHidden = true
                    self.priceLabel.isHidden = false
                    self.unitLabel.isHidden = false
                    self.tjPrice.isHidden = false
                    break
                }
            }
            else {
                // 为空
                self.showPromotionIcon(model.productSign)
                self.cartIcon.isHidden = false
                self.cartIcon.tag = 0
                self.statusBtn.isHidden = true
                self.priceLabel.isHidden = false
                self.unitLabel.isHidden = false
                self.tjPrice.isHidden = false
            }
            
            //对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(12))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
            
            if !self.cartIcon.isHidden && model.carOfCount > 0 && model.carId != 0 {
                self.cartIcon.isHidden = true
                self.stepper.isHidden = false
            }
            
            // 更新宽度约束
            if self.stepper.isHidden {
                // 加车按钮显示，隐藏数量输入控件~!@
                self.vendorLabel.snp.updateConstraints { (make) in
                    make.right.equalTo(self.cartIcon.snp.left).offset(WH(-2))
                }
            }
            else {
                // 加车按钮隐藏，显示数量输入控件~!@
                self.tjPrice.isHidden = true
                self.vendorLabel.snp.updateConstraints { (make) in
                    make.right.equalTo(self.cartIcon.snp.left).offset(WH(-52))
                }
            }
            
            if self.statusBtn.isHidden == false {
                self.vendorLabel.snp.updateConstraints { (make) in
                    make.right.equalTo(self.cartIcon.snp.left).offset(WH(-52))
                }
            }
            self.layoutIfNeeded()
            
            if let sign = model.brandLable {
                promotionSignL.isHidden = false
                switch sign {
                case 2:
                    promotionSignL.text = "专供"
                case 3:
                    promotionSignL.text = "限量"
                case 4:
                    promotionSignL.text = "独家"
                default:
                    promotionSignL.isHidden = true
                }
            } else {
                promotionSignL.isHidden = true
            }
            self.configStepCount(model)
        }
        
    }
    
    // MARK: - Private
    
    // 促销打标 & 限购打标 & 优惠券打标
    func showPromotionIcon(_ product: ProductSignModel?) {
        if let sign = product {
            if sign.specialOffer! {
                self.promotionPriceIcon.text = "特价"
                self.promotionPriceIcon.isHidden = false
            }
            if sign.rebate! {
                self.profitLb.text = "返利"
                self.profitLb.isHidden = false
            }
            if sign.packages! {
                self.groupIcon.text = "套餐"
                self.groupIcon.isHidden = false
            }
            if sign.fullScale! {
                self.minusIcon.text = "满减"
                self.minusIcon.isHidden = false
            }
            if sign.fullGift! {
                self.promotionIcon.text = "满赠"
                self.promotionIcon.isHidden = false
            }
//            if sign.ticket! {
//                self.coupon.text = "领券"
//                self.coupon.isHidden = false
//            }
            if sign.purchaseLimit! {
                self.limitBuy.text = "限购"
                self.limitBuy.isHidden = false
            }
        }
        
        // 各标签展示优化~!@
        self.optimizeAllTagEffect()
    }

    // 各标签展示优化
    func optimizeAllTagEffect() {
        //七个标签的排序优先级：特价、返利、套餐、满减、满赠、领券、限购
        // 1.特价
        if self.promotionPriceIcon.isHidden {
            // 隐藏
            promotionPriceIcon.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(0))
                make.left.equalTo(self.img.snp.right).offset(j1-WH(6))
            })
        } else {
            // 显示
            promotionPriceIcon.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(30))
                make.left.equalTo(self.img.snp.right).offset(j1)
            })
        }
        
        // 2.返利金
        if self.profitLb.isHidden {
            // 隐藏
            profitLb.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(0))
                make.left.equalTo(self.promotionPriceIcon.snp.right).offset(WH(0))
            })
        } else {
            // 显示
            profitLb.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(30))
                make.left.equalTo(self.promotionPriceIcon.snp.right).offset(WH(6))
            })
        }
        
        // 3. 套餐
        if self.groupIcon.isHidden {
            // 隐藏
            groupIcon.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(0))
                make.left.equalTo(self.profitLb.snp.right).offset(WH(0))
            })
        } else {
            // 显示
            groupIcon.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(30))
                make.left.equalTo(self.profitLb.snp.right).offset(WH(6))
            })
        }
        
        // 4.满减
        if self.minusIcon.isHidden {
            // 隐藏
            minusIcon.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(0))
                make.left.equalTo(self.groupIcon.snp.right).offset(WH(0))
            })
        } else {
            // 显示
            minusIcon.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(30))
                make.left.equalTo(self.groupIcon.snp.right).offset(WH(6))
            })
        }
        
        // 5.满赠
        if self.promotionIcon.isHidden {
            // 隐藏
            promotionIcon.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(0))
                make.left.equalTo(self.minusIcon.snp.right).offset(WH(0))
            })
        } else {
            // 显示
            promotionIcon.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(30))
                make.left.equalTo(self.minusIcon.snp.right).offset(WH(6))
            })
        }
        
        // 6.优惠券
        if self.coupon.isHidden {
            // 隐藏
            coupon.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(0))
                make.left.equalTo(self.promotionIcon.snp.right).offset(WH(0))
            })
        } else {
            // 显示
            coupon.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(30))
                make.left.equalTo(self.promotionIcon.snp.right).offset(WH(6))
            })
        }
        
        // 7.限购
        if self.limitBuy.isHidden {
            // 隐藏
            limitBuy.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(0))
                make.left.equalTo(self.coupon.snp.right).offset(WH(0))
            })
        } else {
            // 显示
            limitBuy.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(30))
                make.left.equalTo(self.coupon.snp.right).offset(WH(6))
            })
        }
        
        self.layoutIfNeeded()
    }
    
    /** 初始化加车计数器
     *  @param baseCount    起订量（门槛）
     *  @param stepCount    最小拆零包装（步长）
     *  @param stockCount   库存（最大可加车数量）
     *  @param quantity     当前展示(已加车)的数量
     *  @param isTJ         是否是特价商品
     *  @param minCount     限购商品最低加车数量
     *  @param limitBuyNum  当周限购数量
     */
    func configStepCount(_ model: ShopListProductItemModel) {
        var baseCount = NSInteger(model.miniPackage!)
        var stepCount = NSInteger(model.miniPackage!)
        let stockCount = NSInteger(model.inventory!)
        
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        
        var minCount = 0
        if let co = model.wholeSaleNum  {
            minCount = co
        }

        var quantityCount = 0
        if  model.carOfCount == 0 {
            if minCount != 0 {
                quantityCount = minCount
            }else{
                quantityCount = NSInteger(model.miniPackage!)
            }
        }else {
            quantityCount = model.carOfCount
        }

        var isTJ : Bool = false
        if let proId = model.promotionId, proId.count > 0 {
            isTJ = true
        }

        var limitBuyNum : NSInteger = 0
        if let surplusNum = model.surplusBuyNum, surplusNum > 0 {
            limitBuyNum = surplusNum
        } else {
            limitBuyNum = 0
        }
        
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: stockCount, limitBuyNum: limitBuyNum, quantity: quantityCount ,and:isTJ, and:minCount)
    }
    
    static func configCellHeight(_ model : ShopListProductItemModel) -> CGFloat {
        var hasTag = false //判断是否有活动
        if let sign = model.productSign {
            if sign.fullGift! || sign.fullScale! || sign.packages! || sign.purchaseLimit! || sign.rebate! || sign.specialOffer! || sign.ticket! {
                hasTag = true
            }
        }
        if hasTag == true {
            if let date = model.expiryDate, date.count > 0 {
                return WH(150+20)
            }
            return WH(150)
        }else{
            if let date = model.expiryDate, date.count > 0 {
                return WH(150)
            }
            return WH(150-20)
        }
    }
}

extension ShopListRecommendedAreaCell: ShopListCellInterface {
    static func calculateHeight(withModel model: ShopListModelInterface, tableView: UITableView, identifier: String, indexPath: IndexPath) -> CGFloat {
        if let m = model as? ShopListProductItemModel {
            return configCellHeight(m)
        }
        return 0
    }
    
    func bindOperation(_ callback: @escaping ShopListCellActionCallback) {
        self.callback = callback
    }
    
    func bindModel(_ model: ShopListModelInterface) {
        if let m = model as? ShopListProductItemModel {
            configCell(m)
        }
        else {
            configCell(nil)
        }
    }
}
