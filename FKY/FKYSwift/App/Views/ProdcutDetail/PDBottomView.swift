//
//  PDBottomView.swift
//  FKY
//
//  Created by mahui on 16/8/30.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  商详之底部加车视图

import Foundation
import SnapKit
import RxSwift

typealias IntClosure = (Int)->()
typealias addCarClosure = (Int,Int)->()
typealias addCarAction = ()->()
typealias VoidClosure = ()->()
typealias ConfigBlcok = (_ model : FKYProductObject)->()

// 底部控件布局样式
@objc
enum PDBottomLayoutType: Int {
    case UnLogin = 1         // 未登录
    case UnLoginAndNoContact = 2         // 未登录并且没有小能
    case CantCartWithStockOut = 3        // 不可购买因为缺货
    case CantCartWithStockOutAndNoContact = 4        // 不可购买因为缺货并且没有小能
    case CantCartWithOther = 5      // 不可购买除缺货
    case CantCartWithOtherAndNoContact = 6      // 不可购买除缺货并且没有小能
    case ContactAndCart = 7 // 小能 & 加车
    case NoContactAndTip = 8   // 加车
}

@objc
enum PDBottomButtonType: Int {
    case ShopType = 0      // 店铺按钮
    case CartType = 1         // 购物车按钮
    case ContactType = 2          // 联系按钮
}


