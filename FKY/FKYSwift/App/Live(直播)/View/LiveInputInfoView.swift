//
//  LiveInputInfoView.swift
//  FKY
//
//  Created by yyc on 2020/8/18.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

//MARK:输入群聊信息
class LiveInputInfoView: UIView {
    
    // 响应视图
    fileprivate lazy var viewDismiss: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        return view
    }()
    // 内容视图...<包含所有内容的容器视图>
    fileprivate lazy var viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    // 内容输入框...<单行>
    fileprivate lazy var messageTxtfield: UITextField = {
        let txtfield = UITextField()
        txtfield.delegate = self
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.returnKeyType = .send
        txtfield.font = UIFont.boldSystemFont(ofSize: WH(15))
        txtfield.textColor = RGBColor(0x333333)
        txtfield.autocapitalizationType = .none
        txtfield.autocorrectionType = .no
        //txtfield.setValue(RGBColor(0x999999), forKeyPath: "_placeholderLabel.textColor")
        //txtfield.attributedPlaceholder = NSAttributedString.init(string: "", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: WH(20)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        txtfield.placeholder = "跟主播聊点什么？"
        txtfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        return txtfield
    }()
    
    @objc var viewParent: UIView!
    //内容视图高度
    var heightContentView: CGFloat = WH(50)
    // 最大输入字数
    @objc var maxInputNum: Int = 30
    
    // 输入完毕回调
    @objc var inputOverBlock: ((String?)->())?
    
    var hideKeyInputView = true
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(viewDismiss)
        viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        viewDismiss.bk_(whenTapped: { [weak self] in
            if let strongSelf = self {
                strongSelf.showOrHidePopView(false)
            }
        })
        self.addSubview(viewContent)
        viewContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(heightContentView)
            make.height.equalTo(heightContentView)
        }
        viewContent.addSubview(messageTxtfield)
        messageTxtfield.snp.makeConstraints { (make) in
            make.left.equalTo(viewContent.snp.left).offset(WH(10))
            make.right.equalTo(viewContent.snp.right).offset(-WH(10))
            make.top.equalTo(viewContent.snp.top).offset(WH(10))
            make.bottom.equalTo(viewContent.snp.bottom).offset(-WH(10))
        }
        // 监控键盘
        NotificationCenter.default.addObserver(self, selector: #selector(COInputController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(COInputController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    deinit {
        print("LiveInputInfoView deinit~!@")
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
}
extension LiveInputInfoView {
    func resetInputText(_ copyStr:String) {
        self.showOrHidePopView(true)
        messageTxtfield.text = copyStr
    }
    // 显示or隐藏弹出视图
    @objc func showOrHidePopView(_ show: Bool) {
        // 底部margin
        let margin = COInputController.getScreenBottomMargin()
        
        if show {
            if hideKeyInputView == false {
                return
            }
            hideKeyInputView = false
            // 显示
            if let viewP = viewParent {
                viewP.addSubview(self)
                self.snp.makeConstraints({ (make) in
                    make.edges.equalTo(viewP)
                })
            }
            else {
                let window = UIApplication.shared.keyWindow
                window?.addSubview(self)
                self.snp.makeConstraints({ (make) in
                    make.edges.equalTo(window!)
                })
            }
            IQKeyboardManager.shared().isEnabled = false
            IQKeyboardManager.shared().isEnableAutoToolbar = false
            // 弹出键盘
            messageTxtfield.text = ""
            messageTxtfield.becomeFirstResponder()
            
            // 动画
            viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
            //            UIView.animate(withDuration: 0.3, animations: {[weak self] in
            //                guard let strongSelf = self else {
            //                    return
            //                }
            //                strongSelf .viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
            //                }, completion: { (_) in
            //                    // 弹出键盘
            //                    //self.showKeyboard()
            //            })
        }
        else {
            if hideKeyInputView == true {
                return
            }
            hideKeyInputView = true
            // 隐藏
            IQKeyboardManager.shared().isEnabled = true
            IQKeyboardManager.shared().isEnableAutoToolbar = true
            self.endEditing(true)
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
                strongSelf.viewContent.snp.updateConstraints({[weak self] (make) in
                    guard let strongSelf = self else {
                        return
                    }
                    make.bottom.equalTo(strongSelf).offset(strongSelf.heightContentView + margin)
                })
                strongSelf.layoutIfNeeded()
                }, completion: {[weak self] (_) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.removeFromSuperview()
            })
        }
    }
    // 输入完成后确认...<回传输入内容>
    fileprivate func inputDoneAction() {
        guard let block = inputOverBlock else {
            return
        }
        guard let text = messageTxtfield.text, text.isEmpty == false else {
            block(nil)
            return
        }
        // 去掉前后空格和空行
        let  txt = text.trimmingCharacters(in: .whitespacesAndNewlines)
        // 回调
        block(txt)
    }
}

//MARK:UITextFieldDelegate
extension LiveInputInfoView :UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 隐藏键盘
        guard let text = textField.text, text.isEmpty == false else {
            FKYNavigator.shared()?.visibleViewController.toast("发送内容不能为空哦")
            return true
        }
        self.endEditing(true)
        if self.superview != nil {
            showOrHidePopView(false)
        }
        inputDoneAction()
        return true
    }
    @objc func textfieldDidChange(_ textField: UITextField) {
        // 有未选中的字符
        if let selectedRange = textField.markedTextRange, let newText = textField.text(in: selectedRange), newText.isEmpty == false {
            return
        }
        // 过滤表情符
        //        if NSString.stringContainsEmoji(textField.text) || NSString.hasEmoji(textField.text) {
        //            textField.text = NSString.disableEmoji(textField.text)
        //        }
        if let content = textField.text, content.isEmpty == false {
            // 有输入...<最多30字>
            if content.count >= maxInputNum + 1 {
                textField.text = content.substring(to: content.index(content.startIndex, offsetBy: maxInputNum))
                FKYNavigator.shared()?.visibleViewController.toast("最多只能输入30个汉字哦")
            }
        }
    }
}
// MARK: - Notification
extension LiveInputInfoView {
    // 键盘显示
    @objc func keyboardWillShow(_ notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        // 动画时间
        let time: TimeInterval = info["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval
        // bounds
        let value = info["UIKeyboardBoundsUserInfoKey"]
        let size: CGSize = ((value as AnyObject).cgRectValue.size)
        
        UIView.animate(withDuration: time, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            // 更新布局
            strongSelf.viewContent.snp.updateConstraints {[weak self] (make) in
                guard let strongSelf = self else {
                    return
                }
                make.bottom.equalTo(strongSelf.snp.bottom).offset(-size.height)
            }
            strongSelf.layoutIfNeeded()
        })
    }
    
    // 键盘隐藏
    @objc func keyboardWillHide(_ notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let time: TimeInterval = info["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval
        self.showOrHidePopView(false)
        UIView.animate(withDuration: time, animations: {
            //
        })
    }
}
