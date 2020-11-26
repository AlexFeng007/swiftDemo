//
//  FKYShoppingCarProductTableViewCell.swift
//  FKY
//
//  Created by 曾维灿 on 2019/12/2.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYShoppingCarProductTableViewCell: UITableViewCell {
    var selectItemBlock: emptyClosure?//商品勾选
    var updateAddProductNum: addCarClosure? //加车更新
    var toastAddProductNum : SingleStringClosure? //加车提示
    var cellHeight:CGFloat = 0
    var cellModel:CartCellProductProtocol = CartCellProductProtocol(){
        didSet{
            showProductInfo()
        }
    }
    ///容器视图
    lazy var containerView:UIView = UIView()
    
    ///边框
    let borderLayer = CAShapeLayer()
    
    //选择区域
    fileprivate lazy var imageTapContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let tapGestureMsg = UITapGestureRecognizer()
        tapGestureMsg.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.selectItemBlock {
                closure()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGestureMsg)
        return view
    }()
    
    //全部按钮
    fileprivate var statusImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    ///商品图片
    fileprivate lazy var productImageView:UIImageView = {
        var imageView = UIImageView()
        
        return imageView
    }()
    
    ///异常商品图标
    fileprivate lazy var anomalyImageView:UIImageView = {
        let imageView = UIImageView()
        //        imageView.image = UIImage(named:"no_item_icon")
        imageView.isHidden = false
        return imageView
    }()
    
    ///商品名 自营标签
    fileprivate lazy var productName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        return label
    }()
    
    ///效期视图
    fileprivate lazy var deadlineView:UIView = {
        let view = UIView()
        return view
    }()
    ///厂家名
    fileprivate lazy var factoryLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t16
        label.font = UIFont.systemFont(ofSize: WH(12))
        return label
    }()
    
    /// 有效期名字
    fileprivate lazy var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = t11.font
        label.textColor = RGBColor(0x666666)
        label.backgroundColor = .clear
        label.text = "效期"
        label.sizeToFit()
        return label
    }()
    
    /// 有效期
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    ///限购视图
    fileprivate lazy var limitInfoView:CartLimitInfoView = {
        let view = CartLimitInfoView()
        return view
    }()
    
    //标签
    fileprivate lazy var promotionTagView:CartPromotionTagView = {
        let view = CartPromotionTagView()
        return view
    }()
    
    ///价格视图
    fileprivate lazy var priceInfoView:UIView = {
        let view = UIView()
        return view
    }()
    
    ///分割线
    fileprivate lazy var lineView:UIView = {
        let marginView = UIView()
        marginView.backgroundColor = RGBColor(0xE5E5E5)
        // marginView.backgroundColor = .blue
        
        return marginView
    }()
    
    ///商品单价
    fileprivate lazy var exclusivePriceLabel:UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x333333)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: WH(10.0))
        return label
    }()
    
    ///商品单价
    fileprivate lazy var productPrice:UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: WH(14.0))
        return label
    }()
    
    ///单个商品小计
    fileprivate lazy var subTotalProductPrice:UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x333333)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: WH(12.0))
        return label
    }()
    
    ///商品数量
    lazy var productNumberLB:UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: WH(14.0))
        lb.textColor = RGBColor(0x666666)
        lb.textAlignment = .center
        return lb
    }()
    
    /// 加车器
    lazy var stepper: CartStepper = {
        let stepper = CartStepper()
        stepper.cartUiUpdatePattern()
        //        stepper.bgView.backgroundColor =  RGBColor(0xffffff)
        stepper.bgView.backgroundColor =  UIColor.clear
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override  init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension FKYShoppingCarProductTableViewCell{
    func  setupView(){
        self.backgroundColor = .white
        self.contentView.addSubview(containerView)
        
        containerView.addSubview(imageTapContainer)
        imageTapContainer.addSubview(statusImage)
        
        containerView.addSubview(productImageView)
        productImageView.addSubview(anomalyImageView)
        containerView.addSubview(productName)
        containerView.addSubview(factoryLabel)
        
        containerView.addSubview(deadlineView)
        
        
        deadlineView.addSubview(timeTitleLabel)
        deadlineView.addSubview(timeLabel)
        
        containerView.addSubview(limitInfoView)
        containerView.addSubview(priceInfoView)
        
        priceInfoView.addSubview(productPrice)
        priceInfoView.addSubview(subTotalProductPrice)
        priceInfoView.addSubview(exclusivePriceLabel)
        containerView.addSubview(promotionTagView)
        
        containerView.addSubview(productNumberLB)
        containerView.addSubview(stepper)
        containerView.addSubview(lineView)
        
        
        imageTapContainer.snp.makeConstraints({ (make) in
            make.left.equalTo(containerView)
            make.top.equalTo(containerView).offset(WH(35.5))
            make.width.height.equalTo(WH(41))
        })
        
        statusImage.snp.makeConstraints({ (make) in
            make.center.equalTo(imageTapContainer)
            make.width.height.equalTo(WH(26.0))
        })
        
        productImageView.snp.makeConstraints({ (make) in
            make.top.equalTo(containerView).offset(WH(16))
            make.left.equalTo(containerView).offset(WH(41))
            make.height.width.equalTo(WH(80))
        })
        
        anomalyImageView.snp.makeConstraints({ (make) in
            make.edges.equalTo(productImageView)
        })
        
        productName.snp.makeConstraints({ (make) in
            make.left.equalTo(productImageView.snp.right).offset(WH(6))
            make.right.equalTo(containerView).offset(WH(-8))
            make.top.equalTo(containerView).offset(WH(16))
            make.height.equalTo(0)
        })
        
        factoryLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(productImageView.snp.right).offset(WH(6))
            make.right.equalTo(containerView).offset(WH(-8))
            make.top.equalTo(productName.snp.bottom).offset(WH(8))
            make.height.equalTo(WH(12))
        })
        
        deadlineView.snp.makeConstraints({ (make) in
            make.left.equalTo(productImageView.snp.right).offset(WH(6))
            make.right.equalTo(containerView).offset(WH(-8))
            make.top.equalTo(factoryLabel.snp.bottom).offset(WH(8))
            make.height.equalTo(0)
        })
        
        timeTitleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(deadlineView)
            make.centerY.equalTo(deadlineView)
            make.height.equalTo(WH(12))
        })
        
        timeLabel.snp.makeConstraints({ (make) in
            // make.right.equalTo(deadlineView)
            make.left.equalTo(timeTitleLabel.snp.right).offset(WH(5))
            make.centerY.equalTo(deadlineView)
            make.height.equalTo(WH(12))
        })
        
        limitInfoView.snp.makeConstraints({ (make) in
            make.left.equalTo(productImageView.snp.right).offset(WH(6))
            make.right.equalTo(containerView).offset(WH(-8))
            make.top.equalTo(deadlineView.snp.bottom).offset(WH(8))
            make.height.equalTo(0)
        })
        
        //加车器
        self.stepper.snp.makeConstraints { (make) in
            make.right.equalTo(self.containerView).offset(WH(-8.0))
            make.bottom.equalTo(self.containerView).offset(WH(-16.0))
            make.width.equalTo(WH(140.0))
            make.height.equalTo(WH(30.0))
        }
        
        priceInfoView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.stepper.snp.bottom)
            make.right.equalTo(self.stepper.snp.left)
            //  make.left.equalTo(productImageView.snp.right).offset(WH(6))
            make.height.equalTo(WH(30.0))
            make.width.equalTo((SCREEN_WIDTH - WH(283)))
        }
        
        exclusivePriceLabel.snp.makeConstraints { (make) in
            make.top.right.equalTo(priceInfoView)
            make.width.equalTo((SCREEN_WIDTH - WH(283)))
            make.height.equalTo(0)
        }
        
        productPrice.snp.makeConstraints { (make) in
            make.right.equalTo(priceInfoView)
            make.top.equalTo(exclusivePriceLabel.snp.bottom).offset(WH(3))
            make.width.equalTo((SCREEN_WIDTH - WH(283)))
        }
        
        subTotalProductPrice.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(priceInfoView)
        }
        
        promotionTagView.snp.makeConstraints { (make) in
            make.top.equalTo(priceInfoView.snp.top)
            make.right.equalTo(self.productImageView.snp.right)
            make.height.equalTo(WH(30.0))
            make.left.equalTo(containerView)
        }
        
        productNumberLB.snp.makeConstraints { (make) in
            make.right.equalTo(self.containerView).offset(WH(-10.0))
            make.bottom.equalTo(self.containerView).offset(WH(-22.0))
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self.containerView).offset(0.5)
            make.right.equalTo(self.containerView).offset(-0.5)
            make.bottom.equalTo(self.containerView).offset(0)
            make.height.equalTo(0.5)
        }
    }
    
    
    func showProductInfo(){
        let productModel = self.cellModel.productModel
        if productModel == nil{
            return
        }
        
        if let strProductPicUrl = productModel!.productImageUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }else{
            self.productImageView.image = UIImage.init(named: "image_default_img")
        }
        //商品名称
        let attributedString = FKYShoppingCarProductTableViewCell.getComboMainProductAttrStr(self.cellModel.productModel?.productFullName ?? "", self.cellModel.productModel?.mainProductFlag ?? false)
        let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(145), height: WH(35)), options: .usesLineFragmentOrigin, context: nil).size
        self.productName.attributedText = attributedString
        productName.snp.updateConstraints({ (make) in
            make.height.equalTo(contentSize.height)
        })
        
        //生产厂家
        self.factoryLabel.text = self.cellModel.productModel?.manufactures ?? ""
        if let manufactures = productModel!.manufactures,manufactures.isEmpty == false{
            self.factoryLabel.text = manufactures
            factoryLabel.snp.updateConstraints({ (make) in
                make.top.equalTo(productName.snp.bottom).offset(WH(8))
                make.height.equalTo(WH(12))
            })
        }else{
            factoryLabel.snp.updateConstraints({ (make) in
                make.top.equalTo(productName.snp.bottom).offset(WH(0))
                make.height.equalTo(WH(0))
            })
        }
        
        //效期
        if let deadLine = productModel!.deadLine,deadLine.isEmpty == false{
            timeTitleLabel.text = "效期"
            timeLabel.text = deadLine
            self.timeTitleLabel.isHidden = false
            self.deadlineView.isHidden = false
            deadlineView.snp.updateConstraints({ (make) in
                make.top.equalTo(factoryLabel.snp.bottom).offset(WH(8))
                make.height.equalTo(WH(12))
            })
        }else{
            self.timeTitleLabel.isHidden = true
            self.deadlineView.isHidden = true
            deadlineView.snp.updateConstraints({ (make) in
                make.top.equalTo(factoryLabel.snp.bottom).offset(WH(0))
                make.height.equalTo(WH(0))
            })
        }
        ///商品单价
        self.productPrice.text = String(format: "￥%.2f", self.cellModel.productModel?.productPrice?.doubleValue ?? 0.00)
        //当前商品小计
        self.subTotalProductPrice.text = String(format: "小计￥%.2f", Double(truncating: self.cellModel.productModel?.productPrice! ?? 0.0) * Double(self.cellModel.productModel?.productCount! ?? 0))
        
        let priceContentSize = String(format: "小计￥%.2f", Double(truncating: self.cellModel.productModel?.productPrice! ?? 0.0) * Double(self.cellModel.productModel?.productCount! ?? 0)).boundingRect(with: CGSize(width: SCREEN_WIDTH, height: WH(15)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: WH(12))], context: nil).size
        //判断是否享受了专享价 价格区域高度
        var priceInfoViewHeight = WH(30.0)
        let isShowExclusivePromotion = productModel!.getExclusivePromotionFlag(["2001"])
        if isShowExclusivePromotion{
            //享受了专享价
            promotionTagView.snp.updateConstraints { (make) in
                make.top.equalTo(priceInfoView.snp.top).offset(WH(13))
            }
            self.exclusivePriceLabel.isHidden = false
            self.exclusivePriceLabel.text = String(format: "￥%.2f", self.cellModel.productModel?.originalPrice?.doubleValue ?? 0.00)
            priceInfoViewHeight = WH(43.0)
        }else{
            self.exclusivePriceLabel.isHidden = true
            promotionTagView.snp.updateConstraints { (make) in
                make.top.equalTo(priceInfoView.snp.top)
            }
            priceInfoViewHeight = WH(30.0)
        }
        if self.cellModel.productType == .CartCellProductTypeFixTaoCan{
            //固定套餐尽量把小计显示完全
            priceInfoView.snp.remakeConstraints { (make) in
                make.left.equalTo(productImageView.snp.right).offset(WH(6))
                make.right.equalTo(self.stepper.snp.right)
                make.bottom.equalTo(self.stepper.snp.bottom)
                make.height.equalTo(priceInfoViewHeight)
            }
            if isShowExclusivePromotion {
                productPrice.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(priceInfoView)
                    make.top.equalTo(exclusivePriceLabel.snp.bottom).offset(WH(3))
                }
                exclusivePriceLabel.snp.remakeConstraints { (make) in
                    make.left.top.right.equalTo(priceInfoView)
                    make.height.equalTo(WH(10))
                }
            }else{
                productPrice.snp.remakeConstraints { (make) in
                    make.top.left.right.equalTo(priceInfoView)
                }
                exclusivePriceLabel.snp.remakeConstraints { (make) in
                    make.left.top.right.equalTo(priceInfoView)
                    make.height.equalTo(0)
                }
            }
        }else{
            priceInfoView.snp.remakeConstraints { (make) in
                make.bottom.equalTo(self.stepper.snp.bottom)
                make.height.equalTo(priceInfoViewHeight)
                make.right.equalTo(self.stepper.snp.left)
                make.width.equalTo((priceContentSize.width > (SCREEN_WIDTH - WH(283))) ? priceContentSize.width:(SCREEN_WIDTH - WH(283)))
            }
            if isShowExclusivePromotion {
                productPrice.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(priceInfoView)
                    make.top.equalTo(exclusivePriceLabel.snp.bottom).offset(WH(3))
                }
                exclusivePriceLabel.snp.remakeConstraints { (make) in
                    make.left.top.right.equalTo(priceInfoView)
                    make.height.equalTo(WH(10))
                }
            }else{
                productPrice.snp.remakeConstraints { (make) in
                    make.top.right.equalTo(priceInfoView)
                    make.width.equalTo((SCREEN_WIDTH - WH(283)))
                }
                exclusivePriceLabel.snp.remakeConstraints { (make) in
                    make.left.top.right.equalTo(priceInfoView)
                    make.height.equalTo(WH(0))
                }
            }
        }
        
        promotionTagView.configTagView(productModel!)
        
        //商品选中状态
        self.imageTapContainer.isUserInteractionEnabled = true
        if productModel?.checkStatus == true{
            self.statusImage.image = UIImage.init(named: "img_pd_select_select")
        }else{
            self.statusImage.image = UIImage.init(named: "img_pd_select_normal")
        }
        if productModel?.editStatus != 0 {
            if productModel?.editStatus == 1 {
                self.statusImage.image = UIImage.init(named: "img_pd_select_normal")
            }
            else {
                self.statusImage.image = UIImage.init(named: "img_pd_select_select")
            }
        }
        // 如果在编辑状态 选中按钮按钮正常显示
        if productModel?.productStatus != 0 && productModel?.editStatus == 0{
            //产品失效
            self.statusImage.image = UIImage.init(named: "img_pd_select_none")
            self.imageTapContainer.isUserInteractionEnabled = false
        }
        // 初始化加车器
        var istj = false
        var minCount = 0
        if productModel?.promotionTJ != nil{
            istj = true
            minCount =  productModel?.saleStartNum ?? 0
        }
        if let productLimitBuy = productModel?.productLimitBuy,productLimitBuy.limitTextMsg?.isEmpty == false{
            // 限购周期限制类型必须为2or3,且限购数必须大于0
            self.stepper.configStepperInfoBaseCount(productModel?.saleStartNum ?? 0, stepCount: productModel?.minPackingNum ?? 0, stockCount: productModel?.productMaxNum ?? 0, limitBuyNum: productModel?.productMaxNum ?? 0, quantity: productModel?.productCount ?? 0, and: istj, and: minCount, and: productModel?.outMaxReason ?? "", and: productModel?.lessMinReson ?? "")
        }else{
            // 不显示限购
            self.stepper.configStepperInfoBaseCount(productModel?.saleStartNum ?? 0, stepCount: productModel?.minPackingNum ?? 0, stockCount: productModel?.productMaxNum ?? 0, limitBuyNum: productModel?.productMaxNum ?? 0, quantity: productModel?.productCount ?? 0, and: istj, and: minCount, and: productModel?.outMaxReason ?? "", and: productModel?.lessMinReson ?? "")
        }
        
        
        var tempTagTextList = [String]()
        if !(self.cellModel.productModel?.canUseCouponFlag ?? true) {
            tempTagTextList.append("不可用券")
        }
        
        if (self.cellModel.productModel?.reachLimitNum ?? false) {
            tempTagTextList.append("已达特价限购数量")
        }
        
        if (self.cellModel.productModel?.promotionVip?.reachVipLimitNum ?? false){
            tempTagTextList.append("已达会员价限购数量")
        }
        //搭配套餐 主品每次限购标
        if let limitNum = self.cellModel.productModel?.comboProductLimitNum,limitNum > 0{
            tempTagTextList.append("每次限购\(limitNum)\(self.cellModel.productModel?.unit ?? "个")")
        }
        
        if (productModel?.isHasSomeKindPromotion(["2001"]) ?? false){
            //有专享价
            if let joinDesc = self.cellModel.productModel?.getExclusivePromotionDesc(["2001"]) ,joinDesc.isEmpty == false{
                tempTagTextList.append(joinDesc)
            }
        }
        //周限购标签
        if ([2].contains(self.cellModel.productModel?.productLimitBuy?.cycleType) ){
            tempTagTextList.append(self.cellModel.productModel?.productLimitBuy?.limitTextMsg ?? "")
        }
        
        if tempTagTextList.isEmpty == false{
            limitInfoView.snp.updateConstraints({ (make) in
                make.top.equalTo(deadlineView.snp.bottom).offset(WH(8))
                make.height.equalTo(WH(18))
            })
        }else{
            limitInfoView.snp.updateConstraints({ (make) in
                make.top.equalTo(deadlineView.snp.bottom).offset(WH(0))
                make.height.equalTo(0)
            })
        }
        limitInfoView.configTagView(productModel!)
        
        self.productNumberLB.text = "x\(productModel?.productCount ?? 0)"
        
        if self.cellModel.productType == .CartCellProductTypeNormal {
            self.stepper.isHidden = false
            self.statusImage.isHidden = false
            self.productNumberLB.isHidden = true
        }else if self.cellModel.productType == .CartCellProductTypeFixTaoCan {
            self.stepper.isHidden = true
            self.statusImage.isHidden = true
            self.productNumberLB.isHidden = false
        }else if self.cellModel.productType == .CartCellProductTypeTaoCan {
            self.stepper.isHidden = false
            self.statusImage.isHidden = true
            self.productNumberLB.isHidden = true
        }else if self.cellModel.productType == .CartCellProductTypePromotion {
            self.stepper.isHidden = false
            self.statusImage.isHidden = false
            self.productNumberLB.isHidden = true
        }
        
        self.limitInfoView.isHidden = true
        self.promotionTagView.isHidden = true
        self.anomalyImageView.isHidden = true
        self.subTotalProductPrice.isHidden = true
        self.stepper.isHidden = true
        self.productPrice.isHidden = false
        
        if productModel!.productStatus == 0 {
            //正常
            self.limitInfoView.isHidden = false
            self.promotionTagView.isHidden = false
            self.subTotalProductPrice.isHidden = false
            if self.cellModel.productType != .CartCellProductTypeFixTaoCan {
                self.stepper.isHidden = false
            }
            self.productNormal()
        }else if productModel!.productStatus == -5{
            //缺货
            self.anomalyImageView.isHidden = false
            self.anomalyImageView.image = UIImage.init(named: "no_item_icon")
            self.soldOutAndUNShelevState()
            if self.cellModel.productType == .CartCellProductTypeFixTaoCan{
                //固定套餐尽量把小计显示完全
                productPrice.snp.remakeConstraints { (make) in
                    make.bottom.left.right.equalTo(priceInfoView)
                }
            }else{
                productPrice.snp.remakeConstraints { (make) in
                    make.bottom.right.equalTo(priceInfoView)
                    make.width.equalTo((SCREEN_WIDTH - WH(283)))
                }
            }
            
        }else if productModel!.productStatus == -7{
            //已下架
            self.anomalyImageView.isHidden = false
            self.productPrice.isHidden = true
            self.anomalyImageView.image = UIImage.init(named: "xiajia_icon")
            self.soldOutAndUNShelevState()
        }else {
            //不可购买
            self.anomalyImageView.isHidden = false
            self.productPrice.isHidden = true
            self.anomalyImageView.image = UIImage.init(named: "cannot_bug_icon")
            self.canNotBuyState()
        }
        
        self.containerView.hd_width = SCREEN_WIDTH - WH(5*2)
        self.containerView.hd_x = WH(5.0)
        self.containerView.hd_y = 0
        self.containerView.hd_height = FKYShoppingCarProductTableViewCell.getCellContentHeight(productModel!)
        
        //添加分割线
        if self.cellModel.lastObject {
            lineView.isHidden = true
        }else{
            lineView.isHidden = false
        }
        
        //添加圆角和边框还有背景色
        var corner:UIRectCorner = UIRectCorner()
        //左上-右上-右下-左下 顺时针
        var roundCorner:(CGFloat,CGFloat,CGFloat,CGFloat) = (0,0,0,0)
        var border:(Bool,Bool,Bool,Bool) = (false,true,false,true)
        var borderColor = RGBColor(0xFF2D5C)
        var viewBackgroundColor = RGBColor(0xFFFAFB)
        
        if self.cellModel.productType == .CartCellProductTypeNormal {
            borderColor = RGBColor(0xE5E5E5)
            viewBackgroundColor = UIColor.white
        }
        
        if self.cellModel.firstObject {
            corner = [.topLeft,.topRight]
            roundCorner = (WH(4),WH(4),0,0)
            border.0 = true
        }
        
        if self.cellModel.lastObject {
            corner = [.bottomLeft,.bottomRight]
            roundCorner.2 = WH(4)
            roundCorner.3 = WH(4)
            border.2 = true
        }
        
        if self.cellModel.firstObject && self.cellModel.lastObject {
            corner = [.topLeft,.topRight,.bottomLeft,.bottomRight]
        }
        
        self.containerView.backgroundColor = viewBackgroundColor
        //  self.containerView.layer.removeFromSuperlayer()
        
        configRectCornerAndBorder(view: self.containerView, corner: corner, roundCorner: roundCorner, border: border, borderWidth: 0.5, borderColor: borderColor)
        
    }
    
    //商品正常状态的显示规则
    func productNormal(){
        self.productName.textColor = RGBColor(0x333333)
        self.factoryLabel.textColor = RGBColor(0x666666)
        self.timeTitleLabel.textColor = RGBColor(0x666666)
        self.timeLabel.textColor = RGBColor(0x333333)
        self.productPrice.textColor = RGBColor(0xFF2D5C)
    }
    
    //不能购买(失效)状态下显示规则
    func canNotBuyState(){
        self.productName.textColor = RGBColor(0x999999)
        self.factoryLabel.textColor = RGBColor(0xCCCCCC)
        self.timeTitleLabel.textColor = RGBColor(0xCCCCCC)
        self.timeLabel.textColor = RGBColor(0xCCCCCC)
        self.productPrice.textColor = RGBColor(0x999999)
    }
    
    //缺货下架状态下显示规则
    func soldOutAndUNShelevState(){
        self.productName.textColor = RGBColor(0x999999)
        self.factoryLabel.textColor = RGBColor(0xCCCCCC)
        self.timeTitleLabel.textColor = RGBColor(0xCCCCCC)
        self.timeLabel.textColor = RGBColor(0xCCCCCC)
        self.productPrice.textColor = RGBColor(0x999999)
    }
    
    
    func configRectCornerAndBorder(view: UIView, corner: UIRectCorner, roundCorner: (leftTop:CGFloat,rightTop:CGFloat,rightBottom:CGFloat,leftBottom:CGFloat)=(0,0,0,0),border:(top:Bool,right:Bool,bottom:Bool,left:Bool)=(false,false,false,false),borderWidth:CGFloat = 2,borderColor:UIColor=UIColor.red)  {
        self.borderLayer.removeFromSuperlayer()
        //切圆角
        var radii:CGFloat = 0;
        if roundCorner.leftTop != 0{
            radii = roundCorner.leftTop
        }
        if roundCorner.leftBottom != 0{
            radii = roundCorner.leftBottom
        }
        if roundCorner.rightTop != 0 {
            radii = roundCorner.rightTop
        }
        if roundCorner.rightBottom != 0{
            radii = roundCorner.rightBottom
        }
        
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radii ,height: radii ))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
        
        
        //画边框 从左上角开始
        let pathCenter = borderWidth/2.0
        let path = UIBezierPath()
        path.move(to:CGPoint(x:0,y:0+pathCenter))
        //左上圆角
        if roundCorner.leftTop != 0 {
            path.move(to:CGPoint(x: 0+pathCenter, y: roundCorner.leftTop))
            path.addArc(withCenter: CGPoint(x:roundCorner.leftTop+pathCenter,y:roundCorner.leftTop+pathCenter), radius: roundCorner.leftTop, startAngle:.pi, endAngle: .pi*1.5, clockwise: true)
        }
        
        
        //右上圆角+上方边框
        if roundCorner.rightTop != 0 {
            if border.top{
                if roundCorner.leftTop != 0{
                    path.move(to: CGPoint(x:roundCorner.leftTop+pathCenter, y:0+pathCenter))
                }else{
                    path.move(to:CGPoint(x:0 ,y:0))
                }
                path.addLine(to: CGPoint(x: view.hd_width-roundCorner.rightTop, y: 0+pathCenter))
            }
            
            path.move(to:CGPoint(x: view.hd_width-roundCorner.rightTop, y: 0+pathCenter))
            path.addArc(withCenter: CGPoint(x:(view.hd_width-roundCorner.rightTop)-pathCenter,y:roundCorner.rightTop+pathCenter), radius: roundCorner.rightTop, startAngle: .pi*1.5, endAngle:0, clockwise: true)
        }else{
            if border.top{
                if roundCorner.leftTop != 0{
                    path.move(to: CGPoint(x:roundCorner.leftTop+pathCenter, y:0+pathCenter))
                }else{
                    path.move(to:CGPoint(x:0 ,y:0))
                }
                path.addLine(to: CGPoint(x:view.hd_width,y:0+pathCenter))
            }
        }
        
        //右下圆角+右边边框
        if roundCorner.rightBottom != 0{
            if border.right{
                if roundCorner.rightTop != 0{
                    path.move(to: CGPoint(x:view.hd_width-pathCenter, y:roundCorner.rightTop+pathCenter))
                }else{
                    path.move(to:CGPoint(x:view.hd_width-pathCenter ,y:0))
                }
                path.addLine(to:CGPoint(x: view.hd_width-pathCenter, y: view.hd_height-roundCorner.rightBottom))
            }
            path.move(to:CGPoint(x: view.hd_width-pathCenter, y: view.hd_height-roundCorner.rightBottom))
            path.addArc(withCenter: CGPoint(x:(view.hd_width-roundCorner.rightBottom)-pathCenter,y:(view.hd_height-roundCorner.rightBottom)-pathCenter), radius: roundCorner.rightBottom, startAngle: 0, endAngle:.pi/2.0, clockwise: true)
        }else{
            
            if border.right {
                if roundCorner.rightTop != 0{
                    path.move(to: CGPoint(x:view.hd_width-pathCenter, y:roundCorner.rightTop+pathCenter))
                }else{
                    path.move(to:CGPoint(x:view.hd_width-pathCenter ,y:0))
                }
                path.addLine(to: CGPoint(x:view.hd_width-pathCenter,y:view.hd_height))
            }
        }
        
        //左下圆角+下方边框
        if roundCorner.leftBottom != 0{
            if border.bottom {
                if roundCorner.rightBottom != 0{
                    path.move(to: CGPoint(x:view.hd_width-pathCenter-roundCorner.rightBottom, y:view.hd_height - pathCenter))
                }else{
                    path.move(to:CGPoint(x:view.hd_width ,y:view.hd_height))
                }
                path.addLine(to:CGPoint(x: roundCorner.leftBottom+pathCenter, y: view.hd_height-pathCenter))
            }
            path.move(to:CGPoint(x: roundCorner.leftBottom+pathCenter, y: view.hd_height-pathCenter))
            path.addArc(withCenter: CGPoint(x:roundCorner.leftBottom+pathCenter,y:(view.hd_height-roundCorner.leftBottom)-pathCenter), radius: roundCorner.leftBottom, startAngle: .pi/2.0, endAngle:.pi, clockwise: true)
        }else{
            if border.bottom {
                if roundCorner.rightBottom != 0{
                    path.move(to: CGPoint(x:view.hd_width-pathCenter-roundCorner.rightBottom, y:view.hd_height - pathCenter))
                }else{
                    path.move(to:CGPoint(x:view.hd_width ,y:view.hd_height))
                }
                path.addLine(to: CGPoint(x:0,y:view.hd_height-pathCenter))
            }
        }
        
        //最后一条封闭直线 左边边框
        if roundCorner.leftTop != 0{
            if border.left {
                if roundCorner.leftBottom != 0{
                    path.move(to: CGPoint(x:0+pathCenter, y:view.hd_height - pathCenter-roundCorner.leftBottom))
                }else{
                    path.move(to:CGPoint(x:0+pathCenter ,y:view.hd_height))
                }
                path.addLine(to: CGPoint(x:0+pathCenter,y:roundCorner.leftTop + pathCenter))
            }
        }else{
            if border.left {
                if roundCorner.leftBottom != 0{
                    path.move(to: CGPoint(x:0+pathCenter, y:view.hd_height - pathCenter-roundCorner.leftBottom))
                }else{
                    path.move(to:CGPoint(x:0+pathCenter ,y:view.hd_height))
                }
                path.addLine(to: CGPoint(x:0+pathCenter,y:0))
            }
        }
        
        path.stroke()
        
        //        let borderLayer = CAShapeLayer()
        borderLayer.frame = view.bounds
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = borderWidth
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(borderLayer)
    }
}

