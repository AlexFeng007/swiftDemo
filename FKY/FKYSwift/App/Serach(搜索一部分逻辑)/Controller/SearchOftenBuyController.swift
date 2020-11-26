//
//  SearchOftenBuyController.swift
//  FKY
//
//  Created by 寒山 on 2018/12/11.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  搜索常购清单

import UIKit
import SnapKit
import RxSwift

typealias ChangeBudgeNumAction = (Bool)->Void


class SearchOftenBuyController: UIViewController {
    // MARK: - Property
    var extendDic:[String:AnyObject]?
    // block
    var changeBudgeNumAction: ChangeBudgeNumAction?
    var searchAction: ( (SearchSuggestModel, Int)->() )?
    
    // 当前搜索关键词
    var keyword: String?
    // 当前搜索条码
    var barCode = ""
    // 关联词列表
    var listSuggest = [SearchSuggestModel]()
    // 是否为店铺内的商品搜索...<默认为非店铺内商品搜索>
    var searchInShop = false
    // 顶部空态视图高度
    var headHeight = WH(20) + WH(48) + WH(20) * 2
    
    // 处理滑动相关及属性
    fileprivate var canScroll = false
    
    // 空态视图
    fileprivate lazy var emptyView: FKYSearchEmptyView = {
        let view = FKYSearchEmptyView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.headHeight))
        view.searchInShop = self.searchInShop
        view.extendDic = self.extendDic
        // 点击推荐词搜索
        view.searchClosure = { [weak self] (index, item) in
            guard let strongSelf = self else {
                return
            }
            guard let closure = strongSelf.searchAction else {
                return
            }
            closure(item, index)
        }
        view.resigterClosure = { [weak self]  in
            guard let strongSelf = self else {
                return
            }
            var extendParams:[String:AnyObject] = [:]
            if strongSelf.extendDic != nil{
                for (key, value) in strongSelf.extendDic! {
                    extendParams[key] = value
                }
            }
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition:nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I9008", itemPosition: "1", itemName: "新品登记", itemContent: nil, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: strongSelf)
        }
        return view
    }()
    
    // 返回顶部按钮
    fileprivate lazy var btnBackTop: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setBackgroundImage(UIImage.init(named: "btn_back_top"), for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            //            strongSelf.contentScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            //            strongSelf.bgScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            strongSelf.currentView.backToTopAction()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 分段tab
    fileprivate lazy var topView: HMSegmentedControl = {
        let top = HMSegmentedControl()
        top.frame = CGRect(x: 0, y: self.headHeight, width: SCREEN_WIDTH, height: 46)
        top.defaultSetting()
        top.backgroundColor = UIColor.white
        top.selectedSegmentIndex = 0
        top.indexChangeBlock = { [weak self] (index) in
            if let strongSelf = self {
                //strongSelf.biRecord(index: Int(index))
                strongSelf.viewModel.currentIndex = Int(index)
                strongSelf.viewModel.currentType = strongSelf.viewModel.sectionType[strongSelf.viewModel.currentIndex]
                strongSelf.contentScrollView .setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(index), y: 0), animated: true)
                strongSelf.currentView.updateContentOffY()
            }
        }
        return top
    }()
    
    //
    fileprivate lazy var bgScrollView: UIScrollView = {
        let sv = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - naviBarHeight()))
        sv.delegate = self
        sv.bounces = false
        sv.isScrollEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = bg1
        sv.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - naviBarHeight() + self.headHeight)
        return sv
    }()
    
    //
    fileprivate lazy var contentScrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRect(x: 0, y: 46 + self.headHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 46  - naviBarHeight()))
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        view.delegate = self
        view.backgroundColor = bg1
        view.contentSize = CGSize(width: SCREEN_WIDTH.multiple(3), height:0)
        return view
    }()
    
    // tableview1
    fileprivate lazy var hotSaleView: FKYOftenBuyView = {
        return self.createOftenBuyView(type: .hotSale)
    }()
    
    // tableview2
    fileprivate lazy var oftenBuyView: FKYOftenBuyView = {
        return self.createOftenBuyView(type: .oftenBuy)
    }()
    
    // tableview3
    fileprivate lazy var oftenLookView: FKYOftenBuyView = {
        return self.createOftenBuyView(type: .oftenLook)
    }()
    
    //商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        addView.finishPoint = CGPoint(x:SCREEN_WIDTH - WH(10)-(self.parent?.NavigationBarRightImage?.frame.size.width)!/2.0,y:naviBarHeight()-WH(5)-(self.parent?.NavigationBarRightImage?.frame.size.height)!/2.0)
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
                strongSelf.refreshItemOfTable()
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? OftenBuyProductItemModel {
                    strongSelf.biNewRecord(strongSelf.selectedRow, model,1)
                }
            }
        }
        return addView
    }()
    
    // viewModel
    fileprivate var viewModel: FKYOftenBuyViewModel = {
        let vm = FKYOftenBuyViewModel()
        return vm
    }()
    
    // 查询资质状态
    fileprivate var serviceZz = CredentialsBaseInfoProvider()
    
    fileprivate var currentView: FKYOftenBuyView {
        get {
            switch self.viewModel.currentType {
            case .hotSale?:
                return self.hotSaleView
            case .oftenLook?:
                return self.oftenLookView
            case .oftenBuy?:
                return self.oftenBuyView
            default:
                return FKYOftenBuyView()
            }
        }
        set {
            switch self.viewModel.currentType {
            case .hotSale?:
                self.hotSaleView = newValue
            case .oftenLook?:
                self.oftenLookView = newValue
            case .oftenBuy?:
                self.oftenBuyView = newValue
            default:
                break
            }
        }
    }
    
    fileprivate var selectedRow = 0 //记录加车点击的位置
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentView.refreshDataBackFromCar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        //
        print("SearchOftenBuyController deinit~!@")
        
    }
    
    
    //MARK: - Public
    
    // 
    func setupData(_ txt: String?, _ list: [SearchSuggestModel]?) {
        // 保存数据
        keyword = txt
        listSuggest.removeAll()
        if let list = list, list.count > 0 {
            listSuggest.append(contentsOf: list)
        }
        
        // 显示空态视图
        self.steupEmptyUI()
        
        // 请求商品列表
        serviceZz.zzStatus { [weak self] (status) in
            if let strongSelf = self {
                switch status {
                case 1,3,4,6: // 资质审核通过
                    strongSelf.getListData()
                //strongSelf.biRecord(index: 0)
                default:
                    break
                }
            }
        }
    }
    
    // 从购物车回来后刷新数据 刷新当前视图
    func refreshCurrectViewDataBackFromCar() {
        self.currentView.refreshDataBackFromCar()
    }
    
    
    //MARK: - Private
    
    //    func refreshData() {
    //        if !viewModel.currentModel.isFirstLoad {
    //            viewModel.requestProductList(success: { [weak self] (model) in
    //                // 成功
    //                guard let strongSelf = self else {
    //                    return
    //                }
    //                strongSelf.refreshDataBackFromCar()
    //                strongSelf.dismissLoading()
    //            }) { [weak self] (errMsg) in
    //                // 失败
    //                guard let strongSelf = self else {
    //                    return
    //                }
    //                strongSelf.dismissLoading()
    //                strongSelf.toast(errMsg ?? "请求失败")
    //            }
    //        }
    //    }
    
    // 显示顶部空态视图
    fileprivate func steupEmptyUI() {
        // 填加顶部空态视图
        self.view.addSubview(self.bgScrollView)
        self.bgScrollView.addSubview(self.emptyView)
        self.bgScrollView.isScrollEnabled = false
        // 设置空态视图数据
        emptyView.configView(keyword, listSuggest)
        // 获取顶部空态视图高度
        //headHeight = emptyView.getViewHeight()
        // 更新布局
        updateViewLayout()
    }
    
    // 更新布局
    fileprivate func updateViewLayout() {
        // 获取顶部空态视图高度
        headHeight = self.emptyView.getViewHeight()
        // 更新
        emptyView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headHeight)
        topView.frame = CGRect(x: 0, y: headHeight, width: SCREEN_WIDTH, height: 46)
        bgScrollView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - naviBarHeight())
        bgScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - naviBarHeight() + headHeight)
        contentScrollView.frame = CGRect(x: 0, y: 46 + headHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 46 - naviBarHeight())
    }
    
    fileprivate func steupUI() {
        guard viewModel.sectionTitle.isEmpty == false else {
            return
        }
        
        bgScrollView.isScrollEnabled = true
        bgScrollView.addSubview(topView)
        bgScrollView.addSubview(contentScrollView)
        contentScrollView.contentSize = CGSize(width: SCREEN_WIDTH.multiple(viewModel.sectionTitle.count), height:0)
        let height = SCREEN_HEIGHT - 46  - naviBarHeight()
        topView.sectionTitles = viewModel.sectionTitle
        
        if viewModel.frequentlyBuy.count > 0 {
            contentScrollView.addSubview(oftenBuyView)
            oftenBuyView.scrollBlock = { [weak self] (scrollV) in
                if let strongSelf = self {
                    strongSelf.updateScrollViewContentOffset(scrollV: scrollV)
                }
            }
            oftenBuyView.snp.makeConstraints { (make) in
                make.top.left.equalTo(contentScrollView)
                make.width.equalTo(SCREEN_WIDTH)
                make.height.equalTo(height)
            }
            oftenBuyView.model = self.viewModel.oftenBuyModel
        }
        
        if viewModel.frequentlyView.count > 0 {
            contentScrollView.addSubview(oftenLookView)
            oftenLookView.snp.makeConstraints { (make) in
                if viewModel.frequentlyBuy.count > 0{
                    make.left.equalTo(oftenBuyView.snp.right)
                }else{
                    make.left.equalTo(contentScrollView)
                }
                make.top.equalTo(contentScrollView)
                make.width.equalTo(SCREEN_WIDTH)
                make.height.equalTo(height)
            }
            oftenLookView.scrollBlock = { [weak self] (scrollV) in
                if let strongSelf = self {
                    strongSelf.updateScrollViewContentOffset(scrollV: scrollV)
                }
            }
            oftenLookView.model = self.viewModel.oftenLookModel
        }
        
        if viewModel.cityHotSale.count > 0 {
            contentScrollView.addSubview(hotSaleView)
            hotSaleView.snp.makeConstraints { (make) in
                make.top.equalTo(contentScrollView)
                make.height.equalTo(height)
                make.width.equalTo(SCREEN_WIDTH)
                make.left.equalTo(contentScrollView).offset(SCREEN_WIDTH*((viewModel.frequentlyBuy.count > 0 ? 1:0) + (viewModel.frequentlyView.count > 0 ? 1:0)))
            }
            hotSaleView.scrollBlock = { [weak self] (scrollV) in
                if let strongSelf = self {
                    strongSelf.updateScrollViewContentOffset(scrollV: scrollV)
                }
            }
            hotSaleView.model = self.viewModel.hotSaleModel
        }
        
        self.refreshDataBackFromCar()
        
        view.addSubview(btnBackTop)
        btnBackTop.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-WH(15))
            make.bottom.equalTo(view.snp.bottom).offset(-WH(25))
            make.size.equalTo(CGSize(width: WH(60), height: WH(60)))
        }
        // 默认隐藏
        btnBackTop.alpha = 0.0
    }
    
    fileprivate func createOftenBuyView(type: FKYOftenBuyType) -> FKYOftenBuyView {
        let view = FKYOftenBuyView()
        view.type = type
        view.refreshBlock = { [weak self] in
            if let strongSelf = self {
                strongSelf.viewModel.currentModel.page = 1
                strongSelf.getData()
            }
        }
        view.loadMoreBlock = { [weak self] in
            if let strongSelf = self {
                strongSelf.getData()
            }
        }
        view.updateStepCountBlock = { [weak self] (product, count, row, typeIndex) in
            if let strongSelf = self {
                strongSelf.selectedRow = row
                strongSelf.popAddCarView(product)
            }
        }
        view.clickCellBlock = { [weak self] (product,row) in
            if let strongSelf = self {
                strongSelf.view.endEditing(true)
                strongSelf.biNewRecord(row, product,2)
            }
        }
        view.toastBlock = { [weak self] (msg) in
            if let strongSelf = self {
                strongSelf.toast(msg)
            }
        }
        view.showAlertBlock = { [weak self] (alertVC) in
            if let strongSelf = self {
                strongSelf.present(alertVC, animated: true, completion: {
                    //
                })
            }
        }
        return view
    }
    
    //
    fileprivate func changeBadgeNumber(_ isdelay : Bool) {
        if self.changeBudgeNumAction != nil{
            self.changeBudgeNumAction!(isdelay)
        }
    }
    
    
    //MARK: - 刷新
    
    // 从购物车回来后刷新数据
    func refreshDataBackFromCar() {
        hotSaleView.refreshDataBackFromCar()
        oftenLookView.refreshDataBackFromCar()
        oftenBuyView.refreshDataBackFromCar()
    }
    
    func scrollToNextPage() {
        if !self.viewModel.currentModel.isMore && self.viewModel.currentIndex != (self.viewModel.sectionTitle.count - 1) {
            self.currentView.updateContentOfsetByScrolll()
            self.viewModel.currentIndex = Int(self.viewModel.currentIndex + 1)
            if self.viewModel.sectionType.count <= self.viewModel.currentIndex{
                self.viewModel.currentIndex = self.viewModel.sectionType.count - 1;
            }
            self.viewModel.currentType = self.viewModel.sectionType[self.viewModel.currentIndex]
            self.firstGetData()
            self.contentScrollView .setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(self.viewModel.currentIndex), y: 0), animated: true)
            self.currentView.updateContentOffY()
            self.currentView.refreshDataBackFromCar()
        }
    }
    
    func firstGetData() {
        if viewModel.currentModel.isFirstLoad {
            viewModel.currentModel.isFirstLoad = false
            getData(true)
        }
    }
    
    // 处理两个ScrollView的滑动交互问题
    func updateScrollViewContentOffset(scrollV: UIScrollView) {
        let y = scrollV.contentOffset.y
        if y > 0 {
            if Int(self.bgScrollView.contentOffset.y) < Int(self.headHeight) {
                if Int(bgScrollView.contentOffset.y + y) >= Int(self.headHeight) {
                    bgScrollView.contentOffset.y = self.headHeight
                    scrollV.contentOffset.y = 0
                }else{
                    bgScrollView.contentOffset.y += y
                    scrollV.contentOffset.y = 0
                }
                
            }
        } else {
            if self.bgScrollView.contentOffset.y > 0 {
                bgScrollView.contentOffset.y += y
                scrollV.contentOffset.y = 0
            }
        }
        let height:CGFloat = scrollV.frame.size.height
        let bottomOffset:CGFloat = scrollV.contentSize.height - y
        if bottomOffset < height - MJRefreshFooterHeight &&  scrollV.contentSize.height > SCREEN_HEIGHT {
            self.scrollToNextPage()
        }else {
            let offsetHeight = y
            if  offsetHeight >= WH(150)*10 - SCREEN_HEIGHT + naviBarHeight() {
                // 显示
                if btnBackTop.alpha == 1.0 {
                    return
                }
                UIView.animate(withDuration: 1.0, animations: { [weak self] in
                    // process
                    if let strongSelf = self {
                        strongSelf.btnBackTop.alpha = 1.0;
                    }
                }) { (_) in
                    // over
                }
            }else {
                // 隐藏
                if btnBackTop.alpha == 0.0 {
                    return
                }
                
                UIView.animate(withDuration: 1.0, animations: { [weak self] in
                    // process
                    if let strongSelf = self {
                        strongSelf.btnBackTop.alpha = 0.0;
                    }
                }) { (_) in
                    // over
                }
            }
        }
    }
}


