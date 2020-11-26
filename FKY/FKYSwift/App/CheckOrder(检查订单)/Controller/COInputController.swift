//
//  COInputController.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/22.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  检查订单之文字输入controller

import UIKit

// 输入类型
@objc enum COInputType: Int {
    case leaveMessage = 0   // 留言
    case couponCode = 1     // 优惠券码
    case rebateNumber = 2   // 使用返利金额
    case emailCode = 3 //邮箱
    case shopBuyMoney = 4 //购物金
}


class COInputController: UIViewController {
    //MARK: - Property
    
    // 响应视图
    fileprivate lazy var viewDismiss: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    // 内容视图...<包含所有内容的容器视图>
    fileprivate lazy var viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    // 顶部视图...<标题、关闭、确定>
    fileprivate lazy var viewTop: COPopTitleView = {
        let view = COPopTitleView.init(frame: CGRect.zero)
        // 取消
        view.closeAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.endEditing(true)
            if strongSelf.view.superview != nil {
                strongSelf.showOrHidePopView(false)
            }
            // 埋点
            switch strongSelf.inputType {
            case .couponCode:
                // 优惠码
                strongSelf.inputOverBlock?("close", .couponCode, true)
            default:
                print("隐藏")
            }
        }
        // 确定
        view.doneAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.endEditing(true)
            if strongSelf.view.superview != nil {
                strongSelf.showOrHidePopView(false)
            }
            // 回传
            strongSelf.inputDoneAction()
        }
        return view
    }()
    // 输入视图
    fileprivate lazy var viewInput: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    // 单行输入视图
    fileprivate lazy var viewSingleLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        // 下划线
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0x333333)
        view.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-WH(13))
            make.left.equalTo(view).offset(WH(30))
            make.right.equalTo(view).offset(-WH(30))
            make.height.equalTo(1.0)
        }
        
        // 输入框
        view.addSubview(self.txtfield)
        self.txtfield.snp.makeConstraints { (make) in
            make.bottom.equalTo(viewLine.snp.top).offset(-WH(10))
            make.left.equalTo(view).offset(WH(30))
            make.right.equalTo(view).offset(-WH(30))
            make.top.equalTo((view)).offset(WH(25))
        }
        
        return view
    }()
    // 内容输入框...<单行>
    fileprivate lazy var txtfield: UITextField = {
        let txtfield = UITextField()
        txtfield.delegate = self
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.keyboardType = .asciiCapable
        txtfield.returnKeyType = .done
        txtfield.textAlignment = .center
        txtfield.font = UIFont.boldSystemFont(ofSize: WH(20))
        txtfield.textColor = RGBColor(0x333333)
        //txtfield.clearButtonMode = .whileEditing
        txtfield.autocapitalizationType = .none
        txtfield.autocorrectionType = .no
        txtfield.placeholder = nil
        //txtfield.setValue(RGBColor(0x999999), forKeyPath: "_placeholderLabel.textColor")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: WH(20)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        txtfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        return txtfield
    }()
    
    // 多行输入视图
    fileprivate lazy var viewMultiLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        // 背景
        let viewBg = UIView()
        viewBg.backgroundColor = RGBColor(0xF3F3F3)
        viewBg.layer.masksToBounds = true
        viewBg.layer.cornerRadius = WH(3)
        view.addSubview(viewBg)
        viewBg.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: WH(10), left: WH(10), bottom: WH(10), right: WH(10)))
        }
        
        // 输入框
        view.addSubview(self.txtview)
        self.txtview.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: WH(10), left: WH(10), bottom: WH(10), right: WH(10)))
        }
        
        return view
    }()
    // 内容输入框...<多行>
    fileprivate lazy var txtview: UITextView = {
        let view = UITextView.init(frame: CGRect.zero)
        view.delegate = self
        view.backgroundColor = .clear
        view.textAlignment = .left
        view.keyboardType = .default
        view.returnKeyType = .done
        view.font = UIFont.systemFont(ofSize: WH(15))
        view.textColor = RGBColor(0x333333)
        view.showsVerticalScrollIndicator = false
        //view.textContainerInset = UIEdgeInsetsMake(5, 0 , 0, 0)
        //view.layoutManager.allowsNonContiguousLayout = false
        return view
    }()
    
    // 父view...<若未赋值，则会使用window>
    @objc var viewParent: UIView!
    
    // 输入类型
    @objc var inputType: COInputType = .couponCode {
        didSet {
            // 界面未展示时对布局进行更新，则更新失效~!@
            //updateForInputType()
        }
    }
    
    // 上个界面传入的字符串内容
    @objc var inputContent: String? {
        didSet {
            //
        }
    }
    
    // 内容标题...<必须赋值>
    @objc var popTitle: String! = "请输入" {
        didSet {
            if let t = popTitle, t.isEmpty == false {
                viewTop.setTitle(t)
            }
            else {
                viewTop.setTitle("请输入")
            }
        }
    }
    
    // 最大可输入的返利金抵扣金额...<仅针对.rebateNumber类型>
    @objc var maxRebateValue: Double = 0.0
    
    // 内容视图高度 135 or 185
    @objc var heightContentView: CGFloat = WH(135) {
        didSet {
            // 界面未展示时对布局进行更新，则更新失效~!@
            //            viewContent.snp.updateConstraints({ (make) in
            //                make.height.equalTo(heightContentView)
            //            })
            //            view.layoutIfNeeded()
        }
    }
    
    // 最大输入字数
    @objc var maxInputNum: Int = 100
    
    // 当前输入的商家对象索引
    @objc var shopIndex: Int = 0
    
    // 输入完毕回调
    @objc var inputOverBlock: ((String?, COInputType, Any?)->())?
    
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
        
        // 监控键盘
        NotificationCenter.default.addObserver(self, selector: #selector(COInputController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(COInputController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // 输入
        NotificationCenter.default.addObserver(self, selector: #selector(COInputController.textFieldDidChanged(_:)), name: UITextField.textDidChangeNotification, object:txtfield)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewContent.snp.updateConstraints({ (make) in
            make.height.equalTo(heightContentView)
        })
        view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    deinit {
        print("COInputController deinit~!@")
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - UI
extension COInputController {
    // 设置UI
    fileprivate func setupView() {
        setupSubView()
        setupContentView()
        setupInputView()
    }
    
    // 第一层UI
    fileprivate func setupSubView() {
        view.backgroundColor = UIColor.clear
        
        view.addSubview(viewDismiss)
        viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(viewContent)
        viewContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-COInputController.getScreenBottomMargin())
            make.height.equalTo(heightContentView)
        }
    }
    
    // 第二层UI
    fileprivate func setupContentView() {
        viewContent.addSubview(viewTop)
        viewContent.addSubview(viewInput)
        
        viewTop.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(viewContent)
            make.height.equalTo(WH(55))
        }
        
        viewInput.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(viewContent)
            make.top.equalTo(viewTop.snp.bottom)
        }
    }
    
    // 第三层UI...<输入视图>
    fileprivate func setupInputView() {
        viewInput.addSubview(viewSingleLine)
        viewInput.addSubview(viewMultiLine)
        
        viewSingleLine.snp.makeConstraints { (make) in
            make.edges.equalTo(viewInput)
        }
        
        viewMultiLine.snp.makeConstraints { (make) in
            make.edges.equalTo(viewInput)
        }
    }
}


