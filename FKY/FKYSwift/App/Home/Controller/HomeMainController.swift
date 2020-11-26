//
//  HomeMainController.swift
//  FKY
//
//  Created by 寒山 on 2019/3/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  新首页 A方面界面

import UIKit

class HomeMainController: UIViewController {
    //搜索框高度
    var tabbarHeight = 49.0
    var lastTimeInterval:TimeInterval = 0.0  //防止通知重复刷新
    let serachbar_height:CGFloat  =  naviBarHeight() + WH(11)
    //MARK ：处理滑动相关及属性
    var scrollTag: Bool = false
    var isCurrenctView: Bool = false
    var nextReturn: Bool = false
    var lastDy: CGFloat = 0.0
    fileprivate var isShowFaildView: Bool = false //是否显示加载失败界面
    fileprivate var isFirstRefresh: Bool = true //第一次加载
    //首页蒙版
    let NEW_HOME_MASK = "NEW_HOME_MASK"
    //viewModel
    fileprivate lazy var viewModel: NewHomeViewModel = NewHomeViewModel()
    fileprivate lazy var presenter: HomePresenter = HomePresenter()
    fileprivate lazy var service: FKYCartService = {
        let service = FKYCartService()
        service.editing = false
        return service
    }()
    fileprivate lazy var shopProvider: ShopItemProvider = {
        return ShopItemProvider()
    }()
    //获取未读消息请求类
    fileprivate lazy var messageListProvider: FKYMessageProvider = {
        return FKYMessageProvider()
    }()
    
    var viewType: HomeViewType?
    
    fileprivate var segmentChangeState = false //更改segment颜色
    
    fileprivate var isFirstFresh = true //第一次请求常购清单
    
