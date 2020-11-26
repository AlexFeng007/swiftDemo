//
//  FKYLiveViewController.swift
//  FKY
//
//  Created by 寒山 on 2020/8/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  直播的视图

import UIKit


class FKYLiveViewController: UIViewController {
    var livePlayerUrl:String? //直播的url
    var playerType:TX_Enum_PlayType?
    @objc var activityId: String?//活动ID
    @objc var source: String?//1：正常进来 2：口令进来
    fileprivate lazy var viewModel: LiveViewModel = {
        let viewModel = LiveViewModel()
        return viewModel
    }()
    
    //直播发生错误
    fileprivate lazy var errorView: LiveErrorView = {
        let view = LiveErrorView(frame: CGRect(x: 0, y: (SKPhotoBrowser.getScreenTopMargin() + WH(69) + WH(190)), width: SCREEN_WIDTH, height: WH(70)))
        view.refrshStateBlock = {[weak self]  in
            if let strongSelf = self {
                strongSelf.setUpData()
            }
        }
        return view
    }()
    
    //直播的背景
    fileprivate lazy var liveBgView: UIImageView = {
        let bgView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        bgView.image = UIImage(named: "live_bg")
        bgView.contentMode = .scaleAspectFill
        return bgView
    }()
    
    //直播的容器视图
    fileprivate lazy var livePlayerView: UIView = {
        let bgView = UIView()
        return bgView
    }()
    //直播操作视图
    fileprivate lazy var contentInfoView: LiveContentInfoView = {
        let contentView = LiveContentInfoView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        //点击坑位商品
        contentView.clickSiteProductBlock = {[weak self] index in
            if let strongSelf = self {
                if strongSelf.viewModel.siteProductList.count > index{
                    let siteProductModel = strongSelf.viewModel.siteProductList[index]
                    strongSelf.sitPorductClickBI_Record(siteProductModel,index)
                    FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                        let v = vc as! FKY_ProdutionDetail
                        v.productionId = siteProductModel.spuCode
                        v.vendorId = "\(siteProductModel.supplyId)"
                    }, isModal: false)
                }
                
            }
        }
        //点击分享按钮
        contentView.clickShareBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.shareAction()
            }
        }
        //点击购物篮按钮
        contentView.showLiveProductListBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.liveActionBI_Record(6)
                strongSelf.showLiveProductListAction()
                strongSelf.loadAllProductFirstPage()
            }
        }
        //点击消息输入区域
        contentView.inputMsgActionBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.inputMsgAction()
            }
        }
        //点击用户名
        contentView.checkAnchorBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.liveActionBI_Record(1)
                strongSelf.ckeckAnchorInfoAction()
            }
        }
        //点击退出
        contentView.clickExitBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.exitAction()
            }
        }
        //发送消息
        contentView.sendMessageBlock = {[weak self] (messageStr) in
            if let strongSelf = self {
                let getStr = messageStr.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
                if let redModel = strongSelf.viewModel.liveRedPacketModel,redModel.redPacketPwd == getStr {
                    //发送口令
                    strongSelf.liveRedPacketBI_Record(2)
                }else {
                    //弹幕
                    strongSelf.liveActionBI_Record(2)
                }
                strongSelf.liveIMManager.sendIMMessageInfo(messageStr)
            }
        }
        //点击爱心
        contentView.sendClickLikeBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.liveActionBI_Record(5)
                strongSelf.liveIMManager.sendIMCustomInfo(1)
            }
        }
        //点击领取优惠券
        contentView.receiveCouponBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.liveActionBI_Record(8)
                strongSelf.couponsListView.showCouponListView()
            }
        }
        //点击抽奖
        contentView.accessAwardBlock = {[weak self]  in
            if let strongSelf = self {
                strongSelf.liveActionBI_Record(7)
                strongSelf.showRpCommandView()
            }
        }
        //进入商详
        contentView.touchItem = {[weak self] model in
            if let strongSelf = self {
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = model.spuCode
                    v.vendorId = "\(model.supplyId)"
                    
                }, isModal: false)
            }
        }
        //倒计时未到点击提示
        contentView.sendToastBlock = {[weak self] tipStr in
            if let strongSelf = self {
                strongSelf.toast(tipStr)
            }
        }
        //倒计时结束
        contentView.timeOutSendBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.showRpCommandView()
            }
        }
        return contentView
    }()
    //商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        addView.addBtnType = 3
        //        if let desPoint = self.finishPoint {
        //            addView.finishPoint = desPoint
        //        }
        //更改购物车数量
        addView.addCarSuccess = { [weak self] (isSuccess,type,productNum,productModel) in
            if let strongSelf = self {
                if isSuccess == true {
                    if type == 1 {
                        strongSelf.changeBadgeNumber(false)
                    }else if type == 3 {
                        strongSelf.changeBadgeNumber(true)
                        strongSelf.toast("加入购物车成功")
                    }else if type == 2 {
                        strongSelf.toast("加入购物车成功")
                    }
                }
                //刷新点击的那个商品
                //strongSelf.tableView.reloadRows(at:[strongSelf.selectIndexPath], with: .none)
            }
        }
        //加车弹窗消失弹起全部商品
        //        addView.dismissCartView = {[weak self] in
        //            if let strongSelf = self {
        //                strongSelf.showLiveProductListAction()
        //            }
        //        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? HomeCommonProductModel {
                    
                }
            }
        }
        return addView
    }()
    //直播商品列表
    fileprivate lazy var productListView: LiveIntroProductListView = {
        let listView = LiveIntroProductListView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        listView.isHidden = true
        listView.loadMoreDataBlock = { [weak self] in
            if let strongSelf = self {
                strongSelf.getAllLiveProduct()
            }
        }
        //点击购物车按钮
        listView.clickCartBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.liveCartBI_Record()
                strongSelf.gotoCartAction()
            }
        }
        //进入商详
        listView.touchItem = {[weak self] (model,index) in
            if let strongSelf = self {
                strongSelf.allPorductClickBI_Record(model,index,1)
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = model.spuCode
                    v.vendorId = "\(model.supplyId)"
                    v.updateCarNum = { (carId ,num) in
                        if let count = num {
                            model.carOfCount = count.intValue
                        }
                        if let getId = carId {
                            model.carId = getId.intValue
                        }
                    }
                }, isModal: false)
            }
        }
        //点击加车
        listView.addCartItem = {[weak self] (model,index) in
            if let strongSelf = self {
                strongSelf.allPorductClickBI_Record(model,index,2)
                strongSelf.popAddCarView(model)
            }
        }
        //到货通知
        listView.addProductArriveNotice = {[weak self] (model,index) in
            if let strongSelf = self {
                strongSelf.allPorductClickBI_Record(model,index,3)
                FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                    let controller = vc as! ArrivalProductNoticeVC
                    controller.productId = model.spuCode
                    controller.venderId = "\(model.supplyId)"
                    controller.productUnit = model.packageUnit
                }, isModal: false)
            }
        }
        return listView
    }()
    // 分享视图
    fileprivate lazy var shareView: LiveShareView = {
        let view = LiveShareView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        // 微信分享
        view.WeChatShareClourse = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.shareForWechat()
        }
        // QQ分享
        view.QQShareClourse = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.shareForQQ()
        }
        //        // 复制链接
        //        view.CopyLinkShareClourse = { [weak self] in
        //            guard let strongSelf = self else {
        //                return
        //            }
        //            strongSelf.shareForCopy()
        //        }
        return view
    }()
    //直播优惠券列表
    fileprivate lazy var couponsListView: LiveCouponsListView = {
        let listView = LiveCouponsListView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        listView.isHidden = true
        listView.clickGetCouponsBlock = {[weak self] couponModel in
            if let strongSelf = self {
                strongSelf.getReciveCouponsInfo(couponModel)
                strongSelf.liveCouponListBI_Record(1)
            }
        }
        listView.clickTypeAction = {[weak self] typeIndex in
            if let strongSelf = self {
                if typeIndex == 1 {
                    //可用商品
                    strongSelf.liveCouponListBI_Record(2)
                }
            }
        }
        
        return listView
    }()
    //口令红包
    fileprivate lazy var rpView: LiveRedPacketView = {
        let view = LiveRedPacketView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        view.isHidden = true
        view.clickCopyActionBlock = {[weak self] copyStr in
            if let strongSelf = self {
                strongSelf.contentInfoView.autoCopyStrToInput(copyStr)
                strongSelf.liveRedPacketBI_Record(1)
            }
        }
        return view
    }()
    //领取红包结果页
    fileprivate lazy var rpResultView: LiveRedPacketResultView = {
        let view = LiveRedPacketResultView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        view.isHidden = true
        view.clickTypeActionBlock = { [weak self] typeIndex in
            if let strongSelf = self {
                if typeIndex == 1 {
                    strongSelf.liveRedPacketBI_Record(3)
                    strongSelf.gotoProudctListWithCanUseCoupons()
                }
            }
            
        }
        return view
    }()
    //未领取到红包结果页
    fileprivate lazy var tipView: LiveRedPacketTipView = {
        let view = LiveRedPacketTipView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        view.isHidden = true
        return view
    }()
    //播放器
    fileprivate lazy var livePlayer: TXLivePlayer = {
        let palyer = TXLivePlayer()
        return palyer
    }()
    //直播配置
    fileprivate lazy var livePlayerConfig: TXLivePlayConfig = {
        let config = TXLivePlayConfig()
        config.enableMessage = true
        return config
    }()
    //IM管理工具
    fileprivate lazy var liveIMManager: LiveIMManagerView = {
        let manager = LiveIMManagerView()
        //收到消息或者有新人加入直播群中
        manager.getActionType = {[weak self] (typeIndex,messageModelArr) in
            if let strongSelf = self {
                strongSelf.contentInfoView.configListMessageViewInfoData(typeIndex,messageModelArr)
                if typeIndex == 3 {
                    //发送消息成功
                    if let model = messageModelArr.first {
                        strongSelf.getRedPacketInfoWithSendMessage(model.messageStr)
                    }
                }
            }
        }
        //im错误相关提示
        manager.showToast = {[weak self] (tipStr) in
            if let strongSelf = self {
                strongSelf.toast(tipStr)
            }
        }
        //接收系统通知类型刷新对应的接口
        manager.refreshDemandType = {[weak self] (refreshModel) in
            if let strongSelf = self {
                strongSelf.refreshApiWithIMMessage(refreshModel)
            }
        }
        manager.getCustomActionType = {[weak self] (typeIndex) in
            if let strongSelf = self {
                if typeIndex == 1 {
                    //点赞
                    strongSelf.contentInfoView.showLikeHeartStartRect()
                }
            }
        }
        return manager
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.pauseLivePlay()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.resumeLivePlay()
    }
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>FKYLiveViewController deinit~!@")
        stopLivePlay()
        liveIMManager.removeGroupMessage()
        liveIMManager.quitIMGroupAndQuitLogin()
        
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        // 同步购物车商品数量
        self.getCartNumber()
        // 购物车badge
        self.changeBadgeNumber(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setUpView()
        setUpData()
        FKYNavigator.shared().topNavigationController.dragBackDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(FKYLiveViewController.loginOutIMNotification), name: NSNotification.Name.FKYRefreshIMLoginOut, object: nil)
        // Notification...<每次从前台到后台时，暂停直播>
        NotificationCenter.default.addObserver(self, selector: #selector(pauseLivePlay), name: UIApplication.didEnterBackgroundNotification, object: nil)
        // Notification...<每次从后台到前台时，开始直播>
        NotificationCenter.default.addObserver(self, selector: #selector(resumeLivePlay), name: UIApplication.willEnterForegroundNotification, object: nil)
        //停止直播
        NotificationCenter.default.addObserver(self, selector: #selector(stopLivePlay), name:NSNotification.Name.FKYLiveEndForCommand, object: nil)
        
        if let model = FKYLoginAPI.currentUser() ,let userIdStr = model.ycenterpriseId{
            self.liveIMManager.userId = userIdStr
        }
    }
    //初始化播放器
    func configLivePlayer(){
        livePlayer.config = livePlayerConfig
    }
    func setUpView(){
        self.view.addSubview(liveBgView)
        self.view.addSubview(contentInfoView)
        self.view.addSubview(errorView)
        self.view.addSubview(productListView)
        self.view.addSubview(couponsListView)
        self.view.addSubview(shareView)
        self.view.addSubview(rpView)
        self.view.addSubview(self.rpResultView)
        self.view.addSubview(self.tipView)
        errorView.isHidden = true
        shareView.isHidden = true
    }
    func setUpData(){
        showLoading()
        self.viewModel.source = self.source ?? "1"
        self.viewModel.activityId = self.activityId
        self.getLiveRoomBaseInfo()
    }
}
// MARK: -购物相关操作
extension FKYLiveViewController{
    //显示复制红包口令的页面
    func showRpCommandView(){
        rpView.configRpView(self.viewModel.liveRedPacketModel)
        rpView.show()
    }
    //显示红包领取结果
    func showRpResultView(_ packetModel:CommonCouponNewModel?){
        if let model = packetModel {
            rpResultView.configRpResultView(model)
            rpResultView.show()
        }
    }
    //显示未领取到红包提示
    func showRpTipView(_ tipStr:String){
        tipView.configTipView(tipStr)
        tipView.show()
    }
    //点击优惠券弹框上面的查看可用商品
    func gotoProudctListWithCanUseCoupons() {
        if let redModel = self.viewModel.liveRedPacketGetInfoModel {
            if let couponsModel =  redModel.couponDesc {
                FKYNavigator.shared().openScheme(FKY_ShopCouponProductController.self, setProperty: { (vc) in
                    let viewController = vc as! CouponProductListViewController
                    if let str = couponsModel.couponTempCode ,str.count > 0 {
                        viewController.couponTemplateId = str
                    }
                    if let str = couponsModel.templateCode ,str.count > 0 {
                        viewController.couponTemplateId = str
                    }
                    viewController.shopId = couponsModel.enterpriseId ?? ""
                    viewController.couponName = couponsModel.couponFullName ?? ""
                    viewController.couponCode = couponsModel.couponCode ?? ""
                    viewController.sourceType = "1"
                })
            }
        }
    }
    //点击购物篮按钮
    func showLiveProductListAction(){
        self.productListView.showProductListView()
    }
    //点击购物车按钮
    func gotoCartAction(){
        FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
            let v = vc as! FKY_ShopCart
            v.canBack = true
        }, isModal: false)
    }
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        //let sourceType = HomeString.SHOPITEM_ALL_ADD_SOURCE_TYPE
        self.addCarView.configAddCarViewController(productModel,nil)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
        //self.productListView.hideProductListView()
    }
    //点击消息输入区域
    func inputMsgAction(){
        
    }
    //查看主播信息
    func ckeckAnchorInfoAction(){
        FKYNavigator.shared().openScheme(FKY_LiveRoomInfoVIewController.self, setProperty: { [weak self] (vc) in
            if let strongSelf = self {
                let v = vc as! LiveRoomInfoVIewController
                v.roomId = "\(strongSelf.viewModel.liveBaseInfo?.roomId ?? 0)"
            }
            }, isModal: false)
    }
    // 修改购物车显示数量
    fileprivate func changeBadgeNumber(_ isdelay: Bool) {
        var deadline: DispatchTime
        if  isdelay {
            deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        }else {
            deadline = DispatchTime.now()
        }
        
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    let count = FKYCartModel.shareInstance().productCount
                    if count <= 0 {
                        strongSelf.productListView.configCartNumText("")
                    }
                    else if count > 99 {
                        strongSelf.productListView.configCartNumText("99+")
                    }else{
                        strongSelf.productListView.configCartNumText("\(count)")
                    }
                }
            }
        }
    }
    // 修改所有购物车的商品显示数量
    fileprivate func changeAllProductNumber(_ isdelay: Bool) {
        var deadline: DispatchTime
        if  isdelay {
            deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        }else {
            deadline = DispatchTime.now()
        }
        
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    let count = strongSelf.viewModel.totalProductNum
                    if count <= 0 {
                        strongSelf.contentInfoView.productBadgeNumText("")
                    }
                    else if count > 99 {
                        strongSelf.contentInfoView.productBadgeNumText("99+")
                    }else{
                        strongSelf.contentInfoView.productBadgeNumText("\(count)")
                    }
                }
            }
        }
    }
    //刷新商品购物车数量
    fileprivate func refreshAllProductTableView(){
        for homeModel in self.viewModel.allLiveProductList {
            if FKYCartModel.shareInstance().productArr.count > 0 {
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == homeModel.spuCode && cartOfInfoModel.supplyId.intValue == homeModel.supplyId {
                            homeModel.carOfCount = cartOfInfoModel.buyNum.intValue
                            homeModel.carId = cartOfInfoModel.cartId.intValue
                            break
                        } else {
                            homeModel.carOfCount = 0
                            homeModel.carId = 0
                        }
                    }
                }
            }else {
                homeModel.carOfCount = 0
                homeModel.carId = 0
            }
        }
    }
}

