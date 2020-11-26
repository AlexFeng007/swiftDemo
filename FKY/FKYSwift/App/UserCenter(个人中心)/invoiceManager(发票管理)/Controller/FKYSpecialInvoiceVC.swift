//
//  FKYSpecialInvoiceVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSpecialInvoiceVC: UIViewController {
    
    ///是否展开
    var isUnfold:Bool = false
    
    ///list
    lazy var tableList:UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = RGBColor(0xF2F2F2)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.estimatedRowHeight = 44
        table.rowHeight = UITableView.automaticDimension
        table.register(FKYAuditStatusCell.self, forCellReuseIdentifier: NSStringFromClass(FKYAuditStatusCell.self))
        table.register(FKYInvoiceInfoInputCell.self, forCellReuseIdentifier: NSStringFromClass(FKYInvoiceInfoInputCell.self))
        table.register(FKYInvoiceTipsCell.self, forCellReuseIdentifier: NSStringFromClass(FKYInvoiceTipsCell.self))
        table.register(FKYUnfoldInvoiceCell.self, forCellReuseIdentifier: NSStringFromClass(FKYUnfoldInvoiceCell.self))
        table.register(FKYInvoiceEmptyCell.self, forCellReuseIdentifier: NSStringFromClass(FKYInvoiceEmptyCell.self))
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return table
    }()
    
    ///提交按钮
    lazy var submitView:FKYSubmitInvoiceInfoView = {
        let view = FKYSubmitInvoiceInfoView.init(frame: CGRect.zero)
        return view
    }()
    
    ///普通发票的ViewModel
    lazy var InvoiceViewModel:FKYInvoiceViewModel = {
        let model = FKYInvoiceViewModel()
        model.invoiceType = .specialInvoiceType
        return model
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        requestInvoiceInfo()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.InvoiceViewModel.getInvoiceInfo { (isSuccess, Msg) in
//            self.tableList.reloadData()
//            self.submitView.showData(data:self.InvoiceViewModel)
//            if self.InvoiceViewModel.invoiceRawData.billStatus == 1{//审核中
//                self.submitView.snp_updateConstraints { (make) in
//                    make.height.equalTo(0)
//                }
//            }
//        }
    }
    
}


//MARK: - UI
extension FKYSpecialInvoiceVC {
    func setupView(){
        self.view.addSubview(tableList)
        self.view.addSubview(submitView)
        
        tableList.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(submitView.snp_top)
        }

        submitView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(WH(86))
            make.bottom.equalTo(self.view)
        }
    }
}

//MARK: - VIEW事件回调响应
extension FKYSpecialInvoiceVC {
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKY_unfoldInvoiceCell{//展开
            ///专票模式下默认展开网络请求成功会默认展开
        }else if eventName == FKY_endInputInvoiceInfo{//编辑了发票信息
            let param = userInfo[FKYUserParameterKey] as! Dictionary<String, String>
            self.InvoiceViewModel.changeInputInvoiceInfo(param: param) { (isCompletion) in
                self.updataSubmitViewStatus()
            }
        }else if eventName == FKY_submitInvoiceInfo{//提交按钮点击
            submitInvoiceInfo()
        }else if eventName == FKY_popBankSelector{//弹出银行选择
            self.view.endEditing(true)
            presentBankVC()
        }else if eventName == FKY_checkProtocol{//查看协议
            FKYNavigator.shared()?.openScheme(FKY_InvoiceQualificationViewController.self)
        }else if eventName == FKY_selectProtocolClicked {//协议选中按钮点击
            updataSubmitViewStatus()
        }
    }
    
    ///更新选中按钮的状态
    func updataSubmitViewStatus (){
        if self.InvoiceViewModel.isInputComplete(){
            if self.InvoiceViewModel.invoiceRawData.billStatus != 0{//不是第一次审核 不显示选中按钮
                self.submitView.enableSubmitBtnAction()
            }else{//显示选中按钮
                if self.submitView.selectBtn.isSelected {//按钮选中
                    self.submitView.enableSubmitBtnAction()
                }else{
                    self.submitView.unableSubmitBtnAction()
                }
            }
        }else{
            self.submitView.unableSubmitBtnAction()
        }
    }
    
    ///弹出银行选择框
    func presentBankVC(){
        let bankVC = FKYSelectBankVC()
        bankVC.modalPresentationStyle = .overCurrentContext;
        bankVC.selectBank = { [weak self] (bank) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.InvoiceViewModel.updataBankData(id: bank.id, name: bank.name) {[weak self] in
                guard let strongSelf = self else{
                    return
                }
                strongSelf.updataSubmitViewStatus()
                strongSelf.tableList.reloadData()
            }
        }
        self.present(bankVC, animated: true) {
            
        }
    }
    
    ///提交信息
    func submitInvoiceInfo(){
        let tip = isInfoInputFull()
        
        ///必填项
        if !tip.0{//如果不能提交则弹出提示
            if tip.1 == 1{
                self.toast(tip.2)
            }
            return
        }
        
        //一下为可以提交
        ///非必填项
//        if tip.1 == 2 {
//            let alert = COAlertView.init(frame: CGRect.zero)
//            alert.configView("您的\(tip.2)尚未维护，普票上将无法打印地址、电话，开户行及账号。", "取消", "确定", "", .twoBtn)
//            alert.rightBtnActionBlock = {
//                let keyList = ["registerAddress","registerPhone","bankType","bankName","bankAccount"]
//                for key in keyList {
//                    self.InvoiceViewModel.submitInvoiceParam[key] = ""
//                }
//                self.InvoiceViewModel.saveInvoiceInfo { (success, msg) in
//                    if success {
//                        self.toast("维护成功")
//                        FKYNavigator.shared().pop()
//                    }else{
//                        self.toast(msg)
//                    }
//                }
//            }
//            alert.showAlertView()
//            return
//        }
        
        self.InvoiceViewModel.saveInvoiceInfo { (success, msg) in
            if success {
                if msg == "信息未变更" {
                    self.toast("信息未变更")
                }else{
                    self.toast("提交成功")
                }
                FKYNavigator.shared().pop()
            }else{
                self.toast(msg)
            }
        }
    }
    
    ///信息是否填写完整 isCanSubmit 能否提交  TipTyp：提示类型 0为无提示 1toast  2弹窗  tipMsg：提示内容
    func isInfoInputFull() -> (isCanSubmit:Bool ,TipTyp:Int ,tipMsg:String){
        for item in self.InvoiceViewModel.submitInvoiceParam{
            if item.key == "businessName" {
                if item.value.count == 0{
                    return (false,1,"企业名称不能为空")
                }else if item.value.count > 200 {
                    return (false,1,"企业名称最长200个字符")
                }
            }else if item.key == "taxNum"{
                if item.value.count == 0{
                    return (false,1,"纳税人识别号不能为空")
                }else if item.value.count != 15 && item.value.count != 18 && item.value.count != 20{
                    return (false,1,"纳税人识别号只能是15或18或20位字符")
                }
            }
            
            if item.key == "bankAccount" {
                if item.value.count == 0{
                    return (false,1,"银行账号不能为空")
                }else if item.value.count > 50 {
                    return (false,1,"银行账号最长50个字符")
                }
            }else if item.key == "bankName" {
                if item.value.count == 0{
                    return (false,1,"开户银行不能为空")
                }else if item.value.count > 100 {
                    return (false,1,"开户银行最长100个字符")
                }
            }else if item.key == "registerAddress" {
                if item.value.count == 0{
                    return (false,1,"注册地址不能为空")
                }else if item.value.count > 200 {
                    return (false,1,"注册地址最长200个字符")
                }
            }else if item.key == "registerPhone"{
                if item.value.count == 0{
                    return (false,1,"注册电话不能为空")
                }else if item.value.count > 30 {
                    return (false,1,"注册电话最长30个字符")
                }
                
            }else if item.key == "bankType" {
                if item.value.count == 0{
                    return (false,1,"银行类型不能为空")
                }
            }
        }
        return (true,0,"")
    }
}

