//
//  FKYVodPlayerViewController.swift
//  FKY
//
//  Created by 寒山 on 2020/8/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYVodPlayerViewController: UIViewController {
    var livePlayerUrl:String? //直播的url
    var currectVideoTime:Float = 0.0 //当前视频播放时间
    var totalVideoTime:Float = 0.0 //总的视频播放时间
    @objc var activityId: String?//活动ID
    @objc var source: String?//1：正常进来 2：口令进来
    @objc var liveInfoModel:LiveInfoListModel?
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
    //录播的容器视图
    fileprivate lazy var vodPlayerView: UIView = {
        let bgView = UIView()
        return bgView
    }()
    //播放器
    fileprivate lazy var vodPlayer: TXVodPlayer = {
        let palyer = TXVodPlayer()
        return palyer
    }()
    //直播操作视图
    fileprivate lazy var contentInfoView: VodPlayerContentInfoView = {
        let contentView = VodPlayerContentInfoView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        //点击购物篮按钮
        contentView.showLiveProductListBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.liveActionBI_Record(6)
                strongSelf.showLiveProductListAction()
                strongSelf.loadAllProductFirstPage()
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
                strongSelf.exitBI_Record()
                strongSelf.exitAction()
            }
        }
        //点击播放按钮
        contentView.playVideoBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.playVideo()
            }
        }
        //点击暂停按钮
        contentView.pauseVideoBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.pasueVideo()
            }
        }
        //拖动进度条修改播放时间
        contentView.setVideoTimeBlock = {[weak self] value in
            if let strongSelf = self {
                strongSelf.vodPlayer.seek(value*strongSelf.totalVideoTime)
                if !strongSelf.vodPlayer.isPlaying(){
                    if strongSelf.getCcurrentPlaybackTime() < strongSelf.getTotalPlayerTime(){
                        strongSelf.vodPlayer.resume()
                    }
                }
                // strongSelf.contentInfoView.setVideoCurrectTime(value*strongSelf.totalVideoTime)
            }
        }
        //点击分享按钮
        contentView.clickShareBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.shareAction()
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
                        strongSelf.changeAllProductNumber(false)
                    }else if type == 3 {
                        strongSelf.changeAllProductNumber(true)
                        strongSelf.toast("加入购物车成功")
                    }else if type == 2 {
                        strongSelf.toast("加入购物车成功")
                    }
                }
                //刷新点击的那个商品
                //strongSelf.tableView.reloadRows(at:[strongSelf.selectIndexPath], with: .none)
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? HomeCommonProductModel {
                    
                }
            }
        }
        //加车弹窗消失弹起全部商品
        //        addView.dismissCartView = {[weak self] in
        //            if let strongSelf = self {
        //                strongSelf.showLiveProductListAction()
        //            }
        //        }
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
        return view
    }()
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>FKYVodPlayerViewController deinit~!@")
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.pasueVideo()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.playVideo()
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
        // Notification...<每次从前台到后台时，停止播放>
        NotificationCenter.default.addObserver(self, selector: #selector(pasueVideo), name: UIApplication.didEnterBackgroundNotification, object: nil)
        // Notification...<每次从后台到前台时，开始播放>
        NotificationCenter.default.addObserver(self, selector: #selector(playVideo), name: UIApplication.willEnterForegroundNotification, object: nil)
        //停止直播
        NotificationCenter.default.addObserver(self, selector: #selector(stopLivePlay), name:NSNotification.Name.FKYLiveEndForCommand, object: nil)
        FKYNavigator.shared().topNavigationController.dragBackDelegate = self
        setUpView()
        setUpData()
        // let _ = self.startLivePlay()
    }
    func setUpView(){
        self.view.addSubview(liveBgView)
        self.view.addSubview(contentInfoView)
        self.view.addSubview(errorView)
        self.view.addSubview(productListView)
        self.view.addSubview(shareView)
        
        errorView.isHidden = true
        shareView.isHidden = true
    }
    func setUpData(){
        showLoading()
        self.viewModel.source = self.source ?? "1"
        self.viewModel.activityId = self.activityId
        self.contentInfoView.configLiveRoomBaseInfo(self.liveInfoModel)
        self.livePlayerUrl = self.liveInfoModel?.replayUrl ?? ""
        self.productListView.configActivityText(self.liveInfoModel?.name ?? "")
        self.contentInfoView.configPersonNumInfo("\(self.liveInfoModel?.allTimes ?? 0)看过")
        self.getAllLiveProduct()
        let _ = self.startLivePlay()
    }
}
// MARK: -购物相关操作
extension FKYVodPlayerViewController{
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
        // self.productListView.hideProductListView()
    }
    //查看主播信息
    func ckeckAnchorInfoAction(){
        FKYNavigator.shared().openScheme(FKY_LiveRoomInfoVIewController.self, setProperty: { [weak self] (vc) in
            if let strongSelf = self {
                let v = vc as! LiveRoomInfoVIewController
                v.roomId = "\(strongSelf.liveInfoModel?.roomId ?? 0)"
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
// MARK: -录播操作
extension FKYVodPlayerViewController{
    //退出直播
    func exitAction(){
        stopLivePlay()
        FKYNavigator.shared().pop()
    }
    //开始播放
    @objc func startLivePlay()->(Bool){
        if  let playUrl = livePlayerUrl,playUrl.isEmpty == false{
            let playerRect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            self.view.addSubview(vodPlayerView)
            vodPlayerView.frame = playerRect
            vodPlayer.setupVideoWidget(vodPlayerView, insert: 0)
            self.view.sendSubviewToBack(vodPlayerView)
            vodPlayer.isAutoPlay = true
            vodPlayer.vodDelegate = self
            vodPlayer.startPlay(livePlayerUrl)
            UIApplication.shared.isIdleTimerDisabled = true
            return true
        }else{
            self.dismissLoading()
            self.liveBgView.isHidden = false
            self.errorView.isHidden = false
            self.toast("获取播放地址失败")
            return false
        }
    }
    //停止播放
    @objc func stopLivePlay(){
        UIApplication.shared.isIdleTimerDisabled = false
        vodPlayer.vodDelegate = nil
        vodPlayer.removeVideoWidget()
        vodPlayer.stopPlay()
    }
    //    @objc func pauseLivePlay(){
    //        vodPlayer.pause()
    //    }
    //获取当前播放时间
    func getCcurrentPlaybackTime()-> Float{
        return vodPlayer.currentPlaybackTime()
    }
    //获取视频总的播放时长
    func getTotalPlayerTime()-> Float{
        return vodPlayer.duration()
    }
    @objc  func playVideo(){
        if  let playUrl = livePlayerUrl,playUrl.isEmpty == false{
            contentInfoView.playAction()
            if !self.vodPlayer.isPlaying(){
                //重放
                //print ("\(self.getCcurrentPlaybackTime()) 1== \(self.totalVideoTime)")
                if abs(self.totalVideoTime - self.getCcurrentPlaybackTime()) <= 1.0 && self.totalVideoTime != 0{
                    self.vodPlayer.seek(0)
                    vodPlayer.startPlay(livePlayerUrl)
                }else{
                    vodPlayer.resume()
                }
                
            }
        }
    }
    @objc  func pasueVideo(){
        contentInfoView.pasuseAction()
        if self.vodPlayer.isPlaying(){
            vodPlayer.pause()
        }
    }
}
// MARK:录播sdk事件接受和网络状态判断
extension FKYVodPlayerViewController : TXVodPlayListener {
    func onPlayEvent(_ player: TXVodPlayer!, event EvtID: Int32, withParam param: [AnyHashable : Any]!) {
        if (EvtID == PLAY_EVT_PLAY_END.rawValue) {
           // print ("\(self.getCcurrentPlaybackTime()) 123== \(self.totalVideoTime)====\(abs(self.totalVideoTime - self.getCcurrentPlaybackTime()))")
            contentInfoView.setVideoCurrectTime(self.getCcurrentPlaybackTime())
            if (abs(self.totalVideoTime - self.getCcurrentPlaybackTime()) <= 1.0 && self.totalVideoTime != 0){
                if self.totalVideoTime != self.getCcurrentPlaybackTime(){
                  //  print ("\(self.getCcurrentPlaybackTime()) 122== \(self.totalVideoTime)")
                    DispatchQueue.main.async {[weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        //strongSelf.vodPlayer.seek(strongSelf.totalVideoTime + 1.0)
                        strongSelf.contentInfoView.setVideoCurrectTime(strongSelf.totalVideoTime)
                    }
                }
                 self.vodPlayer.pause()
                 contentInfoView.pasuseAction()
            }
        }
        else if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME.rawValue) {
            contentInfoView.setVideoCurrectTime(self.getCcurrentPlaybackTime())
            self.liveBgView.isHidden = true
            self.dismissLoading()
        }
        else if (EvtID == PLAY_EVT_PLAY_BEGIN.rawValue) {
            self.totalVideoTime = self.getTotalPlayerTime()
            contentInfoView.setVideoTotalTime(self.totalVideoTime)
            contentInfoView.setVideoCurrectTime(self.getCcurrentPlaybackTime())
            contentInfoView.playAction()
        }else if (EvtID == EVT_VIDEO_PLAY_PROGRESS.rawValue) {
            //print ("\(self.getCcurrentPlaybackTime()) 124567== \(self.totalVideoTime)====\(abs(self.totalVideoTime - self.getCcurrentPlaybackTime()))")
            contentInfoView.setVideoCurrectTime(self.getCcurrentPlaybackTime())
            if self.getCcurrentPlaybackTime() == self.totalVideoTime && self.totalVideoTime != 0{
                vodPlayer.pause()
                contentInfoView.pasuseAction()
            }
        }else if (EvtID == PLAY_ERR_NET_DISCONNECT.rawValue) {
            //网络断连，且经多次重连亦不能恢复，更多重试请自行重启播放
            //self.toast("网络断连，且经多次重连亦不能恢复，请重进直播间")
            //            self.liveBgView.isHidden = false
            //            self.errorView.isHidden = false
        }else if (EvtID == PLAY_WARNING_RECONNECT.rawValue) {
            ////网络断连，已启动自动重连（重连超过三次就直接抛送 PLAY_ERR_NET_DISCONNECT）
            //            self.liveBgView.isHidden = false
            //            self.errorView.isHidden = false
            // self.toast("网络断连，已启动自动重连")
        }
    }
    
    func onNetStatus(_ player: TXVodPlayer!, withParam param: [AnyHashable : Any]!) {
        
    }
}
extension FKYVodPlayerViewController : FKYNavigationControllerDragBackDelegate {
    func dragBackShouldStart(in navigationController: FKYNavigationController!) -> Bool {
        return false
    }
}
// MARK: - Share
extension FKYVodPlayerViewController {
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
        if let shareWord  = self.viewModel.liveBaseInfo?.shareWord,shareWord.isEmpty == false{
            FKYShareManage.shareToWX(withMessage:shareWord)
        }else{
            self.toast("口令无效")
        }
    }
    
    // QQ好友分享
    fileprivate func shareForQQ() {
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
        toast("直播口令复制成功！")
    }
}
// MARK: - 网络请求
extension FKYVodPlayerViewController{
    // 同步购物车商品数量
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
    //直播所有商品列表
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
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
}
//MARK:埋点
extension FKYVodPlayerViewController{
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
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : "特价" as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S9606", sectionPosition:"\(index + 1)", sectionName: "更多商品", itemId: itemId, itemPosition: nil, itemName: itemName, itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    //主播头像  发送弹幕 开始时间（开始拉流） 结束时间（结束拉流） 点赞按钮点击
    func liveActionBI_Record(_ type:Int){
        var itemName = ""
        var itemId = ""
        if type == 1{
            itemName = "主播头像"
            itemId = "I9601"
        }else if type == 6{
            itemName = "更多商品点击"
            itemId = "I9616"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName: nil, itemId: itemId, itemPosition: nil, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        
    }
    
    //点击购物车
    func liveCartBI_Record(){
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S9606", sectionPosition:nil, sectionName: "更多商品", itemId: "I9610", itemPosition: nil, itemName: "点击购物车", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    }
    //退出
    func exitBI_Record(){
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName: nil, itemId: "I9617", itemPosition: nil, itemName: "关闭直播间", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    }
}
