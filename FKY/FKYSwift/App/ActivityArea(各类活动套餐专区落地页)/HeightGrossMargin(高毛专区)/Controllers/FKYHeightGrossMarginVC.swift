//
//  FKYHeiGrossMarginVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/1.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHeightGrossMarginVC: UIViewController {
    
    /// 中cell 位置
    fileprivate var selectIndexPath: IndexPath?
    
    /// viewModel
    var viewModel: FKYHeightGrossMarginViewModel = {
        let vm = FKYHeightGrossMarginViewModel()
        return vm
    }()
    
    /// spuCode 从上个界面传过来或者FKY传过来
    //@objc var spuCode:String = "";
    
    ///行高管理器
    var cellHeightManager:ContentHeightManager = {
        let heightManager = ContentHeightManager()
        return heightManager
    }()
    
    /// 导航栏
    fileprivate var navBar: UIView?
    
    //页码计数
    fileprivate lazy var lblPageCount:FKYCornerRadiusLabel  = {
        let label = FKYCornerRadiusLabel()
        label.initBaseInfo()
        label.isHidden = true
        return label
    }()
    
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            if let strongSelf = self {
                strongSelf.loadMore()
            }
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        footer!.mj_h = WH(67)
        return footer!
    }()
    
    /// 列表
    lazy var mainTableView:UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 40
        tb.separatorStyle = .none
        tb.register(ProductInfoListCell.self, forCellReuseIdentifier: NSStringFromClass(ProductInfoListCell.self))
        //        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(FKYHeightGrossMarginVC.loadMore))
        //        footer?.setTitle("-- 没有更多啦！--", for: .noMoreData)
        tb.mj_footer = self.mjfooter
        tb.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(FKYHeightGrossMarginVC.refreshTable))
        tb.backgroundColor = .white
        if #available(iOS 11, *) {
            tb.contentInsetAdjustmentBehavior = .never
        }
        return tb
    }()
    
    ///商品加车弹框
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
                strongSelf.refreshSingleCell()
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? HomeProductModel {
                    //strongSelf.addCarBI_Record(model)
                }
            }
        }
        return addView
    }()
    fileprivate lazy var emptyView : FKYNoNewPrdListDataView = {
        let view = FKYNoNewPrdListDataView()
        view.resetPreferentialData()
        view.isHidden = true
        return view
    }()
    
    /// 右上角购物车数量
    var badgeView: JSBadgeView?
    /// (1:默认高毛专区 ，2:城市热销 3 ：即将售罄 4 :新品上架 5:一品多商<为您推荐二级界面> 6:降价专区)
    @objc var typeIndex = 1
    /// 获取商品列表需要用到的字段，我也不知道代表什么
    @objc var labelId = "" //高毛专区需要字段
    
    /// sellerCode 从上个界面传过来或者FKY传过来
    @objc var sellCode : String? //卖家编码
    
    /// spuCode 从上个界面传过来或者FKY传过来
    @objc var spuCode : String? //商品编码
    
    @objc var titleStr: String? //列表标题
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.spuCode = self.spuCode
        self.viewModel.sellCode = self.sellCode
        self.getProductList()
        self.setupUI()
        self.mainTableView.reloadData()
        self.changeBadgeNumber(true)
        // 登录成功后刷新界面数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataWithLoginSuccess), name: NSNotification.Name.FKYLoginSuccess, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 同步购物车商品数量
        self.getCartNumber()
        // 购物车badge
        self.changeBadgeNumber(false)
        
        //self.handleLoginStatusJump()
    }
    deinit {
        print("FKYHeightGrossMarginVC deinit>>>>>>>")
        NotificationCenter.default.removeObserver(self)
    }
}


//MARK: - UI
extension FKYHeightGrossMarginVC{
    
