//
//  FKYOrderPayStatusVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/16.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit


class FKYOrderPayStatusVC: UIViewController {
    
    /// 从哪个界面跳转而来
    /// 1 支付宝支付成功跳转
    /// 2 微信支付成功跳转
    /// 3 订单详情
    /// 4 请人代付
    /// 5 线下转账
    /// 6 其他支付成功立即跳转抽奖的界面
    /// 7检查订单提交时，使用抵扣金，总支付金额为0，直接跳到支付成功
    /// 8上海银行快捷支付
    @objc var fromePage = 0
    
    /// 订单号，由外部传进来
    @objc var orderNO: String = ""
    
    /// 套餐优惠viewmodel
    var discountPackageViewModel = FKYDiscountPackageViewModel()
    
    /// 订单数据管理类
    var detailService: FKYOrderService = FKYOrderService()
    
    /// 选中cell 的位置
    var selectIndexPath: IndexPath?
    
    /// ViewModel
    var viewModel = FKYOrderPayStatusViewModel()
    
    /// 下拉刷新的时候多个线程同步
    let refreshGroup = DispatchGroup()
    
    /// 是否已经上报了套餐优惠曝光埋点
    var isUploadedDiscountEntryBI = false
    
    /// 导航栏
    fileprivate var navBar: UIView?
    ///可用商家弹框
    fileprivate lazy var popShopVC: FKYPopShopListViewController = self.creatPopShopVC()
    
    /// 主table
    lazy var mainTable: UITableView = self.creatMainTable()
    
    ///商品加车弹框
    fileprivate lazy var addCarView: FKYAddCarViewController = self.creatAddCarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.configOrderID()
        self.viewModel.fromePage = self.fromePage
        self.showLoading()
        self.requestPrizeInfo()
        self.requestOrderInfo()
        self.getHomeOftenBuyInfo()
        self.requestDiscountPackageInfo()
        self.refreshGroup.notify(queue: DispatchQueue.main) {
            self.dismissLoading()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 同步购物车商品数量
        self.getCartNumber()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    deinit {
        print("FKYOrderPayStatusVC deinit~!@")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(FKYOrderPayStatusVC.addDiscountBaoGuangBi), object: nil)
    }
}


