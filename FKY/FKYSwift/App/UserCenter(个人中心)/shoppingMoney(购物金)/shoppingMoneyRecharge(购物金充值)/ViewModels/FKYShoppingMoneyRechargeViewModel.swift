//
//  FKYShoppingMoneyRechargeViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYShoppingMoneyRechargeViewModel: NSObject, HandyJSON {

    override required init() { }

    /// 充值活动列表
    var rechargeActivityList: [FKYRechargeActivityInfoModel] = []

    /// 数据列表CellList
    var cellList: [FKYShoppingMoneyRechargeCellModel] = []

    /// 点击去充值之后接口请求成功返回的信息

    /// 账户企业id
    var accountEnterprise: Int = 0

    /// 账户id
    var accountId: Int = 0

    /// 实际充值支付金额
    var actualChargeAmount: String = ""

    /// 充值金额
    var chargeAmount: String = ""

    /// 充值状态
    var chargeStatus: Int = 0

    /// 流水号
    var dealSeqNo: String = ""

    /// 操作类型
    var type: String = ""

}

//MARK: - 网络请求
extension FKYShoppingMoneyRechargeViewModel {

    /// 整理数据
    func processingData() {
        self.cellList.removeAll()
        for (index, model) in self.rechargeActivityList.enumerated() {
            let cellModel = FKYShoppingMoneyRechargeCellModel()
            if index == 0 {
                cellModel.isSelected = true
            }
            cellModel.rechargeModel = model
            self.cellList.append(cellModel)
        }
    }

    /// 整理支付成功的返回数据
    func processingToPayData(dic: [String: Any]) {
        var temp = self
        JSONDeserializer.update(object: &temp, from: dic)
    }
}

//MARK: - 网络请求
extension FKYShoppingMoneyRechargeViewModel {
    ///预充值，生成流水日志
    func requestPrecharge(block: @escaping (_ isSuccess: Bool, _: String) -> ()) {
        var activityId = ""
        var chargeAmount: Float = 0
        for cellModel in self.cellList {
            if cellModel.isSelected {
                activityId = cellModel.rechargeModel.thresholdId
                chargeAmount = cellModel.rechargeModel.threshold
            }
        }
        let paramDic = ["enterpriseId": FKYLoginAPI.currentUser()?.ycenterpriseId ?? "",
            "activityId": activityId,
            "chargeAmount": chargeAmount] as [String: Any]
        FKYRequestService.sharedInstance()?.requestPostForShoppingMoneyPrecharge(withParam: paramDic, completionBlock: { [weak self] (success, error, response, model) in
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
            weakSelf.processingToPayData(dic: responseDic)
            block(true, "")
        })
    }

    /// 获取充值金额列表
    func requestRechargeInfo(block: @escaping (_ isSuccess: Bool, _: String) -> ()) {
        FKYRequestService.sharedInstance()?.requestPostForRechargeActivityInfo(withParam: nil, completionBlock: { [weak self] (success, error, response, model) in
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
            guard let rechargeList = response as? [Any] else {
                block(false, "数据解析失败")
                return
            }
            weakSelf.rechargeActivityList.removeAll()
            let temp = [FKYRechargeActivityInfoModel].deserialize(from: rechargeList)
            if let temp1 = temp as? [FKYRechargeActivityInfoModel] {
                weakSelf.rechargeActivityList = temp1
                weakSelf.processingData()
                block(true, "")
            } else {
                block(false, "数据解析失败")
            }

        })
    }
}

//MARK: - cellModel
class FKYShoppingMoneyRechargeCellModel: NSObject {

    /// 是否被选中
    var isSelected = false

    /// 当前item的数据
    var rechargeModel: FKYRechargeActivityInfoModel = FKYRechargeActivityInfoModel()
}