    func setupUI(){
        self.configNaviBar()
        self.configBadgeView()
        
        self.view.addSubview(self.mainTableView)
        
        self.mainTableView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(self.navBar!.snp_bottom)
        }
        //页码视图
        self.view.addSubview(lblPageCount);
        lblPageCount.snp.makeConstraints({[weak self] (make) in
            if let strongSelf = self {
                make.centerX.equalTo(strongSelf.view.snp.centerX)
                make.bottom.equalTo(strongSelf.view.snp.bottom).offset(-PAGE_LA_BOTTOM_H-bootSaveHeight())
                make.height.equalTo(LBLABEL_H)
                make.width.lessThanOrEqualTo(SCREEN_WIDTH-100)
            }
        })
        self.view.addSubview(self.emptyView)
        self.emptyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    /// 配置导航栏
    func configNaviBar() {
        self.navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            }else{
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
            }()
        self.viewModel.title = self.titleStr ?? ""
        self.fky_setupTitleLabel(self.viewModel.title)
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            // 返回
            if let selfStrong = self {
                if selfStrong.typeIndex == 5 {
                    selfStrong.add_NEW_BI(itemId: "I2020", itemName: "返回", itemPosition: "1", itemContent: "", storage: "", pm_price: "", pm_pmtn_type: "")
                }else  {
                    selfStrong.add_NEW_BI(itemId: "I6450", itemName: "返回", itemPosition: "1", itemContent: "", storage: "", pm_price: "", pm_pmtn_type: "")
                }
                
                FKYNavigator.shared().pop()
            }
        }
        self.fky_setupRightImage("icon_cart_new") {[weak self] in
            // 购物车
            if let selfStrong = self {
                if selfStrong.typeIndex == 5 {
                    selfStrong.add_NEW_BI(itemId: "I2020", itemName: "购物车", itemPosition: "2", itemContent: "", storage: "", pm_price: "", pm_pmtn_type: "")
                }else {
                    selfStrong.add_NEW_BI(itemId: "I6450", itemName: "购物车", itemPosition: "2", itemContent: "", storage: "", pm_price: "", pm_pmtn_type: "")
                }
                
                FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
                    let v = vc as! FKY_ShopCart
                    v.canBack = true
                }, isModal: false)
            }
        }
    }
    
    /// 配置右上角购物车数量
    func configBadgeView(){
        let bv = JSBadgeView(parentView: self.NavigationBarRightImage, alignment: .topRight)
        bv?.badgePositionAdjustment = CGPoint(x: WH(-3), y: WH(3))
        bv?.badgeTextFont = UIFont.systemFont(ofSize: WH(11))
        bv?.badgeBackgroundColor = RGBColor(0xFF2D5C)
        self.badgeView = bv
    }
}

//MARK: -  table代理
extension FKYHeightGrossMarginVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ProductInfoListCell.self)) as! ProductInfoListCell
        
        if let homeModel = self.viewModel.dataSource[indexPath.row] as? HomeProductModel{
            self.configProductCell(cell: cell, indexPath: indexPath, cellData: homeModel)
        }else if let homeModel = self.viewModel.dataSource[indexPath.row] as? HomeCommonProductModel {
            self.configProductCell(cell: cell, indexPath: indexPath, cellData: homeModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellData =  self.viewModel.dataSource[indexPath.row]
        let conutCellHeight = ProductInfoListCell.getCellContentHeight(cellData)
        return conutCellHeight
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let scrollIndex = indexPath.row / 10 + 1
        self.showCurrectPage(scrollIndex)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating && !decelerate {
            self.showCurrectPage(0)
            //            let deadline :DispatchTime = DispatchTime.now() + 1
            //            DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
            //                DispatchQueue.main.async {[weak self] in
            //                    guard let strongSelf = self else {
            //                        return
            //                    }
            //
            //                }
            //            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating {
            self.showCurrectPage(0)
            //  let deadline :DispatchTime = DispatchTime.now() + 1
            //            DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
            //                DispatchQueue.main.async {[weak self] in
            //                    guard let strongSelf = self else {
            //                        return
            //                    }
            //                    strongSelf.showCurrectPage(0)
            //                }
            //            }
        }
    }
}

