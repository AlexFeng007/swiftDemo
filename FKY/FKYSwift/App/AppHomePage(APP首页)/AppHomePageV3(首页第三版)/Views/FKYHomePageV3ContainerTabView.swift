//
//  FKYHomePageV3ContainerTabView.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/14.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePageV3ContainerTabView: UIView {
    
    
    /// 通知父scroll，向上滚动
    //static let collectionViewScrollUp = "FKYHomePageV3ContainerTabView-collectionViewSCrollUp"
    /// 通知父scroll，向下滚动
    
    /// 更新子co的滚动状态
    static let updataCollectionScrollStatus = "FKYHomePageV3ContainerTabView-updataCollectionScrollStatus"
    
    //static let collectionViewScrollDown = "FKYHomePageV3ContainerTabView-collectionViewScrollDown"
    
    /// 切换视图滚动了
    static let switchScrollViewDidScroll = "FKYHomePageV3ContainerTabView-switchScrollViewDidScroll"
    
    /// 滑动切换了tab
    static let scrollSwitchTab = "FKYHomePageV3ContainerTabView-scrollSwitchTab"
    
    /// 上拉加载
    static let pullUpLoadAction = "FKYHomePageV3ContainerTabView-pullUpLoadAction"
    
    /// 点击了卡片
    static let itemClickAction = "FKYHomePageV3ContainerTabView-itemClickAction"
    
    /// item展示事件
    static let itemShowAction = "FKYHomePageV3ContainerTabView-itemShowAction"

    /// 父table是否滚动到底部了
    var isSupperScrollToBottom = false
    
    /// 父table是否滚动到顶部
    var isSupperScrollToTop = false
    
    /// 滚动容器最后的offset
    var containerScrollViewLastOffSetX:CGFloat = 0
    
    /// 四个瀑布流的容器视图
    let collectionContainerView:UIView = UIView()
    
    /// 单个collectionView的宽度
    let collectionViewWidth = SCREEN_WIDTH - WH(20)
    
    /// 四个collection的数组
    var collectionList:[UICollectionView] = [UICollectionView]()
    
    /// 当前展示的第几个列表 从0开始
    var currentCollectionIndex:Int = 0;
    
    /// 当前展示的collection最后一次的offsetY
    var currentCollectionLastOffsetY:CGFloat = 0;
    
    /// 储存4个collection最后一次的offset
    lazy var lastOffsetYList:[CGFloat] = [-self.getTipInset(),-self.getTipInset(),-self.getTipInset(),-self.getTipInset()]
    
    //行高管理器
    fileprivate var cellHeightManager:ContentHeightManager = {
        let heightManager = ContentHeightManager()
        return heightManager
    }()
    /// 横向滚动的视图
    lazy var containerScrollView:FKYMultiGestureScrollView = {
        let scroll = FKYMultiGestureScrollView()
        scroll.delegate = self
        scroll.isPagingEnabled = true
        scroll.bounces = false
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    /// 储存4个空态视图
    var emptyViewList:[FKYCommonEmptyView] = [FKYCommonEmptyView]()
    
    /// 4个空态图
    fileprivate lazy var activityEmptyView1: FKYCommonEmptyView = {
        let view = FKYCommonEmptyView()
        view.mainTitle?.font = .systemFont(ofSize: WH(14))
        view.mainTitle?.textColor = RGBColor(0x999999)
        view.configEmptyView("image_search_empty", title: "活动暂无商品", subtitle: nil)
        return view
    }()
    
    fileprivate lazy var activityEmptyView2: FKYCommonEmptyView = {
        let view = FKYCommonEmptyView()
        view.mainTitle?.font = .systemFont(ofSize: WH(14))
        view.mainTitle?.textColor = RGBColor(0x999999)
        view.configEmptyView("image_search_empty", title: "活动暂无商品", subtitle: nil)
        return view
    }()
    
    fileprivate lazy var activityEmptyView3: FKYCommonEmptyView = {
        let view = FKYCommonEmptyView()
        view.mainTitle?.font = .systemFont(ofSize: WH(14))
        view.mainTitle?.textColor = RGBColor(0x999999)
        view.configEmptyView("image_search_empty", title: "活动暂无商品", subtitle: nil)
        return view
    }()
    
    fileprivate lazy var activityEmptyView4: FKYCommonEmptyView = {
        let view = FKYCommonEmptyView()
        view.mainTitle?.font = .systemFont(ofSize: WH(14))
        view.mainTitle?.textColor = RGBColor(0x999999)
        view.configEmptyView("image_search_empty", title: "活动暂无商品", subtitle: nil)
        return view
    }()
    
    /// 四个collectionView
    lazy var collectionView1:FKYMultiGestureCollectionView = {
        //let layout = UICollectionViewFlowLayout()

        let layout = WaterfallMutiSectionFlowLayout()
        layout.delegate = self
        layout.scrollDirection = .vertical
        //layout.estimatedItemSize = CGSize(width: WH(172), height: WH(240))
        let collection = FKYMultiGestureCollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = RGBColor(0xF4F4F4)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.scrollsToTop = false
        //collection.bounces = false
        collection.contentInset = UIEdgeInsets(top: self.getTipInset(), left: WH(0), bottom: WH(0), right: WH(0))
        collection.register(FKYHomePagePuBuItem.self, forCellWithReuseIdentifier: NSStringFromClass(FKYHomePagePuBuItem.self))
        collection.register(FKYTempFloorCell.self, forCellWithReuseIdentifier: NSStringFromClass(FKYTempFloorCell.self))
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(FKYHomePageV3ContainerTabView.pullUPLoad))
        footer?.setTitle("--没有更多啦！--", for: .noMoreData)
        collection.mj_footer = footer
        return collection
    }()
    
    lazy var collectionView2:FKYMultiGestureCollectionView = {
        let layout = WaterfallMutiSectionFlowLayout()
        layout.delegate = self
        layout.scrollDirection = .vertical
       // layout.estimatedItemSize = CGSize(width: WH(172), height: WH(240))
        let collection = FKYMultiGestureCollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.scrollsToTop = false
        collection.backgroundColor = RGBColor(0xF4F4F4)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(FKYHomePageV3ContainerTabView.pullUPLoad))
        footer?.setTitle("--没有更多啦！--", for: .noMoreData)
        collection.mj_footer = footer
        //collection.bounces = false
        collection.contentInset = UIEdgeInsets(top: self.getTipInset(), left: WH(0), bottom: WH(10), right: WH(0))
        collection.register(FKYHomePagePuBuItem.self, forCellWithReuseIdentifier: NSStringFromClass(FKYHomePagePuBuItem.self))
        collection.register(FKYTempFloorCell.self, forCellWithReuseIdentifier: NSStringFromClass(FKYTempFloorCell.self))
        return collection
    }()
    
    lazy var collectionView3:FKYMultiGestureCollectionView = {
        let layout = WaterfallMutiSectionFlowLayout()
        layout.delegate = self
        layout.scrollDirection = .vertical
        //layout.estimatedItemSize = CGSize(width: WH(172), height: WH(240))
        let collection = FKYMultiGestureCollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.scrollsToTop = false
        collection.backgroundColor = RGBColor(0xF4F4F4)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(FKYHomePageV3ContainerTabView.pullUPLoad))
        footer?.setTitle("--没有更多啦！--", for: .noMoreData)
        collection.mj_footer = footer
        //collection.bounces = false
        collection.contentInset = UIEdgeInsets(top: self.getTipInset(), left: WH(0), bottom: WH(10), right: WH(0))
        collection.register(FKYHomePagePuBuItem.self, forCellWithReuseIdentifier: NSStringFromClass(FKYHomePagePuBuItem.self))
        collection.register(FKYTempFloorCell.self, forCellWithReuseIdentifier: NSStringFromClass(FKYTempFloorCell.self))
        return collection
    }()
    
    lazy var collectionView4:FKYMultiGestureCollectionView = {
        let layout = WaterfallMutiSectionFlowLayout()
        layout.delegate = self
        layout.scrollDirection = .vertical
       // layout.estimatedItemSize = CGSize(width: WH(172), height: WH(240))
        let collection = FKYMultiGestureCollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.scrollsToTop = false
        collection.backgroundColor = RGBColor(0xF4F4F4)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(FKYHomePageV3ContainerTabView.pullUPLoad))
        footer?.setTitle("--没有更多啦！--", for: .noMoreData)
        collection.mj_footer = footer
        //collection.bounces = false
        collection.contentInset = UIEdgeInsets(top: self.getTipInset(), left: WH(0), bottom: WH(10), right: WH(0))
        collection.register(FKYHomePagePuBuItem.self, forCellWithReuseIdentifier: NSStringFromClass(FKYHomePagePuBuItem.self))
        collection.register(FKYTempFloorCell.self, forCellWithReuseIdentifier: NSStringFromClass(FKYTempFloorCell.self))
        return collection
    }()
    
    var tabList:[FKYHomePageV3FlowTabModel] = [FKYHomePageV3FlowTabModel]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        collectionList.removeAll()
        collectionList.append(self.collectionView1)
        collectionList.append(self.collectionView2)
        collectionList.append(self.collectionView3)
        collectionList.append(self.collectionView4)
        
        emptyViewList = [activityEmptyView1,activityEmptyView2,activityEmptyView3,activityEmptyView4]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: - 数据展示
