//
//  FileSearchResultHeader.swift
//  FKY
//
//  Created by mahui on 16/9/26.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  商品列表之顶部操作视图...<搜索筛选视图>

import Foundation
import SnapKit
import RxSwift

enum HeaderType : Int {
    case priceSortType // 价格排序
    case shopType      // 店铺类型
    case activityType  // 活动类型
}

enum PriceRangeEnum: String {
    case DESC = "desc"
    case ASC = "asc"
    case SALES = "sales"
    case NONE = "default"
}

enum StockStateEnum: String {
    case ALL = "all"
    case HAVE = "have"
}

enum ShopSortEnum: String {
    case ALLSHOP = "AllShop"
    case SELFSHOP = "selfShop"
}

typealias ChangePriceRangeColosure = (PriceRangeEnum)->()
typealias ChangeStockStateColosure = (StockStateEnum)->()
typealias ChangeShopSortColosure = (ShopSortEnum)->()
typealias sellerNameList = ([SerachSellersInfoModel])->()

let TOTAL_ARR_NUM = 5 //总共的item数量

//priceSortType
class FKYReusableHeader: UIView{
    fileprivate var viewFounction: FKYSearchFunctionalHeaderView?
    fileprivate var currentPriceState: PriceRangeEnum = .NONE
    fileprivate var currentStockState: StockStateEnum?
    fileprivate var currentShopStort: ShopSortEnum? //当前是否自营店
    fileprivate var mpNameSortModel:  FKYSortListModel?
    fileprivate var priceInfoSortModel: FKYSortListModel?
    fileprivate var priceNodeList : FKYSortListModel?
    fileprivate var currentStateList: [FKYSortListModel] = []
    fileprivate var isAllProduct:Bool = true //true:全部商品搜索，false店铺内商品搜索
    @objc var topFilterHeight = WH(0) //筛选视图距顶部位置
    
    /// ------ 记录当前筛选项是否已经有了筛选条件------
    /// 是否有自营商家筛选条件
    var isHaveSelfSeller = false
    
    ///是否有排序筛选条件
    var isHaveSort = false
    
    ///是否有厂家筛选条件
    var isHaveFactory = false
    
    /// 是否有商家筛选条件
    var isHaveMPSeller = false
    
    /// 是否有规格筛选条件
    var isHaveRank = false
    
    /// 当前展开的item
    var currentOpenItemIndex = 0 //等于-1 代表收起已经  其他代码 当前选中哪项
    
    /// 规格列表
    var rankListView:FKYSearchRankListView = {
        let view = FKYSearchRankListView()
        return view
    }()
    
