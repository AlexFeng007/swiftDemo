//
//  COOnlinePayViewModel.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/23.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class COOnlinePayViewModel: NSObject {
    //MARK: - Property
    
    var supplyIdList:[Any] = []    // 父订单供应商列表
    
    // 供应商id
    var supplyId: String?
    
    // 订单id
    var orderId: String?
    
    // 一起购订单传1 一起拼订单传3 普通订单不传 ？？？
    var orderType: String?
    
    // 订单金额
    var orderMoney: String?
    
    // 判断是否从检查订单界面跳转过来...<默认为否>
    var flagFromCO: Bool = false
    
    /**********************************/
    // 接口1：请求所有在线支付类型列表
    
    /// 在线支付类型数组
    var payList: [PayTypeItemModel] = [PayTypeItemModel]()
    
    /// 在线支付方式的原始数据
    var payListRAWData: [PayTypeItemModel] = [PayTypeItemModel]()
    
    /// 正常展示的支付方式列表
    var showPayList:[PayTypeItemModel] = [PayTypeItemModel]()
    
    /// 需要折叠隐藏的支付方式列表
    var hidePayList:[PayTypeItemModel] = [PayTypeItemModel]()
    
    /// 是否已经展开过隐藏支付方式  如果已经展开过则不再显示展开更多支付方式的按钮
    var isUnfoldHidePayWay:Bool = false
    
    // 选中索引
    var selectedIndex: Int?
    
    // 选中支付方式
    var selectedPayType: COOnlinePayType?
    
    // 是否展示花呗分期选择视图...<默认不展示>
    var showInstalment: Bool = false
    
    // 是否展示上海银行快捷支付...<默认不展示>
    var showQuickPay: Bool = false
    
    // 是否为上海银行快捷支付绑定银行卡...<默认没有>
    var blindQuickPayBankCard: Bool = false
    
    /// 快捷支付流水号
    var quickPayFlowId = ""
    
    /// 快捷支付短信验证码
    var quickPaySmsCode = ""
    
    // 绑定银行卡手机号
    var quickPayPhoneNum = ""
    
    // 有没有选择过支付协议 默认选中
    var aggreementSelectState: Bool = true
    /**********************************/
    // 接口2：请求上次保存/使用的支付方式...<可能返回3-线下转账，即不仅仅只返回在线支付方式>
    var realName = "" //快捷支付时持卡人名字
    var idCardNo = ""//快捷支付时持卡人身份证号
    // 上次支付方式id~!@
    var payTypeId: Int?
    
    /**********************************/
    // 接口3：请求花呗分期详情数据
    
    // 花呗分期列表数据
    var alipayList: [COAlipayInstallmentItemModel] = [COAlipayInstallmentItemModel]()
    
    // 选中的花呗分期索引
    var selectedAlipayIndex: Int?
}


// MARK: - Public
extension COOnlinePayViewModel {
    // 根据在线支付方式来确定支付类型
    func getOnlinePayTypeForSaved(_ type: Int) -> COOnlinePayType {
        var payType: COOnlinePayType = .others
        
        if type == 7 || type == 8 {
            payType = .aliPay
        }
        else if type == 12 || type == 13 || type == 14 {
            payType = .wechatPay
        }
        else if type == 17 {
            payType = .loanPay
        }
        else if type == 20 {
            payType = .instalmentPay
        }
        else if type == 100 {
            payType = .agentPay
        }
        else if type == 9 {
            payType = .unionPay
        }
        else if type == 26{
            payType = .shBankQuickPay
        }else if type == 28{
            payType = .HuaBei
        }
        else {
            // 其它...<不能识别，显示，但不可支付>
            payType = .others
        }
        
        return payType
    }
    
    // 获取当前选中的花呗分期详情model
    func getAlipayIntalmentDetail() -> COAlipayInstallmentItemModel? {
        guard let index = selectedAlipayIndex, index >= 0, index < alipayList.count else {
            return nil
        }
        return alipayList[index]
    }
}

// MARK: - 数据处理
extension COOnlinePayViewModel {
    
    /// 分离出需要隐藏和显示的支付方式
    func separatePayWay(){
        self.payListRAWData = self.payList
        self.showPayList.removeAll()
        self.hidePayList.removeAll()
        for payWay in self.payList {
            if payWay.showFlag != "0" {// 需要展示的支付方式
                self.showPayList.append(payWay)
            }else {// 需要隐藏的支付方式
                self.hidePayList.append(payWay)
            }
        }
        self.organizeHideOrShowPayList()
    }
    
