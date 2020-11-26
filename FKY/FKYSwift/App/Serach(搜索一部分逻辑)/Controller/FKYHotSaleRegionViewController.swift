//
//  FKYHotSaleRegionViewController.swift
//  FKY
//
//  Created by yyc on 2020/3/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHotSaleRegionViewController: UIViewController {
    enum fromPage {
        /// 未设置，有可能是以前的页面代码中没有传此参数
        case notSet
        /// 从搜索结果列表页
        case searchResult
    }
    /// cell列表
    var cellList: [FKYHotSaleRegionCellModel] = []
    
    fileprivate var navBar: UIView?
    fileprivate var badgeView: JSBadgeView?
    fileprivate var finishPoint: CGPoint? //购物车位置
    fileprivate var selectIndexPath: IndexPath = IndexPath.init(row: 0, section: 0) //选中cell 位置
    fileprivate var dataArr = [ShopProductCellModel]()
    //行高管理器
    fileprivate lazy var cellHeightManager: ContentHeightManager = self.creatCellHeightManager()
    
    
    fileprivate lazy var tableView: UITableView = self.creatTableView() 
    
    fileprivate lazy var mjheader: MJRefreshNormalHeader = self.creatMjheader()
    
    
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = self.creatMjfooter()
    
    //商品加车弹框
    fileprivate lazy var addCarView: FKYAddCarViewController = self.creatAddCarView()
    
    
    //请求工具类
    fileprivate lazy var hotServiece: FKYHotService = self.creatHotServiece()
    
    /// 套餐优惠viewmodel
    var discountPackageViewModel:FKYDiscountPackageViewModel = FKYDiscountPackageViewModel()
    
    /// 是否已经上传过曝光埋点
    var isUploadedDiscountEntryBI = false
    
    /// 从哪个界面过来
    var fromPage:fromPage = .notSet
    
    //传入数据
    var spuCode: String? //
    var vcTitle: String? //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.getHotProductList(true)
        self.requestDiscountPackageEntryInfo()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //删除存储高度
        cellHeightManager.removeAllContentCellHeight()
        // 同步购物车商品数量
        self.getCartNumber()
        // 购物车badge
        self.changeBadgeNumber(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(FKYOrderPayStatusVC.addDiscountBaoGuangBi), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("内存不足")
    }
    deinit {
        print("FKYHotSaleRegionViewController deinit>>>>>>>")
    }
}

//MARK: - view事件响应
extension FKYHotSaleRegionViewController{
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKY_goInDiscountPackage{// 优惠套餐入口
            self.addDiscountClickBI()
            let entryModel = userInfo[FKYUserParameterKey] as! FKYDiscountPackageModel
            (UIApplication.shared.delegate as! AppDelegate).p_openPriveteSchemeString(entryModel.jumpInfo)
        }
    }
}

//MARK:ui相关
extension FKYHotSaleRegionViewController {
    func setupView() {
        self.view.backgroundColor = RGBColor(0xF4F4F4)
        self.navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            } else {
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
            }()
        self.fky_setupTitleLabel(self.vcTitle)
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            //需关闭弹框
            // 返回
            if let strongSelf = self {
                FKYNavigator.shared().pop()
            }
        }
        self.fky_setupRightImage("icon_cart_new") { [weak self] in
            // 购物车
            if let strongSelf = self {
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
        
        //调整左右按钮
        self.NavigationBarRightImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationTitleLabel!.snp.centerY)
            make.right.equalTo(self.navBar!.snp.right).offset(-WH(14))
        })
        self.NavigationBarLeftImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationTitleLabel!.snp.centerY)
            make.left.equalTo(self.navBar!.snp.left).offset(WH(9))
            make.width.height.equalTo(WH(30))
        })
        self.navBar?.layoutIfNeeded()
        self.finishPoint = self.NavigationBarRightImage?.center
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.navBar!.snp.bottom)
        }
    }
}
//MARK:网络请求相关的处理
extension FKYHotSaleRegionViewController {
    
