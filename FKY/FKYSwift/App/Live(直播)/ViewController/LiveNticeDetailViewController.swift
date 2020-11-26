//
//  LiveNticeDetailViewController.swift
//  FKY
//
//  Created by yyc on 2020/8/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  预告详情

import UIKit

class LiveNticeDetailViewController: UIViewController {
    fileprivate var navBar : UIView?
    
    // 上拉加载更多
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.getAllLiveProduct()
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = RGBColor(0xF4F4F4)
        tableV.showsVerticalScrollIndicator = false
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.estimatedRowHeight = WH(500)
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(LiveProductInfoCell.self, forCellReuseIdentifier: "LiveProductInfoCell_notice")
        tableV.register(LiveNoticeHeadInfoCell.self, forCellReuseIdentifier: "LiveNoticeHeadInfoCell_notice")
        tableV.register(LiveTitleCell.self, forCellReuseIdentifier: "LiveTitleCell_notice")
        tableV.register(LiveNoticeCouponCell.self, forCellReuseIdentifier: "LiveNoticeCouponCell_notice")
        tableV.mj_footer = mjfooter
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    
    //可用商家弹框
    fileprivate lazy var popShopVC : FKYPopShopListViewController = {
        let vc = FKYPopShopListViewController()
        vc.clickShopItem = { [weak self] (shopModel) in
            if let strongSelf = self {
                strongSelf.dealCouponCanUseShopList(shopModel)
            }
        }
        return vc
    }()
    
    //获取预告商品
    fileprivate lazy var viewModel: LiveViewModel = {
        let viewModel = LiveViewModel()
        viewModel.activityId = self.activityId
        return viewModel
    }()
    //获取预告详情
    fileprivate lazy var noticeViewModel: LiveForecastViewModel = {
        let viewModel = LiveForecastViewModel()
        viewModel.activityId = self.activityId
        return viewModel
    }()
    
    //
    @objc var activityId = ""
    //回调是否提醒的状态<>
    @objc var changeNoticeTipStatus : ((Int)->(Void))?
    //MARK:生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.getNoticeDetailData()
        self.loadAllProductFirstPage()
    }
    
}
extension LiveNticeDetailViewController {
    //设置导航栏
    fileprivate func setupView() {
        self.view.backgroundColor = RGBColor(0xF4F4F4)
        
        self.navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            }else{
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
            }()
        self.fky_setupTitleLabel("直播预告")
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared()?.pop()
        }
        //调整左右按钮
        self.NavigationBarLeftImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationTitleLabel!.snp.centerY)
            make.left.equalTo(self.navBar!.snp.left).offset(WH(9))
            make.width.height.equalTo(WH(30))
        })
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.right.left.bottom.equalTo(self.view)
        }
    }
}

