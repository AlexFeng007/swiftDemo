//
//  FKYHomePageV3VC.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIImageColors
import UIKit

class FKYHomePageV3VC: UIViewController {
    /// 列表是否可以滚动控制flat
    var isMainTableViewCanScroll = true
    
    /// viewModel
    var viewModel: FKYHomePageV3ViewModel = FKYHomePageV3ViewModel()
    
    /// 状态栏状态
    var barStatus: UIStatusBarStyle = .default
    
    /// 子collection是否向下移动到顶部
    var isSubCollcScrollToTop:Bool = true
    
    var changeBudgeNumAction: ChangeBudgeNumAction?
    
    var spreadModel:FKYCommandEnterTreasuryModel? //推广视图model
    
    var viewIsAppear:Bool = false
    
    /// 记录table最后的offset
    var mainTableLastOffsetY:CGFloat = 0
    
    /// 搜索视图
    lazy var searchBar: HomeSearchBar = {
        let bar = HomeSearchBar()
        bar.operation = self
        bar.containsLeftButtonLayout()
        return bar
    }()
    
    /// 常搜词view
    var hotSearchView: FKYHomePageHotSearchView = FKYHomePageHotSearchView()
    
    /// 背景图片
    lazy var backgroundImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    /// 惊喜视图
    fileprivate lazy var surpriseTipView : FKYTipSurpriseView = {
        let view = FKYTipSurpriseView()
        view.isHidden = true
        view.clickTipView = { [weak self] typeNum in
            guard let strongSelf = self else {
                return
            }
            if typeNum == 1 {
                //去惊喜页面
                FKYNavigator.shared().openScheme(FKY_Send_Coupon_Info.self, setProperty: { (vc) in
                    //
                })
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "底部资源位", itemId: ITEMCODE.HOME_ACTION_SUPRISE_EIXT.rawValue, itemPosition: "1", itemName: "点进资源位", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            }
            strongSelf.updateTipView(true, nil)
        }
        return view
    }()
    
    // MARK:请求失败空视图
    fileprivate lazy var failedView : UIView = {
        weak var weakSelf = self
        let view = self.showEmptyNoDataCustomView_v3(self.view, "no_shop_pic", GET_FAILED_TXT,false) {
            weakSelf?.pullDownRefresh()
        }
//        view.snp.remakeConstraints({ (make) in
//            make.bottom.left.right.equalTo(self.view)
//            make.top.equalTo(self.searchBar.snp.bottom)
//        })
        view.isHidden = true
        return view
    }()
    
    //首页推广入口
    fileprivate lazy var spreadTipView : FKYHomePageSpreadView = {
        let view = FKYHomePageSpreadView()
        view.isHidden = true
        view.clickTipView = { [weak self] typeNum in
            guard let strongSelf = self else {
                return
            }
            if typeNum == 1 {
                //去惊喜页面
                if let app = UIApplication.shared.delegate as? AppDelegate {
                    if let desModel = strongSelf.spreadModel, let url = desModel.jumpUrl, url.isEmpty == false {
                        app.p_openPriveteSchemeString(url)
                    }
                }
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S10205", sectionPosition: "0", sectionName: "首页引导", itemId: ITEMCODE.HOME_ACTION_SUPRISE_APPLY.rawValue, itemPosition: nil, itemName: "立即申请", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            }else {
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S10205", sectionPosition: "0", sectionName: "首页引导", itemId: ITEMCODE.HOME_ACTION_SUPRISE_CLOSE.rawValue, itemPosition: nil, itemName: "关闭弹窗", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            }
            strongSelf.showOrHideSpreadView(true)
            strongSelf.getClickSpreadView()
        }
        return view
    }()
    
    /// 商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        // 首页暂时不需要加车动画
        //addView.finishPoint = CGPoint(x:SCREEN_WIDTH - WH(10)-(self.parent?.NavigationBarRightImage?.frame.size.width)!/2.0,y:naviBarHeight()-WH(5)-(self.parent?.NavigationBarRightImage?.frame.size.height)!/2.0)
        //更改购物车数量
        addView.addCarSuccess = { [weak self] (isSuccess,type,productNum,productModel) in
            if let strongSelf = self {
                if isSuccess == true {
                    if type == 1 {
                        strongSelf.changeBadgeNumber(false)
                    }else if type == 3 {
                        strongSelf.changeBadgeNumber(true)
                    }
                    strongSelf.updataProductCartCount()
                    strongSelf.toast("加入购物车成功")
                }
                //strongSelf.refreshItemOfTable()
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? OftenBuyProductItemModel {
                    //strongSelf.biNewRecord(strongSelf.selectedRow, model,1)
                }
            }
        }
        addView.immediatelyOrderAddCarSuccess = {[weak self] (isSuccess ,productNum, productModel) in
            if let strongSelf = self {
                strongSelf.goOrderCheckViewController()
                if let model = productModel as? FKYPackageRateModel {
                    //strongSelf.add_NEW_BI(3, model, nil)
                }
            }
        }
        return addView
    }()
    
    /// 主table
    lazy var mainTableView: FKYMultiGestureTableview = {
        let tb = FKYMultiGestureTableview()
        tb.delegate = self
        tb.dataSource = self
        // tb.backgroundColor = RGBColor(0xF4F4F4)
        //tb.bounces = false
        tb.separatorStyle = .none
        tb.tableFooterView = UIView(frame: CGRect.zero)
        tb.estimatedRowHeight = WH(500)
        tb.rowHeight = UITableView.automaticDimension
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(FKYHomePageV3VC.userPullDown))
        tb.mj_header = header
        
        // 下方商品列表切换tab cell
        tb.register(FKYHomePageSwitchTabCell.self, forCellReuseIdentifier: NSStringFromClass(FKYHomePageSwitchTabCell.self))
        // 首页轮播图cell
        tb.register(HomeBannerListCell.self, forCellReuseIdentifier: NSStringFromClass(HomeBannerListCell.self))
        // 导航栏cell
        tb.register(FKYHomePageNaviCell.self, forCellReuseIdentifier: NSStringFromClass(FKYHomePageNaviCell.self))
        // 单行广告栏
        tb.register(FKYHomePageSingleAdCell.self, forCellReuseIdentifier: NSStringFromClass(FKYHomePageSingleAdCell.self))
        // 1 2 3个系统推荐cell
        tb.register(FKYHomePageSysRecommendCell.self, forCellReuseIdentifier: NSStringFromClass(FKYHomePageSysRecommendCell.self))
        // 一行两个相同模块
        tb.register(FKYHomePageTwoSameItemCell.self, forCellReuseIdentifier: NSStringFromClass(FKYHomePageTwoSameItemCell.self))
        // 一行两个不同模块
        tb.register(FKYHomePageTwoDifferentItemCell.self, forCellReuseIdentifier: NSStringFromClass(FKYHomePageTwoDifferentItemCell.self))
        // 切换tab的sectionHeader
        tb.register(FKYHomePageSwitchTabHeader.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(FKYHomePageSwitchTabHeader.self))
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if #available(iOS 11.0, *) {
            self.mainTableView.contentInsetAdjustmentBehavior = .never
        } else {
        }
        automaticallyAdjustsScrollViewInsets = false
        //mainTableView.mj_header.beginRefreshing()
        pullDownRefresh()
        self.getHomeDataCache()
        /*
        //updataTableViewInset()
        requestUPFloor()
        requestUnreadMsgCount()
        requestSwitchTab()
        */
        /// 刷新数据 拿到当前的item
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSurpriseTipStrView()
        updataProductCartCount()
        //updataTableViewInset()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // UIApplication.shared.statusBarStyle = .darkContent
        navigationController?.navigationBar.barStyle = .black
        viewIsAppear = true
    }
}

