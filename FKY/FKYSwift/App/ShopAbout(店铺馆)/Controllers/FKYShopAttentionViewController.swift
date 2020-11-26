//
//  FKYShopAttentionViewController.swift
//  FKY
//
//  Created by yyc on 2020/10/14.
//  Copyright © 2020 yiyaowang. All rights reserved.
//关注店铺

import UIKit

class FKYShopAttentionViewController: UIViewController {
    
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
    fileprivate lazy var shopTableView: UITableView = { [weak self] in
        var tableView = UITableView(frame: CGRect.null, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = bg2
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(FKYShopAttFunsTableViewCell.self, forCellReuseIdentifier: "FKYShopAttFunsTableViewCell")
        tableView.register(FKYShopAttSecHedCell.self, forCellReuseIdentifier: "FKYShopAttSecHedCell")
        tableView.register(FKYShopAttListCell.self, forCellReuseIdentifier: "FKYShopAttListCell")
        tableView.register(FKYShopFlageTitleCell.self, forCellReuseIdentifier: "FKYShopFlageTitleCell")
        tableView.register(FKYShopNoAttCell.self, forCellReuseIdentifier: "FKYShopNoAttCell")
        
        
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
    
    //空视图
    fileprivate var emptyView: FKYShopEmptyView = {
        let view = FKYShopEmptyView()
        view.isHidden = true
        return view
    }()
    
    //viewModel
    fileprivate var viewModel: FKYShopAttViewModel = {
        let vm = FKYShopAttViewModel()
        return vm
    }()
    
    fileprivate lazy var gropQueue:DispatchGroup = {
        let grop:DispatchGroup = DispatchGroup.init()
        return grop
    }()
    
    
    fileprivate var indexPathNum:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.refreshTable()
        //监控登录状态的改变
        NotificationCenter.default.addObserver(self, selector: #selector(FKYShopAttentionViewController.loginStatuChanged(_:)), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FKYShopAttentionViewController.loginStatuChanged(_:)), name: NSNotification.Name.FKYLogoutComplete, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
//MARK:UI相关
extension FKYShopAttentionViewController {
    fileprivate func setupView(){
        view.addSubview(shopTableView)
        shopTableView.snp.makeConstraints { (make) in
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
//MARK:
extension FKYShopAttentionViewController {
    
}
// MARK:UITableViewDelegate UITableViewDataSource
extension FKYShopAttentionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1+self.viewModel.shopList.count
        }else {
            if self.viewModel.ultimateShops.count > 0 {
                return 1+self.viewModel.ultimateShops.count
            }else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            //MARK:旗舰店铺
            let cell = tableView.dequeueReusableCell(withIdentifier: "FKYShopAttFunsTableViewCell", for: indexPath) as! FKYShopAttFunsTableViewCell
            cell.configCell(self.viewModel.flagShipShopArr)
            cell.clickNavItemBlock = {[weak self] (typeIndex,shopModel) in
                if let strongSelf = self {
                    FKYNavigator.shared().openScheme(FKY_ShopItem.self) { (vc) in
                        let v = vc as! FKYNewShopItemViewController
                        v.shopId = "\(shopModel.enterpriseId ?? 0)"
                        if let type = shopModel.type ,type == 1 {
                            v.shopType = "1"
                        }
                    }
                    strongSelf.addAttensionShopIconCommonBIWithView(1, typeIndex+1)
                }
            }
            return cell
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                //MARK:标题
                let cell = tableView.dequeueReusableCell(withIdentifier: "FKYShopAttSecHedCell", for: indexPath) as! FKYShopAttSecHedCell
                cell.configSectionHeadView()
                cell.clickViewBlock = { [weak self] type in
                    if let strongSelf = self  {
                        FKYNavigator.shared().openScheme(FKY_ShopAllList.self) { (vc) in
                        }
                        strongSelf.addAttensionShopIconCommonBIWithView(2, nil)
                    }
                }
                return cell
            }else {
                //MARK:店铺cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "FKYShopAttListCell", for: indexPath) as! FKYShopAttListCell
                let shopModel = self.viewModel.shopList[indexPath.row-1]
                cell.configCellData(shopModel)
                cell.clickViewBock = { [weak self] typeIndex in
                    if let strongSelf = self {
                        strongSelf.indexPathNum = indexPath
                        if typeIndex == 1 {
                            shopModel.showTypeName = !shopModel.showTypeName
                            strongSelf.shopTableView.reloadRows(at: [indexPath], with: .none)
                        }else if typeIndex == 2 || typeIndex == 3 {
                            //收藏按钮
                            if FKYLoginAPI.loginStatus() != .unlogin {
                                strongSelf.addOrCancellShopCollectionInfo((typeIndex == 2 ? true:false) ,shopModel)
                            }else {
                                FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
                            }
                        }
                    }
                }
                cell.clickProductView = { [weak self] (indexNum,prdModel) in
                    if let strongSelf = self  {
                        strongSelf.indexPathNum = indexPath
                        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                            let v = vc as! FKYProductionDetailViewController
                            v.productionId = prdModel.spuCode
                            v.vendorId = "\(shopModel.shopId ?? 0)"
                        }, isModal: false)
                        strongSelf.addAttensionShopListCommonBIWithView(2, indexNum+1, shopModel, prdModel)
                    }
                }
                return cell
            }
        }else if indexPath.section == 2 {
            //MARK:以下为旗舰店铺
            if indexPath.row == 0 {
                if self.viewModel.shopList.count > 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FKYShopFlageTitleCell", for: indexPath) as! FKYShopFlageTitleCell
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FKYShopNoAttCell", for: indexPath) as! FKYShopNoAttCell
                    return cell
                }
            }else{
                //MARK:店铺cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "FKYShopAttListCell", for: indexPath) as! FKYShopAttListCell
                let shopModel = self.viewModel.ultimateShops[indexPath.row-1]
                cell.configCellData(shopModel)
                cell.clickViewBock = { [weak self] typeIndex in
                    if let strongSelf = self {
                        strongSelf.indexPathNum = indexPath
                        if typeIndex == 1 {
                            shopModel.showTypeName = !shopModel.showTypeName
                            strongSelf.shopTableView.reloadRows(at: [indexPath], with: .none)
                        }else if typeIndex == 2 || typeIndex == 3 {
                            //收藏按钮
                            if FKYLoginAPI.loginStatus() != .unlogin {
                                strongSelf.addOrCancellShopCollectionInfo((typeIndex == 2 ? true:false) ,shopModel)
                            }else {
                                FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
                            }
                        }
                    }
                }
                cell.clickProductView = { [weak self] (indexNum,prdModel) in
                    if let strongSelf = self  {
                        strongSelf.indexPathNum = indexPath
                        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                            let v = vc as! FKYProductionDetailViewController
                            v.productionId = prdModel.spuCode
                            v.vendorId = "\(shopModel.shopId ?? 0)"
                        }, isModal: false)
                        strongSelf.addAttensionShopListCommonBIWithView(2, indexNum+1, shopModel, prdModel)
                    }
                }
                return cell
            }
        }
        return  UITableViewCell.init()
    }
}
extension FKYShopAttentionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0  {
            //MARK:旗舰店铺
            if self.viewModel.flagShipShopArr.count > 0 {
                return FKYShopAttFunsTableViewCell.getCellContentHeight(self.viewModel.flagShipShopArr)
            }else{
                return WH(0)
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return WH(51)
            }else {
                let shopModel = self.viewModel.shopList[indexPath.row-1]
                return FKYShopAttListCell.getShopPromotionNewTableViewHeight(shopModel)
            }
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                if self.viewModel.shopList.count > 0 {
                    return WH(24)
                }else {
                    return  WH(46)
                }
            }else {
                let shopModel = self.viewModel.ultimateShops[indexPath.row-1]
                return FKYShopAttListCell.getShopPromotionNewTableViewHeight(shopModel)
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1 || indexPath.section == 2 ) && indexPath.row > 0 {
            var getModel:FKYShopListModel?
            if indexPath.section == 1 {
                getModel = self.viewModel.shopList[indexPath.row-1]
            }else if indexPath.section == 2 {
                getModel = self.viewModel.ultimateShops[indexPath.row-1]
            }
            if let shopModel = getModel , let shopId = shopModel.shopId {
                FKYNavigator.shared().openScheme(FKY_ShopItem.self) { (vc) in
                    let v = vc as! FKYNewShopItemViewController
                    v.shopId = "\(shopId)"
                    if let type = shopModel.type ,type == 1 {
                        v.shopType = "1"
                    }
                }
                self.addAttensionShopListCommonBIWithView(1, nil, shopModel, nil)
            }
        }
    }
}
//MARK:网络请求
extension FKYShopAttentionViewController{
    /// 下拉刷新
    @objc func refreshTable(){
        self.viewModel.hasNextPage = true
        self.viewModel.currentPage = 1
        self.shopTableView.mj_footer.endRefreshing()
        
        self.gropQueue.enter()
        self.getAllFlagShipArr()
        self.gropQueue.enter()
        self.getMainShopArr(true)
        self.gropQueue.notify(queue: DispatchQueue.main) { [weak self] in
            if let strongSelf = self {
                let arrCount = strongSelf.viewModel.shopList.count + strongSelf.viewModel.ultimateShops.count + strongSelf.viewModel.allShopList.count
                if arrCount == 0 {
                    strongSelf.emptyView.isHidden = false
                }else {
                    strongSelf.emptyView.isHidden = true
                }
            }
        }
    }
    // 上拉加载
    @objc func loadMore(){
        if self.viewModel.hasNextPage == false{
            self.dismissLoading()
            return
        }
        self.getMainShopArr(false)
    }
    @objc fileprivate func loginStatuChanged(_ nty: Notification) {
        self.refreshTable()
    }
    
