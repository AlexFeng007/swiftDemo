//
//  HomeMainOftenBuyController.swift
//  FKY
//
//  Created by 寒山 on 2019/3/19.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  新首页 B方面界面

import UIKit

let SURPRISE_TIP_H = WH(42)

class HomeMainOftenBuyController: UIViewController {
    var lastTimeInterval:TimeInterval = 0.0  //防止通知重复刷新
    fileprivate var isFirstRefresh : Bool = true //第一次加载
    fileprivate var seletedIndex :IndexPath? //记录加车点击的那个区域
    // MARK:搜索框高度
    let  serachbar_height  =  naviBarHeight() + WH(11)
    //viewmodel
    fileprivate lazy var presenter: HomePresenter = HomePresenter()
    fileprivate var viewModel: NewHomeViewModel = {
        let vm = NewHomeViewModel()
        return vm
    }()
    // MARK:购物车和购物数量相关操作
    fileprivate var service: FKYCartService = {
        let service = FKYCartService()
        service.editing = false
        return service
    }()
    // MARK:单品加车的类
    fileprivate var shopProvider: ShopItemProvider = {
        return ShopItemProvider()
    }()
    // MARK:获取未读消息请求类
    fileprivate lazy var messageListProvider : FKYMessageProvider = {
        return FKYMessageProvider()
    }()
    // 视图类型
    // MARK: - 搜索bar
    fileprivate lazy var searchBar: HomeSearchBar = {
        let bar = HomeSearchBar()
        bar.operation = self
        bar.containsLeftButtonLayout()
        return bar
    }()
    // MARK: - 常搜关键词
    fileprivate lazy var keyWordView: HomeSearchKeyListView = {
        let view = HomeSearchKeyListView()
        view.clickHotItem = {[weak self] index in
            if let strongSelf = self{
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_HOT_SEARCH_WORD_CODE.rawValue, itemPosition: "\(index+1)", itemName: "热搜词", itemContent: nil, itemTitle: nil, extendParams: nil, viewController:strongSelf)
            }
            
        }
        view.isHidden = true
        return view
    }()
    // MARK:请求失败空视图
    fileprivate lazy var failedView : UIView = {
        weak var weakSelf = self
        let view = self.showEmptyNoDataCustomView(self.view, "no_shop_pic", GET_FAILED_TXT,false) {
            weakSelf?.requestFirstHomePage(true)
        }
        view.snp.remakeConstraints({ (make) in
            make.bottom.left.right.equalTo(self.view)
            make.top.equalTo(self.searchBar.snp.bottom)
        })
        return view
    }()
    // MARK:置顶按钮
    fileprivate lazy var topButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "btn_back_top"), for: .normal)
        btn.isHidden = true
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self]  (_) in
            guard let strongSelf = self else {
                return
            }
            btn.isHidden = true
            strongSelf.resetTableViewOffsetY()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    // MARK:tableview
    public lazy var tableView: UITableView = { [weak self] in
        var tableView = UITableView(frame: CGRect.null, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = bg2
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(ProductInfoListCell.self, forCellReuseIdentifier: "ProductInfoListCell")
        tableView.register(HomePromotionStyleCell.self, forCellReuseIdentifier: "HomePromotionStyleCell")
        tableView.register(HomePromotionNewTableViewCell.self, forCellReuseIdentifier: "HomePromotionNewTableViewCell")
        tableView.register(HomeBannerListCell.self, forCellReuseIdentifier: "HomeBannerListCell")
        tableView.register(HomeFucListCell.self, forCellReuseIdentifier: "HomeFucListCell")
        tableView.register(HomePublicNoticeCell.self, forCellReuseIdentifier: "HomePublicNoticeCell")
        tableView.register(HomeOneAdPageCell.self, forCellReuseIdentifier: "HomeOneAdPageCell")
        tableView.register(HomeTwoAdPageCell.self, forCellReuseIdentifier: "HomeTwoAdPageCell")
        tableView.register(HomeThreeAdPageCell.self, forCellReuseIdentifier: "HomeThreeAdPageCell")
        tableView.register(HomeSingleProductIntroCell.self, forCellReuseIdentifier: "HomeSingleProductIntroCell")
        // tableView.register(HomeSingleProductIntroCell.self, forCellReuseIdentifier: "HomeSingleProductIntroCell")
        tableView.register(HomeHotSellFloorCell.self, forCellReuseIdentifier: "HomeHotSellFloorCell")
        tableView.register(HomeSecKillRecommCell.self, forCellReuseIdentifier: "HomeSecKillRecommCell")
        //我的推荐商品title
        tableView.register(FKYRecommendTitleTableViewCell.self, forCellReuseIdentifier: "FKYHomeRecommendTitleTableViewCell")
        //我的推荐商品
        tableView.register(FKYHomeSuggestTableViewCell.self, forCellReuseIdentifier: "FKYHomeSuggestTableViewCell")
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
    // MARK:刷新控件
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            //下拉刷新
            if let strongSelf = self {
                strongSelf.requestFirstHomePage(true)
                strongSelf.requestUnreadMsgCount()
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
                //if strongSelf.viewModel.nextPageId == 3 {
                strongSelf.getRecommendForYouPrdList(false)
                //}
            }
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        footer!.backgroundColor = bg2
        return footer!
    }()
    
    // MARK:商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        //更改购物车数量
        addView.addCarSuccess = { [weak self] (isSuccess,type,productNum,productModel) in
            if let strongSelf = self {
                if isSuccess == true {
                    if type == 1 {
                        
                    }else if type == 3 {
                        
                    }
                }
                strongSelf.refreshDataBackFromCar()
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? HomeCommonProductModel {
                    //strongSelf.addCarBI_Record(model)
                    
                }
            }
        }
        return addView
    }()
    // MARK:惊喜视图
    fileprivate lazy var surpriseTipView : FKYTipSurpriseView = {
        let view = FKYTipSurpriseView()
        view.isHidden = true
        view.clickTipView = { [weak self] typeNum in
            guard let strongSelf = self else {
                return
            }
            if typeNum == 1 {
                //去惊喜页面
                FKYNavigator.shared().openScheme(FKY_Send_Coupon_Info.self, setProperty: { (vc) in
                    //
                })
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "底部资源位", itemId: ITEMCODE.HOME_ACTION_SUPRISE_EIXT.rawValue, itemPosition: "1", itemName: "点进资源位", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            }
            strongSelf.updateTipView(true, nil)
        }
        return view
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        FKYTimerManager.timerManagerShared.stopTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //获取消息盒子
        self.getNoReadMessageCount()
        //刷新购物车数量
        self.refreshCartNum()
        self.getSurpriseTipStrView()
        // 刷新未读消息数量
        self.requestUnreadMsgCount()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化UI
        self.steupUI()
        //获取缓存数据
        self.loadCacheData()
        //获取数据
        self.requestFirstHomePage(true)
        // 首页秒杀一起购楼层倒计时结束时需刷新数据
        NotificationCenter.default.addObserver(self, selector: #selector(HomeMainOftenBuyController.refreshHomePage(_:)), name: NSNotification.Name(rawValue: FKYNEWHomeSecondKillCountOver), object: nil)
        //收到透传消息通知
        NotificationCenter.default.addObserver(self, selector: #selector(HomeMainOftenBuyController.refreshNoReadMessage), name: NSNotification.Name.FKYHomeNoReadMessage, object: nil)
    }
    fileprivate func steupUI() {
        
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(serachbar_height)
        }
        view.addSubview(keyWordView)
        keyWordView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(WH(0))
            make.top.equalTo(searchBar.snp.bottom)
        }
        
        view.addSubview(surpriseTipView)
        surpriseTipView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(0)
            make.bottom.equalTo(self.view)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(keyWordView.snp.bottom)
            make.bottom.equalTo(surpriseTipView.snp.top)
        }
        view.addSubview(topButton)
        topButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view)
            //make.height.width.equalTo(WH(60))
            make.bottom.equalTo(surpriseTipView.snp.top).offset(-WH(10))
        }
    }
    //更新惊喜提示框
    fileprivate func updateTipView(_ hideTipView:Bool ,_ tipStr:String?){
        if hideTipView == true {
            surpriseTipView.isHidden = true
            UIView.animate(withDuration: 0.3) { [weak self] in
                if let strongSelf = self {
                    strongSelf.surpriseTipView.snp.updateConstraints { (make) in
                        make.height.equalTo(0)
                    }
                }
            }
        }else {
            surpriseTipView.configTipStr(tipStr ?? "")
            surpriseTipView.isHidden = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                if let strongSelf = self {
                    strongSelf.surpriseTipView.snp.updateConstraints { (make) in
                        make.height.equalTo(SURPRISE_TIP_H)
                    }
                }
            }
        }
    }
}
// MARK:UITableViewDelegate UITableViewDataSource
extension HomeMainOftenBuyController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.cellRecommendProductArr.count > 0 {
            return self.viewModel.dataSource.count + 1 + self.viewModel.cellRecommendProductArr.count
        }else {
            return self.viewModel.dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.viewModel.dataSource.count {
            //MARK:配置楼层
            let cellData =  self.viewModel.dataSource[indexPath.row]
            switch cellData.cellType{
            //普品
            case .HomeCellTypeCommonProduct? :
                let cellModel:HomeCommonProductCellModel = cellData as! HomeCommonProductCellModel
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInfoListCell", for: indexPath) as!   ProductInfoListCell
                cell.selectionStyle = .none
                cellModel.model!.showSequence = indexPath.row + 1 //埋点用
                cell.configCell(cellModel.model!)
                
                //更新加车数量
                cell.addUpdateProductNum = { [weak self] in
                    if let strongSelf = self {
                        strongSelf.updateStepCount(cellModel, 0, indexPath.row, 1)
                        //                    if let block = strongSelf.updateStepCountBlock {
                        //                        block(cellModel,0,indexPath.section,1)
                        //                    }
                    }
                }
                //跳转到聚宝盆商家专区
                cell.clickJBPContentArea = { [weak self] in
                    if let _ = self {
                        // strongSelf.addLookJBPShopBI_Record(cellModel.model!,indexPath.row + 1)
                        FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                            let controller = vc as! FKYNewShopItemViewController
                            controller.shopId = cellModel.model!.shopCode ?? ""
                            controller.shopType = "1"
                        }, isModal: false)
                    }
                }
                //到货通知
                cell.productArriveNotice = {
                    FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                        let controller = vc as! ArrivalProductNoticeVC
                        controller.productId = cellModel.model!.spuCode
                        controller.venderId = "\(cellModel.model!.supplyId)"
                        controller.productUnit = cellModel.model!.packageUnit
                    }, isModal: false)
                }
                //登录
                cell.loginClosure = {
                    FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
                }
                // 商详
                cell.touchItem = {
                    //self.addLookDetailBI_Record(cellModel.model!,indexPath.row + 1)
                    FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                        let v = vc as! FKY_ProdutionDetail
                        v.productionId = cellModel.model!.spuCode
                        v.vendorId = "\(cellModel.model!.supplyId)"
                        v.updateCarNum = { (carId ,num) in
                            if let count = num {
                                cellModel.model!.carOfCount = count.intValue
                            }
                            if let getId = carId {
                                cellModel.model!.carId = getId.intValue
                            }
                        }
                    }, isModal: false)
                }
                return cell
            case .HomeCellTypeBanner? :
                //banner
                let cellModel:HomeBannerCellModel = cellData as! HomeBannerCellModel
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeBannerListCell", for: indexPath) as!   HomeBannerListCell
                cell.selectionStyle = .none
                cell.configContent(cellModel.model!)
                return cell
            case .HomeCellTypeAD? :   //一栏广告
                let cellModel:HomeADCellModel = cellData as! HomeADCellModel
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOneAdPageCell", for: indexPath) as!  HomeOneAdPageCell
                cell.configCell(cellModel.model!)
                weak var weakSelf = self
                cell.checkAdBlock = { (typeIndex) in
                    weakSelf?.addBIRecordForADCheckMore(cellModel.model!,typeIndex)
                    //                if let clouser = weakSelf?.callback {
                    let action = HomeTemplateAction()
                    action.actionType = .category_home_ad_clickItem
                    action.needRecord = false
                    if let adList = cellModel.model!.iconImgDTOList,adList.count > typeIndex{
                        action.actionParams = [HomeString.ACTION_KEY: adList[typeIndex] ]
                    }
                    weakSelf?.presenter.onClickCellAction(action)
                    //                    clouser(action)
                    //                }
                }
                return cell
            case .HomeCellTypeTwoAD? :   //二栏广告
                let cellModel:HomeTwoADCellModel = cellData as! HomeTwoADCellModel
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTwoAdPageCell", for: indexPath) as!  HomeTwoAdPageCell
                cell.configCell(cellModel.model!)
                weak var weakSelf = self
                cell.checkAdBlock = { (typeIndex) in
                    weakSelf?.addBIRecordForADCheckMore(cellModel.model!,typeIndex)
                    //                if let clouser = weakSelf?.callback {
                    let action = HomeTemplateAction()
                    action.actionType = .category_home_ad_clickItem
                    action.needRecord = false
                    if let adList = cellModel.model!.iconImgDTOList,adList.count > typeIndex{
                        action.actionParams = [HomeString.ACTION_KEY: adList[typeIndex] ]
                    }
                    weakSelf?.presenter.onClickCellAction(action)
                    //                    clouser(action)
                    //                }
                }
                return cell
            case .HomeCellTypeThreeAD? : //三栏广告
                let cellModel:HomeThreeADCellModel = cellData as! HomeThreeADCellModel
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeThreeAdPageCell", for: indexPath) as!   HomeThreeAdPageCell
                weak var weakSelf = self
                cell.checkAdBlock = { (typeIndex) in
                    weakSelf?.addBIRecordForADCheckMore(cellModel.model!,typeIndex)
                    //                if let clouser = weakSelf?.callback {
                    let action = HomeTemplateAction()
                    action.actionType = .category_home_ad_clickItem
                    action.needRecord = false
                    if let adList = cellModel.model!.iconImgDTOList,adList.count > typeIndex{
                        action.actionParams = [HomeString.ACTION_KEY: adList[typeIndex] ]
                    }
                    weakSelf?.presenter.onClickCellAction(action)
                    //                    clouser(action)
                    //                }
                }
                cell.configCell(cellModel.model!)
                return cell
            case .HomeCellTypeNotice? : //MARK:广播
                let cellModel:HomeNoticeCellModel = cellData as! HomeNoticeCellModel
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomePublicNoticeCell", for: indexPath) as!   HomePublicNoticeCell
                cell.configCell(notice: cellModel.model!)
                return cell
            case .HomeCellTypeNavFunc? : //MARK:导航按钮
                let cellModel:HomeNavFucCellModel = cellData as! HomeNavFucCellModel
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFucListCell", for: indexPath) as!   HomeFucListCell
                cell.selectionStyle = .none
                cell.configContent(cellModel.model!)
                return cell
            case  .HomeCellTypeSingleSecKill? ://MARK:单品秒杀
                let cellModel:HomeSingleSecKillCellModel = cellData as! HomeSingleSecKillCellModel
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSingleProductIntroCell", for: indexPath) as!   HomeSingleProductIntroCell
                cell.selectionStyle = .none
                cell.configCell(cellModel.model!)
                //更新加车数量
                weak var weakSelf = self
                cell.updateAddProductNum = { (count,typeIndex) in
                    weakSelf?.updateStepCount(cellModel, count, indexPath.row, typeIndex)
                }
                cell.toastAddProductNum = { msg in
                    //                if let block = weakSelf?.toastBlock {
                    //                    block(msg)
                    //                }
                    weakSelf?.toast(msg)
                }
                // 商详
                cell.touchItem = {
                    if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                        let productItem = list[0]
                        self.addBIRecordForCheckDetail(productItem,cellModel.model!,.HomeCellTypeSingleSecKill)
                        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                            let v = vc as! FKY_ProdutionDetail
                            v.productionId = productItem.productCode
                            v.vendorId = "\(productItem.supplyId ?? 0)"
                            v.updateCarNum = { (carId ,num) in
                                if let count = num {
                                    productItem.carOfCount = count.intValue
                                }
                                if let getId = carId {
                                    productItem.carId = getId.intValue
                                }
                            }
                        }, isModal: false)
                    }
                    
                }
                //查看活动
                cell.moreCallback = {
                    if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                        let productItem = list[0]
                        self.addBIRecordForCheckMore(productItem,cellModel.model!,.HomeCellTypeSingleSecKill)
                    }
                    //                if let clouser = weakSelf?.callback {
                    let action = HomeTemplateAction()
                    action.actionType = .secondKill016_clickMore
                    action.needRecord = false
                    action.actionParams = [HomeString.ACTION_KEY: cellModel.model ?? ""]
                    weakSelf?.presenter.onClickCellAction(action)
                    //  clouser(action)
                    //                }
                }
                return cell
            //MARK:秒杀/一起购系列/品牌
            case .HomeCellTypeSecKill?, .HomeCellTypeYQG? ,.HomeCellTypeBrand? :
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomePromotionStyleCell", for: indexPath) as!   HomePromotionStyleCell
                cell.configHomePromotionCell(cellData)
                return cell
            //MARK:秒杀活动和商品推荐(又叫商家特惠)/套餐
            case .HomeCellTypeTwoComponents,.HomeCellTypeOneComponents :
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSecKillRecommCell", for: indexPath) as!   HomeSecKillRecommCell
                //cell.configHomePromotionCell(cellData)
                cell.configCellData(cellData)
                cell.checkRecommendBlock = {[weak self] (productModel,model,index,productID) in
                    //点击推荐的楼层
                    if let strongSelf = self {
                        strongSelf.addBIRecordForRecommendFloor(productModel,model,index)
                        if model.type == 26{
                            //系统推荐秒杀
                            FKYNavigator.shared().openScheme(FKY_SecondKillActivityDetail.self, setProperty: {  (vc) in
                                let v = vc as! FKYSecondKillActivityController
                                
                            }, isModal: false)
                        }
                        if model.type == 27 {
                            //系统推荐商家特惠
                            FKYNavigator.shared().openScheme(FKY_Preferential_Shop.self, setProperty: {  (vc) in
                                let v = vc as! FKYPreferentialShopsViewController
                                if productModel != nil{
                                    //有商品信息 点击商品进去的
                                    v.spuCode = productModel!.spuCode ?? ""
                                    v.sellCode = "\(productModel!.supplyId ?? 0)"
                                }else{
                                    //没有商品信息 不是点击商品进去的
                                }
                                v.vcTitle = model.name
                            }, isModal: false)
                        }
                        if model.type == 39 {// 搭配套餐
                            FKYNavigator.shared().openScheme(FKY_MatchingPackageVC.self, setProperty: {  (vc) in
                                let vc_t = vc as! FKYMatchingPackageVC
                                vc_t.enterpriseId = model.dinnerEnterpriseId
                                vc_t.spuCode = productID
                            }, isModal: false)
                        }
                        if model.type == 40 {// 固定套餐
                            FKYNavigator.shared().openScheme(FKY_ComboList.self, setProperty: {  (vc) in
                                let vc_t = vc as! FKYComboListViewController
                                vc_t.sellerCode = Int(model.dinnerEnterpriseId) ?? 0
                                vc_t.spuCode = productID
                            }, isModal: false)
                            
                        }
                    }
                }
                return cell
            //MARK:系统推荐 新品推荐 即将售罄 热销榜
            case .HomeCellTypeOneSystemRecomm?, .HomeCellTypeTwoSystemRecomm? ,.HomeCellTypeThreeSystemRecomm? :
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHotSellFloorCell", for: indexPath) as!   HomeHotSellFloorCell
                cell.configHomePromotionCell(cellData)
                cell.checkRecommendBlock = {[weak self] (productModel,model,index) in
                    //点击推荐的楼层
                    if let strongSelf = self {
                        strongSelf.addBIRecordForRecommendFloor(productModel,model,index)
                        if model.type == 31 {
                            //高毛专区
                            if let app = UIApplication.shared.delegate as? AppDelegate {
                                if let url = model.jumpInfoMore, url.isEmpty == false {
                                    app.p_openPriveteSchemeString(url)
                                }
                            }
                        }else {
                            var typeIndex = 2
                            if model.type == 28 {
                                //系统推荐新品
                                typeIndex = 4
                            }
                            if model.type == 29 {
                                //系统推荐售罄
                                typeIndex = 3
                            }
                            if model.type == 30 {
                                //系统推荐热销
                                typeIndex = 2
                            }
                            FKYNavigator.shared().openScheme(FKY_HeightGrossMarginVC.self, setProperty: {  (vc) in
                                let v = vc as! FKYHeightGrossMarginVC
                                v.typeIndex = typeIndex
                                v.titleStr = model.name
                                if productModel != nil{
                                    //有商品信息 点击商品进去的
                                    v.spuCode = productModel!.spuCode ?? ""
                                    v.sellCode = "\(productModel!.supplyId ?? 0)"
                                }else{
                                    //没有商品信息 不是点击商品进去的
                                    
                                }
                                
                            }, isModal: false)
                        }
                    }
                }
                return cell
            //MARK:毛利  一起返等
            case .HomeCellTypeOther? :
                let cellModel:HomeOtherProductCellModel = cellData as! HomeOtherProductCellModel
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomePromotionNewTableViewCell", for: indexPath) as!   HomePromotionNewTableViewCell
                cell.configPromotionNewTableViewData(cellModel.model)
                cell.productDetailClosure = { [weak self] (index,prdModel) in
                    if let strongSelf = self {
                        strongSelf.clickPromotionNewViewProduct(index, prdModel, cellModel.model)
                    }
                }
                cell.clickHeaderView = { [weak self]  in
                    if let strongSelf = self {
                        strongSelf.clickPromotionViewHeader(cellModel.model)
                    }
                }
                return cell
            default:
                return UITableViewCell.init()
            }
        }else if indexPath.row == self.viewModel.dataSource.count {
            //MARK:为你推荐title
            let cell: FKYRecommendTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYHomeRecommendTitleTableViewCell", for: indexPath) as! FKYRecommendTitleTableViewCell
            return cell
        }else {
            //MARK:为您推荐
            let cell: FKYHomeSuggestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYHomeSuggestTableViewCell", for: indexPath) as! FKYHomeSuggestTableViewCell
            let index = indexPath.row-self.viewModel.dataSource.count-1
            if index < self.viewModel.cellRecommendProductArr.count {
                let prdModel = self.viewModel.cellRecommendProductArr[index]
                cell.configFKYHomeSuggestTableViewCell(prdModel)
                // 商详
                cell.touchItem = { [weak self] in
                    if let strongSelf = self {
                        strongSelf.addBIRecordForRecommendList(prdModel,index)
                        //进入推荐二级界面
                        FKYNavigator.shared().openScheme(FKY_HeightGrossMarginVC.self, setProperty: {  (vc) in
                            let v = vc as! FKYHeightGrossMarginVC
                            v.typeIndex = 5
                            v.spuCode = prdModel.spuCode
                        }, isModal: false)
                    }
                }
            }
            return cell
        }
    }
}
extension HomeMainOftenBuyController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < self.viewModel.dataSource.count {
            let cellData =  self.viewModel.dataSource[indexPath.row]
            
