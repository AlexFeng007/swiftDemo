//
//  ShopItemOldViewController.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/26.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  店铺详情...<商家之商品列表>...<old>
//  注：2018-4-28 店铺改版以后，本文件仅用来展示（促销活动商品列表）


import UIKit
import SnapKit


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


// 视图展示类型
enum controllerDisplayType: Int {
    case none         // 没有促销
    case noraml       // 全部商品
    case specialPrice // 特价商品
    case fullReduce   // 满减商品
}


@objc
class ShopItemOldViewController: UIViewController {
    enum fromPage {
        /// 未设置，有可能是以前的页面代码中没有传此参数
        case notSet
        /// 从搜索结果列表页
        case searchResult
    }
    
    //行高管理器
    fileprivate var cellHeightManager:ContentHeightManager = {
        let heightManager = ContentHeightManager()
        return heightManager
    }()
    //头部控件
    fileprivate lazy var myHeaderView : FKYShopActivityHeaderView = {
        let view = FKYShopActivityHeaderView()
        return view
    }()
    
    /// 从哪个界面过来
    var fromPage:fromPage = .notSet
    
    /// 是否已经上报过曝光埋点
    var isUploadedDiscountEntryBI = false
    
    /// 套餐优惠viewmodel
    fileprivate lazy var discountPackageViewModel:FKYDiscountPackageViewModel = FKYDiscountPackageViewModel()
    
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            if let strongerSelf = self {
                if strongerSelf.type == 4 {
                    //多品返利
                    strongerSelf.requestRebateShopItem(false)
                }else if strongerSelf.type == 6 {
                    //分享口令
                    strongerSelf.requestCommandData(false)
                }else if strongerSelf.type == 5 {
                    //满折专区
                    strongerSelf.requestFullDiscountData(false)
                }else if strongerSelf.type == 1{
                    //特价专区
                    strongerSelf.requestSpecialPriceData(false)
                }else{
                    strongerSelf.shopProvider.getNextProductList{ [weak self] in
                        if let strongInSelf = self {
                            strongInSelf.dataSource = strongInSelf.shopProvider.shopProducts ?? []
                            if let model = strongInSelf.lastModel {
                                //通过钩子商品进入专区，在商品列表第一个插入钩子商品
                                strongInSelf.dataSource.insert(model, at: 0)
                            }
                            strongInSelf.collectionView.reloadData()
                            if strongInSelf.shopProvider.hasNext() == true {
                                strongInSelf.mjfooter.resetNoMoreData()
                            }else {
                                strongInSelf.mjfooter.endRefreshingWithNoMoreData()
                            }
                            strongInSelf.lblPageCount.text = String.init(format: "%zi/%zi", strongInSelf.shopProvider.nowPage, strongInSelf.shopProvider.totalPage)
                        }
                    }
                }
            }
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    
    //ui控件
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.alwaysBounceVertical = true
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = bg1
        cv.register(HomeCommonProductInfoCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeCommonProductInfoCell")
        cv.register(FKYDiscountPackageEntryCollecHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(FKYDiscountPackageEntryCollecHeader.self));
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                cv.contentInsetAdjustmentBehavior = .never
                cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                cv.scrollIndicatorInsets = cv.contentInset
            }
        }
        cv.mj_footer = self.mjfooter
        return cv
    }()
    
    //联系商家
    fileprivate lazy var contactView: FKYContactShopView = {
        let view = FKYContactShopView.init(frame: CGRect.init(x: WH(20) , y:SCREEN_HEIGHT-WH(60+80), width: WH(60), height: WH(60)))
        view.isHidden = true
        view.clickContactView = { [weak self] in
            if let strongSelf = self {
                var titleStr = ""
                var itemId = "I6121"
                if strongSelf.type == 1 {
                    titleStr = "特价专区"
                }else if strongSelf.type == 2 {
                    titleStr =  "满减专区"
                }else if strongSelf.type == 3 {
                    titleStr = "满赠专区"
                }else if strongSelf.type == 4 {
                    titleStr = "返利专区"
                }else if strongSelf.type == 5 {
                    titleStr = "满折专区"
                }else if strongSelf.type == 6 {
                    titleStr = "BD工具分享"
                    itemId = "I6522"
                }else{
                    titleStr = "活动专区"
                }
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: titleStr, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: itemId, itemPosition: "1", itemName: "联系商家", itemContent:nil , itemTitle: nil, extendParams:nil, viewController: self)
                //点击客服
                FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                    let v = vc as! GLWebVC
                    v.urlPath = String.init(format:"%@?platform=3&supplyId=%@&openFrom=%d",API_IM_H5_URL,strongSelf.shopId!,3)
                    v.navigationController?.isNavigationBarHidden = true
                }, isModal: false)
            }
        }
        return view;
    }()
    
    fileprivate lazy var toTopButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage.init(named: "icon_back_top"), for: UIControl.State())
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            if let strongSelf = self {
                UIView.animate(withDuration: 0.3, animations: {
                    strongSelf.collectionView.contentOffset = CGPoint(x: 0, y: 0)
                })
                if strongSelf.type == 5 || strongSelf.type == 1 || strongSelf.type == 4{
                    strongSelf.lblPageCount.text = "第1页"
                }else{
                    strongSelf.lblPageCount.text = String.init(format: "1/%zi", strongSelf.shopProvider.totalPage)
                }
                
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        return button;
    }()
    
    fileprivate lazy var activityEmptyView: FKYCommonEmptyView = {
        let view = FKYCommonEmptyView()
        view.configEmptyView("icon_shop_drug_none", title: "暂无活动商品", subtitle: nil)
        return view
    }()
    
    fileprivate lazy var viewErrorView: FKYBlankView = {
        let view: FKYBlankView = FKYBlankView.init(initWithFrame: CGRect.zero, andImage: UIImage.init(named: "icon_production_face"), andTitle: nil, andSubTitle: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var noAuthorityLabel: UILabel! = {
        let label = UILabel()
        label.text = "您所在的区域暂时没有采购权限哦，请浏览其他站点商品。"
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.systemFont(ofSize: 13)
        label.isHidden = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var lblPageCount: FKYCornerRadiusLabel = {
        let label = FKYCornerRadiusLabel()
        label.initBaseInfo()
        return label
    }()
    
    //MARK:商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        addView.finishPoint = CGPoint(x:SCREEN_WIDTH - WH(10)-(self.NavigationBarRightImage?.frame.size.width)!/2.0,y:naviBarHeight()-WH(5)-(self.NavigationBarRightImage?.frame.size.height)!/2.0)
        //更改购物车数量
        addView.addCarSuccess = { [weak self] (isSuccess,type,productNum,productModel) in
            if let strongSelf = self {
                if isSuccess == true {
                    if type == 1 {
                        strongSelf.changeBadgeNumber(false)
                    }else if type == 3 {
                        strongSelf.changeBadgeNumber(true)
                    }
                    
                    strongSelf.refreshHeaderProtionView(productModel)
                    
                }
                strongSelf.refreshItemOfCollection(strongSelf.selectedSection)
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? HomeProductModel {
                    strongSelf.addNewBI_Record(model,(strongSelf.selectedSection ?? 0)+1)
                }
            }
        }
        return addView
    }()
    
    
    fileprivate var navBar: UIView?
    fileprivate var badgeView: JSBadgeView?
    fileprivate var timer: Timer!
    fileprivate var nowLocalTime : Int64 = 0 //记录当前系统时间
    
    //加车及请求店铺内满减满赠特价商品
    fileprivate var shopProvider: ShopItemProvider = {
        return ShopItemProvider()
    }()
    
    //mp商家请求类
    fileprivate lazy var fullProvider: FKYShopFullRedueProvider = {
        let provider = FKYShopFullRedueProvider()
        return provider
    }()
    
    fileprivate var dataSource:[Any] = []
    fileprivate var promotionInfo: String = ""
    
    fileprivate var selectedSection: Int?
    fileprivate var priceSeq = PriceRangeEnum.NONE.rawValue
    
    //控制滑动显示页码
    fileprivate var isScrollDown : Bool = true
    var lastOffsetY : CGFloat = 0.0
    
    //MARK: - Property（外部入参数）
    @objc dynamic var shopId: String? // 店铺id（必须传，判断是否有联系商家按钮）
    @objc dynamic var type: Int = 0 // 1-特价活动 2-满减活动 3-满赠活动 4-返利专区 5-满折专区 6-口令分享
    @objc dynamic var promotionId: String? // 满减活动id / 返利专区活动id
    //@objc var promotionModel: FKYPromationInfoModel? // 2-满减活动需传入
    @objc var lastModel:HomeProductModel? //钩子商品model(上个界面传入)
    @objc var commandShareId: String?//口令分享id
    
    //MARK: - 生命周期
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestData()
        if self.fromPage == .searchResult{
            self.requestDiscountPackageEntryInfo()
        }
        
        // 登录成功后刷新界面数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        if self.type == 1 || self.type == 4 || self.type == 5{
            //特价专区/满减专区/满赠专区/返利专区/满折专区
            self.beginSystemTimeOut()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        //删除存储高度
        cellHeightManager.removeAllContentCellHeight()
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ [weak self] (isSuccess) in
            if let strongSelf = self {
                if strongSelf.dataSource.count > 0 {
                    strongSelf.refreshDataBackFromCar()
                }
            }
        }) { [weak self] (reason) in
            if let strongSelf = self {
                strongSelf.toast(reason)
            }
        }
        
        self.changeBadgeNumber(true)
        //获取促销信息
        getAvtivityInfo()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        }
        self.stopTimer()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(FKYOrderPayStatusVC.addDiscountBaoGuangBi), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    deinit {
        // 移除KVO
        // 移除通知
        print("ShopItemOldViewController deinit~!@")
        self.dismissLoading()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("内存不足")
    }
    
    
    //MARK: - Private
    fileprivate func showWrongView(_ errorMessage: String) {
        self.view.addSubview(viewErrorView)
        viewErrorView.backgroundColor = RGBColor(0xf3f3f3)
        viewErrorView.setTitle(errorMessage)
        viewErrorView.snp.makeConstraints({[weak self] (make) in
            make.left.right.bottom.equalTo(self!.view)
            make.top.equalTo(self!.navBar!.snp.bottom);
        })
    }
    //刷新时更新显示页码
    fileprivate func updatePageInfo() {
        if 1 == self.shopProvider.nowPage {
            self.lblPageCount.text = String.init(format: "%zi/%zi", shopProvider.nowPage,shopProvider.totalPage)
            self.lblPageCount.isHidden = false
        }
    }
    //控制是否显示联系客服
    fileprivate func updateSettingBtn(_ hideSettinBtn:Bool){
        if hideSettinBtn == true {
            self.contactView.isHidden = true
        }else{
            self.contactView.isHidden = false
        }
    }
    
    //MARK: - Notification
    @objc func reloadData() {
        // 刷新界面数据
        self.requestData()
    }
    
    //MARK: - Others
    func refreshDataBackFromCar() {
        for product in self.dataSource {
            if let searchModel = product as? HomeProductModel{
                if FKYCartModel.shareInstance().productArr.count > 0 {
                    for cartModel  in FKYCartModel.shareInstance().productArr {
                        if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                            if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == searchModel.productId && cartOfInfoModel.supplyId.intValue == Int(searchModel.vendorId) {
                                searchModel.carOfCount = cartOfInfoModel.buyNum.intValue
                                searchModel.carId = cartOfInfoModel.cartId.intValue
                                break
                            } else {
                                searchModel.carOfCount = 0
                                searchModel.carId = 0
                            }
                        }
                    }
                }else {
                    searchModel.carOfCount = 0
                    searchModel.carId = 0
                }
            }else if let homeModel = product as? HomeCommonProductModel{
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
        self.collectionView.reloadData()
    }
    
    func changeBadgeNumber(_ isdelay : Bool) {
        var deadline :DispatchTime
        if  isdelay {
            deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        }else {
            deadline = DispatchTime.now()
        }
        DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.badgeView!.badgeText = {
                    let count = FKYCartModel.shareInstance().productCount
                    if count <= 0 {
                        return ""
                    }
                    else if count > 99 {
                        return "99+"
                    }
                    return String(count)
                }()
            }
        }
    }
}

