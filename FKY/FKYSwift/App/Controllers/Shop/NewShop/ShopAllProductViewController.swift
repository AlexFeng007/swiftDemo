//
//  ShopAllProductViewController.swift
//  FKY
//
//  Created by 寒山 on 2019/10/30.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  店铺内全部商品

import UIKit
typealias AddProdcutChangeNumAction = (Bool)->()
class ShopAllProductViewController: UIViewController {
    var callback: AddProdcutChangeNumAction? //加车刷新顶部购物车数量
    var cacheDic : Dictionary<String, Any>? //缓存数据
    @objc public var shopId: String = ""
    @objc dynamic var shopType: String? //是否是专区（1 专区 2 店铺详情,默认为店铺详情）
    fileprivate var lookCachesData = false;//是否查看了缓存数据
    fileprivate var shopAllProductNoDataView : UIView?//空态视图
    fileprivate var selectIndexPath: IndexPath = IndexPath.init(row: 0, section: 0) //选中cell 位置
    var navRightImageSize:CGSize? //导航栏宽度右边图片
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
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            self?.getFirstPageShopProductFuc()
            self?.getProductActivityType()
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
    // 顶部筛选视图
    fileprivate lazy var headerSelectedView: ShopAllProductFilterHeaderView = {
        let headView = ShopAllProductFilterHeaderView()
        return headView
    }()
    
