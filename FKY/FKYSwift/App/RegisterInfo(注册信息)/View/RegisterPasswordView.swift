//
//  RegisterPasswordView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/7/31.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  注册界面之[密码]输入视图

import UIKit

class RegisterPasswordView: UIView {
    // MARK: - Property
    
    var changeTextfield: emptyClosure?
    var beginEditing: emptyClosure?
    var endEditing: emptyClosure?
    //var forgetPassword: emptyClosure?
     
    // 输入框
    fileprivate lazy var txtfield: UITextField = {
        let txtfield = UITextField()
        txtfield.delegate = self
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.keyboardType = .asciiCapable
        txtfield.returnKeyType = .done
        txtfield.font = UIFont.boldSystemFont(ofSize: WH(15))
        txtfield.textColor = RGBColor(0x333333)
        txtfield.autocapitalizationType = .none
        txtfield.autocorrectionType = .no
        txtfield.clearButtonMode = .whileEditing
        txtfield.isSecureTextEntry = true // 默认密文
        txtfield.placeholder = "6~20位密码(不可是纯字母/数字/符号)"
        txtfield.tintColor = RGBColor(0xFF2D5C)
        //txtfield.setValue(RGBColor(0xCCCCCC), forKeyPath: "_placeholderLabel.textColor")
        //txtfield.setValue(UIFont.systemFont(ofSize: WH(15)), forKeyPath: "_placeholderLabel.font")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "6~20位密码(不可是纯字母/数字/符号)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(15)), NSAttributedString.Key.foregroundColor: RGBColor(0xCCCCCC)])
        txtfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        return txtfield
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
    
    // 输入内容非法提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0xFF2D5D)
        lbl.textAlignment = .left
        lbl.text = nil
        return lbl
    }()
    
//    // 找回密码
//    fileprivate lazy var btnPassword: UIButton = {
//        let btn = UIButton.init(type: .custom)
//        btn.backgroundColor = .clear
//        btn.setTitleColor(RGBColor(0x666666), for: .normal)
//        btn.setTitleColor(RGBColor(0x333333), for: .highlighted)
//        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(15))
//        btn.setTitle("忘记密码", for: .normal)
//        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
//            guard let strongSelf = self else {
//                return
//            }
//            if let closure = strongSelf.forgetPassword {
//                closure()
//            }
//            }, onError: nil, onCompleted: nil, onDisposed: nil)
//        return btn
//    }()
//
//    // 竖向分隔线
//    fileprivate lazy var viewHorLine : UIView = {
//        let iv = UIView()
//        iv.backgroundColor = RGBColor(0xEAEAEA)
//        return iv
//    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("RegisterPasswordView deinit~!@")
    }
    
    
    // MARK: - UI
    
    fileprivate func setupView() {
        backgroundColor = .clear
        
        addSubview(viewLine)
        addSubview(btnSecure)
        addSubview(txtfield)
        addSubview(lblTip)
//        addSubview(btnPassword)
//        addSubview(viewHorLine)
        
        
        viewLine.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(30))
            make.right.equalTo(self).offset(-WH(30))
            make.top.equalTo(self).offset(WH(60))
            make.height.equalTo(1)
        }
        
//        btnPassword.snp.makeConstraints({ (make) in
//            make.right.equalTo(self).offset(-WH(25))
//            make.bottom.equalTo(viewLine.snp.top).offset(-WH(8))
//            make.height.equalTo(WH(30))
//            make.width.equalTo(WH(80))
//        })
//
//        viewHorLine.snp.makeConstraints({ (make) in
//            make.right.equalTo(btnPassword.snp.left)
//            make.centerY.equalTo(btnPassword.snp.centerY)
//            make.height.equalTo(20)
//            make.width.equalTo(WH(1))
//        })
        
        btnSecure.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-WH(25))
            make.bottom.equalTo(viewLine.snp.top).offset(-WH(8))
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(30))
        }
        
        txtfield.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(30))
            make.right.equalTo(btnSecure.snp.left).offset(-WH(10))
            make.bottom.equalTo(viewLine.snp.top).offset(-WH(8))
            make.height.equalTo(WH(30))
        }
        
        lblTip.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(30))
            make.right.equalTo(self).offset(-WH(30))
            make.top.equalTo(viewLine.snp.bottom).offset(WH(6))
            //make.height.equalTo(WH(15))
        }
        
        // 默认隐藏
        lblTip.isHidden = true
    }
    
    
    // MARK: - Public
    
    //
    func setPlaceholder(_ tip: String?) {
        txtfield.placeholder = tip
        txtfield.attributedPlaceholder = NSAttributedString.init(string: tip ?? "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(15)), NSAttributedString.Key.foregroundColor: RGBColor(0xCCCCCC)])
    }
    
    //
    func getInputContent() -> String? {
        guard let content = txtfield.text, content.isEmpty == false else {
            return nil
        }
        // 去左右空格
        let txt = content.trimmingCharacters(in: .whitespacesAndNewlines)
        // 去中间空格
        return txt.replacingOccurrences(of: " ", with: "")
    }
    
    //
    func showTip(_ tip: String?) {
        if let txt = tip, txt.isEmpty == false {
            // 有错误提示
            lblTip.text = txt
            lblTip.isHidden = false
            viewLine.backgroundColor = RGBColor(0xFF2D5D)
        }
        else {
            // 无错误提示
            lblTip.text = nil
            lblTip.isHidden = true
            viewLine.backgroundColor = RGBColor(0xEAEAEA)
            if txtfield.isFirstResponder {
                viewLine.backgroundColor = RGBColor(0x333333)
            }
        }
    }
    
    //
    func setValue(_ value: String?) {
        txtfield.text = value ?? ""
    }
    
    
    // MARK: - Private
    
    fileprivate func changeTextShowMode() {
        let status = txtfield.isSecureTextEntry
        txtfield.isSecureTextEntry = !status
        if  txtfield.isSecureTextEntry {
            // 密文
            btnSecure.setImage(UIImage.init(named: "image_register_hide"), for: .normal)
        }
        else {
            // 明文
            btnSecure.setImage(UIImage.init(named: "image_register_show"), for: .normal)
        }
    }
}


extension RegisterPasswordView: UITextFieldDelegate {
    // 监听UITextField变化
    @objc func textfieldDidChange(_ textField: UITextField) {
        // 为空
        guard let text = textField.text, text.isEmpty == false else {
            if let closure = changeTextfield {
                closure()
            }
            return
        }
        
        // 字数控制
        let str: NSString = text as NSString
        if str.length >= 21 {
            textField.text = str.substring(to: 20)
        }
        // 回调
        if let closure = changeTextfield {
            closure()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewLine.backgroundColor = RGBColor(0x333333)
        if let closure = beginEditing {
            closure()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewLine.backgroundColor = RGBColor(0xEAEAEA)
        
        if let text = textField.text, text.isEmpty == false {
            // 去左右空格
            let txt = text.trimmingCharacters(in: .whitespacesAndNewlines)
            // 去中间空格
            textField.text = txt.replacingOccurrences(of: " ", with: "")
        }
        
        if let closure = endEditing {
            closure()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        return true
    }
}
