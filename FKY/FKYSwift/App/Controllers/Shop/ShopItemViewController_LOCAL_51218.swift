//
//  ShopItemViewController.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/26.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  店铺详情...<商家之商品列表>
//  注：涉及到列表界面的打标需求需修改当前文件

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
class ShopItemViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    FSearchBarProtocol {
    //MARK: - Property
    dynamic var shopId: String?
    dynamic var promotionId: String?
    dynamic var promotionRule: String?
    dynamic var promotionType: String?
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.alwaysBounceVertical = true
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = bg1
        cv.register(HomeBannerCell.self, forCellWithReuseIdentifier: "HomeBannerCell")
        cv.register(ShopAddCartCell.self, forCellWithReuseIdentifier: "ShopAddCartCell")
        cv.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader,withReuseIdentifier: "UICollectionReusableView")
        cv.register(HomeShopSection.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HomeShopSection")
        cv.register(FKYReusableForShopPLHeader.self, forCellWithReuseIdentifier: "FKYReusableForShopPLHeader")
        cv.register(ShopProductItemCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ShopProductItemCell")
        cv.register(FKYReuseFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "FKYReuseFooter")
        cv.register(ActivityInfoFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ActivityInfoFooterView")
        cv.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter,withReuseIdentifier: "UICollectionReusableView")
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.top)! > CGFloat.init(0) { // iPhone X
                cv.contentInsetAdjustmentBehavior = .never
                cv.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                cv.scrollIndicatorInsets = cv.contentInset
            }
        }
        return cv
    }()
    
    fileprivate lazy var searchBar: FSearchBar = {
        let bar = FSearchBar()
        bar.delegate = self
        bar.placeholder = "药品名/拼音缩写/批准文号/厂家"
        return bar
    }()
    fileprivate lazy var emptyView: StaticView = {
        let ev = StaticView()
        ev.configView("icon_cart_add_empty", title: "暂无结果", btnTitle: "无")
        return ev
    }()
    fileprivate var badgeView: JSBadgeView?
    fileprivate lazy var shareButton: UIButton = {
        let share = UIButton()
        share.setImage(UIImage.init(named: "icon_share"), for: UIControlState())
        return share
    }()
    
    fileprivate lazy var shareView: ShareView = {
        let view = ShareView()
        return view
    }()
    
    fileprivate lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.imageWithColor(RGBColor(0xff394e), size: CGSize(width:SCREEN_WIDTH, height:43)), for: UIControlState())
        button.setTitle("联系供应商", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: WH(15))
        return button;
    }()
    
    fileprivate lazy var toTopButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage.init(named: "icon_back_top"), for: UIControlState())
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
        label.textAlignment = .center
        label.backgroundColor = RGBAColor(0x000000, alpha: 0.5)
        label.textColor = RGBColor(0xFFFFFF)
        label.font = UIFont.systemFont(ofSize: WH(11))
        label.isHidden = true
        label.MaxWidth = (SCREEN_WIDTH - WH(12)*2)
        return label
    }()
    
    fileprivate var dataSource:[HomeProductModel] = []
    fileprivate var viewType : controllerDisplayType = .fullReduce
    fileprivate var nowPage : Int = 1
    fileprivate var promotionInfo: String = ""
    fileprivate var navBar: UIView?
    fileprivate var shopProvider: ShopItemProvider?
    fileprivate var selectedProd: HomeProductModel?
    fileprivate var selectedSection: Int?
    fileprivate var priceSeq = PriceRangeEnum.NONE.rawValue
    fileprivate var chooseFactoryName : String?
    var promotionModel: CartPromotionModel?
    fileprivate var CollectionOffsetKVOContext = "CollectionOffsetKVOContext"

    //MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        
        self.createShareView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.shopProvider = ShopItemProvider()
        self.requestData()
        
        self.collectionView.addPullToRefresh(actionHandler: {[weak self] in
            if let strongerSelf = self {
                if strongerSelf.viewType == .fullReduce{
                    strongerSelf.shopProvider!.getNextFullReduceProductList{ [weak self] in
                        if let strongerSelf = self {
                            strongerSelf.dataSource = (strongerSelf.shopProvider?.fullReduceProducts)!
                            strongerSelf.collectionView.reloadData()
                            strongerSelf.updateViewInfo()
                            strongerSelf.dismissAnimation()
                        }
                    }
                }else if strongerSelf.viewType == .specialPrice{
                    strongerSelf.shopProvider!.getNextSpecialProductList{ [weak self] in
                        if let strongerSelf = self {
                            strongerSelf.dataSource = (strongerSelf.shopProvider?.specialPriceProducts)!
                            strongerSelf.collectionView.reloadData()
                            strongerSelf.updateViewInfo()
                            strongerSelf.dismissAnimation()
                        }
                    }
                }else{
                    strongerSelf.shopProvider!.getNextProductList{ [weak self] in
                        if let strongerSelf = self {
                            strongerSelf.dataSource = (strongerSelf.shopProvider?.shopProducts)!
                            strongerSelf.collectionView.reloadData()
                            strongerSelf.updateViewInfo()
                            strongerSelf.dismissAnimation()
                        }
                    }
                }
            }
            }, position: .bottom)
    self.collectionView.pullToRefreshView.setCustom(FKYPullToRefreshStateView.fky_footerView(with: .stopped), for: .stopped)
    self.collectionView.pullToRefreshView.setCustom(FKYPullToRefreshStateView.fky_footerView(with: .triggered), for: .triggered)
    self.collectionView.pullToRefreshView.setCustom(FKYPullToRefreshStateView.fky_footerView(with: .loading), for: .loading)

        // 登录成功后刷新界面数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        // 提交采购权限成功后，刷新界面数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name(rawValue: FKYSubmitPurchaseAuthSuccess), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeBadgeNumber()
        
        FKYAnalyticsManager.sharedInstance.BI_Record(self, extendParams:["PageValue":self.shopId as AnyObject], eventId: nil)

    }
    
    deinit {
        // 移除KVO
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("内存不足")
    }
    
    //MARK: - setupView
    func setupView() {
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_red_normal") {
            FKYNavigator.shared().pop()
        }
        
        _ = self.toTopButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.contentOffset = CGPoint(x: 0, y: 0)
            })
            self.lblPageCount.text = String.init(format: "1/%zi", (self.shopProvider?.totalPage)!)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        self.view.addSubview(self.toTopButton)
        self.view.bringSubview(toFront: self.toTopButton)
        let toTopBtnToBottom : CGFloat = 40
        self.toTopButton.snp.makeConstraints({ (make) in
            make.right.equalTo(self.view.snp.right).offset(-WH(20))
            make.bottom.equalTo(self.view.snp.bottom).offset(-WH(toTopBtnToBottom))
            make.width.height.equalTo(WH(30))
        })
        
        self.fky_setupRightImage("icon_search_cart") {
            self.BI_Record(.MAINSTORE_YC_CLICKCART)
            FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                let v = vc as! FKY_TabBarController
                v.index = 2
            })
        }
        
        let bv = JSBadgeView(parentView: self.NavigationBarRightImage, alignment: .topRight)
        bv?.badgePositionAdjustment = CGPoint(x: WH(-7), y: WH(5))
        bv?.badgeTextFont = UIFont.systemFont(ofSize: WH(11))
        self.badgeView = bv
        
        if self.promotionModel == nil {
            //search bar
            self.navBar?.addSubview(self.searchBar)
            self.searchBar.snp.makeConstraints({ (make) in
                make.left.equalTo((self.navBar?.snp.left)!).offset(WH(50))
                make.bottom.equalTo(self.navBar!.snp.bottom).offset(WH(-8))
                make.width.equalTo(WH(225))
                make.height.equalTo(WH(25))
            })
            
            //分享按钮
            _ = self.shareButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
                self.shareView.appearClourse!()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            self.navBar?.addSubview(self.shareButton)
            self.shareButton.snp.makeConstraints({ (make) in
                make.right.equalTo(self.NavigationBarRightImage!.snp.left).offset(WH(-10));
                make.centerY.equalTo(self.NavigationBarRightImage!)
            })
        }
        
        self.view.addSubview(self.emptyView)
        self.emptyView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        })
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        })
        
        self.view.addSubview(self.activityEmptyView)
        self.view.sendSubview(toBack: self.activityEmptyView)
        self.activityEmptyView.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.view).offset(WH(314))
        })
        
        self.view.addSubview(lblPageCount);
        let pageToBottom:CGFloat = 12
        lblPageCount.snp.makeConstraints({[weak self] (make) in
            if let strongSelf = self {
                make.centerX.equalTo(strongSelf.view.snp.centerX)
                if #available(iOS 11, *) {
                    let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
                    if (insets?.top)! > CGFloat.init(0) { // iPhone X
                        make.bottom.equalTo(strongSelf.view.snp.bottom).offset(-WH(pageToBottom+iPhoneX_SafeArea_BottomInset))
                    } else {
                        make.bottom.equalTo(strongSelf.view.snp.bottom).offset(-WH(pageToBottom))
                    }
                } else {
                    make.bottom.equalTo(strongSelf.view.snp.bottom).offset(-WH(pageToBottom))
                }
                make.trailing.lessThanOrEqualTo(strongSelf.view.snp.trailing).offset(-WH(pageToBottom))
                make.leading.greaterThanOrEqualTo(strongSelf.view.snp.leading).offset(WH(pageToBottom))
            }
        })
        
        self.view.addSubview(noAuthorityLabel)
        noAuthorityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(WH(20))
            make.right.equalTo(self.view).offset(WH(-20))
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(WH(40))
        }
        
        // 小能
        self.view.addSubview(settingButton)
        var buttonH = 43
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.top)! > CGFloat.init(0) { // iPhone X
                buttonH = Int(43 + iPhoneX_SafeArea_BottomInset)
            }
        }
        settingButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(WH(CGFloat(buttonH)))
        }
        settingButton.isHidden = true;
        _ = self.settingButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            if self.shopProvider?.shopInfo?.xiaoneng_id?.count > 0 {
                let chat : NTalkerChatViewController = NTalker.standardIntegration().startChat(withSettingId: self.shopProvider?.shopInfo?.xiaoneng_id)
                chat.pushOrPresent = false
                chat.isCancelButtonHiden = true
                let nav : UINavigationController = UINavigationController.init(rootViewController: chat)
                nav.navigationBar.isTranslucent = false
                self.present(nav, animated: true, completion: {
                    
                })
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    // 创建分享页面
    func createShareView() -> () {
        self.view.addSubview(self.shareView)
        self.shareView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        
        shareView.WeChatShareClourse = { () in
            self.WXShare()
        }
        shareView.WeChatFriendShareClourse = { () in
            self.WXFriendShare()
        }
        shareView.QQShareClourse = { () in
            self.QQShare()
        }
        shareView.QQZoneShareClourse = { () in
            self.QQZoneShare()
        }
        shareView.SinaShareClourse = { () in
            self.SinaShare()
        }
    }
    
    //MARK: - Private
    fileprivate func showWrongView(_ errorMessage: String) {
        self.shareButton.isEnabled = false
        self.shareButton.tintColor = UIColor.init(red: 190.0/255.0, green: 190.0/255.0, blue: 190.0/255.0, alpha: 1.0)
        self.view.addSubview(viewErrorView)
        viewErrorView.backgroundColor = RGBColor(0xf3f3f3)
        viewErrorView.setTitle(errorMessage)
        viewErrorView.snp.makeConstraints({[weak self] (make) in
            make.left.right.bottom.equalTo(self!.view)
            make.top.equalTo(self!.navBar!.snp.bottom);
        })
    }
    
    fileprivate func updatePageInfo() {
        if let shopProvider = self.shopProvider, 1 == shopProvider.nowPage {
            self.lblPageCount.text = String.init(format: "%zi/%zi", shopProvider.nowPage,shopProvider.totalPage)
            self.lblPageCount.isHidden = false
        }
    }
    
    fileprivate func updateViewInfo() {
        var settingHeight : CGFloat!
        if self.shopProvider?.shopInfo?.xiaoneng_id?.count > 0 {
            // 显示小能
            settingHeight = 43
            settingButton.isHidden = false;
        }
        else {
            settingHeight = 0
            settingButton.isHidden = true;
        }
        
        //返回顶楼按钮
        let toTopBtnToBottom : CGFloat = 40+settingHeight
        self.toTopButton.snp.updateConstraints({ (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-WH(toTopBtnToBottom))
        })
        
        //列表
        self.collectionView.snp.updateConstraints({ (make) in
            make.bottom.equalTo(self.view).offset(-WH(settingHeight))
        })
        
        //页数
        let pageToBottom:CGFloat = 12+settingHeight
        lblPageCount.snp.updateConstraints({[weak self] (make) in
            if let strongSelf = self {
                if #available(iOS 11, *) {
                    let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
                    if (insets?.top)! > CGFloat.init(0) { // iPhone X
                        make.bottom.equalTo(strongSelf.view.snp.bottom).offset(-WH(pageToBottom+iPhoneX_SafeArea_BottomInset))
                    } else {
                        make.bottom.equalTo(strongSelf.view.snp.bottom).offset(-WH(pageToBottom))
                    }
                } else {
                    make.bottom.equalTo(strongSelf.view.snp.bottom).offset(-WH(pageToBottom))
                }
            }
        })
        self.view.layoutIfNeeded()
    }
    
    //MARK: - Share
    func shareUrl() -> String {
        if let shopId = self.shopId {
            return String.init(format: "https://m.yaoex.com/shop.html?enterpriseId=%@", shopId)
        }
        return "https://m.yaoex.com/shop.html?enterpriseId="
    }
    
    func shareImage() -> String {
        if let model : HomeBannerModel = self.shopProvider?.banners?.first {
            return model.imgUrl!
        }else{
            return ""
        }
    }
    
    func shareMessage() -> String {
        let info = self.shopProvider?.shopInfo?.shopName
        return info!
    }
    
    func WXShare() -> () {
        let url = self.shareUrl()
        FKYShareManage.shareToWX(withOpenUrl: url, andMessage: self.shareMessage(), andImage: self.shareImage())
        self.BI_Record(.MAINSTORE_YC_SHARE_WECHAT)
    }
    func WXFriendShare() -> () {
        let url = self.shareUrl()
        FKYShareManage.shareToWXFriend(withOpenUrl: url, andMessage: self.shareMessage(), andImage: self.shareImage())
        self.BI_Record(.MAINSTORE_YC_SHARE_MOMENTS)
    }
    func QQShare() -> () {
        let url = self.shareUrl()
        FKYShareManage.shareToQQ(withOpenUrl: url, andMessage: self.shareMessage(), andImage: self.shareImage())
        self.BI_Record(.MAINSTORE_YC_SHARE_QQ)
    }
    func QQZoneShare() -> () {
        let url = self.shareUrl()
        FKYShareManage.shareToQQZone(withOpenUrl: url, andMessage: self.shareMessage(), andImage: self.shareImage())
        self.BI_Record(.MAINSTORE_YC_SHARE_QZONE)
    }
    func SinaShare() -> () {
        let url = self.shareUrl()
        FKYShareManage.shareToSina(withOpenUrl: url, andMessage: self.shareMessage(), andImage: self.shareImage())
        self.BI_Record(.MAINSTORE_YC_SHARE_WEIBO)
    }
    
    //MARK: - Notification
    func reloadData() {
        // 刷新界面数据
        self.requestData()
    }
    
    //MARK: - Others
    func dismissAnimation() {
        let time: TimeInterval = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            self.collectionView.pullToRefreshView.stopAnimating()
        }
    }
    
    func nowPageAdd() {
        self.nowPage =  self.nowPage + 1
    }
    
    func changeBadgeNumber() {
        self.badgeView!.badgeText = {
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
    
    //MARK: - 初始网络请求
    func initNetwork() {
        self.nowPage = 1
        self.shopProvider?.specialPriceProducts?.removeAll()
        self.shopProvider?.fullReduceProducts?.removeAll()
        self.dataSource.removeAll()
    }
    
    //MARK: - Request
    // 请求数据
    func requestData()  {
        self.initNetwork()
        self.showLoading()
        if let promotionModel = self.promotionModel {
            self.shopProvider?.queryCartPromotion(promotionModel, completionClosure: { (reason) in
                if let re = reason {
                    self.promotionInfo = re
                }
            })
        }
        self.shopProvider?.getOrderingShopList({[weak self] (list) in
            if let strongSelf = self {
                if list.count < 1{
                    strongSelf.viewType = .none
                }else{
                    let arr = list.filter({ (str) -> Bool in
                        return Int(str as! String) == Int(strongSelf.shopId!)!
                    })
                    if arr.count <= 0 {
                        strongSelf.viewType = .none
                    }
                }
                
                let proId = strongSelf.promotionId ?? ""
                let shopId = strongSelf.shopId ?? ""
                if strongSelf.viewType == .none {
                    strongSelf.shopProvider!.getShopItem(["promotionId":proId as AnyObject ,"enterpriseId":shopId as AnyObject,"keyword":"" as AnyObject,"priceSeq":PriceRangeEnum.NONE.rawValue as AnyObject], callback: { [weak self] in
                        
                        if let strongSelf = self {
                            strongSelf.dataSource = (strongSelf.shopProvider?.shopProducts)!
                            strongSelf.noAuthorityLabel.isHidden = !(strongSelf.dataSource.count == 0)
                            strongSelf.view.sendSubview(toBack: strongSelf.activityEmptyView)
                            strongSelf.collectionView.reloadData()
                            strongSelf.dismissLoading()
                            strongSelf.updateViewInfo()
                            strongSelf.updatePageInfo()
                        }
                        
                        }, errorCallBack: {[weak self] statusCode, message in
                            if let strongSelf = self {
                                strongSelf.showWrongView(message)
                                strongSelf.dismissLoading()
                            }
                        })
                }
                else if strongSelf.viewType == .specialPrice {
                    strongSelf.shopProvider!.getShopItem(["promotionId":proId as AnyObject,"enterpriseId":strongSelf.shopId! as AnyObject,"keyword":"" as AnyObject,"priceSeq":PriceRangeEnum.NONE.rawValue as AnyObject], callback: {[weak self] in
                        if let strongSelf = self {
                            strongSelf.specialPriceProducts()
                            strongSelf.updateViewInfo()
                            strongSelf.updatePageInfo()
                        }
                        
                        }, errorCallBack: {[weak self] statusCode, message in
                            if let strongSelf = self {
                                strongSelf.showWrongView(message)
                                strongSelf.dismissLoading()
                            }
                        })
                }
                else if strongSelf.viewType == .fullReduce {
                    strongSelf.shopProvider!.getShopItem(["promotionId":proId as AnyObject,"enterpriseId":strongSelf.shopId! as AnyObject,"keyword":"" as AnyObject,"priceSeq":PriceRangeEnum.NONE.rawValue as AnyObject], callback: {[weak self] in
                        if let strongSelf = self {
                            strongSelf.fullReduceProducts()
                            strongSelf.updateViewInfo()
                            strongSelf.updatePageInfo()
                        }
                        
                        }, errorCallBack: {[weak self] statusCode, message in
                            if let strongSelf = self {
                                strongSelf.showWrongView(message)
                                strongSelf.dismissLoading()
                            }
                        })
                }
                else if strongSelf.viewType == .noraml {
                    strongSelf.getServiceData("", priceRange: .ASC)
                }
            }
        })
    }
    
    // 列表数据
    func getServiceData(_ keyword: String? , priceRange: PriceRangeEnum) {
//        if let shop_id = self.shopId {
        var proId = ""
        if self.promotionId != nil {
            proId = self.promotionId!
        }
        self.showLoading()
        self.shopProvider!.getShopItem(["promotionId":proId as AnyObject,"enterpriseId":self.shopId! as AnyObject,"keyword":keyword! as AnyObject,"priceSeq":priceRange.rawValue as AnyObject], callback: {[weak self] in
            if let strongerSelf = self {
                strongerSelf.dataSource = (strongerSelf.shopProvider?.shopProducts)!
                strongerSelf.view.sendSubview(toBack: strongerSelf.activityEmptyView)
                strongerSelf.collectionView.reloadData()
                strongerSelf.updateViewInfo()
                strongerSelf.updatePageInfo()
                strongerSelf.dismissLoading()
            }
            }, errorCallBack: {[weak self] statusCode, message in
                if let strongerSelf = self {
                    strongerSelf.showWrongView(message)
                    strongerSelf.dismissLoading()
                }
        })
    }
    
    // 满减商品
    func fullReduceProducts() {
        self.showLoading()
        let para = ["nowPage" : "1",
                    "per":10,
                    "sellerCode":self.shopId!,
                    "searchField":""] as [String : Any]
        self.shopProvider?.getFullReduceProductList(para as [String : AnyObject], callback: {
            self.dismissLoading()
            self.dismissAnimation()
            self.dataSource = (self.shopProvider?.fullReduceProducts)!
            if self.dataSource.count < 1{
                self.view.bringSubview(toFront: self.activityEmptyView)
            }else{
                self.view.sendSubview(toBack: self.activityEmptyView)
            }
            self.collectionView.reloadData()
        })
    }
    
    // 特价商品
    func specialPriceProducts() {
        self.showLoading()
        let para = ["nowPage" : "1",
                    "per":10,
                    "sellerCode":self.shopId!,
                    "searchField":""] as [String : Any]
        self.shopProvider?.getSpecialPriceProductList(para as [String : AnyObject], callback: {
            self.dismissLoading()
            self.dismissAnimation()
            self.view.sendSubview(toBack: self.activityEmptyView)
            self.dataSource = (self.shopProvider?.specialPriceProducts)!
            if self.dataSource.count < 1{
                self.view.bringSubview(toFront: self.activityEmptyView)
            }else{
                self.view.sendSubview(toBack: self.activityEmptyView)
                self.collectionView.reloadData()
            }
        })
    }
    
    //
    func getAvtivityInfo()  {
        if let model = self.promotionModel {
            self.shopProvider?.queryCartPromotion(model, completionClosure: { (reason) in
                if let re = reason {
                    self.promotionInfo = re
                    let path = IndexPath.init(row: 0, section: 0);
                    self.collectionView.reloadItems(at: [path])
                }
            })
        }
    }
    
    // MARK: - CollectionViewDelegate&DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return self.dataSource.count > 0 ? 2 + self.dataSource.count:0
        return 2 + self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if 0 == section { //bannner Section
            if let banners = self.shopProvider?.banners {
                if banners.count > 0 {
                    return 1
                }else {
                    return 0
                }
            }else {
                return 0
            }
        } else {
            if self.dataSource.count > 0 {
                if let sec = self.selectedSection,
                    section == sec && section > 1 {
                    return 1
                }
                switch section {
                case 0:
                    if let banners = self.shopProvider?.banners {
                        if banners.count > 0 {
                            return 1
                        }else {
                            return 0
                        }
                    }else {
                        return 0
                    }
                case 1:
                    if self.promotionModel != nil {
                        return 0
                    }else{
                        return 1
                    }
                case 2:
                    return 0
                default:
                    return 0
                }
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCell", for: indexPath) as! HomeBannerCell
            cell.goToActivityClosure = {
                FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                    let v = vc as! FKY_Web
                    v.urlPath = "https://m.yaoex.com/blob/activity_rules.html"
                    v.title = "活动时间"
                    v.barStyle = .barStyleWhite
                })
            }
            cell.selectedBannerClosure = { (url) in
            FKYAnalyticsManager.sharedInstance.BI_Record(floorCode: nil, floorPosition: "0",floorName: nil, sectionCode: "0", sectionPosition: "0", sectionName: nil, itemCode: "clickBanner", itemPosition: "4", itemName:nil,extendParams:nil, viewController: self)
                
                visitSchema(url)
            }
            cell.configCellForActivityShop(self.shopProvider!.banners!, activityButtonHiden: true, activityInfo: self.promotionInfo)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYReusableForShopPLHeader", for: indexPath) as! FKYReusableForShopPLHeader
            
            cell.changePriceRangeAction = {[weak self] (type) in
                print(type.rawValue)
                self!.priceSeq = type.rawValue
                self!.chooseFactoryName = nil
                if let searchKeyWords = self!.searchBar.text {
                    self!.getServiceData(searchKeyWords, priceRange: type)
                }
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopAddCartCell", for: indexPath) as! ShopAddCartCell
            let model: HomeProductModel = self.dataSource[self.selectedSection! - 2]
            cell.configCell(model)
            
            weak var weakSelf = self
            // 加车
            cell.addCartClosure = { (product,count) in
            let outOfStock: String = (product.statusDesc == -5) ? "1" : "0"
            FKYAnalyticsManager.sharedInstance.BI_Record(floorCode: nil, floorPosition: "0",floorName: nil, sectionCode: "0", sectionPosition: "0", sectionName: nil, itemCode: "addCart", itemPosition: "6", itemName:nil,extendParams:["PageValue":self.shopId as AnyObject,"eventid":"button_addCart" as AnyObject,"outofstock":outOfStock as AnyObject,"demand":count as AnyObject,"storage":product.stockCount as AnyObject], viewController: self)
                self.showLoading()
                // 加车
                self.shopProvider?.addShopCart(product, count: count, completionClosure: { (reason, data) in
                    // 说明：若reason不为空，则加车失败；若data不为空，则限购商品加车失败
                    
                    // toast
                    if let re = reason {
                        self.toast(re)
                    }
                    
                    // 加车成功则重置...<限购>
                    product.limitCanBuyNumber = 0
                    // 限购之剩余可购买数量
                    if let res = data {
                        // limitCount
                        // limitBuyCycleType
                        // limitCanBuyNum
                        if res.value(forKeyPath: "limitCanBuyNum") != nil && (res.value(forKeyPath: "limitCanBuyNum") as AnyObject).isKind(of: NSNumber.self) {
                            if let limitCanBuyNum = res.value(forKeyPath: "limitCanBuyNum") {
                                let limit = Int(limitCanBuyNum as! NSNumber)
                                print("limit:" + String(limit))
                                product.limitCanBuyNumber = limit
                            }
                        }
                    }
                    
                    // 更新
                    weakSelf?.selectedSection = nil
                    let maxSection = self.collectionView.numberOfSections
                    if indexPath.section < maxSection {
                        let indexSet = IndexSet(integer: indexPath.section)
                        weakSelf?.collectionView.reloadSections(indexSet)
                    }
                    else {
                        // exception handle
                        weakSelf?.collectionView.reloadData()
                    }
                    weakSelf?.changeBadgeNumber()
                    var promotions = product.promotionList?.filter({ (po) -> Bool in
                        return po.promotionId == weakSelf?.promotionId
                    })
                    if (weakSelf?.promotionId == nil) {
                        promotions = product.promotionList
                    }
                    if (promotions?.count > 0) {
                        self.getAvtivityInfo()
                    }
                    self.dismissLoading()
                })
            }
            //
            cell.toastClosure = {(msg)in
                self.toast(msg)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            //
            switch indexPath.section {
            case 0:
                // 店铺
                let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HomeShopSection", for: indexPath) as! HomeShopSection
                var shopName: String? = nil
                if(self.shopProvider!.shopInfo != nil){
                    shopName = self.shopProvider!.shopInfo!.shopName
                }
                section.configSection(shopName,subTitle:"企业资质")
                section.moreShop = {
                    if let shopDocList = self.shopProvider?.shopDocList, shopDocList.count > 0 {
                        
                        FKYAnalyticsManager.sharedInstance.BI_Record(floorCode: nil, floorPosition: "0",floorName: nil, sectionCode: "0", sectionPosition: "0", sectionName: nil, itemCode: "getQualifile", itemPosition: "17", itemName:nil,extendParams:nil, viewController: self)
                        
                        FKYNavigator.shared().openScheme(FKY_ShopMaterial.self, setProperty: { (vc) in
                            let v = vc as! ShopMaterialViewController
                            v.shopDocList = self.shopProvider!.shopDocList!
                        })
                    }else{
                        self.toast("暂无资质")
                    }
                }
                return section
            case 1:
                // ???
                if indexPath.section == 1 && self.viewType != .none {
                    let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "FKYReuseFooter", for: indexPath) as! FKYReuseFooter
                    
                    footer.allProductsClouser = {
                        self.viewType = .noraml
                        self.initNetwork()
                        self.getServiceData("", priceRange: .ASC)
                    }
                    footer.activityProductsClouser = {
                        self.viewType = .fullReduce
                        self.initNetwork()
                        self.fullReduceProducts()
                    }
                    return footer
                }else{
                    let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
                    section.backgroundColor = bg2
                    return section
                }
            default:
                // 商品cell
                let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ShopProductItemCell", for: indexPath) as! ShopProductItemCell
                
                // 配置cell
                let model = self.dataSource[indexPath.section - 2] as HomeProductModel
                var editing = false
                if self.selectedSection != nil {
                    editing = self.selectedSection! == indexPath.section
                }
                section.configCell(model, editing:editing)

                weak var weakSelf = self
                // 加车(入口)...<展示底部的加车栏>
                section.selectedAction = {
                    // update
                    if weakSelf?.selectedSection != nil && weakSelf?.selectedSection == indexPath.section {
                        // 隐藏
                        weakSelf?.selectedSection = nil
                    }
                    else {
                        // 显示
                        if let section = weakSelf?.selectedSection {
                            // 显示另外一个...<需先隐藏之前已显示的>
                            weakSelf?.selectedSection = nil
                            let maxSection = self.collectionView.numberOfSections
                            if section < maxSection {
                                let indexSet = IndexSet(integer: section)
                                weakSelf?.collectionView.reloadSections(indexSet)
                            }
                            else {
                                // exception handle
                                weakSelf?.collectionView.reloadData()
                            }
                        }
                        else {
                            // 显示全新一个
                        }
                        weakSelf?.selectedSection = indexPath.section
                    }
                    
                    let maxSection = self.collectionView.numberOfSections
                    if indexPath.section < maxSection {
                        let indexSet = IndexSet(integer: indexPath.section)
                        weakSelf?.collectionView.reloadSections(indexSet)
                    }
                    else {
                        // exception handle
                        weakSelf?.collectionView.reloadData()
                    }
                }
                // 登录
                section.loginClosure = {
                    FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
                }
                //
                section.toastClosure = { msg in
                    FKYProductAlertView.show(withTitle: nil, leftTitle: nil, rightTitle: "确定", message: msg, handler: { (_, _) in
                        //
                    })
                }
                //
                section.alterViewClosure = {
                    FKYProductAlertView.show(withTitle: nil, leftTitle: "取消", rightTitle: "确定", message: "确定加入渠道", handler: { (_,isRight) in
                        if isRight {
                            let service = SearchResultProvider()
                            service.addToChannl(model.productId!,venderId: "\(model.vendorId!)", callback: {
                                (message) in
                                self.toast(message)
                            })
                        }
                    })
                }
                //
                section.activityaInfoAlterClosure = {
                    FKYProductAlertView.show(withTitle: nil, leftTitle: "确定", rightTitle: nil, message: model.activityDescription,titleColor:RGBColor(0xe60012), handler: { (_,isRight) in
                    })
                }
                // 商详
                section.touchItem = {
                    //let model = self.dataSource[indexPath.section - 2]
                    FKYAnalyticsManager.sharedInstance.BI_Record(floorCode:nil, floorPosition: "0",floorName: nil, sectionCode: "0", sectionPosition: "0", sectionName: nil, itemCode: "goProductdetail", itemPosition: "7", itemName:nil,extendParams:nil, viewController: self)
                    
                    FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                        let v = vc as! FKY_ProdutionDetail
                        v.productionId = model.productId
                        v.vendorId = "\(model.vendorId!)"
                        }, isModal: false)
                }
                // 申请采购权限
                section.purchaseApplyClosure = {
                    if model.statusDesc == -9 || model.statusDesc == -11 {
                        // 无采购权限 or 权限审核不通过
                        
                        // 商家id
                        var sellerCode: String = SELF_SHOP_ID
                        var isSelfSale: Bool = true
                        if let venderId = model.vendorId, "\(venderId)" == SELF_SHOP_ID {
                            // 自营
                            isSelfSale = true
                            sellerCode = SELF_SHOP_ID
                        }
                        else {
                            // 非自营
                            isSelfSale = false
                            if let venderId = model.vendorId {
                                sellerCode = "\(venderId)"
                            }
                            else {
                                sellerCode = ""
                            }
                        }
                        // NO-申请 YES-查看
                        let isCheckContent: Bool = (model.statusDesc == -9) ? false : true
                        
                        // 界面跳转...<申请采购权限>
                        FKYNavigator.shared().openScheme(FKY_PurchaseAuthority.self, setProperty: { (vc) in
                            // VC
                            let paVC = vc as! FKYPurchaseAuthorityVC
                            paVC.sellerCode = sellerCode // 商家id
                            paVC.isSelfSale = isSelfSale // 是否自营
                            paVC.isCheckContent = isCheckContent // 是否第一次填写or查看
                        }, isModal: false)
                    }
                    else if model.statusDesc == -12 {
                        // 采购权限已禁用
                        
                        // 弹出提示
                        var venderName = "供应商" // 默认
                        if let vender = model.vendorName, vender.isEmpty == false {
                            venderName = vender
                        }
                        let tip = String.init(format: "您的采购权限被关闭，\n可联系 %@ 进行咨询！", venderName)
//                        let alert = UIAlertView.init(title: nil, message: tip, delegate: nil, cancelButtonTitle: "知道啦")
//                        alert.show()
                        
                        let actionDone = UIAlertAction.init(title: "知道啦", style: .default, handler: { (action) in
                            //
                        })
                        actionDone.setValue(RGBColor(0xFE5050), forKey: "titleTextColor")
                        
                        let alertVC = UIAlertController.init(title: nil, message: tip, preferredStyle: .alert)
                        alertVC.addAction(actionDone)
                        self.present(alertVC, animated: true, completion: {
                            //
                        })
                    }
                    else if model.statusDesc == -10 {
                        // 采购权限待审核
                    }
                }
                return section
            } // switch
        }
        else {
            //
            if indexPath.section == 0 && self.promotionModel != nil {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ActivityInfoFooterView", for: indexPath) as! ActivityInfoFooterView
                footer.configView(self.promotionModel!)
                return footer
            }
            let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
            section.backgroundColor = .clear
            return section
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: SCREEN_WIDTH, height: WH(110))
        case 1:
            return CGSize(width: SCREEN_WIDTH, height: WH(40))
        default:
            return CGSize(width: SCREEN_WIDTH, height: WH(40))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch section {
        case 0:
            return CGSize(width: SCREEN_WIDTH, height: WH(40))
        case 1:
            if self.viewType == .none {
                return CGSize(width: SCREEN_WIDTH, height: WH(0))
            }else{
                return CGSize(width: SCREEN_WIDTH, height: WH(60))
            }
        default:
            return CGSize(width: SCREEN_WIDTH, height: WH(104))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 && self.promotionModel != nil {
            let strProtmotion: String = "以下商品享受: " + self.promotionModel!.promotionDescriptionWithoutPromotionType()
            let textHeight: CGFloat = strProtmotion.heightForFontAndWidth(UIFont.systemFont(ofSize: WH(12)), width: (SCREEN_WIDTH - (WH(10))*2), attributes: nil) + (WH(13) * 2)
            if textHeight > WH(60) {
                return CGSize(width: SCREEN_WIDTH, height: textHeight)
            }
            return CGSize(width: SCREEN_WIDTH, height: WH(60))
        }
        if #available(iOS 11, *), section == dataSource.count + 1 {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.top)! > CGFloat.init(0) { // iPhone X
                return CGSize(width: SCREEN_WIDTH, height: WH(iPhoneX_SafeArea_BottomInset))
            }
        }
        return CGSize.zero
    }
    
    // MARK: - FSearchBarDelegate
    func fsearchBar(_ searchBar: FSearchBar, search: String?) {
        self.getServiceData(search, priceRange: .ASC)
    }
    
    func fsearchBar(_ searchBar: FSearchBar, textDidChange: String?) {
//        print("textChange\(textDidChange)")
    }
    
    func fsearchBar(_ searchBar: FSearchBar, touches: String?) {
//        print("touches search bar")
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        observeCollectionViewContentOffset(scrollView.contentOffset)
        let offset_y = scrollView.contentOffset.y
        if offset_y>=SCREEN_HEIGHT/2 {
            self.toTopButton.isHidden = false
            self.view.bringSubview(toFront: self.toTopButton)
        } else {
            self.toTopButton.isHidden = true
            self.view.sendSubview(toBack: self.toTopButton)
        }
    }
    
    func observeCollectionViewContentOffset(_ contentOffset: CGPoint) {
        if let shopProvider = self.shopProvider {
            if #available(iOS 9.0, *) {
                let indexPaths: [IndexPath] = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionElementKindSectionHeader)
                let lastIndexPath = (indexPaths as NSArray).value(forKeyPath: "@max.section")
                if let lastIndexPath = lastIndexPath, let lIndexPath = lastIndexPath as? Int {
                    let pageIndex = (lIndexPath-2) / 10;
                    lblPageCount.text = String.init(format: "%zi/%zi", (pageIndex+1), shopProvider.totalPage)
                    lblPageCount.isHidden = false
                }
            }
            else {
                // Fallback on earlier versions
                if contentOffset.y <= 0 {
                    lblPageCount.text = String.init(format: "1/%zi", shopProvider.totalPage)
                    lblPageCount.isHidden = false
                } else {
                    var HeightForNotProductContent: CGFloat = WH(40);//HomeShopSection
                    
                    HeightForNotProductContent += WH(110)//HomeBannerCell
                    
                    HeightForNotProductContent += WH(40)//FKYReusableForShopPLHeader
                    
                    //加车cell
                    if nil != self.selectedSection {
                        HeightForNotProductContent += WH(40)
                    }
                    //ActivityInfoFooterView
                    if self.promotionModel != nil {
                        let strProtmotion: String = "以下商品享受: " + self.promotionModel!.promotionDescriptionWithoutPromotionType()
                        let textHeight: CGFloat = strProtmotion.heightForFontAndWidth(UIFont.systemFont(ofSize: WH(12)), width: (SCREEN_WIDTH - (WH(10))*2), attributes: nil) + (WH(13) * 2)
                        if textHeight > WH(60) {
                            HeightForNotProductContent += textHeight
                        }else {
                            HeightForNotProductContent += WH(60)
                        }
                    }
                    
                    //FKYReuseFooter
                    if self.viewType != .none{
                        HeightForNotProductContent += WH(60)
                    }
                    
                    let allContentHeitght = collectionView.bounds.height + contentOffset.y
                    
                    var productCount: Int = Int((allContentHeitght - HeightForNotProductContent)/WH(104));
                    if (allContentHeitght - HeightForNotProductContent).truncatingRemainder(dividingBy: WH(104)) > 0 {
                        productCount = productCount + 1;
                    }
                    if productCount > self.dataSource.count {
                        productCount = self.dataSource.count
                    }
                    var pageIndex = Int(productCount / 10)
                    if productCount%10 > 0 {
                        pageIndex += 1
                    }
                    lblPageCount.text = String.init(format: "%zi/%zi", pageIndex, shopProvider.totalPage)
                    lblPageCount.isHidden = false
                }
            }
        }
    }
}