// MARK: - Request
extension SearchOftenBuyController {
    // 请求商品列表
    fileprivate func getListData() {
        showLoading()
        viewModel.requestProductList(success: { [weak self] (model) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.steupUI()
            strongSelf.dismissLoading()
        }) { [weak self] (errMsg) in
            // 失败
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.toast(errMsg ?? "请求失败")
        }
    }
    
    // 请求数据???
    func getData(_ isShowLoading: Bool = false) -> () {
        if isShowLoading {
            showLoading()
        }
        self.viewModel.getData(callback: { [weak self] in
            if let strongSelf = self {
                strongSelf.dismissLoading()
                strongSelf.currentView.model = strongSelf.viewModel.currentModel
                strongSelf.refreshDataBackFromCar()
                strongSelf.viewModel.currentModel.page += 1
            }
        }) { [weak self] (msg) in
            if let strongSelf = self {
                strongSelf.dismissLoading()
                strongSelf.currentView.model = strongSelf.viewModel.currentModel
                strongSelf.currentView.refreshDismiss()
                strongSelf.refreshDataBackFromCar()
                strongSelf.toast(msg)
            }
        }
    }
}


// MARK: - 加车相关
extension SearchOftenBuyController {
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = self.getTypeSourceStr()
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
    //设置加车的来源
    func getTypeSourceStr() -> String {
        if self.viewModel.currentType == .oftenLook {
            return HomeString.SEARCH_OFTENLOOK_ADD_SOURCE_TYPE
        }
        else if self.viewModel.currentType == .hotSale {
            return HomeString.SEARCH_HOTSALE_ADD_SOURCE_TYPE
        }
        else {
            return HomeString.SEARCH_OFTENBUY_ADD_SOURCE_TYPE
        }
    }
    //
    func refreshItemOfTable() {
        currentView.refreshDataSelectedSection()
    }
}
// MARK: - 响应事件
extension SearchOftenBuyController {
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKY_jumpToNewProductRegisterVC{// 跳转到新品登记
            if FKYLoginService.loginStatus() != .unlogin{// 已登录
                FKYNavigator.shared().openScheme(FKY_NewProductRegisterVC.self, setProperty: { (svc) in
                    let v = svc as! FKYNewProductRegisterVC
                    v.barcode = self.barCode
                }, isModal: false, animated: true)
            }else{// 未登录
                FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            }
        }
    }
}

