//
//  FKYUpdateAlertView.swift
//  FKY
//
//  Created by Rabe on 18/09/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  版本更新弹框

import Foundation
import UIKit

//typealias FKYUpdateAlertViewClousre = (_ currentCount: Int)->()
//内容的最大高度（超出则显示最大值）
let MSG_MAX_H = SCREEN_HEIGHT-navBarH-FKYTabBarController.shareInstance().tabbarHeight-28-20 - WH(230)

class FKYUpdateAlertView: UIView {
    // MARK: - Properties
    
    var msg: String = "现在有新的版本可供更新\n更新后体验更佳哦~"
    var forceUpdate: Bool = false
    var msg_H : CGFloat = 0 //内容的高度
    
    fileprivate lazy var backGroundView: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0x000000)
        return view
    }()
    
    fileprivate lazy var alertView: UIView! = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var bgImageView: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "update_alert_bg"))
        return imageView
    }()
    
    fileprivate lazy var logoImageView: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "update_alert_logo"))
        return imageView
    }()
    
    fileprivate lazy var lineImageView: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "update_alert_line"))
        return imageView
    }()
    
    fileprivate lazy var closeButton: UIButton! = {
        let button = UIButton()
        button.setImage(UIImage(named: "update_alert_close"), for: .normal)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let app = UIApplication.shared.delegate as? AppDelegate {
                app.showRedPacketView()
            }
            strongSelf.dismiss()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    fileprivate lazy var titleLabel: UILabel! = {
        let label = UILabel()
        label.text = "更新提示"
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.textColor = RGBColor(0x333333)
        return label
    }()
    
    fileprivate lazy var messageLabel: UILabel! = {
        let label = UILabel()
        label.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = WH(5)
        paragraphStyle.alignment = .left
        label.attributedText = NSAttributedString(string: self.msg, attributes: [NSAttributedString.Key.foregroundColor: RGBColor(0x555555), NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14)), NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()
    
    fileprivate lazy var messageBgscrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    fileprivate lazy var updateButton: UIButton! = {
        let button = UIButton()
        button.setTitle("立即更新", for: .normal)
        button.backgroundColor = RGBColor(0xff4f51)
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            let url = URL.init(string: AppStoreUrl)
            guard UIApplication.shared.canOpenURL(url!) else {
                return
            }
            UIApplication.shared.openURL(url!)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // MARK: - Life Cycle
    
    @objc static func alert(withMessage message: String, shouldForceUpdate flag: Bool) {
//#if FKY_ENVIRONMENT_DIS       // 线上环境
        let av = FKYUpdateAlertView(withMessage: message, shouldForceUpdate: flag)
        av.show()
//#elseif FKY_ENVIRONMENT_DEV  // 开发环境
//#elseif FKY_ENVIRONMENT_TEST // 测试环境
//#endif
    }
    
    convenience init(withMessage message: String, shouldForceUpdate flag: Bool) {
        self.init(frame: CGRect.zero)
        msg = message
        forceUpdate = flag
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = WH(5)
        msg_H = msg.boundingRect(with: CGSize(width: WH(200), height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14)), NSAttributedString.Key.paragraphStyle: paragraphStyle], context: nil).height
        if msg_H < MSG_MAX_H {
            messageBgscrollView.isScrollEnabled = false
        }else {
            msg_H = MSG_MAX_H
            messageBgscrollView.isScrollEnabled = true
        }
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    func show() {
       
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController?.view.addSubview(self)
        if let app = UIApplication.shared.delegate as? AppDelegate, let splash = app.splashView, splash.superview != nil{
            //防止更新框覆盖广告页
            window.rootViewController?.view.insertSubview(self, belowSubview: splash)
        }else if let app = UIApplication.shared.delegate as? AppDelegate, let compliance = app.complianceMaskView, compliance.superview != nil{
                //防止更新框覆盖合规页
                window.rootViewController?.view.insertSubview(self, belowSubview: compliance)

        } else {
            window.rootViewController?.view.bringSubviewToFront(self);
        }
        
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        backGroundView.alpha = 0
        alertView.alpha = 0
        alertView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 0.25) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.backGroundView.alpha = 0.6
            strongSelf.alertView.alpha = 1
        }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: .layoutSubviews, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.alertView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.backGroundView.alpha = 0
            strongSelf.alertView.alpha = 0
            strongSelf.alertView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) {[weak self] (ret) in
            guard let strongSelf = self else {
                return
            }
            if ret {
                strongSelf.removeFromSuperview()
            }
        }
    }
    
    // MARK: - UI
    
    func setupView() {
        self.tag = UPDATE_ALTER_VIEW_TAG
        self.addSubview(backGroundView)
        self.addSubview(alertView)
        if !forceUpdate { 
            self.addSubview(closeButton)
            self.addSubview(lineImageView)
        }
        alertView.addSubview(bgImageView)
        alertView.addSubview(logoImageView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageBgscrollView)
        messageBgscrollView.addSubview(messageLabel)
        alertView.addSubview(updateButton)
        
        backGroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        alertView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(WH(280))
            make.height.lessThanOrEqualTo(SCREEN_HEIGHT-navBarH-FKYTabBarController.shareInstance().tabbarHeight-28-20)
        }
        
        if !forceUpdate {
            closeButton.snp.makeConstraints { (make) in
                make.bottom.equalTo(lineImageView.snp.top)
                make.right.equalTo(alertView)
            }
            
            lineImageView.snp.makeConstraints { (make) in
                make.bottom.equalTo(alertView.snp.top)
                make.centerX.equalTo(closeButton)
            }
        }
        
        bgImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(alertView)
        }
        
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(alertView)
            make.top.equalTo(alertView).offset(WH(16))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(alertView)
            make.top.equalTo(alertView).offset(WH(115))
        }
        
        messageBgscrollView.snp.makeConstraints { (make) in
            make.centerX.equalTo(alertView)
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(12))
            make.left.equalTo(alertView).offset(WH(40))
            make.right.equalTo(alertView).offset(WH(-40))
            make.height.equalTo(msg_H)
        }
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(messageBgscrollView.snp.top)
            make.left.equalTo(messageBgscrollView)
            make.bottom.equalTo(messageBgscrollView.snp.bottom)
            make.width.equalTo(WH(200))
        }
        
        updateButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(alertView)
        make.top.equalTo(messageBgscrollView.snp.bottom).offset(WH(24))
            make.bottom.equalTo(alertView).offset(WH(-20))
            make.size.equalTo(CGSize(width: WH(240), height: WH(43)))
        }
    }
    
    // MARK: - Data
    
    // MARK: - Private Method
}