// MARK: - 事件响应

extension FKYHomePageV3VC {
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable: Any]! = [:]) {
        /*
        if eventName == FKYHomePageV3ContainerTabView.collectionViewScrollUp { // table需要向上滚动 offsetY增加
            let offsetY = userInfo[FKYUserParameterKey] as! CGFloat
            mainTableView.contentOffset.y += offsetY
        } else if eventName == FKYHomePageV3ContainerTabView.collectionViewScrollDown { // table需要向下滚动 offsetY减小
            let offsetY = userInfo[FKYUserParameterKey] as! CGFloat
            
            mainTableView.contentOffset.y -= offsetY
            if Int(mainTableView.contentOffset.y) <= -Int(getTopHeight()) {
                mainTableView.contentOffset.y = -getTopHeight()
            }
            
        } else
        */
        
        if eventName == FKYHomePageV3ContainerTabView.updataCollectionScrollStatus {// 更新子collec滚动状态
            let status = userInfo[FKYUserParameterKey] as! Bool
            isSubCollcScrollToTop = status
        }else if eventName == FKYCirclePageView.itemClicked { /// 轮播图item点击
            let bannerDic = userInfo[FKYUserParameterKey] as! [String:Any]
            let bannerData = bannerDic["cellData"] as! FKYHomePageV3ItemModel
            let index = bannerDic["index"] as! Int
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F1011", floorPosition: "1", floorName: "运营首页", sectionId: nil, sectionPosition: nil, sectionName: "轮播图", itemId: "I1001", itemPosition: "\(index+1)", itemName: "点击轮播图", itemContent: nil, itemTitle: bannerData.name, extendParams: nil, viewController: self)
            bannerItemAction(bannerData: bannerData)
            
        } else if eventName == FKYHomePageNaviCell.naviItemClicked { /// 导航item点击
            let itemDic = userInfo[FKYUserParameterKey] as! [String:Any]
            let itemData = itemDic["itemData"] as! FKYHomePageV3ItemModel
            var index = 0
            for section in viewModel.sectionList {
                for cell in section.cellList{
                    for (index_t,item_t) in cell.cellModel.contents.Navigation.enumerated() {
                        if itemData == item_t {
                            index = index_t
                        }
                    }
                }
            }
            
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F1011", floorPosition: "1", floorName: "运营首页", sectionId: nil, sectionPosition: nil, sectionName: "导航按钮", itemId: "I1003", itemPosition: "\(index+1)", itemName: itemData.name, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            
            naviItemClicked(itemData: itemData)
            print(mainTableView.contentOffset.y)
            print(mainTableView.contentInset)
        } else if eventName == FKYHomePageItemType5.productClickedAction || eventName == FKYHomePageItemType3.productClickedAction || eventName == FKYHomePageItemType2.productClickedAction { /// 1 2 3 个系统推荐中的商品被点击
            let param = userInfo[FKYUserParameterKey] as! [String: Any]
            let itemData = param["itemData"] as! FKYHomePageV3ItemModel
            let product = param["product"] as! FKYHomePageV3FloorProductModel
            recommendProductClicked(itemData: itemData, product: product)
            
        } else if eventName == FKYHomePageSingleAdCell.adImageClicked { /// 中通广告点击
            let itemModel = userInfo[FKYUserParameterKey] as! FKYHomePageV3ItemModel
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F1011", floorPosition: "1", floorName: "运营首页", sectionId: "S1011", sectionPosition: nil, sectionName: "中通广告", itemId: "I1021", itemPosition: "1", itemName: itemModel.name, itemContent: nil, itemTitle:nil, extendParams: nil, viewController: self)
            adClicked(itemData: itemModel)
            
        } else if eventName == FKYHomePageTwoSameItemCell.productClickedAction { /// 一行2个相同模块的item被点击
            let param = userInfo[FKYUserParameterKey] as! [String: Any]
            let itemData = param["itemData"] as! FKYHomePageV3ItemModel
            let product = param["product"] as! FKYHomePageV3FloorProductModel
            moduleFloorClicked(itemData: itemData, product: product)
            
        } else if eventName == FKYHomePageTwoDifferentItemCell.productClickedAction { /// 一行2个不同模块的item被点击
            let param = userInfo[FKYUserParameterKey] as! [String: Any]
            let itemData = param["itemData"] as! FKYHomePageV3ItemModel
            let product = param["product"] as! FKYHomePageV3FloorProductModel
            moduleFloorClicked(itemData: itemData, product: product)
            
        } else if eventName == FKYHomePageHotSearchView.hotSearchItemClicked { // 常搜词点击
            let keyWord = userInfo[FKYUserParameterKey] as! String
            var index = 0
            for (index_t,word) in viewModel.hotSearchKeyWord.enumerated(){
                if word == keyWord{
                    index = index_t
                }
            }
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I1032", itemPosition: "\(index+1)", itemName: "热搜词", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            FKYNavigator.shared()?.openScheme(FKY_SearchResult.self, setProperty: { vc in
                let control = vc as! FKYSearchResultVC
                control.keyword = keyWord
            })
        }else if eventName == FKYHomePageV3ContainerTabView.scrollSwitchTab{// 侧滑切换tab
            let selectIndex = userInfo[FKYUserParameterKey] as! Int
            for (index,itemData) in viewModel.switchTabList.enumerated() {
                if index == selectIndex{
                    itemData.isSelected = true
                }else{
                    itemData.isSelected = false
                }
            }
            mainTableView.reloadData()
        }else if eventName == FKYHomePageSwitchTabHeader.switchItemAction{// 点击tab切换page
            let selectIndex = userInfo[FKYUserParameterKey] as! Int
            for section in viewModel.sectionList {
                if section.sectionType == .switchTabSection {
                    for cell in section.cellList {
                        if cell.cellType == .switchTabCell {
                            print("选中的item："+"\(selectIndex)")
                            cell.currentDisplayIndex = selectIndex
                            
                        }
                    }
                }
            }
            
            mainTableView.reloadData()
        }else if eventName == FKYHomePageV3ContainerTabView.pullUpLoadAction{// 商品列表上拉加载
            let currentIndex = userInfo[FKYUserParameterKey] as! Int
            guard currentIndex < viewModel.switchTabList.count , currentIndex < viewModel.flowTabModelList.count else {
                return
            }
            let currentTabModel = viewModel.switchTabList[currentIndex]
            let currentItemModel = viewModel.flowTabModelList[currentIndex]
            requestTabListData(jumpType: currentTabModel.jumpType, tabPosition:currentIndex+1 , pageId: currentItemModel.nextPageId, pageSize: 10)
        }else if eventName == FKYHomePageV3ContainerTabView.itemClickAction {// 点击了卡片
            let dic = userInfo[FKYUserParameterKey] as! [String:Any]
            let currentTab = dic["currentTab"] as! Int
            let index = dic["index"] as! Int
            let itemData = dic["itemData"] as! FKYHomePageV3FlowItemModel
            var sectionID = ""
            var sectionName = ""
            let curretnTabHeaderModel = viewModel.switchTabList[currentTab]
            sectionName = curretnTabHeaderModel.name
            if currentTab == 0 {
                sectionID = "S1013"
            }else if currentTab == 1{
                sectionID = "S1014"
            }else if currentTab == 2{
                sectionID = "S1015"
            }else if currentTab == 3 {
                sectionID = "S1016"
            }
            
            // 判断是不是单品包邮商品
            if itemData.singlePackage.singlePackageId > 0{// 是单品包邮商品
                let tempProductModel = viewModel.transformModelType2(rawData: itemData)
                let itemContent = "\(itemData.supplyId)|\(itemData.spuCode)"
                let extendParams:[String :AnyObject] = ["storage" : itemData.getStorage() as AnyObject,"pm_price" : itemData.getPm_price() as AnyObject,"pm_pmtn_type" : itemData.getPm_pmtn_type() as AnyObject]
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F1013", floorPosition: nil, floorName: "信息流区域", sectionId: sectionID, sectionPosition: nil, sectionName: sectionName, itemId: "I9999", itemPosition: "\(index+1)", itemName: "购买", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
                self.popAddCarView(tempProductModel, immediatelyOrder: true)
                return
            }
            
            //1.图片，2.视频，3.商品广告，4.普通商品
            if itemData.productType == 1{
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F1013", floorPosition: nil, floorName: "信息流区域", sectionId: sectionID, sectionPosition: nil, sectionName: sectionName, itemId: "I0004", itemPosition: "\(index+1)", itemName: itemData.name+"点击", itemContent: nil, itemTitle: itemData.name, extendParams: nil, viewController: self)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.p_openPriveteSchemeString(itemData.jumpInfo)
                //toast("图片")
            }else if itemData.productType == 2{
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F1013", floorPosition: nil, floorName: "信息流区域", sectionId: sectionID, sectionPosition: nil, sectionName: sectionName, itemId: "I0004", itemPosition: "\(index+1)", itemName: itemData.name+"点击", itemContent: nil, itemTitle: itemData.name, extendParams: nil, viewController: self)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.p_openPriveteSchemeString(itemData.jumpInfo)
                //toast("视频")
            }else if itemData.productType == 3{
                //toast("商品广告")
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F1013", floorPosition: nil, floorName: "信息流区域", sectionId: sectionID, sectionPosition: nil, sectionName: sectionName, itemId: "I0004", itemPosition: "\(index+1)", itemName: itemData.getProductName()+"点击", itemContent: nil, itemTitle: itemData.getProductName(), extendParams: nil, viewController: self)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.p_openPriveteSchemeString(itemData.jumpInfo)
            }else if itemData.productType == 4{
                let itemContent = "\(itemData.supplyId)|\(itemData.spuCode)"
                let extendParams:[String :AnyObject] = ["storage" : itemData.getStorage() as AnyObject,"pm_price" : itemData.getPm_price() as AnyObject,"pm_pmtn_type" : itemData.getPm_pmtn_type() as AnyObject]
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F1013", floorPosition: nil, floorName: "信息流区域", sectionId: sectionID, sectionPosition: nil, sectionName: sectionName, itemId: "I9998", itemPosition: "\(index+1)", itemName: "点进商详", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = itemData.spuCode
                    v.vendorId = itemData.enterpriseId
                    /*
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
                     */
                }, isModal: false)
                //toast("普通商品")
            }
            
        }else if eventName == FKYHomePagePuBuItem.addCarAction{// 购物车按钮点击
            let dic = userInfo[FKYUserParameterKey] as! [String:Any]
            let currentTab = dic["currentTab"] as! Int
            let index = dic["index"] as! Int
            let itemModel = dic["itemData"] as! FKYHomePageV3FlowItemModel
            
            var sectionID = ""
            var sectionName = ""
            let curretnTabHeaderModel = viewModel.switchTabList[currentTab]
            sectionName = curretnTabHeaderModel.name
            if currentTab == 0 {
                sectionID = "S1013"
                
            }else if currentTab == 1{
                sectionID = "S1014"
                
            }else if currentTab == 2{
                sectionID = "S1015"
                
            }else if currentTab == 3 {
                sectionID = "S1016"
                
            }
            
            let itemContent = "\(itemModel.supplyId)|\(itemModel.spuCode)"
            let extendParams:[String :AnyObject] = ["storage" : itemModel.getStorage() as AnyObject,"pm_price" : itemModel.getPm_price() as AnyObject,"pm_pmtn_type" : itemModel.getPm_pmtn_type() as AnyObject]
            
            // 判断是否是单品包邮的品
            if itemModel.singlePackage.singlePackageId < 0{// 非单品包邮
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F1013", floorPosition: nil, floorName: "信息流区域", sectionId: sectionID, sectionPosition: nil, sectionName: sectionName, itemId: "I9999", itemPosition: "\(index+1)", itemName: "加车", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
                let tempProductModel = viewModel.transformModelType1(rawData: itemModel)
                self.popAddCarView(tempProductModel, immediatelyOrder: false)
            }else{// 单品包邮
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F1013", floorPosition: nil, floorName: "信息流区域", sectionId: sectionID, sectionPosition: nil, sectionName: sectionName, itemId: "I9999", itemPosition: "\(index+1)", itemName: "购买", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
                let tempProductModel = viewModel.transformModelType2(rawData: itemModel)
                self.popAddCarView(tempProductModel, immediatelyOrder: true)
            }
            
        }else if eventName == HomeCircleBannerView.itemScrollSwitch {// 轮播图滚动切换展示埋点
            let dic = userInfo[FKYUserParameterKey] as! [String:Any]
            let index = dic["index"] as! Int
            let banner = dic["banner"] as! FKYHomePageV3ItemModel
            if banner.isUPloadBI == false{
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F1011", floorPosition:"1" , floorName: "运营首页", sectionId: nil, sectionPosition: nil, sectionName: "轮播图", itemId: "I1999", itemPosition: "\(index+1)", itemName: "轮播图曝光", itemContent: nil, itemTitle: banner.name, extendParams: nil, viewController: self)
                banner.isUPloadBI = true
            }
            
        }else if eventName == FKYHomePageSysRecommendCell.ItemBIAction ||
                    eventName == FKYHomePageTwoSameItemCell.itemBIAction ||
                    eventName == FKYHomePageTwoDifferentItemCell.ItemBIAction {// 系统推荐埋点
            let dic = userInfo[FKYUserParameterKey] as! [String:Any]
            let index = dic["index"] as! Int
            let itemData = dic["itemData"] as! FKYHomePageV3ItemModel
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F1011", floorPosition: "1", floorName: "运营首页", sectionId: "S1011", sectionPosition: nil, sectionName: "系统推荐", itemId: "I1026", itemPosition: "\(index+1)", itemName: itemData.name, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        }else if eventName == FKYHomePageV3ContainerTabView.itemShowAction{// item曝光
            let dic = userInfo[FKYUserParameterKey] as! [String:Any]
            let currentTab = dic["currentTab"] as! Int
            let index = dic["index"] as! Int
            let itemModel = dic["itemData"] as! FKYHomePageV3FlowItemModel
            
            guard itemModel.isUPloadBI == false else {
                return
            }
            itemModel.isUPloadBI = true
            var sectionID = ""
            var sectionName = ""
            let curretnTabHeaderModel = viewModel.switchTabList[currentTab]
            sectionName = curretnTabHeaderModel.name
            if currentTab == 0 {
                sectionID = "S1013"
                
            }else if currentTab == 1{
                sectionID = "S1014"
                
            }else if currentTab == 2{
                sectionID = "S1015"
                
            }else if currentTab == 3 {
                sectionID = "S1016"
                
            }
            
            //1.图片，2.视频，3.商品广告，4.普通商品
            if itemModel.productType == 1{
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F1013", floorPosition: nil, floorName: "信息流区域", sectionId: sectionID, sectionPosition: nil, sectionName: sectionName, itemId: "I1999", itemPosition: "\(index+1)", itemName: itemModel.name + "曝光", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            }else if itemModel.productType == 2{
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F1013", floorPosition: nil, floorName: "信息流区域", sectionId: sectionID, sectionPosition: nil, sectionName: sectionName, itemId: "I1999", itemPosition: "\(index+1)", itemName: itemModel.name + "曝光", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            }else if itemModel.productType == 3{
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F1013", floorPosition: nil, floorName: "信息流区域", sectionId: sectionID, sectionPosition: nil, sectionName: sectionName, itemId: "I1999", itemPosition: "\(index+1)", itemName: itemModel.getProductName() + "曝光", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            }else if itemModel.productType == 4{
                //FKYAnalyticsManager.sharedInstance.BI_New_Record("F1013", floorPosition: nil, floorName: "信息流区域", sectionId: sectionID, sectionPosition: nil, sectionName: sectionName, itemId: "I1999", itemPosition: "\(index)", itemName: itemModel.getProductName(), itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            }
        }
    }
    
    /// 轮播图item点击
    func bannerItemAction(bannerData: FKYHomePageV3ItemModel) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.p_openPriveteSchemeString(bannerData.jumpInfo)
    }
    
    /// 导航item点击
    func naviItemClicked(itemData: FKYHomePageV3ItemModel) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.p_openPriveteSchemeString(itemData.jumpInfo)
    }
    
    /// 1 2 3 个系统推荐中的商品被点击
    func recommendProductClicked(itemData: FKYHomePageV3ItemModel, product: FKYHomePageV3FloorProductModel) {
        var typeIndex = 2
        if itemData.type == 28 { // 系统推荐新品
            typeIndex = 4
        } else if itemData.type == 29 { // 系统推荐售罄
            typeIndex = 3
        } else if itemData.type == 30 { // 系统推荐热销
            typeIndex = 2
        } else if itemData.type == 31 { // 高毛专区
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.p_openPriveteSchemeString(itemData.jumpInfoMore)
            return
        }
        FKYNavigator.shared().openScheme(FKY_HeightGrossMarginVC.self, setProperty: { vc in
            let v = vc as! FKYHeightGrossMarginVC
            v.typeIndex = typeIndex
            v.titleStr = itemData.name
            v.spuCode = product.productCode
            v.sellCode = product.productSupplyId
        }, isModal: false)
    }
    
    /// 一行两个相同模块或者不同模块被点击
    func moduleFloorClicked(itemData: FKYHomePageV3ItemModel, product: FKYHomePageV3FloorProductModel) {
        if itemData.type == 26 { // 系统推荐秒杀
            FKYNavigator.shared().openScheme(FKY_SecondKillActivityDetail.self, setProperty: { _ in
                // let v = vc as! FKYSecondKillActivityController
                
            }, isModal: false)
            
        } else if itemData.type == 27 { // 系统推荐商家特惠
            FKYNavigator.shared().openScheme(FKY_Preferential_Shop.self, setProperty: { vc in
                let v = vc as! FKYPreferentialShopsViewController
                // 有商品信息 点击商品进去的
                v.spuCode = product.productCode
                v.sellCode = product.productSupplyId
                v.vcTitle = itemData.name
            }, isModal: false)
            
        } else if itemData.type == 39 { // 搭配套餐
            FKYNavigator.shared().openScheme(FKY_MatchingPackageVC.self, setProperty: { vc in
                let vc_t = vc as! FKYMatchingPackageVC
                vc_t.enterpriseId = itemData.dinnerEnterpriseId
                vc_t.spuCode = product.productCode
            }, isModal: false)
            
        } else if itemData.type == 40 { // 固定套餐
            FKYNavigator.shared().openScheme(FKY_ComboList.self, setProperty: { vc in
                let vc_t = vc as! FKYComboListViewController
                vc_t.sellerCode = Int(itemData.dinnerEnterpriseId) ?? 0
                vc_t.spuCode = product.productCode
            }, isModal: false)
        }
    }
    
    /// 中通广告点击
    func adClicked(itemData: FKYHomePageV3ItemModel) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard itemData.iconImgDTOList.count > 0 else{
            return
        }
        appDelegate.p_openPriveteSchemeString(itemData.iconImgDTOList[0].jumpInfo)
    }
    
    /// 搜索栏点击事件
    func clickSearchItemAction(_ bar: HomeSearchBar) {
        // FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_SEARCH_CLICK_CODE.rawValue, itemPosition: "0", itemName: "搜索框", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: CurrentViewController.shared.item)
        
        FKYNavigator.shared().openScheme(FKY_NewSearch.self, setProperty: { svc in
            let searchVC = svc as! FKYSearchInputKeyWordVC
            searchVC.searchType = 1
        }, isModal: false, animated: true)
    }
    
    /// 消息中心点击事件
    func clickMessageBoxAction(_ bar: HomeSearchBar) {
        if FKYLoginAPI.loginStatus() == .unlogin {
            FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: { _ in
                //
            }, isModal: true, animated: true)
        } else {
            FKYNavigator.shared().openScheme(FKY_Message_List.self, setProperty: { _ in
                //
            })
        }
    }
}