@objc
class PDBottomView: UIView {
    //MARK: - Property
    // 客服...<联系供应商>
    fileprivate lazy var contactBtn: PDContactShopView = {
        let button = PDContactShopView()
        button.setButtonType(.ContactType)
        button.clickContactView  = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.endEditing(true)
            if let closure = strongSelf.settingClosure {
                closure()
            }
        }
        return button
    }()
    
    // 店铺进入店铺
    fileprivate lazy var shopBtn: PDContactShopView = {
        let button = PDContactShopView()
        button.setButtonType(.ShopType)
        button.clickContactView  = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.endEditing(true)
            if let closure = strongSelf.jumpToShopDetail {
                closure()
            }
        }
        return button
    }()
    
    // 购物车
    @objc public lazy var cartBtn: PDContactShopView = {
        let button = PDContactShopView()
        button.setButtonType(.CartType)
        button.clickContactView  = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.endEditing(true)
            if let closure = strongSelf.jumpToCart {
                closure()
            }
        }
        return button
    }()
    
    
    
    // 按钮背景 加入购物车 下单
    fileprivate lazy var buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFEDE7)
        view.layer.borderWidth = WH(1)
        view.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        view.layer.cornerRadius = WH(4)
        view.layer.masksToBounds = true
        return view
    }()
    
    
    fileprivate lazy var addCartBrn: UIButton = {
        let button = UIButton()
        button.setTitle("加入购物车", for: UIControl.State())
        //  button.setAttributedTitle(attStr, for: UIControl.State())
        button.titleLabel?.font = t17.font
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = RGBColor(0xFF2D5C)
        button.setTitleColor(UIColor.white, for:.normal)
        button.setTitleColor(RGBAColor(0xFFFFFF, alpha: 0.4), for:.disabled)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.6
        //        button.layer.masksToBounds = true
        //        button.layer.cornerRadius = WH(4)
        // 加入购物车
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.addCartAction {
                closure()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    fileprivate lazy var orderSetBtn: UIButton = {
        let button = UIButton()
        button.setTitle("立即下单", for: UIControl.State())
        button.titleLabel?.font = t17.font
        button.backgroundColor = RGBColor(0xFFEDE7)
        button.setTitleColor(RGBColor(0xFF2D5C), for:.normal)
        button.setTitleColor(RGBAColor(0xFF2D5C, alpha: 0.4), for:.disabled)
        //        button.layer.masksToBounds = true
        //        button.layer.cornerRadius = WH(4)
        // 立即下单
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.addOrderClosure {
                closure()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    fileprivate lazy var stockOutBtn: UIButton = {
        let button = UIButton()
        button.setTitle("到货通知", for: UIControl.State())
        button.titleLabel?.font = t17.font
        button.backgroundColor = RGBColor(0xFFEDE7)
        button.setTitleColor(RGBColor(0xFF2D5C), for:.normal)
        button.setTitleColor(RGBAColor(0xFF2D5C, alpha: 0.4), for:.disabled)
        //        button.layer.masksToBounds = true
        //        button.layer.cornerRadius = WH(4)
        // "到货通知
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickAlertClosure {
                closure(1)
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    //
    //
    //    // 不可购买之缺少经营范围...<不可购买，且商详statusDesc=2>
    //    fileprivate lazy var btnUpdate: UIButton = {
    //        // 自定义按钮背景图片
    //        let imgNormal = UIImage.imageWithColor(RGBColor(0xFF2D5C), size: CGSize.init(width: 2, height: 2))
    //        let imgSelect = UIImage.imageWithColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), size: CGSize.init(width: 2, height: 2))
    //        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
    //
    //        let button = UIButton()
    //        button.backgroundColor = .clear
    //        button.setTitle("去更新经营范围", for: UIControl.State())
    //        button.setTitleColor(UIColor.white, for: .normal)
    //        button.setTitleColor(UIColor.gray, for: .highlighted)
    //        button.setTitleColor(RGBColor(0x999999), for: .disabled)
    //        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
    //        button.titleLabel?.textAlignment = .center
    //        button.layer.masksToBounds = true
    //        button.layer.cornerRadius = WH(4)
    //        button.setBackgroundImage(imgNormal, for: .normal)
    //        button.setBackgroundImage(imgSelect, for: .highlighted)
    //        button.setBackgroundImage(imgDisable, for: .disabled)
    //        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
    //            guard let strongSelf = self else {
    //                return
    //            }
    //            strongSelf.endEditing(true)
    //            if let closure = strongSelf.jumpToUpdateBlock {
    //                closure()
    //            }
    //        }, onError: nil, onCompleted: nil, onDisposed: nil)
    //        return button
    //    }()
    
    
    // block
    //@objc var showCountClosure: IntClosure?       //
    @objc var addOrderClosure: emptyClosure?      // 立即下单
    @objc var addCartAction: addCarAction?        //
    @objc var clickAlertClosure : IntClosure?     // 到货通知
    @objc var toastClosure: SingleStringClosure?  //
    @objc var settingClosure: VoidClosure?        //
    @objc var addCartBlock: emptyClosure?         // 加车
    @objc var cartNumChangedBlock: emptyClosure?  //
    @objc var jumpToUpdateBlock: VoidClosure?     // 跳转到个人中心之经营范围
    @objc var jumpToCart: VoidClosure?     // 跳转到购物车
    @objc var jumpToShopDetail: VoidClosure?     // 跳转到店铺内
    
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = bg1
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - UI
    
    fileprivate func setupView() {
        //店铺
        addSubview(shopBtn)
        shopBtn.isHidden = true
        shopBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(WH(10))
            make.height.equalTo(WH(43))
            make.width.equalTo(WH(45))
        })
        
        // 小能
        addSubview(contactBtn)
        contactBtn.isHidden = true
        contactBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(shopBtn.snp.right)
            make.height.equalTo(WH(43))
            make.width.equalTo(WH(45))
        })
        
        //购物车
        addSubview(cartBtn)
        cartBtn.isHidden = true
        cartBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(shopBtn.snp.right).offset(WH(45))
            make.height.equalTo(WH(43))
            make.width.equalTo(WH(45))
        })
        
        //
        addSubview(buttonView)
        buttonView.isHidden = true
        buttonView.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(cartBtn.snp.right).offset(WH(10))
            make.right.equalTo(self).offset(WH(-10))
            make.height.equalTo(WH(43))
        })
        
        //立即下单
        buttonView.addSubview(orderSetBtn)
        orderSetBtn.isHidden = true
        orderSetBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(buttonView).offset(WH(1))
            make.right.equalTo(buttonView.snp.centerX)
            make.height.equalTo(WH(41))
        })
        //进入购物车
        buttonView.addSubview(addCartBrn)
        addCartBrn.isHidden = true
        addCartBrn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(buttonView).offset(WH(-1))
            make.left.equalTo(buttonView.snp.centerX)
            make.height.equalTo(WH(41))
        })
        //到货通知
        buttonView.addSubview(stockOutBtn)
        stockOutBtn.isHidden = true
        stockOutBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(buttonView).offset(WH(-1))
            make.left.equalTo(buttonView).offset(WH(1))
            make.height.equalTo(WH(41))
        })
        
        
    }
    
    
    // MARK: - Public
    
    // 绑定model
    @objc func configView(_ model: FKYProductObject?, showBtn showContactBtn: Bool) {
        guard let model = model else {
            return
        }
        
        settingViewLayout(model,showContactBtn)
        settingStepper(model)
    }
    
    // 设置数量输入框的数字
    @objc func setSetpperNumber(_ limitCount: Int) -> () {
        //self.stepper.setSetpperNumber(count: limitCount)
    }
    
    // 数量更改失败时重置到之前的数量
    @objc func resetStepperNum() {
        // self.stepper.resetStepperToLastCount()
    }
    
    // 重置数量输入框中数量
    @objc func resetStepperWithNum(_ num:Int) {
        // self.stepper.resetcountLableValue(num)
    }
    
    
    // MARK: - Private
    // 设置各子视图控件布局
    fileprivate func settingViewLayout(_ model: FKYProductObject, _ showcontactBtn: Bool) {
        
        let layoutType = getLayoutType(model,showcontactBtn)
        switch layoutType {
        case .UnLogin:
            contactBtn.isHidden = false
            cartBtn.isHidden = false
            shopBtn.isHidden = false
            buttonView.isHidden = false
            orderSetBtn.isHidden = false
            addCartBrn.isHidden = false
            orderSetBtn.isEnabled = true
            addCartBrn.isEnabled = true
            stockOutBtn.isHidden = true
            cartBtn.snp.updateConstraints({ (make) in
                make.left.equalTo(shopBtn.snp.right).offset(WH(45))
                
            })
            break;
        case .UnLoginAndNoContact:
            contactBtn.isHidden = true
            cartBtn.isHidden = false
            shopBtn.isHidden = false
            buttonView.isHidden = false
            orderSetBtn.isHidden = false
            addCartBrn.isHidden = false
            orderSetBtn.isEnabled = true
            addCartBrn.isEnabled = true
            stockOutBtn.isHidden = true
            
            cartBtn.snp.updateConstraints({ (make) in
                make.left.equalTo(shopBtn.snp.right)
                
            })
            break;
        case .CantCartWithStockOut:
            // 不可购买因为缺货
            contactBtn.isHidden = false
            cartBtn.isHidden = false
            shopBtn.isHidden = false
            buttonView.isHidden = false
            orderSetBtn.isHidden = true
            addCartBrn.isHidden =  true
            stockOutBtn.isHidden = false
            
            cartBtn.snp.updateConstraints({ (make) in
                make.left.equalTo(shopBtn.snp.right).offset(WH(45))
                
            })
            break;
        case .CantCartWithStockOutAndNoContact:
            // 不可购买因为缺货并且没有小能
            contactBtn.isHidden = true
            cartBtn.isHidden = false
            shopBtn.isHidden = false
            buttonView.isHidden = false
            orderSetBtn.isHidden = true
            addCartBrn.isHidden =  true
            stockOutBtn.isHidden = false
            
            cartBtn.snp.updateConstraints({ (make) in
                make.left.equalTo(shopBtn.snp.right)
                
            })
            break;
        case .CantCartWithOther:
            // 不可购买除缺货
            contactBtn.isHidden = false
            cartBtn.isHidden = false
            shopBtn.isHidden = false
            buttonView.isHidden = false
            orderSetBtn.isHidden = false
            addCartBrn.isHidden = false
            stockOutBtn.isHidden = true
            
            orderSetBtn.isEnabled = false
            addCartBrn.isEnabled = false
            cartBtn.snp.updateConstraints({ (make) in
                make.left.equalTo(shopBtn.snp.right).offset(WH(45))
                
            })
            break;
        case .CantCartWithOtherAndNoContact:
            //不可购买除缺货并且没有小能
            contactBtn.isHidden = true
            cartBtn.isHidden = false
            shopBtn.isHidden = false
            buttonView.isHidden = false
            orderSetBtn.isHidden = false
            addCartBrn.isHidden = false
            stockOutBtn.isHidden = true
            
            orderSetBtn.isEnabled = false
            addCartBrn.isEnabled = false
            cartBtn.snp.updateConstraints({ (make) in
                make.left.equalTo(shopBtn.snp.right)
                
            })
            break;
        case .ContactAndCart:
            // 加车&小能
            contactBtn.isHidden = false
            cartBtn.isHidden = false
            shopBtn.isHidden = false
            buttonView.isHidden = false
            orderSetBtn.isHidden = false
            addCartBrn.isHidden = false
            stockOutBtn.isHidden = true
            
            orderSetBtn.isEnabled = true
            addCartBrn.isEnabled = true
            cartBtn.snp.updateConstraints({ (make) in
                make.left.equalTo(shopBtn.snp.right).offset(WH(45))
                
            })
            break;
        case .NoContactAndTip:
            // 加车
            contactBtn.isHidden = true
            cartBtn.isHidden = false
            shopBtn.isHidden = false
            buttonView.isHidden = false
            orderSetBtn.isHidden = false
            addCartBrn.isHidden = false
            stockOutBtn.isHidden = true
            
            orderSetBtn.isEnabled = true
            addCartBrn.isEnabled = true
            cartBtn.snp.updateConstraints({ (make) in
                make.left.equalTo(shopBtn.snp.right)
                
            })
            break;
        default:
            print("异常情况")
            contactBtn.isHidden = false
            cartBtn.isHidden = false
            shopBtn.isHidden = false
            buttonView.isHidden = false
            orderSetBtn.isHidden = false
            addCartBrn.isHidden = false
            stockOutBtn.isHidden = true
            
            orderSetBtn.isEnabled = true
            addCartBrn.isEnabled = true
            cartBtn.snp.updateConstraints({ (make) in
                make.left.equalTo(shopBtn.snp.right).offset(WH(45))
                
            })
            break;
        }
        //  if model.isZiYingFlag == 1{
        orderSetBtn.isHidden = true
        addCartBrn.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(buttonView).offset(WH(-1))
            make.left.equalTo(buttonView).offset(WH(1))
            make.height.equalTo(WH(43))
        })
        //        }else{
        //            addCartBrn.snp.remakeConstraints({ (make) in
        //                make.centerY.equalTo(self)
        //                make.right.equalTo(buttonView).offset(WH(-1))
        //                make.left.equalTo(buttonView.snp.centerX)
        //                make.height.equalTo(WH(41))
        //            })
        //        }
        layoutIfNeeded()
    }
    
    
    // 设置加车器
    fileprivate func settingStepper(_ model : FKYProductObject) {
        //1-----技术设置初始
        var tempStr = "加入购物车"
        if let info = model.priceInfo ,info.appButtonCanClick == true {
            tempStr = info.buttonText ?? "加入购物车"
            var str = "\(tempStr)"
            if let num =  model.carOfCount ,num.intValue>0{
                str = str + "(\(num))"
            }
            let attStr = NSMutableAttributedString.init(string: str)
            attStr.yy_setFont(t17.font, range:((str as NSString).range(of: tempStr)))
            attStr.yy_setAlignment(.center, range:((str as NSString).range(of: str)))
            attStr.yy_setColor(RGBAColor(0xFFFFFF, alpha:1.0), range:((str as NSString).range(of: tempStr)))
            self.addCartBrn.setAttributedTitle(attStr, for: UIControl.State())
        }else {
            let str = "\(tempStr)"
            let attStr = NSMutableAttributedString.init(string: str)
            attStr.yy_setFont(t17.font, range:((str as NSString).range(of: tempStr)))
            attStr.yy_setAlignment(.center, range:((str as NSString).range(of: str)))
            attStr.yy_setColor(RGBAColor(0xFFFFFF, alpha: 0.4) , range:((str as NSString).range(of: tempStr)))
            self.addCartBrn.setAttributedTitle(attStr, for: UIControl.State())
        }
//
//        if model.carOfCount == nil||model.carOfCount.intValue == 0 || model.getSigleCanBuy() == false {
//            if let _ = model.priceInfo.status {
//                if model.getCanAddCarBtn() == false {
//                    // 不可加车
//                    var tempStr = "加入购物车"
//                    if model.getSigleCanBuy() == false {
//                        tempStr = "购买套餐"
//                        let str = "\(tempStr)"
//                        let attStr = NSMutableAttributedString.init(string: str)
//                        attStr.yy_setFont(t17.font, range:((str as NSString).range(of: tempStr)))
//                        attStr.yy_setAlignment(.center, range:((str as NSString).range(of: str)))
//                        attStr.yy_setColor(RGBAColor(0xFFFFFF, alpha:1.0), range:((str as NSString).range(of: tempStr)))
//                        self.addCartBrn.setAttributedTitle(attStr, for: UIControl.State())
//                    }else if model.getNoLoginStatus() == true {
//                        //未登录
//                        let str = "\(tempStr)"
//                        let attStr = NSMutableAttributedString.init(string: str)
//                        attStr.yy_setFont(t17.font, range:((str as NSString).range(of: tempStr)))
//                        attStr.yy_setAlignment(.center, range:((str as NSString).range(of: str)))
//                        attStr.yy_setColor(RGBAColor(0xFFFFFF, alpha:1.0), range:((str as NSString).range(of: tempStr)))
//                        self.addCartBrn.setAttributedTitle(attStr, for: UIControl.State())
//                    }else {
//                        let str = "\(tempStr)"
//                        let attStr = NSMutableAttributedString.init(string: str)
//                        attStr.yy_setFont(t17.font, range:((str as NSString).range(of: tempStr)))
//                        attStr.yy_setAlignment(.center, range:((str as NSString).range(of: str)))
//                        attStr.yy_setColor(RGBAColor(0xFFFFFF, alpha: 0.4) , range:((str as NSString).range(of: tempStr)))
//                        self.addCartBrn.setAttributedTitle(attStr, for: UIControl.State())
//                    }
//                }else {
//                    // 可加车
//                    let tempStr = "加入购物车"
//                    let str = "\(tempStr)"
//                    let attStr = NSMutableAttributedString.init(string: str)
//                    attStr.yy_setFont(t17.font, range:((str as NSString).range(of: tempStr)))
//                    attStr.yy_setAlignment(.center, range:((str as NSString).range(of: str)))
//                    attStr.yy_setColor(RGBAColor(0xFFFFFF, alpha:1.0), range:((str as NSString).range(of: tempStr)))
//                    self.addCartBrn.setAttributedTitle(attStr, for: UIControl.State())
//                }
//            }
//        }else{
//            let tempStr = "加入购物车"
//            let countStr = String.init(format: "(%ld)",model.carOfCount.intValue)
//            let str = "\(tempStr)\(countStr)"
//            let attStr = NSMutableAttributedString.init(string: str)
//            attStr.yy_setFont(t21.font, range:((str as NSString).range(of: tempStr)))
//            attStr.yy_setFont(t27.font, range:((str as NSString).range(of: countStr)))
//            attStr.yy_setAlignment(.center, range:((str as NSString).range(of: str)))
//            if let _ = model.priceInfo.status {
//                // 根据状态判断是否可加车
//                if model.getCanAddCarBtn() == false {
//                    // 不可加车
//                    attStr.yy_setColor(RGBAColor(0xFFFFFF, alpha: 0.4) , range:((str as NSString).range(of: tempStr)))
//                    self.addCartBrn.setAttributedTitle(NSMutableAttributedString.init(string:"加入购物车"), for: UIControl.State())
//                }else {
//                    // 可加车
//                    attStr.yy_setColor(RGBAColor(0xFFFFFF, alpha:1.0), range:((str as NSString).range(of: tempStr)))
//                    self.addCartBrn.setAttributedTitle(attStr, for: UIControl.State())
//                }
//            }else{
//                self.addCartBrn.setAttributedTitle(attStr, for: UIControl.State())
//            }
//        }
        self.cartBtn.changeBadgeNumber(false)
    }
    
    // 获取布局样式
    fileprivate func getLayoutType(_ model: FKYProductObject, _ showContactBtn: Bool) -> PDBottomLayoutType {
        // 是否可购买
        var canAddCart = true
        //判断是否缺货
        var stockOutState = false
        if let status = model.priceInfo.status {
            // 根据状态判断是否可加车
            if status == "-1"{
                if showContactBtn == true{
                    return .UnLogin
                }else{
                    return .UnLoginAndNoContact
                }
            }
            if status == "-5"{
                stockOutState = true
            }
            if let info = model.priceInfo ,info.appButtonCanClick == true {
                canAddCart = true
            }else {
                canAddCart = false
            }
//            if model.getCanAddCarBtn() == false {
//                // 不可加车
//                if model.getSigleCanBuy() == false {
//                    canAddCart = true
//                }else {
//                    canAddCart = false
//                }
//            }else {
//                // 可加车
//                canAddCart = true
//            }
        }
        else {
            // 默认可加车
            canAddCart = true
        }
        if stockOutState == true {
            if showContactBtn == true{
                return .CantCartWithStockOut
            }else{
                return .CantCartWithStockOutAndNoContact
            }
        }else if canAddCart == false{
            if showContactBtn == true{
                return .CantCartWithOther
            }else{
                return .CantCartWithOtherAndNoContact
            }
        }else{
            if showContactBtn == true{
                return .ContactAndCart
            }else{
                return .NoContactAndTip
            }
        }
    }
    
}
