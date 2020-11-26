//
//  FKYShopAllListViewController.swift
//  FKY
//
//  Created by yyc on 2020/10/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
// 全部店铺

import UIKit

class FKYShopAllListViewController: UIViewController {
    
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
        tableView.tableHeaderView?.hd_height = WH(10)
        tableView.register(FKYShopAttListCell.self, forCellReuseIdentifier: "FKYShopAttListCell")
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
    
    fileprivate var navBar: UIView?
    
    //viewModel
    fileprivate var viewModel: FKYShopAttViewModel = {
        let vm = FKYShopAttViewModel()
        return vm
    }()
    
    fileprivate var indexPathNum:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.refreshTable()
        //监控登录状态的改变
        NotificationCenter.default.addObserver(self, selector: #selector(FKYShopAllListViewController.loginStatuChanged(_:)), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FKYShopAllListViewController.loginStatuChanged(_:)), name: NSNotification.Name.FKYLogoutComplete, object: nil)
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK:UI相关
extension FKYShopAllListViewController {
    fileprivate func setupView(){
        self.navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            }else{
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
        }()
        self.fky_setupTitleLabel("全部店铺")
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            // 返回
            if let _ = self {
                FKYNavigator.shared().pop()
            }
        }
        view.addSubview(shopTableView)
        shopTableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(self.navBar!.snp_bottom)
        }
    }
}
//MARK:
extension FKYShopAllListViewController {
    
}
// MARK:UITableViewDelegate UITableViewDataSource
extension FKYShopAllListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.allShopList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK:店铺cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "FKYShopAttListCell", for: indexPath) as! FKYShopAttListCell
        let shopModel = self.viewModel.allShopList[indexPath.row]
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
                strongSelf.addAllShopListCommonBIWithView(2,indexNum+1,shopModel,prdModel)
            }
        }
        return cell
    }
}
extension FKYShopAllListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let shopModel = self.viewModel.allShopList[indexPath.row]
        return FKYShopAttListCell.getShopPromotionNewTableViewHeight(shopModel)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shopModel = self.viewModel.allShopList[indexPath.row]
        if let shopId = shopModel.shopId {
            FKYNavigator.shared().openScheme(FKY_ShopItem.self) { (vc) in
                let v = vc as! FKYNewShopItemViewController
                v.shopId = "\(shopId)"
                if let type = shopModel.type ,type == 1 {
                    v.shopType = "1"
                }
            }
            self.addAllShopListCommonBIWithView(1,nil,shopModel,nil)
        }
    }
}
//MARK:网络请求
extension FKYShopAllListViewController{
    /// 下拉刷新
    @objc func refreshTable(){
        self.viewModel.hasNextPage = true
        self.viewModel.offset = 0
        self.shopTableView.mj_footer.endRefreshing()
        self.getAllShopArr()
    }
    // 上拉加载
    @objc func loadMore(){
        if self.viewModel.hasNextPage == false{
            self.dismissLoading()
            return
        }
        self.getAllShopArr()
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
    fileprivate func getAllShopArr(){
        showLoading()
        viewModel.getAllShopList(){ [weak self] (success, msg) in
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
                return
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
                strongSelf.addAllShopListCommonBIWithView(3,nil,shopModel,nil)
            }else{
                strongSelf.toast("关注成功")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addFav"), object: shopModel.shopId, userInfo: nil)
                strongSelf.addAllShopListCommonBIWithView(4,nil,shopModel,nil)
            }
            shopModel.follow = shopModel.follow == "0" ? "1":"0"
            strongSelf.shopTableView.reloadData()
        })
    }
}

//MARK:埋点相关
extension FKYShopAllListViewController {
    fileprivate func addAllShopListCommonBIWithView(_ type:Int,_ indexNum:Int?,_ shopModel:FKYShopListModel,_ prdModel : FKYSpecialPriceModel?) {
        var itemId:String?
        var itemName:String?
        var itemPosition :String?
        let itemTitle = shopModel.shopName
        var itemContent :String?
        var extendParams : [String :AnyObject]?
        var sectionPosition : String?
        if let indexPath = self.indexPathNum {
            sectionPosition = "\(indexPath.row+1)"
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
                extendParams = ["pm_price" :pModel.pm_price! as AnyObject,"pm_pmtn_type" : pModel.pm_pmtn_type! as AnyObject]
            }
        }else if type == 3 {
            //取消关注
            itemId = "I4302"
            itemName = "取消关注"
        }else if type == 4 {
            //关注店铺
            itemId = "I4303"
            itemName = "关注店铺"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition:nil, floorName: "全部店铺", sectionId: nil, sectionPosition: sectionPosition, sectionName: nil, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: itemContent, itemTitle: itemTitle, extendParams: extendParams, viewController: self)
    }
}
