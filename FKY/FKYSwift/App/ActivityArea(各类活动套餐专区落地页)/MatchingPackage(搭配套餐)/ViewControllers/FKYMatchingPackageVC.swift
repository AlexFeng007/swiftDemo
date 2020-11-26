//
//  FKYMatchingPackageVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYMatchingPackageVC: UIViewController {
    
    /// viewModel
    var viewModel:FKYMatchingPackageViewModel = FKYMatchingPackageViewModel()
    
    /// 企业ID/店铺ID 从上一个界面传过来
    @objc var enterpriseId:String = ""
    /// 商品的spuCode 从上一个界面传过来
    @objc var spuCode:String = ""
    
    /// 导航栏
    fileprivate var navBar: UIView?
    
    /// 是否是第一次加载 下拉刷新也会重置为第一次
    var isFirstTimeLoad = true
    
    /// 右上角购物车数量
    var badgeView: JSBadgeView?
    
    /// tableHeaderView
    var tableHeaderView:FKYMatchingPackageEnterpriseNameView = FKYMatchingPackageEnterpriseNameView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(63)))
    
    /// 数据列表
    lazy var mainTableView:UITableView = {
        let tb = UITableView(frame: CGRect.null, style: .grouped)
        tb.delegate = self
        tb.dataSource = self
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 150
        tb.sectionHeaderHeight = UITableView.automaticDimension
        tb.estimatedSectionHeaderHeight = WH(30)
        tb.separatorStyle = .none
        tb.tableHeaderView = self.tableHeaderView
        tb.tableFooterView = UIView.init(frame: CGRect.zero)
        tb.register(FKYMatchingPackageEmptyCell.self, forCellReuseIdentifier: NSStringFromClass(FKYMatchingPackageEmptyCell.self))
        tb.register(FKYMactchingPackageMarginCell.self, forCellReuseIdentifier: NSStringFromClass(FKYMactchingPackageMarginCell.self))
        tb.register(FKYMatchingPackageProductCell.self, forCellReuseIdentifier: NSStringFromClass(FKYMatchingPackageProductCell.self))
        tb.register(FKYMatchingPackageBuyPackageCell.self, forCellReuseIdentifier: NSStringFromClass(FKYMatchingPackageBuyPackageCell.self))
        tb.register(FKYMatchingPackageNoProductCell.self, forCellReuseIdentifier: NSStringFromClass(FKYMatchingPackageNoProductCell.self))
        
        tb.register(FKYMatchingPackageSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(FKYMatchingPackageSectionHeaderView.self))
        
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(FKYMatchingPackageVC.loadMore))
        footer?.setTitle("-- 没有更多啦！--", for: .noMoreData)
        tb.mj_footer = footer
        tb.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(FKYMatchingPackageVC.pullRefrash))
        tb.backgroundColor = .white
        if #available(iOS 11, *) {
            tb.contentInsetAdjustmentBehavior = .never
        }
        tb.backgroundColor = RGBColor(0xF4F4F4)
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.enterpriseId = "8353"
        self.viewModel.enterpriseId = self.enterpriseId
        self.viewModel.spuCode = self.spuCode
        self.viewModel.position = "1_0"
        self.setupUI()
        
        self.requestMatchingPackageList()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updataCartNumber()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: - 事件响应
extension FKYMatchingPackageVC {
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKYMatchingPackageProductCell.FKY_ProductSelectAction {/// 商品选中按钮点击
            self.viewModel.calculationPackagePrice()
            self.mainTableView.reloadData()
        }else if eventName == FKYSelectItemQuantityView.FKY_ProductNumberDownAction{/// 减少商品数量
            let param = userInfo[FKYUserParameterKey] as! (FKYProductModel,Int,String)
            self.updataProductListInfo(param)
            //self.updataProductListInfo()
        }else if eventName == FKYSelectItemQuantityView.FKY_ProductNumberUpAction{/// 增加商品数量
            let param = userInfo[FKYUserParameterKey] as! (FKYProductModel,Int,String)
            self.updataProductListInfo(param)
            //self.updataProductListInfo()
        }else if eventName == FKYSelectItemQuantityView.FKY_InputProductNumberAction{/// 完成输入数量  用户手动输入商品数量时候触发
            let param = userInfo[FKYUserParameterKey] as! (FKYProductModel,Int,String)
            self.updataProductListInfo(param)
            //self.updataProductListInfo()
        }else if eventName == FKYMatchingPackageBuyPackageCell.FKY_BuyPackageAction{/// 购买套餐事件
            //self.toast("/// 购买套餐事件")
            let dinnerID:String = userInfo[FKYUserParameterKey] as! String
            self.addBIType2(sectionName: self.viewModel.getSectionName(product: FKYProductModel(), dinnerID: dinnerID, type: 1), sectionPosition: self.viewModel.getSectionPosition(dinnerID: dinnerID), itemId: "I9999", itemName: "加车", itemPosition: "0", itemContent: self.viewModel.getItemContent(product: FKYProductModel(), dinnerID: dinnerID, type: 1))
            self.addPackageToCart(dinnerID: dinnerID)
        }else if eventName == FKYSelectItemQuantityView.FKY_PopErrorMsgAction{/// 展示错误信息
            let msg = userInfo[FKYUserParameterKey] as! String
            self.toast(msg)
        }
    }
    
    /// 从新计算商品数量和价格
    func updataProductListInfo(_ param:(FKYProductModel,Int,String)){
        self.viewModel.changeProductNum(product: param.0, type: param.1, inputNum: param.2)
        self.mainTableView.reloadData()
    }
}

