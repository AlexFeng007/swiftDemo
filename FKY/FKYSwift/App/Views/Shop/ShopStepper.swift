//
//  ShopStepper.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/31.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  加入购物车之数量输入控件

import UIKit
import SnapKit
import RxSwift

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


typealias SingleStringClosure = (String)->(Void)

class ShopStepper: UIView , UITextFieldDelegate {
    // MARK: - Property
    
    fileprivate lazy var bgView: UIView = {
        let iv = UIView()
        iv.layer.borderWidth = 1
        iv.layer.borderColor = RGBColor(0xd5d9da).cgColor
        iv.layer.cornerRadius = 1
        iv.layer.masksToBounds = true
        return iv
    }()
    fileprivate lazy var addBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.setImage(UIImage(named:"icon_jia"), for: UIControl.State())
        btn.addTarget(self, action: #selector(onAddBtn(_:)), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var minusBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.setImage(UIImage(named:"icon_jian"), for: UIControl.State())
        btn.addTarget(self, action: #selector(onMinusBtn(_:)), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var countLabel: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.font = t26.font
        tf.textColor = t26.color
        tf.keyboardType = .numberPad
        tf.delegate = self
        return tf
    }()
    var nowCount: Int?
    var lastCount : Int? //记录上次数量
    fileprivate var baseCount: Int?
    fileprivate var stepCount: Int?
    fileprivate var stockCount: Int?
    fileprivate var isLimitBuy = false //是否限购
    fileprivate var limitNum = 0 //当周限购数量
    var toastClosure: SingleStringClosure?
    var updateProductClosure: IntClosure?
    var updateCountNumClosure: IntClosure?
    var unit: String = "件"
    var mpReceiveFlag: Bool = false // 仅用于mp确认收货
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 自动布局时不应该取frame.size.width。因为在最开始初始化时，width为0, 所以之前的开发者才会在当前方法中再设置一遍!
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.addBtn.snp.makeConstraints({ (make) in
//            make.width.equalTo(self.frame.size.width / 4.0)
//        })
//        self.minusBtn.snp.makeConstraints({ (make) in
//            make.width.equalTo(self.frame.size.width / 4.0)
//        })
//
//        //setupView()
//    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 70, height: 26)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        self.addSubview(bgView)
        bgView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        
        // 总长度的1/4
        self.bgView.addSubview(addBtn)
        addBtn.snp.makeConstraints({ (make) in
            make.right.top.bottom.equalTo(self.bgView)
            make.width.equalTo(self.snp.width).dividedBy(4)
        })
        
        // 总长度的1/4
        self.bgView.addSubview(minusBtn)
        minusBtn.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalTo(self.bgView)
            make.width.equalTo(self.snp.width).dividedBy(4)
        })
        
        self.bgView.addSubview(countLabel)
        countLabel.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self.bgView)
            make.left.equalTo(self.minusBtn.snp.right).offset(-WH(4))
            make.right.equalTo(self.addBtn.snp.left).offset(WH(4))
        })
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = string as NSString
        if str.length > 0 {
            if str.isPureInteger() {
                if let textFieldText = textField.text {
                    let count = (textFieldText as NSString).replacingCharacters(in: range, with: string)
                    var intCount = (count as NSString).integerValue
                    // 整数倍
                    if (intCount % self.stepCount!) != 0 {
                        intCount = intCount - (intCount % self.stepCount!) + self.stepCount!
                    }
                    // 过大
                    if(self.isLimitBuy){//如果设置了限购，则最多只能购买库存和限购数量中的最小者
                        let usefulCount = self.stockCount! - (self.stockCount! % self.stepCount!)
                        self.limitNum = self.limitNum - (self.limitNum % self.stepCount!)
                        let canBuyNum = (usefulCount < self.limitNum ? usefulCount :self.limitNum)
                        var tip = ""
                        if(usefulCount >= self.limitNum){//如果是限购是较小值
                            tip="此商品为限购商品，本周最多还能购买\(canBuyNum)\(self.unit)!"
                        }else{
                            tip="超出最大可售数量，最多只能买\(canBuyNum)\(self.unit)!"
                        }
                        if(intCount > canBuyNum){
                            textField.text = "\(canBuyNum)"
                            textField.resignFirstResponder()
                            if let closure = self.toastClosure {
                                closure(tip)
                            }
                            return false
                        }
                    }else {
                        if intCount > self.stockCount! {
                            textField.text = "\(self.stockCount!)"
                            let usefulCount = self.stockCount! - (self.stockCount! % self.stepCount!)
                            textField.resignFirstResponder()
                            if let closure = self.toastClosure {
                                closure("超出最大可售数量，最多只能买\(usefulCount)\(self.unit)!")
                            }
                            return false
                        }
                    }
                }
                return true
            }else {
                return false
            }
        }else {//删除
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nowCount = (textField.text! as NSString).integerValue
        textField.endEditing(true)
        self.updateCountLabel()
        // 为了不影响其它用到当前控件的界面和功能，此处仅针对mp确认收货界面来增加限制
        if mpReceiveFlag {
            updateButtonStatus()
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.nowCount = (textField.text! as NSString).integerValue
        self.updateCountLabel()
        // 为了不影响其它用到当前控件的界面和功能，此处仅针对mp确认收货界面来增加限制
        if mpReceiveFlag {
            updateButtonStatus()
        }
        return true
    }
    
    
    //MARK: -  User Action
    
    // 加
    @objc func onAddBtn(_ sender: UIButton) {
        self.countLabel.endEditing(true)
        self.lastCount = self.nowCount
        self.nowCount = self.nowCount! + self.stepCount!
        self.updateCountLabel()
        self.minusBtn.isEnabled = true
        // 为了不影响其它用到当前控件的界面和功能，此处仅针对mp确认收货界面来增加限制
        if mpReceiveFlag {
            if self.nowCount! >= self.stockCount! {
                self.addBtn.isEnabled = false
            }
            else {
                self.addBtn.isEnabled = true
            }
        }
    }
    
    // 减
    @objc func onMinusBtn(_ sender: UIButton) {
        self.countLabel.endEditing(true)
        self.lastCount = self.nowCount
        self.nowCount = self.nowCount! - self.stepCount!
        self.updateCountLabel()
        self.addBtn.isEnabled = true
        if self.nowCount! <= self.baseCount! {
            self.minusBtn.isEnabled = false
        }
        else {
            self.minusBtn.isEnabled = true
        }
    }
    
    
    //MARK: - Public
    
    // 通用设置方法
    func configStepper(_ baseCount: Int, stepCount: Int, stockCount: Int, unit: String){
        self.countLabel.text = "\(baseCount)"
        self.nowCount = baseCount
        self.baseCount = baseCount
        self.stepCount = stepCount
        self.stockCount = stockCount
        self.unit = unit
        self.minusBtn.isEnabled = false
        self.updateCountText()
    }
    
    // 涉及限购
    func configStepperLimit(_ baseCount: Int, stepCount: Int, stockCount: Int, unit: String, isLimit: Bool, limitNum: Int){
        self.countLabel.text = "\(baseCount)"
        self.nowCount = baseCount
        self.baseCount = baseCount
        self.stepCount = stepCount
        self.stockCount = stockCount
        self.unit = unit
        self.isLimitBuy = isLimit
        self.limitNum = limitNum
        self.minusBtn.isEnabled = false
        self.updateCountText()
    }
    
    // 仅用于mp确认收货界面
    func configStepperWithNowCount(_ baseCount: Int, stepCount: Int, stockCount: Int, nowCount: Int){
        self.countLabel.text = "\(nowCount)"
        self.nowCount = nowCount
        self.baseCount = baseCount
        self.stepCount = stepCount
        self.stockCount = stockCount
        self.updateCountText()
    }
    
    // 禁用控件，加减号不可点击，输入框不可输入
    func disableStepper()  {
        self.countLabel.isEnabled = false
        self.addBtn.isEnabled = false
        self.minusBtn.isEnabled = false
    }
    
    // 更新输入框中数字
    func setSetpperNumber(count: Int) {
        self.countLabel.text = "\(count)"
        self.nowCount = count
        self.updateCountText()
    }
    
    // 更新加、减按钮状态...<仅用于mp确认收货界面>...<不涉及限购>
    func updateButtonStatus() {
        // 减
        if self.nowCount! <= self.baseCount! {
            self.minusBtn.isEnabled = false
        }
        else {
            self.minusBtn.isEnabled = true
        }
        // 加
        if self.nowCount! >= self.stockCount! {
            self.addBtn.isEnabled = false
        }
        else {
            self.addBtn.isEnabled = true
        }
    }
    
    
    //MARK: - Private
    
    // 通用配置方法
    fileprivate func updateCountText() {
        // 过小
        if self.nowCount! < self.baseCount! {
            self.nowCount = self.baseCount
//            if let closure = self.toastClosure {
//                closure("最小拆零包装为\(self.stepCount!)\(self.unit)")
//            }
        }
        // 整数倍
        if (self.nowCount!%self.stepCount!) != 0 {
            self.nowCount = self.nowCount! - (self.nowCount!%self.stepCount!) + self.stepCount!
        }
        // 过大
        if self.nowCount > self.stockCount! {
            self.nowCount = self.stockCount! - (self.stockCount! % self.stepCount!)
//            if let closure = self.toastClosure, let nowCount = self.nowCount {
//                closure("最多只能买\(nowCount)\(self.unit)!")
//            }
        }
        
        if let closure = self.updateProductClosure {
            closure(self.nowCount!)
        }
        if let closure = self.updateCountNumClosure {
            closure(self.nowCount!)
        }
        
        self.countLabel.text = "\(self.nowCount!)"
    }
    
    // 用户手动操作后的更新操作
    fileprivate func updateCountLabel() {
        // 过小
        if self.nowCount! < self.baseCount! {
            self.nowCount = self.baseCount
            if let closure = self.toastClosure {
                closure("最小拆零包装为\(self.stepCount!)\(self.unit)")
            }
        }
        // 整数倍
        if (self.nowCount!%self.stepCount!) != 0 {
            self.nowCount = self.nowCount! - (self.nowCount!%self.stepCount!) + self.stepCount!
        }
        // 过大
//        if self.nowCount > self.stockCount! {
//            self.nowCount = self.stockCount! - (self.stockCount! % self.stepCount!)
//            if let closure = self.toastClosure, let nowCount = self.nowCount {
//                closure("最多只能买\(nowCount)\(self.unit)!")
//            }
//        }
        // 限购
        if (self.isLimitBuy) {
            // 有限购...<最多只能购买库存和限购数量中的最小者>
            let usefulCount = self.stockCount! - (self.stockCount! % self.stepCount!)
            self.limitNum = self.limitNum - (self.limitNum % self.stepCount!)
            let canBuyNum = (usefulCount < self.limitNum ? usefulCount : self.limitNum)
            var tip = ""
            if (usefulCount >= self.limitNum) {
                tip = "此商品为限购商品，本周最多还能购买\(canBuyNum)\(self.unit)!"
            }
            else {
                tip = "超出最大可售数量，最多只能买\(canBuyNum)\(self.unit)!"
            }
            if (nowCount > canBuyNum) {
                if let closure = self.toastClosure {
                    closure(tip)
                }
                self.nowCount = canBuyNum
                self.addBtn.isEnabled = false
            }
        }
        else {
            // 无限购
            if nowCount > self.stockCount! {
                self.nowCount = self.stockCount! - (self.stockCount! % self.stepCount!)
                let usefulCount = self.nowCount
                if let closure = self.toastClosure {
                    closure("超出最大可售数量，最多只能买\(usefulCount ?? 0)\(self.unit)!")
                }
            }
        }
        
        if let closure = self.updateProductClosure {
            closure(self.nowCount!)
        }
        
        self.countLabel.text = "\(self.nowCount!)"
    }
}

extension ShopStepper {
    func changeViewPattern() {
        self.bgView.layer.borderColor = RGBColor(0xff394e).cgColor
        self.addBtn.backgroundColor = RGBColor(0xff394e)
        self.addBtn.setTitleColor(RGBColor(0xffffff), for: UIControl.State())
        self.minusBtn.backgroundColor = RGBColor(0xff394e)
        self.minusBtn.setTitleColor(RGBColor(0xffffff), for: UIControl.State())
        
    }
    
    //加载失败重置
    func resetNumWithAddFailed () {
        self.nowCount = self.lastCount
        self.countLabel.text = "\(self.nowCount!)"
    }
    
    func addNumWithAuto()  {
        self.countLabel.endEditing(true)
        self.lastCount = self.nowCount
        self.nowCount = self.nowCount! + self.stepCount!
        self.updateCountLabel()
        self.minusBtn.isEnabled = true
    }
}
