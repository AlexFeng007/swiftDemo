//
//  FKYSearchResultVC.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/26.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  商品列表(搜索结果列表)

import UIKit
import SnapKit
import QuartzCore

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
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
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

let IsShowMore = "FILTER_FACTORY_SHOW_MORE"


class FKYSearchResultVC: UIViewController,FSearchBarProtocol {
    // MARK: - Property
    /// BI埋点model
    var BIModel = FKYSearchBIModel()
    
    fileprivate var navBar: UIView?
    fileprivate var searchBar: FSearchBar?
    fileprivate var searchResultProvider: SearchResultProvider = {
        let resultProvider = SearchResultProvider()
        return resultProvider
    }()
    fileprivate var searchShopProvider : FKYShopListProvider = {
        let shopProvider = FKYShopListProvider()
        
        return shopProvider
    }()
    // 顶部搜索筛选视图
    fileprivate var sectionHeadFilter :FKYReusableHeader = {
        let headView = FKYReusableHeader()
        return headView
    }()
    //    //店铺信息
    //    fileprivate var shopInfoHeadView :SearchShopInfoHeadView = {
    //        let headView = SearchShopInfoHeadView()
    //        return headView
    //    }()
    
    fileprivate var selectedIndexPath: IndexPath? // 当前加车的cell索引
    fileprivate var emptyViewForShop: FKYCommonEmptyView? // 店铺内搜索的空态视图
    fileprivate var nowPage = 1
    fileprivate var tableHeadHeight = WH(0)
    fileprivate var totalPage: NSInteger?
    /// 搜索关键词来源0用户输入关键词，1扫码搜索关键词    默认0
    @objc var keyWordSoruceType = 0
    
    /// 是否是从扫码搜索页过来的
    @objc var isFromScanVC = false
    
    /// 条码编码 只有扫码搜索的时候采用
    @objc var barCode = ""
    
    @objc var sortColumn = "default"
    @objc var selectedPriceDefault = false //默认是未选中默认的
    @objc var priceSeq = PriceRangeEnum.NONE.rawValue //价格标签
    @objc var stockSeq = StockStateEnum.ALL.rawValue //是否有货标签
    @objc var shopSort = ShopSortEnum.ALLSHOP.rawValue //自营标签
    @objc var getVerbCondition: ( (String,String,String,String)->() )?
    @objc var updateSearchKeyword: ( (String, NSNumber?) -> () )?
    
    //筛选条件
    fileprivate var setedStatusCondition = false
    fileprivate var chooseFactoryName = [SerachFactorysInfoModel]() //选中的生产厂家
    fileprivate var chooseSellersName = [SerachSellersInfoModel]() //选中的商家
    fileprivate var chooseRankName = [SerachRankInfoModel]() //选中的商品规格
    //生产厂家是否展开
    fileprivate var factoryContentMode: FactoryFliterListCotentMode = .FactoryNormal
    //商品规格是否展开
    fileprivate var rankContentMode: RankFliterListCotentMode = .RankNormal
    