    /// 请求优惠套餐入口信息
    func requestDiscountPackageEntryInfo(){
        self.discountPackageViewModel.type = "35"
        self.discountPackageViewModel.requestDiscountPackageInfo {[weak self] (isSuccess, msg) in
            guard let weakSelf = self else {
                return
            }
            
            guard isSuccess else {
                weakSelf.toast(msg)
                return
            }
            weakSelf.processingData()
            weakSelf.tableView.reloadData()
        }
    }
    
    
    
    fileprivate func getHotProductList(_ isFresh: Bool) {
        if isFresh == true {
            self.showLoading()
            self.mjfooter.resetNoMoreData()
        }
        self.hotServiece.getCityHotRegionProductList(isFresh, spuCode ?? "") { [weak self] (hasMoreData, dataArr, tip) in
            guard let strongSelf = self else {
                return
            }
            if isFresh == true {
                strongSelf.dismissLoading()
                strongSelf.mjheader.endRefreshing()
                //删除存储高度
                strongSelf.cellHeightManager.removeAllContentCellHeight()
            }
            if hasMoreData == true {
                strongSelf.mjfooter.endRefreshing()
            } else {
                strongSelf.mjfooter.endRefreshingWithNoMoreData()
            }
            if let msg = tip {
                strongSelf.toast(msg)
            } else {
                //请求成功
                if let arr = dataArr, arr.count > 0 {
                    if isFresh == true {
                        strongSelf.dataArr.removeAll()
                        strongSelf.dataArr = arr
                        let model = strongSelf.dataArr[0]
                        strongSelf.fky_setupTitleLabel(model.hotRankName)
                    } else {
                        strongSelf.dataArr = strongSelf.dataArr + arr
                    }
                    strongSelf.processingData()
                    strongSelf.tableView.reloadData()
                }
                //判断是否显示空态页面
                //                if strongSelf.itemArr.count == 0 {
                //                    strongSelf.emptyView.isHidden = false
                //                }else {
                //                    strongSelf.emptyView.isHidden = true
                //                }
            }
        }
    }
    