//MARK: - view事件响应
extension ShopItemOldViewController{
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKY_goInDiscountPackage{// 套餐优惠入口
            self.addDiscountClickBI()
            let entryModel = userInfo[FKYUserParameterKey] as! FKYDiscountPackageModel
            (UIApplication.shared.delegate as! AppDelegate).p_openPriveteSchemeString(entryModel.jumpInfo)
        }
        
    }
}


//MARK: - ui布局
extension ShopItemOldViewController{
    //MARK: - setupView
    func setupView() {
        //导航栏设置
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.fky_setupLeftImage("togeterBack") {
            FKYNavigator.shared().pop()
        }
        self.fky_setupRightImage("secKill_car") { [weak self] in
            if let strongSelf = self {
                FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
                    let v = vc as! FKY_ShopCart
                    v.canBack = true
                }, isModal: false)
            }
        }
        self.NavigationBarRightImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationBarLeftImage!.snp.centerY)
            make.right.equalTo(self.navBar!.snp.right).offset(-WH(14))
        })
        
        let bv = JSBadgeView(parentView: self.NavigationBarRightImage, alignment: .topRight)
        bv?.badgePositionAdjustment = CGPoint(x: WH(-3), y: WH(3))
        bv?.badgeTextFont = UIFont.systemFont(ofSize: WH(11))
        bv?.badgeTextColor = RGBColor(0xFF2D5C)
        bv?.badgeBackgroundColor = RGBColor(0xFFFFFF)
        self.badgeView = bv
        var titleStr = ""
        if self.type == 1 {
            titleStr = "特价专区"
        }else if self.type == 2 {
            titleStr =  "满减专区"
        }else if self.type == 3 {
            titleStr = "满赠专区"
        }else if self.type == 4 {
            titleStr = "返利专区"
        }else if self.type == 5 {
            titleStr = "满折专区"
        }else if self.type == 6 {
            titleStr = "1药城特惠推荐"
        }else{
            titleStr = "活动专区"
        }
        fky_setupTitleLabel(titleStr)
        NavigationTitleLabel?.textColor = RGBColor(0xFFFFFF)
        self.navBar?.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFF5A9B), to: RGBColor(0xFF2D5C), withWidth: Float(SCREEN_WIDTH))
        
        
        self.view.addSubview(self.myHeaderView)
        self.myHeaderView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(WH(0))
        })
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.myHeaderView.snp.bottom)
            make.left.bottom.right.equalTo(self.view)
        })
        
        self.view.addSubview(self.activityEmptyView)
        self.view.sendSubviewToBack(self.activityEmptyView)
        self.activityEmptyView.snp.makeConstraints({ (make) in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(self.myHeaderView.snp.bottom)
        })
        
        self.view.addSubview(noAuthorityLabel)
        noAuthorityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(WH(20))
            make.right.equalTo(self.view).offset(WH(-20))
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(WH(40))
        }
        self.setFunctionView()
    }
    //设置功能按钮(联系客服，回到顶部，页码器)
    func setFunctionView(){
        // 联系供应商
        self.view.addSubview(contactView)
        //回到顶部按钮
        
        self.view.addSubview(self.toTopButton)
        self.view.bringSubviewToFront(self.toTopButton)
        self.toTopButton.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.contactView.snp.centerX)
            make.top.equalTo(self.contactView.snp.bottom).offset(WH(20))
            make.width.height.equalTo(WH(30))
        })
        
        self.view.addSubview(lblPageCount);
        lblPageCount.snp.makeConstraints({(make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.toTopButton.snp.bottom)
            make.height.equalTo(LBLABEL_H)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-100)
        })
    }
}