extension FKYHomePageV3ContainerTabView {
    /*
    func configCell(cellData:FKYHomePageV3CellModel){
        endRefrashAnimation()
        self.cellData = cellData
        scrollTopPage(page: cellData.currentDisplayIndex)
        showTabPageCount(count: cellData.flowTabModelList.count)
        showTabData(pageIndex: cellData.currentDisplayIndex)
    }
    */
    
    /// 显示信息流
    func configTabData(tabList:[FKYHomePageV3FlowTabModel],currentTab:Int){
        self.tabList = tabList
//        configEmptyView()
//        endRefrashAnimation()
//        showTabPageCount(count: tabList.count)
//        currentCollectionIndex = currentTab
//        showTabData(pageIndex:self.currentCollectionIndex)
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                strongSelf.configEmptyView()
                strongSelf.endRefrashAnimation()
                strongSelf.showTabPageCount(count: tabList.count)
                strongSelf.currentCollectionIndex = currentTab
                strongSelf.showTabData(pageIndex:strongSelf.currentCollectionIndex)
            }
        }
    }
    
    func showTabData(pageIndex:Int){
        guard pageIndex < collectionList.count else{
            return
        }
        
        let co = collectionList[pageIndex]
        co.collectionViewLayout.invalidateLayout()
        co.reloadData()
    }
    
    
    /// 切换page
    /// - Parameter page: index
    func scrollTopPage(page:Int){
        
        guard page < lastOffsetYList.count else {
            return
        }
        currentCollectionLastOffsetY = lastOffsetYList[page]
        
        if currentCollectionLastOffsetY > 0{
            routerEvent(withName: FKYHomePageV3ContainerTabView.updataCollectionScrollStatus, userInfo: [FKYUserParameterKey:false])
        }else{
            routerEvent(withName: FKYHomePageV3ContainerTabView.updataCollectionScrollStatus, userInfo: [FKYUserParameterKey:true])
        }
        
        containerScrollView.setContentOffset(CGPoint(x:collectionViewWidth * CGFloat(page), y: 0), animated: true)
        showTabData(pageIndex: currentCollectionIndex)
        
    }
}



