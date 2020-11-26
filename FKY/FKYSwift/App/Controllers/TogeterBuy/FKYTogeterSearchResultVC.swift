//
//  FKYTogeterSearchResultVC.swift
//  FKY
//
//  Created by hui on 2019/1/4.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYTogeterSearchResultVC: UIViewController {
    //MARK:UI相关
    //本期认购
    fileprivate lazy var togeterNowView: FKYTogeterNowView = {
        let view = FKYTogeterNowView()
        view.isSearchResultView = true
        view.isHidden = true
        view.updateStepCountBlock = { [weak self] (product, row) in
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
        //未开始活动到点
        view.refreshDataWithNextTypeOver = { [weak self] in
            self?.getTogeterBuyListData(true,typeNowIndex)
        }
        //点击cell
        view.clickCellBlock = {[weak self] (product, row, nowTime) in
            if let strongSelf = self {
                let itemContent =  (product.enterpriseId ?? "")+"|"+(product.spuCode ?? "")
                var extendParams = ["pm_price":product.pm_price,"keyword":strongSelf.keyWordStr,"srn":"\(strongSelf.togeterNowView.dataArr?.count ?? 0)"]
                if let beginInterval = product.beginTime {
                    if beginInterval > nowTime {
                        extendParams["storage"] = "未开始"
                    }else{
                        extendParams["storage"] = product.storage
                    }
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId:nil, sectionPosition:nil, sectionName: "商品搜索结果列表", itemId: ITEMCODE.TOGETER_BUY_SEARCH_DETAIL_ITEM_CODE.rawValue, itemPosition: "\(row+1)", itemName: "点进商详页", itemContent: itemContent, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: strongSelf)
            }
         }
      }
        return view
    }()
        
    //无数据显示view
    fileprivate lazy var noDataView: FKYTogeterSearchNoDataView = {
        let view = FKYTogeterSearchNoDataView()
        view.isHidden = true
        return view
    }()
    //搜索框
    fileprivate lazy var searchbar: FSearchBar = { [weak self] in
        let searchbar = FSearchBar()
        searchbar.initCommonSearchItem()
        searchbar.delegate = self
        searchbar.placeholder = "请输入1起购商品"
        searchbar.text = self?.keyWordStr ?? ""
        return searchbar
        }()
    //本期请求失败
    fileprivate lazy var togeterNowFailedView : UIView = {
        weak var weakSelf = self
        let view = self.showEmptyNoDataCustomView(self.togeterNowView, "no_shop_pic", GET_FAILED_TXT,false) {
            weakSelf?.getTogeterBuyListData(true,typeNowIndex)
        }
        self.isShowNowFaildView = true
        return view
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
                    let extendParams = ["storage":model.storage,"pm_price":model.pm_price,"keyword":strongSelf.keyWordStr,"srn":"\(strongSelf.togeterNowView.dataArr?.count ?? 0)"]
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "商品搜索结果列表", itemId: ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue, itemPosition: "\((strongSelf.selectedRow ?? 0)+1)", itemName: "加车", itemContent: itemContent, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: strongSelf)
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
    fileprivate var isShowNowFaildView : Bool = false //是否显示本期认购了加载失败界面
    @objc var keyWordStr : String? //搜索关键词
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
        self.getTogeterBuyListData(true,typeNowIndex)
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
        print("FKYTogeterSearchResultVC  deinit~!@")
        self.dismissLoading()
        NotificationCenter.default.removeObserver(self)
    }
    
}
// MARK:ui相关
extension FKYTogeterSearchResultVC {
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
                // 埋点
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "头部", itemId: ITEMCODE.TOGETER_BUY_SEARCH_LIST_ITEM_CODE.rawValue, itemPosition: "1", itemName: "返回", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            }
        }
        fky_setupTitleLabel("")
        
        fky_setupRightImage("togeterCarWhite") { [weak self] in
            // 埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "头部", itemId: ITEMCODE.TOGETER_BUY_SEARCH_LIST_ITEM_CODE.rawValue, itemPosition: "3", itemName: "1起购购物车", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
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
        self.navBar?.addSubview(self.searchbar)
        self.searchbar.snp.makeConstraints({[weak self] (make) in
            if let strongSelf = self {
                make.centerX.equalTo(strongSelf.navBar!)
                make.bottom.equalTo(strongSelf.navBar!.snp.bottom).offset(WH(-8))
                make.left.equalTo(strongSelf.navBar!.snp.left).offset(WH(51))
                make.right.equalTo(strongSelf.navBar!.snp.right).offset(-WH(56))
                make.height.equalTo(WH(32))
            }
        })
        cartBadgeView = {
            let cbv = JSBadgeView.init(parentView: self.NavigationBarRightImage, alignment:JSBadgeViewAlignment.topRight)
            cbv?.badgePositionAdjustment = CGPoint(x: WH(-5), y: WH(11))
            cbv?.badgeTextFont = UIFont.systemFont(ofSize: WH(10))
            cbv?.badgeTextColor = RGBColor(0xFF2D5C)
            cbv?.badgeBackgroundColor = RGBColor(0xFFFFFF)
            cbv?.isHidden=true;
            return cbv
        }()
        self.navBar?.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFF5A9B), to: RGBColor(0xFF2D5C), withWidth: Float(SCREEN_WIDTH))
        self.view.backgroundColor = RGBColor(0xf5f5f5)
        FKYNavigator.shared().topNavigationController.dragBackDelegate = self
    }
    
    //MARK: 内容ui
    fileprivate func setContentView() {
        self.view.addSubview(self.togeterNowView)
        self.togeterNowView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self.view)
            make.top.equalTo(self.navBar!.snp.bottom)
        }
        self.view.addSubview(self.noDataView)
        self.noDataView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self.view)
            make.top.equalTo(self.navBar!.snp.bottom)
        }
    }
}
//MARK:数据请求
extension FKYTogeterSearchResultVC {
    //登录后刷新
    @objc func refreshData(){
        self.getTogeterBuyListData(true,typeNowIndex)
    }
    
