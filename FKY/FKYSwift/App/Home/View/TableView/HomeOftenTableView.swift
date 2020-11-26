//
//  HomeOftenBuyView.swift
//  FKY
//
//  Created by 寒山 on 2019/3/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  新首页 常购清单的tableview

import UIKit

class HomeOftenBuyTableView: UIView {
    
    var homeTemplateModel = [HomeTemplateModel]()
    var dataSource: Array<HomeBaseCellProtocol> = []  //数据
    //行高管理器
    fileprivate var cellHeightManager:ContentHeightManager = {
        let heightManager = ContentHeightManager()
        return heightManager
    }()
    var model: HomeOftenBuyModel? {
        didSet {
            if let data = model {
                if data.dataSource.count == 0 {
                    // emptyView.isHidden = false
                } else {
                    // emptyView.isHidden = true
                    dataSource = data.dataSource
                    tableView.reloadData()
                    refreshDismiss()
                }
                if data.hasNextPage == true {
                    mjfooter.resetNoMoreData()
                }else {
                    mjfooter.endRefreshingWithNoMoreData()
                }
            } else {
                //emptyView.isHidden = false
            }
        }
    }
    // 记录滑动开始
    var isScrollViewBegin : Bool = false
    
    //刷新操作
    var refreshBlock: (()->())?
    //加载更多
    var loadMoreBlock: (()->())?
    //更新加车
    var updateStepCountBlock: ((_ product: HomeBaseCellProtocol ,_ count: Int, _ row: Int,_ typeIndex: Int)->())?
    //提示
    var toastBlock: ((_ msg: String)->())?
    //提示
    var showAlertBlock: ((_ alertVC: UIAlertController)->())?
    // closure
    //查看更多点击广告
    var callback: HomeCellActionCallback?
    //检测tableView滑动
    var scrollBlock: ScrollViewDidScrollBlock?
    var index:Int = 0 //类型（0，1，2） 当前类型
    var hasNextData:Bool = true //判断是否有下一页
    //滚到下一个tab
    var goTableTop : (()->(Void))? //回到顶部
    fileprivate var isScrollDown : Bool = true
    var lastOffsetY : CGFloat = 0.0 //当前contentoff set y 位置
    var viewType: HomeViewType?
    var type: FKYOftenBuyType? {
        didSet {
            switch type! {
            case .hotSale:
                // emptyView.type = .hotSale
                mjfooter.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
                break
            case .oftenBuy:
                // emptyView.type = .oftenBuy
                mjfooter.setTitle("—— 继续上拉，查看更多商品 ——", for: MJRefreshState.noMoreData)
                break
            case .oftenLook:
                // emptyView.type = .oftenLook
                mjfooter.setTitle("—— 继续上拉，查看更多商品 ——", for: MJRefreshState.noMoreData)
                break
            default :
                // emptyView.type = .homeRecommend
                mjfooter.setTitle("—— 继续上拉，查看更多商品 ——", for: MJRefreshState.noMoreData)
                break
            }
        }
    }
    //    fileprivate var emptyView: FKYOftenBuyEmptyView = {
    //        let view = FKYOftenBuyEmptyView()
    //        view.isHidden = true
    //        return view
    //    }()
    //置顶按钮
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
    