//MARK: - 网络请求
extension ShopItemOldViewController {
    /// 请求优惠套餐入口信息
    func requestDiscountPackageEntryInfo(){
        
        if self.type == 5 {
            //满折专区
            self.discountPackageViewModel.type = "36"
        }else if self.type == 1{
            //特价专区
            self.discountPackageViewModel.type = "37"
        }
        self.discountPackageViewModel.requestDiscountPackageInfo {[weak self] (isSuccess, msg) in
            guard let weakSelf = self else {
                return
            }
            
            guard isSuccess else{
                weakSelf.toast(msg)
                return
            }
            weakSelf.collectionView.reloadData()
        }
    }
    
    //    //MARK: - Request
    //    fileprivate func getProfitDetail(_ isFresh:Bool){
    //        //返利专区
    //        self.shopProvider.getProfitList(["promotionId":self.promotionId as AnyObject],self.shopId, isFresh) { [weak self] (errStr) in
    //            if let strongSelf = self {
    //                if let str = errStr {
    //                    //请求失败
    //                    if isFresh == true {
    //                        strongSelf.dismissLoading()
    //                        strongSelf.showWrongView(str)
    //                    }else{
    //                        strongSelf.toast(str)
    //                    }
    //                }else{
    //                    //请求成功
    //                    strongSelf.dataSource = strongSelf.shopProvider.shopProducts ?? []
    //                    if isFresh == true {
    //                        //刷新
    //                        if let model = strongSelf.lastModel {
    //                            //通过钩子商品进入专区，在商品列表第一个插入钩子商品
    //                            strongSelf.dataSource.insert(model, at: 0)
    //                        }
    //                        strongSelf.noAuthorityLabel.isHidden = !(strongSelf.dataSource.count == 0)
    //                        strongSelf.view.sendSubviewToBack(strongSelf.activityEmptyView)
    //                        strongSelf.dismissLoading()
    //                        strongSelf.updateActivityHeaderView()
    //                        //如果没有列表数据
    //                        if strongSelf.dataSource.count == 0 {
    //                            strongSelf.collectionView.isScrollEnabled = false
    //                            strongSelf.lblPageCount.isHidden = true
    //                        }
    //                    }
    //                    strongSelf.collectionView.reloadData()
    //                    if strongSelf.shopProvider.hasNext() == true {
    //                        strongSelf.mjfooter.resetNoMoreData()
    //                    }else {
    //                        strongSelf.mjfooter.endRefreshingWithNoMoreData()
    //                    }
    //                    strongSelf.lblPageCount.text = String.init(format: "%zi/%zi", strongSelf.shopProvider.nowPage, strongSelf.shopProvider.totalPage)
    //                }
    //            }
    //        }
    //    }
    // 请求数据requestRebateShopIte
    func requestData()  {
        self.dataSource.removeAll()
        self.showLoading()
        if self.type == 4 {
            self.requestRebateShopItem(true)
        } else if type == 6 {
            //口令
            requestCommandData(true)
        } else if type == 5 {
            //满折专区
            requestFullDiscountData(true)
        }else if type == 1{
            //特价专区
            requestSpecialPriceData(true)
        }else{
            let proId = self.promotionId ?? ""
            let shopId = self.shopId ?? ""
            //特价专区or满赠专区or满减专区
            self.shopProvider.getShopItem(["promotionId":proId as AnyObject ,"enterpriseId":shopId as AnyObject,"keyword":"" as AnyObject,"priceSeq":PriceRangeEnum.NONE.rawValue as AnyObject, "type": self.type as AnyObject], callback: { [weak self] in
                if let strongSelf = self {
                    strongSelf.dataSource = strongSelf.shopProvider.shopProducts ?? []
                    if let model = strongSelf.lastModel {
                        //通过钩子商品进入专区，在商品列表第一个插入钩子商品
                        strongSelf.dataSource.insert(model, at: 0)
                    }
                    strongSelf.noAuthorityLabel.isHidden = !(strongSelf.dataSource.count == 0)
                    strongSelf.view.sendSubviewToBack(strongSelf.activityEmptyView)
                    strongSelf.collectionView.reloadData()
                    strongSelf.dismissLoading()
                    strongSelf.updatePageInfo()
                    strongSelf.updateActivityHeaderView()
                    if strongSelf.shopProvider.hasNext() == true {
                        strongSelf.mjfooter.resetNoMoreData()
                    }else {
                        strongSelf.mjfooter.endRefreshingWithNoMoreData()
                    }
                    //如果没有列表数据
                    if strongSelf.dataSource.count == 0 {
                        strongSelf.collectionView.isScrollEnabled = false
                        strongSelf.lblPageCount.isHidden = true
                    }
                }
                }, errorCallBack: {[weak self] statusCode, message in
                    if let strongSelf = self {
                        strongSelf.showWrongView(message)
                        strongSelf.dismissLoading()
                    }
            })
        }
        
        //判断是否显示联系客服入口
        if type != 6 {
            if FKYLoginAPI.loginStatus() == .unlogin {
                //隐藏卖家入口
                self.updateSettingBtn(true)
                return
            }
            FKYRequestService.sharedInstance()?.requesImShow(withParam: ["enterpriseId":self.shopId!], completionBlock: { [weak self] (success, error, response, model) in
                guard let strongSelf = self else {
                    return
                }
                if success==true,let showNum = response as? Int,showNum==0 {
                    //展示卖家客服入口
                    strongSelf.updateSettingBtn(false)
                }else{
                    //隐藏卖家入口
                    strongSelf.updateSettingBtn(true)
                }
            })
        }
    }
    //请求分享口令数据
    func requestCommandData(_ isRefresh: Bool) {
        showLoading()
        shopProvider.getCrmProductList(isRefresh, false, commandShareId ?? "") { [weak self](success, msg, needLoadMore) in
            if let strongSelf = self {
                strongSelf.dismissLoading()
                strongSelf.mjfooter.endRefreshing()
                guard success else {
                    if isRefresh {
                        strongSelf.lblPageCount.isHidden = true
                        strongSelf.showWrongView(msg ?? "请求失败")
                    }
                    strongSelf.toast(msg)
                    return
                }
                
                var nowPage = strongSelf.shopProvider.nowPage
                if needLoadMore == true {
                    strongSelf.mjfooter.resetNoMoreData()
                    nowPage = strongSelf.shopProvider.nowPage - 1
                }else {
                    strongSelf.mjfooter.endRefreshingWithNoMoreData()
                }
                
                strongSelf.dataSource = strongSelf.shopProvider.shopProducts ?? []
                strongSelf.collectionView.reloadData()
                if strongSelf.dataSource.count == 0 {
                    strongSelf.collectionView.isScrollEnabled = false
                    strongSelf.noAuthorityLabel.isHidden = false
                }else {
                    strongSelf.noAuthorityLabel.isHidden = true
                }
                if (nowPage <= strongSelf.shopProvider.totalPage  && strongSelf.dataSource.count > 0) {
                    strongSelf.lblPageCount.isHidden = false
                    strongSelf.lblPageCount.text = String.init(format: "%zi/%zi", nowPage, strongSelf.shopProvider.totalPage)
                }else {
                    strongSelf.lblPageCount.isHidden = true
                }
                
                if isRefresh {
                    strongSelf.view.sendSubviewToBack(strongSelf.activityEmptyView)
                }
            }
        }
    }
    //请求多品返利专区
    func requestRebateShopItem(_ isRefresh: Bool) {
        showLoading()
        let proId = self.promotionId ?? ""
        let shopId = self.shopId ?? ""
        if isRefresh == true{
            //恢复原始位置
            self.shopProvider.currentPosition = "1_0"
        }
        self.shopProvider.getRebateShopItem(["promotionId":proId as AnyObject ,"enterpriseId":shopId as AnyObject], callback: { [weak self] in
            if let strongSelf = self {
                strongSelf.dataSource = strongSelf.shopProvider.shopProducts ?? []
                if let model = strongSelf.lastModel {
                    //通过钩子商品进入专区，在商品列表第一个插入钩子商品
                    strongSelf.dataSource.insert(model, at: 0)
                }
                strongSelf.noAuthorityLabel.isHidden = !(strongSelf.dataSource.count == 0)
                strongSelf.view.sendSubviewToBack(strongSelf.activityEmptyView)
                strongSelf.collectionView.reloadData()
                strongSelf.dismissLoading()
                strongSelf.updateActivityHeaderView()
                if strongSelf.shopProvider.hasNextPage == true {
                    strongSelf.mjfooter.resetNoMoreData()
                }else {
                    strongSelf.mjfooter.endRefreshingWithNoMoreData()
                }
                //如果没有列表数据
                if strongSelf.dataSource.count == 0 {
                    strongSelf.collectionView.isScrollEnabled = false
                    strongSelf.lblPageCount.isHidden = true
                }else {
                    strongSelf.lblPageCount.isHidden = false
                }
            }
            }, errorCallBack: {[weak self] statusCode, message in
                if let strongSelf = self {
                    strongSelf.showWrongView(message)
                    strongSelf.dismissLoading()
                }
        })
    }
    //请求满折专区
    func requestFullDiscountData(_ isRefresh: Bool) {
        showLoading()
        let proId = self.promotionId ?? ""
        let shopId = self.shopId ?? ""
        if isRefresh == true{
            //恢复原始位置
            self.shopProvider.currentPosition = "1_0"
        }
        self.shopProvider.getFullDiscountShopItem(["promotionId":proId as AnyObject ,"enterpriseId":shopId as AnyObject], callback: { [weak self] in
            if let strongSelf = self {
                strongSelf.dataSource = strongSelf.shopProvider.shopProducts ?? []
                if let model = strongSelf.lastModel {
                    //通过钩子商品进入专区，在商品列表第一个插入钩子商品
                    strongSelf.dataSource.insert(model, at: 0)
                }
                strongSelf.noAuthorityLabel.isHidden = !(strongSelf.dataSource.count == 0)
                strongSelf.view.sendSubviewToBack(strongSelf.activityEmptyView)
                strongSelf.collectionView.reloadData()
                strongSelf.dismissLoading()
                strongSelf.updateActivityHeaderView()
                if strongSelf.shopProvider.hasNextPage == true {
                    strongSelf.mjfooter.resetNoMoreData()
                }else {
                    strongSelf.mjfooter.endRefreshingWithNoMoreData()
                }
                //如果没有列表数据
                if strongSelf.dataSource.count == 0 {
                    strongSelf.collectionView.isScrollEnabled = false
                    strongSelf.lblPageCount.isHidden = true
                }else {
                    strongSelf.lblPageCount.isHidden = false
                }
            }
            }, errorCallBack: {[weak self] statusCode, message in
                if let strongSelf = self {
                    strongSelf.showWrongView(message)
                    strongSelf.dismissLoading()
                }
        })
    }
    //请求特价专区
    func requestSpecialPriceData(_ isRefresh: Bool) {
        showLoading()
        let shopId = self.shopId ?? ""
        if isRefresh == true{
            //恢复原始位置
            self.shopProvider.currentPosition = "1_0"
        }
        self.shopProvider.getSpecialPriceShopItem(["enterpriseId":shopId as AnyObject], callback: { [weak self] in
            if let strongSelf = self {
                strongSelf.dataSource = strongSelf.shopProvider.shopProducts ?? []
                if let model = strongSelf.lastModel {
                    //通过钩子商品进入专区，在商品列表第一个插入钩子商品
                    strongSelf.dataSource.insert(model, at: 0)
                }
                strongSelf.noAuthorityLabel.isHidden = !(strongSelf.dataSource.count == 0)
                strongSelf.view.sendSubviewToBack(strongSelf.activityEmptyView)
                strongSelf.collectionView.reloadData()
                strongSelf.dismissLoading()
                strongSelf.updateActivityHeaderView()
                if strongSelf.shopProvider.hasNextPage == true {
                    strongSelf.mjfooter.resetNoMoreData()
                }else {
                    strongSelf.mjfooter.endRefreshingWithNoMoreData()
                }
                //如果没有列表数据
                if strongSelf.dataSource.count == 0 {
                    strongSelf.collectionView.isScrollEnabled = false
                    strongSelf.lblPageCount.isHidden = true
                }else {
                    strongSelf.lblPageCount.isHidden = false
                }
            }
            }, errorCallBack: {[weak self] statusCode, message in
                if let strongSelf = self {
                    strongSelf.showWrongView(message)
                    strongSelf.dismissLoading()
                }
        })
    }
    // 获取促销信息(已购买***)满减才会请求
    func getAvtivityInfo() {
        //满减 满折
        if self.type == 2 || self.type == 5 {
            self.shopProvider.queryCartPromotion(self.promotionId, completionClosure: { [weak self] (reason) in
                guard let strongSelf = self else {
                    return
                }
                if let re = reason {
                    strongSelf.promotionInfo = re
                    strongSelf.updateActivityHeaderView()
                }
            })
        }else if self.type == 4 {
            //返利列表(第一次不请求)
            // if let _ = self.shopProvider.rebateRuleText {
            self.shopProvider.getProfitRebateText(["rebateId":self.promotionId as AnyObject,"userId":FKYLoginAPI.currentUser()?.userId as AnyObject]) { [weak self] (reason) in
                guard let strongSelf = self else {
                    return
                }
                if let re = reason {
                    strongSelf.shopProvider.rebateText = re
                    strongSelf.updateActivityHeaderView()
                }
            }
            //  }
        }
        
    }
    //更新满减头部视图
    func updateActivityHeaderView(){
        //店铺名称
        var shopName = ""
        if self.type == 4 {
            //多品返利
            shopName = self.shopProvider.sellerName ?? ""
        }else if self.type == 5  || self.type == 1{
            //满折专区 特价专区
            shopName = self.shopProvider.sellerName ?? ""
        }else{
            if let shopStr = self.shopProvider.shopInfo?.shopName {
                shopName = shopStr
            }
        }
        //门槛
        var alertStr = ""
        //规则
        var tip = ""
        if self.type == 1 {
            tip = "以下商品为特价商品"
        }else if self.type == 2 {
            tip = "以下商品享受: "
            if self.dataSource.count > 0 {
                if let model = self.dataSource[0] as? HomeProductModel {
                    tip = tip + model.getMJPromotionDes()
                }
            }
            alertStr = self.promotionInfo
        }else if self.type == 3 {
            tip = "以下商品为赠送赠品的商品"
        }else if self.type == 4 {
            tip = self.shopProvider.rebateRuleText ?? ""
            alertStr = self.shopProvider.rebateText ?? ""
        }else if self.type == 5 {
            tip = "以下商品享受: " + (self.shopProvider.rebateRuleText ?? "")
            alertStr = self.promotionInfo
        }
        let h = self.myHeaderView.getShopActivityHeaderHeight(alertStr, tip,shopName)
        self.myHeaderView.snp.updateConstraints({ (make) in
            make.height.equalTo(h)
        })
    }
    //获取商品满赠信息
    func getFullGiftInfo(promotionid: String, msgStr: String) {
        self.showLoading()
        let pid = promotionid
        FKYProductionDetailService.requestProductFullGiftInfo(pid, success: { [weak self] (success, list) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            let view = FKYFullGiftActionSheetView(contentArray:(list as! [Any]), andText:msgStr)
            view?.show(in: (UIApplication.shared.delegate?.window)!)
        }) { [weak self] (msg, data) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.toast(msg)
            let view = FKYFullGiftActionSheetView(contentArray:[], andText:msgStr)
            view?.show(in: (UIApplication.shared.delegate?.window)!)
        }
    }
}

