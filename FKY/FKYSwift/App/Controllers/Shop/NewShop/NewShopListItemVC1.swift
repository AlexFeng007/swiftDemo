//
//  NewShopListItemVC1.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/21.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  店铺管-活动

import UIKit

class NewShopListItemVC1: UIViewController, NewShoplistItemProtocol {
    //行高管理器
    fileprivate var cellHeightManager:ContentHeightManager = {
        let heightManager = ContentHeightManager()
        return heightManager
    }()
    // MARK: - properties
    fileprivate lazy var viewModel: ShopListVarietiesViewModel = ShopListVarietiesViewModel()
    
    lazy var tableView: UITableView = { [weak self] in
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.00001))
        headerView.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xFF5A9B), RGBColor(0xFF2D5C), SCREEN_WIDTH)
        
        let tableView = UITableView(frame: CGRect.null, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = WH(150)
        tableView.estimatedSectionFooterHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xFF5A9B), RGBColor(0xFF2D5C), SCREEN_WIDTH)
        tableView.register(ShopListBannerCell.self, forCellReuseIdentifier: "ShopListBannerCell")
        tableView.register(ShopListFuncCell.self, forCellReuseIdentifier: "ShopListFuncCell")
        tableView.register(HighQualityShopsCell.self, forCellReuseIdentifier: "HighQualityShopsCell")
        tableView.register(ShopListMajorActivityCell.self, forCellReuseIdentifier: "ShopListMajorActivityCell")
        //tableView.register(ShopListActivityZoneCell.self, forCellReuseIdentifier: "ShopListActivityZoneCell")
        tableView.register(ShopActivitySpaceCell.self, forCellReuseIdentifier: "ShopActivitySpaceCell")
        
        tableView.register(ShopListRecommendedAreaCell.self, forCellReuseIdentifier: "ShopListRecommendedAreaCell")
        tableView.register(ShopRecommendListCell.self, forCellReuseIdentifier: "ShopRecommendListCell")
        tableView.register(ShopSecondKillCell.self, forCellReuseIdentifier: "ShopSecondKillCell")
        tableView.mj_header = self?.mjheader
        tableView.mj_footer = self?.mjfooter
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
        }()
    
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            self?.onTableViewRefreshAction()
        })
        header?.stateLabel.textColor = UIColor.white
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.activityIndicatorViewStyle = UIActivityIndicatorView.Style.white
        header?.stateLabel.textColor = UIColor.white
        return header!
    }()
    
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            self?.onTableViewLoadNextPageAction()
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    
    //商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        //更改购物车数量
        addView.addCarSuccess = { [weak self] (isSuccess,type,productNum,productModel) in
            if let strongSelf = self {
                if isSuccess == true {
                    if type == 1 {
                        
                    }else if type == 3 {
                        
                    }
                }
                strongSelf.updateProductInfo()
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? ShopListProductItemModel {
                    //推荐专区
                    let  extendParams:[String:AnyObject] = ["storage" : model.storage! as AnyObject,"pm_price" : model.pm_price! as AnyObject,"pm_pmtn_type" : model.pm_pmtn_type! as AnyObject]
                    FKYAnalyticsManager.sharedInstance.BI_New_Record("F4001", floorPosition: "1", floorName: "华中自营", sectionId: SECTIONCODE.SHOPLIST_CHANGE_SECTION_CODE.rawValue, sectionPosition: "\(model.showSequence)", sectionName: "推荐专区", itemId: "I9999", itemPosition: "0", itemName: "加车", itemContent: "\(model.productSupplyId ?? "0")|\(model.productCode ?? "0")", itemTitle: nil, extendParams: extendParams, viewController: self)
                    
                }
                if let model = productModel as? ShopListSecondKillProductItemModel {
                    //特惠秒杀 
                    let  extendParams:[String:AnyObject] = ["storage" : model.storage! as AnyObject,"pm_price" : model.pm_price! as AnyObject,"pm_pmtn_type" : model.pm_pmtn_type! as AnyObject]
                    FKYAnalyticsManager.sharedInstance.BI_New_Record("F4001", floorPosition: "1", floorName: "华中自营", sectionId: nil, sectionPosition: nil, sectionName: "特惠秒杀", itemId: "I9999", itemPosition: "0", itemName: "加车", itemContent: "\(model.productSupplyId ?? "0")|\(model.productCode ?? "0")", itemTitle: nil, extendParams: extendParams, viewController: self)
                }
            }
        }
        return addView
    }()
    
    // app启动后加载首页数据过程中，先不显示空态视图；仅在加载无数据时才显示(至少有调用过一次接口)
    fileprivate var showEmptyDataView = false
    
    var needToResetTableviewOffset = false
    
    var scrollBlock: ((CGFloat)->())?
    
    var bgScrollOffset: CGFloat = 0
    
    //MARK: Life Style
    deinit {
        print("NewShopListItemVC1 deinit~!@")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showToastWhenNoNetwork()
        
        setupView()
        adapterView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewShopListItemVC1.loginStatuChanged(_:)), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewShopListItemVC1.loginStatuChanged(_:)), name: NSNotification.Name.FKYLogoutComplete, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchUserLocation(finishedCallback: { (_) in
        })
        updateAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetVarietiesPageStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private
    
    fileprivate func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    fileprivate func adapterView() {
        self.showLoading()
        // 请求数据(刷新)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            // 读缓存
            strongSelf.viewModel.loadCacheData(finishedCallback: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                DispatchQueue.main.async(execute: {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.updateVarietiesPageContent()
                    strongSelf.hideLoadMoreFooterWhenRequestFail()
                    strongSelf.showLoading()
                    // 请求数据(刷新)
                    strongSelf.onTableViewRefreshAction()
                })
            })
        }
    }
    
    @objc fileprivate func loginStatuChanged(_ nty: Notification) {
        needToResetTableviewOffset = true
        showLoading()
        onTableViewRefreshAction()
    }
    
    @objc fileprivate func refreshHomePage(_ nty: Notification) {
        needToResetTableviewOffset = true
        onTableViewRefreshAction()
    }
    
    fileprivate func updateAction() {
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ [weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.refreshDataBackFromCart()
            strongSelf.tableView.reloadData()
        }) {[weak self] (reason) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.toast(reason)
        }
    }
    
    // 数据源更新后刷新整个界面
    fileprivate func updateVarietiesPageContent() {
        if mjheader.isRefreshing() {
            mjheader.endRefreshing()
            mjfooter.resetNoMoreData()
        }
        if viewModel.hasNextPage == false {
            // 数据加载完毕，隐藏上拉加载footer
            mjfooter.endRefreshing()
        } else {
            // 数据未加载完，上拉加载footer需一直显示
            mjfooter.endRefreshing()
            if tableView.mj_footer == nil {
                tableView.mj_footer = mjfooter
            }
        }
        tableView.reloadData()
    }
    
    // 只要有调接口，就置为true
    fileprivate func updateEmptyDataShowStatus() {
        if !showEmptyDataView {
            showEmptyDataView = true
            tableView.reloadEmptyDataSet()
        }
    }
    
    // 重置首页显示状态
    fileprivate func resetVarietiesPageStatus() {
        // tableview滑到顶部...<修复(tableview滑到底部后)切换账号后返回到首页时出现顶部出现空白区域的情况>
        if needToResetTableviewOffset {
            needToResetTableviewOffset = false
            tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        }
    }
    
    // 接口请求失败时，隐藏上拉加载更多的footer，以避免出现无限请求的问题
    fileprivate func hideLoadMoreFooterWhenRequestFail() {
        mjfooter.endRefreshingWithNoMoreData()
        tableView.mj_footer = nil
        
        if mjheader.isRefreshing() {
            mjheader.endRefreshing()
            mjfooter.resetNoMoreData()
        }
    }
    
    // 刷新...<获取第1页数据>
    fileprivate func onTableViewRefreshAction() {
        DispatchQueue.global().async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.loadDataBinding(finishedCallback: {[weak self] (msg, success) in
                guard let strongSelf = self else {
                    return
                }
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.dismissLoading()
                    strongSelf.updateEmptyDataShowStatus()
                    if !success {
                        // 请求失败
                        strongSelf.hideLoadMoreFooterWhenRequestFail()
                    }
                    guard msg == nil else {
                        strongSelf.toast(msg)
                        return
                    }
                    // 每次刷新数据成功时，均需要发通知，以便使得有倒计时的楼层cell中的timer暂停
                    // 解决bug: 刷新之前有倒计时楼层，刷新之后无倒计时楼层。若不发通知取消，则timer会一直在后台运行
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShopListString.FKYShopListRefreshToStopTimers), object: self, userInfo: nil)
                    // 刷新
                    strongSelf.updateVarietiesPageContent()
                }
            })
        }
    }
    
    // 加载更多...<获取第1页之后的数据>
    fileprivate func onTableViewLoadNextPageAction() {
        DispatchQueue.global().async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.loadNextPageBinding(finishedCallback: {[weak self] (msg, success) in
                guard let strongSelf = self else {
                    return
                }
                DispatchQueue.main.async {
                    if !success {
                        // 请求失败
                        strongSelf.hideLoadMoreFooterWhenRequestFail()
                    }
                    guard msg == nil else {
                        strongSelf.toast(msg)
                        return
                    }
                    strongSelf.updateVarietiesPageContent()
                };
            })
        }
    }
    
    func resetContentOffset() {
        tableView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    func currentOffset() -> CGFloat {
        return self.tableView.contentOffset.y
    }
}

