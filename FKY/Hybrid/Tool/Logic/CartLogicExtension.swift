//
//  CartLogicExtension.swift
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  【购物流程】模块供js调用方法 

import Foundation

extension GLBridge {
    
    /**
     同步当前购物车数量信息(原FKYNative.cartNum)
     
     逻辑说明，更新本地购物车数量
     
     接口调用:
     
     数据示例：
     
     gl://synCartNumStatus?callid=11111&param={
     cartnum:100  //购物车当前总数量
     }
     数据返回:
     
     数据示例：
     
     callback({
     "callid":11111,
     "errcode":0,
     "errmsg":"ok",
     })
     */
    func synCartNumStatus(_ request: GLJsRequest) {
        guard let num = request.param(forKey: "cartnum") as? NSNumber else {
            sendWrongParamRespToJS(withCallbackid: request.callbackId)
            return
        }
        if num.intValue >= 0 {
            FKYCartModel.shareInstance().productCount = num.intValue
        }
        
        let response = GLBridgeResponse.reponse(withErrCode: .OK, data: nil)
        interactiveDelegate.sendBridgeResponse(toJs: response, callbackId: request.callbackId)
    }
}