    //call back
    var changePriceRangeAction: ChangePriceRangeColosure?
    var changeStockStateRangeAction: ChangeStockStateColosure?
    var changeShopSortRangeAction: ChangeShopSortColosure?
    var clickPriceRangeWithFirst : emptyClosure? //点击排序
    var clickedShopBtn: emptyClosure? //点击商家按钮
    var updatePositionBtn: emptyClosure? //更新位置按钮
    var clickedSpecBtn: emptyClosure? //点击规格按钮
    var sellerNameFliterAction: sellerNameList?
    var factoryNameFliterAction: ((_ cell: FKYReusableHeader)->())?
    /// 厂家筛选回调
    var selectedFactoryListCallBackBlock:(([SerachFactorysInfoModel])->())?
    /// 规格筛选回调
    var selectedRankListCallBackBlock:(([SerachRankInfoModel])->())?
    ///BI 埋点回调
    var selectedBICallBackBlock:((FKYSearchBIModel)->())?
    //弹出视图
    fileprivate var  priceSortView : FKYPriceSortSelectView?
    fileprivate var  mpNameSortView : FKYMPSelectView?
    fileprivate var mpNameArr: [SerachSellersInfoModel]? //记录选择的商家
    fileprivate weak var mpNameItem: FKYSearchFunctionalItemView? //记录商家item
    fileprivate weak var factoryNameItem: FKYSearchFunctionalItemView? //记录厂家item
    
    
    //销毁时
    func hidePopView() {
        if self.mpNameSortView?.isShowIng == true {
            self.mpNameSortView?.dissmissViewRightNow()
        }
        if self.priceSortView?.isShowIng == true {
            self.priceSortView?.dissmissViewRightNow()
        }
        if self.rankListView.isPoped == true {
            self.rankListView.dissmissViewRightNow()
        }
    }
    ///滑动列表消失选择框
    func hidePopViewForScroll() {
        if self.mpNameSortView?.isShowIng == true {
            self.mpNameSortView?.dissmissViewForScroll()
            if self.isAllProduct {
                //收起弹窗更新按钮状态
                self.updateItemFoldStatusForScroll(3)
                self.updateItemFoldStatusForScroll(4)
                self.updateItemFoldStatusForScroll(1)
            }else{
                self.updateItemFoldStatusForScroll(2)
            }
            
        }
        if self.priceSortView?.isShowIng == true {
            self.priceSortView?.dissmissViewForScroll()
            if self.isAllProduct {
                self.updateItemFoldStatusForScroll(2)
                
            }else{
                self.updateItemFoldStatusForScroll(1)
            }
        }
        if self.rankListView.isPoped == true {
            self.rankListView.dissmissViewForScroll()
            if self.isAllProduct {
                self.updateItemFoldStatusForScroll(5)
                
            }else{
                self.updateItemFoldStatusForScroll(3)
            }
        }
    }
    func setupView(_ isAllProduct :Bool) {
        if self.viewFounction != nil {
            return
        }
        self.isAllProduct = isAllProduct
        var aryItemTuple:[(title:String?, imageName:String?, contentAlignment:ImagesWithTextAlignment, canMultiSelected: Bool, hasContentBg: Bool)] = []
        if self.isAllProduct == true {
            aryItemTuple.append((title: "自营", imageName: "Triangle2", contentAlignment: .horizontal_textLeft_imageRight, canMultiSelected: false, hasContentBg: true))
        }
        aryItemTuple.append((title: "排序", imageName: "Triangle2", contentAlignment: .horizontal_textLeft_imageRight, canMultiSelected: false, hasContentBg: true))
        aryItemTuple.append((title: "厂家", imageName: "Triangle2", contentAlignment: .horizontal_textLeft_imageRight, canMultiSelected: false, hasContentBg: true))
        if self.isAllProduct == true {
            aryItemTuple.append((title: "商家", imageName: "Triangle2", contentAlignment: .horizontal_textLeft_imageRight, canMultiSelected: false, hasContentBg: true))
        }
        aryItemTuple.append((title: "规格", imageName: "Triangle2", contentAlignment: .horizontal_textLeft_imageRight, canMultiSelected: false, hasContentBg: true))
        
        let priceNodeInfoNone = FKYSortItemModel()
        priceNodeInfoNone.initWithInfo(true, "默认", "排序")
        
        let priceNodeInfoSales = FKYSortItemModel()
        priceNodeInfoSales.initWithInfo(false, "月店数", "月店数")
        
        let priceNodeInfoAsc = FKYSortItemModel()
        priceNodeInfoAsc.initWithInfo(false, "价格由低到高", "价格↑")
        
        let priceNodeInfoDsc = FKYSortItemModel()
        priceNodeInfoDsc.initWithInfo(false, "价格由高到低", "价格↓")
        
        self.priceNodeList = FKYSortListModel()
        self.priceNodeList?.adddNonde(priceNodeInfoNone);
        self.priceNodeList?.adddNonde(priceNodeInfoSales);
        self.priceNodeList?.adddNonde(priceNodeInfoAsc);
        self.priceNodeList?.adddNonde(priceNodeInfoDsc);
        
        self.viewFounction = FKYSearchFunctionalHeaderView.init(items: aryItemTuple)
        self.viewFounction?.isSerachItem = true //和全部商品的搜索栏区别
        if nil != self.viewFounction {
            self.viewFounction?.translatesAutoresizingMaskIntoConstraints = false
            addSubview(self.viewFounction!)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[headerView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["headerView" : self.viewFounction!]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[headerView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["headerView" : self.viewFounction!]))
            
            let  priceSortView = FKYPriceSortSelectView()
            let  mpNameSortView = FKYMPSelectView()
            self.priceSortView = priceSortView
            self.mpNameSortView = mpNameSortView
            self.viewFounction?.didSelectItem = { [weak self] (item, selectedIndex, isRunAction) in
                if let strongSelf = self {
                    //更想你滑动高度
                    if let updateAction = self!.updatePositionBtn {
                        updateAction()
                    }
                    //判断弹窗未收起并且不是当前的要下啦的弹窗
                    if strongSelf.currentOpenItemIndex != -1 && self?.currentOpenItemIndex != selectedIndex{//收起其他index
                        strongSelf.hidePopViewForScroll()
                    }
                    
                    if selectedIndex == 1 {
                        if self?.isAllProduct ?? true{//从全部商品中搜索 moren全部商品
                            // 自营商家筛选
                            if let changeAction = self!.clickedShopBtn {
                                changeAction()
                            }
                            if priceSortView.isShowIng == true {
                                //点击弹起
                                priceSortView.dissmissViewRightNow()
                            }
                            if mpNameSortView.isShowIng == true {
                                if self!.isHaveSelfSeller {
                                    self?.updateItemStatus(item! ,type: 3)
                                }else{
                                    self?.updateItemStatus(item! ,type: 1)
                                }
                                strongSelf.currentOpenItemIndex = -1
                                mpNameSortView.dissmissViewRightNow()
                            }
                            else {
                                self?.mpNameItem = item
                                self!.updateItemStatus(item!, type: 2)
                                mpNameSortView.initWithContentAraay(CGRect(x: 0, y: self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)),FKYFilterSearchServicesModel.shared.sellerList,[SerachFactorysInfoModel(factoryId: 0000, factoryName: "")], 1)
                                strongSelf.currentOpenItemIndex = 1
                                //与商家筛选条件互斥
                                if self?.isHaveMPSeller == true{
                                    mpNameSortView.clearSelectData()
                                }
                            }
                            mpNameSortView.callBackBlock{ [weak self] (nodeList) in
                                strongSelf.currentOpenItemIndex = -1
                                if nodeList == nil || nodeList?.count == 0 {
                                    self?.isHaveSelfSeller = false
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                else {
                                    self?.isHaveSelfSeller = true
                                    self?.updateItemStatus(item!, type: 3)
                                    //与商家筛选条件互斥
                                    if self?.isHaveMPSeller == true{
                                        self?.isHaveMPSeller = false
                                        for item_new in (strongSelf.viewFounction?.itemList)! {
                                            if item_new.titleLabel.text == "商家"{
                                                self?.updateItemStatus(item_new, type: 1)
                                            }
                                        }
                                    }
                                }
                                if let changeAction = self!.sellerNameFliterAction {
                                    //                                    self!.mpNameArr = nodeList
                                    //                                    changeAction(nodeList!)
                                    if nodeList == nil{
                                        self!.mpNameArr = [SerachSellersInfoModel]()
                                        changeAction([SerachSellersInfoModel]())
                                    }else{
                                        self!.mpNameArr = nodeList
                                        changeAction(nodeList!)
                                    }
                                }
                            }
                            mpNameSortView.rankListBIBlock = { (BIModel) in
                                if let callBack = self?.selectedBICallBackBlock{
                                    callBack(BIModel)
                                }
                            }
                        }else{// 从店铺内搜索
                            if let clickAction = strongSelf.clickPriceRangeWithFirst {
                                clickAction()
                            }
                            if mpNameSortView.isShowIng == true {
                                if self?.isHaveSort == true {
                                    self?.updateItemStatus(item!, type: 3)
                                }else{
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                strongSelf.currentOpenItemIndex = -1
                                mpNameSortView.dissmissViewRightNow()
                            }
                            if priceSortView.isShowIng == true {
                                if self?.isHaveSort == true {
                                    self?.updateItemStatus(item!, type: 3)
                                }else{
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                strongSelf.currentOpenItemIndex = -1
                                priceSortView.dissmissViewRightNow()
                            }
                            else {
                                self?.updateItemStatus(item!, type: 2)
                                priceSortView.initWithContentAraay(CGRect(x: 0, y: self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)), self!.priceNodeList!)
                                strongSelf.currentOpenItemIndex = 1
                            }
                            priceSortView.callBackBlock{[weak self] (node) in
                                guard let strongSelf = self else {
                                    return
                                }
                                strongSelf.currentOpenItemIndex = -1
                                if node == nil {
                                    self?.isHaveSort = false
                                    self?.updateItemStatus(item!, type: 1)
                                }else{
                                    self?.isHaveSort = true
                                    self?.updateItemStatus(item!, type: 3)
                                    
                                    strongSelf.priceNodeList!.nodeSelectAction(node!)
                                    item?.setTitle((strongSelf.priceNodeList?.selectTitle)!)
                                    if node?.title == "默认" {
                                        strongSelf.currentPriceState = .NONE
                                    }else if node?.title == "月店数" {
                                        strongSelf.currentPriceState = .SALES
                                    }else if node?.title == "价格由低到高" {
                                        strongSelf.currentPriceState = .ASC
                                    }else if node?.title == "价格由高到低" {
                                        strongSelf.currentPriceState = .DESC
                                    }
                                }
                                if let changeAction = strongSelf.changePriceRangeAction {
                                    changeAction(strongSelf.currentPriceState)
                                }
                            }
                        }
                    }
                    else if selectedIndex == 2 {
                        if self?.isAllProduct ?? true{//从全部商品中搜索 moren全部商品
                            if let clickAction = strongSelf.clickPriceRangeWithFirst {
                                clickAction()
                            }
                            if mpNameSortView.isShowIng == true {
                                if self?.isHaveSort == true {
                                    self?.updateItemStatus(item!, type: 3)
                                }else{
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                mpNameSortView.dissmissViewRightNow()
                            }
                            if priceSortView.isShowIng == true {
                                if self?.isHaveSort == true {
                                    self?.updateItemStatus(item!, type: 3)
                                }else{
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                strongSelf.currentOpenItemIndex = -1
                                priceSortView.dissmissViewRightNow()
                            }
                            else {
                                self?.updateItemStatus(item!, type: 2)
                                priceSortView.initWithContentAraay(CGRect(x: 0, y:self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)), self!.priceNodeList!)
                                strongSelf.currentOpenItemIndex = 2
                            }
                            priceSortView.callBackBlock{[weak self] (node) in
                                guard let strongSelf = self else {
                                    return
                                }
                                strongSelf.currentOpenItemIndex = -1
                                if node == nil {
                                    self?.isHaveSort = false
                                    self?.updateItemStatus(item!, type: 1)
                                }else{
                                    self?.isHaveSort = true
                                    self?.updateItemStatus(item!, type: 3)
                                    
                                    strongSelf.priceNodeList!.nodeSelectAction(node!)
                                    item?.setTitle((strongSelf.priceNodeList?.selectTitle)!)
                                    if node?.title == "默认" {
                                        strongSelf.currentPriceState = .NONE
                                    }else if node?.title == "月店数" {
                                        strongSelf.currentPriceState = .SALES
                                    }else if node?.title == "价格由低到高" {
                                        strongSelf.currentPriceState = .ASC
                                    }else if node?.title == "价格由高到低" {
                                        strongSelf.currentPriceState = .DESC
                                    }
                                }
                                if let changeAction = strongSelf.changePriceRangeAction {
                                    changeAction(strongSelf.currentPriceState)
                                }
                            }
                        }
                        else{// 从店铺中搜索
                            // 厂家筛选
                            if let changeAction = self!.clickedShopBtn {
                                changeAction()
                            }
                            if priceSortView.isShowIng == true {
                                //点击弹起
                                priceSortView.dissmissViewRightNow()
                            }
                            if mpNameSortView.isShowIng == true {
                                if self?.isHaveFactory == true{
                                    self?.updateItemStatus(item!, type: 3)
                                }else{
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                strongSelf.currentOpenItemIndex = -1
                                mpNameSortView.dissmissViewRightNow()
                            }
                            else {
                                self?.mpNameItem = item
                                self?.updateItemStatus(item!, type: 2)
                                mpNameSortView.initWithContentAraay(CGRect(x: 0, y: self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)),FKYFilterSearchServicesModel.shared.sellerList,SearchFactoryName.shared.factoryList,3)
                                strongSelf.currentOpenItemIndex = 2
                            }
                            mpNameSortView.callBackBlock{ (nodeList) in
                                strongSelf.currentOpenItemIndex = -1
                                if nodeList == nil || nodeList?.count == 0{
                                    self?.isHaveFactory = false
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                else {
                                    self?.isHaveFactory = true
                                    self?.updateItemStatus(item!, type: 3)
                                }
                                if let changeAction = self!.sellerNameFliterAction {
                                    //                                    self!.mpNameArr = nodeList
                                    //                                    changeAction(nodeList!)
                                    if nodeList == nil{
                                        self!.mpNameArr = [SerachSellersInfoModel]()
                                        changeAction([SerachSellersInfoModel]())
                                    }else{
                                        self!.mpNameArr = nodeList
                                        changeAction(nodeList!)
                                    }
                                }
                            }
                            mpNameSortView.factoryListCallBack = { (factoryList) in
                                strongSelf.currentOpenItemIndex = -1
                                if factoryList.count == 0 {
                                    self?.isHaveFactory = false
                                    self?.updateItemStatus(item!, type: 1)
                                }else {
                                    self?.isHaveFactory = true
                                    self?.updateItemStatus(item!, type: 3)
                                }
                                
                                if let changeAction = self!.selectedFactoryListCallBackBlock {
                                    changeAction(factoryList)
                                }
                            }
                            mpNameSortView.rankListBIBlock = { (BIModel) in
                                if let callBack = self?.selectedBICallBackBlock{
                                    callBack(BIModel)
                                }
                            }
                        }
                    }
                    else if selectedIndex == 3 {
                        if self?.isAllProduct ?? true{//从全部商品中搜索 moren全部商品
                            // 厂家筛选
                            if let changeAction = self!.clickedShopBtn {
                                changeAction()
                            }
                            if priceSortView.isShowIng == true {
                                //点击弹起
                                priceSortView.dissmissViewRightNow()
                            }
                            if mpNameSortView.isShowIng == true {
                                if self?.isHaveFactory == true{
                                    self?.updateItemStatus(item!, type: 3)
                                }else{
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                strongSelf.currentOpenItemIndex = -1
                                mpNameSortView.dissmissViewRightNow()
                            }
                            else {
                                self?.mpNameItem = item
                                self?.updateItemStatus(item!, type: 2)
                                mpNameSortView.initWithContentAraay(CGRect(x: 0, y: self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)),FKYFilterSearchServicesModel.shared.sellerList,SearchFactoryName.shared.factoryList,3)
                                strongSelf.currentOpenItemIndex = 3
                            }
                            mpNameSortView.callBackBlock{ (nodeList) in
                                strongSelf.currentOpenItemIndex = -1
                                if nodeList == nil || nodeList?.count == 0{
                                    self?.isHaveFactory = false
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                else {
                                    self?.isHaveFactory = true
                                    self?.updateItemStatus(item!, type: 3)
                                }
                                if let changeAction = self!.sellerNameFliterAction {
                                    //                                    self!.mpNameArr = nodeList
                                    //                                    changeAction(nodeList!)
                                    if nodeList == nil{
                                        self!.mpNameArr = [SerachSellersInfoModel]()
                                        changeAction([SerachSellersInfoModel]())
                                    }else{
                                        self!.mpNameArr = nodeList
                                        changeAction(nodeList!)
                                    }
                                }
                            }
                            mpNameSortView.factoryListCallBack = { (factoryList) in
                                strongSelf.currentOpenItemIndex = -1
                                if factoryList.count == 0 {
                                    self?.isHaveFactory = false
                                    self?.updateItemStatus(item!, type: 1)
                                }else {
                                    self?.isHaveFactory = true
                                    self?.updateItemStatus(item!, type: 3)
                                }
                                
                                if let changeAction = self!.selectedFactoryListCallBackBlock {
                                    changeAction(factoryList)
                                }
                            }
                            
                            mpNameSortView.rankListBIBlock = { (BIModel) in
                                if let callBack = self?.selectedBICallBackBlock{
                                    callBack(BIModel)
                                }
                            }
                        }else{//从店铺中搜索
                            if self?.rankListView.isPoped == true {//已弹出则收起
                                if self?.isHaveRank == true{
                                    self?.updateItemStatus(item!, type: 3)
                                }else{
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                strongSelf.currentOpenItemIndex = -1
                                self?.rankListView.dissmissView()
                            }else{
                                self?.updateItemStatus(item!, type: 2)
                                self?.rankListView.initRankList(CGRect(x: 0, y: self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)))
                                strongSelf.currentOpenItemIndex = 3
                            }
                            self?.rankListView.rankListCallBack = { (rankList) in
                                strongSelf.currentOpenItemIndex = -1
                                if rankList.count == 0{
                                    self?.isHaveRank = false
                                    self?.updateItemStatus(item!, type: 1)
                                }else{
                                    self?.isHaveRank = true
                                    self?.updateItemStatus(item!, type: 3)
                                }
                                if let callBack = self?.selectedRankListCallBackBlock{
                                    callBack(rankList)
                                }
                            }
                            self?.rankListView.rankListBIBlock = { (BIModel) in
                                if let callBack = self?.selectedBICallBackBlock{
                                    callBack(BIModel)
                                }
                            }
                        }
                        
                    }
                    else if selectedIndex == 4 {
                        // 商家筛选
                        if let changeAction = self!.clickedShopBtn {
                            changeAction()
                        }
                        if priceSortView.isShowIng == true {
                            //点击弹起
                            priceSortView.dissmissViewRightNow()
                        }
                        if mpNameSortView.isShowIng == true {
                            if self?.isHaveMPSeller == true{
                                self?.updateItemStatus(item!, type: 3)
                            }else{
                                self?.updateItemStatus(item!, type: 1)
                            }
                            strongSelf.currentOpenItemIndex = -1
                            mpNameSortView.dissmissViewRightNow()
                        }
                        else {
                            self?.mpNameItem = item
                            self?.updateItemStatus(item!, type: 2)
                            mpNameSortView.initWithContentAraay(CGRect(x: 0, y: self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)),FKYFilterSearchServicesModel.shared.sellerList,[SerachFactorysInfoModel(factoryId: 0000, factoryName: "")],2)
                            strongSelf.currentOpenItemIndex = 4
                            //与自营筛选条件互斥
                            if self?.isHaveSelfSeller == true{
                                mpNameSortView.clearSelectData()
                            }
                        }
                        mpNameSortView.callBackBlock{ (nodeList) in
                            strongSelf.currentOpenItemIndex = -1
                            if nodeList == nil || nodeList?.count == 0{
                                self?.isHaveMPSeller = false
                                self?.updateItemStatus(item!, type: 1)
                            }else {
                                self?.isHaveMPSeller = true
                                self?.updateItemStatus(item!, type: 3)
                                //与自营筛选条件互斥
                                if self?.isHaveSelfSeller == true{
                                    self?.isHaveSelfSeller = false
                                    for item_new in (strongSelf.viewFounction?.itemList)! {
                                        if item_new.titleLabel.text == "自营"{
                                            self?.updateItemStatus(item_new, type: 1)
                                        }
                                    }
                                }
                            }
                            if let changeAction = self!.sellerNameFliterAction {
                                if nodeList == nil{
                                    self!.mpNameArr = [SerachSellersInfoModel]()
                                    changeAction([SerachSellersInfoModel]())
                                }else{
                                    self!.mpNameArr = nodeList
                                    changeAction(nodeList!)
                                }
                            }
                        }
                    }
                    else if selectedIndex == 5 {
                        if let changeAction = self!.clickedSpecBtn {
                            changeAction()
                        }
                        //
                        if self?.rankListView.isPoped == true {//已弹出则收起
                            if self?.isHaveRank == true{
                                self?.updateItemStatus(item!, type: 3)
                            }else{
                                self?.updateItemStatus(item!, type: 1)
                            }
                            strongSelf.currentOpenItemIndex = -1
                            self?.rankListView.dissmissView()
                        }else{
                            self?.updateItemStatus(item!, type: 2)
                            self?.rankListView.initRankList(CGRect(x: 0, y: self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)))
                            strongSelf.currentOpenItemIndex = 5
                        }
                        self?.rankListView.rankListCallBack = { (rankList) in
                            strongSelf.currentOpenItemIndex  = -1
                            if rankList.count == 0{
                                self?.isHaveRank = false
                                self?.updateItemStatus(item!, type: 1)
                            }else{
                                self?.isHaveRank = true
                                self?.updateItemStatus(item!, type: 3)
                            }
                            if let callBack = self?.selectedRankListCallBackBlock{
                                callBack(rankList)
                            }
                        }
                        
                        self?.rankListView.rankListBIBlock = { (BIModel) in
                            if let callBack = self?.selectedBICallBackBlock{
                                callBack(BIModel)
                            }
                        }
                        
                    }
                }
                
            }
            
            self.viewFounction?.didUpdateItem = { [weak self] (item, updateIndex) in
                if let strongSelf = self {
                    if let updateAction = self!.updatePositionBtn {
                        updateAction()
                    }
                    if updateIndex != 5{
                        if self?.isHaveRank == true{
                            for item_new in (strongSelf.viewFounction?.itemList)! {
                                if item_new.titleLabel.text == "规格"{
                                    self?.updateItemStatus(item_new, type: 3)
                                }
                            }
                        }else{
                            for item_new in (strongSelf.viewFounction?.itemList)! {
                                if item_new.titleLabel.text == "规格"{
                                    self?.updateItemStatus(item_new, type: 1)
                                }
                            }
                        }
                        // self?.rankListView.dissmissViewRightNow()
                    }
                    //判断弹窗未收起并且不是当前的要下啦的弹窗
                    if strongSelf.currentOpenItemIndex != -1 && self?.currentOpenItemIndex != updateIndex{//收起其他index
                        strongSelf.hidePopViewForScroll()
                    }
                    
                    if updateIndex == 1 {
                        if self?.isAllProduct ?? true{//从全部商品中搜索 moren全部商品
                            if priceSortView.isShowIng == true {
                                priceSortView.dissmissViewRightNow()
                            }
                            if mpNameSortView.isShowIng == true {
                                if self!.isHaveSelfSeller{
                                    self!.updateItemStatus(item! ,type: 3)
                                }else{
                                    self!.updateItemStatus(item! ,type: 1)
                                }
                                strongSelf.currentOpenItemIndex = -1
                                mpNameSortView.dissmissView()
                            }else {
                                self!.updateItemStatus(item! ,type: 2)
                                mpNameSortView.initWithContentAraay(CGRect(x: 0, y:self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)), FKYFilterSearchServicesModel.shared.sellerList,[SerachFactorysInfoModel(factoryId: 0000, factoryName: "")],1)
                                strongSelf.currentOpenItemIndex = 1
                                //与商家筛选条件互斥
                                if self?.isHaveMPSeller == true{
                                    mpNameSortView.clearSelectData()
                                }
                            }
                            mpNameSortView.callBackBlock{ (nodeList) in
                                strongSelf.currentOpenItemIndex = -1
                                if nodeList == nil || nodeList?.count == 0 {
                                    self?.isHaveSelfSeller = false
                                    self?.updateItemStatus(item! ,type: 1)
                                }else{
                                    self?.isHaveSelfSeller = true
                                    self?.updateItemStatus(item! ,type: 3)
                                    //与商家筛选条件互斥
                                    if self?.isHaveMPSeller == true{
                                        self?.isHaveMPSeller = false
                                        for item_new in (strongSelf.viewFounction?.itemList)! {
                                            if item_new.titleLabel.text == "商家"{
                                                self?.updateItemStatus(item_new, type: 1)
                                            }
                                        }
                                    }
                                }
                                if let changeAction = strongSelf.sellerNameFliterAction {
                                    //                                        strongSelf.mpNameArr = nodeList
                                    //                                        changeAction(nodeList!)
                                    if nodeList == nil{
                                        self!.mpNameArr = [SerachSellersInfoModel]()
                                        changeAction([SerachSellersInfoModel]())
                                    }else{
                                        self!.mpNameArr = nodeList
                                        changeAction(nodeList!)
                                    }
                                }
                            }
                            mpNameSortView.rankListBIBlock = { (BIModel) in
                                if let callBack = self?.selectedBICallBackBlock{
                                    callBack(BIModel)
                                }
                            }
                        }else{//从店铺中搜索
                            if mpNameSortView.isShowIng == true {
                                if self?.isHaveSort == true {
                                    self?.updateItemStatus(item!, type: 3)
                                }else{
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                strongSelf.currentOpenItemIndex = -1
                                mpNameSortView.dissmissViewRightNow()
                            }
                            if priceSortView.isShowIng == true {
                                if self?.isHaveSort == true {
                                    self?.updateItemStatus(item!, type: 3)
                                }else{
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                strongSelf.currentOpenItemIndex = -1
                                priceSortView.dissmissView()
                                return;
                            }
                            self?.updateItemStatus(item!, type: 2)
                            priceSortView.initWithContentAraay(CGRect(x: 0, y: self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)), strongSelf.priceNodeList!)
                            strongSelf.currentOpenItemIndex = 1
                            priceSortView.callBackBlock{ (node) in
                                strongSelf.currentOpenItemIndex = -1
                                if node == nil{
                                    self?.isHaveSort = false
                                    self?.updateItemStatus(item!, type: 1)
                                }else{
                                    self?.isHaveSort = true
                                    self?.updateItemStatus(item!, type: 3)
                                    strongSelf.priceNodeList!.nodeSelectAction(node!)
                                    item?.setTitle((strongSelf.priceNodeList?.selectTitle)!)
                                    if node?.title == "默认" {
                                        strongSelf.currentPriceState = .NONE
                                    }else if node?.title == "月店数" {
                                        strongSelf.currentPriceState = .SALES
                                    }
                                    else if node?.title == "价格由低到高" {
                                        strongSelf.currentPriceState = .ASC
                                    }else if node?.title == "价格由高到低" {
                                        strongSelf.currentPriceState = .DESC
                                    }
                                }
                                if let changeAction = strongSelf.changePriceRangeAction {
                                    changeAction(strongSelf.currentPriceState)
                                }
                            }
                        }
                    }
                    else if updateIndex == 2 {
                        if self?.isAllProduct ?? true{//从全部商品中搜索 默认全部商品
                            if mpNameSortView.isShowIng == true {
                                if self?.isHaveSort == true {
                                    self?.updateItemStatus(item!, type: 3)
                                }else{
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                if let clickAction = strongSelf.clickPriceRangeWithFirst {
                                    clickAction()
                                }
                                strongSelf.currentOpenItemIndex = -1
                                mpNameSortView.dissmissViewRightNow()
                            }
                            if priceSortView.isShowIng == true {
                                if self?.isHaveSort == true {
                                    self?.updateItemStatus(item!, type: 3)
                                }else{
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                strongSelf.currentOpenItemIndex = -1
                                priceSortView.dissmissView()
                                return;
                            }
                            self?.updateItemStatus(item!, type: 2)
                            priceSortView.initWithContentAraay(CGRect(x: 0, y: self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)), strongSelf.priceNodeList!)
                            strongSelf.currentOpenItemIndex = 2
                            priceSortView.callBackBlock{ (node) in
                                strongSelf.currentOpenItemIndex = -1
                                if node == nil{
                                    self?.isHaveSort = false
                                    self?.updateItemStatus(item!, type: 1)
                                }else{
                                    self?.isHaveSort = true
                                    self?.updateItemStatus(item!, type: 3)
                                    strongSelf.priceNodeList!.nodeSelectAction(node!)
                                    item?.setTitle((strongSelf.priceNodeList?.selectTitle)!)
                                    if node?.title == "默认" {
                                        strongSelf.currentPriceState = .NONE
                                    }else if node?.title == "月店数" {
                                        strongSelf.currentPriceState = .SALES
                                    }
                                    else if node?.title == "价格由低到高" {
                                        strongSelf.currentPriceState = .ASC
                                    }else if node?.title == "价格由高到低" {
                                        strongSelf.currentPriceState = .DESC
                                    }
                                }
                                if let changeAction = strongSelf.changePriceRangeAction {
                                    changeAction(strongSelf.currentPriceState)
                                }
                            }
                        }else{/// 从店铺内搜索
                            if priceSortView.isShowIng == true {
                                strongSelf.currentOpenItemIndex = -1
                                priceSortView.dissmissViewRightNow()
                            }
                            if mpNameSortView.isShowIng == true {
                                if self?.isHaveFactory == true{
                                    self?.updateItemStatus(item!, type: 3)
                                }else{
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                strongSelf.currentOpenItemIndex = -1
                                mpNameSortView.dissmissView()
                            }else {
                                self?.updateItemStatus(item!, type: 2)
                                mpNameSortView.initWithContentAraay(CGRect(x: 0, y: self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)),FKYFilterSearchServicesModel.shared.sellerList,SearchFactoryName.shared.factoryList,3)
                                strongSelf.currentOpenItemIndex = 2
                            }
                            mpNameSortView.callBackBlock{ (nodeList) in
                                strongSelf.currentOpenItemIndex = -1
                                if nodeList == nil || nodeList?.count == 0{
                                    self?.isHaveFactory = false
                                    self?.updateItemStatus(item!, type: 1)
                                }else{
                                    self?.isHaveFactory = true
                                    self?.updateItemStatus(item!, type: 3)
                                }
                                if let changeAction = strongSelf.sellerNameFliterAction {
                                    //                                    strongSelf.mpNameArr = nodeList
                                    //                                    changeAction(nodeList!)
                                    if nodeList == nil{
                                        self!.mpNameArr = [SerachSellersInfoModel]()
                                        changeAction([SerachSellersInfoModel]())
                                    }else{
                                        self!.mpNameArr = nodeList
                                        changeAction(nodeList!)
                                    }
                                }
                            }
                            mpNameSortView.factoryListCallBack = { (factoryList) in
                                strongSelf.currentOpenItemIndex = -1
                                if factoryList.count == 0 {
                                    self?.isHaveFactory = false
                                    self?.updateItemStatus(item!, type: 1)
                                }else {
                                    self?.isHaveFactory = true
                                    self?.updateItemStatus(item!, type: 3)
                                }
                                
                                if let changeAction = self!.selectedFactoryListCallBackBlock {
                                    changeAction(factoryList)
                                }
                            }
                            
                            mpNameSortView.rankListBIBlock = { (BIModel) in
                                if let callBack = self?.selectedBICallBackBlock{
                                    callBack(BIModel)
                                }
                            }
                        }
                    }
                    else if updateIndex == 3 {
                        if self?.isAllProduct ?? true{//从全部商品中搜索 默认全部商品
                            if priceSortView.isShowIng == true {
                                strongSelf.currentOpenItemIndex = -1
                                priceSortView.dissmissViewRightNow()
                            }
                            if mpNameSortView.isShowIng == true {
                                if self?.isHaveFactory == true{
                                    self?.updateItemStatus(item!, type: 3)
                                }else{
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                strongSelf.currentOpenItemIndex = -1
                                mpNameSortView.dissmissView()
                            }else {
                                self?.updateItemStatus(item!, type: 2)
                                mpNameSortView.initWithContentAraay(CGRect(x: 0, y: self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)),FKYFilterSearchServicesModel.shared.sellerList,SearchFactoryName.shared.factoryList,3)
                                strongSelf.currentOpenItemIndex = 3
                            }
                            mpNameSortView.callBackBlock{ (nodeList) in
                                strongSelf.currentOpenItemIndex = -1
                                if nodeList == nil || nodeList?.count == 0{
                                    self?.isHaveFactory = false
                                    self?.updateItemStatus(item!, type: 1)
                                }else{
                                    self?.isHaveFactory = true
                                    self?.updateItemStatus(item!, type: 3)
                                }
                                if let changeAction = strongSelf.sellerNameFliterAction {
                                    //                                    strongSelf.mpNameArr = nodeList
                                    //                                    changeAction(nodeList!)
                                    if nodeList == nil{
                                        self!.mpNameArr = [SerachSellersInfoModel]()
                                        changeAction([SerachSellersInfoModel]())
                                    }else{
                                        self!.mpNameArr = nodeList
                                        changeAction(nodeList!)
                                    }
                                }
                            }
                            mpNameSortView.factoryListCallBack = { (factoryList) in
                                strongSelf.currentOpenItemIndex = -1
                                if factoryList.count == 0 {
                                    self?.isHaveFactory = false
                                    self?.updateItemStatus(item!, type: 1)
                                }else {
                                    self?.isHaveFactory = true
                                    self?.updateItemStatus(item!, type: 3)
                                }
                                
                                if let changeAction = self!.selectedFactoryListCallBackBlock {
                                    changeAction(factoryList)
                                }
                            }
                            
                            mpNameSortView.rankListBIBlock = { (BIModel) in
                                if let callBack = self?.selectedBICallBackBlock{
                                    callBack(BIModel)
                                }
                            }
                        }else{// 从店铺中搜索
                            if self?.rankListView.isPoped == true {//已弹出则收起
                                if self?.isHaveRank == true{
                                    self?.updateItemStatus(item!, type: 3)
                                }else{
                                    self?.updateItemStatus(item!, type: 1)
                                }
                                strongSelf.currentOpenItemIndex = -1
                                self?.rankListView.dissmissView()
                            }else{
                                self?.updateItemStatus(item!, type: 2)
                                self?.rankListView.initRankList(CGRect(x: 0, y: self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)))
                                strongSelf.currentOpenItemIndex = 3
                            }
                            self?.rankListView.rankListCallBack = { (rankList) in
                                strongSelf.currentOpenItemIndex = -1
                                if rankList.count == 0{
                                    self?.isHaveRank = false
                                    self?.updateItemStatus(item!, type: 1)
                                }else{
                                    self?.isHaveRank = true
                                    self?.updateItemStatus(item!, type: 3)
                                }
                                if let callBack = self?.selectedRankListCallBackBlock{
                                    callBack(rankList)
                                }
                            }
                            
                            self?.rankListView.rankListBIBlock = { (BIModel) in
                                if let callBack = self?.selectedBICallBackBlock{
                                    callBack(BIModel)
                                }
                            }
                            
                        }
                    }
                    else if updateIndex == 4 {
                        if priceSortView.isShowIng == true {
                            strongSelf.currentOpenItemIndex = -1
                            priceSortView.dissmissViewRightNow()
                        }
                        if mpNameSortView.isShowIng == true {
                            if self?.isHaveMPSeller == true{
                                self?.updateItemStatus(item!, type: 3)
                            }else{
                                self?.updateItemStatus(item!, type: 1)
                            }
                            strongSelf.currentOpenItemIndex = -1
                            mpNameSortView.dissmissView()
                        }else {
                            self?.updateItemStatus(item!, type: 2)
                            mpNameSortView.initWithContentAraay(CGRect(x: 0, y: self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)), FKYFilterSearchServicesModel.shared.sellerList,[SerachFactorysInfoModel(factoryId: 0000, factoryName: "")],2)
                            strongSelf.currentOpenItemIndex = 4
                            //与自营筛选条件互斥
                            if self?.isHaveSelfSeller == true{
                                mpNameSortView.clearSelectData()
                            }
                        }
                        mpNameSortView.callBackBlock{ (nodeList) in
                            strongSelf.currentOpenItemIndex = -1
                            if nodeList == nil || nodeList?.count == 0{
                                self?.isHaveMPSeller = false
                                self?.updateItemStatus(item!, type: 1)
                            }else{
                                self?.isHaveMPSeller = true
                                self?.updateItemStatus(item!, type: 3)
                                //与自营筛选条件互斥
                                if self?.isHaveSelfSeller == true{
                                    self?.isHaveSelfSeller = false
                                    for item_new in (strongSelf.viewFounction?.itemList)! {
                                        if item_new.titleLabel.text == "自营"{
                                            self?.updateItemStatus(item_new, type: 1)
                                        }
                                    }
                                }
                            }
                            if let changeAction = strongSelf.sellerNameFliterAction {
                                //                                strongSelf.mpNameArr = nodeList
                                //                                changeAction(nodeList!)
                                if nodeList == nil{
                                    self!.mpNameArr = [SerachSellersInfoModel]()
                                    changeAction([SerachSellersInfoModel]())
                                }else{
                                    self!.mpNameArr = nodeList
                                    changeAction(nodeList!)
                                }
                            }
                            //未选择商家更新状态
                            //                            strongSelf.updateShopStates()
                        }
                    }
                    else if updateIndex == 5 {
                        if let changeAction = self!.clickedSpecBtn {
                            changeAction()
                        }
                        if self?.rankListView.isPoped == true {//已弹出则收起
                            if self?.isHaveRank == true{
                                self?.updateItemStatus(item!, type: 3)
                            }else{
                                self?.updateItemStatus(item!, type: 1)
                            }
                            strongSelf.currentOpenItemIndex = -1
                            self?.rankListView.dissmissView()
                        }else{
                            self?.updateItemStatus(item!, type: 2)
                            self?.rankListView.initRankList(CGRect(x: 0, y: self?.topFilterHeight ?? 0, width: SCREEN_WIDTH, height: naviBarHeight() + WH(40)))
                            strongSelf.currentOpenItemIndex = 5
                        }
                        self?.rankListView.rankListCallBack = { (rankList) in
                            strongSelf.currentOpenItemIndex = -1
                            if rankList.count == 0{
                                self?.isHaveRank = false
                                self?.updateItemStatus(item!, type: 1)
                            }else{
                                self?.isHaveRank = true
                                self?.updateItemStatus(item!, type: 3)
                            }
                            if let callBack = self?.selectedRankListCallBackBlock{
                                callBack(rankList)
                            }
                        }
                        
                        self?.rankListView.rankListBIBlock = { (BIModel) in
                            if let callBack = self?.selectedBICallBackBlock{
                                callBack(BIModel)
                            }
                        }
                        
                    }
                }
            }
            
            self.viewFounction?.didDeselectItemForMulti = { [weak self] (item , deselectIndex) in
                if let strongSelf = self {
                    if (strongSelf.isAllProduct == true && deselectIndex == 5) || (strongSelf.isAllProduct == false && deselectIndex == 3) {
                        if priceSortView.isShowIng == true {
                            priceSortView.dissmissViewRightNow()
                        }
                        if mpNameSortView.isShowIng == true {
                            mpNameSortView.dissmissViewRightNow()
                        }
                        item?.setImage(UIImage(named: "shaixuan_normal"))
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.currentPriceState = .NONE
        self.currentStockState =  .ALL
        self.currentShopStort = .ALLSHOP
        //setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func desFactoryNameFliterAction() {
        if let segementView = self.viewFounction {
            if self.isAllProduct == true {
                segementView.deselectSegmentForMulti(3)
            }else {
                segementView.deselectSegmentForMulti(2)
            }
        }
    }
    
    //更新厂家item
    func updateFactoryStates(){
        if let factoryItem = self.factoryNameItem {
            factoryItem.setTitleColor(RGBColor(0x333333))
            factoryItem.setImage(UIImage(named: "shaixuan_normal"))
        }
    }
    
    //
    func updateShopStates() {
        if self.isAllProduct == false {
            return
        }
        //未选择商家更新状态
        if let arr = self.mpNameArr ,arr.count > 0 {
            
        }else {
            if let mpItem = self.mpNameItem {
                mpItem.setTitleColor(RGBColor(0x333333));
                mpItem.setImage(UIImage(named: "Triangle2"))
                mpItem.setContentViewState(.ItemViewSelectStateNormal)
            }
        }
    }
    
    //初始化商家筛选条件
    func updateShopStatesWithInitial() {
        //店铺搜索无这个条件
        if self.isAllProduct == false {
            return
        }
        if self.viewFounction?.itemList.count == TOTAL_ARR_NUM, let arr = self.mpNameArr, arr.count > 0 {
            //初始化标签为未选中
            let item = self.viewFounction?.itemList[3]
            item?.setTitleColor(RGBColor(0x333333));
            item?.setImage(UIImage(named: "Triangle2"))
            item?.setContentViewState(.ItemViewSelectStateNormal)
            //初始化选中的商家
            self.mpNameArr?.removeAll()
            self.mpNameSortView?.resetSelectInfoAction()
            FKYFilterSearchServicesModel.shared.sellerSelectedList.removeAll()
        }
    }
    
    //初始自营标签
    func updateShopSortWithInitial()  {
        //店铺搜索无这个条件
        if self.isAllProduct == false {
            return
        }
        //选中自营标签时初始化
        if self.currentShopStort == .SELFSHOP ,self.viewFounction?.itemList.count == TOTAL_ARR_NUM {
            let item = self.viewFounction?.itemList[1]
            item?.setTitleColor(RGBColor(0x333333));
            item?.setContentViewState(.ItemViewSelectStateNormal)
            self.currentShopStort = .ALLSHOP
        }
    }
    
    //初始化记录的状态值
    func updatePirceAndShopSortAndStockStates(_ priceSeq:String,_ stockSeq:String,_ shopSort:String,_ selectedPriceDefault:Bool){
        if priceSeq == PriceRangeEnum.NONE.rawValue, selectedPriceDefault == true {
            //选中默认 ，初始第一个化标签为选中
            if self.viewFounction?.itemList.count == TOTAL_ARR_NUM || self.isAllProduct == false  {
                let item = self.viewFounction?.itemList[0]
                item?.setContentViewState(.ItemViewSelectStateSelected)
                item?.setTitleColor(RGBColor(0xFF2D5C))
                item?.setImage(UIImage(named: "Triangle3"))
                self.currentPriceState = .NONE
            }
        }
        else if priceSeq != PriceRangeEnum.NONE.rawValue {
            //选中其他的条件
            if self.viewFounction?.itemList.count == TOTAL_ARR_NUM || self.isAllProduct == false {
                //初始第一个化标签为选中
                let item = self.viewFounction?.itemList[0]
                item?.setContentViewState(.ItemViewSelectStateSelected)
                item?.setTitleColor(RGBColor(0xFF2D5C))
                item?.setImage(UIImage(named: "Triangle1"))
                if let node = self.priceNodeList?.sortArray[0] {
                    node.isSelected = false
                }
                if priceSeq == PriceRangeEnum.SALES.rawValue {
                    self.currentPriceState = .SALES
                    if let node = self.priceNodeList?.sortArray[1] {
                        node.isSelected = true
                        self.priceNodeList!.nodeSelectAction(node)
                    }
                }else if priceSeq == PriceRangeEnum.ASC.rawValue {
                    self.currentPriceState = .ASC
                    if let node = self.priceNodeList?.sortArray[2] {
                        node.isSelected = true
                        self.priceNodeList!.nodeSelectAction(node)
                    }
                }else if priceSeq == PriceRangeEnum.DESC.rawValue {
                    self.currentPriceState = .DESC
                    if let node = self.priceNodeList?.sortArray[3] {
                        node.isSelected = true
                        self.priceNodeList!.nodeSelectAction(node)
                    }
                }
                item?.setTitle((self.priceNodeList?.selectTitle)!)
            }
        }
        
        if shopSort != ShopSortEnum.ALLSHOP.rawValue {
            if self.isAllProduct == true {
                if self.viewFounction?.itemList.count == TOTAL_ARR_NUM {
                    //初始化第二个标签为选中
                    let item = self.viewFounction?.itemList[1]
                    item?.setTitleColor(RGBColor(0xFF2D5C));
                    item?.setContentViewState(.ItemViewSelectStateSelected)
                    self.currentShopStort = .SELFSHOP
                }
            }
        }
        
        if stockSeq != StockStateEnum.ALL.rawValue {
            if self.isAllProduct == true {
                if self.viewFounction?.itemList.count == TOTAL_ARR_NUM {
                    //初始第三个化标签为选中
                    let item = self.viewFounction?.itemList[2]
                    item?.setTitleColor(RGBColor(0xFF2D5C));
                    item?.setContentViewState(.ItemViewSelectStateSelected)
                    self.currentStockState = .HAVE
                }
            }else {
                //初始第二个化标签为选中
                let item = self.viewFounction?.itemList[1]
                item?.setTitleColor(RGBColor(0xFF2D5C));
                item?.setContentViewState(.ItemViewSelectStateSelected)
                self.currentStockState = .HAVE
            }
        }
    }
}

//MARK: - 更新各个item的状态
extension FKYReusableHeader {
    /// 更新item的折叠状态
    func updateItemFoldStatus(_ itemIndex:Int){
        if self.isAllProduct {// 全部商品搜索
            if itemIndex == 1{
                let item = self.viewFounction?.itemList[0]
                if self.isHaveSelfSeller {
                    self.updateItemStatus(item! ,type: 3)
                }else{
                    self.updateItemStatus(item! ,type: 1)
                }
                self.mpNameSortView?.dissmissViewRightNow()
            }else if itemIndex == 2{
                let item = self.viewFounction?.itemList[1]
                if self.isHaveSort == true {
                    self.updateItemStatus(item!, type: 3)
                }else{
                    self.updateItemStatus(item!, type: 1)
                }
                self.priceSortView?.dissmissViewRightNow()
            }else if itemIndex == 3{
                let item = self.viewFounction?.itemList[2]
                if self.isHaveFactory == true{
                    self.updateItemStatus(item!, type: 3)
                }else{
                    self.updateItemStatus(item!, type: 1)
                }
                self.mpNameSortView?.dissmissViewRightNow()
            }else if itemIndex == 4{
                let item = self.viewFounction?.itemList[3]
                if self.isHaveMPSeller == true{
                    self.updateItemStatus(item!, type: 3)
                }else{
                    self.updateItemStatus(item!, type: 1)
                }
                self.mpNameSortView?.dissmissViewRightNow()
            }else if itemIndex == 5{
                let item = self.viewFounction?.itemList[4]
                if self.isHaveRank == true{
                    self.updateItemStatus(item!, type: 3)
                }else{
                    self.updateItemStatus(item!, type: 1)
                }
                self.rankListView.dissmissViewRightNow()
            }
        }else{// 店铺内搜索
            if itemIndex == 1{
                let item = self.viewFounction?.itemList[0]
                if self.isHaveSort == true {
                    self.updateItemStatus(item!, type: 3)
                }else{
                    self.updateItemStatus(item!, type: 1)
                }
                self.priceSortView?.dissmissViewRightNow()
            }else if itemIndex == 2{
                let item = self.viewFounction?.itemList[1]
                if self.isHaveFactory == true{
                    self.updateItemStatus(item!, type: 3)
                }else{
                    self.updateItemStatus(item!, type: 1)
                }
                self.mpNameSortView?.dissmissViewRightNow()
            }else if itemIndex == 3{
                let item = self.viewFounction?.itemList[2]
                if self.isHaveRank == true{
                    self.updateItemStatus(item!, type: 3)
                }else{
                    self.updateItemStatus(item!, type: 1)
                }
                self.rankListView.dissmissViewRightNow()
            }
        }
    }
    /// 更新item的折叠状态
    func updateItemFoldStatusForScroll(_ itemIndex:Int){
        if self.isAllProduct {// 全部商品搜索
            if itemIndex == 1{
                let item = self.viewFounction?.itemList[0]
                if self.isHaveSelfSeller {
                    self.updateItemStatus(item! ,type: 3)
                }else{
                    self.updateItemStatus(item! ,type: 1)
                }
            }else if itemIndex == 2{
                let item = self.viewFounction?.itemList[1]
                if self.isHaveSort == true {
                    self.updateItemStatus(item!, type: 3)
                }else{
                    self.updateItemStatus(item!, type: 1)
                }
            }else if itemIndex == 3{
                let item = self.viewFounction?.itemList[2]
                if self.isHaveFactory == true{
                    self.updateItemStatus(item!, type: 3)
                }else{
                    self.updateItemStatus(item!, type: 1)
                }
            }else if itemIndex == 4{
                let item = self.viewFounction?.itemList[3]
                if self.isHaveMPSeller == true{
                    self.updateItemStatus(item!, type: 3)
                }else{
                    self.updateItemStatus(item!, type: 1)
                }
            }else if itemIndex == 5{
                let item = self.viewFounction?.itemList[4]
                if self.isHaveRank == true{
                    self.updateItemStatus(item!, type: 3)
                }else{
                    self.updateItemStatus(item!, type: 1)
                }
            }
        }else{// 店铺内搜索
            if itemIndex == 1{
                let item = self.viewFounction?.itemList[0]
                if self.isHaveSort == true {
                    self.updateItemStatus(item!, type: 3)
                }else{
                    self.updateItemStatus(item!, type: 1)
                }
            }else if itemIndex == 2{
                let item = self.viewFounction?.itemList[1]
                if self.isHaveFactory == true{
                    self.updateItemStatus(item!, type: 3)
                }else{
                    self.updateItemStatus(item!, type: 1)
                }
            }else if itemIndex == 3{
                let item = self.viewFounction?.itemList[2]
                if self.isHaveRank == true{
                    self.updateItemStatus(item!, type: 3)
                }else{
                    self.updateItemStatus(item!, type: 1)
                }
            }
        }
    }
    
    /// 更新item状态
    /// - Parameters:
    ///   - item: 需要更新的item
    ///   - type: 1收起状态但未确定选中任何筛选状态  2已选中展开状态  3收起状态且选择了具体的筛选条件
    func updateItemStatus(_ item:FKYSearchFunctionalItemView,type:Int){
        if type == 1{
            item.setContentViewState(.ItemViewSelectStateNormal)
            item.setTitleColor(RGBColor(0x333333))
            item.setImage(UIImage(named: "Triangle2"))
        }else if type == 2{
            item.setContentViewState(.ItemViewSelectStateSelected)
            item.setTitleColor(RGBColor(0xFF2D5C))
            item.setImage(UIImage(named: "Triangle3"))
        }else if type == 3{
            item.setContentViewState(.ItemViewSelectStateSelected)
            item.setTitleColor(RGBColor(0xFF2D5C))
            item.setImage(UIImage(named: "Triangle1"))
        }
    }
}

class ActivityInfoFooterView: UICollectionReusableView {
    
    fileprivate var infoLabel: UILabel?
    var changeInfoClouser:SingleStringClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.changeInfoClouser = { (info) in
            self.infoLabel?.text = info
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        self.infoLabel = {
            let s = UILabel()
            self.addSubview(s)
            s.snp.makeConstraints({ (make) in
                make.top.equalTo(self.snp.top).offset(WH(10))
                make.left.equalTo(self.snp.left).offset(j1)
                make.right.equalTo(self.snp.right).offset(-j1)
                make.bottom.equalTo(self.snp.bottom).offset(WH(-10))
            })
            s.numberOfLines = 0
            s.textColor = RGBColor(0x707070)
            s.font = UIFont.systemFont(ofSize: WH(12))
            return s
        }()
        
        // 底部分隔线
        let v = UIView()
        v.backgroundColor = m1
        self.addSubview(v)
        v.snp.makeConstraints({ (make) in
            make.right.equalTo(self).offset(-WH(10))
            make.left.equalTo(self).offset(WH(10))
            make.bottom.equalTo(self)
            make.height.equalTo(1)
        })
    }
    
    func configView(_ promotionModel:FKYPromationInfoModel?) {
        self.infoLabel?.text = "以下商品享受: " + promotionModel!.promotionDescriptionWithoutPromotionType()
    }
    
    func configViewText(_ desc: String?) {
        self.infoLabel?.text = desc
    }
}
