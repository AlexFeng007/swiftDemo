//
//  RCSendInfoController.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/21.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退换货之回寄信息

import UIKit

class RCSendInfoController: UIViewController, FKY_RCSendInfoController {
    // MARK: - Property
    
    // 退换货申请ID...<上个界面传递过来>
    var applyId: String = ""
    
    // 类型：(退货 or 换货)...<上个界面传递过来>
    //var sendType: ReturnChangeType = .rcReturn
    var returnFlag: Bool = false
    
    // 是否线上订单...<上个界面传递过来>
    var onlineFlag: Bool = false
    
    // 收件人名称
    var addressName: String!
    // 收件人手机号
    var addressPhone: String!
    // 收件人地址
    var addressContent: String!
    // 收件人省名称
    var addressProvince: String!
    // 收件人市名称
    var addressCity: String!
    
    // viewmodel
    fileprivate lazy var viewModel: RCSendInfoViewModel = {
        let vm = RCSendInfoViewModel()
        vm.applyId = self.applyId
        vm.onlineFlag = self.onlineFlag
        return vm
    }()
    
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
        view.tableHeaderView = self.addressView
//        if self.returnFlag {
//            // 退货
//            view.tableHeaderView = {
//                let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
//                view.backgroundColor = UIColor.clear
//                return view
//            }()
//        } else {
//            // 换货
//            view.tableHeaderView = self.addressView
//        }
        view.tableFooterView = UIView.init(frame: CGRect.zero)
        view.register(RCSendInfoCell.self, forCellReuseIdentifier: "RCSendInfoCell")
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    // 地址视图...<table-header>
    fileprivate lazy var addressView: RCSendAddressView = {
        let view = RCSendAddressView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(148)))
        view.configView(self.addressContent, self.addressName, self.addressPhone)
        return view
    }()
    // 快递公司视图...<section-header>
    fileprivate lazy var companyView: RCSendCompanyView = {
        let view = RCSendCompanyView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(50)))
        view.configView(nil)
        // 弹出快递公司列表视图
        view.selectSendCompany = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.selectSendCompany()
        }
        return view
    }()
    // 提交视图...<section-footer>
    fileprivate lazy var submitView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(92)))
        view.backgroundColor = .white
        view.addSubview(self.btnSubmit)
        self.btnSubmit.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(WH(20))
            make.left.equalTo(view).offset(WH(30))
            make.right.equalTo(view).offset(WH(-30))
            make.height.equalTo(WH(42))
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
            strongSelf.submitAction()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    // 弹出视图对应的controller
    fileprivate lazy var popController: RCPopController = {
        let vc = RCPopController.init()
        vc.popType = .sendCompanyList               // 类型
        vc.popTitle = "选择快递公司"                  // 标题
        vc.contentHeight = SCREEN_HEIGHT * 2 / 3    // 内容高度
        vc.cellHeight = WH(45)                      // cell高度
        vc.showBtn = true                           // 显示底部按钮
        vc.requestBySelf = true                     // 自已请求数据
        vc.viewParent = self.view                   // 父视图
        // 选择
        vc.selectItemBlock = { [weak self] (model, index) in
            guard let strongSelf = self else {
                return
            }
            // 保存
            strongSelf.viewModel.sendCompany = model as? RCSendCompanyModel
            strongSelf.viewModel.index4Company = index as Int
            // 刷新
            strongSelf.companyView.configView(model as? RCSendCompanyModel)
        }
        return vc
    }()
    
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 开启切换
        IQKeyboardManager.shared().previousNextDisplayMode = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 隐藏切换
        IQKeyboardManager.shared().previousNextDisplayMode = .alwaysHide
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("RCSendInfoController deinit")
    }
}

// MARK: - UI
extension RCSendInfoController {
    // UI绘制
    fileprivate func setupView() {
        setupNavigationBar()
        setupContentView()
        updateAddressHeight()
    }
    
