//
//  RCSendInfoCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/21.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退换货之回寄信息界面cell

import UIKit

// 回寄信息类型
enum RCInputType: Int {
    case sendOrderId = 0    // 快递单号
    case bankName = 1       // 开户行
    case bankAccount = 2    // 银行账户
    case userName = 3       // 开户名
}


class RCSendInfoCell: UITableViewCell {
    // MARK: - Property
    
    // closure
    var inputOver: ((String?, RCInputType)->())? // 输入完成时回调
    
    // 输入框类型...<默认快递单号>
    fileprivate var inputType: RCInputType = .sendOrderId
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        return lbl
    }()
    
    // 背景图
    fileprivate lazy var viewBg: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF6F6F6)
        view.layer.cornerRadius = WH(4)
        view.layer.masksToBounds = true
        return view
    }()
    // 下划线
    fileprivate lazy var bottomLine: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    // 内容
    fileprivate lazy var txtfieldContent: UITextField = {
        let txtfield = UITextField()
        txtfield.delegate = self
//        txtfield.backgroundColor = RGBColor(0xF6F6F6)
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.textAlignment = .left
        txtfield.font = UIFont.systemFont(ofSize: WH(13))
        txtfield.textColor = RGBColor(0x333333)
        txtfield.returnKeyType = .done
        txtfield.clearButtonMode = .whileEditing
        txtfield.autocapitalizationType = .none
        txtfield.autocorrectionType = .no
//        txtfield.layer.cornerRadius = WH(4)
//        txtfield.layer.masksToBounds = true
//        txtfield.placeholder = "请输入"
//        txtfield.setValue(RGBColor(0x999999), forKeyPath: "_placeholderLabel.textColor")
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
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(20))
            make.centerY.equalTo(contentView)
            make.width.equalTo(WH(60))
        }
        
        contentView.addSubview(viewBg)
        viewBg.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(10))
            make.right.equalTo(contentView).offset(WH(-20))
            make.centerY.equalTo(contentView)
            make.height.equalTo(WH(30))
        }
        
        contentView.addSubview(txtfieldContent)
        txtfieldContent.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(15))
            make.right.equalTo(contentView).offset(WH(-25))
            make.centerY.equalTo(contentView)
            make.height.equalTo(WH(30))
        }
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(15))
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(title: String, content: String?, type: RCInputType) {
        inputType = type
        lblTitle.text = title
        txtfieldContent.text = content
        updateInputType()
        bottomLine.isHidden = true
    }
    
    //配置填写退款信息界面的cell
    func configBankInfoCell(title: String, placeholderStr: String , content: String?, type: RCInputType){
        lblTitle.snp.remakeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(17))
            make.centerY.equalTo(contentView)
            make.width.equalTo(WH(60))
        }
        viewBg.isHidden = true
        if type == .userName {
            bottomLine.isHidden = true
        }else {
            bottomLine.isHidden = false
        }
        inputType = type
        lblTitle.text = title
        txtfieldContent.text = content
        txtfieldContent.placeholder = placeholderStr
        updateInputType()
    }
    
    
    // MARK: - Private

    // 根据输入类型来设置输入框类型
    fileprivate func updateInputType() {
        switch inputType {
        case .sendOrderId, .bankAccount:
            // ascii键盘
            txtfieldContent.keyboardType = .asciiCapable
        case .bankName, .userName:
            // 默认键盘
            txtfieldContent.keyboardType = .default
        }
    }
}

// MARK: - UITextFieldDelegate
extension RCSendInfoCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 隐藏键盘
        textField.endEditing(true)
        return true
        
//        guard let block = inputOver else {
//            return true
//        }
//        block(textField.text, inputType)
//        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let block = inputOver else {
            return true
        }
        guard let text = textField.text, text.isEmpty == false else {
            block(nil, inputType)
            return true
        }
        
        // 去掉前后空格和空行
        let txt = text.trimmingCharacters(in: .whitespacesAndNewlines)
        textField.text = txt
        
        // 指定输入框只可输入汉字
        switch self.inputType {
        case .bankName, .userName: // 开户行/开户名...<2~50个汉字>
            textField.text = NSString.filter(forChinese: txt)
        default:
            break
        }
        
        // 回调
        block(textField.text, inputType)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = string as NSString
        if str.length > 0 {
            // 输入判断
            switch self.inputType {
            case .sendOrderId, .bankAccount: // 快递单号<8~30位长度的数字和字母> & 银行账户<10~30位长度的数字和字母>
                let valid = NSString.validateOnlyEnglishAndNumber(str as String)
                return valid
            case .bankName, .userName: // 开户行<2~50个汉字> & 开户名<2~50个汉字>
//                let valid = NSString.validateOnlyChinese(str as String)
//                return valid
                return true
            }
        }
        return true
    }
    
    // 字数控制
    @objc func textfieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, text.isEmpty == false else {
            return
        }
        
        let str: NSString = text as NSString
        switch self.inputType {
        case .sendOrderId, .bankAccount: // 快递单号 & 银行账户 <最长30>
            if str.length >= 31 {
                textField.text = str.substring(to: 30)
            }
        case .bankName, .userName: // 开户行 & 开户名 <最长50>
//            if str.length >= 51 {
//                textField.text = str.substring(to: 50)
//            }
            // 仅能输入汉字~!@
            if let selectedRange = textField.markedTextRange, let newText = textField.text(in: selectedRange), newText.isEmpty == false {
                // 有高亮文字...<不处理>
            }
            else {
                // 无高亮选择的文字...<过滤掉非汉字>
                textField.text = NSString.filter(forChinese: str as String)
                guard let txt = textField.text, txt.isEmpty == false else {
                    return
                }
                let st: NSString = txt as NSString
                if st.length >= 51 {
                    textField.text = st.substring(to: 50)
                }
            }
        }
    }
}