            switch cellData.cellType{
            //普品
            case .HomeCellTypeCommonProduct? :
                let cellModel:HomeCommonProductCellModel = cellData as! HomeCommonProductCellModel
                if cellModel.model != nil{
                    //                let cellHeight = cellHeightManager.getContentCellHeight(cellModel.model!.spuCode ?? "","\(cellModel.model!.supplyId ?? 0)","FKY")
                    //                if  cellHeight == 0{
                    let conutCellHeight = ProductInfoListCell.getCellContentHeight(cellModel.model!)
                    // cellHeightManager.addContentCellHeight(cellModel.model!.spuCode ?? "","\(cellModel.model!.supplyId ?? 0)","FKY", conutCellHeight)
                    return conutCellHeight
                    //                }else{
                    //                    return cellHeight!
                    //                }
                }
                return 0
                
            case .HomeCellTypeBanner? :
                //banner
                return (SCREEN_WIDTH - 20)*110/355.0 + 9
            case .HomeCellTypeAD? :   //一栏广告
                return HomeOneAdPageCell.getCellContentHeight()
            case .HomeCellTypeTwoAD? :   //二栏广告
                return HomeTwoAdPageCell.getCellContentHeight()
            case .HomeCellTypeThreeAD? : //三栏广告
                return HomeThreeAdPageCell.getCellContentHeight()
            case .HomeCellTypeNotice? : //广播
                if self.viewModel.hasNavFunc == false{
                    return WH(46) + WH(10)
                }else{
                    return WH(46)
                }
            case .HomeCellTypeNavFunc? : //导航按钮
                let cellModel:HomeNavFucCellModel = cellData as! HomeNavFucCellModel
                return HomeFucListCell.getHomeFucListeCellHeight(cellModel)
            case .HomeCellTypeSingleSecKill? ://单品秒杀
                return (SCREEN_WIDTH)*121/375.0 + WH(10)
                
            //秒杀//一起购
            case .HomeCellTypeSecKill?, .HomeCellTypeYQG? ,.HomeCellTypeBrand? :
                return  HomePromotionStyleCell.getPromotionStyleCellHeight(cellData)
            //秒杀活动和商品推荐
              
            case .HomeCellTypeOneComponents,.HomeCellTypeTwoComponents :
                if cellData.cellType == .HomeCellTypeOneComponents{
                     let cellModel:HomeFloorModel = cellData as! HomeFloorModel
                     if cellModel.hasBtttom == true{
                         return WH(146)
                     }
                }
                else if cellData.cellType == .HomeCellTypeTwoComponents{
                     let cellModel:HomeFloorModel = cellData as! HomeFloorModel
                     if cellModel.hasBtttom == true{
                         return WH(146)
                     }
                }
                return WH(155)
            //系统推荐 新品推荐 即将售罄 热销榜
            case .HomeCellTypeOneSystemRecomm?, .HomeCellTypeTwoSystemRecomm? ,.HomeCellTypeThreeSystemRecomm? :
               return WH(155)
            //毛利  一起返等
            case .HomeCellTypeOther? :
                let cellModel:HomeOtherProductCellModel = cellData as! HomeOtherProductCellModel
                return  HomePromotionNewTableViewCell.getPromotionNewTableViewHeight(cellModel.model)
            default:
                return 0.0
            }
        }else if indexPath.row == self.viewModel.dataSource.count {
            return WH(34)
        }else {
            let index = indexPath.row-self.viewModel.dataSource.count-1
            if index < self.viewModel.cellRecommendProductArr.count {
                let prdModel = self.viewModel.cellRecommendProductArr[index]
                return FKYHomeSuggestTableViewCell.getCellContentHeight(prdModel)
            }
            return 0.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeMainOftenBuyController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            if tableView.contentOffset.y > SCREEN_HEIGHT{
                self.topButton.isHidden = false
            }else{
                self.topButton.isHidden = true
            }
        }
    }
    //重置滑动位置后重置一些参数
    func resetTableViewOffsetY(){
        self.topButton.isHidden = true
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
}

