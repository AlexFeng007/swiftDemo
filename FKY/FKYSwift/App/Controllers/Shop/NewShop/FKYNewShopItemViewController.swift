//
//  FKYNewShopItemViewController.swift
//  FKY
//
//  Created by hui on 2019/10/28.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
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

let navBarH = CGFloat(Int(naviBarHeight()))
let HEADER_H = WH(CGFloat(80+28)) + navBarH //头视图高
let HEADER_NO_NOTIC_H = WH(CGFloat(80)) + navBarH //头视图高
let SEGMET_H = WH(CGFloat(46)) //头视图高
let BOTTOM_BTN_H = WH(CGFloat(50)) //联系供应商BT
let PAGE_LA_BOTTOM_H = WH(30) //页码距离下边距离
let SCAN_V_H = WH(41) //历史浏览标签高
let SCAN_V_W = WH(227) //历史浏览标签宽
let LBLABEL_H = WH(28) //页码器
let CACHE_NUM = 10 //缓存起步页码（大于CACHE_NUM）
let GET_FAILED_TXT = "加载失败"
let SORT_TAB_W = WH(86)
let COLLECT_CELL_W = SCREEN_WIDTH-SORT_TAB_W
@objc
class FKYNewShopItemViewController: ViewController {
    //MARK: - Property
    /*入参*/
    @objc dynamic var shopId: String? //店铺id
    @objc dynamic var shopType: String? //是否是专区（1 专区 2 店铺详情,默认为店铺详情）
    @objc dynamic var selectType: String? //默认选择到第几个
    
    @objc fileprivate var cacheDic : Dictionary<String, Any>? //缓存数据
    @objc fileprivate var lookCachesData = false;//是否查看了缓存数据
    var finishPoint:CGPoint? //购物车位置
    
    // fileprivate var navBar: UIView?
    fileprivate var searchBar: FSearchBar?
    fileprivate var badgeView: JSBadgeView?
    
    //MARK:懒加载ui视图
    //历史浏览记录按钮
    fileprivate lazy var scanPreDataView : FKYScanHisView = {
        let view = FKYScanHisView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = SCAN_V_H/2.0
        view.isHidden = true
        return view
    }()
    
