//
//  FKYShopListViewController.swift
//  FKY
//
//  Created by hui on 2018/5/23.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  店铺列表...<New>

import UIKit
import MJRefresh

class FKYShopListViewController: UIViewController,NewShoplistItemProtocol{
    
    //MARK: - UI属性
    fileprivate lazy var shopsSiftView: FKYShopTypeSiftView = {
        let view = FKYShopTypeSiftView.init(frame: CGRect.init(x:0, y:0, width: SCREEN_WIDTH, height:SCREEN_HEIGHT))
        if let window = UIApplication.shared.delegate?.window {
            window?.addSubview(view)
        }
        view.isHidden = true
        //重置/确认
        view.clickTypeBtn = { [weak self,weak view] index  in
            if index == 1 {
                
            }else if index == 2 {
                self?.shopListCollectionView.reloadData()
                self?.getFirstShopList()
                UIView.animate(withDuration: 0.05, delay: 0, options: .curveEaseOut, animations: {
                }, completion: {[weak view] finished in
                    view?.isHidden = true
                })
            }else {
                UIView.animate(withDuration: 0.05, delay: 0, options: .curveEaseOut, animations: {
                }, completion: {[weak view] finished in
                    view?.isHidden = true
                })
            }
        }
        //点击item
        view.clickItem = { [weak self] indexPath  in
            //BI埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S4101", sectionPosition: "\(indexPath.section+2)", sectionName: nil, itemId: "I4101", itemPosition: "\(indexPath.item+1)", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        }
        return view
    }()
    
    fileprivate lazy var emptyView: StaticView = {
        let ev = StaticView()
        ev.configView("icon_cart_add_empty", title: "暂无结果", btnTitle: "重新加载")
        ev.isHidden = true
        self.view.addSubview(ev)
        ev.snp.makeConstraints({(make) in
            make.edges.equalTo(self.view)
        })
        //重新加载
        ev.actionBlock = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.shopListCollectionView.isHidden = false
            strongSelf.emptyView.isHidden = true
            strongSelf.shopListCollectionView.mj_header.beginRefreshing()
        }
        return ev
    }()
    
    fileprivate lazy var shopListCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = WH(10)
        flowLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(FKYBannerBgCell.self, forCellWithReuseIdentifier: "FKYBannerBgCell")
        cv.register(FKYShopListCell.self, forCellWithReuseIdentifier: "HomeShopCell")
        cv.register(FKYShopListHeaderCell.self, forCellWithReuseIdentifier: "FKYShopListHeaderCell")
        cv.backgroundColor = UIColor.clear
        cv.showsVerticalScrollIndicator = false
        cv.mj_header = self.mjheader
        cv.mj_footer = self.mjfooter
        cv.mj_footer.isAutomaticallyHidden = true
        return cv
    }()
    
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            self?.shopsSiftView.resetData()
            self?.shopListCollectionView.reloadData()
            self?.getFirstShopList()
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
            let params = ["delivery":self?.shopsSiftView.deliveriesStr,"service_label":self?.shopsSiftView.serviceStr]
            self?.provider.getNextShopList(params as [String : AnyObject], callback:{
                self?.shopListCollectionView.reloadData()
                if let isNext = self?.provider.hasNext(), isNext {
                    self?.shopListCollectionView.mj_footer.endRefreshing()
                }
                else {
                    self?.shopListCollectionView.mj_footer.endRefreshingWithNoMoreData()
                }
            })
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    
    fileprivate var provider: FKYShopListProvider = FKYShopListProvider() //请求工具
    var scrollBlock: ((CGFloat) -> ())?
    var bgScrollOffset: CGFloat = 0.0
    //var siftSection:Int = 0//记录筛选行的section
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.mjheader.beginRefreshing()
        //监控登录状态的改变
        NotificationCenter.default.addObserver(self, selector: #selector(self.loginStatuChanged(_:)), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loginStatuChanged(_:)), name: NSNotification.Name.FKYLogoutComplete, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("FKYShopListViewController deinit~!@")
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func loginStatuChanged(_ nty: Notification) {
        self.shopsSiftView.resetData()
        self.shopListCollectionView.reloadData()
        self.getFirstShopList()
    }
    //MARK: Public
    func resetContentOffset() {
        shopListCollectionView.contentOffset = CGPoint(x: 0, y: 0)
    }
    func currentOffset() -> CGFloat {
        return shopListCollectionView.contentOffset.y
    }
}

