//
//  FKYJPPEmptyViewController.swift
//  FKY
//
//  Created by 寒山 on 2019/11/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYJPPEmptyViewController: UIViewController {
    var extendDic:[String:AnyObject]? //搜索的埋点
    var changeBudgeNumAction: ChangeBudgeNumAction?
    @objc public var shopId: String = ""  //自营店铺ID
    @objc public var keyWord: String = "" //搜搜关键字
    fileprivate var  selectIndexPath: IndexPath? //选中cell 位置
    // viewModel
    fileprivate var viewModel: FKYJBPSearchViewModel = {
        let vm = FKYJBPSearchViewModel()
        return vm
    }()
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            self?.getShopALLProductFuc()
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    //行高管理器
    fileprivate var cellHeightManager:ContentHeightManager = {
        let heightManager = ContentHeightManager()
        return heightManager
    }()
    fileprivate lazy var mainCollectView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(CommonProductItemCell.self, forCellWithReuseIdentifier: "CommonProductItemCell")
        cv.register(FKYJPBSearchEmptyHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FKYJPBSearchEmptyHeaderView")
        cv.backgroundColor = RGBColor(0xF4F4F4)
        cv.showsVerticalScrollIndicator = false
        cv.mj_footer = self.mjfooter
        cv.mj_footer.isAutomaticallyHidden = true
        if #available(iOS 11, *) {
            cv.contentInsetAdjustmentBehavior = .never
        }
        return cv
    }()
    //商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        addView.finishPoint = CGPoint(x:SCREEN_WIDTH - WH(10)-(self.parent?.NavigationBarRightImage?.frame.size.width)!/2.0,y:naviBarHeight()-WH(5)-(self.parent?.NavigationBarRightImage?.frame.size.height)!/2.0)
        //更改购物车数量
        addView.addCarSuccess = { [weak self] (isSuccess,type,productNum,productModel) in
            if let strongSelf = self {
                if isSuccess == true {
                    if type == 1 {
                        if let block = strongSelf.changeBudgeNumAction{
                            block(false)
                        }
                    }else if type == 3 {
                        if let block = strongSelf.changeBudgeNumAction{
                            block(true)
                        }
                        
                    }
                }
                strongSelf.refreshSingleCell()
            }
        }
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
            if let strongSelf = self {
                if let model = productModel as? HomeProductModel {
                    if strongSelf.selectIndexPath != nil{
                        strongSelf.addNewBI_Record(model,(strongSelf.selectIndexPath!.row + 1),2)
                    }
                    
                }
            }
        }
        return addView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //删除存储高度
        cellHeightManager.removeAllContentCellHeight()
        self.getCartNumber()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mainCollectView)
        mainCollectView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.left.right.bottom.equalTo(strongSelf.view)
            make.top.equalTo(strongSelf.view)
        }
        mainCollectView.mj_footer.endRefreshing()
        // Do any additional setup after loading the view.
    }
    //初始化数据
    func setUpData(_ shopId:String?,_ keyWord:String?){
        self.shopId = shopId ?? ""
        self.keyWord = keyWord ?? ""
        viewModel.enterpriseId = self.shopId
        viewModel.keyWord = self.keyWord
        self.mainCollectView.reloadData()
        self.getFirstPageShopProductFuc()
    }
    //刷新全部
    func refreshAllProductTableView() {
        if  self.viewModel.dataSource.isEmpty == true{
            return
        }
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            for index in 0...(strongSelf.viewModel.dataSource.count - 1) {
                let product = strongSelf.viewModel.dataSource[index]
                if FKYCartModel.shareInstance().productArr.count > 0{
                    for cartModel  in FKYCartModel.shareInstance().productArr {
                        if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                            if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.productId && cartOfInfoModel.supplyId.intValue == (product.vendorId )  {
                                product.carOfCount = cartOfInfoModel.buyNum.intValue
                                product.carId = cartOfInfoModel.cartId.intValue
                                break
                            }
                        }
                    }
                }else{
                    product.carOfCount = 0
                    product.carId = 0
                }
                
                strongSelf.mainCollectView.reloadData()
            }
        }
    }
    //加车 刷新单个cell
    func refreshSingleCell() {
        if let indexPath = self.selectIndexPath , self.viewModel.dataSource.count > indexPath.row{
            let product =  self.viewModel.dataSource[indexPath.row]
            for cartModel  in FKYCartModel.shareInstance().productArr {
                if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                    if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.productId && cartOfInfoModel.supplyId.intValue == (product.vendorId ) {
                        product.carOfCount = cartOfInfoModel.buyNum.intValue
                        product.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
            self.mainCollectView.reloadItems(at: [indexPath])
        }
    }
    func refreshDismiss() {
        if  viewModel.hasNextPage {
            mainCollectView.mj_footer.endRefreshing()
        }else{
            mainCollectView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = HomeString.SEARCH_JBP_ADD_SOURCE_TYPE
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
    
}
//MARK:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout代理
extension FKYJPPEmptyViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dataSource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = self.viewModel.dataSource[indexPath.row]
        let cellHeight = cellHeightManager.getContentCellHeight(model.productId ,"\(model.vendorId )",self.ViewControllerPageCode()!)
        if  cellHeight == 0{
            let conutCellHeight = CommonProductItemCell.getCellContentHeight(model)
            cellHeightManager.addContentCellHeight(model.productId ,"\(model.vendorId )",self.ViewControllerPageCode()!, conutCellHeight)
            return CGSize(width: SCREEN_WIDTH, height:conutCellHeight)
        }else{
            return CGSize(width: SCREEN_WIDTH, height:cellHeight)
        }
        //        let cellH = CommonProductItemCell.getContentHeight(model)
        //        return CGSize(width: SCREEN_WIDTH, height: cellH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.viewModel.dataSource.isEmpty == false{
            return CGSize(width: SCREEN_WIDTH, height: WH(104))
        }else{
            return CGSize(width: SCREEN_WIDTH, height: WH(90))
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.viewModel.dataSource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonProductItemCell", for: indexPath) as! CommonProductItemCell
        //        prdModel.indexPath = indexPath
        cell.configCell(model)
        // 更新加车数量
        cell.addUpdateProductNum = { [weak self] in
            if let strongSelf = self {
                strongSelf.selectIndexPath = indexPath
                strongSelf.popAddCarView(model)
            }
        }
        cell.productArriveNotice = {
            FKYNavigator.shared().openScheme(FKY_ArrivalProductNoticeVC.self, setProperty: { (vc) in
                let controller = vc as! ArrivalProductNoticeVC
                controller.productId = model.productId
                controller.venderId = "\(model.vendorId)"
                controller.productUnit = model.unit
            }, isModal: false)
        }
        //跳转到聚宝盆商家专区
        cell.clickJBPContentArea = { [weak self] in
            if let strongSelf = self {
                strongSelf.addNewBI_Record(model, indexPath.row + 1, 3)
                FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                    let controller = vc as! FKYNewShopItemViewController
                    controller.shopId = "\(model.vendorId)"
                    controller.shopType = "1"
                }, isModal: false)
            }
        }
        //商详
        cell.touchItem = { [weak self] in
            if let strongSelf = self {
                strongSelf.view.endEditing(false)
                strongSelf.addNewBI_Record(model, indexPath.row + 1, 1)
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKY_ProdutionDetail
                    v.productionId = model.productId
                    v.vendorId = "\(model.vendorId)"
                    v.updateCarNum = { [weak self] (carId, num) in
                        if let strongInSelf = self{
                            if let count = num {
                                model.carOfCount = count.intValue
                            }
                            if let getId = carId {
                                model.carId = getId.intValue
                            }
                        }
                    }
                }, isModal: false)
            }
        }
        
        // 登录
        cell.loginClosure = {
            FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FKYJPBSearchEmptyHeaderView", for: indexPath) as! FKYJPBSearchEmptyHeaderView
        headerView.configView(self.keyWord)
        if self.viewModel.dataSource.isEmpty == false{
            headerView.visibleTipsView(false)
        }else{
            headerView.visibleTipsView(true)
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = self.viewModel.dataSource[indexPath.row]
        self.view.endEditing(false)
        self.addNewBI_Record(product, indexPath.row + 1, 1)
        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
            let v = vc as! FKY_ProdutionDetail
            v.productionId = product.productId
            v.vendorId = "\(product.vendorId)"
            v.updateCarNum = { [weak self] (carId, num) in
                if let strongInSelf = self{
                    if let count = num {
                        product.carOfCount = count.intValue
                    }
                    if let getId = carId {
                        product.carId = getId.intValue
                    }
                }
            }
        }, isModal: false)
    }
}
// MARK: Requset Method

