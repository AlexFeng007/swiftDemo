//
//  RegisterNameView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/7/31.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  注册界面之[用户名]输入视图

import UIKit

class RegisterNameView: UIView {
    // MARK: - Property
    
    var changeTextfield: emptyClosure?
    var beginEditing: emptyClosure?
    var endEditing: emptyClosure?
    
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
        txtfield.placeholder = "请输入用户名(数字、字母或下划线)"
        txtfield.tintColor = RGBColor(0xFF2D5C)
        //txtfield.setValue(RGBColor(0xCCCCCC), forKeyPath: "_placeholderLabel.textColor")
        //txtfield.setValue(UIFont.systemFont(ofSize: WH(15)), forKeyPath: "_placeholderLabel.font")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "请输入用户名(数字、字母或下划线)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(15)), NSAttributedString.Key.foregroundColor: RGBColor(0xCCCCCC)])
        txtfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        return txtfield
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
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("RegisterNameView deinit~!@")
    }
    
    
    // MARK: - UI
    
    fileprivate func setupView() {
        backgroundColor = .clear
        
        addSubview(viewLine)
        addSubview(txtfield)
        addSubview(lblTip)
        
        viewLine.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(30))
            make.right.equalTo(self).offset(-WH(30))
            make.top.equalTo(self).offset(WH(60))
            make.height.equalTo(1)
        }
        
        txtfield.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(30))
            make.right.equalTo(self).offset(-WH(30))
            make.bottom.equalTo(viewLine.snp.top).offset(-WH(8))
            make.height.equalTo(WH(30))
        }

        lblTip.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(30))
            make.right.equalTo(self).offset(-WH(30))
            make.top.equalTo(viewLine.snp.bottom).offset(WH(5))
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
}


extension RegisterNameView: UITextFieldDelegate {
    // 监听UITextField变化
    @objc func textfieldDidChange(_ textField: UITextField) {
        // 为空
        guard let text = textField.text, text.isEmpty == false else {
            if let closure = changeTextfield {
                closure()
            }
            return
        }
        
        // 去unicode码...<界面不展示的两个特殊unicode码:\u202C \u202D>
        let txt: NSString = text as NSString
        textField.text = txt.trimmingInvisibleUnicode()
        // 为空
        guard let string = textField.text, string.isEmpty == false else {
            if let closure = changeTextfield {
                closure()
            }
            return
        }
        // 若上面去unicode码方法无效，则手动删除...<\u202D15830793003\u202C>
        var finalStr: String = string
        finalStr = finalStr.replacingOccurrences(of: "\\u202D", with: "")
        finalStr = finalStr.replacingOccurrences(of: "\\u202C", with: "")
        textField.text = finalStr
        
        // 为空
        guard let content = textField.text, content.isEmpty == false else {
            if let closure = changeTextfield {
                closure()
            }
            return
        }
        
        // 字数控制
        let str: NSString = content as NSString
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
