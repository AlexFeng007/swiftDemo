//
//  FKYShopListCell.swift
//  FKY
//
//  Created by hui on 2018/5/23.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

let TOP_VIEW_H = WH(15+16) //头部高度
let BOTTOM_VIEW_H = WH(159) //底部高度
let LOW_MONEY_VIEW_H = WH(20) //起售/包邮
let SHOP_TAG_ONE_LINE_H = WH(11*2)//多快好省1行
let SHOP_TAG_TWO_LINE_H = WH(11*3+9)//多快好省2行
let SHOP_TYPE_H = WH(12+14) //店铺标签类型
let ACTIVITY_VIEW_H = WH(18+2+2) //活动view的高度
let PRODUCT_NUM_W = WH(100) //商品数量显示的最大宽度
let LOW_MONEY_VIEW_W = WH(100) //起售标签最大宽度

let PRO_W_H = WH(60)
let PRD_VIEW_SPACE = (SCREEN_WIDTH - WH(15+48+10)-(PRO_W_H*4)-WH(20))/3.0  //商品间隔
let YHQ_CON_W  = SCREEN_WIDTH - WH(15+48+10) - WH(44+5) - WH(22) //优惠券内容
let MJ_MZ_CON_W  = SCREEN_WIDTH - WH(15+48+10) - WH(34+8) - WH(22) //满减内容

let TITLE_H = WH(60) // 标题视图高度
let PATTER_H = WH(148) // 商品item高度
let COLLECT_ITEM_W = SCREEN_WIDTH*2/7.0 // 商品item宽度

let COLLECTTION_H = WH(323) //商品列表两行高度（36为增加标签）
let COLLECT_S_H = WH(27) //Page的高度
let COLLECT_B_H = WH(175) //减去一半的高度(18一个表情的高度)
let TITLE_VIEW_H = WH(40) //标题的高度
let SINGLE_VIEW_H = WH(25) //情报小站视图高度
let SPACE_SINGLE_COLLECTTION_H = WH(16) //情报小站与collectionview之间的间隔
typealias viewClosure = (Int)->(Void)
typealias clickProductClosure = (FKYSpecialPriceModel ,String,Int)->(Void)
typealias clickShopClosure = (FKYShopListModel)->(Void)
//促销活动
class ActivityView: UIView {
    //活动标签
    fileprivate var yhqTitleLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = WH(18)/2.0
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = t1.color
        label.font = t25.font
        label.backgroundColor = RGBColor(0xFF3260)
        return label
    }()
    //活动内容
    fileprivate var yhqContentsLabel: UILabel = {
        let label = UILabel()
        label.font = t22.font
        label.numberOfLines = 0
        label.textColor = RGBColor(0x838383)
        label.lineBreakMode = .byCharWrapping
        label.isUserInteractionEnabled = true
        return label
    }()
    
    fileprivate lazy var showMoreYHQBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"downIcon"), for: .normal)
        btn.setImage(UIImage(named:"upIcon"), for: .selected)
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var showMoreYHQClosure: emptyClosure?
    
    func setupView(){
        //优惠卷
        self.addSubview(yhqTitleLabel)
        yhqTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(self.snp.top).offset(WH(2))
            make.height.equalTo(WH(18))
            make.width.equalTo(WH(44))
        }
        
        self.addSubview(yhqContentsLabel)
        yhqContentsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(yhqTitleLabel.snp.right).offset(WH(8))
            make.right.equalTo(self.snp.right).offset(-WH(22))
            make.top.equalTo(self.snp.top).offset(WH(2))
            make.bottom.equalTo(self.snp.bottom).offset(-WH(2))
        }
        
        let yhqTap = UITapGestureRecognizer()
        yhqTap.rx.event.subscribe(onNext: { [weak self] _ in
            if let strongSelf = self {
                if let closure = strongSelf.showMoreYHQClosure {
                    closure()
                }
            }
        }).disposed(by: disposeBag)
        yhqContentsLabel.addGestureRecognizer(yhqTap)
        
        self.addSubview(showMoreYHQBtn)
        showMoreYHQBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right)
            make.centerY.equalTo(yhqTitleLabel.snp.centerY)
            make.height.equalTo(WH(12))
            make.width.equalTo(WH(24))
        }
        _ = showMoreYHQBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.showMoreYHQClosure {
                //self.addRotationAnimation(self.showMoreYHQBtn)
                closure()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    //刷新数据
    func initActivityViewData(_ typeIndex:Int ,_ contentStr:String) {
        self.yhqContentsLabel.text = contentStr
        //满减或者满赠
        if typeIndex == 1 || typeIndex == 3 {
            yhqTitleLabel.snp.updateConstraints { (make) in
                make.width.equalTo(WH(34))
            }
            yhqContentsLabel.snp.updateConstraints { (make) in
                make.left.equalTo(yhqTitleLabel.snp.right).offset(WH(8))
            }
        }else{
            //优惠券
            yhqTitleLabel.snp.updateConstraints { (make) in
                make.width.equalTo(WH(44))
            }
            yhqContentsLabel.snp.updateConstraints { (make) in
                make.left.equalTo(yhqTitleLabel.snp.right).offset(WH(5))
            }
            self.yhqTitleLabel.text = "优惠券"
            //self.yhqTitleLabel.backgroundColor = RGBColor(0xFF3260)
        }
        //满减
        if typeIndex == 1 {
            self.yhqTitleLabel.text = "满减"
            //self.yhqTitleLabel.backgroundColor = RGBColor(0xFF8E15 )
        }
        if typeIndex == 3 {
            self.yhqTitleLabel.text = "满赠"
            //self.yhqTitleLabel.backgroundColor = RGBColor(0x8287F3)
        }
    }
    func refreshMoreBt(_ showBt : Bool) {
        self.showMoreYHQBtn.isSelected = showBt
    }
    func hideClickBt(_ hideClick : Bool){
        if hideClick == true {
            showMoreYHQBtn.isHidden = true
            yhqContentsLabel.isUserInteractionEnabled = false
        }else {
            showMoreYHQBtn.isHidden = false
            yhqContentsLabel.isUserInteractionEnabled = true
        }
    }
}

