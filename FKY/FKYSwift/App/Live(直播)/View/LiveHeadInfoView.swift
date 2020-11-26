//
//  LiveHeadInfoView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/17.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  直播间头部信息 包含退出和 直播信息

import UIKit

class LiveHeadInfoView: UIView {
    @objc var clickExitBlock: emptyClosure? //点击退出
    @objc var checkAnchorBlock: emptyClosure? //点击用户名
    @objc var clickShareBlock: emptyClosure? //点击分享按钮
    // MARK: - property
    //头部渐变背景
    fileprivate lazy var bgView :UIView = {
        let view = UIView()
        return view
    }()
    fileprivate lazy var contentLayer: CALayer = {
        let bgLayer1 = CAGradientLayer()
        bgLayer1.backgroundColor = UIColor.clear.cgColor
        bgLayer1.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.54).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor]
        bgLayer1.locations = [0,1]
        //bgLayer1.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(170))
        bgLayer1.startPoint = CGPoint(x: 0.5, y: 0)
        bgLayer1.endPoint = CGPoint(x: 0.5, y: 1.0)
        //        bgLayer1.shouldRasterize = true
        //        bgLayer1.rasterizationScale = UIScreen.main.scale
        return bgLayer1
    }()
    //主播信息
    fileprivate lazy var anchorViewView : LiveAnchorInfoView = {
        let view = LiveAnchorInfoView()
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.checkAnchorBlock {
                closure()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    //消失按钮
    fileprivate lazy var dismissBtn : UIButton = {
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "live_room_close"), for: [.normal])
        //backBtn.alpha = 0.2
        backBtn.backgroundColor = RGBAColor(0x000000,alpha: 0.2)
        backBtn.layer.masksToBounds = true
        backBtn.layer.cornerRadius = WH(18.5)
        _ = backBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickExitBlock {
                closure()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        backBtn.isHidden = false
        return backBtn
    }()
    
    //分享按钮
    fileprivate lazy var shareIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "live_room_share"), for: UIControl.State())
       // button.alpha = 0.2
        button.backgroundColor = RGBAColor(0x000000,alpha: 0.2)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = WH(18.5)
//        button.imageEdgeInsets = UIEdgeInsets(top: WH(10), left: WH(10), bottom: WH(10), right: WH(10))
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickShareBlock {
                closure()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(bgView)
        self.addSubview(anchorViewView)
        self.addSubview(dismissBtn)
        self.addSubview(shareIcon)
       
        bgView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:CGFloat(SKPhotoBrowser.getScreenTopMargin()) + WH(69))
        
        anchorViewView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(16))
            make.top.equalTo(self).offset(CGFloat(SKPhotoBrowser.getScreenTopMargin()) + WH(27))
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(186))
        }
        
        dismissBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(WH(-14))
            make.centerY.equalTo(anchorViewView.snp.centerY)
            make.height.width.equalTo(WH(37))
        }
        
        shareIcon.snp.makeConstraints { (make) in
            make.right.equalTo(dismissBtn.snp.left).offset(WH(-10))
            make.centerY.equalTo(anchorViewView.snp.centerY)
            make.height.width.equalTo(WH(37))
        }
        
        contentLayer.frame =  CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:CGFloat(SKPhotoBrowser.getScreenTopMargin()) + WH(69))
        bgView.layer.addSublayer(contentLayer)
        contentLayer.layoutIfNeeded()
    }
    func configView(_ baseInfo:Any?){
        if  let _ = baseInfo as? LiveInfoListModel{
            //点播信息是从列表来并且不支持分享
            shareIcon.isHidden = true
        }
        self.anchorViewView.configView(baseInfo)
    }
    func configPersonNumInfo(_ personNum:String?){
        anchorViewView.configPersonNumInfo(personNum)
    }
    func showHidenHeadView(){
        anchorViewView.isHidden = !anchorViewView.isHidden
        shareIcon.isHidden = !shareIcon.isHidden
    }
}
