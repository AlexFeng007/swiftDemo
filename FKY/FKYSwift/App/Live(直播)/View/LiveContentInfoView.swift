//
//  LiveContentInfoView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/17.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveContentInfoView: UIView {
    @objc var clickSiteProductBlock: ((Int)->())? //点击坑位
    @objc var clickShareBlock: emptyClosure? //点击分享按钮
    @objc var showLiveProductListBlock: emptyClosure? //点击购物篮按钮
    @objc var clickCartBlock: emptyClosure? //点击购物车按钮
    @objc var inputMsgActionBlock: emptyClosure? //点击消息输入区域
    @objc var checkAnchorBlock: emptyClosure? //点击用户名
    @objc var clickExitBlock: emptyClosure? //点击退出
    @objc var sendMessageBlock :((String)->())? //发送消息
    @objc var sendClickLikeBlock :(()->())? //点赞
    @objc var receiveCouponBlock: emptyClosure?//点击领取优惠券
    @objc var accessAwardBlock: emptyClosure?//点击抽奖
    @objc var touchItem:((HomeCommonProductModel)->())? //进入商详
    @objc var sendToastBlock: ((String)->())?//抽奖倒计时未开始提示
    @objc var timeOutSendBlock: (()->())?//抽奖倒计时结束
    var marginBottom: CGFloat = 0
    var currectRcommendProduct:HomeCommonProductModel? //当前主推品
    fileprivate var timer: Timer!
    var awardTimeCount : Int64 = 0
    var siteProductHiddenFlag: Bool = true   //坑位商品隐藏或者显示
    var currentIntrlProductHiddenFlag: Bool = true   //当前主品商品隐藏或者显示
    //判断是否有红包，优惠券，倒计时视图
    var hasCouponsView = false
    var hasRedPacketView = false
    var hasRedTimeOut = false
    
    fileprivate lazy var bgView : UIView = {
        let bgview = UIView()
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.showHideContentView()
        }).disposed(by: disposeBag)
        bgview.addGestureRecognizer(tapGesture)
        return bgview
    }()//
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
    //MARK:消息列表视图及欢迎新进观众提示
    fileprivate lazy var messageListView : LiveListMessageInfoView = {
        let view = LiveListMessageInfoView()
        return view
    }()
    //MARK:消息输入
    fileprivate lazy var messageInputView : LiveInputInfoView = {
        let view = LiveInputInfoView()
        view.viewParent = self
        view.inputOverBlock = { [weak self] (messageStr) in
            if let strongSelf = self {
                if let str = messageStr ,str.count > 0 {
                    if let block = strongSelf.sendMessageBlock {
                        block(str)
                    }
                }
            }
        }
        return view
    }()
    //坑位背景
    fileprivate lazy var siteProductBgView : UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = WH(8)
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = RGBAColor(0x000000, alpha: 0.2)
        
        let layerView = UIView()
        layerView.frame = CGRect(x: 0, y: 0, width: WH(74), height: WH(20))
        // fillCode
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = [UIColor(red: 1, green: 0.41, blue: 0.15, alpha: 1).cgColor, UIColor(red: 1, green: 0.38, blue: 0.28, alpha: 1).cgColor]
        bgLayer1.locations = [0, 1]
        bgLayer1.frame = layerView.bounds
        bgLayer1.startPoint = CGPoint(x: 1, y: 0.5)
        bgLayer1.endPoint = CGPoint(x: 0.5, y: 0.5)
        layerView.layer.addSublayer(bgLayer1)
        bgView.addSubview(layerView)
        
        let label = UILabel()
        let attrString = NSMutableAttributedString(string: "本场爆款")
        label.numberOfLines = 0
        let attr: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: WH(12)),.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1)]
        attrString.addAttributes(attr, range: NSRange(location: 0, length: attrString.length))
        label.attributedText = attrString
        label.textAlignment = .center
        layerView.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(layerView)
        }
        return bgView
    }()
    //坑位商品 1
    fileprivate lazy var firstSiteProductView : LiveSiteProductView = {
        let view = LiveSiteProductView()
        view.layer.cornerRadius = WH(2)
        view.layer.masksToBounds = true
        view.backgroundColor = RGBColor(0xffffff)
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickSiteProductBlock {
                closure(0)
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    //坑位商品 2
    fileprivate lazy var secondSiteProductView : LiveSiteProductView = {
        let view = LiveSiteProductView()
        view.layer.cornerRadius = WH(2)
        view.layer.masksToBounds = true
        view.backgroundColor = RGBColor(0xffffff)
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickSiteProductBlock {
                closure(1)
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    //抽奖入口
    fileprivate lazy var accessAwardView : UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.backgroundColor = .clear
        view.image = UIImage(named: "live_award_icon")
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if  0 >= strongSelf.awardTimeCount {
                if let closure = strongSelf.accessAwardBlock {
                    closure()
                }
            }else {
                if let closure = strongSelf.sendToastBlock {
                    closure("活动暂未开始，请耐心等待")
                }
            }
            
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    //倒计时
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFFEB92)
        label.font = UIFont.boldSystemFont(ofSize: WH(11))
        label.textAlignment = .center
        label.isHidden = true
        label.layer.cornerRadius = WH(8)
        label.layer.masksToBounds = true
        label.backgroundColor = RGBAColor(0x070D32, alpha: 0.4)
        return label
    }()
    
    //优惠券入口
    fileprivate lazy var receiveCouponView : UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.backgroundColor = .clear
        view.image = UIImage(named: "live_coupon_icon")
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.receiveCouponBlock {
                closure()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
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
    fileprivate lazy var bottomView : LiveInfoBottomView = {
        let view = LiveInfoBottomView()
        view.backgroundColor = .clear
        //点击购物篮按钮
        view.showLiveProductListBlock = {[weak self] in
            if let strongSelf = self {
                if let closure = strongSelf.showLiveProductListBlock  {
                    closure()
                }
            }
        }
        //点击消息输入区域
        view.inputMsgActionBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.messageInputView.showOrHidePopView(true)
                if let closure = strongSelf.inputMsgActionBlock {
                    closure()
                }
            }
        }
        //点击点赞
        view.clickLikeBtnBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.showLikeHeartStartRect()
                if let block = strongSelf.sendClickLikeBlock{
                    block()
                }
            }
        }
        
        return view
    }()
    
    //动画运动层
    fileprivate lazy var animationrView :UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.showHideContentView()
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
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
        //bgLayer1.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(170))
        bgLayer1.startPoint = CGPoint(x: 0.5, y: 0)
        bgLayer1.endPoint = CGPoint(x: 0.5, y: 1.0)
        //        bgLayer1.shouldRasterize = true
        //        bgLayer1.rasterizationScale = UIScreen.main.scale
        return bgLayer1
    }()
    
    
    //
    var heartAnimationPoints = NSMutableArray()
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
        self.addSubview(bgView)
        self.addSubview(headView)
        self.addSubview(bottomLayerView)
        self.addSubview(siteProductBgView)
        siteProductBgView.addSubview(firstSiteProductView)
        siteProductBgView.addSubview(secondSiteProductView)
        self.addSubview(accessAwardView)
        self.addSubview(timeLabel)
        self.addSubview(receiveCouponView)
        self.addSubview(introProductView)
        self.addSubview(messageListView)
        self.addSubview(bottomView)
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                marginBottom = iPhoneX_SafeArea_BottomInset
            }
        }
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        siteProductBgView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(16))
            make.top.equalTo(headView.snp.bottom).offset(WH(19))
            make.height.equalTo(WH(164))
            make.width.equalTo(WH(74))
        }
        
        firstSiteProductView.snp.makeConstraints { (make) in
            make.centerX.equalTo(siteProductBgView)
            make.top.equalTo(siteProductBgView).offset(WH(23))
            make.height.equalTo(WH(65))
            make.width.equalTo(WH(65))
        }
        secondSiteProductView.snp.makeConstraints { (make) in
            make.centerX.equalTo(siteProductBgView)
            make.top.equalTo(firstSiteProductView.snp.bottom).offset(WH(5))
            make.height.equalTo(WH(65))
            make.width.equalTo(WH(65))
        }
        
        accessAwardView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(WH(-11))
            make.top.equalTo(siteProductBgView.snp.top)
            make.height.equalTo(WH(60))
            make.width.equalTo(WH(60))
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(accessAwardView)
            make.top.equalTo(accessAwardView.snp.bottom).offset(WH(3))
            make.height.equalTo(WH(0))
            make.width.equalTo(WH(60))
        }
        
        receiveCouponView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(WH(-11))
            make.top.equalTo(timeLabel.snp.bottom).offset(WH(20))
            make.height.equalTo(WH(60))
            make.width.equalTo(WH(60))
        }
        
        bottomLayerView.frame = CGRect(x:0, y: SCREEN_HEIGHT - WH(175) - marginBottom/2.0, width: SCREEN_WIDTH, height: WH(175) + marginBottom/2.0)
        
        bottomView.frame = CGRect(x:0, y: SCREEN_HEIGHT - WH(63) - marginBottom/2.0, width: SCREEN_WIDTH, height: WH(63) + marginBottom/2.0)
        
        introProductView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(12))
            make.right.equalTo(self).offset(WH(-95))
            make.bottom.equalTo(bottomView.snp.top)
            make.height.equalTo(WH(86.7))
        }
        introProductView.isHidden = true
        siteProductBgView.isHidden = true
        bottomLayer.frame = CGRect(x:0, y: 0, width: SCREEN_WIDTH, height: WH(175) + marginBottom/2.0)
        bottomLayerView.layer.addSublayer(bottomLayer)
        bottomLayer.layoutIfNeeded()
        
        messageListView.snp.makeConstraints { (make) in
            make.height.equalTo(MESSAGE_TAB_H+WELCOM_VIEW_H)
            make.left.equalTo(self)
            make.width.equalTo(MESSAGE_LIST_W+WH(14))
            make.bottom.equalTo(introProductView.snp.top).offset(-WH(8))
        }
        
        self.insertSubview(animationrView, belowSubview: bottomView)
        animationrView.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.bottom.equalTo(bottomView.snp.top).offset(WH(20))
            make.width.equalTo(WH(90))
            make.height.equalTo(SCREEN_HEIGHT-WH(30)-marginBottom/2.0-WH(300))
        }
    }
}

