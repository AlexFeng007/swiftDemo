//
//  RegisterMessageCodeView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/7/31.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  注册界面之[短信验证码]输入视图

import UIKit

class RegisterMessageCodeView: UIView {
    // MARK: - Property
    
    // 获取短信验证码block
    var getMessageCodeClosure: ( () -> () )?
    
    var changeTextfield: emptyClosure?
    var beginEditing: emptyClosure?
    var endEditing: emptyClosure?
    
    // 定时器
    fileprivate var timer: Timer!
    // 剩余时间
    fileprivate var count: Int = 0
    
    // 输入框
    fileprivate lazy var txtfield: UITextField = {
        let txtfield = UITextField()
        txtfield.delegate = self
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.keyboardType = .numberPad
        txtfield.returnKeyType = .done
        txtfield.font = UIFont.boldSystemFont(ofSize: WH(15))
        txtfield.textColor = RGBColor(0x333333)
        txtfield.autocapitalizationType = .none
        txtfield.autocorrectionType = .no
        txtfield.clearButtonMode = .whileEditing
        txtfield.placeholder = "请输入短信验证码"
        txtfield.tintColor = RGBColor(0xFF2D5C)
        //txtfield.setValue(RGBColor(0xCCCCCC), forKeyPath: "_placeholderLabel.textColor")
        //txtfield.setValue(UIFont.systemFont(ofSize: WH(15)), forKeyPath: "_placeholderLabel.font")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "请输入短信验证码", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(15)), NSAttributedString.Key.foregroundColor: RGBColor(0xCCCCCC)])
        txtfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        return txtfield
    }()
    
    // 获取验证码
    fileprivate lazy var btnCode: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(RGBColor(0x333333), for: .normal)
        btn.setTitleColor(RGBColor(0x999999), for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(15))
        btn.titleLabel?.textAlignment = .right
        btn.setTitle("获取验证码", for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.getMessageCodeClosure else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 倒计时
    fileprivate lazy var lblCount: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(15))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .right
        lbl.text = "60s后重新获取"
        return lbl
    }()
    
    // 下划线
    fileprivate lazy var viewLine : UIView = {
        let iv = UIView()
        iv.backgroundColor = RGBColor(0xEAEAEA)
        return iv
    }()
    
    // 输入内容非法提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0xFF2D5D)
        lbl.textAlignment = .left
        lbl.text = nil
        return lbl
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("RegisterMessageCodeView deinit~!@")
    }
    
    
    // MARK: - UI
    
    fileprivate func setupView() {
        backgroundColor = .clear
        
        addSubview(viewLine)
        addSubview(btnCode)
        addSubview(lblCount)
        addSubview(txtfield)
        addSubview(lblTip)
        
        viewLine.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(30))
            make.right.equalTo(self).offset(-WH(30))
            make.top.equalTo(self).offset(WH(60))
            make.height.equalTo(1)
        }
        
        btnCode.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-WH(20))
            make.bottom.equalTo(viewLine.snp.top).offset(-WH(8))
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(100))
        }
        
        lblCount.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-WH(30))
            make.bottom.equalTo(viewLine.snp.top).offset(-WH(8))
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(108))
        }
        
        txtfield.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(30))
            make.right.equalTo(btnCode.snp.left).offset(-WH(20))
            make.bottom.equalTo(viewLine.snp.top).offset(-WH(8))
            make.height.equalTo(WH(30))
        }
        
        lblTip.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(30))
            make.right.equalTo(self).offset(-WH(30))
            make.top.equalTo(viewLine.snp.bottom).offset(WH(6))
            //make.height.equalTo(WH(15))
        }
        
        // 默认隐藏
        lblTip.isHidden = true
        lblCount.isHidden = true
    }
    
    
    // MARK: - Public
    
    //
    func startTimer() {
        txtfield.text = ""//请求短信验证码把上一次验证码的清空
        beginCount()
    }
    
    //
    func stopTimer() {
        stopCount()
    }
    
    //
    func getInputContent() -> String? {
        guard let content = txtfield.text, content.isEmpty == false else {
            return nil
        }
        // 去左右空格
        let txt = content.trimmingCharacters(in: .whitespacesAndNewlines)
        // 去中间空格
        return txt.replacingOccurrences(of: " ", with: "")
    }
    
    //
    func showTip(_ tip: String?) {
        if let txt = tip, txt.isEmpty == false {
            // 有错误提示
            lblTip.text = txt
            lblTip.isHidden = false
            viewLine.backgroundColor = RGBColor(0xFF2D5D)
        }
        else {
            // 无错误提示
            lblTip.text = nil
            lblTip.isHidden = true
            viewLine.backgroundColor = RGBColor(0xEAEAEA)
            if txtfield.isFirstResponder {
                viewLine.backgroundColor = RGBColor(0x333333)
            }
        }
    }
    func setMessageBtnValid(_ isValid: Bool?) {
        if let valid = isValid, valid == false {
            // 失效
             btnCode.isEnabled = false
        }
        else {
            // 有效
            btnCode.isEnabled = true
        }
    }
}


// MARK: - Timer

extension RegisterMessageCodeView {
    // 开始倒计时
    fileprivate func beginCount() {
        // 取消timer
        stopCount()
        
        // 最大时间间隔
        count = 60
        // 先显示最大时间间隔
        showCountDownContent(count)
        
        // 启动timer...<1.2s后启动>
        let date = NSDate.init(timeIntervalSinceNow: 0.2)
        timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    // 停止倒计时
    fileprivate func stopCount() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        count = 0
//        btnCode.isEnabled = true
//        btnCode.setTitle("获取验证码", for: .normal)
        btnCode.isHidden = false
        lblCount.isHidden = true
    }
    
    // 倒计时操作
    @objc fileprivate func showTimeCount() {
        count = count - 1
        let timeInterval: Int = count
        print("count:\(count)")
        
        // 倒计时结束
        guard timeInterval > 0 else {
            stopCount()
            return
        }
        
        // 显示内容
        showCountDownContent(timeInterval)
    }
    
    // 显示倒计时内容
    func showCountDownContent(_ timeInterval: Int) {
//        btnCode.isEnabled = false
//        btnCode.setTitle(String.init(format: "%ds后重新获取", timeInterval), for: .disabled)
        btnCode.isHidden = true
        lblCount.isHidden = false
        lblCount.text = String.init(format: "%ds后重新获取", timeInterval)
    }
}


// MARK: - UITextFieldDelegate

extension RegisterMessageCodeView: UITextFieldDelegate {
    // 监听UITextField变化
    @objc func textfieldDidChange(_ textField: UITextField) {
        // 为空
        guard let text = textField.text, text.isEmpty == false else {
            if let closure = changeTextfield {
                closure()
            }
            return
        }
        
        // 字数控制
        let str: NSString = text as NSString
        if str.length >= 7 {
            textField.text = str.substring(to: 6)
        }
        // 回调
        if let closure = changeTextfield {
            closure()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewLine.backgroundColor = RGBColor(0x333333)
        if let closure = beginEditing {
            closure()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewLine.backgroundColor = RGBColor(0xEAEAEA)
        
        if let text = textField.text, text.isEmpty == false {
            // 去左右空格
            let txt = text.trimmingCharacters(in: .whitespacesAndNewlines)
            // 去中间空格
            textField.text = txt.replacingOccurrences(of: " ", with: "")
        }
        
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
