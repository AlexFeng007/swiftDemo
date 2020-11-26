//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

import UIKit
import WYPopoverController

class HomePresenter {
    // MARK: - properties
    weak var view: HomeViewInterface?
    weak var viewModel: HomeViewModelInterface?
}

// MARK: - delegates
extension HomePresenter: HomeViewOperation {
    func onclickScanSearchButtonAction() {
        
    }
    
    // 刷新...<获取第1页数据>
    func onTableViewRefreshAction() {
        DispatchQueue.global().async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel?.loadDataBinding(finishedCallback: { (msg, success) in
                //开始渲染结束埋点计时
                //YWSpeedUpManager.sharedInstance().end(with: ModuleType.fkyHome)
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.view?.hideLoading()
                    strongSelf.view?.updateEmptyDataShowStatus()
                    if !success {
                        // 请求失败
                        strongSelf.view?.hideLoadMoreFooterWhenRequestFail()
                    }
                    guard msg == nil else {
                        strongSelf.view?.toast(msg)
                        return
                    }
                    // 每次刷新数据成功时，均需要发通知，以便使得有倒计时的楼层cell中的timer暂停
                    // 解决bug: 刷新之前有倒计时楼层，刷新之后无倒计时楼层。若不发通知取消，则timer会一直在后台运行
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: FKYHomeRefreshToStopTimers), object: self, userInfo: nil)
                    // 刷新首页
                    strongSelf.view?.viewModel = strongSelf.viewModel
                    strongSelf.view?.operation = strongSelf
                   strongSelf.view?.updateHomePageContent()
                }
            })
        }
    }
    
    // 加载更多...<获取第1页之后的数据>
    func onTableViewLoadNextPageAction() {
        DispatchQueue.global().async {
            self.viewModel?.loadNextPageBinding(finishedCallback: {[weak self] (msg, success) in
                guard let strongSelf = self else {
                    return
                }
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    if !success {
                        // 请求失败
                        strongSelf.view?.hideLoadMoreFooterWhenRequestFail()
                    }
                    guard msg == nil else {
                        strongSelf.view?.toast(msg)
                        return
                    }
                    strongSelf.view?.viewModel = strongSelf.viewModel
                    strongSelf.view?.operation = strongSelf
                    strongSelf.view?.updateHomePageContent()
                };
            })
        }
    }
    
    func onClickSearchItemAction(_ bar: HomeSearchBar) {
//        FKYAnalyticsManager.sharedInstance.BI_Record(floorCode: .HOME_YC_PAGEHEADER, floorPosition: nil,floorName: nil, sectionCode: nil, sectionPosition: nil, sectionName: nil, itemCode: ITEMCODE.HOME_YC_PAGEHEADER_Search.rawValue, itemPosition: "1", itemName: nil,extendParams:nil, viewController: CurrentViewController.shared.item)
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_SEARCH_CLICK_CODE.rawValue, itemPosition: "0", itemName: "搜索框", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: CurrentViewController.shared.item)
        
        /*
        FKYNavigator.shared().openScheme(FKY_Search.self, setProperty: { (svc) in
            let searchVC = svc as! FKYSearchViewController
            searchVC.vcSourceType = .common
            searchVC.searchType = .prodcut
            searchVC.searchFromType = .fromCommon
            searchVC.fromePage = 1;
        }, isModal: false, animated: true)
        */
        
        FKYNavigator.shared().openScheme(FKY_NewSearch.self, setProperty: { (svc) in
            let searchVC = svc as! FKYSearchInputKeyWordVC
            searchVC.searchType = 1
        }, isModal: false, animated: true)
    }
    
    func onClickMessageBoxAction(_ bar: HomeSearchBar) {
//        FKYAnalyticsManager.sharedInstance.BI_Record(floorCode: .HOME_YC_PAGEHEADER, floorPosition: nil,floorName: nil, sectionCode: nil, sectionPosition: nil, sectionName: nil, itemCode: ITEMCODE.HOME_YC_PAGEHEADER_Notice.rawValue, itemPosition: "1", itemName: nil,extendParams:nil, viewController: CurrentViewController.shared.item)
//
//        FKYNavigator.shared().openScheme(FKY_TabBarController.self) { (vc) in
//            let v = vc as! FKY_TabBarController
//            v.index = 4
//        }
       FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_MESSAGE_CLICK_CODE.rawValue, itemPosition: "0", itemName: "消息中心", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: CurrentViewController.shared.item)
        if FKYLoginAPI.loginStatus() == .unlogin {
            FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: { (svc) in
                //
            }, isModal: true, animated: true)
        }else {
            FKYNavigator.shared().openScheme(FKY_Message_List.self, setProperty: { (vc) in
                //
            })
        }
    }
    
    func onClickCellAction(_ action: HomeTemplateAction) {
        let type: HomeTemplateActionType = action.actionType
        let params: Dictionary<String, Any> = action.actionParams
        let model = params[HomeString.ACTION_KEY]
        // 埋点处理
        if action.needRecord {
            /*
            //let floorType: HomeTemplateType = action.floorPosition
            let floorCode = action.floorCode
            let floorName = action.floorName
            let floorPosition = action.floorPosition
            let sectionCode = action.sectionCode
            let sectionPosition = action.sectionPosition
            let sectionName = action.sectionName
            let itemCode = action.itemCode
            let itemPosition = action.itemPosition
            let itemTitle = action.itemTitle
            let itemName = action.itemName
            let itemContent = action.itemContent
            let extendParams = action.extenParams
            let viewController = CurrentViewController.shared.item
            
            FKYAnalyticsManager.sharedInstance.BI_New_Record(floorCode, floorPosition: floorPosition, floorName: floorName, sectionId: sectionCode, sectionPosition: sectionPosition, sectionName: sectionName, itemId: itemCode, itemPosition: itemPosition, itemName: itemName, itemContent: itemContent, itemTitle: itemTitle , extendParams: extendParams, viewController: viewController)
            */
        }
        //处理 model 传空的情况 其他类型用不上model
       if (model == nil && (type != .supplySelect007_clickMore && type != .hexie009_clickItem &&  type != .recentPurchase0011_clickItem &&  type != .topCategories012_clickMore)){
           return
       }
        switch type {
        case .banner001_clickItem:
            // 根据jumpType来判断跳转类型：不跳转 or 商品详情 or 搜索详情 or 店铺主页 or 活动页
            if let mod = model as? HomeCircleBannerItemModel {
                if let app = UIApplication.shared.delegate as? AppDelegate {
                    if let url = mod.jumpInfo, url.isEmpty == false {
                        app.p_openPriveteSchemeString(mod.jumpInfo)
                    }
                }
            }
        case .newPrivillege002_clickItem:
            // 跳转H5
            let mod: HomeNewPrivilegeModel = model as! HomeNewPrivilegeModel
            if let url = mod.jumpInfo, url.isEmpty == false {
                visitSchema(url)
            }
        case .activityBuy003_clickItem:
            // 跳转H5
            let mod: HomeActivityBuyItemModel = model as! HomeActivityBuyItemModel
            if let url = mod.jumplink, url.isEmpty == false {
                visitSchema(url)
            }
        case .adWelfare004_clickItem:
            if let mod = model as? HomeAdWelfareModel {
                jumpBannerDetailActionWithAll(jumpType: mod.jumpType, jumpInfo: mod.jumpInfo, jumpExpandOne: mod.jumpExpandOne, jumpExpandTwo: mod.jumpExpandTwo)
            }
        case .firstRecommend006_clickItem:
            //
            if let mod = model as? HomeRecommendProductItemModel {
                if let url = mod.buyTogetherJumpInfo, url.count > 0 {
                    if url.contains("web/h5/yqg_active") {
                        FKYNavigator.shared().openScheme(FKY_Togeter_Detail_Buy.self, setProperty: { (vc) in
                            let v = vc as! FKYTogeterBuyDetailViewController
                            v.typeIndex = "1"
                            v.productId = "\(mod.buyTogetherId ?? 0)"
                        })
                    }
                    else {
                        // 跳转到商品一起购活动
                        visitSchema(url)
                    }
                }
                else {
                    // 跳转商详
                    jumpProductDetail(productCode: mod.productCode, productSupplyId: mod.productSupplyId)
                }
            }
            else if let mod = model as? HomeSecdKillProductModel {
                if let url = mod.jumpInfo, url.isEmpty == false {
                    visitSchema(url)
                }
                else if let url = mod.jumpInfoMore, url.isEmpty == false {
                    visitSchema(url)
                }
            }
        case .supplySelect007_clickItem:
            // 跳转店铺主页
            let mod: HomeSuppliersShopItemModel = model as! HomeSuppliersShopItemModel
            FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                let controller = vc as! FKYNewShopItemViewController
                if let sid = mod.enterpriseId, sid.isEmpty == false {
                    // 店铺id
                    controller.shopId = sid
                }
                else {
                    controller.shopId = ""
                }
            }, isModal: false)
        case .supplySelect007_clickMore:
            // 跳转店铺列表
            FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                let v = vc as! FKY_TabBarController
                v.index = 2
            })
        case .categoryHotSale008_clickItem:
            // 跳转搜索列表（商品列表）
            let mod = model as! HomeHotSaleProductItemModel
            FKYNavigator.shared().openScheme(FKY_SearchResult.self, setProperty: { (vc) in
                let controller = vc as! FKYSearchResultVC
                controller.spuCode = mod.spu_code // 商品id
            })
        case .categoryHotSale008_clickMore:
            // 跳转（当前类目）搜索列表
            let code = model as! String
            //let keyword = model as! String
            FKYNavigator.shared().openScheme(FKY_SearchResult.self, setProperty: { (vc) in
                let controller = vc as! FKYSearchResultVC
                controller.selectedAssortId = code  // 类目编码
                //controller.keyword = keyword // 关键字
            })