//MARK: - 响应事件
extension FKYOrderPayStatusVC {
    
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable: Any]! = [:]) {
        if eventName == FKY_OrderPayStatusCheckOrderBtnÇlicked { // 查看订单按钮点击
            FKYNavigator.shared()?.openScheme(FKY_AllOrderController.self, setProperty: { (vc) in
                let allOrderVC = vc as! FKYAllOrderViewController
                allOrderVC.status = "0"
            })
            self.addNewType1BIRec(itemId: "I9411", itemName: "查看订单", itemPosition: "1")
            
        } else if eventName == FKY_OrderPayStatusBackgroundBtnClicked { // 迎解封 大降价 按钮点击 后台配置
            var jumpUrl = ""
            var drawName = ""
            if self.viewModel.drawRawData.promotionLink.isEmpty == false {
                jumpUrl = self.viewModel.drawRawData.promotionLink
                drawName = self.viewModel.drawRawData.drawName
            } else if self.viewModel.drawRawData.orderDrawRecordDto.promotionLink.isEmpty == false {
                jumpUrl = self.viewModel.drawRawData.orderDrawRecordDto.promotionLink
                drawName = self.viewModel.drawRawData.orderDrawRecordDto.drawName
            }
            (UIApplication.shared.delegate as! AppDelegate).p_openPriveteSchemeString(jumpUrl)
            self.addNewType2BIRec(itemId: "I9411", itemName: "促销按钮", itemPosition: "2", itemContent: drawName)
        } else if eventName == FKY_activityRulerBtnClicked { // 活动规则按钮点击
            var jumpUrl = ""
            if self.viewModel.drawRawData.ruleLink.isEmpty == false {
                jumpUrl = self.viewModel.drawRawData.ruleLink
            } else if self.viewModel.drawRawData.orderDrawRecordDto.ruleLink.isEmpty == false {
                jumpUrl = self.viewModel.drawRawData.orderDrawRecordDto.ruleLink
            }
            (UIApplication.shared.delegate as! AppDelegate).p_openPriveteSchemeString(jumpUrl)
        } else if eventName == FKY_startLottery { // 开始抽奖按钮点击
            self.view.isUserInteractionEnabled = false
            self.startDraw()
            self.addNewType1BIRec(itemId: "I9412", itemName: "开始抽奖", itemPosition: "1")
        } else if eventName == FKY_turntableIsStoped { // 抽奖转盘已经停止转动
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute:{
                self.switchDrawResult()
            })
            self.view.isUserInteractionEnabled = true
        } else if eventName == FKY_useButtonClicked { // 立即使用优惠券按钮点击
            self.couponBtnClicked()
        } else if eventName == FKY_checkCouponBtnClicked { // 去我的优惠券查看按钮点击
            FKYNavigator.shared()?.openScheme(FKY_MyCoupon.self, setProperty: { (vc) in
                
            })
            self.addNewType1BIRec(itemId: "I9413", itemName: "前往我的优惠券", itemPosition: "3")
        } else if eventName == FKY_goInDiscountPackage { // 优惠套餐活动入口
            self.addDiscountClickBI()
            let entryModel = userInfo[FKYUserParameterKey] as! FKYDiscountPackageModel
            (UIApplication.shared.delegate as! AppDelegate).p_openPriveteSchemeString(entryModel.jumpInfo)
        }else if eventName == FKYLotteryView.FKY_turntableIsStopedWithError {// 转盘因为异常情况停止转动
            self.view.isUserInteractionEnabled = true
        }
    }
    
    /// 切换抽奖后的界面
    func switchDrawResult() {
        //奖品类型 1实物 2返利金 3优惠券 4店铺券
        if self.viewModel.drawResult.priseType == 1 { //1实物
            self.viewModel.winningThePrize(cellType: .entityPrizeCell)
        } else if self.viewModel.drawResult.priseType == 2 { // 2返利金
            self.viewModel.winningThePrize(cellType: .entityPrizeCell)
        } else if self.viewModel.drawResult.priseType == 3 || self.viewModel.drawResult.priseType == 4 { // 3优惠券 4店铺券
            self.viewModel.winningThePrize(cellType: .virtualPrizeCell)
        } else if Int(self.viewModel.drawResult.priseLevel) == 0 { /// 未中奖
            self.viewModel.winningThePrize(cellType: .noPrizeCell)
        }
        self.mainTable.reloadData()
    }
    
    /// 优惠券上的按钮点击事件
    func couponBtnClicked() {
        if self.viewModel.drawResult.couponDto.tempType == "1", self.viewModel.drawResult.couponDto.isLimitShop == "1" {
            /// 平台券 限制商家  展示按钮
            var canUserList: [UseShopModel] = []
            for shop in self.viewModel.drawResult.couponDto.couponDtoShopList {
                let newShopModel = UseShopModel.init(tempEnterpriseId: shop.tempEnterpriseId, tempEnterpriseName: shop.tempEnterpriseName)
                canUserList.append(newShopModel)
            }
            self.popShopVC.configPopShopListViewController(canUserList)
            self.addNewType1BIRec(itemId: "I9413", itemName: "查看可用商家", itemPosition: "2")
        } else if self.viewModel.drawResult.couponDto.tempType == "0", self.viewModel.drawResult.couponDto.isLimitProduct == "1" {
            /// 店铺券 限制商品 展示按钮
            FKYNavigator.shared().openScheme(FKY_ShopCouponProductController.self, setProperty: { (vc) in
                let viewController = vc as! CouponProductListViewController
                viewController.couponTemplateId = self.viewModel.drawResult.couponDto.couponTempCode
                viewController.shopId = self.viewModel.drawResult.couponDto.enterpriseId
            })
            self.addNewType1BIRec(itemId: "I9413", itemName: "立即使用", itemPosition: "1")
        }
        
    }
    
    //MARK:处理优惠会点击店铺弹框
    fileprivate func dealCouponCanUseShopList(_ model: UseShopModel) {
        self.popShopVC.removeMySelf()
        FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { vc in
            let viewController = vc as! FKYNewShopItemViewController
            viewController.shopId = model.tempEnterpriseId
        })
    }
    
    /// 上拉加载
    @objc func pullUpLoadMore() {
        self.loadMoreData()
    }
}

//MARK: - UI
extension FKYOrderPayStatusVC {
    