//MARK:设置消息视图数据
extension LiveContentInfoView {
    func configListMessageViewInfoData(_ typeIndex:Int,_ messageModelArr:[LiveMessageMode]) {
        messageListView.configListMessageViewInfo(typeIndex,messageModelArr)
    }
    func autoCopyStrToInput(_ copyStr:String) {
        messageInputView.resetInputText(copyStr)
    }
    func removeMessageListView() {
        messageListView.removeFromSuperview()
    }
}

//MARK:点赞
extension LiveContentInfoView {
    func showLikeHeartStartRect() {
        if self.animationrView.isHidden == true {
            //底部隐藏不显示爱心
            return
        }
        animationrView.layoutIfNeeded()
        let frame = CGRect(x: SCREEN_WIDTH-WH(21+40)-animationrView.frame.origin.x, y: SCREEN_HEIGHT-WH(50+40)-marginBottom/2.0-animationrView.frame.origin.y, width: WH(40), height: WH(40))
        LiveFrequeControl.shareLiveControl.resetCountsAndSeconds(10, 1);
        if LiveFrequeControl.shareLiveControl.canTrigger() == false {
            return
        }
        let imageView = UIImageView.init(frame: frame)
        let endNum = arc4random_uniform(5)
        let imageStr = "live_show_like_\(endNum)"
        imageView.image = UIImage(named: imageStr)
        animationrView.addSubview(imageView)
        imageView.alpha = 0.0
        imageView.layer.add(hearAnimationFrom(frame), forKey: nil)
        let deadline = DispatchTime.now() + 3
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            DispatchQueue.main.async {
                imageView.removeFromSuperview()
            }
        }
    }
    
    fileprivate func hearAnimationFrom(_ frame:CGRect) -> CAAnimationGroup {
        let animation = CAKeyframeAnimation(keyPath:"position")
        animation.beginTime = 0.5
        animation.duration = 2.5
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.repeatCount = 0
        animation.calculationMode = .cubicPaced
        
        let curvedPath = CGMutablePath()
        let point0 = CGPoint(x: frame.origin.x + frame.size.width / 2, y: frame.origin.y + frame.size.height / 2)
        curvedPath.move(to: point0)
        if self.heartAnimationPoints.count < 40 {
            let offsetNum:UInt32 = 20
            var offsetX :CGFloat = 0
            let offsetY = (frame.origin.y-WH(20))/3.0 //(frame.origin.y - WH(300))/3.0
            if arc4random() % 2 == 0 {
                offsetX = CGFloat(arc4random()%offsetNum)+frame.size.width / 2
            }else {
                offsetX = -CGFloat(arc4random()%offsetNum)-frame.size.width / 2
            }
            let x1 = point0.x + offsetX
            let y1 = frame.origin.y - offsetY
            let x2 =  point0.x + offsetX/2.0
            let y2 =  y1 - offsetY
            let x3 =  point0.x + offsetX/3.0
            let y3 =  y2 - offsetY + CGFloat(arc4random()%UInt32(offsetY))
            let point1 = CGPoint(x: x1, y: y1)
            let point2 = CGPoint(x: x2, y: y2)
            let point3 = CGPoint(x: x3, y: y3)
            
            self.heartAnimationPoints.add(NSValue.init(cgPoint: point1))
            self.heartAnimationPoints.add(NSValue.init(cgPoint: point2))
            self.heartAnimationPoints.add(NSValue.init(cgPoint: point3))
        }
        
        let idx = arc4random() % UInt32(heartAnimationPoints.count/3);
        if let v1 = self.heartAnimationPoints[Int(3*idx)] as? NSValue ,
            let v2 = self.heartAnimationPoints[Int(3*idx+1)] as? NSValue,
            let v3 = self.heartAnimationPoints[Int(3*idx+2)] as? NSValue{
            let p1 = v1.cgPointValue
            let p2 = v2.cgPointValue
            let p3 = v3.cgPointValue
            curvedPath.addLines(between: [point0,p1,p2,p3])
        }
        animation.path = curvedPath;
        
        //CGPathRelease(curvedPath)
        
        //透明度变化
        let opacityAnim1 = CABasicAnimation(keyPath:"opacity")
        opacityAnim1.fromValue =  NSNumber(1.0)
        opacityAnim1.toValue = NSNumber(1.0)
        opacityAnim1.isRemovedOnCompletion = false
        opacityAnim1.beginTime = 0
        opacityAnim1.duration = 1.5
        
        //透明度变化
        let opacityAnim = CABasicAnimation(keyPath:"opacity")
        opacityAnim.fromValue =  NSNumber(1.0)
        opacityAnim.toValue = NSNumber(0)
        opacityAnim.isRemovedOnCompletion = false
        opacityAnim.beginTime = 1.5
        opacityAnim.duration = 3
        
        //比例
        let scaleAnim = CABasicAnimation(keyPath:"transform.scale")
        
        scaleAnim.fromValue = NSNumber(0)
        scaleAnim.toValue = NSNumber(1.0)
        scaleAnim.isRemovedOnCompletion = false
        scaleAnim.fillMode = .forwards
        scaleAnim.duration = 0.5
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [scaleAnim,opacityAnim1,opacityAnim,animation]
        animGroup.duration = 3
        
        return animGroup;
    }
}

