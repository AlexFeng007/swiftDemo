//
//  FKYRebateDetailViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/2/24.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYRebateDetailViewModel: NSObject {
    /// 数据列表
    var sellerTypeList = [FKYRebateSellerTypeModel]()
    
    /// 是否共享返利金
    var isShareRebate = ""
}

// MARK: - 网络请求
extension FKYRebateDetailViewModel{
    /// 获取返利金详情
    func requestRebateInfo(block: @escaping (_ isSuccess:Bool, _ Msg:String?)->()){
        FKYRequestService.sharedInstance()?.requestForGetRebateDetailList(withParam: nil, completionBlock: { [weak self] (success, error, response, model) in
            guard let selfStrong = self else {
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
            
            // 请求成功 整理数据
            if let data = response as? NSDictionary {
                selfStrong.sellerTypeList.removeAll()
                selfStrong.isShareRebate = data["isShareRebate"] as! String
                let listAmount = data["listAmount"] as! [[String: AnyObject]]
                for dic in listAmount{
                    let sellerType = (dic as NSDictionary).mapToObject(FKYRebateSellerTypeModel.self)
                    
                    if sellerType.platformRebateType == "1"{// 平台商家通用
                        sellerType.subTitleText = "平台商家通用，自营商家除外"
                        sellerType.cellType = "2"
                    }else{
                        if sellerType.ziyingCommonUse == "1"{// 自营商家通用
                            sellerType.subTitleText = "可用商家"
                            sellerType.cellType = "1"
                            let couldBuyList = data["couldBuyList"] as! [[String: AnyObject]]
                            for dic_t in couldBuyList{
                                let sellerModel = (dic_t as NSDictionary).mapToObject(FKYRebteSellerModel.self)
                                sellerType.sellerList.append(sellerModel)
                            }
                        }else{// 单商家
                            sellerType.subTitleText = "可用商家"
                            sellerType.cellType = "3"
                        }
                    }
                    selfStrong.sellerTypeList.append(sellerType)
                }
                block(true,"获取成功")
            }
        })
    }
}