//MARK: -  响应事件
extension FKYHeightGrossMarginVC{
    /// 刷新商品卡片的购物车数量
    func reloadViewWithBackFromCart() {
        for desModel in self.viewModel.dataSource {
            if let model = desModel as? HomeProductModel {
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
            }else if let model = desModel as? HomeCommonProductModel {
                if FKYCartModel.shareInstance().productArr.count > 0 {
                    for cartModel  in FKYCartModel.shareInstance().productArr {
                        if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                            if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == model.spuCode && cartOfInfoModel.supplyId.intValue == (model.supplyId ?? 0) {
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
            
        }
        self.mainTableView.reloadData()
    }
    
    /// 下拉刷新
    @objc func refreshTable(){
        self.viewModel.dataSource.removeAll()
        self.viewModel.hasNextPage = true
        self.viewModel.nextPage = 1
        self.viewModel.allPages = 0
        self.mainTableView.mj_footer.endRefreshing()
        self.getProductList()
    }
    @objc func reloadDataWithLoginSuccess() {
        self.refreshTable()
    }
    /// 上拉加载
    @objc func loadMore(){
        if self.viewModel.hasNextPage == false{
            self.dismissLoading()
            //            self.mainTableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        self.getProductList()
    }
    
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
}

//MARK: -  私有方法
extension FKYHeightGrossMarginVC{
    /// 检查登录状态
    func checkLogStatus() -> Bool{
        if FKYLoginService.loginStatus() != .unlogin{// 已登录
            return true
        }else{// 未登录
            self.mainTableView.mj_footer.endRefreshing()
            self.mainTableView.mj_header.endRefreshing()
            FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            return false
        }
    }
    
    func showCurrectPage(_ indexPage:Int){
        ////为0隐藏
        if indexPage == 0 || self.mainTableView.contentOffset.y == 0{
            self.lblPageCount.isHidden = true
        }else {
            //记录当前浏览的页数
            self.lblPageCount.isHidden = false
            self.lblPageCount.text = String.init(format: "第%zi页", indexPage)
        }
    }
    /// 配置cell
    func configProductCell(cell:ProductInfoListCell,indexPath:IndexPath,cellData:HomeProductModel){
        cell.selectionStyle = .none
        cellData.showSequence = indexPath.row + 1
        cell.configCell(cellData)
        cell.resetCanClickShopArea(cellData)
        //更新加车数量
        cell.addUpdateProductNum = { [weak self] in
            if let strongSelf = self {
                strongSelf.add_NEW_BI(itemId: "I9999", itemName: "加车", itemPosition: "\(indexPath.row + 1)", itemContent: "\(cellData.vendorId)|\(cellData.productId )", storage: cellData.storage ?? "", pm_price: cellData.pm_price ?? "", pm_pmtn_type: cellData.pm_pmtn_type ?? "")
                strongSelf.selectIndexPath = indexPath
                strongSelf.popAddCarView(cellData)
            }
        }
        
        //到货通知
        cell.productArriveNotice = {
            FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                let controller = vc as! ArrivalProductNoticeVC
                controller.productId = cellData.productId
                controller.venderId = "\(cellData.vendorId)"
                controller.productUnit = cellData.unit
            }, isModal: false)
        }
        
        //跳转到聚宝盆商家专区
        cell.clickJBPContentArea = { [weak self] in
            if let _ = self {
                FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                    let controller = vc as! FKYNewShopItemViewController
                    controller.shopId = "\(cellData.vendorId )"
                    controller.shopType = "1"
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
                strongSelf.add_NEW_BI(itemId: "I9998", itemName: "点进商详", itemPosition: "\(indexPath.row + 1)", itemContent: "\(cellData.vendorId)|\(cellData.productId )", storage: cellData.storage ?? "", pm_price: cellData.pm_price ?? "", pm_pmtn_type: cellData.pm_pmtn_type ?? "")
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = cellData.productId
                    v.vendorId = "\(cellData.vendorId)"
                    v.updateCarNum = { (carId ,num) in
                        if let count = num {
                            cellData.carOfCount = count.intValue
                        }
                        if let getId = carId {
                            cellData.carId = getId.intValue
                        }
                        strongSelf.mainTableView.reloadData()
                    }
                }, isModal: false)
            }
        }
        
        /// 跳转到店铺首页
        cell.clickShopContentArea = { [weak self] in
            if let _ = self {
                FKYNavigator.shared()?.openScheme(FKY_ShopItem.self, setProperty: { (viewControl) in
                    let vc = viewControl as! FKYNewShopItemViewController
                    vc.shopId = "\(cellData.vendorId)"
                    vc.shopType = "2"
                }, isModal: false)
            }
        }
    }
    
    /// 配置cell
    func configProductCell(cell:ProductInfoListCell,indexPath:IndexPath,cellData:HomeCommonProductModel){
        cell.selectionStyle = .none
        cellData.showSequence = indexPath.row + 1
        cell.configCell(cellData)
        cell.resetCanClickShopArea(cellData)
        //更新加车数量
        cell.addUpdateProductNum = { [weak self] in
            if let strongSelf = self {
                strongSelf.add_NEW_BI(itemId: "I9999", itemName: "加车", itemPosition: "\(indexPath.row + 1)", itemContent: "\(cellData.supplyId ?? 0)|\(cellData.spuCode ?? "0")", storage: cellData.storage ?? "", pm_price: cellData.pm_price ?? "", pm_pmtn_type: cellData.pm_pmtn_type ?? "")
                strongSelf.selectIndexPath = indexPath
                strongSelf.popAddCarView(cellData)
            }
        }
        
        //到货通知
        cell.productArriveNotice = {
            FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                let controller = vc as! ArrivalProductNoticeVC
                controller.productId = cellData.spuCode
                controller.venderId = "\(cellData.supplyId)"
                controller.productUnit = cellData.packageUnit
            }, isModal: false)
        }
        
