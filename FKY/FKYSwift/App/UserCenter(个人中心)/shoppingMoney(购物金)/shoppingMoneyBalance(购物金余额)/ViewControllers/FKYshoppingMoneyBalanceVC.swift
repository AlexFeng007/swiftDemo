//
//  FKYshoppingMoneyBalanceVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYshoppingMoneyBalanceVC: UIViewController {

    /// 导航栏
    fileprivate var navBar: UIView?

    /// viewModel
    var viewModel: FKYshoppingMoneyBalanceViewModel = FKYshoppingMoneyBalanceViewModel()

    /// 充值购物金的viewModel
    var rechargeViewModel: FKYShoppingMoneyRechargeViewModel = FKYShoppingMoneyRechargeViewModel()

    /// 各个tab的生成数据，方便后期扩展
    var tabDataList: [[FKYShoppingMoneyRecordModel]] = []

    /// 储存各个类型的记录View
    lazy var tabViewList: [FKYShoppingMoneySingleTebView] = []

    /// 最外层容器视图是否可以滚动
    var isBackContainerIsCanScroll = true

    ///  最外层容器Scroll是否正在滚动
    var isBackContainerIsScrollIng = false

    /// 下方切换tab的Scroll是正在滚动
    var isBottomScrollIsScrolling = false

    /// 最大上下滑动偏移量
    var maxOffset: CGFloat = 0

    /// 是否需要刷新，用于从别的界面回退回来时候设置的标志位
    var isNeedRefrash = false

    /// 上方的购物金账户余额信息
    lazy var accountInfoView: FKYShoppingMoneyAccountInfoView = FKYShoppingMoneyAccountInfoView()

    /// 中部记录的切换视图
    lazy var tabSwitchView: FKYShoppingMoneySwitchView = FKYShoppingMoneySwitchView()

    /// 当前展示的第几个tab
    var currentDisplayTabIndex = 0

    /// 背后的容器视图最后的便宜位置
    var backScrollLastOffsetY: CGFloat = 0.0

    /// 容器滚动视图
    lazy var backContainerScroll: FKYshoppingMoneyScrollView = self.creatBackContainerScroll()

    /// 下方的滚动视图
    lazy var bottomScrollContianerView: UIScrollView = self.creatBottomScrollContianerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.processingData()
        self.setupUI()
        self.requestShoppingMoneyInfo()
        self.requestAllTabData()
        self.requestRechargeList()
        self.addNewBi(itemID: "I6102", itemName: "全部记录", itemPosition: "1")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updataMaxOffset()
        if self.isNeedRefrash {
            self.requestShoppingMoneyInfo()
            self.requestAllTabData()
            self.isNeedRefrash = false
        }
    }
}

