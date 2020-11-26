//
//  FKYTogeterBuyDetailViewController.swift
//  FKY
//
//  Created by hui on 2018/10/23.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYTogeterBuyDetailViewController: UIViewController {    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .grouped)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(FKYScrollViewCell.self, forCellReuseIdentifier: "FKYScrollViewCell")
        tableV.register(FKYTogeterPriceTabCell.self, forCellReuseIdentifier: "FKYTogeterPriceTabCell")
        tableV.register(PDSupplierCell.self, forCellReuseIdentifier: "PDSupplierCell")
        tableV.register(FKYTogeterTitleTabCell.self, forCellReuseIdentifier: "FKYTogeterTitleTabCell")
        tableV.register(FKYTogeterPrdIntrolCell.self, forCellReuseIdentifier: "FKYTogeterPrdIntrolCell")
        tableV.register(FKYTogeterFlowIntrolTabCell.self, forCellReuseIdentifier: "FKYTogeterFlowIntrolTabCell")
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    //底部工具栏
    fileprivate lazy var togeterBottomTool: FKYTogeterBottomView = {
        let view = FKYTogeterBottomView()
        view.isHidden = true
        //更新加车
        view.addCartBlock = { [weak self] in
            if let strongSelf = self {
                strongSelf.addBtnType = 0
                strongSelf.popAddCarView(strongSelf.detailModel)
            }
        }
        view.clickStatusBtn = { [weak self] (typeIndex) in
            if let strongSelf = self {
                if typeIndex == 0 {
                    // 登录
                    FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
                }else if typeIndex == 1  {
                    //立即购买
                    strongSelf.addBtnType = 1
                    strongSelf.popAddCarView(strongSelf.detailModel)
                }else if typeIndex == 2 {
                    //weakSelf?.popAlertAction()
                }
            }
            
        }
        return view
    }()
    //商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        let desY = WH(212.5)/2.0
        let desX = SCREEN_WIDTH/2.0
        let desRect = CGRect.init(x: desX, y: desY, width: WH(40), height: WH(40))
        //购物车相对屏幕坐标
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
                strongSelf.refreshTogeterBottomTool()
                //点击的是立即购买
                if strongSelf.addBtnType == 1 {
                    strongSelf.toSettleAccounts()
                    if let model = productModel as? FKYTogeterBuyDetailModel {
                        // 埋点
                        let itemContent =  (model.sellerId ?? "")+"|"+(model.spuCode ?? "")
                        let extendParams = ["storage":model.storage,"pm_price":model.pm_price,"pm_pmtn_type":model.pm_pmtn_type,"pageValue":model.spuCode]
                        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I5000", itemPosition: "0", itemName: "立即下单", itemContent: itemContent, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: strongSelf)
                    }
                }
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? FKYTogeterBuyDetailModel {
                    if strongSelf.addBtnType == 0 {
                        // 埋点<立即购买不埋加车的埋点>
                        let itemContent =  (model.sellerId ?? "")+"|"+(model.spuCode ?? "")
                        let extendParams = ["storage":model.storage,"pm_price":model.pm_price,"pm_pmtn_type":model.pm_pmtn_type,"pageValue":model.spuCode]
                        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue, itemPosition: "0", itemName: "加车", itemContent: itemContent, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: strongSelf)
                    }
                }
            }
        }
        return addView
    }()
    
    fileprivate lazy var bottomTipView : UIView = { [weak self] in
        let view = UIView()
        view.isHidden = true
        let topLine = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.5))
        topLine.backgroundColor = RGBColor(0xFFE1CC)
        view.addSubview(topLine)
        view.addSubview(self!.bottomTipLabel)
        self?.bottomTipLabel.snp.makeConstraints({ (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(topLine.snp.bottom)
        })
        return view
        }()
    
    fileprivate lazy var bottomTipLabel: UILabel = {
        let label = UILabel()
        label.font = t3.font
        label.textAlignment = .center
        label.textColor = RGBColor(0xE8772A)
        label.backgroundColor = RGBColor(0xFFFCF1)
        return label
    }()
    //请求失败
    fileprivate lazy var failedView : UIView = { [weak self] in
        let view = self!.showEmptyNoDataCustomView(self!.view, "no_shop_pic", GET_FAILED_TXT,false) { [weak self] in
            if let strongSelf = self {
                strongSelf.getTogeterBuyDetail()
            }
        }
        self!.isShowFaildView = true
        view.snp.remakeConstraints({ (make) in
            make.bottom.left.right.equalTo(self!.view)
            make.top.equalTo(self!.navBar!.snp.bottom)
        })
        return view
        }()
    fileprivate var desImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "image_default_img"))
        return imageView
    }()
    //请求类
    fileprivate lazy var togeterBuyProvider : FKYTogeterBuyProvider = {
        return FKYTogeterBuyProvider()
    }()
    var cartProvider : FKYYQGCartProvider = {
        return FKYYQGCartProvider()
    }()
    //三步加车一起购商品
    fileprivate var service: FKYCartService = {
        let service = FKYCartService()
        service.editing = false
        service.isTogeterBuyAddCar = true
        return service
    }()
    //
    fileprivate var shopProvider: ShopItemProvider = {
        return ShopItemProvider()
    }()
    
    //MARK: 控制器相关属性
    fileprivate var cartBadgeView : JSBadgeView?
    fileprivate var navBar: UIView?
    @objc var updateCarNum :((_ carId: Int, _ prdCount: Int)->())?
    @objc var typeIndex : String? //类型
    @objc var productId : String? //一起购商品id
    @objc var detailModel : FKYTogeterBuyDetailModel? //返回商品详情model
    fileprivate var timer: Timer!
    fileprivate var spaceTime : Int = 0//流失的时间
    fileprivate var isShowFaildView : Bool = false //
    fileprivate var addBtnType : Int = 0// 0:表示点击了加入购物车按钮；1:表示点击了立即购买按钮
    //MARK: 控制器生命周期
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weak var weakSelf = self
        //获取一起购购物车数量
        FKYVersionCheckService.shareInstance().syncTogeterBuyCartNumberSuccess({ (isSuccess) in
            weakSelf?.reloadViewWithBackFromCart()
            // 购物车badge
            weakSelf?.changeBadgeNumber(false)
            
        }) { (reason) in
            weakSelf?.toast(reason)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        
        self.setContentView()
        
        self.getTogeterBuyDetail()
        // 登录成功后刷新数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.getTogeterBuyDetail), name: NSNotification.Name.FKYLoginSuccess, object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        print("FKYTogeterBuyDetailViewController deinit~!@")
        self.dismissLoading()
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: 导航栏
    fileprivate func setupNavigationBar() {
        navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            }else{
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
            }()
        fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            FKYNavigator.shared().pop()
            if let strongSelf = self {
                if strongSelf.timer != nil {
                    strongSelf.timer.invalidate()
                    strongSelf.timer = nil
                    // 埋点
                    var pageValue = ""
                    if let model = strongSelf.detailModel,let spuCode = model.spuCode {
                        pageValue = spuCode
                    }
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "头部", itemId: ITEMCODE.TOGETER_BUY_HEADER_DETAIL_ITEM_CODE.rawValue, itemPosition: "1", itemName: "返回", itemContent: nil, itemTitle: nil, extendParams:["pageValue":pageValue] as [String : AnyObject], viewController: strongSelf)
                }
            }
            
        }
        fky_setupTitleLabel("商品详情")
        self.fky_hiddedBottomLine(false)
        self.navBar!.backgroundColor = bg1
        
        fky_setupRightImage("togeterCarRed") { [weak self] in
            if let strongSelf = self {
                // 埋点
                var pageValue = ""
                if let model = strongSelf.detailModel,let spuCode = model.spuCode {
                    pageValue = spuCode
                }
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "头部", itemId: ITEMCODE.TOGETER_BUY_HEADER_DETAIL_ITEM_CODE.rawValue, itemPosition: "2", itemName: "1起购购物车", itemContent: nil, itemTitle: nil, extendParams:["pageValue":pageValue] as [String : AnyObject], viewController: strongSelf)
                // (统一)购物车
                FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
                    let v = vc as! FKY_ShopCart
                    v.canBack = true
                    v.typeIndex = 1
                }, isModal: false)
            }
        }
        self.NavigationBarRightImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationBarLeftImage!)
            make.right.equalTo(self.navBar!).offset(-16)
        })
        self.NavigationBarLeftImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationTitleLabel!.snp.centerY)
            make.left.equalTo(self.navBar!.snp.left).offset(WH(12))
            make.height.width.equalTo(WH(30))
        })
        
        cartBadgeView = {
            let cbv = JSBadgeView.init(parentView: self.NavigationBarRightImage, alignment:JSBadgeViewAlignment.topRight)
            cbv?.badgePositionAdjustment = CGPoint(x: WH(-5), y: WH(12))
            cbv?.badgeTextFont = UIFont.systemFont(ofSize: WH(10))
            cbv?.badgeBackgroundColor = RGBColor(0xFF2D5C)
            return cbv
        }()
        FKYNavigator.shared().topNavigationController.dragBackDelegate = self
    }
    
    //MARK: 内容ui
    fileprivate func setContentView() {
        self.view.backgroundColor = tableView.backgroundColor
        var bottomViewH = WH(64)
        bottomViewH = bottomViewH + bootSaveHeight()
        self.view.addSubview(self.togeterBottomTool)
        togeterBottomTool.snp.makeConstraints({ (make) in
            make.left.bottom.right.equalTo(self.view)
            make.height.equalTo(bottomViewH)
        })
        self.view.addSubview(self.bottomTipView)
        bottomTipView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(WH(32))
            make.bottom.equalTo(self.togeterBottomTool.snp.top)
        })
        self.view.layoutIfNeeded()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.navBar!.snp.bottom)
            make.bottom.equalTo(self.bottomTipView.snp.top)
        })
        if self.typeIndex == "0" {
            bottomTipView.snp.updateConstraints { (make) in
                make.height.equalTo(WH(0))
            }
        }
    }
}

