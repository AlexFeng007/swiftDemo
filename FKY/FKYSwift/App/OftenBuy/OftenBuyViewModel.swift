//
//  OftenBuyViewModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/14.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  常购模块之ViewModel对象...<包含常购商家、 常购清单>

import UIKit

// MARK: - 常购清单
class OftenBuyViewModel: NSObject {
    // MARK: - Property
    
    // 每次接口请求成功后返回的实时数据model...<用于记录分页>
    var productModel: OftenBuyProductModel?
    // 三个类型的数据源
    var cityHotSale = [OftenBuyProductItemModel]()    // 热销
    var frequentlyBuy = [OftenBuyProductItemModel]()  // 常买
    var frequentlyView = [OftenBuyProductItemModel]() // 常看
    
    // 是否需要加载更多
    var needLoadMore = false
    
    // 加车动画相关
    var indexPathSelect: IndexPath? // 选中的商品索引model
    var imgviewSelect: UIImageView? // 选中的商品cell图片
    var rectSelect: CGRect?         // 选中的商品cell图片rect
    
    // 网络请求service...<商品列表>
    fileprivate lazy var requestService: FKYPublicNetRequestSevice = {
        let service = FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as! FKYPublicNetRequestSevice
        return service
    }()
    // 网络请求service...<购物车>
    fileprivate var cartService: FKYCartService = {
        let service = FKYCartService()
        service.editing = false
        return service
    }()
    // 网络请求service...< 店铺 >
    fileprivate var shopService: ShopItemProvider = {
        return ShopItemProvider()
    }()
    
    
    // MARK: - Public
    
    // 获取各类型的商品个数
    func getProductListCount(_ section: Int) -> Int {
        if section == 0 {
            // 常买
            return frequentlyBuy.count
        }
        else if section == 1 {
            // 常看
            return frequentlyView.count
        }
        else if section == 2 {
            // 热销
            return cityHotSale.count
        }
        else {
            return 0
        }
    }
    
    // 获取各类型的标题
    func getProductListTitle(_ section: Int) -> String? {
        guard let model = productModel else {
            return nil
        }
        
        if section == 0 {
            // 常买
            guard let item = model.frequentlyBuy, let title = item.floorName, title.isEmpty == false else {
                return nil
            }
            return title
        }
        else if section == 1 {
            // 常看
            guard let item = model.frequentlyView, let title = item.floorName, title.isEmpty == false else {
                return nil
            }
            return title
        }
        else if section == 2 {
            // 热销
            guard let item = model.cityHotSale, let title = item.floorName, title.isEmpty == false else {
                return nil
            }
            return title
        }
        else {
            return nil
        }
    }
    
    // 获取指定索引处的商品model
    func getProductItemModel(_ indexPath: IndexPath) -> OftenBuyProductItemModel? {
        if indexPath.section == 0 {
            // 常买
            guard indexPath.row < frequentlyBuy.count else {
                return nil
            }
            return frequentlyBuy[indexPath.row]
        }
        else if indexPath.section == 1 {
            // 常看
            guard indexPath.row < frequentlyView.count else {
                return nil
            }
            return frequentlyView[indexPath.row]
        }
        else if indexPath.section == 2 {
            // 热销
            guard indexPath.row < cityHotSale.count else {
                return nil
            }
            return cityHotSale[indexPath.row]
        }
        else {
            return nil
        }
    }
    
    // 判断是否没有任何商品
    func checkOftenBuyNoProductList() -> (Bool) {
        guard let _ = productModel else {
            return false
        }
        var noData = true
        if cityHotSale.count > 0 || frequentlyBuy.count > 0 || frequentlyView.count > 0 {
            noData = false
        }
        return noData
    }
    
    // 重置所有数据
    func resetAllData() {
        productModel = nil
        cityHotSale.removeAll()
        frequentlyBuy.removeAll()
        frequentlyView.removeAll()
        needLoadMore = false
        indexPathSelect = nil
        imgviewSelect = nil
        rectSelect = nil
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
}


// MARK: - Private
extension OftenBuyViewModel {
    // 数据处理
    fileprivate func handleProductModel(_ refresh: Bool) {
        guard let model = productModel else {
            needLoadMore = false
            return
        }
        
        if refresh {
            cityHotSale.removeAll()
            frequentlyBuy.removeAll()
            frequentlyView.removeAll()
        }
        
        if let buy = model.frequentlyBuy, let list = buy.list, list.count > 0 {
            frequentlyBuy.append(contentsOf: list)
        }
        
        if let see = model.frequentlyView, let list = see.list, list.count > 0 {
            frequentlyView.append(contentsOf: list)
        }
        
        if let hotsale = model.cityHotSale, let list = hotsale.list, list.count > 0 {
            cityHotSale.append(contentsOf: list)
            
            if let page = hotsale.pageId, let total = hotsale.totalPageCount, let pageCount = Int(page), let totalCount = Int(total) {
                // normal
                if pageCount >= totalCount {
                    // 加载完毕
                    needLoadMore = false
                }
                else {
                    // 需要加载更多
                    needLoadMore = true
                }
            }
            else {
                // error
                needLoadMore = false
            }
        }
        else {
            // 无数据
            needLoadMore = false
        }
    }
}


// MARK: - 常购清单 Request
extension OftenBuyViewModel {
    // 资质状态查询
    func requestZzStatus(_ callback:@escaping (_ statusCode: Int?)->()) {
        requestService.getAuditStatusBlock(withParam: nil) { (response, error) in
            if error == nil {
                if let json = response as? NSDictionary {
                    if let statusCode = (json as AnyObject).value(forKeyPath: "statusCode") as? NSNumber {
                        callback(statusCode.intValue)
                    }
                    else {
                        callback(-2)
                    }
                }
                else {
                    callback(-2)
                }
            }
            else {
                callback(-2)
            }
        }
    }
    
