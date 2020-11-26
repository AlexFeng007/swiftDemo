//
//  PDGroupBottomView.swift
//  FKY
//
//  Created by 夏志勇 on 2017/12/19.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  商详(搭配 or 固定)套餐之底部加车视图

import UIKit
import Foundation

typealias AddCart4GroupClosure = (_ group: FKYProductGroupModel?)->()

class PDGroupBottomView: UIView {
    // 上划线
    fileprivate lazy var viewLine: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    // 加车btn
    fileprivate lazy var btnCart: UIButton! = {
        // 自定义按钮背景图片
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFF2D5C), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        
        let button = UIButton()
        //button.backgroundColor = RGBColor(0xFF2D5C)
        button.backgroundColor = .clear
        button.setTitle("购买套餐", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.setTitleColor(RGBColor(0x999999), for: .disabled)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        button.titleLabel?.textAlignment = .center
        button.layer.masksToBounds = true
        button.layer.cornerRadius = WH(4)
        button.setBackgroundImage(imgNormal, for: .normal)
        button.setBackgroundImage(imgSelect, for: .highlighted)
        button.setBackgroundImage(imgDisable, for: .disabled)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.addCartCallback {
                closure(strongSelf.group)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // 套餐价lbl
    fileprivate lazy var lblPrice: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .left
//        lbl.text = "金额:"
//        lbl.adjustsFontSizeToFitWidth = true
//        lbl.minimumScaleFactor = 0.7
//        lbl.numberOfLines = 2
        return lbl
    }()
    
    // 已省lbl
    fileprivate lazy var lblSave: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .left
//        lbl.text = "已省:"
//        lbl.adjustsFontSizeToFitWidth = true
//        lbl.minimumScaleFactor = 0.7
//        lbl.numberOfLines = 2
        return lbl
    }()

    // 套餐相关数据
    var group: FKYProductGroupModel!
    
    // 套餐加车回调闭包
    var addCartCallback: AddCart4GroupClosure?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - setupView
    
    func setupView() {
        self.backgroundColor = RGBColor(0xF7F7F7)
        
        self.addSubview(self.viewLine)
        self.addSubview(self.btnCart)
        self.addSubview(self.lblPrice)
        self.addSubview(self.lblSave)
        
        self.viewLine.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        self.btnCart.snp.makeConstraints { (make) in
//            make.top.bottom.right.equalTo(self)
//            make.width.equalTo(SCREEN_WIDTH/3)
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(WH(-16))
            make.size.equalTo(CGSize.init(width: WH(200), height: WH(41)))
        }
        self.lblPrice.snp.makeConstraints { (make) in
//            make.top.bottom.equalTo(self)
//            make.left.equalTo(self).offset(WH(10))
            make.left.equalTo(self).offset(WH(17))
            make.right.equalTo(btnCart.snp.left).offset(WH(-5))
            make.bottom.equalTo(self).offset(WH(-15))
            make.height.equalTo(WH(20))
        }
        self.lblSave.snp.makeConstraints { (make) in
//            make.top.bottom.equalTo(self)
//            make.left.equalTo(self.lblPrice.snp.right).offset(WH(10))
//            make.right.equalTo(self.btnCart.snp.left).offset(WH(-10))
//            make.width.greaterThanOrEqualTo(SCREEN_WIDTH/3-5*WH(10))
            make.left.equalTo(self).offset(WH(17))
            make.right.equalTo(btnCart.snp.left).offset(WH(-5))
            make.bottom.equalTo(lblPrice.snp.top).offset(WH(-2))
            make.height.equalTo(WH(15))
        }
        
//        // 当冲突时，lblPrice不被压缩，lblSave可以被压缩
//        // 当前lbl抗压缩（不想变小）约束的优先级高 UILayoutPriority
//        self.lblPrice.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
//        // 当前lbl抗压缩（不想变小）约束的优先级低
//        self.lblSave.setContentCompressionResistancePriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)
    }
    
