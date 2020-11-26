//
//  HomeNewOftenBuyCell.swift
//  FKY
//
//  Created by 寒山 on 2019/3/24.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  新首页 常购清单 的cell

import UIKit

class HomeNewOftenBuyCell: UITableViewCell {

    //头部栏
    fileprivate var scrollType: FKYOftenBuyType?
    fileprivate lazy var operation: HomePresenter = HomePresenter()
    fileprivate lazy var viewModel: NewHomeViewModel = NewHomeViewModel()
    
    public lazy var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    public lazy var homeSegment: HMSegmentedControl = {
        let sv = HMSegmentedControl()
        sv.defaultSetting()
        sv.backgroundColor = UIColor.white
        let normaltextAttr:Dictionary = [NSAttributedString.Key.foregroundColor.rawValue: RGBAColor(0x333333 ,alpha: 1.0),NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(15))] as! [String : Any]
        let selectedtextAttr:Dictionary = [NSAttributedString.Key.foregroundColor.rawValue: RGBAColor(0xFF2D5C,alpha: 1.0),NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(15))] as! [String : Any]
        sv.titleTextAttributes = normaltextAttr
        sv.selectedTitleTextAttributes = selectedtextAttr
        sv.selectionIndicatorColor =  RGBColor(0xFF2D5C)
        sv.selectionIndicatorHeight = 1
        sv.selectionStyle = .textWidthStripe
        sv.selectionIndicatorLocation = .down
        sv.indexChangeBlock = { [weak self] index in
            guard let strongSelf = self else {
                return
            }
            strongSelf.homeScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(index), y: 0), animated: true)
            if let closure = strongSelf.getCurrentType {
                closure(index)
            }
            strongSelf.addClickSegmentBI_Record()
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S7000", sectionPosition: nil, sectionName: nil, itemId: strongSelf.getItemId(index), itemPosition: "0", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController:CurrentViewController.shared.item)
        }
        return sv
    }()
    //底层左右滑动cell
    public lazy var homeScrollView: UIScrollView = {
        let sv = UIScrollView(frame:CGRect.zero)
        sv.delegate = self
        sv.isPagingEnabled = false
        sv.bounces = false
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = .white
        return sv
    }()
    
    var oneView:HomeOftenBuyTableView?
    fileprivate var twoView:HomeOftenBuyTableView?
    fileprivate var threeView:HomeOftenBuyTableView?
    var getTypeMoreData : (()->(Void))? //加载更多
    var getCurrentType : ((Int)->(Void))? //当前的type
    var goAllTableTop : (()->(Void))? //回到顶部
    var scrollToNextPage : (()->(Void))? //滚动到下一个tab
    var scrollToNextPageBySwipeRight: (()->(Void))? //滚动到下一个tab
    var scrollToLastPage : (()->(Void))? //滑动到上一个tab
    var changeCarNumCellBlock :((Bool)->())? //修改购物车数量
    var addCarAnimationCellBlock :((_ imgView: UIImageView? ,_ imgRect: CGRect?)->())? //增加动画
    var updateStepCountBlock: ((_ product: HomeBaseCellProtocol ,_ count: Int, _ row: Int,_ typeIndex: Int)->())?
    
    var addObserver : ((HomeOftenBuyTableView)->())? //增加监听
    var removeObserver : ((HomeOftenBuyTableView)->())? //移除监听
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView(reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView(_ reuseIdentifier: String?) {
        self.backgroundColor = bg7
        self.contentView.addSubview(topLine)
        self.contentView.addSubview(homeSegment)
        topLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        homeSegment.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(topLine.snp.bottom)
            make.height.equalTo(WH(44))
        }
        self.contentView.addSubview(homeScrollView)
        homeScrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(homeSegment.snp.bottom)
        }
        //初始化常购清单/
        for index in 0...2 {
            let oftenBuyView = HomeOftenBuyTableView()
            oftenBuyView.viewType = .planA
            oftenBuyView.index = index
            //加载更多
            oftenBuyView.loadMoreBlock = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                if let closure = strongSelf.getTypeMoreData {
                    closure()
                }
            }
