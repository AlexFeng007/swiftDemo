//
//  VodPlayerContentInfoView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class VodPlayerContentInfoView: UIView {
    @objc var checkAnchorBlock: emptyClosure? //点击用户名
    @objc var clickExitBlock: emptyClosure? //点击退出
    @objc var showLiveProductListBlock: emptyClosure? //点击购物篮按钮
    @objc var setVideoTimeBlock :((Float)->())? //设置播放时间
    @objc var clickShareBlock: emptyClosure? //点击分享按钮
    @objc var playVideoBlock: emptyClosure? //点击播放按钮
    @objc var pauseVideoBlock: emptyClosure? //点击暂停按钮
    var marginBottom: CGFloat = 0
    //头部信息 包含基本信息和退出
    fileprivate lazy var headView : LiveHeadInfoView = {
        let view = LiveHeadInfoView(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: (SKPhotoBrowser.getScreenTopMargin() + WH(69))))
        view.backgroundColor = .clear
        view.checkAnchorBlock = {[weak self] in
            if let strongSelf = self {
                if let closure = strongSelf.checkAnchorBlock {
                    closure()
                }
            }
        }
        view.clickExitBlock = {[weak self] in
            if let strongSelf = self {
                if let closure = strongSelf.clickExitBlock  {
                    closure()
                }
            }
        }
        //点击分享按钮
        view.clickShareBlock = {[weak self] in
            if let strongSelf = self {
                if let closure = strongSelf.clickShareBlock {
                    closure()
                }
            }
        }
        return view
    }()
    //推荐商品
    fileprivate lazy var introProductView : LiveIntroProductInfoView = {
        let view = LiveIntroProductInfoView()
        view.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.showLiveProductListBlock {
                closure()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    //底部信息
    fileprivate lazy var bottomView : VodInfoBottomView = {
        let view = VodInfoBottomView()
        view.backgroundColor = .clear
        //点击购物篮按钮
        view.showLiveProductListBlock = {[weak self] in
            if let strongSelf = self {
                if let closure = strongSelf.showLiveProductListBlock  {
                    closure()
                }
            }
        }
        view.setVideoTimeBlock = {[weak self] value in
            if let strongSelf = self {
                if let closure = strongSelf.setVideoTimeBlock  {
                    closure(value)
                }
            }
        }
        //点击播放按钮
        view.playVideoBlock = {[weak self] in
            if let strongSelf = self {
                if let closure = strongSelf.playVideoBlock  {
                    closure()
                }
            }
        }
        //点击暂停按钮
        view.pauseVideoBlock = {[weak self] in
            if let strongSelf = self {
                if let closure = strongSelf.pauseVideoBlock  {
                    closure()
                }
            }
        }
        return view
    }()
    
    //底部大渐变层
    fileprivate lazy var bottomLayerView :UIView = {
        let view = UIView()
        return view
    }()
    fileprivate lazy var bottomLayer: CALayer = {
        let bgLayer1 = CAGradientLayer()
        bgLayer1.backgroundColor = UIColor.clear.cgColor
        bgLayer1.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.36).cgColor]
        bgLayer1.locations = [0,1]
        bgLayer1.startPoint = CGPoint(x: 0.5, y: 0)
        bgLayer1.endPoint = CGPoint(x: 0.5, y: 1.0)
        return bgLayer1
    }()
    //视频介绍
    fileprivate lazy var introduceLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.textColor = RGBColor(0xffffff)
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
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
        self.backgroundColor = .clear
        self.addSubview(headView)
        self.addSubview(introProductView)
        self.addSubview(bottomLayerView)
        self.addSubview(bottomView)
        self.addSubview(introduceLabel)
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                marginBottom = iPhoneX_SafeArea_BottomInset
            }
        }
        
        bottomView.frame = CGRect(x:0, y: SCREEN_HEIGHT - WH(70) - marginBottom/2.0, width: SCREEN_WIDTH, height: WH(70) + marginBottom/2.0)
        bottomLayerView.frame = CGRect(x:0, y: SCREEN_HEIGHT - WH(70) - marginBottom/2.0, width: SCREEN_WIDTH, height: WH(70) + marginBottom/2.0)
        bottomLayer.frame = CGRect(x:0, y: 0, width: SCREEN_WIDTH, height: WH(70) + marginBottom/2.0)
        bottomLayerView.layer.addSublayer(bottomLayer)
        bottomLayer.layoutIfNeeded()
        
        introProductView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(12))
            make.right.equalTo(self).offset(WH(-95))
            make.bottom.equalTo(bottomView.snp.top)
            make.height.equalTo(WH(86.7))
        }
        introduceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(17))
            make.right.equalTo(self).offset(WH(-95))
            make.bottom.equalTo(introProductView.snp.top).offset(WH(-10))
        }
        introProductView.isHidden = true
    }
}
//MARK:控制播放
extension VodPlayerContentInfoView {
    func playAction(){
        self.bottomView.setPlayVideoState()
    }
    func pasuseAction(){
        self.bottomView.setPauseVideoState()
    }
}
//MARK:对界面赋值
extension VodPlayerContentInfoView {
    func configLiveRoomBaseInfo(_ baseInfo:Any?){
        self.headView.configView(baseInfo)
    }
    func productBadgeNumText(_ badgeText:String?){
        self.bottomView.productBadgeNumText(badgeText)
    }
    func setVideoTotalTime(_ totalTime:Float){
        bottomView.setVideoTotalTime(totalTime)
    }
    func configPersonNumInfo(_ personNum:String?){
        self.headView.configPersonNumInfo(personNum)
    }
    func setVideoCurrectTime(_ currectTime:Float){
        bottomView.setVideoCurrectTime(currectTime)
    }
    //视频播放底部样式 有商品和无商品展示
    func configVideoBottomView(_ show:Bool){
        if show == true{
            introProductView.isHidden = false
            introProductView.snp.updateConstraints { (make) in
                make.height.equalTo(WH(73))
            }
            introduceLabel.snp.updateConstraints { (make) in
                make.bottom.equalTo(introProductView.snp.top).offset(WH(-10))
            }
        }else{
            introProductView.isHidden = true
            introProductView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            introduceLabel.snp.updateConstraints { (make) in
                make.bottom.equalTo(introProductView.snp.top)
            }
            bottomView.changeBottomViewStyle(show)
        }
    }
    func configLiveCurrectProduct(_ productInfo:HomeCommonProductModel?,_ title:String?){
        introProductView.isHidden = true
        if let model = productInfo{
            self.introProductView.configVideoDetailView(model)
            introProductView.isHidden = false
        }
        if let str = title {
            introduceLabel.isHidden = false
            introduceLabel.text = str
        }
        
    }
    func videoPlayerDetailViewSet(){
        self.headView.showHidenHeadView()
    }
}
