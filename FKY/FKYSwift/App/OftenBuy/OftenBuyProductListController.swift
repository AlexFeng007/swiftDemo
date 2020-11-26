//
//  OftenBuyProductListController.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/14.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  常购清单

import UIKit

@objc
class OftenBuyProductListController: UIViewController {
    // MARK: - Property
    //行高管理器
    fileprivate var cellHeightManager:ContentHeightManager = {
        let heightManager = ContentHeightManager()
        return heightManager
    }()
    // 导航栏
    fileprivate lazy var navBar: UIView? = {
        if let _ = self.NavigationBar {
            //
        }
        else {
            self.fky_setupNavBar()
        }
        self.NavigationBar?.backgroundColor = bg1
        return self.NavigationBar
    }()
    // 角标
    fileprivate lazy var cartBadgeView: JSBadgeView? = {
        let view = JSBadgeView.init(parentView: self.NavigationBarRightImage, alignment:JSBadgeViewAlignment.topRight)
        view?.badgePositionAdjustment = CGPoint(x: WH(-2), y: WH(1))
        view?.badgeTextFont = UIFont.systemFont(ofSize: WH(10))
        view?.isHidden = true
        return view
    }()
    // 列表
    fileprivate lazy var tableview: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.tableHeaderView = {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
            view.backgroundColor = .clear
            return view
        }()
        view.tableFooterView = UIView.init(frame: CGRect.zero)
       // view.register(OftenBuyProductCell.self, forCellReuseIdentifier: "OftenBuyProductCell")
        view.register(ShopRecommendListCell.self, forCellReuseIdentifier: "ShopRecommendListCell")
        view.mj_header = self.mjheader
        view.mj_footer = self.mjfooter
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    // 标题
    fileprivate lazy var titleList: [FKYRecommendTitleView] = {
        var list = [FKYRecommendTitleView]()
        for i in 0..<3 {
            let viewTitle: FKYRecommendTitleView = {
                let view = FKYRecommendTitleView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(60)))
                view.backgroundColor = .white
                view.title = (i == 0 ? "常买" : (i == 1 ? "常看" : "热销"))
                view.hideMoreBtn(true)
                view.hideBottomLine(false)
                return view
            }()
            list.append(viewTitle)
        }
        return list
    }()
    // 下拉刷新
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.getListData(true)
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
    }()
    // 上拉加载更多
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.getListData(false)
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    // 无数据展示时的空态视图
    fileprivate lazy var tipView: OftenBuyProductEmptyView = {
        let view = OftenBuyProductEmptyView()
        return view
    }()
    // 返回顶部按钮
    fileprivate lazy var btnBackTop: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setBackgroundImage(UIImage.init(named: "btn_back_top"), for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tableview.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    //商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        addView.finishPoint = CGPoint(x: SCREEN_WIDTH-10-self.NavigationBarRightImage!.frame.size.width/2.0, y: self.fky_NavigationBarHeight()-5-self.NavigationBarRightImage!.frame.size.height/2.0)
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
                strongSelf.updateProductInfo()
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? OftenBuyProductItemModel ,let index = strongSelf.viewModel.indexPathSelect {
                    strongSelf.addBIRecordForProductPositon(index, model)
                }
            }
        }
        return addView
    }()
    
    //  网络请求 & 数据处理 & 数据源
    fileprivate var viewModel = OftenBuyViewModel()
    
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
        registerNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //删除存储高度
        cellHeightManager.removeAllContentCellHeight()
        updateAction()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("OftenBuyProductListController deinit~!@")
        self.dismissLoading()
        removeNotification()
    }
}

// MARK: - UI
extension OftenBuyProductListController {
    // UI绘制
    fileprivate func setupView() {
        setupNavigationBar()
        setupContentView()
    }
    