class FKYPrdouctViewCell: UICollectionViewCell {
    //商品图片
    fileprivate var productImageView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.yellow
        return img
    }()
    //商品标签
    fileprivate var productBQLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xffffff)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 2.0
        label.font = UIFont.systemFont(ofSize: WH(10))
        label.textAlignment = .center
        return label
    }()
    //商品名称
    fileprivate var productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = t7.font
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    //商品规格
    fileprivate var productRankLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x666666)
        label.font = t3.font
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    //商品价格（新）
    fileprivate var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = t19.font
        label.textAlignment = .center
        return label
    }()
    //商品原价格
    fileprivate var productPiceOldLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xB2B2B2)
        label.font = t28.font
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        let line = UIView()
        label.addSubview(line)
        line.snp.makeConstraints({ (make) in
            make.left.right.centerY.equalTo(label)
            make.height.equalTo(WH(1))
        })
        line.backgroundColor = RGBColor(0xB2B2B2)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.contentView.addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.height.width.equalTo(WH(70))
            make.centerX.equalTo(contentView.snp.centerX)
        }
        self.productImageView.addSubview(productBQLabel)
        productBQLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.productImageView)
            make.height.equalTo(WH(13))
            make.width.equalTo(WH(27))
        }
        
        self.contentView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(2))
            make.right.equalTo(contentView.snp.right).offset(-WH(2))
            make.top.equalTo(self.productImageView.snp.bottom).offset(WH(10))
            make.height.equalTo(WH(12))
        }
        
        self.contentView.addSubview(productRankLabel)
        productRankLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(2))
            make.right.equalTo(contentView.snp.right).offset(-WH(2))
            make.top.equalTo(self.productNameLabel.snp.bottom).offset(WH(5))
            make.height.equalTo(WH(14))
        }
        self.contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(2))
            make.right.equalTo(contentView.snp.right).offset(-WH(2))
            make.top.equalTo(self.productRankLabel.snp.bottom).offset(WH(8))
            make.height.equalTo(WH(13))
        }
        
        self.contentView.addSubview(productPiceOldLabel)
        productPiceOldLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(self.priceLabel.snp.bottom).offset(WH(1))
            make.width.lessThanOrEqualTo(COLLECT_ITEM_W-WH(4))
            make.height.equalTo(WH(14))
        }
    }
    
    func configCell(_ product: FKYSpecialPriceModel?) {
        if let model = product {
            self.productImageView.sd_setImage(with: URL.init(string: model.productPicUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "), placeholderImage: UIImage.init(named: "image_default_img"))
            self.productNameLabel.text = model.prductName
            self.productRankLabel.text = model.spec
            //判断标签显示
            self.productBQLabel.isHidden = true
            self.productPiceOldLabel.isHidden = true
            if model.hasSpePrice == "1" {
                self.productBQLabel.isHidden = false
                self.productBQLabel.backgroundColor = RGBColor(0xFF2D5C)
                self.productBQLabel.text = "特价"
                self.productPiceOldLabel.isHidden = false
                if let spePrice = model.spePrice {
                    self.updatePriceStatus(model, String(format: "￥%.2f", CGFloat(spePrice)))
                }
                if let price = model.showPrice {
                    self.productPiceOldLabel.text = String(format: "￥%.2f", CGFloat(price))
                }
            }else {
                if let price = model.showPrice {
                    self.updatePriceStatus(model, String(format: "￥%.2f", CGFloat(price)))
                }
            }
            if self.productBQLabel.isHidden == true , model.hasRebate == "1"{
                self.productBQLabel.isHidden = false
                self.productBQLabel.backgroundColor = RGBColor(0xFF8E15)
                self.productBQLabel.text = "返利"
            }
            if self.productBQLabel.isHidden == true , model.hasFullSub == "1"{
                self.productBQLabel.isHidden = false
                self.productBQLabel.backgroundColor = RGBColor(0xFFA083)
                self.productBQLabel.text = "满减"
                
            }
            if self.productBQLabel.isHidden == true , model.hasCoupon == "1" {
                self.productBQLabel.isHidden = false
                self.productBQLabel.backgroundColor = RGBColor(0xFD394D)
                self.productBQLabel.text = "领券"
            }
            //未登录不显示标签和原价格
            if model.statusDesc != 0 {
                self.productBQLabel.isHidden = true
                self.productPiceOldLabel.isHidden = true
            }
        }
    }
    
    func updatePriceStatus(_ product: FKYSpecialPriceModel, _ price: String) {
        priceLabel.font = t25.font
        if let pStatus = product.statusDesc {
            switch pStatus {
            case 0:
                // 正常显示价格...<显示价格>
                priceLabel.text = price
                priceLabel.textColor = RGBColor(0xFF2D5C)
                priceLabel.font = t19.font
            case -1:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    priceLabel.text = msg
                }
                else {
                    priceLabel.text = "登录后可见"
                }
                
            case -2:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    priceLabel.text = msg
                }
                else {
                    priceLabel.text = "控销"
                }
            case -3:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    priceLabel.text = msg
                }
                else {
                    priceLabel.text = "资质认证后可见"
                }
            case -4:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    priceLabel.text = msg
                }
                else {
                    priceLabel.text = "控销"
                }
            case -5:
                // 缺货...<显示价格>
                priceLabel.text = "缺货"
            case -6:
                // 不显示价格
                priceLabel.text = "￥" + "--"
            case -7:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    priceLabel.text = msg
                }
                else {
                    priceLabel.text = "下架"
                }
            case -8:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    priceLabel.text = msg
                }
                else {
                    priceLabel.text = "无采购权限"
                }
            case -9:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    priceLabel.text = msg
                }
                else {
                    priceLabel.text = "申请权限后可见"
                }
            case -10:
                if let msg = product.statusMsg, msg.isEmpty == false {
                    priceLabel.text = msg
                }
                else {
                    priceLabel.text = "权限审核后可见"
                }
            default:
                priceLabel.text = price
                priceLabel.textColor = RGBColor(0xFF2D5C)
                priceLabel.font =  t19.font
                //priceLabel.font = t20.font
            }
        }
    }
}
//MARK:多快好省标签
class FKYShopTagView : UIView {
    fileprivate var productTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(11))
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
        label.layer.cornerRadius = WH(1)
        label.layer.masksToBounds = true
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.layer.borderWidth = WH(0.5)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    fileprivate var productNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = t16.color
        label.font = t31.font
        return label
    }()
    fileprivate var expressTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(11))
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
        label.layer.cornerRadius = WH(1)
        label.layer.masksToBounds = true
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.layer.borderWidth = WH(0.5)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    fileprivate var expressNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = t16.color
        label.font = t31.font
        return label
    }()
    fileprivate var onlyTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(11))
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
        label.layer.cornerRadius = WH(1)
        label.layer.masksToBounds = true
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.layer.borderWidth = WH(0.5)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    fileprivate var onlyNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = t16.color
        label.font = t31.font
        return label
    }()
    fileprivate var couponTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(11))
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
        label.layer.cornerRadius = WH(1)
        label.layer.masksToBounds = true
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.layer.borderWidth = WH(0.5)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    fileprivate var couponNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = t16.color
        label.font = t31.font
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView()  {
        addSubview(productTagLabel)
        productTagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(self.snp.top).offset(WH(11))
            make.height.width.equalTo(WH(11))
        }
        addSubview(productNumLabel)
        productNumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productTagLabel.snp.right).offset(WH(5))
            make.centerY.equalTo(productTagLabel.snp.centerY)
            make.width.equalTo(WH(90))
        }
        addSubview(expressTagLabel)
        expressTagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productNumLabel.snp.right).offset(WH(15))
            make.centerY.equalTo(productTagLabel.snp.centerY)
            make.height.width.equalTo(WH(11))
        }
        addSubview(expressNumLabel)
        expressNumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(expressTagLabel.snp.right).offset(WH(5))
            make.centerY.equalTo(productTagLabel.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-WH(10))
        }
        addSubview(onlyTagLabel)
        onlyTagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(productTagLabel.snp.bottom).offset(WH(9))
            make.height.width.equalTo(WH(11))
        }
        addSubview(onlyNumLabel)
        onlyNumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(onlyTagLabel.snp.right).offset(WH(5))
            make.centerY.equalTo(onlyTagLabel.snp.centerY)
            make.width.equalTo(WH(90))
        }
        addSubview(couponTagLabel)
        couponTagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(onlyNumLabel.snp.right).offset(WH(15))
            make.centerY.equalTo(onlyTagLabel.snp.centerY)
            make.height.width.equalTo(WH(11))
        }
        addSubview(couponNumLabel)
        couponNumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(couponTagLabel.snp.right).offset(WH(5))
            make.centerY.equalTo(onlyTagLabel.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-WH(10))
        }
        
    }
    func configShopTag(_ arr:[Any]){
        self.productTagLabel.isHidden = true
        self.productNumLabel.isHidden = true
        self.expressTagLabel.isHidden = true
        self.expressNumLabel.isHidden = true
        self.onlyTagLabel.isHidden = true
        self.onlyNumLabel.isHidden = true
        self.couponTagLabel.isHidden = true
        self.couponNumLabel.isHidden = true
        if arr.count > 0 {
            let tagLabelArr = [self.productTagLabel,self.expressTagLabel,self.onlyTagLabel,self.couponTagLabel]
            let numLabelArr = [self.productNumLabel,self.expressNumLabel,self.onlyNumLabel,self.couponNumLabel]
            for index in 0...arr.count-1 {
                if let desDic = arr[index] as? NSDictionary {
                    let tagLb = tagLabelArr[index]
                    let numLb = numLabelArr[index]
                    tagLb.isHidden = false
                    numLb.isHidden = false
                    tagLb.text = desDic.allKeys[0] as? String
                    numLb.text = desDic.allValues[0] as? String
                }
            }
        }
    }
}
//MARK:店铺类型标签
class FKYShopTypeCell: UICollectionViewCell {
    //店铺名称
     var shopTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.systemFont(ofSize: WH(10))
        label.textAlignment = .center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        self.layer.cornerRadius = WH(2)
        self.layer.masksToBounds = true
        self.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        self.layer.borderWidth = WH(0.5)
        self.contentView.addSubview(shopTypeLabel)
        shopTypeLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    //MARK:新店铺馆店铺列表标签
    func configNewShopListTag(_ str:String ) {
        shopTypeLabel.text = str
        self.layer.cornerRadius = WH(2)
        self.layer.masksToBounds = true
        self.shopTypeLabel.font = t25.font
        self.layer.borderWidth = WH(0)
        if str.contains("起送") || str.contains("包邮") {
            self.backgroundColor = RGBColor(0xFFF2E7)
            self.shopTypeLabel.textColor = RGBColor(0xFF832C)
        }else {
            self.backgroundColor = RGBColor(0xF4F4F4)
            self.shopTypeLabel.textColor = RGBColor(0x999999)
        }
    }
    //商品列表标签赋值
    func configTagData(_ str:String) {
        shopTypeLabel.font = UIFont.boldSystemFont(ofSize: WH(10))
        self.layer.masksToBounds = true
        self.layer.cornerRadius = TAG_H/2.0
        shopTypeLabel.text = str
        if str.contains("可享专享价") || str == "限购" {
            shopTypeLabel.backgroundColor = RGBColor(0xFFEDE7)
            shopTypeLabel.textColor = RGBColor(0xFF2D5C)
            self.layer.borderWidth = 0
        }else {
            shopTypeLabel.textColor = RGBColor(0xFF2D5C)
            shopTypeLabel.backgroundColor = UIColor.white
            self.layer.borderWidth = 1
            self.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        }
    }
}
class FKYShopTypeView : UIView {
    //类型标签列表
    lazy var shopTypeCollectionView: UICollectionView! = {
        let flowLayout = UICollectionViewLeftAlignedLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .vertical
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(FKYShopTypeCell.self, forCellWithReuseIdentifier: "FKYShopTypeCell")
        view.isScrollEnabled = false
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.dataSource = self
        return view
    }()
    fileprivate lazy var showMoreTypeBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"downIcon"), for: .normal)
        btn.setImage(UIImage(named:"upIcon"), for: .selected)
        return btn
    }()
    var showMoreTypeClosure: emptyClosure?
    var typeArr : [String]?//数据模型
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        self.addSubview(showMoreTypeBtn)
        showMoreTypeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top).offset(WH(12))
            make.height.equalTo(WH(12))
            make.width.equalTo(WH(24))
        }
        _ = showMoreTypeBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.showMoreTypeClosure {
                closure()
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        self.addSubview(shopTypeCollectionView)
        shopTypeCollectionView.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(self)
            make.top.equalTo(self.snp.top).offset(WH(12))
            make.right.equalTo(showMoreTypeBtn.snp.left)
        }
    }
    func refreshMoreTypeBt(_ showBt : Bool) {
        self.showMoreTypeBtn.isSelected = showBt
    }
    func hideTypeClickBt(_ hideClick : Bool){
        if hideClick == true {
            showMoreTypeBtn.isHidden = true
            showMoreTypeBtn.isUserInteractionEnabled = false
        }else {
            showMoreTypeBtn.isHidden = false
            showMoreTypeBtn.isUserInteractionEnabled = true
        }
    }
}
extension FKYShopTypeView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let str = self.typeArr?[indexPath.row] {
            let strW = str.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(10))], context: nil).size.width
            return CGSize(width:(strW + WH(6)), height:WH(14))
        }
            return CGSize(width:WH(0), height:WH(0))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return WH(7)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYShopTypeCell", for: indexPath) as! FKYShopTypeCell
        cell.shopTypeLabel.text = self.typeArr?[indexPath.row] ?? ""
        return cell
    }
}
//MARK:店铺cell
class FKYShopListCell: UICollectionViewCell {
    //店铺头像
    fileprivate var shopImageView: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = WH(4)
        img.clipsToBounds = true
        img.layer.borderColor = RGBColor(0xE7E7E7).cgColor
        img.layer.borderWidth = 0.5
        return img
    }()
    //店铺名称
    fileprivate var shopNameLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t44
        return label
    }()
    //店铺标签
    fileprivate var shopTagView : FKYShopTagView = {
        let view = FKYShopTagView()
        return view
    }()
    //店铺类型标签
    fileprivate var shopTypeView : FKYShopTypeView = {
        let view = FKYShopTypeView()
        return view
    }()
    //促销活动1(满减)
    fileprivate var activityOneView : ActivityView = {
        let view = ActivityView()
        return view
    }()
    //促销活动2（优惠券）
    fileprivate var activityTwoView : ActivityView = {
        let view = ActivityView()
        return view
    }()
    //促销活动3（满赠）
    fileprivate var activityThreeView : ActivityView = {
        let view = ActivityView()
        return view
    }()
    //商品列表
    fileprivate lazy var shopProductView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(FKYPrdouctViewCell.self, forCellWithReuseIdentifier: "FKYPrdouctViewCell")
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    var goProductDes : clickProductClosure?
    var shopModel : FKYShopListModel?
    var showActivityNum : viewClosure? //点击活动
    var goShopDetail : clickShopClosure? //进店铺详情
    // 记录滑动开始
    fileprivate var scrollViewBJ : Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = bg1
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FKYShopListCell {
    func setupView() {
        //头部布局
        contentView.addSubview(shopImageView)
        shopImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(16))
            make.top.equalTo(contentView.snp.top).offset(WH(15))
            make.height.width.equalTo(WH(58))
        }
        contentView.addSubview(shopNameLabel)
        shopNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shopImageView.snp.right).offset(WH(14))
            make.top.equalTo(shopImageView.snp.top)
            make.right.equalTo(contentView.snp.right).offset(-WH(10))
        }
        //展示商品
        contentView.addSubview(shopProductView)
        //shopProductView.backgroundColor = UIColor.yellow
        contentView.addSubview(shopTagView)
        shopProductView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(BOTTOM_VIEW_H)
        }
        //多快好省号标签
        //shopTagView.backgroundColor = UIColor.yellow
        contentView.addSubview(shopTagView)
        shopTagView.snp.makeConstraints { (make) in
            make.left.equalTo(shopNameLabel.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.top.equalTo(shopNameLabel.snp.bottom)
            make.height.equalTo(SHOP_TAG_TWO_LINE_H)
        }
        //店铺类型标签
        contentView.addSubview(shopTypeView)
       // shopTypeView.backgroundColor = UIColor.blue
        shopTypeView.snp.makeConstraints { (make) in
            make.left.equalTo(shopNameLabel.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.top.equalTo(shopTagView.snp.bottom)
            make.height.equalTo(SHOP_TYPE_H)
        }
        shopTypeView.showMoreTypeClosure = { [weak self] in
            if let strongSelf = self {
                if let block = strongSelf.showActivityNum {
                    block(4)
                }
            }
        }
        //活动1
        contentView.addSubview(activityOneView)
        activityOneView.snp.makeConstraints { (make) in
            make.top.equalTo(self.shopTypeView.snp.bottom).offset(WH(10))
            make.left.equalTo(self.shopNameLabel.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(0)
        }
        activityOneView.showMoreYHQClosure = { [weak self] in
            if let strongSelf = self {
                if let block = strongSelf.showActivityNum {
                    block(1)
                }
            }
        }
        self.contentView.addSubview(activityTwoView)
        activityTwoView.snp.makeConstraints { (make) in
            make.top.equalTo(activityOneView.snp.bottom)
            make.left.equalTo(self.shopNameLabel.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(0)
        }
        activityTwoView.showMoreYHQClosure = { [weak self] in
            if let strongSelf = self {
                if let block = strongSelf.showActivityNum {
                    block(2)
                }
            }
        }
        self.contentView.addSubview(activityThreeView)
        activityThreeView.snp.makeConstraints { (make) in
            make.top.equalTo(activityTwoView.snp.bottom)
            make.left.equalTo(self.shopNameLabel.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(0)
        }
        activityThreeView.showMoreYHQClosure = { [weak self] in
            if let strongSelf = self {
                if let block = strongSelf.showActivityNum {
                    block(3)
                }
            }
        }
        
        // 底部分隔线
        let bottomLine = UIView()
        bottomLine.backgroundColor = bg7
        self.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints({ (make) in
            make.bottom.left.right.equalTo(contentView)
            make.height.equalTo(0.5)
        })
    }
}

extension FKYShopListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let productList = self.shopModel?.promotionListInfo {
            return productList.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:COLLECT_ITEM_W, height:BOTTOM_VIEW_H)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYPrdouctViewCell", for: indexPath) as! FKYPrdouctViewCell
        cell.configCell(self.shopModel?.promotionListInfo?[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let clickItemBlock = self.goProductDes,let model = self.shopModel?.promotionListInfo?[indexPath.item],let shopId = model.enterpriseId {
            clickItemBlock(model, "\(shopId)",indexPath.item)
        }
    }
}

//MARK: 赋值数据相关
extension FKYShopListCell {
    //cell数据刷新
    func configCellData(_ model : FKYShopListModel) {
        shopModel = model
        //头部数据刷新
        shopImageView.sd_setImage(with: URL.init(string: model.logo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "), placeholderImage:shopImageView.imageWithColor(RGBColor(0xf4f4f4), "icon_home_placeholder_image_logo", CGSize(width: WH(48), height: WH(48))))
        shopNameLabel.text = model.shopName
        //有无商品时候对商品滑动页显示或隐藏
        self.shopProductView.isHidden = false
        self.shopProductView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(BOTTOM_VIEW_H)
        }
        if model.promotionListInfo?.count == 0 {
            //无商品
            self.shopProductView.isHidden = true
            shopProductView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }
        //判断多快好省标签
        if model.tagArr?.count == 0 {
            self.shopTagView.isHidden = true
            self.shopTagView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }else if (model.tagArr?.count)! > 2  {
            self.shopTagView.isHidden = false
            self.shopTagView.snp.updateConstraints { (make) in
                make.height.equalTo(SHOP_TAG_TWO_LINE_H)
            }
        }else {
            self.shopTagView.isHidden = false
            self.shopTagView.snp.updateConstraints { (make) in
                make.height.equalTo(SHOP_TAG_ONE_LINE_H)
            }
        }
        self.shopTagView.configShopTag(model.tagArr ?? [])
        //判断尖头的指向
        self.shopTypeView.refreshMoreTypeBt(model.showTypeName)
        self.activityOneView.refreshMoreBt(model.showOneActivity)
        self.activityTwoView.refreshMoreBt(model.showTwoActivity)
        self.activityThreeView.refreshMoreBt(model.showThreeActivity)
        //店铺标签类型，满减、优惠券、满赠顺序显示
        self.shopTypeView.isHidden = true
        self.activityOneView.isHidden = true
        self.activityTwoView.isHidden = true
        self.activityThreeView.isHidden = true
        self.shopTypeView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        self.activityOneView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        self.activityTwoView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        self.activityThreeView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        //店铺类型标签
        if let arr = model.typeArr,arr.count > 0 {
            self.shopTypeView.isHidden = false
            self.shopTypeView.typeArr = arr
            self.shopTypeView.snp.updateConstraints { (make) in
                make.height.equalTo(SHOP_TYPE_H)
            }
            self.shopTypeView.layoutIfNeeded()
            self.shopTypeView.shopTypeCollectionView.reloadData()
            self.shopTypeView.layoutIfNeeded()
            let shopTypeH = self.shopTypeView.shopTypeCollectionView.collectionViewLayout.collectionViewContentSize.height
            model.typeNameH = shopTypeH
            if shopTypeH > WH(14) {
                self.shopTypeView.hideTypeClickBt(false)
            }else {
                self.shopTypeView.hideTypeClickBt(true)
            }
            if model.showTypeName == true {
                self.shopTypeView.snp.updateConstraints { (make) in
                    make.height.equalTo(shopTypeH+WH(12)+1)
                }
            }else{
                self.shopTypeView.snp.updateConstraints { (make) in
                    make.height.equalTo(SHOP_TYPE_H)
                }
            }
        }else {
            self.shopTypeView.typeArr = []
            self.shopTypeView.shopTypeCollectionView.reloadData()
        }
        //满减
        if let mjStr = model.mjPromotionDes,mjStr.count > 0 {
            self.activityOneView.isHidden = false
            self.activityOneView.initActivityViewData(1, mjStr)
            let mjContentLabelH =  mjStr.boundingRect(with: CGSize(width: MJ_MZ_CON_W, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t22.font], context: nil).height
            if mjContentLabelH < ACTIVITY_VIEW_H {
                self.activityOneView.hideClickBt(true)
            }else {
                 self.activityOneView.hideClickBt(false)
            }
            if model.showOneActivity == true {
                self.activityOneView.snp.updateConstraints { (make) in
                    make.height.equalTo(ceil(mjContentLabelH)+WH(4))
                }
            }else{
                self.activityOneView.snp.updateConstraints { (make) in
                    make.height.equalTo(ACTIVITY_VIEW_H)
                }
            }
        }
        //优惠券
        if let couponsStr = model.couponsDes,couponsStr.count > 0 {
            self.activityTwoView.isHidden = false
            self.activityTwoView.initActivityViewData(2, couponsStr)
            let couponsContentLabelH =  couponsStr.boundingRect(with: CGSize(width: YHQ_CON_W, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t22.font], context: nil).height
            if couponsContentLabelH < ACTIVITY_VIEW_H {
                self.activityTwoView.hideClickBt(true)
            }else {
                self.activityTwoView.hideClickBt(false)
            }
            if model.showTwoActivity == true {
                self.activityTwoView.snp.updateConstraints { (make) in
                    make.height.equalTo(ceil(couponsContentLabelH)+WH(4))
                }
            }else{
                self.activityTwoView.snp.updateConstraints { (make) in
                    make.height.equalTo(ACTIVITY_VIEW_H)
                }
            }
        }
        //最多显示两个活动标签
        if let couponsStr = model.couponsDes,couponsStr.count > 0,let mjStr = model.mjPromotionDes,mjStr.count > 0 {
            
        }else {
            //满赠
            if let mzStr = model.mzPromotionDes,mzStr.count > 0 {
                self.activityThreeView.isHidden = false
                self.activityThreeView.initActivityViewData(3, mzStr)
                let mzContentLabelH =  mzStr.boundingRect(with: CGSize(width: MJ_MZ_CON_W, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font: t22.font], context: nil).height
                if mzContentLabelH < ACTIVITY_VIEW_H {
                    self.activityThreeView.hideClickBt(true)
                }else {
                    self.activityThreeView.hideClickBt(false)
                }
                if model.showThreeActivity == true {
                    self.activityThreeView.snp.updateConstraints { (make) in
                        make.height.equalTo(ceil(mzContentLabelH)+WH(4))
                    }
                }else{
                    self.activityThreeView.snp.updateConstraints { (make) in
                        make.height.equalTo(ACTIVITY_VIEW_H)
                    }
                }
            }
        }
        //初始化每次商品列表的位子
        self.shopProductView.setContentOffset(CGPoint.init(x:model.collectionOffX, y: 0), animated: false)
        self.shopProductView.reloadData()
        
    }
    
    //计算高度
    static func configCellHeight(_ model : FKYShopListModel) -> CGFloat {
        var cellH = BOTTOM_VIEW_H + WH(10) + TOP_VIEW_H
        if model.promotionListInfo?.count == 0 {
            cellH =  cellH - BOTTOM_VIEW_H
        }
        if (model.mjPromotionDes?.count)! > 0 || (model.couponsDes?.count)! > 0 || (model.mzPromotionDes?.count)! > 0 {
            cellH = cellH + WH(10)
        }else {
            cellH = cellH + WH(2) //微调无优惠券，满减满赠时
        }
        if model.tagArr?.count == 0 {
            
        }else if (model.tagArr?.count)! > 2  {
            cellH =  cellH + SHOP_TAG_TWO_LINE_H
        }else {
            cellH =  cellH + SHOP_TAG_ONE_LINE_H
        }
        
        if let arr = model.typeArr,arr.count > 0 {
            if model.showTypeName == true {
                cellH =  cellH + model.typeNameH + WH(12)+1
            }else{
                cellH =  cellH + SHOP_TYPE_H
            }
        }
        if let mjStr = model.mjPromotionDes,mjStr.count > 0 {
            if model.showOneActivity == true {
                let mjContentLabelH =  mjStr.boundingRect(with: CGSize(width: MJ_MZ_CON_W, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t22.font], context: nil).height
                cellH =  cellH + ceil(mjContentLabelH)+WH(4)
            }else {
                cellH =  cellH + ACTIVITY_VIEW_H
            }
        }
        if let couponsStr = model.couponsDes,couponsStr.count > 0 {
            if model.showTwoActivity == true {
                let couponsContentLabelH =  couponsStr.boundingRect(with: CGSize(width: YHQ_CON_W, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t22.font], context: nil).height
                cellH =  cellH + ceil(couponsContentLabelH)+WH(4)
            }else {
                cellH =  cellH + ACTIVITY_VIEW_H
            }
        }
        if let couponsStr = model.couponsDes,couponsStr.count > 0,let mjStr = model.mjPromotionDes,mjStr.count > 0 {
            
        }else {
            //满赠
            if let mzStr = model.mzPromotionDes,mzStr.count > 0 {
                if model.showThreeActivity == true {
                    let mzContentLabelH =  mzStr.boundingRect(with: CGSize(width: MJ_MZ_CON_W, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font: t22.font], context: nil).height
                    cellH =  cellH + ceil(mzContentLabelH)+WH(4)
                }else{
                    cellH =  cellH + ACTIVITY_VIEW_H
                }
            }
        }
        //防止数据过少问题
        let lessH = WH(15+56+15)
        if model.promotionListInfo?.count != 0,cellH < BOTTOM_VIEW_H+lessH {
            cellH = BOTTOM_VIEW_H + lessH //保证图片高度和商品数量高度
        }
        if model.promotionListInfo?.count == 0,cellH < lessH{
            cellH = lessH//保证图片高度
        }
        return cellH
    }
}
extension FKYShopListCell:UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewBJ = 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.shopProductView else {
            return
        }
        //记录每次collectionView的偏移
        self.shopModel?.collectionOffX = scrollView.contentOffset.x
        //左滑超过70跳转
        if  scrollView.contentOffset.x - (scrollView.contentSize.width - SCREEN_WIDTH) > 70 && self.scrollViewBJ == 0 {
            self.scrollViewBJ = 1
            if let clouser = self.goShopDetail ,let model = self.shopModel {
                clouser(model)
            }
        }
    }
}