extension FKYJPPEmptyViewController{
    //获取全部商品
    @objc func getShopALLProductFuc(){
        showLoading()
        viewModel.getAllProductInfo(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.refreshDismiss()
            strongSelf.dismissLoading()
            if success{
                strongSelf.refreshAllProductTableView()
            } else {
                strongSelf.refreshAllProductTableView()
                // 失败
                //strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    //请求第一页商品
    @objc func getFirstPageShopProductFuc(){
        self.viewModel.currentIndex = 1
        self.viewModel.hasNextPage = true
        self.getShopALLProductFuc()
    }
    // 同步购物车商品数量
    fileprivate func getCartNumber() {
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ [weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.refreshAllProductTableView()
        }) { [weak self] (reason) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.toast(reason)
        }
    }
}
//埋点
extension FKYJPPEmptyViewController{
    func addNewBI_Record(_ product: HomeProductModel,_ itemtPosition:Int,_ type:Int) {
        var itemId : String?
        var itemName:String?
        var itemContent : String?
        if type == 1 {
            itemId = "I9998" //点击商品cell
            itemName = "点进商详"
        }else if type == 2 {
            itemId = "I9999" //加车
            itemName = "加车"
        } else{
            itemId = "I9996" //点进JBP专区
            itemName = "点进JBP专区"
        }
        
        if  product.vendorId != 0{
            itemContent = "\(product.vendorId)|\(product.productId )"
        }
        
        var extendParams:[String :AnyObject] = [:]
        extendParams["pm_price"] = product.pm_price as AnyObject?
        extendParams["storage"] = product.storage as AnyObject?
        extendParams["pm_pmtn_type"] = product.pm_pmtn_type as AnyObject?
        
        if self.extendDic != nil{
            for (key, value) in self.extendDic! {
                extendParams[key] = value
            }
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record("F9001", floorPosition: "1", floorName: "专区内搜索无结果", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: itemId, itemPosition: "\(itemtPosition)", itemName: itemName, itemContent:itemContent , itemTitle: nil, extendParams: extendParams, viewController: self)
    }
    
    
}

