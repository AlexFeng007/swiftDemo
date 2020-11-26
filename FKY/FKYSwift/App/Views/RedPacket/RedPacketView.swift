//
//  RedPacketView.swift
//  FKY
//
//  Created by 寒山 on 2019/1/15.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  红包视图UI

import UIKit

let UPDATE_ALTER_VIEW_TAG =  9473  //更新视图
let SHOW_REDPACKET_VIEW_TAG =  9474  //红包视图

typealias CheckRedPacketAction = ()->()


class RedPacketView: UIView {
    @objc var checkRedPacketAction: CheckRedPacketAction?//领取红包
    @objc var hideRedPacketAction:CheckRedPacketAction?//叉掉红包
    @objc var redPacketInfo: RedPacketInfoModel?
    
    //大背景
    fileprivate lazy var backGroundView: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0x000000)
        return view
    }()
    //红包背景图
    fileprivate lazy var bgImageView: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "rp_contentBg"))
        return imageView
    }()
    //红包图
    fileprivate lazy var rpImageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    //关闭按钮
    fileprivate lazy var closeButton: UIButton! = {
        let button = UIButton()
        button.setImage(UIImage(named: "close_btn_rp"), for: .normal)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            //埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "红包领取弹层", itemId: "I1101", itemPosition: "2", itemName: "关闭", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: HomeController.init())
            strongSelf.dismiss()
            if let clouse = strongSelf.hideRedPacketAction {
                clouse()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    //查看按钮
    fileprivate lazy var checkButton: UIButton! = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "rp_btn"), for: .normal)
        button.setTitle("试试手气吧", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        button.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            //埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "红包领取弹层", itemId: "I1101", itemPosition: "1", itemName: "试试手气吧", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: HomeController.init())
            if strongSelf.checkRedPacketAction != nil {
                strongSelf.checkRedPacketAction!()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    @objc convenience init(_ model: RedPacketInfoModel) {
        self.init(frame: CGRect.zero)
        self.redPacketInfo = model
        setupView()
        setupData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Action
    
    //展示
    @objc func show() {
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController?.view.addSubview(self)
        if let app = UIApplication.shared.delegate as? AppDelegate, let splash = app.splashView, splash.superview != nil {
            //防止更新框覆盖广告页
            window.rootViewController?.view.insertSubview(self, belowSubview: splash)
        }else if let app = UIApplication.shared.delegate as? AppDelegate, let compliance = app.complianceMaskView, compliance.superview != nil{
                //防止更新框覆盖合规页
                window.rootViewController?.view.insertSubview(self, belowSubview: compliance)

        }
        
        //更新提示
        if let subviews = window.rootViewController?.view.subviews{
            for  subView in subviews{
                if subView.tag == UPDATE_ALTER_VIEW_TAG{
                    window.rootViewController?.view.insertSubview(self, belowSubview: subView)
                    break
                }
            }
            //口令
            for  subView in subviews{
                if subView is FKYCommandView {
                    window.rootViewController?.view.insertSubview(self, belowSubview: subView)
                    break
                }
            }
        }
        
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        backGroundView.alpha = 0
        bgImageView.alpha = 0
        bgImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 0.25) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.backGroundView.alpha = 0.6
            strongSelf.bgImageView.alpha = 1
        }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: .layoutSubviews, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.bgImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    //消失
    @objc func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.backGroundView.alpha = 0
            strongSelf.bgImageView.alpha = 0
            strongSelf.bgImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
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
        self.tag = SHOW_REDPACKET_VIEW_TAG
        self.addSubview(backGroundView)
        self.addSubview(bgImageView)
        self.addSubview(rpImageView)
        self.addSubview(closeButton)
        self.addSubview(checkButton)
      
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            //埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "红包领取弹层", itemId: "I1101", itemPosition: "1", itemName: "试试手气吧", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: HomeController.init())
            if strongSelf.checkRedPacketAction != nil {
                strongSelf.checkRedPacketAction!()
            }
            
        }).disposed(by: disposeBag)
        rpImageView.addGestureRecognizer(tapGesture)
        
        backGroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        bgImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(WH(375))
            make.height.equalTo(WH(490))
        }
        rpImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(WH(300))
            make.height.equalTo(WH(347))
        }
        checkButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(WH(193))
            make.height.equalTo(WH(41))
            make.bottom.equalTo(rpImageView.snp.bottom).offset(WH(-35))
        }
        closeButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(rpImageView.snp.bottom).offset(WH(-8))
        }
    }
   
    func setupData() {
        rpImageView.sd_setImage(with: URL(string: self.redPacketInfo!.redPacketImage!), placeholderImage: nil)
        checkButton.setTitle(self.redPacketInfo!.subTitle, for: .normal)
    }
}
