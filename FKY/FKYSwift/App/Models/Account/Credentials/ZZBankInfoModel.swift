//
//  ZZBankInfoModel.swift
//  FKY
//
//  Created by yangyouyong on 2016/12/2.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit

class ZZBankInfoModel: NSObject {
    
    var bankName : String?      // 银行名称
    var bankCode : String?      // 银行帐号
    var accountName : String?   // 银行开户名
    var QCFile: ZZFileModel?    // 银行开户许可证
    
    override init() {
        self.QCFile = ZZFileModel()
    }
    
    init(bankName : String?, bankCode : String?, accountName : String?, QCFile : ZZFileModel?) {
        self.accountName = accountName
        self.bankName = bankName
        self.bankCode = bankCode
        self.QCFile = QCFile
    }
    
    // 非空判断
    func isValid() -> Bool {
        guard QCFile != nil else {
            return false
        }
        guard let name = bankName, let txtN = (name as NSString).trimmingWhitespaceAndNewlines(), txtN.isEmpty == false else {
            return false
        }
        guard let code = bankCode, let txtC = (code as NSString).trimmingWhitespaceAndNewlines(), txtC.isEmpty == false else {
            return false
        }
        guard let account = accountName, let txtA = (account as NSString).trimmingWhitespaceAndNewlines(), txtA.isEmpty == false else {
            return false
        }
        return true
    }
    
    func hashString() -> String {
        var hashString = ""
        if let bankname = self.bankName, bankName != "" {
            hashString = "\(bankname)"
        }
        
        if let bankcode = self.bankCode, bankCode != "" {
            hashString += ";\(bankcode)"
        }else{
            hashString += ";"
        }
        
        if let accountname = self.accountName, accountName != "" {
            hashString += ";\(accountname)"
        }else{
            hashString += ";"
        }
        
        if let filePath = self.QCFile?.filePath, filePath != "" {
            hashString += ";\(filePath)"
        }else{
            hashString += ";"
        }
        return hashString
    }
    
    // MARK: NSKeyedArchiver For ZZBankInfoModel
    required convenience init?(coder aDecoder: NSCoder) {
        let bankName = aDecoder.decodeObject(forKey: "bankName") as? String
        let bankCode = aDecoder.decodeObject(forKey: "bankCode") as? String
        let accountName = aDecoder.decodeObject(forKey: "accountName") as? String
        let QCFile = aDecoder.decodeObject(forKey: "QCFile") as? ZZFileModel
        self.init(bankName : bankName, bankCode : bankCode, accountName : accountName, QCFile : QCFile)
    }
}


func ==(lhs: ZZBankInfoModel, rhs: ZZBankInfoModel) -> Bool {
    if (lhs.bankName != rhs.bankName) {
        return false
    }
    if (lhs.bankCode != rhs.bankCode) {
        return false
    }
    if (lhs.accountName != rhs.accountName) {
        return false
    }
    if (lhs.QCFile?.filePath != rhs.QCFile?.filePath) {
        return false
    }
    return true
}