//MARK:数据请求
extension FKYTogeterBuyDetailViewController {
    //请求接口
    @objc func getTogeterBuyDetail() {
        self.showLoading()
        self.togeterBuyProvider.getTogeterBuyDetailData(["id" : self.productId as AnyObject,"enterpriseId" : FKYLoginAPI.loginStatus() == .unlogin ? "" as AnyObject : FKYLoginAPI.currentEnterpriseid() as AnyObject,"buyerid" : FKYLoginAPI.loginStatus() == .unlogin ? "" as AnyObject : FKYLoginAPI.currentUserId() as AnyObject], callback: { [weak self] (model, message) in
            if let strongSelf = self {
                strongSelf.dismissLoading()
                if model != nil {
                    strongSelf.detailModel = model
                    strongSelf.refreshTogeterViewData()
                    if strongSelf.isShowFaildView == true {
                        strongSelf.failedView.isHidden = true
                    }
                }else {
                    strongSelf.toast(message)
                    strongSelf.failedView.isHidden = false
                }
            }
        })
    }
    //刷新界面
    func refreshTogeterViewData() {
        self.spaceTime = 0
        self.tableView.reloadData()
        self.togeterBottomTool.isHidden = false
        self.calculatetLoseTime()
        self.reloadViewWithBackFromCart()
        if self.detailModel?.projectStatus == 0  {
            if let limitNum = self.detailModel?.surplusNum{
                //活动正常
                self.bottomTipView.isHidden = false
                self.bottomTipView.snp.updateConstraints({ (make) in
                    make.height.equalTo(WH(32))
                })
                //对比库存和限购数量
                var maxNum : Int = 0
                let stockCount : Int = (self.detailModel?.currentInventory)!
                if limitNum > -1 {
                    if (stockCount < limitNum) {
                        maxNum = stockCount
                    }else{
                        maxNum = limitNum
                    }
                }else {
                    maxNum = stockCount
                }
                if limitNum == 0 {
                    let unitStr = self.detailModel?.unit ?? ""
                    self.bottomTipLabel.text = String.init(format: "%d%@为一个购买单位，已达最大购买数量", self.detailModel?.projectUnit ?? 1,unitStr)
                }else {
                    let unitStr = self.detailModel?.unit ?? ""
                    self.bottomTipLabel.text = String.init(format: "%d%@为一个购买单位，最多认购%d%@", self.detailModel?.projectUnit ?? 1,unitStr,maxNum,unitStr)
                }
            }else {
                self.bottomTipView.isHidden = true
                self.bottomTipView.snp.updateConstraints({ (make) in
                    make.height.equalTo(WH(0))
                })
            }
        }else {
            self.bottomTipView.isHidden = true
            self.bottomTipView.snp.updateConstraints({ (make) in
                make.height.equalTo(WH(0))
            })
        }
    }
    //计算流失的时间
    func calculatetLoseTime() {
        if timer != nil {
            timer.invalidate()
            timer = nil
            self.spaceTime = 0
        }
        // 启动timer...<1.s后启动>
        let date = NSDate.init(timeIntervalSinceNow: 1.0)
        timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(calculateCount), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    @objc func calculateCount() {
        self.spaceTime = self.spaceTime+1
    }
}
extension FKYTogeterBuyDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return WH(212.5)
        }else if indexPath.row == 1 {
            return WH(45)
        }else if indexPath.row == 2 {
            return  FKYTogeterTitleTabCell.configCellHeight(self.detailModel)
        }else if indexPath.row == 3 {
            if let model = self.detailModel {
                //有批准文号则显示，否则隐藏
                if let approvaStr = model.approvalNum ,approvaStr.count > 0 {
                    return WH(145)
                }
                return WH(127)
            }
            return WH(0.0001)
        }else {
            return WH(41)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return WH(10)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = RGBColor(0xf4f4f4)
        return view
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = RGBColor(0xf4f4f4)
        return view
    }
}