// MARK: - EventHandle
extension COInputController {
    // 设置事件
    fileprivate func setupAction() {
        // 隐藏
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.endEditing(true)
            if strongSelf.view.superview != nil {
                strongSelf.showOrHidePopView(false)
            }
        }).disposed(by: disposeBag)
        viewDismiss.addGestureRecognizer(tapGesture)
        
        // 避免键盘隐藏（当前弹出视图却仍然显示）
        let tapGesture_ = UITapGestureRecognizer()
        tapGesture_.rx.event.subscribe(onNext: { _ in
            print("error")
        }).disposed(by: disposeBag)
        viewContent.addGestureRecognizer(tapGesture_)
    }
}


// MARK: - Notification
extension COInputController {
    // 键盘显示
    @objc func keyboardWillShow(_ notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        // 动画时间
        let time: TimeInterval = info["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval
        // bounds
        let value = info["UIKeyboardBoundsUserInfoKey"]
        let size: CGSize = ((value as AnyObject).cgRectValue.size)
        // 获取键盘信息
        //        let keyboardInfo = info["UIKeyboardFrameBeginUserInfoKey"]
        //        let keyboardHeight: CGFloat = (keyboardInfo?.CGRectValue.size.height)!
        
        UIView.animate(withDuration: time, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            // 更新布局
            strongSelf.viewContent.snp.updateConstraints {[weak self] (make) in
                guard let strongSelf = self else {
                    return
                }
                make.bottom.equalTo(strongSelf.view.snp.bottom).offset(-size.height)
            }
            strongSelf.view.layoutIfNeeded()
        })
    }
    