//MARK: - 响应事件
extension FKYshoppingMoneyBalanceVC {
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable: Any]! = [:]) {
        if eventName == FKYShoppingMoneySwitchView.FKY_allRecordAction { // 切换到所有记录
            self.showTabData(index: 0, data: self.tabDataList[0])
            self.scrollToTab(index: 0)
        } else if eventName == FKYShoppingMoneySwitchView.FKY_incomeRecordAction { // 切换到收入
            self.showTabData(index: 1, data: self.tabDataList[1])
            self.scrollToTab(index: 1)
        } else if eventName == FKYShoppingMoneySwitchView.FKY_expenditureRecordAction { // 切换到支出
            self.showTabData(index: 2, data: self.tabDataList[2])
            self.scrollToTab(index: 2)
        } else if eventName == FKYShoppingMoneyAccountInfoView.FKY_goToRechargeAction { // 去充值
            self.jumpToShoppingMoneyRechargeVC()
        } else if eventName == FKYShoppingMoneySingleTebView.FKY_ShoppingMoneyRefreshAction { // 下拉刷新
            self.pullRefrash()
        } else if eventName == FKYShoppingMoneySingleTebView.FKY_ShoppingMoneyLoadMoreAction { // 上拉加载
            self.loadMore()
        } else if eventName == FKYShoppingMoneySingleTebView.FKY_ShoppingMoneyCellClickedAction { // cell点击
            let cellModel = userInfo[FKYUserParameterKey] as! FKYShoppingMoneyRecordModel
            self.cellClkick(cellModel: cellModel)
        } else if eventName == FKYShoppingMoneySingleTebView.FKY_ShoppingMoneyOutsideCanScrollAction { // 外层可以滚动了
            self.isBackContainerIsCanScroll = true
        }
    }

    /// cell点击
    func cellClkick(cellModel:FKYShoppingMoneyRecordModel){
        guard cellModel.orderNo.isEmpty == false else {
            return
        }
        FKYNavigator.shared().openScheme(FKY_OrderDetailController.self, setProperty: { (svc) in
            let orderDetailVC = svc as! FKYOrderDetailViewController
            let orderModel = FKYOrderModel.init()
            orderModel!.orderId = cellModel.orderNo
            orderDetailVC.orderModel = orderModel
        }, isModal: false, animated: true)
    }
    
    /// 下拉刷新
    func pullRefrash(){
        self.installPageInfo(tabIndex: self.currentDisplayTabIndex)
        if self.currentDisplayTabIndex == 0 { // 所有记录
            self.viewModel.allRacord.removeAll()
            self.requestShoppingMoneyRecord(expend: false, income: false)
        } else if self.currentDisplayTabIndex == 1 { // 收入
            self.viewModel.incomeRecord.removeAll()
            self.requestShoppingMoneyRecord(expend: false, income: true)
        } else if self.currentDisplayTabIndex == 2 { // 支出
            self.viewModel.expendRacord.removeAll()
            self.requestShoppingMoneyRecord(expend: true, income: false)
        }
    }
    
    /// 上拉加载
    func loadMore(){
        if self.currentDisplayTabIndex == 0 { // 所有记录
            self.requestShoppingMoneyRecord(expend: false, income: false)
        } else if self.currentDisplayTabIndex == 1 { // 收入
            self.requestShoppingMoneyRecord(expend: false, income: true)
        } else if self.currentDisplayTabIndex == 2 { // 支出
            self.requestShoppingMoneyRecord(expend: true, income: false)
        }
    }
    
    /// 切换列表 0 全部 1 收入 2支出
    func scrollToTab(index: Int) {
        guard index != self.self.currentDisplayTabIndex else {
            return
        }
        self.currentDisplayTabIndex = index
        self.addSwitchTabBi(index: self.currentDisplayTabIndex)
        /// 这里这样设置是应为在动画中途，如果上下滑动的话各个视图滑动状态会错乱，可能会导致无法滑动的情况。
        self.view.isUserInteractionEnabled = false
        self.bottomScrollContianerView.setContentOffset(CGPoint(x: CGFloat(index) * SCREEN_WIDTH, y: 0), animated: true)
    }
}

//MARK: - 私有方法
extension FKYshoppingMoneyBalanceVC {

    func isBottomScrollContianerViewCanScroll() -> Bool {
        let currentTab = self.tabViewList[self.currentDisplayTabIndex]
        if self.isBackContainerIsScrollIng == false, currentTab.isTableScrolling == false {
            return true
        } else {
            return false
        }
    }

    /// 展示所有tab记录
    func showAllTabData() {
        let temp = [self.viewModel.allRacord, self.viewModel.incomeRecord, self.viewModel.expendRacord]
        for (index, data) in temp.enumerated() {
            self.showTabData(index: index, data: data)
        }
    }

    /// 展示某一个tab的记录
    func showTabData(index: Int, data: [FKYShoppingMoneyRecordModel]) {
        let tab = self.tabViewList[index]
        tab.showData(data: data)
    }

    /// 整理数据
    func processingData() {
        self.tabDataList = [self.viewModel.allRacord, self.viewModel.incomeRecord, self.viewModel.expendRacord]
    }

    /// 初始化所有page信息
    func installAllTabPageInfo() {
        self.installPageInfo(tabIndex: 0)
        self.installPageInfo(tabIndex: 1)
        self.installPageInfo(tabIndex: 2)
    }

