//
//  FKYRedPacketViewController.swift
//  FKY
//
//  Created by hui on 2019/1/16.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYRedPacketViewController: ViewController {
    fileprivate lazy var redPacketTab: FKYRecognizeSimultaneousTab = { [weak self] in
        var tableView = FKYRecognizeSimultaneousTab(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.backgroundColor = ColorConfig.colorf4f4f4
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = SCREEN_HEIGHT
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableFooterView = UIView.init(frame: .zero)
        
        tableView.register(FKYGetCouponTableViewCell.self, forCellReuseIdentifier: "FKYGetCouponTableViewCell")
        tableView.register(FKYNotCouponTableViewCell.self, forCellReuseIdentifier: "FKYNotCouponTableViewCell")
        //常购清单
        tableView.register(HomeOftenBuyCell.self, forCellReuseIdentifier: "ReaPacketCell")
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
        }()
    
    //商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        addView.finishPoint = CGPoint(x: SCREEN_WIDTH-16-self.NavigationBarRightImage!.frame.size.width/2.0, y: self.NavigationBarRightImage!.frame.origin.y+self.NavigationBarRightImage!.frame.size.height/2.0)
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
               strongSelf.redPacketTab.reloadData()
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? OftenBuyProductItemModel {
                   strongSelf.addBIRecordForProductPositon(strongSelf.selectedRow,model)
                }
            }
        }
        return addView
    }()
    
    //fileprivate var navBar: UIView?
    fileprivate var cartBadgeView : JSBadgeView?
    
    // 查询资质状态
    fileprivate var serviceZz = CredentialsBaseInfoProvider()
    //请求常购清单工具类
    fileprivate var viewOftenModel: FKYOftenBuyViewModel = {
        let vm = FKYOftenBuyViewModel()
        return vm
    }()
    var isAudit = false//判断资质是否通过（true为通过了）
    
    //MARK ：处理滑动相关
    fileprivate var canScroll  = false
    fileprivate var isTopCanNotMoveTableView  = false
    fileprivate var isTopCanNotMoveTableViewPre  = false
    fileprivate var isFirstFresh = true //第一次请求常购清单
    fileprivate var redPacketTabOffsetY :CGFloat = 0.0 //记录滑动的位子
    fileprivate var selectedRow = 0 //记录加车点击的位置
    
    @objc var redPacketModel : RedPacketDetailInfoModel? //红包数据模型（从上个界面传入）
    
    //MARK: 控制器生命周期
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CurrentViewController.shared.item = self
        UIApplication.shared.statusBarStyle = .lightContent
        if FKYLoginAPI.loginStatus() != .unlogin && self.isAudit == true,self.viewOftenModel.titleArr.count > 0{
            //每次进入界面只有显示了常购清单才获取购物车数量
            self.refreshCarNum()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setContentView()
        //登录后请求常购清单相关
        if FKYLoginAPI.loginStatus() != .unlogin {
            self.getUserZzStatus(false)//每次进入界面获取状态
        }
        NotificationCenter.default.addObserver(self, selector: #selector(FKYRedPacketViewController.acceptMes(_:)), name: NSNotification.Name(rawValue: TABLELEAVETOP), object: nil)
        self.changeBadgeNumber(false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        }
        CurrentViewController.shared.item = self
    }
    deinit {
        print("FKYRedPacketViewController deinit~!@")
        self.dismissLoading()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func acceptMes(_ nty: Notification) {
        let dic = nty.userInfo
        if let canScroll = dic?["canScroll"] as? String , canScroll == "1", let tagStr = dic?["tag"] as? String,"2" == tagStr {
            self.canScroll = true
        }
    }
}
// MARK:ui相关
extension FKYRedPacketViewController {
    //MARK: 导航栏
    fileprivate func setupNavigationBar() {
        navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            }else{
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
        }()
        fky_setupLeftImage("togeterBack") { [weak self] in
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "领到红包", itemId: "I6201", itemPosition: "1", itemName: "返回", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
           // FKYNavigator.shared().pop()
        }
        fky_setupTitleLabel("药城红包")
        NavigationTitleLabel?.textColor = RGBColor(0xFFFFFF)
        self.NavigationBarLeftImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationTitleLabel!.snp.centerY)
            make.left.equalTo(self.navBar!.snp.left).offset(WH(12))
            make.height.width.equalTo(WH(30))
        })
        //weak var weakself = self
        fky_setupRightImage("combo_car_white") {
            FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
                let v = vc as! FKY_ShopCart
                v.canBack = true
            }, isModal: false)
        }
        self.NavigationBarRightImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationBarLeftImage!)
            make.right.equalTo(self.navBar!).offset(-16)
        })
        
        cartBadgeView = { [weak self] in
            let cbv = JSBadgeView.init(parentView: self!.NavigationBarRightImage, alignment:JSBadgeViewAlignment.topRight)
            cbv?.badgePositionAdjustment = CGPoint(x: WH(-3), y: WH(3))
            cbv?.badgeTextFont = UIFont.systemFont(ofSize: WH(10))
            cbv?.badgeTextColor = RGBColor(0xFF2D5C)
            cbv?.badgeBackgroundColor = RGBColor(0xFFFFFF)
            return cbv
        }()
        self.navBar?.backgroundColor = RGBColor(0xFF2D5C)
        self.view.backgroundColor = RGBColor(0xf5f5f5)
    }
    
    //MARK: 内容ui
    fileprivate func setContentView() {
        self.view.addSubview(redPacketTab)
        redPacketTab.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.navBar!.snp.bottom)
        }
    }
}
extension FKYRedPacketViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        //登录并且资质认证通过有数据才显示常购清单44
        if FKYLoginAPI.loginStatus() != .unlogin && self.isAudit == true,self.viewOftenModel.titleArr.count > 0 {
            return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let model = self.redPacketModel {
                if model.status == "1" {
                    
                    if model.showshopName == true {
                        return WH(127) + model.shopNameH - WH(12)
                    }else {
                        return WH(127)
                    }
                } else if model.status == "2" {
                    //优惠券被抢完（未中奖）
                    return WH(213)
                }else {
                    return WH(213)
                }
            }else {
                return WH(213)
            }
        }else {
            return SCREEN_HEIGHT-naviBarHeight()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if self.redPacketModel?.status == "1" {
                let cell: FKYGetCouponTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYGetCouponTableViewCell", for: indexPath) as! FKYGetCouponTableViewCell
                if let model = self.redPacketModel {
                    cell.configCell(model)
                    cell.showShopNames = { [weak self] in
                        if let strongSelf = self {
                            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "领到红包", itemId: "I6203", itemPosition: "0", itemName: "查看可用商家", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
                            model.showshopName = !model.showshopName
                            strongSelf.redPacketTab.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
                return cell
            }else {
                //无优惠券
                let cell: FKYNotCouponTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYNotCouponTableViewCell", for: indexPath) as! FKYNotCouponTableViewCell
                if let model = self.redPacketModel {
                    cell.configCell(model)
                }
                return cell
            }
        }else {
            // 常购清单楼层
            let cell: HomeOftenBuyCell = tableView.dequeueReusableCell(withIdentifier: "ReaPacketCell", for: indexPath) as! HomeOftenBuyCell
            cell.selectionStyle = .none
            cell.configCellData(viewOftenModel,self.isFirstFresh,2)
            self.isFirstFresh = false
            //加载更多
            cell.getTypeMoreData = { [weak self] type in
                if let strongSelf = self {
                    strongSelf.getData()
                }
            }
            //获取当前的type
            cell.getCurrentType = { [weak self] type in
                if let strongSelf = self {
                    strongSelf.viewOftenModel.currentType = type
                    //请求全部商品逻辑
                    if strongSelf.viewOftenModel.currentModel.isFirstLoad == true {
                        strongSelf.viewOftenModel.currentModel.isFirstLoad  = false
                        strongSelf.redPacketTab.reloadData()
                    }
                }
                
            }
            //回到顶部
            cell.goAllTableTop = { [weak self] in
                DispatchQueue.main.async {
                    if let strongSelf = self {
                        strongSelf.isTopCanNotMoveTableView = false
                        strongSelf.isTopCanNotMoveTableViewPre = false
                        strongSelf.canScroll = false
                        strongSelf.redPacketTab.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                        strongSelf.redPacketTab.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .bottom, animated: false)
                    }
                }
            }
            //点击加入购物车按钮
            cell.updateCarNumView = { [weak self] (productModel,selectedNum) in
                if let strongSelf = self {
                    strongSelf.selectedRow = selectedNum
                    strongSelf.popAddCarView(productModel)
                }
            }
            return cell
        }
    }
}
// MARK: - UIScrollViewDelegate
extension FKYRedPacketViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.redPacketTab else {
            return
        }
        //处理滑动冲突
        if  self.redPacketTab.numberOfSections > 1 {
            self.redPacketTabOffsetY = scrollView.contentOffset.y
            let tableViewOffsetY = self.redPacketTab.rect(forSection: 1).origin.y
            let contentOffsetY = scrollView.contentOffset.y
            self.isTopCanNotMoveTableViewPre = self.isTopCanNotMoveTableView
            if Int(contentOffsetY) >= Int(tableViewOffsetY)  {
                scrollView.setContentOffset(CGPoint.init(x: 0, y: tableViewOffsetY), animated: false)
                self.isTopCanNotMoveTableView = true
            }else {
                self.isTopCanNotMoveTableView = false
            }
            if self.isTopCanNotMoveTableViewPre != self.isTopCanNotMoveTableView {
                if self.isTopCanNotMoveTableView == true && self.isTopCanNotMoveTableViewPre == false {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:TABLETOP), object: nil, userInfo: ["canScroll":"1","tag":"2"])
                    self.canScroll = false
                }
                if self.isTopCanNotMoveTableViewPre == true && self.isTopCanNotMoveTableView == false {
                    if self.canScroll == false {
                        scrollView.setContentOffset(CGPoint.init(x: 0, y: tableViewOffsetY), animated: false)
                    }
                }
            }
        }
    }
}
extension FKYRedPacketViewController {
    //常购清单第一页数据（包含三个tab）
    func firstGetData() {
        if FKYLoginAPI.loginStatus() != .unlogin && self.isAudit == true {
            //请求全部商品逻辑
            self.isFirstFresh = true
            self.redPacketTab.reloadData()
            self.viewOftenModel.requestProductList(success: { [weak self] (model) in
                if let strongSelf = self {
                    strongSelf.viewOftenModel.resetIsFirstLoad()
                    strongSelf.redPacketTab.reloadData()
                }
            }) { [weak self] (errMsg) in
                if let strongSelf = self {
                    strongSelf.redPacketTab.reloadData()
                }
            }
        }
    }
    //MARK: - Request 常购清单加载更多
    func getData(_ isShowLoading: Bool = false) -> () {
        if isShowLoading {
            self.showLoading()
        }
        self.viewOftenModel.getData(callback: { [weak self] in
            if let strongSelf = self {
                strongSelf.viewOftenModel.currentModel.page += 1
                strongSelf.dismissLoading()
                strongSelf.redPacketTab.reloadData()
            }
        }) { [weak self] (msg) in
            if let strongSelf = self {
                strongSelf.dismissLoading()
                strongSelf.redPacketTab.reloadData()
                strongSelf.toast(msg)
            }
        }
    }
    func getUserZzStatus(_ isLoginChange:Bool) {
        //登录状态改变的时候重置滑动相关的属性
        if isLoginChange == true {
            self.isTopCanNotMoveTableView = false
            self.isTopCanNotMoveTableViewPre = false
            self.canScroll = false
            self.isAudit = false
            self.viewOftenModel.currentIndex = 0
            self.viewOftenModel.resetModels()
            self.redPacketTab.reloadData()
        }
        serviceZz.zzStatus { [weak self] (status) in
            if let strongSelf = self {
                switch status {
                case 1,3,4,6: // 资质审核通过
                    if strongSelf.isAudit == false {
                        strongSelf.isAudit = true
                        strongSelf.firstGetData()
                    }
                case -1,11,12,13,14: // 资质未提交审核
                    strongSelf.isAudit = false
                case 2,7: // 资质提交审核未通过
                    strongSelf.isAudit = false
                case 0,5: // 资质提交审核中
                    strongSelf.isAudit = false
                default:
                    break
                }
            }
        }
    }
    //获取购物车数量后刷新常购清单
    func refreshCarNum() {
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ [weak self] (isSuccess) in
            if let strongSelf = self {
                strongSelf.changeBadgeNumber(false)
                strongSelf.redPacketTab.reloadData()
            }
        }) { [weak self] (reason) in
            if let strongSelf = self {
               strongSelf.toast(reason)
            }
        }
    }
}
extension FKYRedPacketViewController {
    //更新购物车显示数量
    func changeBadgeNumber(_ isdelay : Bool) {
        var deadline :DispatchTime
        if  isdelay {
            deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        }else {
            deadline = DispatchTime.now()
        }
        
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    strongSelf.cartBadgeView!.badgeText = {
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
        let sourceType = self.getTypeSourceStr()
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
    //设置加车的来源
    func getTypeSourceStr() -> String{
        if self.viewOftenModel.currentType == .oftenLook {
            return HomeString.REDPACKET_OFTENLOOK_ADD_SOURCE_TYPE
        }else if self.viewOftenModel.currentType == .hotSale {
            return HomeString.REDPACKET_HOTSALE_ADD_SOURCE_TYPE
        }else {
            return HomeString.REDPACKET_OFTENBUY_ADD_SOURCE_TYPE
        }
    }
    // 商品位置埋点
    fileprivate func addBIRecordForProductPositon(_ row: Int, _ product: OftenBuyProductItemModel) {
        let contentStr = "\(product.supplyId!)"+"/"+product.spuCode!
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : product.pm_pmtn_type! as AnyObject]
        switch self.viewOftenModel.currentType {
        case .oftenBuy?: // 常买
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F1001", floorPosition: "1", floorName: "常购清单", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I9999", itemPosition: "\(row+1)", itemName: "加车", itemContent: contentStr, itemTitle: product.sourceFrom ?? "", extendParams: extendParams, viewController: self)
        case .oftenLook?: // 常看
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F1001", floorPosition: "2", floorName: "常看", sectionId:  nil, sectionPosition: nil, sectionName: nil, itemId: "I9999", itemPosition: "\(row+1)", itemName: "加车", itemContent: contentStr, itemTitle: product.sourceFrom ?? "", extendParams: extendParams, viewController: self)
        case .hotSale?: // 热销
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F1001", floorPosition: "3", floorName:"当地热销", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I9999", itemPosition: "\(row+1)", itemName: "加车", itemContent: contentStr, itemTitle: product.sourceFrom ?? "", extendParams: extendParams, viewController: self)
        default:
            break
        }
    }
}