//MARK: - 事件响应
extension FKYHomePageV3ContainerTabView {
    
    /// 上拉加载
    @objc func pullUPLoad(){
        
        guard currentCollectionIndex < tabList.count else {
            endRefrashAnimation()
            return
        }
        
        let currentItemData = tabList[currentCollectionIndex]
        guard currentItemData.hasNextPage,currentItemData.isUPloading == false else {
            endRefrashAnimation()
            return
        }
        currentItemData.isUPloading = true
        routerEvent(withName: FKYHomePageV3ContainerTabView.pullUpLoadAction, userInfo: [FKYUserParameterKey:currentCollectionIndex])
    }
    
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKYHomePageV3ProductInfoView.rightBtnAction {// 拦截加车按钮加参数
            
            let itemData = userInfo[FKYUserParameterKey] as! FKYHomePageV3FlowItemModel
            guard currentCollectionIndex < tabList.count else{
                return
            }
            // 当前tab的列表
            let dataList = tabList[currentCollectionIndex]
            var index = -199
            for (index_t,itemData_t) in dataList.list.enumerated() {
                if itemData == itemData_t {
                    index = index_t
                }
            }
            
            guard index >= 0 else {
                return
            }
            
            super.routerEvent(withName: FKYHomePagePuBuItem.addCarAction, userInfo: [FKYUserParameterKey:["currentTab":currentCollectionIndex,"index":index,"itemData":itemData]])
        }else if eventName == FKYHomePagePuBuItem.updataImageHeight {// 只有GIF才更新高度
            guard currentCollectionIndex < collectionList.count else{
                return
            }
            let itemData = userInfo[FKYUserParameterKey] as! FKYHomePageV3FlowItemModel
            // 当前tab的列表
            let dataList = tabList[currentCollectionIndex]
            var index = -199
            for (index_t,item) in dataList.list.enumerated() {
                if item == itemData {
                    index = index_t
                }
            }
            guard index >= 0 else {
                return
            }
            let co = collectionList[currentCollectionIndex]
            guard index <= co.numberOfItems(inSection: 0) else{
                return
            }
            //co.reloadItems(at: [IndexPath(item: index, section: 0)])
            co.collectionViewLayout.invalidateLayout()
            co.reloadData()
        }
        else{
            super.routerEvent(withName: eventName, userInfo: userInfo)
        }
    }
}


