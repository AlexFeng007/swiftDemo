//
//  FKYTogeterBuyViewController.swift
//  FKY
//
//  Created by hui on 2018/10/22.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

let typeNowIndex = "1" //本期认购类型
let typeNextIndex = "3"//下期预告

class FKYTogeterBuyViewController: UIViewController {
    @objc var sellerCode: String?       // 商家id
    //本期认购/往期认购
    fileprivate lazy var headerView: FKYTogeterHeaderView = {
        let view = FKYTogeterHeaderView()
        view.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFF5A9B), to: RGBColor(0xFF2D5C), withWidth: Float(SCREEN_WIDTH))
        view.clickIndexClosure = { [weak self] index in
            if let strongSelf = self {
                strongSelf.currentIndex = index
                strongSelf.contentScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(index), y: 0), animated: true)
                //埋点
                if index == 0 {
                    //本期
                    strongSelf.addTabBI_Record(0)
                }else {
                    //下期
                    strongSelf.addTabBI_Record(1)
                }
            }
        }
        return view
    }()
    
    fileprivate lazy var contentScrollView: UIScrollView = { [weak self] in
        let view = UIScrollView(frame: CGRect.null)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        view.delegate = self
        return view
        }()
    
    //本期认购
    fileprivate lazy var togeterNowView: FKYTogeterNowView = {
        let view = FKYTogeterNowView()
        view.typeIndex = typeNowIndex
        view.isHidden = true
        view.updateStepCountBlock = {[weak self] (product, row) in
            if let strongSelf = self {
                strongSelf.selectedRow = row
                strongSelf.popAddCarView(product)
            }
        }
        view.toastBlock = { [weak self] msg in
            self?.toast(msg)
        }
        view.refreshTogeterNowViewData = { [weak self] in
            self?.getTogeterBuyListData(true,typeNowIndex)
        }
        view.reloadMoreTogeterNowViewData = { [weak self] in
            self?.getTogeterBuyListData(false,typeNowIndex)
        }
        view.clickCellBlock = {[weak self] (product, row, nowTime) in
            if let strongSelf = self {
                let itemContent =  (product.enterpriseId ?? "")+"|"+(product.spuCode ?? "")
                let extendParams = ["storage":product.storage,"pm_price":product.pm_price,"pm_pmtn_type":product.pm_pmtn_type]
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.TOGETER_BUY_SECTION_CODE.rawValue, sectionPosition: "1", sectionName: "本期认购", itemId: ITEMCODE.TOGETER_BUY_DETAIL_ITEM_CODE.rawValue, itemPosition: "\(row+1)", itemName: "点进商详", itemContent: itemContent, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: strongSelf)
            }
        }
        return view
    }()
    
    //下期预告
    fileprivate lazy var togeterOldView: FKYTogeterNowView = {
        let view = FKYTogeterNowView()
        view.typeIndex = typeNextIndex
        view.isHidden = true
        view.refreshTogeterNowViewData = { [weak self] in
            self?.getTogeterBuyListData(true,typeNextIndex)
        }
        view.reloadMoreTogeterNowViewData = { [weak self] in
            self?.getTogeterBuyListData(false,typeNextIndex)
        }
        //未开始活动到点
        view.refreshDataWithNextTypeOver = { [weak self] in
            self?.getTogeterBuyListData(true,typeNowIndex)
            self?.getTogeterBuyListData(true,typeNextIndex)
        }
        view.clickCellBlock = {[weak self] (product, row, nowTime) in
            if let strongSelf = self {
                let itemContent =  (product.enterpriseId ?? "")+"|"+(product.spuCode ?? "")
                let extendParams = ["storage":"未开始","pm_price":product.pm_price,"pm_pmtn_type":product.pm_pmtn_type]
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.TOGETER_BUY_SECTION_CODE.rawValue, sectionPosition: "2", sectionName: "下期预告", itemId: ITEMCODE.TOGETER_BUY_DETAIL_ITEM_CODE.rawValue, itemPosition: "\(row+1)", itemName: "点进商详", itemContent: itemContent, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: strongSelf)
            }
        }
        return view
    }()
    
    //本期请求失败
    fileprivate lazy var togeterNowFailedView : UIView = {
        let view = self.showEmptyNoDataCustomView(self.togeterNowView, "no_shop_pic", GET_FAILED_TXT,false) { [weak self] in
            self?.getTogeterBuyListData(true,typeNowIndex)
        }
        self.isShowNowFaildView = true
        return view
    }()
    
    //往期请求失败
    fileprivate lazy var togeterOldFailedView : UIView = {
        let view = self.showEmptyNoDataCustomView(self.togeterOldView, "no_shop_pic", GET_FAILED_TXT,false) { [weak self] in
            self?.getTogeterBuyListData(true,typeNextIndex)
        }
        self.isShowOldFaildView = true
        return view
    }()
    //搜索按钮
    fileprivate lazy var searchBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"togeterSearchPic"), for: .normal)
        
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            // 埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "头部", itemId: ITEMCODE.TOGETER_BUY_HEADER_ITEM_CODE.rawValue, itemPosition: "2", itemName: "搜索", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            
            FKYNavigator.shared().openScheme(FKY_Search.self, setProperty: { (svc) in
                let searchVC = svc as! FKYSearchViewController
                searchVC.vcSourceType = .pilot
                searchVC.searchType = .togeterProduct
                searchVC.searchFromType = .fromCommon
            }, isModal: false, animated: true)
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    //商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        addView.finishPoint = CGPoint(x: SCREEN_WIDTH-16-self.NavigationBarRightImage!.frame.size.width/2.0, y: self.NavigationBarRightImage!.frame.origin.y+self.NavigationBarRightImage!.frame.size.height/2.0)
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
                if let model = productModel as? FKYTogeterBuyModel {
                    // 埋点
                    let itemContent =  (model.enterpriseId ?? "")+"|"+(model.spuCode ?? "")
                    let extendParams = ["storage":model.storage,"pm_price":model.pm_price,"pm_pmtn_type":model.pm_pmtn_type]
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.TOGETER_BUY_SECTION_CODE.rawValue, sectionPosition: "1", sectionName: "本期认购", itemId: ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue, itemPosition: "\((strongSelf.selectedRow ?? 0)+1)", itemName: "加车", itemContent: itemContent, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: strongSelf)
                }
            }
        }
        return addView
    }()
    
    //请求类
    fileprivate lazy var togeterBuyProvider : FKYTogeterBuyProvider = {
        return FKYTogeterBuyProvider()
    }()
    
    fileprivate var cartBadgeView : JSBadgeView?
    fileprivate var navBar: UIView?
    fileprivate var lookOldBuy :Bool = false
    fileprivate var isShowNowFaildView : Bool = false //是否显示本期认购了加载失败界面
    fileprivate var isShowOldFaildView : Bool = false //是否显示往期认购了加载失败界面
    fileprivate var currentIndex = 0
    fileprivate var selectedRow : Int? //记录选择的是第一个cell
    
    //MARK: 控制器生命周期
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        //获取一起购购物车数量
        weak var weakSelf = self
        FKYVersionCheckService.shareInstance().syncTogeterBuyCartNumberSuccess({ (isSuccess) in
            weakSelf?.togeterNowView.reloadViewWithBackFromCart()
            // 购物车badge
            weakSelf?.changeBadgeNumber(false)
            
        }) { (reason) in
            weakSelf?.toast(reason)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setContentView()
        togeterBuyProvider.sellerCode = self.sellerCode ?? ""
        self.getTogeterBuyListData(true,typeNowIndex)
        self.getTogeterBuyListData(true,typeNextIndex)
        // 登录成功后刷新数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name: NSNotification.Name.FKYLoginSuccess, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("FKYTogeterBuyViewController deinit~!@")
        self.dismissLoading()
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK:ui相关
extension FKYTogeterBuyViewController {
    //MARK: 导航栏
    fileprivate func setupNavigationBar() {
        navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            }else{
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
            }()
        
        fky_setupLeftImage("togeterBack") { [weak self] in
            FKYNavigator.shared().pop()
            if let strongSelf = self {
                strongSelf.togeterNowView.stopTimer()
                strongSelf.togeterOldView.stopTimer()
                // 埋点
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "头部", itemId: ITEMCODE.TOGETER_BUY_HEADER_ITEM_CODE.rawValue, itemPosition: "1", itemName: "返回", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            }
        }
        fky_setupTitleLabel("1起购")
        NavigationTitleLabel?.textColor = RGBColor(0xFFFFFF)
        
        fky_setupRightImage("togeterCarWhite") { [weak self] in
            // 埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "头部", itemId: ITEMCODE.TOGETER_BUY_HEADER_ITEM_CODE.rawValue, itemPosition: "3", itemName: "1起购购物车", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            // (统一)购物车
            FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
                let v = vc as! FKY_ShopCart
                v.canBack = true
                v.typeIndex = 1
            }, isModal: false)
        }
        
        self.NavigationBarRightImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationBarLeftImage!)
            make.right.equalTo(self.navBar!).offset(-16)
        })
        
        self.NavigationBarLeftImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationTitleLabel!.snp.centerY)
            make.left.equalTo(self.navBar!.snp.left).offset(WH(12))
            make.height.width.equalTo(WH(30))
        })
        
        //搜索按钮
        navBar?.addSubview(self.searchBtn)
        self.searchBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.NavigationBarLeftImage!)
            make.right.equalTo(self.NavigationBarRightImage!.snp.left).offset(-18.5)
            make.height.width.equalTo(WH(35))
        }
        
        cartBadgeView = {
            let cbv = JSBadgeView.init(parentView: self.NavigationBarRightImage, alignment:JSBadgeViewAlignment.topRight)
            cbv?.badgePositionAdjustment = CGPoint(x: WH(-5), y: WH(11))
            cbv?.badgeTextFont = UIFont.systemFont(ofSize: WH(10))
            cbv?.badgeTextColor = RGBColor(0xFF2D5C)
            cbv?.badgeBackgroundColor = RGBColor(0xFFFFFF)
            return cbv
        }()
        
        self.navBar?.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFF5A9B), to: RGBColor(0xFF2D5C), withWidth: Float(SCREEN_WIDTH))
        self.view.backgroundColor = RGBColor(0xf5f5f5)
        FKYNavigator.shared().topNavigationController.dragBackDelegate = self
    }
    
    //MARK: 内容ui
    fileprivate func setContentView() {
        self.view.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalTo((self.navBar?.snp.bottom)!)
            make.left.right.equalTo(self.view)
            make.height.equalTo(WH(56))
        }
        self.view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(self.headerView.snp.bottom)
        }
        self.view.layoutIfNeeded()
        let height = SCREEN_HEIGHT-navBar!.frame.height-WH(56)
        contentScrollView.addSubview(self.togeterNowView)
        contentScrollView.addSubview(self.togeterOldView)
        self.togeterNowView.snp.makeConstraints { (make) in
            make.top.left.equalTo(contentScrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(height)
            make.right.equalTo(self.togeterOldView.snp.left);
        }
        self.togeterOldView.snp.makeConstraints { (make) in
            make.top.right.equalTo(contentScrollView)
            make.height.equalTo(height)
            make.width.equalTo(0)
        }
        contentScrollView.snp.makeConstraints { (make) in
            make.right.equalTo(self.togeterOldView)
        }
    }
}

