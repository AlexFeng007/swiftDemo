//
//  LiveInfoBottomView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/18.
//  Copyright © 2020 yiyaowang. All rights reserved.
// 直播底部 分享 购物车 直播商品中心 消息入口

import UIKit

class LiveInfoBottomView: UIView {
    @objc var showLiveProductListBlock: emptyClosure? //点击购物篮按钮
    @objc var inputMsgActionBlock: emptyClosure? //点击消息输入区域
    @objc var clickLikeBtnBlock: emptyClosure? //点击点赞按钮
   // var marginBottom: CGFloat = 0
    //直播商品列表入口
    fileprivate lazy var productIcon: UIButton = {
        let button = UIButton()
       // button.setImage(UIImage(named: "live_product_list_icon"), for: UIControl.State())
        button.setBackgroundImage(UIImage(named: "live_product_list_icon"), for: UIControl.State())
        //button.imageView?.contentMode = .scaleToFill
        //button.imageEdgeInsets = UIEdgeInsets(top: WH(10), left: WH(10), bottom: WH(10), right: WH(10))
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.showLiveProductListBlock {
                closure()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    //抢购按钮
    var productBadgeView : JSBadgeView?
    //消息输入背景
    fileprivate lazy var inputBgView: UIView = {
        let view = UIView()
        //view.alpha = 0.2
        view.backgroundColor = RGBAColor(0x000000,alpha:0.2)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(17.5)
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.inputMsgActionBlock {
                closure()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    //消息输入描述
    fileprivate lazy var inputDescLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBAColor(0xffffff,alpha: 0.9)
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        label.text = "我来说两句~~"
        return label
    }()
    
    //直播商品列表入口
    fileprivate lazy var likeIcon: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "live_like_btn"), for: UIControl.State())
        //button.setImage(UIImage(named: "live_like_btn"), for: UIControl.State())
       // button.imageView?.contentMode = .scaleToFill
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickLikeBtnBlock {
                strongSelf.addAnimationWithLikeBtn()
                closure()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    //点赞数量
    var likeNumBadgeView : JSBadgeView?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
//        if #available(iOS 11, *) {
//            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
//            if (insets?.bottom)! > CGFloat.init(0) {
//                // iPhone X
//                marginBottom = iPhoneX_SafeArea_BottomInset
//            }
//        }
        
        self.addSubview(productIcon)
        productBadgeView = {
            let cbv = JSBadgeView.init(parentView: self.productIcon, alignment:JSBadgeViewAlignment.topCenter)
            cbv?.badgePositionAdjustment = CGPoint(x: WH(0), y: WH(2))
            cbv?.badgeTextFont = UIFont.systemFont(ofSize: WH(12))
            cbv?.badgeTextColor =  RGBColor(0xFFFFFF)
            cbv?.badgeBackgroundColor = RGBColor(0xFF2D5C)
            cbv?.badgeStrokeWidth = WH(1)
            cbv?.badgeStrokeColor = RGBColor(0xFFFFFF)
            return cbv
        }()
        self.addSubview(inputBgView)
        
        inputBgView.addSubview(inputDescLabel)
        
        inputBgView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(78))
            make.right.equalTo(self).offset(WH(-65))
            make.top.equalTo(self).offset(WH(13))
            make.height.equalTo(WH(35))
           // make.width.equalTo(WH(232))
        }
        productIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(19))
            make.centerY.equalTo(inputBgView.snp.centerY)
            make.height.width.equalTo(WH(40))
        }
        
        inputDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(inputBgView).offset(WH(20))
            make.centerY.equalTo(inputBgView)
            make.right.equalTo(inputBgView).offset(WH(-5))
        }
        
        self.addSubview(likeIcon)
        likeIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(inputBgView.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-WH(11))
            make.height.width.equalTo(WH(40))
        }
        likeNumBadgeView = {
            let cbv = JSBadgeView.init(parentView: self.likeIcon, alignment:JSBadgeViewAlignment.topCenter)
            cbv?.badgePositionAdjustment = CGPoint(x: WH(0), y: WH(2))
            cbv?.badgeTextFont = UIFont.boldSystemFont(ofSize: WH(12))
            cbv?.badgeTextColor =  RGBColor(0xFF2D5C)
            cbv?.badgeBackgroundColor = RGBColor(0xFFFFFF)
            return cbv
        }()
        
    }
    //设置商品数量
    func productBadgeNumText(_ badgeText:String?){
        self.productBadgeView?.badgeText = badgeText
    }
    //设置点赞数量
    func likeNumBadgeNumText(_ badgeText:String?) {
        self.likeNumBadgeView?.badgeText = badgeText
    }
}
extension LiveInfoBottomView {
    fileprivate func addAnimationWithLikeBtn(){
        //比例
        let scaleToLargeAnim = CABasicAnimation(keyPath:"transform.scale")
        scaleToLargeAnim.fromValue = NSNumber(1)
        scaleToLargeAnim.toValue = NSNumber(1.2)
        scaleToLargeAnim.isRemovedOnCompletion = true
        scaleToLargeAnim.fillMode = .forwards
        scaleToLargeAnim.duration = 0.2
        
        let scaleToSmallAnim = CABasicAnimation(keyPath:"transform.scale")
        scaleToSmallAnim.fromValue = NSNumber(1.2)
        scaleToSmallAnim.toValue = NSNumber(1.0)
        scaleToSmallAnim.isRemovedOnCompletion = true
        scaleToSmallAnim.fillMode = .forwards
        scaleToSmallAnim.duration = 0.2
        scaleToSmallAnim.beginTime = 0.2
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [scaleToLargeAnim,scaleToSmallAnim]
        animGroup.duration = 0.4
        if let _ = self.likeIcon.layer.animation(forKey: "like_icon_animation") {
            //防止点击过快
            self.likeIcon.layer.removeAnimation(forKey: "like_icon_animation")
        }
        self.likeIcon.layer.add(animGroup, forKey: "like_icon_animation")
    }
}