//            //向右滑
//            oftenBuyView.swipeRightRecognizer = { [weak self] in
//                guard let strongSelf = self else {
//                    return
//                }
//                if let block = strongSelf.scrollToLastPage {
//                    block()
//                }
//            }
//            //向左滑
//            oftenBuyView.swipeLeftRecognizer = { [weak self] in
//                guard let strongSelf = self else {
//                    return
//                }
//                if let block = strongSelf.scrollToNextPageBySwipeRight {
//                    block()
//                }
//            }
            oftenBuyView.callback = { [weak self] (ac) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.operation.onClickCellAction(ac)
            }
            //更改购物车数量
            oftenBuyView.updateStepCountBlock = { [weak self] (product, count, row, typeIndex) in
                guard let strongSelf = self else {
                    return
                }
                if let block = strongSelf.updateStepCountBlock {
                    block(product,count,row,typeIndex)
                }
            }
            //回到顶部
            oftenBuyView.goTableTop = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                if let closure = strongSelf.goAllTableTop {
                    //重置tableView的偏移量
                    strongSelf.oneView?.resetTableViewOffsetY()
                    strongSelf.twoView?.resetTableViewOffsetY()
                    strongSelf.threeView?.resetTableViewOffsetY()
                    closure()
                }
            }
            
            var oftenBuyViewH = SCREEN_HEIGHT - naviBarHeight() - WH(11) - WH(44) - 0.5
            if let str = reuseIdentifier ,str == "HomeNewOftenBuyCell" {
                //底部有导航栏的界面
                oftenBuyViewH  = oftenBuyViewH - FKYTabBarController.shareInstance().tabbarHeight
            }
            oftenBuyView.frame = CGRect(x: SCREEN_WIDTH.multiple(index), y: 0, width:SCREEN_WIDTH, height: oftenBuyViewH)
            self.homeScrollView.addSubview(oftenBuyView)
            if index == 0 {
                oneView = oftenBuyView
            }else if  index == 1 {
                twoView = oftenBuyView
            }else {
                threeView = oftenBuyView
            }
        }
        
        weak var weakself = self
        oneView!.scrollBlock = { (scrollV) in
            weakself?.updateScrollViewContentOffset(scrollV: scrollV)
        }
        twoView!.scrollBlock = { (scrollV) in
            weakself?.updateScrollViewContentOffset(scrollV: scrollV)
        }
        threeView!.scrollBlock = { (scrollV) in
            weakself?.updateScrollViewContentOffset(scrollV: scrollV)
        }
    }
    
    func updateScrollViewContentOffset(scrollV: UIScrollView) {
        let y = scrollV.contentOffset.y
        let height:CGFloat = scrollV.frame.size.height
        let bottomOffset:CGFloat = scrollV.contentSize.height - y
        let oftenBuyViewH = SCREEN_HEIGHT - naviBarHeight() - WH(11) - WH(44) - 0.5
        if height > (bottomOffset + WH(80))  &&  scrollV.contentSize.height > (oftenBuyViewH +  MJRefreshFooterHeight) && self.getCurrectView().isScrollViewBegin == true {
            if scrollType != nil && scrollType == self.getCurrectView().type{
                return
            }
            scrollType = self.getCurrectView().type
            let deadline = DispatchTime.now() + 0.6
            DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    if let block = strongSelf.scrollToNextPage {
                        strongSelf.scrollType = nil
                        block()
                    }
                }
            }
        }
        self.getCurrectView().isScrollViewBegin = false
    }
    
    func getAllAddObserverTable() {
        if let block = self.addObserver {
            block(oneView!)
            block(twoView!)
            block(threeView!)
        }
    }
    
    func getAllRmoveObserverTable(){
        if let block = self.removeObserver {
            block(oneView!)
            block(twoView!)
            block(threeView!)
        }
    }
}

extension HomeNewOftenBuyCell{
    func getCurrectView() ->(HomeOftenBuyTableView) {
//        if viewModel.currentType == self.oneView?.type {
//            return self.oneView!
//        }else if viewModel.currentType == self.twoView?.type {
//            return self.twoView!
//        }else if viewModel.currentType == self.threeView?.type {
//            return self.threeView!
//        }else{
            return self.oneView!
      //  }
    }
}

