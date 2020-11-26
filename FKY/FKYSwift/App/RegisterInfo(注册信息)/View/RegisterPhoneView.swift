//
//  RegisterPhoneView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/7/31.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  注册界面之[手机号]输入视图

import UIKit

class RegisterPhoneView: UIView {
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
        txtfield.keyboardType = .numberPad
        txtfield.returnKeyType = .done
        txtfield.font = UIFont.boldSystemFont(ofSize: WH(15))
        txtfield.textColor = RGBColor(0x333333)
        txtfield.autocapitalizationType = .none
        txtfield.autocorrectionType = .no
        txtfield.clearButtonMode = .whileEditing
        txtfield.placeholder = "请输入手机号"
        txtfield.tintColor = RGBColor(0xFF2D5C)
        //txtfield.setValue(RGBColor(0xCCCCCC), forKeyPath: "_placeholderLabel.textColor")
        //txtfield.setValue(UIFont.systemFont(ofSize: WH(15)), forKeyPath: "_placeholderLabel.font")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "请输入手机号", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(15)), NSAttributedString.Key.foregroundColor: RGBColor(0xCCCCCC)])
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
        print("RegisterPhoneView deinit~!@")
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
            make.top.equalTo(viewLine.snp.bottom).offset(WH(6))
            //make.height.equalTo(WH(15))
        }
        
        // 默认隐藏
        lblTip.isHidden = true
    }
    
    
    // MARK: - Public
    
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
    func setValue(_ value: String?) {
        
        if var phoneNum = value,phoneNum.isEmpty == false {
            phoneNum = phoneNum.trimmingCharacters(in: .whitespacesAndNewlines)
            // 去中间空格
            phoneNum = phoneNum.replacingOccurrences(of: " ", with: "")
            // 每次输入都先清除空格
            let noBlankString:NSMutableString = NSMutableString(string: phoneNum)
            // 插入空格
//            if(noBlankString.length >= 4 && noBlankString.length < 8) {
//                noBlankString.insert(" ", at: 3)
//            } else if(noBlankString.length > 7) {
//                noBlankString.insert(" ", at: 3)
//                noBlankString.insert(" ", at: 8)
//            }
            txtfield.text = noBlankString as String
        }
    }

}


extension RegisterPhoneView: UITextFieldDelegate {
    // 监听UITextField变化
    @objc func textfieldDidChange(_ textField: UITextField) {
        // 为空
        guard var text = textField.text, text.isEmpty == false else {
            if let closure = changeTextfield {
                closure()
            }
            return
        }
        
        if let txt = textField.text, txt.isEmpty == false {
            if !RITextInputCell.onlyInputTheNumber(txt) {
                // 包含非数字
                textField.text = NSString.getPureNumber(txt)
                text = textField.text!
            }
        }
        
        // 字数控制
        let str: NSString = text as NSString
        if str.length >= 12 {
            textField.text = str.substring(to: 11)
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
//        if string == " " || ((textField.text! as NSString).length == 13 && range.length == 0) {
//            return false
//        }
//        var txt = string.trimmingCharacters(in: .whitespacesAndNewlines)
//        // 去中间空格
//        txt = txt.replacingOccurrences(of: " ", with: "")
//        if let contentStr:String = txt.trimmingCharacters(in: .decimalDigits) {
//            if (contentStr as NSString).length > 0 {
//                return false
//            }
//        }
//        let mStr:NSMutableString = NSMutableString(string: textField.text!)
//        let contentStr = textField.text! as NSString
//        // 删减字符
//        if ((string as NSString).length == 0 && range.location < contentStr.length) {
//            let removeTemp = contentStr.substring(with: NSRange.init(location: range.location, length: range.length))
//            var removeTempFontier = ""
//            if (range.location >= 1) {
//                removeTempFontier = contentStr.substring(with: NSRange.init(location: range.location - 1, length: range.length))
//            }
//            if removeTemp != " " {
//                mStr.deleteCharacters(in: NSRange.init(location: range.location, length: range.length))
//                let noBlankString:NSMutableString = NSMutableString(string: mStr.replacingOccurrences(of: " ", with: ""))
//                if (noBlankString.length >= 4) {
//                    noBlankString.insert(" ", at: 3)
//                }
//                if (noBlankString.length >= 9) {
//                    noBlankString.insert(" ", at: 8)
//                }
//                txtfield.text = noBlankString as String
//            }
//            // 判断当前位置往前一个字符是否为空格
//            if removeTempFontier == " " {
//                self.setTextRangeWithOffset(range.location - 1)
//            }else{
//                self.setTextRangeWithOffset(range.location)
//            }
//            return false
//        }
//        // 输入字符
//        if (string as NSString).length > 0 {
//            mStr.deleteCharacters(in: NSRange.init(location: range.location, length: range.length))
//            var location = range.location + 1
//            if (range.location == 3 || range.location == 8) {
//                location += 1
//            }
//            mStr.insert(string, at: range.location)
//            // 每次输入都先清除空格
//            let noBlankString:NSMutableString = NSMutableString(string: mStr.replacingOccurrences(of: " ", with: ""))
//            // 插入空格
//            if (noBlankString.length >= 4 && noBlankString.length < 8) {
//                noBlankString.insert(" ", at: 3)
//            } else if (noBlankString.length > 7) {
//                noBlankString.insert(" ", at: 3)
//                noBlankString.insert(" ", at: 8)
//            }
//            txtfield.text = noBlankString as String
//            self.setTextRangeWithOffset(location)
//            return false
//        }
        return true
    }
    
    func setTextRangeWithOffset(_ offset:NSInteger) {
        let beginning = txtfield.beginningOfDocument
        let startPosition = txtfield.position(from: beginning, offset: offset)
        let endPosition = txtfield.position(from: beginning, offset: offset)
        if startPosition != nil {
            txtfield.textRange(from: startPosition!, to: endPosition!)
        }
    }
}
