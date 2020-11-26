//
//  RCSendInfoViewModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/22.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  回寄信息界面ViewModel

import UIKit

class RCSendInfoViewModel: NSObject {
    // MARK: - Property
    
    // 退换货申请ID...<不能为空>
    var applyId: String?
    
    // 是否线上订单
    var onlineFlag: Bool = false
    
    // 回寄信息相关内容
    var sendCompany: RCSendCompanyModel?
    var sendOrder: String?
    var bankName: String?
    var bankAccount: String?
    var userName: String?
    
    // 选中的快递公司索引...<默认未选中>
    var index4Company: Int = -1
    
    
    // MARK: - Public
    
    // 判断用户输入信息是否完整
    func checkSendInfoStatus(_ online: Bool) -> (status: Int, msg: String) {
        onlineFlag = online
        
        guard index4Company >= 0, sendCompany != nil else {
            return (1, "请选择快递公司")
        }
        guard let order = sendOrder, order.isEmpty == false else {
            return (2, "请输入快递单号")
        }
        guard order.count >= 8, order.count <= 30 else {
            return (6, "快递单号长度不符")
        }
        guard online == false else {
            // 线上订单
            return (0, "ok")
        }
        
        guard let bName = bankName, bName.isEmpty == false else {
            return (3, "请输入开户行")
        }
        guard bName.count >= 2, bName.count <= 50 else {
            return (7, "开户行长度不符")
        }
        guard let bAccount = bankAccount, bAccount.isEmpty == false else {
            return (4, "请输入银行账户")
        }
        guard bAccount.count >= 10, bAccount.count <= 30 else {
            return (8, "银行账户长度不符")
        }
        guard let uName = userName, uName.isEmpty == false else {
            return (5, "请输入开户名")
        }
        guard uName.count >= 2, uName.count <= 50 else {
            return (9, "开户名长度不符")
        }
        // 线下订单
        return (0, "ok")
    }
}

// MARK: - Private
extension RCSendInfoViewModel {
    // 封装入参...<提交回寄信息>
    fileprivate func getSubmitData() -> Dictionary<NSString, Any>? {
        // 退换货申请ID
        var aid = ""
        if let applyId = applyId, applyId.isEmpty == false {
            aid = applyId
        }
        // 快递ID
        var sid = ""
        if let sendCompany = sendCompany, let carrierId = sendCompany.carrierId, carrierId.isEmpty == false {
            sid = carrierId
        }
        // 快递名称
        var sname = ""
        if let sendCompany = sendCompany, let carrierName = sendCompany.carrierName, carrierName.isEmpty == false {
            sname = carrierName
        }
        // 快递单号
        var scode = ""
        if let sendOrder = sendOrder, sendOrder.isEmpty == false {
            scode = sendOrder
        }
        // 开户行名称
        var bname = ""
        if let bankName = bankName, bankName.isEmpty == false {
            bname = bankName
        }
        // 银行卡号
        var baccount = ""
        if let bankAccount = bankAccount, bankAccount.isEmpty == false {
            baccount = bankAccount
        }
        // 开户名
        var uname = ""
        if let userName = userName, userName.isEmpty == false {
            uname = userName
        }

        let param: [NSString: Any] = ["applyId":aid, "expressId":sid, "expressName":sname, "expressNo":scode, "bankName":bname, "bankCardNo":baccount, "accountName":uname]
        return param
    }
    
    // 封装入参...<订阅物流信息>
    fileprivate func getSubscribeData(_ province: String?, _ city: String?) -> Dictionary<NSString, Any>? {
        // 快递ID
        var sid = ""
        if let sendCompany = sendCompany, let carrierId = sendCompany.carrierId, carrierId.isEmpty == false {
            sid = carrierId
        }
        // 快递单号
        var scode = ""
        if let sendOrder = sendOrder, sendOrder.isEmpty == false {
            scode = sendOrder
        }
        // 省
        var pname = ""
        if let province = province, province.isEmpty == false {
            pname = province
        }
        // 市
        var cname = ""
        if let city = city, city.isEmpty == false {
            cname = city
        }
        
        let dic: [NSString: Any] = ["carrierCode":sid, "waybillCode":scode, "provinceName":pname, "cityName":cname]
        let param: [NSString: Any] = ["subscribeKD100DtoList":[dic]]
        return param
    }
}

// MARK: - Request
extension RCSendInfoViewModel {
    // 提交回寄信息...<包含解析>
    func submitSendInfo(_ aid: String?, block: @escaping (Bool, String?)->()) {
        // 保存
        applyId = aid
        // 传参
        let param: [NSString: Any]? = getSubmitData()
        // 请求
        FKYRequestService.sharedInstance()?.requestForSubmitSendInfo(withParam: param, completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "提交失败"
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
            guard let res = response as? NSDictionary else {
                // 无返回值
                block(false, "提交失败")
                return
            }
            // 有返回值<解析>
            let code = res["code"] as? String
            let msg = res["message"] as? String
            guard let co = code, let value = Int(co), value > 0 else {
                // 操作失败...<code=0失败；code>0成功>
                block(false, msg ?? "提交失败")
                return
            }
            // 操作成功
            block(true, "提交成功")
        })
    }
    
    // 订阅物流信息
    func subcribeSendInfo(_ province: String?, _ city: String?, block: @escaping (Bool, String?)->()) {
        // 传参
        let param: [NSString: Any]? = getSubscribeData(province, city)
        // 请求
        FKYRequestService.sharedInstance()?.requestForSubscribeSendInfo(withParam: param, completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "订阅失败"
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
            // 操作成功
            block(true, "订阅成功")
        })
    }
    
    // 请求快递公司列表...<已自动解析>...<未使用>
    class func requestSendCompanyList(_ param: Dictionary<String, Any>?, block: @escaping RequestServiceBlock) {
        FKYRequestService.sharedInstance()?.requestForSendCompanyList(withParam: param, completionBlock: { (success, error, response, model) in
            block(success, error, response, model)
        })
    }
}