//AMRK:处理数据
extension HomeNewOftenBuyCell {
    //初始化
    func configCellData(_ viewModel:NewHomeViewModel,_ isFirstFresh:Bool) {
//        guard viewModel.sectionTitle.isEmpty == false else {
//            return
//        }
//        guard viewModel.sectionType.isEmpty == false else {
//            return
//        }
//        if viewModel.sectionTitle.count != viewModel.sectionType.count{
//             return
//        }
//        self.viewModel = viewModel
//        homeSegment.sectionTitles = viewModel.sectionTitle
//        homeScrollView.contentSize = CGSize(width: SCREEN_WIDTH.multiple(1), height:0)
//        if viewModel.sectionTitle.count > 0 {
//            for i in 0...viewModel.sectionTitle.count-1 {
//                let type = viewModel.sectionType[i]
//                if i == 0 {
//                    self.oneView?.type = type
//                }else if i == 1 {
//                    self.twoView?.type = type
//                }else {
//                    self.threeView?.type = type
//                }
//            }
//        }
//        //更新购物车数量
//        if viewModel.currentType == self.oneView?.type {
//            self.oneView?.configData(viewModel)
//            self.oneView?.refreshDataBackFromCar()
//            if isFirstFresh{
//                //整体刷新 重置contentoffset
//                self.oneView?.tableView.contentOffset = .zero
//            }
//        }else if viewModel.currentType == self.twoView?.type {
//            self.twoView?.configData(viewModel)
//            self.twoView?.refreshDataBackFromCar()
//            if isFirstFresh{
//                //整体刷新 重置contentoffset
//                self.twoView?.tableView.contentOffset = .zero
//            }
//        }else if viewModel.currentType == self.threeView?.type {
//            self.threeView?.configData(viewModel)
//            self.threeView?.refreshDataBackFromCar()
//            if isFirstFresh{
//                //整体刷新 重置contentoffset
//                self.threeView?.tableView.contentOffset = .zero
//            }
//        }
//        //第一次刷新，初始化到第一页
//        if isFirstFresh {
//            self.homeSegment.setSelectedSegmentIndex(0, animated: true)
//            UIView.animate(withDuration: 0.05, animations: {[weak self] in
//                guard let strongSelf = self else {
//                    return
//                }
//                strongSelf.homeScrollView.contentOffset = CGPoint(x: SCREEN_WIDTH.multiple(0), y: 0)
//            }) { (ret) in
//                //
//            }
//        }
    }
    
    func getType(_ index:Int) -> FKYOftenBuyType {
        if index == 0 {
            return self.oneView?.type ?? .oftenLook
        }else if index == 1 {
            return self.twoView?.type ?? .oftenLook
        }else {
            return self.threeView?.type ?? .oftenLook
        }
    }
    
    //根据类型获取itemid
    func getItemId(_ index:Int) -> String {
        let type = self.getType(index)
        if type == .oftenLook {
            return "I7001"
        }else if type == .hotSale {
            return "I7000"
        }else {
            return "I7002"
        }
    }
}

//MARK:UIScrollViewDelegate代理
extension HomeNewOftenBuyCell :UIScrollViewDelegate{
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.homeScrollView {
            let index = scrollView.contentOffset.x / SCREEN_WIDTH
            if Int(index) != self.viewModel.currentIndex {
                self.homeSegment.setSelectedSegmentIndex(UInt(index), animated: true)
                if let closure = self.getCurrentType {
                    closure(Int(index))
                }
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S7000", sectionPosition: nil, sectionName: nil, itemId: self.getItemId(Int(index)), itemPosition: "0", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController:CurrentViewController.shared.item)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //防止错误反弹
        if scrollView == self.homeScrollView {
            let offsetX = scrollView.contentOffset.x
            if offsetX == 0 && self.viewModel.currentIndex != 0 {
                self.homeScrollView.contentOffset = CGPoint(x: SCREEN_WIDTH.multiple(self.viewModel.currentIndex), y: 0)
            }
        }
    }
}

extension HomeNewOftenBuyCell{
    //点击
    func addClickSegmentBI_Record() {
//        switch self.viewModel.currentType {
//        case .oftenBuy?: // 常买
//            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: nil, sectionId: SECTIONCODE.HOME_ACTION_OFTEN_BUY.rawValue, sectionPosition: "1", sectionName: nil, itemId: ITEMCODE.HOME_ACTION_COMMON_ITEMDETAIL.rawValue, itemPosition: "0", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: CurrentViewController.shared.item)
//        case .oftenLook?: // 常看
//            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: "2", floorName: nil, sectionId: SECTIONCODE.HOME_ACTION_OFTEN_LOOK.rawValue, sectionPosition: "1", sectionName: nil, itemId: ITEMCODE.HOME_ACTION_COMMON_ITEMDETAIL.rawValue, itemPosition: "0", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: CurrentViewController.shared.item)
//        case .hotSale?: // 热销
//            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: "3", floorName: nil, sectionId: SECTIONCODE.HOME_ACTION_OFTEN_HOTSALES.rawValue, sectionPosition: "1", sectionName: nil, itemId: ITEMCODE.HOME_ACTION_COMMON_ITEMDETAIL.rawValue, itemPosition: "0", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: CurrentViewController.shared.item)
//        default:
//            break
//        }
    }
}