//MARK: - 私有方法
extension FKYHomePageV3ContainerTabView {
    
    /// collectionview 上方的间隔
    func getTipInset() -> CGFloat {
        //return WH(10)
        return WH(0)
    }
    
    /// 结束刷新
    func endRefrashAnimation(){
        guard currentCollectionIndex < collectionList.count,currentCollectionIndex < tabList.count else {
            for co in collectionList{
                co.mj_footer.endRefreshing()
            }
            return
        }
        let co = collectionList[currentCollectionIndex]
        let itemData = tabList[currentCollectionIndex]
        if itemData.isUPloading == false {
            if itemData.hasNextPage {
                if itemData.list.count < 1 {
                    co.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    co.mj_footer.endRefreshing()
                }
                
                co.collectionViewLayout.invalidateLayout()
                co.reloadData()
            }else{
                co.mj_footer.endRefreshingWithNoMoreData()
                co.collectionViewLayout.invalidateLayout()
                co.reloadData()
            }
        }
        
    }
    
    /// 设置co是否可以滚动
    func isCollectionViewCanScroll(isCan:Bool){
        for co in collectionList{
            co.isScrollEnabled = isCan
        }
    }
}



//MARK: - ScrollView代理
extension FKYHomePageV3ContainerTabView:UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == containerScrollView{// 滚动的是下方的容器视图
            isCollectionViewCanScroll(isCan: false)
            containerScrollViewLastOffSetX = scrollView.contentOffset.x
        }else{
            containerScrollView.isScrollEnabled = false
            
            for co in collectionList {
                if co == scrollView {// 滚动的是瀑布流
                    // 先判断co是在向上还是在向下滚动
                    let scrollDirection = scrollView.contentOffset.y - currentCollectionLastOffsetY
                    if scrollDirection >= 0 {// 界面在向上移动
                        /// 先判断父table位置
                        if isSupperScrollToBottom {// 父table已经向上移动到底 此时co可以滑动
                            currentCollectionLastOffsetY = scrollView.contentOffset.y
                        }else{// 父tabel没有向上移动到底，需要先让父table移动
                            scrollView.contentOffset.y = currentCollectionLastOffsetY
                        }
                        
                    }else{// 界面在向下移动
                        if scrollView.contentOffset.y <= 0 {// 子co已经向下移动到顶部 可以通知父table滚动
                            scrollView.contentOffset.y = 0
                            currentCollectionLastOffsetY = 0
                            routerEvent(withName: FKYHomePageV3ContainerTabView.updataCollectionScrollStatus, userInfo: [FKYUserParameterKey:true])
                        }else{// 子co还未向下移动到顶部，父table不可以滚动
                            currentCollectionLastOffsetY = scrollView.contentOffset.y
                            routerEvent(withName: FKYHomePageV3ContainerTabView.updataCollectionScrollStatus, userInfo: [FKYUserParameterKey:false])
                        }
                    }
                    
                }
            }
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.containerScrollView {
            isCollectionViewCanScroll(isCan: true)
            
            let currentIndex = Int((scrollView.contentOffset.x+1)/CGFloat(collectionViewWidth))
            guard currentIndex != currentCollectionIndex,currentCollectionIndex < tabList.count else{
                return
            }
            
            let currentItemData = tabList[currentCollectionIndex]
            currentItemData.isUPloading = false
            
            lastOffsetYList[currentCollectionIndex] = currentCollectionLastOffsetY
            currentCollectionLastOffsetY = lastOffsetYList[currentCollectionIndex]
            currentCollectionIndex = currentIndex
            
            showTabData(pageIndex: currentCollectionIndex)
            
            /// 更新当前tab的滚动状态
            if currentCollectionLastOffsetY > 0{
                routerEvent(withName: FKYHomePageV3ContainerTabView.updataCollectionScrollStatus, userInfo: [FKYUserParameterKey:false])
            }else{
                routerEvent(withName: FKYHomePageV3ContainerTabView.updataCollectionScrollStatus, userInfo: [FKYUserParameterKey:true])
            }
            
            routerEvent(withName: FKYHomePageV3ContainerTabView.scrollSwitchTab, userInfo: [FKYUserParameterKey:currentCollectionIndex])
            
        }else{
            containerScrollView.isScrollEnabled = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.containerScrollView {
            isCollectionViewCanScroll(isCan: true)
            
            let currentIndex = Int((scrollView.contentOffset.x+1)/CGFloat(collectionViewWidth))
            guard currentIndex != currentCollectionIndex,currentCollectionIndex < tabList.count else{
                return
            }
            
            let currentItemData = tabList[currentCollectionIndex]
            currentItemData.isUPloading = false
            
            lastOffsetYList[currentCollectionIndex] = currentCollectionLastOffsetY
            currentCollectionLastOffsetY = lastOffsetYList[currentCollectionIndex]
            currentCollectionIndex = currentIndex
            
            showTabData(pageIndex: currentCollectionIndex)
            
            /// 更新当前tab的滚动状态
            if currentCollectionLastOffsetY > 0{
                routerEvent(withName: FKYHomePageV3ContainerTabView.updataCollectionScrollStatus, userInfo: [FKYUserParameterKey:false])
            }else{
                routerEvent(withName: FKYHomePageV3ContainerTabView.updataCollectionScrollStatus, userInfo: [FKYUserParameterKey:true])
            }
            
            routerEvent(withName: FKYHomePageV3ContainerTabView.scrollSwitchTab, userInfo: [FKYUserParameterKey:currentCollectionIndex])
            
        }else{
            containerScrollView.isScrollEnabled = true
            
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.containerScrollView {
            
            isCollectionViewCanScroll(isCan: true)
            
            let currentIndex = Int((scrollView.contentOffset.x+1)/CGFloat(collectionViewWidth))
            guard currentIndex != currentCollectionIndex,currentCollectionIndex < tabList.count else{
                return
            }
            
            let currentItemData = tabList[currentCollectionIndex]
            currentItemData.isUPloading = false
            
            lastOffsetYList[currentCollectionIndex] = currentCollectionLastOffsetY
            currentCollectionLastOffsetY = lastOffsetYList[currentCollectionIndex]
            currentCollectionIndex = currentIndex
            
            showTabData(pageIndex: currentCollectionIndex)
            
            /// 更新当前tab的滚动状态
            if currentCollectionLastOffsetY > 0{
                routerEvent(withName: FKYHomePageV3ContainerTabView.updataCollectionScrollStatus, userInfo: [FKYUserParameterKey:false])
            }else{
                routerEvent(withName: FKYHomePageV3ContainerTabView.updataCollectionScrollStatus, userInfo: [FKYUserParameterKey:true])
            }
            
            routerEvent(withName: FKYHomePageV3ContainerTabView.scrollSwitchTab, userInfo: [FKYUserParameterKey:currentCollectionIndex])
            
        }else{
            containerScrollView.isScrollEnabled = true
        }
        
    }
    
}


//MARK: - collectionView代理
extension FKYHomePageV3ContainerTabView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WaterfallMutiSectionDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard currentCollectionIndex < tabList.count else {
            return 0
        }
        // 当前tab的列表
        let dataList = tabList[currentCollectionIndex]
        // 当前item的数据
        return dataList.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let co = collectionList[currentCollectionIndex]
        if co != collectionView {
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FKYTempFloorCell.self), for: indexPath) as! FKYTempFloorCell
            return item
        }
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FKYHomePagePuBuItem.self), for: indexPath) as! FKYHomePagePuBuItem
        
        guard currentCollectionIndex < tabList.count else {
            return item
        }
        // 当前tab的列表
        let dataList = tabList[currentCollectionIndex]
        // 当前item的数据
        guard indexPath.row < dataList.list.count else {
            //item.showTestData()
            return item
        }
        
        // 预加载
        if dataList.list.count - indexPath.row < 40 {
            //pullUPLoad()
        }
        let itemData = dataList.list[indexPath.row]
        item.configItemModel(itemData: itemData)