    // 键盘隐藏
    @objc func keyboardWillHide(_ notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let time: TimeInterval = info["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval
        
        UIView.animate(withDuration: time, animations: {
            //
        })
    }
    
    // 输入变化
    @objc func textFieldDidChanged(_ notification: Notification) {
        //        let sender = notification.object as! UITextField
        //        if let str = sender.text {
        //            switch self.inputType {
        //            case .couponCode: // 优惠券码
        //                if str.count >= 21 {
        //                    sender.text = str.substring(to: str.index(str.startIndex, offsetBy: 20))
        //                }
        //            case .rebateNumber: // 金额
        //                if str.count >= 11 {
        //                    sender.text = str.substring(to: str.index(str.startIndex, offsetBy: 10))
        //                }
        //            default:
        //                break
        //            }
        //        }
    }
}


// MARK: - Private
extension COInputController {
    // 根据不同输入类型来更新控件属性
    func updateForInputType() {
        switch inputType {
        case .leaveMessage:
            // 留言...<多行>
            viewTop.setTitle("留言")
            
            viewMultiLine.isHidden = false
            viewSingleLine.isHidden = true
            
            txtview.text = inputContent
            //txtview.becomeFirstResponder()
            
        //heightContentView = WH(185)
        case .couponCode:
            // 优惠券码...<单行>
            viewTop.setTitle("优惠码")
            
            viewMultiLine.isHidden = true
            viewSingleLine.isHidden = false
            
            txtfield.placeholder = "请填写优惠券码"
            txtfield.text = inputContent
            //txtfield.becomeFirstResponder()
            txtfield.keyboardType = .asciiCapable
            
            txtfield.attributedPlaceholder = NSAttributedString.init(string: "请填写优惠券码", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: WH(20)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
            
        //heightContentView = WH(135)
        case .rebateNumber:
            // 返利金额...<单行>
            viewTop.setTitle("返利金抵扣金额")
            
            viewMultiLine.isHidden = true
            viewSingleLine.isHidden = false
            
            txtfield.placeholder = "请输入抵扣金额"
            txtfield.text = inputContent
            //txtfield.becomeFirstResponder()
            txtfield.keyboardType = .decimalPad
            
            txtfield.attributedPlaceholder = NSAttributedString.init(string: "请输入抵扣金额", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: WH(20)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
            
            if maxRebateValue > 0 {
                txtfield.placeholder = String(format: "本单最高可抵%.2f元", maxRebateValue)
                txtfield.attributedPlaceholder = NSAttributedString.init(string: String(format: "本单最高可抵%.2f元", maxRebateValue), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: WH(20)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
            }
            
        //heightContentView = WH(135)
        case .emailCode:
            // 邮箱...<单行>
            viewTop.setTitle("发送邮箱")
            
            viewMultiLine.isHidden = true
            viewSingleLine.isHidden = false
            
            txtfield.placeholder = "请填写发送邮箱"
            txtfield.text = inputContent
            //txtfield.becomeFirstResponder()
            //txtfield.keyboardType = .asciiCapable
            
            txtfield.attributedPlaceholder = NSAttributedString.init(string: "请填写发送邮箱", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: WH(20)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
            
        //heightContentView = WH(135)
        case .shopBuyMoney:
            // 返利金额...<单行>
            viewTop.setTitle("购物金")
            
            viewMultiLine.isHidden = true
            viewSingleLine.isHidden = false
            
            txtfield.placeholder = "请输入购物金额"
            txtfield.text = inputContent
            //txtfield.becomeFirstResponder()
            txtfield.keyboardType = .decimalPad
            
            txtfield.attributedPlaceholder = NSAttributedString.init(string: "请输入购物金额", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
            
            if maxRebateValue > 0 {
                
                txtfield.placeholder = String(format: "当前共%.2f元可使用", maxRebateValue)
                txtfield.attributedPlaceholder = NSAttributedString.init(string: String(format: "当前共%.2f元可使用", maxRebateValue), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
            }
            
        }
        
        print("内容视图高度：\(heightContentView)")
        
        // 更新内容视图高度
        viewContent.snp.updateConstraints { (make) in
            make.height.equalTo(heightContentView)
        }
        view.layoutIfNeeded()
    }
    
    // 弹出键盘
    fileprivate func showKeyboard() {
        switch inputType {
        case .leaveMessage:
            // 留言
            txtview.becomeFirstResponder()
        case .couponCode:
            // 优惠券码
            txtfield.becomeFirstResponder()
        case .rebateNumber, .shopBuyMoney:
            // 返利金额 or 购物金
            txtfield.becomeFirstResponder()
        case .emailCode:
            //邮箱
            txtfield.becomeFirstResponder()
        }
    }
    
    // 输入完成后确认...<回传输入内容>
    fileprivate func inputDoneAction() {
        guard let block = inputOverBlock else {
            return
        }
        
        // 回传字符串
        var txt = ""
        
        switch inputType {
        case .leaveMessage:
            // 留言
            guard let text = txtview.text, text.isEmpty == false else {
                block(nil, inputType, nil)
                return
            }
            
            // 去掉前后空格和空行
            txt = text.trimmingCharacters(in: .whitespacesAndNewlines)
        case .couponCode, .rebateNumber ,.shopBuyMoney:
            // 优惠券码 or 返利金 or 邮箱  or 购物金
            guard let text = txtfield.text, text.isEmpty == false else {
                block(nil, inputType, nil)
                return
            }
            
            // 去掉前后空格和空行
            txt = text.trimmingCharacters(in: .whitespacesAndNewlines)
        case .emailCode:
            guard let text = txtfield.text, text.isEmpty == false else {
                self.toast("邮箱不能为空")
                return
            }
            if text.isEmailAddress() == false {
                self.toast("邮箱格式错误")
                return
            }
            txt = text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // 回调
        block(txt, inputType, nil)
    }
}


// MARK: - Public
extension COInputController {
    // 显示or隐藏弹出视图
    @objc func showOrHidePopView(_ show: Bool) {
        // 底部margin
        let margin = COInputController.getScreenBottomMargin()
        
        if show {
            // 显示
            if let viewP = viewParent {
                viewP.addSubview(view)
                view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(viewP)
                })
            }
            else {
                let window = UIApplication.shared.keyWindow
                window?.addSubview(view)
                view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(window!)
                })
            }
            
            // 更新输入框...<包括重设高度>
            updateForInputType()
            
            // 弹出键盘
            self.showKeyboard()
            
            // 动画
            viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf .viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
                }, completion: { (_) in
                    // 弹出键盘
                    //self.showKeyboard()
            })
        }
        else {
            // 隐藏
            view.endEditing(true)
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
                strongSelf.viewContent.snp.updateConstraints({[weak self] (make) in
                    guard let strongSelf = self else {
                        return
                    }
                    make.bottom.equalTo(strongSelf.view).offset(strongSelf.heightContentView + margin)
                })
                strongSelf.view.layoutIfNeeded()
                }, completion: {[weak self] (_) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.view.removeFromSuperview()
            })
        }
    }
}


