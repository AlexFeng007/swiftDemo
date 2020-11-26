//
//  CouponItemView.swift
//  FKY
//
//  Created by Rabe on 11/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  优惠券模块单行优惠券item父类

import Foundation

class CouponItemView: UIView {
    // MARK: - properties
    var itemType: CouponItemType? // 平台券 或 店铺券
    var usageType: CouponItemUsageType? // 使用场景（页面）
    var useShopViewHeight: CGFloat? //可用店铺view的高度

    var value: AnyObject?
    var model: AnyObject? {
        get { return value }
        set {
            value = newValue
            configCommonData()
            configSettings()
        }
    }
    
    // MARK: 通用视图
    /// 背景
    public lazy var bgView: UIView! = {
        let view = UIView()
        return view
    }()
    /// 背景图
    public lazy var bgImageView: UIImageView! = {
        let imageView = UIImageView()
        return imageView
    }()
    /// 金额
    public lazy var moneyLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.init(name: "DINCondensed-Bold", size: WH(40))
        label.minimumScaleFactor = 0.2
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    /// 满XX可用
    public lazy var priceLimitLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textColor = RGBColor(0xffffff)
        label.minimumScaleFactor = 0.1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    /// 交互按钮
    public lazy var interactButton: UIButton! = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(10))
        button.layer.cornerRadius = 3
        return button
    }()
    /// 【店铺券】店铺名称、【平台去】使用限制描述
    public lazy var titleDescLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.textAlignment = .left
        label.textColor = RGBColor(0x2a2928)
        label.numberOfLines = 2
        return label
    }()
    /// 时间限制
    public lazy var timeLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.init(name: "Helvetica", size: WH(12))
        label.textAlignment = .left
        label.textColor = RGBColor(0x979797)
        return label
    }()
    /// 可用商家或者商品按钮
    public lazy var detailDescLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(10))
        label.textAlignment = .left
        label.textColor = RGBColor(0x477ae9)
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(detailDescLabelClick))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    /// 优惠券使用限制商品描述
    public lazy var subTitleDescLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(10))
        label.textAlignment = .left
        label.textColor = RGBColor(0x666666)
        label.numberOfLines = 1
        return label
    }()
    
    /// 可用店铺列表
    public lazy var useShopView: UIView! = {
        let shopView = UIView()
        shopView.backgroundColor = RGBColor(0xF7F7F7)
        shopView.layer.borderWidth = 0.5
        shopView.layer.borderColor = RGBColor(0xeaeaea).cgColor
        shopView.isHidden=true;
        return shopView
    }()
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        __setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - delegates
    
    // MARK: - action
    
    // MARK: - data
    
    /// 填充优惠券通用数据
    fileprivate func configCommonData() {
        // 优惠券面值、金额限制文描、日期区间限制文描
        var denomination = ""
        if let vo = model as? CouponTempModel {
            denomination = "¥\(vo.denomination ?? 0)"
            priceLimitLabel.text = "满\(vo.limitprice ?? 0)可用"
            //subTitleDescLabel.text = vo.couponDescribe
            if let showTime = vo.couponTimeText {
                 timeLabel.text = showTime
            }else {
                timeLabel.text = vo.begindate! + "-" + vo.endDate!
            }
        } else if let vo = model as? CouponModel {
            denomination = "¥\(vo.denomination ?? 0)"
            priceLimitLabel.text = "满\(vo.limitprice ?? 0)可用"
            timeLabel.text = (vo.begindate ?? "") + "-" + (vo.endDate ?? "")
        } else if let vo = model as? FKYReCheckCouponModel {
            denomination = "¥\(vo.denomination)"
            priceLimitLabel.text = "满\(vo.limitprice)可用"
            timeLabel.text = vo.useTimeStr
            //subTitleDescLabel.text = vo.couponDescribe
        } else {
            print("未知优惠券item对象！")
        }
        //创建标签位置变量
        var  positionX:CGFloat = 20
        var  positionY:CGFloat =  20
        //临界值判断变量
        let bgViewWidth:CGFloat = 300
        self.useShopViewHeight = 0
        //移除self.useShopView上已经动态添加的label
        for subview in self.useShopView.subviews {
            if let desLabel = subview as? UILabel {
                desLabel.removeFromSuperview()
            }
        }
        if let vo = model as? CouponModel {
            if let items = vo.couponDtoShopList {
                for (index, value) in items.enumerated(){
                    let model :UseShopModel = value
                    let labelSize :CGSize = getTextSize(text: model.tempEnterpriseName! + "、 ", font: UIFont.systemFont(ofSize: WH(10)), maxSize: CGSize.init(width:1000,height:200))
                    let labelWidth :CGFloat = labelSize.width
                    if(positionX + labelWidth > bgViewWidth)
                    {
                        positionX = 20;
                        positionY += 20;
                    }
                    let label = UILabel()
                    label.frame = CGRect.init(x: positionX, y: positionY, width: labelWidth, height: 20)
//                    label.lineBreakMode=NSLineBreakMode.byWordWrapping
//                    label.numberOfLines = 0
                    
                    positionX += labelWidth
                    
                    label.font = UIFont.systemFont(ofSize: WH(10))
                    label.textAlignment = .left
                    label.textColor = RGBColor(0x477ae9)
                    var str = ""
                    if(index == (vo.couponDtoShopList?.count)!-1){
                        str = model.tempEnterpriseName!
                    }else{
                        str = model.tempEnterpriseName! + "、 "
                    }
                    
                    let attributedString = NSMutableAttributedString(string: str)
                    let range = NSMakeRange(0, CFStringGetLength(model.tempEnterpriseName! as CFString?))
                    let value = NSNumber.init(value: Int8(NSUnderlineStyle.single.rawValue))
                    attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: value, range: range)
                    
                    label.attributedText = attributedString
                    label.isUserInteractionEnabled = true
                    label.bk_(whenTouches: 1, tapped: 1, handler: {
                        FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { vc in
                            let viewController = vc as! FKYNewShopItemViewController
                            viewController.shopId = model.tempEnterpriseId
                        })
                    })
                    self.useShopView.addSubview(label)
                }
                self.useShopViewHeight = positionY+40;
            }
            
            self.useShopView.isHidden = !vo.isShowUseShopList;
            if(vo.isShowUseShopList==true && vo.tempType == 1){
                self.useShopView.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(self.useShopViewHeight!))
                }
                self.bgView.snp.updateConstraints { (make) in
                    make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 0, bottom: WH(self.useShopViewHeight!), right: 0))
                }
            }else{
                self.useShopView.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(0))
                }
                self.bgView.snp.updateConstraints { (make) in
                    make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                }
            }
            self.layoutIfNeeded()
        }
        
        if let vo = model as? FKYReCheckCouponModel {
            if let items = vo.couponDtoShopList {
                for (index, value) in items.enumerated(){
                    let model :UseShopModel = UseShopModel.fromJSON((value as! NSDictionary) as! [String : AnyObject])
                    let labelSize :CGSize = getTextSize(text: model.tempEnterpriseName! + "、 ", font: UIFont.systemFont(ofSize: WH(10)), maxSize: CGSize.init(width:1000,height:200))
                    let labelWidth :CGFloat = labelSize.width
                    if(positionX + labelWidth > bgViewWidth)
                    {
                        positionX = 20;
                        positionY += 20;
                    }
                    let label = UILabel()
                    label.frame = CGRect.init(x: positionX, y: positionY, width: labelWidth, height: 20)
                    
                    positionX += labelWidth
                    
                    label.font = UIFont.systemFont(ofSize: WH(10))
                    label.textAlignment = .left
                    label.textColor = RGBColor(0x477ae9)
                    var str = ""
                    if(index == (vo.couponDtoShopList?.count)!-1){
                        str = model.tempEnterpriseName!
                    }else{
                        str = model.tempEnterpriseName! + "、 "
                    }
                    let attributedString = NSMutableAttributedString(string: str)
                    let range = NSMakeRange(0, CFStringGetLength(model.tempEnterpriseName! as CFString?))
                    let value = NSNumber.init(value: Int8(NSUnderlineStyle.single.rawValue))
                    attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: value, range: range)
                    
                    label.attributedText = attributedString
                    label.isUserInteractionEnabled = true
                    label.bk_(whenTouches: 1, tapped: 1, handler: {
                        FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { vc in
                            let viewController = vc as! FKYNewShopItemViewController
                            viewController.shopId = model.tempEnterpriseId
                        })
                    })
                    self.useShopView.addSubview(label)
                }
                self.useShopViewHeight = positionY+40;
            }
            self.useShopView.isHidden = !vo.isShowUseShopList;
            if(vo.isShowUseShopList==true && vo.tempType == 1){
                self.useShopView.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(self.useShopViewHeight!))
                }
                self.bgView.snp.updateConstraints { (make) in
                    make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 0, bottom: WH(self.useShopViewHeight!), right: 0))
                }
            }else{
                self.useShopView.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(0))
                }
                self.bgView.snp.updateConstraints { (make) in
                    make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                }
            }
            self.layoutIfNeeded()
        }
    
        let myMutableString = NSMutableAttributedString(string: denomination, attributes: nil)
        myMutableString.addAttribute(NSAttributedString.Key.font, value:UIFont.systemFont(ofSize: 14.0), range:NSRange(location:0,length:1))
        moneyLabel.attributedText = myMutableString
        
        // 交互按钮状态更新
        interactButton.fky_setStyle(withItemType: itemType, usageType: usageType!)
        
        // 过期状态
        if usageType == . MY_COUPON_LIST_OUTDATE || usageType == . MY_COUPON_LIST_USED || usageType == .USE_COUPON_DISABLED {
            setValidState(withState: false)
        } else {
            setValidState(withState: true)
        }
        
        
        
        if usageType == .MY_COUPON_LIST_ENABLED ||
            usageType == .MY_COUPON_LIST_USED ||
            usageType == .MY_COUPON_LIST_OUTDATE ||
            usageType == .USE_COUPON_ENABLED {
            moneyLabel.snp.updateConstraints { (make) in
                make.bottom.equalTo(bgView.snp.centerY).offset(WH(20))
            }
        } else {
            moneyLabel.snp.updateConstraints { (make) in
                make.bottom.equalTo(bgView.snp.centerY).offset(WH(8))
            }
        }
    }
    
    func getTextSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize {
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
    
    // MARK: - public methods
    func setValidState(withState state: Bool) {
        setOutDate(withState: !state)
        if state {
            bgImageView.image = UIImage.init(named: itemType == .shop ? "img_coupon_bg_orange" : "img_coupon_bg_red")
        } else {
            bgImageView.image = UIImage.init(named: "img_coupon_bg_gray")
        }
    }
    func setSelectedStatus(withState state: Bool) {
        setOutDate(withState: !state)
        if state {
            bgImageView.image = UIImage.init(named: itemType == .shop ? "img_coupon_bg_orange_selected" : "img_coupon_bg_red_selected")
        } else {
            bgImageView.image = UIImage.init(named: "img_coupon_bg_gray")
        }
    }
    @objc func detailDescLabelClick() {
        if let vo = model as? CouponModel {
            vo.isShowUseShopList = !vo.isShowUseShopList;
        }
        if let cvo = model as? FKYReCheckCouponModel {
            cvo.isShowUseShopList = !cvo.isShowUseShopList;
        }
    }
    
    /// 子类可覆载以下方法，设置非通用数据赋值及修改约束以满足业务场景
    func configSettings() {
        
    }
    
    // MARK: - ui
    
    /// 绘制优惠券通用ui
    fileprivate func __setupView() {
        addSubview(bgView)
        bgView.addSubview(bgImageView)
        bgView.addSubview(moneyLabel)
        bgView.addSubview(priceLimitLabel)
        bgView.addSubview(interactButton)
        bgView.addSubview(titleDescLabel)
        bgView.addSubview(timeLabel)
        bgView.addSubview(detailDescLabel)
        bgView.addSubview(subTitleDescLabel)
        addSubview(useShopView)
        
        
        moneyLabel.preferredMaxLayoutWidth = WH(60)
        titleDescLabel.preferredMaxLayoutWidth = WH(193)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            //make.height.equalTo(105)
            make.width.equalTo(WH(300))
        }
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(bgView)
        }

        moneyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(WH(10))
            make.bottom.equalTo(bgView.snp.centerY).offset(WH(8))
            make.width.equalTo(WH(86))
        }
        
        priceLimitLabel.snp.makeConstraints { (make) in
            make.left.equalTo(moneyLabel).offset(WH(-8))
            make.right.equalTo(moneyLabel).offset(WH(3))
            make.top.equalTo(moneyLabel.snp.bottom).offset(WH(-5))
        }
        
        interactButton.snp.makeConstraints { (make) in
            make.top.equalTo(priceLimitLabel.snp.bottom).offset(WH(2))
            make.left.equalTo(bgView).offset(WH(18))
            make.size.equalTo(CGSize.init(width: WH(63), height: WH(18)))
        }
        
        titleDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(moneyLabel.snp.right).offset(WH(20))
            make.bottom.equalTo(bgView.snp.centerY)
            make.right.equalTo(bgView).offset(WH(-15))
            make.top.equalTo(bgView).offset(WH(2))
        }
        
        timeLabel.snp.makeConstraints { (make) in
            //make.top.equalTo(bgView.snp.centerY).offset(WH(-5))
            make.top.equalTo(self.titleDescLabel.snp_bottom).offset(WH(-7))
            make.left.right.equalTo(titleDescLabel)
            
        }
        
        subTitleDescLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.timeLabel.snp_bottom).offset(WH(5))
            make.left.right.equalTo(titleDescLabel)
        }
        
        /*
        subTitleDescLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleDescLabel.snp_bottom).offset(WH(-7))
            make.left.right.equalTo(titleDescLabel)
        }
        */
        
        /*
        timeLabel.snp.makeConstraints { (make) in
            //make.top.equalTo(bgView.snp.centerY).offset(WH(-5))
            make.top.equalTo(self.subTitleDescLabel.snp_bottom).offset(WH(0))
            make.left.right.equalTo(titleDescLabel)
        }
        */
        
        detailDescLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleDescLabel)
            //make.top.equalTo(timeLabel.snp.bottom).offset(WH(2))
            make.top.equalTo(subTitleDescLabel.snp.bottom).offset(WH(5))
        }
        
        useShopView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.width.equalTo(300)
            make.height.equalTo(0)
            make.top.equalTo(bgView.snp.bottom)
            make.bottom.equalTo(self).offset(-10)
        }

    }
    
    // MARK: - private methods
    func setOutDate(withState state: Bool) {
        let textColor = state ? RGBColor(0x979797) : RGBColor(0x2a2928)
        titleDescLabel.textColor = textColor
        if (detailDescLabel.text == "查看可用商家") {
             detailDescLabel.textColor = RGBColor(0x487ae8)
        } else {
             detailDescLabel.textColor = textColor
            detailDescLabel.textColor = RGBColor(0x666666)
        }
    }
}

