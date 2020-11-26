//
//  ActivityLogicExtension.swift
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  【活动】模块供js调用方法

import Foundation

extension GLBridge {
    
    /**
     查看详情/抽中奖品(原native.activitySignUp)
     
     接口调用:
     
     数据示例:
     
     gl://activitySignUp?callid=11111&param={
     }
     */
    func activitySignUp(_ request: GLJsRequest) {
        let service = FKYActivityWebService()
        service.signupActivity(in: self.viewController)
        
        let response = GLBridgeResponse.reponse(withErrCode: .OK, data: nil)
        interactiveDelegate.sendBridgeResponse(toJs: response, callbackId: request.callbackId)
    }
}