    /// 初始化某一个tab的page信息
    func installPageInfo(tabIndex: Int) {
        if tabIndex == 0 { // 全部
            self.viewModel.currentPage1 = 1
            self.viewModel.totlePageCount1 = 2
            self.viewModel.allRacord.removeAll()
        } else if tabIndex == 1 { // 收入
            self.viewModel.currentPage2 = 1
            self.viewModel.totlePageCount2 = 2
            self.viewModel.incomeRecord.removeAll()
        } else if tabIndex == 2 { // 支出.
            self.viewModel.currentPage3 = 1
            self.viewModel.totlePageCount3 = 2
            self.viewModel.expendRacord.removeAll()
        }
    }


    /// 获取当前展示tab的当前数据页index
    func getCurrentTabPageIndex() -> Int {
        if self.currentDisplayTabIndex == 0 {
            return self.viewModel.currentPage1
        } else if self.currentDisplayTabIndex == 1 {
            return self.viewModel.currentPage2
        } else if self.currentDisplayTabIndex == 2 {
            return self.viewModel.currentPage3
        }
        return 0
    }

    /// 设置当前展示tab的当前数据页index
    func setCurrentTabPageIndex(index: Int) {
        if self.currentDisplayTabIndex == 0 {
            self.viewModel.currentPage1 = index
        } else if self.currentDisplayTabIndex == 1 {
            self.viewModel.currentPage2 = index
        } else if self.currentDisplayTabIndex == 2 {
            self.viewModel.currentPage3 = index
        }
    }

    /// 获取当前展示tab的当前数据总页数
    func getCurrentTabTotlePage() -> Int {
        if self.currentDisplayTabIndex == 0 {
            return self.viewModel.totlePageCount1
        } else if self.currentDisplayTabIndex == 1 {
            return self.viewModel.totlePageCount2
        } else if self.currentDisplayTabIndex == 2 {
            return self.viewModel.totlePageCount3
        }
        return 0
    }

    /// 设置当前展示tab的当前数据总页数
    func setCurrentTabTotlePage(totlePage: Int) {
        if self.currentDisplayTabIndex == 0 {
            self.viewModel.totlePageCount1 = totlePage
        } else if self.currentDisplayTabIndex == 1 {
            self.viewModel.totlePageCount2 = totlePage
        } else if self.currentDisplayTabIndex == 2 {
            self.viewModel.totlePageCount3 = totlePage
        }
    }
}

//MARK: - 网络请求
extension FKYshoppingMoneyBalanceVC {

    /// 先请求数据，再跳转界面
    func jumpToShoppingMoneyRechargeVC() {
        self.addNewBi(itemID: "I6101", itemName: "去充值", itemPosition: "1")
        self.rechargeViewModel.requestRechargeInfo { [weak self] (isSuccess, msg) in
            guard let weakSelf = self else {
                return
            }
            guard isSuccess else {
                weakSelf.toast(msg)
                return
            }
            if weakSelf.rechargeViewModel.rechargeActivityList.count > 0 {
                let rechargeVC = FKYShoppingMoneyRechargeVC()
                rechargeVC.modalPresentationStyle = .overFullScreen
                rechargeVC.viewModel.rechargeActivityList = weakSelf.rechargeViewModel.rechargeActivityList
                rechargeVC.successPreChargeCallBack = { [weak self] (dealSeqNo: String, actualChargeAmount: String) in
                    guard let _ = self else {
                        return
                    }
                    FKYNavigator.shared()?.openScheme(FKY_SelectOnlinePay.self, setProperty: { (vc) in
                        let selectPayVC = vc as! COSelectOnlinePayController
                        selectPayVC.orderId = dealSeqNo
                        selectPayVC.orderType = "2"
                        selectPayVC.orderMoney = actualChargeAmount
                        //selectPayVC.supplyId = FKYLoginAPI.currentUser()?.ycenterpriseId ?? ""
                        selectPayVC.fromePage = .shoppingMoney
                    })
                }
                weakSelf.present(rechargeVC, animated: false) {

                }
            }
        }
    }
    /// 请求所有数据  会刷新所有列表，清空所有以前的数据
    @objc func requestAllData() {
        self.installAllTabPageInfo()
        self.processingData()
        self.requestAllTabData()
        self.requestRechargeList()
        self.requestShoppingMoneyInfo()
    }

