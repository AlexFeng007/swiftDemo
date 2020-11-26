//
//  FKYOtherReasonCell.swift
//  FKY
//
//  Created by My on 2019/12/11.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYOtherReasonCell: UITableViewCell {
    
    // closure
    var selectBlock: (()->())?
    var beginEditingClosure: (()->())?
    var endEditingClosure: (()->())?
    var didChangeClosure: ((String?)->())?
    
    var isFirstResponser = false
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    // 单选按钮
    fileprivate lazy var btnSelect: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        btn.setImage(UIImage(named: "img_pd_select_select"), for: .selected)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            if let strongSelf = self {
                if strongSelf.btnSelect.isSelected {
                    return
                }
                strongSelf.selectBlock?()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    lazy var otherView: YYTextView = {
        let view = YYTextView()
        view.delegate = self
        view.returnKeyType = .done
        view.placeholderText = "请填写原因"
        view.placeholderTextColor = RGBColor(0x999999)
        view.placeholderFont = UIFont.systemFont(ofSize: WH(14))
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.textColor = RGBColor(0x999999)
        view.font = UIFont.systemFont(ofSize: WH(14))
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.textContainerInset = UIEdgeInsets(top: WH(10), left: WH(10), bottom: WH(10), right: WH(10))
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//        otherView.becomeFirstResponder()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension FKYOtherReasonCell {
    func setupView() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(btnSelect)
        contentView.addSubview(lblTitle)
        contentView.addSubview(otherView)
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(30))
            make.right.equalTo(btnSelect.snp.left).offset(WH(-10))
            make.top.equalTo(contentView)
            make.height.equalTo(WH(43))
        }
        
        btnSelect.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-WH(30))
            make.centerY.equalTo(lblTitle)
            make.size.equalTo(CGSize.init(width: WH(40), height: WH(40)))
        }
        
        otherView.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle)
            make.right.equalTo(btnSelect)
            make.height.equalTo(WH(85))
            make.top.equalTo(lblTitle.snp_bottom)
        }
    }
    
    func configCell(_ model: FKYOrderResonModel, _ selected: Bool) {
        lblTitle.text = model.reason
        btnSelect.isSelected = selected
    }
    

    
    func becomeResponser() {
        otherView.becomeFirstResponder()
    }
}

extension FKYOtherReasonCell: YYTextViewDelegate {
    func textView(_ textView: YYTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let inputMode = textView.textInputMode, let language = inputMode.primaryLanguage, language.isEmpty == false else {
            return false
        }
        if language == "emoji" {
            // 禁止输入emoji
            return false
        }
        
        if text == "\n" {
            // 完成
            textView.resignFirstResponder()
            return false
        }
        return true
    }

//    func textViewDidBeginEditing(_ textView: YYTextView) {
//        textView.reloadInputViews()
//        beginEditingClosure?()
//    }
    
    func textViewShouldBeginEditing(_ textView: YYTextView) -> Bool {
        textView.reloadInputViews()
        beginEditingClosure?()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: YYTextView) -> Bool {
        endEditingClosure?()
        return true
    }
    
    func textViewDidChange(_ textView: YYTextView) {
        
        // 过滤表情符
        if NSString.stringContainsEmoji(textView.text) || NSString.hasEmoji(textView.text) {
            textView.text = NSString.disableEmoji(textView.text)
        }
        
        // 过滤空格
        if let txt = textView.text, txt.isEmpty == false {
            // 先判断是否有包含空格...<如果每次均直接设置的话，则光标每次都会重置到最后>
            if (txt as NSString).contains(" ") {
                textView.text = txt.replacingOccurrences(of: " ", with: "")
            }
        }
        
        // 字数限制
         if let content = textView.text, content.isEmpty == false {
             // 字数限制
             let count = 200
             if content.count >= count + 1 {
                 textView.text = content.substring(to: content.index(content.startIndex, offsetBy: count))
             }
         }
        
        didChangeClosure?(textView.text)
    }
}