// MARK: - CollectionViewDelegate&DataSource
extension ShopItemOldViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var count =  self.dataSource.count
        if self.discountPackageViewModel.discountPackage.imgPath.isEmpty == false,self.fromPage == .searchResult{
            count += 1
        }
        return count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        /// 套餐优惠入口
        if self.discountPackageViewModel.discountPackage.imgPath.isEmpty == false , indexPath.section == 0,self.fromPage == .searchResult{
            //        if indexPath.section == 0{
            let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(FKYDiscountPackageEntryCollecHeader.self), for: indexPath) as! FKYDiscountPackageEntryCollecHeader
            section.configItem(discountModel: self.discountPackageViewModel.discountPackage)
            self.perform(#selector(FKYOrderPayStatusVC.addDiscountBaoGuangBi), with: nil, afterDelay: 3)
            return section
        }
        
        // 商品cell
        // 配置cell
        var sectionCount = indexPath.section
        if self.discountPackageViewModel.discountPackage.imgPath.isEmpty == false ,self.fromPage == .searchResult,indexPath.section > 0{
            sectionCount -= 1
        }
        let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeCommonProductInfoCell", for: indexPath) as! HomeCommonProductInfoCell
        if let model = self.dataSource[sectionCount] as? HomeProductModel{
            section.configCell(model)
            if self.type == 3 {
                section.showBottomFullGift(model)
            }
            //        // 满赠
            section.fullGiftClosure = { [weak self] desStr in
                if let strongSelf = self {
                    if let promotonList = model.promotionList, promotonList.count > 0 {
                        let predicate: NSPredicate = NSPredicate(format: "self.stringPromotionType IN %@", ["5", "6", "7", "8"])
                        let result = (promotonList as NSArray).filtered(using: predicate) as! Array<PromotionModel>
                        var promotionId = ""
                        for po in result {
                            promotionId = po.promotionId!
                        }
                        strongSelf.getFullGiftInfo(promotionid: promotionId, msgStr: desStr)
                    }
                }
            }
            // 更新加车数量
            section.addUpdateProductNum = { [weak self] in
                if let strongSelf = self {
                    strongSelf.selectedSection = sectionCount
                    strongSelf.popAddCarView(model)
                }
            }
            //跳转到聚宝盆商家专区
            section.clickJBPContentArea = { [weak self] in
                if let strongSelf = self {
                    strongSelf.addEnterJBPShopBI(model,sectionCount)
                    FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                        let controller = vc as! FKYNewShopItemViewController
                        controller.shopId = "\(model.vendorId)"
                        controller.shopType = "1"
                    }, isModal: false)
                }
            }
            //到货通知
            section.productArriveNotice = {
                FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                    let controller = vc as! ArrivalProductNoticeVC
                    controller.productId = model.productId
                    controller.venderId = "\(model.vendorId)"
                    controller.productUnit = model.unit
                }, isModal: false)
            }
            // 登录
            section.loginClosure = {
                FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            }
            // 商详
            section.touchItem = { [weak self] in
                if let strongSelf = self {
                    var titleStr = ""
                    var itemId = "I9998"
                    var itemTitle: String? = nil
                    if strongSelf.type == 1 {
                        titleStr = "特价专区"
                    }else if strongSelf.type == 2 {
                        titleStr =  "满减专区"
                    }else if strongSelf.type == 3 {
                        titleStr = "满赠专区"
                    }else if strongSelf.type == 4 {
                        titleStr = "返利专区"
                    }else if strongSelf.type == 5 {
                        titleStr = "满折专区"
                    }else if strongSelf.type == 6 {
                        titleStr = "BD工具分享"
                        itemId = "I6521"
                        itemTitle = strongSelf.shopProvider.shareTypeName
                    }else {
                        titleStr = "活动专区"
                    }
                    let extendParams:[String :AnyObject] = ["storage" : model.storage! as AnyObject,"pm_price" : model.pm_price! as AnyObject,"pm_pmtn_type" : model.pm_pmtn_type! as AnyObject]
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: titleStr, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: itemId, itemPosition: "\(sectionCount)", itemName: "点进商详", itemContent:"\(model.vendorId )|\(model.productId )" , itemTitle: itemTitle, extendParams:extendParams, viewController: strongSelf)
                    strongSelf.view.endEditing(false)
                    FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: {  (vc) in
                        let v = vc as! FKY_ProdutionDetail
                        v.productionId = model.productId
                        v.vendorId = "\(model.vendorId)"
                        v.updateCarNum = { [weak self] (carId ,num) in
                            if let strongInSelf = self {
                                if let count = num {
                                    model.carOfCount = count.intValue
                                }
                                if let getId = carId {
                                    model.carId = getId.intValue
                                }
                                strongInSelf.collectionView.reloadSections(IndexSet(integer: sectionCount))
                            }
                        }
                    }, isModal: false)
                }
            }
        }else if  let model = self.dataSource[sectionCount] as? HomeCommonProductModel{
            section.configCell(model)
            
            
            // 更新加车数量
            section.addUpdateProductNum = { [weak self] in
                if let strongSelf = self {
                    strongSelf.selectedSection = sectionCount
                    strongSelf.popAddCarView(model)
                }
            }
            //跳转到聚宝盆商家专区
            section.clickJBPContentArea = { [weak self] in
                if let strongSelf = self {
                    strongSelf.newAddEnterJBPShopBI(model,sectionCount)
                    FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                        let controller = vc as! FKYNewShopItemViewController
                        controller.shopId = "\(model.supplyId ?? 0)"
                        controller.shopType = "1"
                    }, isModal: false)
                }
            }
            //到货通知
            section.productArriveNotice = {
                FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                    let controller = vc as! ArrivalProductNoticeVC
                    controller.productId = model.spuCode
                    controller.venderId = "\(model.supplyId)"
                    controller.productUnit = model.packageUnit
                }, isModal: false)
            }
            // 登录
            section.loginClosure = {
                FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            }
            // 商详
            section.touchItem = { [weak self] in
                if let strongSelf = self {
                    var titleStr = ""
                    let itemId = "I9998"
                    if strongSelf.type == 1 {
                        titleStr = "特价专区"
                    }else if strongSelf.type == 2 {
                        titleStr =  "满减专区"
                    }else if strongSelf.type == 3 {
                        titleStr = "满赠专区"
                    }else if strongSelf.type == 4 {
                        titleStr = "返利专区"
                    }else if strongSelf.type == 5 {
                        titleStr = "满折专区"
                    }else {
                        titleStr = "活动专区"
                    }
                    let extendParams:[String :AnyObject] = ["storage" : model.storage! as AnyObject,"pm_price" : model.pm_price! as AnyObject,"pm_pmtn_type" : model.pm_pmtn_type! as AnyObject]
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: titleStr, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: itemId, itemPosition: "\(sectionCount)", itemName: "点进商详", itemContent:"\(model.supplyId ?? 0) )|\(model.productId ?? 0)" , itemTitle: nil, extendParams:extendParams, viewController: strongSelf)
                    strongSelf.view.endEditing(false)
                    FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: {  (vc) in
                        let v = vc as! FKY_ProdutionDetail
                        v.productionId = "\(model.spuCode ?? "")"
                        v.vendorId = "\(model.supplyId ?? 0)"
                        v.updateCarNum = { [weak self] (carId ,num) in
                            if let strongInSelf = self {
                                if let count = num {
                                    model.carOfCount = count.intValue
                                }
                                if let getId = carId {
                                    model.carId = getId.intValue
                                }
                                strongInSelf.collectionView.reloadSections(IndexSet(integer: sectionCount))
                            }
                        }
                    }, isModal: false)
                }
            }
        }
        
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var sectionCount = section
        if self.discountPackageViewModel.discountPackage.imgPath.isEmpty == false , section == 0,self.fromPage == .searchResult{
            let height = FKYDiscountPackageEntryCollecHeader.getHeight()
            return CGSize(width: SCREEN_WIDTH, height:height)
            
        }
        if self.discountPackageViewModel.discountPackage.imgPath.isEmpty == false ,section > 0,self.fromPage == .searchResult{
            sectionCount -= 1
        }
        
        let model = self.dataSource[sectionCount]
        if let serachmodel = self.dataSource[sectionCount] as? HomeProductModel{
            if serachmodel.isHasSomeKindPromotion(["5", "6", "7", "8"]), type == 3 {
                let conutCellHeight = HomeCommonProductInfoCell.getPresenterCellContentHeight(model as Any)
                return CGSize(width: SCREEN_WIDTH, height:conutCellHeight)
            }
        }
        let conutCellHeight = HomeCommonProductInfoCell.getCellContentHeight(model as Any)
        return CGSize(width: SCREEN_WIDTH, height:conutCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if (collectionView.isDragging || collectionView.isDecelerating) && isScrollDown {
            //上滑处理
            let scrollIndex = indexPath.section / 10
            if self.type == 5 || self.type == 1 || type == 4{
                self.lblPageCount.text = String.init(format: "第%zi页", scrollIndex+1)
            }else{
                self.lblPageCount.text = String.init(format: "%zi/%zi", scrollIndex+1, self.shopProvider.totalPage)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if (collectionView.isDragging || collectionView.isDecelerating) && !isScrollDown {
            //下滑处理
            let scrollIndex = (indexPath.section-1) / 10
            if self.type == 5 || self.type == 1 || type == 4{
                self.lblPageCount.text = String.init(format: "第%zi页", scrollIndex+1)
            }else{
                self.lblPageCount.text = String.init(format: "%zi/%zi", scrollIndex+1, self.shopProvider.totalPage)
            }
        }
    }
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isScrollDown = lastOffsetY < scrollView.contentOffset.y
        lastOffsetY = scrollView.contentOffset.y
        let offset_y = scrollView.contentOffset.y
        if offset_y>=SCREEN_HEIGHT/2 {
            self.toTopButton.isHidden = false
            self.view.bringSubviewToFront(self.toTopButton)
        } else {
            self.toTopButton.isHidden = true
            self.view.sendSubviewToBack(self.toTopButton)
        }
    }
}