// MARK: - BI
extension SearchOftenBuyController {
    //
    //    fileprivate func biRecord(index: Int) {
    //        let currectType: FKYOftenBuyType?
    //        if self.viewModel.sectionType.isEmpty == false && self.viewModel.sectionType.count > index {
    //            currectType = self.viewModel.sectionType[index]
    //            switch currectType {
    //            case .hotSale?:
    //                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.HOME_SUGGESTPILL_SECTION_CODE.rawValue, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_SUGGESTPILL_HOT_CLICK_CODE.rawValue, itemPosition: "0", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    //            case .oftenLook?:
    //                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.HOME_SUGGESTPILL_SECTION_CODE.rawValue, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_SUGGESTPILL_OFTENLOOK_CLICK_CODE.rawValue, itemPosition: "0", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    //            case .oftenBuy?:
    //                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.HOME_SUGGESTPILL_SECTION_CODE.rawValue, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_SUGGESTPILL_OFTENBUY_CLICK_CODE.rawValue, itemPosition: "0", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    //            default:
    //                break
    //            }
    //        }
    //    }
    
    //埋点（加车or点击cell）
    fileprivate func biNewRecord(_ row: Int, _ product: OftenBuyProductItemModel, _ type:Int) {
        let currectType: FKYOftenBuyType?
        if self.viewModel.sectionType.isEmpty == false && self.viewModel.sectionType.count > viewModel.currentIndex {
            var floorName :String?
            var floorPosition :String?
            var itemId :String?
            var itemName :String?
            var itemContent :String?
            currectType = self.viewModel.sectionType[viewModel.currentIndex]
            if currectType == .oftenBuy {
                //常买
                floorName = "常购清单"
                floorPosition = "1"
            }else if currectType == .oftenLook {
                //常看
                floorName = "常看"
                floorPosition = "2"
            }else if currectType == .hotSale {
                //热销榜
                floorName = "当地热销"
                floorPosition = "3"
            }
            if type == 1 {
                itemId = ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue
                itemName = "加车"
            }else {
                itemId = "I9998"//ITEMCODE.HOME_ACTION_COMMON_ITEMDETAIL.rawValue
                itemName = "点进商详"
            }
            if let supplyId = product.supplyId {
                itemContent = "\(supplyId)|\(product.spuCode ?? "")"
            }
            
            var extendParams:[String:AnyObject] = ["storage":product.storage as AnyObject,"pm_price":product.pm_price as AnyObject,"pm_pmtn_type":product.pm_pmtn_type as AnyObject]
            if self.extendDic != nil{
                for (key, value) in self.extendDic! {
                    extendParams[key] = value
                }
            }
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: floorPosition, floorName: floorName, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: itemId, itemPosition: "\(row+1)", itemName: itemName, itemContent: itemContent, itemTitle: product.sourceFrom, extendParams: extendParams as [String : AnyObject], viewController: self)
        }
    }
}


// MARK: - UIScrollViewDelegate
extension SearchOftenBuyController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.contentScrollView {
            let index = scrollView.contentOffset.x / self.view.bounds.size.width
            topView.setSelectedSegmentIndex(UInt(index), animated: true)
            self.viewModel.currentIndex = Int(index)
            self.viewModel.currentType = self.viewModel.sectionType[self.viewModel.currentIndex]
            self.currentView.updateContentOffY()
            self.currentView.refreshDataBackFromCar()
            firstGetData()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / self.view.bounds.size.width
        //biRecord(index: Int(index))
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bgScrollView {
            changeScolllView()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == bgScrollView {
            changeScolllView()
        }
    }
    
    func changeScolllView() {
        let y = bgScrollView.contentOffset.y
        if y <= 0 {
            bgScrollView.contentOffset.y = 0
        }
    }
}