extension FKYTogeterBuyViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = scrollView.contentOffset.x / pageWidth
        self.headerView.updateLabelColore(Int(page))
        self.currentIndex = Int(page)
        //        if self.lookOldBuy == false ,Int(page) == 1 {
        //            self.getTogeterBuyListData(true,"2")
        //            self.lookOldBuy = true
        //        }
        //埋点
        if Int(page) == 0 {
            //本期
            self.addTabBI_Record(0)
        }else {
            //下期
            self.addTabBI_Record(1)
        }
    }
}

//MARK:数据请求
extension FKYTogeterBuyViewController {
    //登录后刷新
    @objc func refreshData(){
        self.getTogeterBuyListData(true,typeNowIndex)
        self.getTogeterBuyListData(true,typeNextIndex)
    }
    //1:表示本期认购  2:下期预告
    func getTogeterBuyListData(_ isFresh:Bool,_ typeStr : String) {
        if isFresh == true {
            self.showLoading()
        }
        self.togeterBuyProvider.getTogeterBuyList(nil,isFresh,typeStr) { [weak self] (data,isCheck,enterpriseId,message) in
            if let strongSelf = self {
                if isFresh == true {
                    strongSelf.dismissLoading()
                }
                if let arr = data {
                    if typeStr == typeNowIndex {
                        //本期
                        strongSelf.togeterNowView.refreshNowViewDate(arr,isCheck,enterpriseId,isFresh,strongSelf.togeterBuyProvider.hasNext(typeStr),strongSelf.togeterBuyProvider.pageNowTotalSize)
                        if isFresh == true {
                            if strongSelf.isShowNowFaildView == true {
                                strongSelf.togeterNowFailedView.isHidden = true
                            }
                        }
                    }else {
                        //下期预告
                        strongSelf.togeterOldView.refreshNowViewDate(arr,isCheck,enterpriseId,isFresh,strongSelf.togeterBuyProvider.hasNext(typeStr),strongSelf.togeterBuyProvider.pageNowTotalSize)
                        if isFresh == true {
                            strongSelf.refreshContentScrollView(arr)
                            if strongSelf.isShowOldFaildView == true {
                                strongSelf.togeterOldFailedView.isHidden = true
                            }
                        }
                    }
                }else {
                    if typeStr == typeNowIndex {
                        strongSelf.togeterNowView.refreshNowViewDate(nil,nil,nil,isFresh,strongSelf.togeterBuyProvider.hasNext(typeStr),strongSelf.togeterBuyProvider.pageNowTotalSize)
                        if isFresh == true {
                            strongSelf.togeterNowFailedView.isHidden = false
                        }
                    }else {
                        strongSelf.togeterOldView.refreshNowViewDate(nil,nil,nil,isFresh,strongSelf.togeterBuyProvider.hasNext(typeStr),strongSelf.togeterBuyProvider.pageNowTotalSize)
                        if isFresh == true {
                            strongSelf.refreshContentScrollView(nil)
                            strongSelf.togeterOldFailedView.isHidden = false
                        }
                    }
                    strongSelf.toast(message)
                }
            }
        }
    }
}

