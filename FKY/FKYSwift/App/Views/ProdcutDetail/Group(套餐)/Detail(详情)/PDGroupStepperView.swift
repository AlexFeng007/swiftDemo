//
//  PDGroupStepperView.swift
//  FKY
//
//  Created by 夏志勇 on 2018/10/9.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详之固定套餐用到的数量输入控件

import UIKit

typealias PDGroupStepperViewClousre = (_ currentCount: Int)->()
typealias PDGroupStepperViewUpdateClousre = (_ currentCount: Int, _ msg: String?)->()


class PDGroupStepperView: UIView {
    // MARK: - Properties
    
    var maximum: Int = 10000
    var minimum: Int = 0
    
    var addCallback: PDGroupStepperViewClousre?
    var minusCallback: PDGroupStepperViewClousre?
    var validateTextinputCallback: PDGroupStepperViewClousre?
    var updateRealTimeCallback: PDGroupStepperViewUpdateClousre?
    
    fileprivate lazy var addButton: UIButton! = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "icon_jia_new"), for: .normal)
        button.setImage(UIImage(named: "btn_pd_add_gray"), for: .disabled)
        return button
    }()
    
    fileprivate lazy var minusButton: UIButton! = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "icon_jian_new"), for: .normal)
        button.setImage(UIImage(named: "btn_pd_minus_gray"), for: .disabled)
        return button
    }()
    
    fileprivate lazy var inputTextfield: UITextField! = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.backgroundColor = RGBColor(0xF6F6F6)
        textfield.textAlignment = .center
        textfield.font = UIFont.boldSystemFont(ofSize: WH(16))
        textfield.textColor = RGBColor(0x333333)
        textfield.text = "\(self.minimum)"
        textfield.keyboardType = .numberPad
        textfield.adjustsFontSizeToFitWidth = true
        textfield.minimumFontSize = 0.6
        textfield.layer.masksToBounds = true
        textfield.layer.cornerRadius = WH(4)
        textfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
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
    
    
    // MARK: - layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let btnAdd = addButton, let btnMinus = minusButton {
            btnAdd.snp.updateConstraints { (make) in
                make.width.equalTo(self.frame.size.width / 5.0);
            }
            btnMinus.snp.updateConstraints { (make) in
                make.width.equalTo(self.frame.size.width / 5.0);
            }
        }
        else {
            setupView()
        }
    }
    
    
    // MARK: - Action
    
    func updateStepperNumber(withCount newCount: Int) {
        self.inputTextfield.text = "\(newCount)"
    }
    
    func enableAddButton(_ enabled: Bool) {
        //addButton.setImage(UIImage(named: enabled ? "btn_pd_add" : "btn_pd_add_gray"), for: .normal)
        addButton.isEnabled = enabled
    }
    
    func enableMinusButton(_ enabled: Bool) {
        //minusButton.setImage(UIImage(named: enabled ? "btn_pd_minus" : "btn_pd_minus_gray"), for: .normal)
        minusButton.isEnabled = enabled
    }
    
    
    // MARK: - UI
    
    func setupView() {
        self.backgroundColor = .clear
        
        self.addSubview(minusButton)
        self.addSubview(addButton)
        self.addSubview(inputTextfield)
        
        minusButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(WH(30))
        }
        
        addButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(WH(30))
        }
        
        inputTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(minusButton.snp.right)
            make.top.bottom.equalTo(self)
            make.right.equalTo(addButton.snp.left)
        }
        
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = .clear
        self.insertSubview(btn, at: 0)
        btn.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    
    // MARK: - Data
    
    func bindViewModel() {
        _ = addButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.inputTextfield.endEditing(true)
            if strongSelf.addCallback != nil {
                strongSelf.addCallback!(Int(strongSelf.inputTextfield.text!)!)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        _ = minusButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.inputTextfield.endEditing(true)
            if strongSelf.minusCallback != nil {
                strongSelf.minusCallback!(Int(strongSelf.inputTextfield.text!)!)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    
    // MARK: - Public
    
    func changeStepperColor(_ color: UIColor?) {
        guard let color = color else {
            return
        }
        inputTextfield.backgroundColor = color
    }
    
    // 针对搭配套餐，修改按钮禁用时的背景图片
    func changeButtonImage() {
        addButton.setImage(UIImage(named: "btn_pd_add_white"), for: .disabled)
        minusButton.setImage(UIImage(named: "btn_pd_minus_white"), for: .disabled)
    }
}

extension PDGroupStepperView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // 为空
//        guard string.isEmpty == false else {
//            return true
//        }
//        // 只能为纯数字
//        guard NSString.validateOnlyNumber(string) == true else {
//            return false
//        }
        
        let str = string as NSString
        if str.length > 0 {
            // 有输入
            return str.isPureInteger()
        } else {
            // 无输入
            return true
        }
    }
    
    // 数量控制
    @objc func textfieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, text.isEmpty == false else {
            return
        }
        
        var newString: NSMutableString = NSMutableString.init(string: text)
        while newString.hasPrefix("0") {
            newString.deleteCharacters(in: NSRange.init(location: 0, length: 1))
        }
        
        var number = newString.integerValue
        if number > maximum {
            // 超过最大
            number = maximum
            textField.text = "\(number)"
            // toast
            if let block = updateRealTimeCallback {
                block(number, "超出最大可售数量，最多只能买" + "\(number)")
            }
        } else if number <= minimum {
            // 小于等于最小
            number = minimum
            textField.text = "\(number)"
            if let block = updateRealTimeCallback {
                block(number, nil)
            }
        } else {
            // 合法
            textField.text = newString as String
            if let block = updateRealTimeCallback {
                block(number, nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let block = validateTextinputCallback {
            let str = textField.text! as NSString
            block(str.integerValue)
        }
    }
}

