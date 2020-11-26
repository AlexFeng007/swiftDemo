//
//  RISearchView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class RISearchView: UIView {
    // MARK: - Property
    
    var changeText: ( (String?)->() )?
    var beginEditing: emptyClosure?
    var endEditing: emptyClosure?
    
    // 输入类型...<默认为企业名称>
    var inputType: RITextInputType = .enterpriseName
    
    // 星号
    fileprivate lazy var lblStar: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(16))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .center
        lbl.text = "*"
        return lbl
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(16))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = ""
        return lbl
    }()
    
    // 输入框
    fileprivate lazy var txtfield: UITextField = {
        let txtfield = UITextField()
        txtfield.delegate = self
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.keyboardType = .default
        txtfield.returnKeyType = .done
        txtfield.font = UIFont.systemFont(ofSize: WH(16))
        txtfield.textColor = RGBColor(0x333333)
        txtfield.autocapitalizationType = .none
        txtfield.autocorrectionType = .no
        txtfield.clearButtonMode = .whileEditing
        txtfield.placeholder = ""
        //txtfield.tintColor = RGBColor(0xFF2D5C)
        //txtfield.setValue(RGBColor(0x999999), forKeyPath: "_placeholderLabel.textColor")
        //txtfield.setValue(UIFont.systemFont(ofSize: WH(13)), forKeyPath: "_placeholderLabel.font")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        txtfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        return txtfield
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        addSubview(lblStar)
        addSubview(lblTitle)
        addSubview(txtfield)
        
        lblStar.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(WH(15))
        }
        lblTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(WH(15))
            make.width.lessThanOrEqualTo(WH(90))
        }
        txtfield.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(WH(110))
            make.right.equalTo(self).offset(-WH(15))
            make.height.equalTo(WH(36))
        }
        
        // 上分隔线
        let viewLineTop = UIView()
        viewLineTop.backgroundColor = RGBColor(0xE5E5E5).withAlphaComponent(0.5)
        self.addSubview(viewLineTop)
        viewLineTop.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(0.5)
        }
        
        // 下分隔线
        let viewLineBottom = UIView()
        viewLineBottom.backgroundColor = RGBColor(0xE5E5E5)
        self.addSubview(viewLineBottom)
        viewLineBottom.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
}


extension RISearchView {
    //
    func configView(_ type: RITextInputType, _ content: String?) {
        // 保存类型
        inputType = type
        // 赋值
        txtfield.text = content
        
        // 根据类型设置输入框属性
        lblTitle.text = type.typeName
        txtfield.placeholder = type.typeDescription
        txtfield.keyboardType = type.typeKeyboard
        
        txtfield.attributedPlaceholder = NSAttributedString.init(string: type.typeDescription, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        
        // 是否必填...<必填显示星号>
        lblStar.isHidden = !type.typeInputMust
        if lblStar.isHidden {
            // 非必填
            lblTitle.snp.updateConstraints { (make) in
                make.left.equalTo(self).offset(WH(15))
            }
        }
        else {
            // 必填...<显示星号>
            lblTitle.snp.updateConstraints { (make) in
                make.left.equalTo(self).offset(WH(22))
            }
        }
        layoutIfNeeded()
    }
    
    //
    func getContent() -> String? {
        //return txtfield.text
        
        guard let content = txtfield.text, content.isEmpty == false else {
            return nil
        }
        // 去左右空格
        let txt = content.trimmingCharacters(in: .whitespacesAndNewlines)
        return txt
    }
    
    //
    func showKeyboard() {
        txtfield.becomeFirstResponder()
    }
}


extension RISearchView: UITextFieldDelegate {
    // 监听UITextField变化
    @objc func textfieldDidChange(_ textField: UITextField) {
        // 有未选中的字符
        if let selectedRange = textField.markedTextRange, let newText = textField.text(in: selectedRange), newText.isEmpty == false {
            return
        }
        
        // 过滤表情符
        if NSString.stringContainsEmoji(textField.text) || NSString.hasEmoji(textField.text) {
            textField.text = NSString.disableEmoji(textField.text)
        }
        
        if let content = textField.text, content.isEmpty == false {
            // 有输入
            let count = inputType.typeNumberMax
            if content.count >= count + 1 {
                textField.text = (content as NSString).substring(to: count)
            }
        }
        
        // 回调
        if let block = changeText {
            block(textField.text)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let closure = beginEditing {
            closure()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
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