extension NewShopListItemVC1: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model: ShopListModelInterface = viewModel.rowModel(atIndexPath: indexPath)
        return tableView.heightForRow(withShopListModelInterface: model, in: tableView, withIdentifier: model.floorCellIdentifier(), cachedBy: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let section = indexPath.section
        let row = indexPath.row
        if viewModel.floors.count > section {
            if let model = viewModel.floors[section] as? ShopListTemplateModel{
                if let subModel = model.contents as? ShopListSecondKillModel {
                    //特惠秒杀
                    if let list = subModel.recommend?.floorProductDtos, list.count > row {
                        let mod = list[row]
                        let  extendParams:[String:AnyObject] = ["storage" : mod.storage! as AnyObject,"pm_price" : mod.pm_price! as AnyObject,"pm_pmtn_type" : mod.pm_pmtn_type! as AnyObject]
                        FKYAnalyticsManager.sharedInstance.BI_New_Record("F4001", floorPosition: "1", floorName: "华中自营", sectionId:nil, sectionPosition: nil, sectionName: "特惠秒杀", itemId: ITEMCODE.SHOPLIST_SECONDKILL_CLICK_CODE.rawValue, itemPosition: "\(indexPath.row+1)", itemName: "点进商详", itemContent: "\(mod.productSupplyId ?? "0")|\(mod.productCode ?? "0")", itemTitle: subModel.floorName ?? "", extendParams: extendParams, viewController: self)
                    }
                    
                    if let list = subModel.recommend?.floorProductDtos, list.count > row {
                        let mod = list[row]
                        jumpProductDetail(productCode: mod.productCode, productSupplyId: mod.productSupplyId)
                    }
                }
                else if let subModel = model.contents as? ShopListRecommendAreaModel {
                    //推荐专区
                    if let list = subModel.recommend?.floorProductDtos, list.count > row {
                        let mod = list[row]
                        let  extendParams:[String:AnyObject] = ["storage" : mod.storage! as AnyObject,"pm_price" : mod.pm_price! as AnyObject,"pm_pmtn_type" : mod.pm_pmtn_type! as AnyObject]
                        FKYAnalyticsManager.sharedInstance.BI_New_Record("F4001", floorPosition: "1", floorName: "华中自营", sectionId: SECTIONCODE.SHOPLIST_CHANGE_SECTION_CODE.rawValue, sectionPosition: "\(model.showSequence)", sectionName: "推荐专区", itemId: ITEMCODE.SHOPLIST_RECOMMENT_CLICK_CODE.rawValue, itemPosition: "\(indexPath.row+1)", itemName: "点进商详", itemContent: "\(mod.productSupplyId ?? "0")|\(mod.productCode ?? "0")", itemTitle: subModel.floorName ?? "" , extendParams: extendParams, viewController: self)
                    }
                    
                    if let list = subModel.recommend?.floorProductDtos, list.count > row {
                        let mod = list[row]
                        jumpProductDetail(productCode: mod.productCode, productSupplyId: mod.productSupplyId)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.floors.count > section {
            if let model = viewModel.floors[section] as? ShopListTemplateModel{
                switch model.type {
                case .unknow000:
                    break
                case .secondsKill:
                    return WH(40)
                default:
                    break
                }
            }
        }
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if viewModel.floors.count > section {
            if let model = viewModel.floors[section] as? ShopListTemplateModel{
                if model.type == .areaChoice || model.type == .clinicArea{
                    let indexPath  = IndexPath(row: 0, section: section)
                    let configModel: ShopListModelInterface = viewModel.rowModel(atIndexPath: indexPath)
                    return ShopListActivityZoneCell.calculateFooterHeight(withModel: configModel, tableView: tableView);
                }
            }
        }
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.floors.count > section {
            if let model = viewModel.floors[section] as? ShopListTemplateModel{
                switch model.type {
                case .unknow000:
                    break
                case .secondsKill:
                    let view = FKYRecommendTitleView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(40)))
                    view.backgroundColor = UIColor.white
                    
                    if let name = model.floorName, name.isEmpty == false {
                        view.title = name
                    }
                    
                    if let subModel = model.contents as? ShopListSecondKillModel {
                        //判读是否显示更多按钮
                        if let urlMore = subModel.recommend?.jumpInfoMore, urlMore.isEmpty == false {
                            view.hideMoreBtn(false)
                            view.moreCallback = {
                                FKYAnalyticsManager.sharedInstance.BI_New_Record("F4001", floorPosition: "1", floorName: "华中自营", sectionId: nil, sectionPosition: nil, sectionName: "特惠秒杀", itemId: ITEMCODE.SHOPLIST_SECONDKILL_CLICK_CODE.rawValue, itemPosition: "0", itemName: "更多", itemContent: nil, itemTitle: model.floorName, extendParams: nil, viewController: self)
                                
                                visitSchema(urlMore)
                            }
                        }else {
                            view.hideMoreBtn(true)
                        }
                    }
                    
                    return view
                default:
                    break
                }
            }
            
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.00001))
        view.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xFF5A9B), RGBColor(0xFF2D5C), SCREEN_WIDTH)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewModel.floors.count > section {
            if let model = viewModel.floors[section] as? ShopListTemplateModel{
                if model.type == .areaChoice || model.type == .clinicArea{
                    let footerView = ShopListActivityZoneCell()
                    let indexPath  = IndexPath(row: 0, section: section)
                    let configModel: ShopListModelInterface = viewModel.rowModel(atIndexPath: indexPath)
                    footerView.configCell(recommend: (configModel as! ShopListActivityZoneModel))
                    footerView.callback = {[weak self] (action) in
                        guard let strongSelf = self else {
                            return
                        }
                        let ac = action
                        strongSelf.onClickCellAction(ac)
                    }
                    return footerView
                }
            }
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.00001))
        view.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xFF5A9B), RGBColor(0xFF2D5C), SCREEN_WIDTH)
        return view
    }
}