    fileprivate var badgeView: JSBadgeView?
    fileprivate var CollectionOffsetKVOContext = 1
    // fileprivate var sectionHeadFilter: FKYReusableHeader? // 顶部搜索筛选视图
    //行高管理器
    fileprivate var cellHeightManager:ContentHeightManager = {
        let heightManager = ContentHeightManager()
        return heightManager
    }()
    // 当前页索引
    fileprivate lazy var lblPageCount: FKYCornerRadiusLabel = {
        let label = FKYCornerRadiusLabel()
        label.initBaseInfo()
        return label
    }()
    // 返回顶部按钮
    fileprivate lazy var toTopButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage.init(named: "icon_back_top"), for: UIControl.State())
        return button;
    }()
    // 搜商品时的空态视图容器
    fileprivate lazy var noProductView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    
    //商品加车弹框
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
                }
                strongSelf.refreshItemOfCollection(strongSelf.selectedIndexPath)
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? HomeProductModel {
                    strongSelf.addNewBI_Record(model,strongSelf.getCurrectCellIndex(strongSelf.selectedIndexPath?.row ?? 0),2)
                }
            }
        }
        return addView
    }()
    // 搜专区商品时的空态视图
    fileprivate lazy var jbpEmptyVC: FKYJPPEmptyViewController = {
        let vc = FKYJPPEmptyViewController()
        vc.shopId = "\(self.shopId ?? 0)"
        //
        vc.changeBudgeNumAction = { [weak self] isdelay in
            if let strongSelf = self {
                strongSelf.changeBadgeNumber(isdelay)
            }
        }
        self.noProductView.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.edges.equalTo(self.noProductView)
        }
        self.noProductView.isHidden = true
        self.addChild(vc)
        return vc
    }()
    fileprivate  lazy var tableView: UITableView = { [weak self] in
        var tableView = UITableView(frame: CGRect.null, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ColorConfig.colorffffff
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(SearchProductInfoCell.self, forCellReuseIdentifier: "SearchProductInfoCell")
        tableView.register(SearchShopListCell.self, forCellReuseIdentifier: "SearchShopListCell")
        tableView.register(FKYSearchResualtLowRecallHeader.self, forCellReuseIdentifier: "FKYSearchResualtLowRecallHeader")
        tableView.register(SearchGZProductInfoCell.self, forCellReuseIdentifier: "SearchGZProductInfoCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.register(SearchShopInfoCell.self, forCellReuseIdentifier: "SearchShopInfoCell")
        tableView.register(SearchZeroKeyWordCell.self, forCellReuseIdentifier: "SearchZeroKeyWordCell")
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0//WH(213)
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
        }()
    // 搜商品时的空态视图
    fileprivate lazy var emptyVC: SearchOftenBuyController = {
        let vc = SearchOftenBuyController()
        //        vc.barCode = self.barCode
        vc.searchInShop = self.shopProductSearch
        //
        vc.changeBudgeNumAction = { [weak self] isdelay in
            if let strongSelf = self {
                strongSelf.changeBadgeNumber(isdelay)
            }
        }
        // 搜索
        vc.searchAction = { [weak self] (item, index) in
            guard let strongSelf = self else {
                return
            }
            guard let word = item.word, word.isEmpty == false else {
                // error
                strongSelf.toast("无搜索词")
                return
            }
            // 埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "搜索无结果推荐词", itemId: ITEMCODE.SEARCHRESULT_NO_RESULT_CODE.rawValue, itemPosition: "\(index + 1)", itemName: "建议搜索词", itemContent: strongSelf.itemContentStr, itemTitle: word, extendParams: self?.getBI_KeyWord(), viewController: self)
            // 保存keyword
            strongSelf.keyword = word
            // 保存nature
            strongSelf.nature = item.nature
            // 更新输入框内容
            strongSelf.searchBar?.text = word
            // 去掉筛选弹出视图中的选项，保留筛选栏中的选项
            strongSelf.resetFilterForFactoryAndSpec()
            // 开始(重新)搜索
            strongSelf.getAllData(true)
            // block回传
            if let block = strongSelf.updateSearchKeyword {
                block(word, strongSelf.sellerCode)
            }
        }
        self.noProductView.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.edges.equalTo(self.noProductView)
        }
        self.addChild(vc)
        return vc
    }()
    
    var shopId: Int?                      //
    @objc var station: String?            //
    @objc var keyword: String?            // 搜索关键词
    @objc var searchBarkeyword: String = ""           // 当0搜词时顶部搜索关键词
    @objc var factoryNameKeyword: String? // 厂商关键词
    @objc var fromWhere: String?          // 记录搜索词是从哪里来的
    @objc var spuCode: String?            // 商品id
    @objc var product_name: String?       // 商品名称
    @objc var sellerCode: NSNumber?       // 商家id...<有商家id，则一定是店铺内的商品搜索>
    @objc var jbpShopID: String?       // 专区ID
    @objc var yflShopID: String?       // 药福利ID
    @objc var itemContentStr:String?      // 埋点商家id
    @objc var couponTemplateId: String?   // 查看更多优惠券商品入参
    @objc dynamic var selectedAssortId: String? // 类目id
    // 默认为非店铺内的商品搜索...<v3.9.5>（true代表店铺内搜索）
    @objc dynamic var shopProductSearch: Bool = false
    //shop:搜索店铺  Product：搜索商品
    @objc var searchResultType: String?
    //进入搜索的路径
    @objc var searchFromType: String?
    // 搜索推荐关键词时的传参
    @objc var nature: String?
    
    
    // MARK: - LifeCircle
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addPullToRefresh(actionHandler: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.hasNextPage() {
                // 未加载完毕...<上拉加载更多>
                strongSelf.getAllData(false)
            } else {
                // 全部加载完毕
                strongSelf.dismissAnimation()
            }
            }, position: .bottom)
        self.tableView.pullToRefreshView.setCustom(FKYPullToRefreshStateView.fky_footerView(with: .stopped), for: .stopped)
        self.tableView.pullToRefreshView.setCustom(FKYPullToRefreshStateView.fky_footerView(with: .triggered), for: .triggered)
        self.tableView.pullToRefreshView.setCustom(FKYPullToRefreshStateView.fky_footerView(with: .loading), for: .loading)
        self.searchResultProvider.refreshTableViewAction = { [weak self]  in
            if let strongSelf = self {
                strongSelf.tableView.reloadData()
            }
        }
        FKYFilterSearchServicesModel.shared.sellerSelectedList.removeAll()
        
        // 请求数据
        self.getAllData(true)
        // 登录成功后刷新数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataAfterLogin), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        
        //埋点专用
        if let jbpShopID = self.jbpShopID,jbpShopID.isEmpty == false{
            //聚宝盆专区
            self.itemContentStr = jbpShopID
        } else if let yflId = self.yflShopID,yflId.isEmpty == false {
            //药福利id
            self.itemContentStr = yflId
        }else{
            // 商家id
            if nil != self.sellerCode {
                self.itemContentStr =  "\(self.sellerCode ?? 0)"
            }
        }
        //店铺内或者专区或药福利搜索不展示钩子商品
        if (self.jbpShopID != nil && self.jbpShopID!.isEmpty == false)||(self.yflShopID != nil && self.yflShopID!.isEmpty == false)||(self.sellerCode != nil && (String(format:"\(self.sellerCode ?? 0)")).isEmpty == false){
            self.searchResultProvider.isNormalSearch = false
        }else{
            self.searchResultProvider.isNormalSearch = true
            //请求店铺信息
            self.getSearchShopHeadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //删除存储高度
        cellHeightManager.removeAllContentCellHeight()
        // 同步购物车商品数量
        self.getCartNumber()
        // 购物车badge
        self.changeBadgeNumber(true)
        if self.isFromScanVC == true {
            self.emptyVC.barCode = self.barCode
        }else{
            self.emptyVC.barCode = ""
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sectionHeadFilter.hidePopView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("内存不足")
    }
    
    deinit {
        // 移除通知
        self.dismissLoading()
        print("FKYSearchResultVC deinit>>>>>>>")
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        //self.view.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        self.navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            }else{
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
            }()
        
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            // 返回
            if let strongSelf = self {
                strongSelf.sectionHeadFilter.hidePopView()
                FKYNavigator.shared().pop()
                //                if strongSelf.keyWordSoruceType == 1{// 扫码搜索
                //                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "搜索栏", itemId: "I8010", itemPosition: "1", itemName: "返回", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
                //                }else if strongSelf.keyWordSoruceType == 0{// 关键词搜索
                //
                //                }
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "搜索栏", itemId: ITEMCODE.SEARCHRESULT_BAR_CLICK_CODE.rawValue, itemPosition: "0", itemName: "返回", itemContent: strongSelf.itemContentStr, itemTitle: nil, extendParams: strongSelf.getBI_KeyWord(), viewController: strongSelf)
                
            }
        }
        self.fky_setupRightImage("icon_cart_new") {[weak self] in
            // 购物车
            if let strongSelf = self {
                strongSelf.sectionHeadFilter.hidePopView()
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "搜索栏", itemId: ITEMCODE.SEARCHRESULT_BAR_CLICK_CODE.rawValue, itemPosition: "2", itemName: "购物车", itemContent: strongSelf.itemContentStr, itemTitle: nil, extendParams: strongSelf.getBI_KeyWord(), viewController: self)
                FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
                    let v = vc as! FKY_ShopCart
                    v.canBack = true
                }, isModal: false)
            }
            
        }
        
        let bv = JSBadgeView(parentView: self.NavigationBarRightImage, alignment: .topRight)
        bv?.badgePositionAdjustment = CGPoint(x: WH(-3), y: WH(3))
        bv?.badgeTextFont = UIFont.systemFont(ofSize: WH(11))
        bv?.badgeBackgroundColor = RGBColor(0xFF2D5C)
        self.badgeView = bv
        
        let searchbar = FSearchBar()
        searchbar.initCommonSearchItem()
        searchbar.text = keyword ?? ""
        searchbar.delegate = self
        searchbar.placeholder = "药品名/拼音缩写/批准文号/厂家"
        self.navBar?.addSubview(searchbar)
        searchbar.snp.makeConstraints({[weak self] (make) in
            if let strongSelf = self {
                make.centerX.equalTo(strongSelf.navBar!)
                make.bottom.equalTo(strongSelf.navBar!.snp.bottom).offset(WH(-8))
                make.left.equalTo(strongSelf.navBar!.snp.left).offset(WH(51))
                make.right.equalTo(strongSelf.navBar!.snp.right).offset(-WH(50))
                make.height.equalTo(WH(32))
            }
        })
        self.searchBar = searchbar
        
        //调整左右按钮
        self.NavigationBarRightImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo((self.searchBar?.snp.centerY)!)
            make.right.equalTo(self.navBar!.snp.right).offset(-WH(14))
        })
        self.NavigationBarLeftImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo((self.searchBar?.snp.centerY)!)
            make.left.equalTo(self.navBar!.snp.left).offset(WH(9))
            make.width.height.equalTo(WH(30))
        })
        
        // 空态视图
        if searchResultType == "Shop" {
            // 店铺
            let viewEmpty = FKYCommonEmptyView()
            viewEmpty.emptyType = .shop
            self.view.addSubview(viewEmpty)
            viewEmpty.snp.makeConstraints({[weak self] (make) in
                if let strongSelf = self {
                    if searchResultType == "Shop" || strongSelf.shopProductSearch {
                        // 店铺
                        make.top.equalTo(strongSelf.navBar!.snp.bottom)
                    }
                    else {
                        // 不遮盖collectionView的前两个sectionheaderView（筛选）
                        make.top.equalTo(strongSelf.navBar!.snp.bottom).offset(WH(60))
                    }
                    make.left.right.bottom.equalTo(strongSelf.view)
                }
            })
            self.view.sendSubviewToBack(viewEmpty)
            viewEmpty.isHidden = true
            emptyViewForShop = viewEmpty
        }
        else {
            // 商品
            self.view.addSubview(self.noProductView)
            self.noProductView.snp.makeConstraints({(make) in
                //                if self.shopProductSearch  {
                //                    // 店铺内搜索
                //                    make.top.equalTo(self.navBar!.snp.bottom)
                //                }
                //                else {
                //                    //不遮盖collectionView的前两个sectionheaderView（筛选）
                //                    make.top.equalTo(self.navBar!.snp.bottom).offset(WH(40))
                //                }
                make.top.equalTo(self.navBar!.snp.bottom)
                make.left.right.bottom.equalTo(self.view)
            })
        }
        // iPhone X适配
        var marginBottom: CGFloat = 0
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                marginBottom = iPhoneX_SafeArea_BottomInset
            }
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.navBar!.snp.bottom)
            make.bottom.equalTo(self.view).offset(-marginBottom)
        })
        //self.collectionView = cv
        //专区搜索 药福利搜索 店铺内所搜和 低匹配召回 设置 筛选距底部高度
        if ((self.jbpShopID != nil && self.jbpShopID!.isEmpty == false)||(self.yflShopID != nil && self.yflShopID!.isEmpty == false)||(self.sellerCode != nil && (String(format:"\(self.sellerCode ?? 0)")).isEmpty == false) || self.searchResultProvider.recallStatus == "2"){
            tableHeadHeight = 0
        }
        if let totalPage = self.totalPage {
            lblPageCount.text = String.init(format: "%zi/%zi", (nowPage > totalPage) ? totalPage:nowPage, totalPage)
            lblPageCount.isHidden = false
        }
        self.view.addSubview(lblPageCount);
        let pageToBottom:CGFloat = 12
        lblPageCount.snp.makeConstraints({[weak self] (make) in
            if let strongSelf = self {
                make.centerX.equalTo(strongSelf.view.snp.centerX)
                make.bottom.equalTo(strongSelf.view.snp.bottom).offset(-WH(pageToBottom)-bootSaveHeight())
                make.height.equalTo(LBLABEL_H)
                make.width.lessThanOrEqualTo(SCREEN_WIDTH-100)
            }
        })
        
        self.toTopButton.addTarget(self, action: #selector(onBtnToTop(_:)), for: .touchUpInside)
        self.view.addSubview(self.toTopButton)
        self.view.bringSubviewToFront(self.toTopButton)
        self.toTopButton.snp.makeConstraints({ (make) in
            make.right.equalTo(self.view.snp.right).offset(-WH(20))
            make.bottom.equalTo(self.view.snp.bottom).offset(-WH(40))
            make.width.height.equalTo(WH(30))
        })
    }
    
    
    //MARK: - Action
    
    @objc func onBtnToTop(_ sender: UITextField) {
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.lblPageCount.text = String.init(format: "1/%zi", self.totalPage!)
    }
    
    func addAlertView(_ product:HomeProductModel) {
        FKYProductAlertView.show(withTitle: nil, leftTitle: "取消", rightTitle: "确定", message: "确定加入渠道", handler: { [weak self] (_,isRight) in
            if let strongSelf = self {
                if isRight  {
                    strongSelf.searchResultProvider.addToChannl(product.productId,venderId: "\(product.vendorId)", callback: { [weak self]
                        (message) in
                        if let strongInSelf = self{
                            strongInSelf.toast(message)
                        }
                    })
                    //strongSelf.BI_Record(.PRODUCTRESULT_YC_JOINCHANNEL)
                }
            }
        })
    }
    
    
    //MARK: - Private
    
    // 修改购物车显示数量
    func changeBadgeNumber(_ isdelay: Bool) {
        var deadline: DispatchTime
        if  isdelay {
            deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        }else {
            deadline = DispatchTime.now()
        }
        
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
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
    
    // 分页索引更新
    private func hasNextPage() -> Bool {
        self.nowPage = self.nowPage + 1
        return self.nowPage <= self.totalPage
    }
    
    //
    func dismissAnimation() {
        let time: TimeInterval = 1
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + time)) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tableView.pullToRefreshView.stopAnimating()
        }
    }
    
    // 刷新购物车
    func reloadViewWithBackFromCart() {
        let dataSource:[Any] = self.searchResultProvider.productList as! [Any]
        self.searchResultProvider.productList?.removeAllObjects()
        for product in dataSource {
            if let model = product as?  HomeProductModel{
                if FKYCartModel.shareInstance().productArr.count > 0 {
                    for cartModel  in FKYCartModel.shareInstance().productArr {
                        if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                            if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == model.productId && cartOfInfoModel.supplyId.intValue == Int(model.vendorId) {
                                model.carOfCount = cartOfInfoModel.buyNum.intValue
                                model.carId = cartOfInfoModel.cartId.intValue
                                break
                            } else {
                                model.carOfCount = 0
                                model.carId = 0
                            }
                        }
                    }
                }else {
                    model.carOfCount = 0
                    model.carId = 0
                }
            }
            self.searchResultProvider.productList?.add(product)
        }
        self.tableView.reloadData()
    }
    
    //
    private func observeCollectionViewIndex(_ index: Int) {
        if searchResultType == "Shop" {
            // 店铺
            return
        }
        
        if let totalPage = self.totalPage {
            lblPageCount.text = String.init(format: "%zi/%zi", (index > totalPage) ? totalPage:index, totalPage)
            lblPageCount.isHidden = false
        }
    }
    
    // 清空所有筛选条件
    fileprivate func resetAllFilter() {
        resetFilterForFactoryAndSpec()
    }
    
    // 清空已有的筛选条件...<仅清空生产厂家的规格>
    fileprivate func resetFilterForFactoryAndSpec() {
        // 清空数据
        self.chooseFactoryName.removeAll()
        self.chooseRankName.removeAll()
        // 更新UI
        self.sectionHeadFilter.updateFactoryStates()
    }
    
    
    //MARK: - Notification
    
    @objc func reloadDataAfterLogin() {
        self.getAllData(true)
        if self.searchResultProvider.isNormalSearch == true{
            self.getSearchShopHeadData()
        }
        
    }
}

//MARK: - view响应事件
//extension FKYSearchResultVC {
//    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
//        if eventName == FKY_comfirmFactoryFiltrate{// 通过生产厂家筛选商品列表
//            let factoryList = userInfo[FKYUserParameterKey] as! [SerachFactorysInfoModel]
//            self.chooseFactoryName = factoryList
//            self.requestRankList()
//            self.getProductDataWithpriceSeq(self.priceSeq)
//        }
//    }
//}

//MARK: - 弹出筛选条件
extension FKYSearchResultVC {
    
