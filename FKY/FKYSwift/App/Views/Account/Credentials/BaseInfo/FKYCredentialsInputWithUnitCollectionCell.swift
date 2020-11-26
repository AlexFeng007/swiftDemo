//
//  FKYCredentialsInputWithUnitCollectionCell.swift
//  FKY
//
//  Created by airWen on 2017/7/16.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

class FKYCredentialsInputWithUnitCollectionCell: UICollectionViewCell,UITextFieldDelegate {
    //MARK: Private Proeprty
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(16))
        return label
    }()
    
    fileprivate lazy var textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "0.0  "
        //tf.setValue(RGBColor(0xCCCCCC), forKeyPath: "_placeholderLabel.textColor")
        tf.attributedPlaceholder = NSAttributedString.init(string: "0.0  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16)), NSAttributedString.Key.foregroundColor: RGBColor(0xCCCCCC)])
        tf.font = UIFont.systemFont(ofSize: WH(16))
        tf.textColor = RGBColor(0x9A9A9A)
        tf.textAlignment = .left
        tf.keyboardType = .numberPad
        //tf.setEnablePrevious(false, next: false)
        tf.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        return tf
    }()
    
    fileprivate lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.text = "元"
        label.textColor = RGBColor(0xCCCCCC)
        label.font = UIFont.systemFont(ofSize: WH(16))
        return label
    }()
    
    //MARK: Public Property
    var saveClosure: SingleStringClosure?
    var toastClosure: SingleStringClosure?
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = bg1
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.leading.equalTo(self.contentView.snp.leading).offset(16)
            make.centerY.equalTo(self.contentView)
        })
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldViewDidChange(_:)), for: .editingChanged)
        textField.addDoneOnKeyboard(withTarget: self, action: #selector(ontextFieldDone(_:)))
        self.contentView.addSubview(textField)
        textField.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self.contentView)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(j1)
        })
        
        self.contentView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints({ (make) in
            make.trailing.lessThanOrEqualTo(self.contentView).offset(-WH(8))
            make.centerY.equalTo(self.contentView)
            make.leading.equalTo(textField.snp.trailing)
        })
        
        let viewBottomLine = UIView()
        viewBottomLine.backgroundColor = RGBColor(0xEEEEEE)
        self.contentView.addSubview(viewBottomLine)
        viewBottomLine.snp.makeConstraints({ (make) in
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-0.5)
            make.height.equalTo(0.5)
            make.leading.equalTo(self.contentView.snp.leading).offset(16)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UITextFieldDelegate
    @objc func ontextFieldDone(_ sender: AnyObject) {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            let withOutdot = (text as NSString).replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions(rawValue: UInt(0)), range: NSMakeRange(0, text.count))
            if ((withOutdot as NSString).isPureInteger() == false && self.toastClosure != nil){
                self.toastClosure!("起售价为整数")
            }else{
                if let saveClosure = self.saveClosure {
                    saveClosure(withOutdot)
                }
            }
        }
    }
    
    @objc func textFieldViewDidChange(_ textField: UITextField) {
        // 过滤表情符
        if NSString.stringContainsEmoji(textField.text) || NSString.hasEmoji(textField.text) {
            textField.text = NSString.disableEmoji(textField.text)
        }
        
        if let text = textField.text, text != "" {
            let numberString: [String] = (text as NSString).components(separatedBy: CharacterSet.decimalDigits.inverted)//.componentsSeparatedByString(".")
            if numberString.count > 1 {
                if let toastClosure = self.toastClosure {
                    toastClosure("起售价为整数")
                }
            }
            if let withOutdot: String = numberString.first, withOutdot != "" {
                if withOutdot.count >= 11 {
                    textField.text = (text as NSString).substring(to: 10)
                }else{
                    textField.text = withOutdot
                }
                rightLabel.textColor = RGBColor(0x9A9A9A)
            }else{
                textField.text = ""
                rightLabel.textColor = RGBColor(0xCCCCCC)
            }
        }else{
            rightLabel.textColor = RGBColor(0xCCCCCC)
        }
        textField.invalidateIntrinsicContentSize()
    }
    
    func configCell(title: String?, content: String?) {
        titleLabel.text = title
        textField.text = content
        if let content = content, content != "" {
            rightLabel.textColor = RGBColor(0x9A9A9A)
        }else{
            rightLabel.textColor = RGBColor(0xCCCCCC)
        }
    }
}