extension FKYTogeterBuyViewController {
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = HomeString.YQG_PRD_LIST_ADD_SOURCE_TYPE
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
    
    //根据下期预告是否返回数据更新视图
    func refreshContentScrollView(_ nextArr:[FKYTogeterBuyModel]?){
        if let arr = nextArr,arr.count > 0 {
            self.headerView.updateNumTitle(2)
            self.togeterOldView.snp.updateConstraints { (make) in
                make.width.equalTo(SCREEN_WIDTH)
            }
            self.togeterOldView.isHidden = false
        }else{
            self.headerView.updateNumTitle(1)
            self.togeterOldView.snp.updateConstraints { (make) in
                make.width.equalTo(0)
            }
            self.togeterOldView.isHidden = true
            if self.currentIndex == 1 {
                self.currentIndex = 0
                self.headerView.updateLabelColore(self.currentIndex)
            }
        }
    }
    func refreshItemOfTable() {
        self.togeterNowView.refreshDataSelectedSection()
    }
    //更新一起购购物车显示数量
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
                strongSelf.cartBadgeView!.badgeText = {
                    let count = FKYCartModel.shareInstance().togeterBuyProductCount
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
    
    //埋点
    func addTabBI_Record( _ typeIndex : Int ) {
        //埋点
        var itemName = ""
        var itemPosition = ""
        if typeIndex == 0 {
            //本期
            itemName = "本期认购"
            itemPosition = "1"
        }else {
            //下期
            itemName = "下期预告"
            itemPosition = "2"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "切换tab", itemId: ITEMCODE.TOGETER_BUY_TAB_ITEM_CODE.rawValue, itemPosition: itemPosition, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    }
}

extension FKYTogeterBuyViewController : FKYNavigationControllerDragBackDelegate {
    func dragBackShouldStart(in navigationController: FKYNavigationController!) -> Bool {
        return false
    }
}

