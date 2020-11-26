//
//  CartStepperView.swift
//  FKY
//
//  Created by Rabe on 31/08/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

import Foundation
import UIKit

typealias CartStepperViewClousre = (_ currentCount: Int)->()

class CartStepperView: UIView {
    // MARK: - Properties

    var maximum: Int = Int.max
    var minimum: Int = 0
    var addCallback: CartStepperViewClousre?
    var minusCallback: CartStepperViewClousre?
    var validateTextinputCallback: CartStepperViewClousre?
    var signalOn = false
    
    fileprivate lazy var addButton: UIButton! = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_jia"), for: .normal)
        return button
    }()
    
    fileprivate lazy var minusButton: UIButton! = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_jian"), for: .normal)
        return button
    }()
    
    fileprivate lazy var inputTextfield: UITextField! = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.textAlignment = .center
        textfield.font = UIFont.systemFont(ofSize: WH(12))
        textfield.textColor = RGBColor(0x666666)
        textfield.text = "\(self.minimum)"
        textfield.keyboardType = .numberPad
        textfield.adjustsFontSizeToFitWidth = true
        textfield.minimumFontSize = 0.6
        return textfield
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    func updateStepperNumber(withCount newCount: Int) {
        self.signalOn = false
        self.inputTextfield.text = "\(newCount)"
    }
    
    func enableAddButton(_ enabled: Bool) {
        addButton.setImage(UIImage(named: enabled ? "icon_jia" : "icon_jia_gray"), for: .normal)
        addButton.isEnabled = enabled
    }
    
    func enableMinusButton(_ enabled: Bool) {
        minusButton.setImage(UIImage(named: enabled ? "icon_jian" : "icon_jian_gray"), for: .normal)
        minusButton.isEnabled = enabled
    }
    
    // MARK: - UI
    
    func setupView() {
        self.backgroundColor = RGBColor(0xffffff)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = RGBColor(0xe5e5e5).cgColor
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
        
        self.addSubview(minusButton)
        self.addSubview(addButton)
        self.addSubview(inputTextfield)
        
        let leftline = UIView()
        leftline.backgroundColor = RGBColor(0xe5e5e5)
        self.addSubview(leftline)
        
        let rightline = UIView()
        rightline.backgroundColor = RGBColor(0xe5e5e5)
        self.addSubview(rightline)
        
        minusButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(WH(26))
        }
        
        leftline.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(WH(3))
            make.bottom.equalTo(self).offset(WH(-3))
            make.left.equalTo(minusButton.snp.right)
            make.width.equalTo(0.5)
        }
        
        inputTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(leftline.snp.right)
            make.top.bottom.equalTo(self)
            make.right.equalTo(rightline.snp.left)
        }
        
        rightline.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(WH(3))
            make.bottom.equalTo(self).offset(WH(-3))
            make.right.equalTo(addButton.snp.left)
            make.width.equalTo(0.5)
        }
        
        addButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(WH(26))
        }
    }
    
    // MARK: - Data
    
    func bindViewModel() {
        _ = addButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.signalOn = true
            strongSelf.inputTextfield.endEditing(true)
            if strongSelf.addCallback != nil {
                strongSelf.addCallback!(Int(strongSelf.inputTextfield.text!)!)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)

        _ = minusButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.signalOn = true
            strongSelf.inputTextfield.endEditing(true)
            if strongSelf.minusCallback != nil {
                strongSelf.minusCallback!(Int(strongSelf.inputTextfield.text!)!)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    // MARK: - Private Method
}

extension CartStepperView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = string as NSString
        if str.length > 0 {
            return str.isPureInteger()
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.validateTextinputCallback != nil && self.signalOn == false {
            let string = textField.text! as NSString
            let i = lroundf(string.floatValue)
            self.validateTextinputCallback!(i)
        }
    }
}