    fileprivate lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = SCAN_V_H/2.0
        label.textAlignment = .center
        label.backgroundColor = RGBAColor(0x000000, alpha: 0.7)
        label.textColor = RGBColor(0xFFFFFF)
        label.font = t7.font
        label.text = "已跳转至上次浏览的位置"
        label.isHidden = true
        return label
    }()
    fileprivate lazy var horizonalScrollView: UIScrollView = { [weak self] in
        let sv = UIScrollView()
        sv.delegate = self
        //sv.isPagingEnabled = true
        sv.isScrollEnabled = false
        sv.bounces = false
        sv.showsHorizontalScrollIndicator = false
        sv.backgroundColor = RGBColor(0xF4F4F4)
        sv.contentSize = CGSize(width: SCREEN_WIDTH.multiple(2), height:0)
        return sv
        }()
    
    // 底部功能按钮
    fileprivate lazy var bottomFuctionView : FKYNewShopBottomView = {
        let bottomView = FKYNewShopBottomView()
        if self.shopType == "1" {
            bottomView.resetBottomIconAndLabelView()
        }
        
        bottomView.shadow(with: RGBAColor(0x000000,alpha: 0.1), offset: CGSize(width: 0, height: -4), opacity: 1, radius: 4)
        bottomView.clickViewBock = { [weak self] (selectIndex) in
            if let strongSelf = self {
                strongSelf.addBIWithBottomFuncViewTab(selectIndex)
                if  selectIndex == 2 {
                    //联系客服
                    strongSelf.contactCustomer()
                }else if selectIndex == 0 {
                    //商家信息
                    strongSelf.horizonalScrollView.setContentOffset(CGPoint(x:0, y: 0), animated: true)
//                    if strongSelf.shopType != "1" {
//                        strongSelf.shopMainVC.scrolleToDestinationWithIndex(0)
//                    }
                }else if selectIndex == 1 {
                    //全部商品
                    strongSelf.horizonalScrollView.setContentOffset(CGPoint(x:SCREEN_WIDTH*CGFloat(1), y: 0), animated: true)
                }
//                else{
//                    //商家促销
//                    if strongSelf.horizonalScrollView.contentOffset.x != 0 {
//                        strongSelf.horizonalScrollView.setContentOffset(CGPoint(x:0, y: 0), animated: true)
//                    }
//                    strongSelf.shopMainVC.scrolleToDestinationWithIndex(1)
//                }
            }
        }
        return bottomView
    }()
    // 底部功能按钮
    fileprivate lazy var contactFuctionView : FKYShopContactView = {
        let contactView = FKYShopContactView()
        contactView.clickTypeBtn = { [weak self] (type) in
            if let strongSelf = self {
                if  type == 0 {
                    
                }else if type == 1 {
                    //电话
                    if let url = URL.init(string: "tel:"+(strongSelf.phoneStr ?? "")){
                        UIApplication.shared.openURL(url)
                    }
                    strongSelf.addBIWithClickCustomer(1)
                }else if type == 2 {
                    //点击客服
                    FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                        let v = vc as! GLWebVC
                        v.urlPath = String.init(format:"%@?platform=3&supplyId=%@&openFrom=%d",API_IM_H5_URL,(strongSelf.shopId ?? ""),3)
                        v.navigationController?.isNavigationBarHidden = true
                    }, isModal: false)
                    strongSelf.addBIWithClickCustomer(2)
                }
            }
        }
        return contactView
    }()
    
    // 子控制器<商家信息>
    fileprivate lazy var shopMainVC : FKYShopMainViewController = {
        let vc = FKYShopMainViewController()
        vc.shopId = self.shopId
        vc.finishPoint = self.finishPoint
        vc.shopType = self.shopType
        vc.goToNextPage = { [weak self] in
            if let strongSelf = self {
                if strongSelf.bottomFuctionView.selectIndex != 1 {
                    strongSelf.horizonalScrollView.setContentOffset(CGPoint(x:SCREEN_WIDTH*CGFloat(1), y: 0), animated: true)
                    strongSelf.addBIWithBottomFuncViewTab(2)
                    UIView.animate(withDuration: 0.5) {
                        strongSelf.bottomFuctionView.selectIndex = 1
                    }
                }
            }
        }
        //更新底部状态栏
        vc.updateBottomFuctionView = { [weak self] (productCount) in
            if let strongSelf = self {
                strongSelf.bottomFuctionView.resetProductNum(productCount)
            }
        }
        //更新
//        vc.updatePromotionBottomFuncBtn = { [weak self] (index) in
//            if let strongSelf = self {
//                //strongSelf.addBIWithBottomFuncViewTab(index)
//                UIView.animate(withDuration: 0.5) {
//                    strongSelf.bottomFuctionView.selectIndex = index
//                }
//            }
//        }
        //更新
        vc.updateShopItemCarNum = { [weak self] (hasAnimation) in
            if let strongSelf = self {
                strongSelf.changeBadgeNumber(hasAnimation)
            }
        }
        
        
        return vc
    }()
    // 子控制器<全部商品>
    fileprivate lazy var productAllVC : ShopAllProductViewController = {
        let vc = ShopAllProductViewController()
        // changeBadgeNumber
        vc.navRightImageSize = self.NavigationBarRightImage?.frame.size
        vc.shopId = self.shopId ?? ""
        vc.shopType = self.shopType
        vc.callback = { [weak self] type in
            if let strongSelf = self {
                strongSelf.changeBadgeNumber(type)
            }
        }
        return vc
    }()
    
    //请求参数
    var phoneStr:String? //电话号码
    
    //MARK:生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setContentView()
        //每次进入获取缓存数据进行时间判断是否线上隐藏数据
        self.redCachesFileName()
        if let type = self.selectType, type.count > 0 {
            if type == "all" {
                bottomFuctionView.selectIndex = 1
                self.horizonalScrollView.setContentOffset(CGPoint(x:SCREEN_WIDTH*CGFloat(1), y: 0), animated: true)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 同步购物车商品数量
        self.getCartNumber()
        // 购物车badge
        self.changeBadgeNumber(true)
    }
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>FKYNewShopItemViewController deinit~!@")
        NotificationCenter.default.removeObserver(self)
    }
    
}
//MARK:ui相关
extension FKYNewShopItemViewController {
    //设置导航栏
    fileprivate func setupView() {
        self.view.backgroundColor = RGBColor(0xF4F4F4)
        
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
            //需关闭弹框
            // 返回
            if let strongSelf = self {
                //FKYNavigator.shared().pop()
                strongSelf.addBIWithCommonViewClick(1, 2)
            }
        }
        self.fky_setupRightImage("icon_cart_new") {[weak self] in
            // 购物车
            if let strongSelf = self {
                strongSelf.addBIWithCommonViewClick(2, 2)
                FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
                    let v = vc as! FKY_ShopCart
                    v.canBack = true
                }, isModal: false)
                //需关闭弹框
            }
            
        }
        
        let bv = JSBadgeView(parentView: self.NavigationBarRightImage, alignment: .topRight)
        bv?.badgePositionAdjustment = CGPoint(x: WH(-3), y: WH(3))
        bv?.badgeTextFont = UIFont.systemFont(ofSize: WH(11))
        bv?.badgeBackgroundColor = RGBColor(0xFF2D5C)
        self.badgeView = bv
        
        let searchbar = FSearchBar()
        searchbar.initCommonSearchItem()
        searchbar.delegate = self
        if self.shopType == "1" {
            searchbar.placeholder = "搜索专区内的商品"
        }else {
            searchbar.placeholder = "搜索此商家的商品"
        }
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
        self.navBar?.layoutIfNeeded()
        self.finishPoint = self.NavigationBarRightImage?.center 
    }
    //设置内容视图
    fileprivate func setContentView (){
        self.view.addSubview(self.bottomFuctionView)
        self.bottomFuctionView.snp.makeConstraints { (make) in
            make.height.equalTo(WH(54)+bootSaveHeight())
            make.left.right.bottom.equalTo(self.view)
        }
        
        self.view.addSubview(self.horizonalScrollView)
        self.horizonalScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.bottomFuctionView.snp.top)
        }
        self.view.bringSubviewToFront(self.bottomFuctionView)
        //子控制器<商家信息,全部商品>
        self.addChild(self.shopMainVC)
        self.horizonalScrollView.addSubview(self.shopMainVC.view)
        self.shopMainVC.view.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.horizonalScrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(self.horizonalScrollView)
        }
        self.addChild(self.productAllVC)
        self.horizonalScrollView.addSubview(self.productAllVC.view)
        self.productAllVC.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.horizonalScrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(self.horizonalScrollView)
            make.left.equalTo(self.shopMainVC.view.snp.right);
        }
        //提示视图
        self.view.addSubview(self.tipLabel)
        self.tipLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self.view)
            make.height.equalTo(SCAN_V_H)
            make.width.equalTo(WH(202))
        }
        //查看上次浏览位子
        self.view.addSubview(self.scanPreDataView)
        self.scanPreDataView.snp.makeConstraints {[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.right.equalTo(strongSelf.view.snp.right).offset(SCAN_V_H/2.0)
            make.height.equalTo(SCAN_V_H)
            make.width.equalTo(SCAN_V_W)
            make.bottom.equalTo(-WH(65.1)-bootSaveHeight()-WH(54))
        }
        self.scanPreDataView.clickBt = { [weak self] index in
            if let strongSelf = self {
                //浏览上次查看历史
                if index == 1 {
                    if let dic = strongSelf.cacheDic {
                        //未选中全部商品则跳过去
                        if strongSelf.bottomFuctionView.selectIndex != 2 {
                            strongSelf.bottomFuctionView.selectIndex = 2
                        strongSelf.horizonalScrollView.setContentOffset(CGPoint(x:SCREEN_WIDTH*CGFloat(1), y: 0), animated: false)
                        }
                        
                        strongSelf.productAllVC.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
                        strongSelf.scanPreDataView.removeFromSuperview()
                        strongSelf.productAllVC.configViewWithCache(dic)
                        strongSelf.lookCachesData = true
                        strongSelf.tipLabel.isHidden = false
                        let deadline :DispatchTime = DispatchTime.now() + 1.25
                        DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
                            guard let strongSelf = self else {
                                return
                            }
                            DispatchQueue.main.async {
                                strongSelf.tipLabel.isHidden = true
                                strongSelf.tipLabel.removeFromSuperview()
                            }
                        }
                    }
                }else {
                    //删除
                    strongSelf.scanPreDataView.isHidden = true
                }
            }
        }
    }
    
}
//MARK:业务相关
extension FKYNewShopItemViewController {
    // 修改购物车显示数量
    fileprivate func changeBadgeNumber(_ isdelay: Bool) {
        var deadline: DispatchTime
        if  isdelay {
            deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        }else {
            deadline = DispatchTime.now()
        }
        
        DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    if let badgeNumView = strongSelf.badgeView {
                        badgeNumView.badgeText = {
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
    }
    //点击联系客服
    fileprivate func contactCustomer(){
        if let baseModel = self.shopMainVC.enterBaseInfoModel {
            if let cellStr = baseModel.cellPhone,cellStr.count > 0 {
                self.phoneStr = cellStr
            }
            if let cellStr = baseModel.telPhone,cellStr.count > 0 {
                self.phoneStr = cellStr
            }
        }
        if let str = self.phoneStr ,str.count > 0 ,self.shopMainVC.showCustomer == true {
            self.contactFuctionView.configShopContactView(str)
            self.contactFuctionView.showOrHideContactCustomerPopView(true)
        }
        //只有电话
        if let str = self.phoneStr ,str.count > 0,self.shopMainVC.showCustomer == false {
            //电话
            //            FKYProductAlertView.show(withTitle: nil, leftTitle: "拨号", rightTitle: "取消", message:self.phoneStr, handler: { (alertView, isRight) in
            //                if !isRight {
            //
            //                }
            //            })
            if let url = URL.init(string: "tel:"+(self.phoneStr ?? "")){
                UIApplication.shared.openURL(url)
            }
            self.addBIWithClickCustomer(1)
        }
        //只有客服
        if self.shopMainVC.showCustomer == true ,self.phoneStr == nil {
            //点击客服
            FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: {[weak self] (vc) in
                guard let strongSelf = self else {
                    return
                }
                let v = vc as! GLWebVC
                v.urlPath = String.init(format:"%@?platform=3&supplyId=%@&openFrom=%d",API_IM_H5_URL,(strongSelf.shopId ?? ""),3)
                v.navigationController?.isNavigationBarHidden = true
            }, isModal: false)
            self.addBIWithClickCustomer(2)
        }
        if self.shopMainVC.showCustomer == false ,self.phoneStr == nil {
            self.toast("抱歉该商家暂无联系方式")
        }
    }
    
}
//MARK:请求相关
extension FKYNewShopItemViewController {
    // 同步购物车商品数量
    fileprivate func getCartNumber() {
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ [weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            // 更新
            strongSelf.changeBadgeNumber(false)
            strongSelf.shopMainVC.refreshPromotionProductNum()
            strongSelf.productAllVC.refreshAllProductTableView()
        }) { [weak self] (reason) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.toast(reason)
        }
    }
    
}
//MARK:FSearchBarProtocol代理
extension FKYNewShopItemViewController : FSearchBarProtocol {
    func fsearchBar(_ searchBar: FSearchBar, search: String?) {
    }
    