// MARK: - UITextViewDelegate
extension COInputController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //
    }
    
    // 禁止换行
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // emoji
        guard let inputMode = textView.textInputMode, let language = inputMode.primaryLanguage, language.isEmpty == false else {
            return false
        }
        if language == "emoji" {
            // 禁止输入emoji
            return false
        }
        
        if text == "\n" {
            // 完成
            view.endEditing(true)
            if view.superview != nil {
                showOrHidePopView(false)
            }
            inputDoneAction()
            return false
        }
        
        return true
    }
    
    // 字数限制&统计
    func textViewDidChange(_ textView: UITextView) {
        // 有未选中的字符
        if let selectedRange = textView.markedTextRange, let newText = textView.text(in: selectedRange), newText.isEmpty == false {
            return
        }
        
        // 过滤表情符
        if NSString.stringContainsEmoji(textView.text) || NSString.hasEmoji(textView.text) {
            textView.text = NSString.disableEmoji(textView.text)
        }
        
        if let content = textView.text, content.isEmpty == false {
            // 有输入...<最多100字>
            if content.count >= maxInputNum + 1 {
                textView.text = content.substring(to: content.index(content.startIndex, offsetBy: maxInputNum))
            }
        }
        else {
            // 无输入
        }
    }
}


// MARK: - UITextFieldDelegate
extension COInputController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 隐藏键盘
        view.endEditing(true)
        if view.superview != nil {
            showOrHidePopView(false)
        }
        inputDoneAction()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aString: NSString = textField.text! as NSString
        let toString = aString.replacingCharacters(in: range, with: string)
        if toString.isEmpty == false {
            // 不为空
            switch self.inputType {
            case .couponCode: // 优惠券码
                // 暂无限制
                return true
            case .rebateNumber ,.shopBuyMoney: // 金额
                // 只可输入金额数字
                let isMoneyNumber = COInputController.isMonayValue(toString as String)
                if !isMoneyNumber {
                    return false
                }
            default:
                break
            }
        }
        return true
    }
    
    // 字数控制
    @objc func textfieldDidChange(_ textField: UITextField) {
        //        guard let text = textField.text, text.isEmpty == false else {
        //            return
        //        }
        //
        //        let str: NSString = text as NSString
        //        switch self.inputType {
        //        case .couponCode: // 优惠券码
        //            //
        //
        //        case .rebateNumber: // 金额
        //            //
        //
        //        default:
        //            break
        //        }
        
        // 有未选中的字符
        if let selectedRange = textField.markedTextRange, let newText = textField.text(in: selectedRange), newText.isEmpty == false {
            return
        }
        
        // 过滤表情符
        if NSString.stringContainsEmoji(textField.text) || NSString.hasEmoji(textField.text) {
            textField.text = NSString.disableEmoji(textField.text)
        }
        
        if let content = textField.text, content.isEmpty == false {
            // 有输入...<最多100字>
            if content.count >= maxInputNum + 1 {
                textField.text = content.substring(to: content.index(content.startIndex, offsetBy: maxInputNum))
            }
            if inputType == .rebateNumber {
                // 金额
                let txt = textField.text! as NSString
                let value: Double = Double(txt.doubleValue)
                if maxRebateValue < value {
                    //textField.text = "\(maxRebateValue)"
                    let str = String(format: "%.2f", maxRebateValue)
                    textField.text = str
                    toast("本单最高抵扣\(str)元")
                }
            }else if inputType == .shopBuyMoney {
                // 金额
                let txt = textField.text! as NSString
                let value: Double = Double(txt.doubleValue)
                if maxRebateValue < value {
                    //textField.text = "\(maxRebateValue)"
                    let str = String(format: "%.2f", maxRebateValue)
                    textField.text = str
                    toast("本单最高可使用购物金\(str)元")
                }
            }
            
        }
    }
}


// MARK: - Static
extension COInputController {
    // 校验金额: [一个小数点、小数点后精确两位]
    static func isMonayValue(_ str: String) -> Bool {
        let regex = "(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,9}(([.]\\d{0,2})?)))?"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if predicate.evaluate(with: str) {
            return true
        } else {
            return false
        }
    }
    
    // 屏幕底部margin...<适配iPhone X系列>
    static func getScreenBottomMargin() -> CGFloat {
        var margin: CGFloat = 0.0
        if #available(iOS 11, *) {
            // >= iOS 11
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                margin = (insets?.bottom)!
            }
        }
        return  margin
    }
}