    func setupUI() {
        self.configNaviBar()
        self.view.addSubview(self.mainTable)
        
        self.mainTable.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.navBar!.snp_bottom)
        }
    }
    
    /// 配置导航栏
    func configNaviBar() {
        self.navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            } else {
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
            }()
        self.fky_setupTitleLabel("")
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self] () in
            guard let weakSelf = self else {
                return
            }
            //1 支付宝支付成功跳转 2 微信支付成功跳转 3 订单详情 4 请人代付 5 线下转账 6 其他支付成功立即跳转抽奖的界面
            if weakSelf.fromePage == 4 || weakSelf.fromePage == 5 {
                FKYNavigator.shared()?.openScheme(FKY_TabBarController.self, setProperty: { (destinationViewController) in
                    let vc = destinationViewController as! FKY_TabBarController
                    vc.index = 0
                })
            } else if weakSelf.fromePage == 7 {
                FKYNavigator.shared()?.openScheme(FKY_TabBarController.self, setProperty: { (destinationViewController) in
                    let vc = destinationViewController as! FKY_TabBarController
                    vc.index = 3
                })
            } else if weakSelf.fromePage == 8 { // 上海银行快捷支付
                FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                    let v = vc as! FKY_TabBarController
                    v.index = 4
                    // 订单列表...<待付款>
                    FKYNavigator.shared().openScheme(FKY_AllOrderController.self, setProperty: { (vc) in
                        let controller = vc as! FKYAllOrderViewController
                        controller.status = "2"
                    }, isModal: false)
                }, isModal: false)
            } else {
                FKYNavigator.shared().pop()
            }
            weakSelf.addNewType1BIRec(itemId: "I9410", itemName: "返回", itemPosition: "1")
        }
    }
}


//MARK: - table代理
extension FKYOrderPayStatusVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.cellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = self.viewModel.cellList[indexPath.row]
        
        if cellModel.cellType == .orderPayInfoCell { /// 订单支付信息cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYOrderPayStatusInfocell.self)) as! FKYOrderPayStatusInfocell
            cell.configCellData(cellData: cellModel)
            return cell
        } else if cellModel.cellType == .LotteryCell { ///抽奖cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYLotteryCell.self)) as! FKYLotteryCell
            cell.configCellData(cellData: cellModel)
            if Int(cellModel.drawResultModel.priseLevel)! < 0 {
                cell.stopRotatNow()
            } else if cellModel.drawResultModel.isCanTurn == true {
                cell.stopWithSuccess(stopIndex: cellModel.drawResultModel.stopIndex)
                cellModel.drawResultModel.isCanTurn = false
            }
            return cell
        } else if cellModel.cellType == .virtualPrizeCell { /// 虚拟奖品cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYLotteryVirtualPrizeCell.self)) as! FKYLotteryVirtualPrizeCell
            cell.configCellData(cellData: cellModel)
            return cell
        } else if cellModel.cellType == .entityPrizeCell { /// 实体奖品cell 包含奖励金
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYLotteryEntityPrizeCell.self)) as! FKYLotteryEntityPrizeCell
            cell.configCellData(cellData: cellModel)
            return cell
        } else if cellModel.cellType == .noPrizeCell { /// 未中奖cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYLotteryNoPrizeCell.self)) as! FKYLotteryNoPrizeCell
            return cell
        } else if cellModel.cellType == .productCell { /// 推荐商品cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ProductInfoListCell.self)) as! ProductInfoListCell
            cell.configCell(cellModel.productModel)
            self.configProductCell(cell: cell, indexPath: indexPath, cellData: cellModel.productModel)
            return cell
        } else if cellModel.cellType == .recommendTipCell { /// 推荐商品提示cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYLotteryRecommendTipCell.self)) as! FKYLotteryRecommendTipCell
            cell.tipView.backgroundColor = .clear
            return cell
        } else if cellModel.cellType == .discountPackageCell { /// 优惠套餐活动入口
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYDiscountPackageCell.self)) as! FKYDiscountPackageCell
            cell.configEntryWithModel(model: self.discountPackageViewModel.discountPackage)
            self.perform(#selector(FKYOrderPayStatusVC.addDiscountBaoGuangBi), with: nil, afterDelay: 3)
            return cell
        }
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "error")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellData = self.viewModel.cellList[indexPath.row]
        if cellData.cellType == .productCell {
            let conutCellHeight = ProductInfoListCell.getCellContentHeight(cellData.productModel)
            return conutCellHeight
        }
        return tableView.rowHeight
    }
    
}



