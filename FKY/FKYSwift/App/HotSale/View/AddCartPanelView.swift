//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

import UIKit
import RxSwift

typealias AddCartPanelCallback = ()->()

class AddCartPanelView: WUPopView {
    // MARK: - properties
    fileprivate var viewModel: AddCartViewModel!
    fileprivate var callBack: AddCartPanelCallback?
    fileprivate var needBottomMargin: Bool = false
    fileprivate var bottomSafeAreaInsets: CGFloat = CGFloat.init(0)
    fileprivate lazy var stockNumberLabel: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.text = "\(self.viewModel.stockCount)"
        return label
    }()
    
    fileprivate lazy var packingNumberLabel: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.text = "\(self.viewModel.stepCount)"
        return label
    }()
    
    fileprivate lazy var inputField: UITextField! = {
        let input = UITextField()
        input.delegate = self
        input.textAlignment = .center
        input.keyboardType = .numberPad
        input.font = UIFont.systemFont(ofSize: WH(13))
        input.textColor = RGBColor(0x333333)
        input.backgroundColor = RGBColor(0xffffff)
        input.layer.cornerRadius = WH(4)
        input.text = "\(self.viewModel.nowCount)"
        input.rx.text.bind { (text) in
            self.updateButtonStatu()
            }.disposed(by: disposeBag)
        return input
    }()
    
    fileprivate lazy var minusButton: UIButton! = {
        let button = UIButton()
        button.layer.cornerRadius = WH(13)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](_) in
            let updateTuples = self?.viewModel.minusLogic()
            if updateTuples?.toastMessage != nil {
                self?.makeToast(updateTuples?.toastMessage)
            }
            self?.inputField.text = updateTuples?.outputValue
            self?.inputField.endEditing(true)
            self?.updateButtonStatu()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    fileprivate lazy var plusButton: UIButton! = {
        let button = UIButton()
        button.layer.cornerRadius = WH(13)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](_) in
            let updateTuples = self?.viewModel.plusLogic()
            if updateTuples?.toastMessage != nil {
                self?.makeToast(updateTuples?.toastMessage)
            }
            self?.inputField.text = updateTuples?.outputValue
            self?.inputField.endEditing(true)
            self?.updateButtonStatu()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    fileprivate lazy var addCartButton: UIButton! = {
        let button = UIButton()
        button.layer.cornerRadius = WH(4)
        button.backgroundColor = RGBColor(0xff2d5c)
        button.setTitle("加入购物车", for: .normal)
        button.setTitleColor(RGBColor(0xffffff), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: WH(15))
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](_) in
            
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // MARK: - life cycle
    static func show(withViewModel vm: AddCartViewModel, _ callback: @escaping AddCartPanelCallback) {
        let panel = AddCartPanelView.init(withViewModel: vm)
        panel.show()
        panel.callBack = callback
    }
    
    convenience init() {
        fatalError("不可调用此方法初始化本类!")
    }
    
    convenience init(withViewModel vm: AddCartViewModel) {
        self.init(frame: .zero)
        self.viewModel = vm
        NotificationCenter.default.addObserver(self, selector: #selector(AddCartPanelView.keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        setupView()
    }
    
    deinit {
        print("AddCartPanelView deinit~!@")
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - notification
extension AddCartPanelView {
    @objc func keyboardWillChange(_ notification: Notification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.frame)
            let ret = intersection.height
            
            snp.updateConstraints { (make) in
                make.bottom.equalTo(addCartButton.snp.bottom).offset(needBottomMargin ? (WH(30) + bottomSafeAreaInsets + ret) : (WH(30) + ret))
            }
            
            UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: curve), animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
               strongSelf.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

// MARK: - delegates
extension AddCartPanelView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        let input = (textField.text! as NSString).integerValue
        update(inputValue: input)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let input = (textField.text! as NSString).integerValue
        update(inputValue: input)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = string as NSString
        guard str.isPureInteger() else { return false }
        guard let text = textField.text else { return true }
        let inputValue = (text as NSString).replacingCharacters(in: range, with: string)
        let shouldChangeTuples = viewModel.shouldInputValueChangeCharacters(inputValue)
        if shouldChangeTuples.outputValue != nil {
            textField.text = shouldChangeTuples.outputValue
        }
        if shouldChangeTuples.toastMessage != nil {
            makeToast(shouldChangeTuples.toastMessage)
        }
        if shouldChangeTuples.shouldResignKeyboard {
            textField.resignFirstResponder()
        }
        return shouldChangeTuples.shouldChangeValue
    }
}

// MARK: - action
extension AddCartPanelView {
    
}

