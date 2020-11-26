//
//  FKYShopContactView.swift
//  FKY
//
//  Created by hui on 2019/10/28.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

//加车弹框
let CONTENTVIEW_CONTACT_CUSTOMER_H = WH(180) + bootSaveHeight() //内容视图的高度

class FKYShopContactView: UIView {
    
    //MARK: - Property
    // 响应视图
    fileprivate lazy var viewDismiss: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        return view
    }()
    // 内容视图...<包含所有内容的容器视图>
    fileprivate lazy var viewContent: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    // 取消btn
    fileprivate lazy var btnClose: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.clear
        btn.setImage(UIImage.init(named: "btn_pd_group_close"), for: .normal)
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickTypeBtn {
                block(0)
            }
            strongSelf.showOrHideContactCustomerPopView(false)
        }).disposed(by: disposeBag)
        return btn
    }()
    
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "联系客服"
        label.font = UIFont.systemFont(ofSize: WH(17))
        label.textColor = t49.color
        return label
    }()
    
    // 电话号码
    fileprivate lazy var phoneBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.clear
        btn.titleLabel?.font = t49.font
        btn.setTitleColor(t36.color, for: .normal)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = RGBColor(0xCCCCCC).cgColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickTypeBtn {
                block(1)
            }
            strongSelf.showOrHideContactCustomerPopView(false)
            
        }).disposed(by: disposeBag)
        return btn
    }()
    // 在线客服
    fileprivate lazy var customerBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.clear
        btn.setTitle("在线客服", for: .normal)
        btn.titleLabel?.font = t49.font
        btn.setTitleColor(t36.color, for: .normal)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = RGBColor(0xCCCCCC).cgColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickTypeBtn {
                block(2)
            }
            strongSelf.showOrHideContactCustomerPopView(false)
            
        }).disposed(by: disposeBag)
        return btn
    }()
    
    // 联系客服框是否已弹出
    var viewShowFlag: Bool = false
    //不赋值则使用keyWindow
    var bgView: UIView?
    //点击按钮
    var clickTypeBtn : ((Int)->(Void))?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        self.addSubview(self.viewDismiss)
        self.viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.viewDismiss.bk_(whenTapped:  { [weak self] in
            if let strongSelf = self {
                strongSelf.showOrHideContactCustomerPopView(false)
            }
        })
        self.addSubview(self.viewContent)
        self.viewContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(CONTENTVIEW_CONTACT_CUSTOMER_H)
            make.height.equalTo(CONTENTVIEW_CONTACT_CUSTOMER_H)
        }
        self.viewContent.addSubview(self.btnClose)
        self.btnClose.snp.makeConstraints { (make) in
            make.left.equalTo(self.viewContent.snp.left).offset(WH(13))
            make.top.equalTo(self.viewContent.snp.top).offset(WH(12))
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(30))
        }
        self.viewContent.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.viewContent.snp.centerX)
            make.top.equalTo(self.viewContent.snp.top).offset(WH(16))
            make.height.equalTo(WH(24))
        }
        self.viewContent.addSubview(self.phoneBtn)
        self.phoneBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.viewContent.snp.centerX)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(WH(25))
            make.height.equalTo(WH(42))
            make.width.equalTo(SCREEN_WIDTH-WH(20))
        }
        self.viewContent.addSubview(self.customerBtn)
        self.customerBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.viewContent.snp.centerX)
            make.top.equalTo(self.phoneBtn.snp.bottom).offset(WH(10))
            make.height.equalTo(WH(42))
            make.width.equalTo(SCREEN_WIDTH-WH(20))
        }
    }
    
}
extension FKYShopContactView {
    //更新按钮
    func configShopContactView(_ phoneStr:String){
         phoneBtn.setTitle(phoneStr, for: .normal)
    }
    // 显示or隐藏套餐弹出视图
    func showOrHideContactCustomerPopView(_ show: Bool) {
        //防止弹两次
        if show == viewShowFlag {
            return
        }
        viewShowFlag = show
        if show {
            // 显示
            if let iv = self.bgView {
                iv.addSubview(self)
                self.snp.makeConstraints({ (make) in
                    make.edges.equalTo(iv)
                })
            }else {
                //添加在根视图上面
                let window = UIApplication.shared.keyWindow
                if let rootView = window?.rootViewController?.view {
                    rootView.addSubview(self)
                    self.snp.makeConstraints({ (make) in
                        make.edges.equalTo(rootView)
                    })
                }
            }
            
            self.viewContent.snp.updateConstraints({ (make) in
                make.bottom.equalTo(self).offset(CONTENTVIEW_CONTACT_CUSTOMER_H)
            })
            self.layoutIfNeeded()
            self.viewDismiss.backgroundColor = RGBColor(0x000000).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x000000).withAlphaComponent(0.6)
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(strongSelf).offset(WH(0))
                    })
                    strongSelf.layoutIfNeeded()
                }
                
                }, completion: { (_) in
                    //
            })
            IQKeyboardManager.shared().isEnableAutoToolbar = true
            IQKeyboardManager.shared().isEnabled = true
        }
        else {
            self.endEditing(true)
            // 隐藏
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x000000).withAlphaComponent(0.0)
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(strongSelf).offset(CONTENTVIEW_CONTACT_CUSTOMER_H)
                    })
                    strongSelf.layoutIfNeeded()
                }
                
                }, completion: { [weak self] (_) in
                    if let strongSelf = self {
                        strongSelf.removeFromSuperview()
                        // 移除通知
                    }
            })
        }
    }
}
