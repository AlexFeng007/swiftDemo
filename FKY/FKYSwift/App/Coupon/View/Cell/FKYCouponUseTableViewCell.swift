//
//  FKYCouponUseTableViewCell.swift
//  FKY
//
//  Created by yyc on 2020/2/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYCouponUseTableViewCell: UITableViewCell {
    // MARK: - Properties
    /// 优惠券背景图
    public lazy var bgImageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.bk_(whenTapped: { [weak self] in
            if let strongSelf = self {
                //选择优惠券
                if let block = strongSelf.clickInteractButtonBlock,strongSelf.clickType == 3 {
                    block(strongSelf.clickType)
                }
            }
        })
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
    
    /// 【店铺券】店铺名称、【平台去】使用限制描述
    public lazy var titleDescLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        label.textAlignment = .left
        label.textColor = RGBColor(0x333333)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
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
    
    // 交互按钮(可用商家or可用商品)
    public lazy var interactButton: UIButton! = {
        let button = UIButton()
        button.titleLabel?.font = t27.font
        button.setTitleColor(t73.color, for: .normal)
        button.backgroundColor = RGBColor(0xffffff)
        button.layer.cornerRadius = WH(4)
        button.layer.borderColor = t73.color.cgColor
        button.layer.borderWidth = WH(0.5)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            if let strongSelf = self {
                if let block = strongSelf.clickInteractButtonBlock{
                    block(strongSelf.clickType)
                }
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    // 选中按钮
    public lazy var selectedButton: UIButton! = {
        let button = UIButton()
        button.setImage(UIImage(named: "can_coupon_seleted_pic"), for: .selected)
        button.setImage(UIImage(named: "can_coupon_pic"), for: .normal)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            if let strongSelf = self {
                if let block = strongSelf.clickInteractButtonBlock{
                    block(strongSelf.clickType)
                }
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    //提示背景
    fileprivate lazy var tipBgView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFBFBFB)
        view.layer.cornerRadius = WH(8)
        view.layer.masksToBounds = true
        view.layer.borderWidth = WH(1)
        view.layer.borderColor = RGBColor(0xE9E9E9).cgColor
        return view
    }()
    //提示文字
    fileprivate lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.font = t3.font
        label.textColor = t3.color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    //可用商家列表
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(FKYShopNameInCouponTableViewCell.self, forCellReuseIdentifier: "FKYShopNameInCouponTableViewCell")
        tableView.backgroundColor = RGBColor(0xFBFBFB)
        return tableView
        }()
    
    //属性
    var clickInteractButtonBlock : ((_ typeIndex:Int)->(Void))?
    var shopModelArr:[UseShopModel] = [UseShopModel]() //可用商家的数组
    var clickType = 0 //记录点击的类型(1:可用商品,2:可用商家 3:选中与否)
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupView() {
        self.backgroundColor = RGBColor(0xFCFCFC)
        contentView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.height.equalTo(WH(106))
            make.left.equalTo(contentView.snp.left).offset(WH(14))
            make.right.equalTo(contentView.snp.right).offset(-WH(14))
            make.top.equalTo(contentView.snp.top)
        }
        bgImageView.addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgImageView.snp.left).offset(WH(4))
            make.top.equalTo(bgImageView.snp.top).offset(WH(27))
            make.width.equalTo(WH(100))
        }
        bgImageView.addSubview(priceLimitLabel)
        priceLimitLabel.snp.makeConstraints { (make) in
            make.height.equalTo(WH(12))
            make.left.equalTo(bgImageView.snp.left).offset(WH(4))
            make.top.equalTo(moneyLabel.snp.bottom).offset(WH(13))
            make.width.equalTo(WH(100))
        }
        
        bgImageView.addSubview(titleDescLabel)
        titleDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgImageView.snp.left).offset(WH(124))
            make.top.equalTo(bgImageView.snp.top).offset(WH(26))
            make.right.equalTo(bgImageView.snp.right).offset(-WH(20))
        }
        bgImageView.addSubview(interactButton)
        interactButton.snp.makeConstraints { (make) in
            make.height.equalTo(WH(24))
            make.width.equalTo(WH(65))
            make.bottom.equalTo(bgImageView.snp.bottom).offset(-WH(24))
            make.right.equalTo(bgImageView.snp.right).offset(-WH(19))
        }
        bgImageView.addSubview(selectedButton)
        selectedButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(WH(26))
            make.top.equalTo(bgImageView.snp.top).offset(WH(37))
            make.right.equalTo(bgImageView.snp.right).offset(-WH(19))
        }
        
        bgImageView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgImageView.snp.left).offset(WH(124))
            make.bottom.equalTo(bgImageView.snp.bottom).offset(-WH(20))
            make.right.equalTo(interactButton.snp.left).offset(-WH(10))
        }
        contentView.addSubview(tipBgView)
        tipBgView.snp.makeConstraints { (make) in
            make.height.equalTo(WH(0))
            make.left.equalTo(contentView.snp.left).offset(WH(16))
            make.right.equalTo(contentView.snp.right).offset(-WH(16))
            make.top.equalTo(bgImageView.snp.bottom).offset(-WH(21))
        }
        tipBgView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.height.equalTo(WH(12))
            make.left.equalTo(tipBgView.snp.left).offset(WH(13))
            make.right.equalTo(tipBgView.snp.right).offset(-WH(5))
            make.top.equalTo(tipBgView.snp.top).offset(WH(21+10))
        }
        tipBgView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(tipBgView)
            make.bottom.equalTo(tipBgView.snp.bottom).offset(-WH(4))
            make.top.equalTo(tipLabel.snp.bottom).offset(WH(2))
        }
        //背景图置于顶层
        contentView.bringSubviewToFront(bgImageView)
    }
}
extension FKYCouponUseTableViewCell {
    // MARK: - Data
    func configCouponViewCell(_ couponModel:FKYReCheckCouponModel,_ typeNum:Int,_ viewType:Int) {
        //默认隐藏一些属性
        self.interactButton.isHidden = true
        self.selectedButton.isHidden = true
        self.tipBgView.isHidden = true
        var tipBgView_h = WH(0) //提示和店铺列表的高度
        self.tableView.isHidden = true
        self.shopModelArr.removeAll()
        
        //赋值
        self.moneyLabel.text =  "¥\(couponModel.denomination)"
        self.moneyLabel.adjustPriceLabelWihtFont(UIFont.boldSystemFont(ofSize: WH(18)))
        self.priceLimitLabel.text = "满\(couponModel.limitprice)可用"
        self.timeLabel.text = couponModel.useTimeStr
        if viewType == 1 {
            titleDescLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(bgImageView.snp.left).offset(WH(124))
                make.top.equalTo(bgImageView.snp.top).offset(WH(26))
                make.right.equalTo(selectedButton.snp.left).offset(-WH(5))
            }
            //可用券视图
            self.selectedButton.isHidden = false
            self.clickType = 3
            if couponModel.isCheckCoupon == 1 {
                self.selectedButton.isSelected = true
            }else {
                self.selectedButton.isSelected = false
            }
            if typeNum == 0 {
                //店铺券
                self.titleDescLabel.text = couponModel.tempEnterpriseName
                if couponModel.isCheckCoupon == 1 {
                    self.bgImageView.image = UIImage.init(named:"oc_shop_coupon_bg_pic")
                }else {
                    self.bgImageView.image = UIImage.init(named:"oc_noCan_coupon_bg_pic")
                }
            }else {
                //平台券
                self.titleDescLabel.text = couponModel.tempEnterpriseName
                if couponModel.isCheckCoupon == 1 {
                    self.bgImageView.image = UIImage.init(named:"oc_platform_coupon_bg_pic")
                }else {
                    self.bgImageView.image = UIImage.init(named:"oc_noCan_coupon_bg_pic")
                }
            }
        }else {
            titleDescLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(bgImageView.snp.left).offset(WH(124))
                make.top.equalTo(bgImageView.snp.top).offset(WH(26))
                make.right.equalTo(bgImageView.snp.right).offset(-WH(20))
            }
            //不可用券视图
            self.bgImageView.image = UIImage.init(named:"oc_noCan_coupon_bg_pic")
            tipBgView_h = tipBgView_h + WH(21+10+12+7)
            self.tipBgView.isHidden = false
            self.tipLabel.textColor = t3.color
            self.tipLabel.text = couponModel.noCheckReason
            if typeNum == 0 {
                //店铺券
                self.titleDescLabel.text = couponModel.tempEnterpriseName
                //由于不满金额导致不可使用时，才展示按钮
                if couponModel.lessMoneyStyleType == 1 {
                    self.tipLabel.textColor = t73.color
                    self.interactButton.setTitle("可用商品", for: .normal)
                    self.interactButton.isHidden = false
                    
                }
                self.clickType = 1
            }else {
                //平台券
                self.titleDescLabel.text = couponModel.tempEnterpriseName
                self.clickType = 2
                if couponModel.lessMoneyStyleType == 1 {
                    self.tipLabel.textColor = t73.color
                }
                if let arr = couponModel.couponDtoShopList as? [UseShopModel] ,arr.count > 0 {
                    //店铺数量大于0，并且是由于不满金额导致不可使用时，才展示按钮
                    if couponModel.lessMoneyStyleType == 1 {
                        self.interactButton.setTitle("可用商家", for: .normal)
                        self.interactButton.isHidden = false
                    }
                    self.shopModelArr = arr
                    if couponModel.isShowUseShopList == true {
                        //展示商家列表
                        tipBgView_h = tipBgView_h + WH(24)*CGFloat(arr.count) + WH(4)
                        self.tableView.isHidden = false
                    }
                }
            }
        }
        tipBgView.snp.updateConstraints() { (make) in
            make.height.equalTo(tipBgView_h)
        }
        self.tableView.reloadData()
    }
    static func getCouponCellHeight(_ couponModel:FKYReCheckCouponModel,_ typeNum:Int,_ viewType:Int) -> CGFloat {
        var cell_h = WH(106)
        let onlyTipH = WH(21+10+12+7)
        if viewType == 1 {
            //可用券
        }else {
            //不可用券
            cell_h = cell_h+onlyTipH
            if typeNum == 1 {
                if let arr = couponModel.couponDtoShopList as? [UseShopModel] ,arr.count > 0 {
                    if couponModel.isShowUseShopList == true {
                        //展示商家列表
                        cell_h = cell_h + WH(24)*CGFloat(arr.count) + WH(4)
                    }
                }
            }
        }
        return cell_h
    }
}
extension FKYCouponUseTableViewCell: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shopModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FKYShopNameInCouponTableViewCell(style: .default, reuseIdentifier: "FKYShopNameInCouponTableViewCell")
        if indexPath.row < self.shopModelArr.count {
            let model = self.shopModelArr[indexPath.row]
            cell.configshopNameViewCell(model.tempEnterpriseName ?? "")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(24)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.shopModelArr.count {
            let model = self.shopModelArr[indexPath.row]
            FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { vc in
                let viewController = vc as! FKYNewShopItemViewController
                viewController.shopId = model.tempEnterpriseId
            })
        }
    }
}
