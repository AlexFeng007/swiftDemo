//
//  FKYPhoneView.swift
//  FKY
//
//  Created by hui on 2019/6/25.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYPhoneView: UIView {
    // 内容输入框...<单行>
    lazy var phoneTxtfield: UITextField = {
        let txtfield = UITextField()
        txtfield.delegate = self
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.returnKeyType = .done
        txtfield.font = UIFont.boldSystemFont(ofSize: WH(15))
        txtfield.textColor = RGBColor(0x333333)
        txtfield.autocapitalizationType = .none
        txtfield.autocorrectionType = .no
        txtfield.placeholder = "请输入手机号"
        txtfield.tintColor = RGBColor(0xFF2D5C)
        //txtfield.setValue(RGBColor(0xCCCCCC), forKeyPath: "_placeholderLabel.textColor")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "请输入手机号", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: WH(15)), NSAttributedString.Key.foregroundColor: RGBColor(0xCCCCCC)])
        txtfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        txtfield.addDoneOnKeyboard(withTarget: self, action: #selector(ontextFieldDone(_:)))
        return txtfield
    }()
    
    // 错误提示
    lazy var errorLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = RGBColor(0xFF2D5D)
        label.font = t11.font
        return label
    }()
    
    //清除按钮
    fileprivate lazy var clearButton : UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setImage(UIImage(named: "login_clear_pic"), for: [.normal])
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            if let strongSelf = self {
                strongSelf.phoneTxtfield.text = ""
                strongSelf.clearButton.isHidden = true
                if let closure = strongSelf.changeTextfield {
                    closure()
                }
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 明文/密文展示切换按钮
    fileprivate lazy var btnSecure: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage.init(named: "image_register_hide"), for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.changeTextShowMode()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 下划线
    fileprivate lazy var viewLine : UIView = {
        let iv = UIView()
        iv.backgroundColor = RGBColor(0xEAEAEA)
        return iv
    }()
    
    //MARK: - 属性
    var changeTextfield : emptyClosure?
    var beginEditing : emptyClosure?
    var endEditing : emptyClosure?
    var doneEditing: emptyClosure?
    var type = 0 //判断不同的类型(1:修改密码2:找回密码处需要输入汉字联系)
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        // 默认隐藏
        self.btnSecure.isHidden = true
        self.addSubview(self.btnSecure)
        self.btnSecure.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(WH(7))
            make.right.equalTo(self)
            make.height.width.equalTo(WH(30))
        }
        
        self.addSubview(self.clearButton)
        self.clearButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(WH(7))
            make.right.equalTo(self)
            make.height.width.equalTo(WH(30))
        }
        
        self.addSubview(self.phoneTxtfield)
        self.phoneTxtfield.snp.makeConstraints { (make) in
            make.top.left.equalTo(self)
            make.right.equalTo(self.clearButton.snp.left).offset(-WH(5))
            make.height.equalTo(WH(43))
        }
        
        self.addSubview(self.viewLine)
        self.viewLine.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(self.phoneTxtfield.snp.bottom)
            make.height.equalTo(WH(1))
        }
        
        self.addSubview(self.errorLabel)
        self.errorLabel.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(self.viewLine.snp.bottom).offset(WH(0))
            make.height.equalTo(WH(0))
        }
    }
}

extension FKYPhoneView {
    //更新错误提示
    func refreshErrorLabel(_ errorStr : String?) {
        if let str = errorStr {
            self.errorLabel.text = str
            self.errorLabel.isHidden = false
            self.errorLabel.snp.updateConstraints({ (make) in
                make.top.equalTo(self.viewLine.snp.bottom).offset(WH(5))
                make.height.equalTo(WH(17))
            })
            self.viewLine.backgroundColor = RGBColor(0xFF2D5D)
        }else {
            self.errorLabel.text  = ""
            self.errorLabel.isHidden = true
            self.errorLabel.snp.updateConstraints({ (make) in
                make.top.equalTo(self.viewLine.snp.bottom).offset(WH(0))
                make.height.equalTo(WH(0))
            })
            //判断当前输入框是否聚焦来判断下划线颜色
            if self.phoneTxtfield.isFirstResponder {
                self.viewLine.backgroundColor = RGBColor(0x333333)
            }else{
                self.viewLine.backgroundColor = RGBColor(0xEAEAEA)
            }
        }
    }
    
    //
    func updateLayoutForPassword() {
        self.btnSecure.isHidden = false
        self.clearButton.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-WH(40))
        }
    }
    
    //
    fileprivate func changeTextShowMode() {
        let status = phoneTxtfield.isSecureTextEntry
        phoneTxtfield.isSecureTextEntry = !status
        if  phoneTxtfield.isSecureTextEntry {
            // 密文
            btnSecure.setImage(UIImage.init(named: "image_register_hide"), for: .normal)
        }
        else {
            // 明文
            btnSecure.setImage(UIImage.init(named: "image_register_show"), for: .normal)
        }
    }
}

extension FKYPhoneView: UITextFieldDelegate {
    // 监听UITextField变化
    @objc func textfieldDidChange(_ textField: UITextField) {
        if type == 2 {
            if textField.markedTextRange == nil {
                //输入中文时点击确认才修改
                if let str = textField.text ,str.count > 0 {
                    //输入框有字符
                    self.clearButton.isHidden = false
                }else {
                    //输入框无字符
                    self.clearButton.isHidden = true
                }
                if let closure = self.changeTextfield {
                    closure()
                }
            }
        }else {
            if let str = textField.text ,str.count > 0 {
                //输入框有字符
                self.clearButton.isHidden = false
            }else {
                //输入框无字符
                self.clearButton.isHidden = true
            }
            if let closure = self.changeTextfield {
                closure()
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let str = textField.text ,str.count > 0 {
            self.clearButton.isHidden = false
        }
        self.viewLine.backgroundColor = RGBColor(0x333333)
        if let closure = self.beginEditing {
            closure()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         self.clearButton.isHidden = true
         self.viewLine.backgroundColor = RGBColor(0xEAEAEA)
         if let closure = self.endEditing {
            closure()
         }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false;
        }
        return true;
    }
    @objc func ontextFieldDone(_ sender: AnyObject) {
        if type == 2 {
            if let closure = self.doneEditing {
                closure()
            }
        }else {
            self.endEditing(true)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        phoneTxtfield.resignFirstResponder()
        return true
    }
}