    public lazy var tableView: UITableView = { [weak self] in
        var tableView = UITableView(frame: CGRect.null, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ColorConfig.colorffffff
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableFooterView = UIView.init(frame: .zero)
        //tableView.register(HomeComonProductItemCell.self, forCellReuseIdentifier: "HomeComonProductItemCell")
        // tableView.register(HomePromotionSecKillCell.self, forCellReuseIdentifier: "HomePromotionSecKillCell")
        // tableView.register(HomePromotionGroupBuyCell.self, forCellReuseIdentifier: "HomePromotionGroupBuyCell")
        //tableView.register(HomePromotionHighProfitCell.self, forCellReuseIdentifier: "HomePromotionHighProfitCell")
        tableView.register(ProductInfoListCell.self, forCellReuseIdentifier: "ProductInfoListCell")
        tableView.register(HomePromotionStyleCell.self, forCellReuseIdentifier: "HomePromotionStyleCell")
        tableView.register(HomePromotionNewTableViewCell.self, forCellReuseIdentifier: "HomePromotionNewTableViewCell")
        tableView.register(HomeBannerListCell.self, forCellReuseIdentifier: "HomeBannerListCell")
        tableView.register(HomeFucListCell.self, forCellReuseIdentifier: "HomeFucListCell")
        tableView.register(HomePublicNoticeCell.self, forCellReuseIdentifier: "HomePublicNoticeCell")
        tableView.register(HomeOneAdPageCell.self, forCellReuseIdentifier: "HomeOneAdPageCell")
        tableView.register(HomeTwoAdPageCell.self, forCellReuseIdentifier: "HomeTwoAdPageCell")
        tableView.register(HomeThreeAdPageCell.self, forCellReuseIdentifier: "HomeThreeAdPageCell")
        tableView.register(HomeSecKillRecommCell.self, forCellReuseIdentifier: "HomeSecKillRecommCell")
        tableView.register(HomeSingleProductIntroCell.self, forCellReuseIdentifier: "HomeSingleProductIntroCell")
        tableView.mj_header = self?.mjheader
        tableView.mj_footer = self?.mjfooter
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0//WH(213)
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
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
        footer!.mj_h = WH(67)
        return footer!
    }()
    //    fileprivate lazy var leftRecognizer:UISwipeGestureRecognizer =  {
    //        let left = UISwipeGestureRecognizer()
    //        left.direction = .left
    //       // left.addTarget(self, action: #selector(handleSwipeFrom(_:)))
    //        return left
    //    }()
    //    fileprivate lazy var rightRecognizer:UISwipeGestureRecognizer =  {
    //        let right = UISwipeGestureRecognizer()
    //        right.direction = .right
    //       // right.addTarget(self, action: #selector(handleSwipeFrom(_:)))
    //        return right
    //    }()
    //MARK: Life Style
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = bg2
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        
        //        self.addSubview(emptyView)
        //        emptyView.snp.makeConstraints { (make) in
        //            make.edges.equalTo(self)
        //        }
        
        self.addSubview(topButton)
        topButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right)
            //make.height.width.equalTo(WH(60))
            make.bottom.equalTo(self.snp.bottom).offset(-WH(14))
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
        if let isMore = model?.hasNextPage {
            if isMore {
                tableView.mj_footer.endRefreshing()
            } else {
                tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        }
    }
    func configData(_ viewModel:NewHomeViewModel) {
        self.dataSource.removeAll()
        //        self.dataSource = viewModel.currentModel.dataSource
        //        self.model =  viewModel.currentModel
        //        hasNextData = viewModel.currentModel.hasNextPage
        //        if viewModel.currentModel.hasNextPage == true {
        //            mjfooter.resetNoMoreData()
        //        }else {
        //            mjfooter.endRefreshingWithNoMoreData()
        //        }
        self.tableView.reloadData()
    }
    //从购物车回来后刷新数据
    func refreshDataBackFromCar()  {
        if dataSource.count > 0 {
            self.resetHomeProductCartNum()
            for product in self.dataSource {
                for cartModel  in (FKYCartModel.shareInstance()?.mixProductArr)! {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        switch product.cellType{
                        //普品
                        case .HomeCellTypeCommonProduct? :
                            let cellModel:HomeCommonProductCellModel = product as! HomeCommonProductCellModel
                            let model: HomeCommonProductModel = cellModel.model!
                            if  cartOfInfoModel.spuCode != nil && cartOfInfoModel.fromWhere != nil && cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == model.spuCode && cartOfInfoModel.supplyId.intValue ==  model.supplyId && cartOfInfoModel.fromWhere.intValue != 2 {
                                model.carOfCount = cartOfInfoModel.buyNum.intValue
                                model.carId = cartOfInfoModel.cartId.intValue
                                continue
                            }
                            break
                        //单品秒杀
                        case .HomeCellTypeSingleSecKill? :
                            let cellModel:HomeSingleSecKillCellModel = product as! HomeSingleSecKillCellModel
                            if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                                let model = list[0]
                                if  cartOfInfoModel.spuCode != nil && model.productCode != nil && cartOfInfoModel.supplyId != nil && model.supplyId != nil && cartOfInfoModel.fromWhere != nil  && cartOfInfoModel.spuCode as String == model.productCode! && cartOfInfoModel.supplyId.intValue ==  model.supplyId! && cartOfInfoModel.fromWhere.intValue != 2 {
                                    model.carOfCount = cartOfInfoModel.buyNum.intValue
                                    model.carId = cartOfInfoModel.cartId.intValue
                                    break
                                }
                            }
                            break
                        default:
                            break
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    //重置购物车数据
    func  resetHomeProductCartNum(){
        for product in self.dataSource {
            switch product.cellType{
            //普品
            case .HomeCellTypeCommonProduct? :
                let cellModel:HomeCommonProductCellModel = product as! HomeCommonProductCellModel
                let model: HomeCommonProductModel = cellModel.model!
                model.carOfCount = 0
                model.carId = 0
                break
            //一起购
            case .HomeCellTypeYQG? :
                let cellModel:HomeYQGCellModel = product as! HomeYQGCellModel
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    let model = list[0]
                    model.carOfCount = 0
                    model.carId = 0
                }
                break
            //秒杀
            case .HomeCellTypeSecKill? :
                let cellModel:HomeSecKillCellModel = product as! HomeSecKillCellModel
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    let model = list[0]
                    model.carOfCount = 0
                    model.carId = 0
                }
                break
            //毛利  一起返等
            case .HomeCellTypeOther? :
                let cellModel:HomeOtherProductCellModel = product as! HomeOtherProductCellModel
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    let model = list[0]
                    model.carOfCount = 0
                    model.carId = 0
                }
                break
            default:
                break
            }
        }
    }
    //更新滚动最底部 滑动之后 更新
    func updateContentOfsetByScrolll(){
        tableView.setContentOffset(CGPoint.init(x: 0, y: tableView.contentOffset.y - MJRefreshFooterHeight - WH(20)), animated: false)
    }
    //重新设置contentoffy
    func updateContentOffY(){
        self.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        self.isScrollViewBegin = false
    }
    //重置滑动位置后重置一些参数
    func resetTableViewOffsetY(){
        self.isScrollDown = true
        self.lastOffsetY = 0
        self.topButton.isHidden = true
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
}
extension HomeOftenBuyTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData =  self.dataSource[indexPath.row]
        switch cellData.cellType{
        //普品
        case .HomeCellTypeCommonProduct? :
            let cellModel:HomeCommonProductCellModel = cellData as! HomeCommonProductCellModel
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInfoListCell", for: indexPath) as!   ProductInfoListCell
            cell.selectionStyle = .none
            cellModel.model!.showSequence = indexPath.row + 1 //埋点用
            cell.configCell(cellModel.model!)
            
            //更新加车数量
            cell.addUpdateProductNum = { [weak self] in
                if let strongSelf = self {
                    if let block = strongSelf.updateStepCountBlock {
                        block(cellModel,0,indexPath.section,1)
                    }
                }
            }
            //跳转到聚宝盆商家专区
            cell.clickJBPContentArea = { [weak self] in
                if let strongSelf = self {
                    strongSelf.addLookJBPShopBI_Record(cellModel.model!,indexPath.row + 1)
                    FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                        let controller = vc as! FKYNewShopItemViewController
                        controller.shopId = cellModel.model!.shopCode ?? ""
                        controller.shopType = "1"
                    }, isModal: false)
                }
            }
            //到货通知
            cell.productArriveNotice = {
                FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                    let controller = vc as! ArrivalProductNoticeVC
                    controller.productId = cellModel.model!.spuCode
                    controller.venderId = "\(cellModel.model!.supplyId)"
                    controller.productUnit = cellModel.model!.packageUnit
                }, isModal: false)
            }
            //登录
            cell.loginClosure = {
                FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            }
            // 商详
            cell.touchItem = {
                self.addLookDetailBI_Record(cellModel.model!,indexPath.row + 1)
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = cellModel.model!.spuCode
                    v.vendorId = "\(cellModel.model!.supplyId)"
                    v.updateCarNum = { (carId ,num) in
                        if let count = num {
                            cellModel.model!.carOfCount = count.intValue
                        }
                        if let getId = carId {
                            cellModel.model!.carId = getId.intValue
                        }
                    }
                }, isModal: false)
            }
            return cell
        case .HomeCellTypeBanner? :
            //banner
            let cellModel:HomeBannerCellModel = cellData as! HomeBannerCellModel
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeBannerListCell", for: indexPath) as!   HomeBannerListCell
            cell.selectionStyle = .none
            cell.configContent(cellModel.model!)
            return cell
        case .HomeCellTypeAD? :   //一栏广告
            let cellModel:HomeADCellModel = cellData as! HomeADCellModel
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOneAdPageCell", for: indexPath) as!  HomeOneAdPageCell
            cell.configCell(cellModel.model!)
            weak var weakSelf = self
            cell.checkAdBlock = { (typeIndex) in
                weakSelf?.addBIRecordForADCheckMore(cellModel.model!,typeIndex)
                if let clouser = weakSelf?.callback {
                    let action = HomeTemplateAction()
                    action.actionType = .category_home_ad_clickItem
                    action.needRecord = false
                    if let adList = cellModel.model!.iconImgDTOList,adList.count > typeIndex{
                        action.actionParams = [HomeString.ACTION_KEY: adList[typeIndex] ]
                    }
                    clouser(action)
                }
            }
            return cell
        case .HomeCellTypeTwoAD? :   //二栏广告
            let cellModel:HomeTwoADCellModel = cellData as! HomeTwoADCellModel
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTwoAdPageCell", for: indexPath) as!  HomeTwoAdPageCell
            cell.configCell(cellModel.model!)
            weak var weakSelf = self
            cell.checkAdBlock = { (typeIndex) in
                weakSelf?.addBIRecordForADCheckMore(cellModel.model!,typeIndex)
                if let clouser = weakSelf?.callback {
                    let action = HomeTemplateAction()
                    action.actionType = .category_home_ad_clickItem
                    action.needRecord = false
                    if let adList = cellModel.model!.iconImgDTOList,adList.count > typeIndex{
                        action.actionParams = [HomeString.ACTION_KEY: adList[typeIndex] ]
                    }
                    clouser(action)
                }
            }
            return cell
        case .HomeCellTypeThreeAD? : //三栏广告
            let cellModel:HomeThreeADCellModel = cellData as! HomeThreeADCellModel
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeThreeAdPageCell", for: indexPath) as!   HomeThreeAdPageCell
            weak var weakSelf = self
            cell.checkAdBlock = { (typeIndex) in
                weakSelf?.addBIRecordForADCheckMore(cellModel.model!,typeIndex)
                if let clouser = weakSelf?.callback {
                    let action = HomeTemplateAction()
                    action.actionType = .category_home_ad_clickItem
                    action.needRecord = false
                    if let adList = cellModel.model!.iconImgDTOList,adList.count > typeIndex{
                        action.actionParams = [HomeString.ACTION_KEY: adList[typeIndex] ]
                    }
                    clouser(action)
                }
            }
            cell.configCell(cellModel.model!)
            return cell
        case .HomeCellTypeNotice? : //广播
            let cellModel:HomeNoticeCellModel = cellData as! HomeNoticeCellModel
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomePublicNoticeCell", for: indexPath) as!   HomePublicNoticeCell
            cell.configCell(notice: cellModel.model!)
            return cell
        case .HomeCellTypeNavFunc? : //导航按钮
            let cellModel:HomeNavFucCellModel = cellData as! HomeNavFucCellModel
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFucListCell", for: indexPath) as!   HomeFucListCell
            cell.selectionStyle = .none
            cell.configContent(cellModel.model!)
            return cell
        case  .HomeCellTypeSingleSecKill? ://单品秒杀
            let cellModel:HomeSingleSecKillCellModel = cellData as! HomeSingleSecKillCellModel
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSingleProductIntroCell", for: indexPath) as!   HomeSingleProductIntroCell
            cell.selectionStyle = .none
            cell.configCell(cellModel.model!)
            //更新加车数量
            weak var weakSelf = self
            cell.updateAddProductNum = { (count,typeIndex) in
                if let block = weakSelf?.updateStepCountBlock {
                    block(cellModel,count,indexPath.section,typeIndex)
                }
            }
            cell.toastAddProductNum = { msg in
                if let block = weakSelf?.toastBlock {
                    block(msg)
                }
            }
            // 商详
            cell.touchItem = {
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    let productItem = list[0]
                    self.addBIRecordForCheckDetail(productItem,cellModel.model!,.HomeCellTypeSingleSecKill)
                    FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                        let v = vc as! FKY_ProdutionDetail
                        v.productionId = productItem.productCode
                        v.vendorId = "\(productItem.supplyId ?? 0)"
                        v.updateCarNum = { (carId ,num) in
                            if let count = num {
                                productItem.carOfCount = count.intValue
                            }
                            if let getId = carId {
                                productItem.carId = getId.intValue
                            }
                        }
                    }, isModal: false)
                }
                
            }
            //查看活动
            cell.moreCallback = {
                if let list = cellModel.model!.floorProductDtos, list.count > 0 {
                    let productItem = list[0]
                    self.addBIRecordForCheckMore(productItem,cellModel.model!,.HomeCellTypeSingleSecKill)
                }
                if let clouser = weakSelf?.callback {
                    let action = HomeTemplateAction()
                    action.actionType = .secondKill016_clickMore
                    action.needRecord = false
                    action.actionParams = [HomeString.ACTION_KEY: cellModel.model ?? ""]
                    clouser(action)
                }
            }
            return cell
        //秒杀/一起购系列/品牌
