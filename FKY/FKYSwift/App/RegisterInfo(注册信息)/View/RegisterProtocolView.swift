//
//  RegisterProtocolView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/7/31.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  注册界面之[协议相关]视图

import UIKit

class RegisterProtocolView: UIView {
    // MARK: - Property
    
    // 服务协议block
    var serviceClosure: ( () -> () )?
    // 隐私条款block
    var privateClosure: ( () -> () )?
    // 隐私条款block
    var sellClosure: ( () -> () )?
    // 勾选block
    var selectClosure: ( () -> () )?
    
    // 是否同意用户协议...<默认同意>
    var agreeFlag: Bool = true
    
    // 勾选按钮
    fileprivate lazy var btnSelect: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage.init(named: "icon_cart_selected"), for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            // 勾选or取消
            strongSelf.selectAction()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .left
        lbl.text = "已阅读并同意"
        return lbl
    }()
    
    // 服务协议
    fileprivate lazy var btnService: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(RGBColor(0xFF2D5D), for: .normal)
        btn.setTitleColor(RGBColor(0xFFABBD), for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(12))
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("《1药城服务协议》", for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.serviceClosure else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 隐私条款
    fileprivate lazy var btnPrivate: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(RGBColor(0xFF2D5D), for: .normal)
        btn.setTitleColor(RGBColor(0xFFABBD), for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(12))
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("《1药城隐私条款》", for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.privateClosure else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 销售条款
    fileprivate lazy var sellPrivate: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(RGBColor(0xFF2D5D), for: .normal)
        btn.setTitleColor(RGBColor(0xFFABBD), for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(12))
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("《销售条款与条件》", for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.sellClosure else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
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
        print("RegisterProtocolView deinit~!@")
    }
    
    
    // MARK: - UI
    
    fileprivate func setupView() {
        backgroundColor = .clear
        
        addSubview(btnSelect)
        addSubview(lblTitle)
        addSubview(btnService)
        addSubview(btnPrivate)
        addSubview(sellPrivate)
        
        btnSelect.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(28))
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(30))
            make.top.equalTo(self).offset(WH(5.0))
        }
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(btnSelect.snp.right).offset(WH(2))
            make.centerY.equalTo(btnSelect)
        }
        
        btnService.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(2))
            make.height.equalTo(WH(30))
            make.centerY.equalTo(btnSelect)
        }
        
        btnPrivate.snp.makeConstraints { (make) in
            make.left.equalTo(btnService.snp.right).offset(WH(0))
            make.height.equalTo(WH(30))
            make.centerY.equalTo(btnSelect)
        }
        
        ///销售协议
        sellPrivate.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.left).offset(WH(0))
            make.top.equalTo(lblTitle.snp.bottom).offset(WH(5.0))
            make.height.equalTo(WH(30))
        }
    }
    
    
    // MARK: - Public
    
    func configView() {
        
    }

    
    // MARK: - Private
    
    fileprivate func selectAction() {
        agreeFlag = !agreeFlag
        if agreeFlag {
            // 勾选
            btnSelect.setImage(UIImage.init(named: "icon_cart_selected"), for: .normal)
        }
        else {
            // 取消
            btnSelect.setImage(UIImage.init(named: "icon_cart_unselected"), for: .normal)
        }
        guard let block = selectClosure else {
            return
        }
        block()
    }
}