    // 导航栏
    fileprivate func setupNavigationBar() {
        // 标题
        fky_setupTitleLabel("常购清单")
        // 分隔线
        fky_hiddedBottomLine(false)
        
        // 返回
        fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        
        // 购物车
        fky_setupRightImage("oftenBuy_cart") { [weak self] in
            guard let strongSelf = self else {
                return
            }
            FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
                let v = vc as! FKY_ShopCart
                v.canBack = true
            }, isModal: false)
        }
        self.NavigationBarRightImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationBarLeftImage!)
            make.right.equalTo(self.navBar!).offset(-16)
        })
    }
    
    // 内容视图
    fileprivate func setupContentView() {
        view.backgroundColor = RGBColor(0xF4F4F4)
        
        var margin: CGFloat = 0
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                margin = iPhoneX_SafeArea_BottomInset
            }
        }
        
        tableview.reloadData()
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-margin)
            make.top.equalTo(self.navBar!.snp.bottom)
        }
        
        view.addSubview(btnBackTop)
        btnBackTop.snp.makeConstraints { (make) in
            make.right.right.equalTo(view).offset(-WH(15))
            make.bottom.equalTo(view).offset(-WH(50)-margin)
            make.size.equalTo(CGSize(width: WH(60), height: WH(60)))
        }
        // 默认隐藏
        btnBackTop.alpha = 0.0
    }
}

// MARK: - Data
extension OftenBuyProductListController {
    // 设置数据
    fileprivate func setupData() {
        // 请求资质状态成功后马上请求商品列表
        getZzStatus()
    }
    
    // 更新
    fileprivate func updateAction() {
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ [weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.refreshDataBackFromCart()
            strongSelf.tableview.reloadData()
            strongSelf.changeBadgeNumber(true)
        }) { (reason) in
            self.toast(reason)
        }
    }
    
    // 更新角标数字
    fileprivate func changeBadgeNumber(_ isdelay : Bool) {
        var deadline: DispatchTime = DispatchTime.now()
        if isdelay {
            // 刷新数据的时候有延迟，所以推后1.2s刷新
            deadline = DispatchTime.now() + 1.2
        }
        DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                let count = FKYCartModel.shareInstance().productCount
                if (count <= 0 || FKYLoginAPI.loginStatus() != FKYLoginStatus.loginComplete) {
                    strongSelf.cartBadgeView?.badgeText = ""
                    strongSelf.cartBadgeView?.isHidden = true
                } else if (count > 99) {
                    strongSelf.cartBadgeView?.badgeText = "99+";
                    strongSelf.cartBadgeView?.isHidden = false
                } else {
                    strongSelf.cartBadgeView?.badgeText = String(count)
                    strongSelf.cartBadgeView?.isHidden = false
                }
            }
        }
    }
}

// MARK: - Request
extension OftenBuyProductListController {
    // 查询资质
    fileprivate func getZzStatus() {
        showLoading()
        viewModel.requestZzStatus { [weak self] (status) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            switch status {
            case 1,3,4,6: // 资质审核通过
                // 请求数据
                strongSelf.getListData(true)
            case -1,11,12,13,14: // 资质未提交审核
                strongSelf.showTipView()
                strongSelf.tipView.type = .noSubmitAudit
            case 2,7: // 资质提交审核未通过
                strongSelf.showTipView()
                strongSelf.tipView.type = .noAudit
            case 0,5: // 资质提交审核中
                strongSelf.showTipView()
                strongSelf.tipView.type = .auditing
            default:
                strongSelf.toast("请求失败")
                break
            }
        }
    }
    
    // 请求商品列表
    fileprivate func getListData(_ refresh: Bool) {
        showLoading()
        viewModel.requestProductList(refresh, success: { [weak self] (model, needLoadMore) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            
            if refresh {
                // 刷新
                strongSelf.tableview.mj_header.endRefreshing()
                
            }
            else {
                // 加载更多
                strongSelf.tableview.mj_footer.endRefreshing()
            }
            
            if !needLoadMore {
                // 加载完毕
                strongSelf.tableview.mj_footer.endRefreshingWithNoMoreData()
            }
            else {
                // 需加载更多
                strongSelf.tableview.mj_footer.resetNoMoreData()
            }
            
            strongSelf.showListTitle()
            strongSelf.tableview.reloadData()
            strongSelf.dismissLoading()
            
            // 如三个类型均无数据，则显示空态视图
            strongSelf.checkProductListStatus()
        }) { [weak self] (errMsg) in
            // 失败
            guard let strongSelf = self else {
                return
            }
            
            if refresh {
                // 刷新
                strongSelf.tableview.mj_header.endRefreshing()
            }
            else {
                // 加载更多
                strongSelf.tableview.mj_footer.endRefreshing()
            }
            
            strongSelf.dismissLoading()
            strongSelf.toast(errMsg ?? "请求失败")
        }
    }
}

