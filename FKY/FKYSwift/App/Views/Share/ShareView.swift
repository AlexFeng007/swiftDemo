//
//  ShareView.swift
//  FKY
//
//  Created by mahui on 2016/11/5.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation

typealias ShareClourse = ()->()
typealias ShareDismissCompleteCallBack = ((_ shareView: ShareView)->())

class ShareView: UIView {
    // MARK: - Property
    @objc var QQShareClourse : ShareClourse?
    @objc var QQZoneShareClourse : ShareClourse?
    @objc var WeChatShareClourse : ShareClourse?
    @objc var WeChatFriendShareClourse : ShareClourse?
    @objc var SinaShareClourse : ShareClourse?
    
    @objc var dismissClourse : ShareClourse?
    @objc var dismissComplete : ShareDismissCompleteCallBack?
    @objc var appearClourse : ShareClourse?
    
    var cancleBtn : UIButton?
    var weChatBtn : UIButton?
    var weChatFriendBtn : UIButton?
    var sinaBtn : UIButton?
    var QQBtn : UIButton?
    var QQzoneBtn : UIButton?
    
    var weChatLab : UILabel?
    var weChatFriendLab : UILabel?
    var sinaLab : UILabel?
    var QQLab : UILabel?
    var QQzoneLab : UILabel?
    
    var bgView : UIView?
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
        