    // MARK: - Property
    fileprivate lazy var searchBar: HomeSearchBar = {
        let bar = HomeSearchBar()
        bar.operation = self
        return bar
    }()
    //请求失败
    fileprivate lazy var failedView: UIView = {
        weak var weakSelf = self
        let view = self.showEmptyNoDataCustomView(self.view, "no_shop_pic", GET_FAILED_TXT, false) {
            weakSelf?.setUpData()
        }
        self.isShowFaildView = true
        view.snp.remakeConstraints({ (make) in
            make.bottom.left.right.equalTo(self.view)
            make.top.equalTo(self.searchBar.snp.bottom)
        })
        return view
    }()
    //banner 和 icon View
    fileprivate lazy var bannerIconView: HomeHeaderView = {
        let top = HomeHeaderView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(113) + (SCREEN_WIDTH - 20)*110/355.0))
        top.backgroundColor = UIColor.white
        return top
    }()
    //刷新
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            // 下拉刷新
            
            strongSelf.showLoading()
            strongSelf.setUpData()
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
    }()
    fileprivate lazy var tableContentView: FKYRecognizeSimultaneousTab = {
        let tableView = FKYRecognizeSimultaneousTab.init(frame: CGRect(x: 0, y: (naviBarHeight() + WH(11)) , width: SCREEN_WIDTH, height: SCREEN_HEIGHT - (naviBarHeight() + WH(11)) - CGFloat(self.tabbarHeight)))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ColorConfig.colorf4f4f4
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        //tableView.isDirectionalLockEnabled = true
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableHeaderView = self.bannerIconView
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(HomeNewOftenBuyCell.self, forCellReuseIdentifier: "HomeNewOftenBuyCell")
        tableView.mj_header = self.mjheader
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0//WH(213)
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()
    
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        viewType = .planA
        
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                tabbarHeight = Double(49.0 + iPhoneX_SafeArea_BottomInset)
            }
        }
        
        //初始化UI
        self.steupUI()
        //获取缓存数据
        self.loadCacheData()
        //获取数据
        self.setUpData()
        
        // 首页秒杀一起购楼层倒计时结束时需刷新数据
        NotificationCenter.default.addObserver(self, selector: #selector(HomeMainController.refreshHomePage(_:)), name: NSNotification.Name(rawValue: FKYNEWHomeSecondKillCountOver), object: nil)
        //收到透传消息通知
        NotificationCenter.default.addObserver(self, selector: #selector(HomeMainController.refreshNoReadMessage), name: NSNotification.Name.FKYHomeNoReadMessage, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isCurrenctView = true
        //获取消息盒子
        self.getNoReadMessageCount()
        //刷新购物车数量
        self.refreshCartNum()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isCurrenctView = false
    }
    
    deinit {
        let provinceCells = tableContentView.visibleCells
        if provinceCells.count > 0{
            if  provinceCells[0].isKind(of:HomeNewOftenBuyCell.self){
                let cell:HomeNewOftenBuyCell = provinceCells[0] as! HomeNewOftenBuyCell
                cell.getAllRmoveObserverTable()
            }
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: -
    
    //初始化UI
    fileprivate func steupUI() {
        
        self.view.addSubview(tableContentView)
        self.view.insertSubview(searchBar, aboveSubview: tableContentView)
        searchBar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(serachbar_height)
        }
        let provinceCells = tableContentView.visibleCells
        if provinceCells.count > 0{
            if  provinceCells[0].isKind(of:HomeNewOftenBuyCell.self){
                let cell:HomeNewOftenBuyCell = provinceCells[0] as! HomeNewOftenBuyCell
                cell.getAllAddObserverTable()
            }
        }
    }
    
    //滑到上一页
    func scrollToLastPage() {
        if self.viewModel.currentIndex != 0 {
            let provinceCells = tableContentView.visibleCells
            if provinceCells.count > 0{
                if  provinceCells[0].isKind(of:HomeNewOftenBuyCell.self){
                    let cell:HomeNewOftenBuyCell = provinceCells[0] as! HomeNewOftenBuyCell
                    self.viewModel.currentIndex = Int(self.viewModel.currentIndex - 1)
                    self.viewModel.currentType = self.viewModel.sectionType[self.viewModel.currentIndex]
                    cell.homeScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(self.viewModel.currentIndex), y: 0), animated: true)
                    cell.homeSegment.setSelectedSegmentIndex(UInt(self.viewModel.currentIndex), animated: true)
                    cell.configCellData(self.viewModel, self.isFirstFresh)
                    self.isFirstFresh = false
                    self.addClickSegmentBI_Record()
                }
            }
        }
    }
    
    //滑到右滑 下一页
    func scrollToNextPageBySwipeRight() {
        if self.viewModel.currentIndex != (self.viewModel.sectionTitle.count - 1) {
            let provinceCells = tableContentView.visibleCells
            if provinceCells.count > 0{
                if  provinceCells[0].isKind(of:HomeNewOftenBuyCell.self){
                    let cell:HomeNewOftenBuyCell = provinceCells[0] as! HomeNewOftenBuyCell
                    cell.getCurrectView().updateContentOfsetByScrolll()
                    self.viewModel.currentIndex = Int(self.viewModel.currentIndex + 1)
                    if self.viewModel.sectionType.count <= self.viewModel.currentIndex{
                        self.viewModel.currentIndex = self.viewModel.sectionType.count - 1;
                    }
                    self.viewModel.currentType = self.viewModel.sectionType[self.viewModel.currentIndex]
                    cell.homeScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(self.viewModel.currentIndex), y: 0), animated: true)
                    cell.homeSegment.setSelectedSegmentIndex(UInt(self.viewModel.currentIndex), animated: true)
                    cell.configCellData(self.viewModel, self.isFirstFresh)
                    self.isFirstFresh = false
                    self.addClickSegmentBI_Record()
                }
            }
        }
    }
    
    //滑到下一页
    func scrollToNextPage() {
        if !self.viewModel.currentModel.hasNextPage && self.viewModel.currentIndex != (self.viewModel.sectionTitle.count - 1) {
            let provinceCells = tableContentView.visibleCells
            if provinceCells.count > 0{
                if  provinceCells[0].isKind(of:HomeNewOftenBuyCell.self){
                    let cell:HomeNewOftenBuyCell = provinceCells[0] as! HomeNewOftenBuyCell
                    cell.getCurrectView().updateContentOfsetByScrolll()
                    self.viewModel.currentIndex = Int(self.viewModel.currentIndex + 1)
                    if self.viewModel.sectionType.count <= self.viewModel.currentIndex{
                        self.viewModel.currentIndex = self.viewModel.sectionType.count - 1;
                    }
                    self.viewModel.currentType = self.viewModel.sectionType[self.viewModel.currentIndex]
                    cell.homeScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(self.viewModel.currentIndex), y: 0), animated: true)
                    cell.homeSegment.setSelectedSegmentIndex(UInt(self.viewModel.currentIndex), animated: true)
                    cell.configCellData(self.viewModel, self.isFirstFresh)
                    self.isFirstFresh = false
                    cell.getCurrectView().updateContentOffY()
                    self.addClickSegmentBI_Record()
                }
            }
        }
    }
}

