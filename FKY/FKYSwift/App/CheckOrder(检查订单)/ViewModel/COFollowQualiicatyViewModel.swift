//
//  COFollowQualiicatyViewModel.swift
//  FKY
//
//  Created by 寒山 on 2020/11/10.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class COFollowQualiicatyViewModel: NSObject {
    // 检查订单接口返回数据model
    var modelCO: CheckOrderModel?
    var suppluId:String? //判断当前当家
    var enterpriseTypeSelState: Bool = false //企业首营资质选中状态
    var productTypeSelState: Bool = false  //商品首营资质选中状态
    var shopModel:COSupplyOrderModel? //当前选择的商家
    var productList:[COProductModel] = []  //当前选择的商家的产品列表
    
    //初始化当前的列表
    func queryCurrectShopProduct(handler: @escaping (_ success: Bool)->()){
        if let checkOrderModel = modelCO,let orderSupplyCartVOs = checkOrderModel.orderSupplyCartVOs,orderSupplyCartVOs.isEmpty == false{
            for supplyModel in orderSupplyCartVOs{
                if ("\(supplyModel.supplyId ?? 0)" == self.suppluId){
                    shopModel = supplyModel
                    self.productList.removeAll()
                    self.enterpriseTypeSelState = shopModel?.enterpriseTypeSelState ?? false
                    self.productTypeSelState = shopModel?.productTypeSelState ?? false
                    if let products = supplyModel.products,products.isEmpty == false{
                        self.productList.append(contentsOf: products)
                    }
                }
            }
        }
        return handler(true)
    }
    
    //更新商品首营资质类型  0 枚选择 1选择批件 2选择全套
    func updateProductSelType(_ selType:Int,_ productId:String,handler: @escaping (_ success: Bool)->()){
        for productModel in self.productList{
            if ("\(productModel.productId ?? 0)" == productId){
                productModel.customerRequestProductType = selType
            }
        }
        return handler(true)
    }
    //清空所有商品首营资质类型
    func clearAllProductSelType(handler: @escaping (_ success: Bool)->()){
        for productModel in self.productList{
            productModel.customerRequestProductType = 0
        }
        return handler(true)
    }
    //保存选择数据
    func saveAllShopFollowQuality() -> CheckOrderModel{
        var checkOrderModel = CheckOrderModel()
        checkOrderModel = modelCO!
        if let orderSupplyCartVOs = checkOrderModel.orderSupplyCartVOs,orderSupplyCartVOs.isEmpty == false{
            for supplyModel in orderSupplyCartVOs{
                if ("\(supplyModel.supplyId ?? 0)" == self.suppluId){
                    supplyModel.enterpriseTypeSelState = self.enterpriseTypeSelState
                    for productModel in self.productList{
                        supplyModel.productTypeSelState = false
                        if productModel.customerRequestProductType != 0{
                            supplyModel.productTypeSelState = true
                            break
                        }
                    }
                }
            }
        }
        return checkOrderModel
    }
}
