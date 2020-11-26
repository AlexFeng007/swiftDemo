//
//  FKYInvoiceViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

class FKYInvoiceViewModel: NSObject {
    ///发票信息的原始数据
    var invoiceRawData = FKYInvoiceModel()
    ///整理后的viewModel
    var cellModelList = [FKYInvoiceCellModel]()
    ///发票类型 默认普通发票
    var invoiceType:FKYInvoiceViewType = .normalInvoiceType
    ///最后要提交的发票参数
    var submitInvoiceParam = ["id":"",//获取发票接口的billid值
                              "businessName":"",//单位名称
                              "taxNum":"",//纳税人识别号
                              "type":"",//发票类型
                              "bankAccount":"",//银行账号
                              "bankName":"",//开户银行
                              "registerAddress":"",//注册地址
                              "registerPhone":"",//注册电话
                              "bankType":""]//银行类型 传这个银行的id
}

class FKYInvoiceCellModel: NSObject {
    ///前面标题文字
    var titleName = ""
    ///输入框默认显示的holder
    var inputHolder = ""
    ///输入框的文字/或者提示文字
    var inputText = ""
    ///审核的状态
    var billStatus = 0
    ///cell的类型
    var cellType:FKYInvoiceType = .noType
    ///cell中附件的类型 关乎到附件的布局
    var AccessoryType:FKYInvoiceAccessoryType = .defaultType
    ///填写后提交给后台的key
    var paramKey = ""
    ///输入框是否可以编辑
    var isCanEditer = true
    ///是否隐藏下方分割线
    var isHiddenMarginLine = true
    
    init(titleName:String ,inputHolder:String,inputText:String,cellType:FKYInvoiceType ,AccessoryType:FKYInvoiceAccessoryType,billStatus:Int,paramKey:String,isCanEditer:Bool){
        super.init()
        self.titleName = titleName
        self.inputHolder = inputHolder
        self.inputText = inputText
        self.cellType = cellType
        self.AccessoryType = AccessoryType
        self.billStatus = billStatus
        self.paramKey = paramKey
        self.isCanEditer = isCanEditer
    }
    
    override init (){
        super.init()
    }
}

enum FKYInvoiceViewType {
    ///普通发票
    case normalInvoiceType
    ///专用发票
    case specialInvoiceType
}

enum FKYInvoiceType {
    ///默认无cell类型
    case noType
    ///审核状态cell
    case auditStatusCell
    ///常规输入cell
    case normalInputCell
    ///电话输入框
//    case phoneCell
    ///银行选择拦
//    case bankCell
    ///提示cell
    case tipsCell
    ///展开cell
    case unfoldCell
    ///空行
    case emptyCell
}

enum FKYInvoiceAccessoryType {
    ///默认情况 全都没有
    case defaultType
    ///只有下部分割线
    case bottomLine
    ///右边显示叉叉按钮
    case phoneCellType
    ///右边显示右箭头
    case bankCellTypr
    ///单个提示
    case singleTipCell
    ///有注意事项的提示
    case attentionTipCell
}

//MARK: - 网络请求
extension FKYInvoiceViewModel {
    /// 保存发票信息
    /// - Parameter block:
    func saveInvoiceInfo(block: @escaping (_ isSuccess:Bool, _ Msg:String?)->()){
        FKYRequestService.sharedInstance()?.requestForSaveInvoiceInfo(withParam: self.submitInvoiceParam, completionBlock: {[weak self] (success, error, response, model) in
            guard let _ = self else {
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
            block(true,"获取成功")
        })
    }
    
    /// 获取发票信息
    /// - Parameter block:
    func getInvoiceInfo(block: @escaping (_ isSuccess:Bool,_ isCompletion:Bool, _ Msg:String?)->()) {
        var param = [String:Int]()
        if self.invoiceType == .normalInvoiceType{//普票
            param = ["type":2,"source":1]
        }else if invoiceType == .specialInvoiceType{//专票
            param = ["type":1,"source":1]
        }
        FKYRequestService.sharedInstance()?.requestForInvoiceInfo(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let selfStrong = self else {
                block(false,false, "请求失败")
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
                block(false,false, msg)
                return
            }
            
            // 请求成功 整理数据
            if let data = response as? NSDictionary {
                let model = data.mapToObject(FKYInvoiceModel.self)
                selfStrong.invoiceRawData = model
                selfStrong.installSubmitParam()
                selfStrong.disposalData(model:model)
                let isComplet = selfStrong.isInputComplete()
                block(true,isComplet,"获取成功")
            }
        })
    }
    
    
}