//        case .HomeCellTypeSecKill?:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSecKillRecommCell", for: indexPath) as!   HomeSecKillRecommCell
//
//            cell.configHomePromotionCell(cellData)
//            return cell
        case .HomeCellTypeSecKill?, .HomeCellTypeYQG? ,.HomeCellTypeBrand? :
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomePromotionStyleCell", for: indexPath) as!   HomePromotionStyleCell
            cell.configHomePromotionCell(cellData)
            return cell
        //毛利  一起返等
        case .HomeCellTypeOther? :
            let cellModel:HomeOtherProductCellModel = cellData as! HomeOtherProductCellModel
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomePromotionNewTableViewCell", for: indexPath) as!   HomePromotionNewTableViewCell
            cell.configPromotionNewTableViewData(cellModel.model)
            return cell
        default:
            return UITableViewCell.init()
        }
    }
}

extension HomeOftenBuyTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellData =  self.dataSource[indexPath.row]
        
        switch cellData.cellType{
        //普品
        case .HomeCellTypeCommonProduct? :
            let cellModel:HomeCommonProductCellModel = cellData as! HomeCommonProductCellModel
            if cellModel.model != nil{
                //                let cellHeight = cellHeightManager.getContentCellHeight(cellModel.model!.spuCode ?? "","\(cellModel.model!.supplyId ?? 0)","FKY")
                //                if  cellHeight == 0{
                let conutCellHeight = ProductInfoListCell.getCellContentHeight(cellModel.model!)
                // cellHeightManager.addContentCellHeight(cellModel.model!.spuCode ?? "","\(cellModel.model!.supplyId ?? 0)","FKY", conutCellHeight)
                return conutCellHeight
                //                }else{
                //                    return cellHeight!
                //                }
            }
            return 0
            
        case .HomeCellTypeBanner? :
            //banner
            return (SCREEN_WIDTH - 20)*110/355.0
        case .HomeCellTypeAD? :   //一栏广告
            return WH(97)
        case .HomeCellTypeTwoAD? :   //二栏广告
            return WH(98)
        case .HomeCellTypeThreeAD? : //三栏广告
            return WH(123)
        case .HomeCellTypeNotice? : //广播
            return WH(46)
        case .HomeCellTypeNavFunc? : //导航按钮
            let cellModel:HomeNavFucCellModel = cellData as! HomeNavFucCellModel
            return HomeFucListCell.getHomeFucListeCellHeight(cellModel)
        case .HomeCellTypeSingleSecKill? ://单品秒杀
            return (SCREEN_WIDTH)*121/375.0 + WH(10)
            
        //秒杀//一起购
        case .HomeCellTypeSecKill?:
            return  WH(150)
        case .HomeCellTypeSecKill?, .HomeCellTypeYQG? ,.HomeCellTypeBrand? :
            return  HomePromotionStyleCell.getPromotionStyleCellHeight(cellData)
        //毛利  一起返等
        case .HomeCellTypeOther? :
            let cellModel:HomeOtherProductCellModel = cellData as! HomeOtherProductCellModel
            return  HomePromotionNewTableViewCell.getPromotionNewTableViewHeight(cellModel.model)
        default:
            return 0.0
        }
    }
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        //  if indexPath.row >= 9{
    //        let cellData =  self.dataSource[indexPath.row ]
    //        switch cellData.cellType{
    //        //普品
    //        case .HomeCellTypeCommonProduct? :
    //            let cellModel:HomeCommonProductCellModel = cellData as! HomeCommonProductCellModel
    //            self.addBIRecordForProductExposure(cellModel.model as Any,cellData.cellType!)
    //            break
    //        case .HomeCellTypeAD? :   //一栏广告
    //            let cellModel:HomeADCellModel = cellData as! HomeADCellModel
    //            self.addBIRecordForProductExposure(cellModel.model as Any,cellData.cellType!)
    //             break
    //        case .HomeCellTypeTwoAD? :   //二栏广告
    //             let cellModel:HomeTwoADCellModel = cellData as! HomeTwoADCellModel
    //             self.addBIRecordForProductExposure(cellModel.model as Any,cellData.cellType!)
    //             break
    //        case .HomeCellTypeThreeAD? : //三栏广告
    //            let cellModel:HomeThreeADCellModel = cellData as! HomeThreeADCellModel
    //             self.addBIRecordForProductExposure(cellModel.model as Any,cellData.cellType!)
    //             break
    //        case .HomeCellTypeBanner? :
    //            break
    //        case .HomeCellTypeNotice? : //广播
    //             //let cellModel:HomeNoticeCellModel = cellData as! HomeNoticeCellModel
    //             break
    //        case .HomeCellTypeNavFunc? : //导航按钮
    //            // let cellModel:HomeNavFucCellModel = cellData as! HomeNavFucCellModel
    //             break
    //        case .HomeCellTypeSingleSecKill? ://单品秒杀
    //             let cellModel:HomeSingleSecKillCellModel = cellData as! HomeSingleSecKillCellModel
    //              self.addBIRecordForProductExposure(cellModel.model as Any,cellData.cellType!)
    //             break
    //        //秒杀/一起购系列/品牌
    //        case .HomeCellTypeBrand? :
    //            let cellModel: HomeBrandCellModel  = cellData as! HomeBrandCellModel
    //            self.addBIRecordForProductExposure(cellModel.model as Any,cellData.cellType!)
    //             break
    ////        //秒杀
    //        case .HomeCellTypeSecKill? :
    //            let cellModel:HomeSecKillCellModel = cellData as! HomeSecKillCellModel
    //            self.addBIRecordForProductExposure(cellModel.model as Any,cellData.cellType!)
    //            break
    //        //一起购
    //        case .HomeCellTypeYQG? :
    //            let cellModel:HomeYQGCellModel = cellData as! HomeYQGCellModel
    //            self.addBIRecordForProductExposure(cellModel.model as Any,cellData.cellType!)
    //            break
    //        //毛利  一起返等
    //        case .HomeCellTypeOther? :
    //            let cellModel:HomeOtherProductCellModel = cellData as! HomeOtherProductCellModel
    //            self.addBIRecordForProductExposure(cellModel.model as Any,cellData.cellType!)
    //            break
    //        default:
    //            break
    //        }
    //        //  }
    //    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeOftenBuyTableView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            if tableView.contentOffset.y > SCREEN_HEIGHT{
                self.topButton.isHidden = false
            }else{
                self.topButton.isHidden = true
            }
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
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScrollViewBegin = true
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.isScrollViewBegin = true
    }
}