// MARK: - 私有方法

extension FKYHomePageV3VC {
    
    /// 用户手动刷新
    @objc func userPullDown(){
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I1041", itemPosition: nil, itemName: "刷新首页", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        pullDownRefresh()
    }
    
    /// 下拉刷新
    @objc func pullDownRefresh() {
        viewModel.installNetData()
        requestUPFloor()
        requestUnreadMsgCount()
        requestSwitchTab()
        getSurpriseTipStrView()
        requestBackImage()
        
    }
    
    /// 登录状态改变时候刷新数据
    func refreshDataForLoginChange() {
        pullDownRefresh()
    }
    
    // 主要计算各种尺寸
    func getSearchBarHeight() -> CGFloat {
        
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                return WH(88+5)+11 // swift代码里高度和oc不一样。。。
            } else {
                return WH(64+5)
            }
        } else {
            return WH(64+5)
        }
        
    }
    
    func getSwitchCellHeight() -> CGFloat {
        //return view.hd_height - getTopHeight() - getSwitchSectionHeaderHeight()
        return view.hd_height - getTopHeight()
    }
    
    func getSwitchSectionHeaderHeight() -> CGFloat {
        return WH(60)
    }
    
    /// 获取顶部的高度用来设置table的偏移量
    func getTopHeight() -> CGFloat {
        
        var hotSearchViewHeight:CGFloat = 0
        if viewModel.hotSearchKeyWord.count > 0{
            view.layoutIfNeeded()
            hotSearchView.layoutIfNeeded()
            hotSearchViewHeight = hotSearchView.hd_height
        }
        return getSearchBarHeight() + hotSearchViewHeight
    }
    
    /// 获取图片的高度
    func getImageHeight() -> CGFloat {
        guard let originalWidth = backgroundImageView.image?.size.width else {
            return 0
        }
        
        guard let originalHeight = backgroundImageView.image?.size.height else {
            return 0
        }
        
        return SCREEN_WIDTH * originalHeight / originalWidth
    }
    
    /// 配置背景图
    func configBackgroundImage() {
        viewModel.configCellDisplayType()
        if viewModel.backImageData.imgPath.isEmpty { // 没有背景图
            backgroundImageView.isHidden = true
            searchBar.backgroundColor = RGBColor(0xFFFFFF)
            searchBar.configDisplayType(type: 1)
            DispatchQueue.main.async { [weak self] in
                if let _ = self {
                    UIApplication.shared.setStatusBarStyle(.default, animated: true)
                    if #available(iOS 13.0, *) {
                        UIApplication.shared.setStatusBarStyle(.darkContent, animated: true)
                    }
                }
            }
           
            //UIApplication.shared.setStatusBarStyle(.default, animated: true)
            hotSearchView.configCellDisplay(type: 1, backgroundColor: RGBColor(0xFFFFFF))
            //self.mainTableView.backgroundColor = RGBColor(0xF4F4F4)
        } else { // 有背景图
            //backgroundImageView.sd_setImage(with: URL(string: viewModel.backImageData.imgPath))
            backgroundImageView.sd_setImage(with: URL(string: viewModel.backImageData.imgPath)) { _, _, _, _ in
                self.searchBar.backgroundColor = self.backgroundImageView.image?.getColors()?.background
                self.hotSearchView.configCellDisplay(type: 2, backgroundColor: self.backgroundImageView.image?.getColors()?.background ?? RGBColor(0xFFFFFF))
                self.updataBackImageFrame()
                //self.mainTableView.backgroundColor = self.backgroundImageView.image?.getColors()?.background
                self.mainTableView.reloadData()
                self.view.setNeedsDisplay()
            }
            backgroundImageView.isHidden = false
            searchBar.configDisplayType(type: 2)
            DispatchQueue.main.async { [weak self] in
                if let _ = self {
                    UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
                    if #available(iOS 13.0, *) {
                        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
                    }
                }
            }
            //UIApplication.shared.statusBarStyle = .lightContent
            //UIApplication.shared.statusBarStyle = .lightContent
        }
        mainTableView.reloadData()
    }
    
    /// 更新常搜词数据
    func updataHotSearchViewData() {
        
        if viewModel.hotSearchKeyWord.count < 1 { // 没有常搜词
            hotSearchView.snp_updateConstraints { make in
                make.height.equalTo(WH(0))
            }
        } else {
            hotSearchView.snp_updateConstraints { make in
                make.height.equalTo(WH(30))
            }
        }
        hotSearchView.configView(keyWordList: viewModel.hotSearchKeyWord)
        //self.view.layoutIfNeeded()
        viewModel.updataSwitchTabCellHeight(height: getSwitchCellHeight())
    }
    
    /// 获取所有tab的第一页数据
    func getAllTabFirstData(){
        for (index,tag) in viewModel.switchTabList.enumerated() {
            requestTabListData(jumpType: tag.jumpType, tabPosition: index+1, pageId: 1, pageSize: 10)
        }
    }
    
    /// 同步购物车数量
    fileprivate func changeBadgeNumber(_ isdelay : Bool) {
        if self.changeBudgeNumAction != nil{
            self.changeBudgeNumAction!(isdelay)
        }
    }
    
    /// 弹出加车框 immediatelyOrder 是否直接结算
    func popAddCarView(_ productModel :Any?,immediatelyOrder:Bool) {
        //加车来源
        let sourceType = self.getTypeSourceStr()
        if immediatelyOrder == true{
            //单品包邮
            self.addCarView.addBtnType = 2
            self.addCarView.configAddCarViewController(productModel,sourceType)
        }else{
            //普通
            self.addCarView.addBtnType = 0
            self.addCarView.configAddCarForImmediatelyOrder(productModel, sourceType, immediatelyOrder)
        }
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
    
    /// 设置加车的来源
    func getTypeSourceStr() -> String {
        /*
         /// 现在没有加车来源这个东西了。不需要了
         if self.viewModel.currentType == .oftenLook {
         return HomeString.SEARCH_OFTENLOOK_ADD_SOURCE_TYPE
         }
         else if self.viewModel.currentType == .hotSale {
         return HomeString.SEARCH_HOTSALE_ADD_SOURCE_TYPE
         }
         else {
         return HomeString.SEARCH_OFTENBUY_ADD_SOURCE_TYPE
         }
         */
        return ""
    }
    
    /// 更新惊喜提示框
    fileprivate func updateTipView(_ hideTipView:Bool ,_ tipStr:String?){
        if hideTipView == true {
            surpriseTipView.isHidden = true
            UIView.animate(withDuration: 0.3) { [weak self] in
                if let strongSelf = self {
                    strongSelf.surpriseTipView.snp.updateConstraints { (make) in
                        make.height.equalTo(0)
                    }
                }
            }
        }else {
            surpriseTipView.configTipStr(tipStr ?? "")
            surpriseTipView.isHidden = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                if let strongSelf = self {
                    strongSelf.surpriseTipView.snp.updateConstraints { (make) in
                        make.height.equalTo(SURPRISE_TIP_H)
                    }
                }
            }
        }
    }
    
    /// 检查订单页
    fileprivate func goOrderCheckViewController() {
        self.addCarView.removeMySelf()
        FKYNavigator.shared().openScheme(FKY_CheckOrder.self, setProperty: {(svc) in
            let controller = svc as! CheckOrderController
            controller.fromWhere = 5 // 购物车
        }, isModal: false, animated: true)
    }
    
    fileprivate func showOrHideSpreadView(_ hideView:Bool){
        if hideView == true {
            spreadTipView.isHidden = true
        }else {
            spreadTipView.isHidden = false
        }
    }
    
    /// 更新商品的加购数量
    func updataProductCartCount(){
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ [weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            for tab in strongSelf.viewModel.flowTabModelList {
                for tabPro in tab.list{
                    /// 遍历购物车商品
                    for carPro in FKYCartModel.shareInstance().productArr {
                        if let cartOfInfoModel = carPro as? FKYCartOfInfoModel {
                            var carSupplyId = ""
                            var catSpuCode = ""
                            var carCount = 0
                            var carID = 0
                            
                            if cartOfInfoModel.spuCode != nil {
                                catSpuCode = "\(cartOfInfoModel.spuCode ?? "")"
                            }
                            
                            if cartOfInfoModel.supplyId != nil{
                                carSupplyId = "\(cartOfInfoModel.supplyId ?? 0)"
                            }
                            
                            if cartOfInfoModel.buyNum != nil {
                                carCount = cartOfInfoModel.buyNum.intValue
                            }
                            if cartOfInfoModel.cartId != nil {
                                carID = cartOfInfoModel.cartId.intValue
                            }
                            
                            if tabPro.spuCode == catSpuCode,tabPro.supplyId == carSupplyId {
                                tabPro.carOfCount = carCount
                                tabPro.carId = carID
                                break
                            }else{
                                tabPro.carOfCount = 0
                                tabPro.carId = 0
                            }
                            
                        }
                        
                    }
                }
            }
            
        }) { [weak self] (reason) in
            guard let strongSelf = self else {
                return
            }
            //strongSelf.toast(reason)
        }
        
    }
}