        //跳转到聚宝盆商家专区
        cell.clickJBPContentArea = { [weak self] in
            if let _ = self {
                FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                    let controller = vc as! FKYNewShopItemViewController
                    controller.shopId = "\(cellData.supplyId ?? 0)"
                    controller.shopType = "1"
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
                strongSelf.add_NEW_BI(itemId: "I9998", itemName: "点进商详", itemPosition: "\(indexPath.row + 1)", itemContent: "\(cellData.supplyId ?? 0)|\(cellData.spuCode ?? "0")", storage: cellData.storage ?? "", pm_price: cellData.pm_price ?? "", pm_pmtn_type: cellData.pm_pmtn_type ?? "")
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = cellData.spuCode
                    v.vendorId = "\(cellData.supplyId ?? 0)"
                    v.updateCarNum = { (carId ,num) in
                        if let count = num {
                            cellData.carOfCount = count.intValue
                        }
                        if let getId = carId {
                            cellData.carId = getId.intValue
                        }
                        strongSelf.mainTableView.reloadData()
                    }
                }, isModal: false)
            }
        }
        
        /// 跳转到店铺首页
        cell.clickShopContentArea = { [weak self] in
            if let _ = self {
                FKYNavigator.shared()?.openScheme(FKY_ShopItem.self, setProperty: { (viewControl) in
                    let vc = viewControl as! FKYNewShopItemViewController
                    vc.shopId = "\(cellData.supplyId ?? 0)"
                    vc.shopType = "2"
                }, isModal: false)
            }
        }
    }
    
    
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = HomeString.YHQ_ADD_SOURCE_TYPE
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
        
    }
    
    //加车 刷新单个cell
    func refreshSingleCell() {
        if let indexPath = self.selectIndexPath , self.viewModel.dataSource.count > indexPath.row{
            if let product =  self.viewModel.dataSource[indexPath.row] as? HomeProductModel {
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.productId && cartOfInfoModel.supplyId.intValue == (product.vendorId ) {
                            product.carOfCount = cartOfInfoModel.buyNum.intValue
                            product.carId = cartOfInfoModel.cartId.intValue
                            break
                        }
                    }
                }
            }else if let product =  self.viewModel.dataSource[indexPath.row] as? HomeCommonProductModel  {
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode && cartOfInfoModel.supplyId.intValue == (product.supplyId ?? 0 ) {
                            product.carOfCount = cartOfInfoModel.buyNum.intValue
                            product.carId = cartOfInfoModel.cartId.intValue
                            break
                        }
                    }
                }
                
            }
            
            self.mainTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    // 同步购物车商品数量
    fileprivate func getCartNumber() {
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ [weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            // 更新
            strongSelf.reloadViewWithBackFromCart()
            strongSelf.changeBadgeNumber(false)
        }) { [weak self] (reason) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.toast(reason)
        }
    }
}