extension NewShopListItemVC1: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let list: ShopListContainerProtocol & ShopListModelInterface = viewModel.floors[section]
        return list.numberOfChildModelsInShopListContainer()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.floors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model: ShopListModelInterface = viewModel.rowModel(atIndexPath: indexPath)
        
        let cell = tableView.cellForRow(withShopListModelInterface: model) {[weak self] (action) in
            guard let strongSelf = self else {
                return
            }
            let ac = action as! ShopListTemplateAction
            strongSelf.onClickCellAction(ac)
        }
        if let ce = cell as? HighQualityShopsCell {
            ce.section = indexPath.section-1
        }
        if let ce = cell as? ShopListMajorActivityCell {
            ce.section = indexPath.section-1
        }
        if let ce = cell as? ShopActivitySpaceCell {
            ce.section = indexPath.section-1
        }
        if let ce = cell as? ShopSecondKillCell {
            //            ce.section = indexPath.section-1
            //
            ce.addUpdateProductNum = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.popAddCarView(model)
            }
            ce.refreshDataWithTimeOut  = { [weak self] typeTimer in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.onTableViewRefreshAction()
            }
        }
        if let ce = cell as? ShopRecommendListCell{
            //更新加车
            ce.addUpdateProductNum = { [weak self]  in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.popAddCarView(model)
            }
            //登录
            ce.loginClosure = {
                FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            }
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.hasNextPage == false {
            // 数据加载完毕，隐藏上拉加载footer
            mjfooter.endRefreshingWithNoMoreData()
            return
        }
        if  (viewModel.shouldAutoLoading)!, !mjfooter.isRefreshing() {
            mjfooter.beginRefreshing()
        }
    }
}

