//
//  ArrivalProductNoticeVc.swift
//  FKY
//
//  Created by 寒山 on 2020/8/10.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class ArrivalProductNoticeVC: UIViewController {
    @objc var productId: String?       // 商品编码
    @objc var venderId: String?        // 商家编码
    @objc var productUnit: String?     // 商品包装
    fileprivate var selectIndexPath: IndexPath? //选中cell 位置
    fileprivate lazy var viewModel: ArrivalProductNoticeViewModel = {
        let vm = ArrivalProductNoticeViewModel()
        return vm
    }()
    fileprivate var navBar: UIView?
    fileprivate var badgeView: JSBadgeView?
    
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            self?.getRecommendProductInfo()
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        // footer!.stateLabel.textColor = RGBColor(0xF73131)
        return footer!
    }()
    //列表
    lazy var tableView: UITableView = { [weak self] in
        var tableView = UITableView(frame: CGRect.null, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(ProductInfoListNoShadowCell.self, forCellReuseIdentifier: "ProductInfoListNoShadowCell")
        tableView.register(ArrivalProductNoticeHeadCell.self, forCellReuseIdentifier: "ArrivalProductNoticeHeadCell")
        tableView.mj_footer = self?.mjfooter
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0//WH(213)
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
        }()
    ///商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        addView.finishPoint = CGPoint(x:SCREEN_WIDTH - WH(10)-(self.NavigationBarRightImage?.frame.size.width)!/2.0,y:naviBarHeight()-WH(5)-(self.NavigationBarRightImage?.frame.size.height)!/2.0)
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
                strongSelf.refreshSingleCell()
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? HomeCommonProductModel {
                    //if strongSelf.keyword.isEmpty == false{
                    strongSelf.addNewBI_Record(model, model.showSequence, 2)
                    //}else{
                    // strongSelf.addCarBI_Record(model)
                    // }
                }
            }
        }
        return addView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("内存不足")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 同步购物车商品数量
        self.getCartNumber()
        // 购物车badge
        self.changeBadgeNumber(true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>ArrivalProductNoticeVC deinit~!@")
        self.dismissLoading()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGBColor(0xF4F4F4)
        setupView()
        setupData()
    }
    // MARK: init Method
    fileprivate func setupData() {
        viewModel.phoneInput  = ((UserDefaults.standard.object(forKey: "user_mobile") ?? "") as! String)
        viewModel.productId = self.productId
        viewModel.venderId = self.venderId
        viewModel.productUnit = self.productUnit
        self.getRecommendProductInfo()
    }
    fileprivate func setupView() {
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar!.backgroundColor = RGBColor(0xFFFFFF)
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") {[weak self] in
            if self != nil {
                FKYNavigator.shared().pop()
            }
        }
        self.fky_setupRightImage("icon_cart_new") {[weak self] in
            // 购物车
            if let _ = self {
                FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
                    let v = vc as! FKY_ShopCart
                    v.canBack = true
                }, isModal: false)
            }
            
        }
        fky_setupTitleLabel("到货通知")
        
        // iPhoneX适配
        var height = WH(62)
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                height += iPhoneX_SafeArea_BottomInset
            }
        }
        
        let bv = JSBadgeView(parentView: self.NavigationBarRightImage, alignment: .topRight)
        bv?.badgePositionAdjustment = CGPoint(x: WH(-3), y: WH(3))
        bv?.badgeTextFont = UIFont.systemFont(ofSize: WH(11))
        bv?.badgeBackgroundColor = RGBColor(0xFF2D5C)
        self.badgeView = bv
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.navBar!.snp.bottom)
            make.bottom.equalTo(self.view)
        }
    }
}
//MARK:显示页码 修改购物车显示数量
extension ArrivalProductNoticeVC {
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
    // MARK: Public Method
    func refreshTableView() {
        // 更新 只对 20条以内的 数据进行赋值
        if  self.viewModel.dataSource.isEmpty == true{
            return
        }
        if self.viewModel.dataSource.count > 30{
            for index in (self.viewModel.dataSource.count - 30)...(self.viewModel.dataSource.count - 1) {
                let product = self.viewModel.dataSource[index]
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode && cartOfInfoModel.supplyId.intValue == (product.supplyId ) {
                            product.carOfCount = cartOfInfoModel.buyNum.intValue
                            product.carId = cartOfInfoModel.cartId.intValue
                            break
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }else{
            for index in 0...(self.viewModel.dataSource.count - 1) {
                let product = self.viewModel.dataSource[index]
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode && cartOfInfoModel.supplyId.intValue == (product.supplyId) {
                            product.carOfCount = cartOfInfoModel.buyNum.intValue
                            product.carId = cartOfInfoModel.cartId.intValue
                            break
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    //加车 刷新单个cell
    func refreshSingleCell() {
        if let indexPath = self.selectIndexPath , self.viewModel.dataSource.count > indexPath.row{
            let product =  self.viewModel.dataSource[indexPath.row]
            for cartModel  in FKYCartModel.shareInstance().productArr {
                if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                    if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode && cartOfInfoModel.supplyId.intValue == (product.supplyId) {
                        product.carOfCount = cartOfInfoModel.buyNum.intValue
                        product.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    //刷新全部
    func refreshAllProductTableView() {
        if  self.viewModel.dataSource.isEmpty == true{
            return
        }
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            for index in 0...(strongSelf.viewModel.dataSource.count - 1) {
                let product = strongSelf.viewModel.dataSource[index]
                if FKYCartModel.shareInstance().productArr.count > 0{
                    for cartModel  in FKYCartModel.shareInstance().productArr {
                        if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                            if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode && cartOfInfoModel.supplyId.intValue == (product.supplyId )  {
                                product.carOfCount = cartOfInfoModel.buyNum.intValue
                                product.carId = cartOfInfoModel.cartId.intValue
                                break
                            }else {
                                product.carOfCount = 0
                                product.carId = 0
                            }
                        }
                    }
                }else{
                    product.carOfCount = 0
                    product.carId = 0
                }
                
                strongSelf.tableView.reloadData()
            }
        }
    }
    func refreshDismiss() {
        self.dismissLoading()
        if  self.viewModel.hasNextPage {
            self.tableView.mj_footer.endRefreshing()
        }else{
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = HomeString.YHQ_ADD_SOURCE_TYPE
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true, self.view)
    }
}
extension ArrivalProductNoticeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArrivalProductNoticeHeadCell", for: indexPath) as!   ArrivalProductNoticeHeadCell
            cell.configView(self.viewModel.stockoutModel,self.viewModel.phoneInput,self.viewModel.numberInput,self.viewModel.productUnit,self.viewModel.dataSource.isEmpty == false)
            cell.changeProductNumText = { [weak self] (txt) in
                guard let strongSelf = self else {
                    return
                }
                // 保存内容
                strongSelf.viewModel.numberInput = txt
            }
            cell.changePhoneNumText = { [weak self] (txt) in
                guard let strongSelf = self else {
                    return
                }
                // 保存内容
                strongSelf.viewModel.phoneInput = txt
            }
            cell.sendArrivalNoticeAction = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                // 提交到货通知
                strongSelf.sendArrivalNoticeRequest()
            }
            return cell
        }
        let cellData =  self.viewModel.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInfoListNoShadowCell", for: indexPath) as!   ProductInfoListNoShadowCell
        cell.selectionStyle = .none
        cellData.showSequence = indexPath.row + 1
        cell.configCell(cellData)
        cell.resetCanClickShopArea(cellData,.CommonSearch)
        //更新加车数量
        cell.addUpdateProductNum = { [weak self] in
            if let strongSelf = self {
                strongSelf.selectIndexPath = indexPath
                strongSelf.popAddCarView(cellData)
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
            if let strongSelf = self {
                strongSelf.addNewBI_Record(cellData, indexPath.row + 1, 3)
                FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                    let controller = vc as! FKYNewShopItemViewController
                    controller.shopId = "\(cellData.supplyId)"
                    controller.shopType = "1"
                }, isModal: false)
            }
        }
        //跳转到店铺详情
        cell.clickShopContentArea = { [weak self] in
            if let strongSelf = self {
                strongSelf.selectIndexPath = indexPath
                strongSelf.addNewBI_Record(cellData, indexPath.row + 1, 4)
                FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                    let controller = vc as! FKYNewShopItemViewController
                    controller.shopId = "\(cellData.supplyId)"
                    controller.shopType = "2"
                }, isModal: false)
            }
        }
        //登录
        cell.loginClosure = {
            FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
        }
        
        // 商详
        cell.touchItem = {[weak self] in
            if let strongSelf = self {
                strongSelf.addNewBI_Record(cellData, indexPath.row + 1, 1)
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = cellData.spuCode
                    v.vendorId = "\(cellData.supplyId)"
                    v.updateCarNum = { (carId ,num) in
                        if let count = num {
                            cellData.carOfCount = count.intValue
                        }
                        if let getId = carId {
                            cellData.carId = getId.intValue
                        }
                    }
                }, isModal: false)
            }
        }
        