extension LiveNticeDetailViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.allLiveProductList.count > 0 {
            return 2 + 1 + self.viewModel.allLiveProductList.count
        }else {
            return 2
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if let _ = self.noticeViewModel.liveBaseInfo {
                return tableView.rowHeight
            }
        }else if indexPath.row == 1 {
            return LiveNoticeCouponCell.configShopCouponsTableViewH(self.noticeViewModel.allCouponsList)
        }else if indexPath.row == 2 {
            return WH(40)
        }else {
            let indexNum = indexPath.row - 3
            if indexNum < self.viewModel.allLiveProductList.count{
                let productModel = self.viewModel.allLiveProductList[indexNum]
                return LiveProductInfoCell.getContentHeight(productModel.productFullName ?? "")
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            //MARK:头部信息
            let cell: LiveNoticeHeadInfoCell = tableView.dequeueReusableCell(withIdentifier: "LiveNoticeHeadInfoCell_notice", for: indexPath) as! LiveNoticeHeadInfoCell
            cell.configNticeHeadInfo(self.noticeViewModel.liveBaseInfo)
            cell.clickHeadViewAction = {[weak self] typeIndex in
                if let strongSelf = self {
                    if typeIndex == 1 {
                        //点击提醒我
                        strongSelf.liveStartTipsAction(indexPath)
                    }else {
                        FKYNavigator.shared().openScheme(FKY_LiveRoomInfoVIewController.self, setProperty: { [weak self] (vc) in
                            if let strongSelf = self {
                                let v = vc as! LiveRoomInfoVIewController
                                v.roomId = "\(strongSelf.noticeViewModel.liveBaseInfo?.roomId ?? 0)"
                            }
                            }, isModal: false)
                    }
                }
            }
            return cell
        }else if indexPath.row == 1 {
            //MARK:优惠券
            let cell: LiveNoticeCouponCell = tableView.dequeueReusableCell(withIdentifier: "LiveNoticeCouponCell_notice", for: indexPath) as! LiveNoticeCouponCell
            cell.configShopCouponsViewData(self.noticeViewModel.allCouponsList)
            cell.clickCouponsTableView = { [weak self] (typeIndex,indexNum,couponsModel) in
                if let strongSelf = self {
                    strongSelf.dealCouponListViewAction(typeIndex,indexNum,couponsModel)
                }
            }
            return cell
        }else if indexPath.row == 2 {
            let cell: LiveTitleCell = tableView.dequeueReusableCell(withIdentifier: "LiveTitleCell_notice", for: indexPath) as! LiveTitleCell
            return cell
        }else {
            // MARK:商品cell
            let cell: LiveProductInfoCell = tableView.dequeueReusableCell(withIdentifier: "LiveProductInfoCell_notice", for: indexPath) as! LiveProductInfoCell
            let indexNum = indexPath.row - 3
            if indexNum < self.viewModel.allLiveProductList.count{
                let productModel = self.viewModel.allLiveProductList[indexNum]
                cell.configCell(productModel)
                cell.cartView.isHidden = true
                cell.productArriveNotice = {[weak self] in
                    if let _ = self {
                        FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                            let controller = vc as! ArrivalProductNoticeVC
                            controller.productId = productModel.spuCode
                            controller.venderId = "\(productModel.supplyId)"
                            controller.productUnit = productModel.packageUnit
                        }, isModal: false)
                        
                    }
                }
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //商品详情
        if indexPath.row > 1 {
            let indexNum = indexPath.row - 3
            if indexNum < self.viewModel.allLiveProductList.count{
                let productModel = self.viewModel.allLiveProductList[indexNum]
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = productModel.spuCode
                    v.vendorId = "\(productModel.supplyId)"
                }, isModal: false)
                self.liveNoticeProductViewBI_Record(productModel)
            }
        }
    }
}
extension LiveNticeDetailViewController {
    //处理点击可用商家事件
    fileprivate func dealCouponCanUseShopList(_ model:UseShopModel){
        self.popShopVC.removeMySelf()
        FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { vc in
            let viewController = vc as! FKYNewShopItemViewController
            viewController.shopId = model.tempEnterpriseId
        })
    }
    //处理优惠券点击事件
    fileprivate func dealCouponListViewAction(_ typeIndex:Int,_ indexNum:Int, _ couponsModel:CommonCouponNewModel){
        if typeIndex == 1 {
            //点击立即领取(暂时不支持领取)
            //self.getReciveCouponsInfo(couponsModel)
        }else if typeIndex == 2 {
            //点击查看可用商品
            FKYNavigator.shared().openScheme(FKY_ShopCouponProductController.self, setProperty: { (vc) in
                let viewController = vc as! CouponProductListViewController
                if let str = couponsModel.couponTempCode ,str.count > 0 {
                    viewController.couponTemplateId = str
                }
                if let str = couponsModel.templateCode ,str.count > 0 {
                    viewController.couponTemplateId = str
                }
                viewController.shopId = couponsModel.enterpriseId ?? ""
                viewController.couponName = couponsModel.couponFullName ?? ""
                viewController.couponCode = couponsModel.couponCode ?? ""
                viewController.sourceType = "1"
            })
            self.liveNoticeViewBI_Record(3)
        }else if typeIndex == 3 {
            //查看可用商家
            if let shopArr = couponsModel.couponDtoShopList, shopArr.count > 0 {
                self.popShopVC.configPopShopListViewController(shopArr)
            }
        }
    }
}
//MARK:网络请求
extension LiveNticeDetailViewController {
    //开播提醒获取取消提醒
    func liveStartTipsAction(_ indexPath: IndexPath){
        if let liveModel = self.noticeViewModel.liveBaseInfo {
            if liveModel.hasSetNotice == 0 {
                //点击开播提醒
                self.liveNoticeViewBI_Record(1)
            }else {
                //关闭提醒
                self.liveNoticeViewBI_Record(2)
            }
            showLoading()
            viewModel.setLiveActivityNotice(liveModel.hasSetNotice == 0 ? 1:2, self.activityId){ [weak self] (success, msg, status) in
                // 成功
                guard let strongSelf = self else {
                    return
                }
                strongSelf.dismissLoading()
                //status 0：成功 1失败
                if success{
                    if status == 0{
                        liveModel.hasSetNotice =  liveModel.hasSetNotice == 0 ? 1:0
                        if liveModel.hasSetNotice  == 1{
                            strongSelf.toast("设置直播提醒成功")
                        }else{
                            strongSelf.toast("取消直播提醒成功")
                        }
                        if let block = strongSelf.changeNoticeTipStatus {
                            block(liveModel.hasSetNotice ?? 0)
                        }
                    }else{
                        strongSelf.toast("设置失败")
                    }
                    strongSelf.tableView.reloadRows(at: [indexPath], with: .none)
                } else {
                    // 失败
                    strongSelf.toast(msg ?? "设置失败")
                    return
                }
            }
        }
        
    }
    //MARK:领取优惠券
//    func getReciveCouponsInfo(_ cpModel:CommonCouponNewModel) {
//        viewModel.getLiveRecieveCouponInfo(cpModel.templateCode) { [weak self] (success, msg) in
//            guard let strongSelf = self else {
//                return
//            }
//            if success{
//                if let desModel = strongSelf.viewModel.getCouponModel {
//                    cpModel.received = true
//                    cpModel.couponTempCode = cpModel.templateCode
//                    cpModel.couponCode = desModel.couponCode
//                    cpModel.begindate = desModel.begindate
//                    cpModel.endDate = desModel.endDate
//                    strongSelf.tableView.reloadData()
//                    strongSelf.toast(msg ?? "领取成功")
//                }
//            } else {
//                strongSelf.toast(msg ?? "领取失败")
//            }
//        }
//    }
    //MARK:获取直播间信息
    fileprivate func getNoticeDetailData(){
        noticeViewModel.getNoticeDetailInfo { [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            if success{
                strongSelf.tableView.reloadData()
            } else {
                
            }
        }
    }
    //MARK:直播所有商品列表
    fileprivate func loadAllProductFirstPage(){
        viewModel.hasNextPage = true
        viewModel.currentPage = 1
        getAllLiveProduct()
    }
    fileprivate func getAllLiveProduct(){
        viewModel.getAllLiveProductInfo(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            if success{
                if strongSelf.viewModel.hasNextPage == true {
                    strongSelf.tableView.mj_footer.resetNoMoreData()
                    strongSelf.tableView.mj_footer.endRefreshing()
                }else {
                    strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                strongSelf.tableView.reloadData()
            } else {
                // 失败
            }
        }
    }
}
extension LiveNticeDetailViewController {
    //口令红包
    func liveNoticeViewBI_Record(_ typeIndex:Int) {
        var itemId:String?
        var itemName:String?
        if typeIndex == 1 {
            //开播提醒
            itemId = "I9620"
            itemName = "开播提醒"
        }else if typeIndex == 2 {
            //关闭提醒
            itemId = "I9621"
            itemName = "关闭提醒"
        }else if typeIndex == 3 {
            //可用商品
            itemId = "I9622"
            itemName = "优惠券可用商家"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName: nil, itemId: itemId, itemPosition: nil, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    }
    func liveNoticeProductViewBI_Record(_ prdModel:HomeCommonProductModel) {
        let itemId = "I9998"
        let itemName = "商品-商详"
        let itemContent  = "\(prdModel.supplyId)｜\(prdModel.spuCode)"
        let extendParams:[String :AnyObject] = ["storage" : prdModel.storage! as AnyObject,"pm_price" : prdModel.pm_price! as AnyObject,"pm_pmtn_type" : prdModel.pm_pmtn_type! as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName: nil, itemId: itemId, itemPosition: nil, itemName: itemName, itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
}
