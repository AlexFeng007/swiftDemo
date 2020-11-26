//
//  ShareView4Pay.swift
//  FKY
//
//  Created by 夏志勇 on 2017/10/24.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  找人代付功能相关分享视图

import UIKit
import Foundation


typealias SharePayClourse = ()->()
typealias SharePayDismissCompleteCallBack = ((_ shareView: ShareView4Pay)->())


class ShareView4Pay: UIView {
    // MARK: - Property
    
    @objc var WeChatShareClourse : SharePayClourse?      // 微信好友
    @objc var QQShareClourse : SharePayClourse?          // QQ好友
    @objc var CopyLinkShareClourse : SharePayClourse?    // 复制链接
    
    @objc var dismissClourse : SharePayClourse?   // 隐藏
    @objc var appearClourse : SharePayClourse?    // 显示
    @objc var dismissComplete : SharePayDismissCompleteCallBack?  // 完成
    
    var weChatBtn : UIButton?
    var QQBtn : UIButton?
    var copyBtn : UIButton?
    var cancleBtn : UIButton?
    
    var weChatLab : UILabel?
    var QQLab : UILabel?
    var copyLab : UILabel?
    
    var bgView : UIView?
    var lineView : UIView?
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    // MARK: - Init
    
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
        
        let widthBtn = (SCREEN_WIDTH - WH(30)) / 3
        
        bgView = {
            let view = UIView()
            view.backgroundColor = bg1
            //view.frame = CGRect(x: 0, y: (SCREEN_HEIGHT - WH(55) - WH(150)), width: SCREEN_WIDTH, height: (WH(55) + WH(150)))
            view.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: (WH(55) + WH(150)))
            self.addSubview(view)
            return view
        }()
        
        cancleBtn = {
            let btn = UIButton()
            bgView?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(bgView!)
                make.height.equalTo(WH(55))
            })
            btn.setTitle("取消", for: UIControl.State())
            //btn.setBackgroundImage(UIImage.imageWithColor(bg2, size: CGSize(width: SCREEN_WIDTH, height: h17)), for: UIControlState())
            //btn.setBackgroundImage(UIImage.imageWithColor(RGBColor(0xeaeaea), size: CGSize(width: SCREEN_WIDTH, height: h17)), for: .highlighted)
            btn.titleLabel!.font = t36.font
            btn.setTitleColor(t44.color, for: .normal)
            btn.setTitleColor(UIColor.gray, for: .highlighted)
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
        
        QQBtn = {
            let btn = UIButton()
            bgView?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.centerX.equalTo((bgView?.snp.centerX)!)
                make.top.equalTo((bgView?.snp.top)!).offset(WH(15))
                make.width.equalTo(widthBtn)
                make.height.equalTo(WH(80))
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
                make.height.equalTo(h5)
                make.width.equalTo(widthBtn)
                make.top.equalTo((QQBtn?.snp.bottom)!).offset(-WH(5))
            })
            label.text = "QQ好友"
            label.fontTuple = t48
            label.textAlignment = .center
            return label
        }()
        
        weChatBtn = {
            let btn = UIButton()
            bgView?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.right.equalTo((QQBtn?.snp.left)!)
                make.top.equalTo((bgView?.snp.top)!).offset(WH(15))
                //make.height.width.equalTo(widthBtn)
                make.width.equalTo(widthBtn)
                make.height.equalTo(WH(80))
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
                make.height.equalTo(h5)
                make.width.equalTo(widthBtn)
                make.top.equalTo((weChatBtn?.snp.bottom)!).offset(-WH(5))
            })
            label.text = "微信好友"
            label.fontTuple = t48
            label.textAlignment = .center
            return label
        }()
        
        copyBtn = {
            let btn = UIButton()
            bgView?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.left.equalTo((QQBtn?.snp.right)!)
                make.top.equalTo((bgView?.snp.top)!).offset(WH(15))
                //make.height.width.equalTo(widthBtn)
                make.width.equalTo(widthBtn)
                make.height.equalTo(WH(80))
            })
            
            btn.setImage(UIImage.init(named: "icon_copy_share"), for: UIControl.State())
            btn.titleLabel!.fontTuple = t44
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.CopyLinkShareClourse != nil {
                    strongSelf.CopyLinkShareClourse!()
                    strongSelf.dismissClourse!()
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            
            return btn
        }()
        
        copyLab = {
            let label = UILabel()
            bgView?.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.centerX.equalTo((copyBtn?.snp.centerX)!)
                make.height.equalTo(h5)
                make.width.equalTo(widthBtn)
                make.top.equalTo((copyBtn?.snp.bottom)!).offset(-WH(5))
            })
            label.text = "复制链接"
            label.fontTuple = t48
            label.textAlignment = .center
            return label
        }()
        
        // 加分隔线
        lineView = {
            let view = UIView()
            view.backgroundColor = RGBColor(0xEBEDEC)
            //view.backgroundColor = UIColor.purple
            bgView?.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.height.equalTo(1.0)
                make.bottom.equalTo((cancleBtn?.snp.top)!)
                //make.bottom.equalTo(bgView!).offset(-(WH(55)))
                make.left.right.equalTo(bgView!)
            })
            return view
        }()
        
        // 默认
        self.isUserInteractionEnabled = false
    }
    
    fileprivate func setupAction() {
        // 分享视图显示
        self.appearClourse = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isUserInteractionEnabled = true
            strongSelf.superview?.bringSubviewToFront(strongSelf)
            
            UIView.animate(withDuration: 0.35, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf .backgroundColor =  RGBAColor(0x000000, alpha: 0.3)
                var height = CGFloat.init(0)
                if #available(iOS 11, *) {
                    let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
                    if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                        height = iPhoneX_SafeArea_BottomInset
                    }
                }
                strongSelf.bgView?.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT - (WH(55) + WH(150) + height) / 2)
            })
        }
        
        // 分享视图移除
        self.dismissClourse = {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isUserInteractionEnabled = false
            
            //            UIView.animate(withDuration: 0.35, animations: {
            //                self.backgroundColor =  RGBAColor(0x000000, alpha: 0.0)
            //                self.bgView?.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT + (WH(55) + WH(150)) / 2)
            //            })
            
            UIView.animate(withDuration: 0.35, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf .backgroundColor =  RGBAColor(0x000000, alpha: 0.0)
                strongSelf .bgView?.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT + (WH(55) + WH(150)) / 2)
                }, completion: { [weak self](finished) in
                    guard let strongSelf = self else {
                        return
                    }
                    if let dismissCompleteCallBack = strongSelf .dismissComplete {
                        dismissCompleteCallBack(strongSelf)
                    }
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
        
        UIView.animate(withDuration: 0.35, animations: {[weak self] in
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
            strongSelf.bgView?.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT - (WH(55) + WH(150) + height) / 2)
        })
    }
}
