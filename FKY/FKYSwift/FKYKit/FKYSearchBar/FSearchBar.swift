//
//  FSearchBar.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/25.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

protocol FSearchBarProtocol : class {
    func fsearchBar(_ searchBar: FSearchBar, textDidChange:String?) -> Void
    func fsearchBar(_ searchBar: FSearchBar, search:String?) -> Void
    func fsearchBar(_ searchBar: FSearchBar, touches:String?) -> Void
}

class FSearchBar: UIView, UITextFieldDelegate {
    // MARK: - Property
    weak var delegate: FSearchBarProtocol?
    var placeholder: String? {
        get{
            return self.textField!.placeholder
        }
        set{
            self.textField!.placeholder = newValue
        }
    }
    var enabled: Bool? {
        get{
            return self.textField!.isUserInteractionEnabled
        }
        set{
            self.textField!.isUserInteractionEnabled = newValue!
        }
    }
    var text: String? {
        get{
            return self.textField!.text
        }
        set{
            if newValue != nil {                
                self.textField!.text = newValue!
                self.textField!.endEditing(true)
            }
        }
        
    }
    var leftIcon: UIImageView?
    fileprivate var textField: UITextField?
    fileprivate var clearBT : UIButton?
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    func setupView() {
        self.leftIcon = {
            let icon = UIImageView()
            icon.image = UIImage(named: "icon_search_gray")
            self.addSubview(icon)
            icon.snp.makeConstraints({[weak self] (make) in
                guard let strongSelf = self else {
                    return
                }
                make.width.height.equalTo(WH(20))
                make.centerY.equalTo(strongSelf)
                make.left.equalTo(strongSelf.snp.left).offset(WH(7.5))
            })
            return icon
        }()
        
        self.textField = {
            let tf = UITextField()
            tf.delegate = self
            tf.backgroundColor = UIColor.clear
            tf.tintColor = bg3
            tf.keyboardType = .webSearch
            tf.returnKeyType = .search
            tf.contentHorizontalAlignment = .center
            tf.textAlignment = .left
            tf.font = FKYSystemFont(WH(13))
            tf.textColor = RGBColor(0x666666)
            tf.clearButtonMode = .never
            //tf.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
            self.addSubview(tf)
            tf.snp.makeConstraints({ (make) in
                make.left.equalTo(self.leftIcon!.snp.right).offset(WH(10))
                make.top.bottom.equalTo(self)
                make.right.equalTo(self.snp.right).offset(-WH(20))
            })
            
            tf.rx.text.subscribe(onNext: {[weak self] text in
                guard let strongSelf = self else {
                    return
                }
                if let de = strongSelf.delegate {
                    if text == "" {
                        strongSelf.clearBT?.isHidden = true
                    }else {
                        strongSelf.clearBT?.isHidden = false
                    }
                    de.fsearchBar(strongSelf, textDidChange:text)
                }
            })
            return tf
        }()
        self.backgroundColor = RGBColor(0xf4f4f4)
        self.layer.cornerRadius = WH(11.5)
        self.layer.borderWidth = 1
        self.layer.borderColor = RGBColor(0xebedec).cgColor
        
        self.clearBT = {
            let bt = UIButton()
            bt.isHidden = true
            bt.setImage(UIImage.init(named: "icon_search_clear"), for: .normal)
            self.addSubview(bt)
            bt.snp.makeConstraints({[weak self] (make) in
                guard let strongSelf = self else {
                    return
                }
                make.right.equalTo(WH(-12))
                make.centerY.equalTo(strongSelf.snp.centerY)
                make.width.height.equalTo(WH(20))
            })
            _=bt.rx.controlEvent(.touchUpInside).subscribe(onNext: {  [weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.textField?.text = ""
                strongSelf.textField?.sendActions(for: .valueChanged)
                strongSelf.textField?.resignFirstResponder()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            return bt
        }()
    }
    
    
    // MARK: -
    override func becomeFirstResponder() -> Bool {
        self.textField?.becomeFirstResponder()
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        self.textField?.resignFirstResponder()
        return super.resignFirstResponder()
    }
    
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let de = self.delegate {
            de.fsearchBar(self, search: textField.text)
        }
        return true
    }
    
    //
    //    func textfieldDidChange(_ textField: UITextField) {
    //        // 有未选中的字符
    //        if let selectedRange = textField.markedTextRange, let newText = textField.text(in: selectedRange), newText.isEmpty == false {
    //            return
    //        }
    //
    //        // 过滤表情符
    //        if NSString.stringContainsEmoji(textField.text) || NSString.hasEmoji(textField.text) {
    //            textField.text = NSString.disableEmoji(textField.text)
    //        }
    //    }
    
    
    // MARK: - Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.enabled! == false && self.delegate != nil {
            self.delegate?.fsearchBar(self, touches: nil)
        }
    }
    
    //初始化店铺列表上方搜索框
    func initShopSearchItem (){
        self.layer.cornerRadius = 4
        self.enabled = false
        self.leftIcon?.image = UIImage.init(named: "shopList_search_icon")
        self.leftIcon?.snp.updateConstraints({ [weak self](make) in
            guard let strongSelf = self else {
                return
            }
            make.width.height.equalTo(WH(15))
            make.left.equalTo(strongSelf.snp.left).offset(WH(14))
        })
        self.textField?.text = "请输入商家名称"
        self.textField?.textColor = RGBColor(0x999999)
        self.textField?.snp.updateConstraints({  [weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.left.equalTo(strongSelf.leftIcon!.snp.right).offset(WH(7))
        })
    }
    
    //初始化搜索结果上方搜索框
    func initCommonSearchItem (){
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 0
        self.enabled = false
        self.leftIcon?.image = UIImage.init(named: "shopList_search_icon")
        self.leftIcon?.snp.updateConstraints({ [weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.width.height.equalTo(WH(15))
            make.left.equalTo(strongSelf.snp.left).offset(WH(14))
        })
        self.textField?.textColor = RGBColor(0x999999)
        self.textField?.snp.updateConstraints({ [weak self](make) in
            guard let strongSelf = self else {
                return
            }
            make.left.equalTo(strongSelf.leftIcon!.snp.right).offset(WH(7))
        })
    }
    //初始化单品包邮的搜索
    func initProductPinkageSearchItem (){
        self.layer.cornerRadius = WH(15)
        self.layer.borderWidth = 0
        self.enabled = false
        self.leftIcon?.image = UIImage.init(named: "pinkage_gray_search_gray")
        self.leftIcon?.snp.updateConstraints({ [weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.width.height.equalTo(WH(15))
            make.left.equalTo(strongSelf.snp.left).offset(WH(10))
        })
        self.textField?.textColor = RGBColor(0xF3F3F3)
        self.textField?.snp.updateConstraints({ [weak self](make) in
            guard let strongSelf = self else {
                return
            }
            make.left.equalTo(strongSelf.leftIcon!.snp.right).offset(WH(6))
        })
    }
}
