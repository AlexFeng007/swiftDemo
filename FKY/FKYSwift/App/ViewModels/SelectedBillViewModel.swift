//
//  SelectedBillViewModel.swift
//  FKY
//
//  Created by Rabe on 17/07/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// 发票审核状态枚举
enum ValueAddedTaxState: Int {
    case unknow = 0 // 默认未知
    case daiShenHe // 待审核
    case shenHeTongGuo // 审核通过
    case shenHeWeiTongGuo // 审核未通过
}

// 发票类型枚举
enum ValueAddedTaxType: Int {
    case notSelected = 0 // 默认未选择
    case special // 专用发票
    case ordinary // 普通发票
    case eleInvoice // 电子发票
}

class SelectedBillViewModel {
    // MARK: - Properties
    
    var state: ValueAddedTaxState = .unknow // 审核状态
    var type: ValueAddedTaxType = .notSelected // 类型
    var dataLoaded: Bool = false    // 是否已经请求服务端发票数据
    var invoiceModel: InvoiceModel? // 发票model
    var severModel: InvoiceModel?   // 服务端请求来的model，用于对比invoiceModel，如果发生改变才允许用户点击提交
    var taxpayerIdNecessity: Bool { // 纳税人识别号是否必填
        get {
            return invoiceModel?.license == "1" || type == .special
        }
    }
    var taxpayerIdNotVisible: Bool { // 不展示纳税人识别号一行【除个人中心进发票的一级页面外均用此逻辑判断】
        get {
            return state == .daiShenHe && invoiceModel?.license != "1" && invoiceModel?.taxpayerIdentificationNumber?.count == 0 && (type == .ordinary || type == .eleInvoice)
        }
    }
    var confirmResult: OutputResult { // 确定按钮点击后结果枚举
        get {
            if self.type == .ordinary {
                let name = (self.invoiceModel!.enterpriseName)!
                let id = (self.invoiceModel!.taxpayerIdentificationNumber)!
                if taxpayerIdNecessity || id.count > 0 {
                    // 纳税人识别号必填时才校验是否修改
//                    if severModel != nil && state != .daiShenHe {
//                        if name == severModel?.enterpriseName && id == severModel?.taxpayerIdentificationNumber {
//                            return .failed(message: "您未做任何修改！")
//                        }
//                    }
                    return SelectedBillProvider.shared.validateOrdinaryUat(name, id: id)
                }
                return SelectedBillProvider.shared.validateCompanyname(name)
            }
            else if self.type == .eleInvoice {
                let name = (self.invoiceModel!.enterpriseName)!
                let id = (self.invoiceModel!.taxpayerIdentificationNumber)!
                if taxpayerIdNecessity || id.count > 0 {
                    // 纳税人识别号必填时才校验是否修改
//                    if severModel != nil && state != .daiShenHe {
//                        if name == severModel?.enterpriseName && id == severModel?.taxpayerIdentificationNumber {
//                            return .failed(message: "您未做任何修改！")
//                        }
//                    }
                    return SelectedBillProvider.shared.validateOrdinaryUat(name, id: id)
                }
                return SelectedBillProvider.shared.validateCompanyname(name)
            }
            else if self.type == .special {
//                let name = (self.invoiceModel!.enterpriseName)!
//                let id = (self.invoiceModel!.taxpayerIdentificationNumber)!
                let address = (self.invoiceModel!.registeredAddress)!
                let phone = (self.invoiceModel!.registeredTelephone)!
                let bank = (self.invoiceModel!.openingBank)!
                let account = (self.invoiceModel!.bankAccount)!
//                if severModel != nil && state != .daiShenHe {
//                    if name == (severModel?.enterpriseName)! && id == (severModel?.taxpayerIdentificationNumber)! && address == (severModel?.registeredAddress)! && phone == (severModel?.registeredTelephone)! && bank == (severModel?.openingBank)! && account == (severModel?.bankAccount)! {
//                        return .failed(message: "您未做任何修改！")
//                    }
//                }
                return SelectedBillProvider.shared.validateSpecialUat((self.invoiceModel!.enterpriseName)!, id: (self.invoiceModel!.taxpayerIdentificationNumber)!, address: address, phone: phone, bank: bank, account: account)
            } else {
                return .empty(message: "未知发票类型")
            }
        }
    }
    