    /// 拼接查询厂家和规格列表的参数
    func apendFactoryAndRanksListParam() -> [String: String]{
        var dic = [String: String]()
        if self.couponTemplateId != nil, self.couponTemplateId?.count > 0 {
            // 搜索查看可用优惠券商品列表入参
            dic["templateId"] = self.couponTemplateId
        }
        dic["keyword"] = self.keyword
        dic["buyerCode"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        dic["roleId"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentRoleId()
        dic["userType"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserType()
        
        if let spuCode = self.spuCode {
            dic["spuCode"] = spuCode
        }
        if nil != self.product_name {
            dic["product_name"] = self.product_name
        }
        if nil != self.sellerCode {
            dic["sellerCode"] = "\(String(describing: self.sellerCode))"
        }
        if nil != self.selectedAssortId {
            dic["product2ndLMCode"] = self.selectedAssortId
        }
        
        //筛选条件
        //价格/默认/店月数筛选条件
        if self.priceSeq ==  PriceRangeEnum.SALES.rawValue {
            dic["sortMode"] = "default"
        }else {
            dic["sortMode"] = self.priceSeq //价格排序
        }
        dic["sortColumn"] = self.sortColumn //扩展字段
        /// 自营标签
        if self.shopSort == ShopSortEnum.ALLSHOP.rawValue {
            dic["sellerFilterMode"] = "0"
        }else{
            dic["sellerFilterMode"] = "1"
        }
        //是否有货筛选标签
        if self.stockSeq == StockStateEnum.HAVE.rawValue {
            dic["haveGoodsTag"] = "true"
        }else{
            dic["haveGoodsTag"] = nil
        }
        
        /// 加入筛选的商家
        var sellerCodes: String = ""
        for (index, item) in self.chooseSellersName.enumerated() {
            if index == 0 {
                sellerCodes = sellerCodes + String(item.sellerCode!)
            }else{
                sellerCodes = sellerCodes + "," + String(item.sellerCode!)
            }
        }
        dic["sellerCodes"] = sellerCodes
        
        /// 加入商品规格
        var specs:String = ""
        for (index, item) in self.chooseRankName.enumerated() {
            if let rankStr = item.rankName {
                if index == 0{
                    specs = specs + String(rankStr)
                }else{
                    specs =  specs + "," + String(rankStr)
                }
            }
        }
        dic["specs"] = specs
        
        /// 加入筛选的厂家
        var factoryIds:String = ""
        for (index, item) in self.chooseFactoryName.enumerated() {
            if index == 0{
                factoryIds = factoryIds + String(item.factoryId!)
            }else{
                factoryIds =  factoryIds + "," + String(item.factoryId!)
            }
        }
        dic["factoryIds"] = factoryIds
        dic["barCode"] = self.barCode
        return dic
    }
    
    //筛选生产厂家和规格包装
    func popFactorysAndRankView(_ sectionCell: FKYReusableHeader) {
        //    func popFactorysAndRankView() {
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "筛选栏", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue, itemPosition: "5", itemName: "筛选", itemContent: self.itemContentStr, itemTitle: nil, extendParams: nil, viewController: self)
        
        // 传参
        let dic = NSMutableDictionary()
        if self.couponTemplateId != nil, self.couponTemplateId?.count > 0 {
            // 搜索查看可用优惠券商品列表入参
            dic["templateId"] = self.couponTemplateId
        }
        dic["keyword"] = self.keyword
        dic["buyerCode"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        dic["roleId"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentRoleId()
        dic["userType"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserType()
        
        if let spuCode = self.spuCode {
            dic["spuCode"] = spuCode
        }
        if nil != self.product_name {
            dic["product_name"] = self.product_name
        }
        if nil != self.sellerCode {
            dic["sellerCode"] = self.sellerCode
        }
        if nil != self.selectedAssortId {
            dic["product2ndLMCode"] = self.selectedAssortId
        }
        
        //筛选条件
        //价格/默认/店月数筛选条件
        if self.priceSeq ==  PriceRangeEnum.SALES.rawValue {
            dic["sortMode"] = "default"
        }else {
            dic["sortMode"] = self.priceSeq //价格排序
        }
        dic["sortColumn"] = self.sortColumn //扩展字段
        /// 自营标签
        if self.shopSort == ShopSortEnum.ALLSHOP.rawValue {
            dic["sellerFilterMode"] = "0"
        }else{
            dic["sellerFilterMode"] = "1"
        }
        //是否有货筛选标签
        if self.stockSeq == StockStateEnum.HAVE.rawValue {
            dic["haveGoodsTag"] = "true"
        }else{
            dic["haveGoodsTag"] = nil
        }
        
        /// 加入筛选的商家
        var sellerCodes: String = ""
        for (index, item) in self.chooseSellersName.enumerated() {
            if index == 0 {
                sellerCodes = sellerCodes + String(item.sellerCode!)
            }else{
                sellerCodes = sellerCodes + "," + String(item.sellerCode!)
            }
        }
        dic["sellerCodes"] = sellerCodes
        
        /// 加入商品规格
        var specs:String = ""
        for (index, item) in self.chooseRankName.enumerated() {
            if let rankStr = item.rankName {
                if index == 0{
                    specs = specs + String(rankStr)
                }else{
                    specs =  specs + "," + String(rankStr)
                }
            }
        }
        dic["specs"] = specs as AnyObject
        
        /// 加入筛选的厂家
        var factoryIds:String = ""
        for (index, item) in self.chooseFactoryName.enumerated() {
            if index == 0{
                factoryIds = factoryIds + String(item.factoryId!)
            }else{
                factoryIds =  factoryIds + "," + String(item.factoryId!)
            }
        }
        dic["factoryIds"] = factoryIds as AnyObject
        
        
        // 厂家筛选 选择
        let factoryListVC = FKYFactoryFliterForSearchResultVC()
        factoryListVC.dicAPIParam = NSDictionary.init(dictionary: dic) as? [String : AnyObject]
        if let str = self.sellerCode {
            factoryListVC.itemContentStr = "\(str)"
        }
        //初始化选择的生产厂家和商品规格
        factoryListVC.currentSelected = self.chooseFactoryName
        factoryListVC.currentRankSelected = self.chooseRankName
        factoryListVC.factoryContentMode = self.factoryContentMode
        factoryListVC.rankContentMode = self.rankContentMode
        
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, true, UIScreen.main.scale)
        self.view.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: true)
        let snapImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if nil != snapImg {
            factoryListVC.setScreenCaptureImageForBackground(snapImg!)
        }
        
        
        
        
        factoryListVC.filterResultWithFactoryAction = { [weak self] (factoryName,rankName,factoryContentMode,rankContentMode) in
            if let strongSelf = self {
                strongSelf.factoryContentMode = factoryContentMode
                strongSelf.rankContentMode = rankContentMode
                if nil == factoryName && rankName == nil {
                    sectionCell.desFactoryNameFliterAction()
                }else {
                    strongSelf.chooseFactoryName = factoryName!
                    strongSelf.chooseRankName = rankName!
                    strongSelf.nowPage = 1
                    strongSelf.searchResultProvider.productList?.removeAllObjects()
                    strongSelf.requestSellerListInfo()
                    strongSelf.getProductDataWithpriceSeq(strongSelf.priceSeq)
                }
                //未选择生产厂家和商品规格更新状态
                if strongSelf.chooseFactoryName.count == 0 && strongSelf.chooseRankName.count == 0 {
                    sectionCell.updateFactoryStates()
                }
            }
        }
        FKYNavigator.shared().topNavigationController.pushViewController(factoryListVC, animated: false, snapshotFirst: false)
    }
    
    //判断是否有筛选条件
    func hasSiftConditions(_ dic: NSDictionary) -> Bool {
        // 通用商品搜索
        if self.searchResultType != "Shop" {
            //有筛选条件的全部商品
            if self.priceSeq == PriceRangeEnum.NONE.rawValue, self.selectedPriceDefault == true {
                //选中默认
                return true
            }else if self.priceSeq != PriceRangeEnum.NONE.rawValue  {
                //选中其他的条件
                return true
            }
            // 此筛选条件已经去掉
            //            if self.shopSort != ShopSortEnum.ALLSHOP.rawValue {
            //                return true
            //            }
            //此筛选条件已经去掉
            //            if self.stockSeq != StockStateEnum.ALL.rawValue {
            //                return true
            //            }
            //商家id
            if let sellerCodes = dic["sellerCodes"] as? String, sellerCodes.count > 0 {
                return true
            }
            //生产厂家id
            if let factoryIds = dic["factoryIds"] as? String, factoryIds.count > 0 {
                return true
            }
            //商品规格
            if let specs = dic["specs"] as? String, specs.count > 0 {
                return true
            }
            return false
        }
        return false
    }
}


// MARK: - 加车埋点相关
extension FKYSearchResultVC {
    // 更新
    func refreshItemOfCollection(_ section: IndexPath?) {
        if searchResultType == "Shop" {
            // 店铺
            self.tableView.reloadData()
            return
        }
        //刷新商品
        if let selectSection = section ,selectSection.row >= 0,let selectRow = self.tableView.cellForRow(at: selectSection){
            self.tableView.reloadRows(at: [selectSection], with: .none)
        }
    }
    
    //埋点
    func addNewBI_Record(_ product: HomeProductModel,_ itemtPosition:Int,_ type:Int) {
        var itemId : String?
        var itemName:String?
        var itemContent : String?
        if type == 1 {
            itemId = "I9998" //点击商品cell
            itemName = "点进商详"
        }else if type == 2 {
            itemId = "I9999" //加车
            itemName = "加车"
        } else if type == 3{
            itemId = "I9996" //点进JBP专区
            itemName = "点进JBP专区"
        }else{
            itemId = "I9997" //点进JBP专区
            itemName = "点进店铺"
        }
        
        if product.vendorId != 0 {
            itemContent = "\(product.vendorId)|\(product.productId )"
        }
        
        var extendParams:[String :AnyObject] = ["keyword" : "\(self.keyword ?? "")" as AnyObject]
        extendParams["pm_price"] = product.pm_price as AnyObject?
        extendParams["storage"] = product.storage as AnyObject?
        extendParams["pm_pmtn_type"] = product.pm_pmtn_type as AnyObject?
        for (key, value) in self.getBI_KeyWord() {
            extendParams[key] = value
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S9002", sectionPosition: "1", sectionName: "商品列表", itemId: itemId, itemPosition: "\(itemtPosition)", itemName: itemName, itemContent:itemContent , itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = couponTemplateId == nil ? HomeString.SEARCH_ADD_SOURCE_TYPE :HomeString.YHQ_ADD_SOURCE_TYPE
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
}



// MARK: - 搜索框FSearchBarDelegate
extension FKYSearchResultVC {
    func fsearchBar(_ searchBar: FSearchBar, search: String?) {
        //
    }
    
    func fsearchBar(_ searchBar: FSearchBar, textDidChange: String?) {
        print("textChange\(String(describing: textDidChange))")
    }
    
    func fsearchBar(_ searchBar: FSearchBar, touches: String?) {
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "搜索栏", itemId: ITEMCODE.SEARCHRESULT_BAR_CLICK_CODE.rawValue, itemPosition: "1", itemName: "搜索框", itemContent: self.itemContentStr, itemTitle: nil, extendParams: self.getBI_KeyWord(), viewController: self)
        self.sectionHeadFilter.hidePopView()
        FKYNavigator.shared()?.pop()
        /*
        FKYNavigator.shared().openScheme(FKY_Search.self, setProperty: {[weak self] (svc) in
            if let strongSelf = self {
                let searchVC = svc as! FKYSearchViewController
                searchVC.vcSourceType = .common
                searchVC.searchFromType = .fromCommon
                if strongSelf.shopProductSearch {
                    searchVC.vcSourceType = .pilot
                }
            }
        })
        */
        
        /*
        FKYNavigator.shared().openScheme(FKY_NewSearch.self, setProperty: {[weak self] (svc) in
            if let strongSelf = self {
                let searchInputVC = svc as! FKYSearchInputKeyWordVC
                searchInputVC.switchViewType = 1
                searchInputVC.searchType = 1
                if strongSelf.shopProductSearch {
                    searchInputVC.searchType = 3
                    searchInputVC.switchViewType = 2
                }
            }
        })
        */
    }
}


//MARK: - Request
extension FKYSearchResultVC {
    
    /// 获取最新的厂家和规格信息
    func updataFactoryAndRankSInfo(){
        self.requestFactoryList()
        self.requestRankList()
    }
    
    /// 查询厂家列表
    func requestFactoryList(){
        var param = self.apendFactoryAndRanksListParam()
        param["factoryIds"] = "" //选择厂家和当前选中的厂家无关系
        SearchFactoryName.shared.getFactoryFliterList(param, callback: { [weak self] (factoryList) in
            if let strongSelf = self {
                /// 记录选中状态
                for factory in strongSelf.chooseFactoryName {
                    for factory_new in SearchFactoryName.shared.factoryList{
                        if factory.factoryId == factory_new.factoryId{
                            factory_new.isSelected = factory.isSelected
                        }
                    }
                }
            }
        }) {
            
        }
    }
    
    /// 查询规格列表
    func requestRankList(){
        var param = self.apendFactoryAndRanksListParam()
        param["specs"] = "" //选择规格和当前选中的规格无关系
        SearchFactoryName.shared.getProductRanksList(param) { [weak self] (rankList, msg) in
            if let strongSelf = self {
                if msg != nil {
                    strongSelf.toast(msg)
                }else{
                    /// 记录选中状态
                    for rank in strongSelf.chooseRankName{
                        for rank_new in SearchFactoryName.shared.rankList{
                            if rank.rankName == rank_new.rankName{
                                rank_new.isSelected = rank.isSelected
                            }
                        }
                    }
                }
                // strongSelf.dismissLoading()
            }
        }
    }
    
    // 同步购物车商品数量
    fileprivate func getCartNumber() {
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ [weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.searchResultType != "Shop" {
                // 商品
                if strongSelf.searchResultProvider.productList?.count > 0 {
                    strongSelf.reloadViewWithBackFromCart()
                }
                else {
                    // 刷新搜索常够清单的购物车数据
                    if let jbpShopID = strongSelf.jbpShopID,jbpShopID.isEmpty == false{
                        //聚宝盆专区
                        strongSelf.jbpEmptyVC.refreshAllProductTableView()
                    }else{
                        strongSelf.emptyVC.refreshCurrectViewDataBackFromCar()
                    }
                    
                }
            }
            // 更新
            strongSelf.changeBadgeNumber(false)
        }) { [weak self] (reason) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.toast(reason)
        }
    }
    //请求顶部店铺信息
    fileprivate func getSearchShopHeadData(){
        self.searchResultProvider.getSearcheMainShop(nil, callback: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.searchResultProvider.tableHeadHeight = SearchShopInfoCell.getCellContentHeight(strongSelf.searchResultProvider.searchShopModel)
            strongSelf.tableView.reloadData()
        })
    }
    // 请求数据...<搜店铺or搜商品>
    fileprivate func getAllData(_ isRefresh: Bool) {
        if (isRefresh == true) {
            // 刷新
            self.showLoading()
            self.searchResultProvider.productList?.removeAllObjects()
            self.searchResultProvider.suggestWords.removeAll()
            self.searchShopProvider.shopList.removeAll()
            self.nowPage = 1
        }
        
        // 请求数据
        if self.searchResultType == "Shop" {
            // 店铺...<搜店铺>
            self.getShopDataWithType("")
        }
        else {
            // 商品...<搜商品>
            self.getProductDataWithpriceSeq(self.priceSeq)
            
            // 店铺内不需要请求商家
            if self.shopProductSearch == false {
                // 非店铺内商品搜索...<通用的商品搜索>
                self.requestSellerListInfo()
            }
            //更新厂家和规格列表
           self.updataFactoryAndRankSInfo()
        }
        //
        self.dismissAnimation()
    }
    
    // 获取店铺列表...<搜店铺>
    fileprivate func getShopDataWithType(_ type : String) -> () {
        var para = ["keyword": keyword ?? "", "typeId": "", "nowPage": String(nowPage), "per": String(5), "isSearch": "yes", "queryAll": "no"]
        if !type.isEmpty {
            para["typeId"] = type
        }
        self.showLoading()
        self.searchShopProvider.getSearchShopList(para as [String : AnyObject], callback: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            //
            strongSelf.dismissLoading()
            if strongSelf.searchShopProvider.shopList.count > 0 {
                // 有商家列表
                strongSelf.totalPage = strongSelf.searchShopProvider.totalPage
                strongSelf.tableView.reloadData()
                strongSelf.emptyViewForShop!.isHidden = true
            }
            else {
                // 无数据
                if strongSelf.nowPage == 1 {
                    // 加载首页
                    strongSelf.view.bringSubviewToFront(strongSelf.emptyViewForShop!)
                    strongSelf.emptyViewForShop!.isHidden = false
                }
                else {
                    // 非首页
                    strongSelf.nowPage = strongSelf.nowPage - 1
                }
            }
        })
    }
    
    // 获取商品列表...<搜商品>
    fileprivate func getProductDataWithpriceSeq(_ type: String) {
        // 入参
        let dic = NSMutableDictionary()
        
        // 个性入参
        if couponTemplateId != nil, couponTemplateId?.count > 0 {
            // 搜索查看可用优惠券商品列表入参
            dic["templateId"] = couponTemplateId
        }
        
        // 搜索关键字商品列表入参
        if let keyword = self.keyword {
            dic["keyword"] = keyword
        } else {
            dic["keyword"] = ""
        }
        
        if let spuCode = self.spuCode {
            dic["spuCode"] = spuCode
        }
        
        // 搜索推荐关键词时需新增的字段
        if let txt = self.nature, txt.isEmpty == false {
            dic["nature"] = txt
        }
        
        if (product_name != nil), product_name?.count > 0 {
            dic["product_name"] = product_name
        }
        if (selectedAssortId != nil), selectedAssortId?.count > 0 {
            dic["product2ndLMCode"] = selectedAssortId
        }
        dic["buyerCode"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        dic["roleId"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentRoleId()
        dic["userType"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserType()
        
        if let jbpShopID = self.jbpShopID,jbpShopID.isEmpty == false{
            //聚宝盆专区
            dic["sellerCode"] = jbpShopID
        }else{
            // 商家id
            if nil != self.sellerCode {
                dic["sellerCode"] = self.sellerCode
            }
        }
        if let yflId = self.yflShopID,yflId.isEmpty == false {
            //药福利<药福利需要传真实id>
            dic["reqScene"] = "flszq_search"
        }
        
        /// 扫码搜索入参
        dic["barCode"] = self.barCode
        
        //筛选条件
        dic["sortColumn"] = self.sortColumn //扩展字段
        if type.count > 0 {
            if self.priceSeq ==  PriceRangeEnum.SALES.rawValue {
                dic["sortMode"] = "default"
            }else {
                dic["sortMode"] = type //价格排序
            }
        }
        
        //自营标签
        if self.shopSort == ShopSortEnum.ALLSHOP.rawValue {
            dic["sellerFilterMode"] = "0"
        }else{
            dic["sellerFilterMode"] = "1"
        }
        
        //是否有货
        if self.stockSeq == StockStateEnum.HAVE.rawValue {
            dic["haveGoodsTag"] = "true"
        }else{
            dic["haveGoodsTag"] = nil
        }
        
        var factoryIds: String = "" //生产厂家id
        var sellerCodes: String = "" //商家id
        var specs: String = "" //商品规格
        
        // 厂家列表
        for (index, item) in self.chooseFactoryName.enumerated() {
            if index == 0{
                factoryIds = factoryIds + String(item.factoryId!)
            }else{
                factoryIds =  factoryIds + "," + String(item.factoryId!)
            }
        }
        dic["factoryIds"] = factoryIds
        
        // 规格列表
        for (index, item) in self.chooseRankName.enumerated() {
            if let rankStr = item.rankName {
                if index == 0{
                    specs = specs + String(rankStr)
                }else{
                    specs =  specs + "," + String(rankStr)
                }
            }
        }
        dic["specs"] = specs
        
        // 商家列表
        for (index, item) in self.chooseSellersName.enumerated() {
            if index == 0 {
                sellerCodes = sellerCodes + String(item.sellerCode!)
            }else{
                sellerCodes =  sellerCodes + "," + String(item.sellerCode!)
            }
        }
        dic["sellerCodes"] = sellerCodes
        
        //分享库存新增字段
        if self.searchFromType == "fromShop"{
            dic["from"] = String(2)
        }else if self.searchFromType == "fromCommon"{
            dic["from"] = String(1)
        }
        dic["ver"] = String(1)
        dic["stock_mode"] = String(1)
        
        // 通用入参
        dic["nowPage"] = String(nowPage)
        dic["per"] = String(10)
        
        // 最终入参
        let paraDic = NSDictionary.init(dictionary: dic)
        
        self.showLoading()
        self.searchResultProvider.getProductList(paraDic as? [String : AnyObject], callback: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            // 请求完成
            strongSelf.dismissLoading()
            if strongSelf.searchResultProvider.recallStatus == "5"{//0搜词
                strongSelf.searchBarkeyword =  strongSelf.keyword ?? ""
                strongSelf.keyword = strongSelf.searchResultProvider.newKeyWord
                strongSelf.requestSellerListInfo()
                strongSelf.updataFactoryAndRankSInfo()
            }
            if strongSelf.searchResultProvider.recallStatus == "1"{//只有高分才展示搜索数量
                if strongSelf.keyWordSoruceType == 0 {// 用户输入关键词搜索
                    strongSelf.searchBar?.text = (strongSelf.keyword ?? "") + "(\(strongSelf.searchResultProvider.totalCount ?? 0))"
                }else if strongSelf.keyWordSoruceType == 1{// 扫码搜索条码
                    strongSelf.searchBar?.text = strongSelf.barCode + "(\(strongSelf.searchResultProvider.totalCount ?? 0))"
                }
                
            }else{
                if strongSelf.keyWordSoruceType == 0 {// 用户输入关键词搜索
                    strongSelf.searchBar?.text = strongSelf.searchBarkeyword.isEmpty == false ? strongSelf.searchBarkeyword:(strongSelf.keyword ?? "")
                }else if strongSelf.keyWordSoruceType == 1{// 扫码搜索条码
                    strongSelf.searchBar?.text = strongSelf.barCode
                }
            }
            strongSelf.totalPage = strongSelf.searchResultProvider.totalPage
            if strongSelf.nowPage == 1 {
                strongSelf.BI_NEW(strongSelf.searchResultProvider.totalCount ?? 0)
            }
            if strongSelf.searchResultProvider.productList?.count > 0 {
                // 有数据
                strongSelf.view.bringSubviewToFront(strongSelf.tableView)
                strongSelf.view.bringSubviewToFront(strongSelf.lblPageCount)
                strongSelf.tableView.isScrollEnabled = true
                strongSelf.tableView.reloadData()
                strongSelf.noProductView.isHidden = true
                
                if let totalPage = strongSelf.totalPage, strongSelf.nowPage == 1 {
                    strongSelf.lblPageCount.text = String.init(format: "%zi/%zi", (strongSelf.nowPage > totalPage) ? totalPage:strongSelf.nowPage, totalPage)
                    strongSelf.lblPageCount.isHidden = false
                }
                // 第一页
                if strongSelf.nowPage == 1 {
                    // 上传搜索结果
                    strongSelf.sendSearchData(strongSelf.searchResultProvider.productList![0] as! HomeProductModel)
                }
            }
            else {
                // 无数据
                //if strongSelf.shopProductSearch == false {
                //                // 通用的商品搜索
                //                if strongSelf.hasSiftConditions(paraDic) == true {
                //                    // 有筛选条件...<显示>
                //                    strongSelf.noProductView.snp.updateConstraints({ (make) in
                //                        make.top.equalTo(strongSelf.navBar!.snp.bottom)
                //                    })
                //                }
                //                else {
                //                    // 无筛选条件...<隐藏>
                //                    strongSelf.noProductView.snp.updateConstraints({ (make) in
                //                        make.top.equalTo(strongSelf.navBar!.snp.bottom).offset(WH(0))
                //                    })
                //                }
                // }
                //else {
                // 店铺内的商品搜索...<无筛选条件视图>
                //}
                
                // 更新
                var listSuggest = [SearchSuggestModel]()
                if  strongSelf.searchResultProvider.suggestWords.count > 0 {
                    listSuggest.append(contentsOf: strongSelf.searchResultProvider.suggestWords)
                }
                if let jbpShopID = strongSelf.jbpShopID,jbpShopID.isEmpty == false{
                    //聚宝盆专区
                    strongSelf.jbpEmptyVC.setUpData("\(strongSelf.sellerCode ?? 0)", strongSelf.keyword)
                    strongSelf.jbpEmptyVC.extendDic =  strongSelf.getBI_KeyWord()
                }else{
                    strongSelf.emptyVC.setupData(strongSelf.keyword, listSuggest)
                    strongSelf.emptyVC.extendDic =  strongSelf.getBI_KeyWord()
                }
                strongSelf.view.bringSubviewToFront(strongSelf.noProductView)
                strongSelf.noProductView.isHidden = false
                strongSelf.tableView.isScrollEnabled = false
                strongSelf.tableView.reloadData()
                
                // 第一页
                if strongSelf.nowPage == 1 {
                    // 上传搜索数据...<搜索无结果时>
                    strongSelf.sendSearchDataForNoResult(["keyword" : strongSelf.keyword ?? ""])
                }
            }
        })
    }
    
    // 获取商家信息列表...<搜商家>
    fileprivate func requestSellerListInfo() {
        let dic = NSMutableDictionary()
        if couponTemplateId != nil, couponTemplateId?.count > 0 {
            // 搜索查看可用优惠券商品列表入参
            dic["templateId"] = couponTemplateId
        }
        dic["keyword"] = self.keyword ?? ""
        dic["buyerCode"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        dic["roleId"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentRoleId()
        dic["userType"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserType()
        
        if let spuCode = self.spuCode {
            dic["spuCode"] = spuCode
        }
        if nil != self.product_name{
            dic["product_name"] = self.product_name
        }
        if nil != self.selectedAssortId{
            dic["product2ndLMCode"] = self.selectedAssortId
        }
        
        // 商家id
        if nil != self.sellerCode {
            dic["sellerCode"] = self.sellerCode
        }
        
        //筛选条件
        //价格的升降
        if self.priceSeq ==  PriceRangeEnum.SALES.rawValue {
            dic["sortMode"] = "default"
        }else {
            dic["sortMode"] = self.priceSeq //价格排序
        }
        dic["sortColumn"] = self.sortColumn //扩展字段
        //是否有货
        if self.stockSeq == StockStateEnum.HAVE.rawValue {
            dic["haveGoodsTag"] = "true"
        }else{
            dic["haveGoodsTag"] = nil
        }
        if self.factoryNameKeyword != nil && self.chooseFactoryName.isEmpty == true{
            dic["factoryNameKeyword"] = self.factoryNameKeyword
        }
        //筛选的厂家
        var factoryIds:String = ""
        for (index, item) in self.chooseFactoryName.enumerated() {
            if index == 0{
                factoryIds = factoryIds + String(item.factoryId!)
            }else{
                factoryIds =  factoryIds + "," + String(item.factoryId!)
            }
        }
        dic["factoryIds"] = factoryIds
        //商品规格
        var specs:String = ""
        for (index, item) in self.chooseRankName.enumerated() {
            if let rankStr = item.rankName {
                if index == 0{
                    specs = specs + String(rankStr)
                }else{
                    specs =  specs + "," + String(rankStr)
                }
            }
        }
        dic["specs"] = specs // (specs as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)
        dic["barCode"] = self.barCode
        FKYFilterSearchServicesModel.shared.getSellerFliterList(dic as? [String : AnyObject])
    }
    
    // 上传搜索词第一条数据
    fileprivate func sendSearchData(_ model: HomeProductModel) {
        let dic = NSMutableDictionary()
        let userid = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserId()
        dic["buyerCode"] = userid
        if let keyword = self.keyword {
            dic["keyword"] = keyword
        } else {
            dic["keyword"] = ""
        }
        if let jbpShopID = self.jbpShopID,jbpShopID.isEmpty == false{
            //聚宝盆专区
            dic["sellerCode"] = jbpShopID
        }else{
            if model.vendorId != 0 {
                dic["sellerCode"] = model.vendorId
            } else {
                dic["sellerCode"] = ""
            }
        }
        
        //是否联想搜索 int 0-联想词, 1-普通词 必填
        if let fromWhere = self.fromWhere {
            if fromWhere == "think"{
                dic["isAssociation"] = String(0)
            }else{
                dic["isAssociation"] = String(1)
            }
        }
        else {
            dic["isAssociation"] = String(1)
        }
        if model.productId.isEmpty == false {
            dic["spuCode"] = model.productId
        } else {
            dic["spuCode"] = ""
        }
        //价格
        if let price = model.productPrice {
            dic["price"] = price
        } else {
            dic["price"] = ""
        }
        
        // 发送
        FKYRequestService.sharedInstance()?.sendSearchData(withParam: (dic as! [AnyHashable : Any]), completionBlock: { (success, error, response, model) in
            //
        })
    }
    
    // App搜索无结果或者异常时调用
    fileprivate func sendSearchDataForNoResult(_ dic: Dictionary<AnyHashable, Any>) {
        // 发送
        FKYRequestService.sharedInstance()?.sendSearchDataForNoResult(withParam: dic, completionBlock: { (success, error, response, model) in
            //
        })
    }
}
extension FKYSearchResultVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchResultType == "Shop" {
            // 店铺
            return 1
        }
        
        // 商品...<不需要像老版那样展开cell>
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResultType == "Shop" {
            // 店铺
            return self.searchShopProvider.shopList.count
        }
        if self.searchResultProvider.recallStatus == "2" && section == 0{
            return 2
        }
        if section == 0{
            return 1
        }
        // 商品
        return self.searchResultProvider.productList!.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchResultType == "Shop" {
            // MARK:店铺
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchShopListCell", for: indexPath) as!   SearchShopListCell
            if self.searchShopProvider.shopList.count > indexPath.row, let shopModel = self.searchShopProvider.shopList[indexPath.row] as? FKYShopListModel {
                cell.configCellData(shopModel)
                cell.selectionStyle = .none
                cell.showActivityNum = {[weak self] (index) in
                    if let strongSelf = self {
                        if index == 1 {
                            shopModel.showOneActivity = !shopModel.showOneActivity
                        }else if index == 2 {
                            shopModel.showTwoActivity = !shopModel.showTwoActivity
                        }else if index == 3 {
                            shopModel.showThreeActivity = !shopModel.showThreeActivity
                        }else if index == 4 {
                            shopModel.showTypeName = !shopModel.showTypeName
                        }
                        if indexPath.row <  strongSelf.searchShopProvider.shopList.count {
                            strongSelf.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                        else {
                            strongSelf.tableView.reloadData()
                        }
                    }
                }
                //商品详情
                cell.goProductDes = {[weak self](productModel, shopId,index) in
                    if let strongSelf = self {
                        strongSelf.bi_shopList(1,indexPath.row,shopModel,index)
                        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                            let v = vc as! FKY_ProdutionDetail
                            v.productionId = productModel.spuCode!
                            v.vendorId = shopId
                        }, isModal: false)
                    }
                }
            }
            //店铺详情
            cell.goShopDetail = { [weak self] (shopModel) in
                if let strongSelf = self {
                    strongSelf.bi_shopList(2,indexPath.row,shopModel)
                    FKYNavigator.shared().openScheme(FKY_ShopItem.self) { (vc) in
                        let v = vc as! FKYNewShopItemViewController
                        if let _ = shopModel.shopId {
                            v.shopId = "\(shopModel.shopId!)"
                        }
                        if let type = shopModel.type ,type == 1 {
                            v.shopType = "1"
                        }
                    }
                    
                }
            }
            return cell
        }
        if (self.searchResultProvider.recallStatus == "2" && indexPath.section == 0 && indexPath.row == 1){//第一页并且是低分召回 固定在 1-0 展示低分召回UI
            let cell = tableView.dequeueReusableCell(withIdentifier: "FKYSearchResualtLowRecallHeader", for: indexPath) as!   FKYSearchResualtLowRecallHeader
            cell.selectionStyle = .none
            return cell
        }
        if (indexPath.section == 1 && indexPath.row == 0)  {//第一页并且是低分召回 固定在 1-0 展示低分召回UI
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchZeroKeyWordCell", for: indexPath) as!    SearchZeroKeyWordCell
            cell.selectionStyle = .none
            cell.showZeroKeyWordData(self.searchResultProvider.newKeyWord,self.searchResultProvider.recallStatus == "5" && self.searchResultProvider.newKeyWord.isEmpty == false)
            return cell
        }
        
        if indexPath.section == 0 && indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchShopInfoCell", for: indexPath) as!   SearchShopInfoCell
            cell.configShopMainHeadViewData(self.searchResultProvider.searchShopModel)
            cell.selectionStyle = .none
            //进入店铺
            cell.gotoShopAction = {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.searchResultProvider.searchShopModel != nil{
                    strongSelf.sectionHeadFilter.hidePopView()
                    strongSelf.BI_ENTER_SHOP(strongSelf.searchResultProvider.searchShopModel)
                    FKYNavigator.shared().openScheme(FKY_ShopItem.self) { (vc) in
                        let v = vc as! FKYNewShopItemViewController
                        if let _ = strongSelf.searchResultProvider.searchShopModel!.enterpriseId {
                            v.shopId = "\(strongSelf.searchResultProvider.searchShopModel!.enterpriseId ?? "")"
                        }
                    }
                }
            }
            //点击轮播图埋点
            cell.clickBannerAction = {[weak self] (index,model) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.sectionHeadFilter.hidePopView()
                if strongSelf.searchResultProvider.searchShopModel != nil{
                    strongSelf.BI_CLICK_BANNER(index,model)
                    
                }
            }
            return cell
        }
        var product: HomeProductModel! = nil // 商品model
        if self.searchResultProvider.productList?.count > 0, (self.searchResultProvider.productList?.count)! >= indexPath.row{
            if let model = self.searchResultProvider.productList![indexPath.row - 1] as? HomeProductModel{
                product = model
            }else if let model = self.searchResultProvider.productList![indexPath.row - 1] as? ShopProductCellModel{
                //自营热销商品
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchGZProductInfoCell", for: indexPath) as!   SearchGZProductInfoCell
                cell.selectionStyle = .none
                cell.configCell(model)
                //查看更多
                cell.checkPromotionAction = { [weak self]  in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.BI_click_Insert_product(2,model)
                    if let _ = self {
                        FKYNavigator.shared().openScheme(FKY_Hot_Sale_Region.self, setProperty: { (vc) in
                            let controller = vc as! FKYHotSaleRegionViewController
                            controller.spuCode = model.productId ?? ""
                            controller.vcTitle = model.hotRankName ?? ""
                            controller.fromPage = .searchResult
                        }, isModal: false)
                    }
                }
                return cell
            }else if let model = self.searchResultProvider.productList![indexPath.row - 1] as? SearchMpHockProductModel{
                //mp钩子商品
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchGZProductInfoCell", for: indexPath) as!   SearchGZProductInfoCell
                cell.selectionStyle = .none
                cell.configCell(model)
                //查看更多
                cell.checkPromotionAction = { [weak self]  in
                    if let strongSelf = self {
                        strongSelf.BI_click_Insert_product(3,model)
                        FKYNavigator.shared().openScheme(FKY_ShopItemOld.self) { (vc) in
                            let shopVC = vc as! ShopItemOldViewController
                            shopVC.fromPage = .searchResult
                            if model.productType == .MZProduct{
                                //多品满折
                                shopVC.type = 5
                                //生成 FKYPromationInfoModel传到 满折专区
                                let promotionModel = FKYTranslatorHelper.translateModel(fromJSON: [:], with: FKYPromationInfoModel.self) as! FKYPromationInfoModel
                                
                                promotionModel.id = model.productPromotionInfo?.promotionId?.toNSNumber()
                                promotionModel.method = (model.productPromotionInfo?.promotionMethod ?? "0").toNSNumber()
                                promotionModel.promationDescription = model.productPromotionInfo?.promotionDesc ?? ""
                                promotionModel.limitNum = (model.productPromotionInfo?.limitNum ?? "0").toNSNumber()
                                if model.productPromotionInfo?.productPromotionRules != nil{
                                    var arr: Array<Any> = []
                                    for rulesModel  in model.productPromotionInfo!.productPromotionRules!{
                                        let cartPromotionRule  = FKYTranslatorHelper.translateModel(fromJSON: [:], with: CartPromotionRule.self) as! CartPromotionRule
                                        cartPromotionRule.promotionMinu = (rulesModel.promotionMinu ?? "0").toNSNumber()
                                        cartPromotionRule.promotionSum = (rulesModel.promotionSum ?? 0.0) as NSNumber
                                        arr.append(cartPromotionRule)
                                    }
                                    promotionModel.ruleList = arr as? [CartPromotionRule]
                                }
                                promotionModel.limitNum = (model.productPromotionInfo?.limitNum ?? "0").toNSNumber()
                                promotionModel.promotionType = (model.productPromotionInfo?.promotionType ?? "0").toNSNumber()
                                promotionModel.promotionPre = (model.productPromotionInfo?.promotionPre ?? "0").toNSNumber()
                                
                                //shopVC.promotionModel = promotionModel
                                shopVC.promotionId = model.productPromotionInfo?.promotionId
                                // strongSelf.searchResultProvider.mpGZProductModel
                            }else if model.productType == .TJProduct{
                                //特价
                                shopVC.type = 1
                                //  shopVC.promotionId = model.productPromotion?.promotionId
                            }
                            shopVC.shopId = "\(model.sellerCode ?? "")"
                            shopVC.lastModel = strongSelf.searchResultProvider.mpGZProductModel
                        }
                    }
                }
                return cell
            }
        }
        if product == nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            return cell
        }
        
        if product.productType == .MZProduct || product.productType == .TJProduct{
            //自营钩子商品
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchGZProductInfoCell", for: indexPath) as!   SearchGZProductInfoCell
            cell.selectionStyle = .none
            cell.configCell(product)
            //查看更多
            cell.checkPromotionAction = { [weak self]  in
                if let strongSelf = self {
                    strongSelf.BI_click_Insert_product(1,product)
                    FKYNavigator.shared().openScheme(FKY_ShopItemOld.self) { (vc) in
                        let shopVC = vc as! ShopItemOldViewController
                        shopVC.fromPage = .searchResult
                        if product.productType == .MZProduct{
                            //多品满折
                            shopVC.type = 5
                            if product.getMZPromotionInfo() != nil{
                                let mzPromotionModel = product.getMZPromotionInfo()!
                                //生成 FKYPromationInfoModel传到 满折专区
                                let promotionModel = FKYTranslatorHelper.translateModel(fromJSON: [:], with: FKYPromationInfoModel.self) as! FKYPromationInfoModel
                                promotionModel.id = mzPromotionModel.promotionId?.toNSNumber()
                                promotionModel.method = (mzPromotionModel.promotionMethod ?? 0) as NSNumber
                                promotionModel.promationDescription = mzPromotionModel.promotionDesc ?? ""
                                promotionModel.limitNum = mzPromotionModel.limitNum as NSNumber?
                                if mzPromotionModel.productPromotionRules != nil{
                                    var arr: Array<Any> = []
                                    for rulesModel  in mzPromotionModel.productPromotionRules!{
                                        let cartPromotionRule  = FKYTranslatorHelper.translateModel(fromJSON: [:], with: CartPromotionRule.self) as! CartPromotionRule
                                        cartPromotionRule.promotionMinu = rulesModel.promotionMinu?.toNSNumber()
                                        cartPromotionRule.promotionSum = rulesModel.promotionSum as NSNumber?
                                        arr.append(cartPromotionRule)
                                    }
                                    promotionModel.ruleList = arr as? [CartPromotionRule]
                                }
                                promotionModel.promotionType = (mzPromotionModel.promotionType ?? 0) as NSNumber
                                promotionModel.promotionPre = (mzPromotionModel.promotionPre  ?? 0) as NSNumber
                                
                                //shopVC.promotionModel = promotionModel
                                shopVC.promotionId = mzPromotionModel.promotionId
                            }
                        }else if product.productType == .TJProduct{
                            //特价
                            shopVC.type = 1
                            // shopVC.promotionId = product.productPromotion?.promotionId
                        }
                        shopVC.lastModel = product
                        shopVC.shopId = "\(product.vendorId )"
                    }
                }
            }
            return cell
        }
        //普通商品
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchProductInfoCell", for: indexPath) as!   SearchProductInfoCell
        cell.selectionStyle = .none
        cell.configCell(product)
        // searchType:SearchProductType = .CommonSearch
        if self.shopProductSearch == true{
            //埋点专用
            if let jbpShopID = self.jbpShopID,jbpShopID.isEmpty == false{
                //聚宝盆专区
                cell.resetCanClickShopArea(product,.JBPSearch)
            }else{
                // 商家id
                if nil != self.sellerCode {
                    cell.resetCanClickShopArea(product,.ShopSearch)
                }else{
                    cell.resetCanClickShopArea(product)
                }
            }
        }else{
            cell.resetCanClickShopArea(product)
        }
        //更新加车数量
        cell.addUpdateProductNum = { [weak self]  in
            if let strongSelf = self {
                strongSelf.selectedIndexPath = indexPath
                strongSelf.popAddCarView(product)
            }
        }
        //到货通知
        cell.productArriveNotice = {
            FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                let controller = vc as! ArrivalProductNoticeVC
                controller.productId = product!.productId
                controller.venderId = "\(product!.vendorId)"
                controller.productUnit = product!.unit
            }, isModal: false)
        }
        //点击购买套餐按钮
        cell.clickComboBtn = {
            if  let itemModel = product {
                if itemModel.isComboProudct() == true {
                    //固定套餐
                    FKYNavigator.shared().openScheme(FKY_ComboList.self, setProperty: { (vc) in
                        let controller = vc as! FKYComboListViewController
                        controller.enterpriseName = itemModel.vendorName
                        controller.sellerCode = itemModel.vendorId
                        controller.spuCode = itemModel.spuCode ?? ""
                    }, isModal: false)
                }else {
                    //搭配套餐
                    FKYNavigator.shared().openScheme(FKY_MatchingPackageVC.self, setProperty: { (vc) in
                        let controller = vc as! FKYMatchingPackageVC
                        controller.spuCode = itemModel.productId
                        controller.enterpriseId = "\(itemModel.vendorId)"
                    }, isModal: false)
                }
            }
        }
        //跳转到聚宝盆商家专区
        cell.clickJBPContentArea = { [weak self] in
            if let strongSelf = self {
                strongSelf.addNewBI_Record(product!, strongSelf.getCurrectCellIndex(indexPath.row), 3)
                FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                    let controller = vc as! FKYNewShopItemViewController
                    controller.shopId = "\(product!.vendorId)"
                    controller.shopType = "1"
                }, isModal: false)
            }
        }
        //跳转到店铺详情
        cell.clickShopContentArea = { [weak self] in
            if let strongSelf = self {
                strongSelf.addNewBI_Record(product!, strongSelf.getCurrectCellIndex(indexPath.row), 4)
                FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                    let controller = vc as! FKYNewShopItemViewController
                    controller.shopId = "\(product!.vendorId)"
                    controller.shopType = "2"
                }, isModal: false)
            }
        }
        //登录
        cell.loginClosure = {
            FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
        }
        // 商详
        cell.touchItem = {[weak self] in
            if let strongSelf = self {
                strongSelf.view.endEditing(false)
                strongSelf.addNewBI_Record(product!, strongSelf.getCurrectCellIndex(indexPath.row), 1)
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = product!.productId
                    v.vendorId = "\(product!.vendorId)"
                    v.updateCarNum = { [weak self] (carId, num) in
                        if let strongInSelf = self{
                            if let count = num {
                                product!.carOfCount = count.intValue
                            }
                            if let getId = carId {
                                product!.carId = getId.intValue
                            }
                            if indexPath.row < strongInSelf.searchResultProvider.productList?.count {
                                strongInSelf.tableView.reloadRows(at: [indexPath], with: .none)
                            }
                            else {
                                strongInSelf.tableView.reloadData()
                            }
                        }
                    }
                }, isModal: false)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{//|| self.searchResultProvider.recallStatus == "2"
            //聚宝盆专区或者店铺内搜索
            //低分召回
            let section = UIView()
            section.backgroundColor = .clear
            return section
        }
        if  self.searchResultProvider.recallStatus == "2" && section == 1{
            let section = UIView()
            section.backgroundColor = .clear
            return section
        }
        //        if section == 0{
        //            shopInfoHeadView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(89))
        //            shopInfoHeadView.gotoShopAction = {[weak self] in
        //                guard let strongSelf = self else {
        //                    return
        //                }
        //                if strongSelf.searchResultProvider.searchShopModel != nil{
        //                    FKYNavigator.shared().openScheme(FKY_ShopItem.self) { (vc) in
        //                        let v = vc as! FKYNewShopItemViewController
        //                        if let _ = strongSelf.searchResultProvider.searchShopModel!.enterpriseId {
        //                            v.shopId = "\(strongSelf.searchResultProvider.searchShopModel!.enterpriseId ?? "")"
        //                        }
        //                    }
        //                }
        //            }
        //            return shopInfoHeadView
        //        }
        // 固定的筛选视图...<显示>
        sectionHeadFilter.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(40))
        weak var weakSection = sectionHeadFilter
        sectionHeadFilter.backgroundColor = bg1
        sectionHeadFilter.setupView(!self.shopProductSearch)
        // 保存
        // self.sectionHeadFilter = section
        if self.setedStatusCondition == false {
            //初始化一次记录的筛选条件
            sectionHeadFilter.updatePirceAndShopSortAndStockStates(self.priceSeq, self.stockSeq, self.shopSort, self.selectedPriceDefault)
            self.setedStatusCondition = true
        }
        // 点击价格筛选条件
        sectionHeadFilter.clickPriceRangeWithFirst = { [weak self,weak sectionHeadFilter]  in
            guard let strongSelf = self else {
                return
            }
            guard let strongSectionHeadFilter = sectionHeadFilter else {
                return
            }
            strongSectionHeadFilter.topFilterHeight = strongSelf.tableHeadHeight
            strongSelf.selectedPriceDefault = true
        }
        // 默认 or 价格高低等
        sectionHeadFilter.changePriceRangeAction = { [weak self,weak sectionHeadFilter] (type) in
            guard let strongSelf = self else {
                return
            }
            guard let strongSectionHeadFilter = sectionHeadFilter else {
                return
            }
            strongSectionHeadFilter.topFilterHeight = strongSelf.tableHeadHeight
            switch type {
            case .NONE:
                
                strongSelf.BIModel.floorName = "筛选条件"
                strongSelf.BIModel.sectionId = "S9001"
                strongSelf.BIModel.sectionPosition = "2"
                strongSelf.BIModel.sectionName = "排序"
                strongSelf.BIModel.itemId = ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue
                strongSelf.BIModel.itemPosition = "1"
                strongSelf.BIModel.itemName = "默认"
                strongSelf.BIModel.type = ""
                
            //                        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "筛选条件", sectionId: "S9001", sectionPosition: "2", sectionName: "排序", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue, itemPosition: "1", itemName: "默认", itemContent: strongSelf.itemContentStr, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            case .SALES:
                
                strongSelf.BIModel.floorName = "筛选条件"
                strongSelf.BIModel.sectionId = "S9001"
                strongSelf.BIModel.sectionPosition = "2"
                strongSelf.BIModel.sectionName = "排序"
                strongSelf.BIModel.itemId = ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue
                strongSelf.BIModel.itemPosition = "2"
                strongSelf.BIModel.itemName = "月店数"
                strongSelf.BIModel.type = ""
                
                //                        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "筛选条件", sectionId: "S9001", sectionPosition: "2", sectionName: "排序", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue, itemPosition: "2", itemName: "月店数", itemContent: strongSelf.itemContentStr, itemTitle: nil, extendParams: nil, viewController: strongSelf)
                
            case .ASC:
                strongSelf.BIModel.floorName = "筛选条件"
                strongSelf.BIModel.sectionId = "S9001"
                strongSelf.BIModel.sectionPosition = "2"
                strongSelf.BIModel.sectionName = "排序"
                strongSelf.BIModel.itemId = ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue
                strongSelf.BIModel.itemPosition = "3"
                strongSelf.BIModel.itemName = "价格升序"
                strongSelf.BIModel.type = ""
                
                //                        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "筛选条件", sectionId: "S9001", sectionPosition: "2", sectionName: "排序", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue, itemPosition: "3", itemName: "价格升序", itemContent: strongSelf.itemContentStr, itemTitle: nil, extendParams: nil, viewController: strongSelf)
                
            case .DESC:
                strongSelf.BIModel.floorName = "筛选条件"
                strongSelf.BIModel.sectionId = "S9001"
                strongSelf.BIModel.sectionPosition = "2"
                strongSelf.BIModel.sectionName = "排序"
                strongSelf.BIModel.itemId = ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue
                strongSelf.BIModel.itemPosition = "4"
                strongSelf.BIModel.itemName = "价格降序"
                strongSelf.BIModel.type = ""
                
                //                        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "筛选条件", sectionId: "S9001", sectionPosition: "2", sectionName: "排序", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue, itemPosition: "4", itemName: "价格降序", itemContent: strongSelf.itemContentStr, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            }
            // 价格排序筛选选择
            
            strongSelf.nowPage = 1
            strongSelf.priceSeq = type.rawValue
            
            if strongSelf.priceSeq == PriceRangeEnum.NONE.rawValue {
                strongSelf.sortColumn = strongSelf.priceSeq
            }else if strongSelf.priceSeq ==  PriceRangeEnum.SALES.rawValue {
                strongSelf.sortColumn = "cust" //strongSelf.priceSeq
            }else {
                strongSelf.sortColumn = "price"
            }
            strongSelf.searchResultProvider.productList?.removeAllObjects()
            strongSelf.requestSellerListInfo()
            strongSelf.getProductDataWithpriceSeq(type.rawValue)
            
        }
        // 是否自营筛选条件
        sectionHeadFilter.changeShopSortRangeAction = { [weak self,weak sectionHeadFilter] (type) in
            guard let strongSectionHeadFilter = sectionHeadFilter else {
                return
            }
            if let strongSelf = self {
                strongSectionHeadFilter.topFilterHeight = strongSelf.tableHeadHeight
                strongSelf.nowPage = 1
                strongSelf.shopSort = type.rawValue
                strongSelf.searchResultProvider.productList?.removeAllObjects()
                //当选中自营时与商家互斥,移除商家选中的条件及选中背景颜色
                //判断条件选中自营及商家之前有筛选条件
                if strongSelf.shopSort == ShopSortEnum.SELFSHOP.rawValue,strongSelf.chooseSellersName.count > 0 {
                    strongSelf.chooseSellersName.removeAll()
                    weakSection?.updateShopStatesWithInitial()
                }
                
                strongSelf.getProductDataWithpriceSeq(strongSelf.priceSeq)
                //  FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "筛选栏", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue, itemPosition: "7", itemName: "自营", itemContent: nil, itemTitle: nil, extendParams: strongSelf.getBI_KeyWord(), viewController: strongSelf)
            }
        }
        // 是否有货筛选
        sectionHeadFilter.changeStockStateRangeAction = { [weak self,weak sectionHeadFilter] (type) in
            guard let strongSectionHeadFilter = sectionHeadFilter else {
                return
            }
            if let strongSelf = self {
                strongSectionHeadFilter.topFilterHeight = strongSelf.tableHeadHeight
                strongSelf.nowPage = 1
                strongSelf.stockSeq = type.rawValue
                strongSelf.searchResultProvider.productList?.removeAllObjects()
                strongSelf.requestSellerListInfo()
                strongSelf.getProductDataWithpriceSeq(strongSelf.priceSeq)
                //  FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "筛选栏", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue, itemPosition: "3", itemName: "有货", itemContent: strongSelf.itemContentStr, itemTitle: nil, extendParams: strongSelf.getBI_KeyWord(), viewController: strongSelf)
            }
        }
        // 商家筛选
        sectionHeadFilter.sellerNameFliterAction = { [weak self,weak sectionHeadFilter](nodeList) in
            guard let strongSectionHeadFilter = sectionHeadFilter else {
                return
            }
            if let strongSelf = self {
                strongSectionHeadFilter.topFilterHeight = strongSelf.tableHeadHeight
                strongSelf.nowPage = 1
                strongSelf.chooseSellersName = nodeList
                strongSelf.searchResultProvider.productList?.removeAllObjects()
                //当选中自营时与商家互斥,移除自营选中的条件及选中背景颜色
                //判断条件选中自营及商家之前有筛选条件
                if strongSelf.shopSort == ShopSortEnum.SELFSHOP.rawValue,strongSelf.chooseSellersName.count > 0 {
                    strongSelf.shopSort = ShopSortEnum.ALLSHOP.rawValue
                    weakSection?.updateShopSortWithInitial()
                }
                //strongSelf.requestSellerListInfo()
                strongSelf.getProductDataWithpriceSeq(strongSelf.priceSeq)
            }
        }
        //更细位置事件
        sectionHeadFilter.updatePositionBtn = { [weak self,weak sectionHeadFilter] in
            guard let strongSectionHeadFilter = sectionHeadFilter else {
                return
            }
            guard let strongSelf = self else {
                return
            }
            strongSectionHeadFilter.topFilterHeight = strongSelf.tableHeadHeight
        }
        //点击商家按钮事件
        sectionHeadFilter.clickedShopBtn = { [weak self,weak sectionHeadFilter] in
            guard let strongSectionHeadFilter = sectionHeadFilter else {
                return
            }
            guard let strongSelf = self else {
                return
            }
            strongSectionHeadFilter.topFilterHeight = strongSelf.tableHeadHeight
            //  FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: "4", sectionName: "筛选栏", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue, itemPosition: "4", itemName: "选择商家", itemContent: nil, itemTitle: nil, extendParams: strongSelf.getBI_KeyWord(), viewController: strongSelf)
        }
        //点击规格
        sectionHeadFilter.clickedSpecBtn = { [weak self,weak sectionHeadFilter] in
            guard let strongSectionHeadFilter = sectionHeadFilter else {
                return
            }
            guard let strongSelf = self else {
                return
            }
            strongSectionHeadFilter.topFilterHeight = strongSelf.tableHeadHeight
        }
        // 筛选生产厂家和商品规格
        sectionHeadFilter.factoryNameFliterAction = {[weak self,weak sectionHeadFilter] (sectionCell) in
            guard let strongSectionHeadFilter = sectionHeadFilter else {
                return
            }
            guard let strongSelf = self else {
                return
            }
            strongSectionHeadFilter.topFilterHeight = strongSelf.tableHeadHeight
            //MARK: - 规格按钮点击在这里
            strongSelf.popFactorysAndRankView(sectionCell)
        }
        
        /// 厂家筛选回调
        sectionHeadFilter.selectedFactoryListCallBackBlock = {[weak self,weak sectionHeadFilter] (factoryList) in
            guard let strongSectionHeadFilter = sectionHeadFilter else {
                return
            }
            guard let strongSelf = self else {
                return
            }
            strongSectionHeadFilter.topFilterHeight = strongSelf.tableHeadHeight
            strongSelf.searchResultProvider.productList?.removeAllObjects()
            strongSelf.chooseFactoryName = factoryList
            //                    strongSelf.requestRankList()
            strongSelf.updataFactoryAndRankSInfo()
            strongSelf.getProductDataWithpriceSeq(strongSelf.priceSeq)
        }
        
        /// 规格筛选回调
        sectionHeadFilter.selectedRankListCallBackBlock = { [weak self,weak sectionHeadFilter] (rankList) in
            guard let strongSelf = self else {
                return
            }
            guard let strongSectionHeadFilter = sectionHeadFilter else {
                return
            }
            strongSectionHeadFilter.topFilterHeight = strongSelf.tableHeadHeight
            strongSelf.searchResultProvider.productList?.removeAllObjects()
            strongSelf.chooseRankName = rankList
            //                    strongSelf.requestFactoryList()
            strongSelf.updataFactoryAndRankSInfo()
            strongSelf.getProductDataWithpriceSeq(strongSelf.priceSeq)
        }
        
        /// BI埋点回调
        sectionHeadFilter.selectedBICallBackBlock = { [weak self] (BIModel) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.BIModel = BIModel
        }
        return sectionHeadFilter
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let scrollIndex = indexPath.row / 10 + 1
        self.observeCollectionViewIndex(scrollIndex)
    }
}