extension UIButton {
    func fky_setStyle(withItemType type: CouponItemType?, usageType: CouponItemUsageType) {
        guard (type != nil) else {
            return
        }
        self.isHidden = false
        switch usageType {
        case .PRODUCTDETAIL_GET_COUPON_RECEIVED,
              .CART_GET_COUPON_RECEIVED:
            self.setTitle("已领取", for: .normal)
            self.setTitleColor(RGBColor(type == .shop ? 0xffffff : 0xffbab7), for: .normal)
            self.backgroundColor = RGBColor(type == .shop ? 0xffab7c : 0xe2342b)
            self.isEnabled = false
        case .MY_COUPON_LIST_ENABLED:
            self.isHidden = true
        case .MY_COUPON_LIST_USED:
            self.isHidden = true
            self.setTitle("已使用", for: .normal)
            self.setTitleColor(RGBColor(type == .shop ? 0x5ac0de : 0xf95e58), for: .normal)
            self.backgroundColor = RGBColor(type == .shop ? 0x9dd7e8 : 0xffb2af)
            self.isEnabled = false
        case .MY_COUPON_LIST_OUTDATE:
            self.isHidden = true
            self.setTitle("已过期", for: .normal)
            self.setTitleColor(RGBColor(0xc5ccda), for: .normal)
            self.backgroundColor = RGBColor(0xffffff)
            self.isEnabled = false
        case .USE_COUPON_ENABLED:
            self.isHidden = true
        case .USE_COUPON_DISABLED:
            self.setTitle("不可使用", for: .normal)
            self.setTitleColor(RGBColor(0xc5ccda), for: .normal)
            self.backgroundColor = RGBColor(0xffffff)
            self.isEnabled = false
        case .PRODUCTDETAIL_GET_COUPON_RECEIVE,
             .CART_GET_COUPON_RECEIVE:
            self.setTitle("点击领取>", for: .normal)
            self.setTitleColor(RGBColor(type == .shop ? 0xff2d5c : 0xf95e58), for: .normal)
            self.backgroundColor = RGBColor(0xffffff)
            self.isEnabled = true
        }
    }
}
