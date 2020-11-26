//
//  PDLowPriceInputCell.swift
//  FKY
//
//  Created by 寒山 on 2020/3/12.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class PDLowPriceInputCell: UITableViewCell {
    var changeText: ( (String?)->() )?
    var beginEditing: emptyClosure?
    var endEditing: emptyClosure?
    
    // cell类型...<默认为企业名称>
    var cellType: PDLowPriceTextInputType = .lowPriceInfoType
    
    // 星号
    fileprivate lazy var lblStar: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .center
        lbl.text = "*"
        return lbl
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
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
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14)), NSAttributedString.Key.foregroundColor: RGBColor(0xCCCCCC)])
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
            make.width.lessThanOrEqualTo(WH(60))
        }
        txtfield.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(85))
            make.right.equalTo(contentView).offset(-WH(15))
            make.height.equalTo(WH(36))
        }
    }
    
}
extension PDLowPriceInputCell {
    //
    func configCell(_ type: PDLowPriceTextInputType, _ content: String?) {
        // 显示
        contentView.isHidden = false
        // 赋值
        txtfield.text = content
        
        // 根据类型设置输入框属性
        lblTitle.text = type.typeName
        txtfield.placeholder = type.typeDescription
        txtfield.keyboardType = type.typeKeyboard
        
        txtfield.attributedPlaceholder = NSAttributedString.init(string: type.typeDescription, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(13)), NSAttributedString.Key.foregroundColor: RGBColor(0xCCCCCC)])
        
        // 必填...<显示星号>
        lblTitle.snp.updateConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(22))
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


extension PDLowPriceInputCell {
    // 仅可输入数字
    class func onlyInputTheNumber(_ string: String) -> Bool {
        let numString = "[0-9]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", numString)
        let number = predicate.evaluate(with: string)
        return number
    }
}


extension PDLowPriceInputCell: UITextFieldDelegate {
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

         if cellType == .userPhoneType {
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
// 资料管理之输入框类型
enum PDLowPriceTextInputType: Int {
    // 所有类型
    case lowPriceInfoType = 0             // 价格输入
    case userPhoneType = 1             // 填写手机号

    
    // 标题
    var typeName: String {
        switch self {
        case .lowPriceInfoType:
            return "期望价格"
        case .userPhoneType:
            return "手机号"
        }
    }
    // 描述
       var typeDescription: String {
           switch self {
           case .lowPriceInfoType:
               return "低于此价格会通知您"
           case .userPhoneType:
               return "请输入1开头手机号"
           }
       }
    // 是否必填
    var typeInputMust: Bool {
        switch self {
        case .lowPriceInfoType:
            return true
        case .userPhoneType:
            return true
        }
    }
    
    // 输入框最大可输入字数
    var typeNumberMax: Int {
        switch self {
        case .lowPriceInfoType:
            return 50
        case .userPhoneType:
            return 12
        }
    }
    // 输入框键盘类型
    var typeKeyboard: UIKeyboardType {
        switch self {
        case .lowPriceInfoType:
            return .decimalPad
        case .userPhoneType:
            return .numberPad
        }
    }
}
