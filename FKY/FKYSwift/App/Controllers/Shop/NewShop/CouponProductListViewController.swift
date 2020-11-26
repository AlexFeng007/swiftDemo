//
//  CouponProductListViewController.swift
//  FKY
//
//  Created by 寒山 on 2019/10/30.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  优惠券 可以商品列表

import UIKit

class CouponProductListViewController: UIViewController,FKY_ShopCouponProductController {
    fileprivate var navBar: UIView?
    fileprivate var selectIndexPath: IndexPath? //选中cell 位置
    fileprivate var badgeView: JSBadgeView?
    lazy var tableView: UITableView = { [weak self] in
        var tableView = UITableView(frame: CGRect.null, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ColorConfig.colorffffff
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(ProductInfoListCell.self, forCellReuseIdentifier: "ProductInfoListCell")
        tableView.mj_header = self?.mjheader
        tableView.mj_footer = self?.mjfooter
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0//WH(213)
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
        }()
    fileprivate lazy var headview: ShopCoupleProductHeadView = {
        let headview = ShopCoupleProductHeadView()
        return headview
    }()
    
    fileprivate lazy var emptyView: CouponProductEmptyView = {
        let view = CouponProductEmptyView()
        return view
    }()
    
    
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            self?.getFirstPageShopProductFuc()
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
    }()
    
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            self?.getShopALLProductFuc()
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        footer!.mj_h = WH(67)
        return footer!
    }()
    fileprivate var viewModel: CoupleProductListViewModel = {
        let vm = CoupleProductListViewModel()
        return vm
    }()
    //行高管理器
    fileprivate var cellHeightManager:ContentHeightManager = {
        let heightManager = ContentHeightManager()
        return heightManager
    }()
    // 返回顶部按钮
    fileprivate lazy var toTopButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage.init(named: "icon_back_top"), for: UIControl.State())
        return button;
    }()
    //页码计数
    fileprivate lazy var lblPageCount:FKYCornerRadiusLabel  = {
        let label = FKYCornerRadiusLabel()
        label.initBaseInfo()
        label.isHidden = true
        return label
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
                    if strongSelf.keyword.isEmpty == false{
                        strongSelf.addNewBI_Record(model, model.showSequence, 2)
                    }else{
                        strongSelf.addCarBI_Record(model)
                    }
                }
            }
        }
        return addView
    }()
    @objc public var shopId: String = ""
    @objc public var couponTemplateId: String = ""
    @objc public var keyword: String = ""
    @objc public var couponName: String = ""
    @objc public var sourceType: String = "" //进入界面等来源（1:直播间的优惠券列表查看可用商品）
    /// 优惠券模板编号
    @objc var couponCode = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //删除存储高度
        cellHeightManager.removeAllContentCellHeight()
        // 同步购物车商品数量
        self.getCartNumber()
        // 购物车badge
        self.changeBadgeNumber(true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>CouponProductListViewController deinit~!@")
        self.dismissLoading()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("内存不足")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 登录成功后刷新界面数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.getFirstPageShopProductFuc), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        // app被杀掉时缓存数据
        
        viewModel.enterpriseId = self.shopId
        viewModel.couponTemplateId = self.couponTemplateId
        viewModel.keyword = self.keyword
        viewModel.couponCode = self.couponCode
        viewModel.sourceType = self.sourceType
        setupView()
        //每次进入获取缓存数据进行时间判断是否线上隐藏数据
    }
    // MARK: init Method
    fileprivate func setupView() {
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") {[weak self] in
            // 返回
            if let strongSelf = self {
                if strongSelf.keyword.isEmpty == false{
                    strongSelf.addBIWithCommonViewClickForSearch(0)
                }else{
                    strongSelf.addBIWithCommonViewClick(1)
                }
                FKYNavigator.shared().pop()
            }
        }
        fky_setupTitleLabel( "优惠券可用商品")
        self.fky_setupRightImage("icon_cart_new") {[weak self] in
            // 购物车
            if let strongSelf = self {
                if strongSelf.keyword.isEmpty == false{
                    strongSelf.addBIWithCommonViewClickForSearch(2)
                }else{
                    strongSelf.addBIWithCommonViewClick(2)
                }
                FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
                    let v = vc as! FKY_ShopCart
                    v.canBack = true
                }, isModal: false)
                //需关闭弹框
            }
            
        }
        
        let searchbar = FSearchBar()
        searchbar.initCommonSearchItem()
        searchbar.delegate = self
        searchbar.placeholder = self.keyword.isEmpty == false ? self.keyword: "搜索可用该券商品"
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
        
        
        //调整左右按钮
        self.NavigationBarRightImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(searchbar.snp.centerY)
            make.right.equalTo(self.navBar!.snp.right).offset(-WH(14))
        })
        self.NavigationBarLeftImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(searchbar.snp.centerY)
            make.left.equalTo(self.navBar!.snp.left).offset(WH(9))
            make.width.height.equalTo(WH(30))
        })
        self.navBar?.layoutIfNeeded()
        FKYNavigator.shared().topNavigationController.dragBackDelegate = self
        
        let bv = JSBadgeView(parentView: self.NavigationBarRightImage, alignment: .topRight)
        bv?.badgePositionAdjustment = CGPoint(x: WH(-3), y: WH(3))
        bv?.badgeTextFont = UIFont.systemFont(ofSize: WH(11))
        bv?.badgeBackgroundColor = RGBColor(0xFF2D5C)
        self.badgeView = bv
        
        self.view.addSubview(headview)
        headview.snp.makeConstraints {[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.left.right.equalTo(strongSelf.view)
            make.top.equalTo(navBar!.snp.bottom)
            make.height.equalTo(WH(0))
        }
        //headview.configView(self.couponName)
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.left.right.bottom.equalTo(strongSelf.view)
            make.top.equalTo(headview.snp.bottom)
        }
        tableView.mj_header.beginRefreshing()
        
        self.view.addSubview(emptyView)
        emptyView.isHidden = true
        emptyView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.left.right.bottom.equalTo(strongSelf.view)
            make.top.equalTo(headview.snp.bottom)
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
        self.toTopButton.addTarget(self, action: #selector(onBtnToTop), for: .touchUpInside)
        self.view.addSubview(self.toTopButton)
        self.view.bringSubviewToFront(self.toTopButton)
        self.toTopButton.snp.makeConstraints({ (make) in
            make.right.equalTo(self.view.snp.right).offset(-WH(20))
            make.bottom.equalTo(self.view.snp.bottom).offset(-WH(40))
            make.width.height.equalTo(WH(30))
        })
    }
    // MARK: Public Method
    func refreshTableView() {
        // 更新 只对 20条以内的 数据进行赋值
        if  self.viewModel.dataSource.isEmpty == true{
            return
        }
        if self.viewModel.dataSource.count > 20{
            for index in (self.viewModel.dataSource.count - 20)...(self.viewModel.dataSource.count - 1) {
                let product = self.viewModel.dataSource[index]
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.productId && cartOfInfoModel.supplyId.intValue == (product.vendorId ) {
                            product.carOfCount = cartOfInfoModel.buyNum.intValue
                            product.carId = cartOfInfoModel.cartId.intValue
                            break
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }else{
            for index in 0...(self.viewModel.dataSource.count - 1) {
                let product = self.viewModel.dataSource[index]
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.productId && cartOfInfoModel.supplyId.intValue == (product.vendorId ) {
                            product.carOfCount = cartOfInfoModel.buyNum.intValue
                            product.carId = cartOfInfoModel.cartId.intValue
                            break
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    //加车 刷新单个cell
    func refreshSingleCell() {
        if let indexPath = self.selectIndexPath , self.viewModel.dataSource.count > indexPath.row{
            let product =  self.viewModel.dataSource[indexPath.row]
            for cartModel  in FKYCartModel.shareInstance().productArr {
                if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                    if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.productId && cartOfInfoModel.supplyId.intValue == (product.vendorId ) {
                        product.carOfCount = cartOfInfoModel.buyNum.intValue
                        product.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    //刷新全部
    func refreshAllProductTableView() {
        if  self.viewModel.dataSource.isEmpty == true{
            return
        }
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            for index in 0...(strongSelf.viewModel.dataSource.count - 1) {
                let product = strongSelf.viewModel.dataSource[index]
                if FKYCartModel.shareInstance().productArr.count > 0{
                    for cartModel  in FKYCartModel.shareInstance().productArr {
                        if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                            if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.productId && cartOfInfoModel.supplyId.intValue == (product.vendorId )  {
                                product.carOfCount = cartOfInfoModel.buyNum.intValue
                                product.carId = cartOfInfoModel.cartId.intValue
                                break
                            }else {
                                product.carOfCount = 0
                                product.carId = 0
                            }
                        }
                    }
                }else{
                    product.carOfCount = 0
                    product.carId = 0
                }
                
                strongSelf.tableView.reloadData()
            }
        }
    }
    func refreshDismiss() {
        self.dismissLoading()
        if self.tableView.mj_header.isRefreshing() {
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.resetNoMoreData()
        }
        if  self.viewModel.hasNextPage {
            self.tableView.mj_footer.endRefreshing()
        }else{
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    
    /// 更新上方提示的内容和布局
    func configHeaderView(){
        if self.viewModel.words.isEmpty == true {// 空的
            self.headview.snp_updateConstraints { (make) in
                make.height.equalTo(0)
            }
            headview.configView("")
        }else{
            self.headview.snp_updateConstraints { (make) in
                make.height.equalTo(WH(30))
            }
            headview.configView(self.viewModel.words)
        }
    }
    
    //判断是否展示空视图
    fileprivate func showEmptyProducViewInfo(){
        //全部商品无产品判断
        if self.viewModel.currentPage == 1 && self.viewModel.dataSource.isEmpty == true{
            emptyView.isHidden = false;
            tableView.isHidden = true
        } else {
            emptyView.isHidden = true
            tableView.isHidden = false
        }
        emptyView.configView(self.keyword)
    }
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = HomeString.YHQ_ADD_SOURCE_TYPE
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
    //MARK: - Action
    @objc func onBtnToTop() {
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.lblPageCount.text = "第1页"
    }
}
//MARK:FSearchBarProtocol代理
extension CouponProductListViewController : FSearchBarProtocol {
    func fsearchBar(_ searchBar: FSearchBar, search: String?) {
    }
    
    func fsearchBar(_ searchBar: FSearchBar, textDidChange: String?) {
        print("textChange\(String(describing: textDidChange))")
    }
    
    func fsearchBar(_ searchBar: FSearchBar, touches: String?) {
        //点击搜索框
        if keyword.isEmpty == false{
            self.addBIWithCommonViewClickForSearch(1)
            FKYNavigator.shared().pop()
        }else{
            self.searchKeyBI_Record()
            FKYNavigator.shared().openScheme(FKY_Search.self, setProperty: { [weak self] (svc) in
                if let strongSelf = self {
                    let searchVC = svc as! FKYSearchViewController
                    searchVC.vcSourceType = .coupon
                    searchVC.searchType = .coupon
                    searchVC.couponID = strongSelf.couponTemplateId
                    searchVC.shopID = strongSelf.shopId
                    searchVC.couponName = strongSelf.couponName
                    searchVC.sourceType = strongSelf.sourceType
                    searchVC.couponCode = strongSelf.couponCode
                }
                }, isModal: false, animated: true)
        }
        
    }
}
extension CouponProductListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData =  self.viewModel.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInfoListCell", for: indexPath) as!   ProductInfoListCell
        cell.selectionStyle = .none
        cellData.showSequence = indexPath.row + 1
        cell.configCell(cellData)
        cell.resetCanClickShopArea(cellData,.ShopSearch)
        //更新加车数量
        cell.addUpdateProductNum = { [weak self] in
            if let strongSelf = self {
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
            if let strongSelf = self {
                if strongSelf.keyword.isEmpty == false{
                    strongSelf.addNewBI_Record(cellData, indexPath.row + 1, 3)
                }else{
                    strongSelf.itemEnterJBPShopBI_Record(cellData)
                }
                
                FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                    let controller = vc as! FKYNewShopItemViewController
                    controller.shopId = "\(cellData.vendorId )"
                    controller.shopType = "1"
                }, isModal: false)
            }
        }
        //跳转到店铺详情
        cell.clickShopContentArea = { [weak self] in
            if let strongSelf = self {
                strongSelf.selectIndexPath = indexPath
                if strongSelf.keyword.isEmpty == false{
                    strongSelf.addNewBI_Record(cellData, indexPath.row + 1, 4)
                }
                
                FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                    let controller = vc as! FKYNewShopItemViewController
                    controller.shopId = "\(cellData.vendorId )"
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
                if strongSelf.keyword.isEmpty == false{
                    strongSelf.addNewBI_Record(cellData, indexPath.row + 1, 1)
                }else{
                    strongSelf.itemDetailBI_Record(cellData)
                }
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
                    }
                }, isModal: false)
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let scrollIndex = indexPath.row / self.viewModel.pageSize + 1
        self.showCurrectPage(scrollIndex)
    }
}


extension CouponProductListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellData =  self.viewModel.dataSource[indexPath.row]
        let cellHeight = cellHeightManager.getContentCellHeight(cellData.productId ,"\(cellData.vendorId )",self.ViewControllerPageCode()!)
        if  cellHeight == 0{
            let conutCellHeight = ProductInfoListCell.getCellContentHeight(cellData)
            cellHeightManager.addContentCellHeight(cellData.productId ,"\(cellData.vendorId )",self.ViewControllerPageCode()!, conutCellHeight)
            return conutCellHeight
        }else{
            return cellHeight
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension CouponProductListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset_y = scrollView.contentOffset.y
        if offset_y >= SCREEN_HEIGHT/2 {
            self.toTopButton.isHidden = false
            self.view.bringSubviewToFront(self.toTopButton)
        }
        else {
            self.toTopButton.isHidden = true
            self.view.sendSubviewToBack(self.toTopButton)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating && !decelerate {
            let deadline :DispatchTime = DispatchTime.now() + 1
            DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.showCurrectPage(0)
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating {
            let deadline :DispatchTime = DispatchTime.now() + 1
            DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.showCurrectPage(0)
                }
            }
        }
    }
}
// MARK: Requset Method

extension CouponProductListViewController{
    //获取全部商品
    @objc func getShopALLProductFuc(){
        showLoading()
        viewModel.getAllProductInfo(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            //print("==============================123")
            strongSelf.tableView.mj_header.endRefreshing()
            strongSelf.refreshDismiss()
            strongSelf.showEmptyProducViewInfo()
            if success{
                strongSelf.refreshTableView()
                strongSelf.configHeaderView()
            } else {
                // 失败
                //strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    //请求第一页商品
    @objc func getFirstPageShopProductFuc(){
        self.viewModel.currentPosition = "1_0"
        self.viewModel.hasNextPage = true
        self.getShopALLProductFuc()
        self.getCartNumber()
        self.changeBadgeNumber(true)
    }
    // 同步购物车商品数量
    fileprivate func getCartNumber() {
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ [weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.refreshAllProductTableView()
        }) { [weak self] (reason) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.toast(reason)
        }
    }
}
//MARK:显示页码 修改购物车显示数量
extension CouponProductListViewController {
    func showCurrectPage(_ indexPage:Int){
        ////为0隐藏
        if indexPage == 0 || self.tableView.contentOffset.y == 0{
            self.lblPageCount.isHidden = true
        }else {
            //记录当前浏览的页数
            self.lblPageCount.isHidden = false
            self.lblPageCount.text = String.init(format: "第%zi页", indexPage)
        }
    }
    // 修改购物车显示数量
    fileprivate func changeBadgeNumber(_ isdelay: Bool) {
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
//MARK:埋点相关
extension CouponProductListViewController {
    func addCarBI_Record(_ product: HomeProductModel) {
        let itemContent = "\(product.vendorId )|\(product.productId )"
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : product.pm_pmtn_type! as AnyObject,"pageValue" : (self.couponTemplateId) as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName: "优惠券可用商品列表", itemId: ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue, itemPosition: "\(product.showSequence)", itemName: "加车", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    func itemDetailBI_Record(_ product: HomeProductModel) {
        let itemContent = "\(product.vendorId )|\(product.productId )"
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : product.pm_pmtn_type! as AnyObject,"pageValue" : (self.couponTemplateId) as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName: "优惠券可用商品列表", itemId: "I9998", itemPosition: "\(product.showSequence)", itemName: "点进商详", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    func itemEnterJBPShopBI_Record(_ product: HomeProductModel) {
        let itemContent = "\(product.vendorId )|\(product.productId )"
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : product.pm_pmtn_type! as AnyObject,"pageValue" : (self.couponTemplateId) as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName: "优惠券可用商品列表", itemId: "I9996", itemPosition: "\(product.showSequence)", itemName: "点进JBP专区", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    func addBIWithCommonViewClick(_ itemPosition:Int){
        var itemName = ""
        let itemId = "I6430"
        let extendParams:[String :AnyObject] = ["pageValue" : (self.couponTemplateId) as AnyObject]
        if itemPosition == 1 {
            itemName = "返回"
        }else if itemPosition == 2 {
            itemName = "购物车"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: itemId, itemPosition: "\(itemPosition)", itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    func addBIWithCommonViewClickForSearch(_ itemPosition:Int){
        var itemName = ""
        let itemId = "I9000"
        let extendParams:[String :AnyObject] = ["pageValue" : (self.couponTemplateId) as AnyObject]
        if itemPosition == 0 {
            itemName = "返回"
        }else if itemPosition == 2 {
            itemName = "购物车"
        }else if itemPosition == 1 {
            itemName = "搜索框"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "搜索栏", itemId: itemId, itemPosition: "\(itemPosition)", itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    func searchKeyBI_Record() {
        let extendParams:[String :AnyObject] = ["pageValue" : (self.couponTemplateId) as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName: nil, itemId: "I1000", itemPosition: "0", itemName: "搜索可用券商品", itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    func getBI_KeyWord()->[String :AnyObject]{
        let extendParams:[String :AnyObject] = ["keyword" : self.keyword as AnyObject,"pageValue" : (self.couponTemplateId) as AnyObject]
        return extendParams
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
        
        var extendParams:[String :AnyObject] = getBI_KeyWord()
        extendParams["pm_price"] = product.pm_price as AnyObject?
        extendParams["storage"] = product.storage as AnyObject?
        extendParams["pm_pmtn_type"] = product.pm_pmtn_type as AnyObject?
        for (key, value) in self.getBI_KeyWord() {
            extendParams[key] = value
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S9002", sectionPosition: "1", sectionName: "商品列表", itemId: itemId, itemPosition: "\(itemtPosition)", itemName: itemName, itemContent:itemContent , itemTitle: nil, extendParams: extendParams, viewController: self)
    }
}
extension CouponProductListViewController : FKYNavigationControllerDragBackDelegate {
    func dragBackShouldStart(in navigationController: FKYNavigationController!) -> Bool {
        return false
    }
}