// MARK: - 网络请求

extension FKYHomePageV3VC {
    /// 拉取首页上方的楼层信息
    func requestUPFloor() {
        viewModel.getHomenFloorList { [weak self] isSuccess, msg in
            
            guard let weakSelf = self else {
                return
            }
            weakSelf.requestBackImage()
            weakSelf.mainTableView.mj_header.endRefreshing()
            guard isSuccess else {
                weakSelf.getHomeDataCache()
                return
            }
            weakSelf.view.sendSubviewToBack(weakSelf.failedView)
            weakSelf.failedView.isHidden = true
            weakSelf.updataHotSearchViewData()
            weakSelf.viewModel.updataFloorData()
            weakSelf.mainTableView.reloadData()
            
        }
    }
    
    func requestBackImage() {
        viewModel.getBackGroundImage { [weak self] _, _ in
            guard let weakSelf = self else {
                return
            }
            weakSelf.configBackgroundImage()
        }
    }
    
    /// 首页未读消息数量请求
    func requestUnreadMsgCount() {
        viewModel.getUnreadCount { [weak self] isSuccess, _ in
            guard let weakSelf = self else {
                return
            }
            guard isSuccess else {
                return
            }
            if weakSelf.viewModel.unreadMsgCount > 0 {
                weakSelf.searchBar.unreadMsgCount.isHidden = false
                if weakSelf.viewModel.unreadMsgCount <= 9 {
                    weakSelf.searchBar.unreadMsgCount.showText("\(weakSelf.viewModel.unreadMsgCount)", WH(15))
                } else {
                    weakSelf.searchBar.unreadMsgCount.showText("9+", WH(15))
                }
            } else {
                weakSelf.searchBar.unreadMsgCount.isHidden = true
            }
        }
    }
    
