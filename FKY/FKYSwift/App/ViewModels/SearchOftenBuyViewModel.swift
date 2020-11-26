//
//  SearchOftenBuyViewModel.swift
//  FKY
//
//  Created by 寒山 on 2018/12/17.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

class SearchOftenBuyViewModel: NSObject {
    // 每次接口请求成功后返回的实时数据model...<用于记录分页>
    var productModel: OftenBuyProductModel?
    // 三个类型的数据源
    var cityHotSale = [OftenBuyProductItemModel]()    // 热销
    var frequentlyBuy = [OftenBuyProductItemModel]()  // 常买
    var frequentlyView = [OftenBuyProductItemModel]() // 常看
    
    // 网络请求service...<商品列表>
    fileprivate lazy var requestService: FKYPublicNetRequestSevice = {
        let service = FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as! FKYPublicNetRequestSevice
        return service
    }()
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
    }
    // 请求常购清单列表数据
    func requestProductList(success:@escaping (OftenBuyProductModel?)->(), fail:@escaping (String?)->()) {
        // 页索引...<默认为刷新>
        let pageId = 1
         // 每页条数
        let pageSize = 20
        // 企业id
        let enterpriseId = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        // 入参
        let dic: [String: Any] = ["pageId": pageId, "pageSize": pageSize, "enterpriseId":enterpriseId ?? ""]
        // 请求
        _ = requestService.getOftenBuyProductListBlock(withParam: dic, completionBlock: {(responseObject, anError) in
            if anError == nil {
                // 成功
                if let response = responseObject as? NSDictionary{
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
}
