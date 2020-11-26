//
//  RCTypeSelViewModel.swift
//  FKY
//
//  Created by 寒山 on 2018/11/27.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

class RCTypeSelViewModel: NSObject {
    //
    var maxCountCountList: Array<RCProductCountModel>?
    var childOrderId: String?
    var childOrderIdList: Array<RCChildOrderIdModel>?
    var orderModel: FKYOrderModel?
    var allSelect: Bool?
    
    // 查询可退换货数量
    func requestForGetCountsInfo(block: @escaping (Bool, String?)->()) {
        let dic: [String: Any] = [
            "orderId":childOrderId as Any
        ]
        // 请求
        FKYRequestService.sharedInstance()?.requestForGetCountsInfo(withParam: dic, completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                var msg = "访问失败"
                if let errorMsg : String = ((error as Any) as! NSError).userInfo[HJErrorTipKey] as? String{
                    msg = errorMsg;
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg)
                return
            }
            if let data = response as? NSArray {
                if  let rclModelArray = data.mapToObjectArray(RCProductCountModel.self) {
                    self.maxCountCountList = rclModelArray
                    // 有数据
                }
            }
            block(true, "")
        })
    }
    
    //根据第三方订单（药城订单）ID查询药网子单
    func requestForQueryOrderIdInfo(_ oid: String?, block: @escaping (Bool, String?)->()) {
        let dic: [String: Any] = [
            "orderId": oid as Any
        ]
        // 请求
        FKYRequestService.sharedInstance()?.requestForQueryOrderIdInfo(withParam: dic, completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                var msg = "访问失败"
                if let errorMsg : String = ((error as Any) as! NSError).userInfo[HJErrorTipKey] as? String{
                    msg = errorMsg
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg)
                return
            }
            if let data = response as? NSArray {
                if  let rclModelArray = data.mapToObjectArray(RCChildOrderIdModel.self) {
                    self.childOrderIdList = rclModelArray
                    // 有数据
                    if self.childOrderIdList!.count > 0 {
                        let  model:RCChildOrderIdModel = self.childOrderIdList![0]
                        self.childOrderId = model.childSalesOrderId
                    }
                }
            }
            block(true, "")
        })
    }
    
    //获取商品最大可退数目
    func getMaxCount (_ oderDetailID: Int) -> Int {
        if maxCountCountList == nil {
            return 0
        }
        for model in maxCountCountList! {
            if model.orderDetailId == oderDetailID {
                return model.rmaCount!
            }
        }
        return 0
    }
    
    //初始化商品状态
    func initPooductStatus() {
        allSelect = false
        for model in self.orderModel!.productList{
            let productModel:FKYOrderProductModel = model as! FKYOrderProductModel
            productModel.steperCount = 0
            productModel.checkStatus = false
        }
    }
    
    //判断商品是否是全选
    func isAllProductSelected() -> Bool {
        let RegexSelected = NSPredicate.init(format:"checkStatus == YES")
        let tempArray :NSMutableArray = NSMutableArray.init(array: self.orderModel!.productList)
        let selectedArray  = (tempArray).filtered(using: RegexSelected)
        if selectedArray.count == self.orderModel!.productList.count {
            return true
        }
        return false
    }
    
    //判断是1药贷对公的订单 并且都选择最大
    func judgeAllSelectProductIsMax() -> Bool {
        for model in self.orderModel!.productList{
            let productModel:FKYOrderProductModel = model as! FKYOrderProductModel
            if productModel.checkStatus == false || productModel.steperCount != self.getMaxCount(productModel.orderDetailId){
                 return false
            }
        }
        return true
    }
    
    //判断是否包含固定套餐取消选中
    func judgeHasFixComobProduct() -> Bool {
        for model in self.orderModel!.productList{
            let productModel:FKYOrderProductModel = model as! FKYOrderProductModel
            if productModel.checkStatus == true && productModel.promotionType == 14{
                return true
            }
        }
        return false
    }
    
    func setFixComobProductUnCheck(block: @escaping (Bool)->()) {
        allSelect = false
        for model in self.orderModel!.productList{
            let productModel:FKYOrderProductModel = model as! FKYOrderProductModel
            if productModel.checkStatus == true && productModel.promotionType == 14{
                productModel.checkStatus = false
            }
        }
        block(true)
    }
    
    //商品全选 全不选
    func setAllProductCheckSatteAndIsMax(block: @escaping (Bool)->()) {
        allSelect = true
        for model in self.orderModel!.productList{
            let productModel:FKYOrderProductModel = model as! FKYOrderProductModel
            productModel.checkStatus = true
            productModel.steperCount = self.getMaxCount(productModel.orderDetailId)
        }
        block(true)
    }
    
    //获取选中的商品
    func getAllSelectProduct() -> [Any] {
        var selectArray:[Any] = []
        for model in self.orderModel!.productList{
            let productModel:FKYOrderProductModel = model as! FKYOrderProductModel
            if productModel.checkStatus == true && productModel.steperCount != 0{
                selectArray.append(productModel)
            }
            if let arr = self.maxCountCountList {
                for countModel in arr {
                    if countModel.orderDetailId == productModel.orderDetailId {
                        productModel.batchNumber = countModel.batchNumber
                        productModel.orderDeliveryDetailId = countModel.orderDeliveryDetailId ?? 0
                    }
                }
            }
        }
        return selectArray
    }
    
    //MARK:计算选中商品的总金额
    func getAllSelectProductMoneyNum() -> Double {
        var totalNum = 0.0
        for model in self.orderModel!.productList{
            let productModel:FKYOrderProductModel = model as! FKYOrderProductModel
            if productModel.checkStatus == true && productModel.steperCount != 0{
                totalNum = totalNum + Double(productModel.steperCount) * productModel.productPrice.doubleValue
            }
        }
        return totalNum
    }
    
    //商品全选 全不选
    func setAllProductCheckSatte(_ checkSatues: Bool?,block: @escaping (Bool)->()) {
        allSelect = checkSatues
        for model in self.orderModel!.productList{
            let productModel:FKYOrderProductModel = model as! FKYOrderProductModel
            if productModel.steperCount == 0{
                if self.getMaxCount(productModel.orderDetailId) == 0{
                    productModel.checkStatus = false
                }else{
                    productModel.steperCount =  1
                    productModel.checkStatus = checkSatues!
                }
            }else{
                 productModel.checkStatus = checkSatues!
            }
        }
        block(true)
    }
}
//获取mp的商品
extension RCTypeSelViewModel {
    // 查询可退换货数量
    func requestForGetMPProductListInfo(block: @escaping (Bool, String?)->()) {
        let dic: [String: Any] = [
            "flowId":orderModel?.orderId ?? "",
            "pageNo" : "1",
            "pageSize" : "200"
        ]
        // 请求
        self.childOrderId = orderModel?.orderId
        FKYRequestService.sharedInstance()?.requestForGetMPCountsInfo(withParam: ["jsonParams":dic], completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                var msg = "访问失败"
                if let errorMsg : String = ((error as Any) as! NSError).userInfo[HJErrorTipKey] as? String{
                    msg = errorMsg;
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg)
                return
            }
            if let data = response as? NSDictionary, let arr = data["orderDeliveryDetailDtoList"] as? NSArray , arr.count > 0 {
                self.maxCountCountList = RCProductCountModel.paraMpJSON(arr)
            }
            block(true, "")
        })
    }
}
