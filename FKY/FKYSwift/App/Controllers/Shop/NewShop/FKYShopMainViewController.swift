//
//  FKYShopMainViewController.swift
//  FKY
//
//  Created by hui on 2019/10/29.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopMainViewController: UIViewController {
    
    //MARK:ui相关控件
    //下拉刷新
    //    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
    //        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
    //            // 下拉刷新
    //
    //        })
    //        header?.arrowView.image = nil
    //        header?.lastUpdatedTimeLabel.isHidden = true
    //        return header!
    //    }()
    //上拉加载更多
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            guard let strongSelf = self else{
                return
            }
            strongSelf.getShopRecommendProductListWithEterpriseId(false)
        })
        footer?.isHidden = true
        footer!.setTitle("—— 继续拖动，查看全部商品 ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        footer!.endRefreshingWithNoMoreData()
        footer!.mj_h = WH(59)
        return footer!
    }()
    //
    fileprivate lazy var shopMainTableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.estimatedRowHeight = WH(900) //最多五行促销商品
        //tableV.rowHeight = UITableView.automaticDimension // 设置高度自适应
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        //tableV.register(FKYShopMainContentsTableViewCell.self, forCellReuseIdentifier: "FKYShopMainContentsTableViewCell_main")
        //tableV.register(FKYShopMainBannerTableViewCell.self, forCellReuseIdentifier: "FKYShopMainBannerTableViewCell")
        //多品满折
        tableV.register(PDPromotionCell.self, forCellReuseIdentifier: "FKYShopPDPromotionCell")
        //优惠券cell
        tableV.register(FKYShopCouponsTableViewCell.self, forCellReuseIdentifier: "FKYShopCouponsTableViewCell")
        //促销cell
        tableV.register(FKYShopPromotionProuductCell.self, forCellReuseIdentifier: "FKYShopPromotionProuductCell")
        //单品秒杀cell
        tableV.register(ShopSingleSecKillCell.self, forCellReuseIdentifier: "ShopSingleSecKillCell")
        //多个商品秒杀cell
        tableV.register(ShopManySecKillCell.self, forCellReuseIdentifier: "ShopManySecKillCell")
        //轮播图
        tableV.register(ShopBannerListCell.self, forCellReuseIdentifier: "ShopBannerListCell")
        //导航功能按钮
        tableV.register(ShopNavBtnListCell.self, forCellReuseIdentifier: "ShopNavBtnListCell")
        //一栏广告
        tableV.register(ShopOneAdPageCell.self, forCellReuseIdentifier: "ShopOneAdPageCell")
        //两栏广告
        tableV.register(ShopTwoAdPageCell.self, forCellReuseIdentifier: "ShopTwoAdPageCell")
        //三栏个广告
        tableV.register(ShopThreeAdPageCell.self, forCellReuseIdentifier: "ShopThreeAdPageCell")
        //我的推荐商品title
        tableV.register(FKYRecommendTitleTableViewCell.self, forCellReuseIdentifier: "FKYRecommendTitleTableViewCell")
        //我的推荐商品
        tableV.register(ProductInfoListCell.self, forCellReuseIdentifier: "ShopProductInfoListCell")
        
        //tableV.mj_header = self?.mjheader
        tableV.mj_footer = self?.mjfooter
        tableV.tableHeaderView = self?.shopMainHeadView
        tableV.backgroundColor = RGBColor(0xF4F4F4)
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    // section one头部视图
    fileprivate lazy var shopMainHeadView : FKYShopMainHeadView = {
        let view = FKYShopMainHeadView()
        view.isHidden = true
        view.clickViewBock = { [weak self] (type) in
            if let strongSelf = self {
                if type == 1 {
                    //采购须知
                    FKYNavigator.shared().openScheme(FKY_ShopEnterPriseInfo.self, setProperty: { (vc) in
                        let controller = vc as! FKYShopEnterpriseInfoViewController
                        controller.shopId = strongSelf.shopId
                        controller.enterBaseInfoModel = strongSelf.enterBaseInfoModel
                    }, isModal: false)
                    strongSelf.addBIWithCommonViewClick(1,1, nil)
                }else if type == 2 || type == 3 {
                    //收藏按钮
                    if FKYLoginAPI.loginStatus() != .unlogin {
                        strongSelf.addOrCancellShopCollectionInfo(type == 2 ? true:false)
                    }else {
                        FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
                    }
                    strongSelf.addBIWithCommonViewClick(2,1, nil)
                }
            }
        }
        return view
    }()
    
    //商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        if let desPoint = self.finishPoint {
            addView.finishPoint = desPoint
        }
        //更改购物车数量
        addView.addCarSuccess = { [weak self] (isSuccess,type,productNum,productModel) in
            if let strongSelf = self {
                if isSuccess == true {
                    if let block = strongSelf.updateShopItemCarNum{
                        if type == 1 {
                            block(false)
                        }else if type == 3 {
                            block(true)
                        }
                    }
                }
                //刷新点击的那个商品
                if let index = strongSelf.seletedIndex{
                    strongSelf.shopMainTableView.reloadRows(at: [index], with: .none)
                }
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let index = strongSelf.seletedIndex {
                    if index.row < strongSelf.cellArr.count {
                        //运营配置楼层
                        if let model = productModel as? HomeRecommendProductItemModel {
                            if  let promotionModel = strongSelf.cellArr[index.row] as? FKYShopPromotionBaseInfoModel{
                                strongSelf.addBISuggestionCell(floorName: promotionModel.name, floorPosition: promotionModel.showSequence, sectionIdType: 4, itemIdType: 3, itemPosition: (strongSelf.seletedItem + 1), nil, model)
                            }
                        }
                    }else {
                        if let model = productModel as? HomeCommonProductModel {
                            //我的推荐列表
                            let listIndex = index.row - strongSelf.cellArr.count - 1
                            strongSelf.addBIWithRecommendViewClick((listIndex+1), 2, model)
                        }
                    }
                }
            }
        }
        return addView
    }()
    //加载失败
    fileprivate lazy var failedView : UIView = {
        let view = self.showEmptyNoDataCustomView(self.view, "no_shop_pic", GET_FAILED_TXT,false) { [weak self] in
            if let strongSelf = self {
                strongSelf.reloadDataWithLoginSuccess()
            }
        }
        return view
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
    //优惠券列表弹框
    fileprivate lazy var popCouponVC : FKYPopShopCouponListViewController = {
        let vc = FKYPopShopCouponListViewController()
        vc.clickCouponsTableView = { [weak self] (typeIndex,indexNum,couponsModel) in
            if let strongSelf = self {
                strongSelf.dealCouponListViewAction(typeIndex,indexNum,couponsModel)
            }
        }
        return vc
    }()
    //推荐商品请求viewModel
    fileprivate lazy var recommendViewModel : FKYRecommendViewModel = {
        let viewModel = FKYRecommendViewModel()
        return viewModel
    }()
    fileprivate var service: FKYCartService = {
        let service = FKYCartService()
        service.editing = false
        return service
    }()
    fileprivate var shopProvider: ShopItemProvider = {
        return ShopItemProvider()
    }()
    
    //MARK:业务属性
    //入参
    @objc dynamic var shopId: String? //店铺id
    @objc dynamic var shopType: String? //是否是专区（1 专区 2 店铺详情,默认为店铺详情）
    var finishPoint:CGPoint? //购物车位置
    var updateBottomFuctionView :((Int)->(Void))? //更新上一个界面的底部tab
    var updateShopItemCarNum : ((Bool)->(Void))? //更新购物车
    var goToNextPage : (()->(Void))? //滑动到下一页
    fileprivate var hasGoNext = false //记录是否触发了去下一页<触发后，不再触发当前也的滑动事件>
    
    fileprivate var seletedIndex :IndexPath? //记录加车点击的那个区域
    fileprivate var seletedItem = 0 //
    fileprivate var sectionHeadOne_h  = WH(69) //头部的高度
    //请求数据模型
    var enterBaseInfoModel : FKYShopEnterInfoModel? //头部基本信息
    var promotionInfoModel : FKYShopPromotionInfoModel? //优惠券及促销活动
    var showCustomer:Bool = false //默认不展示
    var cellArr = [Any]() //楼层数据(优惠券+配置楼层)
    var hasNavArray:Bool = false //默认不展示导航栏按钮
    var cellRecommendProductArr = [HomeCommonProductModel]() //推荐商品列表数据
    var hasRecommendMoreData = true //默认有推荐商品
    var showTowCouponView = false //展开两行优惠券
    var lastTimeInterval:TimeInterval = 0.0  //防止通知重复刷新
    //MARK:生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setContentView()
        self.reloadDataWithLoginSuccess()
        // 点欧秒杀楼层倒计时结束时需刷新数据
        NotificationCenter.default.addObserver(self, selector: #selector(FKYShopMainViewController.refreshShopPage(_:)), name: NSNotification.Name(rawValue: FKYShopRefreshToStopTimers), object: nil)
        // 登录成功后刷新界面数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataWithLoginSuccess), name: NSNotification.Name.FKYLoginSuccess, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshPromotionProductNum()
    }
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>FKYShopMainViewController deinit~!@")
        NotificationCenter.default.removeObserver(self)
    }
}
//MARK:UI及业务方法相关
extension FKYShopMainViewController{
    //设置内容视图
    fileprivate func setContentView (){
        self.view.addSubview(self.shopMainTableView)
        self.shopMainTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    //MARK:弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = HomeString.SHOPITEM_FIRST_ADD_SOURCE_TYPE
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
    //MARK:登陆成功刷新数据
    @objc func reloadDataWithLoginSuccess() {
        // 刷新界面数据
        failedView.isHidden = true
        self.mjfooter.isHidden = true
        self.cellArr.removeAll()
        self.getShowCusterInfo()
        self.getShopOpreateCellListWithEterpriseId()
        self.getShopBaseInfoAndShopCouponListInfoWithEnterPriseId()
        if FKYLoginAPI.loginStatus() != .unlogin {
            self.getShopCollectionInfo()
        }
        self.getShopRecommendProductListWithEterpriseId(true)
    }
    //MARK:倒计时结束刷新楼层数据
    @objc fileprivate func refreshShopPage(_ nty: Notification) {
        //防止通知重复刷新
        let currentTime = NSDate().timeIntervalSince1970
        if lastTimeInterval == 0  || (lastTimeInterval > 0 && (currentTime - lastTimeInterval > 1)){
            failedView.isHidden = true
            self.mjfooter.isHidden = true
            self.cellArr.removeAll()
            self.getShowCusterInfo()
            self.getShopBaseInfoAndShopCouponListInfoWithEnterPriseId()
            if FKYLoginAPI.loginStatus() != .unlogin {
                self.getShopCollectionInfo()
            }
            self.getShopOpreateCellListWithEterpriseId()
            //self.getShopRecommendProductListWithEterpriseId(true)
            lastTimeInterval = NSDate().timeIntervalSince1970
        }
    }
    //MARK:刷新整个列表商品数量
    func refreshPromotionProductNum() {
        //刷新配置楼层中的商品
        if self.cellArr.count > 0 {
            for anyModel in self.cellArr {
                if  let model = anyModel as? FKYShopPromotionBaseInfoModel {
                    //热销楼层
                    if let arr = model.productList ,arr.count > 0 {
                        for product in arr {
                            if FKYCartModel.shareInstance().productArr.count > 0 {
                                for cartModel  in FKYCartModel.shareInstance().productArr {
                                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == product.spuCode && cartOfInfoModel.supplyId.intValue == (product.supplyId ?? 0) {
                                            product.carOfCount = cartOfInfoModel.buyNum.intValue
                                            product.carId = cartOfInfoModel.cartId.intValue
                                            break
                                        } else {
                                            product.carOfCount = 0
                                            product.carId = 0
                                        }
                                    }
                                }
                            }else {
                                product.carOfCount = 0
                                product.carId = 0
                            }
                        }
                    }
                }else if let singleCellModel = anyModel as? HomeSingleSecKillCellModel{
                    //单品秒杀
                    if let singleModel = singleCellModel.model,let arr = singleModel.floorProductDtos, arr.count > 0 {
                        let product = arr[0]
                        if FKYCartModel.shareInstance().productArr.count > 0 {
                            for cartModel  in FKYCartModel.shareInstance().productArr {
                                if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                                    if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == product.spuCode && cartOfInfoModel.supplyId.intValue == Int(product.supplyId ?? 0) {
                                        product.carOfCount = cartOfInfoModel.buyNum.intValue
                                        product.carId = cartOfInfoModel.cartId.intValue
                                        break
                                    } else {
                                        product.carOfCount = 0
                                        product.carId = 0
                                    }
                                }
                            }
                        }else {
                            product.carOfCount = 0
                            product.carId = 0
                        }
                    }
                }
            }
        }
        //刷新我的推荐列表中商品的数据
        if self.cellRecommendProductArr.count > 0 {
            for product in self.cellRecommendProductArr {
                if FKYCartModel.shareInstance().productArr.count > 0 {
                    for cartModel  in FKYCartModel.shareInstance().productArr {
                        if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                            if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == product.spuCode && cartOfInfoModel.supplyId.intValue == Int(product.supplyId ?? 0) {
                                product.carOfCount = cartOfInfoModel.buyNum.intValue
                                product.carId = cartOfInfoModel.cartId.intValue
                                break
                            } else {
                                product.carOfCount = 0
                                product.carId = 0
                            }
                        }
                    }
                }else {
                    product.carOfCount = 0
                    product.carId = 0
                }
            }
        }
        self.shopMainTableView.reloadData()
    }
    //MARK:刷新头部视图
    fileprivate func resetShopMainHeaderViewData(){
        if let baseInfoModel = self.enterBaseInfoModel {
            if self.shopType == "1" {
                self.shopMainHeadView.configShopMainHeadViewData(baseModel: baseInfoModel,3)
                self.sectionHeadOne_h = self.shopMainHeadView.getShopMainHeadViewHeight(baseModel: baseInfoModel, 3)
                if let flag = baseInfoModel.drugWelfareFlag, flag==true {
                    self.shopMainHeadView.resetCollectviewHideOrShow(true)
                }else {
                    self.shopMainHeadView.resetCollectviewHideOrShow(false)
                }
            }else {
                self.shopMainHeadView.configShopMainHeadViewData(baseModel: baseInfoModel,1)
                self.sectionHeadOne_h = self.shopMainHeadView.getShopMainHeadViewHeight(baseModel: baseInfoModel, 1)
                self.shopMainHeadView.resetCollectviewHideOrShow(false)
            }
            self.shopMainHeadView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sectionHeadOne_h)
            self.shopMainHeadView.isHidden = false
        }else {
            self.shopMainHeadView.isHidden = true
        }
    }
    //MARK:处理优惠券列表点击逻辑(1:立即领取 2:查看可用商品 3:可用商家)
    fileprivate func dealCouponListViewAction(_ typeIndex:Int,_ indexNum:Int, _ couponsModel:FKYShopCouponsInfoModel){
        if typeIndex == 1 {
            //点击立即领取
            self.getCommonCouponsCode(couponsModel)
            self.addBIWithCommonViewClick((indexNum+1), 4, couponsModel.templateCode ?? "")
        }else if typeIndex == 2 {
            //点击查看可用商品
            self.popCouponVC.removeMySelf()
            FKYNavigator.shared().openScheme(FKY_ShopCouponProductController.self, setProperty: { (vc) in
                let viewController = vc as! CouponProductListViewController
                viewController.couponTemplateId = couponsModel.templateCode ?? ""
                viewController.shopId = (self.shopId ?? "0")
                viewController.couponName = couponsModel.couponFullName ?? ""
                viewController.couponCode = couponsModel.couponsId ?? ""
            })
            self.addBIWithCommonViewClick((indexNum+1),5, couponsModel.templateCode ?? "")
        }else if typeIndex == 3 {
            //查看可用商家
            if let shopArr = couponsModel.allowShops, shopArr.count > 0 {
                //                if shopArr.count == 1 {
                //                    let model = shopArr[0]
                //                    self.popCouponVC.removeMySelf()
                //                    FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { vc in
                //                        let viewController = vc as! FKYNewShopItemViewController
                //                        viewController.shopId = model.tempEnterpriseId
                //                    })
                //                }else{
                //                    self.popShopVC.configPopShopListViewController(shopArr)
                //                }
                self.popShopVC.configPopShopListViewController(shopArr)
                self.addBIWithCommonViewClick((indexNum+1),3, couponsModel.templateCode ?? "")
            }
        }
    }
    //MARK:处理优惠会点击店铺弹框
    fileprivate func dealCouponCanUseShopList(_ model:UseShopModel){
        self.popShopVC.removeMySelf()
        self.popCouponVC.removeMySelf()
        FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { vc in
            let viewController = vc as! FKYNewShopItemViewController
            viewController.shopId = model.tempEnterpriseId
        })
    }
    //MARK:处理促销商品楼层点击逻辑(1:加车 2:商品详情 3:更多)
    fileprivate func dealProtionProductListAction(_ typeIndex:Int,_ selectedItem:Int?,_ promotionModel:FKYShopPromotionBaseInfoModel?,_ productModel:HomeRecommendProductItemModel?,_ indexPath:IndexPath){
        if typeIndex == 1 {
            //加车
            self.popAddCarView(productModel)
        }else if typeIndex == 2 {
            //商品详情
            if let prdModel = productModel {
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = prdModel.spuCode ?? ""
                    v.vendorId = "\(prdModel.supplyId ?? 0)"
                }, isModal: false)
                //埋点
                if let proModel = promotionModel{
                    self.addBISuggestionCell(floorName: proModel.name, floorPosition: proModel.showSequence, sectionIdType: 4, itemIdType: 2, itemPosition: (selectedItem ?? 0) + 1, nil, productModel)
                }
            }
        }else if typeIndex == 3 {
            //查看更多
            if let proModel = promotionModel {
                //埋点
                if let urlInt = proModel.type , urlInt == 106 {
                    //特价活动
                    FKYNavigator.shared().openScheme(FKY_ShopItemOld.self) {(vc) in
                        let shopVC = vc as! ShopItemOldViewController
                        shopVC.type = 1
                        shopVC.shopId = self.shopId
                    }
                    self.addBISuggestionCell(floorName: proModel.name, floorPosition: proModel.showSequence, sectionIdType: 4, itemIdType: 1, itemPosition: 0, nil, nil)
                }else {
                    if let url = proModel.jumpInfoMore, url.count > 0 {
                        if let app = UIApplication.shared.delegate as? AppDelegate {
                            app.p_openPriveteSchemeString(dealSellerCodeForSchemeUrl(url))
                            self.addBISuggestionCell(floorName: proModel.name, floorPosition: proModel.showSequence, sectionIdType: 4, itemIdType: 1, itemPosition: 0, nil, nil)
                        }
                    }
                }
            }
        }
    }
    //MARK:处理广告点击动作(1:点击1栏广告，2: 点击2栏广告 3:点击3栏广告)
    fileprivate func dealAdInfoViewAction(_ adType:Int, _ infoAdModel:HomeADInfoModel, _ selectIndex:Int, _ index : IndexPath){
        if let imgModelArr = infoAdModel.iconImgDTOList, selectIndex < imgModelArr.count {
            let picModel = imgModelArr[selectIndex]
            if let app = UIApplication.shared.delegate as? AppDelegate {
                if let url = picModel.jumpInfo, url.isEmpty == false {
                    app.p_openPriveteSchemeString(dealSellerCodeForSchemeUrl(url))
                    self.addBISuggestionCell(floorName: infoAdModel.name, floorPosition: infoAdModel.showSequence, sectionIdType: 1, itemIdType: 0, itemPosition: (selectIndex+1), picModel.imgName, nil)
                }
            }
        }
    }
    //MARK:处理轮播图点击动作
    fileprivate func dealBannerViewAction(_ indexNum : Int, _ itemModel : HomeCircleBannerItemModel){
        if let app = UIApplication.shared.delegate as? AppDelegate {
            if let url = itemModel.jumpInfo, url.isEmpty == false {
                app.p_openPriveteSchemeString(dealSellerCodeForSchemeUrl(url))
                self.addBIWithCommonViewClick((indexNum+1),6,(itemModel.name ?? ""))
            }
        }
    }
    //MARK:处理导航按钮点击动作
    fileprivate func dealNavgationItemViewAction(_ indexNum : Int, _ itemModel : HomeFucButtonItemModel){
        if let app = UIApplication.shared.delegate as? AppDelegate {
            if let url = itemModel.jumpInfo, url.isEmpty == false {
                app.p_openPriveteSchemeString(dealSellerCodeForSchemeUrl(url))
                self.addBIWithCommonViewClick((indexNum+1),7,(itemModel.name ?? ""))
            }
        }
    }
    //MARK:处理我的推荐点击动作(1:加车 2:跳转到聚宝盆商家专区 3:到货通知 4: 登陆 5:商详)
    fileprivate func dealSuggestionViewAction(_ typeIndex : Int, _ index : IndexPath, _ productModel : HomeCommonProductModel){
        self.seletedIndex = index
        if typeIndex == 1 {
            self.popAddCarView(productModel)
        }else if typeIndex == 2 {
            FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                let controller = vc as! FKYNewShopItemViewController
                controller.shopId = productModel.shopCode ?? ""
                controller.shopType = "1"
            }, isModal: false)
        }else if typeIndex == 3 {
            FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                let controller = vc as! ArrivalProductNoticeVC
                controller.productId = productModel.spuCode
                controller.venderId = "\(productModel.supplyId)"
                controller.productUnit = productModel.packageUnit
            }, isModal: false)
        }else if typeIndex == 4 {
            FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
        }else if typeIndex == 5 {
            FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                let v = vc as! FKY_ProdutionDetail
                v.productionId = productModel.spuCode
                v.vendorId = "\(productModel.supplyId ?? 0)"
                v.updateCarNum = { (carId ,num) in
                    if let count = num {
                        productModel.carOfCount = count.intValue
                    }
                    if let getId = carId {
                        productModel.carId = getId.intValue
                    }
                }
            }, isModal: false)
            let listIndex = index.row - self.cellArr.count - 1
            self.addBIWithRecommendViewClick((listIndex+1), 1, productModel)
        }
    }
    //MARK:处理单品秒杀点击动作( 2:商品详情 3:更多)
    func dealShopSingleSecKillViewAction(_ typeIndex : Int, _ index : IndexPath, _ itmeModel : HomeSecdKillProductModel) {
        if let producArr = itmeModel.floorProductDtos,producArr.count > 0 {
            let productModel = producArr[0]
            self.seletedIndex = index
            if typeIndex == 1 {
                //self.popAddCarView(productModel)
            }else if typeIndex == 2 {
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = productModel.productCode
                    v.vendorId = "\(productModel.supplyId ?? 0)"
                    v.updateCarNum = { (carId ,num) in
                        if let count = num {
                            productModel.carOfCount = count.intValue
                        }
                        if let getId = carId {
                            productModel.carId = getId.intValue
                        }
                    }
                }, isModal: false)
                self.addBISuggestionCell(floorName: itmeModel.name, floorPosition: itmeModel.showSequence, sectionIdType: 2, itemIdType: 2, itemPosition: 1, nil, productModel)
            }else if typeIndex == 3 {
                if let app = UIApplication.shared.delegate as? AppDelegate {
                    if let url = itmeModel.jumpInfoMore, url.isEmpty == false {
                        app.p_openPriveteSchemeString(dealSellerCodeForSchemeUrl(url))
                        self.addBISuggestionCell(floorName: itmeModel.name, floorPosition: itmeModel.showSequence, sectionIdType: 2, itemIdType: 1, itemPosition: 0, nil, nil)
                    }
                }
            }
        }
    }
    //MARK:处理单品秒杀点击动作(1:加车)
    fileprivate func clickSingleProductAddCar(_ itmeModel : HomeSecdKillProductModel , _ index: IndexPath ,_ count: Int ,_ typeIndex: Int) {
        if let producArr = itmeModel.floorProductDtos,producArr.count > 0 {
            let product = producArr[0]
            self.seletedIndex = index
            //typeIndex为2的时候延迟加车接口请求
            if typeIndex == 2 || typeIndex == 3 {
                //延迟加车
                return
            }
            if product.carOfCount > 0 && product.carId != 0 {
                self.showLoading()
                if count == 0 {
                    //数量变零，删除购物车
                    self.service.deleteShopCart([product.carId], success: { (mutiplyPage) in
                        FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ [weak self] (success) in
                            //更新
                            if let strongSelf = self {
                                product.carId = 0
                                product.carOfCount = 0
                                if let index = strongSelf.seletedIndex{
                                    strongSelf.shopMainTableView.reloadRows(at: [index], with: .none)
                                }
                                strongSelf.dismissLoading()
                            }
                            }, failure: { [weak self] (reason) in
                                if let strongSelf = self {
                                    if let index = strongSelf.seletedIndex{
                                        strongSelf.shopMainTableView.reloadRows(at: [index], with: .none)
                                    }
                                    strongSelf.dismissLoading()
                                    strongSelf.toast(reason)
                                }
                        })
                    }, failure: { [weak self] (reason) in
                        if let strongSelf = self {
                            if let index = strongSelf.seletedIndex{
                                strongSelf.shopMainTableView.reloadRows(at: [index], with: .none)
                            }
                            strongSelf.dismissLoading()
                            strongSelf.toast(reason)
                        }
                    })
                }else {
                    // 更新购物车...<商品数量变化时需刷新数据>
                    self.service.updateShopCart(forProduct: "\(product.carId)", quantity: count, allBuyNum: -1, success: { (mutiplyPage,aResponseObject) in
                        FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ [weak self] (success) in
                            if let strongSelf = self {
                                strongSelf.dismissLoading()
                                product.carOfCount = count
                                if let index = strongSelf.seletedIndex{
                                    strongSelf.shopMainTableView.reloadRows(at: [index], with: .none)
                                }
                                strongSelf.addBISuggestionCell(floorName: itmeModel.name, floorPosition: itmeModel.showSequence, sectionIdType: 2, itemIdType: 3, itemPosition: 1, nil, product)
                            }
                            }, failure: { [weak self] (reason) in
                                if let strongSelf = self {
                                    if let index = strongSelf.seletedIndex{
                                        strongSelf.shopMainTableView.reloadRows(at: [index], with: .none)
                                    }
                                    strongSelf.dismissLoading()
                                    strongSelf.toast(reason)
                                }
                        })
                    }, failure: { [weak self] (reason) in
                        if let strongSelf = self {
                            if let index = strongSelf.seletedIndex{
                                strongSelf.shopMainTableView.reloadRows(at: [index], with: .none)
                            }
                            strongSelf.dismissLoading()
                            strongSelf.toast(reason)
                        }
                    })
                }
            }
            else if count > 0 {
                self.showLoading()
                //加车埋点
                //  self.biRecord(row, product)
                // 加车
                self.shopProvider.addShopCart(product,HomeString.SHOPITEM_FIRST_ADD_SOURCE_TYPE,count: count, completionClosure: { [weak self] (reason, data) in
                    // 说明：若reason不为空，则加车失败；若data不为空，则限购商品加车失败
                    if let re = reason {
                        if re == "成功" {
                            FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ [weak self] (success) in
                                if let strongSelf = self {
                                    product.carOfCount = count
                                    for cartModel  in FKYCartModel.shareInstance().productArr {
                                        if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == product.spuCode && cartOfInfoModel.supplyId.intValue == (product.supplyId ?? 0) {
                                            product.carId = cartOfInfoModel.cartId.intValue
                                            break
                                        }
                                    }
                                    if let index = strongSelf.seletedIndex{
                                        strongSelf.shopMainTableView.reloadRows(at: [index], with: .none)
                                    }
                                    strongSelf.dismissLoading()
                                    strongSelf.addBISuggestionCell(floorName: itmeModel.name, floorPosition: itmeModel.showSequence, sectionIdType: 2, itemIdType: 3, itemPosition: 1, nil, product)
                                }
                                }, failure: { [weak self] (reason) in
                                    if let strongSelf = self {
                                        if let index = strongSelf.seletedIndex{
                                            strongSelf.shopMainTableView.reloadRows(at: [index], with: .none)
                                        }
                                        strongSelf.dismissLoading()
                                        strongSelf.toast(reason)
                                    }
                            })
                        }else {
                            if let strongSelf = self {
                                if let index = strongSelf.seletedIndex{
                                    strongSelf.shopMainTableView.reloadRows(at: [index], with: .none)
                                }
                                strongSelf.dismissLoading()
                                strongSelf.toast(reason)
                            }
                        }
                    }
                })
            }
            
        }
    }
    //MARK:处理多品秒杀点击动作(1:更多 2:商品详情)<typeIndex ：类型 index：列表中楼层的位子 prdIndex：楼层中商品的位子 itmeModel 楼层模型 desModel：商品模型 >
    func dealShopManySecKillViewAction(_ typeIndex : Int, _ index : IndexPath, _ prdIndex:Int? , _ itmeModel : HomeSecdKillProductModel,_ desModel:HomeRecommendProductItemModel?){
        if typeIndex == 2 {
            if let productModel = desModel {
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = productModel.productCode
                    v.vendorId = "\(productModel.supplyId ?? 0)"
                    v.updateCarNum = { (carId ,num) in
                        if let count = num {
                            productModel.carOfCount = count.intValue
                        }
                        if let getId = carId {
                            productModel.carId = getId.intValue
                        }
                    }
                }, isModal: false)
                self.addBISuggestionCell(floorName: itmeModel.name, floorPosition: itmeModel.showSequence, sectionIdType: 3, itemIdType: 2, itemPosition: ((prdIndex ?? 0) + 1), nil, productModel)
            }
        }else {
            if let app = UIApplication.shared.delegate as? AppDelegate {
                if let url = itmeModel.jumpInfoMore, url.isEmpty == false {
                    app.p_openPriveteSchemeString(dealSellerCodeForSchemeUrl(url))
                    self.addBISuggestionCell(floorName: itmeModel.name, floorPosition: itmeModel.showSequence, sectionIdType: 3, itemIdType: 1, itemPosition: 0, nil, nil)
                }
            }
        }
    }
    //MARK:处理跳转链接对没有商家 ID的链接统一加上商家ID
    func dealSellerCodeForSchemeUrl(_ url:String)->String{
        //现在只针对一起购秒杀和搜索增加商家ID
        if !((url.hasPrefix("fky://secKillList")) || (url.hasPrefix("fky://yqgActive")) || (url.hasPrefix("fky://search/searchResult"))){
            return url
        }
        var sechemUrl = url
        var shopIdStr = self.shopId
        if let infoModel = self.enterBaseInfoModel {
            //药福利
            if let flag = infoModel.drugWelfareFlag ,flag == true {
                shopIdStr = infoModel.realEnterpriseId
            }
        }
        if sechemUrl.contains("?"){
            if sechemUrl.contains("sellerCode"){
                
            }else{
                sechemUrl += "&sellerCode=\(shopIdStr ?? "")"
            }
        }else{
            sechemUrl += "?"
            if sechemUrl.contains("sellerCode"){
                
            }else{
                sechemUrl += "sellerCode=\(shopIdStr ?? "")"
            }
        }
        return sechemUrl
    }
}
//MARK:网络请求相关
extension FKYShopMainViewController{
    //MARK:获取店铺是否收藏信息接口
    func getShopCollectionInfo(){
        FKYRequestService.sharedInstance()?.requestForGetShopCollectionInfo(withParam: ["enterpriseId":self.shopId ?? ""], completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                strongSelf.toast(msg)
                strongSelf.shopMainHeadView.configShopMainHeadCollection(false)
                return
            }
            //0代表未收藏 1代表已收藏
            if let infoModel = response as? NSDictionary,let isCollect = infoModel["isCollect"] as? Int , isCollect == 1 {
                //已收藏
                strongSelf.shopMainHeadView.configShopMainHeadCollection(true)
            }else {
                //未收藏
                strongSelf.shopMainHeadView.configShopMainHeadCollection(false)
            }
        })
    }
    //MARK:收藏or取消店铺接口
    func addOrCancellShopCollectionInfo(_ hasCollect:Bool){
        FKYRequestService.sharedInstance()?.requestForGetShopAddOrCancellCollection(withParam: ["type":hasCollect ? "cancel":"add","enterpriseId":self.shopId ?? ""], completionBlock: { [weak self] (success, error, response, model) in
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
                strongSelf.toast("取消收藏成功")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cancelFav"), object: self?.shopId, userInfo: nil)
            }else{
                strongSelf.toast("收藏成功")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addFav"), object: self?.shopId, userInfo: nil)
            }
            strongSelf.shopMainHeadView.configShopMainHeadCollection(!hasCollect)
            
        })
    }
    
    //MARK:判断是否显示联系客服入口接口
    func getShowCusterInfo (){
        if FKYLoginAPI.loginStatus() == .unlogin {
            //隐藏卖家入口
            self.showCustomer = false
            return
        }
        FKYRequestService.sharedInstance()?.requesImShow(withParam: ["enterpriseId":self.shopId ?? ""], completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            if success==true,let showNum = response as? Int,showNum==0 {
                //展示卖家客服入口
                strongSelf.showCustomer = true
            }else{
                //隐藏卖家入口
                strongSelf.showCustomer = false
            }
        })
    }
    //MARK:获取店铺头部信息及优惠券列表信息
    fileprivate func getShopBaseInfoAndShopCouponListInfoWithEnterPriseId(){
        FKYRequestService.sharedInstance()?.requestForGetShopEnterpriseInfoAndCouponInfo(withParam: ["enterpriseId":self.shopId ?? ""], completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                strongSelf.toast(msg)
                strongSelf.failedView.isHidden = false
                return
            }
            if let infoModel = model as? FKYShopEnterAndCouponInfoModel {
                strongSelf.enterBaseInfoModel = infoModel.enterpriseInfoVO
                strongSelf.resetShopMainHeaderViewData()
                if let block = strongSelf.updateBottomFuctionView,let baseInfoModel = strongSelf.enterBaseInfoModel {
                    //更新底部商品数量
                    block(baseInfoModel.allProductCount ?? 0)
                }
                if let arr = infoModel.couponInfo,arr.count > 0 {
                    strongSelf.cellArr.insert(arr, at: 0)
                }
                if let fullModel = infoModel.fullReductionInfoVo,let str = fullModel.promotionDesc ,str.count > 0{
                    strongSelf.cellArr.insert(fullModel, at: 0)
                }
                strongSelf.shopMainTableView.reloadData()
            }else {
                strongSelf.failedView.isHidden = false
            }
        })
    }
    //MARK:获取运营配置列表
    fileprivate func getShopOpreateCellListWithEterpriseId(){
        self.recommendViewModel.getShopOpreateCellList(self.shopId) { [weak self] (dataArr,hasNavList, tip) in
            guard let strongSelf = self else{
                return
            }
            if let msg = tip {
                strongSelf.toast(msg)
            }else {
                //请求成功
                if let arr = dataArr, arr.count > 0 {
                    strongSelf.cellArr = strongSelf.cellArr + arr
                    strongSelf.shopMainTableView.reloadData()
                }
                strongSelf.hasNavArray = hasNavList ?? false
            }
        }
    }
    //MARK:获取推荐列表
    fileprivate func getShopRecommendProductListWithEterpriseId(_ isFresh:Bool) {
        if isFresh == true {
            self.mjfooter.resetNoMoreData()
        }
        self.recommendViewModel.getShopRecommendProductList(isFresh, self.shopId) { [weak self] (hasMoreData,dataArr, tip) in
            guard let strongSelf = self else{
                return
            }
            if isFresh == true {
                strongSelf.dismissLoading()
            }
            if hasMoreData == true {
                strongSelf.mjfooter.endRefreshing()
            }else {
                strongSelf.mjfooter.endRefreshingWithNoMoreData()
            }
            strongSelf.mjfooter.isHidden = false
            strongSelf.hasRecommendMoreData = hasMoreData
            if let msg = tip {
                strongSelf.toast(msg)
            }else {
                //请求成功
                if let arr = dataArr{
                    strongSelf.cellRecommendProductArr = arr
                    strongSelf.shopMainTableView.reloadData()
                }
            }
        }
    }
    //MARK:领取优惠券
    func getCommonCouponsCode(_ couponModel : FKYShopCouponsInfoModel?) {
        if let commonModel = couponModel {
            let parameters = [ "template_code": commonModel.templateCode ?? ""] as [String : Any]
            FKYRequestService.sharedInstance()?.postReceiveCommonCouponInfo(withParam: parameters, completionBlock: { [weak self] (success, error, response, model) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.dismissLoading()
                guard success else {
                    // 失败
                    let msg = error?.localizedDescription ?? "获取失败"
                    strongSelf.toast(msg)
                    return
                }
                if let couModel = model as? CouponModel {
                    commonModel.received = true
                    commonModel.isLimitProduct = couModel.isLimitProduct
                    if let endStr = couModel.endDate {
                        commonModel.couponEndTime = endStr.dateChangeToFormat("MM.dd")
                    }
                    if let beginStr = couModel.begindate {
                        commonModel.couponStartTime = beginStr.dateChangeToFormat("MM.dd")
                    }
                    strongSelf.shopMainTableView.reloadData()
                    strongSelf.popCouponVC.reloadPopCouponListViewController()
                    strongSelf.toast("领取成功")
                }
            })
        }
    }
}