extension FKYSearchResultVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchResultType == "Shop" {
            // 店铺
            if self.searchShopProvider.shopList.count > indexPath.row, let shopModel = self.searchShopProvider.shopList[indexPath.row] as? FKYShopListModel {
                let shopCellH = SearchShopListCell.configCellHeight(shopModel)
                return shopCellH
            }
            return CGFloat.leastNormalMagnitude
        }
        if  self.searchResultProvider.recallStatus == "2" && indexPath.section == 0 && indexPath.row == 1 {//第一页并且是低分召回 才展示低分召回UI
            return WH(37)
        }
        
        if indexPath.section == 1 && indexPath.row == 0  {// 0搜索词
            if self.searchResultProvider.recallStatus == "5" && self.searchResultProvider.newKeyWord.isEmpty == false{
                return WH(40)
            }
            return CGFloat.leastNormalMagnitude
        }
        if indexPath.section == 0 && indexPath.row == 0{
            if  self.searchResultProvider.isShowSearchShopInfo == true{
                self.updateTableHeadHeight(tableView)
                return SearchShopInfoCell.getCellContentHeight(self.searchResultProvider.searchShopModel)
            }else if  self.searchResultProvider.isShowSearchShopInfo == false || ((self.jbpShopID != nil && self.jbpShopID!.isEmpty == false)||(self.yflShopID != nil && self.yflShopID!.isEmpty == false)||(self.sellerCode != nil && (String(format:"\(self.sellerCode ?? 0)")).isEmpty == false) ){
                //店铺内搜索和专区搜索,药福利不需要展示店铺信息
                self.updateTableHeadHeight(tableView)
                return CGFloat.leastNormalMagnitude
            }
        }
        // 商品
        var product: HomeProductModel! = nil // 商品model
        if self.searchResultProvider.productList?.count > 0, (self.searchResultProvider.productList?.count)! >= indexPath.row {
            if let model = self.searchResultProvider.productList![indexPath.row - 1] as? HomeProductModel{
                product = model
                if  product!.productType == .MZProduct || product!.productType == .TJProduct{
                    //自营钩子商品
                    return SearchGZProductInfoCell.getCellContentHeight(product as Any)
                }else{
                    //普通商品
                    return SearchProductInfoCell.getCellContentHeight(product as Any)
                }
            }else if let model = self.searchResultProvider.productList![indexPath.row - 1] as? SearchMpHockProductModel{
                //mp钩子商品
                return SearchGZProductInfoCell.getCellContentHeight(model as Any)
            }else if let model = self.searchResultProvider.productList![indexPath.row - 1] as? ShopProductCellModel{
                //热销钩子
                return SearchGZProductInfoCell.getCellContentHeight(model as Any)
            }
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  section == 0{ //|| self.searchResultProvider.recallStatus == "2"
            //低分召回
            return CGFloat.leastNormalMagnitude
        }
        if  self.searchResultProvider.recallStatus == "2" && section == 1{
            return CGFloat.leastNormalMagnitude
        }
        // 商品筛选
        return WH(40)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.searchResultType == "Shop" {
            // 店铺
            if self.searchShopProvider.shopList.count > indexPath.row {
                let product = self.searchShopProvider.shopList[indexPath.row] as! FKYShopListModel
                self.bi_shopList(2,indexPath.row,product)
                FKYNavigator.shared().openScheme(FKY_ShopItem.self) { (vc) in
                    let v = vc as! FKYNewShopItemViewController
                    if let _ = product.shopId {
                        v.shopId = "\(product.shopId!)"
                    }
                    if let type = product.type ,type == 1 {
                        v.shopType = "1"
                    }
                }
            }
        }
    }
}
extension FKYSearchResultVC: UIScrollViewDelegate {
    // MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //滑动消失弹窗
        //计算下拉选择距离顶部的高度
        self.updateTableHeadHeight(scrollView)
        self.sectionHeadFilter.hidePopViewForScroll()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // observeCollectionViewContentOffset(scrollView.contentOffset)
        let offset_y = scrollView.contentOffset.y
        //计算下拉选择距离顶部的高度
        //计算下拉选择距离顶部的高度
        self.updateTableHeadHeight(scrollView)
        if offset_y >= SCREEN_HEIGHT/2 {
            self.toTopButton.isHidden = false
            self.view.bringSubviewToFront(self.toTopButton)
        }
        else {
            self.toTopButton.isHidden = true
            self.view.sendSubviewToBack(self.toTopButton)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //计算下拉选择距离顶部的高度
        self.updateTableHeadHeight(scrollView)
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // let offset_y = scrollView.contentOffset.y
        //计算下拉选择距离顶部的高度
        self.updateTableHeadHeight(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.updateTableHeadHeight(scrollView)
    }
    func updateTableHeadHeight(_ scrollView: UIScrollView){
        //计算下拉选择距离顶部的高度
        if ((self.jbpShopID != nil && self.jbpShopID!.isEmpty == false)||(self.yflShopID != nil && self.yflShopID!.isEmpty == false)||(self.sellerCode != nil && (String(format:"\(self.sellerCode ?? 0)")).isEmpty == false) || self.searchResultProvider.recallStatus == "2"){
            tableHeadHeight = -0.5
        }else{
            //计算下拉选择距离顶部的高度
            if  scrollView.contentOffset.y >= (self.searchResultProvider.isShowSearchShopInfo ? self.searchResultProvider.tableHeadHeight:WH(0)){
                tableHeadHeight = -0.5
            }else {
                tableHeadHeight = (self.searchResultProvider.isShowSearchShopInfo ? self.searchResultProvider.tableHeadHeight:WH(0)) - scrollView.contentOffset.y
            }
        }
    }
}
// MARK: - 响应事件
extension FKYSearchResultVC {
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKY_jumpToNewProductRegisterVC{// 跳转到新品登记
            //            self.toast("跳转到新品登记")
            if FKYLoginService.loginStatus() != .unlogin{// 已登录
                FKYNavigator.shared().openScheme(FKY_NewProductRegisterVC.self, setProperty: { (svc) in
                    let v = svc as! FKYNewProductRegisterVC
                    if self.isFromScanVC == true{
                        v.barcode = self.barCode
                    }else{
                        v.barcode = ""
                    }
                }, isModal: false, animated: true)
            }else{// 未登录
                FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            }
            
        }
    }
}