        self.appearClourse = {[weak self] () in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isUserInteractionEnabled = true
            strongSelf.superview?.bringSubviewToFront(strongSelf)
            UIView.animate(withDuration: 0.35, animations: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.backgroundColor =  RGBAColor(0x000000, alpha: 0.3)
                var height = CGFloat.init(0)
                if #available(iOS 11, *) {
                    let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
                    if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                        height = iPhoneX_SafeArea_BottomInset
                    }
                }
                strongSelf.bgView?.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT - (h17 + h26 + height) / 2)
            })
        }
        
        self.dismissClourse = { [weak self] () in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.35, animations: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.backgroundColor =  RGBAColor(0x000000, alpha: 0.0)
                strongSelf.bgView?.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT + (h17 + h26) / 2)
            })
            
            UIView.animate(withDuration: 0.35, animations: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.backgroundColor =  RGBAColor(0x000000, alpha: 0.0)
                strongSelf.bgView?.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT + (h17 + h26) / 2)
                }, completion: {[weak self]  (finished) in
                    guard let strongSelf = self else {
                        return
                    }
                    if let dismissCompleteCallBack = strongSelf.dismissComplete {
                        dismissCompleteCallBack(strongSelf)
                    }
            })
        }
        
        if self.dismissClourse != nil {
            self.dismissClourse!()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -
    
    func setupView() -> () {
        self.backgroundColor =  RGBAColor(0x000000, alpha: 0.0)
        let x = SCREEN_WIDTH / 4
        let width = WH(75)
        
        bgView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: (SCREEN_HEIGHT - h17 - h26), width: SCREEN_WIDTH, height: (h17 + h26))
            self.addSubview(view)
            view.backgroundColor = bg1
            return view
        }()
        
        cancleBtn = {
            let btn = UIButton()
            bgView?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(bgView!)
                make.height.equalTo(h17)
            })
            btn.setTitle("取消", for: UIControl.State())
            btn.setBackgroundImage(UIImage.imageWithColor(bg2, size: CGSize(width: SCREEN_WIDTH, height: h17)), for: UIControl.State())
            btn.setBackgroundImage(UIImage.imageWithColor(RGBColor(0xeaeaea), size: CGSize(width: SCREEN_WIDTH, height: h17)), for: .highlighted)
            btn.titleLabel!.font = t7.font
            btn.setTitleColor(t7.color, for: UIControl.State())
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
        
        QQzoneLab = {
            let label = UILabel()
            bgView?.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.bottom.equalTo((cancleBtn?.snp.top)!).offset(-h9)
                make.centerX.equalTo((bgView?.snp.centerX)!)
                make.height.equalTo(h5)
            })
            label.text = "QQ空间"
            label.fontTuple = t8
            return label
        }()
        
        QQzoneBtn = {
            let btn = UIButton()
            bgView?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.centerX.equalTo((QQzoneLab?.snp.centerX)!)
                make.bottom.equalTo((QQzoneLab?.snp.top)!)
                make.height.width.equalTo(width)
            })
            if FKYShareManage.qqInstall() {
                //
                btn.setImage(UIImage.init(named: "icon_zone"), for: UIControl.State())
                _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if let closure = strongSelf.QQZoneShareClourse {
                        closure()
                    }
                    if let closure = strongSelf.dismissClourse {
                        closure()
                    }
                    
                    //                    if self.QQZoneShareClourse != nil {
                    //                        self.QQZoneShareClourse!()
                    //                        self.dismissClourse!()
                    //                    }
                    }, onError: nil, onCompleted: nil, onDisposed: nil)
            }
            else {
                //
                btn.setImage(UIImage.init(named: "icon_un_zone"), for: UIControl.State())
                btn.isEnabled = false
            }
            btn.titleLabel!.fontTuple = t7
            return btn
        }()
        
        QQLab = {
            let label = UILabel()
            bgView?.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.centerX.equalTo(QQzoneLab!.snp.centerX).offset(-x)
                make.height.equalTo(h5)
                make.centerY.equalTo(QQzoneLab!)
            })
            label.text = "QQ好友"
            label.fontTuple = t8
            return label
        }()
        
        QQBtn = {
            let btn = UIButton()
            bgView?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.centerX.equalTo((QQLab?.snp.centerX)!)
                make.bottom.equalTo((QQLab?.snp.top)!)
                make.height.width.equalTo(width)
            })
            if FKYShareManage.qqInstall() {
                // 已安装QQ
                btn.setImage(UIImage.init(named: "icon_qq"), for: UIControl.State())
                _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if let closure = strongSelf.QQShareClourse {
                        closure()
                    }
                    if let closure = strongSelf.dismissClourse {
                        closure()
                    }
                    
                    //                    if strongSelf.QQShareClourse != nil {
                    //                        strongSelf.QQShareClourse!()
                    //                        strongSelf.dismissClourse!()
                    //                    }
                    }, onError: nil, onCompleted: nil, onDisposed: nil)
            }
            else {
                // 未安装QQ
                btn.setImage(UIImage.init(named: "icon_un_qq"), for: UIControl.State())
                btn.isEnabled = false
            }
            btn.titleLabel!.fontTuple = t7
            
            return btn
        }()
        
        weChatFriendLab = {
            let label = UILabel()
            bgView?.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.centerX.equalTo(bgView!.snp.centerX)
                make.height.equalTo(h5)
                make.bottom.equalTo((QQzoneBtn?.snp.top)!).offset(-h9)
            })
            label.text = "微信朋友圈"
            label.fontTuple = t8
            return label
        }()
        
        weChatFriendBtn = {
            let btn = UIButton()
            bgView?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.centerX.equalTo((weChatFriendLab?.snp.centerX)!)
                make.bottom.equalTo((weChatFriendLab?.snp.top)!)
                make.height.width.equalTo(width)
            })
            
            if FKYShareManage.wxInstall() {
                //
                btn.setImage(UIImage.init(named: "icon_wx_friends"), for: UIControl.State())
                btn.titleLabel!.fontTuple = t7
                _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if let closure = strongSelf.WeChatFriendShareClourse {
                        closure()
                    }
                    if let closure = strongSelf.dismissClourse {
                        closure()
                    }
                    
                    //                    if self.WeChatFriendShareClourse != nil {
                    //                        self.WeChatFriendShareClourse!()
                    //                        self.dismissClourse!()
                    //                    }
                    }, onError: nil, onCompleted: nil, onDisposed: nil)
            }
            else {
                //
                btn.setImage(UIImage.init(named: "icon_un_wx_friends"), for: UIControl.State())
                btn.isEnabled = false
            }
            return btn
        }()
        
        weChatLab = {
            let label = UILabel()
            bgView?.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.centerX.equalTo(weChatFriendLab!.snp.centerX).offset(-x)
                make.height.equalTo(h5)
                make.centerY.equalTo(weChatFriendLab!)
            })
            label.text = "微信好友"
            label.fontTuple = t8
            return label
        }()
        
        weChatBtn = {
            let btn = UIButton()
            bgView?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.centerX.equalTo((weChatLab?.snp.centerX)!)
                make.bottom.equalTo((weChatLab?.snp.top)!)
                make.height.width.equalTo(width)
            })
            
            if FKYShareManage.wxInstall() {
                //
                btn.setImage(UIImage.init(named: "icon_wx"), for: UIControl.State())
                btn.titleLabel!.fontTuple = t7
                _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if let closure = strongSelf.WeChatShareClourse {
                        closure()
                    }
                    if let closure = strongSelf.dismissClourse {
                        closure()
                    }
                    
                    //                    if self.WeChatShareClourse != nil {
                    //                        self.WeChatShareClourse!()
                    //                        self.dismissClourse!()
                    //                    }
                    }, onError: nil, onCompleted: nil, onDisposed: nil)
            }
            else {
                //
                btn.setImage(UIImage.init(named: "icon_un_wx"), for: UIControl.State())
                btn.isEnabled = false
            }
            
            return btn
        }()
        
        sinaLab = {
            let label = UILabel()
            bgView?.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.centerX.equalTo(weChatFriendLab!.snp.centerX).offset(x)
                make.height.equalTo(h5)
                make.centerY.equalTo(weChatFriendLab!)
            })
            label.text = "微博"
            label.fontTuple = t8
            return label
        }()
        
        sinaBtn = {
            let btn = UIButton()
            bgView?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.centerX.equalTo((sinaLab?.snp.centerX)!)
                make.bottom.equalTo((sinaLab?.snp.top)!)
                make.height.width.equalTo(width)
            })
            
            if FKYShareManage.sinaInstall() {
                //
                btn.setImage(UIImage.init(named: "icon_wb"), for: UIControl.State())
                btn.titleLabel!.fontTuple = t7
                _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if let closure = strongSelf.SinaShareClourse {
                        closure()
                    }
                    if let closure = strongSelf.dismissClourse {
                        closure()
                    }
                    
                    //                    if self.SinaShareClourse != nil {
                    //                        self.SinaShareClourse!()
                    //                        self.dismissClourse!()
                    //                    }
                    }, onError: nil, onCompleted: nil, onDisposed: nil)
            }
            else {
                //
                btn.setImage(UIImage.init(named: "icon_un_wb"), for: UIControl.State())
                btn.isEnabled = false
            }
            return btn
        }()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if (touch.view == self && self.dismissClourse != nil) {
                self.dismissClourse!()
            }
        }
    }
}
extension ShareView {
    class func showShareViewWithParamas(_ shareUrl:String ,_ shareTitle : String ,_ shareMessage:String ,_ shareImage : String){
        let shareView = ShareView()
        if let bgView = UIApplication.shared.windows.last {
            bgView.addSubview(shareView)
            shareView.snp.makeConstraints({ (make) in
                make.edges.equalTo(bgView)
            })
            
            shareView.WeChatShareClourse = { () in
                FKYShareManage.shareToWX(withOpenUrl: shareUrl, title: shareTitle, andMessage: shareMessage, andImage: shareImage)
                //CurrentViewController.shared.item?.BI_Record(.MAINSTORE_YC_SHARE_WECHAT)
            }
            shareView.WeChatFriendShareClourse = { () in
                FKYShareManage.shareToWXFriend(withOpenUrl: shareUrl, title: shareTitle, andMessage: shareMessage, andImage: shareImage)
                //CurrentViewController.shared.item?.BI_Record(.MAINSTORE_YC_SHARE_MOMENTS)
            }
            shareView.QQShareClourse = { () in
                FKYShareManage.shareToQQ(withOpenUrl: shareUrl, title: shareTitle, andMessage: shareMessage, andImage: shareImage)
                //CurrentViewController.shared.item?.BI_Record(.MAINSTORE_YC_SHARE_QQ)
            }
            shareView.QQZoneShareClourse = { () in
                FKYShareManage.shareToQQZone(withOpenUrl: shareUrl, title: shareTitle, andMessage: shareMessage, andImage: shareImage)
                //CurrentViewController.shared.item?.BI_Record(.MAINSTORE_YC_SHARE_QZONE)
            }
            shareView.SinaShareClourse = { () in
                FKYShareManage.shareToSina(withOpenUrl: shareUrl, title: shareTitle, andMessage: shareMessage, andImage: shareImage)
                //CurrentViewController.shared.item?.BI_Record(.MAINSTORE_YC_SHARE_WEIBO)
            }
            shareView.appearClourse!()
        }
    }
}

