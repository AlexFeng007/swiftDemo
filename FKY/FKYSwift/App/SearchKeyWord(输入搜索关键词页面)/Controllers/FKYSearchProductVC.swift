//
//  FKYSearchProductVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/8/30.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  输入关键词搜索商品界面

import UIKit

class FKYSearchProductVC: UIViewController {
    
    /// 更改搜索框文字
    static let changeSearchBarTextAction = "changeSearchBarTextAction"
    
    /// viewModel
    var viewModel:FKYSearchService = FKYSearchService()
    
    /// 商家ID 只有搜店铺内商品的时候才有 从父VC传过来
    var shopID:String = ""
    
    /// 折叠状态下历史搜索词的数据源
    //var foldHistoryList:[FKYSearchProductCellModel] = [FKYSearchProductCellModel]();
    
    /// 是否超过了两行
    var isOverTwoLine:Bool = false;
    
    /// 是否折叠 进入界面默认折叠
    var isFold:Bool = false;
    
    /// 历史记录 & 发现 视图
    var itemView:FKYSearchItemView = FKYSearchItemView();
    
    /// 搜索类型，默认为1 全栈搜索商品 3店铺内搜索商品 后续扩展可对此字段加类型
    var searchType = 1
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>FKYSearchProductVC deinit~!@")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.itemView.mainCollectionView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isFold = true;
        //更新历史搜索词
        self.updataHistoryKeyWordList(isFold: true)
        
        // 更新发现列表
        self.getSearchActivityData()
        
    }
    
    
}

//MARK: - 事件响应
extension FKYSearchProductVC{
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKYSearchItemView.searchItemViewSelectedItemAction {
            // 点击了某一个item
            let cellModel = userInfo[FKYUserParameterKey] as! FKYSearchProductCellModel
            if cellModel.cellType == .foundCell{
                // 点击的发现item
                if cellModel.foundModel.jumpInfo.isEmpty == false{
                    if let app = UIApplication.shared.delegate as? AppDelegate{
                        app.p_openPriveteSchemeString(cellModel.foundModel.jumpInfo)
                    }
                }
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "搜索发现", itemId: "I8002", itemPosition: "\(cellModel.cellRow)", itemName: cellModel.foundModel.name, itemContent: self.shopID, itemTitle: nil, extendParams: nil, viewController: self);
            }else if cellModel.cellType == .historyCell{
                // 点击的历史搜索词
                self.viewModel.save(cellModel.historyModel.name, type: self.searchType as NSNumber, shopId: nil, success: { (isSuccess) in
                    self.updataHistoryKeyWordList(isFold: self.isFold)
                    
                }) { (msg:String?) in
                    self.toast(msg)
                }
                // 更新搜索框的搜索词
                self.routerEvent(withName: FKYSearchProductVC.changeSearchBarTextAction, userInfo: [FKYUserParameterKey:cellModel.historyModel.name])
                FKYNavigator.shared()?.openScheme(FKY_SearchResult.self, setProperty: { (vc) in
                    let searchResultVC = vc as! FKYSearchResultVC
                    searchResultVC.keyword = cellModel.historyModel.name; // 搜索关键词
                    //searchResultVC.factoryNameKeyword = "searchButton";
                    searchResultVC.fromWhere = "history";
                    searchResultVC.keyWordSoruceType = 0;
                    searchResultVC.searchResultType = "Product"; // 搜索类型
                    //searchResultVC.sellerCode
                })
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "最近搜索", itemId: "I8003", itemPosition: "\(cellModel.cellRow)", itemName: "最近搜索词", itemContent: self.shopID, itemTitle: nil, extendParams: ["keyword":cellModel.historyModel.name] as [String:AnyObject], viewController: self);
            }else if cellModel.cellType == .foldCell {
                // 点击的折叠item
                self.isFold = !self.isFold
                let type = isFold ? "flodItem_up" : "flodItem_down"
                self.viewModel.switchHistoryList(withType: type, andIsOverTwoLine: self.isOverTwoLine)
                self.itemView.showData(dataList: self.viewModel.dataList as! [FKYSearchProductSectionModel])
            }
        }else if eventName == FKYSearchContentHeader.clearHistoryWordListAction {
            /// 清空按钮
            self.viewModel.clearHistorytype(self.searchType as NSNumber, shopId: nil, success: { (isSuccess) in
                self.viewModel.clearHistoryWordListInMemory()
                self.itemView.showData(dataList: self.viewModel.dataList as! [FKYSearchProductSectionModel])
            }) { (msg:String?) in
                self.toast(msg)
            }
        }else{
            super.routerEvent(withName: eventName, userInfo: userInfo)
        }
    }
}

//MARK: - 私有方法
extension FKYSearchProductVC{
    
    /// 更新搜索词
    func updataHistoryKeyWordList(isFold:Bool){
        self.viewModel.fetchSearchHistory(withType: 1, success: { (mutiplyPage) in
            self.viewModel.mapperToCellModel()
            self.installFoldHistoryList()
            let type = isFold ?  "flodItem_up" : "flodItem_down"
            self.viewModel.switchHistoryList(withType:type, andIsOverTwoLine: self.isOverTwoLine)
            self.itemView.showData(dataList: self.viewModel.dataList as! [FKYSearchProductSectionModel])
        }) { (reason:String?) in
            self.toast(reason)
        }
    }
    