extension FKYTogeterBuyDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.detailModel != nil {
            return 1
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            //轮播图
            let cell: FKYScrollViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYScrollViewCell", for: indexPath) as! FKYScrollViewCell
            cell.selectionStyle = .none
            if let imgStr = self.detailModel?.appDetailAdImg {
                cell.configCell([imgStr])
                if let strProductPicUrl = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl){
                    self.desImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
                }
            }
            cell.clickDetailPicBlock = { [weak self] in
                if let strongSelf = self {
                    // 埋点
                    var pageValue = ""
                    if let model = strongSelf.detailModel,let spuCode = model.spuCode {
                        pageValue = spuCode
                    }
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.TOGETER_BUY_PIC_DETAIL_ITEM_CODE.rawValue, itemPosition: "1", itemName: "查看商品大图", itemContent: nil, itemTitle: nil, extendParams:["pageValue":pageValue] as [String : AnyObject], viewController: strongSelf)
                }
            }
            return cell
        }else if indexPath.row == 1 {
            //价格倒计时栏
            let cell: FKYTogeterPriceTabCell = tableView.dequeueReusableCell(withIdentifier: "FKYTogeterPriceTabCell", for: indexPath) as! FKYTogeterPriceTabCell
            cell.selectionStyle = .none
            if let model = self.detailModel {
                cell.configCell(model, self.spaceTime)
            }
            //倒计时到了
            cell.refreshDataForTimeOver = { [weak self] type in
                if let strongSelf = self {
                    if type == 1 {
                        //活动从未开始到开始
                        strongSelf.detailModel?.projectStatus = 0
                    }else if type == 2 {
                        //活动从开始到结束
                        strongSelf.detailModel?.projectStatus = 4
                    }
                    strongSelf.tableView.reloadRows(at: [indexPath], with: .none)
                    strongSelf.togeterBottomTool.configViewData(strongSelf.detailModel)
                }
                
            }
            return cell
        }else if indexPath.row == 2 {
            //商品标题
            let cell: FKYTogeterTitleTabCell = tableView.dequeueReusableCell(withIdentifier: "FKYTogeterTitleTabCell", for: indexPath) as! FKYTogeterTitleTabCell
            cell.selectionStyle = .none
            if let model = self.detailModel {
                cell.configCell(model)
            }
            return cell
        }else if indexPath.row == 3 {
            //商品规格信息
            let cell: FKYTogeterPrdIntrolCell = tableView.dequeueReusableCell(withIdentifier: "FKYTogeterPrdIntrolCell", for: indexPath) as! FKYTogeterPrdIntrolCell
            cell.selectionStyle = .none
            if let model = self.detailModel {
                cell.configCell(model)
            }
            return cell
        }else {
            //店铺
            let cell: PDSupplierCell = tableView.dequeueReusableCell(withIdentifier: "PDSupplierCell", for: indexPath) as! PDSupplierCell
            cell.selectionStyle = .none
            cell.configCell(self.detailModel?.enterpriseName)
            cell.gotoShop = {[weak self] in
                // 埋点
                var pageValue = ""
                if let model = self?.detailModel,let spuCode = model.spuCode {
                    pageValue = spuCode
                }
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.TOGETER_BUY_SHOP_DETAIL_ITEM_CODE.rawValue, itemPosition: "1", itemName: "进入店铺", itemContent: nil, itemTitle: nil, extendParams:["pageValue":pageValue] as [String : AnyObject], viewController: self)
                
                FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { [weak self] (vc) in
                    if let strongSelf = self {
                        let controller = vc as! FKYNewShopItemViewController
                        if let shopId = strongSelf.detailModel?.sellerId, shopId.isEmpty == false {
                            // 店铺id
                            controller.shopId = shopId
                        }
                        else {
                            controller.shopId = ""
                        }
                    }
                    }, isModal: false)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FKYTogeterBuyDetailViewController {
    func reloadViewWithBackFromCart() {
        if let product = self.detailModel {
            if FKYCartModel.shareInstance().togeterBuyProductArr.count > 0 {
                for cartModel  in FKYCartModel.shareInstance().togeterBuyProductArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.promotionId != nil && cartOfInfoModel.spuCode as String == product.spuCode! && cartOfInfoModel.supplyId.intValue == Int(product.sellerId!) && cartOfInfoModel.promotionId.intValue == Int(product.buyTogetherId ?? "0") {
                            product.carOfCount = cartOfInfoModel.buyNum.intValue
                            product.carId = cartOfInfoModel.cartId.intValue
                            break
                        }else{
                            product.carOfCount = 0
                            product.carId = 0
                        }
                    }
                }
            }else {
                product.carOfCount = 0
                product.carId = 0
            }            
            self.togeterBottomTool.configViewData(self.detailModel)
        }
    }
    
    //刷新加车器
    func refreshTogeterBottomTool () {
        self.togeterBottomTool.configViewData(self.detailModel)
    }
    
    //弹出加车框
    fileprivate func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = HomeString.YQG_PRD_DET_ADD_SOURCE_TYPE
        self.addCarView.addBtnType = self.addBtnType
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
    //更新一起购购物车显示数量
    func changeBadgeNumber(_ isdelay : Bool) {
        var deadline :DispatchTime
        if  isdelay {
            deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        }else {
            deadline = DispatchTime.now()
        }
        
        DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
            DispatchQueue.main.async {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.cartBadgeView!.badgeText = {
                    let count = FKYCartModel.shareInstance().togeterBuyProductCount
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
    
    //埋点
    func addBI_Record( _ typeIndex : Int , _ selectNum : Int) {
        if typeIndex == 0 {
            //购物车
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I710\(typeIndex)", itemPosition: "\(selectNum)", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        }else if typeIndex == 1 {
            //+/完成/立即购买
            let contentStr = (self.detailModel?.sellerId ?? "") + (self.detailModel?.spuCode ?? "")
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I9999", itemPosition: "\(selectNum)", itemName: nil, itemContent: contentStr, itemTitle: nil, extendParams: nil, viewController: self)
        }
    }
    
    func toSettleAccounts() {
        if self.detailModel?.carOfCount == 0 {
            //self.toast("您还没有添加商品哟");
            return;
        }
        self.showLoading()
        var jsonParam = [Any]()
        let productInfo:FKYCartGroupInfoModel =  FKYCartGroupInfoModel()
        productInfo.productCount =  NSNumber(value:(self.detailModel?.carOfCount)!)
        productInfo.productPrice = NSNumber(value:(self.detailModel?.subscribePrice)!) //self.detailModel?.subscribePrice as! NSNumber
        productInfo.productName =  self.detailModel?.productName
        
        productInfo.promotionId = self.productId?.toNSNumber()
        //productInfo.productCodeCompany = self.detailModel?.productcodeCompany?.toNSNumber()
        productInfo.productCodeCompany = self.detailModel?.productcodeCompany
        jsonParam.append(productInfo)
        
        FKYNavigator.shared().openScheme(FKY_CheckOrder.self, setProperty: { (svc) in
            let controller = svc as! CheckOrderController
            controller.productArray = jsonParam
            controller.fromWhere  = 1 // 一起购之立即认购
        }, isModal: false, animated: true)
    }
}

//MARK: - Share
//extension FKYTogeterBuyDetailViewController {
//    // 创建分享页面
//    func createShareView() -> () {
//        self.view.addSubview(self.shareView)
//        self.shareView.snp.makeConstraints({ (make) in
//            make.edges.equalTo(self.view)
//        })
//
//        shareView.WeChatShareClourse = { () in
//            self.WXShare()
//        }
//        shareView.WeChatFriendShareClourse = { () in
//            self.WXFriendShare()
//        }
//        shareView.QQShareClourse = { () in
//            self.QQShare()
//        }
//        shareView.QQZoneShareClourse = { () in
//            self.QQZoneShare()
//        }
//        shareView.SinaShareClourse = { () in
//            self.SinaShare()
//        }
//    }
//
//    //MARK: - Share
//    func shareUrl() -> String {
//        return String.init(format: "https://m.yaoex.com/product.html?enterpriseId=%@&productId=%@", self.detailModel?.sellerId ?? "",self.detailModel?.productId ?? "")
//    }
//
//    func shareImage() -> String {
//        return self.detailModel?.appChannelAdImg ?? ""
//    }
//
//    func shareMessage() -> String {
//        return String.init(format: "%@%@",self.detailModel?.enterpriseName ?? "",self.detailModel?.spec ?? "" )
//    }
//
//    func WXShare() -> () {
//        let url = self.shareUrl()
//        FKYShareManage.shareToWX(withOpenUrl: url, andMessage: self.shareMessage(), andImage: self.shareImage())
//        self.BI_Record(.MAINSTORE_YC_SHARE_WECHAT)
//    }
//
//    func WXFriendShare() -> () {
//        let url = self.shareUrl()
//        FKYShareManage.shareToWXFriend(withOpenUrl: url, andMessage: self.shareMessage(), andImage: self.shareImage())
//        self.BI_Record(.MAINSTORE_YC_SHARE_MOMENTS)
//    }
//
//    func QQShare() -> () {
//        let url = self.shareUrl()
//        FKYShareManage.shareToQQ(withOpenUrl: url, andMessage: self.shareMessage(), andImage: self.shareImage())
//        self.BI_Record(.MAINSTORE_YC_SHARE_QQ)
//    }
//
//    func QQZoneShare() -> () {
//        let url = self.shareUrl()
//        FKYShareManage.shareToQQZone(withOpenUrl: url, andMessage: self.shareMessage(), andImage: self.shareImage())
//        self.BI_Record(.MAINSTORE_YC_SHARE_QZONE)
//    }
//
//    func SinaShare() -> () {
//        let url = self.shareUrl()
//        FKYShareManage.shareToSina(withOpenUrl: url, andMessage: self.shareMessage(), andImage: self.shareImage())
//        self.BI_Record(.MAINSTORE_YC_SHARE_WEIBO)
//    }
//}
extension FKYTogeterBuyDetailViewController : FKYNavigationControllerDragBackDelegate {
    func dragBackShouldStart(in navigationController: FKYNavigationController!) -> Bool {
        return false
    }
}
extension FKYTogeterBuyDetailViewController {
    func popAlertAction() {
        let alert = UIAlertController(title: nil, message: "您可以去电脑上完善资质，认证成功即可购买！", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "知道啦", style: UIAlertAction.Style.default, handler: { (action) in
        })
        action.setValue(RGBColor(0xFE5050), forKey: "titleTextColor")
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