    /// 拉switchTab
    func requestSwitchTab() {
        // 未登录情况下不拉这个接口,同时移除以前已经加载的数据
        guard FKYLoginAPI.loginStatus() != .unlogin else{
            viewModel.removeFlowData()
            return
        }
        
        viewModel.getSwitchTab { [weak self] isSuccess, _ in
            guard let weakSelf = self else {
                return
            }
            guard isSuccess else {
                return
            }
            weakSelf.getAllTabFirstData()
            //weakSelf.mainTableView.reloadData()
        }
    }
    
    /// 拉取每个tab下的列表
    func requestTabListData(jumpType:String,tabPosition:Int,pageId:Int,pageSize:Int){
        viewModel.getInfoFollowData(jumpType: jumpType, tabPosition: tabPosition, pageId: pageId, pageSize: pageSize) {[weak self] (isSuccess, msg) in
            guard let weakSelf = self else {
                return
            }
            guard isSuccess else {
                weakSelf.toast(msg)
                return
            }
            weakSelf.updataProductCartCount()
            weakSelf.mainTableView.reloadData()
        }
    }
    
    /// 使用缓存展示
    func getHomeDataCache(){
        self.viewModel.fetchHomeRecommendCacheData { (isSuccess_t, msg) in
            guard isSuccess_t else{
                self.view.bringSubviewToFront(self.failedView)
                self.failedView.isHidden = false
                return
            }
            self.updataHotSearchViewData()
            self.viewModel.updataFloorData()
            self.mainTableView.reloadData()
            self.view.sendSubviewToBack(self.failedView)
            self.failedView.isHidden = true
            
        }
    }

    
    /// 请求是否有惊喜提示
    fileprivate func getSurpriseTipStrView() {
        self.updateTipView(true, nil)
        self.showOrHideSpreadView(true)
        self.viewModel.getSurpriseTipViewYesOrFlase { [weak self] (showStr, tipStr) in
            guard let strongSelf = self else{
                return
            }
            if showStr == "1" {
                //展示
                strongSelf.updateTipView(false, tipStr)
            }else{
                //隐藏
                strongSelf.updateTipView(true, nil)
                if FKYLoginAPI.loginStatus() != .unlogin {
                    strongSelf.getSpreadView()
                }
            }
        }
    }
    //获取推广视图是否显示
    fileprivate func getSpreadView(){
        self.viewModel.getSpreadShowOrHideView {[weak self] (isSuccess, msg, model) in
            guard let strongSelf = self else{
                return
            }
            if isSuccess == true {
                //显示首页推广视图
                strongSelf.spreadModel = model
                if let desModel = model, desModel.isPopup == 1 {
                    strongSelf.showOrHideSpreadView(false)
                }else{
                    strongSelf.showOrHideSpreadView(true)
                }
            }else {
                strongSelf.showOrHideSpreadView(true)
            }
        }
    }
    //点击推广视图
    fileprivate func getClickSpreadView(){
        self.viewModel.getSpreadViewClick {[weak self] (isSuccess, msg) in
            guard let _ = self else{
                return
            }
        }
    }
    
}

