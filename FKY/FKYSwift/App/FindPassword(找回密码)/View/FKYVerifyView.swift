//
//  FKYVerifyView.swift
//  FKY
//
//  Created by hui on 2019/6/25.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYVerifyView: UIView {
    // 内容输入框...<单行>
    lazy var verifyTxtfield: UITextField = {
        let txtfield = UITextField()
        txtfield.delegate = self
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.returnKeyType = .done
        txtfield.font = UIFont.boldSystemFont(ofSize: WH(15))
        txtfield.textColor = RGBColor(0x333333)
        txtfield.autocapitalizationType = .none
        txtfield.autocorrectionType = .no
        txtfield.placeholder = "请输入右图中的字符"
        txtfield.tintColor = RGBColor(0xFF2D5C)
        //txtfield.setValue(RGBColor(0xCCCCCC), forKeyPath: "_placeholderLabel.textColor")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "请输入右图中的字符", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: WH(15)), NSAttributedString.Key.foregroundColor: RGBColor(0xCCCCCC)])
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
                strongSelf.verifyTxtfield.text = ""
                strongSelf.clearButton.isHidden = true
                if let closure = strongSelf.changeTextfield {
                    closure()
                }
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    //图像验证码
    fileprivate lazy var verifyImg: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderWidth = WH(1)
        iv.layer.borderColor = RGBColor(0xF1F1F1).cgColor
        iv.image = UIImage.init(named: "image_placeholder")
        return iv
    }()
    
    //换一张图片按钮
    fileprivate lazy var changeButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("换一张", for: [.normal])
        btn.setTitleColor(RGBColor(0x333333), for: [.normal])
        btn.titleLabel?.font = t11.font
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            if let strongSelf = self {
                if let closure = strongSelf.changePicCode {
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
    var changePicCode : emptyClosure?
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(self.changeButton)
        self.changeButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(WH(13))
            make.right.equalTo(self)
            make.height.equalTo(WH(18))
            make.width.lessThanOrEqualTo(WH(40))
        }
        self.addSubview(self.verifyImg)
        self.verifyImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.changeButton.snp.centerY)
            make.right.equalTo(self.changeButton.snp.left).offset(-WH(8))
            make.height.equalTo(WH(28))
            make.width.equalTo(WH(68))
        }
        
        self.addSubview(self.clearButton)
        self.clearButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.changeButton.snp.centerY)
            make.right.equalTo(self.verifyImg.snp.left).offset(-WH(15))
            make.height.width.equalTo(WH(30))
        }
        self.addSubview(self.verifyTxtfield)
        self.verifyTxtfield.snp.makeConstraints { (make) in
            make.top.left.equalTo(self)
            make.right.equalTo(self.clearButton.snp.left)
            make.height.equalTo(WH(44))
        }
        self.addSubview(self.viewLine)
        self.viewLine.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(self.verifyTxtfield.snp.bottom)
            make.height.equalTo(WH(1))
        }
    }
}

extension FKYVerifyView {
    func updatePicCodeImageView(_ picModel : FKYAccountPicCodeModel?){
        if let model = picModel {
            self.verifyImg.image = UIImage.init(data: model.imageData)
        }else{
            self.verifyImg.image = UIImage.init(named: "image_placeholder")
        }
    }
}

extension FKYVerifyView: UITextFieldDelegate {
    // 监听UITextField变化
    @objc func textfieldDidChange(_ textField: UITextField) {
        if let str = textField.text ,str.count > 0 {
            //输入框有字符
            self.clearButton.isHidden = false
            //self.changeButton.setTitleColor(RGBColor(0x333333), for: [.normal])
        }else {
            //输入框无字符
            self.clearButton.isHidden = true
            //self.changeButton.setTitleColor(RGBColor(0x999999), for: [.normal])
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