        return cell
    }
    
}


extension ArrivalProductNoticeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return ArrivalProductNoticeHeadCell.getCellContentHeight(self.viewModel.stockoutModel)
        }
        let cellData =  self.viewModel.dataSource[indexPath.row]
        let conutCellHeight = ProductInfoListCell.getCellContentHeight(cellData)
        return conutCellHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
extension ArrivalProductNoticeVC {
    //提交到货通知
    func sendArrivalNoticeRequest(){
        let result = self.viewModel.submitResult
        switch result {
        case .ok:
            self.viewModel.submit(handler: { (message, ret) in
                self.toast(message)
                if ret {
                    //提交成功返回
                    FKYNavigator.shared().pop()
                }
            })
        case let .empty(message):
            self.toast(message)
        case let .failed(message):
            self.toast(message)
        }
    }
    //获取推荐商品
    func getRecommendProductInfo(){
        showLoading()
        self.viewModel.getAllRecommondProductInfo(callback: { [weak self] in
            if let strongSelf = self {
                strongSelf.tableView.reloadData()
                if strongSelf.viewModel.dataSource.count == 0{
                    strongSelf.tableView.mj_footer.isHidden = true
                }else{
                    strongSelf.tableView.mj_footer.isHidden = false
                }
                strongSelf.refreshDismiss()
            }
        }) { [weak self] (msg) in
            if let strongSelf = self {
                strongSelf.refreshDismiss()
                strongSelf.toast(msg)
            }
        }
    }
    // 同步购物车商品数量
    fileprivate func getCartNumber() {
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ [weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.refreshAllProductTableView()
        }) { [weak self] (reason) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.toast(reason)
        }
    }
}
extension ArrivalProductNoticeVC {
    //埋点
    func addNewBI_Record(_ product: HomeCommonProductModel,_ itemtPosition:Int,_ type:Int) {
        var itemId : String?
        var itemName:String?
        var itemContent : String?
        if type == 1 {
            itemId = "I9998" //点击商品cell
            itemName = "点进商详"
        }else if type == 2 {
            itemId = "I9999" //加车
            itemName = "加车"
        } else if type == 3{
            itemId = "I9996" //点进JBP专区
            itemName = "点进JBP专区"
        }else{
            itemId = "I9997" //点进JBP专区
            itemName = "点进店铺"
        }
        
        if product.supplyId != 0 {
            itemContent = "\(product.supplyId)|\(product.spuCode)"
        }
        
        var extendParams:[String :AnyObject] = [:]
        extendParams["pm_price"] = product.pm_price as AnyObject?
        extendParams["storage"] = product.storage as AnyObject?
        extendParams["pm_pmtn_type"] = product.pm_pmtn_type as AnyObject?
        
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S8901", sectionPosition: "1", sectionName: "推荐商品", itemId: itemId, itemPosition: "\(itemtPosition)", itemName: itemName, itemContent:itemContent , itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    
}