//        case .categoryHotSale008_clickSwitch:
//            // 用户切换类目后，当前类目下的商品数量与之前类目下的商品数量不一致，故需要更新cell高度
//            let mod = model as! Dictionary<String, Any>
//            let categoryIndex = mod["categoryIndex"] as! Int
//            let cell = mod["cell"] as! HomeHotSaleListCell
//            self.view?.updateTableviewCell(cell, nil, categoryIndex)
        case .hexie009_clickItem:
            // 跳转区域热搜
            FKYNavigator.shared().openScheme(FKY_HotSale.self, setProperty: { (vc) in
                let controller = vc as! FKY_HotSale
                controller.isWeekRankMode = false
            })
        case .rankList010_clickMore:
            // 跳转排行榜：本周热销 or 区域热搜
            let isWeek = model as! Bool
            FKYNavigator.shared().openScheme(FKY_HotSale.self, setProperty: { (vc) in
                let controller = vc as! FKY_HotSale
                controller.isWeekRankMode = isWeek
            })
        case .recentPurchase0011_clickItem:
            // 跳转常购清单
            FKYNavigator.shared().openScheme(FKY_OfftenProductList.self, setProperty: { _ in
                //
            })
        case .topCategories012_clickItem:
            // 跳转搜索
            let mod = model as! HomeCategoryTypeModel
            let categoryId = mod.catagoryId
            FKYNavigator.shared().openScheme(FKY_SearchResult.self, setProperty: { (vc) in
                let v = vc as! FKYSearchResultVC
                v.selectedAssortId = categoryId
            })
        case .topCategories012_clickMore:
            // 跳转分类
            FKYNavigator.shared().openScheme(FKY_TabBarController.self) { (vc) in
                let v = vc as! FKY_TabBarController
                v.index = 1
            }
        case .notice013_clickItem:
            // 药城公告
            if let mod = model as? HomePublicNoticeItemModel {
                if let app = UIApplication.shared.delegate as? AppDelegate {
                    if let url = mod.jumpInfo, url.isEmpty == false {
                       app.p_openPriveteSchemeString(mod.jumpInfo)
                   }
                }
            }
        case .navigation014_clickItem:
            // 点击功能按钮
            let mod: HomeFucButtonItemModel = model as! HomeFucButtonItemModel
            if let app = UIApplication.shared.delegate as? AppDelegate {
                if let url = mod.jumpInfo, url.isEmpty == false {
                    app.p_openPriveteSchemeString(mod.jumpInfo)
                }
            }
        case .activityPatterm_clickMore:
            // 点击一起系列更多 跳转H5
            if let mod = model as? HomeActivityBuyModel {
                if let url = mod.jumpInfo, url.isEmpty == false {
                    visitSchema(url)
                } else if let url = mod.jumpInfoMore, url.isEmpty == false {
                    visitSchema(url)
                }
            }else if let mod = model as? HomeSecdKillProductModel{
                if let url = mod.jumpInfo, url.isEmpty == false {
                    visitSchema(url)
                } else if let url = mod.jumpInfoMore, url.isEmpty == false {
                    visitSchema(url)
                }
            }
        case .firstRecommend006_clickItemMore:
            // 点击药城精选更多 跳转H5
            let mod: HomeRecommendModel = model as! HomeRecommendModel
            if let url = mod.recommend?.jumpInfoMore, url.isEmpty == false {
                visitSchema(url)
            }
        case .secondKill016_clickMore:
            // 秒杀专区之查看更多
            if let mod = model as? HomeSecondKillModel {
                if let app = UIApplication.shared.delegate as? AppDelegate {
                    if let url = mod.jumpInfoMore, url.isEmpty == false {
                         app.p_openPriveteSchemeString(mod.jumpInfoMore)
                   }
                }
            }
            else if let mod = model as? HomeSecdKillProductModel {
                if let app = UIApplication.shared.delegate as? AppDelegate {
                    if let url = mod.jumpInfoMore, url.isEmpty == false {
                          app.p_openPriveteSchemeString(mod.jumpInfoMore)
                    }
                }
            }
        case .secondKill016_clickItem:
            // 秒杀专区之查看单个商品详情
            let mod: HomeRecommendProductItemModel = model as! HomeRecommendProductItemModel
            jumpProductDetail(productCode: mod.productCode, productSupplyId: mod.productSupplyId)
        case .category_home_ad_clickItem:
            //中通广告
            let mod: HomeBrandDetailModel = model as! HomeBrandDetailModel
            if let app = UIApplication.shared.delegate as? AppDelegate {
                 if let url = mod.jumpInfo, url.isEmpty == false {
                      app.p_openPriveteSchemeString(mod.jumpInfo)
                 }
               
            }
        default:
            print("\(params[HomeString.ACTION_KEY] ?? "无参数")")
        }
    }
}