//MARK: - 数据整理
extension FKYInvoiceViewModel {
    
    ///需要提交的参数是否已经填写完整
    func isInputComplete()->Bool{
        for item in self.submitInvoiceParam {
            if item.value.isEmpty {//未填写完整
                if item.key != "id"{
                    return false
                }
            }
        }
        //已填写完整
        return true
    }
    
    ///整理银行数据
    func updataBankData(id:String,name:String,block: @escaping ()->()){
        self.submitInvoiceParam["bankType"] = id
        for item in self.cellModelList {
            if item.paramKey == "bankType" {///银行类型的cellModel
                item.inputText = name
            }
        }
        block()
    }
    
    ///将填写完的参数加入到提交参数中
    func changeInputInvoiceInfo(param:Dictionary<String,String>,block: @escaping (_ isCompletion:Bool)->()){
        for item in param{
            self.submitInvoiceParam[item.key] = item.value
        }
        block(isInputComplete())
    }
    
    ///第一次网络请求回来时初始化提交参数
    func installSubmitParam(){
        //主键id
        self.submitInvoiceParam["id"] = self.invoiceRawData.billId
        //单位名称
        self.submitInvoiceParam["businessName"] = self.invoiceRawData.enterpriseName
        //纳税人识别号
        self.submitInvoiceParam["taxNum"] = self.invoiceRawData.taxpayerIdentificationNumber
        //发票类型
        self.submitInvoiceParam["type"] = "\(self.invoiceRawData.billType)"
        //银行账号
        self.submitInvoiceParam["bankAccount"] = self.invoiceRawData.bankAccount
        //开户银行
        self.submitInvoiceParam["bankName"] = self.invoiceRawData.openingBank
        //注册地址
        self.submitInvoiceParam["registerAddress"] = self.invoiceRawData.registeredAddress
        //注册电话
        self.submitInvoiceParam["registerPhone"] = self.invoiceRawData.registeredTelephone
        //银行ID
        self.submitInvoiceParam["bankType"] = self.invoiceRawData.bankTypeVO.id
    }
    
    /// 洗数据
    /// - Parameter model:
    func disposalData(model:FKYInvoiceModel){
        var edit = true //默认可编辑
        self.submitInvoiceParam["id"] = model.billId
        self.submitInvoiceParam["type"] = "\(model.billType)"
        self.cellModelList.removeAll()
        
        //审核状态cell
        if model.billStatus != 0{
            var inputStr = ""
            if self.invoiceRawData.billStatus == 3{
                inputStr = self.invoiceRawData.remark
            }else{
                inputStr = self.invoiceRawData.topMsg
            }
            
            let cellModel = FKYInvoiceCellModel.init(titleName: "", inputHolder: "", inputText: inputStr, cellType: .auditStatusCell, AccessoryType: .defaultType, billStatus: model.billStatus ,paramKey: "",isCanEditer: edit)
            self.cellModelList.append(cellModel)
        }
        
        //空行
        let emptyCell1 = FKYInvoiceCellModel.init(titleName: "", inputHolder: "", inputText: model.enterpriseName, cellType: .emptyCell, AccessoryType: .defaultType, billStatus: model.billStatus ,paramKey: "",isCanEditer: edit)
        self.cellModelList.append(emptyCell1)
        
        if model.billStatus == 1 {
            edit = false
        }
        
        if model.billStatus == 2 && model.deliverStatus == 1 && model.branchSwitch == 0{
            edit = false
        }
        
        if model.billStatus == 3 && model.deliverStatus == 1 && model.branchSwitch == 0{
            edit = false
        }
        
        ///企业名称行
        let cellModel1 = FKYInvoiceCellModel.init(titleName: "*企业名称", inputHolder: "请填写企业名称", inputText: model.enterpriseName, cellType: .normalInputCell, AccessoryType: .defaultType, billStatus: model.billStatus ,paramKey: "businessName",isCanEditer: edit)
        self.cellModelList.append(cellModel1)
        
        //纳税人识别号
        let cellModel2 = FKYInvoiceCellModel.init(titleName: "*纳税人识别号", inputHolder: "如果三证合一，请填写统一社会信用代码", inputText: model.taxpayerIdentificationNumber, cellType: .normalInputCell, AccessoryType: .defaultType, billStatus: model.billStatus ,paramKey: "taxNum",isCanEditer: edit)
        if self.invoiceType == .normalInvoiceType{
            cellModel2.isHiddenMarginLine = false
        }
        self.cellModelList.append(cellModel2)
        
        //展开按钮
        let cellModel3 = FKYInvoiceCellModel.init(titleName: "", inputHolder: "展开按钮", inputText: "", cellType: .unfoldCell, AccessoryType: .defaultType, billStatus: model.billStatus ,paramKey: "",isCanEditer: edit)
        self.cellModelList.append(cellModel3)
        
        //空行
        let emptyCell2 = FKYInvoiceCellModel.init(titleName: "", inputHolder: "空行", inputText: "", cellType: .emptyCell, AccessoryType: .defaultType, billStatus: model.billStatus ,paramKey: "",isCanEditer: edit)
        self.cellModelList.append(emptyCell2)
        
        //最后的底部tips
        if !model.bottomMsg.isEmpty {///提示不为空就添加
            let bottomTipCell = FKYInvoiceCellModel.init(titleName: "", inputHolder: "", inputText: model.bottomMsg, cellType: .tipsCell, AccessoryType: .attentionTipCell, billStatus: model.billStatus ,paramKey: "",isCanEditer: edit)
            self.cellModelList.append(bottomTipCell)
        }
    }
    
