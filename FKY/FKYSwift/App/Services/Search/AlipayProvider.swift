//
//  AlipayProvider.swift
//  FKY
//
//  Created by mahui on 2016/11/12.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import RxSwift

class AlipayProvider: NSObject {
    //
    var resultStr : String?

    fileprivate lazy var payService: FKYPublicNetRequestSevice? = {
        return FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice
    }()
    
    override  init() {
        
    }
    
    @objc func alipaySignWith(_ payFlowId:String, totalPay:Float,orderType:String = "", callback:@escaping (_ resultStr : String)->()) {
        let yctoken: NSString? = UserDefaults.standard.value(forKey: "user_token") as? NSString
        let s =  "1药城(\(payFlowId))"
        let m = String.init(format: "%.2f", totalPay)
        var appUuid = ""
        if let deviceId = UIDevice.readIdfvForDeviceId(), deviceId.isEmpty == false {
            appUuid = deviceId
        }
        let dic = ["body": "ios", "subject": s, "total_fee": "\(m)", "out_trade_no": payFlowId, "appUuid": appUuid, "ycToken":(yctoken ?? "") as String,"orderType":orderType] as [String : Any]
        
        _ = self.payService?.getAppPayParamsBlock(withParam: dic, completionBlock: {(responseObject, anError)  in
            if anError == nil {
                if let data = responseObject as? String {
                    self.resultStr = data
                }
                if self.resultStr == nil {
                    self.resultStr = ""
                }
                callback(self.resultStr!)
            }
            else {
                if let err = anError {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        FKYAppDelegate!.showToast("用户登录过期, 请重新手动登录")
                    }
                }
                callback("")
            }
        })
    }
    
    /// 花呗
    @objc func alipayHuaBeiInstallment(payFlowId: String,orderType:String = "", callback:@escaping (_ resultStr : String)->()) {
        let yctoken: NSString? = UserDefaults.standard.value(forKey: "user_token") as? NSString
        var appUuid = ""
        if let deviceId = UIDevice.readIdfvForDeviceId(), deviceId.isEmpty == false {
            appUuid = deviceId
        }
        let param = ["out_trade_no": payFlowId, "ycToken": yctoken ?? "", "appUuid": appUuid,"orderType":orderType] as [String : Any]
        _ = self.payService?.getAlipayHuaBeiPayParamsBlock(withParam: param, completionBlock: { (responseObj, anError) in
            if anError == nil {
                if let data = responseObj as? String {
                    self.resultStr = data
                }
                if self.resultStr == nil {
                    self.resultStr = ""
                }
                callback(self.resultStr!)
            }else{
                print("error_____\(String(describing: anError))")
                var returnMsg:String = ""
                if let error = anError as NSError? {
                    if let errorCode = error.userInfo["rtn_code"] {
                        returnMsg += "code,"
                        returnMsg += "\(errorCode),"
                    }
                    if let msg = error.userInfo["rtn_msg"] {
                        returnMsg += "msg,"
                        returnMsg += "\(msg),"
                    }
                    callback(returnMsg)
                }
            }
        })
    }
    
    /// 花呗分期
    @objc func huaBeiInstallment(payFlowId: String, num: String,orderType:String = "", callback:@escaping (_ resultStr : String)->()) {
        let yctoken: NSString? = UserDefaults.standard.value(forKey: "user_token") as? NSString
        var appUuid = ""
        if let deviceId = UIDevice.readIdfvForDeviceId(), deviceId.isEmpty == false {
            appUuid = deviceId
        }
        let param = ["out_trade_no": payFlowId, "hb_fq_num": num, "ycToken": yctoken ?? "", "appUuid": appUuid,"orderType":orderType] as [String : Any]
        _ = self.payService?.getHuaBeiPayParamsBlock(withParam: param, completionBlock: { (responseObj, anError) in
            if anError == nil {
                if let data = responseObj as? String {
                    self.resultStr = data
                }
                if self.resultStr == nil {
                    self.resultStr = ""
                }
                callback(self.resultStr!)
            }else{
                print("error_____\(String(describing: anError))")
            }
        })
    }
}


class WXPayProvider: NSObject {
    //
    var resultStr : String?
    
    fileprivate lazy var payService: FKYPublicNetRequestSevice? = {
        return FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice
    }()
    
    override  init() {
        //
    }
    
    @objc func WXPaySignWith(_ payFlowId:String,orderType:String = "" , callback:@escaping (_ wxInfoModel : WXPayInfoModel)->(), failure:@escaping (_ reason:String?)->()) {
        let yctoken: NSString? = UserDefaults.standard.value(forKey: "user_token") as? NSString
        var appUuid = ""
        if let deviceId = UIDevice.readIdfvForDeviceId(), deviceId.isEmpty == false {
            appUuid = deviceId
        }
        let dic = ["out_trade_no": payFlowId, "ycToken": (yctoken ?? ""), "appUuid": appUuid,"orderType":orderType] as [String : Any]
        _ = self.payService?.getAppWechatPayParamsBlock(withParam: dic, completionBlock: {(responseObject, anError)  in
            if anError == nil {
                if let data = responseObject as? NSDictionary {
                    let model = data.mapToObject(WXPayInfoModel.self)
                    callback(model)
                }
            }
            else {
                var errMsg = anError?.localizedDescription ?? "请求失败"
                if let err = anError {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        errMsg = "用户登录过期, 请重新手动登录"
                    }
                }
                failure(errMsg)
            }
        })
    }
}

