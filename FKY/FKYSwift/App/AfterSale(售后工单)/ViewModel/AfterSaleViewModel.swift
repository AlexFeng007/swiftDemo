//
//  AfterSaleViewModel.swift
//  FKY
//
//  Created by 寒山 on 2019/5/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  售后工单
//  提交工单接口wiki地址：http://wiki.yiyaowang.com/pages/viewpage.action?pageId=20087021


import UIKit

class AfterSaleViewModel: NSObject {
    var dataSource: Array<ASApplyTypeModel> = []  //申请售后列表
    var applyList: Array<ASApplyListInfoModel> = []  //申请记录列表
    var asDetailModel: ASApplyDetailInfoModel? //申请记录详情
    var asBaseInfo: ASAplyBaseInfoModel? //工单基本信息
    var orderModel: FKYOrderModel?
    var amountLimit: String?     //额度
    var isExistClaim: String?  //是否展示标识( 0 - 允许发起 ； 1 - 因发起过一次，不能再发起 ； 2 - 因承运商问题，不能发起)
}
// MARK: - func
extension AfterSaleViewModel {
    //获取选中的商品
    func getAllSelectProduct() -> [ASApplyBaseProductModel] {
        var selectArray:[ASApplyBaseProductModel] = []
        for model in self.asBaseInfo!.productList!{
            let productModel:ASApplyBaseProductModel = model
            if productModel.checkStatus == true && productModel.steperCount != 0{
                selectArray.append(productModel)
            }
        }
        return selectArray
    }
    //清空选择商品信息
    func resetAllSelectProduct() {
        for model in self.asBaseInfo!.productList!{
            let productModel:ASApplyBaseProductModel = model
            productModel.checkStatus = false
            productModel.steperCount = 0
        }
    }
}

// MARK: - Request
extension AfterSaleViewModel {
    //处理返回数据
    fileprivate func dealApplyTypeArr(){
        if self.dataSource.count > 0 {
            var desArr = Array<ASApplyTypeModel>()
            for model in self.dataSource {
                //去掉退换货
                if model.typeId ==  ASTypeECode.ASType_RC.rawValue{
                    if self.orderModel!.selfCanReturn == false ||  self.orderModel!.selfReturnApplyStatus == true{
                        //不显示退换货
                    }else {
                        //显示退换货
                        desArr.append(model)
                    }
                }else if model.typeId ==  ASTypeECode.ASType_Compensation.rawValue{
                    //显示极速理赔选项（夏沼润需要这么写的）
                    if self.orderModel!.selfCanReturn == true {
                        if self.isExistClaim == "0" {
                            desArr.append(model)
                        }
                    }
                }else {
                    desArr.append(model)
                }
            }
            self.dataSource = desArr
        }
    }
    //判断是否展示极速理赔接口
    func getShowOrHideCompensationView(callback: @escaping (_ errStr :String?)->()) {
        // 入参
        let dic: [String: Any] = [
            "orderId":self.orderModel?.orderId ?? "" ,
        ]
        // 请求
        FKYRequestService.sharedInstance()?.queryTypeShowCompensation(withParam: dic, completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "获取失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                callback(msg)
                return
            }
            // 请求成功
            if let data = response as? NSDictionary {
                if let str = data["amountLimit"] as? String {
                    self.amountLimit = str
                }
                if let str = data["isExistClaim"] as? String {
                    self.isExistClaim = str
                }
                callback(nil)
                return
            }
            callback("获取失败")
        })
    }
    //获取申请售后列表
    func getASServiceType(withParams soNo: String?,_ type:Int, callback: @escaping (_ goods : [ASApplyTypeModel])->(), fail: @escaping (_ reason : String)->()) {
        // 入参
        let dic: [String: Any] = [
            "orderNo":soNo as Any ,
            "shopType" : type
        ]
        // 请求
        FKYRequestService.sharedInstance()?.queryASServiceType(withParam: dic, completionBlock: { (success, error, response, model) in
            if error == nil {
                if let data = response as? NSArray {
                    if  let rclModelArray = data.mapToObjectArray(ASApplyTypeModel.self) {
                        self.dataSource = rclModelArray
                        let model = ASApplyTypeModel()
                        model.typeId = 7
                        model.typeName = "极速理赔"
                        self.dataSource.append(model)
                        self.dealApplyTypeArr()
                        // 有数据
                        callback(self.dataSource)
                    }else {
                        // 无数据
                        callback(self.dataSource)
                    }
                }
                else {
                    // 无数据
                    callback(self.dataSource)
                }
            }
            else {
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
                fail(msg)
            }
        })
    }
    
    //获取申请记录
    func getWorkOrderList(withParams soNo: String?,_ type:Int, callback: @escaping (_ goods : [ASApplyListInfoModel])->(), fail: @escaping (_ reason : String)->()) {
        // 入参
        let dic: [String: Any] = [
            "orderNo":soNo as Any ,
            "shopType" : type
        ]
        // 请求
        FKYRequestService.sharedInstance()?.queryWorkOrderList(withParam: dic, completionBlock: { (success, error, response, model) in
            if error == nil {
                if let data = response as? NSArray {
                    if  let rclModelArray = data.mapToObjectArray(ASApplyListInfoModel.self) {
                        self.applyList = rclModelArray
                        // 有数据
                        callback(self.applyList)
                    }else {
                        // 无数据
                        callback(self.applyList)
                    }
                }
                else {
                    // 无数据
                    callback(self.applyList)
                }
            }
            else {
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
                fail(msg)
            }
        })
    }
    
    //获取工单详情
    func getASApplyDetailInfo(_ soNo: String?, _ typeId: Int?, block: @escaping (Bool, String?)->()) {
        // 传参
        let dic: [String: Any] = [
            "soNo": soNo as Any,
            "typeId": typeId as Any
        ]
        FKYRequestService.sharedInstance()?.queryAsWorkTypeDetail(withParam: dic, completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "获取失败"
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
            // 请求成功
            if let data = response as? NSDictionary {
                self.asDetailModel = data.mapToObject(ASApplyDetailInfoModel.self)
                block(true, "获取成功")
                return
            }
            block(false, "")
        })
    }
    
    //提交工单
    class func saveAsWorkOrder(withParams dic: Dictionary<String, Any>, block: @escaping (Bool, String?)->()) {
        // 请求
        FKYRequestService.sharedInstance()?.saveAsWorkOrderForB2BTypeDetail(withParam: dic, completionBlock: { (success, error, response, model) in
            if error == nil {
                // 请求成功
                if (response as? NSDictionary) != nil {
                    // 有数据
                    block(true,"成功")
                }
                else {
                    // 无数据
                    block(true,"成功")
                }
            }
            else {
                // 请求失败
                var msg = "访问失败"
                if let errorMsg : String = ((error as Any) as! NSError).userInfo[HJErrorTipKey] as? String {
                    msg = errorMsg;
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false,msg)
            }
        })
    }
    
    //获取工单基本信息
    func getWorkOrderBaseInfo(withParams dic: Dictionary<String, Any>, block: @escaping (Bool, ASAplyBaseInfoModel?, String?)->()) {
        //
        FKYRequestService.sharedInstance()?.getAsWorkOrderBaseInfo(withParam: dic, completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "获取失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, nil, msg)
                return
            }
            // 请求成功
            if let data = response as? NSDictionary {
                let baseInfo = data.mapToObject(ASAplyBaseInfoModel.self)
                self.asBaseInfo = baseInfo
                block(true, baseInfo, "获取成功")
                return
            }
            block(false, nil, "")
        })
    }
}