    // 请求常购清单列表数据
    func requestProductList(_ refresh: Bool, success:@escaping (OftenBuyProductModel?, Bool)->(), fail:@escaping (String?)->()) {
        // 页索引...<默认为刷新>
        var pageId = 1
        if !refresh {
            // 加载更多
            if !needLoadMore {
                success(nil, false)
                return
            }
            if let model = productModel, let hotsale = model.cityHotSale, let page = hotsale.pageId, let index = Int(page), index >= 0 {
                pageId = index + 1
            }
        }
        // 每页条数
        let pageSize = 20
        // 企业id
        let enterpriseId = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        // 入参
        let dic: [String: Any] = ["pageId": pageId, "pageSize": pageSize, "enterpriseId":enterpriseId ?? ""]
        // 请求
        _ = requestService.getOftenBuyProductListBlock(withParam: dic, completionBlock: {[weak self] (responseObject, anError) in
            guard let strongSelf = self else {
                return
            }
            if anError == nil {
                // 成功
                if let response = responseObject as? NSDictionary {
                    let model: OftenBuyProductModel = response.mapToObject(OftenBuyProductModel.self)
                    // 有数据...<请求成功，且有数据，才会保存>
                    strongSelf.productModel = model
                    strongSelf.handleProductModel(refresh)
                    strongSelf.refreshDataBackFromCart()
                    success(model, strongSelf.needLoadMore)
                }
                else {
                    // 无数据
                    strongSelf.needLoadMore = false
                    success(nil, false)
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
}


// MARK: - 常购清单 Request
extension OftenBuyViewModel {
    // 数量变零，删除购物车
    func deleteShopCartItem(_ model: OftenBuyProductItemModel, callback:@escaping (_ success: Bool, _ msg: String?)->()) {
        cartService.deleteShopCart([model.carId], success: { (mutiplyPage) in
            // 成功
            callback(true, nil)
        }, failure: { (reason) in
            // 失败
            callback(false, reason)
        })
    }
    
    // 更新购物车中商品加车数量
    func updateShopCartItem(_ model: OftenBuyProductItemModel, count: Int, callback:@escaping (_ success: Bool, _ msg: String?)->()) {
        cartService.updateShopCart(forProduct: "\(model.carId)", quantity: count, allBuyNum: -1, success: { (mutiplyPage,aResponseObject) in
            // 成功
            callback(true, nil)
        }, failure: { (reason) in
            // 失败
            callback(false, reason)
        })
    }
    
    // 商品直接加车
    func addShopCartItem(_ model: OftenBuyProductItemModel,_ sourceType:String? ,count: Int, callback:@escaping (_ msg: String?, _ data: AnyObject?)->()) {
        shopService.addShopCart(model,sourceType,count: count, completionClosure: { (reason, data) in
            callback(reason, data as AnyObject?)
        })
    }
}

// MARK: - 常购商家 Request
extension OftenBuyViewModel {
    // 请求常购商家列表数据
    class func getChangMerchants(_ callback:@escaping (_ sellerList: [OftenBuySellerModel])->()) {
        // 入参
        let yctoken: NSString? = UserDefaults.standard.value(forKey: "user_token") as? NSString
        let dic = ["ycToken": (yctoken ?? "") as Any] as [String : Any]
        // service
        let orderService: FKYPublicNetRequestSevice? = FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice
        // 请求
        _ = orderService?.getChangMerchantsBlock(withParam: dic, completionBlock: {(responseObject, anError)  in
            if anError == nil {
                if let adviserList = responseObject as? NSArray, let adviserArray = adviserList.mapToObjectArray(OftenBuySellerModel.self) {
                    // 有数据
                    callback(adviserArray)
                }
                else {
                    // 无数据
                    callback([])
                }
            }
            else {
                if let err = anError {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        FKYAppDelegate!.showToast("用户登录过期，请重新手动登录")
                    }
                }
                callback([])
            }
        })
    }
}
