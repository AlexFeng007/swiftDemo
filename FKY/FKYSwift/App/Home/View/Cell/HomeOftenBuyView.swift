//
//  HomeOftenBuyView.swift
//  FKY
//
//  Created by hui on 2018/12/12.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class HomeOftenBuyView: UIView {
    //行高管理器
    fileprivate var cellHeightManager:ContentHeightManager = {
        let heightManager = ContentHeightManager()
        return heightManager
    }()
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            if let closure = self!.getMoreData {
                closure(self!.type)
            }
            
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.estimatedRowHeight = WH(250)
        tableV.showsVerticalScrollIndicator = false
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        //  tableV.register(OftenBuyProductCell.self, forCellReuseIdentifier: "OftenBuyProductCell")
        tableV.register(ShopRecommendListCell.self, forCellReuseIdentifier: "ShopRecommendListCell")
        tableV.mj_footer = self?.mjfooter
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    fileprivate lazy var topButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "btn_back_top"), for: .normal)
        btn.isHidden = true
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self]  (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.goTableTop {
                btn.isHidden = true
                closure()
            }
            
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    fileprivate var shopProvider: ShopItemProvider = {
        return ShopItemProvider()
    }()
    
    fileprivate var service: FKYCartService = {
        let service = FKYCartService()
        service.editing = false
        return service
    }()
    
    //MARK ：处理滑动相关及属性
    fileprivate var canScroll  = false
    // 记录滑动开始
    fileprivate var isScrollViewBegin : Bool = false
    fileprivate var tabContentH : CGFloat?//记录tabview的内容高度
    var type:FKYOftenBuyType = .oftenLook //类型（0，1，2）
    var index:Int = 0 //类型（0，1，2）
    var indexPathSelect : IndexPath?//被选中的row
    var dataArr : [OftenBuyProductItemModel]? = [] //加载的数据
    var hasNextData:Bool = true //判断是否有下一页
    
    var goNextTab : ((Int)->(Void))?
    var getMoreData : ((FKYOftenBuyType)->(Void))? //加载更多
    var goTableTop : (()->(Void))? //回到顶部
    var updateCarNum :((OftenBuyProductItemModel?,Int)->(Void))? //更新商品数量
    fileprivate var isScrollDown : Bool = true
    var lastOffsetY : CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        self.addSubview(topButton)
        topButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-WH(17))
            make.height.width.equalTo(WH(44))
            make.bottom.equalTo(self.snp.bottom).offset(-WH(30))
        }
        NotificationCenter.default.addObserver(self, selector: #selector(HomeOftenBuyView.acceptMes(_:)), name: NSNotification.Name(rawValue: TABLETOP), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeOftenBuyView.acceptMes(_:)), name: NSNotification.Name(rawValue: TABLELEAVETOP), object: nil)
    }
    
    @objc fileprivate func acceptMes(_ nty: Notification) {
        let dic = nty.userInfo
        if nty.name.rawValue ==  TABLETOP {
            if let canScroll = dic?["canScroll"] as? String , canScroll == "1",let tagStr = dic?["tag"] as? String,self.tag == Int(tagStr) {
                self.canScroll = true
            }
        }else if nty.name.rawValue ==  TABLELEAVETOP {
            if let tagStr = dic?["tag"] as? String,self.tag == Int(tagStr){
                self.canScroll = false
                self.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            }
        }
    }
    deinit {
        print("HomeOftenBuyView deinit~!@")
        NotificationCenter.default.removeObserver(self)
    }
}

//Mark :数据刷新处理
extension HomeOftenBuyView {
    func configData(_ viewModel:FKYOftenBuyViewModel,_ isFirstFresh:Bool) {
        //第一次加载
        if isFirstFresh == true {
            self.canScroll = false
            dataArr?.removeAll()
            self.tableView.reloadData()
        }
        viewModel.currentModel.isFirstLoad = false
        dataArr = viewModel.currentModel.dataSource
        hasNextData = viewModel.currentModel.isNotMoreData
        if viewModel.currentModel.isNotMoreData == true {
            mjfooter.resetNoMoreData()
        }else {
            mjfooter.endRefreshingWithNoMoreData()
        }
        self.tableView.reloadData()
    }
    //根据购物车数量更新列表数据
    func refreshArr() {
        if let arr = self.dataArr ,arr.count > 0 {
            for product in arr {
                if FKYCartModel.shareInstance().productArr.count > 0 {
                    for cartModel  in FKYCartModel.shareInstance().productArr {
                        if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == product.spuCode && cartOfInfoModel.supplyId.intValue == Int(product.supplyId!) {
                            product.carId = cartOfInfoModel.cartId.intValue
                            product.carOfCount = cartOfInfoModel.buyNum.intValue
                            break
                        }else {
                            product.carOfCount = 0
                            product.carId = 0
                        }
                    }
                }else {
                    product.carOfCount = 0
                    product.carId = 0
                } 
            }
            self.tableView.reloadData()
        }
    }
    //重置滑动位置后重置一些参数
    func resetTableViewOffsetY(){
        self.isScrollViewBegin = false
        self.canScroll = false
        self.isScrollDown = true
        self.lastOffsetY = 0
        self.topButton.isHidden = true
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
}

//MARK: UITableViewDataSource,UITableViewDelegate 代理
extension HomeOftenBuyView: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 商品cell
        let cell: ShopRecommendListCell = tableView.dequeueReusableCell(withIdentifier: "ShopRecommendListCell", for: indexPath) as! ShopRecommendListCell
        cell.selectionStyle = .none
        // 配置cell
        let model = self.dataArr?[indexPath.row]
        cell.configCell(model as Any)
        
