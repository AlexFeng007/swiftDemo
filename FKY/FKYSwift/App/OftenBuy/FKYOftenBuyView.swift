//
//  FKYOftenBuyView.swift
//  FKY
//
//  Created by 乔羽 on 2018/8/20.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

enum FKYOftenBuyType {
    case hotSale
    case oftenBuy
    case oftenLook
    case homeRecommend
}
typealias ScrollViewDidScrollBlock = (UIScrollView)->(Void)
class FKYOftenBuyView: UIView {
    //行高管理器
    fileprivate var cellHeightManager:ContentHeightManager = {
        let heightManager = ContentHeightManager()
        return heightManager
    }()
    var scrollBlock: ScrollViewDidScrollBlock?
    fileprivate var isScrollDown : Bool = true
    var lastOffsetY : CGFloat = 0.0
    var type: FKYOftenBuyType? {
        didSet {
            switch type! {
            case .hotSale:
                emptyView.type = .hotSale
                break
            case .oftenBuy:
                emptyView.type = .oftenBuy
                break
            case .oftenLook:
                emptyView.type = .oftenLook
                break
            case .homeRecommend :
                emptyView.type = .homeRecommend
                break
            }
           
        }
    }

    fileprivate var emptyView: FKYOftenBuyEmptyView = {
        let view = FKYOftenBuyEmptyView()
        view.isHidden = true
        return view
    }()

    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        //tableV.register(OftenBuyProductCell.self, forCellReuseIdentifier: "OftenBuyProductCell")
        tableV.register(ShopRecommendListCell.self, forCellReuseIdentifier: "ShopRecommendListCell")
        tableV.mj_header = self?.mjheader
        tableV.mj_footer = self?.mjfooter
        tableV.estimatedRowHeight = WH(240)
        tableV.showsVerticalScrollIndicator = false
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
    }()
    
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            if let block = self?.refreshBlock {
                block()
            }
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
    }()
    
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            if let block = self?.loadMoreBlock {
                block()
            }
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    
    var dataSource: Array<OftenBuyProductItemModel> = []
    
    var model: FKYOftenBuyModel? {
        didSet {
            if let data = model {
                if data.dataSource.count == 0 {
                    emptyView.isHidden = false
                } else {
                    dataSource = data.dataSource
                    tableView.reloadData()
                    refreshDismiss()
                }
            } else {
                emptyView.isHidden = false
            }
        }
    }
    
    fileprivate var selectedSection: Int?
    fileprivate var desRect : CGRect? //点击cell的图片rect
    fileprivate var desImageView : UIImageView? //点击cell的图片

    var refreshBlock: (()->())?
    
    var loadMoreBlock: (()->())?
    
    var updateStepCountBlock: ((_ product: OftenBuyProductItemModel ,_ count: Int, _ row: Int,_ typeIndex: Int)->())?
    
    var toastBlock: ((_ msg: String)->())?
    
    var clickCellBlock: ((_ product: OftenBuyProductItemModel ,_ row: Int)->())?
    
    var showAlertBlock: ((_ alertVC: UIAlertController)->())?
    
    //MARK: Life Style
    
    init() {
        super.init(frame: CGRect.null)
        backgroundColor = bg1
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        
        self.addSubview(emptyView)
        emptyView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Public Method
    func refreshDismiss() {
        if tableView.mj_header.isRefreshing() {
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.resetNoMoreData()
        }
        if let isMore = model?.isMore {
            if isMore {
                tableView.mj_footer.endRefreshing()
            } else {
                tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        }
    }
    
    //加车动画
    func addCarAnimation(callback: @escaping (_ imgView: UIImageView ,_ imgRect: CGRect)->())  {
        if let imgRect = self.desRect {
            callback(self.desImageView!, imgRect)
        }
    }
    
    func refreshDataSelectedSection() {
        if let seletedNum = self.selectedSection {
            let maxSection = self.tableView.numberOfSections
            if seletedNum < maxSection {
                
                let product = self.dataSource[seletedNum]
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if  cartOfInfoModel.spuCode != nil && product.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode! && cartOfInfoModel.supplyId.intValue ==  product.supplyId! {
                            product.carOfCount = cartOfInfoModel.buyNum.intValue
                            product.carId = cartOfInfoModel.cartId.intValue
                            break
                        }
                    }
                }
                
                let indexSet = IndexSet(integer: seletedNum)
                self.tableView.reloadSections(indexSet, with: .none)
            }
        }
    }
    
    //从购物车回来后刷新数据
    func refreshDataBackFromCar()  {
        if dataSource.count > 0 {
            for product in self.dataSource {
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        if  cartOfInfoModel.spuCode != nil && product.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode! && cartOfInfoModel.supplyId.intValue ==  product.supplyId! {
                            product.carOfCount = cartOfInfoModel.buyNum.intValue
                            product.carId = cartOfInfoModel.cartId.intValue
                            break
                        } else {
                            product.carOfCount = 0
                            product.carId = 0
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    //返回最上层
    func backToTopAction(){
        tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        lastOffsetY = 0.0
    }
     //更新滚动最底部 滑动之后 更新
    func updateContentOfsetByScrolll(){
        tableView.setContentOffset(CGPoint.init(x: 0, y: tableView.contentOffset.y - MJRefreshFooterHeight), animated: false)
    }
    //重新设置contentoffy
    func updateContentOffY(){
        if let block = self.scrollBlock {
            block(tableView)
        }
    }
}

extension FKYOftenBuyView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
}

extension FKYOftenBuyView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 商品cell
         let cell: ShopRecommendListCell = tableView.dequeueReusableCell(withIdentifier: "ShopRecommendListCell", for: indexPath) as! ShopRecommendListCell
        cell.selectionStyle = .none
        // 配置cell
        let model : OftenBuyProductItemModel = self.dataSource[indexPath.section]
        cell.configCell(model)

        //weak var weakSelf = self
        //更新加车数量
        cell.addUpdateProductNum = { [weak self] in
            if let strongSelf = self {
                if let block =  strongSelf.updateStepCountBlock{
                    strongSelf.selectedSection = indexPath.section
                    block(model,0,indexPath.section,1)
                }
            }
        }
//        cell.toastAddProductNum = { msg in
//            if let block = weakSelf?.toastBlock {
//                block(msg)
//            }
//        }
//        // 登录
//        cell.loginClosure = {
//            FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
//        }

//        // 商详
//        cell.touchItem = {
//
//        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model : OftenBuyProductItemModel = self.dataSource[indexPath.section]
        let conutCellHeight = ShopRecommendListCell.getCellContentHeight(model as Any)
        return conutCellHeight
//
//        let cellHeight = cellHeightManager.getContentCellHeight(model.spuCode ?? "","\(model.supplyId ?? 0)","fky")
//        if  cellHeight == 0{
//            let conutCellHeight = ShopRecommendListCell.getCellContentHeight(model as Any)
//            cellHeightManager.addContentCellHeight(model.spuCode ?? "","\(model.supplyId ?? 0)","fky", conutCellHeight)
//            return conutCellHeight
//        }else{
//            return cellHeight!
//        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model : OftenBuyProductItemModel = self.dataSource[indexPath.section]
        weak var weakSelf = self
        if let block = weakSelf?.clickCellBlock {
            block(model,indexPath.section)
        }
        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
            let v = vc as! FKY_ProdutionDetail
            v.productionId = model.spuCode!
            v.vendorId = "\(model.supplyId!)"
            v.updateCarNum = { (carId ,num) in
                if let count = num {
                    model.carOfCount = count.intValue
                }
                if let getId = carId {
                    model.carId = getId.intValue
                }
                
                self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
            }
        }, isModal: false)
    }
}

extension FKYOftenBuyView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            isScrollDown = lastOffsetY < scrollView.contentOffset.y
            lastOffsetY = scrollView.contentOffset.y
            if let block = self.scrollBlock {
                block(scrollView)
            }
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == tableView {
            isScrollDown = lastOffsetY < scrollView.contentOffset.y
            lastOffsetY = scrollView.contentOffset.y
            if let block = self.scrollBlock {
                block(scrollView)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating && !decelerate {
            let deadline :DispatchTime = DispatchTime.now() + 1
            DispatchQueue.global().asyncAfter(deadline: deadline) {
                DispatchQueue.main.async {
//                    if let block = self.scrollIndexBlock ,self.pageCount > 0 {
//                        block(0,0)
//                    }
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating {
            let deadline :DispatchTime = DispatchTime.now() + 1
            DispatchQueue.global().asyncAfter(deadline: deadline) {
                DispatchQueue.main.async {
//                    if let block = self.scrollIndexBlock ,self.pageCount > 0 {
//                        block(0,0)
//                    }
                }
            }
        }
    }
}
