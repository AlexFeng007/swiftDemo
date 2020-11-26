//
//  CredentialsInputCollectionCell.swift
//  FKY
//
//  Created by yangyouyong on 2016/10/27.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit
import SnapKit

class CredentialsInputCollectionCell: UICollectionViewCell, UITextFieldDelegate {
    // 必填标记
    fileprivate lazy var starLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF394E)
        label.font = UIFont.systemFont(ofSize: WH(15))
        label.textAlignment = .center
        label.text = "*"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(16))
        return label
    }()
    
    fileprivate lazy var textField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: WH(16))
        tf.textColor = RGBColor(0x333333)
        tf.textAlignment = .left
        tf.placeholder = "请填写"
        //tf.setValue(RGBColor(0x999999), forKeyPath: "_placeholderLabel.textColor")
        tf.attributedPlaceholder = NSAttributedString.init(string: "请填写", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        return tf
    }()
    
    fileprivate var inputType: ZZEnterpriseInputType = .BaseInfo
    var saveClosure: SingleStringClosure?
    var toastClosure: SingleStringClosure?
    var isCanEdit: Bool = true
    var placeholder: String? {
        willSet {
            self.textField.placeholder = newValue
            self.textField.attributedPlaceholder = NSAttributedString.init(string: newValue ?? "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        }
    }
    
    //MARK: Private Method
    fileprivate func setupView() {
        self.backgroundColor = bg1
        
        self.contentView.addSubview(starLabel)
        starLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(WH(15))
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(WH(8))
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(starLabel.snp.right)
            make.centerY.equalTo(self.contentView)
        })
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldViewDidChange(_:)), for: .editingChanged)
        textField.addDoneOnKeyboard(withTarget: self, action: #selector(ontextFieldDone(_:)))
        self.contentView.addSubview(textField)
        textField.snp.makeConstraints({ (make) in
            make.right.equalTo(self.contentView).offset(WH(-j1))
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.titleLabel.snp.right).offset(j1)
        })
        
        // 当冲突时，titleLabel不被压缩，textField可以被压缩
        // 当前lbl抗拉伸（不想变大）约束的优先级高 UILayoutPriority
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗拉伸（不想变大）约束的优先级低
        textField.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        // 当冲突时，titleLabel不被拉伸，textField可以被拉伸
        // 当前lbl抗压缩（不想变小）约束的优先级高
        titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗压缩（不想变小）约束的优先级低
        textField.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        let viewBottomLine = UIView()
        viewBottomLine.backgroundColor = RGBColor(0xEEEEEE)
        self.contentView.addSubview(viewBottomLine)
        viewBottomLine.snp.makeConstraints({ (make) in
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(0)
            make.height.equalTo(0.5)
            make.leading.equalTo(self.contentView.snp.leading).offset(16)
        })
    }
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public Method
    func configCell(_ title: String, isShowStarView: Bool){
        self.titleLabel.text = title
        configCell(title, content: nil, isShowStarView: isShowStarView)
    }
    
    func configCell(_ title: String , content: String?, isShowStarView: Bool){
        self.titleLabel.text = title
        textField.text = content
        self.textField.isUserInteractionEnabled = isCanEdit
        
        starLabel.isHidden = !isShowStarView
        starLabel.snp.updateConstraints { (make) in
            if isShowStarView {
                make.width.equalTo(WH(8))
            }
            else {
                make.width.equalTo(0)
            }
        }
    }
    
    func configCell(_ title: String, content: String?, type: ZZEnterpriseInputType, isShowStarView: Bool){
        configCell(title, content: content, isShowStarView: isShowStarView)
        if type == .TelePhone {
            textField.keyboardType = .phonePad
        } else if type == .BankCode || type == .InvitationCode || type == .ShopNum  {
            textField.keyboardType = .numberPad
        } else {
            textField.keyboardType = .default
        }
        inputType = type
    }
    
    func configCell(_ title: String, content: String?, type: ZZEnterpriseInputType, font: UIFont?, isShowStarView: Bool){
        configCell(title, content: content, type: type, isShowStarView: isShowStarView)
        self.titleLabel.font = font
    }
    
    func configCell(_ title: String, content: String?, type: ZZEnterpriseInputType, defaultContent: String?, isShowStarView: Bool){
        configCell(title, content: content, type: type, isShowStarView: isShowStarView)
        
        if let defaultContent = defaultContent, defaultContent != "" {
            textField.placeholder = defaultContent;
            textField.attributedPlaceholder = NSAttributedString.init(string: defaultContent, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        }
        else {
            textField.placeholder = "请填写";
            textField.attributedPlaceholder = NSAttributedString.init(string: "请填写", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        }
    }
    
    //MARK: UITextFieldDelegate
    @objc func ontextFieldDone(_ sender: AnyObject) {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if self.inputType == .TelePhone {
                if ((text as NSString).isPhoneNumber() == false && self.toastClosure != nil) {
                    self.toastClosure!("手机号输入有误")
                } else {
                    if let saveClosure = self.saveClosure {
                        saveClosure(text)
                    }
                }
            } else if inputType == .ShopNum, toastClosure != nil {
//                if text.count == 0 {
//                    toastClosure!("请输入门店数")
//                }
                if let saveClosure = self.saveClosure {
                    saveClosure(text)
                }
            } else {
                if let saveClosure = self.saveClosure {
                    saveClosure(text)
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        func onlyInputTheNumber(_ string: String) -> Bool {
            let numString = "[0-9]*"
            let predicate = NSPredicate(format: "SELF MATCHES %@", numString)
            return predicate.evaluate(with: string)
        }
        if self.inputType == .ShopNum {
            return onlyInputTheNumber(string)
        }
        return true
    }
    
    @objc func textFieldViewDidChange(_ textField: UITextField) {
        // 过滤表情符
        if NSString.stringContainsEmoji(textField.text) || NSString.hasEmoji(textField.text) {
            textField.text = NSString.disableEmoji(textField.text)
        }
        
        if let text = textField.text {
            let str = text as NSString
            
            switch self.inputType {
            case .BaseInfo:
                if str.length >= 21 {
                    textField.text = str.substring(to: 20)
                }
                break
            case .EnterpriseName:
                if str.length >= 34 {
                    textField.text = str.substring(to: 33)
                }
                break
            case .LegalPerson,.ContectPerson:
                if str.length >= 11 {
                    textField.text = str.substring(to: 10)
                }
                break
            case .TelePhone:
                if str.length >= 13 {
                    textField.text = str.substring(to: 12)
                }
                break
            case .BankCode: // 银行账号限制为30位
                if str.length >= 31 {
                    textField.text = str.substring(to: 30)
                }
                break
            case .BankName:
                fallthrough
            case .BankAccountName:
                if str.length >= 61 {
                    textField.text = str.substring(to: 60)
                }
                break
            case .InvitationCode:
                if str.length >= 7 {
                    textField.text = str.substring(to: 6)
                }
                break
            case .SalesManPhone:
                if str.length >= 31 {
                    textField.text = str.substring(to: 30)
                }
                break
            default:
                break
            }
        }
    }
    
}