// MARK: - UI
extension HomeMainController {
    //更改segment的颜色
    func channgeSegmentColor(_ needChange: Bool) {
        let provinceCells = tableContentView.visibleCells
        if provinceCells.count > 0{
            if  provinceCells[0].isKind(of:HomeNewOftenBuyCell.self){
                let cell:HomeNewOftenBuyCell = provinceCells[0] as! HomeNewOftenBuyCell
                if needChange && !segmentChangeState {
                    segmentChangeState = true
                    let normaltextAttr:Dictionary = [NSAttributedString.Key.foregroundColor.rawValue: RGBAColor(0xFFFFFF,alpha: 0.8),NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(17))] as! [String : Any]
                    let selectedtextAttr:Dictionary = [NSAttributedString.Key.foregroundColor.rawValue: RGBAColor(0xFFFFFF,alpha: 1.0),NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(18))] as! [String : Any]
                    // self.homeSegment.setSelectedSegmentIndex(UInt(index), animated: true)
                    cell.topLine.backgroundColor =  RGBColor(0xFF2D5C)
                    cell.homeSegment.backgroundColor = RGBColor(0xFF2D5C)
                    cell.homeSegment.titleTextAttributes = normaltextAttr
                    cell.homeSegment.selectedTitleTextAttributes = selectedtextAttr
                    cell.homeSegment.selectionIndicatorColor =  RGBColor(0xFFFFFF)
                    cell.homeSegment.selectionIndicatorHeight = WH(2)
                    cell.homeSegment.sectionTitles = self.viewModel.sectionTitle
                }
                else if segmentChangeState && !needChange {
                    segmentChangeState = false
                    let normaltextAttr:Dictionary = [NSAttributedString.Key.foregroundColor.rawValue: RGBAColor(0x333333 ,alpha: 1.0),NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(15))] as! [String : Any]
                    let selectedtextAttr:Dictionary = [NSAttributedString.Key.foregroundColor.rawValue: RGBAColor(0xFF2D5C,alpha: 1.0),NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(15))] as! [String : Any]
                    cell.topLine.backgroundColor = RGBColor(0xE5E5E5)
                    cell.homeSegment.backgroundColor = RGBColor(0xFFFFFF)
                    cell.homeSegment.titleTextAttributes = normaltextAttr
                    cell.homeSegment.selectedTitleTextAttributes = selectedtextAttr
                    cell.homeSegment.selectionIndicatorColor =  RGBColor(0xFF2D5C)
                    cell.homeSegment.selectionIndicatorHeight = WH(1)
                    cell.homeSegment.sectionTitles = self.viewModel.sectionTitle
                }
            }
        }
    }
    
    //设置banner和icon 信息
    func updateBannerAndIcon() {
        self.bannerIconView.configContent(self.viewModel.headList)
    }
    
    //监测tableView 的滚动
    func tableViewContentScroll() {
        //最大可滑动
        let maxOffsetY = WH(113) + (SCREEN_WIDTH - 20)*110/355.0;
        //bannner 可见高度
        let bannerVisualOffsetY = (SCREEN_WIDTH - 20)*110/355.0;
        if (Int(tableContentView.contentOffset.y) >= Int(maxOffsetY)) {
            //改变segment 的 状态
            self.channgeSegmentColor(true)
        }else{
            self.channgeSegmentColor(false)
        }
    }
    
    //监听当前tabeleView 的滑动并处理
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let maxOffsetY = WH(113) + (SCREEN_WIDTH - 20)*110/355.0;
            if self.nextReturn {self.nextReturn = false;return;}
            let new = (change?[NSKeyValueChangeKey.newKey] as! CGPoint).y
            let old = (change?[NSKeyValueChangeKey.oldKey] as! CGPoint).y
            if  new == old {return;}
            let dh = new - old
            if  dh < 0  {
                //向下
                if (object as! UIScrollView).contentOffset.y < 0 {
                    self.nextReturn = true
                    (object as! UIScrollView).contentOffset = .zero
                }
                self.scrollTag = false;
            }
            else {
                //向上
                if Int(tableContentView.contentOffset.y) < Int(maxOffsetY) {
                    self.nextReturn = true
                    self.scrollTag = true
                    if old < 0 {
                        (object as! UIScrollView).contentOffset = .zero
                    }else{
                        (object as! UIScrollView).contentOffset = CGPoint(x:0,  y:old)
                    }
                }
                else {
                    self.scrollTag = false;
                }
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    //对于还有顶部还没完全隐藏的切换tab tabel置顶
    func changeTabClickSetZero() {
        let maxOffsetY = WH(113) + (SCREEN_WIDTH - 20)*110/355.0
        let dh =  self.tableContentView.contentOffset.y
        if (dh < maxOffsetY) {
            let provinceCells = tableContentView.visibleCells
            if provinceCells.count > 0{
                if  provinceCells[0].isKind(of:HomeNewOftenBuyCell.self){
                    let cell:HomeNewOftenBuyCell = provinceCells[0] as! HomeNewOftenBuyCell
                    cell.getCurrectView().tableView.contentOffset = .zero
                }
            }
        }
    }
}

