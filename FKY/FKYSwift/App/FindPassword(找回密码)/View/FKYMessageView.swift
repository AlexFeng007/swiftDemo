//
//  FKYMessageView.swift
//  FKY
//
//  Created by hui on 2019/6/25.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYMessageView: UIView {
    // 内容输入框...<单行>
    lazy var messageTxtfield: UITextField = {
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
        txtfield.placeholder = "请输入短信验证码"
        txtfield.tintColor = RGBColor(0xFF2D5C)
        //txtfield.setValue(RGBColor(0xCCCCCC), forKeyPath: "_placeholderLabel.textColor")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "请输入短信验证码", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: WH(15)), NSAttributedString.Key.foregroundColor: RGBColor(0xCCCCCC)])
        txtfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        return txtfield
    }()
    
    //清除按钮
    fileprivate lazy var clearButton : UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setImage(UIImage(named: "login_clear_pic"), for: [.normal])
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self]  (_) in
            if let strongSelf = self {
                strongSelf.messageTxtfield.text = ""
                strongSelf.clearButton.isHidden = true
                if let closure = strongSelf.changeTextfield {
                    closure()
                }
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    //获取验证码
    fileprivate lazy var messageButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("获取验证码", for: [.normal])
        btn.isEnabled = false;
        btn.setTitleColor(RGBColor(0x999999), for: [.normal])
        btn.titleLabel?.font = t40.font
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            if let strongSelf = self {
                if let closure = strongSelf.getSMSCodeBlock {
                    closure()
                }
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 下划线
    fileprivate lazy var viewLine : UIView = {
        let iv = UIView()
        iv.backgroundColor = RGBColor(0xEAEAEA)
        return iv
    }()
    
    //MARK: - 属性
    var changeTextfield : emptyClosure?
    var getSMSCodeBlock : emptyClosure?
    fileprivate var timer: Timer!
    var timeout : Int = 60 //倒计时
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(self.messageButton)
        self.messageButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(WH(12))
            make.right.equalTo(self)
            make.height.equalTo(WH(20))
            make.width.lessThanOrEqualTo(WH(103))
        }
        self.addSubview(self.clearButton)
        self.clearButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.messageButton.snp.centerY)
            make.right.equalTo(self.messageButton.snp.left).offset(-WH(15))
            make.height.width.equalTo(WH(30))
        }
        self.addSubview(self.messageTxtfield)
        self.messageTxtfield.snp.makeConstraints { (make) in
            make.top.left.equalTo(self)
            make.right.equalTo(self.clearButton.snp.left).offset(-WH(5))
            make.height.equalTo(WH(44))
        }
        self.addSubview(self.viewLine)
        self.viewLine.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(self.messageTxtfield.snp.bottom)
            make.height.equalTo(WH(1))
        }
    }
}

//
extension FKYMessageView {
    //显示倒计时按钮
    func beginTimerDown() {
        self.messageButton.setTitle("\(timeout)s后重新获取", for: [.normal])
        self.messageButton.setTitleColor(RGBColor(0x999999), for: [.normal])
        self.messageButton.isEnabled = false
        let date = NSDate.init(timeIntervalSinceNow: 1.0)
        timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @objc func showTimeCount() {
        timeout -= 1
        if timeout <= 0 {
            self.messageButton.setTitle("获取验证码", for: [.normal])
            self.messageButton.setTitleColor(RGBColor(0x333333), for: [.normal])
            self.messageButton.isEnabled = true
            if timer != nil {
                timeout = 60
                timer.invalidate()
                timer = nil
            }
        } else {
             self.messageButton.setTitle("\(timeout)s后重新获取", for: [.normal])
             self.messageButton.setTitleColor(RGBColor(0x999999), for: [.normal])
             self.messageButton.isEnabled = false
        }
        //根据判断views所属的控制器被销毁了，销毁定时器
        guard (self.getFirstViewController()) != nil else{
            if timer != nil {
                timer.invalidate()
                timer = nil
            }
            return
        }
    }
    
    //更新获取短信验证码的按钮状态
    func updateMessageButton(_ messageEnable: Bool) {
        //不处于倒计时阶段
        if timeout == 60 {
            if messageEnable == true {
                //可点击
                self.messageButton.setTitleColor(RGBColor(0x333333), for: [.normal])
                self.messageButton.isEnabled = true
            }else{
                //不可点击
                self.messageButton.setTitleColor(RGBColor(0x999999), for: [.normal])
                self.messageButton.isEnabled = false
            }
        }
    }
}

extension FKYMessageView: UITextFieldDelegate {
    // 监听UITextField变化
    @objc func textfieldDidChange(_ textField: UITextField) {
        if let str = textField.text ,str.count > 0 {
            //输入框有字符
            self.clearButton.isHidden = false
        }else {
            //输入框无字符
            self.clearButton.isHidden = true
        }
        if let closure = self.changeTextfield {
            closure()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let str = textField.text ,str.count > 0 {
            self.clearButton.isHidden = false
        }
        self.viewLine.backgroundColor = RGBColor(0x333333)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.clearButton.isHidden = true
        self.viewLine.backgroundColor = RGBColor(0xEAEAEA)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false;
        }
        return true;
    }
}
