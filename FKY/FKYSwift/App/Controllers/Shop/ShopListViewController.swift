//
//  ShopListViewController.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/26.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  店铺馆（店铺列表）...<old>

import UIKit
import SnapKit
import RxSwift

@objc
class ShopListViewController: UIViewController,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    // MARK: - Property
    fileprivate var tableView: UITableView?
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0//WH(5)
        flowLayout.minimumLineSpacing = WH(5)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(HomeBannerCell.self, forCellWithReuseIdentifier: "HomeBannerCell")
        cv.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader,withReuseIdentifier: "UICollectionReusableView")
        cv.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter,withReuseIdentifier: "UICollectionReusableView")
        cv.register(HomeShopCell.self, forCellWithReuseIdentifier: "HomeShopCell")
        cv.register(ShopListCell.self, forCellWithReuseIdentifier: "ShopListCell")
        cv.backgroundColor = RGBColor(0xf4f4f4)
        return cv
    }()
    fileprivate var navBar: UIView?
    fileprivate var provider: ShopListProvider = ShopListProvider()
    fileprivate var emptyView: StaticView = {
        let ev = StaticView()
        ev.configView("icon_cart_add_empty", title: "暂无结果", btnTitle: "无")
        return ev
    }()
    fileprivate var badgeView: JSBadgeView?
    
    // MARK: - LifeCircle
    override func loadView() {
        super.loadView()
        
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showLoading()
        
        self.provider.getShopList(nil, callback: {[weak self] in
            if let strongSelf = self {
                strongSelf.updateEmptyView()
                strongSelf.collectionView.reloadData()
                strongSelf.dismissLoading()
            }}, errorCallBack: {[weak self] in
                if let strongSelf = self {
                    strongSelf.updateEmptyView()
                    strongSelf.collectionView.reloadData()
                    strongSelf.dismissLoading()
                }
        })
        
        self.badgeView!.badgeText = {
            let count = FKYCartModel.shareInstance().productCount
            if count <= 0 {
                return ""
            }
            else if count > 99 {
                return "99+"
            }
            return String(count)
        }()
        
        // 上拉加载
        self.collectionView.addPullToRefresh(actionHandler: {
            self.provider.getNextShopList{
                self.updateEmptyView()
                self.collectionView.reloadData()
                self.dismissAnimation()
            }
        }, position: .bottom)
        self.collectionView.pullToRefreshView.setCustom(FKYPullToRefreshStateView.fky_footerView(with: .stopped), for: .stopped)
        self.collectionView.pullToRefreshView.setCustom(FKYPullToRefreshStateView.fky_footerView(with: .triggered), for: .triggered)
        self.collectionView.pullToRefreshView.setCustom(FKYPullToRefreshStateView.fky_footerView(with: .loading), for: .loading)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let count = FKYCartModel.shareInstance().productCount
        if (count <= 0) {
            self.badgeView!.badgeText = ""
        } else if (count > 99) {
            self.badgeView!.badgeText = "99+";
        } else {
            self.badgeView!.badgeText = String(count)
        }
    }
    
    // MARK: - setupView
    func setupView() {
        self.navBar = {
            if let _ = self.NavigationBar {
            } else {
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.fky_setupLeftImage("icon_back_red_normal") {
            FKYNavigator.shared().pop()
        }
        weak var weakself = self
        self.fky_setupRightImage("icon_cart_normal") {
            weakself?.BI_Record(.MAINSTORE_YC_CLICKCART)
            FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
                let v = vc as! FKY_ShopCart
                v.isPushed = true
            }, isModal: false)
//            FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
//                let v = vc as! FKY_TabBarController
//                v.index = 2
//            })
        }
       
        // 购物车中商品数量
        self.badgeView = {
            let bv = JSBadgeView(parentView: self.NavigationBarRightImage, alignment: .topRight)
            bv?.badgePositionAdjustment = CGPoint(x: WH(-6), y: WH(8))
            bv?.badgeTextFont = UIFont.systemFont(ofSize: WH(10))
            return bv
        }()
        
        self.navBar!.backgroundColor = bg1
        self.fky_setupTitleLabel("店铺馆")
        self.NavigationTitleLabel!.fontTuple = t14
        
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        })
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        })
    }
    
    // MARK: - Private
    func updateEmptyView() {
        if self.provider.sectionTypeArray.count <= 0 {
            self.view.bringSubview(toFront: self.emptyView)
        } else {
            self.view.sendSubview(toBack: self.emptyView)
        }
    }
    
    func dismissAnimation() {
        let time:TimeInterval = 1
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            self.collectionView.pullToRefreshView.stopAnimating()
        }
    }
    
    // MARK: - CollectionViewDelegate&DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.provider.sectionTypeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = self.provider.sectionTypeArray[section]
        switch sectionType {
        case .Banner:
            return 1
        case .RecommendShops:
            return self.provider.recommendShops.count
        case .ShopList:
            return self.provider.shopList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = self.provider.sectionTypeArray[indexPath.section]
        switch sectionType {
        case .Banner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCell", for: indexPath) as! HomeBannerCell
            cell.configCell(self.provider.banners,activityButtonHiden: true)
            cell.selectedBannerClosure = { schema in
                  FKYAnalyticsManager.sharedInstance.BI_Record(floorCode: nil, floorPosition: "0",floorName: nil, sectionCode: "0", sectionPosition: "0", sectionName: nil, itemCode: "clickBanner", itemPosition: "1", itemName:nil,extendParams:nil, viewController: self)
                
                    visitSchema(schema)
            }
            return cell
        case .RecommendShops:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeShopCell", for: indexPath) as! HomeShopCell
            cell.configCell(self.provider.recommendShops[indexPath.row],left: indexPath.row == 0)
            return cell
        case .ShopList:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopListCell", for: indexPath) as! ShopListCell
            cell.configCell(self.provider.shopList[indexPath.row])
            return cell
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopListCell", for: indexPath) as! ShopListCell
//            cell.configCell(self.provider!.shopList![indexPath.section - 2])
//            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionType = self.provider.sectionTypeArray[indexPath.section]
        if sectionType == .RecommendShops && kind == UICollectionElementKindSectionHeader {
            let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
            section.backgroundColor = bg1
            return section
        }else{
            let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
            section.backgroundColor = bg2
            return section
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionType = self.provider.sectionTypeArray[indexPath.section]
        switch sectionType {
        case .Banner:
            return CGSize(width: SCREEN_WIDTH, height: WH(110))
        case .RecommendShops:
            return CGSize(width: SCREEN_WIDTH/2.0, height: WH(95))
        case .ShopList:
            return CGSize(width: SCREEN_WIDTH, height: WH(142))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionType = self.provider.sectionTypeArray[section]
        switch sectionType {
        case .Banner:
            fallthrough
        case .ShopList:
            return CGSize.zero
        case .RecommendShops:
            return CGSize(width: SCREEN_WIDTH, height: WH(5))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let sectionType = self.provider.sectionTypeArray[section]
        switch sectionType {
        case .Banner:
            fallthrough
        case .RecommendShops:
            return CGSize(width: SCREEN_WIDTH, height: WH(5))
        case .ShopList:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = self.provider.sectionTypeArray[indexPath.section]
        switch sectionType {
        case .Banner:
            return;
        case .RecommendShops:
            FKYAnalyticsManager.sharedInstance.BI_Record(floorCode: nil, floorPosition: "0",floorName: nil, sectionCode: "0", sectionPosition: "0", sectionName: nil, itemCode: "goShop", itemPosition: "2", itemName:nil,extendParams:nil, viewController: self)
            let shop = self.provider.recommendShops[indexPath.row]
            if let url = shop.schema {
                visitSchema(url)
            }
            return
        case .ShopList:
            FKYAnalyticsManager.sharedInstance.BI_Record(floorCode: nil, floorPosition: "0",floorName: nil, sectionCode: "0", sectionPosition: "0", sectionName: nil, itemCode: "goShop", itemPosition: "2", itemName:nil,extendParams:nil, viewController: self)
            let shopModel: HomeShopModel = self.provider.shopList[indexPath.row]
            if let shopId = shopModel.shopId {
                FKYNavigator.shared().openScheme(FKY_ShopItem.self) { (vc) in
                    let v = vc as! ShopItemViewController
                    v.shopId = "\(shopId)"
                }
            }
            return
        }
    }
}