extension HomeMainController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 常购清单楼层
        let cell: HomeNewOftenBuyCell = tableView.dequeueReusableCell(withIdentifier: "HomeNewOftenBuyCell", for: indexPath) as! HomeNewOftenBuyCell
        cell.selectionStyle = .none
        cell.configCellData(self.viewModel, self.isFirstFresh)
        self.isFirstFresh = false
        //更改购物车数量
        cell.updateStepCountBlock = { [weak self] (product, count, row, typeIndex) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.updateStepCount(product, count, row, typeIndex)
        }
        //增加监听
        cell.addObserver  = { [weak self] view in
            guard let strongSelf = self else {
                return
            }
            view.tableView.addObserver(strongSelf, forKeyPath: "contentOffset", options:  [.new, .old], context: nil)
        }
        //移除监听
        cell.removeObserver = { [weak self] view in
            guard let strongSelf = self else {
                return
            }
            view.tableView.removeObserver(strongSelf, forKeyPath: "contentOffset", context: nil)
        }
        //加载更多
        cell.getTypeMoreData = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.refreshData()
        }
        //滑到下一页
        cell.scrollToNextPage  = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.scrollToNextPage()
        }
        //滑到上一页
        cell.scrollToLastPage  = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.scrollToLastPage()
        }
        //滑到下一页 手势
        cell.scrollToNextPageBySwipeRight = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.scrollToNextPageBySwipeRight()
        }
        //获取当前的type
        cell.getCurrentType = { [weak self] index in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.currentType = strongSelf.viewModel.sectionType[index]
            strongSelf.viewModel.currentIndex = index
            strongSelf.changeTabClickSetZero()
            //刷新
            let provinceCells = strongSelf.tableContentView.visibleCells
            
            if  provinceCells.count > 0 && provinceCells[0].isKind(of:HomeNewOftenBuyCell.self){
                let cell:HomeNewOftenBuyCell = provinceCells[0] as! HomeNewOftenBuyCell
                cell.configCellData(strongSelf.viewModel, strongSelf.isFirstFresh)
                strongSelf.isFirstFresh = false
            }
        }
        //回到顶部
        cell.goAllTableTop = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tableContentView.contentOffset = CGPoint(x:0,  y:0);
            if let parentVC = strongSelf.parent as? HomeController ,parentVC.getShowRedBtn() == true {
                parentVC.showRedBtn(true)
            }
        }
        
        return cell
    }
}

