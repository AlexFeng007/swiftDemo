//
//  UISetExtension.swift
//  FKY
//
//  Created by Rabe on 17/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import Foundation

extension GLBridge {
    
    /**
     控制web容器是否吸顶（statuBar）
     gl://stickTop?callid=11111&param={"shouldStickTop": true}
     */
    func stickTop(_ request: GLJsRequest) {
        guard let shouldStickTopNumber = request.param(forKey: "shouldStickTop") as? NSNumber else {
            sendWrongParamRespToJS(withCallbackid: request.callbackId)
            return
        }
        let y = self.webView.frame.origin.y;
        var h = WH(64);
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                h = (insets?.top)! + 44;
            }
        }
        
        if y >= h { // 有导航栏显示时，不允许控制是否吸顶
            sendWrongParamRespToJS(withCallbackid: request.callbackId)
        }
        let shouldStickTop = shouldStickTopNumber.boolValue
        let vc = self.viewController as! GLViewController;
        vc.setWebViewStickTop(shouldStickTop)
        vc.setFakeStatusBarHidden(shouldStickTop)
        vc.isFakeStatusBarVisible = !shouldStickTop
        sendOkRespToJS(withData: nil, callbackid: request.callbackId)
    }
    
    /**
     控制web容器是否显示下拉刷新控件
     gl://setRefreshComponent?callid=11111&param={"visible": true}
     */
    func setRefreshComponent(_ request: GLJsRequest) {
        guard let visibleNumber = request.param(forKey: "visible") as? NSNumber else {
            sendWrongParamRespToJS(withCallbackid: request.callbackId)
            return
        }
        let visible = visibleNumber.boolValue
        let vc = self.viewController as! GLWebVC;
        vc.header.isHidden = visible;
        sendOkRespToJS(withData: nil, callbackid: request.callbackId)
    }
}