    fileprivate var viewModel: ShopAllProducViewModel = {
        let vm = ShopAllProducViewModel()
        return vm
    }()
    //行高管理器
    fileprivate var cellHeightManager:ContentHeightManager = {
        let heightManager = ContentHeightManager()
        return heightManager
    }()
    //页码计数
    fileprivate lazy var lblPageCount:FKYCornerRadiusLabel  = {
        let label = FKYCornerRadiusLabel()
        label.initBaseInfo()
        label.isHidden = true
        return label
    }()
    //商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        addView.finishPoint = CGPoint(x:SCREEN_WIDTH - WH(10)-navRightImageSize!.width/2.0,y:naviBarHeight()-WH(5)-(navRightImageSize?.height)!/2.0)
        //更改购物车数量
        addView.addCarSuccess = { [weak self] (isSuccess,type,productNum,productModel) in
            if let strongSelf = self {
                if isSuccess == true {
                    if type == 1 {
                        if (strongSelf.callback != nil){
                            strongSelf.callback!(false)
                        }
                    }else if type == 3 {
                        if (strongSelf.callback != nil){
                            strongSelf.callback!(true)
                        }
                    }
                }
                strongSelf.refreshSingleCell()
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? ShopProductItemModel {
                    strongSelf.addCarBI_Record(model)
                }
            }
        }
        return addView
    }()
    deinit {
        // 移除通知
        print("...>>>>>>>>>>>>>>>>>>>>>ShopAllProductViewController deinit~!@")
        NotificationCenter.default.removeObserver(self)
        self.saveCachesData()
    }
    // MARK: Life Style
    override func viewDidLoad() {
        super.viewDidLoad()
        //        // 登录成功后刷新界面数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.getFirstPageShopProductFuc), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        // app被杀掉时缓存数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveCachesData), name: UIApplication.willTerminateNotification, object: nil)
        viewModel.enterpriseId = self.shopId
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //删除存储高度
        self.refreshTableView()
        cellHeightManager.removeAllContentCellHeight()
    }
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        //取消第一个按钮的选择
        self.headerSelectedView.dismissProductSelTypeView()
    }
    // MARK: init Method
    fileprivate func setupView() {
        headerSelectedView.shopId = self.shopId
        self.view.addSubview(headerSelectedView)
        headerSelectedView.snp.makeConstraints {[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.left.right.equalTo(strongSelf.view)
            make.top.equalTo(strongSelf.view)
            make.height.equalTo(WH(40))
        }
        headerSelectedView.productSortClick = { [weak self] type in
            guard let strongSelf = self else {
                return
            }
            strongSelf.itemSortSelBI_Record(type)
            strongSelf.viewModel.sortType =  type
            strongSelf.viewModel.currentIndex = 1
            strongSelf.viewModel.hasNextPage = true
            strongSelf.getShopALLProductFuc()
        }
        headerSelectedView.productTypeClick = { [weak self] typeCode in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.product2ndLM =  typeCode
            strongSelf.viewModel.currentIndex = 1
            strongSelf.viewModel.hasNextPage = true
            strongSelf.getShopALLProductFuc()
        }
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.left.right.bottom.equalTo(strongSelf.view)
            make.top.equalTo(headerSelectedView.snp.bottom)
        }
        tableView.mj_header.beginRefreshing()
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
    }
    // MARK: Public Method
    func refreshTableView() {
        if  self.viewModel.dataSource.isEmpty == true{
            return
        }
        // 更新 只对 100条以内的 数据进行赋值
        if self.viewModel.dataSource.count > 100{
            for index in (self.viewModel.dataSource.count - 100)...(self.viewModel.dataSource.count - 1) {
                let product = self.viewModel.dataSource[index]
                if FKYCartModel.shareInstance().productArr.count > 0 {
                    for cartModel  in FKYCartModel.shareInstance().productArr {
                        if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                            if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode && cartOfInfoModel.supplyId.intValue == Int(product.sellerCode ?? "0") {
                                product.carOfCount = cartOfInfoModel.buyNum.intValue
                                product.carId = cartOfInfoModel.cartId.intValue
                                break
                            }else {
                                product.carOfCount = 0
                                product.carId = 0
                            }
                        }
                    }
                }else {
                    product.carOfCount = 0
                    product.carId = 0
                }
                self.tableView.reloadData()
            }
        }else{
            for index in 0...(self.viewModel.dataSource.count - 1) {
                let product = self.viewModel.dataSource[index]
                if FKYCartModel.shareInstance().productArr.count > 0 {
                    for cartModel  in FKYCartModel.shareInstance().productArr {
                        if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                            if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode && cartOfInfoModel.supplyId.intValue == Int(product.sellerCode ?? "0") {
                                product.carOfCount = cartOfInfoModel.buyNum.intValue
                                product.carId = cartOfInfoModel.cartId.intValue
                                break
                            }else {
                                product.carOfCount = 0
                                product.carId = 0
                            }
                        }
                    }
                }else {
                    product.carOfCount = 0
                    product.carId = 0
                }
                
                self.tableView.reloadData()
            }
        }
    }
    //加车 刷新单个cell
    func refreshSingleCell() {
        if self.viewModel.dataSource.count > self.selectIndexPath.row{
            let product =  self.viewModel.dataSource[self.selectIndexPath.row]
            if FKYCartModel.shareInstance().productArr.count > 0 {
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode && cartOfInfoModel.supplyId.intValue == Int(product.sellerCode ?? "0") {
                            product.carOfCount = cartOfInfoModel.buyNum.intValue
                            product.carId = cartOfInfoModel.cartId.intValue
                            break
                        }else {
                            product.carOfCount = 0
                            product.carId = 0
                        }
                    }
                }
            }else {
                product.carOfCount = 0
                product.carId = 0
            }
            self.tableView.reloadRows(at: [self.selectIndexPath], with: .none)
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
                if FKYCartModel.shareInstance().productArr.count > 0 {
                    for cartModel  in FKYCartModel.shareInstance().productArr {
                        if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                            if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode && cartOfInfoModel.supplyId.intValue == Int(product.sellerCode ?? "0") {
                                product.carOfCount = cartOfInfoModel.buyNum.intValue
                                product.carId = cartOfInfoModel.cartId.intValue
                                break
                            }else {
                                product.carOfCount = 0
                                product.carId = 0
                            }
                        }
                    }
                }else {
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
    //判断是否展示空视图
    fileprivate func showEmptyProducViewInfo(){
        //全部商品无产品判断
        if self.viewModel.currentPage == 1 && self.viewModel.dataSource.isEmpty == true{
            if shopAllProductNoDataView == nil {
                // self.allProductView.layoutIfNeeded()
                shopAllProductNoDataView = self.showEmptyNoDataCustomView(self.tableView, "no_shop_pic", "暂无宝贝",false) {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.viewModel.currentIndex = 1
                    strongSelf.viewModel.hasNextPage = true
                    strongSelf.getShopALLProductFuc()
                }
            }else{
                //全部商品
                shopAllProductNoDataView?.isHidden = false;
            }
            shopAllProductNoDataView!.snp.remakeConstraints {[weak self] (make) in
                guard let strongSelf = self else {
                    return
                }
                make.left.right.bottom.equalTo(strongSelf.view)
                make.top.equalTo(strongSelf.headerSelectedView.snp.bottom)
            }
        } else {
            
            shopAllProductNoDataView?.isHidden = true
        }
    }
    //获取缓存后刷新
    func configViewWithCache(_ dic:Dictionary<String, Any>) {
        self.lookCachesData = true
        cellHeightManager.contentCellDic.removeAll()
        self.viewModel.dataSource.removeAll()
        self.viewModel.currentPage = Int(dic[shop_pageCount] as! String)!
        self.viewModel.dataSource.append(contentsOf:(dic[shop_data] as! [ShopProductItemModel]))
        self.refreshAllProductTableView()
        self.viewModel.currentIndex = self.viewModel.dataSource.count/10 + 1 //(数据+1代表要请求的页码)
        if self.viewModel.dataSource.count % 10 > 0 {
            self.viewModel.currentIndex = self.viewModel.currentIndex+1
        }
        self.viewModel.hasNextPage = self.viewModel.currentIndex <= self.viewModel.currentPage ? true : false
        self.viewModel.totalPage = Int(dic[shop_pageTotals] as! String)!
        tableView.reloadData()
        tableView.setContentOffset(CGPoint.init(x: 0, y: Double(dic[shop_offY] as! String)!), animated: false)
    }
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = HomeString.SHOPITEM_ALL_ADD_SOURCE_TYPE
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
}