    func configView(_ group: FKYProductGroupModel) {
        // 保存套餐model
        self.group = group
        
        // 更新按钮状态
        self.updateAddCartStatus(group)
        // 更新金额
        self.updatePrice(group)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func updateTopLine(_ full: Bool) {
        if full {
            // 分隔线全屏
            self.viewLine.snp.updateConstraints { (make) in
                make.left.right.equalTo(self)
            }
        }
        else {
            // 分隔线左右有间距
            self.viewLine.snp.updateConstraints { (make) in
                make.left.equalTo(self).offset(WH(16))
                make.right.equalTo(self).offset(WH(-16))
            }
        }
        
        layoutIfNeeded()
    }
    
    
    //MARK: - Private
    
    // 更新金额
    fileprivate func updatePrice(_ group: FKYProductGroupModel) {
        var totalPrice: Double = 0   // 总金额
        var savePrice: Double = 0    // 节省金额
        var finalPrice: Double = 0   // 实付金额
        if let plist = group.productList, plist.count > 0 {
            for product in plist {
                if product.unselected == true {
                    // 未选中的商品不计入总价
                    continue
                }
                let count = product.getProductNumber() // 当前商品购买数量
                var price: Double! = 0   // 原价
                var save: Double! = 0    // 节省
                if let originPrice = product.originalPrice {
                    price = originPrice.doubleValue
                }
                if let discountMoney = product.discountMoney {
                    save = discountMoney.doubleValue
                }
                totalPrice += (price * Double(count))
                savePrice += (save * Double(count))
            } // for
        }
        finalPrice = (totalPrice - savePrice)
        
        //self.lblPrice.text = "金额:¥\(price)"
        //self.lblSave.text = "已省:¥\(save)"
        
        let strPrice = String.init(format: "¥ %.2f", finalPrice)
        let strSave = String.init(format: "¥ %.2f", savePrice)
        
        // 节省金额
        self.lblSave.text = "已省 \(strSave)"
        
        // 应付金额
//        let mStr = NSMutableAttributedString(string: "金额:\(strPrice)", attributes: [NSForegroundColorAttributeName:RGBColor(0xFE394E), NSFontAttributeName:UIFont.systemFont(ofSize: WH(18))])
//        mStr.addAttributes([NSForegroundColorAttributeName:RGBColor(0x222222)], range: NSMakeRange(0, 3))
//        mStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: WH(14))], range: NSMakeRange(0, 3))
//        mStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: WH(11))], range: NSMakeRange(3, 1))
        let mStr = NSMutableAttributedString(string: strPrice, attributes: [NSAttributedString.Key.foregroundColor:RGBColor(0xFF2D5C), NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(18))])
        mStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(14))], range: NSMakeRange(0, 1))
        self.lblPrice.attributedText = mStr
    }
    
    // 更新加车按钮
    fileprivate func updateAddCartStatus(_ group: FKYProductGroupModel) {
        // 默认不可加车
        var canSubmit = false
        // 单独针对固定套餐...<默认可加车>
        if let type = group.promotionRule, type == 2 {
            if let list = group.productList, list.count > 1 {
                canSubmit = true
            }
            else {
                canSubmit = false
            }
        }
        
        // 搭配套餐是否可加车逻辑
        if  let type = group.promotionRule, type == 1 {
            // 最新逻辑：主品必选，子品至少有一个选中时，才可加车 或者没有主品，子品必须至少有两个勾选才能加车
            if let plist = group.productList, plist.count > 0 {
                if plist.count > 1 {
                    //只要有两个品被勾选就能购买
                    var selectedNum = 0
                    for item in plist {
                        if item.unselected == false {
                            selectedNum = selectedNum+1
                        }
                    }
                    if selectedNum > 1 {
                        canSubmit = true
                    }
                }
                else {
                    // 无子品
                    canSubmit = false
                }
            }
        }
        if canSubmit {
            // 可加车
            self.btnCart.isEnabled = true
            self.btnCart.backgroundColor = RGBColor(0xFF394E)
        }
        else {
            // 不可加车
            self.btnCart.isEnabled = false
            self.btnCart.backgroundColor = RGBColor(0x999999)
        }
    }
}