// MARK: - 搜索栏代理

extension FKYHomePageV3VC: HomeSearchBarOperation {
    /// 搜索框点击
    func onClickSearchItemAction(_ bar: HomeSearchBar) {
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I1000", itemPosition: "0", itemName: "搜索框", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        clickSearchItemAction(bar)
    }
    
    /// 右边消息按钮点击
    func onClickMessageBoxAction(_ bar: HomeSearchBar) {
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I1010", itemPosition: "0", itemName: "消息中心", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        clickMessageBoxAction(bar)
    }
    
    /// 扫码搜索事件
    func onclickScanSearchButtonAction() {
        FKYNavigator.shared()?.openScheme(FKY_ScanVC.self)
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_SCAN_CLICK_CODE.rawValue, itemPosition: "0", itemName: "扫一扫", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    }
}

// MARK: - UIScrollViewDelegate代理

extension FKYHomePageV3VC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if viewIsAppear == false {// 界面还未展示的时候各种尺寸获取会有问题
            return
        }
        
        let scrollDirection = scrollView.contentOffset.y - mainTableLastOffsetY
        
        
        if scrollView.contentSize.height <= scrollView.hd_height{
            if scrollDirection > 0{// 界面向上移动
                scrollView.contentOffset.y = 0
            }else{// 向下移动
                if isSubCollcScrollToTop { // 子co已经向下移动到顶部，此时允许父table向下移动
                    
                }else{
                    scrollView.contentOffset.y = 0
                }
            }
            
            return
        }
        
        if scrollDirection > 0{// 界面向上移动
            
            if scrollView.contentOffset.y >= scrollView.contentSize.height-scrollView.hd_height {// 界面已经向上移动到底部了 不允许再向上移动
                scrollView.contentOffset.y = scrollView.contentSize.height-scrollView.hd_height
                
                if let switchTabIndex = viewModel.getSwitchTabIndex() {
                    let cell = mainTableView.cellForRow(at: IndexPath(row: switchTabIndex.1, section: switchTabIndex.0)) as? FKYHomePageSwitchTabCell
                    if let cell_t = cell {
                        cell_t.isSupperScrollToBottom(isBottom: true)
                    }
                }
            }else{// 界面还未向上移动到底部
                mainTableLastOffsetY = scrollView.contentOffset.y
                if let switchTabIndex = viewModel.getSwitchTabIndex() {
                    let cell = mainTableView.cellForRow(at: IndexPath(row: switchTabIndex.1, section: switchTabIndex.0)) as? FKYHomePageSwitchTabCell
                    if let cell_t = cell {
                        cell_t.isSupperScrollToBottom(isBottom: false)
                    }
                }
            }
            
        }else{// 界面向下移动
            // 先判断子co的滚动状态
            if isSubCollcScrollToTop { // 子co已经向下移动到顶部，此时允许父table向下移动
                mainTableLastOffsetY = scrollView.contentOffset.y
            }else{// 子co还没有向下移动到顶部先让子co滚动
                if mainTableLastOffsetY >= scrollView.contentSize.height-scrollView.hd_height  {
                    mainTableLastOffsetY = scrollView.contentSize.height-scrollView.hd_height
                }
                scrollView.contentOffset.y = mainTableLastOffsetY
                
            }
        }
        
        
        /*
        if scrollView.contentOffset.y <= 0 { // 向下已经滚动到顶部了，
        }
        
        if scrollView.contentOffset.y > 0, scrollView.contentOffset.y + mainTableView.hd_height < mainTableView.contentSize.height { // 不在顶部也不在底部
            guard let switchTabIndex = viewModel.getSwitchTabIndex() else {
                return
            }
            
            let cell = mainTableView.cellForRow(at: IndexPath(row: switchTabIndex.1, section: switchTabIndex.0)) as? FKYHomePageSwitchTabCell
            if let cell_t = cell {
                cell_t.isSupperScrollToBottom(isBottom: false)
            }
        }
        
        if Int(scrollView.contentOffset.y+1) + Int(mainTableView.hd_height) >= Int(mainTableView.contentSize.height) { // 已经向上滚动到底部
            guard let switchTabIndex = viewModel.getSwitchTabIndex() else {
                return
            }
            
            let cell = mainTableView.cellForRow(at: IndexPath(row: switchTabIndex.1, section: switchTabIndex.0)) as? FKYHomePageSwitchTabCell
            if let cell_t = cell {
                //cell_t.isSupperScrollToBottom = true
                cell_t.isSupperScrollToBottom(isBottom: true)
            }
            scrollView.contentOffset.y = mainTableView.contentSize.height - mainTableView.hd_height
        }
        */
    }
}