//MARK: - TableView代理
extension FKYMatchingPackageVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sectionList[section].cellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel:FKYMatchingPackageCellModel = self.viewModel.sectionList[indexPath.section].cellList[indexPath.row]
        if cellModel.cellType == .productCell {/// 商品cell
            let cell:FKYMatchingPackageProductCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYMatchingPackageProductCell.self)) as! FKYMatchingPackageProductCell
            cell.showData(cellModel: cellModel)
            return cell
        }else if cellModel.cellType == .marginCell {// 选择其他搭售商品的分割cell
            let cell:FKYMactchingPackageMarginCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYMactchingPackageMarginCell.self)) as! FKYMactchingPackageMarginCell
            return cell
        }else if cellModel.cellType == .buyCell {// 购买餐cell
            let cell:FKYMatchingPackageBuyPackageCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYMatchingPackageBuyPackageCell.self)) as! FKYMatchingPackageBuyPackageCell
            cell.showData(cellModel: cellModel)
            return cell
        }else if cellModel.cellType == .emptyCell {// 空的分割cell
            let cell:FKYMatchingPackageEmptyCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYMatchingPackageEmptyCell.self)) as! FKYMatchingPackageEmptyCell
            return cell
        }else if cellModel.cellType == .noProductCell{
            let cell:FKYMatchingPackageNoProductCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYMatchingPackageNoProductCell.self)) as! FKYMatchingPackageNoProductCell
            return cell
        }
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel:FKYMatchingPackageCellModel = self.viewModel.sectionList[indexPath.section].cellList[indexPath.row]
        if cellModel.cellType == .productCell {
            self.addBIType3(sectionName: self.viewModel.sectionList[indexPath.section].packageModel.promotionName, sectionPosition: "\(indexPath.section+1)", itemId: "I9998", itemName: "点进商详", itemPosition: self.viewModel.getItemPosition(product: cellModel.cellData), itemContent: self.viewModel.getItemContent(product: cellModel.cellData, dinnerID: "", type: 2), storage: self.viewModel.getStorage(product: cellModel.cellData), pm_price: self.viewModel.getPm_price(product: cellModel.cellData), pm_pmtn_type: self.viewModel.getPm_pmtn_type())
            self.jumpToProductDetail(product: cellModel.cellData)
            return
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = self.viewModel.sectionList[section]
        guard sectionModel.isHaveSectionHeader else{
            return nil
        }
        
        let headerView:FKYMatchingPackageSectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(FKYMatchingPackageSectionHeaderView.self)) as! FKYMatchingPackageSectionHeaderView
        headerView.showPackageName(name: sectionModel.packageName)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = self.viewModel.sectionList[section]
        guard sectionModel.isHaveSectionHeader else{
            return 0.0000001
        }
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel:FKYMatchingPackageCellModel = self.viewModel.sectionList[indexPath.section].cellList[indexPath.row]
        if cellModel.cellType == .emptyCell {
            return WH(13)
        }else if cellModel.cellType == .noProductCell{
            return WH(508)
        }
        return tableView.rowHeight
    }
    
    //MARK: - ScrollView
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

//MARK: - 网络请求
extension FKYMatchingPackageVC {
    
    /// 将搭配套餐加入到购物车
    func addPackageToCart(dinnerID:String){
        self.showLoading()
        self.viewModel.requestAddPackageToCart(dinnerID: dinnerID) {[weak self] (isSuccess, msg) in
            guard let weakSelf = self else{
                self?.dismissLoading()
                return
            }
            weakSelf.dismissLoading()
            guard isSuccess else{
                weakSelf.toast(msg)
                return
            }
            weakSelf.toast("成功加入购物车")
            weakSelf.updataCartNumber()
        }
    }
    
    /// 获取搭配套餐列表
    func requestMatchingPackageList(){
        self.viewModel.requestMatchingPackageList {[weak self] (isSuccess, msg) in
            guard let weakSelf = self else{
                self?.mainTableView.mj_header.endRefreshing()
                self?.mainTableView.mj_footer.endRefreshing()
                return
            }
            guard isSuccess else {
                weakSelf.mainTableView.mj_header.endRefreshing()
                weakSelf.mainTableView.mj_footer.endRefreshing()
                weakSelf.toast(msg)
                return
            }
            
            weakSelf.viewModel.progressData()
            weakSelf.mainTableView.mj_header.endRefreshing()
            if weakSelf.viewModel.position.isEmpty {// 没有下一页了
                weakSelf.mainTableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                weakSelf.mainTableView.mj_footer.endRefreshing()
            }
            weakSelf.showData()
        }
    }
}

