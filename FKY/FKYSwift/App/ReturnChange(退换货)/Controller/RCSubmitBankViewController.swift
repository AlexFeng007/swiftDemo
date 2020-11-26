//
//  RCSubmitBankViewController.swift
//  FKY
//
//  Created by hui on 2019/8/1.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class RCSubmitBankViewController: UIViewController {

    // 导航栏
    fileprivate lazy var navBar: UIView? = {
        if let _ = self.NavigationBar {
            //
        }
        else {
            self.fky_setupNavBar()
        }
        self.NavigationBar?.backgroundColor = bg1
        return self.NavigationBar
    }()
    // 列表
    fileprivate lazy var tableview: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.register(RCSendInfoCell.self, forCellReuseIdentifier: "RCSendInfoCell")
        view.register(FKYInvoiceInfoInputCell.self, forCellReuseIdentifier: NSStringFromClass(FKYInvoiceInfoInputCell.self))
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    //提交按钮背景图
    fileprivate lazy var submitView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF2F2F2)
        view.addSubview(self.btnSubmit)
        self.btnSubmit.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(WH(10))
            make.left.equalTo(view).offset(WH(30))
            make.right.equalTo(view).offset(WH(-30))
            make.height.equalTo(WH(42))
        }
        // 分隔线
        let viewLine = UIView.init(frame: CGRect.zero)
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        view.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(0.5)
        }
        return view
    }()
    // 提交按钮
    fileprivate lazy var btnSubmit: UIButton = {
        // 自定义按钮背景图片
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFF2D5C), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("提交", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(3)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.submitBankInfo()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    //属性
    var bankName: String?//开户行
    var bankAccount: String?//银行账户
    var userName: String?//开户名
    ///选中的银行 ID
    var bankType = ""
    
    var viewModel: RCSubmitInfoViewModel?//请求模型类型
    var rcType = 2 //1:mp退货 2:自营退货(上个界面传过来的) 3极速理赔
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupContentView()
        requestBankInfo()
    }
    // 导航栏
    fileprivate func setupNavigationBar() {
        // 标题
        fky_setupTitleLabel("填写退款信息")
        // 分隔线
        fky_hiddedBottomLine(false)
        
        // 返回
        fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
    }
    // 内容视图
    fileprivate func setupContentView() {
        view.backgroundColor = RGBColor(0xF4F4F4)
        
        view.addSubview(submitView)
        submitView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(bootSaveHeight()+WH(62))
        }
        
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(submitView.snp.top)
            make.top.equalTo(self.navBar!.snp.bottom)
        }
    }

}

//:MARK: 事件响应
extension RCSubmitBankViewController {
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKY_popBankSelector {//弹出银行选择器
            presentBankVC()
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
            strongSelf.bankType = bank.id
            strongSelf.viewModel?.cellModel.inputText = bank.name
            strongSelf.tableview.reloadData()
        }
        self.present(bankVC, animated: true) {
            
        }
    }
}

//:MARK: 网络请求
extension RCSubmitBankViewController {
    
    func requestBankInfo(){
        var param = ["rmaBizType":0]
        if self.rcType == 3 {
            param["rmaBizType"] = 1
        }
        self.viewModel?.requestBankInfo(param,block: { (success, msg) in
            guard success else{
                self.toast(msg)
                return
            }
            self.bankType = self.viewModel?.bankInfoModel.bankTypeVO.id ?? ""//银行ID
            self.bankName = self.viewModel?.bankInfoModel.bankName//银行开户行
            self.bankAccount = self.viewModel?.bankInfoModel.bankCardNo//银行卡号
            self.userName = self.viewModel?.bankInfoModel.accountName//开户名名称
            self.tableview.reloadData()
        })
    }
    
    func submitBankInfo(){
        view.endEditing(true)
        let statusStr = self.checkSubmitBankStatus()
        guard statusStr.count == 0 else {
            // 不合法
            toast(statusStr)
            return
        }
        if let bankViewModel = self.viewModel {
            bankViewModel.bankName = self.bankName
            bankViewModel.bankAccount = self.bankAccount
            bankViewModel.userName = self.userName
            bankViewModel.bankType = self.bankType
            showLoading()
            let isMp = (rcType == 1 ? true : false)
            bankViewModel.submitRCInfo(bankViewModel.returnFlag,isMp) { [weak self] (success, msg) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.dismissLoading()
                guard success else {
                    // 失败
                    strongSelf.toast(msg ?? "提交失败")
                    return
                }
                // 成功
                strongSelf.toast(msg ?? "提交成功")
                // 发通知...<申请记录需刷新>
                NotificationCenter.default.post(name: NSNotification.Name.FKYRCSubmitApplyInfo, object: self, userInfo: nil)
                // 提交成功，返回到申请记录列表
                FKYNavigator.shared()?.pop(toScheme: FKY_AfterSaleListController.self)
                
            }
        }
    }
    //验证输入字段
    func checkSubmitBankStatus() -> String {
        
        guard (!self.bankType.isEmpty) else {
            return "请选择银行"
        }
        guard let bName = bankName, bName.isEmpty == false else {
            return "请输入开户行"
        }
        guard bName.count >= 2, bName.count <= 50 else {
            return "开户行长度不符"
        }
        guard let bAccount = bankAccount, bAccount.isEmpty == false else {
            return "请输入银行账户"
        }
        //只有纯数据才当成银行账户
        guard NSString.validateOnlyNumber( bAccount) == true else {
           return  "请输入正确的银行账户！"
        }
//        guard bAccount.count >= 10, bAccount.count <= 30 else {
//            return  "银行账户长度不符"
//        }
        guard let uName = userName, uName.isEmpty == false else {
            return  "请输入开户名"
        }
        guard uName.count >= 2, uName.count <= 50 else {
            return  "开户名长度不符"
        }
        return ""
    }
}
//:MARK: UITableViewDelegate, UITableViewDataSource
extension RCSubmitBankViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(45)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RCSendInfoCell") as! RCSendInfoCell
        // 配置cell
        var title = ""
        var content = ""
        var placeholderStr = ""
        var type: RCInputType = .sendOrderId
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            title = "开户行"
            type = .bankName
            content = self.bankName ?? ""
            placeholderStr = "请填写您的开户行"
        }
        else if indexPath.row == 1 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYInvoiceInfoInputCell.self)) as! FKYInvoiceInfoInputCell
            cell1.showData(cellData: self.viewModel?.cellModel ?? FKYInvoiceCellModel())
            cell1.accessoryButtonMarginLine.isHidden = false
            cell1.saleReturnLayout()
            return cell1
        }
        else if indexPath.row == 2 {
            title = "银行账户"
            type = .bankAccount
            content = self.bankAccount ?? ""
            placeholderStr = "请填写您的银行账户"
        }
        else if indexPath.row == 3 {
            title = "开户名"
            type = .userName
            content = self.userName ?? ""
            placeholderStr = "请填写您的开户名"
        }
        cell.configBankInfoCell(title: title,placeholderStr:placeholderStr ,content: content, type: type)
        //回调
        cell.inputOver = { [unowned self] (content: String?, type: RCInputType) -> Void in
            // 保存
            switch type {
            case .bankName:
                // 开户行
                self.bankName = content
            case .bankAccount:
                // 银行账户
                self.bankAccount = content
            case .userName:
                // 开户名
                self.userName = content
            case .sendOrderId: break

            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(11)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return WH(0.0001)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
