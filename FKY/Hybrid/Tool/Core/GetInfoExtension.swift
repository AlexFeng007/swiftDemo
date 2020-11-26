//
//  GetInfoExtension.swift
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  【基本信息】模块供js调用方法

import Foundation

extension GLBridge {
    
    /**
     数据示例：
     
     gl://synLocaltion?callid=11111&param={}
     参数说明：无
     
     数据返回:
     
     数据示例：
     
     callback({
     "callid":11111,
     "errcode":0,
     "errmsg":"ok",
     "data": {"privonceName": "广东", "code": "123", "isCommon": "0"}
     })
     data参数说明：
     
     privonceName：注册用户分站名
     code：注册用户分站code
     isCommon：是否通用分站
     */
    func synLocaltion(_ request: GLJsRequest) {
        let model: FKYLocationModel = FKYLocationService().currentLoaction
        
        let data:Dictionary = [
            "privonceName": StringValue(model.substationName),
            "code": StringValue(model.substationCode),
            "isCommon": StringValue(model.isCommon)
        ];
        
        let res = GLBridgeResponse.reponse(withErrCode: .OK, data: data)
        interactiveDelegate.sendBridgeResponse(toJs: res, callbackId: request.callbackId)
    }
    
    /**
     返回app写入到webview的cookie的JSON字符串
     
     gl://getAppCookie?callid=11111&param={}
     
     callback({
     "callid":11111,
     "errcode":0,
     "errmsg":"ok",
     "data":{
     "ycusertype": "xxxx",
     "ycuserName": "xxxx",
     ....
     }
     })
     
     */
    func getAppCookie(_ request: GLJsRequest) {
        let data = GLCookieSyncManager.shared().hybridCookieDictionary()
        let res = GLBridgeResponse.reponse(withErrCode: .OK, data: data)
        interactiveDelegate.sendBridgeResponse(toJs: res, callbackId: request.callbackId)
    }
}
