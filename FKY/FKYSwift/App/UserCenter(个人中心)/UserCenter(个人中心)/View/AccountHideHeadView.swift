//
//  AccountHideHeadView.swift
//  FKY
//
//  Created by 寒山 on 2020/6/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  个人中心隐藏的头部视图

import UIKit

class AccountHideHeadView: UIView {
    @objc var loginBlock: emptyClosure?//登录
    @objc var settingBlock: emptyClosure?//设置
    @objc var switchShopBlock: emptyClosure?//切换店铺
    // 头像
    fileprivate lazy var avtorImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "account_avtor_icon")
        return iv
    }()
    
    //用户名字
    fileprivate lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.text = "登录/注册"
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if FKYLoginAPI.loginStatus() == .unlogin {
                if let closure = strongSelf.loginBlock {
                    closure()
                }
            }
        }).disposed(by: disposeBag)
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    // 设置图片
    fileprivate lazy var setIconImg: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.image = UIImage(named: "account_set_icon")
        iv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.settingBlock {
                closure()
            }
        }).disposed(by: disposeBag)
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    //切换店铺
    fileprivate lazy var switchShopView: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        view.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.switchShopBlock{
                block()
            }
        }).disposed(by: disposeBag)
        view.layer.borderWidth = 1
        view.layer.borderColor = RGBColor(0xE5E5E5).cgColor
        view.layer.cornerRadius = WH(12.5)
        view.layer.masksToBounds = true
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    //切换店铺label
    fileprivate var switchShopLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textColor = RGBColor(0x333333)
        label.text = "切换企业"
        return label
    }()
    //切换店铺icon
    fileprivate lazy var switchShopIcon: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "switch_shop_icon"))
        return imageView
    }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - ui
    func setupView() {
        self.backgroundColor = UIColor.white
        self.addSubview(avtorImageView)
        self.addSubview(userNameLabel)
        self.addSubview(switchShopView)
        switchShopView.addSubview(switchShopLabel)
        switchShopView.addSubview(switchShopIcon)
        self.addSubview(setIconImg)
        let topMargin = SKPhotoBrowser.getScreenTopMargin()
        
        avtorImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(14))
            make.width.height.equalTo(WH(30))
            make.top.equalTo(self).offset(topMargin + WH(28))
        }
        
        //22 20 27
        setIconImg.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(WH(-11))
            make.centerY.equalTo(userNameLabel.snp.centerY)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(30))
        }
        
        switchShopView.snp.makeConstraints { (make) in
            make.right.equalTo(setIconImg.snp.left).offset(WH(-20))
            make.centerY.equalTo(userNameLabel.snp.centerY)
            make.height.equalTo(WH(25))
            make.width.equalTo(WH(75))
        }
        
        switchShopView.addSubview(switchShopIcon)
        switchShopView.addSubview(switchShopLabel)
        
        switchShopIcon.snp.makeConstraints { (make) in
            make.left.equalTo(switchShopView).offset(WH(8))
            make.centerY.equalTo(switchShopView)
            make.width.equalTo(11)
            make.height.equalTo(8)
        }
        switchShopLabel.snp.makeConstraints { (make) in
            make.left.equalTo(switchShopIcon.snp.right).offset(WH(3))
            make.centerY.equalTo(switchShopView)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avtorImageView.snp.right).offset(WH(9))
            make.centerY.equalTo(avtorImageView.snp.centerY)
            make.height.equalTo(WH(16))
            make.right.equalTo(switchShopView.snp.left)
        }
    }
    //使用登录的用户信息
    func configViewByUserInfo(_ userInfoModel:FKYUserInfoModel?){
        
        switchShopView.isHidden = true
        userNameLabel.text = "登录/注册"
        if let model = userInfoModel {
            if FKYLoginAPI.loginStatus() == .unlogin {
                userNameLabel.text = "登录/注册"
            }else{
                // 用户名称
                if let enterpriseName = model.enterpriseName,enterpriseName.isEmpty == false{
                    // 企业名称
                    userNameLabel.text = enterpriseName
                }else{
                    // 无企业名称
                    if let userName = model.userName,userName.isEmpty == false{
                        userNameLabel.text = "用户名：\(userName)"
                    }else{
                        userNameLabel.text = "用户名："
                    }
                }
            }
            if let user: FKYUserInfoModel = FKYLoginAPI.currentUser() {
                if let nameList = user.nameList,nameList.count > 1 {
                    switchShopView.isHidden = false
                }
            }
        }
    }
}