//MARK: - BI埋点
extension FKYHeightGrossMarginVC{
    func add_NEW_BI(itemId:String,itemName:String,itemPosition:String,itemContent:String,storage:String,pm_price:String,pm_pmtn_type:String){
        var extendParams = ["pageValue":self.viewModel.title,
                            "storage":storage,
                            "pm_price":pm_price,
                            "pm_pmtn_type":pm_pmtn_type]
        var sectionName:String = ""
        if self.typeIndex == 5 {
            //一品多商
            extendParams = ["pageValue":(self.spuCode ?? ""),
                            "storage":storage,
                            "pm_price":pm_price,
                            "pm_pmtn_type":pm_pmtn_type]
            
        }else if self.typeIndex == 6 {
            //降价专区push落地页
            sectionName = "头部"
        }
        else {
            //高毛专区
            extendParams = ["pageValue":self.viewModel.title,
                            "storage":storage,
                            "pm_price":pm_price,
                            "pm_pmtn_type":pm_pmtn_type]
        }
        
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: sectionName, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: itemContent, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: self)
        
    }
}
//MARK: - 网络请求
extension FKYHeightGrossMarginVC {
    //MARK:请求商品数据
    fileprivate func getProductList(){
        if typeIndex == 1 {
            //高毛专区
            self.viewModel.labelId = self.labelId
            self.requestProductList()
        }else if typeIndex == 2 {
            //城市热销
            self.getCityHotSaleProductList()
        }else if typeIndex == 3 {
            //即将售罄
            self.getSaleOutProductList()
        }else if typeIndex == 4 {
            //新品上架
            self.getNewGoodsOnSaleProductList()
        }else if typeIndex == 5 {
            //一品多商
            self.getSameProductMoreSellersProductList()
        }else if typeIndex == 6{
            // 降价专区 需要登录才能进来
            guard self.checkLogStatus() else{
                return
            }
            self.getCutPriceProductList()
        }
        
    }
    
    //MARK:降价专区
    fileprivate func getCutPriceProductList(){
        self.showLoading()
        self.viewModel.requestCutPriceProductList(type: "6",spuCode: self.spuCode ?? "",sellerCode: self.sellCode ?? "") {[weak self] (isSuccess, Msg) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.dismissLoading()
            if strongSelf.viewModel.hasNextPage == false {
                strongSelf.mainTableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                strongSelf.mainTableView.mj_footer.endRefreshing()
            }
            strongSelf.mainTableView.mj_header.endRefreshing()
            guard isSuccess else{
                strongSelf.toast(Msg)
                return
            }
            strongSelf.fky_setupTitleLabel(strongSelf.viewModel.title.count > 0 ? strongSelf.viewModel.title : "降价专区")
            strongSelf.mainTableView.reloadData()
            //判断是否显示空态页面
            if strongSelf.viewModel.dataSource.count == 0 {
                strongSelf.emptyView.isHidden = false
            }else {
                strongSelf.emptyView.isHidden = true
            }
        }
    }
    
