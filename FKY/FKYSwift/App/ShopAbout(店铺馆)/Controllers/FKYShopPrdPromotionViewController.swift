//
//  FKYShopPrdPromotionViewController.swift
//  FKY
//
//  Created by yyc on 2020/10/14.
//  Copyright © 2020 yiyaowang. All rights reserved.
//商家促销

import UIKit

class FKYShopPrdPromotionViewController: UIViewController {
    
    // MARK:刷新控件
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            //下拉刷新
            if let strongSelf = self {
                strongSelf.refreshTable()
            }
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
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
        footer!.backgroundColor = bg2
        return footer!
    }()
    // MARK:tableview
    public lazy var mainTableView: UITableView = { [weak self] in
        var tableView = UITableView(frame: CGRect.null, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = bg2
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = WH(150)
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ProductInfoListCell.self, forCellReuseIdentifier: "ProductInfoListCell_shop")
        tableView.register(FKYPrdHeaderView.self, forHeaderFooterViewReuseIdentifier: "FKYPrdHeaderView")
        tableView.mj_header = self?.mjheader
        tableView.mj_footer = self?.mjfooter
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()
    
    //商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        addView.pageType = 1
        //更改购物车数量
        addView.addCarSuccess = { [weak self] (isSuccess,type,productNum,productModel) in
            if let strongSelf = self {
                if isSuccess == true {
                    //                    if type == 1 {
                    //                        strongSelf.changeBadgeNumber(false)
                    //                    }else if type == 3 {
                    //                        strongSelf.changeBadgeNumber(true)
                    //                    }
                }
                strongSelf.refreshSingleCell()
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? FKYMedicinePrdDetModel {
                    strongSelf.addCommonBIWithView(1,nil,model)
                }
            }
        }
        return addView
    }()
    
    //空视图
    fileprivate var emptyView: FKYShopEmptyView = {
        let view = FKYShopEmptyView()
        view.isHidden = true
        return view
    }()
    
    //viewModel
    fileprivate var viewModel: FKYShopPromotionViewModel = {
        let vm = FKYShopPromotionViewModel()
        return vm
    }()
    
    //选中cell 位置
    fileprivate var selectIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.getProductList()
        //监控登录状态的改变
        NotificationCenter.default.addObserver(self, selector: #selector(FKYShopPrdPromotionViewController.loginStatuChanged(_:)), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FKYShopPrdPromotionViewController.loginStatuChanged(_:)), name: NSNotification.Name.FKYLogoutComplete, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCartNumber()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
//MARK:ui相关
extension FKYShopPrdPromotionViewController {
    func setupUI(){
        self.view.addSubview(self.mainTableView)
        self.mainTableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        emptyView.clickViewBlock = { [weak self] type in
            if let strongSelf = self {
                strongSelf.refreshTable()
            }
        }
    }
}
// MARK:UITableViewDelegate UITableViewDataSource
extension FKYShopPrdPromotionViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.prdArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = self.viewModel.prdArr[section]
        if let arr = sectionModel.mpHomeProductDtos {
            return arr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ProductInfoListCell_shop") as! ProductInfoListCell
        let sectionModel = self.viewModel.prdArr[indexPath.section]
        if let arr = sectionModel.mpHomeProductDtos {
            self.configProductCell(cell: cell, indexPath: indexPath, cellData: arr[indexPath.row])
        }
        cell.resetContentLayerColor()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FKYPrdHeaderView") as! FKYPrdHeaderView
        let sectionModel = self.viewModel.prdArr[section]
        headerView.configTitle(sectionModel.title)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionModel = self.viewModel.prdArr[indexPath.section]
        if let arr = sectionModel.mpHomeProductDtos {
            let cellData =  arr[indexPath.row]
            let conutCellHeight = ProductInfoListCell.getCellContentHeight(cellData)
            return conutCellHeight
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(35)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return WH(0.0001)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
//MARK: -  私有方法
extension FKYShopPrdPromotionViewController{
    /// 配置cell
    func configProductCell(cell:ProductInfoListCell,indexPath:IndexPath,cellData:FKYMedicinePrdDetModel){
        cell.selectionStyle = .none
        cell.configCell(cellData)
        cell.resetCanClickShopArea(cellData)
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
                controller.productId = cellData.productCode
                controller.venderId = cellData.productSupplyId
                controller.productUnit = cellData.unit
            }, isModal: false)
        }
        
        //跳转到聚宝盆商家专区
        cell.clickJBPContentArea = { [weak self] in
            if let _ = self {
                FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                    let controller = vc as! FKYNewShopItemViewController
                    controller.shopId = cellData.productSupplyId
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
                strongSelf.selectIndexPath = indexPath
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = cellData.productCode
                    v.vendorId = cellData.productSupplyId
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
                strongSelf.addCommonBIWithView(2,indexPath.row,cellData)
            }
        }
        
        /// 跳转到店铺首页
        cell.clickShopContentArea = { [weak self] in
            if let _ = self {
                FKYNavigator.shared()?.openScheme(FKY_ShopItem.self, setProperty: { (viewControl) in
                    let vc = viewControl as! FKYNewShopItemViewController
                    vc.shopId = cellData.productSupplyId
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
        self.addCarView.showOrHideAddCarPopView(true,self.parent?.view)
    }
    
    //加车 刷新单个cell
    func refreshSingleCell() {
        if let indexPath = self.selectIndexPath , self.viewModel.prdArr.count > indexPath.section{
            let sectionModel = self.viewModel.prdArr[indexPath.section]
            if let arr = sectionModel.mpHomeProductDtos,indexPath.row < arr.count {
                let product = arr[indexPath.row]
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.productCode && cartOfInfoModel.supplyId.intValue == Int(product.productSupplyId ?? "0") {
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
        }) { [weak self] (reason) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.toast(reason)
        }
    }
}
//MARK: -  响应事件
extension FKYShopPrdPromotionViewController{
    /// 刷新商品卡片的购物车数量
    func reloadViewWithBackFromCart() {
        for sectionModel in self.viewModel.prdArr {
            if let getarr = sectionModel.mpHomeProductDtos {
                for model in getarr {
                    if FKYCartModel.shareInstance().productArr.count > 0 {
                        for cartModel  in FKYCartModel.shareInstance().productArr {
                            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                                if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == model.productCode && cartOfInfoModel.supplyId.intValue == Int(model.productSupplyId ?? "0") {
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
        }
        self.mainTableView.reloadData()
    }
}
//MARK: - 网络请求
extension FKYShopPrdPromotionViewController {
    //下拉刷新
    @objc func refreshTable(){
        self.viewModel.hasNextPage = true
        self.viewModel.currentPage = 1
        self.viewModel.pageSize = 0
        self.mainTableView.mj_footer.endRefreshing()
        showLoading()
        self.getProductList()
    }
    // 上拉加载
    @objc func loadMore(){
        if self.viewModel.hasNextPage == false{
            self.dismissLoading()
            return
        }
        self.getProductList()
    }
    @objc fileprivate func loginStatuChanged(_ nty: Notification) {
        self.refreshTable()
    }
    
    fileprivate func refreshDismiss() {
        self.dismissLoading()
        if self.mainTableView.mj_header.isRefreshing() {
            self.mainTableView.mj_header.endRefreshing()
            self.mainTableView.mj_footer.resetNoMoreData()
        }
        if self.viewModel.hasNextPage {
            self.mainTableView.mj_footer.endRefreshing()
        }else{
            self.mainTableView.mj_footer.endRefreshingWithNoMoreData()
        }
        //判断有更多数据并且返回商品数量少于5
        if viewModel.hasNextPage == true && viewModel.totalProductsCount < 10  {
            self.mainTableView.mj_footer.beginRefreshing()
        }
    }
    //MARK:请求数据
    fileprivate func getProductList(){
        viewModel.getShopPromotionList(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.mainTableView.reloadData()
            strongSelf.refreshDismiss()
            if success{
                
            } else {
                // 失败
                strongSelf.toast(msg ?? "请求失败")
            }
            if strongSelf.viewModel.prdArr.count == 0 {
                strongSelf.emptyView.isHidden = false
            }else {
                strongSelf.emptyView.isHidden = true
            }
        }
    }
}
//MARK:埋点相关
extension FKYShopPrdPromotionViewController {
    fileprivate func addCommonBIWithView(_ type:Int,_ indexNum:Int?,_ model: FKYMedicinePrdDetModel) {
        var itemId:String?
        var itemName:String?
        var itemPosition :String?
        var sectionPosition :String?
        if let indexPath = self.selectIndexPath {
            sectionPosition = "\(indexPath.section+1)"
        }
        if type == 1 {
            //加车
            itemId = "I9999"
            itemName = "加车"
            itemPosition = "0"
        }else if type == 2 {
            //点击商品详情
            itemId = "I9998"
            itemName = "点进商详"
            itemPosition = "\(indexNum ?? 0)"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "商家热销", sectionId: "S4201", sectionPosition: sectionPosition, sectionName: nil, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: "\(model.productSupplyId ?? "0")|\(model.productCode ?? "0")", itemTitle: nil, extendParams: nil, viewController: self)
    }
}