    // 导航栏
    fileprivate func setupNavigationBar() {
        // 标题
        fky_setupTitleLabel("填写回寄信息")
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
        
        var margin: CGFloat = 0
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                margin = iPhoneX_SafeArea_BottomInset
            }
        }
        
        tableview.reloadData()
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-margin)
            make.top.equalTo(self.navBar!.snp.bottom)
        }
    }
    
    // 更新地址视图高度
    fileprivate func updateAddressHeight() {
//        if !self.returnFlag {
            // 换货
            let width = SCREEN_WIDTH - WH(20) * 2
            let dic = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(13))]
            let size = addressContent.boundingRect(with: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: dic, context: nil).size
            let height = size.height + WH(2)
            var addHeight = WH(0)
            if height >= WH(64) {
                // 最多显示4行
                addHeight = WH(22)
            }
            else if height >= WH(48) {
                // 3行
                addHeight = WH(10)
            }
            else if height <= WH(20) {
                // 1行...<高度减小一点>
                addHeight = -WH(15)
            }
            addressView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(148) + addHeight)
//        }
    }
}

// MARK: - Private
extension RCSendInfoController {
    // 提交
    fileprivate func submitAction() {
        view.endEditing(true)

        let (status, msg) = viewModel.checkSendInfoStatus(onlineFlag)
        guard status == 0 else {
            // 不合法
            toast(msg)
            return
        }
        
        // 合法，提交信息
        requestForSubmitInfo()
    }
    
    // 选择快递公司
    fileprivate func selectSendCompany() {
        view.endEditing(true)
        
        // 显示
        popController.showOrHidePopView(true)
        // 传递之前已经选中项的索引，并滑到选中项
        popController.showSelectedItem(viewModel.index4Company)
    }
}

// MARK: - Request
extension RCSendInfoController {
    // 请求快递公司列表
    fileprivate func requestForSendCompanyList() {
        //
    }
    
    // 提交回寄信息
    fileprivate func requestForSubmitInfo() {
        showLoading()
        viewModel.submitSendInfo(applyId) { [weak self] (success, msg) in
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
//            strongSelf.toast(msg ?? "提交成功")
            // 发通知
            NotificationCenter.default.post(name: NSNotification.Name.FKYRCSubmitBackInfo, object: self, userInfo: nil)
            // 返回
//            strongSelf.navigationController?.popViewController(animated: true)
            // 提交成功后调用一下订阅物流信息接口
            strongSelf.requestForSubscribeSendInfo(msg)
        }
    }
    
    // 订阅物流信息
    fileprivate func requestForSubscribeSendInfo(_ message: String?) {
        showLoading()
        viewModel.subcribeSendInfo(addressProvince, addressCity) { [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            // 无论成功与失败，均提示(提交回寄信息)成功
            strongSelf.dismissLoading()
            // 成功
            strongSelf.toast(message ?? "提交成功")
            // 返回
            strongSelf.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITableViewDelegate
extension RCSendInfoController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onlineFlag ? 1 : 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(50)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RCSendInfoCell", for: indexPath) as! RCSendInfoCell
        // 配置cell
        var title = ""
        var content = ""
        var type: RCInputType = .sendOrderId
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            title = "快递单号"
            type = .sendOrderId
            if let sendOrder = viewModel.sendOrder, sendOrder.isEmpty == false {
                content = sendOrder
            }
        }
        else if indexPath.row == 1 {
            title = "开户行"
            type = .bankName
            if let bankName = viewModel.bankName, bankName.isEmpty == false {
                content = bankName
            }
        }
        else if indexPath.row == 2 {
            title = "银行账户"
            type = .bankAccount
            if let bankAccount = viewModel.bankAccount, bankAccount.isEmpty == false {
                content = bankAccount
            }
        }
        else if indexPath.row == 3 {
            title = "开户名"
            type = .userName
            if let userName = viewModel.userName, userName.isEmpty == false {
                content = userName
            }
        }
        cell.configCell(title: title, content: content, type: type)
        // 回调
        cell.inputOver = { [unowned self] (content: String?, type: RCInputType) -> Void in
            // 保存
            switch type {
            case .sendOrderId:
                // 快递单号
                self.viewModel.sendOrder = content
            case .bankName:
                // 开户行
                self.viewModel.bankName = content
            case .bankAccount:
                // 银行账户
                self.viewModel.bankAccount = content
            case .userName:
                // 开户名
                self.viewModel.userName = content
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(50)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return companyView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return WH(92)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return submitView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