//MARK:对界面赋值
extension LiveContentInfoView {
    func showHideContentView(){
        headView.showHidenHeadView()
        bottomLayerView.isHidden =  !bottomLayerView.isHidden
        
        if siteProductHiddenFlag == false{
            siteProductBgView.isHidden =  bottomLayerView.isHidden
        }
        
        if hasRedPacketView == true {
            accessAwardView.isHidden =  bottomLayerView.isHidden
        }
        if hasCouponsView == true {
            receiveCouponView.isHidden = bottomLayerView.isHidden
        }
        if hasRedTimeOut == true {
            timeLabel.isHidden =  bottomLayerView.isHidden
        }
        if currentIntrlProductHiddenFlag == false{
            introProductView.isHidden =  bottomLayerView.isHidden
        }
        
        messageListView.isHidden =  !messageListView.isHidden
        bottomView.isHidden =  !bottomView.isHidden
        animationrView.isHidden = !animationrView.isHidden
    }
    func configLiveRoomBaseInfo(_ baseInfo:LiveRoomBaseInfo?){
        self.headView.configView(baseInfo)
        //设置优惠券和抽奖图标
        self.congfigGitImageView(baseInfo?.prizePic,self.accessAwardView,"live_award_icon")
        self.congfigGitImageView(baseInfo?.couponPic,self.receiveCouponView,"live_coupon_icon")
    }
    func configLiveSiteProduct(_ siteProductList:[HomeCommonProductModel]?){
        firstSiteProductView.isHidden = true
        secondSiteProductView.isHidden = true
        siteProductHiddenFlag = true
        if let productList = siteProductList{
            if productList.count > 0{
                for index: Int in 0...(productList.count - 1) {
                    if index == 0{
                        firstSiteProductView.isHidden = false
                        let firstModel = productList[0]
                        firstSiteProductView.configView(firstModel)
                    }else if index == 1{
                        secondSiteProductView.isHidden = false
                        let secondModel = productList[1]
                        secondSiteProductView.configView(secondModel)
                    }
                }
            }
            if productList.count == 0{
                siteProductBgView.isHidden = true
                siteProductHiddenFlag = true
            }else if productList.count == 1{
                siteProductBgView.isHidden = false
                siteProductHiddenFlag = false
                siteProductBgView.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(94))
                }
            }else{
                siteProductBgView.isHidden = false
                siteProductHiddenFlag = false
                siteProductBgView.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(164))
                }
            }
        }else{
            siteProductHiddenFlag = true
            siteProductBgView.isHidden = true
        }
        
    }
    func configLiveCurrectProduct(_ productInfo:HomeCommonProductModel?){
        self.currectRcommendProduct = productInfo
        self.introProductView.configView(productInfo)
        if let productModel = productInfo{
            currentIntrlProductHiddenFlag = false
        }else{
            currentIntrlProductHiddenFlag = true
        }
        
    }
    func configPersonNumInfo(_ personNum:String?){
        self.headView.configPersonNumInfo(personNum)
    }
    func productBadgeNumText(_ badgeText:String?){
        self.bottomView.productBadgeNumText(badgeText)
    }
    //加载图片
    fileprivate func congfigGitImageView(_ str:String?,_ desImage:UIImageView, _ defalutStr:String){
        let defaultAwardImage = UIImage.init(named: defalutStr)
        desImage.image = defaultAwardImage
        if let imageStr = str,  let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            if strProductPicUrl.lowercased().hasSuffix("gif") {
                // gif
                DispatchQueue.global().async {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    let imageData = NSData(contentsOf: urlProductPic)
                    DispatchQueue.main.async {[weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        if let gifData = imageData, gifData.length > 0 {
                            //self.imgView.gifData = gifData
                            // 解决tableview滑动时Gif动画停止的问题
                            if let img = UIImage.sd_animatedGIF(with: gifData as Data) {
                                desImage.image = img
                            }
                            else {
                                desImage.image = defaultAwardImage
                            }
                        }
                        else {
                            desImage.sd_setImage(with: urlProductPic, placeholderImage: defaultAwardImage)
                        }
                    }
                }
            }
            else {
                // 非gif
                desImage.sd_setImage(with: urlProductPic, placeholderImage: defaultAwardImage)
            }
        }
    }
}
//MARK:倒计时相关or设置优惠券和抽奖图标是否显示
extension LiveContentInfoView {
    func resetAccessAwardView() {
        if self.accessAwardView.isHidden == true {
            self.accessAwardView.snp.updateConstraints { (make) in
                make.top.equalTo(siteProductBgView.snp.top).offset(-WH(23+60))
            }
        }else {
            self.accessAwardView.snp.updateConstraints { (make) in
                make.top.equalTo(siteProductBgView.snp.top)
            }
        }
    }
    func resetCouponPicAndPrizePic(_ typeIndex:Int, _ hide:Bool,_ rpModel:LiveRoomRedPacketInfo?)  {
        if typeIndex == 1 {
            //抽奖
            self.accessAwardView.isHidden = hide
            if hide == false {
                hasRedPacketView = true
            }else {
                hasRedPacketView = false
            }
            self.resetAccessAwardView()
            if let rModel = rpModel,hide == false,self.accessAwardView.isHidden == false {
                if rModel.isShowTime == 1 {
                    self.awardTimeCount = rModel.leftTime ?? 0
                    //显示倒计时
                    if self.awardTimeCount > 0 {
                        hasRedTimeOut = true
                        self.stopTimer()
                        self.resetTimeSatus(false)
                        self.showCountDownContent(self.awardTimeCount)
                        let date = NSDate.init(timeIntervalSinceNow: 1.0)
                        timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(beginAccessAwardTime), userInfo: nil, repeats: true)
                        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
                        return
                    }
                }
            }
            //隐藏倒计时
            hasRedTimeOut = false
            self.resetTimeSatus(true)
            self.stopTimer()
        }else if typeIndex == 2 {
            //优惠券
            self.receiveCouponView.isHidden = hide
            if hide == false {
                hasCouponsView = true
            }else {
                hasCouponsView = false
            }
            self.resetAccessAwardView()
        }
    }
    @objc func beginAccessAwardTime() {
        self.awardTimeCount = self.awardTimeCount-1
        if self.awardTimeCount <= 0 {
            //倒计时结束
            if let block = self.timeOutSendBlock {
                block()
            }
            self.stopTimer()
            self.resetTimeSatus(true)
        }else {
            self.showCountDownContent(self.awardTimeCount)
        }
        //根据判断views所属的控制器被销毁了，销毁定时器
        guard (self.getFirstViewController()) != nil else{
            self.stopTimer()
            return
        }
    }
    
    func stopTimer()  {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    func showCountDownContent(_ timeInterval: Int64) {
        let hour = timeInterval / 3600
        let min = timeInterval % 3600 / 60
        let sec = timeInterval % 60
        let hourStr = String.init(format: "%02d",hour)
        let minStr = String.init(format: "%02d",min)
        let secStr = String.init(format: "%02d",sec)
        if hour > 0 {
            self.timeLabel.text = "\(hourStr):\(minStr):\(secStr)"
        }else {
            self.timeLabel.text = "\(minStr):\(secStr)"
        }
        
    }
    func resetTimeSatus(_ hide:Bool) {
        if hide == true {
            self.timeLabel.isHidden = true
            self.timeLabel.snp.updateConstraints { (make) in
                make.height.equalTo(WH(0))
            }
        }else {
            self.timeLabel.isHidden = false
            self.timeLabel.snp.updateConstraints { (make) in
                make.height.equalTo(WH(16))
            }
        }
    }
}