//MARK - REQUEST
extension HomeMainOftenBuyController{
    
    //MARK: 首页未读消息数量请求
    func requestUnreadMsgCount(){
        self.viewModel.getUnreadCount { [weak self] (isSuccess, msg) in
            guard let weakSelf = self else {
                return
            }
            guard isSuccess else {
                return
            }
            if weakSelf.viewModel.unreadMsgCount > 0 {
                weakSelf.searchBar.unreadMsgCount.isHidden = false
                if weakSelf.viewModel.unreadMsgCount <= 9{
                    weakSelf.searchBar.unreadMsgCount.showText("\(weakSelf.viewModel.unreadMsgCount)", WH(15))
                }else{
                    weakSelf.searchBar.unreadMsgCount.showText("9+", WH(15))
                }
            }else{
                weakSelf.searchBar.unreadMsgCount.isHidden = true
            }
            
        }
    }
    
    // MARK:刷新数据
    //请求第一页数据
    func requestFirstHomePage(_ showLoading:Bool){
        //防止重复刷新
        let currentTime = NSDate().timeIntervalSince1970
        //print("1====\(currentTime)========\(lastTimeInterval)=====\(currentTime*1000000 - lastTimeInterval*1000000)")
        if lastTimeInterval == 0  || (lastTimeInterval > 0 && (currentTime*1000000 - lastTimeInterval*1000000 > 1000000)){
            lastTimeInterval = NSDate().timeIntervalSince1970
            self.viewModel.nextPageId = 1
            //self.viewModel.dataSource.removeAll()
            self.refreshData(showLoading)
            self.getRecommendForYouPrdList(true)
        }else{
            lastTimeInterval = NSDate().timeIntervalSince1970
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }
        
    }
    func refreshData(_ showLoading:Bool){
        if showLoading == true{
            self.showLoading()
        }
        if (self.viewModel.nextPageId == 1){
            //刷新数据 有倒计时的停止
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: FKYHomeRefreshToStopTimers), object: self, userInfo: nil)
        }
        viewModel.getHomenFloorList(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.tableView.mj_header.endRefreshing()
            strongSelf.refreshDismiss()
            strongSelf.dismissLoading()
            if success{
                strongSelf.failedView.isHidden = true
                if strongSelf.viewModel.nextPageId == 2 {
                    //只在第一页数据的时候刷新热搜词
                    strongSelf.refreshHotSearchView()
                }
                if strongSelf.viewModel.nextPageId == 3 {
                    //第二页数据回来(启动本地计时器)
                    FKYTimerManager.timerManagerShared.allTimerStart()
                }
                strongSelf.refreshDataBackFromCar()
            } else {
                // 失败
                if  strongSelf.viewModel.dataSource.count == 0{
                    strongSelf.failedView.isHidden = false
                }
                strongSelf.toast(msg ?? "请求失败")
            }
            if(strongSelf.viewModel.nextPageId == 2){
                //请求完第一页数据马上请求第二页数据啊
                strongSelf.refreshData(true)
            }
        }
    }
    
    // MARK:获取缓存数据
    func loadCacheData(){
        viewModel.fetchHomeRecommendCacheData(){ [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            if success{
                strongSelf.failedView.isHidden = true
                //strongSelf.setUpContentUI()
                strongSelf.refreshDataBackFromCar()
            } else {
                // 失败
                if  strongSelf.viewModel.dataSource.count == 0{
                    strongSelf.failedView.isHidden = false
                }
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    // MARK: 首次请求  获取所有类型第一页数据 刷新完置顶 登录发生改变请求首页数据
    func refreshDataForLoginChange() {
        self.getNoReadMessageCount()
        self.requestFirstHomePage(false)
    }
    //MARK:为您推荐接口
    func getRecommendForYouPrdList(_ isFresh:Bool) {
        if isFresh == true {
            self.mjfooter.resetNoMoreData()
        }
        self.viewModel.getRecommendForYouWithProductList(isFresh) {[weak self] (hasMoreData, tip) in
            guard let strongSelf = self else{
                return
            }
            if isFresh == true {
                strongSelf.mjheader.endRefreshing()
            }
            if hasMoreData == true {
                strongSelf.mjfooter.endRefreshing()
            }else {
                strongSelf.mjfooter.endRefreshingWithNoMoreData()
            }
            if let _ = tip {
                //strongSelf.toast(msg)
            }else {
                //请求成功
                strongSelf.tableView.reloadData()
            }
        }
    }
    //MARK:请求是否有惊喜提示
    fileprivate func getSurpriseTipStrView() {
        self.updateTipView(true, nil)
        self.viewModel.getSurpriseTipViewYesOrFlase { [weak self] (showStr, tipStr) in
            guard let strongSelf = self else{
                return
            }
            if showStr == "1" {
                //展示
                strongSelf.updateTipView(false, tipStr)
            }else{
                //隐藏
                strongSelf.updateTipView(true, nil)
            }
        }
    }
    // MARK: - 获取未读消息数量 methods
    func getNoReadMessageCount() {
        /*
        if FKYLoginAPI.loginStatus() != .unlogin {
            messageListProvider.getNoReadMessageCountWithProvider {[weak self] (messageCount) in
                guard let strongSelf = self else {
                    return
                }
                if let count = messageCount,count > 0 {
                    strongSelf.searchBar.cartBadgeView?.badgeText = "\(count)"
                    strongSelf.searchBar.cartBadgeView?.isHidden = false
                }else{
                    strongSelf.searchBar.cartBadgeView?.isHidden = true
                    strongSelf.searchBar.cartBadgeView?.badgeText = ""
                }
            }
        }else {
            self.searchBar.cartBadgeView?.isHidden = true
            self.searchBar.cartBadgeView?.badgeText = ""
        }
        */
    }
    // MARK: 对刷新空间状态进行改变
    func refreshDismiss() {
        if tableView.mj_header.isRefreshing() {
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.resetNoMoreData()
        }
        //        if viewModel.hasNextPage {
        //            tableView.mj_footer.endRefreshing()
        //        }else{
        //            tableView.mj_footer.endRefreshingWithNoMoreData()
        //        }
    }
}
extension HomeMainOftenBuyController{
    // MARK:购物车刷新
    func refreshCartNum(){
        if  isFirstRefresh == false {
            //self.showLoading()
        }
        //isFirstRefresh = false
        weak var weakSelf = self
        FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ (success) in
            weakSelf?.dismissLoading()
            weakSelf?.refreshDataBackFromCar()
        }, failure: { (reason) in
            weakSelf?.refreshDataBackFromCar()
            weakSelf?.dismissLoading()
        })
    }
    // MARK:更新加车
    func updateStepCount(_ cellData : HomeBaseCellProtocol ,_ count: Int, _ row: Int,_ typeIndex: Int)  {
        if  cellData .cellType  == .HomeCellTypeCommonProduct {
            let cellModel:HomeCommonProductCellModel = cellData as! HomeCommonProductCellModel
            if let productModel = cellModel.model {
                //加车来源
                self.addCarView.configAddCarViewController(productModel,"")
                self.addCarView.showOrHideAddCarPopView(true,self.view)
            }
        }else {
            //typeIndex为2的时候延迟加车接口请求
            if typeIndex == 2 || typeIndex == 3 {
                //延迟加车
                return
            }
            // weak var weakSelf = self
            
            var itemModel:HomeRecommendProductItemModel?
            
            if let cellModel = cellData as? HomeSecKillCellModel {
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    itemModel = list[0]
                }
            }else if  let cellModel = cellData as? HomeOtherProductCellModel{
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    itemModel = list[0]
                }
            }else if  let cellModel = cellData as? HomeSingleSecKillCellModel{
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    itemModel = list[0]
                    self.addCarProtionBI_Record(itemModel!,cellModel.model!)
                }
            }else if  let cellModel = cellData as? HomeYQGCellModel{
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    itemModel = list[0]
                }
            } else if  let cellModel = cellData as? HomeSingleSecKillCellModel{
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    itemModel = list[0]
                }
            }
            if let product = itemModel{
                // self.addBI_Record(product, count)
                if product.carOfCount > 0 && product.carId != 0 {
                    self.showLoading()
                    if count == 0 {
                        //数量变零，删除购物车
                        self.service.deleteShopCart([product.carId], success: {[weak self] (mutiplyPage) in
                            FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({[weak self] (success) in
                                //更新
                                guard let strongSelf = self else {
                                    return
                                }
                                product.carId = 0
                                product.carOfCount = 0
                                strongSelf.refreshDataBackFromCar()
                                strongSelf.dismissLoading()
                                }, failure: {[weak self] (reason) in
                                    guard let strongSelf = self else {
                                        return
                                    }
                                    strongSelf.refreshDataBackFromCar()
                                    strongSelf.dismissLoading()
                                    strongSelf.toast(reason)
                            })
                            }, failure: {[weak self] (reason) in
                                guard let strongSelf = self else {
                                    return
                                }
                                strongSelf.refreshDataBackFromCar()
                                strongSelf.dismissLoading()
                                strongSelf.toast(reason)
                        })
                    }else {
                        // 更新购物车...<商品数量变化时需刷新数据>
                        //self.biRecord(row, product)
                        self.service.updateShopCart(forProduct: "\(product.carId)", quantity: count, allBuyNum: -1, success: { (mutiplyPage,aResponseObject) in
                            FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({[weak self] (success) in
                                guard let strongSelf = self else {
                                    return
                                }
                                strongSelf.dismissLoading()
                                // product.carOfCount = count
                                strongSelf.refreshDataBackFromCar()
                                }, failure: {[weak self] (reason) in
                                    guard let strongSelf = self else {
                                        return
                                    }
                                    strongSelf.refreshDataBackFromCar()
                                    strongSelf.dismissLoading()
                                    strongSelf.toast(reason)
                            })
                        }, failure: {[weak self] (reason) in
                            guard let strongSelf = self else {
                                return
                            }
                            //strongSelf.currentView.refreshDataBackFromCar()
                            strongSelf.dismissLoading()
                            strongSelf.toast(reason)
                        })
                    }
                }
                else if count > 0 {
                    self.showLoading()
                    //加车埋点
                    //  self.biRecord(row, product)
                    // 加车
                    self.shopProvider.addShopCart(product,"",count: count, completionClosure: { [weak self](reason, data) in
                        guard let strongSelf = self else {
                            return
                        }
                        // 说明：若reason不为空，则加车失败；若data不为空，则限购商品加车失败
                        if let re = reason {
                            if re == "成功" {
                                FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({[weak self] (success) in
                                    guard let strongSelf = self else {
                                        return
                                    }
                                    strongSelf.refreshDataBackFromCar()
                                    strongSelf.dismissLoading()
                                    }, failure: {[weak self] (reason) in
                                        guard let strongSelf = self else {
                                            return
                                        }
                                        strongSelf.refreshDataBackFromCar()
                                        strongSelf.dismissLoading()
                                        strongSelf.toast(reason)
                                })
                            }else {
                                strongSelf.refreshDataBackFromCar()
                                strongSelf.dismissLoading()
                                strongSelf.toast(reason)
                            }
                        }
                    })
                }
            }
        }
    }
    // MARK:从购物车回来后刷新数据
    func refreshDataBackFromCar()  {
        if self.viewModel.dataSource.count > 0 {
            self.resetHomeProductCartNum()
            for product in self.viewModel.dataSource {
                if product.cellType != .HomeCellTypeSingleSecKill{
                    continue
                }
                for cartModel  in (FKYCartModel.shareInstance()?.mixProductArr)! {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        //单品秒杀
                        if product.cellType == .HomeCellTypeSingleSecKill{
                            let cellModel:HomeSingleSecKillCellModel = product as! HomeSingleSecKillCellModel
                            if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                                let model = list[0]
                                if  cartOfInfoModel.spuCode != nil && model.productCode != nil && cartOfInfoModel.supplyId != nil && model.supplyId != nil && cartOfInfoModel.fromWhere != nil  && cartOfInfoModel.spuCode as String == model.productCode! && cartOfInfoModel.supplyId.intValue ==  model.supplyId! && cartOfInfoModel.fromWhere.intValue != 2 {
                                    model.carOfCount = cartOfInfoModel.buyNum.intValue
                                    model.carId = cartOfInfoModel.cartId.intValue
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    // MARK:重置购物车数据
    func  resetHomeProductCartNum(){
        for product in self.viewModel.dataSource {
            switch product.cellType{
            //普品
            case .HomeCellTypeCommonProduct? :
                let cellModel:HomeCommonProductCellModel = product as! HomeCommonProductCellModel
                let model: HomeCommonProductModel = cellModel.model!
                model.carOfCount = 0
                model.carId = 0
                break
            //一起购
            case .HomeCellTypeYQG? :
                let cellModel:HomeYQGCellModel = product as! HomeYQGCellModel
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    let model = list[0]
                    model.carOfCount = 0
                    model.carId = 0
                }
                break
            //秒杀
            case .HomeCellTypeSecKill? :
                let cellModel:HomeSecKillCellModel = product as! HomeSecKillCellModel
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    let model = list[0]
                    model.carOfCount = 0
                    model.carId = 0
                }
                break
            //毛利  一起返等
            case .HomeCellTypeOther? :
                let cellModel:HomeOtherProductCellModel = product as! HomeOtherProductCellModel
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    let model = list[0]
                    model.carOfCount = 0
                    model.carId = 0
                }
                break
            default:
                break
            }
        }
    }
    //刷新热搜视图
    fileprivate func refreshHotSearchView(){
        if let arr = self.viewModel.hotSearchArr, arr.count > 0 {
            keyWordView.isHidden = false
            keyWordView.snp.updateConstraints { (make) in
                make.height.equalTo(WH(32))
            }
            keyWordView.configHotSearchView(arr)
        }else {
            keyWordView.isHidden = true
            keyWordView.snp.updateConstraints { (make) in
                make.height.equalTo(WH(0))
            }
        }
        
    }
    //MARK:点击药城精选(2*3)的商品
    fileprivate func clickPromotionNewViewProduct(_ index:Int , _ product:HomeRecommendProductItemModel, _ itemModel:HomeSecdKillProductModel?){
        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
            let v = vc as! FKYProductionDetailViewController
            v.productionId = product.productCode
            v.vendorId = "\(product.supplyId ?? 0)"
        }, isModal: false)
        var sectionPosition = ""
        var itemTitle : String?
        if let model = itemModel {
            sectionPosition = "\(model.showSequence ?? 1)"
            itemTitle = model.name
        }
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : product.pm_pmtn_type! as AnyObject]
        //FKYAnalyticsManager.sharedInstance.BI_New_Record("F1011", floorPosition: "1", floorName: "运营首页", sectionId: "S1011", sectionPosition: sectionPosition, sectionName: "药城精选(3*2)", itemId: ITEMCODE.HOME_ACTION_PRODUCTION_MORE_ADD.rawValue, itemPosition: "\(index+1)", itemName: "点进商详", itemContent: "\(product.supplyId ?? 0)|\(product.productCode ?? "0")", itemTitle: itemTitle, extendParams: extendParams, viewController: self)
    }
    //MARK:点击药城精选(2*3)头部
    fileprivate func clickPromotionViewHeader(_ itemModel:HomeSecdKillProductModel?){
        if let app = UIApplication.shared.delegate as? AppDelegate , let model = itemModel {
            app.p_openPriveteSchemeString(model.jumpInfoMore)
        }
        var sectionPosition = ""
        var itemTitle : String?
        if let model = itemModel {
            sectionPosition = "\(model.showSequence ?? 1)"
            itemTitle = model.name
        }
        //FKYAnalyticsManager.sharedInstance.BI_New_Record("F1011", floorPosition: "1", floorName: "运营首页", sectionId: "S1011", sectionPosition:sectionPosition, sectionName: "药城精选(3*2)", itemId: ITEMCODE.HOME_ACTION_PRODUCTION_MORE_ADD.rawValue, itemPosition: "0", itemName: "更多", itemContent: nil, itemTitle: itemTitle, extendParams: nil, viewController: self)
    }
}
extension HomeMainOftenBuyController {
    @objc fileprivate func refreshHomePage(_ nty: Notification) {
        //防止通知重复刷新
        self.requestFirstHomePage(false)
    }
    @objc fileprivate func refreshNoReadMessage(){
        self.getNoReadMessageCount()
    }
}
// MARK:搜索框事件
extension HomeMainOftenBuyController: HomeSearchBarOperation {
    
