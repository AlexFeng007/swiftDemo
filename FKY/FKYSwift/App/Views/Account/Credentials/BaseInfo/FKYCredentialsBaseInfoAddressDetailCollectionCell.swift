//
//  FKYCredentialsBaseInfoAddressDetailCollectionCell.swift
//  FKY
//
//  Created by airWen on 2017/7/14.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  企业基本信息之详细地址ccell or 用户输入ccell

import UIKit

class FKYCredentialsBaseInfoAddressDetailCollectionCell: UICollectionViewCell, UITextViewDelegate {
    //MARK: - Private Property
    
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
    
    // 标题
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(16))
        return label
    }()
    
    // 输入框
    fileprivate lazy var inputText: FKYCenterContentTextView = {
        let tf = FKYCenterContentTextView()
        tf.text = "请填写"
        tf.font = UIFont.systemFont(ofSize: WH(16))
        tf.textColor = RGBColor(0x999999)
        tf.showsHorizontalScrollIndicator = false
        tf.showsVerticalScrollIndicator = false
        tf.textAlignment = .left
        return tf
    }()
    
    // 占位文描
    fileprivate var placeHolder: String?
    
    
    //MARK: - Public Property
    
    var saveClosure: SingleStringClosure?
    var toastClosure: SingleStringClosure?
    var inputTextMaxLong: Int = 50
    var canEdit: Bool = true
    
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        
        self.contentView.addSubview(inputText)
        inputText.snp.makeConstraints({ (make) in
            make.trailing.equalTo(self.contentView.snp.trailing).offset(WH(-j1))
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.titleLabel.snp.right).offset(WH(5))
        })
        inputText.delegate = self
        
        let viewBottomLine = UIView()
        viewBottomLine.backgroundColor = RGBColor(0xEEEEEE)
        self.contentView.addSubview(viewBottomLine)
        viewBottomLine.snp.makeConstraints({ (make) in
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(0)
            make.height.equalTo(0.5)
            make.leading.equalTo(self.contentView.snp.leading).offset(16)
        })
        
        self.backgroundColor = bg1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public
    
    func configCell(_ title: String, isShowStarView: Bool) {
        self.titleLabel.text = title
        configCell(title, content: nil, isShowStarView: isShowStarView)
    }
    
    func configCell(_ title: String , inputText: String?, isShowStarView: Bool) {
        configCell(title, content: inputText, isShowStarView: isShowStarView)
    }
    
    func configCell(_ title: String , content: String?, isShowStarView: Bool) {
        configCell(title, content: content, type: .BaseInfo, isShowStarView: isShowStarView)
    }
    
    func configCell(_ title: String, content: String?, type: ZZEnterpriseInputType, defaultContent: String?, isShowStarView: Bool) {
        self.titleLabel.text = title.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if type == .TelePhone {
            inputText.keyboardType = .phonePad
        } else if type == .BankCode {
            inputText.keyboardType = .numberPad
        }else{
            inputText.keyboardType = .default
        }
        
        self.placeHolder = defaultContent;
        if let content = content, content != "" {
            // 不为空
            inputText.textColor = RGBColor(0x333333)
            inputText.text = content
        }
        else {
            // 为空
            inputText.textColor = RGBColor(0x999999)
            inputText.text = self.placeHolder
        }
        
        self.inputText.isEditable = canEdit
        
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
    
    func configCell(_ title: String, content: String?, type: ZZEnterpriseInputType, isShowStarView: Bool) {
        self.titleLabel.text = title.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if content != nil && content != "" {
            // 不为空
            inputText.textColor = RGBColor(0x333333)
            inputText.text = content
        }
        else {
            // 为空
            inputText.textColor = RGBColor(0x999999)
            self.placeHolder = "请填写";
            inputText.text = self.placeHolder
        }
        
        if type == .TelePhone {
            inputText.keyboardType = .phonePad
        } else if type == .BankCode {
            inputText.keyboardType = .numberPad
        }else{
            inputText.keyboardType = .default
        }
        
        self.inputText.isEditable = canEdit
        self.inputText.isSelectable = canEdit
        
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
    
    
    //MARK: - Custom
    
    func updateLayout(_ type: ZZEnterpriseBankInputType) {
        if type == .BankAccountName {
            inputText.snp.updateConstraints({ (make) in
                make.left.equalTo(self.titleLabel.snp.right).offset(WH(22))
            })
        }
        else {
            inputText.snp.updateConstraints({ (make) in
                make.left.equalTo(self.titleLabel.snp.right).offset(WH(5))
            })
        }
        layoutIfNeeded()
    }
    
    
    //MARK: - UITextViewDelegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        var content = ""
        if let txt = textView.text, txt.isEmpty == false {
            // 有值
            content = txt
            textView.textColor = RGBColor(0x333333)
        }
        else {
            // 无值
            textView.textColor = RGBColor(0x999999)
            textView.text = self.placeHolder
        }
        // 回调
        if let saveClosure = self.saveClosure {
            saveClosure(content)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == self.placeHolder {
            textView.text = ""
            textView.textColor = RGBColor(0x333333)
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
         inputText.centerTextContainerView()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.endEditing(true)
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // 过滤表情符
        if NSString.stringContainsEmoji(textView.text) || NSString.hasEmoji(textView.text) {
            textView.text = NSString.disableEmoji(textView.text)
        }
        
        if let text = textView.text {
            let str = text as NSString
            if str.length >= (inputTextMaxLong+1) {
                textView.text = str.substring(to: inputTextMaxLong)
            }
        }
    }
}
