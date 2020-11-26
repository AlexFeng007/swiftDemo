//
//  UserGuideMaskInAccountView.swift
//  FKY
//
//  Created by 寒山 on 2020/6/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class UserGuideMaskInAccountView: UIView {
    @objc var enterCredentialInfoBlock: emptyClosure?//跳到资料管理
    
    //个人中心用户引导信息
    fileprivate lazy var introImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.image = UIImage(named: "account_complentInfo")
        return view
    }()
    //知道了btn
    fileprivate lazy var konwButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("知道了", for: .normal)
        btn.titleLabel?.font = t21.font
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        btn.backgroundColor = .clear
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(15.5)
        btn.layer.borderWidth = WH(1)
        btn.layer.borderColor = RGBColor(0xFFFFFF).cgColor
        btn.isEnabled = false
        return btn
    }()
    //空白镂空
    fileprivate lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.onBtnCredentialsDismiss()
            
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - ui
    func setupView() {
        self.backgroundColor = RGBAColor(0x000000, alpha: 0.65)
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.onControlMaskDismiss()
        }).disposed(by: disposeBag)
        self.addGestureRecognizer(tapGesture)
        
        let baseHeight = WH(136)  //未完善资料的用户，顶部高度写死140 ，可以根据根据用户信息更改，后面修改记得看
        let topMargin = SKPhotoBrowser.getScreenTopMargin()
        let toolViewHeight = 2*(WH(10) + WH(123)) + baseHeight + topMargin
        let xPath = (SCREEN_WIDTH - WH(32))/4.0 - 0.5 + WH(16) + ((SCREEN_WIDTH - WH(32))/4.0 - 0.5)/2.0 - WH(26.5)
        
        self.addSubview(introImageView)
        self.addSubview(konwButton)
        self.addSubview(emptyView)
        introImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(13))
            make.bottom.equalTo(self.snp.top).offset(toolViewHeight)
            make.height.equalTo(WH(90))
            make.width.equalTo(WH(259))
        }
        konwButton.snp.makeConstraints { (make) in
            make.top.equalTo(introImageView.snp.bottom).offset(WH(69))
            make.centerX.equalTo(introImageView.snp.centerX)
            make.height.equalTo(WH(31))
            make.width.equalTo(WH(95))
        }
        emptyView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(toolViewHeight - WH(14.5))
            make.centerX.equalTo(introImageView.snp.centerX)
            make.height.equalTo(WH(80))
            make.width.equalTo(WH(80))
        }
        let path: UIBezierPath = UIBezierPath(rect: self.bounds)
        path.append(UIBezierPath(roundedRect: CGRect.init(x: xPath , y: toolViewHeight, width: WH(53), height: WH(53)), byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: WH(26.5), height: WH(26.5))).reversing())
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath;
        self.layer.mask = shapeLayer;
        
    }
}
extension UserGuideMaskInAccountView{
    func showInUserGuide(){
        let rootView :UIWindow = UIApplication.shared.keyWindow!
        rootView.addSubview(self)
        rootView.bringSubviewToFront(self)
    }
    func showWithoutAnimation(){
        if self.superview  != nil{
            self.superview!.bringSubviewToFront(self)
        }else{
            self.showInUserGuide()
        }
    }
    func dismissWithoutAnimation(){
        if self.superview  != nil{
            self.superview!.sendSubviewToBack(self)
        }else{
            let rootView :UIWindow = UIApplication.shared.keyWindow!
            rootView.addSubview(self)
            rootView.sendSubviewToBack(self)
        }
    }
    //点击全局
    func onControlMaskDismiss(){
        UserDefaults.standard.set(true, forKey: "isHandelUserGuideMask")
        UserDefaults.standard.synchronize()
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.backgroundColor = RGBAColor(0x000000, alpha: 0.0)
            }, completion: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                // 弹出键盘
                strongSelf.removeFromSuperview()
        })
    }
    //点击资质管理的按钮
    func onBtnCredentialsDismiss(){
        UserDefaults.standard.set(true, forKey: "isHandelUserGuideMask")
        UserDefaults.standard.synchronize()
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.backgroundColor = RGBAColor(0x000000, alpha: 0.0)
            }, completion: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                // 弹出键盘
                strongSelf.removeFromSuperview()
                if let block = strongSelf.enterCredentialInfoBlock{
                    block()
                }
        })
    }
}