extension ShopAllProductViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.dataSource.count <= indexPath.row{
            return UITableViewCell.init()
        }
        let cellData =  self.viewModel.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInfoListCell", for: indexPath) as!   ProductInfoListCell
        cell.selectionStyle = .none
        cellData.showSequence = indexPath.row + 1
        cell.configCell(cellData)
        //更新加车数量
        cell.addUpdateProductNum = { [weak self] in
            if let strongSelf = self {
                strongSelf.selectIndexPath = indexPath
                strongSelf.popAddCarView(cellData)
            }
        }
        //跳转到聚宝盆商家专区
        cell.clickJBPContentArea = { [weak self] in
            if let strongSelf = self {
                
            }
        }
        //到货通知
        cell.productArriveNotice = {
             FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                let controller = vc as! ArrivalProductNoticeVC
                controller.productId = cellData.spuCode!
                controller.venderId = "\(cellData.sellerCode ?? "0")"
                controller.productUnit = cellData.unit ?? ""
            }, isModal: false)
        }
        //登录
        cell.loginClosure = {
            FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
        }
        // 商详
        cell.touchItem = {[weak self] in
            if let strongSelf = self {
                strongSelf.itemDetailBI_Record(cellData)
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = cellData.spuCode
                    v.vendorId = cellData.sellerCode
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
        //MARK:套餐按钮
        cell.clickComboBtn = { [weak self] in
            if let _ = self {
                if let num = cellData.dinnerPromotionRule , num == 2 {
                    //固定套餐
                    FKYNavigator.shared().openScheme(FKY_ComboList.self, setProperty: { (vc) in
                        let controller = vc as! FKYComboListViewController
                        controller.enterpriseName = cellData.sellerName
                        if let codeNum = Int(cellData.sellerCode ?? "0") {
                            controller.sellerCode = codeNum
                        }else {
                            controller.sellerCode = 0
                        }
                        controller.spuCode = cellData.spuCode ?? ""
                    }, isModal: false)
                }else {
                    //搭配套餐
                   FKYNavigator.shared().openScheme(FKY_MatchingPackageVC.self, setProperty: { (vc) in
                        let controller = vc as! FKYMatchingPackageVC
                        controller.spuCode = cellData.spuCode ?? ""
                        controller.enterpriseId = cellData.sellerCode ?? ""
                    }, isModal: false)
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let scrollIndex = indexPath.row / self.viewModel.pageSize + 1
        self.showCurrectPage(scrollIndex)
    }
}


extension ShopAllProductViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.viewModel.dataSource.count <= indexPath.row{
            return 0
        }
        let cellData =  self.viewModel.dataSource[indexPath.row]
        let cellHeight = cellHeightManager.getContentCellHeight((cellData.spuCode ?? "" +  (cellData.idd ?? "")),(cellData.sellerCode ?? ""),self.ViewControllerPageCode()!)
        if  cellHeight == 0{
            let conutCellHeight = ProductInfoListCell.getCellContentHeight(cellData)
            cellHeightManager.addContentCellHeight((cellData.spuCode ?? "" +  (cellData.idd ?? "")),(cellData.sellerCode ?? ""),self.ViewControllerPageCode()!, conutCellHeight)
            return conutCellHeight
        }else{
            return cellHeight
        }
    }
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        let cellData =  self.viewModel.dataSource[indexPath.row]
    //        let cellHeight = cellHeightManager.getContentCellHeight(cellData.spuCode ?? "",self.ViewControllerPageCode()!)
    //        if  cellHeight == 0{
    //            let conutCellHeight = ProductInfoListCell.getContentHeight(cellData)
    //            cellHeightManager.addContentCellHeight(cellData.spuCode ?? "",self.ViewControllerPageCode()!, conutCellHeight)
    //            return conutCellHeight
    //        }else{
    //            return cellHeight!
    //        }
    //    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
extension ShopAllProductViewController: UIScrollViewDelegate {
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

extension ShopAllProductViewController{
    //获取全部商品
    @objc func getShopALLProductFuc(){
        //showLoading()
        viewModel.getAllProductInfo(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.tableView.mj_header.endRefreshing()
            strongSelf.refreshDismiss()
            if success{
                if strongSelf.viewModel.currentIndex == 2{
                    //防止历史记录和刷新的商品行高不同 刷新第一页去除行高记录
                    strongSelf.cellHeightManager.removeAllContentCellHeight()
                }
                strongSelf.refreshTableView()
                strongSelf.showEmptyProducViewInfo()
            } else {
                // 失败
                strongSelf.showEmptyProducViewInfo()
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    //请求第一页商品
    @objc func getFirstPageShopProductFuc(){
        self.viewModel.currentIndex = 1
        self.viewModel.hasNextPage = true
        self.getShopALLProductFuc()
        self.getCartNumber()
    }
    //获取商品分类和活动
    func getProductActivityType(){
        viewModel.getShopProductCatagoryInfo(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.tableView.mj_header.endRefreshing()
            strongSelf.refreshDismiss()
            if success{
                strongSelf.headerSelectedView.activityConfig = strongSelf.viewModel.activityConfig
                strongSelf.headerSelectedView.produftCategory = strongSelf.viewModel.produftCategory
                strongSelf.headerSelectedView.updateSelectProductTypeStates()
            } else {
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    // 同步购物车商品数量
    fileprivate func getCartNumber() {
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ [weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            if (strongSelf.callback != nil){
                strongSelf.callback!(true)
            }
        }) { [weak self] (reason) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.toast(reason)
        }
    }
    
}
//MARK:显示页码
extension ShopAllProductViewController {
    func showCurrectPage(_ indexPage:Int){
        ////为0隐藏
        if indexPage == 0 || self.tableView.contentOffset.y == 0{
            self.lblPageCount.isHidden = true
        }else {
            //记录当前浏览的页数
            self.lblPageCount.isHidden = false
            self.lblPageCount.text = String.init(format: "%zi/%zi", indexPage,self.viewModel.totalPage)
        }
    }
}
//MARK:缓存数据相关
extension ShopAllProductViewController {
    //离开界面保存或者清除缓存
    @objc func saveCachesData() {
        //大于10页时候进行缓存
        if self.viewModel.currentPage > CACHE_NUM && self.viewModel.contentIsAllProduct() {
            //查看缓存后，未查看更多，则清除缓存
            if self.lookCachesData == true, let dic = self.cacheDic {
                let arr = dic[shop_data] as? [ShopProductItemModel]
                if let list = arr, list.count > 0 {
                    let count = list.count
                    var hisPage = count/10
                    if count % 10 > 0 {
                        hisPage = hisPage + 1
                    }
                    if hisPage >= self.viewModel.currentPage {
                        self.cacheDic = nil
                        WUCache.removeFile(self.getCachesFileName())
                        return
                    }
                }
            }
            //保存
            let dic = NSMutableDictionary()
            dic[shop_pageCount] = String(format:"%d", self.viewModel.currentPage)
            dic[shop_pageTotals] = String(format:"%d", self.viewModel.totalPage)
            dic[shop_offY] = String(format:"%f", self.tableView.contentOffset.y)
            //获取当前滑动页的总数据(滑动到最后一页数据不全问题)
            if self.viewModel.totalPage == self.viewModel.currentPage, self.viewModel.currentPage*10-1 > self.viewModel.dataSource.count {
                WUCache.cacheShop(self.viewModel.dataSource, and: dic, toFile: self.getCachesFileName())
            } else {
                var index = 0 // 索引
                if self.viewModel.dataSource.count >= self.viewModel.currentPage*10 {
                    index = self.viewModel.currentPage*10
                }
                else {
                    index = self.viewModel.dataSource.count
                }
                let cacheArr = self.viewModel.dataSource[0..<index]
                WUCache.cacheShop(Array(cacheArr), and: dic, toFile: self.getCachesFileName())
            }
        }
        else {
            if self.lookCachesData == true, let dic = self.cacheDic {
                let arr = dic[shop_data] as? [ShopProductItemModel]
                if let list = arr, list.count > 0 {
                    let count = list.count
                    var hisPage = count/10
                    if count % 10 > 0 {
                        hisPage = hisPage + 1
                    }
                    if hisPage >= self.viewModel.currentPage {
                        WUCache.removeFile(self.getCachesFileName())
                        self.cacheDic = nil
                    }
                }
            }
        }
    }
    
    func getCachesFileName() -> String {
        // 店铺id
        if FKYLoginAPI.loginStatus() == .unlogin {
            return shop_fky + self.shopId
        }else {
            if let userId = FKYLoginAPI.currentUser().userId {
                return shop_fky + self.shopId + userId
            }else {
                return shop_fky + self.shopId
            }
        }
    }
}
//MARK:埋点相关
extension ShopAllProductViewController {
    func addCarBI_Record(_ product: ShopProductItemModel) {
        let itemContent = "\(product.sellerCode ?? "0")|\(product.spuCode ?? "0")"
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : product.pm_pmtn_type! as AnyObject,"pageValue" : (product.sellerCode ?? "0") as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName: "商品列表", itemId: ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue, itemPosition: "\(product.showSequence)", itemName: "加车", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    func itemDetailBI_Record(_ product: ShopProductItemModel) {
        let itemContent = "\(product.sellerCode ?? "0")|\(product.spuCode ?? "0")"
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : product.pm_pmtn_type! as AnyObject,"pageValue" : (product.sellerCode ?? "0") as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName: "商品列表", itemId: "I6409", itemPosition: "\(product.showSequence)", itemName: "点进商详", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    func itemSortSelBI_Record(_ sortType: ProdcutSortType) {
        let extendParams:[String :AnyObject] = ["pageValue" : (self.shopId) as AnyObject]
        if sortType == ProdcutSortType.ProdcutSortType_Sales{
            //销量
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F6406", floorPosition: "2", floorName: "排序", sectionId: nil, sectionPosition:nil, sectionName: nil, itemId: "I6408", itemPosition: "1", itemName: "销量", itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: self)
        }else  if sortType == ProdcutSortType.ProdcutSortType_ShopNum{
            //月店数
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F6406", floorPosition: "2", floorName: "排序", sectionId: nil, sectionPosition:nil, sectionName: nil, itemId: "I6408", itemPosition: "2", itemName: "月店数", itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: self)
        }
        
    }
}