        // 更新加车数量
        cell.addUpdateProductNum = { [weak self]  in
            guard let strongSelf = self else {
                return
            }
            strongSelf.indexPathSelect = indexPath
            if let block = strongSelf.updateCarNum{
                block(model,indexPath.row)
            }
        }
        //点击套餐按钮
        cell.clickComboBtn = { [weak self]  in
            guard let _ = self else {
                return
            }
            if let itemModel = model {
                if let num = itemModel.dinnerPromotionRule , num == 2 {
                    //固定套餐
                    FKYNavigator.shared().openScheme(FKY_ComboList.self, setProperty: { (vc) in
                        let controller = vc as! FKYComboListViewController
                        controller.enterpriseName = itemModel.supplyName
                        controller.sellerCode = itemModel.supplyId ?? 0
                        controller.spuCode = itemModel.spuCode ?? ""
                    }, isModal: false)
                }else {
                    //搭配套餐
                    FKYNavigator.shared().openScheme(FKY_MatchingPackageVC.self, setProperty: { (vc) in
                        let controller = vc as! FKYMatchingPackageVC
                        controller.spuCode = itemModel.spuCode ?? ""
                        controller.enterpriseId = "\(itemModel.supplyId ?? 0)"
                    }, isModal: false)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArr?[indexPath.row]
        CurrentViewController.shared.item?.view.endEditing(true)
        guard let product = model else {
            return
        }
        self.addLookDetailBI_Record(indexPath.row + 1,product)
        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
            let v = vc as! FKY_ProdutionDetail
            v.productionId = product.spuCode!
            v.vendorId = "\(product.supplyId!)"
            v.updateCarNum = { (carId ,num) in
                if let count = num {
                    product.carOfCount = count.intValue
                }
                if let getId = carId {
                    product.carId = getId.intValue
                }
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }, isModal: false)
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (tableView.isDragging || tableView.isDecelerating) && isScrollDown {
            //上滑处理
            let scrollIndex = indexPath.row / 10
            if scrollIndex+1 > 1 {
                self.topButton.isHidden = false
            }
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (tableView.isDragging || tableView.isDecelerating) && !isScrollDown {
            //下滑处理
            let scrollIndex = (indexPath.row-1) / 10
            if scrollIndex+1 < 2 {
                self.topButton.isHidden = true
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataArr?[indexPath.row]
        let conutCellHeight = ShopRecommendListCell.getCellContentHeight(model as Any)
        return conutCellHeight
        //        let cellHeight = cellHeightManager.getContentCellHeight(model!.spuCode ?? "","\(model!.supplyId ?? 0)","fky")
        //        if  cellHeight == 0{
        //            let conutCellHeight = ShopRecommendListCell.getCellContentHeight(model as Any)
        //            cellHeightManager.addContentCellHeight(model!.spuCode ?? "","\(model!.supplyId ?? 0)","fky", conutCellHeight)
        //            return conutCellHeight
        //        }else{
        //            return cellHeight!
        //        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScrollViewBegin = true
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.isScrollViewBegin = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //滑动冲突
        if self.canScroll == false {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        }
        let offSetY = scrollView.contentOffset.y
        if offSetY < 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:TABLELEAVETOP), object: nil , userInfo: ["canScroll":"1","tag":"\(self.tag)"])
        }
        
        //控制显示回到顶部按钮
        isScrollDown = lastOffsetY < scrollView.contentOffset.y
        lastOffsetY = scrollView.contentOffset.y
        
        //滑动到底部继续滑动跳转下一个tab
        if let arr = self.dataArr ,arr.count >= 10 ,self.hasNextData == false {
            tabContentH = self.tableView.contentSize.height+WH(44)
            if (offSetY + self.bounds.size.height - tabContentH!) > 60 && self.isScrollViewBegin == true {
                let deadline = DispatchTime.now() + 0.6
                DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    DispatchQueue.main.async {[weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        if let closure = strongSelf.goNextTab {
                            closure(strongSelf.index)
                        }
                    }
                }
            }
            self.isScrollViewBegin = false
        }
    }
}
//加车埋点问题
extension HomeOftenBuyView {
    func refreshItemOfTable() {
        self.tableView.reloadRows(at: [self.indexPathSelect!], with: .none)
    }
}
//查看商详埋点
extension HomeOftenBuyView {
    //普通查看商详埋点
    func addLookDetailBI_Record(_ index:Int,_ product: OftenBuyProductItemModel) {
        let itemContent = "\(product.supplyId ?? 0)|\(product.spuCode ?? "0")"
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : product.pm_pmtn_type! as AnyObject]
        switch self.type {
        case .oftenBuy: // 常买
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: "常购清单", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_ACTION_COMMON_ITEMDETAIL.rawValue, itemPosition: "\(index)", itemName: "点进商详", itemContent: itemContent, itemTitle: product.sourceFrom ?? "", extendParams: extendParams, viewController: CurrentViewController.shared.item)
            break
        case .oftenLook:
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: "常看", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_ACTION_COMMON_ITEMDETAIL.rawValue, itemPosition: "\(index)", itemName: "点进商详", itemContent: itemContent, itemTitle: product.sourceFrom ?? "", extendParams: extendParams, viewController: CurrentViewController.shared.item)
            break
        case .hotSale: // 热销
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: "3", floorName: "当地热销", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_ACTION_COMMON_ITEMDETAIL.rawValue, itemPosition: "\(index)", itemName: "点进商详", itemContent: itemContent, itemTitle: product.sourceFrom ?? "", extendParams: extendParams, viewController: CurrentViewController.shared.item)
            break
        default:
            break
        }
    }
}