    func fsearchBar(_ searchBar: FSearchBar, textDidChange: String?) {
        print("textChange\(String(describing: textDidChange))")
    }
    
    func fsearchBar(_ searchBar: FSearchBar, touches: String?) {
        //点击搜索框
        self.addBIWithCommonViewClick(0, 1)
        //if self.shopType == "1"{
            FKYNavigator.shared().openScheme(FKY_Search.self, setProperty: { [weak self] (svc) in
            if let strongSelf = self {
                let searchVC = svc as! FKYSearchViewController
                searchVC.vcSourceType = .pilot
                if strongSelf.shopType == "1"{
                    //专区搜索
                    if let infoModel = strongSelf.shopMainVC.enterBaseInfoModel {
                        searchVC.shopID = infoModel.realEnterpriseId
                        if let wel = infoModel.drugWelfareFlag, wel == true {
                            //药福利
                            searchVC.yflShopID = strongSelf.shopId
                            searchVC.searchType = .yflShop
                        }else {
                            //专区
                            searchVC.jbpShopID = strongSelf.shopId
                            searchVC.searchType = .jbpShop
                        }
                    }
                }else{
                    searchVC.shopID = strongSelf.shopId
                    searchVC.searchType = .prodcut
                }
                searchVC.searchFromType = .fromShop
            }
            }, isModal: false, animated: true)
        //}
        /*
        else{
            FKYNavigator.shared().openScheme(FKY_NewSearch.self, setProperty: { [weak self] (svc) in
                guard let strongSelf = self else {
                    return;
                }
                let searchVC = svc as! FKYSearchInputKeyWordVC
                searchVC.searchType = 3
                searchVC.switchViewType = 2
                searchVC.shopID = strongSelf.shopId ?? ""
            })
        }
        */
        
    }
}
//MARK:UIScrollViewDelegate代理
extension FKYNewShopItemViewController :UIScrollViewDelegate {
   // func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //        if scrollView == self.horizonalScrollView {
        //            let index = scrollView.contentOffset.x / self.view.bounds.size.width
        //            if index == 0 {
        //                self.bottomFuctionView.selectIndex = 0
        //            }else if index == 1 {
        //                self.bottomFuctionView.selectIndex = 2
        //            }
        //        }
   // }
}
//MARK:上次浏览记录
extension FKYNewShopItemViewController  {
    func getCachesFileName() -> String {
        // 店铺id
        if FKYLoginAPI.loginStatus() == .unlogin {
            return shop_fky + (self.shopId ?? "")
        }else {
            if let userId = FKYLoginAPI.currentUser().userId {
                return shop_fky + (self.shopId ?? "") + userId
            }else {
                return shop_fky + (self.shopId ?? "")
            }
        }
    }
    //读取缓存和判断
    func redCachesFileName(){
        if let getCacheData = WUCache.getCachedObject(forFile: self.getCachesFileName()) as? Dictionary<String, Any>, let cacheTime = getCacheData[shop_time] as? String {
            let app_version = FKYEnvironmentation().app_version
            let nowTime = Date.init().timeIntervalSince1970
            if nowTime - Double(cacheTime)! > 24*60*60 || Int(app_version)! < 6100{
                self.cacheDic = nil
                self.productAllVC.cacheDic = nil
                self.scanPreDataView.isHidden = true
                WUCache.removeFile(self.getCachesFileName())
            }else{
                self.scanPreDataView.isHidden = false
                self.cacheDic = getCacheData
                self.productAllVC.cacheDic = getCacheData
            }
        }
    }
}
//MARK:UI埋点
extension FKYNewShopItemViewController {
    func addBIWithBottomFuncViewTab(_ tabIndex:Int){
        var itemName = ""
        if tabIndex == 0 {
            itemName = "商家信息"
        }else if tabIndex == 1 {
            itemName = "商家促销"
        }else if tabIndex == 2 {
            itemName = "全部商品"
        }else if tabIndex == 3 {
            itemName = "联系客服"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "底部导航栏", itemId: ITEMCODE.SHOP_DETAIL_TAB_CODE.rawValue, itemPosition: "\(tabIndex+1)", itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: ["pageValue":self.shopId ?? ""] as [String : AnyObject], viewController: self)
    }
    func addBIWithClickCustomer(_ selectIndex:Int){
        var itemName = ""
        if selectIndex == 1 {
            itemName = "手机/电话"
        }else if selectIndex == 2 {
            itemName = "在线客服"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "联系客服", itemId: ITEMCODE.SHOP_DETAIL_CONTACT_CUSTOMER_CODE.rawValue, itemPosition: "\(selectIndex)", itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: ["pageValue":self.shopId ?? ""] as [String : AnyObject], viewController: self)
    }
    func addBIWithCommonViewClick(_ itemPosition:Int, _ itemIdType:Int){
        var itemName = ""
        var itemId = ""
        var itemContent : String?
        if itemIdType == 1 {
            itemId = ITEMCODE.HOME_SEARCH_CLICK_CODE.rawValue
            itemName = "店铺内搜索"
            itemContent = self.shopId
        }else if itemIdType == 2 {
            itemId = ITEMCODE.SHOP_DETAIL_BACK_CART_CODE.rawValue
            if itemPosition == 1 {
                itemName = "返回"
            }else if itemPosition == 2 {
                itemName = "购物车"
            }
        }
        
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: itemId, itemPosition: "\(itemPosition)", itemName: itemName, itemContent: itemContent, itemTitle: nil, extendParams: ["pageValue":self.shopId ?? ""] as [String : AnyObject], viewController: self)
    }
}