    /// 处理数据
    func processingData() {
        self.cellList.removeAll()
        if self.discountPackageViewModel.discountPackage.imgPath.isEmpty == false , self.fromPage == .searchResult{ // 有优惠套餐的入口并且是从搜索结果页进来
            let entryCell = FKYHotSaleRegionCellModel()
            entryCell.cellType = .discountEntryCell
            self.cellList.append(entryCell)
        }
        
        for model in self.dataArr {
            let cellModel = FKYHotSaleRegionCellModel()
            cellModel.cellType = .productCell
            cellModel.productInfo = model
            self.cellList.append(cellModel)
        }
    }
    
}
//MARK:顶部导航栏相关的处理
extension FKYHotSaleRegionViewController {
    // 刷新购物车
    fileprivate func reloadViewWithBackFromCart() {
        for product in self.dataArr {
            if FKYCartModel.shareInstance().productArr.count > 0 {
                for cartModel in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.productId && cartOfInfoModel.supplyId.intValue == (product.vendorId ?? 0) {
                            product.carOfCount = cartOfInfoModel.buyNum.intValue
                            product.carId = cartOfInfoModel.cartId.intValue
                            break
                        } else {
                            product.carOfCount = 0
                            product.carId = 0
                        }
                    }
                }
            } else {
                product.carOfCount = 0
                product.carId = 0
            }
        }
        self.tableView.reloadData()
    }
    // 同步购物车商品数量
    fileprivate func getCartNumber() {
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ [weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            // 更新
            strongSelf.changeBadgeNumber(false)
            strongSelf.reloadViewWithBackFromCart()
        }) { [weak self] (reason) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.toast(reason)
        }
    }
    // 修改购物车显示数量
    fileprivate func changeBadgeNumber(_ isdelay: Bool) {
        var deadline: DispatchTime
        if isdelay {
            deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        } else {
            deadline = DispatchTime.now()
        }
        
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    strongSelf.badgeView!.badgeText = {
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
    //弹出加车框
    func popAddCarView(_ productModel: Any?) {
        //加车来源
        let sourceType = HomeString.SHOPITEM_ALL_ADD_SOURCE_TYPE
        self.addCarView.configAddCarViewController(productModel, sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
}
extension FKYHotSaleRegionViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.dataArr.count
        return self.cellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.cellList.count <= indexPath.row {
            return UITableViewCell.init()
        }
        let cellModel: FKYHotSaleRegionCellModel = self.cellList[indexPath.row]
        if cellModel.cellType == .productCell { // 商品
            let model: ShopProductCellModel = self.cellList[indexPath.row].productInfo
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInfoListCell", for: indexPath) as! ProductInfoListCell
            self.configCell(cell: cell, indexPath: indexPath, model: model)
            return cell
        } else if cellModel.cellType == .discountEntryCell { // 优惠套餐
            let cell: FKYDiscountPackageCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYDiscountPackageCell.self)) as! FKYDiscountPackageCell
            cell.configEntryWithModel(model: self.discountPackageViewModel.discountPackage)
            self.perform(#selector(FKYOrderPayStatusVC.addDiscountBaoGuangBi), with: nil, afterDelay: 3)
            return cell
        }
        return UITableViewCell.init()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.cellList.count <= indexPath.row {
            return 0.0001
        }
        let cellModel: FKYHotSaleRegionCellModel = self.cellList[indexPath.row]
        if cellModel.cellType == .productCell { // 商品
            let model: ShopProductCellModel = self.cellList[indexPath.row].productInfo
            let cellHeight = cellHeightManager.getContentCellHeight((model.productId ?? ""), "\(model.vendorId ?? 0)", self.ViewControllerPageCode()!)
            if cellHeight == 0 {
                let conutCellHeight = ProductInfoListCell.getCellContentHeight(model)
                cellHeightManager.addContentCellHeight((model.productId ?? ""), "\(model.vendorId ?? 0)", self.ViewControllerPageCode()!, conutCellHeight)
                return conutCellHeight
            } else {
                return cellHeight
            }
        } else if cellModel.cellType == .discountEntryCell,self.fromPage == .searchResult { // 优惠套餐 并且是从搜索结果列表页过来
            return 176.0 * SCREEN_WIDTH / 710.0 + WH(10) + WH(10)
        }
        return 0.001
    }
    
    /// 配置商品cell
    func configCell(cell: ProductInfoListCell, indexPath: IndexPath, model: ShopProductCellModel) {
        cell.selectionStyle = .none
        cell.configCell(model, model.hotRank ?? 10086)// 10086无意义标志位，可理解为空值
        cell.resetCanClickShopArea(model)
        //更新加车数量
        cell.addUpdateProductNum = { [weak self] in
            if let strongSelf = self {
                strongSelf.selectIndexPath = indexPath
                strongSelf.popAddCarView(model)
            }
        }
        //跳转到聚宝盆商家专区
        cell.clickJBPContentArea = { [weak self] in
            if let strongSelf = self {
                FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                    let controller = vc as! FKYNewShopItemViewController
                    controller.shopId = "\(model.vendorId ?? 0)"
                    controller.shopType = "1"
                }, isModal: false)
            }
        }
        //跳转到店铺详情
        cell.clickShopContentArea = { [weak self] in
            if let strongSelf = self {
                strongSelf.selectIndexPath = indexPath
                strongSelf.addBiInHotSaleRegion(model, 3)
                FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                    let controller = vc as! FKYNewShopItemViewController
                    controller.shopId = "\(model.vendorId ?? 0)"
                    controller.shopType = "2"
                }, isModal: false)
            }
        }
        //到货通知
        cell.productArriveNotice = {
            FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                let controller = vc as! ArrivalProductNoticeVC
                controller.productId = model.productId ?? "0"
                controller.venderId = "\(model.vendorId ?? 0)"
                controller.productUnit = model.unit ?? ""
            }, isModal: false)
        }
        //登录
        cell.loginClosure = {
            FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
        }
        // 商详
        cell.touchItem = { [weak self] in
            if let strongSelf = self {
                strongSelf.view.endEditing(false)
                strongSelf.selectIndexPath = indexPath
                strongSelf.addBiInHotSaleRegion(model, 2)
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = model.productId
                    v.vendorId = "\(model.vendorId ?? 0)"
                    v.updateCarNum = { [weak self] (carId, num) in
                        if let strongInSelf = self {
                            if let count = num {
                                model.carOfCount = count.intValue
                            }
                            if let getId = carId {
                                model.carId = getId.intValue
                            }
                            strongInSelf.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }, isModal: false)
            }
        }
    }
}
//MARK:bi埋点相关
extension FKYHotSaleRegionViewController {
    
