//
//  FKYArrivalNoticeSheetView.swift
//  FKY
//
//  Created by Rabe on 17/11/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift
import UIKit
import MBProgressHUD

@objc
protocol FKYArrivalNoticeSheetViewDelegate:NSObjectProtocol {
    @objc func submitNoticClick() -> Void
}

class FKYArrivalNoticeSheetView: WUPopView {
    
    // MARK: - Properties
    @objc var submitDelegate: FKYArrivalNoticeSheetViewDelegate?
    
    var hud : MBProgressHUD?
    var minPackageDesc: String?
    var viewModel: FKYArrivalNoticeViewModel! = {
        return FKYArrivalNoticeViewModel()
    }()
    
    fileprivate lazy var closeButton: UIButton! = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "close"), for: UIControl.State())
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.phoneTextField.resignFirstResponder()
            strongSelf.numberTextField.resignFirstResponder()
            strongSelf.hide()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    fileprivate lazy var phoneTextField: UITextField! = {
        let textField = UITextField()
        let mobile = UserDefaults.standard.object(forKey: "user_mobile") as? String
        textField.text = mobile
        textField.placeholder = "请填写手机号码"
        textField.keyboardType = .phonePad
        textField.backgroundColor = RGBColor(0xffffff)
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = RGBColor(0x333333)
        return textField
    }()
    
    fileprivate lazy var numberTextField: UITextField! = {
        let textField = UITextField()
        textField.placeholder = "请填写期望采购数量(\(self.minPackageDesc ?? "盒"))"
        textField.keyboardType = .numberPad
        textField.backgroundColor = RGBColor(0xffffff)
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = RGBColor(0x333333)
        return textField
    }()
    
    fileprivate lazy var tipLabel: UILabel! = {
        let label = UILabel()
        label.text = "若该商品到货，我们会在第一时间短信通知您！"
        label.fontTuple = t31
        return label
    }()
    
    fileprivate lazy var submitButton: UIButton! = {
        let btn = UIButton()
        btn.setTitle("提交到货通知", for: UIControl.State())
        btn.fontTuple = t41
        btn.backgroundColor = RGBColor(0xFE403B)
        return btn
    }()
    
    // MARK: - Life Cycle
    @objc convenience init(productId: String, venderId: NSNumber, minPackageDesc: String) {
        self.init(frame: .zero)
        self.viewModel.productId = productId
        self.viewModel.venderId = venderId
        self.minPackageDesc = minPackageDesc
        setupView()
        bindViewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FKYArrivalNoticeSheetView.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FKYArrivalNoticeSheetView.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FKYArrivalNoticeSheetView.textFieldDidChanged(_:)), name: UITextField.textDidChangeNotification, object:self.numberTextField)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    override func hide() {
        super.hide()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Data
    func bindViewModel() {
        phoneTextField.rx.text.bind { (text) in
            self.viewModel.phoneInput = text
            }.disposed(by: disposeBag)
        
        numberTextField.rx.text.bind { (text) in
            self.viewModel.numberInput = text
            }.disposed(by: disposeBag)
        
        _ = submitButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.submitDelegate != nil{
                strongSelf.submitDelegate?.submitNoticClick()
            }
            
            let result = strongSelf.viewModel.submitResult
            switch result {
            case .ok:
                strongSelf.viewModel.submit(handler: { (message, ret) in
                    strongSelf.makeToast(message, duration: 3, position: CGPoint.init(x: SCREEN_WIDTH/2, y: 80))
                    if ret {
                        strongSelf.perform(#selector(strongSelf.hide(_:)), with: nil, afterDelay: 3)
                    }
                })
            case let .empty(message):
                strongSelf.makeToast(message, duration: 3, position: CGPoint.init(x: SCREEN_WIDTH/2, y: 80))
            case let .failed(message):
                strongSelf.makeToast(message, duration: 3, position: CGPoint.init(x: SCREEN_WIDTH/2, y: 80))
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    // MARK: - UI
    func setupView() {
        self.type = .sheet
        self.backgroundColor = bg4
        
        self.setContentCompressionResistancePriority(UILayoutPriority.required , for: .horizontal)
        self.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .vertical)
        
        self.addSubview(closeButton)
        self.addSubview(phoneTextField)
        self.addSubview(numberTextField)
        self.addSubview(tipLabel)
        self.addSubview(submitButton)
        
        self.snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH)
        }
        
        closeButton.snp.makeConstraints({ (make) in
            make.top.equalTo(self).offset(WH(10))
            make.right.equalTo(self).offset(WH(-10))
        })
        
        phoneTextField.snp.makeConstraints({ (make) in
            make.top.equalTo(closeButton.snp.bottom).offset(WH(5))
            make.right.equalTo(self).offset(WH(-25))
            make.left.equalTo(self).offset(WH(25))
            make.height.equalTo(WH(44))
        })
        
        numberTextField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phoneTextField)
            make.top.equalTo(phoneTextField.snp.bottom).offset(WH(10))
        }
        
        tipLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(numberTextField.snp.bottom).offset(WH(15))
            make.centerX.equalTo(self)
        })
        
        var h: CGFloat = 45
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                h += iPhoneX_SafeArea_BottomInset
            }
        }
        submitButton.snp.makeConstraints({ (make) in
            make.top.equalTo(tipLabel.snp.bottom).offset(WH(20))
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(WH(h))
        })
        
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(submitButton.snp.bottom)
        }
    }
    
    // MARK: - Private Method
    @objc func keyboardWillShow(_ no:Notification) -> () {
        let info:NSDictionary = no.userInfo! as NSDictionary
        let value = info["UIKeyboardBoundsUserInfoKey"]
        let size:CGSize = ((value as AnyObject).cgRectValue.size)
        let time:TimeInterval = info["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval
        UIView.animate(withDuration: time, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.transform = CGAffineTransform(translationX: 0, y: -size.height)
        })
    }
    
    @objc func keyboardWillHide(_ no:Notification) -> () {
        let info:NSDictionary = no.userInfo! as NSDictionary
        let time:TimeInterval = info["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval
        UIView.animate(withDuration: time, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    @objc func textFieldDidChanged(_ no:Notification) {
        let sender = no.object as! UITextField
        if let str = sender.text {
            if str.count >= 8 {
                sender.text = str.substring(to: str.index(str.startIndex, offsetBy: 7))
            }
        }
    }
}

class FKYArrivalNoticeViewModel {
    // MARK: - Properties
    var productId: String?       // 商品编码
    var venderId: NSNumber?      // 商家编码
    
    var phoneInput: String?      // 手机号码
    var numberInput: String?     // 期望购买数
    
    var submitResult: OutputResult { // 按钮点击后结果枚举
        get {
            guard let phone = phoneInput, phone.isEmpty == false else {
                return .empty(message: "请输入手机号码!")
            }
            let phoneValid = (phone as NSString).isPhoneNumber()
            if !phoneValid {
                return .failed(message: "手机号码有误，请重新输入!")
            }
            
            guard let number = numberInput, number.isEmpty == false else {
                return .empty(message: "请输入期望采购数量!")
            }
            let numberValid = (number as NSString).integerValue > 0
            if !numberValid {
                return .failed(message: "期望采购数必须为正整数，请重新输入!")
            }
            
            if phoneValid, numberValid {
                return .ok
            }
            return .failed(message: "输入有误，请重新输入!")
        }
    }
    
    // MARK: - Life Cycle
    
    // MARK: - Action
    
    // MARK: - Data
    func submit(handler: @escaping (_ message: String, _ ret: Bool)->Void) {
//        ShopArrivalProvider().submitArrivalInfo(productId! , sellerCode: venderId!.intValue, phoneNumber: (phoneInput)!, numberInput: (numberInput)!, callback: { (dic) in
//            let msg = dic
//            handler(msg, true)
//        }, failCallback: {
//            handler("服务器繁忙，请稍后再试!", false)
//        })
    }
    
    // MARK: - UI
    
    // MARK: - Private Method
    
}