//MARK: 加车
extension NewShopListItemVC1 {
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = HomeString.MP_PZH_ADD_SOURCE_TYPE
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
    fileprivate func updateProductInfo() {
        viewModel.refreshDataBackFromCart()
        tableView.reloadData()
    }
}

//MARK: 页面跳转
extension NewShopListItemVC1 {
    fileprivate func onClickCellAction(_ action: ShopListTemplateAction) {
        let type: ShopListTemplateActionType = action.actionType
        let params: Dictionary<String, Any> = action.actionParams
        let model = params[ShopListString.ACTION_KEY]
        
        // 埋点处理
        if action.needRecord {
            let floorType = action.floorPosition
            let floorCode = action.floorCode
            let floorName = action.floorName
            let sectionCode = action.sectionCode
            let sectionPosition = action.sectionPosition
            let sectionName = action.sectionName
            let itemCode = action.itemCode
            let itemPosition = action.itemPosition
            let itemName = action.itemName
            let itemTitle = action.itemTitle
            let itemContent = action.itemContent
            let extendParams = action.extenParams
            let viewController = self
            FKYAnalyticsManager.sharedInstance.BI_New_Record(floorCode, floorPosition: floorType, floorName: floorName, sectionId: sectionCode, sectionPosition: sectionPosition, sectionName: sectionName, itemId: itemCode, itemPosition: itemPosition, itemName: itemName, itemContent: itemContent, itemTitle: itemTitle, extendParams: extendParams, viewController: viewController)
        }
        
        switch type {
        case .unknow:
            break
        case .banners_clickItem:
            let mod: HomeCircleBannerItemModel = model as! HomeCircleBannerItemModel
            jumpBannerDetailActionWithAll(jumpType: mod.jumpType, jumpInfo: mod.jumpInfo, jumpExpandOne: mod.jumpExpandOne, jumpExpandTwo: mod.jumpExpandTwo)
        case .mpNavigation_clickItem:
            let mod: HomeFucButtonItemModel = model as! HomeFucButtonItemModel
            jumpBannerDetailActionWithAll(jumpType: mod.jumpType, jumpInfo: mod.jumpInfo, jumpExpandOne: mod.jumpExpandOne, jumpExpandTwo: mod.jumpExpandTwo)
        case .highQualityShops_clickItem:
            let mod: HighQualityShopsItemModel = model as! HighQualityShopsItemModel
            jumpBannerDetailActionWithAll(jumpType: mod.jumpType, jumpInfo: mod.jumpInfo, jumpExpandOne: mod.jumpExpandOne, jumpExpandTwo: mod.jumpExpandTwo)
        case .majorActivity_clickItem:
            let mod: ShopListMajorActivityModel = model as! ShopListMajorActivityModel
            jumpBannerDetailActionWithAll(jumpType: mod.jumpType, jumpInfo: mod.jumpInfo, jumpExpandOne: mod.jumpExpandOne, jumpExpandTwo: mod.jumpExpandTwo)
        case .ActivityZone_clickItem:
            jumpActivityZone(model as! HomeRecommendProductItemModel)
        case .ActivityZone_clickItemMore:
            jumpActivityZoneMore(model as! ShopListActivityZoneModel)
        case .login:
            FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
        case .product_cartNumChanged:
            break
        case .product_addCart:
            break
        }
    }
    
