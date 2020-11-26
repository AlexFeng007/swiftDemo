//
//  FKYAllPrefectureViewController.swift
//  FKY
//
//  Created by hui on 2018/11/29.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  满减专区 or 特价限量

import UIKit

class FKYAllPrefectureViewController: UIViewController {
    //MARK: - UI控件
    fileprivate lazy var toTopButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage.init(named: "icon_back_top"), for: UIControl.State())
        return button;
    }()
    
    fileprivate lazy var lblPageCount: FKYCornerRadiusLabel = {
        let label = FKYCornerRadiusLabel()
        label.initBaseInfo()
        label.isHidden = true
        return label
    }()
    //行高管理器
    fileprivate var cellHeightManager:ContentHeightManager = {
        let heightManager = ContentHeightManager()
        return heightManager
    }()
    fileprivate lazy var emptyView: StaticView = {
        let ev = StaticView()
        ev.configView("icon_cart_add_empty", title: "暂无结果", btnTitle: "重新加载")
        ev.isHidden = true
        self.view.addSubview(ev)
        ev.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        })
        //重新加载
        ev.actionBlock = { [weak self] in
            if let strongSelf = self {
                strongSelf.allPrefectureCollectionView.isHidden = false
                strongSelf.emptyView.isHidden = true
                strongSelf.allPrefectureCollectionView.mj_header.beginRefreshing()
            }
        }
        return ev
    }()
    
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            self?.requestData(1)
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
    }()
    
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            self?.requestData(2)
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    
    fileprivate lazy var allPrefectureCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(CommonProductItemCell.self, forCellWithReuseIdentifier: "CommonProductItemCell")
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = RGBColor(0xf5f5f5)
        cv.mj_header = self.mjheader
        cv.mj_footer = self.mjfooter
        cv.mj_footer.isAutomaticallyHidden = true
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                cv.contentInsetAdjustmentBehavior = .never
                cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                cv.scrollIndicatorInsets = cv.contentInset
            }
        }
        return cv
    }()
    
    //商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        addView.finishPoint = CGPoint(x:SCREEN_WIDTH - WH(10) - (self.NavigationBarRightImage?.frame.size.width)!/2.0, y:naviBarHeight() - WH(5) - (self.NavigationBarRightImage?.frame.size.height)!/2.0)
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
                strongSelf.refreshItemOfCollectionView()
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? FKYFullProductModel {
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I9999", itemPosition: nil, itemName: "加车按钮", itemContent: "\(model.enterpriseId ?? "0")|\(model.spuCode ?? "0")", itemTitle: nil, extendParams: nil, viewController: self)

                }
            }
        }
        return addView
    }()
    
    fileprivate var navBar: UIView?
    fileprivate var badgeView: JSBadgeView?
    
    //MARK:请求类，属性相关
    //mp商家请求类
    fileprivate lazy var fullProvider: FKYShopFullRedueProvider = {
        let provider = FKYShopFullRedueProvider()
        return provider
    }()
    fileprivate var selctedIndexPath: IndexPath? //记录被选中的cell
    fileprivate var dataSource:[FKYFullProductModel] = []
    fileprivate var isScrollDown : Bool = true
    var lastOffsetY : CGFloat = 0.0
    //MARK: Property（外部入参数）
    @objc var type: Int = 1 //1 特价活动 2 满减活动
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.requestData(1)
        // 登录成功后刷新界面数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name.FKYLoginSuccess, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //删除存储高度
        cellHeightManager.removeAllContentCellHeight()
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ [weak self] (isSuccess) in
            if let strongSelf = self {
                strongSelf.refreshDataBackFromCar()
                strongSelf.changeBadgeNumber(true)
            }
        }) { [weak self] (reason) in
            if let strongSelf = self {
                strongSelf.toast(reason)
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print("FKYAllPrefectureViewController deinit~!@")
        self.dismissLoading()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("内存不足")
    }
    
    //MARK: - Notification
    @objc func reloadData() {
        // 刷新界面数据
        self.requestData(1)
    }
    
    //MARK: - setupView
    func setupView() {
        self.view.backgroundColor = RGBColor(0xf5f5f5)
        
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        // 全部商品的特价满减
        fky_setupTitleLabel(type == 2 ? "满减专区" : "特价限量")
        
        weak var weakself = self
        self.fky_setupRightImage("icon_cart_new") {
            FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
                let v = vc as! FKY_ShopCart
                v.canBack = true
            }, isModal: false)
        }
        self.NavigationBarRightImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationBarLeftImage!.snp.centerY)
            make.right.equalTo(self.navBar!.snp.right).offset(-WH(14))
        })
        
        let bv = JSBadgeView(parentView: self.NavigationBarRightImage, alignment: .topRight)
        bv?.badgePositionAdjustment = CGPoint(x: WH(-3), y: WH(3))
        bv?.badgeTextFont = UIFont.systemFont(ofSize: WH(11))
        self.badgeView = bv
        
        self.view.addSubview(self.allPrefectureCollectionView)
        self.allPrefectureCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        
        _ = self.toTopButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            if let strongSelf = self {
                UIView.animate(withDuration: 0.3, animations: {
                    strongSelf.allPrefectureCollectionView.contentOffset = CGPoint(x: 0, y: 0)
                })
                strongSelf.lblPageCount.text = String.init(format: "1/%zi",strongSelf.fullProvider.pageSize)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        self.view.addSubview(self.toTopButton)
        self.toTopButton.snp.makeConstraints({ (make) in
            make.right.equalTo(self.view.snp.right).offset(-WH(20))
            make.bottom.equalTo(self.view.snp.bottom).offset(-WH(40)-bootSaveHeight())
            make.width.height.equalTo(WH(30))
        })
        
        self.view.addSubview(lblPageCount)
        lblPageCount.snp.makeConstraints({[weak self] (make) in
            if let strongSelf = self {
                make.centerX.equalTo(strongSelf.view.snp.centerX)
                make.bottom.equalTo(strongSelf.view.snp.bottom).offset(-WH(12)-bootSaveHeight())
                make.height.equalTo(LBLABEL_H)
                make.width.lessThanOrEqualTo(SCREEN_WIDTH-100)
            }
        })
    }
    
    fileprivate func updatePageInfo() {
        if 1 == self.fullProvider.pageId {
            self.lblPageCount.text = String.init(format: "%zi/%zi", self.fullProvider.pageId,self.fullProvider.pageSize)
            self.lblPageCount.isHidden = false
        }
    }
    
    func refreshDataBackFromCar() {
        for product in self.dataSource {
            if FKYCartModel.shareInstance().productArr.count > 0 {
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode! && cartOfInfoModel.supplyId.intValue == Int(product.enterpriseId ?? "0") {
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
        self.allPrefectureCollectionView.reloadData()
    }
    
    func changeBadgeNumber(_ isdelay : Bool) {
        var deadline :DispatchTime
        if  isdelay {
            deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        }else {
            deadline = DispatchTime.now()
        }
        DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.badgeView!.badgeText = {
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

//MARK: - 网络请求
extension FKYAllPrefectureViewController {
    
    //MARK: - Request
    // 请求数据
    func requestData(_ requestType : Int)  {
        if requestType == 1 {
            self.showLoading()
        }
        self.fullProvider.getFullCutOrBargainPromotionProductList(self.type, requestType) {  [weak self] (dataArr,message) in
            if let strongSelf = self {
                if requestType == 1 {
                    strongSelf.dismissLoading()
                }
                if let arr = dataArr {
                    if  strongSelf.fullProvider.hasNext() == true {
                        strongSelf.allPrefectureCollectionView.mj_footer.resetNoMoreData()
                    }else {
                        strongSelf.allPrefectureCollectionView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    strongSelf.allPrefectureCollectionView.mj_header.endRefreshing()
                    if requestType == 1 {
                        //刷新
                        strongSelf.dataSource.removeAll()
                    }
                    strongSelf.dataSource = strongSelf.dataSource + arr
                    strongSelf.allPrefectureCollectionView.reloadData()
                    strongSelf.updatePageInfo()
                    //加载数据判断
                    if strongSelf.dataSource.count == 0 {
                        strongSelf.allPrefectureCollectionView.isHidden = true
                        strongSelf.emptyView.isHidden = false
                    }else {
                        strongSelf.allPrefectureCollectionView.isHidden = false
                        strongSelf.emptyView.isHidden = true
                    }
                }else {
                    strongSelf.allPrefectureCollectionView.mj_header.endRefreshing()
                    strongSelf.allPrefectureCollectionView.mj_footer.resetNoMoreData()
                    strongSelf.toast(message)
                    if strongSelf.dataSource.count == 0 {
                        strongSelf.allPrefectureCollectionView.isHidden = true
                        strongSelf.emptyView.isHidden = false
                    }
                }
            }
        }
    }
}

// MARK: - CollectionViewDelegate&DataSource
extension FKYAllPrefectureViewController : UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonProductItemCell", for: indexPath) as! CommonProductItemCell
        let model = self.dataSource[indexPath.section] as FKYFullProductModel
        model.promationType = self.type
        cell.configCell(model)
        cell.addUpdateProductNum = { [weak self] in
            if let strongSelf = self {
                strongSelf.selctedIndexPath = indexPath
                strongSelf.popAddCarView(model)
            }
        }
        //跳转到聚宝盆商家专区
        cell.clickJBPContentArea = { [weak self] in
            if let strongSelf = self {
                 
            }
        }
        //登录
        cell.loginClosure = {
            FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
        }
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = self.dataSource[indexPath.section] as FKYFullProductModel
        model.promationType = self.type
        let cellHeight = cellHeightManager.getContentCellHeight(model.productcodeCompany ?? "",(model.enterpriseId ?? ""),self.ViewControllerPageCode()!)
        if  cellHeight == 0{
            let conutCellHeight = CommonProductItemCell.getCellContentHeight(model)
            cellHeightManager.addContentCellHeight(model.productcodeCompany ?? "",(model.enterpriseId ?? ""),self.ViewControllerPageCode()!, conutCellHeight)
            return CGSize(width: SCREEN_WIDTH, height:conutCellHeight)
        }else{
            return CGSize(width: SCREEN_WIDTH, height:cellHeight)
        }
//         let itemH = CommonProductItemCell.getContentHeight(model)
//        return CGSize(width: SCREEN_WIDTH, height: itemH)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.section] as FKYFullProductModel
        //BI埋点
        let itemId = self.type == 1 ? "I7500" : "I7402"
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: itemId, itemPosition: "\(indexPath.section+1)", itemName: "商品\(indexPath.section+1)", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        //查看商品详情
        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
            let v = vc as! FKY_ProdutionDetail
            v.productionId = model.spuCode
            v.vendorId = model.enterpriseId
            v.updateCarNum = { [weak self] (carId ,num) in
                if let count = num {
                    model.carOfCount = count.intValue
                }
                if let getId = carId {
                    model.carId = getId.intValue
                }
                self?.allPrefectureCollectionView.reloadSections(IndexSet(integer: indexPath.section))
            }
        }, isModal: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (collectionView.isDragging || collectionView.isDecelerating) && !isScrollDown {
            //下滑处理
            let scrollIndex = (indexPath.section-1) / 10
            self.lblPageCount.text = String.init(format: "%zi/%zi", scrollIndex+1, self.fullProvider.pageSize)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (collectionView.isDragging || collectionView.isDecelerating) && isScrollDown {
            //上滑处理
            let scrollIndex = indexPath.section / 10
            self.lblPageCount.text = String.init(format: "%zi/%zi", scrollIndex+1, self.fullProvider.pageSize)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isScrollDown = lastOffsetY < scrollView.contentOffset.y
        lastOffsetY = scrollView.contentOffset.y
        let offset_y = scrollView.contentOffset.y
        if offset_y>=SCREEN_HEIGHT/2 {
            self.toTopButton.isHidden = false
            self.view.bringSubviewToFront(self.toTopButton)
        } else {
            self.toTopButton.isHidden = true
            self.view.sendSubviewToBack(self.toTopButton)
        }
    }
}

// MARK: - 加车bi埋点
extension FKYAllPrefectureViewController {
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = self.getTypeSourceStr()
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
    //刷新点击的cell
    func refreshItemOfCollectionView() {
        if let seletedNum = self.selctedIndexPath {
            self.allPrefectureCollectionView.reloadItems(at:[seletedNum])
        }
    }
    //设置加车的来源
    func getTypeSourceStr() -> String{
       return type == 2 ? HomeString.MP_MJ_ADD_SOURCE_TYPE:HomeString.MP_TJ_ADD_SOURCE_TYPE
    }
}