    /// 请求所有tab数据
    @objc func requestAllTabData() {
        self.installAllTabPageInfo()
        self.requestShoppingMoneyRecord(expend: false, income: false)
        self.requestShoppingMoneyRecord(expend: false, income: true)
        self.requestShoppingMoneyRecord(expend: true, income: false)
    }

    /// 获取充值金额列表
    func requestRechargeList() {
        self.rechargeViewModel.requestRechargeInfo { [weak self] (isSuccess, msg) in
            guard let weakSelf = self else {
                return
            }
            guard isSuccess else {
                weakSelf.toast(msg)
                return
            }
            if weakSelf.rechargeViewModel.rechargeActivityList.count < 1 {
                weakSelf.accountInfoView.hideRechargeBtn(true)
                weakSelf.updataMaxOffset()
            } else {
                weakSelf.accountInfoView.hideRechargeBtn(false)
                weakSelf.updataMaxOffset()
            }
        }
    }

    /// 获取购物金记录
    func requestShoppingMoneyRecord(expend: Bool, income: Bool) {
        if self.getCurrentTabPageIndex() > self.getCurrentTabTotlePage() { // 超出总页数了
            let currentTabView = self.tabViewList[self.currentDisplayTabIndex]
            currentTabView.mainTableView.mj_header.endRefreshing()
            currentTabView.mainTableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        self.viewModel.requestShoppingMoneyRecord(currentPage: self.getCurrentTabPageIndex(), expend: expend, income: income) { [weak self] (isSuccess, msg) in
            guard let weakSelf = self else {
                let currentTabView = self?.tabViewList[self!.currentDisplayTabIndex]
                currentTabView?.mainTableView.mj_header.endRefreshing()
                currentTabView?.mainTableView.mj_footer.endRefreshing()
                return
            }
            let currentTabView = weakSelf.tabViewList[weakSelf.currentDisplayTabIndex]
            guard isSuccess else {
                currentTabView.mainTableView.mj_header.endRefreshing()
                currentTabView.mainTableView.mj_footer.endRefreshing()
                weakSelf.toast(msg)

                weakSelf.processingData()
                if expend == false, income == false { // 全部记录
                    weakSelf.showTabData(index: 0, data: weakSelf.tabDataList[0])
                } else if expend == false, income == true { // 收入记录
                    weakSelf.showTabData(index: 1, data: weakSelf.tabDataList[1])
                } else if expend == true, income == false { // 支出记录
                    weakSelf.showTabData(index: 2, data: weakSelf.tabDataList[2])
                }
                return
            }

            /// 设置上拉加载的状态
            if weakSelf.getCurrentTabPageIndex() >= weakSelf.getCurrentTabTotlePage() {
                currentTabView.mainTableView.mj_header.endRefreshing()
                currentTabView.mainTableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                currentTabView.mainTableView.mj_header.endRefreshing()
                currentTabView.mainTableView.mj_footer.endRefreshing()
            }

            weakSelf.processingData()
            if expend == false, income == false { // 全部记录
                weakSelf.showTabData(index: 0, data: weakSelf.tabDataList[0])
                weakSelf.viewModel.currentPage1 = weakSelf.viewModel.currentPage1 + 1
            } else if expend == false, income == true { // 收入记录
                weakSelf.showTabData(index: 1, data: weakSelf.tabDataList[1])
                weakSelf.viewModel.currentPage2 = weakSelf.viewModel.currentPage2 + 1
            } else if expend == true, income == false { // 支出记录
                weakSelf.showTabData(index: 2, data: weakSelf.tabDataList[2])
                weakSelf.viewModel.currentPage3 = weakSelf.viewModel.currentPage3 + 1
            }
        }
    }

    /// 获取购物金余额
    @objc func requestShoppingMoneyInfo() {
        self.viewModel.requestShoppingMoneyInfo { [weak self] (isSuccess, msg) in
            guard let weakSelf = self else {
                return
            }
            guard isSuccess else {
                weakSelf.toast(msg)
                return
            }
            weakSelf.accountInfoView.showData(data: weakSelf.viewModel.shoppingMoneyInfo)
            weakSelf.updataMaxOffset()
        }
    }
}

//MARK: - UI
extension FKYshoppingMoneyBalanceVC {