    fileprivate func refreshDismiss() {
        self.dismissLoading()
        if self.shopTableView.mj_header.isRefreshing() {
            self.shopTableView.mj_header.endRefreshing()
            self.shopTableView.mj_footer.resetNoMoreData()
        }
        if  self.viewModel.hasNextPage {
            self.shopTableView.mj_footer.endRefreshing()
        }else{
            self.shopTableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    //MARK:请求数据
    fileprivate func getMainShopArr(_ isFresh:Bool){
        showLoading()
        viewModel.getMainShopList(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.shopTableView.reloadData()
            strongSelf.refreshDismiss()
            if success{
                
            } else {
                // 失败
                strongSelf.toast(msg ?? "请求失败")
            }
            if isFresh == true {
                strongSelf.gropQueue.leave()
            }
        }
    }
    //MARK:收藏or取消店铺接口
    func addOrCancellShopCollectionInfo(_ hasCollect:Bool ,_ shopModel:FKYShopListModel){
        FKYRequestService.sharedInstance()?.requestForGetShopAddOrCancellCollection(withParam: ["type":hasCollect ? "cancel":"add","enterpriseId":shopModel.shopId ?? ""], completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                strongSelf.toast(msg)
                return
            }
            if(hasCollect){
                strongSelf.toast("取消关注成功")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cancelFav"), object: shopModel.shopId, userInfo: nil)
                strongSelf.addAttensionShopListCommonBIWithView(3, nil, shopModel, nil)
            }else{
                strongSelf.toast("关注成功")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addFav"), object: shopModel.shopId, userInfo: nil)
                strongSelf.addAttensionShopListCommonBIWithView(4, nil, shopModel, nil)
            }
            shopModel.follow = shopModel.follow == "0" ? "1":"0"
            strongSelf.shopTableView.reloadData()
        })
    }
    //MARK:获取旗舰店列表
    fileprivate func getAllFlagShipArr(){
        viewModel.getFlagShipShopList(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.shopTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            if success{
                
            } else {
                // 失败
                strongSelf.toast(msg ?? "请求失败")
            }
            strongSelf.gropQueue.leave()
        }
    }
}