    fileprivate func jumpActivityZoneMore(_ mod: ShopListActivityZoneModel) {
        if let url = mod.recommend?.jumpInfoMore, url.isEmpty == false {
            visitSchema(url)
        }
    }
    
    fileprivate func jumpActivityZone(_ mod: HomeRecommendProductItemModel) {
        if let url = mod.buyTogetherJumpInfo, url.count > 0 {
            if url.contains("web/h5/yqg_active") {
                FKYNavigator.shared().openScheme(FKY_Togeter_Detail_Buy.self, setProperty: { (vc) in
                    let v = vc as! FKYTogeterBuyDetailViewController
                    v.typeIndex = "1"
                    v.productId = "\(mod.buyTogetherId ?? 0)"
                })
            }else {
                // 跳转到商品一起购活动
                visitSchema(url)
            }
        }
        else {
            // 跳转商详
            jumpProductDetail(productCode: mod.productCode, productSupplyId: mod.productSupplyId)
        }
    }
}

extension NewShopListItemVC1: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 100 {
            tableView.backgroundColor = UIColor.white
        } else {
            tableView.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xFF5A9B), RGBColor(0xFF2D5C), SCREEN_WIDTH)
        }
        if let block = scrollBlock {
            block(scrollView.contentOffset.y)
        }
    }
}

