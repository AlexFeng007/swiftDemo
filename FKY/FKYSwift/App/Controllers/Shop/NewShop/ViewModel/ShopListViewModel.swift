//
//  ShopListVarietiesViewModel.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/26.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  品种汇

class ShopListVarietiesViewModel: ShopListViewModelInterface {
    
    // MARK: - properties
    fileprivate var pageId = 1
    fileprivate var pageSize = 1
    fileprivate var logic: ShopListLogic?
    fileprivate var floorIndexMap = [ShopListTemplateType: String]()
    
    /// 初始化配置
    internal var shouldAutoLoading: Bool? = true
    internal var didSelectCity: Bool? = false
    internal var floors: [ShopListContainerProtocol & ShopListModelInterface] = [ShopListContainerProtocol & ShopListModelInterface]() {
        didSet {
            DispatchQueue.global().async {
                for (index, value) in self.floors.enumerated() {
                    if let templateModel = value as? ShopListTemplateModel {
                        self.floorIndexMap[templateModel.type] = "\(index+1)"
                    }
                }
            }
        }
    }
    
    internal var preLoadingRowFlag: Int? {
        get {
            return floors.count - pageSize
        }
    }
    
    internal var hasNextPage: Bool? {
        get {
            return pageId < pageSize
        }
    }
    
    // 当前是否正在进行刷新操作
    internal var isRefresh: Bool = false
    
    var indexPathSelect: IndexPath?
    
    fileprivate var cartService: FKYCartService = {
        let service = FKYCartService()
        service.editing = false
        return service
    }()
    
    // MARK: - life cycle
    init() {
        logic = ShopListLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? ShopListLogic
    }
}

extension ShopListVarietiesViewModel {
    func floorPosition(withTemplateType type: ShopListTemplateType) -> String {
        return floorIndexMap[type] ?? "0"
    }
    
    func rowModel(atIndexPath indexPath: IndexPath) -> ShopListModelInterface {
        guard floors.count > indexPath.section else {
            return HomeMarginModel()
        }
        let floorModel: ShopListContainerProtocol & ShopListModelInterface = floors[indexPath.section]
        let rowModel: ShopListModelInterface? = floorModel.childShopListFloorModel(atIndex: indexPath.row)
        return rowModel ?? HomeMarginModel()
    }
    
    // 获取用户站点
    func fetchUserLocation(finishedCallback: @escaping (String?) -> ()) {
        if FKYLoginAPI.loginStatus() == .loginComplete {
            let userModel = FKYLoginService.currentUser()
            if userModel?.substationName != nil, didSelectCity == false {
                let m = FKYLocationModel()
                m?.substationCode = userModel?.substationCode.toNSNumber()
                m?.substationName = userModel?.substationName
                m?.isCommon = 0
                m?.showIndex = 1
                FKYLocationService().setCurrentLocation(m)
                finishedCallback(m?.substationName)
            } else {
                finishedCallback(FKYLocationService().currentLocationName())
            }
        } else {
            var stationname = "默认"
            if FKYLocationService().currentLoaction == nil {
                let model = FKYLocationModel.default()
                stationname = (model?.substationName)!
            } else {
                stationname = FKYLocationService().currentLocationName()
            }
            finishedCallback(stationname)
        }
    }
    
    // 读缓存
    func loadCacheData(finishedCallback: @escaping () -> ()) {
        logic?.fetchShopListTemplateCacheData({ [weak self] (templates, pageId, pageSize) in
            // 无缓存
            guard templates != nil else {
                finishedCallback()
                return
            }
            // 有缓存
            self?.pageId = pageId
            self?.pageSize = pageSize
            self?.floors = templates as! [ShopListContainerProtocol & ShopListModelInterface]
            finishedCallback()
        })
    }
    
    // 请求首页的第1页数据
    func loadDataBinding(finishedCallback : @escaping (_ message: String?, _ success: Bool) -> ()) {
        pageId = 1
        pageSize = 1
        isRefresh = true
        logic?.fetchShopListTemplateData(withPage: 1) { [weak self] (templates, pageId, pageSize, message) in
            self?.shouldAutoLoading = true
            self?.isRefresh = false
            // 接口失败
            guard templates != nil else {
                finishedCallback(message, false)
                return
            }
            // 接口成功
            self?.pageId = 1
            self?.pageSize = pageSize
            self?.floors = templates as! [ShopListContainerProtocol & ShopListModelInterface]
            self?.refreshDataBackFromCart()
            finishedCallback(nil, true)
        }
    }
    