    //MARK:高毛专区商品列表
    fileprivate func requestProductList(){
        self.showLoading()
        self.viewModel.requestHeightGrossMarginProductList { [weak self] (isSuccess, Msg) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.dismissLoading()
            if strongSelf.viewModel.hasNextPage == false {
                strongSelf.mainTableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                strongSelf.mainTableView.mj_footer.endRefreshing()
            }
            strongSelf.mainTableView.mj_header.endRefreshing()
            guard isSuccess else{
                strongSelf.toast(Msg)
                return
            }
            strongSelf.fky_setupTitleLabel(strongSelf.viewModel.title.count > 0 ? strongSelf.viewModel.title : "活动专区")
            strongSelf.mainTableView.reloadData()
            //判断是否显示空态页面
            if strongSelf.viewModel.dataSource.count == 0 {
                strongSelf.emptyView.isHidden = false
            }else {
                strongSelf.emptyView.isHidden = true
            }
        }
    }
    //MARK:请求城市热销商品列表
    fileprivate func getCityHotSaleProductList (){
        self.showLoading()
        self.viewModel.requestCityHotSaleProductList { [weak self] (isSuccess, Msg) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.dismissLoading()
            if strongSelf.viewModel.hasNextPage == false {
                strongSelf.mainTableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                strongSelf.mainTableView.mj_footer.endRefreshing()
            }
            strongSelf.mainTableView.mj_header.endRefreshing()
            guard isSuccess else{
                strongSelf.toast(Msg)
                return
            }
            strongSelf.fky_setupTitleLabel(strongSelf.viewModel.title.count > 0 ? strongSelf.viewModel.title : "城市热销")
            strongSelf.mainTableView.reloadData()
            //判断是否显示空态页面
            if strongSelf.viewModel.dataSource.count == 0 {
                strongSelf.emptyView.isHidden = false
            }else {
                strongSelf.emptyView.isHidden = true
            }
        }
        
    }
    //MARK:请求即将售罄商品列表
    fileprivate func getSaleOutProductList (){
        self.showLoading()
        self.viewModel.requestSaleOutProductList { [weak self] (isSuccess, Msg) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.dismissLoading()
            if strongSelf.viewModel.hasNextPage == false {
                strongSelf.mainTableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                strongSelf.mainTableView.mj_footer.endRefreshing()
            }
            strongSelf.mainTableView.mj_header.endRefreshing()
            guard isSuccess else{
                strongSelf.toast(Msg)
                return
            }
            strongSelf.fky_setupTitleLabel(strongSelf.viewModel.title.count > 0 ? strongSelf.viewModel.title : "即将售罄")
            strongSelf.mainTableView.reloadData()
            //判断是否显示空态页面
            if strongSelf.viewModel.dataSource.count == 0 {
                strongSelf.emptyView.isHidden = false
            }else {
                strongSelf.emptyView.isHidden = true
            }
        }
    }
    //MARK:请求一品多商商品列表
    fileprivate func getSameProductMoreSellersProductList (){
        self.showLoading()
        self.viewModel.requestSameProductMoreProductList { [weak self] (isSuccess, Msg) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.dismissLoading()
            if strongSelf.viewModel.hasNextPage == false {
                strongSelf.mainTableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                strongSelf.mainTableView.mj_footer.endRefreshing()
            }
            strongSelf.mainTableView.mj_header.endRefreshing()
            guard isSuccess else{
                strongSelf.toast(Msg)
                return
            }
            strongSelf.fky_setupTitleLabel(strongSelf.viewModel.title.count > 0 ? strongSelf.viewModel.title : "常购清单")
            strongSelf.mainTableView.reloadData()
            //判断是否显示空态页面
            if strongSelf.viewModel.dataSource.count == 0 {
                strongSelf.emptyView.isHidden = false
            }else {
                strongSelf.emptyView.isHidden = true
            }
        }
    }
    //MARK:新品上架商品列表
    fileprivate func getNewGoodsOnSaleProductList (){
        self.showLoading()
        self.viewModel.requestNewGoodsOnSaleProductList { [weak self] (isSuccess, Msg) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.dismissLoading()
            if strongSelf.viewModel.hasNextPage == false {
                strongSelf.mainTableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                strongSelf.mainTableView.mj_footer.endRefreshing()
            }
            strongSelf.mainTableView.mj_header.endRefreshing()
            guard isSuccess else{
                strongSelf.toast(Msg)
                return
            }
            strongSelf.fky_setupTitleLabel(strongSelf.viewModel.title.count > 0 ? strongSelf.viewModel.title : "新品上架")
            strongSelf.mainTableView.reloadData()
            //判断是否显示空态页面
            if strongSelf.viewModel.dataSource.count == 0 {
                strongSelf.emptyView.isHidden = false
            }else {
                strongSelf.emptyView.isHidden = true
            }
        }
    }
}