//MARK: -  私有方法
extension FKYOrderPayStatusVC {
    
    func configOrderID() {
        if self.fromePage == 1 || self.fromePage == 2 || self.fromePage == 4 || self.fromePage == 6 {
            let userDefault = UserDefaults.standard
            self.orderNO = userDefault.string(forKey: "NewestPayOrderID") ?? ""
        } else if self.fromePage == 3 || self.fromePage == 5 {
            
        }
    }
    
    /// 配置商品cell
    func configProductCell(cell: ProductInfoListCell, indexPath: IndexPath, cellData: HomeCommonProductModel) {
        cell.selectionStyle = .none
        cellData.showSequence = indexPath.row + 1
        cell.configCell(cellData)
        cell.resetCanClickShopArea(cellData)
        
        //更新加车数量
        cell.addUpdateProductNum = { [weak self] in
            if let strongSelf = self {
                strongSelf.selectIndexPath = indexPath
                strongSelf.popAddCarView(cellData)
                var itemPosition = 0
                for (index, product) in strongSelf.viewModel.ofentBuyModel.list.enumerated() {
                    if product.spuCode == cellData.spuCode {
                        itemPosition = index + 1
                    }
                }
                strongSelf.addNewType3BIRec(sectionId: "S9414", sectionName: "为您推荐", sectionPosition: "1", itemId: "I9999", itemName: "加车", itemPosition: "\(itemPosition)", itemTitle: "", itemContent: "\(cellData.supplyId ?? 0)|\(cellData.spuCode ?? "")", storage: cellData.storage ?? "", pm_price: cellData.pm_price ?? "", pm_pmtn_type: cellData.pm_pmtn_type ?? "")
            }
        }
        
        //到货通知
        cell.productArriveNotice = {
            FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                let controller = vc as! ArrivalProductNoticeVC
                controller.productId = cellData.spuCode
                controller.venderId = "\(cellData.supplyId)"
                controller.productUnit = cellData.packageUnit
            }, isModal: false)
        }
        
        //跳转到聚宝盆商家专区
        cell.clickJBPContentArea = { [weak self] in
            if let _ = self {
                FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                    let controller = vc as! FKYNewShopItemViewController
                    controller.shopId = cellData.shopCode ?? ""
                    controller.shopType = "1"
                }, isModal: false)
            }
        }
        
        //登录
        cell.loginClosure = {
            FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
        }
        
        //套餐按钮
        cell.clickComboBtn = { [weak self] in
            if let _ = self {
                if let num = cellData.dinnerPromotionRule , num == 2 {
                    //固定套餐
                    FKYNavigator.shared().openScheme(FKY_ComboList.self, setProperty: { (vc) in
                        let controller = vc as! FKYComboListViewController
                        controller.enterpriseName = cellData.supplyName
                        controller.sellerCode = cellData.supplyId
                        controller.spuCode = cellData.spuCode
                    }, isModal: false)
                }else {
                    //搭配套餐
                    FKYNavigator.shared().openScheme(FKY_MatchingPackageVC.self, setProperty: { (vc) in
                        let controller = vc as! FKYMatchingPackageVC
                        controller.spuCode = cellData.spuCode
                        controller.enterpriseId = "\(cellData.supplyId)"
                    }, isModal: false)
                }
            }
        }
        
        // 商详
        cell.touchItem = { [weak self] in
            if let strongSelf = self {
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = cellData.spuCode
                    v.vendorId = "\(cellData.supplyId ?? 0)"
                    v.updateCarNum = { (carId, num) in
                        if let count = num {
                            cellData.carOfCount = count.intValue
                        }
                        if let getId = carId {
                            cellData.carId = getId.intValue
                        }
                        strongSelf.mainTable.reloadData()
                    }
                }, isModal: false)
                
                var itemPosition = 0
                for (index, product) in strongSelf.viewModel.ofentBuyModel.list.enumerated() {
                    if product.spuCode == cellData.spuCode {
                        itemPosition = index + 1
                    }
                }
                strongSelf.addNewType3BIRec(sectionId: "S9414", sectionName: "为您推荐", sectionPosition: "1", itemId: "I9998", itemName: "点进商详", itemPosition: "\(itemPosition)", itemTitle: "", itemContent: "\(cellData.supplyId ?? 0)|\(cellData.spuCode ?? "")", storage: cellData.storage ?? "", pm_price: cellData.pm_price ?? "", pm_pmtn_type: cellData.pm_pmtn_type ?? "")
            }
        }
        
        /// 跳转到店铺首页
        cell.clickShopContentArea = { [weak self] in
            if let strongSelf = self {
                FKYNavigator.shared()?.openScheme(FKY_ShopItem.self, setProperty: { (viewControl) in
                    let vc = viewControl as! FKYNewShopItemViewController
                    vc.shopId = "\(cellData.supplyId ?? 0)"
                    vc.shopType = "2"
                }, isModal: false)
                
                var itemPosition = 0
                for (index, product) in strongSelf.viewModel.ofentBuyModel.list.enumerated() {
                    if product.spuCode == cellData.spuCode {
                        itemPosition = index + 1
                    }
                }
                strongSelf.addNewType3BIRec(sectionId: "S9414", sectionName: "为您推荐", sectionPosition: "1", itemId: "I9997", itemName: "点进店铺", itemPosition: "\(itemPosition)", itemTitle: "", itemContent: "\(cellData.supplyId ?? 0)|\(cellData.spuCode ?? "")", storage: cellData.storage ?? "", pm_price: cellData.pm_price ?? "", pm_pmtn_type: cellData.pm_pmtn_type ?? "")
            }
        }
    }
    
    //弹出加车框
    func popAddCarView(_ productModel: Any?) {
        self.addCarView.configAddCarViewController(productModel, "")
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
    
    //加车 刷新单个cell
    func refreshSingleCell() {
        if let indexPath = self.selectIndexPath, self.viewModel.cellList.count > indexPath.row {
            let product = self.viewModel.cellList[indexPath.row].productModel
            for cartModel in FKYCartModel.shareInstance().productArr {
                if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                    if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == "\(product.spuCode ?? "")" && cartOfInfoModel.supplyId.intValue == (product.supplyId ?? 0) {
                        product.carOfCount = cartOfInfoModel.buyNum.intValue
                        product.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
            self.mainTable.reloadRows(at: [indexPath], with: .none)
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
    
    /// 刷新商品卡片的购物车数量
    func reloadViewWithBackFromCart() {
        for productModel in self.viewModel.ofentBuyModel.list {
            if FKYCartModel.shareInstance().productArr.count > 0 {
                for cartModel in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == "\(productModel.spuCode ?? "")" && cartOfInfoModel.supplyId.intValue == (productModel.supplyId ?? 0) {
                            productModel.carOfCount = cartOfInfoModel.buyNum.intValue
                            productModel.carId = cartOfInfoModel.cartId.intValue
                            break
                        } else {
                            productModel.carOfCount = 0
                            productModel.carId = 0
                        }
                    }
                }
            } else {
                productModel.carOfCount = 0
                productModel.carId = 0
            }
        }
        self.mainTable.reloadData()
    }
}


//MARK: - 网络请求
extension FKYOrderPayStatusVC {
    /// 刷新页面数据
    func refreshData() {
        self.viewModel.ofentBuyModel.nextPageId = 1
        self.viewModel.ofentBuyModel.hasNextPage = true
        self.viewModel.ofentBuyModel.list.removeAll()
        self.requestOrderInfo()
        self.getHomeOftenBuyInfo()
    }
    
    /// 获取套餐优惠的入口信息
    func requestDiscountPackageInfo() {
        self.discountPackageViewModel.type = "38"
        self.discountPackageViewModel.requestDiscountPackageInfo { [weak self] (isSuccess, Msg) in
            guard let weakSelf = self else {
                return
            }
            guard isSuccess else {
                weakSelf.toast(Msg)
                return
            }
            weakSelf.viewModel.discountPackageModel = weakSelf.discountPackageViewModel.discountPackage
            weakSelf.viewModel.processingData()
            weakSelf.mainTable.reloadData()
        }
    }
    
    /// 上拉加载，只加载推荐品
    func loadMoreData() {
        if self.viewModel.ofentBuyModel.hasNextPage == false {
            if self.viewModel.ofentBuyModel.list.count > 0 {
                self.mainTable.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.mainTable.mj_footer.endRefreshing()
                self.mainTable.mj_footer = nil
            }
            return
        }
        self.getHomeOftenBuyInfo()
    }
    
    /// 开始抽奖接口
    func startDraw() {
        self.viewModel.startDrawRequest { [weak self] (isSuccess, Msg) in
            guard let weakSelf = self else {
                return
            }
            guard isSuccess else {
                weakSelf.toast(Msg)
                weakSelf.mainTable.reloadData()
                return
            }
            weakSelf.mainTable.reloadData()
        }
    }
    
    /// 请求抽奖信息
    func requestPrizeInfo() {
        self.refreshGroup.enter()
        var fromPage = ""
        if self.fromePage == 1 || self.fromePage == 2 || self.fromePage == 6 || self.fromePage == 7 || self.fromePage == 8 {
            fromPage = "1"
        } else if self.fromePage == 3 || self.fromePage == 4 || self.fromePage == 5 {
            fromPage = ""
        }
        self.viewModel.requestDrawInfo(fromPage: fromPage, orderNo: self.orderNO) { [weak self] (isSuccess, Msg) in
            guard let strongSelf = self else {
                self?.refreshGroup.leave()
                return
            }
            guard isSuccess else {
                strongSelf.toast(Msg)
                strongSelf.refreshGroup.leave()
                return
            }
            strongSelf.mainTable.reloadData()
            strongSelf.refreshGroup.leave()
        }
    }
    
    /// 请求订单信息
    func requestOrderInfo() {
        self.refreshGroup.enter()
        self.detailService.getOrderDetail(withOrderId: self.orderNO, success: { (orderDetailModel) in
            self.viewModel.orderInfoRawData = orderDetailModel ?? FKYOrderModel()
            self.viewModel.processingData()
            self.mainTable.reloadData()
            if self.viewModel.orderInfoRawData.isPay == 1 { // 已支付
                self.fky_setupTitleLabel("支付完成")
            } else if self.viewModel.orderInfoRawData.isPay == 0 { // 未支付
                self.fky_setupTitleLabel("待支付")
            }
            self.refreshGroup.leave()
        }) { (Msg) in
            self.toast(Msg)
            self.refreshGroup.leave()
        }
    }
    
    /// 获取首页常购清单推荐品
    func getHomeOftenBuyInfo() {
        self.refreshGroup.enter()
        self.viewModel.getHomeOftenBuyInfo { [weak self] (isSuccess, Msg) in
            guard let weakSelf = self else {
                self?.refreshGroup.leave()
                return
            }
            guard isSuccess else {
                weakSelf.toast(Msg)
                weakSelf.refreshGroup.leave()
                return
            }
            weakSelf.viewModel.processingData()
            weakSelf.reloadViewWithBackFromCart()
            weakSelf.mainTable.reloadData()
            if weakSelf.viewModel.ofentBuyModel.hasNextPage == false {
                if weakSelf.viewModel.ofentBuyModel.list.count > 0 {
                    weakSelf.mainTable.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    weakSelf.mainTable.mj_footer.endRefreshing()
                    weakSelf.mainTable.mj_footer = nil
                }
            } else {
                weakSelf.mainTable.mj_footer.endRefreshing()
            }
            weakSelf.refreshGroup.leave()
        }
    }
}

//MARK: - BI埋点
extension FKYOrderPayStatusVC {
    
    /// 套餐优惠曝光埋点
    @objc func addDiscountBaoGuangBi() {
        guard isUploadedDiscountEntryBI == true else {
            return;
        }
        isUploadedDiscountEntryBI = true
        FKYAnalyticsManager.sharedInstance.BI_New_Record("", floorPosition: "", floorName: "", sectionId: "", sectionPosition: "", sectionName: "", itemId: "I1999", itemPosition: "", itemName: "有效曝光", itemContent: "", itemTitle: "", extendParams: [:] as [String: AnyObject], viewController: self)
    }
    /// 套餐优惠点击埋点
    func addDiscountClickBI() {
        FKYAnalyticsManager.sharedInstance.BI_New_Record("", floorPosition: "", floorName: "", sectionId: "", sectionPosition: "", sectionName: "", itemId: "I0004", itemPosition: "1", itemName: self.discountPackageViewModel.discountPackage.name , itemContent: "", itemTitle: "", extendParams: [:] as [String: AnyObject], viewController: self)
    }
    
    /// 第一种类型BI
    func addNewType1BIRec(itemId: String, itemName: String, itemPosition: String) {
        self.addNewType2BIRec(itemId: itemId, itemName: itemName, itemPosition: itemPosition, itemContent: "")
    }
    
    /// 第二种类型BI
    func addNewType2BIRec(itemId: String, itemName: String, itemPosition: String, itemContent: String) {
        self.addNewType3BIRec(sectionId: "", sectionName: "", sectionPosition: "", itemId: itemId, itemName: itemName, itemPosition: itemPosition, itemTitle: "", itemContent: itemContent, storage: "", pm_price: "", pm_pmtn_type: "")
    }
    
    /// 第三种类型BI
    func addNewType3BIRec(sectionId: String, sectionName: String, sectionPosition: String, itemId: String, itemName: String, itemPosition: String, itemTitle: String, itemContent: String, storage: String, pm_price: String, pm_pmtn_type: String) {
        let extendDic = ["storage": storage,
                         "pm_price": pm_price,
                         "pm_pmtn_type": pm_pmtn_type]
        FKYAnalyticsManager.sharedInstance.BI_New_Record("", floorPosition: "", floorName: "", sectionId: sectionId, sectionPosition: sectionPosition, sectionName: sectionName, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: itemContent, itemTitle: itemTitle, extendParams: extendDic as [String: AnyObject], viewController: self)
    }
}

//MARK: - 属性对应的生成方法
extension FKYOrderPayStatusVC {
    func creatPopShopVC() -> FKYPopShopListViewController {
        let vc = FKYPopShopListViewController()
        vc.clickShopItem = { [weak self] (shopModel) in
            if let strongSelf = self {
                strongSelf.dealCouponCanUseShopList(shopModel)
            }
        }
        return vc
    }
    
    func creatMainTable() -> UITableView {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 200
        tb.estimatedSectionHeaderHeight = 0
        tb.estimatedSectionFooterHeight = 0
        tb.separatorStyle = .none
        tb.register(FKYOrderPayStatusInfocell.self, forCellReuseIdentifier: NSStringFromClass(FKYOrderPayStatusInfocell.self))
        tb.register(FKYLotteryCell.self, forCellReuseIdentifier: NSStringFromClass(FKYLotteryCell.self))
        tb.register(FKYLotteryVirtualPrizeCell.self, forCellReuseIdentifier: NSStringFromClass(FKYLotteryVirtualPrizeCell.self))
        tb.register(FKYLotteryEntityPrizeCell.self, forCellReuseIdentifier: NSStringFromClass(FKYLotteryEntityPrizeCell.self))
        tb.register(ProductInfoListCell.self, forCellReuseIdentifier: NSStringFromClass(ProductInfoListCell.self))
        tb.register(FKYLotteryRecommendTipCell.self, forCellReuseIdentifier: NSStringFromClass(FKYLotteryRecommendTipCell.self))
        tb.register(FKYLotteryNoPrizeCell.self, forCellReuseIdentifier: NSStringFromClass(FKYLotteryNoPrizeCell.self))
        tb.register(FKYDiscountPackageCell.self, forCellReuseIdentifier: NSStringFromClass(FKYDiscountPackageCell.self))
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(FKYOrderPayStatusVC.pullUpLoadMore))
        footer?.setTitle("--没有更多啦！--", for: .noMoreData)
        tb.mj_footer = footer
        tb.backgroundColor = RGBColor(0xFCEFB7)
        return tb
    }
    
    func creatAddCarView() -> FKYAddCarViewController {
        let addView = FKYAddCarViewController()
        //addView.finishPoint = CGPoint(x:SCREEN_WIDTH - WH(10)-(self.NavigationBarRightImage?.frame.size.width)!/2.0,y:naviBarHeight()-WH(5)-(self.NavigationBarRightImage?.frame.size.height)!/2.0)
        //更改购物车数量
        addView.addCarSuccess = { [weak self] (isSuccess, type, productNum, productModel) in
            if let strongSelf = self {
                if isSuccess == true {
                    if type == 1 {
                        //strongSelf.changeBadgeNumber(false)
                    } else if type == 3 {
                        //strongSelf.changeBadgeNumber(true)
                    }
                }
                strongSelf.refreshSingleCell()
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? HomeProductModel {
                    //strongSelf.addCarBI_Record(model)
                }
            }
        }
        return addView
    }
    
}

