//
//  FKYshoppingMoneyBalanceViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYshoppingMoneyBalanceViewModel: NSObject {

    /// 余额信息
    var shoppingMoneyInfo: FKYShoppingMoneyBalanceInfoModel = FKYShoppingMoneyBalanceInfoModel()

    /// 所有类型的记录
    var allRacord: [FKYShoppingMoneyRecordModel] = []

    /// 收入记录
    var incomeRecord: [FKYShoppingMoneyRecordModel] = []

    /// 支出记录
    var expendRacord: [FKYShoppingMoneyRecordModel] = []

    /// 当前页
    /// 所有
    var currentPage1 = 1
    /// 收入
    var currentPage2 = 1
    /// 支出
    var currentPage3 = 1

    /// 总页数 设置成2是为了保证第一次网络请求能正常发出，请求成功后会刷新为真实的页数
    /// 所有类型
    var totlePageCount1 = 2
    /// 收入
    var totlePageCount2 = 2
    /// 支出
    var totlePageCount3 = 2

}


//MARK: - 网络请求
extension FKYshoppingMoneyBalanceViewModel {

    /// 查询购物金流水 expend 是否查收入 income 是否查支出 查全部 双false
    func requestShoppingMoneyRecord(currentPage: Int, expend: Bool, income: Bool, block: @escaping (_ isSuccess: Bool, _: String) -> ()) {
        let paramDic = ["expend": expend,
            "income": income,
            "page": currentPage,
            "pageSize": 10,
            "enterpriseId": FKYLoginAPI.currentUser()?.ycenterpriseId ?? ""] as [String: Any]
        FKYRequestService.sharedInstance()?.requestPostForShoppingMoneyRecord(withParam: paramDic, completionBlock: { [weak self] (success, error, response, model) in
            guard let weakSelf = self else {
                block(false, "内存溢出")
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

            guard let responseDic = response as? [String: Any] else {
                block(false, "数据解析失败")
                return
            }

            let temp = [FKYShoppingMoneyRecordModel].deserialize(from: responseDic["list"] as? [Any])
            if expend == false, income == false { // 全部记录
                if let temp1 = temp as? [FKYShoppingMoneyRecordModel] {
                    weakSelf.allRacord += temp1
                    weakSelf.currentPage1 = responseDic["page"] as! Int
                    weakSelf.totlePageCount1 = responseDic["pageCount"] as! Int
                } else {
                    block(false, "数据解析失败")
                }
            } else if expend == false, income == true { // 收入记录
                if let temp1 = temp as? [FKYShoppingMoneyRecordModel] {
                    weakSelf.incomeRecord += temp1
                    weakSelf.currentPage2 = responseDic["page"] as! Int
                    weakSelf.totlePageCount2 = responseDic["pageCount"] as! Int
                } else {
                    block(false, "数据解析失败")
                }
            } else if expend == true, income == false { // 支出记录
                if let temp1 = temp as? [FKYShoppingMoneyRecordModel] {
                    weakSelf.expendRacord += temp1
                    weakSelf.currentPage3 = responseDic["page"] as! Int
                    weakSelf.totlePageCount3 = responseDic["pageCount"] as! Int
                } else {
                    block(false, "数据解析失败")
                }
            }
            block(true, "")
        })
    }

    /// 查询购物金信息
    func requestShoppingMoneyInfo(block: @escaping (_ isSuccess: Bool, _: String) -> ()) {
        FKYRequestService.sharedInstance()?.requestPostForShoppingMoneyInfo(withParam: ["enterpriseId": FKYLoginAPI.currentUser()?.ycenterpriseId ?? ""], completionBlock: { [weak self] (success, error, response, model) in
                guard let weakSelf = self else {
                    block(false, "内存溢出")
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

                guard let responseDic = response as? [String: Any] else {
                    block(false, "数据解析失败")
                    return
                }
                weakSelf.shoppingMoneyInfo = FKYShoppingMoneyBalanceInfoModel.deserialize(from: responseDic) ?? FKYShoppingMoneyBalanceInfoModel()
                block(true, "")

            })
    }
}
