//
//  RedPacketShowProvider.swift
//  FKY
//
//  Created by 寒山 on 2019/1/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class RedPacketShowProvider: NSObject {
    @objc static let sharedInstance = RedPacketShowProvider()

    //检查是否显示红包
    @objc func checkRedPacketShowInfo(block: @escaping (Bool, RedPacketInfoModel?,String?)->()) {
        // 请求
        FKYRequestService.sharedInstance()?.queryRedPacketShow(withParam: nil, completionBlock: { (success, error, response, model) in
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
                block(false, nil, msg)
                return
            }
            if let data = response as? NSDictionary {
                // 红包model
                let model: RedPacketInfoModel = data.mapToObject(RedPacketInfoModel.self)
                // 是否显示红包...<默认不显示>
                var showRedPacket = false
                //
                if let flag = model.showRedPacket {
                    showRedPacket = flag
                }
                block(showRedPacket, model, "")
                return
            }
            block(false, nil, "")
        })
    }
    
    //抽取红包
    @objc func checkRedPacketDrawInfo(block: @escaping (Bool,RedPacketDetailInfoModel?, String?)->()) {
        // 请求
        FKYRequestService.sharedInstance()?.queryRedPacketDraw(withParam: nil, completionBlock: { (success, error, response, model) in
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
                block(false, nil, msg)
                return
            }
            if let data = response as? NSDictionary {
                let model: RedPacketDetailInfoModel = data.mapToObject(RedPacketDetailInfoModel.self)
                block(true, model, "")
                return
            }
            block(false, nil, "")
        })
    }
}