    func setupUI() {
        self.view.backgroundColor = RGBColor(0xF2F2F2)
        self.configNaviBar()
        self.configTabs()

        self.view.addSubview(self.backContainerScroll)
        self.backContainerScroll.addSubview(self.accountInfoView)
        self.backContainerScroll.addSubview(self.tabSwitchView)
        self.backContainerScroll.addSubview(self.bottomScrollContianerView)

        self.backContainerScroll.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.navBar!.snp_bottom)
        }

        self.accountInfoView.snp_makeConstraints { (make) in
            make.centerX.top.left.right.equalToSuperview()
        }

        self.tabSwitchView.snp_makeConstraints { (make) in
            make.top.equalTo(self.accountInfoView.snp_bottom).offset(WH(13))
            make.centerX.left.right.equalToSuperview()
            make.height.equalTo(WH(45))
        }

        self.accountInfoView.layoutIfNeeded()
        self.tabSwitchView.layoutIfNeeded()
        self.navBar!.layoutIfNeeded()
        self.bottomScrollContianerView.snp_makeConstraints { (make) in
            make.top.equalTo(self.tabSwitchView.snp_bottom)
            make.centerX.left.bottom.right.equalToSuperview()
            make.height.equalTo(SCREEN_HEIGHT - self.navBar!.hd_height - self.tabSwitchView.hd_height)
        }
    }

    /// 配置各个列表
    func configTabs() {
        self.tabViewList.removeAll()

        var x: CGFloat = 0
        for (index, _) in self.tabDataList.enumerated() {
            let view = FKYShoppingMoneySingleTebView()
            self.bottomScrollContianerView.addSubview(view)
            view.snp_makeConstraints { (make) in
                make.left.equalToSuperview().offset(x)
                make.top.centerY.bottom.equalToSuperview()
                make.width.equalTo(SCREEN_WIDTH)
            }
            if index == self.tabDataList.count - 1 { // 最后一个
                view.snp_remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(x)
                    make.top.centerY.bottom.equalToSuperview()
                    make.width.equalTo(SCREEN_WIDTH)
                    make.right.equalToSuperview()
                }
            }
            self.tabViewList.append(view)
            x += SCREEN_WIDTH
        }
    }

    /// 配置导航栏
    func configNaviBar() {
        self.navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            } else {
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
        }()
        self.fky_setupTitleLabel("购物金余额")
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self] () in
            guard let _ = self else {
                return
            }
            FKYNavigator.shared().pop()
        }

        /*
        self.fky_setupRightTitle("使用帮助") {[weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.toast("使用帮助点击")
        }
        self.fky_setRightTitleColor(color: RGBColor(0x333333))
        */
    }

    /// 更新最大偏移量
    func updataMaxOffset() {
        self.backContainerScroll.layoutIfNeeded()
        self.maxOffset = self.backContainerScroll.contentSize.height - (SCREEN_HEIGHT - self.navBar!.hd_height)
    }
}

//MARK: - ScrollView 代理
extension FKYshoppingMoneyBalanceVC: UIScrollViewDelegate {

