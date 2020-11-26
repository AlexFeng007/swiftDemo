//
//  CredentialsInputCCell.swift
//  FKY
//
//  Created by 夏志勇 on 2017/11/2.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  新增／编辑地址界面之普通输入ccell

import UIKit
import SnapKit

class CredentialsInputCCell: UICollectionViewCell, UITextFieldDelegate {
    //MARK: - Property
    
    // 标题...<不可压缩，不可拉伸>
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(15))
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        return label
    }()
    
    // 输入框...<可压缩，可拉伸>
    fileprivate lazy var textField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.placeholder = "请填写"
        //tf.setValue(RGBColor(0x9F9F9F), forKeyPath: "_placeholderLabel.textColor")
        tf.attributedPlaceholder = NSAttributedString.init(string: "请填写", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(15)), NSAttributedString.Key.foregroundColor: RGBColor(0x9F9F9F)])
        tf.textColor = RGBColor(0x343434)
        tf.font = UIFont.systemFont(ofSize: WH(15))
        tf.textAlignment = .right
        tf.returnKeyType = .done
        tf.addTarget(self, action: #selector(textFieldViewDidChange(_:)), for: .editingChanged)
        //tf.setEnablePrevious(false, next: false)
        //tf.addDoneOnKeyboard(withTarget: self, action: #selector(onTextFieldDone(_:)))
        tf.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 800), for: NSLayoutConstraint.Axis.horizontal)
        tf.setContentHuggingPriority(UILayoutPriority(rawValue: 800), for: NSLayoutConstraint.Axis.horizontal)
        return tf
    }()
    
    // 输入框类型
    fileprivate var inputType: ZZEnterpriseInputType = .BaseInfo
    var saveClosure: SingleStringClosure?
    var toastClosure: SingleStringClosure?
    var isCanEdit: Bool = true
    var placeholder: String? {
        willSet {
            self.textField.placeholder = newValue
            self.textField.attributedPlaceholder = NSAttributedString.init(string: newValue ?? "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(15)), NSAttributedString.Key.foregroundColor: RGBColor(0x9F9F9F)])
        }
    }
    
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - UI
    
    fileprivate func setupView() {
        self.backgroundColor = bg1
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.leading.equalTo(self.contentView.snp.leading).offset(j5)
            make.centerY.equalTo(self.contentView)
        })
        
        self.contentView.addSubview(textField)
        textField.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-j5)
            make.left.equalTo(self.titleLabel.snp.right).offset(j1)
        })
        
        let viewBottomLine = UIView()
        viewBottomLine.backgroundColor = RGBColor(0xD8D8D8)
        self.contentView.addSubview(viewBottomLine)
        viewBottomLine.snp.makeConstraints({ (make) in
            make.leading.equalTo(self.contentView.snp.leading).offset(j5)
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.bottom.equalTo(self.contentView.snp.bottom)
            make.height.equalTo(0.6)
        })
    }
    
    
    //MARK: - Public
    
    func configCell(_ title: String, content: String?, type: ZZEnterpriseInputType) {
        self.titleLabel.text = title
        self.textField.text = content
        var deafaultStr = "请填写"
        self.inputType = type
        if type == .TelePhone {
            textField.keyboardType = .phonePad
            if  title == "手机号或固话" {
                deafaultStr = "1开头手机号或0开头固话"
            }else if  title == "联系方式" {
                deafaultStr = "请填写采购员联系方式"
            }
        } else if (type == .BankCode || type == .InvitationCode) {
            textField.keyboardType = .numberPad
        } else{
            if title == "采购员"{
                deafaultStr = "请填写采购员姓名"
            }else if title == "详细地址"{
                deafaultStr = "请填写收货详细地址"
            }else if title == "收货人"{
                deafaultStr = "请填写收货人姓名"
            }
            textField.keyboardType = .default
        }
        textField.placeholder = deafaultStr
        textField.attributedPlaceholder = NSAttributedString.init(string: deafaultStr, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(15)), NSAttributedString.Key.foregroundColor: RGBColor(0x9F9F9F)])
    }
    
    
    //MARK: - Private
    
    // 仅可输入数字
    func onlyInputTheNumber(_ string: String) -> Bool {
        let numString = "[0-9]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", numString)
        let number = predicate.evaluate(with: string)
        return number
    }
    
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        if self.inputType == .TelePhone {
        //            let currentText = textField.text ?? ""
        //            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        //            if self.onlyInputTheNumber(newText) {
        //                return true
        //            }
        //            return false
        //        }
        return true
    }
    
    // 编辑完成、键盘隐藏
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if self.inputType == .TelePhone {
                // 手机号
                if ((text as NSString).isPhoneNumber() == false && self.toastClosure != nil) {
                    self.toastClosure!("手机号输入有误")
                } else {
                    if let saveClosure = self.saveClosure {
                        saveClosure(text)
                    }
                }
            } else {
                // 其它
                if let saveClosure = self.saveClosure {
                    saveClosure(text)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 完成
    //    func onTextFieldDone(_ sender: AnyObject) {
    //        textField.resignFirstResponder()
    //    }
    
    @objc func textFieldViewDidChange(_ textField: UITextField) {
        // 过滤表情符
        if NSString.stringContainsEmoji(textField.text) || NSString.hasEmoji(textField.text) {
            textField.text = NSString.disableEmoji(textField.text)
        }
        
        // 手机号单独考虑
        if self.inputType == .TelePhone {
            // 过滤掉非数字
            if let txt = textField.text, txt.isEmpty == false {
                if !self.onlyInputTheNumber(txt) {
                    // 包含非数字
                    textField.text = NSString.getPureNumber(txt)
                }
            }
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
            case .LegalPerson, .ContectPerson:
                if str.length >= 11 {
                    textField.text = str.substring(to: 10)
                }
                break
            case .TelePhone:
                if str.length >= 13 {
                    textField.text = str.substring(to: 12)
                }
                break
            case .BankCode:
                if str.length >= 21 {
                    textField.text = str.substring(to: 20)
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
            case .AddressDetail:
                if str.length >= 101 {
                    textField.text = str.substring(to: 100)
                }
                break
            default:
                break
            }
        }
    }
}
