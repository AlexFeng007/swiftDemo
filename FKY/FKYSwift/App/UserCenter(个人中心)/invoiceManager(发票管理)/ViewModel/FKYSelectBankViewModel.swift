//
//  FKYSelectBankViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/9.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSelectBankViewModel: NSObject {
    var bankList = [FKYBankModel]()
}

///MARK：- 网络请求
extension FKYSelectBankViewModel {

    func requestBankList(block: @escaping (_ isSuccess:Bool, _ Msg:String?)->()){
        FKYRequestService.sharedInstance()?.requestForBankList(withParam: nil, completionBlock: {[weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                block(false, "请求失败")
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
            strongSelf.disposalBankData(response: response!)
            block(true,"获取成功")
        })
    }
}

///MARK：- 清洗数据
extension FKYSelectBankViewModel {
    func disposalBankData(response:Any){
        self.bankList.removeAll()
        guard let array = response as? [Any] else {
            return
        }
        for item in array {
            guard let dic = item as? NSDictionary else {
                return
            }
            let model = dic.mapToObject(FKYBankModel.self)
            self.bankList.append(model)
        }
    }
}