    /// 停止拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.bottomScrollContianerView {
            if decelerate == false {
                let currentIndex: Int = Int(scrollView.contentOffset.x / SCREEN_WIDTH)
                self.tabSwitchView.selectedBtnWithIndex(currentIndex)
                if currentIndex != self.currentDisplayTabIndex{
                    self.addSwitchTabBi(index: self.currentDisplayTabIndex)
                }
                self.currentDisplayTabIndex = currentIndex
                
                self.isBottomScrollIsScrolling = false
            } else {

            }
        } else if scrollView == self.backContainerScroll {
            self.isBackContainerIsScrollIng = false
        }
    }

    // 停止惯性
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.bottomScrollContianerView {
            let currentIndex: Int = Int(scrollView.contentOffset.x / SCREEN_WIDTH)
            self.tabSwitchView.selectedBtnWithIndex(currentIndex)
            if currentIndex != self.currentDisplayTabIndex{
                self.addSwitchTabBi(index: self.currentDisplayTabIndex)
            }
            self.currentDisplayTabIndex = currentIndex
            //self.addSwitchTabBi(index: self.currentDisplayTabIndex)
            self.isBottomScrollIsScrolling = false
        } else if scrollView == self.backContainerScroll {

        }
    }

    /// 开始滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView == self.bottomScrollContianerView {

            if self.isBottomScrollContianerViewCanScroll() {
                self.isBottomScrollIsScrolling = true
            } else {
                if self.isBottomScrollIsScrolling == false {
                    let currentOffsetX = CGFloat(self.currentDisplayTabIndex) * SCREEN_WIDTH
                    scrollView.contentOffset.x = currentOffsetX
                }
            }
        }
        if scrollView == self.backContainerScroll, self.isBottomScrollIsScrolling == true {
            self.backContainerScroll.contentOffset.y = self.backScrollLastOffsetY
            return
        }
        guard scrollView == self.backContainerScroll, self.isBottomScrollIsScrolling == false else {
            return
        }
        if self.isBackContainerIsCanScroll == false { // 只有在外层上滑到最上面，并且内层table不是在头部并且向下滑动的情况，外层的都不允许滑动
            scrollView.contentOffset.y = self.maxOffset
            self.backScrollLastOffsetY = self.maxOffset
        } else {
            self.backScrollLastOffsetY = scrollView.contentOffset.y
            for tabView in self.tabViewList {
                tabView.isCanRefrash = false
            }
            if scrollView.contentOffset.y >= self.maxOffset {
                self.isBackContainerIsCanScroll = false
                for tabView in self.tabViewList {
                    tabView.isCanScroll = true
                    tabView.isCanLoadMore = true
                }
            }
            if scrollView.contentOffset.y == 0 {
                for tabView in self.tabViewList {
                    tabView.isCanScroll = true
                    tabView.isCanRefrash = true
                    tabView.isCanLoadMore = false
                }
            }
        }
    }

    /// 停止滚动动画
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.bottomScrollContianerView {
            self.view.isUserInteractionEnabled = true
            self.isBottomScrollIsScrolling = false
        } else if scrollView == self.backContainerScroll {
            if scrollView.contentOffset.y == 0 {
                for tabView in self.tabViewList {
                    tabView.isCanScroll = true
                    tabView.isCanRefrash = true
                }
            }
        }
    }
}

//MARK: - BI埋点
extension FKYshoppingMoneyBalanceVC {
    
    func addSwitchTabBi(index:Int){
        var name = ""
        var position = ""
        if index == 0{//全部
            name = "全部记录"
            position = "1"
        }else if index == 1{// 收入
            name = "收入记录"
            position = "2"
        }else if index == 2{// 支出
            name = "支出记录"
            position = "3"
        }
        self.addNewBi(itemID: "I6102", itemName: name, itemPosition: position)
    }
    
    func addNewBi(itemID:String,itemName:String,itemPosition:String){
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: itemID, itemPosition: itemPosition, itemName:itemName, itemContent: nil, itemTitle: nil, extendParams:nil, viewController: self)
    }
}

//MARK: - 属性对应的生成方法
extension FKYshoppingMoneyBalanceVC {
    func creatBackContainerScroll() -> FKYshoppingMoneyScrollView {
        let scroll = FKYshoppingMoneyScrollView()
        scroll.delegate = self
        scroll.backgroundColor = RGBColor(0xF2F2F2)
        scroll.showsVerticalScrollIndicator = false
        scroll.bounces = false
        return scroll
    }

    func creatBottomScrollContianerView() -> UIScrollView {
        let scroll = UIScrollView()
        scroll.delegate = self
        scroll.backgroundColor = RGBColor(0xF2F2F2)
        scroll.isPagingEnabled = true
        scroll.bounces = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }

}

