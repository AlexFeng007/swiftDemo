//
//  ArrivalProductNoticeViewModel.swift
//  FKY
//
//  Created by 寒山 on 2020/8/11.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class ArrivalProductNoticeViewModel: NSObject {
    var phoneInput: String?      // 手机号码
    var numberInput: String?     // 期望购买数
    var productId: String?       // 商品编码
    var venderId: String?        // 商家编码
    var productUnit: String?     // 商品包装
    let pageSize = 10
    var hasNextPage = true  //判断是否有下一页
    var currentPage: Int = 1   //当前页加载页 已有的
    var stockoutModel:HomeCommonProductModel? //缺货的商品model
    //首页banner 和 icon 的数据
    var dataSource = [HomeCommonProductModel]()//商品数组
   
    fileprivate lazy var logic: FKYOftenBuyLogic = { [weak self] in
        let logic = FKYOftenBuyLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYOftenBuyLogic
        return logic!
        }()
    // MARK: - Properties
    var submitResult: OutputResult { // 按钮点击后结果枚举
        get {
            guard let phone = phoneInput, phone.isEmpty == false else {
                return .empty(message: "请输入手机号码!")
            }
            let phoneValid = (phone as NSString).isPhoneNumber()
            if !phoneValid {
                return .failed(message: "手机号码有误，请重新输入!")
            }
            
            guard let number = numberInput, number.isEmpty == false else {
                return .empty(message: "请输入期望采购数量!")
            }
            let numberValid = (number as NSString).integerValue > 0
            if !numberValid {
                return .failed(message: "期望采购数必须为正整数，请重新输入!")
            }
            
            if phoneValid, numberValid {
                return .ok
            }
            return .failed(message: "输入有误，请重新输入!")
        }
    }
    
    //获取全部商品
    func getAllRecommondProductInfo(callback: @escaping ()->(), fail: @escaping (_ reason : String)->()) {
        // 传参postArrivalRecommendProductInfoWithParam
        let dic: [String: Any] = [
            "page":self.currentPage,
            "pageSize":self.pageSize,
            "spuCode":self.productId ?? "",
            "sellerCode":self.venderId ?? "" // 企业id
        ]
        FKYRequestService.sharedInstance()?.postArrivalRecommendProductInfo(withParam: (dic as [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
            if let strongSelf = self {
                strongSelf.dealData(response: response, error: error, callback: callback, fail: fail)
            }
        })
    }
    func dealData(response: Any?, error: Error?, callback: @escaping ()->(), fail: @escaping (_ reason : String)->()) {
        var dataSource: Array<HomeCommonProductModel> = []
        if self.currentPage != 1 && self.dataSource.count > 0 {
            dataSource = self.dataSource
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
                self.hasNextPage = false
                fail(tip)
                return
            }
            if let model = data["product"] as? NSDictionary {
                self.stockoutModel = model.mapToObject(HomeCommonProductModel.self)
                self.productUnit = self.stockoutModel?.packageUnit ?? ""
            }
            if let list = data["productList"] as? NSArray {
                // 有数据
                let datas = list
                let items = datas.mapToObjectArray(HomeCommonProductModel.self)!
                dataSource.append(contentsOf: items)
                // < self.currentModel.pageSize
                if items.count < self.pageSize {
                    self.hasNextPage = false
                } else {
                    self.hasNextPage = true
                }
                self.currentPage += 1
                self.dataSource = dataSource
                callback()
            } else {
                // 无数据
                self.hasNextPage = false
                fail(tip)
            }
        }
    }
    //  MARK: - Data
    func submit(handler: @escaping (_ message: String, _ ret: Bool)->Void) {
        ShopArrivalProvider().submitArrivalInfo(productId ?? "" , sellerCode: venderId ?? "", phoneNumber: (phoneInput ?? "")!, numberInput: (numberInput ?? "")!, callback: { (dic) in
            let msg = dic
            handler(msg, true)
        }, failCallback: {
            handler("服务器繁忙，请稍后再试!", false)
        })
    }
}