    /// 套餐优惠曝光埋点
    @objc func addDiscountBaoGuangBi() {
        if self.isUploadedDiscountEntryBI == true{
            return;
        }
        self.isUploadedDiscountEntryBI = true
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I1999", itemPosition: nil, itemName: "有效曝光", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    }
    
    /// 套餐优惠点击埋点
    func addDiscountClickBI() {
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I0004", itemPosition: "1", itemName: self.discountPackageViewModel.discountPackage.name , itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    }
    
    fileprivate func addBiInHotSaleRegion(_ model: ShopProductCellModel, _ typeIndex: Int) {
        var itemId: String?
        var itemName: String?
        var itemContent: String?
        if typeIndex == 1 {
            //加车
            itemId = ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue
            itemName = "加车"
        } else if typeIndex == 2 {
            //点击商品详情
            itemId = "I9998"
            itemName = "点进商详"
        } else if typeIndex == 3 {
            //点击店铺
            itemId = "I9997"
            itemName = "点进店铺"
        }
        if let vendorId = model.vendorId {
            itemContent = "\(vendorId)|\(model.productId ?? "")"
        }
        let itemPosition = self.selectIndexPath.row + 1
        let itemTitle = model.hotSell?.cityName
        let floorName = model.hotSell?.cat3Name
        var extendParams = [String: AnyObject]()
        extendParams["pm_price"] = model.pm_price as AnyObject?
        extendParams["storage"] = model.storage as AnyObject?
        extendParams["pm_pmtn_type"] = model.pm_pmtn_type as AnyObject?
        extendParams["pageValue"] = model.hotRankName as AnyObject?
        
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: floorName, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: itemId, itemPosition: "\(itemPosition)", itemName: itemName, itemContent: itemContent, itemTitle: itemTitle, extendParams: extendParams, viewController: self)
    }
}

//MARK: - 属性对应的生成方法
extension FKYHotSaleRegionViewController {
    func creatCellHeightManager() -> ContentHeightManager{
        let heightManager = ContentHeightManager()
        return heightManager
    }
    
    func creatTableView() -> UITableView{
        var tableView = UITableView(frame: CGRect.null, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = RGBColor(0xF4F4F4)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = WH(80)
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(ProductInfoListCell.self, forCellReuseIdentifier: "ProductInfoListCell")
        tableView.register(FKYDiscountPackageCell.self, forCellReuseIdentifier: NSStringFromClass(FKYDiscountPackageCell.self))
        tableView.mj_header = self.mjheader
        tableView.mj_footer = self.mjfooter
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0//WH(213)
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }
    
    func creatMjheader() -> MJRefreshNormalHeader{
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            if let strongSelf = self {
                strongSelf.getHotProductList(true)
            }
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
    }
    
    func creatMjfooter() -> MJRefreshAutoStateFooter{
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            if let strongSelf = self {
                strongSelf.getHotProductList(false)
            }
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        footer!.mj_h = WH(67)
        return footer!
    }
    
    func creatAddCarView() -> FKYAddCarViewController{
        let addView = FKYAddCarViewController()
        if let desPoint = self.finishPoint {
            addView.finishPoint = desPoint
        }
        //更改购物车数量
        addView.addCarSuccess = { [weak self] (isSuccess, type, productNum, productModel) in
            if let strongSelf = self {
                if isSuccess == true {
                    if type == 1 {
                        strongSelf.changeBadgeNumber(false)
                    } else if type == 3 {
                        strongSelf.changeBadgeNumber(true)
                    }
                }
                //刷新点击的那个商品
                strongSelf.tableView.reloadData()
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? ShopProductCellModel {
                    strongSelf.addBiInHotSaleRegion(model, 1)
                }
            }
        }
        return addView
    }
    
    func creatHotServiece() -> FKYHotService{
        let serviece = FKYHotService()
        return serviece
    }
    
}

