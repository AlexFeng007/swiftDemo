//
//  FKYOftenBuyViewModel.swift
//  FKY
//
//  Created by 乔羽 on 2018/8/21.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import Foundation

class FKYOftenBuyViewModel {
    //
    var hotSaleModel: FKYOftenBuyModel = {
        let model = FKYOftenBuyModel()
        return model
    }()
    var oftenLookModel: FKYOftenBuyModel = {
        let model = FKYOftenBuyModel()
        return model
    }()
    var oftenBuyModel: FKYOftenBuyModel = {
        let model = FKYOftenBuyModel()
        return model
    }()
    // 每次接口请求成功后返回的实时数据model...<用于记录分页>
    var productModel: OftenBuyProductModel?
    // 三个类型的数据源
    var cityHotSale = [OftenBuyProductItemModel]()    // 热销
    var frequentlyBuy = [OftenBuyProductItemModel]()  // 常买
    var frequentlyView = [OftenBuyProductItemModel]() // 常看
    var sectionTitle = [String]()    // 抬头名字
    var sectionType = [FKYOftenBuyType]()    // 状态
    var currentIndex: Int = 0
    var titleArr :[FKYOftenTitleModel] = []//首页常购清单标题
    
    var currentType:FKYOftenBuyType?
    var currentModel: FKYOftenBuyModel {
        get {
            switch currentType {
            case .hotSale?:
                return self.hotSaleModel
            case .oftenLook?:
                return self.oftenLookModel
            case .oftenBuy?:
                return self.oftenBuyModel
            default:
                return FKYOftenBuyModel()
            }
        }
        set {
            switch currentType {
            case .hotSale?:
                self.hotSaleModel = newValue
            case .oftenLook?:
                self.oftenLookModel = newValue
            case .oftenBuy?:
                self.oftenBuyModel = newValue
            default:
                break
            }
        }
    }
        
    fileprivate lazy var logic: FKYOftenBuyLogic = { [weak self] in
        let logic = FKYOftenBuyLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYOftenBuyLogic
        return logic!
        }()
    
    // 网络请求service...<商品列表>
    fileprivate lazy var requestService: FKYPublicNetRequestSevice = {
        let service = FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as! FKYPublicNetRequestSevice
        return service
    }()
    
    //MARK: Public Method
    
    func resetModels() {
        hotSaleModel.isFirstLoad = true
        hotSaleModel.isMore = true
        hotSaleModel.page = 1
        hotSaleModel.dataSource = []
        hotSaleModel.isNotMoreData = true
        
        oftenLookModel.isFirstLoad = true
        oftenLookModel.isMore = true
        oftenLookModel.page = 1
        oftenLookModel.dataSource = []
        oftenLookModel.isNotMoreData = true
        
        oftenBuyModel.isFirstLoad = true
        oftenBuyModel.isMore = true
        oftenBuyModel.page = 1
        oftenBuyModel.dataSource = []
        oftenBuyModel.isNotMoreData = true
        
        //刷新清空数组
        currentIndex = 0
        sectionTitle.removeAll()
        sectionType.removeAll()
        titleArr.removeAll()
        frequentlyBuy.removeAll()
        cityHotSale.removeAll()
        frequentlyView.removeAll()
    }

    func getCurrectIndex() -> (Int) {
        switch currentType {
        case .hotSale?:
            return (oftenBuyModel.isHaveData ? 1:0) + (oftenLookModel.isHaveData ? 1:0)
        case .oftenLook?:
            return oftenBuyModel.isHaveData ? 1:0
        case .oftenBuy?:
            return 0
        default:
            return 0
            // break
        }
    }
    
    func getNextIndex() -> (Int) {
        switch currentType {
        case .hotSale?:
            return (oftenBuyModel.isHaveData ? 1:0) + (oftenLookModel.isHaveData ? 1:0) + 1
        case .oftenLook?:
            return (oftenBuyModel.isHaveData ? 1:0) + 1
        case .oftenBuy?:
            return 1
        default:
            return 0
            // break
        }
    }
    
    // 从购物车回来后刷新数据
    func refreshDataBackFromCart() {
        for product in frequentlyBuy {
            for cartModel in FKYCartModel.shareInstance().productArr {
                if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                    if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode! && cartOfInfoModel.supplyId.intValue == Int(product.supplyId!) {
                        product.carOfCount = cartOfInfoModel.buyNum.intValue
                        product.carId = cartOfInfoModel.cartId.intValue
                        break
                    } else {
                        product.carOfCount = 0
                        product.carId = 0
                    }
                }
            } // for
        } // for
        