// MARK: - tableview代理

extension FKYHomePageV3VC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionList[section].cellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < viewModel.sectionList.count, indexPath.row < viewModel.sectionList[indexPath.section].cellList.count else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            return cell
        }
        let sectionModel = viewModel.sectionList[indexPath.section]
        let cellModel = sectionModel.cellList[indexPath.row]
        
        if cellModel.cellType == .bannerCell { // 首页轮播图
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(HomeBannerListCell.self)) as! HomeBannerListCell
            cell.configCell(cellData: cellModel)
            return cell
        }else if cellModel.cellType == .switchTabCell { // 下方商品列表切换tab cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYHomePageSwitchTabCell.self)) as! FKYHomePageSwitchTabCell
            cell.configCell(cellData: cellModel)
            return cell
        }else if cellModel.cellType == .naviCell { // 导航栏cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYHomePageNaviCell.self)) as! FKYHomePageNaviCell
            cell.configCell(cellData: cellModel)
            return cell
        }else if cellModel.cellType == .singleAdCell { // 单行广告栏
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYHomePageSingleAdCell.self)) as! FKYHomePageSingleAdCell
            cell.configCell(cellData: cellModel)
            return cell
        }else if cellModel.cellType == .singleSysRecommend { // 1个系统推荐
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYHomePageSysRecommendCell.self)) as! FKYHomePageSysRecommendCell
            cell.configCell(cellModel: cellModel)
            return cell
        }else if cellModel.cellType == .doubleSysRecommend { // 2个系统推荐
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYHomePageSysRecommendCell.self)) as! FKYHomePageSysRecommendCell
            cell.configCell(cellModel: cellModel)
            return cell
        }else if cellModel.cellType == .threeSysRecommend { // 3个系统推荐
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYHomePageSysRecommendCell.self)) as! FKYHomePageSysRecommendCell
            cell.configCell(cellModel: cellModel)
            return cell
        }else if cellModel.cellType == .twoPackage { // 一行两个相同模块沾满一行
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYHomePageTwoSameItemCell.self)) as! FKYHomePageTwoSameItemCell
            cell.configCell(cellModel: cellModel)
            return cell
        }else if cellModel.cellType == .twoDifferentModule { // 一行两个不同模块沾满一行
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYHomePageTwoDifferentItemCell.self)) as! FKYHomePageTwoDifferentItemCell
            cell.configCell(cellModel: cellModel)
            return cell
        }
        
        /*
         else if cellModel.cellType == .hotSearchKeyWord {// 常搜词
         let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYHomePageHotSearchCell.self)) as! FKYHomePageHotSearchCell
         cell.configCell(cellData: cellModel)
         return cell
         }
         */
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "section-\(indexPath.section),row-\(indexPath.row)"
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section < viewModel.sectionList.count,indexPath.row < viewModel.sectionList[indexPath.section].cellList.count else{
            return 0.0001
        }
        let sectionModel = viewModel.sectionList[indexPath.section]
        let cellModel = sectionModel.cellList[indexPath.row]
        if cellModel.cellType == .bannerCell { // 轮播图
            return tableView.rowHeight
        }else if cellModel.cellType == .switchTabCell {
            return getSwitchCellHeight()
        }else if cellModel.cellType == .naviCell { // 导航栏cell
            return tableView.rowHeight
        }else if cellModel.cellType == .singleAdCell { // 单行广告栏
            //return WH(110 + 8)
            return (SCREEN_WIDTH - 20)*84/355.0 + WH(10)
        }else if cellModel.cellType == .singleSysRecommend || cellModel.cellType == .doubleSysRecommend || cellModel.cellType == .threeSysRecommend { // 1 2 3 个系统推荐
            return WH(145 + 8)
        }else if cellModel.cellType == .twoPackage || cellModel.cellType == .twoDifferentModule {
            return tableView.rowHeight
        }
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < viewModel.sectionList.count else{
            return nil
        }
        let sectionModel = viewModel.sectionList[section]
        if sectionModel.sectionType == .switchTabSection {
            let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(FKYHomePageSwitchTabHeader.self)) as! FKYHomePageSwitchTabHeader
            sectionHeader.configData(headerData: sectionModel.switchTabHeaderData)
            return sectionHeader
        }
        return nil
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        /*
        guard section < viewModel.sectionList.count else{
            return 0.00001
        }
        let sectionModel = viewModel.sectionList[section]
        if sectionModel.sectionType == .switchTabSection {
            return getSwitchSectionHeaderHeight()
        }
        return 0.000001
    }
        */
         return 0.000001
     }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.configCellDisplayInfo()
        mainTableView.sendSubviewToBack(backgroundImageView)
    }
    
    /*
     func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
     let sectionModel = viewModel.sectionList[section]
     if sectionModel.sectionType == .switchTabSection {
     let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(FKYHomePageSwitchTabHeader.self)) as! FKYHomePageSwitchTabHeader
     headerView.backgroundView?.backgroundColor = .clear
     /// 兼容iOS14
     headerView.contentView.backgroundColor = .clear
     }
     }
     */
}

