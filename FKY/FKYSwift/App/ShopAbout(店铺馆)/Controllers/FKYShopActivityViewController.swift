//
//  FKYShopActivityViewController.swift
//  FKY
//
//  Created by yyc on 2020/10/14.
//  Copyright © 2020 yiyaowang. All rights reserved.
//发现活动

import UIKit

class FKYShopActivityViewController: UIViewController {
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
    public lazy var tableView: UITableView = { [weak self] in
        var tableView = UITableView(frame: CGRect.null, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = bg2
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = WH(200)
        
        tableView.register(FKYShopFunsTableViewCell.self, forCellReuseIdentifier: "FKYShopFunsTableViewCell")
        tableView.register(FKYShopNoticeCell.self, forCellReuseIdentifier: "FKYShopNoticeCell")
        tableView.register(HomeOneAdPageCell.self, forCellReuseIdentifier: "FKYShopOneAdPageCell")
        tableView.register(HomeTwoAdPageCell.self, forCellReuseIdentifier: "FKYShopTwoAdPageCell")
        tableView.register(HomeThreeAdPageCell.self, forCellReuseIdentifier: "FKYShopThreeAdPageCell")
        tableView.register(HomePromotionNewTableViewCell.self, forCellReuseIdentifier: "HomePromotionNewTableViewCell")
        tableView.register(FKYShopQualityCell.self, forCellReuseIdentifier: "FKYShopQualityCell")
        
        tableView.mj_header = self?.mjheader
        tableView.mj_footer = self?.mjfooter
        if #available(iOS 11, *) {
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
    
    //请求工具类
    fileprivate var viewModel: FKYShopHomeViewModel = {
        let vm = FKYShopHomeViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.refreshTable()
        //监控登录状态的改变
        NotificationCenter.default.addObserver(self, selector: #selector(FKYShopActivityViewController.loginStatuChanged(_:)), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FKYShopActivityViewController.loginStatuChanged(_:)), name: NSNotification.Name.FKYLogoutComplete, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
//MARK:UI相关
extension FKYShopActivityViewController {
    fileprivate func setupView(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
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
    //重新设置tableview的内边距
    fileprivate func resetTableview(){
        if self.viewModel.hasNavigationBtn == true {
            tableView.tableHeaderView?.mj_h = WH(0)
        }else{
            tableView.tableHeaderView?.mj_h = WH(10)
        }
    }
}
//MARK:
extension FKYShopActivityViewController {
    
}
//MARK:跳转相关
extension FKYShopActivityViewController {
    //MARK:统一跳转fky链接<1:优质商家 2:导航按钮 3:通知点击>
    func clickCommonFkyUrl(_ selectedIndex:Int ,_ urlStr:String?,_ type:Int, _ indexPath: IndexPath) {
        if let app = UIApplication.shared.delegate as? AppDelegate {
            if let url = urlStr, url.isEmpty == false {
                app.p_openPriveteSchemeString(url)
            }
        }
    }
    //MARK:点击中通广告
    fileprivate func dealAdInfoViewAction(_ adType:Int, _ infoAdModel:HomeADInfoModel, _ selectIndex:Int, _ index : IndexPath){
        if let imgModelArr = infoAdModel.iconImgDTOList, selectIndex < imgModelArr.count {
            let picModel = imgModelArr[selectIndex]
            if let app = UIApplication.shared.delegate as? AppDelegate {
                if let url = picModel.jumpInfo, url.isEmpty == false {
                    app.p_openPriveteSchemeString(url)
                }
            }
        }
    }
    //MARK:点击2*3视图商品
    fileprivate func clickPromotionNewViewProduct(_ index:Int , _ product:HomeRecommendProductItemModel, _ itemModel:HomeSecdKillProductModel?){
        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
            let v = vc as! FKYProductionDetailViewController
            v.productionId = product.productCode
            v.vendorId = "\(product.supplyId ?? 0)"
        }, isModal: false)
    }
    //MARK:点击药城精选(2*3)头部
    fileprivate func clickPromotionViewHeader(_ itemModel:HomeSecdKillProductModel?){
        if let app = UIApplication.shared.delegate as? AppDelegate , let model = itemModel {
            app.p_openPriveteSchemeString(model.jumpInfoMore)
        }
    }
}
// MARK:UITableViewDelegate UITableViewDataSource
extension FKYShopActivityViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.shopActivityArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let arr = self.viewModel.shopActivityArr[indexPath.row] as? [HomeFucButtonItemModel] ,arr.count>0 {
            //MARK:导航按钮
            let cell = tableView.dequeueReusableCell(withIdentifier: "FKYShopFunsTableViewCell", for: indexPath) as! FKYShopFunsTableViewCell
            cell.configCell(arr)
            cell.clickItem = {[weak self] (selectedIndex,itemModel) in
                if let strongSelf = self {
                    strongSelf.clickCommonFkyUrl(selectedIndex,itemModel.jumpInfo, 2, indexPath)
                    var index = itemModel.indexNum
                    if arr.count < 10 {
                        index = selectedIndex
                    }
                    strongSelf.addShopActivityCommonBIWithView(1, index+1, itemModel.title, nil,nil)
                }
            }
            return cell
        }else if let arr = self.viewModel.shopActivityArr[indexPath.row] as? [HomePublicNoticeItemModel],arr.count>0{
            //MARK:通知
            let cell = tableView.dequeueReusableCell(withIdentifier: "FKYShopNoticeCell", for: indexPath) as! FKYShopNoticeCell
            cell.clickNoticViewBlock = { [weak self] (selectedIndex,itemModel) in
                if let strongSelf = self {
                    strongSelf.clickCommonFkyUrl(selectedIndex,itemModel.jumpInfo, 3, indexPath)
                    strongSelf.addShopActivityCommonBIWithView(2, selectedIndex+1, nil, nil,nil)
                }
            }
            cell.configCell(arr)
            return cell
        }else if let adModel = self.viewModel.shopActivityArr[indexPath.row] as? HomeADInfoModel , let typeIndex = adModel.floorStyle{
            if typeIndex == 1 {
                //MARK:1栏广告
                let cell = tableView.dequeueReusableCell(withIdentifier: "FKYShopOneAdPageCell", for: indexPath) as!  HomeOneAdPageCell
                cell.backgroundColor = RGBColor(0xf4f4f4)
                cell.configCell(adModel)
                cell.checkAdBlock = { [weak self](typeIndex) in
                    if let strongSelf = self {
                        strongSelf.dealAdInfoViewAction(1, adModel, typeIndex, indexPath)
                        if let arr = adModel.iconImgDTOList,arr.count > 0 {
                            let picModel = arr[0]
                            strongSelf.addShopActivityCommonBIWithView(3, 1, picModel.imgName, "\(indexPath.row+1)",nil)
                        }
                    }
                }
                return cell
            }else if typeIndex == 2 {
                //MARK:2栏广告
                let cell = tableView.dequeueReusableCell(withIdentifier: "FKYShopTwoAdPageCell", for: indexPath) as!  HomeTwoAdPageCell
                cell.backgroundColor = RGBColor(0xf4f4f4)
                cell.configCell(adModel)
                cell.checkAdBlock = { [weak self] (typeIndex) in
                    if let strongSelf = self {
                        strongSelf.dealAdInfoViewAction(2, adModel, typeIndex, indexPath)
                        if let arr = adModel.iconImgDTOList,arr.count > 0 {
                            let picModel = arr[typeIndex]
                            strongSelf.addShopActivityCommonBIWithView(3, typeIndex+1, picModel.imgName, "\(indexPath.row+1)",nil)
                        }
                    }
                }
                return cell
            }else if typeIndex == 3{
                //MARK:3栏广告
                let cell = tableView.dequeueReusableCell(withIdentifier: "FKYShopThreeAdPageCell", for: indexPath) as!  HomeThreeAdPageCell
                cell.backgroundColor = RGBColor(0xf4f4f4)
                cell.configCell(adModel)
                cell.checkAdBlock = { [weak self] (typeIndex) in
                    if let strongSelf = self {
                        strongSelf.dealAdInfoViewAction(3, adModel, typeIndex, indexPath)
                        if let arr = adModel.iconImgDTOList,arr.count > 0 {
                            let picModel = arr[typeIndex]
                            strongSelf.addShopActivityCommonBIWithView(3, typeIndex+1, picModel.imgName, "\(indexPath.row+1)",nil)
                        }
                    }
                }
                return cell
            }
        }else if let arr = self.viewModel.shopActivityArr[indexPath.row] as? [HighQualityShopsItemModel] {
            //MARK:优质商家
            let cell = tableView.dequeueReusableCell(withIdentifier: "FKYShopQualityCell", for: indexPath) as! FKYShopQualityCell
            cell.configCell(arr)
            cell.clickQualityShopBlock = { [weak self] (seletedIndex,qualityModel) in
                if let strongSelf = self {
                    strongSelf.clickCommonFkyUrl(seletedIndex,qualityModel.jumpInfo, 1, indexPath)
                    strongSelf.addShopActivityCommonBIWithView(5, seletedIndex+1, "商家\(seletedIndex+1)", nil,nil)
                }
            }
            return cell
        }else if let secdModel = self.viewModel.shopActivityArr[indexPath.row] as? HomeSecdKillProductModel{
            //MARK:2*3商品楼层
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomePromotionNewTableViewCell", for: indexPath) as!   HomePromotionNewTableViewCell
            cell.configMPHomePromotionNewTableViewData(secdModel)
            cell.productDetailClosure = { [weak self] (index,prdModel) in
                if let strongSelf = self {
                    strongSelf.clickPromotionNewViewProduct(index, prdModel, secdModel)
                    strongSelf.addShopActivityCommonBIWithView(4,(index+1), nil, "\(indexPath.row+1)",prdModel)
                }
            }
            cell.clickHeaderView = { [weak self]  in
                if let strongSelf = self {
                    strongSelf.clickPromotionViewHeader(secdModel)
                    strongSelf.addShopActivityCommonBIWithView(4, 0, nil, "\(indexPath.row+1)",nil)
                }
            }
            return cell
        }
        return  UITableViewCell.init()
    }
}
extension FKYShopActivityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let arr = self.viewModel.shopActivityArr[indexPath.row] as? [HomeFucButtonItemModel] ,arr.count>0 {
            //MARK:导航按钮
            return  FKYShopFunsTableViewCell.getShopFucListeCellHeight(arr)
        }else if let arr = self.viewModel.shopActivityArr[indexPath.row] as? [HomePublicNoticeItemModel],arr.count > 0 {
            //MARK:通知
            return WH(46)
        }else if let adModel = self.viewModel.shopActivityArr[indexPath.row] as? HomeADInfoModel ,let typeIndex = adModel.floorStyle{
            if typeIndex == 1 {
                //MARK:1栏广告
                return HomeOneAdPageCell.getCellContentHeight()
            }else if typeIndex == 2 {
                //MARK:2栏广告
                return HomeTwoAdPageCell.getCellContentHeight()
            }else if typeIndex == 3 {
                //MARK:3栏广告
                return HomeThreeAdPageCell.getCellContentHeight()
            }
        }else if let arr = self.viewModel.shopActivityArr[indexPath.row] as? [HighQualityShopsItemModel] {
            //MARK:优质商家
            return FKYShopQualityCell.getQualityShopListCellHeight(arr)
        }else if let secdModel = self.viewModel.shopActivityArr[indexPath.row] as? HomeSecdKillProductModel {
            //MARK:2*3商品楼层
            return HomePromotionNewTableViewCell.getPromotionNewTableViewHeight(secdModel)
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
//MARK:网络请求
extension FKYShopActivityViewController {
    /// 下拉刷新
    @objc func refreshTable(){
        self.viewModel.hasNextPage = true
        self.viewModel.currentPage = 1
        //self.viewModel.pageTotal = 0
        self.tableView.mj_footer.endRefreshing()
        self.getMainShopActivityArr()
    }
    // 上拉加载
    @objc func loadMore(){
        if self.viewModel.hasNextPage == false{
            self.dismissLoading()
            return
        }
        self.getMainShopActivityArr()
    }
    @objc fileprivate func loginStatuChanged(_ nty: Notification) {
        self.refreshTable()
    }
    
    fileprivate func refreshDismiss() {
        self.dismissLoading()
        if self.tableView.mj_header.isRefreshing() {
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.resetNoMoreData()
        }
        if self.viewModel.hasNextPage {
            self.tableView.mj_footer.endRefreshing()
        }else{
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    //MARK:请求数据
    fileprivate func getMainShopActivityArr(){
        showLoading()
        viewModel.getShopHomeActivityList(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.resetTableview()
            strongSelf.tableView.reloadData()
            strongSelf.refreshDismiss()
            if success{
                
            } else {
                // 失败
                strongSelf.toast(msg ?? "请求失败")
            }
            if strongSelf.viewModel.shopActivityArr.count == 0 {
                strongSelf.emptyView.isHidden = false
            }else {
                strongSelf.emptyView.isHidden = true
            }
        }
    }
}

//MARK:埋点相关
extension FKYShopActivityViewController {
    fileprivate func addShopActivityCommonBIWithView(_ type:Int,_ indexNum:Int,_ itemStr:String?,_ sectionPositionStr:String?,_ prdModel:HomeRecommendProductItemModel?) {
        var itemId:String?
        var itemName:String?
        var itemPosition :String?
        var sectionName :String?
        var sectionPosition :String?
        var itemContent :String?
        var extendParams : [String :AnyObject]?
        if type == 1 {
            sectionName = "导航按钮"
            itemId = "I4003"
            itemName = itemStr
            itemPosition = "\(indexNum)"
        }else if type == 2 {
            //药城公告
            sectionName = "药城公告"
            itemId = "I1002"
            itemName = "药城公告"
            itemPosition = "\(indexNum)"
        }else if type == 3 {
            //中通广告
            sectionName = "中通广告"
            itemId = "I1021"
            itemName = itemStr
            itemPosition = "\(indexNum)"
            sectionPosition = sectionPositionStr
        }else if type == 4 {
            //药城精选(3*2)
            sectionName = "药城精选(3*2)"
            itemId = "I1025"
            if indexNum == 0 {
                itemName = "更多"
            }else{
                itemName = "点进商详"
            }
            itemPosition = "\(indexNum)"
            sectionPosition = sectionPositionStr
            if let model = prdModel {
                itemContent = "\(model.productCode ?? "0")|\(model.supplyId ?? 0)"
                extendParams = ["storage" : model.storage! as AnyObject,"pm_price" : model.pm_price! as AnyObject,"pm_pmtn_type" : model.pm_pmtn_type! as AnyObject]
            }
        }else if type == 5 {
            //优质商家楼层
            sectionName = "优质商家楼层"
            itemId = "I4005"
            itemName = itemStr
            itemPosition = "\(indexNum)"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName:"店铺专区", sectionId: nil, sectionPosition: sectionPosition, sectionName: sectionName, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent:itemContent , itemTitle: nil, extendParams: extendParams, viewController: self)
    }
}
