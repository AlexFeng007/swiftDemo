//
//  RITextInputCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [资料管理]文字输入界面之文字输入ccell

import UIKit

class RITextInputCell: UITableViewCell {
    // MARK: - Property
    
    var changeText: ( (String?)->() )?
    var beginEditing: emptyClosure?
    var endEditing: emptyClosure?
    
    // cell类型...<默认为企业名称>
    var cellType: RITextInputType = .enterpriseName
    
    // 星号
    fileprivate lazy var lblStar: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .center
        lbl.text = "*"
        return lbl
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
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
        txtfield.font = UIFont.systemFont(ofSize: WH(14))
        txtfield.textColor = RGBColor(0x333333)
        txtfield.autocapitalizationType = .none
        txtfield.autocorrectionType = .no
        txtfield.clearButtonMode = .whileEditing
        txtfield.placeholder = ""
        //txtfield.tintColor = RGBColor(0xFF2D5C)
        //txtfield.setValue(RGBColor(0x999999), forKeyPath: "_placeholderLabel.textColor")
        //txtfield.setValue(UIFont.systemFont(ofSize: WH(13)), forKeyPath: "_placeholderLabel.font")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        txtfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        return txtfield
    }()
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        contentView.addSubview(lblStar)
        contentView.addSubview(lblTitle)
        contentView.addSubview(txtfield)
        
        lblStar.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(15))
        }
        lblTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(15))
            make.width.lessThanOrEqualTo(WH(110))
        }
        txtfield.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(132))
            make.right.equalTo(contentView).offset(-WH(15))
            make.height.equalTo(WH(36))
        }
    }
}


extension RITextInputCell {
    //
    func configCell(_ show: Bool, _ type: RITextInputType, _ content: String?) {
        guard show else {
            // 隐藏
            contentView.isHidden = true
            return
        }
        
        // 显示
        contentView.isHidden = false
        // 保存类型
        cellType = type
        // 赋值
        txtfield.text = content
        
        // 根据类型设置输入框属性
        lblTitle.text = type.typeName
        txtfield.placeholder = type.typeDescription
        txtfield.keyboardType = type.typeKeyboard
        
        txtfield.attributedPlaceholder = NSAttributedString.init(string: type.typeDescription, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        
        // 是否必填...<必填显示星号>
        lblStar.isHidden = !type.typeInputMust
        if lblStar.isHidden {
            // 非必填
            lblTitle.snp.updateConstraints { (make) in
                make.left.equalTo(contentView).offset(WH(15))
            }
        }
        else {
            // 必填...<显示星号>
            lblTitle.snp.updateConstraints { (make) in
                make.left.equalTo(contentView).offset(WH(22))
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
}


extension RITextInputCell {
    // 仅可输入数字
    class func onlyInputTheNumber(_ string: String) -> Bool {
        let numString = "[0-9]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", numString)
        let number = predicate.evaluate(with: string)
        return number
    }
}


extension RITextInputCell: UITextFieldDelegate {
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
        
        // 过滤空格
        if let txt = textField.text, txt.isEmpty == false {
            // 先判断是否有包含空格
            if (txt as NSString).contains(" ") {
                textField.text = txt.replacingOccurrences(of: " ", with: "")
            }
        }
        
        // 门店数单独考虑
        if cellType == .storeNumberRetail {
            // 过滤掉非数字
            if let txt = textField.text, txt.isEmpty == false {
                if !RITextInputCell.onlyInputTheNumber(txt) {
                    // 包含非数字
                    textField.text = NSString.getPureNumber(txt)
                }
            }
            // 开头不能为0
            if let txt = textField.text, txt.isEmpty == false {
                let newString: NSMutableString = NSMutableString.init(string: txt)
                while newString.hasPrefix("0") {
                    newString.deleteCharacters(in: NSRange.init(location: 0, length: 1))
                }
                textField.text = newString as String
            }
        }
        else if cellType == .receivePhone || cellType == .buyerPhone {
            // 过滤掉非数字
            if let txt = textField.text, txt.isEmpty == false {
                if !RITextInputCell.onlyInputTheNumber(txt) {
                    // 包含非数字
                    textField.text = NSString.getPureNumber(txt)
                }
            }
        }
        
        // 字数限制
        if let content = textField.text, content.isEmpty == false {
            // 有输入
            let count = cellType.typeNumberMax
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
