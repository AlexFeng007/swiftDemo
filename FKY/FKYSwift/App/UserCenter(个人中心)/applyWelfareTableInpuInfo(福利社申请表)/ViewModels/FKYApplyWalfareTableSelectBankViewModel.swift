//
//  FKYApplyWalfareTableSelectBankViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/14.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class FKYApplyWalfareTableSelectBankViewModel: NSObject {
    /// 银行列表
    var bankList:[bankModel] = []
    
}


//MARK: - 网络请求
extension FKYApplyWalfareTableSelectBankViewModel{
    /// 获取银行列表
    func getBankList(block: @escaping (Bool, String?)->()){
        FKYRequestService.sharedInstance()?.postRequestBankList(nil, completionBlock: { [weak self]  (success, error, response, model) in
            guard let strongSelf = self else {
                 block(false,"内存泄露")
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
                block(false, msg)
                return
            }
            
            guard let responseArr = response as? [Any] else{
                 block(false,"数据解析错误")
                 return
            }
            let bankList = [bankModel].deserialize(from: responseArr)
            if let modelList = bankList as? [bankModel] {
                strongSelf.bankList = modelList
                block(true,"")
            }else{
                block(true,"数据解析错误")
            }
        })
    }
}


class bankModel:NSObject, HandyJSON{
    required override init() {}
    /// 银行ID
    var bankCode = ""
    
    /// 银行名称
    var bankCodeName = ""
}