    func installFoldHistoryList(){
        self.viewModel.foldHistoryList.removeAllObjects()
        // 当前item所在的行
        var lines:Int = 1;
        // 当前最右边的x值
        var maxX:CGFloat = 15;
        // 第二行能容纳的最大X 右边距+展开item+item间距
        let containerMaxX:CGFloat = SCREEN_WIDTH-WH(12);
        // item 是否超过了2行
        var isGreaterTwoLine:Bool = false;
        // 折叠按钮的宽度
        let flodItemWidth:CGFloat = WH(30);
        // 第二行也就是最后一行折叠行的最大宽度 屏幕宽度-左右边距-item间隔-折叠按钮宽度
        //CGFloat lastItemMaxWidth = SCREEN_WIDTH-15-15-10-flodItemWidth;
        // 这一行的第几个item
        var ItemIndexInLine:NSInteger = 0;
        
        if let historyArray =  self.viewModel.searchHistoryArray,historyArray.isEmpty == false{
            for (index,history_t) in historyArray.enumerated()  {
                let history = history_t as! FKYSearchHistoryModel
                let cellModel = FKYSearchProductCellModel()
                cellModel.cellType = .historyCell
                //            NSInteger index = [self.service.searchHistoryArray indexOfObject:history];
                var itemWidth = self.getItemWidthText(text: history.name)
                if (itemWidth < WH(30)) {
                    itemWidth = WH(30);
                }
                if (itemWidth > (SCREEN_WIDTH - 12 - WH(30)-WH(10)-15)){
                    itemWidth = SCREEN_WIDTH - 12 - WH(30)-WH(10)-15
                }
                if (lines == 1) {// 当前在第一行
                    maxX += itemWidth;
                    ItemIndexInLine += 1;
                    if (maxX>containerMaxX){// 超过最右边的界限
                        maxX = 15.0;
                        
                        lines += 1;
                        ItemIndexInLine = 1;
                    }else{
                        maxX += 10;
                        cellModel.historyModel = history
                        self.viewModel.foldHistoryList.add(cellModel)
                    }
                }
                
                if (lines == 2) {// 当前在第二行
                    maxX += itemWidth;
                    if (ItemIndexInLine == 1 && maxX+10+flodItemWidth>containerMaxX){
                        cellModel.historyModel = history
                        self.viewModel.foldHistoryList.add(cellModel)
                        if index < self.viewModel.searchHistoryArray.count - 1{
                            // 说明后面还有，需要加折叠按钮
                            let cellModel_1 = FKYSearchProductCellModel()
                            let history_2 = FKYSearchHistoryModel()
                            history_2?.itemType = "flodItem_up";
                            history_2?.name = "";
                            cellModel_1.historyModel = history_2 ?? FKYSearchHistoryModel()
                            cellModel_1.cellType = .foldCell
                            self.viewModel.foldHistoryList.add(cellModel_1)
                            isGreaterTwoLine = true;
                            self.isOverTwoLine = true;
                        }else{
                            isGreaterTwoLine = false;
                            self.isOverTwoLine = false;
                        }
                        break;
                    }else{
                        if (maxX+10 + flodItemWidth > containerMaxX){
                            let history_1 = FKYSearchHistoryModel()
                            history_1?.itemType = "flodItem_up";
                            history_1?.name = "";
                            cellModel.historyModel = history_1 ?? FKYSearchHistoryModel()
                            cellModel.cellType = .foldCell
                            self.viewModel.foldHistoryList.add(cellModel)
                            isGreaterTwoLine = true;
                            self.isOverTwoLine = true;
                            break;
                        }else{
                            maxX += 10;
                            cellModel.historyModel = history
                            self.viewModel.foldHistoryList.add(cellModel)
                            ItemIndexInLine += 1;
                        }
                    }
                }
            }
        }
        
        self.isOverTwoLine = isGreaterTwoLine;
    }
    
    /// 获取item的宽度
    /// @param text item文字
    func getItemWidthText(text:String) -> CGFloat {
        //        let size = CGSize(width: (SCREEN_WIDTH - WH(12+15)), height: CGFloat.greatestFiniteMagnitude)
        let width = text.ga_widthForComment(fontSize: WH(14), height: CGFloat.greatestFiniteMagnitude)
        return width+WH(20);
    }
    
    /// 从新加载页面数据
    func reloadData(){
        
    }
    
}

//MARK: - 网络请求
extension FKYSearchProductVC{
    
    func getSearchActivityData(){
        self.viewModel.getSearchActivityDataSuccess({ (mutiplyPage) in
            self.viewModel.mapperToCellModel()
            self.installFoldHistoryList()
            let type = self.isFold ?  "flodItem_up" : "flodItem_down"
            self.viewModel.switchHistoryList(withType:type, andIsOverTwoLine: self.isOverTwoLine)
            self.itemView.showData(dataList: self.viewModel.dataList as! [FKYSearchProductSectionModel])
        }) { (reason:String?) in
            self.toast(reason)
        }
    }
}


//MARK： - UI
extension FKYSearchProductVC{
    func setupUI(){
        self.view.addSubview(self.itemView)
        
        self.itemView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
}
