//
//  FKYCommandProvider.swift
//  FKY
//
//  Created by 寒山 on 2020/11/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYCommandProvider: NSObject {
    //一键入库口令解析
    func getEnterTreasuryCommendDecrypt(_ command:String?,_ commandType:String?,block: @escaping (Bool, String?, FKYCommandEnterTreasuryModel?)->()) {
        let dic = NSMutableDictionary()
        //dic["commend"] =  command
        dic["type"] =  commandType
        FKYRequestService.sharedInstance()?.requestForIpurchaseEntrancePopup(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
            guard let _ = self else {
                block(false, "请求失败",nil)
                return
            }
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
                block(false, msg,nil)
                return
            }
            // 请求成功
            if let dic = response as? NSDictionary {
                let commandInfo:FKYCommandEnterTreasuryModel = dic.mapToObject(FKYCommandEnterTreasuryModel.self)
                block(true, "获取成功",commandInfo)
                return
            }
            block(false, "获取失败",nil)
        })
    }
}