// MARK: - UI
extension FKYHomePageV3VC {
    func setupUI() {
        configTableBackgroundColor()
        backgroundImageView.isHidden = true
        mainTableView.backgroundColor = .clear
        view.backgroundColor = RGBColor(0xF4F4F4)
        //view.addSubview(failedView)
        view.addSubview(mainTableView)
        
        mainTableView.addSubview(backgroundImageView)
        view.addSubview(searchBar)
        view.addSubview(hotSearchView)
        view.addSubview(surpriseTipView)
        
        searchBar.snp_makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(getSearchBarHeight())
        }
        hotSearchView.snp_makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchBar.snp_bottom)
            make.height.equalTo(WH(0))
        }
        
        failedView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(searchBar.snp_bottom)
        }
        
        mainTableView.snp_makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(hotSearchView.snp_bottom)
        }
        /*
        backgroundImageView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(-getTopHeight())
            make.height.equalTo(WH(0))
            make.left.right.equalToSuperview()
        }
        
        hotSearchView.snp_makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchBar.snp_bottom)
        */
        
        backgroundImageView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(WH(0))
            make.left.right.equalToSuperview()
        }
        
        surpriseTipView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalToSuperview()
        }
        view.addSubview(spreadTipView)
        spreadTipView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(42)
            make.bottom.equalToSuperview()
        }
    }

    /*
    /// 热搜词变动，更新布局
    func updataTableViewInset() {
        mainTableView.contentInset = UIEdgeInsets(top: getTopHeight(), left: 0, bottom: 0, right: 0)
        mainTableView.contentOffset.y = -getTopHeight()
    }
    */
    
    /// 更新背景图的尺寸 同时更新搜索框的背景色
    func updataBackImageFrame() {
        backgroundImageView.snp_updateConstraints { make in
            make.height.equalTo(getImageHeight())
        }
    }
    
    /// 设置table的渐变背景
    func configTableBackgroundColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT / 5.0 * 2.0)
        view.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [RGBColor(0xFFFFFF).cgColor, RGBColor(0xF4F4F4).cgColor]
        let gradientLocations: [NSNumber] = [0.0, 1]
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    }
}
//MARK:推广视图
extension FKYHomePageV3VC {
    
}


//无数据判断
extension FKYHomePageV3VC {
    func showEmptyNoDataCustomView_v3(_ bgView :UIView,_ img : String,_ title:String,_ isHideBtn:Bool,callback:@escaping ()->()) -> UIView{
        let bg = UIView()
        bg.backgroundColor = bg1
        bgView.addSubview(bg)
        let imageView = UIImageView.init(image: UIImage.init(named: img))
        bg.addSubview(imageView)
        
        let titleLabel = UILabel()
        let attributes = [ NSAttributedString.Key.font: FontConfig.font14, NSAttributedString.Key.foregroundColor: ColorConfig.color999999]
        titleLabel.attributedText = NSAttributedString.init(string: title, attributes: attributes)
        titleLabel.textAlignment = .center
        bg.addSubview(titleLabel)
        
        var topOffy : CGFloat
        if isHideBtn {
            topOffy = WH(15+20)
        }else{
            topOffy = WH(15+20+20+28)
        }
        imageView.snp.makeConstraints ({ (make) in
            make.centerY.equalTo(bg.snp.centerY).offset(-topOffy)
            make.centerX.equalTo(bg)
        })
        
        titleLabel.snp.makeConstraints ({ (make) in
            make.top.equalTo(imageView.snp.bottom).offset(WH(15))
            make.height.equalTo(WH(20))
            make.centerX.equalTo(bg)
        })
        
        if !isHideBtn {
            let button = UIButton()
            button.setTitle(HomeString.EMPTY_PAGE_BUTTON_TITLE, for: .normal)
            button.setBackgroundImage(UIImage.init(named: HomeString.EMPTY_PAGE_BUTTON_BG), for: .normal)
            button.setTitleColor(ColorConfig.color333333, for: .normal)
            button.setTitleColor(ColorConfig.color999999, for: .highlighted)
            button.titleLabel?.font = FontConfig.font14
            _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
                callback()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            bg.addSubview(button)
            button.snp.makeConstraints ({ (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(WH(20))
                make.centerX.equalTo(bg)
                make.size.equalTo(CGSize(width: WH(86), height: WH(28)))
            })
        }
        
        return bg
    }
}

