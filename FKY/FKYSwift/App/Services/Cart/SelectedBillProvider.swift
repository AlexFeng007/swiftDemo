//
//  SelectedBillProvider.swift
//  FKY
//
//  Created by Rabe on 12/07/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  选择发票类型请求类

import Foundation
import RxSwift
import RxCocoa

class SelectedBillProvider: NSObject {
    
    static let shared = SelectedBillProvider()
    
    var billRequestSever : FKYPublicNetRequestSevice?
    
    fileprivate lazy var orderService: FKYPublicNetRequestSevice? = {
        return FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice
    }()
    
    override init() {
        super.init()
        self.billRequestSever = FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice
    }
    
    func getInvoiceData(withBillType billType: Int, handler: @escaping (_ success: Bool, _ invoiceModel: InvoiceModel?)->()) {
        // let parameter = ["billType": billType]
        let yctoken: NSString? = UserDefaults.standard.value(forKey: "user_token") as? NSString
        let params = ["ycToken":(yctoken ?? "")  as Any,"jsonParams":billType] as [String : Any]
        _ = self.orderService?.getBillInfoByCustIdBlock(withParam:params , completionBlock: {(responseObject, anError)  in
            if anError == nil {
                if let data = responseObject as? NSDictionary  {
                    let invoiceModel = data.mapToObject(InvoiceModel.self)
                    handler(true, invoiceModel)
                }else{
                    handler(true, nil)
                }
            }else{
                if let err = anError {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        FKYAppDelegate!.showToast("用户登录过期，请重新手动登录")
                    }
                }
                handler(false, nil)
            }
        });
    }
    
    func saveInvoiceData(withInvoiceModel invoiceModel: InvoiceModel, handler: @escaping (_ success: Bool, _ message: String)->()) {
        self.billRequestSever?.saveInvoiceInfoBlock(withParam: invoiceModel.reverseSaveJSON(), completionBlock: { (response, error) in
            if error == nil {
                handler(true, "成功")
            }else {
                handler(false, (error?.localizedDescription)!)
            }
        })
    }
    
    func validateCompanyname(_ companyname: String) -> OutputResult {
        if companyname.count == 0 {
            return .empty(message: "单位名称不能为空")
        }
        if companyname.count > 200 {
            return .failed(message: "单位名称长度不得超过200")
        }
        return .ok
    }
    
    func validateIdnumber(_ idnumber: String) -> OutputResult {
        if idnumber.count == 0 {
            return .empty(message: "纳税人识别号不能为空")
        }
        if idnumber.count == 15 || idnumber.count == 18 || idnumber.count == 20 {
            return .ok
        }
        return .failed(message: "请输入15、18或20位纳税人识别号")
    }
    
    func validateAddress(_ address: String) -> OutputResult {
        if address.count == 0 {
            return .empty(message: "注册地址不能为空")
        }
        if address.count > 200 {
            return .failed(message: "注册地址长度不得超过200")
        }
        return .ok
    }
    
    func validatePhone(_ phone: String) -> OutputResult {
        if phone.count == 0 {
            return .empty(message: "注册电话不能为空")
        }
        if phone.count > 30 {
            return .failed(message: "注册电话长度不得超过30")
        }
        return .ok
    }
    
    func validateBank(_ bank: String) -> OutputResult {
        if bank.count == 0 {
            return .empty(message: "开户银行不能为空")
        }
        if bank.count > 100 {
            return .failed(message: "开户银行长度不得超过100")
        }
        return .ok
    }
    
    func validateBankAccount(_ account: String) -> OutputResult {
        if account.count == 0 {
            return .empty(message: "银行账户不能为空")
        }
        if account.count > 50 {
            return .failed(message: "银行账户长度不得超过50")
        }
        return .ok
    }
    
    func validateOrdinaryUat(_ name: String, id: String) -> OutputResult {
        let result = self.validateCompanyname(name)
        if result.isValid {
            return self.validateIdnumber(id)
        } else {
            return result
        }
    }
    
    func validateSpecialUat(_ name: String, id: String, address: String, phone: String, bank: String, account: String) -> OutputResult {
        let nameRes = self.validateCompanyname(name)
        if nameRes.isValid {
            let idRes = self.validateIdnumber(id)
            if idRes.isValid {
                let addressRes = self.validateAddress(address)
                if addressRes.isValid {
                    let phoneRes = self.validatePhone(phone)
                    if phoneRes.isValid {
                        let bankRes = self.validateBank(bank)
                        if bankRes.isValid {
                            return self.validateBankAccount(account)
                        } else {
                            return bankRes
                        }
                    } else {
                        return phoneRes
                    }
                } else {
                    return addressRes
                }
            } else {
                return idRes
            }
        } else {
            return nameRes
        }
    }
}