//MARK:埋点相关
extension FKYShopAttentionViewController {
    //MARK:补充旗舰店铺
    fileprivate func addAttensionShopListCommonBIWithView(_ type:Int,_ indexNum:Int?,_ shopModel:FKYShopListModel,_ prdModel : FKYSpecialPriceModel?) {
        var itemId:String?
        var itemName:String?
        var itemPosition :String?
        let itemTitle = shopModel.shopName
        var itemContent :String?
        var extendParams : [String :AnyObject]?
        var sectionPosition : String?
        var sectionName:String?
        
        if let indexPath = self.indexPathNum {
            sectionPosition = "\(indexPath.row)"
            if indexPath.section == 1 {
                sectionName = "关注店铺"
            }else if indexPath.section == 2 {
                sectionName = "补充旗舰店铺"
            }
        }
        if type == 1 {
            //进入店铺首页
            itemId = "I4301"
            itemName = "进入店铺首页"
            itemPosition = "0"
            itemContent = "\(shopModel.shopId ?? 0)"
        }else if type == 2 {
            //点击商品详情
            itemId = "I4301"
            itemName = "点进商详"
            itemPosition = "\(indexNum ?? 0)"
            if let pModel = prdModel {
                itemContent = "\(shopModel.shopId ?? 0)|\(pModel.spuCode ?? "0")"
                extendParams = ["pm_price" :pModel.pm_price! as AnyObject,"pm_pmtn_type" : pModel.pm_pmtn_type! as AnyObject]
            }
        }else if type == 3 {
            //取消关注
            itemId = "I4302"
            itemName = "取消关注"
            itemContent = "\(shopModel.shopId ?? 0)"
        }else if type == 4 {
            //关注店铺
            itemId = "I4303"
            itemName = "关注店铺"
            itemContent = "\(shopModel.shopId ?? 0)"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition:nil, floorName: "关注店铺", sectionId: nil, sectionPosition: sectionPosition, sectionName:sectionName , itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: itemContent, itemTitle: itemTitle, extendParams: extendParams, viewController: self)
    }
    
    fileprivate func addAttensionShopIconCommonBIWithView(_ type:Int,_ indexNum:Int?){
        var itemId:String?
        var itemName:String?
        var itemPosition :String?
        var sectionName:String?
        var sectionPosition : String?
        if type == 1 {
            itemId = "I4300"
            itemName = "点进旗舰店铺"
            sectionName = "旗舰店铺"
            itemPosition = "\(indexNum ?? 0)"
            sectionPosition = "\(indexNum ?? 0)"
        }else if type == 2 {
            sectionName = "全部店铺"
            itemName = "进入全部店铺"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition:nil, floorName: "关注店铺", sectionId: nil, sectionPosition: sectionPosition, sectionName:sectionName , itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    }
}