extension FKYLiveViewController : FKYNavigationControllerDragBackDelegate {
    func dragBackShouldStart(in navigationController: FKYNavigationController!) -> Bool {
        return false
    }
}
// MARK: -直播操作
extension FKYLiveViewController{
    //进入直播结束页面
    func enterLiveEndView(){
        self.stopLivePlay()
        self.contentInfoView.removeMessageListView()
        let liveEndVC =  LiveEndViewController()
        liveEndVC.activityId = self.activityId
        FKYNavigator.shared()?.topNavigationController.pushViewController(liveEndVC, animated: true, snapshotFirst: false)
        FKYNavigator.shared()?.removeViewController(fromNvc: self)
    }
    //退出直播
    func exitAction(){
        FKYNavigator.shared().pop()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.8, execute:
            {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.stopLivePlay()
                strongSelf.contentInfoView.removeMessageListView()
        })
    }
    //开始播放
    @objc func startLivePlay()->(Bool){
        if let playerUrl = livePlayerUrl,playerUrl.isEmpty == false{
            if self.checkPlayerType(livePlayerUrl ?? "") == false{
                return false
            }
            self.liveActionBI_Record(3)
            let playerRect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            self.view.addSubview(livePlayerView)
            livePlayerView.frame = playerRect
            livePlayer.setupVideoWidget(.zero, contain: livePlayerView, insert: 0)
            self.view.sendSubviewToBack(livePlayerView)
            livePlayer.delegate = self
            let ret = livePlayer.startPlay(livePlayerUrl ?? "", type: playerType!)
            if (ret != 0) {
                self.toast("播放器启动失败")
                return false
            }
            UIApplication.shared.isIdleTimerDisabled = true
            self.showLiveLog(false)
            self.swithLiveDir(Enum_Type_HomeOrientation.HOME_ORIENTATION_DOWN)
            self.switchRenderMode(Enum_Type_RenderMode.RENDER_MODE_FILL_SCREEN)
            return true
        }else{
            return false
        }
    }
    //停止播放
    @objc func stopLivePlay(){
        self.liveActionBI_Record(4)
        self.liveBgView.isHidden = false
        self.livePlayerUrl = nil
        UIApplication.shared.isIdleTimerDisabled = false
        livePlayer.delegate = nil
        livePlayer.removeVideoWidget()
        livePlayer.stopPlay()
    }
    //暂停播放
    @objc func pauseLivePlay(){
        UIApplication.shared.isIdleTimerDisabled = false
        livePlayer.pause()
    }
    //继续播放
    @objc func resumeLivePlay(){
        if let playerUrl = livePlayerUrl,playerUrl.isEmpty == false{
            if self.checkPlayerType(livePlayerUrl ?? "") == false{
                return
            }
            UIApplication.shared.isIdleTimerDisabled = true
            livePlayer.resume()
        }else{
            if self.viewModel.liveBaseInfo != nil{
                self.getLiveRoomBaseInfo()
            }
        }
        
    }
    //确定播放器类型
    func checkPlayerType(_ playUrl:String)->(Bool){
        if playUrl.hasPrefix("rtmp:") {
            playerType = TX_Enum_PlayType.PLAY_TYPE_LIVE_RTMP //&& (playUrl.range(of: ".flv"))).location != NSNotFound
        } else if ((playUrl.hasPrefix("https:") || playUrl.hasPrefix("http:")) && ((playUrl.range(of: ".flv")) != nil)) {
            playerType = TX_Enum_PlayType.PLAY_TYPE_LIVE_FLV
        } else if ((playUrl.hasPrefix("https:") || playUrl.hasPrefix("http:")) && ((playUrl.range(of: ".m3u8")) != nil)){
            playerType = TX_Enum_PlayType.PLAY_TYPE_VOD_HLS
        } else{
            self.toast("播放地址不合法，直播目前仅支持rtmp,flv播放方式!")
            return false
        }
        return true
    }
    //显示日志
    func showLiveLog(_ showLog:Bool) {
        livePlayer.showVideoDebugLog(showLog)
        livePlayer.setLogViewMargin(UIEdgeInsets(top: WH(120), left: WH(10), bottom:WH(60), right: WH(10)))
    }
    
    // 设置缓冲策略
    func onAdjustFast(){
        // 极速
        self.setCacheStrategy(ENUM_TYPE_CACHE_STRATEGY.CACHE_STRATEGY_FAST)
    }
    
    func onAdjustSmooth() {
        // 流畅
        self.setCacheStrategy(ENUM_TYPE_CACHE_STRATEGY.CACHE_STRATEGY_SMOOTH)
    }
    //
    func onAdjustAuto(){
        // 自动
        self.setCacheStrategy(ENUM_TYPE_CACHE_STRATEGY.CACHE_STRATEGY_AUTO)
    }
    func setCacheStrategy(_ cacheStrategy:ENUM_TYPE_CACHE_STRATEGY){
        switch (cacheStrategy) {
        case ENUM_TYPE_CACHE_STRATEGY.CACHE_STRATEGY_FAST:
            livePlayerConfig.bAutoAdjustCacheTime = true
            livePlayerConfig.minAutoAdjustCacheTime = Float(CACHE_TIME_FAST)
            livePlayerConfig.maxAutoAdjustCacheTime = Float(CACHE_TIME_FAST)
            livePlayer.config = livePlayerConfig
            break;
            
        case ENUM_TYPE_CACHE_STRATEGY.CACHE_STRATEGY_SMOOTH:
            livePlayerConfig.bAutoAdjustCacheTime = false
            livePlayerConfig.minAutoAdjustCacheTime = Float(CACHE_TIME_SMOOTH)
            livePlayerConfig.maxAutoAdjustCacheTime = Float(CACHE_TIME_SMOOTH)
            livePlayer.config = livePlayerConfig
            break;
            
        case ENUM_TYPE_CACHE_STRATEGY.CACHE_STRATEGY_AUTO:
            livePlayerConfig.bAutoAdjustCacheTime = true
            livePlayerConfig.minAutoAdjustCacheTime = Float(CACHE_TIME_FAST)
            livePlayerConfig.maxAutoAdjustCacheTime = Float(CACHE_TIME_SMOOTH)
            livePlayer.config = livePlayerConfig
            break;
        }
    }
    //切换横竖屏
    func swithLiveDir(_ dirType:Enum_Type_HomeOrientation){
        switch dirType {
        case Enum_Type_HomeOrientation.HOME_ORIENTATION_RIGHT://HOME 键在右边，横屏模式
            livePlayer.setRenderRotation(TX_Enum_Type_HomeOrientation.HOME_ORIENTATION_RIGHT)
            break
        case Enum_Type_HomeOrientation.HOME_ORIENTATION_DOWN://HOME 键在下面，手机直播中最常见的竖屏直播模式
            livePlayer.setRenderRotation(TX_Enum_Type_HomeOrientation.HOME_ORIENTATION_DOWN)
            break
        case Enum_Type_HomeOrientation.HOME_ORIENTATION_LEFT://HOME 键在左边，横屏模式
            livePlayer.setRenderRotation(TX_Enum_Type_HomeOrientation.HOME_ORIENTATION_LEFT)
            break
        case Enum_Type_HomeOrientation.HOME_ORIENTATION_UP ://HOME 键在上边，竖屏直播（适合小米 MIX2）
            livePlayer.setRenderRotation(TX_Enum_Type_HomeOrientation.HOME_ORIENTATION_UP)
            break
        }
    }
    // 渲染模式：(a) 图像铺满屏幕，不留黑边  (b) 图像适应屏幕，保持画面完整
    func switchRenderMode(_ renderMode:Enum_Type_RenderMode) {
        switch renderMode {
        case Enum_Type_RenderMode.RENDER_MODE_FILL_SCREEN ://图像铺满屏幕，不留黑边，如果图像宽高比不同于屏幕宽高比，部分画面内容会被裁剪掉。
            livePlayer.setRenderMode(TX_Enum_Type_RenderMode.RENDER_MODE_FILL_SCREEN)
            break
        case Enum_Type_RenderMode.RENDER_MODE_FILL_EDGE://图像适应屏幕，保持画面完整，但如果图像宽高比不同于屏幕宽高比，会有黑边的存在。
            livePlayer.setRenderMode(TX_Enum_Type_RenderMode.RENDER_MODE_FILL_EDGE)
            break
        }
    }
    // 开启硬件加速
    func startHWAcceleration(_ startHW:Bool){
        self.stopLivePlay()
        livePlayer.enableHWAcceleration = startHW
        if startHW {
            //self.toast("切换为硬解码. 重启播放流程")
        }else {
            //self.toast("切换为软解码. 重启播放流程")
        }
        let _ = self.startLivePlay()
    }
    // 低延时播放
}
// MARK:直播sdk事件接受和网络状态判断
extension FKYLiveViewController : TXLivePlayListener {
    //直播事件通知
    func onPlayEvent(_ EvtID: Int32, withParam param: [AnyHashable : Any]!) {
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                switch EvtID {
                case PLAY_EVT_TYPE.PLAY_EVT_CONNECT_SUCC.rawValue://已经连接服务器
                    strongSelf.dismissLoading()
                    //                    strongSelf.liveBgView.isHidden = true
                    //                    strongSelf.errorView.isHidden = true
                    break
                case PLAY_EVT_TYPE.PLAY_EVT_RTMP_STREAM_BEGIN.rawValue:    //已经连接服务器，开始拉流（仅播放 RTMP 地址时会抛送）
                    break
                case PLAY_EVT_TYPE.PLAY_EVT_RCV_FIRST_I_FRAME.rawValue:   //收到首帧数据，越快收到此消息说明链路质量越好
                    strongSelf.dismissLoading()
                    strongSelf.liveBgView.isHidden = true
                    strongSelf.errorView.isHidden = true
                    break
                case PLAY_EVT_TYPE.PLAY_EVT_PLAY_BEGIN.rawValue:   //视频播放开始，如果您自己做 loading，会需要它
                    strongSelf.dismissLoading()
                    break
                case PLAY_EVT_TYPE.PLAY_EVT_PLAY_PROGRESS.rawValue:  //播放进度，如果您在直播中收到此消息，可以忽略
                    break
                case PLAY_EVT_TYPE.PLAY_EVT_PLAY_LOADING.rawValue:    //视频播放进入缓冲状态，缓冲结束之后会有 PLAY_BEGIN 事件
                    break
                case PLAY_EVT_TYPE.PLAY_EVT_START_VIDEO_DECODER.rawValue:    //视频解码器开始启动（2.0 版本以后新增）
                    break
                case PLAY_EVT_TYPE.PLAY_EVT_CHANGE_RESOLUTION.rawValue:    //视频分辨率发生变化（分辨率在 EVT_PARAM 参数中）
                    break
                case PLAY_EVT_TYPE.PLAY_EVT_GET_PLAYINFO_SUCC.rawValue: // 如果您在直播中收到此消息，可以忽略
                    break
                case PLAY_EVT_TYPE.PLAY_EVT_CHANGE_ROTATION.rawValue:    //如果您在直播中收到此消息，可以忽略
                    break
                case PLAY_EVT_TYPE.PLAY_EVT_GET_MESSAGE.rawValue:   //获取夹在视频流中的自定义 SEI 消息，消息的发送需使用 TXLivePusher
                    break
                case PLAY_EVT_TYPE.PLAY_EVT_VOD_PLAY_PREPARED.rawValue:   //如果您在直播中收到此消息，可以忽略
                    break
                case PLAY_EVT_TYPE.PLAY_EVT_VOD_LOADING_END.rawValue:   //如果您在直播中收到此消息，可以忽略
                    break
                case PLAY_EVT_TYPE.PLAY_EVT_STREAM_SWITCH_SUCC.rawValue:   // 直播流切换完成，请参考 清晰度无缝切换
                    break
                //结束事件
                case PLAY_EVT_TYPE.PLAY_EVT_PLAY_END.rawValue:    //视频播放结束  播放结束，HTTP-FLV 的直播流是不抛这个事件的
                    strongSelf.toast("直播结束")
                    strongSelf.liveBgView.isHidden = false
                    strongSelf.enterLiveEndView()
                    break
                case PLAY_EVT_TYPE.PLAY_ERR_NET_DISCONNECT.rawValue:    //网络断连，且经多次重连亦不能恢复，更多重试请自行重启播放
                    //strongSelf.toast("网络断连，且经多次重连亦不能恢复，请重进直播间")
                    strongSelf.liveBgView.isHidden = false
                    strongSelf.errorView.isHidden = false
                    break
                //警告事件
                case PLAY_EVT_TYPE.PLAY_WARNING_VIDEO_DECODE_FAIL.rawValue:    //当前视频帧解码失败
                    break
                case PLAY_EVT_TYPE.PLAY_WARNING_AUDIO_DECODE_FAIL.rawValue:    //当前音频帧解码失败
                    break
                case PLAY_EVT_TYPE.PLAY_WARNING_RECONNECT.rawValue:   //网络断连，已启动自动重连（重连超过三次就直接抛送 PLAY_ERR_NET_DISCONNECT）
                    //strongSelf.toast("网络断连，已启动自动重连")
                    strongSelf.liveBgView.isHidden = false
                    strongSelf.errorView.isHidden = false
                    break
                case PLAY_EVT_TYPE.PLAY_WARNING_RECV_DATA_LAG.rawValue:   //网络来包不稳：可能是下行带宽不足，或由于主播端出流不均匀
                    break
                case PLAY_EVT_TYPE.PLAY_WARNING_VIDEO_PLAY_LAG.rawValue:   //当前视频播放出现卡顿
                    break
                case PLAY_EVT_TYPE.PLAY_WARNING_HW_ACCELERATION_FAIL.rawValue:    //硬解启动失败，采用软解
                    break
                case PLAY_EVT_TYPE.PLAY_WARNING_VIDEO_DISCONTINUITY.rawValue:    //当前视频帧不连续，可能丢帧
                    break
                case PLAY_EVT_TYPE.PLAY_WARNING_DNS_FAIL.rawValue:   //RTMP-DNS 解析失败（仅播放 RTMP 地址时会抛送）
                    break
                case PLAY_EVT_TYPE.PLAY_WARNING_SEVER_CONN_FAIL.rawValue:    //RTMP 服务器连接失败（仅播放 RTMP 地址时会抛送）
                    break
                case PLAY_EVT_TYPE.PLAY_WARNING_SHAKE_FAIL.rawValue:    //RTMP 服务器握手失败（仅播放 RTMP 地址时会抛送）
                    break
                default:
                    break
                }
            }
        }
    }
    // 网络状态通知
    func onNetStatus(_ param: [AnyHashable : Any]!) {
        
    }
}
// MARK: - Share
extension FKYLiveViewController {
    //点击分享按钮
    fileprivate func shareAction() {
        // 分享签名为空，需实时请求
        //        guard let sign = orderShareSign, sign.isEmpty == false else {
        //            requestForOrderShareSign()
        //            return
        //        }
        
        // 显示分享视图...<已获取签名>
        showShareView()
    }
    