//MARK: - BI埋点
extension FKYSearchResultVC {
    func BI_NEW(_ totalCount: NSInteger){
        if self.BIModel.itemId.isEmpty == false{
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "筛选条件", sectionId: "S9001", sectionPosition: self.BIModel.sectionPosition, sectionName: self.BIModel.sectionName, itemId:self.BIModel.itemId, itemPosition: self.BIModel.itemPosition, itemName: self.BIModel.itemName, itemContent: self.itemContentStr, itemTitle: nil, extendParams: self.getBI_KeyWord(), viewController: self)
        }
        //        }else{
        //             FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName:nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId:nil, itemPosition: nil, itemName: nil, itemContent: self.itemContentStr, itemTitle: nil, extendParams: self.getBI_KeyWord(), viewController: self)
        //        }
        
    }
    //进入店铺
    func BI_ENTER_SHOP(_ baseModel : SearchShopInfoModel?){
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: self.BIModel.sectionName, itemId:"I9009", itemPosition: "0", itemName: "进入店铺", itemContent: nil, itemTitle: nil, extendParams: self.getBI_KeyWord(), viewController: self)
    }
    //点击轮播
    func BI_CLICK_BANNER(_ index:Int, _ baseModel : HomeCircleBannerItemModel?){
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: self.BIModel.sectionName, itemId:"I9009", itemPosition: "\(index)", itemName: "点击轮播", itemContent: nil, itemTitle: (baseModel?.name ?? ""), extendParams: self.getBI_KeyWord(), viewController: self)
    }
    //点击插入楼层
    func BI_click_Insert_product(_ index:Int,_ model:Any){
        //itemPosition=1 自营活动专区
        // itemPosition=2 自营榜单
        // itemPosition=3 MP活动专区
        if index == 1{
            if let product = model as? HomeProductModel{
                if product.productType == .MZProduct{
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName:"插入广告楼层", itemId:"I9011", itemPosition: "1", itemName: "点进自营活动专区", itemContent: nil, itemTitle: "满折专区", extendParams: self.getBI_KeyWord(), viewController: self)
                }else if product.productType == .TJProduct{
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName:"插入广告楼层", itemId:"I9011", itemPosition: "1", itemName: "点进自营活动专区", itemContent: nil, itemTitle: "特价专区", extendParams: self.getBI_KeyWord(), viewController: self)
                }
            }
        }else if index == 2{
            //            if let po = model as? ShopProductCellModel{
            //
            //            }
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "插入广告楼层", itemId:"I9011", itemPosition: "2", itemName: "点进自营榜单", itemContent: nil, itemTitle: nil, extendParams: self.getBI_KeyWord(), viewController: self)
        }else if index == 3{
            if let product = model as? SearchMpHockProductModel{
                if product.productType == .MZProduct{
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "插入广告楼层", itemId:"I9011", itemPosition: "3", itemName: "点进MP活动专区", itemContent: nil, itemTitle: "满折专区", extendParams: self.getBI_KeyWord(), viewController: self)
                }else if product.productType == .TJProduct{
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "插入广告楼层", itemId:"I9011", itemPosition: "3", itemName: "点进MP活动专区", itemContent: nil, itemTitle: "特价专区", extendParams: self.getBI_KeyWord(), viewController: self)
                }
            }
        }
    }
    //商家列表的埋点
    func bi_shopList(_ type:Int,_ index:Int,_ model:Any,_ itemP:Int = 1){
        if let shopModel = model as? FKYShopListModel{
            let extendParams:[String :AnyObject] = ["keyword" : self.keyword as AnyObject]
            //type 2 进商详 1 进店铺  index 商家位置
            var itemPosition = "1"
            var itemId = "I9021"
            var itemName = "点进店铺"
            if type == 1{
                itemPosition = "\(itemP + 1)"
                itemId = "I9998"
                itemName = "点进商详"
            }
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S9021", sectionPosition:"\(index + 1)", sectionName: shopModel.shopName ?? "", itemId:itemId, itemPosition: itemPosition, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: self)
        }
    }
    //埋点公共字段
    func getBI_KeyWord()->[String :AnyObject]{
        var bi_keyWord = ""
        var bi_pageValue = ""
        //埋点专用
        if self.barCode.isEmpty == false{
            bi_keyWord = self.barCode
            bi_pageValue = "barcode"
        }else if let _ = self.keyword,self.keyword?.isEmpty == false{
            bi_keyWord = self.keyword!
            bi_pageValue = "keyword"
        }
        if self.itemContentStr != nil && self.itemContentStr!.isEmpty == false{
            bi_pageValue = self.itemContentStr!
        }
        let extendParams:[String :AnyObject] = ["keyword" : bi_keyWord as AnyObject,"pageValue" : bi_pageValue as AnyObject,"srn":(self.searchResultProvider.totalCount ?? 0) as AnyObject]
        return extendParams
    }
    //获取index
    func getCurrectCellIndex(_ indexRow:Int)->Int{
        if indexRow < 5{
            return indexRow
        }else if indexRow < 10{
            if self.searchResultProvider.isShowGzProduct == true{
                return indexRow - 1
            }else{
                return indexRow
            }
        }else if indexRow < 15{
            if self.searchResultProvider.isShowGzProduct == true && self.searchResultProvider.isShowHotSellProduct == true{
                return indexRow - 2
            }else if self.searchResultProvider.isShowGzProduct == true || self.searchResultProvider.isShowHotSellProduct == true{
                return indexRow - 1
            }else{
                return indexRow
            }
        }else{
            if self.searchResultProvider.isShowGzProduct == true && self.searchResultProvider.isShowHotSellProduct == true && self.searchResultProvider.isShowMPGzProduct == true{
                return indexRow - 3
            }
            else if self.searchResultProvider.isShowGzProduct == true || self.searchResultProvider.isShowHotSellProduct == true || self.searchResultProvider.isShowMPGzProduct == true{
                return indexRow - 2
            }
            else if (self.searchResultProvider.isShowGzProduct == true && self.searchResultProvider.isShowHotSellProduct == true) || (self.searchResultProvider.isShowMPGzProduct == true && self.searchResultProvider.isShowHotSellProduct == true) || (self.searchResultProvider.isShowMPGzProduct == true && self.searchResultProvider.isShowGzProduct == true){
                return indexRow - 1
            }
            else{
                return indexRow
            }
        }
    }
}