// MARK: - Notification
extension OftenBuyProductListController {
    // 注册通知
    fileprivate func registerNotification() {
        //
    }
    
    // 移除通知
    fileprivate func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Logic
extension OftenBuyProductListController {
    // 获取各类型下的商品个数
    fileprivate func getListCount(_ section: Int) -> Int {
        return viewModel.getProductListCount(section)
    }
    
    // 获取当前索引处的商品model对象
    fileprivate func getProductItem(_ indexPath: IndexPath) -> OftenBuyProductItemModel? {
        return viewModel.getProductItemModel(indexPath)
    }
    
    // 请求成功后更新标题
    fileprivate func showListTitle() {
        guard titleList.count == 3 else {
            return
        }
        
        for i in 0..<3 {
            let title: String? = viewModel.getProductListTitle(i)
            if let title = title, title.isEmpty == false {
                let view: FKYRecommendTitleView = titleList[i]
                view.title = title
            }
        }
    }
    
    // 显示空态视图
    fileprivate func showTipView() {
        view.addSubview(tipView)
        tipView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo((navBar?.snp.bottom)!)
        }
        tipView.isHidden = false
        tableview.isHidden = true
        btnBackTop.alpha = 0.0
    }
    
    // 若请求成功，但无数据，则显示空态视图
    fileprivate func checkProductListStatus() {
        let noData = viewModel.checkOftenBuyNoProductList()
        if noData {
            // 无数据
            btnBackTop.alpha = 0.0
            tableview.isHidden = true
            tipView.isHidden = false
            
            showTipView()
            tipView.type = .whole
        }
        else {
            // 有数据
            tableview.isHidden = false
            tipView.isHidden = true
        }
    }
    
    // 更新商品信息
    fileprivate func updateProductInfo() {
        guard let indexPath = viewModel.indexPathSelect else {
            return
        }
        guard let product: OftenBuyProductItemModel = getProductItem(indexPath) else {
            return
        }
        
        // 更新
        for cartModel in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                if  cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode! && cartOfInfoModel.supplyId.intValue == Int(product.supplyId!) {
                    product.carOfCount = cartOfInfoModel.buyNum.intValue
                    product.carId = cartOfInfoModel.cartId.intValue
                    break
                }
            }
        }
        UIView.performWithoutAnimation {
            tableview.reloadRows(at: [indexPath], with:UITableView.RowAnimation.none)
        }
    }
}

// MARK: - Cart
extension OftenBuyProductListController {
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        if let index = self.viewModel.indexPathSelect {
            let sourceType = self.getTypeSourceStr(index)
            self.addCarView.configAddCarViewController(productModel,sourceType)
            self.addCarView.showOrHideAddCarPopView(true,self.view)
        }
        
    }
    //设置加车的来源
    func getTypeSourceStr(_ indexPath: IndexPath) -> String{
        if indexPath.section == 0 {
            // 常买
            return  HomeString.CENTRE_OFTENBUY_ADD_SOURCE_TYPE
        }else if indexPath.section == 1 {
            //常看
            return  HomeString.CENTRE_OFTENLOOK_ADD_SOURCE_TYPE
        }else {
            //热销
            return  HomeString.CENTRE_HOTSALE_ADD_SOURCE_TYPE
        }
    }
}

// MARK: - BI
extension OftenBuyProductListController {
    // 切换类型时的埋点...<不再使用>
    fileprivate func addBIRecordForType(index: Int) {
        switch index {
        case 0: // 常买
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.HOME_SUGGESTPILL_SECTION_CODE.rawValue, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_SUGGESTPILL_OFTENBUY_CLICK_CODE.rawValue, itemPosition: "0", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        case 1: // 常看
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.HOME_SUGGESTPILL_SECTION_CODE.rawValue, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_SUGGESTPILL_OFTENLOOK_CLICK_CODE.rawValue, itemPosition: "0", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        case 2: // 热销
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.HOME_SUGGESTPILL_SECTION_CODE.rawValue, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_SUGGESTPILL_HOT_CLICK_CODE.rawValue, itemPosition: "0", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        default:
            break
        }
    }
    