//MARK:UITableViewDelegate
extension FKYShopMainViewController :UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < self.cellArr.count {
            if let model = self.cellArr[indexPath.row] as? FKYShopPromotionBaseInfoModel {
                //展示促销类型选择行or不展示
                if let productArr = model.productList {
                    return FKYShopPromotionProuductCell.configShopPromotionCellH(productArr)
                }
            }else if let _ = self.cellArr[indexPath.row] as? FKYfullReductionInfoVoModel {
                //多品满折
                return WH(49)
            }else if let copounArr = self.cellArr[indexPath.row] as? [FKYShopCouponsInfoModel] {
                return FKYShopCouponsTableViewCell.configShopCouponsTableViewH(copounArr,self.showTowCouponView)
            }else if let singleCellModel = self.cellArr[indexPath.row] as? HomeSingleSecKillCellModel{
                if let singleModel = singleCellModel.model {
                    return  ShopSingleSecKillCell.getCellContentHeight(singleModel)
                }
                return CGFloat.leastNormalMagnitude
            }else if let seckillCellModel = self.cellArr[indexPath.row] as? HomeSecKillCellModel {
                return ShopManySecKillCell.getCellContentHeight()
            }else if let bannerModel = self.cellArr[indexPath.row] as? HomeCircleBannerModel {
                return ShopBannerListCell.getCellContentHeight(self.hasNavArray)
            }else if let modelArr = self.cellArr[indexPath.row] as? HomeFucButtonModel {
                return ShopNavBtnListCell.getCellContentHeight(modelArr)
            }else if let _ = self.cellArr[indexPath.row] as? HomeADCellModel {
                return ShopOneAdPageCell.getCellContentHeight()
            }else if let _ = self.cellArr[indexPath.row] as? HomeTwoADCellModel {
                return ShopTwoAdPageCell.getCellContentHeight()
            }else if let _ = self.cellArr[indexPath.row] as? HomeThreeADCellModel {
                return ShopThreeAdPageCell.getCellContentHeight()
            }
        }else if indexPath.row == self.cellArr.count {
            return WH(34)
        }else {
            let listIndex = (indexPath.row-self.cellArr.count-1)
            if self.cellRecommendProductArr.count > listIndex && listIndex >= 0 {
                let prdModel = self.cellRecommendProductArr[listIndex]
                return ProductInfoListCell.getCellContentHeight(prdModel)
            }
        }
        
        return WH(0.01)
    }
    
}
//MARK:UITableViewDataSource
extension FKYShopMainViewController :UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.cellRecommendProductArr.count > 0 {
            //为你推荐title
            return self.cellArr.count + 1 + self.cellRecommendProductArr.count
        }
        return self.cellArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.cellArr.count {
            if let model = self.cellArr[indexPath.row] as? FKYShopPromotionBaseInfoModel {
                //MARK:热销商品楼层
                let cell: FKYShopPromotionProuductCell = tableView.dequeueReusableCell(withIdentifier: "FKYShopPromotionProuductCell", for: indexPath) as! FKYShopPromotionProuductCell
                cell.configShopPromotionProudctCell(model)
                cell.clickViewBock = { [weak self] (typeIndex,selectedItem,promotionModel,productModel) in
                    if let strongSelf = self {
                        strongSelf.seletedIndex = indexPath
                        strongSelf.seletedItem = selectedItem ?? 0
                        strongSelf.dealProtionProductListAction(typeIndex,selectedItem, promotionModel, productModel, indexPath)
                    }
                }
                return cell
            }else if let promotionModel = self.cellArr[indexPath.row] as? FKYfullReductionInfoVoModel {
                //MARK:多品满折
                let cell: PDPromotionCell = tableView.dequeueReusableCell(withIdentifier: "FKYShopPDPromotionCell", for: indexPath) as! PDPromotionCell
                cell.configShopDetailPromotionDiscount(promotionModel)
            }else if let modelArr = self.cellArr[indexPath.row] as? [FKYShopCouponsInfoModel] {
                //MARK:优惠券楼层
                let cell: FKYShopCouponsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYShopCouponsTableViewCell", for: indexPath) as! FKYShopCouponsTableViewCell
                cell.configShopCouponsViewData(modelArr,self.showTowCouponView)
                cell.clickCouponsTableView = { [weak self] (typeIndex,indexNum,couponsModel) in
                    if let strongSelf = self {
                        strongSelf.dealCouponListViewAction(typeIndex,indexNum,couponsModel)
                    }
                }
                //查看更多优惠券
                cell.showMoreCouponView = { [weak self] (clickType) in
                    if let strongSelf = self {
                        if clickType == 2 {
                            strongSelf.showTowCouponView = true
                            strongSelf.shopMainTableView.reloadRows(at: [indexPath], with: .none)
                        }else {
                            strongSelf.popCouponVC.configPopCouponListViewController(modelArr)
                        }
                        strongSelf.addBIWithCommonViewClick(0,2,nil)
                    }
                }
                return cell
            }else if let singleCellModel = self.cellArr[indexPath.row] as? HomeSingleSecKillCellModel {
                //MARK:单品秒杀
                let cell: ShopSingleSecKillCell = tableView.dequeueReusableCell(withIdentifier: "ShopSingleSecKillCell", for: indexPath) as! ShopSingleSecKillCell
                if let singleModel = singleCellModel.model {
                    cell.configCell(singleModel)
                    //加车更新
                    cell.updateAddProductNum = { [weak self] (count,typeIndex) in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.clickSingleProductAddCar(singleModel,indexPath,count,typeIndex)
                    }
                    //加车提示
                    cell.toastAddProductNum = { [weak self] (tipStr) in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.toast(tipStr)
                    }
                    // 商详
                    cell.touchItem = { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.dealShopSingleSecKillViewAction(2, indexPath, singleModel)
                    }
                    // 查看更多
                    cell.moreCallback = { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.dealShopSingleSecKillViewAction(3, indexPath, singleModel)
                    }
                }
                return cell
            }else if let seckillCellModel = self.cellArr[indexPath.row] as? HomeSecKillCellModel {
                //MARK:多个商品秒杀
                let cell: ShopManySecKillCell = tableView.dequeueReusableCell(withIdentifier: "ShopManySecKillCell", for: indexPath) as! ShopManySecKillCell
                cell.configHomePromotionCell(seckillCellModel)
                cell.clickViewAction = { [weak self] (typeIndex,itemIndex,productModel) in
                    guard let strongSelf = self else {
                        return
                    }
                    if let itemModel = seckillCellModel.model {
                        strongSelf.dealShopManySecKillViewAction(typeIndex,indexPath,itemIndex,itemModel,productModel)
                    }
                }
                return cell
            }else if let bannerModel = self.cellArr[indexPath.row] as? HomeCircleBannerModel {
                //MARK:轮播图
                let cell: ShopBannerListCell = tableView.dequeueReusableCell(withIdentifier: "ShopBannerListCell", for: indexPath) as! ShopBannerListCell
                cell.configCell(banner: bannerModel)
                cell.clickBannerItem = { [weak self] (indexNum, itemModel) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.dealBannerViewAction(indexNum, itemModel)
                }
                return cell
            }else if let modelArr = self.cellArr[indexPath.row] as? HomeFucButtonModel {
                //MARK:导航功能按钮
                let cell: ShopNavBtnListCell = tableView.dequeueReusableCell(withIdentifier: "ShopNavBtnListCell", for: indexPath) as! ShopNavBtnListCell
                cell.configCell(modelArr)
                cell.clickNavItemBlock = { [weak self] (indexNum, itemModel) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.dealNavgationItemViewAction(indexNum, itemModel)
                }
                return cell
            }else if let adModel = self.cellArr[indexPath.row] as? HomeADCellModel {
                //MARK:一栏广告
                let cell: ShopOneAdPageCell = tableView.dequeueReusableCell(withIdentifier: "ShopOneAdPageCell", for: indexPath) as! ShopOneAdPageCell
                if let adInfoModel = adModel.model {
                    cell.configCell(adInfoModel)
                    cell.checkAdBlock = { [weak self] (typeIndex) in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.dealAdInfoViewAction(1, adInfoModel,typeIndex,indexPath)
                    }
                }
                return cell
            }else if let adTwoModel = self.cellArr[indexPath.row] as? HomeTwoADCellModel {
                //MARK:两栏广告
                let cell: ShopTwoAdPageCell = tableView.dequeueReusableCell(withIdentifier: "ShopTwoAdPageCell", for: indexPath) as! ShopTwoAdPageCell
                if let adInfoModel = adTwoModel.model {
                    cell.configCell(adInfoModel)
                    cell.checkAdBlock = { [weak self] (typeIndex) in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.dealAdInfoViewAction(2, adInfoModel,typeIndex,indexPath)
                    }
                }
                
                return cell
            }else if let adThtreeModel = self.cellArr[indexPath.row] as? HomeThreeADCellModel {
                //MARK:三栏个广告
                let cell: ShopThreeAdPageCell = tableView.dequeueReusableCell(withIdentifier: "ShopThreeAdPageCell", for: indexPath) as! ShopThreeAdPageCell
                if let adInfoModel = adThtreeModel.model {
                    cell.configCell(adInfoModel)
                    cell.checkAdBlock = { [weak self] (typeIndex) in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.dealAdInfoViewAction(3, adInfoModel,typeIndex,indexPath)
                    }
                }
                return cell
            }
        }else if indexPath.row == self.cellArr.count {
            //MARK:为你推荐title
            let cell: FKYRecommendTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYRecommendTitleTableViewCell", for: indexPath) as! FKYRecommendTitleTableViewCell
            cell.resetTitle()
            return cell
        }else {
            //MARK:我的推荐
            let cell: ProductInfoListCell = tableView.dequeueReusableCell(withIdentifier: "ShopProductInfoListCell", for: indexPath) as! ProductInfoListCell
            let listIndex = (indexPath.row-self.cellArr.count-1)
            if self.cellRecommendProductArr.count > listIndex && listIndex >= 0 {
                let prdModel = self.cellRecommendProductArr[listIndex]
                cell.configCell(prdModel)
                cell.resetContentLayerColor()
                //更新加车数量
                cell.addUpdateProductNum = { [weak self] in
                    if let strongSelf = self {
                        strongSelf.dealSuggestionViewAction(1, indexPath, prdModel)
                    }
                }
                //跳转到聚宝盆商家专区
                cell.clickJBPContentArea = { [weak self] in
                    if let strongSelf = self {
                        strongSelf.dealSuggestionViewAction(2, indexPath, prdModel)
                    }
                }
                //到货通知
                cell.productArriveNotice = { [weak self] in
                    if let strongSelf = self {
                        strongSelf.dealSuggestionViewAction(3, indexPath, prdModel)
                    }
                }
                //登录
                cell.loginClosure = { [weak self] in
                    if let strongSelf = self {
                        strongSelf.dealSuggestionViewAction(4, indexPath, prdModel)
                    }
                }
                // 商详
                cell.touchItem = { [weak self] in
                    if let strongSelf = self {
                        strongSelf.dealSuggestionViewAction(5, indexPath, prdModel)
                    }
                }
                
                //套餐按钮
                cell.clickComboBtn = { [weak self] in
                    if let _ = self {
                        if let num = prdModel.dinnerPromotionRule , num == 2 {
                            //固定套餐
                            FKYNavigator.shared().openScheme(FKY_ComboList.self, setProperty: { (vc) in
                                let controller = vc as! FKYComboListViewController
                                controller.enterpriseName = prdModel.supplyName
                                controller.sellerCode = prdModel.supplyId
                                controller.spuCode = prdModel.spuCode ?? ""
                            }, isModal: false)
                        }else {
                            //搭配套餐
                            FKYNavigator.shared().openScheme(FKY_MatchingPackageVC.self, setProperty: { (vc) in
                                let controller = vc as! FKYMatchingPackageVC
                                controller.spuCode = prdModel.spuCode
                                controller.enterpriseId = "\(prdModel.supplyId)"
                            }, isModal: false)
                        }
                    }
                }
            }
            return cell
        }
        //空白分割行
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "error")
        cell.backgroundColor =  RGBColor(0xF4F4F4)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.cellArr.count {
            if let promotionModel = self.cellArr[indexPath.row] as? FKYfullReductionInfoVoModel {
                //多品满折
                FKYNavigator.shared().openScheme(FKY_ShopItemOld.self) { (vc) in
                    let shopVC = vc as! ShopItemOldViewController
                    shopVC.type = 5
                    shopVC.promotionId = promotionModel.promotionId
                    shopVC.shopId = self.shopId
                }
            }
        }
    }
}
//MARK:UIScrollViewDelegate代理
extension FKYShopMainViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //促销列表接口回来了才触发这个逻辑
        if self.hasRecommendMoreData == false {
            //自动滑倒下一页逻辑
            if  scrollView.isTracking || scrollView.isDragging {
                let y = scrollView.contentOffset.y
                let height:CGFloat = scrollView.frame.size.height
                if height >= scrollView.contentSize.height {
                    //内容视图小于控制器的高度
                    if  y > WH(70) {
                        if let block = self.goToNextPage {
                            self.hasGoNext = true
                            block()
                        }
                    }
                }else {
                    if (y+height-scrollView.contentSize.height-MJRefreshFooterHeight) > WH(70) {
                        if let block = self.goToNextPage {
                            self.hasGoNext = true
                            block()
                        }
                    }
                }
            }
        }
    }
}
//MARK:bi埋点
extension FKYShopMainViewController {
    //MARK:(1:采购须知/收藏/取消收藏 2:显示全部优惠券 3:查看可用商家 4:立即领取 5:查看可用商品)
    fileprivate func addBIWithCommonViewClick(_ itemPosition:Int, _ itemIdType:Int,_ comStr:String?){
        var itemName = ""
        var itemId = ""
        var floorName : String?
        var itemTitle : String?
        var sectionId : String?
        var sectionName : String?
        var sectionPosition : String?
        
        if itemIdType == 1 {
            itemId = ITEMCODE.SHOP_DETAIL_ENTER_COLLECT_INFO_CODE.rawValue
            if itemPosition == 1 {
                itemName = "采购须知"
            }else if itemPosition == 2 {
                itemName = "收藏/取消收藏"
            }
        }else if itemIdType == 2 {
            //显示全部优惠券
            floorName = "优惠券模块"
            itemId = ITEMCODE.SHOP_DETAIL_COUPONS_CATCH_CODE.rawValue
            itemName = "显示全部优惠券"
        }else if itemIdType == 3 {
            //查看可用商家
            floorName = "优惠券模块"
            sectionId = SECTIONCODE.SHOP_DETAIL_COUPON_LIST_CODE.rawValue
            sectionName = "平台券-查看"
            sectionPosition = "1"
            itemId = ITEMCODE.SHOP_DETAIL_COUPONS_CATCH_CODE.rawValue
            itemName = "查看可用商家"
            itemTitle = comStr
        }else if itemIdType == 4 {
            //立即领取
            floorName = "优惠券模块"
            sectionId = SECTIONCODE.SHOP_DETAIL_COUPON_LIST_CODE.rawValue
            sectionName = "店铺券-领取"
            sectionPosition = "2"
            itemId = ITEMCODE.SHOP_DETAIL_COUPONS_CATCH_CODE.rawValue
            itemName = "立即领取"
            itemTitle = comStr
        }else if itemIdType == 5 {
            //查看可用商品
            floorName = "优惠券模块"
            sectionId = SECTIONCODE.SHOP_DETAIL_COUPON_LIST_CODE.rawValue
            sectionName = "店铺券-查看"
            sectionPosition = "3"
            itemId = ITEMCODE.SHOP_DETAIL_COUPONS_CATCH_CODE.rawValue
            itemName = "查看可用商品"
            itemTitle = comStr
        }else if itemIdType == 6 {
            //点击轮播图
            itemId = ITEMCODE.SHOP_DETAIL_SHOP_BANNER_LIST_CODE.rawValue
            itemName = "点击轮播图"
            itemTitle = comStr
        }else if itemIdType == 7 {
            //点击icon
            itemId = ITEMCODE.SHOP_DETAIL_SHOP_NAVAGATION_LIST_CODE.rawValue
            itemName = "点击icon"
            itemTitle = comStr
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: floorName, sectionId: sectionId, sectionPosition: sectionPosition, sectionName: sectionName, itemId: itemId, itemPosition: "\(itemPosition)", itemName: itemName, itemContent: nil, itemTitle: itemTitle, extendParams: ["pageValue":self.shopId ?? ""] as [String : AnyObject], viewController: self)
    }
    //MARK:(1:中通广告 2:秒杀单品 3:秒杀多品 4:普通商品楼层)
    fileprivate func addBISuggestionCell(floorName:String?, floorPosition:Int?,sectionIdType:Int,itemIdType:Int,itemPosition:Int,_ comStr:String?,_ prdModel:Any?){
        let floorId = FLOORID.SHOP_DETAIL_RECOMMEND_PRODUCT_FLOOR.rawValue
        var sectionId : String?
        var sectionName : String?
        var itemId : String?
        var itemName : String?
        var itemTitle : String?
        var itemContent :String?
        var floorPositionStr:String?
        if sectionIdType == 1 {
            //中通广告
            sectionId = SECTIONCODE.SHOP_DETAIL_AD_LIST_CODE.rawValue
            sectionName = "中通广告"
            itemId = ITEMCODE.SHOP_DETAIL_SHOP_AD_LIST_CODE.rawValue
            itemName = "点击广告图"
            itemTitle = comStr
        }else if sectionIdType == 2 {
            //秒杀单品
            sectionId = SECTIONCODE.SHOP_DETAIL_SINGLE_PRD_LIST_CODE.rawValue
            sectionName = "秒杀单品"
            if itemIdType == 1 {
                //查看更多
                itemId = ITEMCODE.SHOP_DETAIL_SHOP_SIGLE_PRD_MORE_CODE.rawValue
                itemName = "查看更多"
            }else if itemIdType == 2 {
                //点进商详
                itemId = ITEMCODE.HOME_ACTION_COMMON_CLICK_PRDDETAIL.rawValue
                itemName = "点进商详"
            }else if itemIdType == 3 {
                //加车
                itemId = ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue
                itemName = "加车"
            }
        }else if sectionIdType == 3 {
            //秒杀多品
            sectionId = SECTIONCODE.SHOP_DETAIL_MANEY_PRD_LIST_CODE.rawValue
            sectionName = "秒杀多品"
            if itemIdType == 1 {
                //查看更多
                itemId = ITEMCODE.SHOP_DETAIL_SHOP_MANY_PRD_MORE_CODE.rawValue
                itemName = "查看更多"
            }else if itemIdType == 2 {
                //点进商详
                itemId = ITEMCODE.HOME_ACTION_COMMON_CLICK_PRDDETAIL.rawValue
                itemName = "点进商详"
            }else if itemIdType == 3 {
                //加车
                itemId = ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue
                itemName = "加车"
            }
        }else if sectionIdType == 4 {
            //普通商品楼层
            sectionId = SECTIONCODE.SHOP_DETAIL_PRD_LIST_CODE.rawValue
            sectionName = "普通商品楼层"
            if itemIdType == 1 {
                //查看更多
                itemId = ITEMCODE.SHOP_DETAIL_SHOP_PRD_MORE_CODE.rawValue
                itemName = "查看更多"
            }else if itemIdType == 2 {
                //点进商详
                itemId = ITEMCODE.HOME_ACTION_COMMON_CLICK_PRDDETAIL.rawValue
                itemName = "点进商详"
            }else if itemIdType == 3 {
                //加车
                itemId = ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue
                itemName = "加车"
            }
        }
        var extendParams = ["pageValue":self.shopId ?? ""]
        if let model = prdModel as? HomeRecommendProductItemModel {
            itemContent = "\(model.supplyId ?? 0)|\(model.spuCode ?? "")"
            extendParams["storage"] = model.storage
            extendParams["pm_price"] = model.pm_price
            extendParams["pm_pmtn_type"] = model.pm_pmtn_type
        }
        if let num = floorPosition {
            floorPositionStr = "\(num)"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(floorId, floorPosition: floorPositionStr, floorName: floorName, sectionId: sectionId, sectionPosition: "1", sectionName: sectionName, itemId: itemId, itemPosition: "\(itemPosition)", itemName: itemName, itemContent: itemContent, itemTitle: itemTitle, extendParams: extendParams as [String : AnyObject], viewController: self)
    }
    //MARK:推荐商品埋点
    fileprivate func addBIWithRecommendViewClick(_ itemPosition:Int, _ itemIdType:Int,_ prdModel:HomeCommonProductModel?){
        let sectionId = SECTIONCODE.SHOP_DETAIL_RECOMMEND_PRD_LIST_CODE.rawValue
        var itemId : String?
        var itemName : String?
        var itemContent :String?
        if itemIdType == 1 {
            itemId = ITEMCODE.HOME_ACTION_COMMON_CLICK_PRDDETAIL.rawValue
            itemName = "点进商详"
        }else if itemIdType == 2 {
            itemId = ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue
            itemName = "加车"
        }
        var extendParams = ["pageValue":self.shopId ?? ""]
        if let model = prdModel{
            itemContent = "\(model.supplyId ?? 0)|\(model.spuCode ?? "")"
            extendParams["storage"] = model.storage
            extendParams["pm_price"] = model.pm_price
            extendParams["pm_pmtn_type"] = model.pm_pmtn_type
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: sectionId, sectionPosition: "1", sectionName: "为您推荐", itemId: itemId, itemPosition: "\(itemPosition)", itemName: itemName, itemContent: itemContent, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: self)
    }
}


