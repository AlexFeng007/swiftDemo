//
//  FKYMedicineViewController.swift
//  FKY
//
//  Created by hui on 2018/11/22.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  店铺管-商家活动-中药

import UIKit

class FKYMedicineViewController: UIViewController,NewShoplistItemProtocol {
    var scrollBlock: ((CGFloat) -> ())?
    var bgScrollOffset: CGFloat = 0.0
//    //行高管理器
//    fileprivate var cellHeightManager:ContentHeightManager = {
//        let heightManager = ContentHeightManager()
//        return heightManager
//    }()
    //MARK:UI控件
    fileprivate lazy var emptyView: StaticView = {
        let ev = StaticView()
        ev.configView("icon_cart_add_empty", title: "暂无结果", btnTitle: "重新加载")
        ev.isHidden = true
        self.view.addSubview(ev)
        ev.snp.makeConstraints({(make) in
            make.edges.equalTo(self.view)
        })
        //重新加载
        ev.actionBlock = {[weak self] in
            guard let strongSelf = self else {
                return
            }
            //            self.medicineCollectionView.isHidden = false
            //            self.emptyView.isHidden = true
            strongSelf.medicineCollectionView.mj_header.beginRefreshing()
        }
        return ev
    }()
    
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            self?.getMedicineListData(1)
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.activityIndicatorViewStyle = UIActivityIndicatorView.Style.white
        header?.stateLabel.textColor = UIColor.white
        return header!
    }()
    
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            self?.getMedicineListData(2)
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    
    fileprivate lazy var medicineCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(FKYBannerBgCell.self, forCellWithReuseIdentifier: "FKYBannerBgCell")
        cv.register(CommonProductItemCell.self, forCellWithReuseIdentifier: "CommonProductItemCell")
        cv.register(FKYMedicineTitleCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FKYMedicineTitleCell")
        cv.backgroundColor = UIColor.white
        cv.showsVerticalScrollIndicator = false
        cv.mj_header = self.mjheader
        cv.mj_footer = self.mjfooter
        cv.mj_footer.isAutomaticallyHidden = true
        if #available(iOS 11, *) {
            cv.contentInsetAdjustmentBehavior = .never
        }
        return cv
    }()
    
    //商品加车弹框
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
                strongSelf.refreshItemOfCollectionView()
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? FKYMedicinePrdDetModel {
                    let sectionPosition = strongSelf.hasBannerList == true ? "\(model.indexPath!.section)" : "\(model.indexPath!.section+1)"
                    let itemContent = "\(model.productSupplyId ?? "0")|\(model.productCode ?? "0")"
                    let extendParams:[String :AnyObject] = ["storage" : model.storage! as AnyObject,"pm_price" : model.pm_price! as AnyObject,"pm_pmtn_type" : model.pm_pmtn_type! as AnyObject]
                    FKYAnalyticsManager.sharedInstance.BI_New_Record("F4001", floorPosition: "3", floorName: "商家热销", sectionId: "S4201", sectionPosition: sectionPosition, sectionName: "配置楼层", itemId: "I9999", itemPosition: "0", itemName: "加车", itemContent: "\(model.productSupplyId ?? "0")|\(model.productCode ?? "0")", itemTitle: nil, extendParams: extendParams, viewController: self)
                }
            }
        }
        return addView
    }()
    
    //MARK:请求类，属性相关
    fileprivate var provider: FKYShopMedicineProvider = FKYShopMedicineProvider() //列表请求工具
    fileprivate var selctedIndexPath: IndexPath? //记录被选中的cell
    fileprivate var medicineArr : [Any] = [] //请求的数据
    var hasBannerList:Bool = false //
    //MARK:生命周期
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({[weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.reloadViewWithBackFromCart()
        }) {[weak self] (reason) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.toast(reason)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissLoading()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(self.medicineCollectionView)
        self.medicineCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.mjheader.beginRefreshing()
        //监控登录状态的改变
        NotificationCenter.default.addObserver(self, selector: #selector(FKYMedicineViewController.loginStatuChanged(_:)), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FKYMedicineViewController.loginStatuChanged(_:)), name: NSNotification.Name.FKYLogoutComplete, object: nil)
    }
    deinit {
        print("FKYMedicineViewController deinit~!@")
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: Public
    func resetContentOffset() {
        medicineCollectionView.contentOffset = CGPoint(x: 0, y: 0)
    }
    func currentOffset() -> CGFloat {
        return medicineCollectionView.contentOffset.y
    }
    @objc fileprivate func loginStatuChanged(_ nty: Notification) {
        self.getMedicineListData(1)
    }
}
//MARK:列表请求
extension FKYMedicineViewController {
    
    func getMedicineListData(_ type:Int) {
        //self.showLoading()
        self.provider.getChineseMedicineList(type) { [weak self] (dataArr,message) in
            //self?.dismissLoading()
            if let arr = dataArr {
                if  self?.provider.hasNext() == true {
                    self?.medicineCollectionView.mj_footer.resetNoMoreData()
                }else {
                    self?.medicineCollectionView.mj_footer.endRefreshingWithNoMoreData()
                }
                self?.medicineCollectionView.mj_header.endRefreshing()
                if type == 1 {
                    //刷新
                    self?.medicineArr.removeAll()
                }
                self?.medicineArr = (self?.medicineArr)! + arr
                self?.hasBannerList = false
                self?.medicineCollectionView.reloadData()
                //加载数据判断
                if self?.medicineArr == nil ||  self?.medicineArr.count == 0 {
                    self?.medicineCollectionView.isHidden = true
                    self?.emptyView.isHidden = false
                }else {
                    self?.medicineCollectionView.isHidden = false
                    self?.emptyView.isHidden = true
                }
                //判断有更多数据并且返回商品数量少于5
                if self?.provider.hasNext() == true &&  (self?.provider.totalProductsCount)! < 10  {
                    self?.mjfooter.beginRefreshing()
                }
            }else {
                self?.medicineCollectionView.mj_header.endRefreshing()
                self?.medicineCollectionView.mj_footer.resetNoMoreData()
                self?.toast(message)
                if self?.medicineArr == nil ||  self?.medicineArr.count == 0 {
                    self?.medicineCollectionView.isHidden = true
                    self?.emptyView.isHidden = false
                }
            }
        }
    }
}
//MARK:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout代理
extension FKYMedicineViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let medicineModel = self.medicineArr[section] as? FKYMedicineModel  {
            return medicineModel.mpHomeProductDtos?.count ?? 0
        }else if let _ =  self.medicineArr[section] as? [HomeCircleBannerItemModel] {
            self.hasBannerList = true
            return 1
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.medicineArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let medicineModel = self.medicineArr[indexPath.section] as? FKYMedicineModel  {
            if let prdModel = medicineModel.mpHomeProductDtos?[indexPath.row] {
                
                let medicineCellH = CommonProductItemCell.getCellContentHeight(prdModel)
                return CGSize(width: SCREEN_WIDTH, height: medicineCellH)

//                let cellHeight = cellHeightManager.getContentCellHeight(prdModel.productCode ?? "",(prdModel.productSupplyId ?? ""),self.ViewControllerPageCode()!)
//                if  cellHeight == 0{
//                    let conutCellHeight = CommonProductItemCell.getCellContentHeight(prdModel)
//                    cellHeightManager.addContentCellHeight(prdModel.productCode ?? "",(prdModel.productSupplyId ?? ""),self.ViewControllerPageCode()!, conutCellHeight)
//                     return CGSize(width: SCREEN_WIDTH, height:conutCellHeight)
//                }else{
//                     return CGSize(width: SCREEN_WIDTH, height:cellHeight!)
//                }
            }
        }else if let _ =  self.medicineArr[indexPath.section] as? [HomeCircleBannerItemModel] {
            return CGSize(width: SCREEN_WIDTH, height: WH(160+8))
        }
        return CGSize(width:WH(0) , height: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let _ = self.medicineArr[section] as? FKYMedicineModel  {
            return CGSize(width: SCREEN_WIDTH, height: WH(60))
        }
        return CGSize(width: SCREEN_WIDTH, height: WH(0))
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let medicineModel = self.medicineArr[indexPath.section] as? FKYMedicineModel,let prdModel = medicineModel.mpHomeProductDtos?[indexPath.row] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonProductItemCell", for: indexPath) as! CommonProductItemCell
            prdModel.indexPath = indexPath
            cell.configCell(prdModel)
            // 更新加车数量
            cell.addUpdateProductNum = { [weak self] in
                if let strongSelf = self {
                    strongSelf.selctedIndexPath = indexPath
                    strongSelf.popAddCarView(prdModel)
                }
            }
            //跳转到聚宝盆商家专区
            cell.clickJBPContentArea = { [weak self] in
                if let strongSelf = self {
                    
                }
            }
            // 登录
            cell.loginClosure = {
                FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            }
            return cell
        }else {
            //轮播图
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYBannerBgCell", for: indexPath) as! FKYBannerBgCell
            if let bannerArr =  self.medicineArr[indexPath.section] as? [HomeCircleBannerItemModel] {
                cell.configNewMedicineListCell(bannerArr)
                cell.selecteHomeBannerClosure = {[weak self] (bannerModel,index) in
                    guard let strongSelf = self else {
                        return
                    }
                    //BI埋点
                    if let mod = bannerModel as? HomeCircleBannerItemModel {
                        FKYAnalyticsManager.sharedInstance.BI_New_Record("F4001", floorPosition: "3", floorName: "商家热销", sectionId: nil, sectionPosition: nil, sectionName: "轮播图", itemId: "I4200", itemPosition: "\(index+1)", itemName: mod.name, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
                        jumpBannerDetailActionWithAll(jumpType: mod.jumpType, jumpInfo: mod.jumpInfo, jumpExpandOne: mod.jumpExpandOne, jumpExpandTwo: mod.jumpExpandTwo)
                    }
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FKYMedicineTitleCell", for: indexPath) as! FKYMedicineTitleCell
        headerView.backgroundColor = UIColor.white
        if let medicineModel = self.medicineArr[indexPath.section] as? FKYMedicineModel  {
            headerView.configTitle(medicineModel.title)
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let medicineModel = self.medicineArr[indexPath.section] as? FKYMedicineModel,let prdModel = medicineModel.mpHomeProductDtos?[indexPath.row] {
            //BI埋点
            let sectionPosition = self.hasBannerList == true ? "\(indexPath.section)" : "\(indexPath.section+1)"
            let itemContent = "\(prdModel.productSupplyId ?? "0")|\(prdModel.productCode ?? "0")"
            let extendParams:[String :AnyObject] = ["storage" : prdModel.storage! as AnyObject,"pm_price" : prdModel.pm_price! as AnyObject,"pm_pmtn_type" : prdModel.pm_pmtn_type! as AnyObject]
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F4001", floorPosition: "3", floorName: "商家热销", sectionId: "S4201", sectionPosition: sectionPosition, sectionName: "配置楼层", itemId: "I4201", itemPosition: "\(indexPath.row+1)", itemName: "点进商详", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
            //查看商品详情
            FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { [weak self] (vc) in
                let v = vc as! FKY_ProdutionDetail
                v.productionId = prdModel.productCode
                v.vendorId = prdModel.productSupplyId
                v.updateCarNum = { [weak self] (carId ,num) in
                    if let count = num {
                        prdModel.carOfCount = count.intValue
                    }
                    if let getId = carId {
                        prdModel.carId = getId.intValue
                    }
                    self?.medicineCollectionView.reloadItems(at:[indexPath])
                }
            }, isModal: false)
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let block = scrollBlock {
            block(scrollView.contentOffset.y)
        }
    }
}
//MARK :加车相关
extension FKYMedicineViewController {
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = HomeString.MP_ZYC_ADD_SOURCE_TYPE
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
    //刷新点击的cell
    func refreshItemOfCollectionView() {
        if let seletedNum = self.selctedIndexPath {
            self.medicineCollectionView.reloadItems(at:[seletedNum])
        }
    }
    //进入界面即刷新
    func reloadViewWithBackFromCart() {
        if self.medicineArr.count > 0 {
            for product in self.medicineArr {
                if let model  = product as? FKYMedicineModel,let prdArr = model.mpHomeProductDtos {
                    for prdMode in prdArr {
                        if FKYCartModel.shareInstance().productArr.count > 0 {
                            for cartModel  in FKYCartModel.shareInstance().productArr {
                                if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                                    if cartOfInfoModel.supplyId != nil &&  cartOfInfoModel.spuCode as String == prdMode.productCode! && cartOfInfoModel.supplyId.intValue == Int(prdMode.productSupplyId ?? "0") {
                                        prdMode.carOfCount = cartOfInfoModel.buyNum.intValue
                                        prdMode.carId = cartOfInfoModel.cartId.intValue
                                        break
                                    }else{
                                        prdMode.carOfCount = 0
                                        prdMode.carId = 0
                                    }
                                }
                            }
                        }else {
                            prdMode.carOfCount = 0
                            prdMode.carId = 0
                        }
                    }
                }
            }
            self.medicineCollectionView.reloadData()
        }
    }
    
}