// MARK: - public
extension HomePresenter {
    func adapter<VM: HomeViewModelInterface, V: HomeViewInterface>(viewModel: VM,  view: V) {
        self.view = view;
        self.viewModel = viewModel
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            // 读缓存
            strongSelf.viewModel?.loadCacheData(finishedCallback: {
                //开始渲染结束埋点计时
                // YWSpeedUpManager.sharedInstance().end(with: ModuleType.fkyHome)
                DispatchQueue.main.async(execute: {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.view?.viewModel = viewModel
                    strongSelf.view?.operation = self
                    strongSelf.view?.updateHomePageContent()
                    strongSelf.view?.hideLoadMoreFooterWhenRequestFail()
                    strongSelf.view?.showLoading()
                    // 请求首页数据(刷新)
                    strongSelf.onTableViewRefreshAction()
                })
            })
        }
    }
    
    func onLoadView() {
//        self.startTime = round(Date().timeIntervalSince1970 * 1000)
//        self.apiStartTime = round(Date().timeIntervalSince1970 * 1000)
    }
    
    func onViewWillAppear() {
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
        if #available(iOS 13.0, *) {
            UIApplication.shared.setStatusBarStyle(.darkContent, animated: false)
        }
        //UIApplication.shared.setStatusBarHidden(false, with: .fade)
        self.viewModel?.fetchUserLocation(finishedCallback: { (location) in
            self.view?.updateUserLocation(location)
        })
    }
    
    func onViewDidAppear() {
        self.view?.resetHomePageStatus()
        
//        self.pageCreateTime = Int(round(Date().timeIntervalSince1970 * 1000) - self.startTime!)
//        if self.apiStartTime != nil && self.pageLoadTotalTime != nil && self.pageLoadTotalTime != 0 {
//            self.apiStartTime = nil;
//             FKYAnalyticsManager.sharedInstance.BI_Record_Main_Time((self.pageCreateTime)!, pageApiTime: (self.pageApiTime)!, pageLoadTotalTime: (self.pageLoadTotalTime)!, viewController:CurrentViewController.shared.item)
//        }
    }
    
    func onViewWillDisappear() {
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
        if #available(iOS 13.0, *) {
            UIApplication.shared.setStatusBarStyle(.darkContent, animated: false)
        }
    }
}