//埋点
extension HomeOftenBuyTableView{
    //普通加车埋点
    func addCarBI_Record(_ product: HomeCommonProductModel) {
        let itemContent = "\(product.supplyId)|\(product.spuCode)"
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : product.pm_pmtn_type! as AnyObject]
        switch self.type {
        case .oftenBuy?: // 常买
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: "常购清单", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue, itemPosition: "\(product.showSequence )", itemName: "加车", itemContent: itemContent, itemTitle: product.sourceFrom ?? "", extendParams: extendParams, viewController: CurrentViewController.shared.item)
            break
        case .hotSale?: // 热销
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: "3", floorName: "当地热销", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue, itemPosition: "\(product.showSequence )", itemName: "加车", itemContent: itemContent, itemTitle: product.sourceFrom ?? "", extendParams: extendParams, viewController: CurrentViewController.shared.item)
            break
        default:
            break
        }
    }
    //查看聚宝盆埋点
    func addLookJBPShopBI_Record(_ product: HomeCommonProductModel,_ index:Int) {
        let itemContent = "\(product.supplyId)|\(product.spuCode)"
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : product.pm_pmtn_type! as AnyObject]
        switch self.type {
        case .oftenBuy?: // 常买
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: "常购清单", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I1012", itemPosition: "\(index)", itemName: "点进JBP专区", itemContent: itemContent, itemTitle: product.sourceFrom ?? "", extendParams: extendParams, viewController: CurrentViewController.shared.item)
            break
        case .hotSale?: // 热销
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: "3", floorName: "当地热销", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I1012", itemPosition: "\(index)", itemName: "点进JBP专区", itemContent: itemContent, itemTitle: product.sourceFrom ?? "", extendParams: extendParams, viewController: CurrentViewController.shared.item)
            break
        default:
            break
        }
    }
    
    //普通查看商详埋点
    func addLookDetailBI_Record(_ product: HomeCommonProductModel,_ index:Int) {
        let itemContent = "\(product.supplyId)|\(product.spuCode)"
        let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : product.pm_pmtn_type! as AnyObject]
        switch self.type {
        case .oftenBuy?: // 常买
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: "常购清单", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_ACTION_COMMON_ITEMDETAIL.rawValue, itemPosition: "\(index)", itemName: "点进商详", itemContent: itemContent, itemTitle: product.sourceFrom ?? "", extendParams: extendParams, viewController: CurrentViewController.shared.item)
            break
        case .hotSale?: // 热销
            FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_COMMON_PRODUCT_FLOOR.rawValue, floorPosition: "3", floorName: "当地热销", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_ACTION_COMMON_ITEMDETAIL.rawValue, itemPosition: "\(index)", itemName: "点进商详", itemContent: itemContent, itemTitle: product.sourceFrom ?? "", extendParams: extendParams, viewController: CurrentViewController.shared.item)
            break
        default:
            break
        }
    }
    // 活动商品 点击商详 商品位置埋点
    fileprivate func addBIRecordForCheckDetail(_ product: HomeRecommendProductItemModel, _ model:HomeSecdKillProductModel,_ pronationType:HomeCellType) {
        let itemContent = "\(product.supplyId ?? 0)|\(product.productCode ?? "0")"
        switch self.type {
        case .homeRecommend?: // 首页推荐
            //秒杀单品
            if pronationType == .HomeCellTypeSingleSecKill{
                let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : "特价" as AnyObject]
                FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_RECOMMEND_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: "运营首页", sectionId: SECTIONCODE.HOME_RECOMMEND_SECTION_CODE.rawValue, sectionPosition: "\(model.showSequence ?? 0)", sectionName: "秒杀-单品", itemId: ITEMCODE.HOME_ACTION_SINGLE_ITEMDETAIL.rawValue, itemPosition: "1", itemName: "点进商详", itemContent: itemContent, itemTitle: model.name, extendParams: extendParams, viewController: CurrentViewController.shared.item)
            }
            
            break
        default:
            break
        }
    }
    
    // 活动商品 点击更多
    // name
    fileprivate func addBIRecordForCheckMore(_ product: HomeRecommendProductItemModel, _ model:HomeSecdKillProductModel,_ pronationType:HomeCellType) {
        let itemContent = "\(product.supplyId ?? 0)|\(product.productCode ?? "0")"
        switch self.type {
        case .homeRecommend?: // 首页推荐
            //秒杀单品
            if pronationType == .HomeCellTypeSingleSecKill{
                let extendParams:[String :AnyObject] = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : "特价" as AnyObject]
                FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_RECOMMEND_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: "运营首页", sectionId: SECTIONCODE.HOME_RECOMMEND_SECTION_CODE.rawValue, sectionPosition:  "\(model.showSequence ?? 0)", sectionName: "秒杀-单品", itemId: ITEMCODE.HOME_ACTION_SINGLE_ITEMDETAIL.rawValue, itemPosition: "0", itemName: "更多", itemContent: itemContent, itemTitle: model.name, extendParams: extendParams, viewController: CurrentViewController.shared.item)
            }
            
            break
        default:
            break
        }
    }
    
    // 广告 点击
    fileprivate func addBIRecordForADCheckMore(_ model:HomeADInfoModel,_ typeIndex:Int) {
        switch self.type {
        case .homeRecommend?: // 首页推荐
            //floorStyle: Int? // 1：中通广告一行1个，2：中通广告一行2个，3：中通广告一行3个"\(model.showSequence ?? 0)"
            if let imageList = model.iconImgDTOList,imageList.count > typeIndex{
                let imgeModel = imageList[typeIndex] as HomeBrandDetailModel
                FKYAnalyticsManager.sharedInstance.BI_New_Record(FLOORID.HOME_RECOMMEND_PRODUCT_FLOOR.rawValue, floorPosition: "1", floorName: "运营首页", sectionId: SECTIONCODE.HOME_RECOMMEND_SECTION_CODE.rawValue, sectionPosition: "\(model.showSequence ?? 0)", sectionName: "中通广告", itemId: ITEMCODE.HOME_ACTION_AD_CONTENT.rawValue, itemPosition: "\(typeIndex + 1)", itemName: imgeModel.imgName, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: CurrentViewController.shared.item)
            }
            break
        default:
            break
        }
    }
}