    func onClickSearchItemAction(_ bar: HomeSearchBar) {
        presenter.onClickSearchItemAction(bar)
    }
    
    func onClickMessageBoxAction(_ bar: HomeSearchBar) {
        presenter.onClickMessageBoxAction(bar)
    }
    
    /// 扫码搜索事件
    func onclickScanSearchButtonAction(){
        FKYNavigator.shared()?.openScheme(FKY_ScanVC.self)
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_SCAN_CLICK_CODE.rawValue, itemPosition: "0", itemName: "扫一扫", itemContent: nil, itemTitle: nil, extendParams: nil, viewController:self)
    }
}
// MARK: 埋点
extension HomeMainOftenBuyController{
    // 活动商品 点击商详 商品位置埋点
    fileprivate func addBIRecordForCheckDetail(_ product: HomeRecommendProductItemModel, _ model:HomeSecdKillProductModel,_ pronationType:HomeCellType) {
        let itemContent = "\(product.supplyId ?? 0)|\(product.productCode ?? "0")"
        if pronationType == .HomeCellTypeSingleSecKill{
            let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : "特价" as AnyObject]
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_RECOMMEND_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: "运营首页", sectionId: SECTIONCODE.HOME_RECOMMEND_SECTION_CODE.rawValue, sectionPosition: "\(model.showSequence ?? 0)", sectionName: "秒杀-单品", itemId: ITEMCODE.HOME_ACTION_SINGLE_ITEMDETAIL.rawValue, itemPosition: "1", itemName: "点进商详", itemContent: itemContent, itemTitle: model.name, extendParams: extendParams, viewController: self)
        }
    }
    
    // 活动商品 点击更多
    // name
    fileprivate func addBIRecordForCheckMore(_ product: HomeRecommendProductItemModel, _ model:HomeSecdKillProductModel,_ pronationType:HomeCellType) {
        let itemContent = "\(product.supplyId ?? 0)|\(product.productCode ?? "0")"
        //秒杀单品
        if pronationType == .HomeCellTypeSingleSecKill{
            let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : "特价" as AnyObject]
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_RECOMMEND_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: "运营首页", sectionId: SECTIONCODE.HOME_RECOMMEND_SECTION_CODE.rawValue, sectionPosition:  "\(model.showSequence ?? 0)", sectionName: "秒杀-单品", itemId: ITEMCODE.HOME_ACTION_SINGLE_ITEMDETAIL.rawValue, itemPosition: "0", itemName: "更多", itemContent: itemContent, itemTitle: model.name, extendParams: extendParams, viewController: self)
        }
    }
    
    // 广告 点击
    fileprivate func addBIRecordForADCheckMore(_ model:HomeADInfoModel,_ typeIndex:Int) {
        if let imageList = model.iconImgDTOList,imageList.count > typeIndex{
            let imgeModel = imageList[typeIndex] as HomeBrandDetailModel
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_RECOMMEND_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: "运营首页", sectionId: SECTIONCODE.HOME_RECOMMEND_SECTION_CODE.rawValue, sectionPosition: "\(model.showSequence ?? 0)", sectionName: "中通广告", itemId: ITEMCODE.HOME_ACTION_AD_CONTENT.rawValue, itemPosition: "\(typeIndex + 1)", itemName: imgeModel.imgName, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        }
    }
    //系统推荐 点进二级页面
    fileprivate func addBIRecordForRecommendFloor(_ product: HomeRecommendProductItemModel?, _ model:HomeSecdKillProductModel,_ itemIndex:Int){
        if product != nil{
            let itemContent = "\(product!.supplyId ?? 0)|\(product!.productCode ?? "0")"
            let extendParams:[String :AnyObject] = ["storage" : product!.storage! as AnyObject,"pm_price" : product!.pm_price! as AnyObject,"pm_pmtn_type" : product!.pm_pmtn_type as AnyObject]
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_RECOMMEND_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: "运营首页", sectionId: SECTIONCODE.HOME_RECOMMEND_SECTION_CODE.rawValue, sectionPosition:  "\(model.showSequence ?? 0)", sectionName: "系统推荐", itemId: "I1026", itemPosition: "\(itemIndex + 1)", itemName: "点进专区", itemContent: itemContent, itemTitle: model.name, extendParams: extendParams, viewController: CurrentViewController.shared.item)
        }else{
            
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_RECOMMEND_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: "运营首页", sectionId: SECTIONCODE.HOME_RECOMMEND_SECTION_CODE.rawValue, sectionPosition:  "\(model.showSequence ?? 0)", sectionName: "系统推荐", itemId: "I1026", itemPosition: "\(itemIndex + 1)", itemName: "点进专区", itemContent: nil, itemTitle: model.name, extendParams: nil, viewController: CurrentViewController.shared.item)
        }
        
    }
    //为您推荐 点进列表页
    fileprivate func addBIRecordForRecommendList(_ product: HomeRecommendProductItemModel,_ itemIndex:Int){
        let itemContent = "\(product.productCode ?? "0")"
        FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_RECOMMEND_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: "运营首页", sectionId: nil, sectionPosition:  nil, sectionName: "为您推荐", itemId: "I1027", itemPosition: "\(itemIndex + 1)", itemName: "点进列表页", itemContent: itemContent, itemTitle: nil, extendParams: nil, viewController: self)
    }
    //活动加车埋点
    func addCarProtionBI_Record(_ product: HomeRecommendProductItemModel, _ model:HomeSecdKillProductModel) {
        let itemContent = "\(product.supplyId ?? 0)|\(product.productCode ?? "0")"
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : "特价" as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_RECOMMEND_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: "运营首页", sectionId: SECTIONCODE.HOME_RECOMMEND_SECTION_CODE.rawValue, sectionPosition:"\(model.showSequence ?? 0)", sectionName: "秒杀-单品", itemId: ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue, itemPosition: "0", itemName: "加车", itemContent: itemContent, itemTitle: model.name, extendParams: extendParams, viewController: self)
    }
    
}
