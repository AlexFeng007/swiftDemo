//
//  PDSameProductRecommendCell.swift
//  FKY
//
//  Created by 乔羽 on 2019/1/8.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

let TAG_H = WH(15) //标签高

class PDSameProductRecommendCell: UITableViewCell {
    
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
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = t22.font
        label.textColor = RGBColor(0x666666)
        label.backgroundColor = .clear
        return label
    }()
    
    //七个标签的排序优先级：特价、返利、套餐、满减、满赠、领券、限购
    // 满减(标签)
    fileprivate lazy var minusIcon: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = TAG_H/2.0
        label.layer.masksToBounds = true
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.textColor = RGBColor(0xFFFFFF)
        label.text = "满减"
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
        label.text = "满赠"
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
        label.text = "特价"
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
        label.text = "限购"
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
        label.text = "领券"
        return label
    }()
    
    // 返利金(标签)
    fileprivate lazy var profitLb: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = TAG_H/2.0
        label.layer.masksToBounds = true
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.textColor = RGBColor(0xFFFFFF)
        label.text = "返利"
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
        label.text = "套餐"
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
        button.setImage(UIImage(named: "icon_jia_new"), for: UIControl.State())
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.stepper.addNumWithAuto()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // 加车器
    fileprivate lazy var stepper: CartStepper = {
        let stepper = CartStepper()
        stepper.oftenBuyPattern(1)
        // 提示框
        stepper.toastBlock = { (str) in
            if let window: UIWindow = UIApplication.shared.windows.last {
                window.rootViewController?.toast(str)
            }
        }
        // 更新加车数量
        stepper.updateProductBlock = { [weak self] (count : Int,typeIndex : Int) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.updateAddProductNum {
                if count > 0 {
                    strongSelf.cartIcon.isHidden = true
                    strongSelf.stepper.isHidden = false
                }else if count == 0 && typeIndex == 1 {
                    strongSelf.cartIcon.isHidden = false
                    strongSelf.stepper.isHidden = true
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
    
    var updateAddProductNum: addCarClosure? //修改加车数量
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - UI
    
    fileprivate func setupView() {
        self.backgroundColor = bg1
        self.clipsToBounds = true
        
        // 顶部分隔线
        let v = UIView()
        v.backgroundColor = m1
        contentView.addSubview(v)
        v.snp.makeConstraints({ (make) in
            make.right.equalTo(contentView)
            make.left.equalTo(contentView)
            make.top.equalTo(contentView)
            make.height.equalTo(1)
        })
        
        // 图片
        contentView.addSubview(img)
        img.snp.makeConstraints({ (make) in
            make.left.equalTo(contentView).offset(WH(17))
            make.top.equalTo(contentView).offset(WH(20))
            make.width.equalTo(WH(78))
            make.height.equalTo(WH(78))
        })
        
        // 名称
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView).offset(WH(20))
            make.left.equalTo(self.img.snp.right).offset(WH(12))
            make.right.equalTo(contentView).offset(-WH(20))
            make.height.equalTo(WH(15))
        })
        
        // 规格
        contentView.addSubview(specLabel)
        specLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.titleLabel.snp.left)
            make.height.equalTo(WH(14))
            make.top.equalTo(self.titleLabel.snp.bottom).offset(WH(5))
            make.right.equalTo(contentView).offset(-WH(20))
        })
        
        // 有效期...<不能固定高度>...<无返回值时需隐藏>
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.titleLabel.snp.left)
            make.top.equalTo(self.specLabel.snp.bottom).offset(WH(4))
            make.right.equalTo(self.snp.right).offset(-j1)
            // make.height.equalTo(WH(10))
        })
        /*************************************************************/
        
        // 特价
        contentView.addSubview(promotionPriceIcon)
        promotionPriceIcon.snp.makeConstraints({ (make) in
            make.left.equalTo(self.img.snp.right).offset(WH(12))
            make.top.equalTo(self.timeLabel.snp.bottom).offset(WH(7))
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        })
        // 返利金
        contentView.addSubview(profitLb)
        profitLb.snp.makeConstraints { (make) in
            make.left.equalTo(self.promotionPriceIcon.snp.right).offset(WH(6))
            make.centerY.equalTo(self.promotionPriceIcon.snp.centerY)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        }
        
        // 套餐
        contentView.addSubview(groupIcon)
        groupIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self.profitLb.snp.right).offset(WH(6))
            make.centerY.equalTo(self.promotionPriceIcon.snp.centerY)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        }
        
        // 满减
        contentView.addSubview(minusIcon)
        minusIcon.snp.makeConstraints({ (make) in
            make.left.equalTo(self.groupIcon.snp.right).offset(WH(6))
            make.centerY.equalTo(self.promotionPriceIcon.snp.centerY)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        })
        // 满赠
        contentView.addSubview(promotionIcon)
        promotionIcon.snp.makeConstraints({ (make) in
            make.left.equalTo(self.minusIcon.snp.right).offset(WH(6))
            make.centerY.equalTo(self.promotionPriceIcon.snp.centerY)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        })
        // 优惠券
        contentView.addSubview(coupon)
        coupon.snp.makeConstraints({ (make) in
            make.left.equalTo(self.promotionIcon.snp.right).offset(WH(6))
            make.centerY.equalTo(self.promotionPriceIcon.snp.centerY)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        })
        // 限购
        contentView.addSubview(limitBuy)
        limitBuy.snp.makeConstraints({ (make) in
            make.left.equalTo(self.coupon.snp.right).offset(WH(6))
            make.centerY.equalTo(self.promotionPriceIcon.snp.centerY)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        })
        
        /*************************************************************/
        
        // 加车btn
        contentView.addSubview(cartIcon)
        cartIcon.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentView.snp.bottom).offset(WH(-20))
            make.right.equalTo(contentView.snp.right).offset(WH(-17))
            make.width.equalTo(WH(26))
            make.height.equalTo(WH(26))
        })
        
        // 数量输入框
        contentView.addSubview(stepper)
        stepper.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentView.snp.bottom).offset(WH(-20))
            make.right.equalTo(contentView.snp.right).offset(WH(-17))
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(90))
        })
        // 价格
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentView).offset(-WH(18))
            make.height.equalTo(WH(15))
            make.left.equalTo(self.img.snp.right).offset(WH(13))
            make.right.equalTo(self.stepper.snp.left).offset(WH(-13))
        })
        /*************************************************************/
        
        // 供应商图片
        contentView.addSubview(vendorTagLabel)
        vendorTagLabel.snp.makeConstraints( { (make) in
            make.left.equalTo(self.titleLabel.snp.left)
            make.bottom.equalTo(self.priceLabel.snp.top).offset(-WH(11))
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
            make.bottom.equalTo(self.vendorTagLabel.snp.top).offset(-WH(6))
            make.width.height.equalTo(WH(11))
        })
        
        // 生产商
        contentView.addSubview(factoryLabel)
        factoryLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.factoryTagLabel.snp.right).offset(WH(4))
            make.centerY.equalTo(self.factoryTagLabel.snp.centerY)
            make.right.equalTo(contentView.snp.right).offset(WH(-20))
        })
    }
}
//MARK:数据初始化
extension PDSameProductRecommendCell {
    func configCell(_ model : FKYSameProductModel?) {
        if let getModel = model {
            self.img.image = UIImage.init(named: "image_default_img")
            if let strProductPicUrl = getModel.productMainPic, let urlString = (strProductPicUrl as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue) {
                self.img.sd_setImage(with: URL(string: urlString) , placeholderImage: UIImage.init(named: "image_default_img"))
            }
            self.priceLabel.text = ""
            if let tjstr = getModel.showPrice ,tjstr > 0 {
                //显示价格（后台进行了是否特价判断）
                self.priceLabel.text = String.init(format: "¥ %.2f/%@",tjstr,getModel.unit ?? "")
            }
            //对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                if let unitStr =  getModel.unit {
                    let yRange = (priceStr as NSString).range(of:"/"+unitStr)
                    priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(12)), NSAttributedString.Key.foregroundColor:RGBColor(0x999999)], range: yRange)
                }
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
            
            titleLabel.text = getModel.productName
            specLabel.text = getModel.spec
            vendorLabel.text = getModel.sellerName
            factoryLabel.text = getModel.factoryName
            self.stepper.isHidden = true
            self.cartIcon.isHidden = false
            if !self.cartIcon.isHidden && getModel.carOfCount > 0 && getModel.carId != 0 {
                self.cartIcon.isHidden = true
                self.stepper.isHidden = false
            }
            // 有效期
            if let time = getModel.deadLine, time.isEmpty == false {
                self.timeLabel.text = "有效期至：" + time
                timeLabel.snp.updateConstraints({ (make) in
                    make.top.equalTo(self.specLabel.snp.bottom).offset(WH(4))
                    //make.height.equalTo(WH(10))
                })
            }else {
                self.timeLabel.text = ""
                timeLabel.snp.updateConstraints({ (make) in
                    make.top.equalTo(self.specLabel.snp.bottom).offset(WH(0))
                    //make.height.equalTo(WH(0))
                })
            }
            self.showPromotionIcon(getModel)
            self.configStepCount(getModel)
        }
    }
    //初始化加车计数器
    func configStepCount(_ model:FKYSameProductModel) {
        var num: NSInteger = 0
        if let count = model.stockCount {
            num = count
        }else{
            num = 0
        }
        //限购的数量
        var exceedLimitBuyNum : NSInteger = 0
        if  model.surplusBuyNum != nil && model.surplusBuyNum! > 0 {
            exceedLimitBuyNum = model.surplusBuyNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        //计算特价
        var istj : Bool = false
        var quantityCount = 0
        var minCount = 0
        if let num = model.wholeSaleNum , num > 0 {
            minCount = num
            istj = true
        }
        
        //
        var baseCount = model.stepCount ?? 1
        var stepCount = model.stepCount ?? 1
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        
        if  model.carOfCount == 0 {
            if minCount != 0 {
                quantityCount = minCount
            }else{
                quantityCount = stepCount
            }
        }else {
            quantityCount = model.carOfCount
        }
        
        //
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
    func showPromotionIcon(_ product: FKYSameProductModel?) {
        // 先默认所有标签均隐藏
        self.promotionIcon.isHidden = true
        self.promotionPriceIcon.isHidden = true
        self.minusIcon.isHidden = true
        self.limitBuy.isHidden = true
        self.coupon.isHidden = true
        self.profitLb.isHidden = true
        self.groupIcon.isHidden = true
        
        if let model = product {
            // 特价
            if model.specialOffer == 1 {
                self.promotionPriceIcon.isHidden = false
            }
            // 返利金
            if let rb = model.isRebate, rb == 1 {
                self.profitLb.isHidden = false
            }
            // 套餐
            if model.packages == 1 {
                self.groupIcon.isHidden = false
            }
            // 满减
            if model.fullScale  == 1 {
                self.minusIcon.isHidden = false
            }
            // 满赠
            if model.fullGift == 1 {
                self.promotionIcon.isHidden = false
            }
            // 优惠券
            if let cp = model.isCoupon, cp == 1 {
                self.coupon.isHidden = false
            }
            // 限购
            if let li = model.limitBuy, li == 1 {
                self.limitBuy.isHidden = false
            }
            // 各标签展示优化~!@
            self.optimizeAllTagEffect()
        }
    }
    
    // 各标签展示优化
    func optimizeAllTagEffect() {
        // 1.特价
        if self.promotionPriceIcon.isHidden {
            // 隐藏
            promotionPriceIcon.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(0))
                make.left.equalTo(self.img.snp.right).offset(WH(12)-WH(6))
            })
        } else {
            // 显示
            promotionPriceIcon.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(30))
                make.left.equalTo(self.img.snp.right).offset(WH(12))
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
    static func configCellHeight(_ model : FKYSameProductModel) -> CGFloat {
        var cellH = WH(140)
        if let time = model.deadLine, time.isEmpty == false {
            cellH =  cellH + WH(14)
        }
        //七个标签的排序优先级：特价、返利、套餐、满减、满赠、领券、限购
        var hasTag = false //判断是否有活动
        // 特价
        if model.specialOffer == 1 {
            hasTag = true
        }
        // 返利金
        if let rb = model.isRebate, rb == 1 {
            hasTag = true
        }
        // 套餐
        if model.packages == 1 {
            hasTag = true
        }
        // 满减
        if model.fullScale  == 1 {
            hasTag = true
        }
        // 满赠
        if model.fullGift == 1 {
            hasTag = true
        }
        // 优惠券
        if let cp = model.isCoupon, cp == 1 {
            hasTag = true
        }
        // 限购
        if let li = model.limitBuy, li == 1 {
            hasTag = true
        }
        if hasTag == true {
            cellH =  cellH + WH(25)
        }
        
        return cellH
    }
}