    /// 处理是否显示数据
    func organizeHideOrShowPayList(){
        self.payList.removeAll()
        if self.isUnfoldHidePayWay == false {// 未展开过
            self.payList.append(contentsOf: self.showPayList)
            if self.hidePayList.isEmpty == false {// 有需要隐藏的支付方式
                let unfoldCell:PayTypeItemModel = PayTypeItemModel()
                unfoldCell.cellType = .hideCell
                self.payList.append(unfoldCell)
            }
        }else{// 已经展开过
            self.payList = self.payListRAWData
        }
    }
}

// MARK: - 封装入参
extension COOnlinePayViewModel {
    // 封装入参...<在线支付方式列表>
    fileprivate func getOnlinePayListData() -> Dictionary<String, Any>? {
        // 最终入参...<一级>
        var param = Dictionary<String, Any>()
        
        // token
        var yctoken = ""
        if let token: String = UserDefaults.standard.value(forKey: "user_token") as? String, token.isEmpty == false {
            yctoken = token
        }
        param["yctoken"] = yctoken
        // 订单id 多个商家合并支付不传 传个0
        if supplyIdList.isEmpty == false{
            param["supplyId"] = "0"
        }else{
            param["supplyId"] = supplyId ?? "0"
        }
        
        // 订单类型
        param["orderId"] = orderId ?? ""
        // 订单类型
        param["orderType"] = orderType ?? ""
        // 判断是否显示找人代付 0-不显示 1-显示
        param["type"] = flagFromCO ? "1" : "0"
        
        return param
    }
    
    // 封装入参...<花呗分期列表>
    fileprivate func getAlipayInstalmentListData() -> Dictionary<String, Any>? {
        // 最终入参...<一级>
        var param = Dictionary<String, Any>()
        
        // token
        var yctoken = ""
        if let token: String = UserDefaults.standard.value(forKey: "user_token") as? String, token.isEmpty == false {
            yctoken = token
        }
        param["yctoken"] = yctoken
        
        // 订单相关
        let dic: [NSString: Any] = ["position":0, "orderMoney":(orderMoney ?? "0")]
        // 订单类型
        param["moneyList"] = [dic]
        
        return param
    }
    
    // 封装入参...<上次在线支付方式>
    fileprivate func getSaveOnlinePayTypeData() -> Dictionary<String, Any>? {
        // 入参
        var param = Dictionary<String, Any>()
        // userid
        let userid: String = (FKYLoginAPI.loginStatus() == .unlogin) ? "" : FKYLoginAPI.currentUserId()
        param["custId"] = userid
        // 供应商id
        if supplyIdList.isEmpty == false{
            param["supplyIdList"] = supplyIdList
        }else{
            let list: [String] = [supplyId ?? ""]
            param["supplyIdList"] = list
        }
        
        
        return ["jsonParams": param]
    }
    // 封装入参...<快捷支付获取流水号>
    fileprivate func getQuickPayFlowdData() -> Dictionary<String, Any>? {
        // 最终入参...<一级>
        var param = Dictionary<String, Any>()
        
        // token
        var yctoken = ""
        if let token: String = UserDefaults.standard.value(forKey: "user_token") as? String, token.isEmpty == false {
            yctoken = token
        }
        param["yctoken"] = yctoken
        param["orderType"] = self.orderType ?? ""
        // 订单类型
        param["flowId"] = orderId ?? ""
        return param
    }
    // 封装入参...<快捷支付确认支付>
    fileprivate func confirmQuickPayData() -> Dictionary<String, Any>? {
        // 最终入参...<一级>
        var param = Dictionary<String, Any>()
        
        // token
        var yctoken = ""
        if let token: String = UserDefaults.standard.value(forKey: "user_token") as? String, token.isEmpty == false {
            yctoken = token
        }
        param["yctoken"] = yctoken
        
        //流水号
        param["reqNo"] = quickPayFlowId
        // 短信验证码
        param["smsCode"] = quickPaySmsCode
        return param
    }
}


