//
//  LiveShareView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/28.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveShareView: UIView {
    // MARK: - Property
    @objc var WeChatShareClourse : SharePayClourse?      // 微信好友
    @objc var QQShareClourse : SharePayClourse?          // QQ好友
    
    
    @objc var dismissClourse : SharePayClourse?   // 隐藏
    @objc var appearClourse : SharePayClourse?    // 显示
    @objc var dismissComplete : SharePayDismissCompleteCallBack?  // 完成
    
    var liveShareWord: String?//分享口令
    
    var bgView : UIView?
    var sharedWordTextView:UITextView?
    var weChatBtn : UIButton?
    var QQBtn : UIButton?
    var weChatLab : UILabel?
    var QQLab : UILabel?
    
    
    
    var cancleBtn : UIButton?
    var titleLabel : UILabel?
    var lineView : UIView?
    var bottomlineView : UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
        self.setupAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Touch
    
    // 隐藏
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if (touch.view == self && self.dismissClourse != nil) {
                self.dismissClourse!()
            }
        }
    }
    
    
    // MARK: - Private
    
    fileprivate func setupView() -> () {
        self.backgroundColor =  RGBAColor(0x000000, alpha: 0.0)
        
        let widthBtn = SCREEN_WIDTH / 2.0
        
        bgView = {
            let view = UIView()
            view.backgroundColor = bg1
            view.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: WH(341))
            self.addSubview(view)
            return view
        }()
        
        titleLabel = {
            let label = UILabel()
            bgView?.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.centerX.left.right.equalTo(bgView!)
                make.height.equalTo(WH(16))
                make.top.equalTo(bgView!).offset(WH(22))
            })
            label.text = "口令已复制，去粘贴给好友吧"
            label.fontTuple = t36
            label.textAlignment = .center
            return label
        }()
        
        cancleBtn = {
            let btn = UIButton(type: .custom)
            bgView?.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(WH(-5))
                make.top.equalToSuperview().offset(WH(8))
                make.size.equalTo(CGSize(width: WH(40), height: WH(40)))
            }
            btn.setImage(UIImage(named: "btn_pd_group_close"), for: UIControl.State())
            // btn.imageEdgeInsets = UIEdgeInsets(top: WH(10), left: WH(10), bottom: WH(10), right: WH(10))
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.dismissClourse != nil {
                    strongSelf.dismissClourse!()
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            return btn
        }()
        
        // 加分隔线
        bottomlineView  = {
            let view = UIView()
            view.backgroundColor = RGBColor(0xE5E5E5)
            //view.backgroundColor = UIColor.purple
            bgView?.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.height.equalTo(1.0)
                make.top.equalTo(bgView!).offset(WH(222))
                make.left.right.equalTo(bgView!)
            })
            return view
        }()
        
        // 加分隔线
        lineView = {
            let view = UIView()
            view.backgroundColor = RGBColor(0xE5E5E5)
            //view.backgroundColor = UIColor.purple
            bgView?.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.height.equalTo(1.0)
                make.top.equalTo(bgView!).offset(WH(58))
                make.left.right.equalTo(bgView!)
            })
            return view
        }()
        
        sharedWordTextView = {
            let view = UITextView()
            bgView?.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.bottom.equalTo((bottomlineView?.snp.top)!).offset(WH(-16))
                make.top.equalTo((lineView?.snp.bottom)!).offset(WH(16))
                make.left.equalTo(bgView!).offset(WH(16))
                make.right.equalTo(bgView!).offset(WH(-16))
            })
            view.backgroundColor = RGBColor(0xF6F6F6)
            view.textAlignment = .left
            view.isEditable = false
            view.font = UIFont.systemFont(ofSize: WH(14))
            view.textColor = RGBColor(0x666666)
            view.showsVerticalScrollIndicator = true
            view.isScrollEnabled = true
            view.layer.masksToBounds = false
            view.layer.cornerRadius = WH(2)
            view.textContainerInset = UIEdgeInsets(top: WH(10), left: WH(10) , bottom: 0, right: WH(10))
            //view.text = "给你安利一个主播： 恒得利翡翠拍卖的直播简直太火爆了，快来看！ 翡翠精品一元起拍捡漏 —————————————— 復·制这段信息后咑閞 【淘&#9794寳&#9792】即可看见 快啦给你安利一个主播： 恒得利翡翠拍卖的直播简直太火爆了，快来看！ 翡翠精品一元起拍捡漏 —————————————— 復·制这段信息后咑閞 【淘&#9794寳&#9792】即可看见 快啦"
            view.clipsToBounds = true
            return view
        }()
        
        QQBtn = {
            let btn = UIButton()
            bgView?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.centerX.equalTo((bgView?.snp.centerX)!).offset(widthBtn/2.0)
                make.top.equalTo((bottomlineView?.snp.bottom)!).offset(WH(6))
                make.width.equalTo(widthBtn)
                make.height.equalTo(WH(74))
            })
            
            if FKYShareManage.qqInstall() {
                // QQ已安装
                btn.setImage(UIImage.init(named: "icon_qq"), for: UIControl.State())
                _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                    guard let strongSelf = self else {
                        return
                    }
                    if strongSelf.QQShareClourse != nil {
                        strongSelf.QQShareClourse!()
                        strongSelf.dismissClourse!()
                    }
                    }, onError: nil, onCompleted: nil, onDisposed: nil)
            } else {
                // QQ未安装
                btn.setImage(UIImage.init(named: "icon_un_qq"), for: UIControl.State())
                btn.isEnabled = false
            }
            //btn.titleLabel!.fontTuple = t44
            
            return btn
        }()
        
        QQLab = {
            let label = UILabel()
            bgView?.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.centerX.equalTo((QQBtn?.snp.centerX)!)
                // make.height.equalTo(h5)
                make.width.equalTo(widthBtn)
                make.top.equalTo((QQBtn?.snp.bottom)!)
            })
            label.text = "QQ好友"
            label.fontTuple = t16
            label.textAlignment = .center
            return label
        }()
        
        weChatBtn = {
            let btn = UIButton()
            bgView?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.centerX.equalTo((bgView?.snp.centerX)!).offset(-widthBtn/2.0)
                make.top.equalTo((bottomlineView?.snp.bottom)!).offset(WH(6))
                make.width.equalTo(widthBtn)
                make.height.equalTo(WH(74))
            })
            
            if FKYShareManage.wxInstall() {
                // 微信已安装
                btn.setImage(UIImage.init(named: "icon_wx"), for: UIControl.State())
                btn.titleLabel!.fontTuple = t44
                _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                    guard let strongSelf = self else {
                        return
                    }
                    if strongSelf.WeChatShareClourse != nil {
                        strongSelf.WeChatShareClourse!()
                        strongSelf.dismissClourse!()
                    }
                    }, onError: nil, onCompleted: nil, onDisposed: nil)
            } else {
                // 微信未安装
                btn.setImage(UIImage.init(named: "icon_un_wx"), for: UIControl.State())
                btn.isEnabled = false
            }
            
            return btn
        }()
        
        weChatLab = {
            let label = UILabel()
            bgView?.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.centerX.equalTo((weChatBtn?.snp.centerX)!)
                // make.height.equalTo(h5)
                make.width.equalTo(widthBtn)
                make.top.equalTo((weChatBtn?.snp.bottom)!)
            })
            label.text = "微信好友"
            label.fontTuple = t16
            label.textAlignment = .center
            return label
        }()
        
        
        setMutiBorderRoundingCorners(bgView!, corner: WH(20))
        // 默认
        self.isUserInteractionEnabled = false
    }
    //设置圆角
    func setMutiBorderRoundingCorners(_ view:UIView,corner:CGFloat){
        
        let maskPath = UIBezierPath.init(roundedRect: view.bounds,
                                         
                                         byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.topLeft],
                                         
                                         cornerRadii: CGSize(width: corner, height: corner))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = view.bounds
        
        maskLayer.path = maskPath.cgPath
        
        view.layer.mask = maskLayer
        
    }
    fileprivate func setupAction() {
        // 分享视图显示
        self.appearClourse = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isUserInteractionEnabled = true
            strongSelf.superview?.bringSubviewToFront(strongSelf)
            strongSelf.sharedWordTextView?.text = strongSelf.liveShareWord ?? ""
            UIView.animate(withDuration: 0.35, animations: {[weak self]  in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.backgroundColor =  RGBAColor(0x000000, alpha: 0.3)
                strongSelf.bgView?.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT - WH(341) / 2)
            })
        }
        
        // 分享视图移除
        self.dismissClourse = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isUserInteractionEnabled = false
            //清空剪贴板
            
            UIView.animate(withDuration: 0.35, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.backgroundColor =  RGBAColor(0x000000, alpha: 0.0)
                strongSelf.bgView?.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT + WH(341) / 2)
                }, completion: { (finished) in
                    //                    if let dismissCompleteCallBack = self.dismissComplete {
                    //                        //dismissCompleteCallBack(self)
                    //                    }
                    UIPasteboard.general.string = ""
            })
        }
        
        // 取消
        if self.dismissClourse != nil {
            self.dismissClourse!()
        }
    }
    
    
    // MARK: - Public
    
    // 对外的显示方法
    @objc func showShareView() {
        self.isUserInteractionEnabled = true
        self.superview?.bringSubviewToFront(self)
        sharedWordTextView?.text = self.liveShareWord ?? ""
        UIView.animate(withDuration: 0.35, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.backgroundColor =  RGBAColor(0x000000, alpha: 0.3)
            strongSelf.bgView?.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT - WH(341) / 2)
        })
    }
}