    //1:表示本期认购
    func getTogeterBuyListData(_ isFresh:Bool,_ typeStr : String) {
        if isFresh == true {
            self.showLoading()
        }
        self.togeterBuyProvider.getTogeterBuyList(keyWordStr,isFresh,typeStr) { [weak self] (data,isCheck,enterpriseId,message) in
            if let strongSelf = self {
                if isFresh == true {
                    strongSelf.dismissLoading()
                }
                if let arr = data {
                    if typeStr == typeNowIndex {
                        if isFresh == true {
                            if strongSelf.isShowNowFaildView == true {
                                strongSelf.togeterNowFailedView.isHidden = true
                            }
                            if arr.count > 0 {
                                strongSelf.togeterNowView.refreshNowViewDate(arr,isCheck,enterpriseId,isFresh,strongSelf.togeterBuyProvider.hasNext(typeStr),strongSelf.togeterBuyProvider.pageNowTotalSize)
                            }else {
                                //显示无数据
                                strongSelf.noDataView.isHidden = false
                            }
                        }else {
                            strongSelf.togeterNowView.refreshNowViewDate(arr,isCheck,enterpriseId,isFresh,strongSelf.togeterBuyProvider.hasNext(typeStr),strongSelf.togeterBuyProvider.pageNowTotalSize)
                        }
                    }
                }else {
                    if typeStr == typeNowIndex {
                        strongSelf.togeterNowView.refreshNowViewDate(nil,nil,nil,isFresh,strongSelf.togeterBuyProvider.hasNext(typeStr),strongSelf.togeterBuyProvider.pageNowTotalSize)
                        if isFresh == true {
                            strongSelf.togeterNowFailedView.isHidden = false
                        }
                    }
                    strongSelf.toast(message)
                }
            }
        }
    }
}

extension FKYTogeterSearchResultVC {
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = HomeString.YQG_PRD_SEARCH_ADD_SOURCE_TYPE
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
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
       // weak var weakSelf = self
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            DispatchQueue.main.async {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.cartBadgeView!.badgeText = { 
                    let count = FKYCartModel.shareInstance().togeterBuyProductCount
                    if count <= 0 {
                        strongSelf.cartBadgeView?.isHidden = true
                        return ""
                    }
                    else if count > 99 {
                        strongSelf.cartBadgeView?.isHidden = true
                        return "99+"
                    }
                    strongSelf.cartBadgeView?.isHidden = false
                    return String(count)
                    }()
            }
        }
    }
    
    //埋点
    func addBI_Record( _ typeIndex : Int , _ selectNum : Int, _ model:FKYTogeterBuyModel?)  {
        var itemContent : String?
        if typeIndex == 0 {
            //购物车
        }else if typeIndex == 1 {
            //本期认购/抢购按钮
            if selectNum != 0 {
                itemContent =  (model!.enterpriseId ?? "")+"|"+(model!.spuCode ?? "")
            }
        }else if typeIndex == 2 {
            //往期认购
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S7100", sectionPosition: nil, sectionName: nil, itemId: "I710\(typeIndex)", itemPosition: "\(selectNum)", itemName: nil, itemContent: itemContent, itemTitle: nil, extendParams: nil, viewController: self)
    }
}
// MARK: - FSearchBarDelegate
extension FKYTogeterSearchResultVC : FSearchBarProtocol {
    func fsearchBar(_ searchBar: FSearchBar, search: String?) {
    }
    func fsearchBar(_ searchBar: FSearchBar, textDidChange: String?) {
    }
    func fsearchBar(_ searchBar: FSearchBar, touches: String?) {
        FKYNavigator.shared().openScheme(FKY_Search.self, setProperty: { (svc) in
            let searchVC = svc as! FKYSearchViewController
            searchVC.vcSourceType = .pilot
            searchVC.searchType = .togeterProduct
            searchVC.searchFromType = .fromCommon
        }, isModal: false, animated: true)
        // 埋点
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "头部", itemId: ITEMCODE.TOGETER_BUY_SEARCH_LIST_ITEM_CODE.rawValue, itemPosition: "2", itemName: "搜索框", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    }
}
extension FKYTogeterSearchResultVC : FKYNavigationControllerDragBackDelegate {
    func dragBackShouldStart(in navigationController: FKYNavigationController!) -> Bool {
        return false
    }
}