// MARK: - Request
extension COOnlinePayViewModel {
    // 在线支付方式列表接口请求
    func requestForOnlinePayList(_ block: @escaping (Bool, String?, Any?)->()) {
        // 先清空
        payList.removeAll()
        // 传参
        let param: [String: Any]? = getOnlinePayListData()
        // 请求
        FKYRequestService.sharedInstance()?.requestForOnlinePayType(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard success else {
                var msg = error?.localizedDescription ?? "请求失败"
                if let err = error {
                    let e = err as NSError
                    // token过期
                    if e.code == 2 {
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                // 失败回调
                block(false, msg, nil)
                return
            }
            // 请求成功
            if let list = model as? [PayTypeItemModel] {
                // 获取线上支付方式成功
                
                // 保存
                strongSelf.payList.append(contentsOf: list)
                strongSelf.separatePayWay()
                // 成功回调
                block(true, nil, nil)
                return
            }
            // 获取线上支付方式失败
            block(false, nil, nil)
        })
    }
    
    // 花呗分期列表接口请求
    func requestForAlipayInstalmentList(_ block: @escaping (Bool, String?, Any?)->()) {
        // 先清空
        alipayList.removeAll()
        // 传参
        let param: [String: Any]? = getAlipayInstalmentListData()
        // 请求
        FKYRequestService.sharedInstance()?.requestForAlipayInstalmentList(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard success else {
                var msg = error?.localizedDescription ?? "请求失败"
                if let err = error {
                    let e = err as NSError
                    // token过期
                    if e.code == 2 {
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                // 失败回调
                block(false, msg, nil)
                return
            }
            // 请求成功
            if let list = model as? [COAlipayInstallmentModel] {
                // 获取花呗分期详情成功
                
                // 无数据
                guard list.count > 0 else {
                    // 获取花呗分期详情失败
                    block(false, nil, nil)
                    return
                }
                
                // 保存
                if let item: COAlipayInstallmentModel = list.first, let arr = item.hbInstalmentInfoDtoList, arr.count > 0 {
                    strongSelf.alipayList.append(contentsOf: arr)
                }
                
                // 成功回调
                block(true, nil, nil)
                return
            }
            // 获取花呗分期详情失败
            block(false, nil, nil)
        })
    }
    
    // 上次在线支付方式类型请求
    func requestForSavedOnlinePayType(_ block: @escaping (Bool, String?, Any?)->()) {
        // 先清空
        alipayList.removeAll()
        // 传参
        let param: [String: Any]? = getSaveOnlinePayTypeData()
        // 请求
        FKYRequestService.sharedInstance()?.requestForSavedOnlinePayType(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard success else {
                var msg = error?.localizedDescription ?? "请求失败"
                if let err = error {
                    let e = err as NSError
                    // token过期
                    if e.code == 2 {
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                // 失败回调
                block(false, msg, nil)
                return
            }
            // 请求成功
            if let data = response as? NSDictionary {
                // 获取在线支付方式成功
                if let list: [NSDictionary] = data["data"] as? [NSDictionary], list.count > 0 {
                    if let item: NSDictionary = list.first, let pId: NSNumber = item["payTypeId"] as? NSNumber, pId.intValue > 0 {
                        // 保存
                        strongSelf.payTypeId = pId.intValue
                        // 成功回调
                        block(true, nil, nil)
                        return
                    }
                }
            }
            // 获取在线支付方式失败
            block(false, nil, nil)
        })
    }
    // 快捷支付获取流水号并且自动发送短信
    func requestForBankQuickPayFlowId(_ block: @escaping (Bool, String?, Any?)->()) {
        // 传参
        let param: [String: Any]? = getQuickPayFlowdData()
        // 请求
        FKYRequestService.sharedInstance()?.requestForQuickPayFlowId(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard success else {
                var msg = error?.localizedDescription ?? "请求失败"
                if let err = error {
                    let e = err as NSError
                    // token过期
                    if e.code == 2 {
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                // 失败回调
                block(false, msg, nil)
                return
            }
            // 请求成功
            if let data = response as? NSDictionary {
                // if let payInfoDic = data["data"] as? NSDictionary{
                let statusCode: Int? = data["statusCode"] as? Int
                if let code = statusCode,code == 0{
                    //正常
                    // 获取流水号成功
                    if let payInfoDic = data["data"] as? NSDictionary {
                        let flowId: String? = payInfoDic["requestNo"] as? String
                        if let payFlowId = flowId, payFlowId.isEmpty == false {
                            strongSelf.quickPayFlowId = payFlowId
                        }
                        let mobile: String? = payInfoDic["mobile"] as? String
                        if let payPhoneNum  = mobile , payPhoneNum.isEmpty == false {
                            strongSelf.quickPayPhoneNum = payPhoneNum
                        }
                        block(true, nil, nil)
                        return
                    }
                }else{
                    //获取失败
                    let msg: String? = data["msg"] as? String
                    if let errMsg = msg, errMsg.isEmpty == false {
                        block(false, errMsg, nil)
                        return
                    }
                }
                
                // }
                
            }
            // 获取流水号成功失败
            block(false, nil, nil)
        })
    }
    
    //
    //快捷支付 支付确认接口
    func confirmForBankQuickPay(_ block: @escaping (Bool, String?, Any?)->()) {
        // 传参
        let param: [String: Any]? = confirmQuickPayData()
        // 请求
        FKYRequestService.sharedInstance()?.requestForQuickPayConfirm(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard success else {
                var msg = error?.localizedDescription ?? "请求失败"
                if let err = error {
                    let e = err as NSError
                    // token过期
                    if e.code == 2 {
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                // 失败回调
                block(false, msg, nil)
                return
            }
            // 请求成功
             block(true, nil, nil)
             return
        })
    }
    
}