    ///展开cell
    func unfoldCell(block: @escaping ()->()) {
        var edit = true
        var index = 0
        for (index_t,item) in self.cellModelList.enumerated() {
            if item.cellType == .unfoldCell{
                index = index_t
            }
            if item.paramKey == "taxNum" {
                item.AccessoryType = .bottomLine
            }
        }
        self.cellModelList.remove(at: index)
        var str1 = "注册地址"
        var str2 = "注册电话"
        var str3 = "银行类型"
        var str4 = "开户银行"
        var str5 = "银行账号"
        var list = [FKYInvoiceCellModel]()
        //普通发票加入提示行
        if self.invoiceType == .normalInvoiceType  {
            if !self.invoiceRawData.midMsg.isEmpty {
                let cellModel = FKYInvoiceCellModel.init(titleName: "", inputHolder: "", inputText: self.invoiceRawData.midMsg, cellType: .tipsCell, AccessoryType: .singleTipCell, billStatus: self.invoiceRawData.billStatus ,paramKey: "",isCanEditer: edit)
                list.append(cellModel)
            }
        }else{//专用发票
            str1 = "*注册地址"
            str2 = "*注册电话"
            str3 = "*银行类型"
            str4 = "*开户银行"
            str5 = "*银行账号"
        }
        if self.invoiceRawData.billStatus == 1 {//未在审核中的都可以修改
            edit = false
        }
        let cellModel1 = FKYInvoiceCellModel.init(titleName: str1, inputHolder: "请填写注册地址", inputText: self.invoiceRawData.registeredAddress, cellType: .normalInputCell, AccessoryType: .defaultType, billStatus: self.invoiceRawData.billStatus ,paramKey: "registerAddress",isCanEditer: edit)
        list.append(cellModel1)
        
        let cellModel2 = FKYInvoiceCellModel.init(titleName: str2, inputHolder: "请填写注册电话号码", inputText: self.invoiceRawData.registeredTelephone, cellType: .normalInputCell, AccessoryType: .phoneCellType, billStatus: self.invoiceRawData.billStatus ,paramKey: "registerPhone",isCanEditer: edit)
        cellModel2.isHiddenMarginLine = false
        list.append(cellModel2)
        
        let cellModel3 = FKYInvoiceCellModel.init(titleName: str3, inputHolder: "请选择银行类型", inputText: self.invoiceRawData.bankTypeVO.name, cellType: .normalInputCell, AccessoryType: .bankCellTypr, billStatus: self.invoiceRawData.billStatus ,paramKey: "bankType",isCanEditer: edit)
        cellModel3.isHiddenMarginLine = false
        list.append(cellModel3)
        
        let cellModel4 = FKYInvoiceCellModel.init(titleName: str4, inputHolder: "请填写开户银行", inputText: self.invoiceRawData.openingBank, cellType: .normalInputCell, AccessoryType: .defaultType, billStatus: self.invoiceRawData.billStatus ,paramKey: "bankName",isCanEditer: edit)
        list.append(cellModel4)
        
        let cellModel5 = FKYInvoiceCellModel.init(titleName: str5, inputHolder: "请填写银行账户", inputText: self.invoiceRawData.bankAccount, cellType: .normalInputCell, AccessoryType: .defaultType, billStatus: self.invoiceRawData.billStatus ,paramKey: "bankAccount",isCanEditer: edit)
        list.append(cellModel5)
        
        self.cellModelList.insert(contentsOf: list, at: index)
        block()
//        self.updataBankData(id: self.invoiceRawData.bankType, name: self.invoiceRawData.bankName) {
//            
//        }
    }
}
