//
//  CredentialsAddressCRView.swift
//  FKY
//
//  Created by 夏志勇 on 2017/11/2.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  新增／编辑地址界面之(仓库地址)Footerview

import UIKit

class CredentialsAddressCRView: UICollectionReusableView, UITextViewDelegate {
    //MARK: - Property
//    fileprivate var lblTitle: UILabel?
//    fileprivate var btnSaleInfo: UIButton?
//    fileprivate var viewAddress: UIView?
//    fileprivate var lblTip: UILabel?
//    fileprivate var txtview: UITextView?
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434).withAlphaComponent(0.52)
        label.font = UIFont.systemFont(ofSize: WH(15))
        label.textAlignment = .left
        label.text = "销售单上打印的仓库地址"
//        label.setContentCompressionResistancePriority(1000, for: UILayoutConstraintAxis.horizontal)
//        label.setContentHuggingPriority(1000, for: UILayoutConstraintAxis.horizontal)
        return label
    }()
    
    // 销售单示例按钮
    fileprivate lazy var btnSaleInfo: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.setTitle("销售单示例", for: .normal)
        btn.setTitleColor(RGBColor(0x4192EB), for: .normal)
        btn.setTitleColor(UIColor.init(red: 21/255, green: 71/255, blue: 119/255, alpha: 1), for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        btn.setImage(UIImage.init(named: "img_question"), for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -WH(40), bottom: 0, right: 0)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -WH(140))
        btn.addTarget(self, action: #selector(showSaleInfo), for: .touchUpInside)
        return btn
    }()
    
    // 内容视图
    fileprivate lazy var viewAddress: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    // 提示
    fileprivate lazy var lblTip: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x9F9F9F)
        label.font = UIFont.systemFont(ofSize: WH(15))
        label.textAlignment = .right
        label.text = "请填写销售单上的打印地址"
        return label
    }()
    
    // 内容输入框
    fileprivate lazy var txtview: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        tv.backgroundColor = UIColor.clear
        tv.font = UIFont.systemFont(ofSize: WH(15))
        tv.textColor = RGBColor(0x343434D)
        tv.textAlignment = .left
        tv.minimumZoomScale = 0.8
        tv.keyboardType = UIKeyboardType.default
        tv.returnKeyType = UIReturnKeyType.done
        tv.textContainerInset = UIEdgeInsets(top: 5, left: 0 , bottom: 0, right: 0)
        tv.layoutManager.allowsNonContiguousLayout = false
        return tv
    }()
    
    var saveClosure: SingleStringClosure?
    var showSaleInfoClosure: SingleStringClosure?
    
    //MARK: - LiftCircle
    override init(frame: CGRect){
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    fileprivate func setupView() {
        self.backgroundColor = UIColor.clear
        
        self.addSubview(self.lblTitle)
        self.lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(10))
            make.top.equalTo(self).offset(WH(10))
            make.height.equalTo(WH(30))
        }
        
        self.addSubview(self.btnSaleInfo)
        self.btnSaleInfo.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-WH(4))
            make.top.equalTo(self).offset(WH(10))
            make.height.equalTo(WH(30))
            make.width.equalTo(105)
        }
        
        self.addSubview(self.viewAddress)
        self.viewAddress.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(self.lblTitle.snp.bottom).offset(WH(10))
        }
        
        self.viewAddress.addSubview(self.lblTip)
        self.lblTip.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.viewAddress)
            make.right.equalTo(self.viewAddress).offset(-WH(10))
        }
        
        self.viewAddress.addSubview(self.txtview)
        self.txtview.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.viewAddress).offset(WH(5))
            make.bottom.right.equalTo(self.viewAddress).offset(-WH(5))
        }
        
        let viewBottomLine = UIView()
        viewBottomLine.backgroundColor = RGBColor(0xD8D8D8)
        self.addSubview(viewBottomLine)
        viewBottomLine.snp.makeConstraints({ (make) in
            make.leading.equalTo(self.snp.leading).offset(j5)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(0.6)
        })
    }
    
    //MARK: - Public
    func configView(_ content:String?) {
        // 显示地址内容
        self.txtview.text = content
        // 若地址有内容，则隐藏提示
        if self.txtview.text != nil && self.txtview.text.count > 0 {
            self.lblTip.isHidden = true
        } else {
            self.lblTip.isHidden = false
        }
    }
    
    //MARK: - EventAction
    @objc func showSaleInfo() {
        if let showClosure = self.showSaleInfoClosure {
            showClosure("")
        }
    }
    
    //MARK: - UITextViewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.lblTip.isHidden = true
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.lblTip.isHidden = false
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text != nil) && textView.text.count > 0 {
            self.lblTip.isHidden = true
        }
        else {
            self.lblTip.isHidden = false
        }
        
        if let text = textView.text {
            if let saveClosure = self.saveClosure {
                saveClosure(text)
            }
        }
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
        
        // 判断键盘是不是九宫格键盘...<解决禁止输入emoji时导致九宫格键盘无法输入的问题>
        if NSString.isNineKeyBoard(text) {
            //return true
        }
        else {
            // 禁止输入表情符
            if NSString.stringContainsEmoji(text) || NSString.hasEmoji(text) {
                return false
            }
        }
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // 仓库地址最多200字
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            let str = text as NSString
            if str.length >= 201 {
                textView.text = str.substring(to: 200)
            }
        }
    }
}