extension FKYNewShopItemViewController {
    // 判断是否需要直接跳本地界面，而不是先跳转到H5
    @objc class func jumpLocalPageByUrl(_ url: String?) -> Bool {
        // url为空
        guard let url = url, url.isEmpty == false else {
            return false
        }
        
        // 兼容老规则url拦截首页跳转，避免进入老版H5首页
        // http://m.yaoex.com/tryindex.html & https://m.yaoex.com/tryindex.html
        if url.contains("m.yaoex.com/tryindex.html") {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    // 跳转原生首页
                    FKYNavigator.shared().openScheme(FKY_TabBarController.self) { (vc) in
                        let v = vc as! FKY_TabBarController
                        v.index = 0
                    }
                }
            }
            return true
        }
        
        // 兼容老规则url拦截跳转商品详情
        if url.contains("m.yaoex.com/product.html") {
            let paramString = url.components(separatedBy: "?").last
            let params = paramString?.components(separatedBy: "&")
            var productid = ""
            var enterpriseid = ""
            for (_, value) in (params?.enumerated())! {
                if value.hasPrefix("product") {
                    productid = value.components(separatedBy: "=").last!
                }
                if value.hasPrefix("enterprise") {
                    enterpriseid = value.components(separatedBy: "=").last!
                }
            }
            if productid.count > 0, enterpriseid.count > 0 {
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (viewController) in
                            let vc = viewController as! FKY_ProdutionDetail
                            vc.productionId = productid
                            vc.vendorId = enterpriseid
                        })
                    }
                }
            }
            return true
        }
        
        // 兼容老规则url拦截跳转登录
        if url.contains("m.yaoex.com/login.html") {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    if FKYLoginAPI.checkLoginExistByModelStyle() == false {
                        FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true, animated: true)
                    }
                }
            }
            return true
        }
        
        // 兼容老规则url拦截跳转店铺馆详情...<带商家id>
        if url.contains("m.yaoex.com/shop.html?enterpriseId") {
            let enterpriseId: String = url.components(separatedBy: "=").last!
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    // 跳转店铺详情
                    FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { vc in
                        let viewController = vc as! FKYNewShopItemViewController
                        viewController.shopId = enterpriseId
                    })
                }
            }
            return true
        }
        
        // 兼容老规则url拦截跳转店铺馆列表...<不带商家id>
        if url.contains("m.yaoex.com/shop.html") {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                        let v = vc as! FKY_TabBarController
                        v.index = 2
                    })
                }
            }
            return true
        }
        
        // 兼容老规则url拦截跳转个人中心 AccountViewController
        if url.contains("m.yaoex.com/account.html") {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { vc in
                        let viewController = vc as! FKYTabBarController
                        viewController.index = 4
                    })
                }
            }
            return true
        }
        
        // 兼容老规则url拦截跳转订单列表 FKYAllOrderViewController
        if url.contains("m.yaoex.com/allorder.html") {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    FKYNavigator.shared().openScheme(FKY_AllOrderController.self, setProperty: { vc in
                        let viewController = vc as! FKYAllOrderViewController
                        viewController.status = "0"
                    })
                }
            }
            return true
        }
        
        // 兼容老规则url拦截跳转订单详情...<带订单id> FKYOrderDetailViewController
        if url.contains("m.yaoex.com/orderdetail.html?orderId") {
            let orderId: String = url.components(separatedBy: "=").last!
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    FKYNavigator.shared().openScheme(FKY_OrderDetailController.self, setProperty: { vc in
                        let viewController = vc as! FKYOrderDetailViewController
                        let model = FKYOrderModel()
                        model?.orderId = orderId;
                        viewController.orderModel = model
                    })
                }
            }
            return true
        }
        
        // 除上面几种情况之外，都先跳转H5
        return false
    }
}
