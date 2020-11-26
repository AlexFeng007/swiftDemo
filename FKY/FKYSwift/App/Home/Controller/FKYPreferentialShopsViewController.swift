//
//  FKYPreferentialShopsViewController.swift
//  FKY
//
//  Created by yyc on 2020/4/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYPreferentialShopsViewController: UIViewController {
    
    fileprivate var navBar : UIView?
    fileprivate var badgeView: JSBadgeView?
    fileprivate var finishPoint:CGPoint? //购物车位置
    fileprivate var selectIndexPath: IndexPath = IndexPath.init(row: 0, section: 0) //选中cell 位置
    fileprivate var dataArr = [FKYPreferetailModel]()
    
    fileprivate var timer: Timer!
    fileprivate var nowLocalTime : Int64 = 0 //记录当前系统时间
    
    //行高管理器
    fileprivate var cellHeightManager:ContentHeightManager = {
        let heightManager = ContentHeightManager()
        return heightManager
    }()
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        var tableView = UITableView(frame: CGRect.null, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = RGBColor(0xF4F4F4)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(FKYComPreKillCell.self, forCellReuseIdentifier: "FKYComPreKillCell")
        tableView.register(HomeOneAdPageCell.self, forCellReuseIdentifier: "HomePreOneAdPageCell")
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
            if let strongSelf = self {
                strongSelf.getPreferetialProductList(true)
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
                strongSelf.getPreferetialProductList(false)
            }
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        footer!.mj_h = WH(67)
        return footer!
    }()
    //商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        if let desPoint = self.finishPoint {
            addView.finishPoint = desPoint
        }
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
                //刷新点击的那个商品
                strongSelf.tableView.reloadRows(at:[strongSelf.selectIndexPath], with: .none)
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? FKYPreferetailModel {
                    strongSelf.add_NEW_BI(itemId: "I9999", itemName: "加车", itemPosition: "\(strongSelf.selectIndexPath.row)", itemContent: "\(model.sellerCode ?? "")|\(model.spuCode ?? "")", storage: model.storage ?? "", pm_price: model.pm_price ?? "", pm_pmtn_type: model.pm_pmtn_type ?? "")
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
    
    //请求工具类
    fileprivate lazy var preferetialServiece : FKYPreferentialModel = {
        let serviece = FKYPreferentialModel()
        return serviece
    }()
    
    //传入数据
    var spuCode:String? // 商品编码
    var sellCode:String? //卖家id
    var vcTitle:String? //
    override func viewDidLoad() {
        super.viewDidLoad()
        if let str = vcTitle ,str.count > 0 {
        }else {
            vcTitle = "商家特惠"
        }
        self.setupView()
        self.getPreferetialProductList(true)
        // 登录成功后刷新界面数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataWithLoginSuccess), name: NSNotification.Name.FKYLoginSuccess, object: nil)
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("内存不足")
    }
    deinit {
        print("FKYPreferentialShopsViewController deinit>>>>>>>")
        self.stopTimer()
        NotificationCenter.default.removeObserver(self)
    }
    
}
//MARK:ui相关
extension FKYPreferentialShopsViewController {
    func setupView() {
        self.view.backgroundColor = RGBColor(0xFFFFFF)
        self.navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            }else{
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
            }()
        self.fky_setupTitleLabel(self.vcTitle)
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            // 返回
            if let strongSelf = self {
                strongSelf.stopTimer()
                FKYNavigator.shared().pop()
                strongSelf.add_NEW_BI(itemId: "I7300", itemName: "返回", itemPosition: "1", itemContent: "", storage: "", pm_price: "", pm_pmtn_type: "")
            }
        }
        self.fky_setupRightImage("icon_cart_new") {[weak self] in
            // 购物车
            if let strongSelf = self {
                FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
                    let v = vc as! FKY_ShopCart
                    v.canBack = true
                }, isModal: false)
                strongSelf.add_NEW_BI(itemId: "I7300", itemName: "购物车", itemPosition: "2", itemContent: "", storage: "", pm_price: "", pm_pmtn_type: "")
            }
        }
        
        let bv = JSBadgeView(parentView: self.NavigationBarRightImage, alignment: .topRight)
        bv?.badgePositionAdjustment = CGPoint(x: WH(-3), y: WH(3))
        bv?.badgeTextFont = UIFont.systemFont(ofSize: WH(11))
        bv?.badgeBackgroundColor = RGBColor(0xFF2D5C)
        self.badgeView = bv
        
        FKYNavigator.shared().topNavigationController.dragBackDelegate = self
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
        self.view.addSubview(self.emptyView)
        self.emptyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
}
//MARK:网络请求相关的处理
extension FKYPreferentialShopsViewController{
    @objc func reloadDataWithLoginSuccess() {
        self.getPreferetialProductList(true)
    }
    fileprivate func getPreferetialProductList(_ isFresh:Bool) {
        if isFresh == true {
            self.showLoading()
            self.mjfooter.resetNoMoreData()
        }
        self.preferetialServiece.getPreferentialShopWithProductList(self.sellCode,self.spuCode,isFresh) {[weak self] (hasMoreData,dataArr, tip) in
            guard let strongSelf = self else{
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
            }else {
                strongSelf.mjfooter.endRefreshingWithNoMoreData()
            }
            if let msg = tip {
                strongSelf.toast(msg)
            }else {
                //请求成功
                if let arr = dataArr, arr.count > 0 {
                    if isFresh == true {
                        strongSelf.dataArr.removeAll()
                        strongSelf.dataArr = arr
                        strongSelf.beginSystemTimeOut()
                    }else {
                        strongSelf.dataArr = strongSelf.dataArr + arr
                        strongSelf.tableView.reloadData()
                    }
                }
                //判断是否显示空态页面
                if strongSelf.dataArr.count == 0 {
                    strongSelf.emptyView.isHidden = false
                }else {
                    strongSelf.emptyView.isHidden = true
                }
            }
        }
    }
}
//MARK:顶部导航栏相关的处理
extension FKYPreferentialShopsViewController {
    // 刷新购物车
    fileprivate func reloadViewWithBackFromCart() {
        for product in self.dataArr {
            if FKYCartModel.shareInstance().productArr.count > 0 {
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode && cartOfInfoModel.supplyId.intValue == Int(product.sellerCode ?? "0") {
                            product.carOfCount = cartOfInfoModel.buyNum.intValue
                            product.carId = cartOfInfoModel.cartId.intValue
                            break
                        } else {
                            product.carOfCount = 0
                            product.carId = 0
                        }
                    }
                }
            }else {
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
        if  isdelay {
            deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        }else {
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
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = HomeString.SHOPITEM_ALL_ADD_SOURCE_TYPE
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
}
extension FKYPreferentialShopsViewController: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataArr.count > 0 {
            return self.dataArr.count+1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomePreOneAdPageCell", for: indexPath) as!  HomeOneAdPageCell
            let prdModel = self.dataArr[0]
            cell.configPreferentialShopAdView(
                prdModel.imgPath)
            return cell
        }else {
            let model =  self.dataArr[indexPath.row-1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "FKYComPreKillCell", for: indexPath) as!   FKYComPreKillCell
            cell.selectionStyle = .none
            cell.configCell(model, nowLocalTime: self.nowLocalTime)
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
                        controller.shopId = model.sellerCode ?? ""
                        controller.shopType = "1"
                    }, isModal: false)
                }
            }
            //跳转到店铺详情
            cell.clickShopContentArea = { [weak self] in
                if let strongSelf = self {
                    strongSelf.selectIndexPath = indexPath
                    strongSelf.add_NEW_BI(itemId: "I9997", itemName: "点进店铺", itemPosition: "\(indexPath.row)", itemContent: "\(model.sellerCode ?? "")|\(model.spuCode ?? "")", storage: model.storage ?? "", pm_price: model.pm_price ?? "", pm_pmtn_type: model.pm_pmtn_type ?? "")
                    FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                        let controller = vc as! FKYNewShopItemViewController
                        controller.shopId = model.sellerCode ?? ""
                        controller.shopType = "2"
                    }, isModal: false)
                }
            }
            //到货通知
            cell.productArriveNotice = {
                FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                    let controller = vc as! ArrivalProductNoticeVC
                    controller.productId = model.spuCode ?? "0"
                    controller.venderId = "\(model.sellerCode ?? "0")"
                    controller.productUnit = model.unitName ?? ""
                }, isModal: false)
            }
            //登录
            cell.loginClosure = {
                FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            }
            // 商详
            cell.touchItem = {[weak self] in
                if let strongSelf = self {
                    strongSelf.view.endEditing(false)
                    strongSelf.selectIndexPath = indexPath
                    strongSelf.add_NEW_BI(itemId: "I9998", itemName: "点进商详", itemPosition: "\(indexPath.row)", itemContent: "\(model.sellerCode ?? "")|\(model.spuCode ?? "")", storage: model.storage ?? "", pm_price: model.pm_price ?? "", pm_pmtn_type: model.pm_pmtn_type ?? "")
                    FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: {  (vc) in
                        let v = vc as! FKY_ProdutionDetail
                        v.productionId = model.spuCode
                        v.vendorId = model.sellerCode ?? ""
                        v.updateCarNum = { [weak self] (carId ,num) in
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
            cell.refreshDataWithTimeOut = { [weak self] typeTimer in
                if let strongSelf = self {
                    strongSelf.getPreferetialProductList(true)
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return WH(97)
        }else {
            let model =  self.dataArr[indexPath.row-1]
            let cellHeight = cellHeightManager.getContentCellHeight((model.spuCode ?? ""),model.sellerCode ?? "",self.ViewControllerPageCode()!)
            
            if  cellHeight == 0{
                let conutCellHeight = FKYComPreKillCell.getCellContentHeight(model,self.nowLocalTime)
                cellHeightManager.addContentCellHeight((model.spuCode ?? ""),model.sellerCode ?? "",self.ViewControllerPageCode()!, conutCellHeight)
                return conutCellHeight
            }else{
                return cellHeight
            }
        }
    }
}
//MARK:bi埋点相关
extension FKYPreferentialShopsViewController{
    func add_NEW_BI(itemId:String,itemName:String,itemPosition:String,itemContent:String,storage:String,pm_price:String,pm_pmtn_type:String){
        //高毛专区
        let extendParams = ["storage":storage,
                            "pm_price":pm_price,
                            "pm_pmtn_type":pm_pmtn_type,
                            "pageValue":self.vcTitle ?? ""]
        var sectionName:String?
        if itemId == "I7300" {
            sectionName = "头部"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: sectionName, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: itemContent, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: self)
    }
}

extension FKYPreferentialShopsViewController {
    fileprivate func beginSystemTimeOut(){
        //刷新
        if self.dataArr.count > 0 {
            let preModel = self.dataArr[0]
            self.stopTimer()
            self.nowLocalTime = preModel.systemTime ?? 0
            self.tableView.reloadData()
            // 启动timer...<1.s后启动>
            let date = NSDate.init(timeIntervalSinceNow: 1.0)
            timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(calculateCount), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        }
    }
    @objc fileprivate func calculateCount() {
        self.nowLocalTime = self.nowLocalTime+1000
    }
    fileprivate func stopTimer()  {
        if timer != nil {
            timer.invalidate()
            timer = nil
            self.nowLocalTime = 0
        }
    }
}
extension FKYPreferentialShopsViewController : FKYNavigationControllerDragBackDelegate {
    func draBackEnd(in navigationController: FKYNavigationController!) {
        if let _ = navigationController.viewControllers.last as? FKYPreferentialShopsViewController {
            self.stopTimer()
        }
    }
}