//获取行高
extension FKYShoppingCarProductTableViewCell{
    static func  getCellContentHeight(_ product: Any) -> CGFloat{
        var cellHeight = WH(16)
        if let productModel = product as? CartProdcutnfoModel {
            
            if let  productFullName = productModel.productFullName,productFullName.isEmpty == false{
                let attributedString = FKYShoppingCarProductTableViewCell.getComboMainProductAttrStr(productFullName, productModel.mainProductFlag)
                       let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(145), height: WH(35)), options: .usesLineFragmentOrigin, context: nil).size
                       
               // let contentSize = productFullName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(145), height: WH(35)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: WH(14))], context: nil).size
                cellHeight += contentSize.height + WH(1) //产品名
            }
            if let  manufactures = productModel.manufactures,manufactures.isEmpty == false{
                cellHeight +=   WH(20) //厂家
            }
            if let  deadLine = productModel.deadLine,deadLine.isEmpty == false{
                cellHeight += WH(20) //效期
            }
            if productModel.getExclusivePromotionFlag(["2001"]){
                //享受了专享价
                cellHeight += WH(10)
            }
            if productModel.productStatus == 0 {
                //限购信息标签
                var hasLimitInfo = false
                if !(productModel.canUseCouponFlag ?? true) {
                    hasLimitInfo = true
                }
                
                if (productModel.reachLimitNum ?? false) {
                    hasLimitInfo = true
                }
                
                if (productModel.promotionVip?.reachVipLimitNum ?? false){
                    hasLimitInfo = true
                }
                if let limitNum = productModel.comboProductLimitNum,limitNum > 0{
                    hasLimitInfo = true
                }
                if productModel.isHasSomeKindPromotion(["2001"]){
                    //有专享价
                    hasLimitInfo = true
                }
                //周限购标签
                if ([2].contains(productModel.productLimitBuy?.cycleType) ){
                    hasLimitInfo = true
                }
                if hasLimitInfo == true{
                    cellHeight += WH(26)
                }
                cellHeight += WH(12) //标签或者效期和价格之间的空隙
                cellHeight += WH(45) //加车和底部
                if cellHeight < WH(146){
                    return WH(146)
                }else{
                    return cellHeight
                }
            }else{
                return WH(129)
            }
        }
        return cellHeight
    }
}
extension FKYShoppingCarProductTableViewCell{
    //搭配套餐 主品加个标
    static func getComboMainProductAttrStr(_ productName:String,_ mainProductFlag:Bool) -> (NSMutableAttributedString) {
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        //图片
        let shopImage : UIImage?
        if  mainProductFlag == true{
            //主品标
            let textAttachment : NSTextAttachment = NSTextAttachment()
            if let tagImage = FKYComboMainProductFlagManager.shareInstance.tagNameImage(tagName: "主品", colorType: .red) {
                shopImage = tagImage
                textAttachment.bounds = CGRect(x: 0, y: -(UIFont.boldSystemFont(ofSize: WH(14)).lineHeight - tagImage.size.height)/2.0, width: tagImage.size.width, height:tagImage.size.height)
                textAttachment.image = shopImage
            }
            
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:" %@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(14))])
            
            attributedStrM.append(NSAttributedString(attachment: textAttachment))
            attributedStrM.append(productNameStr)
        }else {
            ///商品没标
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:"%@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(14))])
            attributedStrM.append(productNameStr)
        }
        return attributedStrM;
    }
    
}