extension HomeMainController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_HEIGHT - serachbar_height - CGFloat(tabbarHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

//消息通知
extension HomeMainController {
    @objc fileprivate func refreshHomePage(_ nty: Notification) {
        //防止通知重复刷新
        let currentTime = NSDate().timeIntervalSince1970
        if lastTimeInterval == 0  || (lastTimeInterval > 0 && (currentTime - lastTimeInterval > 1)){
            self.isFirstFresh = true
            self.showLoading()
            self.setUpData()
            lastTimeInterval = NSDate().timeIntervalSince1970
        }
    }
    
    @objc fileprivate func refreshNoReadMessage(){
        self.getNoReadMessageCount()
    }
}

// MARK: - UIScrollViewDelegate
extension HomeMainController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let parentVC = self.parent as? HomeController ,parentVC.getShowRedBtn() == true {
            parentVC.showRedBtn(false)
        }
        //处理scrolview 的滑动
        if scrollView == tableContentView {
            let provinceCells = tableContentView.visibleCells
            let maxOffsetY = WH(113) + (SCREEN_WIDTH - 20)*110/355.0
            let dh =  scrollView.contentOffset.y
            if (dh >= maxOffsetY) {
                scrollView.contentOffset =  CGPoint(x:0,  y:maxOffsetY);
                lastDy = scrollView.contentOffset.y
            }
            else {
                if provinceCells.count > 0{
                    if  provinceCells[0].isKind(of:HomeNewOftenBuyCell.self){
                        let cell:HomeNewOftenBuyCell = provinceCells[0] as! HomeNewOftenBuyCell
                        if (dh <= 0) {
                            if  cell.getCurrectView().tableView.contentOffset.y > 0 {
                                cell.getCurrectView().tableView.contentOffset = .zero
                            }
                        }
                    }
                }
            }
            if provinceCells.count > 0{
                if  provinceCells[0].isKind(of:HomeNewOftenBuyCell.self){
                    let cell:HomeNewOftenBuyCell = provinceCells[0] as! HomeNewOftenBuyCell
                    if  cell.getCurrectView().tableView.contentOffset.y > 0 && scrollView.contentOffset.y < maxOffsetY && !self.scrollTag {
                        scrollView.contentOffset = CGPoint(x:0,  y:lastDy);
                    }
                    //防止界面混乱
                    if cell.getCurrectView().tableView.contentOffset.y < WH(-100){
                        cell.getCurrectView().tableView.contentOffset = .zero
                        self.isFirstFresh = true
                        self.showLoading()
                        self.setUpData()
                        cell.getAllAddObserverTable()
                    }
                }
            }
            lastDy = scrollView.contentOffset.y
            //搜索框颜色
            self.tableViewContentScroll()
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let parentVC = self.parent as? HomeController ,parentVC.getShowRedBtn() == true{
            parentVC.showRedBtn(true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let parentVC = self.parent as? HomeController ,parentVC.getShowRedBtn() == true {
            parentVC.showRedBtn(true)
        }
    }
}

//搜索框事件
extension HomeMainController: HomeSearchBarOperation {
    func onClickSearchItemAction(_ bar: HomeSearchBar) {
        presenter.onClickSearchItemAction(bar)
    }
    
    func onClickMessageBoxAction(_ bar: HomeSearchBar) {
        presenter.onClickMessageBoxAction(bar)
    }
}

// MARK: - request
extension HomeMainController {
    //获取缓存数据
    func loadCacheData() {
//        viewModel.fetchBannerIconCacheData(){ [weak self] (success, msg) in
//            guard let strongSelf = self else {
//                return
//            }
//            if success {
//                strongSelf.updateBannerAndIcon()
//            }
//            else {
//                // 失败
//                strongSelf.toast(msg ?? "请求失败")
//                return
//            }
//        }
        
        viewModel.fetchMixPageCacheData(){ [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isFirstFresh = true
            if success {
                strongSelf.tableContentView.reloadData()
            }
            else {
                // 失败
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    //请求数据
    func setUpData() {
        //请求banner 和icon
        viewModel.getHomeBannerNavInfo(){ [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if success {
                strongSelf.updateBannerAndIcon()
                if strongSelf.isShowFaildView == true {
                    strongSelf.failedView.isHidden = true
                }
            }
            else {
                // 失败self.viewModel.headList
                if strongSelf.viewModel.headList.count == 0 {
                    strongSelf.failedView.isHidden = false
                }
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
        
        //请求第一页混合数据
        viewModel.getHomeMixInfo(){ [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isFirstFresh = true
            strongSelf.dismissLoading()
            
            let provinceCells = strongSelf.tableContentView.visibleCells
            if provinceCells.count > 0{
                if  provinceCells[0].isKind(of:HomeNewOftenBuyCell.self){
                    let cell:HomeNewOftenBuyCell = provinceCells[0] as! HomeNewOftenBuyCell
                    cell.getCurrectView().tableView.mj_header.endRefreshing()
                    cell.getCurrectView().refreshDismiss()
                }
            }
            strongSelf.tableContentView.mj_header.endRefreshing()
            if success {
                if  provinceCells.count > 0 && provinceCells[0].isKind(of:HomeNewOftenBuyCell.self){
                    let cell:HomeNewOftenBuyCell = provinceCells[0] as! HomeNewOftenBuyCell
                    cell.configCellData(strongSelf.viewModel, strongSelf.isFirstFresh)
                    strongSelf.isFirstFresh = false
                }
                if strongSelf.isShowFaildView == true {
                    strongSelf.failedView.isHidden = true
                }
            }
            else {
                // 失败
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    
    //加载更多
    func refreshData() {
        self.showLoading()
        viewModel.getHomeOftenBuyInfo(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            let provinceCells = strongSelf.tableContentView.visibleCells
            if  provinceCells.count > 0{
                if  provinceCells[0].isKind(of:HomeNewOftenBuyCell.self){
                    let cell:HomeNewOftenBuyCell = provinceCells[0] as! HomeNewOftenBuyCell
                    cell.getCurrectView().refreshDismiss()
                }
            }
            if success {
                if provinceCells.count > 0{
                    if  provinceCells[0].isKind(of:HomeNewOftenBuyCell.self){
                         let cell:HomeNewOftenBuyCell = provinceCells[0] as! HomeNewOftenBuyCell
                         cell.configCellData(strongSelf.viewModel, strongSelf.isFirstFresh)
                         strongSelf.isFirstFresh = false
                    }
                }
            }
            else {
                // 失败
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    
    // MARK: - 获取未读消息数量 methods
    func getNoReadMessageCount() {
        if FKYLoginAPI.loginStatus() != .unlogin {
            messageListProvider.getNoReadMessageCountWithProvider { (messageCount) in
                if let count = messageCount,count > 0 {
                    self.searchBar.cartBadgeView?.badgeText = "\(count)"
                    self.searchBar.cartBadgeView?.isHidden = false
                }else{
                    self.searchBar.cartBadgeView?.isHidden = true
                    self.searchBar.cartBadgeView?.badgeText = ""
                }
            }
        }else {
            self.searchBar.cartBadgeView?.isHidden = true
            self.searchBar.cartBadgeView?.badgeText = ""
        }
    }
}

extension HomeMainController {
    //购物车刷新
    func refreshCartNum() {
        if  isFirstRefresh == false {
            self.showLoading()
        }
        isFirstRefresh = false
        FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ [weak self] (success) in
            guard let strongSelf = self else {
                return
            }
            //首页蒙版
            // strongSelf.setUpWelcomePage()
            strongSelf.dismissLoading()
            strongSelf.refreshCurrectViewCartNum()
            }, failure: { [weak self] (reason) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.dismissLoading()
                strongSelf.refreshCurrectViewCartNum()
        })
    }
    //刷新单个列表购物车数量
    func refreshCurrectViewCartNum() {
        let provinceCells = tableContentView.visibleCells
        if provinceCells.count > 0{
            if  provinceCells[0].isKind(of:HomeNewOftenBuyCell.self){
              let cell:HomeNewOftenBuyCell = provinceCells[0] as! HomeNewOftenBuyCell
              cell.getCurrectView().refreshDataBackFromCar()
            }
        }
    }
    //更新加车
    func updateStepCount(_ cellData : HomeBaseCellProtocol ,_ count: Int, _ row: Int,_ typeIndex: Int) {
        //typeIndex为2的时候延迟加车接口请求
        if typeIndex == 2 || typeIndex == 3 {
            //延迟加车
            return
        }
        weak var weakSelf = self
        
        if  cellData .cellType  == .HomeCellTypeCommonProduct {
            let cellModel:HomeCommonProductCellModel = cellData as! HomeCommonProductCellModel
            if let product = cellModel.model {
                if product.carOfCount > 0 && product.carId != 0 {
                    self.showLoading()
                    if count == 0 {
                        //数量变零，删除购物车
                        self.service.deleteShopCart([product.carId], success: { (mutiplyPage) in
                            FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ (success) in
                                //更新
                                product.carId = 0
                                product.carOfCount = 0
                                weakSelf?.refreshCurrectViewCartNum()
                                weakSelf?.dismissLoading()
                            }, failure: { (reason) in
                                weakSelf?.refreshCurrectViewCartNum()
                                weakSelf?.dismissLoading()
                                weakSelf?.toast(reason)
                            })
                        }, failure: { (reason) in
                            weakSelf?.refreshCurrectViewCartNum()
                            weakSelf?.dismissLoading()
                            weakSelf?.toast(reason)
                        })
                    }
                    else {
                        // 更新购物车...<商品数量变化时需刷新数据>
                        self.service.updateShopCart(forProduct: "\(product.carId)", quantity: count, allBuyNum: -1, success: { (mutiplyPage) in
                            FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ (success) in
                                weakSelf?.dismissLoading()
                                product.carOfCount = count
                                weakSelf?.refreshCurrectViewCartNum()
                            }, failure: { (reason) in
                                weakSelf?.refreshCurrectViewCartNum()
                                weakSelf?.dismissLoading()
                                weakSelf?.toast(reason)
                            })
                        }, failure: { (reason) in
                            weakSelf?.refreshCurrectViewCartNum()
                            weakSelf?.dismissLoading()
                            weakSelf?.toast(reason)
                        })
                    }
                }
                else if count > 0 {
                    self.showLoading()
                    // 加车
                    self.shopProvider.addShopCart(product,getTypeSourceStr(),count: count, completionClosure: { (reason, data) in
                        // 说明：若reason不为空，则加车失败；若data不为空，则限购商品加车失败
                        if let re = reason {
                            if re == "成功" {
                                FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ (success) in
                                    weakSelf?.refreshCurrectViewCartNum()
                                    self.dismissLoading()
                                }, failure: { (reason) in
                                    weakSelf?.refreshCurrectViewCartNum()
                                    self.dismissLoading()
                                    self.toast(reason)
                                })
                            }else {
                                self.dismissLoading()
                                self.toast(reason)
                            }
                        }
                        // 加车成功则重置...<限购>
                        product.limitCanBuyNumber = 0
                        // 限购之剩余可购买数量
                        if let res = data {
                            if res.value(forKeyPath: "limitCanBuyNum") != nil && (res.value(forKeyPath: "limitCanBuyNum") as AnyObject).isKind(of: NSNumber.self) {
                                if let limitCanBuyNum = res.value(forKeyPath: "limitCanBuyNum") {
                                    let limit = Int(limitCanBuyNum as! NSNumber)
                                    print("limit:" + String(limit))
                                    product.limitCanBuyNumber = limit
                                }
                            }
                        }
                    })
                }
            }
        }
        else {
            var itemModel:HomeRecommendProductItemModel?
            if let cellModel = cellData as? HomeSecKillCellModel {
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    itemModel = list[0]
                }
                self.service.isTogeterBuyAddCar = false
            }
            else if  let cellModel = cellData as? HomeOtherProductCellModel {
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    itemModel = list[0]
                }
                self.service.isTogeterBuyAddCar = false
            }
            else if  let cellModel = cellData as? HomeYQGCellModel {
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    itemModel = list[0]
                    itemModel!.isTogetherProduct = true
                    //一起购加车 删除 更改数量的 的判断
                    self.service.isTogeterBuyAddCar = true
                }
            }
            
            if let product = itemModel {
                if product.carOfCount > 0 && product.carId != 0 {
                    self.showLoading()
                    if count == 0 {
                        //数量变零，删除购物车
                        self.service.deleteShopCart([product.carId], success: { (mutiplyPage) in
                            FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ (success) in
                                //更新
                                weakSelf?.refreshCurrectViewCartNum()
                                weakSelf?.dismissLoading()
                            }, failure: { (reason) in
                                weakSelf?.refreshCurrectViewCartNum()
                                weakSelf?.dismissLoading()
                                weakSelf?.toast(reason)
                            })
                        }, failure: { (reason) in
                            weakSelf?.refreshCurrectViewCartNum()
                            weakSelf?.dismissLoading()
                            weakSelf?.toast(reason)
                        })
                    }
                    else {
                        // 更新购物车...<商品数量变化时需刷新数据>
                        self.service.updateShopCart(forProduct: "\(product.carId)", quantity: count, allBuyNum: -1, success: { (mutiplyPage) in
                            FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ (success) in
                                weakSelf?.dismissLoading()
                                weakSelf?.refreshCurrectViewCartNum()
                            }, failure: { (reason) in
                                weakSelf?.refreshCurrectViewCartNum()
                                weakSelf?.dismissLoading()
                                weakSelf?.toast(reason)
                            })
                        }, failure: { (reason) in
                            weakSelf?.refreshCurrectViewCartNum()
                            weakSelf?.dismissLoading()
                            weakSelf?.toast(reason)
                        })
                    }
                }
                else if count > 0 {
                    self.showLoading()
                    // 加车
                    self.shopProvider.addShopCart(product,getTypeSourceStr(),count: count, completionClosure: { (reason, data) in
                        // 说明：若reason不为空，则加车失败；若data不为空，则限购商品加车失败
                        if let re = reason {
                            if re == "成功" {
                                FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ (success) in
                                    weakSelf?.refreshCurrectViewCartNum()
                                    self.dismissLoading()
                                }, failure: { (reason) in
                                    weakSelf?.refreshCurrectViewCartNum()
                                    self.dismissLoading()
                                    self.toast(reason)
                                })
                            }
                            else {
                                weakSelf?.refreshCurrectViewCartNum()
                                self.dismissLoading()
                                self.toast(reason)
                            }
                        }
                    })
                }
            }
        }
    }
    
    //设置加车的来源
    func getTypeSourceStr() -> String {
        if self.viewModel.currentType == .oftenLook {
            return HomeString.SEARCH_OFTENLOOK_ADD_SOURCE_TYPE
        }else if self.viewModel.currentType == .hotSale {
            return HomeString.SEARCH_HOTSALE_ADD_SOURCE_TYPE
        }else {
            return HomeString.SEARCH_OFTENBUY_ADD_SOURCE_TYPE
        }
    }
}

extension HomeMainController {
    //点击
    func addClickSegmentBI_Record() {
        switch self.viewModel.currentType {
        case .oftenBuy?: // 常买
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: nil, sectionId: SECTIONCODE.HOME_ACTION_OFTEN_BUY.rawValue, sectionPosition: "1", sectionName: nil, itemId: ITEMCODE.HOME_ACTION_COMMON_ITEMDETAIL.rawValue, itemPosition: "0", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: HomeController())
        case .oftenLook?: // 常看
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: "2", floorName: nil, sectionId: SECTIONCODE.HOME_ACTION_OFTEN_LOOK.rawValue, sectionPosition: "1", sectionName: nil, itemId: ITEMCODE.HOME_ACTION_COMMON_ITEMDETAIL.rawValue, itemPosition: "0", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: HomeController())
        case .hotSale?: // 热销
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: "3", floorName: nil, sectionId: SECTIONCODE.HOME_ACTION_OFTEN_HOTSALES.rawValue, sectionPosition: "1", sectionName: nil, itemId: ITEMCODE.HOME_ACTION_COMMON_ITEMDETAIL.rawValue, itemPosition: "0", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: HomeController())
        default:
            break
        }
    }
}