    // 商品位置埋点
    fileprivate func addBIRecordForProductPositon(_ indexPath: IndexPath, _ product: OftenBuyProductItemModel) {
        let contentStr = "\(product.supplyId!)"+"/"+product.spuCode!
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0: // 常买
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.HOME_SUGGESTPILL_SECTION_CODE.rawValue, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_SUGGESTPILL_OFTENBUY_CLICK_CODE.rawValue, itemPosition: "\(row+1)", itemName: nil, itemContent: contentStr, itemTitle: "常买", extendParams: nil, viewController: self)
        case 1: // 常看
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.HOME_SUGGESTPILL_SECTION_CODE.rawValue, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_SUGGESTPILL_OFTENLOOK_CLICK_CODE.rawValue, itemPosition: "\(row+1)", itemName: nil, itemContent: contentStr, itemTitle: "常看", extendParams: nil, viewController: self)
        case 2: // 热销
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.HOME_SUGGESTPILL_SECTION_CODE.rawValue, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_SUGGESTPILL_HOT_CLICK_CODE.rawValue, itemPosition: "\(row+1)", itemName: nil, itemContent: contentStr, itemTitle: "热销榜", extendParams: nil, viewController: self)
        default:
            break
        }
    }
}

// MARK: - UIScrollViewDelegate
extension OftenBuyProductListController: UIScrollViewDelegate {
    // 置顶按钮显示状态控制
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetHeight = scrollView.contentOffset.y
        if offsetHeight >= WH(128) * 8 {
            // 显示
            if btnBackTop.alpha == 1.0 {
                return
            }
            
            UIView.animate(withDuration: 1.0, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                // process
                strongSelf.btnBackTop.alpha = 1.0;
            }) { (_) in
                // over
            }
        }
        else {
            // 隐藏
            if btnBackTop.alpha == 0.0 {
                return
            }
            
            UIView.animate(withDuration: 1.0, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                // process
                strongSelf.btnBackTop.alpha = 0.0;
            }) { (_) in
                // over
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension OftenBuyProductListController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getListCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 商品cell
        let cell: ShopRecommendListCell = tableView.dequeueReusableCell(withIdentifier: "ShopRecommendListCell", for: indexPath) as! ShopRecommendListCell
        cell.selectionStyle = .none
        // 配置cell
        let model: OftenBuyProductItemModel? = getProductItem(indexPath)
        cell.configCell(model as Any)
        
        // 更新加车数量
        cell.addUpdateProductNum = { [weak self] in
            if let strongSelf = self {
                strongSelf.viewModel.indexPathSelect = indexPath
                strongSelf.popAddCarView(model)
            }
        }
        // 商详
//        cell.touchItem = { [weak self] in
//            guard let strongSelf = self else {
//                return
//            }
//            strongSelf.view.endEditing(true)
//
//        }
//        // toast
//        cell.toastAddProductNum = { [weak self] msg in
//            guard let strongSelf = self else {
//                return
//            }
//            strongSelf.toast(msg)
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model: OftenBuyProductItemModel? = getProductItem(indexPath)
//        let cellHeight = cellHeightManager.getContentCellHeight(model!.spuCode ?? "","\(model!.supplyId ?? 0)",self.ViewControllerPageCode()!)
//        if  cellHeight == 0{
            let conutCellHeight = ShopRecommendListCell.getCellContentHeight(model as Any)
           // cellHeightManager.addContentCellHeight(model!.spuCode ?? "","\(model!.supplyId ?? 0)",self.ViewControllerPageCode()!, conutCellHeight)
            return conutCellHeight
//        }else{
//            return cellHeight!
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return getListCount(section) > 0 ? WH(60) : CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let count = getListCount(section)
        guard count > 0 else {
            return UIView()
        }
        guard section < titleList.count else {
            return UIView()
        }
        return titleList[section]
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return getListCount(section) > 0 ? WH(10) : CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let count = getListCount(section)
        guard count > 0 else {
            return UIView()
        }
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model: OftenBuyProductItemModel? = getProductItem(indexPath)
        guard let product = model else {
            return
        }
        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { [weak self]  (vc) in
            guard let strongSelf = self else {
                return
            }
            let v = vc as! FKY_ProdutionDetail
            v.productionId = product.spuCode!
            v.vendorId = "\(product.supplyId!)"
            v.updateCarNum = { (carId ,num) in
                if let count = num {
                    product.carOfCount = count.intValue
                }
                if let getId = carId {
                    product.carId = getId.intValue
                }
                strongSelf.tableview.reloadSections(IndexSet(integer: indexPath.section), with: .none)
            }
        }, isModal: false)
    }
}
