//
//  RegisterImageCodeView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/7/31.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  注册界面之[图片字符]输入视图

import UIKit

class RegisterImageCodeView: UIView {
    // MARK: - Property
    
    var changeTextfield: emptyClosure?
    var beginEditing: emptyClosure?
    var endEditing: emptyClosure?
    
    // 获取图片验证码block
    var getImageCodeClosure: ( () -> () )?
    
    // 输入框
    fileprivate lazy var txtfield: UITextField = {
        let txtfield = UITextField()
        txtfield.delegate = self
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.keyboardType = .asciiCapable
        txtfield.returnKeyType = .done
        txtfield.font = UIFont.boldSystemFont(ofSize: WH(15))
        txtfield.textColor = RGBColor(0x333333)
        txtfield.autocapitalizationType = .none
        txtfield.autocorrectionType = .no
        txtfield.clearButtonMode = .whileEditing
        txtfield.placeholder = "请输入右图中的字符"
        txtfield.tintColor = RGBColor(0xFF2D5C)
        //txtfield.setValue(RGBColor(0xCCCCCC), forKeyPath: "_placeholderLabel.textColor")
        //txtfield.setValue(UIFont.systemFont(ofSize: WH(15)), forKeyPath: "_placeholderLabel.font")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "请输入右图中的字符", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(15)), NSAttributedString.Key.foregroundColor: RGBColor(0xCCCCCC)])
        txtfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        return txtfield
    }()
    
    // 换一张
    fileprivate lazy var btnChange: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(RGBColor(0x333333), for: .normal)
        btn.setTitleColor(RGBColor(0x999999), for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(12))
        btn.titleLabel?.textAlignment = .right
        btn.setTitle("换一张", for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.getImageCodeClosure else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 图片验证码
    fileprivate lazy var imgviewCode: UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = WH(1)
        view.layer.borderColor = RGBColor(0xF1F1F1).cgColor
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named: "update_alert_logo")
        return view
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
        print("RegisterImageCodeView deinit~!@")
    }
    
    
    // MARK: - UI
    
    fileprivate func setupView() {
        backgroundColor = .clear
        
        addSubview(viewLine)
        addSubview(btnChange)
        addSubview(imgviewCode)
        addSubview(txtfield)
        addSubview(lblTip)
        
        viewLine.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(30))
            make.right.equalTo(self).offset(-WH(30))
            make.top.equalTo(self).offset(WH(60))
            make.height.equalTo(1)
        }
        
        btnChange.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-WH(28))
            make.bottom.equalTo(viewLine.snp.top).offset(-WH(8))
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(40))
        }
        
        imgviewCode.snp.makeConstraints { (make) in
            make.right.equalTo(btnChange.snp.left).offset(-WH(6))
            make.bottom.equalTo(viewLine.snp.top).offset(-WH(8))
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(66))
        }
        
        txtfield.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(30))
            make.right.equalTo(imgviewCode.snp.left).offset(-WH(10))
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
    }
    
    
    // MARK: - Public
    
    //
    func setPlaceholder(_ tip: String?) {
        txtfield.placeholder = tip
        txtfield.attributedPlaceholder = NSAttributedString.init(string: tip ?? "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(15)), NSAttributedString.Key.foregroundColor: RGBColor(0xCCCCCC)])
    }
    
    //
    func setupCodeImage(_ imgModel: FKYAccountPicCodeModel?) {
        guard let model = imgModel, let imgData = model.imageData else {
            return
        }
        imgviewCode.image = UIImage.init(data: imgData)
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
}


extension RegisterImageCodeView: UITextFieldDelegate {
    // 监听UITextField变化
    @objc func textfieldDidChange(_ textField: UITextField) {
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