// MARK: - 加车bi埋点
extension ShopItemOldViewController {
    
    /// 套餐优惠曝光埋点
    @objc func addDiscountBaoGuangBi() {
        if (self.isUploadedDiscountEntryBI == true){
            return;
        }
        self.isUploadedDiscountEntryBI = true
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I1999", itemPosition: nil, itemName: "有效曝光", itemContent: nil, itemTitle: nil, extendParams: [:], viewController: self);
    }
    
    /// 套餐优惠点击埋点
    func addDiscountClickBI() {
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I0004", itemPosition: "1", itemName: self.discountPackageViewModel.discountPackage.name , itemContent: nil, itemTitle: nil, extendParams: [:], viewController: self);
    }
    
    //设置加车的来源
    func getTypeSourceStr() -> String{
        if self.type == 1 {
            return  HomeString.SHOPITEM_TJ_ADD_SOURCE_TYPE
        }else if self.type == 2 {
            return  HomeString.SHOPITEM_MJ_ADD_SOURCE_TYPE
        }else if self.type == 3 {
            return  HomeString.SHOPITEM_MZ_ADD_SOURCE_TYPE
        }else if self.type == 4 {
            return  HomeString.SHOPITEM_FL_ADD_SOURCE_TYPE
        }else if self.type == 5 {
            return  HomeString.SHOPITEM_MANZHE_ADD_SOURCE_TYPE
        }else if self.type == 6 {
            return HomeString.SHOPITEM_SHAREID_ADD_SOURCE_TYPE
        }else {
            return  HomeString.SHOPITEM_FL_ADD_SOURCE_TYPE
        }
    }
    // 更新
    func refreshItemOfCollection(_ section: Int?) {
        guard let section = section, section >= 0 else {
            if let selectedNum = self.selectedSection, selectedNum >= 0 {
                let maxSection = self.collectionView.numberOfSections
                if selectedNum < maxSection {
                    refreshCartCount(selectedNum)
                    let indexSet = IndexSet(integer: selectedNum)
                    self.collectionView.reloadSections(indexSet)
                }
                else {
                    self.collectionView.reloadData()
                }
            }
            else {
                self.collectionView.reloadData()
            }
            return
        }
        
        let maxSection = self.collectionView.numberOfSections
        if section < maxSection {
            refreshCartCount(section)
            let indexSet = IndexSet(integer: section)
            self.collectionView.reloadSections(indexSet)
        }
        else {
            self.collectionView.reloadData()
        }
    }
    