//MARK: 空页面
extension NewShopListItemVC1: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        tableView.backgroundColor = UIColor.white
        guard showEmptyDataView else {
            tableView.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xFF5A9B), RGBColor(0xFF2D5C), SCREEN_WIDTH)
            return nil
        }
        let bg = UIView()
        let imageView = UIImageView.init(image: UIImage.init(named: ShopListString.EMPTY_PAGE_IMG))
        bg.addSubview(imageView)
        let titleLabel = UILabel()
        let attributes = [ NSAttributedString.Key.font: FontConfig.font14, NSAttributedString.Key.foregroundColor: ColorConfig.color999999]
        titleLabel.attributedText = NSAttributedString.init(string: ShopListString.EMPTY_PAGE_TEXT, attributes: attributes)
        bg.addSubview(titleLabel)
        let button = UIButton()
        button.setTitle(ShopListString.EMPTY_PAGE_BUTTON_TITLE, for: .normal)
        button.setBackgroundImage(UIImage.init(named: ShopListString.EMPTY_PAGE_BUTTON_BG), for: .normal)
        button.setTitleColor(ColorConfig.color333333, for: .normal)
        button.setTitleColor(ColorConfig.color999999, for: .highlighted)
        button.titleLabel?.font = FontConfig.font14
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.showLoading()
            strongSelf.onTableViewRefreshAction()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        bg.addSubview(button)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(bg)
            make.centerX.equalTo(bg)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(WH(15))
            make.centerX.equalTo(bg)
        }
        button.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(20))
            make.centerX.equalTo(bg)
            make.size.equalTo(CGSize(width: WH(86), height: WH(28)))
            make.bottom.equalTo(bg)
        }
        return bg
    }
}