// MARK: - private methods
extension AddCartPanelView {
    func update(inputValue input: Int) {
        let updateTuples = viewModel.updateInputValue(input)
        if updateTuples.toastMessage != nil {
            makeToast(updateTuples.toastMessage)
        }
        inputField.text = updateTuples.outputValue
    }
    
    func updateButtonStatu() {
        setMinusButton(self.viewModel.minusValid)
        setPlusButton(self.viewModel.plusValid)
    }
    
    func setMinusButton(_ valid: Bool) {
        let disabledImage = "icon_home_hotsale_minus_disabled"
        let enabledImage = "icon_home_hotsale_minus_enabled"
        minusButton.setBackgroundImage(UIImage.init(named: valid ? enabledImage : disabledImage), for: .normal)
        minusButton.isEnabled = valid
    }
    
    func setPlusButton(_ valid: Bool) {
        let disabledImage = "icon_home_hotsale_plus_disabled"
        let enabledImage = "icon_home_hotsale_plus_enabled"
        plusButton.setBackgroundImage(UIImage.init(named: valid ? enabledImage : disabledImage), for: .normal)
        plusButton.isEnabled = valid
    }
}

// MARK: - ui
extension AddCartPanelView {
    func setupView() {
        self.type = .sheet
        self.backgroundColor = RGBColor(0xf7f7f7)
        self.isUserInteractionEnabled = true
        
        setContentCompressionResistancePriority(UILayoutPriority.required , for: .horizontal)
        setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .vertical)

        addSubview(minusButton)
        addSubview(plusButton)
        addSubview(inputField)
        addSubview(stockNumberLabel)
        addSubview(packingNumberLabel)
        addSubview(addCartButton)
        let lineWH = WH(1)
        let lineColor = RGBColor(0xe5e5e5)
        let line1 = UIView()
        line1.backgroundColor = lineColor
        addSubview(line1)
        let line2 = UIView()
        line2.backgroundColor = lineColor
        addSubview(line2)

        snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH)
        }
        
        inputField.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(WH(17))
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: WH(203), height: WH(32)))
        }
        
        minusButton.snp.makeConstraints { (make) in
            make.right.equalTo(inputField.snp.left).offset(WH(-30))
            make.centerY.equalTo(inputField)
            make.size.equalTo(CGSize(width: WH(26), height: WH(26)))
        }
        
        plusButton.snp.makeConstraints { (make) in
            make.left.equalTo(inputField.snp.right).offset(WH(30))
            make.centerY.equalTo(inputField)
            make.size.equalTo(minusButton)
        }
        
        line1.snp.makeConstraints { (make) in
            make.height.equalTo(lineWH)
            make.left.equalTo(minusButton)
            make.right.equalTo(plusButton)
            make.top.equalTo(inputField.snp.bottom).offset(WH(17))
        }
        
        let label1 = UILabel()
        label1.textColor = RGBColor(0x999999)
        label1.font = UIFont.systemFont(ofSize: WH(12))
        label1.text = "库存"
        addSubview(label1)
        let label2 = UILabel()
        label2.textColor = RGBColor(0x999999)
        label2.font = UIFont.systemFont(ofSize: WH(12))
        label2.text = "最小可拆零包装"
        addSubview(label2)
        
        label1.snp.makeConstraints { (make) in
            make.left.equalTo(line1)
            make.top.equalTo(line1.snp.bottom).offset(WH(19))
        }
        
        stockNumberLabel.snp.makeConstraints { (make) in
            make.right.equalTo(line1)
            make.centerY.equalTo(label1)
        }
        
        line2.snp.makeConstraints { (make) in
            make.left.right.equalTo(line1)
            make.top.equalTo(label1.snp.bottom).offset(WH(19))
            make.height.equalTo(lineWH)
        }
        
        label2.snp.makeConstraints { (make) in
            make.left.equalTo(line2)
            make.top.equalTo(line2.snp.bottom).offset(WH(19))
        }
        
        packingNumberLabel.snp.makeConstraints { (make) in
            make.right.equalTo(line2)
            make.centerY.equalTo(label2)
        }
        
        addCartButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: WH(315), height: WH(42)))
            make.left.right.equalTo(line2)
            make.top.equalTo(packingNumberLabel.snp.bottom).offset(WH(19))
        }
        
        /// iPhoneX设备底部间隙
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                bottomSafeAreaInsets = (insets?.bottom)!
            }
        }
        needBottomMargin = bottomSafeAreaInsets > CGFloat.init(0)
        snp.makeConstraints { (make) in
            make.bottom.equalTo(addCartButton.snp.bottom).offset(needBottomMargin ? WH(30)+bottomSafeAreaInsets : WH(30))
        }
    }
}