        for product in frequentlyView {
            for cartModel in FKYCartModel.shareInstance().productArr {
                if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                    if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode! && cartOfInfoModel.supplyId.intValue == Int(product.supplyId!) {
                        product.carOfCount = cartOfInfoModel.buyNum.intValue
                        product.carId = cartOfInfoModel.cartId.intValue
                        break
                    } else {
                        product.carOfCount = 0
                        product.carId = 0
                    }
                }
            } // for
        } // for
        
        for product in cityHotSale {
            for cartModel in FKYCartModel.shareInstance().productArr {
                if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                    if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode as String == product.spuCode! && cartOfInfoModel.supplyId.intValue == Int(product.supplyId!) {
                        product.carOfCount = cartOfInfoModel.buyNum.intValue
                        product.carId = cartOfInfoModel.cartId.intValue
                        break
                    } else {
                        product.carOfCount = 0
                        product.carId = 0
                    }
                }
            } // for
        } // for
    }
    
    // 数据处理
    fileprivate func handleProductModel() {
        if self.titleArr.count != 0 {
            self.resetModels()
        }
        guard let model = productModel else {
            return
        }
        if let buy = model.frequentlyBuy, let list = buy.list, list.count > 0 {
            frequentlyBuy.append(contentsOf: list)
        }
        
        if let see = model.frequentlyView, let list = see.list, list.count > 0 {
            frequentlyView.append(contentsOf: list)
        }
        
        if let hotsale = model.cityHotSale, let list = hotsale.list, list.count > 0 {
            cityHotSale.append(contentsOf: list)
        }
        self.dealAllData()
    }
    
    // 请求常购清单列表数据
    func requestProductList(success:@escaping (OftenBuyProductModel?)->(), fail:@escaping (String?)->()) {
        // 页索引...<默认为刷新>
        let pageId = 1
        // 每页条数
        let pageSize = 10 //**需与分页模型每页数量保持一致
        // 企业id
        let enterpriseId = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        // 入参
        let dic: [String: Any] = ["pageId": pageId, "pageSize": pageSize, "enterpriseId":enterpriseId ?? ""]
        // 请求
        _ = requestService.getOftenBuyProductListBlock(withParam: dic, completionBlock: {(responseObject, anError) in
            if anError == nil {
                // 成功
                if let response = responseObject as? NSDictionary {
                    let model: OftenBuyProductModel = response.mapToObject(OftenBuyProductModel.self)
                    // 有数据...<请求成功，且有数据，才会保存>
                    self.productModel = model
                    self.handleProductModel()
                    self.refreshDataBackFromCart()
                    success(model)
                }
                else {
                    // 无数据
                    success(nil)
                }
            }
            else {
                // 失败
                var errMsg = "请求失败"
                if let err = anError {
                    let e = err as NSError
                    let msg: String? = e.userInfo[NSLocalizedDescriptionKey] as? String
                    if let msg = msg, msg.isEmpty == false {
                        errMsg = msg
                    }
                    if e.code == 2 {
                        // token过期
                        errMsg = "用户登录过期，请重新手动登录"
                    }
                }
                fail(errMsg)
            }
        })
    }
    
    func getData(callback: @escaping ()->(), fail: @escaping (_ reason : String)->()) { // /home/recommend/frequentlyBuy
        // 入参
        let dic: [String: Any] = [
            "pageId":currentModel.page,
            "pageSize":currentModel.pageSize,
            "enterpriseId":FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid() // 企业id
        ]
        
        switch currentType {
        case .hotSale?: // 热销榜
            logic.fetchCityHotSaleViewData(withParams: dic) { (response, error) in
                self.dealData(response: response, error: error, callback: callback, fail: fail)
            }
        case .oftenLook?: // 常看
            logic.fetchFrequentlyViewData(withParams: dic) { (response, error) in
                self.dealData(response: response, error: error, callback: callback, fail: fail)
            }
        case .oftenBuy?: // 常买
            logic.fetchFrequentlyBuyData(withParams: dic) { (response, error) in
                self.dealData(response: response, error: error, callback: callback, fail: fail)
            }
        default:
            fail("暂无数据")
            break
        }
    }
    
    func dealData(response: Any?, error: Error?, callback: @escaping ()->(), fail: @escaping (_ reason : String)->()) {
        var dataSource: Array<OftenBuyProductItemModel> = []
        if currentModel.page != 1 && currentModel.dataSource.count > 0 {
            dataSource = currentModel.dataSource
        } else {
            dataSource = []
        }
        
        var tip = "访问失败"
        if let err = error {
            let e = err as NSError
            let code: NSString? = e.userInfo[HJErrorCodeKey] as? NSString
            if code != nil {
                tip = tip + " (" + (code! as String) + ")"
            }
            fail(tip)
        } else {
            tip = "暂无数据"
            guard let data = response as? NSDictionary else {
                self.currentModel.isMore = false
                fail(tip)
                return
            }
            if let list = data["list"] as? NSArray {
                // 有数据
                let datas = list
                let items = datas.mapToObjectArray(OftenBuyProductItemModel.self)!
                dataSource.append(contentsOf: items)
                // < self.currentModel.pageSize
                if items.count < self.currentModel.pageSize {
                    self.currentModel.isMore = false
                } else {
                    self.currentModel.isMore = true
                }
                
                if items.count < self.currentModel.pageSize {
                    self.currentModel.isNotMoreData = false
                }else {
                    self.currentModel.isNotMoreData = true
                }
                
                self.currentModel.dataSource = dataSource
                callback()
            } else {
                // 无数据
                self.currentModel.isMore = false
                fail(tip)
            }
        }
    }
    
    func dealAllData() {
        if frequentlyBuy.count > 0 {
            oftenBuyModel.isFirstLoad = false
            oftenBuyModel.isHaveData = true
            oftenBuyModel.page = 2
            oftenBuyModel.dataSource = frequentlyBuy
            sectionTitle.append((self.productModel?.frequentlyBuy?.floorName)!)
            sectionType.append(.oftenBuy)
            
            //首页常购清单判断数据
            if frequentlyBuy.count < currentModel.pageSize {
                oftenBuyModel.isMore = false
                oftenBuyModel.isNotMoreData = false
            }else {
                oftenBuyModel.isMore = true
                oftenBuyModel.isNotMoreData = true
            }
            let titleModel = FKYOftenTitleModel()
            titleModel.title = self.productModel?.frequentlyBuy?.floorName
            titleModel.type = .oftenBuy
            titleArr.append(titleModel)
        } else {
            oftenBuyModel.isFirstLoad = false
            oftenBuyModel.isHaveData = false
            oftenBuyModel.page = 2
        }
        
        if frequentlyView.count > 0 {
            oftenLookModel.isFirstLoad = false
            oftenLookModel.isHaveData = true
            oftenLookModel.page = 2
            oftenLookModel.dataSource = frequentlyView
            sectionTitle.append((self.productModel?.frequentlyView?.floorName)!)
            sectionType.append(.oftenLook)
            
            //首页常购清单判断数据
            if frequentlyView.count < currentModel.pageSize {
                oftenLookModel.isMore = false
                oftenLookModel.isNotMoreData = false
            }else {
                oftenLookModel.isMore = true
                oftenLookModel.isNotMoreData = true
            }
            let titleModel = FKYOftenTitleModel()
            titleModel.title = self.productModel?.frequentlyView?.floorName
            titleModel.type = .oftenLook
            titleArr.append(titleModel)
            
        } else {
            oftenLookModel.isFirstLoad = false
            oftenLookModel.isHaveData = false
            oftenLookModel.page = 2
        }
        
        if cityHotSale.count > 0 {
            hotSaleModel.isFirstLoad = false
            hotSaleModel.page = 2
            hotSaleModel.isHaveData = true
            hotSaleModel.dataSource = cityHotSale
            var  floorName = (self.productModel?.cityHotSale?.floorName)!
            if floorName.count > 8{
                let floorIndex = floorName.index(floorName.startIndex, offsetBy:5)
                let lastIndex = floorName.index(floorName.startIndex, offsetBy:floorName.count - 3)
                let lastResult = floorName.substring(from: lastIndex)
                floorName = floorName.substring(to: floorIndex) + "..." + lastResult
            }
            sectionTitle.append(floorName)
            sectionType.append(.hotSale)
            
            //首页常购清单判断数据
            if cityHotSale.count < currentModel.pageSize {
                hotSaleModel.isMore = false
                hotSaleModel.isNotMoreData = false
            }else {
                hotSaleModel.isMore = true
                hotSaleModel.isNotMoreData = true
            }
            let titleModel = FKYOftenTitleModel()
            titleModel.title = floorName
            titleModel.type = .hotSale
            titleArr.append(titleModel)
        } else {
            hotSaleModel.isFirstLoad = false
            hotSaleModel.isHaveData = false
            hotSaleModel.page = 2
        }

        //有数据的时候，初始化当前显示的类型
        if titleArr.count > 0 {
            let titleModel = titleArr[0]
            self.currentType = titleModel.type
        }
    }
    
    //重置isFirstLoad属性（首页常购清单使用方法）
    func resetIsFirstLoad() {
        oftenBuyModel.isFirstLoad = true
        oftenLookModel.isFirstLoad = true
        hotSaleModel.isFirstLoad = true
        self.currentModel.isFirstLoad = false
    }
}

