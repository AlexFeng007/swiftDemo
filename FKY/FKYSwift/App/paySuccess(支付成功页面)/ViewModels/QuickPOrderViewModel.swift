//
//  QuickPOrderViewModel.swift
//  FKY
//
//  Created by 寒山 on 2020/7/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class QuickPOrderViewModel: NSObject {
    /// 获取抽奖信息
    @objc func requestQuickPayStateInfo(orderNo: String, block: @escaping (Bool, String?) -> ()) {
        let param = ["flowId": orderNo]
        FKYRequestService.sharedInstance()?.requestForQuickPayStatus(withParam: param as [AnyHashable: Any], completionBlock: { [weak self] (success, error, response, model) in
                guard let _ = self else {
                    block(false, "支付失败")
                    return
                }
                guard success else {
                    // 失败
                    var msg = error?.localizedDescription ?? "支付失败"
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
                block(true, "支付成功")
      })
    }
}
//if let data = response as? NSDictionary {
//    if let dic = data["RtnInfo"] as? NSDictionary{
//        let statusCode: Int? = dic["rtn_code"] as? Int
//        if let code = statusCode,code == 0{
//            block(true, "支付成功")
//            return
//        }else{
//            //支付失败
//            let msg: String? = dic["rtn_msg"] as? String
//            if let errMsg = msg, errMsg.isEmpty == false {
//                block(false, errMsg)
//                return
//            }
//        }
//    }
//}
//block(false, "支付失败")