//MARK: - 网络请求
extension FKYSpecialInvoiceVC {
    
    /// 获取发票信息
    func requestInvoiceInfo(){
        self.InvoiceViewModel.getInvoiceInfo { (isSuccess,isCompletion, Msg) in
            if !isSuccess {
                self.toast(Msg)
                return
            }
            
            self.InvoiceViewModel.unfoldCell {
                self.tableList.reloadData()
                self.isUnfold = true
            }
            self.submitView.showData(data:self.InvoiceViewModel)
            if self.InvoiceViewModel.invoiceRawData.billStatus == 1{//审核中
                self.submitView.snp_updateConstraints { (make) in
                    make.height.equalTo(0)
                }
            }else if self.InvoiceViewModel.invoiceRawData.billStatus != 0{//不是第一次审核
                self.submitView.snp_updateConstraints { (make) in
                    make.height.equalTo(WH(62))
                }
            }
            
            self.updataSubmitViewStatus()
        }
    }
}

//MARK: - UITableViewDelegate,dataSoure
extension FKYSpecialInvoiceVC:UITableViewDelegate,UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.InvoiceViewModel.cellModelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = self.InvoiceViewModel.cellModelList[indexPath.row]
        switch cellModel.cellType {
        case .auditStatusCell://审核状态
            let cell:FKYAuditStatusCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYAuditStatusCell.self)) as! FKYAuditStatusCell
            cell.showData(cellData: cellModel)
            return cell
            
        case .emptyCell://空行
            let cell:FKYInvoiceEmptyCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYInvoiceEmptyCell.self)) as! FKYInvoiceEmptyCell
            return cell
            
        case .tipsCell://提示
            let cell:FKYInvoiceTipsCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYInvoiceTipsCell.self)) as! FKYInvoiceTipsCell
            cell.showData(cellData: cellModel)
            return cell
            
        case .unfoldCell://展开行
            let cell:FKYUnfoldInvoiceCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYUnfoldInvoiceCell.self)) as! FKYUnfoldInvoiceCell
            return cell
            
        case .normalInputCell://常规信息输入cell
            let cell:FKYInvoiceInfoInputCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYInvoiceInfoInputCell.self)) as! FKYInvoiceInfoInputCell
            cell.showData(cellData: cellModel)
            return cell
            
        case .noType://其他未知类型
            let cell:FKYInvoiceEmptyCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYInvoiceEmptyCell.self)) as! FKYInvoiceEmptyCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = self.InvoiceViewModel.cellModelList[indexPath.row]
        switch cellModel.cellType {
        case .auditStatusCell:
            return FKYAuditStatusCell.getCellHeight()
            
        case .emptyCell:
            return FKYInvoiceEmptyCell.getCellHeight()
            
        case .tipsCell:
            return tableView.rowHeight
            
        case .unfoldCell:
            return FKYUnfoldInvoiceCell.getCellHeight()
            
        case .normalInputCell:
            return FKYInvoiceInfoInputCell.getCellHeight()
            
        case .noType:
            return FKYInvoiceEmptyCell.getCellHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