    var inputs: [String] {
        get {
            if self.type == .ordinary || self.type == .eleInvoice{
                guard self.invoiceModel != nil else {
                    return ["", ""]
                }
                if self.taxpayerIdNotVisible {
                    return [(self.invoiceModel!.enterpriseName)!]
                }
                return [(self.invoiceModel!.enterpriseName)!, (self.invoiceModel!.taxpayerIdentificationNumber)!]
            } else if self.type == .special {
                guard self.invoiceModel != nil else {
                    return ["", "", "", "", "", ""]
                }
                return [(self.invoiceModel!.enterpriseName)!, (self.invoiceModel!.taxpayerIdentificationNumber)!, (self.invoiceModel!.registeredAddress)!, (self.invoiceModel!.registeredTelephone)!, (self.invoiceModel!.openingBank)!, (self.invoiceModel!.bankAccount)!]
            } else {
                return []
            }
        }
    }
    var accountCenterInputs: [String] {
        get {
            if self.type == .ordinary {
                guard self.invoiceModel != nil else {
                    return ["", ""]
                }
                if self.invoiceModel?.taxpayerIdentificationNumber?.count == 0 {
                    return [(self.invoiceModel!.enterpriseName)!]
                }
                return [(self.invoiceModel!.enterpriseName)!, (self.invoiceModel!.taxpayerIdentificationNumber)!]
            }
            else if self.type == .eleInvoice {
                guard self.invoiceModel != nil else {
                    return ["", ""]
                }
                if self.invoiceModel?.taxpayerIdentificationNumber?.count == 0 {
                    return [(self.invoiceModel!.enterpriseName)!]
                }
                return [(self.invoiceModel!.enterpriseName)!, (self.invoiceModel!.taxpayerIdentificationNumber)!]
            }
            else if self.type == .special {
                guard self.invoiceModel != nil else {
                    return ["", "", "", "", "", ""]
                }
                return [(self.invoiceModel!.enterpriseName)!, (self.invoiceModel!.taxpayerIdentificationNumber)!, (self.invoiceModel!.registeredAddress)!, (self.invoiceModel!.registeredTelephone)!, (self.invoiceModel!.openingBank)!, (self.invoiceModel!.bankAccount)!]
            } else {
                return []
            }
        }
    }
    var labelTexts: [String] {
        get {
            if self.taxpayerIdNotVisible {
                return ["单位名称", "注册地址", "注册电话", "开户银行", "银行账户"]
            }
            return ["单位名称", "纳税人识别号", "注册地址", "注册电话", "开户银行", "银行账户"]
        }
    }
    var textfieldTexts: [String] {
        get {
            return ["单位全称", "如果三证合一，请填写统一社会信用代码", "详细地址", "电话号码", "所在银行", "账户号码"]
        }
    }
    
    // MARK: - Life Cycle
    
    init(withType type: ValueAddedTaxType) {
        self.type = type
    }
    
    // MARK: - Action
    // 根据发票类型获取对应的发票信息
    func fetchInvoiceData(withHandler handler:@escaping ()->()) {
        if self.type == .notSelected {
            handler()
            return
        }
        // 电子发票和普通发票内容一致
        SelectedBillProvider().getInvoiceData(withBillType: type.rawValue == 3 ? 2 : type.rawValue, handler: { (success, invoiceModel) in
            self.dataLoaded = success
            guard success else {
                handler()
                return
            }
            if invoiceModel != nil {
                if invoiceModel?.billType?.count == 0 {
                    invoiceModel?.billType = "\(self.type.rawValue)"
                }
                self.severModel = InvoiceModel(bankAccount: invoiceModel?.bankAccount, billId: invoiceModel?.billId, billStatus: invoiceModel?.billStatus, billType: invoiceModel?.billType, enterpriseName: invoiceModel?.enterpriseName, openingBank: invoiceModel?.openingBank, registeredAddress: invoiceModel?.registeredAddress, registeredTelephone: invoiceModel?.registeredTelephone, taxpayerIdentificationNumber: invoiceModel?.taxpayerIdentificationNumber, message: invoiceModel?.message, license: invoiceModel?.license)
                // 电子发票类型改回来
                if self.type == .eleInvoice{
                    self.severModel!.billType = "3"
                    invoiceModel?.billType = "3"
                }
                
                self.setNewModel(invoiceModel!)
            }
            handler()
        })
    }
    
    // 新增和编辑发票
    func saveInvoiceData(withHandler handler:@escaping (_ success: Bool, _ message: String) -> ()) {
        SelectedBillProvider().saveInvoiceData(withInvoiceModel: invoiceModel!) { (success, message) in
            handler(success, message)
        }
    }
    
    func setNewModel(_ newModel: InvoiceModel) {
        self.dataLoaded = true
        self.invoiceModel = newModel
        let statu: String = (newModel.billStatus)! as String
        switch statu {
        case "1":
            self.state = .daiShenHe
        case "2":
            self.state = .shenHeTongGuo
        case "3":
            self.state = .shenHeWeiTongGuo
        default:
            self.state = .unknow
        }
    }
    
    func numberOfRowsInTableView() -> NSInteger {
        let flag = self.taxpayerIdNotVisible ? 1 : 0
        switch self.type {
        case .ordinary:
            return 2 - flag
        case .eleInvoice:
            return 2 - flag
        case .special:
            return 6
        default:
            return 0
        }
    }
    
    func updateModel(withText text:String, atIndex index: Int) {
        if self.invoiceModel == nil {
            self.invoiceModel = InvoiceModel(billType: StringValue(self.type.rawValue))
        }
        
        switch index {
        case 0:
            self.invoiceModel!.enterpriseName = text
        case 1:
            self.invoiceModel!.taxpayerIdentificationNumber = text
        case 2:
            self.invoiceModel!.registeredAddress = text
        case 3:
            self.invoiceModel!.registeredTelephone = text
        case 4:
            self.invoiceModel!.openingBank = text
        case 5:
            self.invoiceModel!.bankAccount = text
        default: break
        }
    }
    
    // MARK: - UI
    
    // MARK: - Private Method
}
