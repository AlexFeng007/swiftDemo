//
//  FKYComCouponTableViewCell.swift
//  FKY
//
//  Created by hui on 2019/8/26.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYComCouponTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    /// 优惠券背景图
    public lazy var bgImageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    /// 金额
    public lazy var moneyLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(30))
        label.minimumScaleFactor = 0.2
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = RGBColor(0xffffff)
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
    ///是否领取了优惠券
    public lazy var getImageView: UIImageView! = {
        let imageView = UIImageView()
        return imageView
    }()
    
    /// 【店铺券】店铺名称、【平台去】使用限制描述
    public lazy var titleDescLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        label.textAlignment = .left
        label.textColor = RGBColor(0x333333)
        label.numberOfLines = 2
        return label
    }()
    
    /// 优惠券使用限制商品描述
    public lazy var subTitleDescLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(11))
        label.textAlignment = .left
        label.textColor = RGBColor(0x666666)
        label.numberOfLines = 1
        return label
    }()
    
    /// 时间限制
    public lazy var timeLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.init(name: "Helvetica", size: WH(11))
        label.textAlignment = .left
        label.textColor = RGBColor(0x666666)
        return label
    }()
    
    /// 交互按钮
    public lazy var interactButton: UIButton! = {
        let button = UIButton()
        button.titleLabel?.font = t27.font
        button.layer.cornerRadius = WH(4)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            if let strongSelf = self {
                if let block = strongSelf.clickInteractButtonBlock{
                    block(strongSelf.clickType)
                }
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = RGBColor(0xFBFBFB)
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = WH(8)
        tableView.layer.masksToBounds = true
        tableView.layer.borderWidth = WH(1)
        tableView.layer.borderColor = RGBColor(0xE9E9E9).cgColor
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(39)))
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
        tableView.register(FKYShopNameInCouponTableViewCell.self, forCellReuseIdentifier: "FKYShopNameInCouponTableViewCell")
        
        return tableView
        }()
    
    //属性
    var clickInteractButtonBlock : ((_ typeInde:Int)->(Void))?
    var shopModelArr:[UseShopModel]? //可用商家的数组
    var clickType = 0 //记录点击的类型(1:可用商品,2:立即领取,3:可用商家)
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    
    func setupView() {
        self.backgroundColor = .white
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(getImageView)
        bgImageView.addSubview(moneyLabel)
        bgImageView.addSubview(priceLimitLabel)
        bgImageView.addSubview(subTitleDescLabel)
        bgImageView.addSubview(titleDescLabel)
        bgImageView.addSubview(interactButton)
        bgImageView.addSubview(timeLabel)
        contentView.addSubview(tableView)
        
        bgImageView.snp.makeConstraints { (make) in
            make.height.equalTo(WH(109))
            make.left.equalTo(contentView.snp.left).offset(WH(10))
            make.right.equalTo(contentView.snp.right).offset(-WH(10))
            make.top.equalTo(contentView.snp.top)
        }
        
        moneyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgImageView.snp.left).offset(WH(4))
            make.top.equalTo(bgImageView.snp.top).offset(WH(27))
            make.width.equalTo(WH(100))
        }
        
        priceLimitLabel.snp.makeConstraints { (make) in
            make.height.equalTo(WH(12))
            make.left.equalTo(bgImageView.snp.left).offset(WH(4))
            make.top.equalTo(moneyLabel.snp.bottom).offset(WH(13))
            make.width.equalTo(WH(100))
        }
        
        getImageView.snp.makeConstraints { (make) in
            make.right.equalTo(bgImageView.snp.right).offset(-WH(17))
            make.top.equalTo(bgImageView.snp.top).offset(WH(2))
            make.width.equalTo(WH(70))
            make.height.equalTo(WH(50))
        }
        
        titleDescLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.top).offset(WH(24))
            make.left.equalTo(bgImageView.snp.left).offset(WH(124))
            make.right.equalTo(bgImageView.snp.right).offset(-WH(5))
        }
        
        subTitleDescLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleDescLabel.snp_bottom).offset(WH(5))
            make.left.equalTo(titleDescLabel)
            make.right.equalTo(bgImageView.snp.right).offset(-WH(5))
        }
        
        interactButton.snp.makeConstraints { (make) in
            make.height.equalTo(WH(24))
            make.width.equalTo(WH(65))
            make.right.equalToSuperview().offset(WH(-23))
            make.bottom.equalTo(bgImageView.snp.bottom).offset(WH(-20))
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgImageView.snp.left).offset(WH(124))
            make.centerY.equalTo(interactButton.snp.centerY)
            make.right.equalTo(interactButton.snp.left).offset(-WH(10))
        }
        
        tableView.snp.makeConstraints { (make) in
            make.height.equalTo(WH(0))
            make.left.equalTo(contentView.snp.left).offset(WH(16))
            make.right.equalTo(contentView.snp.right).offset(-WH(16))
            make.top.equalTo(bgImageView.snp.bottom).offset(-WH(21))
        }
        
        //背景图置于顶层
        self.bringSubviewToFront(bgImageView)
    }
}
extension FKYComCouponTableViewCell {
    // MARK: - Data
    func configCouponViewCell(_ couponModel:CommonCouponNewModel) {
        //
        getImageView.isHidden = true
        interactButton.isHidden = true
        interactButton.setTitleColor(RGBColor(0x333333), for: .normal)
        interactButton.backgroundColor = RGBColor(0xffffff)
        interactButton.layer.borderWidth = WH(1)
        interactButton.layer.borderColor = RGBColor(0xCCCCCC).cgColor
        
        var tableView_h = WH(0)
        moneyLabel.text = "¥\(couponModel.denomination ?? 0)"
        // 对价格大小调整
        if let priceStr = moneyLabel.text,priceStr.contains("¥") {
            let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
            priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(18))], range: NSMakeRange(0, 1))
            moneyLabel.attributedText = priceMutableStr
        }
        priceLimitLabel.text = "满\(couponModel.limitprice ?? 0)可用"
        //优惠券时间
        if let beginStr = couponModel.begindate,beginStr.count > 0, let endStr = couponModel.endDate ,endStr.count > 0 {
            timeLabel.text = "\(beginStr)-\(endStr)"
        }else {
            timeLabel.text = couponModel.couponTimeText
        }
        if couponModel.tempType == 0 {
            //店铺券
            let limitDesc = "可购买该店铺内的指定商品"
            let unLimitDesc = "可购买该店铺内的任意商品"
            titleDescLabel.text = couponModel.isLimitProduct == 0 ? unLimitDesc : limitDesc
            bgImageView.image = UIImage.init(named: "shop_coupon_bg_pic")
            if couponModel.received == true {
                //已领取
                getImageView.image = UIImage.init(named: "coupon_get_pic")
                getImageView.isHidden = false
                interactButton.setTitle("可用商品", for: .normal)
                self.clickType = 1
                interactButton.isHidden = false
            }else {
                //未领取
                getImageView.image = UIImage.init(named: "")
                interactButton.setTitleColor(RGBColor(0xffffff), for: .normal)
                interactButton.backgroundColor = RGBColor(0xFF8C30)
                interactButton.layer.borderWidth = WH(0)
                interactButton.setTitle("立即领取", for: .normal)
                self.clickType = 2
                interactButton.isHidden = false
            }
        }else{
            //平台券
            let limitTitle = "1药城平台通用券"
            let unLimitTitle = "全平台通用"
            titleDescLabel.text = couponModel.isLimitShop == 0 ? unLimitTitle : limitTitle
            bgImageView.image = UIImage.init(named: "platform_coupon_bg_pic")
            getImageView.image = UIImage.init(named: "coupon_get_pic")
            getImageView.isHidden = false
            interactButton.setTitle("可用商家", for: .normal)
            self.clickType = 3
            if let shopArr = couponModel.couponDtoShopList,shopArr.count > 0  {
                interactButton.isHidden = false
                if couponModel.showShopNameList == true {
                    self.shopModelArr = shopArr
                    tableView.reloadData()
                    tableView_h = WH(39+10)+WH(24)*CGFloat(shopArr.count)
                }
            }
        }
        subTitleDescLabel.text = couponModel.couponDescribe
        if let str = subTitleDescLabel.text , str.count > 0 {
            titleDescLabel.snp.updateConstraints { (make) in
                make.top.equalTo(bgImageView.snp.top).offset(WH(21))
            }
            interactButton.snp.updateConstraints { (make) in
                make.bottom.equalTo(bgImageView.snp.bottom).offset(WH(-20))
            }
        }else {
            titleDescLabel.snp.updateConstraints { (make) in
                make.top.equalTo(bgImageView.snp.top).offset(WH(24))
            }
            interactButton.snp.updateConstraints { (make) in
                make.bottom.equalTo(bgImageView.snp.bottom).offset(WH(-23))
            }
        }
        tableView.snp.updateConstraints() { (make) in
            make.height.equalTo(tableView_h)
        }
    }
    static func getCouponCellHeight(_ couponModel:CommonCouponNewModel) -> CGFloat {
        var cell_h = WH(109)
        if couponModel.showShopNameList == true ,let shopArr = couponModel.couponDtoShopList,shopArr.count > 0 {
            cell_h = cell_h + WH(39-21+10) + WH(24)*CGFloat(shopArr.count) + WH(8)
        }
        return cell_h
    }
}
extension FKYComCouponTableViewCell: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = self.shopModelArr{
            return arr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FKYShopNameInCouponTableViewCell(style: .default, reuseIdentifier: "FKYShopNameInCouponTableViewCell")
        if let model = self.shopModelArr?[indexPath.row] {
            cell.configshopNameViewCell(model.tempEnterpriseName ?? "")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(24)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.shopModelArr?[indexPath.row] {
            FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { vc in
                let viewController = vc as! FKYNewShopItemViewController
                viewController.shopId = model.tempEnterpriseId
            })
        }
    }
}
//MARk:直播间优惠券
extension FKYComCouponTableViewCell{
    func configLiveCouponViewCell(_ couponModel:CommonCouponNewModel) {
        //重新设置约束
        bgImageView.snp.makeConstraints { (make) in
            make.height.equalTo(WH(109))
            make.left.equalTo(self.snp.left).offset(WH(8))
            make.right.equalTo(self.snp.right).offset(-WH(8))
            make.top.equalTo(self.snp.top)
        }
        moneyLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(bgImageView.snp.left).offset(WH(4))
            make.top.equalTo(bgImageView.snp.top).offset(WH(28))
            make.width.equalTo(WH(100))
            make.height.equalTo(WH(22))
        }
        
        priceLimitLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(WH(12))
            make.left.equalTo(bgImageView.snp.left).offset(WH(4))
            make.top.equalTo(moneyLabel.snp.bottom).offset(WH(17))
            make.width.equalTo(WH(100))
        }
        //
        subTitleDescLabel.isHidden = true
        getImageView.isHidden = true
        interactButton.isHidden = true
        interactButton.layer.cornerRadius = WH(12)
        interactButton.isUserInteractionEnabled = true
        
        //var tableView_h = WH(0)
        moneyLabel.text = "¥\(couponModel.denomination ?? 0)"
        // 对价格大小调整
        moneyLabel.adjustPriceLabelWihtFont(UIFont.boldSystemFont(ofSize: WH(18)))
        priceLimitLabel.text = "满\(couponModel.limitprice ?? 0)可用"
        priceLimitLabel.textColor = RGBColor(0x666666)
        subTitleDescLabel.font = t3.font
        //优惠券时间
        timeLabel.textColor = RGBColor(0x999999)
        if let beginStr = couponModel.begindate,beginStr.count > 0, let endStr = couponModel.endDate ,endStr.count > 0 {
            timeLabel.text = "\(beginStr)-\(endStr)"
        }else {
            timeLabel.text = couponModel.couponTimeText
        }
        if couponModel.tempType == 0 {
            //店铺券
            interactButton.snp.updateConstraints { (make) in
                make.bottom.equalTo(bgImageView.snp.bottom).offset(-WH(19))
            }
            moneyLabel.textColor = RGBColor(0xFF832C)
            
            //优惠券描述
            subTitleDescLabel.isHidden = false
            if couponModel.couponDescribe.count > 0 {
                subTitleDescLabel.text = couponModel.couponDescribe
            }else {
                let limitDesc = "可购买该店铺内的指定商品"
                let unLimitDesc = "可购买该店铺内的任意商品"
                subTitleDescLabel.text = couponModel.isLimitProduct == 0 ? unLimitDesc : limitDesc
            }
                                    
            //标题
            if couponModel.isLimitProduct == 0 {
                //是否限制商品，0-不限制 1或者2-限制
                titleDescLabel.attributedText =   FKYCouponTagManager.shareInstance.getCouponsTagAttributedString(tagName: "店铺券", tableColor: RGBColor(0xFF832C), type: 1, coupStr: couponModel.tempEnterpriseName ?? "")
            }else {
                titleDescLabel.attributedText =   FKYCouponTagManager.shareInstance.getCouponsTagAttributedString(tagName: "店铺商品券", tableColor: RGBColor(0xFF832C), type: 2, coupStr: couponModel.tempEnterpriseName ?? "")
            }
            //重置约束
            if let attriStr = titleDescLabel.attributedText {
                let title_h = attriStr.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(161), height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size.height
                if title_h > WH(18) {
                    //大于两行
                    titleDescLabel.snp.remakeConstraints { (make) in
                        make.top.equalTo(bgImageView.snp.top).offset(WH(12))
                        make.left.equalTo(bgImageView.snp.left).offset(WH(124))
                        make.right.equalTo(bgImageView.snp.right).offset(-WH(21))
                    }
                    subTitleDescLabel.snp.remakeConstraints { (make) in
                        make.top.equalTo(self.titleDescLabel.snp_bottom).offset(WH(8))
                        make.left.equalTo(titleDescLabel)
                        make.right.equalTo(bgImageView.snp.right).offset(-WH(10))
                    }
                    timeLabel.snp.updateConstraints { (make) in
                        make.left.equalTo(bgImageView.snp.left).offset(WH(124))
                        make.centerY.equalTo(interactButton.snp.centerY).offset(WH(3))
                    }
                    interactButton.snp.updateConstraints { (make) in
                        make.bottom.equalTo(bgImageView.snp.bottom).offset(WH(-13))
                    }
                }else {
                    //1行
                    titleDescLabel.snp.remakeConstraints { (make) in
                        make.top.equalTo(bgImageView.snp.top).offset(WH(21))
                        make.left.equalTo(bgImageView.snp.left).offset(WH(124))
                        make.right.equalTo(bgImageView.snp.right).offset(-WH(21))
                    }
                    subTitleDescLabel.snp.remakeConstraints { (make) in
                        make.top.equalTo(self.titleDescLabel.snp_bottom).offset(WH(11))
                        make.left.equalTo(titleDescLabel)
                        make.right.equalTo(bgImageView.snp.right).offset(-WH(10))
                    }
                    timeLabel.snp.updateConstraints { (make) in
                        make.left.equalTo(bgImageView.snp.left).offset(WH(124))
                        make.centerY.equalTo(interactButton.snp.centerY).offset(WH(1))
                    }
                    interactButton.snp.updateConstraints { (make) in
                        make.bottom.equalTo(bgImageView.snp.bottom).offset(WH(-14-6))
                    }
                }
            }
            bgImageView.image = UIImage.init(named: "live_shop_coupon_bg_pic")
            if couponModel.received == true {
                //已领取
                getImageView.isHidden = false
                getImageView.image = UIImage.init(named: "live_shop_get_pic")
                getImageView.snp.remakeConstraints { (make) in
                    make.right.equalTo(bgImageView.snp.right).offset(-WH(8))
                    make.top.equalTo(bgImageView.snp.top).offset(-WH(13))
                    make.width.equalTo(WH(56.4))
                    make.height.equalTo(WH(56.6))
                }
                interactButton.setTitle("可用商品", for: .normal)
                interactButton.setTitleColor(RGBColor(0xFF832C), for: .normal)
                interactButton.backgroundColor = RGBColor(0xffffff)
                interactButton.layer.borderColor = RGBColor(0xFF832C).cgColor
                interactButton.layer.borderWidth = WH(1)
                
                self.clickType = 1
                interactButton.isHidden = false
            }else {
                //未领取
                interactButton.setTitle("立即领取", for: .normal)
                interactButton.setTitleColor(RGBColor(0xffffff), for: .normal)
                interactButton.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xFF6827), RGBColor(0xFFAD63), WH(65))
                interactButton.layer.borderWidth = WH(0)
                
                self.clickType = 2
                interactButton.isHidden = false
            }
        }else{
            if couponModel.couponDescribe.count > 0 {
                subTitleDescLabel.text = couponModel.couponDescribe
                subTitleDescLabel.isHidden = false
                //重新设置titleDescLabel属性
                titleDescLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(bgImageView.snp.top).offset(WH(21))
                    make.left.equalTo(bgImageView.snp.left).offset(WH(124))
                    make.right.equalTo(bgImageView.snp.right).offset(-WH(21))
                }
                subTitleDescLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.titleDescLabel.snp_bottom).offset(WH(11))
                    make.left.equalTo(titleDescLabel)
                    make.right.equalTo(bgImageView.snp.right).offset(-WH(10))
                }
                timeLabel.snp.updateConstraints { (make) in
                    make.left.equalTo(bgImageView.snp.left).offset(WH(124))
                    make.centerY.equalTo(interactButton.snp.centerY).offset(WH(1))
                }
                interactButton.snp.updateConstraints { (make) in
                    make.bottom.equalTo(bgImageView.snp.bottom).offset(WH(-14-6))
                }
            }else {
                //重新设置titleDescLabel属性
                titleDescLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(bgImageView.snp.top).offset(WH(26))
                    make.left.equalTo(bgImageView.snp.left).offset(WH(124))
                    make.right.equalTo(bgImageView.snp.right).offset(-WH(21))
                }
                timeLabel.snp.updateConstraints { (make) in
                    make.left.equalTo(bgImageView.snp.left).offset(WH(124))
                    make.centerY.equalTo(interactButton.snp.centerY).offset(WH(1))
                }
                interactButton.snp.updateConstraints { (make) in
                    make.bottom.equalTo(bgImageView.snp.bottom).offset(WH(-19-6))
                }
            }
            
            //平台券
            moneyLabel.textColor = RGBColor(0xFF2D5C)
            if  couponModel.isLimitShop == 0 {
                let unLimitTitle = "全平台通用"
                titleDescLabel.attributedText =   FKYCouponTagManager.shareInstance.getCouponsTagAttributedString(tagName: "平台券", tableColor: RGBColor(0xFF2D5C), type: 3, coupStr: unLimitTitle)
            }else {
                let limitTitle = "1药城平台通用券"
                titleDescLabel.attributedText =   FKYCouponTagManager.shareInstance.getCouponsTagAttributedString(tagName: "平台券", tableColor: RGBColor(0xFF2D5C), type: 3, coupStr: limitTitle)
            }
            bgImageView.image = UIImage.init(named: "live_platform_bg_pic")
            if couponModel.received == true {
                getImageView.snp.remakeConstraints { (make) in
                    make.right.equalTo(bgImageView.snp.right).offset(-WH(8))
                    make.top.equalTo(bgImageView.snp.top).offset(-WH(10))
                    make.width.equalTo(WH(56.4))
                    make.height.equalTo(WH(56.6))
                }
                getImageView.isHidden = false
                getImageView.image = UIImage.init(named: "live_platform_get_pic")
                //                if let shopArr = couponModel.couponDtoShopList,shopArr.count > 0  {
                //                    interactButton.setTitle("可用商家", for: .normal)
                //                    interactButton.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
                //                    interactButton.backgroundColor = RGBColor(0xffffff)
                //                    interactButton.layer.borderColor = RGBColor(0xFF2D5C).cgColor
                //                    interactButton.layer.borderWidth = WH(1)
                //                    self.clickType = 3
                //                    interactButton.isHidden = false
                //                    if couponModel.showShopNameList == true {
                //                        self.shopModelArr = shopArr
                //                        tableView.reloadData()
                //                        tableView_h = WH(39+10)+WH(24)*CGFloat(shopArr.count)
                //                    }
                //                }
            }else {
                interactButton.setTitle("立即领取", for: .normal)
                interactButton.setTitleColor(RGBColor(0xffffff), for: .normal)
                interactButton.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xFF2D5C), RGBColor(0xFF5A9B), WH(65))
                interactButton.layer.borderWidth = WH(0)
                
                self.clickType = 2
                interactButton.isHidden = false
            }
        }
        //        tableView.snp.updateConstraints() { (make) in
        //            make.height.equalTo(tableView_h)
        //        }
    }
    static func getLiveCouponCellHeight(_ couponModel:CommonCouponNewModel) -> CGFloat {
        var cell_h = WH(109+2)
        if couponModel.showShopNameList == true ,let shopArr = couponModel.couponDtoShopList,shopArr.count > 0 {
            cell_h = cell_h + WH(39-21+10) + WH(24)*CGFloat(shopArr.count) + WH(8)
        }
        return cell_h
    }
}