    // 显示分享视图
    fileprivate func showShareView() {
        shareView.isHidden = false
        shareView.liveShareWord = self.viewModel.liveBaseInfo?.shareWord
        self.shareForCopy()
        if let closure = shareView.appearClourse {
            closure()
        }
        else {
            shareView.showShareView()
        }
    }
    
    // 微信好友分享
    fileprivate func shareForWechat() {
        self.liveShareActionBI_Record(1)
        if let shareWord  = self.viewModel.liveBaseInfo?.shareWord,shareWord.isEmpty == false{
            FKYShareManage.shareToWX(withMessage:shareWord)
        }else{
            self.toast("口令无效")
        }
    }
    
    // QQ好友分享
    fileprivate func shareForQQ() {
        self.liveShareActionBI_Record(2)
        if let shareWord  = self.viewModel.liveBaseInfo?.shareWord,shareWord.isEmpty == false{
            FKYShareManage.shareToQQ(withMessage: shareWord)
        }else{
            self.toast("口令无效")
        }
        
    }
    
    // 复制链接
    fileprivate func shareForCopy() {
        // 复制口令
        UIPasteboard.general.string = self.viewModel.liveBaseInfo?.shareWord ?? ""
        // toast("直播口令复制成功！")
    }
    
}
//MARK:IM登录相关
extension FKYLiveViewController {
    @objc fileprivate func loginOutIMNotification(){
        let model = LiveMessageMode()
        model.groupId = self.liveIMManager.groupId
        model.messageStr = "您已在其他设备登录"
        model.nickName = "系统消息"
        self.contentInfoView.configListMessageViewInfoData(1,[model])
    }
    fileprivate func loginMyTXIM(){
        if let baseModel = self.viewModel.liveBaseInfo {
            self.liveIMManager.nickName = baseModel.enterpriseName ?? "游客"
            self.liveIMManager.groupId = baseModel.groupId ?? ""
            self.liveIMManager.userSig = baseModel.userSign ?? ""
            self.liveIMManager.loginTXIM()
        }
    }
}
//MARK:网络请求
extension FKYLiveViewController{
    //MARK: 同步购物车商品数量
    fileprivate func getCartNumber() {
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ [weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.refreshAllProductTableView()
        }) { [weak self] (reason) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.toast(reason)
        }
    }
    //MARK:获取直播当前正在讲解的商品
    func getCurrectLiveProduct(){
        viewModel.getLiveCurrectProductInfo(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            if success{
                strongSelf.contentInfoView.configLiveCurrectProduct(strongSelf.viewModel.currectLiveProduct)
            } else {
                // 失败
                //strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    //MARK:直播所有商品列表
    func loadAllProductFirstPage(){
        viewModel.hasNextPage = true
        viewModel.currentPage = 1
        getAllLiveProduct()
    }
    func getAllLiveProduct(){
        viewModel.getAllLiveProductInfo(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            if success{
                strongSelf.productListView.configView(strongSelf.viewModel.allLiveProductList,strongSelf.viewModel.hasNextPage,strongSelf.viewModel.totalProductNum)
                strongSelf.changeAllProductNumber(true)
                strongSelf.refreshAllProductTableView()
            } else {
                // 失败
                ///strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    //MARK:直播推荐品
    func getRecommmendLiveSiteProduct(){
        viewModel.getLiveSiteProductList(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            if success{
                strongSelf.contentInfoView.configLiveSiteProduct(strongSelf.viewModel.siteProductList)
            } else {
                // 失败
                //strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    //MARK:直播间活动详情
    func getLiveRoomBaseInfo(){
        viewModel.getLiveRoomBaseInfo(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            if success{
                strongSelf.contentInfoView.configLiveRoomBaseInfo(strongSelf.viewModel.liveBaseInfo)
                strongSelf.livePlayerUrl = strongSelf.viewModel.liveBaseInfo?.pullStreamUrl
                strongSelf.productListView.configActivityText(strongSelf.viewModel.liveBaseInfo?.activityName)
                strongSelf.configLivePlayer()
                strongSelf.loginMyTXIM()
                strongSelf.getCurrectLiveProduct()
                strongSelf.getAllLiveProduct()
                strongSelf.getRecommmendLiveSiteProduct()
                strongSelf.getLiveRedPacketInfo()
                strongSelf.getLiveCouponsInfo()
                strongSelf.getLivePersonInfo()
                let _ = strongSelf.startLivePlay()
            } else {
                strongSelf.toast(msg ?? "直播详情获取失败")
                strongSelf.exitAction()
                return
            }
        }
    }
    //MARK:获取优惠券列表<接口>
    func getLiveCouponsInfo() {
        viewModel.getLiveCouponsListInfo { [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            if success{
                strongSelf.couponsListView.configView(strongSelf.viewModel.allCouponsList, false)
                if strongSelf.viewModel.allCouponsList.count > 0 {
                    strongSelf.contentInfoView.resetCouponPicAndPrizePic(2, false, nil)
                }else {
                    strongSelf.contentInfoView.resetCouponPicAndPrizePic(2, true, nil)
                }
            }
        }
    }
    //MARK:直播间人数
    func getLivePersonInfo() {
        viewModel.getLiveRoomPersonNum { [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            if success{
                strongSelf.contentInfoView.configPersonNumInfo("正在观看：\(strongSelf.viewModel.liveOnlineNum)人")
            }
        }
    }
    //MARK:获取口令红包<接口>
    func getLiveRedPacketInfo() {
        viewModel.getLiveRedPacketActivityInfo { [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            if success{
                strongSelf.contentInfoView.resetCouponPicAndPrizePic(1, false, strongSelf.viewModel.liveRedPacketModel)
            } else {
                strongSelf.contentInfoView.resetCouponPicAndPrizePic(1, true,nil)
            }
        }
    }
    //MARK:领取优惠券
    func getReciveCouponsInfo(_ cpModel:CommonCouponNewModel) {
        viewModel.getLiveRecieveCouponInfo(cpModel.templateCode) { [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            if success{
                if let desModel = strongSelf.viewModel.getCouponModel {
                    cpModel.received = true
                    cpModel.couponTempCode = cpModel.templateCode
                    cpModel.couponCode = desModel.couponCode
                    cpModel.begindate = desModel.begindate
                    cpModel.endDate = desModel.endDate
                    strongSelf.couponsListView.reloadCouponsView()
                    strongSelf.toast(msg ?? "领取成功")
                }
            } else {
                strongSelf.toast(msg ?? "")
            }
        }
    }
    //MARK:获取红包《复制口令发送后》
    func getRedPacketInfoWithSendMessage(_ message:String) {
        if message.count > 0 {
            // 去左右空格
            if self.contentInfoView.awardTimeCount > 0{
                //倒计时的时候不准发送活动红包信息
                return
            }
            let getStr = message.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
            if let redModel = self.viewModel.liveRedPacketModel,redModel.redPacketPwd == getStr {
                //口令相同请求红包接口
                viewModel.getRedPacketGetInfoDetail { [weak self] (success, msg) in
                    guard let strongSelf = self else {
                        return
                    }
                    if success{
                        if let redModel = strongSelf.viewModel.liveRedPacketGetInfoModel {
                            if redModel.drawResult == true {
                                //中奖
                                strongSelf.showRpResultView(redModel.couponDesc)
                            }else {
                                //未中奖
                                strongSelf.showRpTipView(redModel.desStr ?? "红包已经被人抢完啦\n等待下一场红包")
                            }
                        }else {
                            strongSelf.toast(msg ?? "获取失败")
                        }
                    } else {
                        strongSelf.toast(msg ?? "")
                    }
                }
            }
        }
    }
}
//MARK:通过im消息刷新接口
extension FKYLiveViewController{
    func refreshApiWithIMMessage(_ refreshModel:LiveRoomIMRefreshInfo) {
        if let baseModel = self.viewModel.liveBaseInfo {
            if refreshModel.groupId.count > 0 && refreshModel.groupId == (baseModel.groupId ?? ""){
                //只有群ID和接受群ID相同才可以接收
                if refreshModel.type == 1 {
                    //刷新观看人数
                    self.getLivePersonInfo()
                }else if refreshModel.type == 2 {
                    // 推送观看人数
                    self.contentInfoView.configPersonNumInfo("正在观看：\(refreshModel.peopleValue ?? 0)人")
                }else if refreshModel.type == 3 {
                    //刷新左侧推荐品
                    self.getRecommmendLiveSiteProduct()
                }else if refreshModel.type == 4 {
                    //刷新右侧抽奖信息
                    self.getLiveRedPacketInfo()
                }else if refreshModel.type == 5 {
                    //推送关闭右侧抽奖入口
                    self.viewModel.liveRedPacketModel = nil
                    self.contentInfoView.resetCouponPicAndPrizePic(1, true,nil)
                }else if refreshModel.type == 6 {
                    //刷新右侧优惠券
                    self.getLiveCouponsInfo()
                }else if refreshModel.type == 7 {
                    //刷新主推品
                    self.getCurrectLiveProduct()
                }else if refreshModel.type == 8 {
                    //关闭直播间
                    self.enterLiveEndView()
                }
            }
        }
    }
}
//MARK:埋点
extension FKYLiveViewController{
    //推荐商品
    func sitPorductClickBI_Record(_ product: HomeCommonProductModel, _ index:Int){
        let itemContent = "\(product.supplyId)|\(product.spuCode)"
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : "特价" as AnyObject,"pageValue":(self.activityId ?? "") as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S9604", sectionPosition:"\(index + 1)", sectionName: "推荐商品", itemId: "I9998", itemPosition: nil, itemName: "商品-商详", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    //主推品
    func currectLivePorductClickBI_Record(_ product: HomeCommonProductModel){
        let itemContent = "\(product.supplyId)|\(product.spuCode)"
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : "特价" as AnyObject,"pageValue":(self.activityId ?? "") as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S9605", sectionPosition:nil, sectionName: "主推商品", itemId: "I9607", itemPosition: nil, itemName: "点击", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    //全部商品
    func allPorductClickBI_Record(_ product: HomeCommonProductModel, _ index:Int,_ type:Int){
        var itemName = ""
        var itemId = ""
        if type == 1{
            itemName = "商品-商详"
            itemId = "I9998"
        }else if type == 2{
            itemName = "加车"
            itemId = "I9999"
        }else{
            itemName = "缺货通知"
            itemId = "i9609"
        }
        let itemContent = "\(product.supplyId)|\(product.spuCode)"
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : "特价" as AnyObject,"pageValue":(self.activityId ?? "") as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S9606", sectionPosition:"\(index + 1)", sectionName: "更多商品", itemId: itemId, itemPosition: nil, itemName: itemName, itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    //主播头像  发送弹幕 开始时间（开始拉流） 结束时间（结束拉流） 点赞按钮点击
    func liveActionBI_Record(_ type:Int){
        var itemName = ""
        var itemId = ""
        if type == 1{
            itemName = "主播头像"
            itemId = "I9601"
        }else if type == 2{
            itemName = "发送弹幕"
            itemId = "I9611"
        }else if type == 3{
            itemName = "开始时间（开始拉流）"
            itemId = "I9613"
        }else if type == 4{
            itemName = "结束时间（结束拉流）"
            itemId = "I9614"
        }else if type == 5{
            itemName = "点赞按钮点击"
            itemId = "I9615"
        }else if type == 6{
            itemName = "更多商品点击"
            itemId = "I9616"
        }else if type == 7{
            itemName = "抽奖点击"
            itemId = "I9617"
        }else if type == 8{
            itemName = "优惠券点击"
            itemId = "I9618"
        }
        let extendParams = ["pageValue":(self.activityId ?? "") as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName: nil, itemId: itemId, itemPosition: nil, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams:extendParams, viewController: self)
        
    }
    //分享
    func liveShareActionBI_Record(_ type:Int){
        var itemName = ""
        var itemId = ""
        var itemPosition = ""
        if type == 1{
            itemName = "分享"
            itemId = "I9612"
            itemPosition = "1"
        }else if type == 2{
            itemName = "分享"
            itemId = "I9612"
            itemPosition = "2"
        }
        let extendParams = ["pageValue":(self.activityId ?? "") as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName: nil, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    //点击购物车
    func liveCartBI_Record(){
        let extendParams = ["pageValue":(self.activityId ?? "") as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S9606", sectionPosition:nil, sectionName: "更多商品", itemId: "I9610", itemPosition: nil, itemName: "点击购物车", itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    //优惠券列表
    func liveCouponListBI_Record(_ typeIndex:Int) {
        let sectionId = "S9602"
        let sectionName = "领券"
        var itemId:String?
        var itemName:String?
        if typeIndex == 1 {
            //领取
            itemId = "I9602"
            itemName = "领取"
        }else if typeIndex == 2 {
            //查看可用商品
            itemId = "I9603"
            itemName = "查看可用商品"
        }
        let extendParams = ["pageValue":(self.activityId ?? "") as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: sectionId, sectionPosition:nil, sectionName: sectionName, itemId: itemId, itemPosition: nil, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    //口令红包
    func liveRedPacketBI_Record(_ typeIndex:Int) {
        let sectionId = "S9603"
        let sectionName = "口令红包"
        var itemId:String?
        var itemName:String?
        if typeIndex == 1 {
            //复制文字
            itemId = "I9604"
            itemName = "复制文字"
        }else if typeIndex == 2 {
            //发送
            itemId = "I9605"
            itemName = "发送"
        }else if typeIndex == 3 {
            //可用商品
            itemId = "I9606"
            itemName = "可用商品"
        }
        let extendParams = ["pageValue":(self.activityId ?? "") as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: sectionId, sectionPosition:nil, sectionName: sectionName, itemId: itemId, itemPosition: nil, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
}
