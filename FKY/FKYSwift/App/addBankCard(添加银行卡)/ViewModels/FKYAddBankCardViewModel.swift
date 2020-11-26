//
//  FKYAddBankCardViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYAddBankCardViewModel: NSObject {

    /// 卡编辑类型  1绑卡 2换卡
    var editerType = 0

    /// 协议选中状态
    var protocolSelectedStatus = true

    ///cell数据list
    var cellModelList: [FKYAddBankCardCellModel] = []

    /// 提交给后台的入参
    var submitParam = ["realName": "", //用户真实姓名
        "idCardNo": "", //身份证号
        "bankCardNo": "", //银行卡号
        "mobile": "", //银行预留手机号
        "codeRequestNo": ""//短信验证码下发请求流水号
    ]

}

//MARK: - 整理数据
extension FKYAddBankCardViewModel {

    /// 处理数据
    func ProcessingData() {
        self.cellModelList.removeAll()

        let tipCell = FKYAddBankCardCellModel()
        tipCell.cellType = .tipCell
        var isCanEditer = false
        if self.editerType == 1 { // 绑卡
            isCanEditer = true
        } else if self.editerType == 2 { // 换卡
            isCanEditer = false
        }

        let inputPeopleCell = FKYAddBankCardCellModel.init(cellType: .inputCell, titleText: "持卡人", holderText: "持卡人姓名", inputText: submitParam["realName"]!, paramKey: "realName", isFirstCell: true, isLastCell: false, isCanInput: isCanEditer)

        let inputIDNOCell = FKYAddBankCardCellModel.init(cellType: .inputCell, titleText: "身份证", holderText: "请输入本人证件号码", inputText: submitParam["idCardNo"]!, paramKey: "idCardNo", isFirstCell: false, isLastCell: false, isCanInput: isCanEditer)

        let inputBankCarNOCell = FKYAddBankCardCellModel.init(cellType: .inputCell, titleText: "卡号", holderText: "请输入本人储蓄卡号", inputText: "", paramKey: "bankCardNo", isFirstCell: false, isLastCell: false, isCanInput: true)
        inputBankCarNOCell.showTipBtn = true

        let inputPhoneNOCell = FKYAddBankCardCellModel.init(cellType: .inputCell, titleText: "手机号", holderText: "请输入银行预留手机号", inputText: "", paramKey: "mobile", isFirstCell: false, isLastCell: true, isCanInput: true)

        let confirmCell = FKYAddBankCardCellModel()
        confirmCell.cellType = .confirmCell

        self.cellModelList.append(contentsOf: [tipCell, inputPeopleCell, inputIDNOCell, inputBankCarNOCell, inputPhoneNOCell, confirmCell])
    }

    /// 是否填写符合要求并且完整
    func isInputFull() -> (isSuccess: Bool, msg: String) {

        var isFull = true
        var msg = ""

        /*
        if self.submitParam["codeRequestNo"]!.isEmpty == false {//短信验证码下发请求流水号
            
        }else{
            isFull = false
            msg = "codeRequestNo参数异常"
        }
        */

        if self.protocolSelectedStatus == false { /// 用户没有勾选协议
            isFull = false
            msg = "请阅读并勾选《1药城快捷支付协议》"
        }

        if self.submitParam["mobile"]!.isEmpty == false { //银行预留手机号
            let mobile = "^[0-9]{11}"
            let regextestmobile = NSPredicate(format: "SELF MATCHES %@", mobile)
            if (regextestmobile.evaluate(with: self.submitParam["mobile"]!) == true)
            {
                if self.submitParam["mobile"]!.count != 11{// 不是11位手机号
                    isFull = false
                    msg = "请输入正确手机号"
                }
            }
            else
            {
                isFull = false
                msg = "请输入正确手机号"
            }
        } else {
            isFull = false
            msg = "请填写手机号"
        }

        if self.submitParam["bankCardNo"]!.isEmpty == false { //银行卡号

        } else {
            isFull = false
            msg = "请填写银行卡号"
        }

        if self.editerType == 1 { // 绑卡
            if self.submitParam["idCardNo"]!.isEmpty == false { //身份证号

            } else {
                isFull = false
                msg = "请填写身份证号"
            }

            if (self.submitParam["realName"]!).isEmpty == false { //用户真实姓名

            } else {
                isFull = false
                msg = "请填写真实姓名"
            }
        }

        return (isFull, msg)
    }

}

//MARK: - 网络请求
extension FKYAddBankCardViewModel {

    /// 修改银行卡信息
    func updataBankCardInfo(bankcardNo: String, moblie: String, block: @escaping (Bool, String?) -> ()) {
        FKYRequestService.sharedInstance()?.postUpdataBankCardInfo(["bankcardNo": bankcardNo, "moblie": moblie], completionBlock: { [weak self] (success, error, response, model) in
                guard let _ = self else {
                    block(false, "内存泄露")
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

                block(true, "")
            })
    }

    /// 验证手机验证码
    func checkVerificationCod(phoneNum: String, verificationCode: String, block: @escaping (Bool, String?, _ codeRequestNo: String) -> ()) {
        FKYRequestService.sharedInstance()?.postCheckVerificationCod(["mobile": phoneNum, "verificationCode": verificationCode], completionBlock: { [weak self] (success, error, response, model) in
                guard let _ = self else {
                    block(false, "内存泄露", "")
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
                    block(false, msg, "")
                    return
                }

                guard let responseStr = response as? String else {
                    block(false, "数据解析错误", "")
                    return
                }

                block(true, "", responseStr)
            })
    }

    /// 绑定银行卡界面发送短信验证码
    func sendVerificationCodeInBandingView(phoneNum: String, block: @escaping (Bool, String?) -> ()) {
        FKYRequestService.sharedInstance()?.postSendVerificationCode(inBandingView: ["mobile": phoneNum], completionBlock: { [weak self] (success, error, response, model) in
                guard let _ = self else {
                    block(false, "内存泄露")
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

                block(true, "")

            })
    }

    /// 提交银行卡信息
    func submitBankCardInfo(block: @escaping (Bool, String?) -> ()) {
        FKYRequestService.sharedInstance()?.postSubmitBankCardInfo(self.submitParam, completionBlock: { [weak self] (success, error, response, model) in
            guard let _ = self else {
                block(false, "内存泄露")
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

            block(true, "")
        })
    }

}








enum FKYAddBankCardCellType {
    case noType
    case tipCell
    case inputCell
    case confirmCell
}

// MARK: - cellModel
class FKYAddBankCardCellModel: NSObject {

    /// cell类型
    var cellType: FKYAddBankCardCellType = .noType

    /// title文字
    var titleText = ""

    /// holder文字
    var holderText = ""

    /// 输入的文字
    var inputText = ""

    /// 传给后台的key
    var paramKey = ""

    /// 是否是第一个cell
    var isFirstCell = false

    /// 是否是最后一个cell
    var isLastCell = false

    /// 是否展示提示按钮
    var showTipBtn = false

    /// 是否允许输入
    var isCanInput = false

    /// 银行卡号是否需要打码
    var isNeedMSK = true

    convenience init(cellType: FKYAddBankCardCellType, titleText: String, holderText: String, inputText: String, paramKey: String, isFirstCell: Bool, isLastCell: Bool, isCanInput: Bool) {
        self.init()
        self.cellType = cellType
        self.titleText = titleText
        self.holderText = holderText
        self.inputText = inputText
        self.paramKey = paramKey
        self.isFirstCell = isFirstCell
        self.isLastCell = isLastCell
        self.isCanInput = isCanInput
    }

}