    func refreshCartCount(_ selectedNum: Int) {
        let product = self.dataSource[selectedNum]
        if let searchModel = product as? HomeProductModel{
            if FKYCartModel.shareInstance().productArr.count > 0 {
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == searchModel.productId && cartOfInfoModel.supplyId.intValue == Int(searchModel.vendorId) {
                            searchModel.carOfCount = cartOfInfoModel.buyNum.intValue
                            searchModel.carId = cartOfInfoModel.cartId.intValue
                            break
                        } else {
                            searchModel.carOfCount = 0
                            searchModel.carId = 0
                        }
                    }
                }
            }else {
                searchModel.carOfCount = 0
                searchModel.carId = 0
            }
        }
        else if let homeModel = product as? HomeCommonProductModel{
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
    
    // 埋点
    func addNewBI_Record(_ product: HomeProductModel, _ section: Int) {
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : product.pm_pmtn_type! as AnyObject]
        
        var itemTitle: String? = nil
        var floorName = "活动专区"
        if type == 1 {
            floorName = "特价专区"
        }else if type == 2 {
            floorName =  "满减专区"
        }else if type == 3 {
            floorName = "满赠专区"
        }else if type == 4 {
            floorName = "返利专区"
        }else if type == 5 {
            floorName = "满折专区"
        }else if type == 6 {
            floorName = "BD工具分享"
            itemTitle = shopProvider.shareTypeName
        }
        
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: floorName, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I9999", itemPosition: "0", itemName: "加车", itemContent:"\(product.vendorId )|\(product.productId )" , itemTitle: itemTitle, extendParams:extendParams, viewController: self)
    }
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = self.getTypeSourceStr()
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
    //刷新头部促销相关的信息
    func refreshHeaderProtionView(_ product:Any)  {
        if let model = product as? HomeProductModel {
            var promotions = model.promotionList?.filter({ (po) -> Bool in
                return po.promotionId == self.promotionId
            })
            if (self.promotionId == nil) {
                promotions = model.promotionList
            }
            if (promotions?.count > 0 || self.type == 4) {
                self.getAvtivityInfo()
            }
        }
        
        if let model = product as? HomeCommonProductModel {
            if let sign = model.productSign {
                if sign.fullScale == true || sign.fullGift == true || sign.fullDiscount == true || sign.specialOffer == true || sign.rebate == true{
                    //有活动  满折 多品返利
                    if  self.type == 5 || type == 4{
                        self.getAvtivityInfo()
                    }
                }
            }
        }
    }
    
    func addEnterJBPShopBI(_ model:HomeProductModel,_ section:NSInteger){
        var titleStr = ""
        var itemId = "I6403"
        var itemTitle: String? = nil
        if self.type == 1 {
            titleStr = "特价专区"
        }else if self.type == 2 {
            titleStr =  "满减专区"
        }else if self.type == 3 {
            titleStr = "满赠专区"
        }else if self.type == 4 {
            titleStr = "返利专区"
        }else if self.type == 5 {
            titleStr = "满折专区"
        }else if self.type == 6 {
            titleStr = "BD工具分享"
            itemId = "I6421"
            itemTitle = self.shopProvider.shareTypeName
        }else {
            titleStr = "活动专区"
        }
        let extendParams:[String :AnyObject] = ["storage" : model.storage! as AnyObject,"pm_price" : model.pm_price! as AnyObject,"pm_pmtn_type" : model.pm_pmtn_type! as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: titleStr, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: itemId, itemPosition: "\(section)", itemName: "点进JBP专区", itemContent:"\(model.vendorId )|\(model.productId )" , itemTitle: itemTitle, extendParams:extendParams, viewController: self)
        
    }
    func newAddEnterJBPShopBI(_ model:HomeCommonProductModel,_ section:NSInteger){
        var titleStr = ""
        var itemId = "I6403"
        var itemTitle: String? = nil
        if self.type == 1 {
            titleStr = "特价专区"
        }else if self.type == 2 {
            titleStr =  "满减专区"
        }else if self.type == 3 {
            titleStr = "满赠专区"
        }else if self.type == 4 {
            titleStr = "返利专区"
        }else if self.type == 5 {
            titleStr = "满折专区"
        }else if self.type == 6 {
            titleStr = "BD工具分享"
            itemId = "I6421"
            itemTitle = self.shopProvider.shareTypeName
        }else {
            titleStr = "活动专区"
        }
        
        let extendParams:[String :AnyObject] = ["storage" : model.storage! as AnyObject,"pm_price" : model.pm_price! as AnyObject,"pm_pmtn_type" : model.pm_pmtn_type! as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: titleStr, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: itemId, itemPosition: "\(section)", itemName: "点进商详", itemContent:"\(model.supplyId ?? 0)|\(model.productId ?? 0)" , itemTitle: itemTitle, extendParams:extendParams, viewController:self)
        
    }
}
//MARK:页面埋点
extension ShopItemOldViewController {
    fileprivate func beginSystemTimeOut(){
        // 启动timer...<1.s后启动>
        let date = NSDate.init(timeIntervalSinceNow: 1.0)
        timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(calculateCount), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    @objc fileprivate func calculateCount() {
        self.nowLocalTime = self.nowLocalTime+1
        if self.nowLocalTime == 3 {
            self.stopTimer()
            var titleStr = ""
            if self.type == 1 {
                titleStr = "特价专区"
            }else if self.type == 4 {
                titleStr = "返利专区"
            }else if self.type == 5 {
                titleStr = "满折专区"
            }
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: titleStr, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I10000", itemPosition: nil, itemName: "专区有效浏览", itemContent:nil, itemTitle: nil, extendParams:nil, viewController:self)
        }
    }
    fileprivate func stopTimer()  {
        if timer != nil {
            timer.invalidate()
            timer = nil
            self.nowLocalTime = 0
        }
    }
}