//MARK: 数据请求
extension FKYShopListViewController {
    func getFirstShopList() {
        let params = ["delivery":shopsSiftView.deliveriesStr,"service_label":shopsSiftView.serviceStr]
        self.provider.getShopList(params as [String : AnyObject], callback: {[weak self] in
            if let strongSelf = self {
                strongSelf.shopListCollectionView.mj_header.endRefreshing()
                if let isNext = self?.provider.hasNext(), isNext {
                    strongSelf.shopListCollectionView.mj_footer.resetNoMoreData()
                }else {
                    strongSelf.shopListCollectionView.mj_footer.endRefreshingWithNoMoreData()
                }
                strongSelf.shopListCollectionView.reloadData()
                if strongSelf.provider.deliveriesList.count > 0 || strongSelf.provider.serviceList.count > 0 {
                    strongSelf.shopsSiftView.refreshSiftData(strongSelf.provider.deliveriesList,strongSelf.provider.serviceList)
                }
                
                if self?.provider.shopList.count == 0 || self?.provider.shopList == nil {
                    self?.shopListCollectionView.isHidden = true
                    self?.emptyView.isHidden = false
                }else {
                    self?.shopListCollectionView.isHidden = false
                    self?.emptyView.isHidden = true
                }
                
            }}, errorCallBack: {[weak self] in
                if let strongSelf = self {
                    strongSelf.shopListCollectionView.mj_header.endRefreshing()
                    strongSelf.shopListCollectionView.mj_footer.resetNoMoreData()
                    strongSelf.shopListCollectionView.reloadData()
                    if self?.provider.shopList.count == 0 || self?.provider.shopList == nil {
                        self?.shopListCollectionView.isHidden = true
                        self?.emptyView.isHidden = false
                    }
                }
        })
    }
}
//MARK: - 初始化UI
extension FKYShopListViewController {
    func setupView(){
        //列表
        self.view.addSubview(shopListCollectionView)
        shopListCollectionView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
    }
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension FKYShopListViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.provider.shopList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let shopModel = self.provider.shopList[indexPath.section] as? FKYShopListModel  {
            let shopCellH = FKYShopListCell.configCellHeight(shopModel)
            return CGSize(width: SCREEN_WIDTH, height: shopCellH)
        }else if let _ =  self.provider.shopList[indexPath.section] as? [HomeBannerModel] {
            return CGSize(width: SCREEN_WIDTH, height: WH(160+8))
        }else {
            //self.siftSection = indexPath.section
            return CGSize(width: SCREEN_WIDTH, height: WH(52))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let shopModel = self.provider.shopList[indexPath.section] as? FKYShopListModel {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeShopCell", for: indexPath) as! FKYShopListCell
            //
            cell.configCellData(shopModel)
            cell.showActivityNum = { (index) in
                if index == 1 {
                    shopModel.showOneActivity = !shopModel.showOneActivity
                }else if index == 2 {
                    shopModel.showTwoActivity = !shopModel.showTwoActivity
                }else if index == 3 {
                    shopModel.showThreeActivity = !shopModel.showThreeActivity
                }else if index == 4 {
                    shopModel.showTypeName = !shopModel.showTypeName
                }
                self.shopListCollectionView.reloadSections(IndexSet(integer:indexPath.section))
            }
            //商品详情
            cell.goProductDes = {[weak self](productModel ,shopId,index) in
                guard let strongSelf = self else {
                    return
                }
                //BI埋点
                let itemContent = "\(shopId)|\(productModel.spuCode ?? "0")"
                let extendParams:[String :AnyObject] = ["pm_price" :productModel.pm_price! as AnyObject,"pm_pmtn_type" : productModel.pm_pmtn_type! as AnyObject]
                let sectionPosition = strongSelf.provider.hasBannerList == true ? "\(indexPath.section)" : "\(indexPath.section + 1)"
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F4001", floorPosition: "2", floorName: "所有店铺", sectionId: "S4102", sectionPosition: sectionPosition, sectionName: "商家列表", itemId: "I4102", itemPosition: "\(index+1)", itemName: "点进商详", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
                
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = productModel.spuCode!
                    v.vendorId = shopId
                }, isModal: false)
            }
            //店铺详情
            cell.goShopDetail = {[weak self] (shopModel) in
                guard let strongSelf = self else {
                    return
                }
                let itemContent = "\(shopModel.shopId ?? 0)"
                let sectionPosition = strongSelf.provider.hasBannerList == true ? "\(indexPath.section)" : "\(indexPath.section + 1)"
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F4001", floorPosition: "2", floorName: "所有店铺", sectionId: "S4102", sectionPosition: sectionPosition, sectionName: "商家列表", itemId: "I4102", itemPosition: "0", itemName: "进入店铺首页", itemContent: itemContent, itemTitle: nil, extendParams: nil, viewController: self)
                
                strongSelf.gotoShopDetail(shopModel,section: indexPath.section)
            }
            return cell
        }
        else if let _ = self.provider.shopList[indexPath.section] as? String {
            //筛选
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYShopListHeaderCell", for: indexPath) as! FKYShopListHeaderCell
            if  self.shopsSiftView.deliveriesStr.count > 0 || self.shopsSiftView.serviceStr.count > 0 {
                cell.refreshData(true)
            }else {
                cell.refreshData(false)
            }
            cell.clickSiftBtnClosure = { [weak self]  in
                //BI埋点
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S4101", sectionPosition: "0", sectionName: nil, itemId: "I4101", itemPosition: "1", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
                
                UIView.animate(withDuration: 0.05, delay: 0, options: .curveEaseOut, animations: {
                }, completion: {[weak self] finished in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.shopsSiftView.isHidden = false
                })
            }
            return cell
        }
        else {
            //轮播图
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYBannerBgCell", for: indexPath) as! FKYBannerBgCell
            if let bannerArr = self.provider.shopList[indexPath.section] as? [HomeBannerModel]{
                cell.configShopListCell(bannerArr)
                cell.selectedBannerClosure = { (schema , index) in
                    //BI埋点  那itemName直接传轮播图就行了 没有名字
                    FKYAnalyticsManager.sharedInstance.BI_New_Record("F4001", floorPosition: "2", floorName: "所有店铺", sectionId: nil, sectionPosition: nil, sectionName: "轮播图", itemId: "I4100", itemPosition: "\(index+1)", itemName: "轮播图", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
                    
                    visitSchema(schema)
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let shopModel = self.provider.shopList[indexPath.section] as? FKYShopListModel {
            self.gotoShopDetail(shopModel,section: indexPath.section)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let block = scrollBlock {
            block(scrollView.contentOffset.y)
        }
    }
    //进入店铺详情
    func gotoShopDetail(_ shopModel : FKYShopListModel,section:Int) {
        //BI埋点
        let itemContent = "\(shopModel.shopId ?? 0)"
        let sectionPosition = self.provider.hasBannerList == true ? "\(section)" : "\(section+1)"
        FKYAnalyticsManager.sharedInstance.BI_New_Record("F4001", floorPosition: "2", floorName: "所有店铺", sectionId: "S4102", sectionPosition: sectionPosition, sectionName: "商家列表", itemId: "I4102", itemPosition: "0", itemName: "进入店铺首页", itemContent: itemContent, itemTitle: nil, extendParams: nil, viewController: self)
        if let shopId = shopModel.shopId {
            FKYNavigator.shared().openScheme(FKY_ShopItem.self) { (vc) in
                let v = vc as! FKYNewShopItemViewController
                v.shopId = "\(shopId)"
                if let type = shopModel.type ,type == 1 {
                    v.shopType = "1"
                }
            }
        }
    }
}