//MARK: - 私有方法
extension FKYMatchingPackageVC {
    /// 下拉刷新
    @objc func pullRefrash(){
        self.isFirstTimeLoad = true
        self.viewModel.dinners.removeAll()
        self.viewModel.position = "1_0"
        self.requestMatchingPackageList()
    }
    
    /// 上拉加载
    @objc func loadMore(){
        self.requestMatchingPackageList()
    }
    
    /// 跳转到商品详情
    func jumpToProductDetail(product:FKYProductModel){
//        var dinnerID:String = ""
//        for dinner in self.viewModel.dinners {
//            for temp_product in dinner.productList{
//                if temp_product.productId == product.productId{
//                    dinnerID = "\(dinner.promotionId)"
//                }
//            }
//        }
//        self.addBIType3(sectionName: self.viewModel.getSectionName(product: product, dinnerID: "", type: 2), sectionPosition: self.viewModel.getSectionPosition(dinnerID: dinnerID), itemId: "I9998", itemName: "点进商详", itemPosition: self.viewModel.getItemPosition(product: product), itemContent: self.viewModel.getItemContent(product: product, dinnerID: "", type: 2), storage: self.viewModel.getStorage(product: product), pm_price: self.viewModel.getPm_price(product: product), pm_pmtn_type: self.viewModel.getPm_pmtn_type())
        FKYNavigator.shared()?.openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
            let detailVC = vc as! FKY_ProdutionDetail
            detailVC.productionId = product.spuCode
            detailVC.vendorId = self.enterpriseId
        })
    }
    
    /// 显示数据
    func showData(){
        if self.isFirstTimeLoad {
            self.viewModel.installPackagePriceInfo()
            self.isFirstTimeLoad = false
        }
        self.tableHeaderView.showEnterpriseName(name:self.viewModel.enterpriseName)
        self.mainTableView.reloadData()
    }
    
    /// 更新购物车数量
    func updataCartNumber(){
        FKYVersionCheckService.shareInstance()?.syncCartNumberSuccess({ (isSuccess) in
            if isSuccess {
                self.changeBadgeNumber(false)
            }
        }, failure: { (msg) in
            //self.toast(msg)
        })
    }
    
    /// 有动画的时候才延迟
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



//MARK: - UI
extension FKYMatchingPackageVC {
    func setupUI(){
        self.configNaviBar()
        self.configBadgeView()
        self.view.addSubview(self.mainTableView)
        
        self.mainTableView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.navBar!.snp_bottom)
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
        self.fky_setupTitleLabel("搭配套餐")
        NavigationTitleLabel?.textColor = RGBColor(0xFFFFFF)
        self.navBar!.backgroundColor = RGBColor(0xFF2D5C)
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("togeterBack") {[weak self] in
            // 返回
            self?.addBIType1(sectionPosition: "", itemId: "I5999", itemName: "返回", itemPosition: "1")
            FKYNavigator.shared().pop()
        }
        
        self.fky_setupRightImage("secKill_car") {[weak self] in
            self?.addBIType1(sectionPosition: "", itemId: "I5999", itemName: "购物车", itemPosition: "2")
            // 购物车
            FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
                let v = vc as! FKY_ShopCart
                v.canBack = true
            }, isModal: false)
        }
    }
    
    /// 配置右上角购物车数量
    func configBadgeView(){
        let bv = JSBadgeView(parentView: self.NavigationBarRightImage, alignment: .topRight)
        bv?.badgePositionAdjustment = CGPoint(x: WH(-3), y: WH(3))
        bv?.badgeTextFont = UIFont.systemFont(ofSize: WH(11))
        bv?.badgeBackgroundColor = RGBColor(0xFFFFFF)
        bv?.badgeTextColor = RGBColor(0xFF2D5C)
        self.badgeView = bv
    }
}

//MARK: - BI埋点
extension FKYMatchingPackageVC {
    func addBIType1(sectionPosition:String,itemId:String,itemName:String,itemPosition:String){
        self.addBIType2(sectionName: "", sectionPosition: sectionPosition, itemId: itemId, itemName: itemName, itemPosition: itemPosition, itemContent: "")
    }
    
    func addBIType2(sectionName:String,sectionPosition:String,itemId:String,itemName:String,itemPosition:String,itemContent:String){
        self.addBIType3(sectionName: sectionName, sectionPosition: sectionPosition, itemId: itemId, itemName: itemName, itemPosition: itemPosition, itemContent: itemContent, storage: "", pm_price: "", pm_pmtn_type: "")
    }
    
    func addBIType3(sectionName:String,sectionPosition:String,itemId:String,itemName:String,itemPosition:String,itemContent:String,storage:String,pm_price:String,pm_pmtn_type:String){
        let extendParams = ["storage":storage,
                            "pm_price":pm_price,
                            "pm_pmtn_type":pm_pmtn_type]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "搭配套餐", sectionId: "S6402", sectionPosition: sectionPosition, sectionName: sectionName, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: itemContent, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: self)
    }
}
