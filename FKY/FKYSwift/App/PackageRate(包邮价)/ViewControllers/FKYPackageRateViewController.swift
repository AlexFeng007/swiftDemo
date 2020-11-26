//
//  FKYPackageRateViewController.swift
//  FKY
//
//  Created by yyc on 2020/7/28.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYPackageRateViewController: UIViewController {
    
    fileprivate var navBar : UIView?
    fileprivate var selectIndexPath: IndexPath = IndexPath.init(row: 0, section: 0) //选中cell 位置
    fileprivate var dataArr = [FKYPackageRateModel]()
    
    fileprivate var timer: Timer!
    fileprivate var nowLocalTime : Int64 = 0 //记录当前系统时间
    @objc var selfTag : Bool = true //当前搜索的店铺是不是自营
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
        tableView.register(FKYComPreKillCell.self, forCellReuseIdentifier: "FKYComPreKillCell_package")
        tableView.register(HomeOneAdPageCell.self, forCellReuseIdentifier: "HomePreOneAdPageCell_package")
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
        addView.immediatelyOrderAddCarSuccess = {[weak self] (isSuccess ,productNum, productModel) in
            if let strongSelf = self {
                strongSelf.goOrderCheckViewController()
                if let model = productModel as? FKYPackageRateModel {
                    strongSelf.add_NEW_BI(3, model, nil)
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
    
    //搜索框<搜索结果页面需要>
    fileprivate lazy var searchbar: FSearchBar = { [weak self] in
        let searchbar = FSearchBar()
        searchbar.initCommonSearchItem()
        searchbar.delegate = self
        searchbar.placeholder = "请输入商品"
        searchbar.text = self?.keyWordStr ?? ""
        return searchbar
    }()
    
    //请求工具类
    fileprivate lazy var packageService : FKYPackageRateService = {
        let serviece = FKYPackageRateService()
        return serviece
    }()
    
    //传入数据
    var spuCode:String? // 商品编码
    var sellCode:String? //卖家id
    var vcTitle:String? //
    @objc var typeIndex = 0 // 1:搜索界面（默认列表界面）
    @objc var keyWordStr : String? //搜索关键词
    override func viewDidLoad() {
        super.viewDidLoad()
        packageService.isSelfTag = self.selfTag
        self.setupView()
        self.getPreferetialProductList(true)
        // 登录成功后刷新界面数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataWithLoginSuccess), name: NSNotification.Name.FKYLoginSuccess, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //删除存储高度
        cellHeightManager.removeAllContentCellHeight()
//        if self.typeIndex == 1 {
//            UIApplication.shared.statusBarStyle = .lightContent
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if self.typeIndex == 1 {
//            UIApplication.shared.statusBarStyle = .default
//            if #available(iOS 13.0, *) {
//                UIApplication.shared.statusBarStyle = .darkContent
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("内存不足")
    }
    deinit {
        print("FKYPackageRateViewController deinit>>>>>>>")
        self.stopTimer()
        NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK:ui相关
extension FKYPackageRateViewController {
    //初始化包邮价列表页面导航栏
    fileprivate func setPackageListView(){
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
                strongSelf.add_NEW_BI(0, nil,nil)
            }
        }
        self.fky_setupRightImage(HomeString.SEARCH_BAR_SEARCH_ICON_IMGNAME) {[weak self] in
            // 搜索包邮商品
            if let strongSelf = self {
                FKYNavigator.shared().openScheme(FKY_Search.self, setProperty: { (svc) in
                    let searchVC = svc as! FKYSearchViewController
                    searchVC.vcSourceType = .pilot
                    searchVC.searchType = .packageRate
                    searchVC.searchFromType = .fromCommon
                }, isModal: false, animated: true)
                strongSelf.add_NEW_BI(1, nil, nil)
            }
        }
        //调整左右按钮
        self.NavigationBarLeftImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationTitleLabel!.snp.centerY)
            make.left.equalTo(self.navBar!.snp.left).offset(WH(9))
            make.width.height.equalTo(WH(30))
        })
        self.NavigationBarRightImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationTitleLabel!.snp.centerY)
            make.right.equalTo(self.navBar!.snp.right).offset(-WH(12))
            make.height.width.equalTo(WH(30))
        })
    }
    //初始化包邮价搜索结果页面导航栏
    fileprivate func setPackageSearchListView(){
        navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            }else{
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
        }()
        fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            if let strongSelf = self {
                strongSelf.stopTimer()
                FKYNavigator.shared().pop()
            }
        }
        fky_setupTitleLabel("")
        
        self.NavigationBarLeftImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationTitleLabel!.snp.centerY)
            make.left.equalTo(self.navBar!.snp.left).offset(WH(12))
            make.height.width.equalTo(WH(30))
        })
        self.navBar?.addSubview(self.searchbar)
        self.searchbar.snp.makeConstraints({[weak self] (make) in
            if let strongSelf = self {
                make.centerX.equalTo(strongSelf.navBar!)
                make.bottom.equalTo(strongSelf.navBar!.snp.bottom).offset(WH(-8))
                make.left.equalTo(strongSelf.navBar!.snp.left).offset(WH(43))
                make.right.equalTo(strongSelf.navBar!.snp.right).offset(-WH(43))
                make.height.equalTo(WH(32))
            }
        })
        self.navBar?.backgroundColor = bg1//UIColor.gradientLeft(toRightColor: RGBColor(0xFF5A9B), to: RGBColor(0xFF2D5C), withWidth: Float(SCREEN_WIDTH))
    }
    fileprivate func setupView() {
        //导航栏
        if self.typeIndex == 0 {
            //列表
            self.setPackageListView()
        }else {
            //搜索
            self.setPackageSearchListView()
        }
        self.view.backgroundColor = RGBColor(0xF4F4F4)
        FKYNavigator.shared().topNavigationController.dragBackDelegate = self
        self.navBar?.layoutIfNeeded()
        //内容视图
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
extension FKYPackageRateViewController{
    @objc func reloadDataWithLoginSuccess() {
        self.getPreferetialProductList(true)
    }
    fileprivate func getPreferetialProductList(_ isFresh:Bool) {
        if isFresh == true {
            self.showLoading()
            self.mjfooter.resetNoMoreData()
        }
        self.packageService.getSinglePackageRateWithProductList(self.keyWordStr,isFresh) {[weak self] (hasMoreData,dataArr, tip) in
            guard let strongSelf = self else{
                return
            }
            if isFresh == true {
                strongSelf.dismissLoading()
                strongSelf.mjheader.endRefreshing()
                //删除存储高度
                strongSelf.cellHeightManager.removeAllContentCellHeight()
                if strongSelf.typeIndex == 0 {
                    strongSelf.fky_setupTitleLabel(strongSelf.packageService.packageTitle ?? "单品包邮")
                }
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
                    if strongSelf.typeIndex == 0 {
                        strongSelf.NavigationBarRightImage?.isHidden = true
                    }
                }else {
                    strongSelf.emptyView.isHidden = true
                    if strongSelf.typeIndex == 0 {
                        strongSelf.NavigationBarRightImage?.isHidden = false
                    }
                }
            }
        }
    }
}
//MARK:加车相关的处理
extension FKYPackageRateViewController {
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        //let sourceType = HomeString.SHOPITEM_ALL_ADD_SOURCE_TYPE
        self.addCarView.addBtnType = 2
        self.addCarView.configAddCarViewController(productModel,nil)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
    //检查订单页
    fileprivate func goOrderCheckViewController() {
        self.addCarView.removeMySelf()
        FKYNavigator.shared().openScheme(FKY_CheckOrder.self, setProperty: {(svc) in
            let controller = svc as! CheckOrderController
            controller.fromWhere = 5 // 购物车
        }, isModal: false, animated: true)
    }
}
extension FKYPackageRateViewController: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomePreOneAdPageCell_package", for: indexPath) as!  HomeOneAdPageCell
            if let urlStr = self.packageService.imgUrl ,urlStr.count > 0 {
                cell.configPreferentialShopAdView(urlStr)
            }
            return cell
        }else {
            let model =  self.dataArr[indexPath.row-1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "FKYComPreKillCell_package", for: indexPath) as! FKYComPreKillCell
            cell.selectionStyle = .none
            cell.configPackageCell(model, nowLocalTime: self.nowLocalTime,self.packageService.isCheck,selfTag)
            //更新加车数量
            cell.addUpdateProductNum = { [weak self] in
                if let strongSelf = self {
                    strongSelf.selectIndexPath = indexPath
                    strongSelf.popAddCarView(model)
                    strongSelf.add_NEW_BI(2, model, indexPath.row)
                }
            }
            //登录
            cell.loginClosure = {
                FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
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
            if self.typeIndex == 1 {
                return WH(0)
            }else {
                if let str = self.packageService.imgUrl ,str.count > 0 {
                    //有返回广告图片地址
                    return WH(97)
                }
                return WH(0)
            }
        }else {
            let model =  self.dataArr[indexPath.row-1]
            let cellHeight = cellHeightManager.getContentCellHeight((model.spuCode ?? ""),"\(model.enterpriseId ?? 0)",self.ViewControllerPageCode() ?? "")
            
            if  cellHeight == 0{
                let conutCellHeight = FKYComPreKillCell.getCellContentHeight(model,self.nowLocalTime)
                cellHeightManager.addContentCellHeight((model.spuCode ?? ""),"\(model.enterpriseId ?? 0)",self.ViewControllerPageCode()!, conutCellHeight)
                return conutCellHeight
            }else{
                return cellHeight
            }
        }
    }
}
//MARK:bi埋点相关
extension FKYPackageRateViewController{
    func add_NEW_BI(_ biType:Int,_ prdModel:FKYPackageRateModel?,_ index:Int?){
        var sectionId:String?//
        var sectionName:String? //
        var sectionPosition:String? //
        var itemId:String? //
        var itemName:String? //
        var itemPosition:String? //
        var itemContent:String? //
        var extendParams = [String:String]()//
        if biType == 0 {
            sectionId = "S7801"
            sectionName = "单品包邮头部"
            sectionPosition = "0"
            itemId = "I7810"
            itemName = "返回"
            itemPosition = "1"
        }else if biType == 1 {
            sectionId = "S7801"
            sectionName = "单品包邮头部"
            sectionPosition = "0"
            itemId = "I7810"
            itemName = "搜索"
            itemPosition = "2"
        }else if biType == 2 {
            if self.typeIndex == 0 {
                //单品包邮列表加车
                sectionId = "S7802"
                sectionName = "单品包邮活动商品列表页"
                if let prd = prdModel {
                    itemContent = "\(prd.enterpriseId ?? 0)|\(prd.spuCode ?? "")"
                    extendParams = ["storage":prd.storage ?? "","pm_price":prd.pm_price ?? ""];
                }
            }else {
                //单品包邮搜索结果列表加车
                sectionId = "S7805"
                sectionName = "商品搜索结果列表"
                if let prd = prdModel {
                    itemContent = "\(prd.enterpriseId ?? 0)|\(prd.spuCode ?? "")"
                    extendParams = ["storage":prd.storage ?? "","pm_price":prd.pm_price ?? "","keyword":self.keyWordStr ?? ""];
                }
            }
            sectionPosition = "0"
            itemId = ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue
            itemName = "加车（马上抢）"
            itemPosition = "\(index ?? 0)"
            
        }else if biType == 3 {
            if self.typeIndex == 0 {
                //单品包邮列表立即购买
                sectionId = "S7802"
                sectionName = "单品包邮活动商品列表页"
                if let prd = prdModel {
                    itemContent = "\(prd.enterpriseId ?? 0)|\(prd.spuCode ?? "")"
                    extendParams = ["storage":prd.storage ?? "","pm_price":prd.pm_price ?? ""];
                }
            }else {
                //单品包邮搜索结果列表立即购买
                sectionId = "S7805"
                sectionName = "商品搜索结果列表"
                if let prd = prdModel {
                    itemContent = "\(prd.enterpriseId ?? 0)|\(prd.spuCode ?? "")"
                    extendParams = ["storage":prd.storage ?? "","pm_price":prd.pm_price ?? "","keyword":self.keyWordStr ?? ""];
                }
            }
            sectionPosition = "0"
            itemId = "I5000"
            itemName = "立即下单"
            itemPosition = "0"
            
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: sectionId, sectionPosition: sectionPosition, sectionName: sectionName, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: itemContent, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: self)
    }
}

extension FKYPackageRateViewController {
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
extension FKYPackageRateViewController : FKYNavigationControllerDragBackDelegate {
    func draBackEnd(in navigationController: FKYNavigationController!) {
        if let _ = navigationController.viewControllers.last as? FKYPreferentialShopsViewController {
            self.stopTimer()
        }
    }
}
// MARK: - FSearchBarDelegate
extension FKYPackageRateViewController : FSearchBarProtocol {
    func fsearchBar(_ searchBar: FSearchBar, search: String?) {
    }
    func fsearchBar(_ searchBar: FSearchBar, textDidChange: String?) {
    }
    func fsearchBar(_ searchBar: FSearchBar, touches: String?) {
        FKYNavigator.shared().openScheme(FKY_Search.self, setProperty: { (svc) in
            let searchVC = svc as! FKYSearchViewController
            searchVC.vcSourceType = .pilot
            searchVC.searchType = .packageRate
            searchVC.searchFromType = .fromCommon
        }, isModal: false, animated: true)
    }
}