//        let temp_2 = item.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        itemData.itemSize = temp_2

        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard currentCollectionIndex < tabList.count else {
            return
        }
        
        // 当前tab的列表
        let dataList = tabList[currentCollectionIndex]
        // 当前item的数据
        guard indexPath.row < dataList.list.count else {
            return
        }
        let itemData = dataList.list[indexPath.row]
        routerEvent(withName: FKYHomePageV3ContainerTabView.itemClickAction, userInfo: [FKYUserParameterKey:["index":indexPath.row,"currentTab":currentCollectionIndex,"itemData":itemData]])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard currentCollectionIndex < tabList.count else {
            return
        }
        let co = collectionList[currentCollectionIndex]
        if co != collectionView {
            return
        }
        let dataList = tabList[currentCollectionIndex]
        // 当前item的数据
        guard indexPath.row < dataList.list.count else {
            return
        }
        let itemData = dataList.list[indexPath.row]
        DispatchQueue.global().async {[weak self] in
            guard let strongSelf = self else {
                return
            }
           strongSelf.routerEvent(withName: FKYHomePageV3ContainerTabView.itemShowAction, userInfo: [FKYUserParameterKey:["index":indexPath.row,"currentTab":strongSelf.currentCollectionIndex,"itemData":itemData]])
        }
        
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let dataList = cellData.flowTabModelList[cellData.currentDisplayIndex]
        // 当前item的数据
        guard indexPath.row < dataList.list.count else {
            return
        }
        let itemData = dataList.list[indexPath.row]
        routerEvent(withName: FKYHomePageTabSwitchCell.itemShowAction, userInfo: [FKYUserParameterKey:["index":indexPath.row,"currentTab":currentCollectionIndex,"itemData":itemData]])
    }
    */
    
    // item大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard currentCollectionIndex < tabList.count else {
            
            return CGSize.zero
        }
        let co = collectionList[currentCollectionIndex]
        if co != collectionView {
            return CGSize.zero
        }
        // 当前tab的列表
        let dataList = tabList[currentCollectionIndex]
        // 当前item的数据
        guard indexPath.row < dataList.list.count else {
            //item.showTestData()
            return CGSize.zero
        }
         
        let itemData = dataList.list[indexPath.row]
        let cellHeight = cellHeightManager.getContentCellHeight("\(itemData.spuCode)\(itemData.productType)","\(itemData.supplyId)","homeFlow")
        if  cellHeight == 0{
            let conutCellHeight = FKYHomePagePuBuItem.getCellContentHeight(itemData)
            cellHeightManager.addContentCellHeight("\(itemData.spuCode)\(itemData.productType)","\(itemData.supplyId)","homeFlow", conutCellHeight)
            return CGSize(width: WH(172), height: conutCellHeight)
        }else{
            return CGSize(width: WH(172), height: cellHeight)
        }
    }
    
    
    // 最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(10)
    }
    
    // 最小列间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return WH(10)
    }
    
    func heightForRowAtIndexPath(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        guard currentCollectionIndex < tabList.count else {
            return 0.0000001
        }
        let dataList = tabList[currentCollectionIndex]
        // 当前item的数据
        guard indexPath.row < dataList.list.count else {
            return 0.000001
        }
        
        let co = collectionList[currentCollectionIndex]
        if co != collection {
            return 0.000001
        }
        let itemData = dataList.list[indexPath.row]
        let cellHeight = cellHeightManager.getContentCellHeight("\(itemData.spuCode)\(itemData.productType)","\(itemData.supplyId)","homeFlow")
        if  cellHeight == 0{
            let conutCellHeight = FKYHomePagePuBuItem.getCellContentHeight(itemData)
            cellHeightManager.addContentCellHeight("\(itemData.spuCode)\(itemData.productType)","\(itemData.supplyId)","homeFlow", conutCellHeight)
            return conutCellHeight
        }else{
            return cellHeight
        }
    }
    
    func lineSpacing(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGFloat {
        return WH(10)
    }
    
    func interitemSpacing(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGFloat {
        return WH(10)
    }

}



//MARK: - UI
extension FKYHomePageV3ContainerTabView {
    func setupUI(){
        addSubview(self.containerScrollView)
        containerScrollView.backgroundColor = RGBColor(0xF4F4F4)
        containerScrollView.addSubview(collectionContainerView)
        
        collectionContainerView.addSubview(self.collectionView1)
        collectionContainerView.addSubview(self.collectionView2)
        collectionContainerView.addSubview(self.collectionView3)
        collectionContainerView.addSubview(self.collectionView4)
        
        collectionContainerView.addSubview(activityEmptyView1)
        collectionContainerView.addSubview(activityEmptyView2)
        collectionContainerView.addSubview(activityEmptyView3)
        collectionContainerView.addSubview(activityEmptyView4)
        
        //containerScrollView.contentSize = CGSize(width: collectionViewWidth*4, height: 200)
        
        self.containerScrollView.snp_makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.equalTo(collectionViewWidth)
            make.height.equalTo(400)
        }
        
        collectionContainerView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(400)
        }
        
        self.collectionView1.snp_makeConstraints { (make) in
            make.top.left.bottom.centerY.equalToSuperview()
            make.width.equalTo(collectionViewWidth)
        }
        
        self.collectionView2.snp_makeConstraints { (make) in
            make.top.bottom.centerY.equalToSuperview()
            make.left.equalTo(self.collectionView1.snp_right)
            make.width.equalTo(collectionViewWidth)
        }

        self.collectionView3.snp_makeConstraints { (make) in
            make.top.bottom.centerY.equalToSuperview()
            make.left.equalTo(self.collectionView2.snp_right)
            make.width.equalTo(collectionViewWidth)
        }
        
        self.collectionView4.snp_makeConstraints { (make) in
            make.top.right.bottom.centerY.equalToSuperview()
            make.left.equalTo(self.collectionView3.snp_right).offset(1)
            make.width.equalTo(collectionViewWidth)
        }
        
        activityEmptyView1.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(collectionView1)
        }
        
        activityEmptyView2.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(collectionView2)
        }
        
        activityEmptyView3.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(collectionView3)
        }
        
        activityEmptyView4.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(collectionView4)
        }
        
        self.backgroundColor = .clear
        if #available(iOS 11.0, *) {
            self.collectionView1.contentInsetAdjustmentBehavior = .never
            self.collectionView2.contentInsetAdjustmentBehavior = .never
            self.collectionView3.contentInsetAdjustmentBehavior = .never
            self.collectionView4.contentInsetAdjustmentBehavior = .never
        }
    }
    
    func updataCollectionViewHeight(height:CGFloat){
        
        self.containerScrollView.snp_remakeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.equalTo(collectionViewWidth)
            make.height.equalTo(Int(height))
        }
        
        collectionContainerView.snp_remakeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(Int(height))
        }
        
    }
    
    /// 展示多少个tab，多于的tab隐藏
    /// - Parameter count: 展示tab的数量
    func showTabPageCount(count:Int){
        
        for (index,collection) in collectionList.enumerated() {
            if count >= index+1 {
                collection.snp_updateConstraints { (make) in
                    make.width.equalTo(collectionViewWidth)
                }
            }else{
                collectionView4.snp_updateConstraints { (make) in
                    make.width.equalTo(0)
                }
            }
        }
        
    }
    
    /// 配置空态视图
    func configEmptyView(){
        for (index,tab) in tabList.enumerated() {
            guard index < emptyViewList.count else{
                return
            }
            
            let emptyView = emptyViewList[index]
            if tab.list.count < 1 {// 空的
                collectionContainerView.bringSubviewToFront(emptyView)
            }else{
                collectionContainerView.sendSubviewToBack(emptyView)
            }
        }
    }
}