    // 请求首页的非第1页数据
    func loadNextPageBinding(finishedCallback : @escaping (_ message: String?,  _ success: Bool) -> ()) {
        guard hasNextPage! == true else {
            // 无更多数据，不需要再继续请求下一页的接口，直接返回
            finishedCallback(nil, false)
            return
        }
        guard isRefresh == false else {
            // 用户已开始下拉刷新，不需要再继续请求下一页的接口，直接返回
            finishedCallback(nil, false)
            return
        }
        logic?.fetchShopListTemplateData(withPage: (pageId + 1)) { [weak self] (templates, pageId, pageSize, message) in
            self?.shouldAutoLoading = true
            // 接口失败
            guard templates != nil else {
                finishedCallback(message, false)
                return
            }
            // 重复请求
            guard pageId != self?.pageId else {
                finishedCallback(nil, false)
                return
            }
            // 加载下一页（耗时可能较长）时，用户手动刷新（耗时可能较短），之前老的无用请求没有cancel，可能导致数据源混乱
            guard self?.isRefresh == false else {
                finishedCallback(nil, false)
                return
            }
            // 接口成功
            self?.pageId = pageId
            self?.pageSize = pageSize
            let arr: [ShopListContainerProtocol & ShopListModelInterface] = templates as! [ShopListContainerProtocol & ShopListModelInterface]
            self?.floors = (self?.floors)! + arr
            self?.refreshDataBackFromCart()
            finishedCallback(nil, true)
        }
    }
    
    func refreshDataBackFromCart() {
        for value in self.floors {
            if let templateModel = value as? ShopListTemplateModel {
                
                for model in templateModel.itemList! {
                    if let product = model as? ShopListSecondKillProductItemModel {
                        for cartModel in FKYCartModel.shareInstance().productArr {
                            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                                if cartOfInfoModel.spuCode as String == product.productCode! && cartOfInfoModel.supplyId.intValue == Int(product.productSupplyId!) {
                                    product.carOfCount = cartOfInfoModel.buyNum.intValue
                                    product.carId = cartOfInfoModel.cartId.intValue
                                    break
                                } else {
                                    product.carOfCount = 0
                                    product.carId = 0
                                }
                            }
                        }
                    } else if let product = model as? ShopListProductItemModel {
                        for cartModel in FKYCartModel.shareInstance().productArr {
                            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                                if cartOfInfoModel.spuCode as String == product.productCode! && cartOfInfoModel.supplyId.intValue == Int(product.productSupplyId!) {
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
                    
                }
                
            }
        }
    }
}

extension ShopListVarietiesViewModel {
    // 数量变零，删除进货单
    func deleteShopCartItem(_ carId: String, callback:@escaping (_ success: Bool, _ msg: String?)->()) {
        cartService.deleteShopCart([carId], success: { (mutiplyPage) in
            // 成功
            callback(true, nil)
        }, failure: { (reason) in
            // 失败
            callback(false, reason)
        })
    }
    
    // 更新进货单中商品加车数量
    func updateShopCartItem(_ carId: String, count: Int, callback:@escaping (_ success: Bool, _ msg: String?)->()) {
        cartService.updateShopCart(forProduct: "\(carId)", quantity: count, allBuyNum: -1, success: { (mutiplyPage) in
            // 成功
            callback(true, nil)
        }, failure: { (reason) in
            // 失败
            callback(false, reason)
        })
    }
    
    func addCart(_ vendorId: String, _ productId: String, promotionId: String, count: Int, callback:@escaping (_ msg: String?, _ data: AnyObject?)->()) {
        var paramJson =  [String: Any]()
        var paramArray = [Any]()
        paramJson["addType"] = "1"
        
        let params = [
            "supplyId": vendorId,
            "spuCode": productId,
            "productNum": "\(count)",
            "promotionId":promotionId
        ] as [String : AnyObject]
        
        paramArray.append(params)
        paramJson["ItemList"] = paramArray
        
        logic!.fetchAddShoppingProduct(paramJson, callback: { (model, error)  in
            if error == nil {
                //数据ok
                if let statusCode = (model as AnyObject).value(forKeyPath: "statusCode"), (statusCode as! Int) != 0 {
                    // 操作失败
                    // 由于后台不愿意改别人代码，app端兼容判断取那一层message提示错误信息(statusCode==1 取内层message statusCode==2 取外层message)
                    var message : String?
                    if (statusCode as! Int) == 1 {
                        if let arr  = (model as AnyObject).value(forKeyPath: "cartResponseList") as? NSArray ,arr.count > 0 {
                            message =  (arr[0] as AnyObject).value(forKeyPath: "message") as? String
                        }
                    }else {
                        message  = (model as AnyObject).value(forKeyPath: "message") as? String
                    }
                    let data = (model as AnyObject).value(forKeyPath: "data") as AnyObject
                    callback(message ?? "加车失败", data)
                    return
                }
                // 操作成功
                if model  != nil {
                    callback("成功", nil)
                    
                    if let totalCount = (model as AnyObject).value(forKeyPath: "productsCount"){
                        FKYCartModel.shareInstance().productCount = Int(totalCount as! NSNumber)
                    }
                }
            }
            else {
                callback("加车失败", nil)
            }
        } );
    }
}
