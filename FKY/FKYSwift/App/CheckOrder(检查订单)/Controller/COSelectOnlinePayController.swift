//
//  COSelectOnlinePayController.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/23.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [生成订单成功后]选择在线支付方式...<前提是提交订单时选择的一级支付类型为在线支付方式>

import UIKit

class COSelectOnlinePayController: UIViewController, FKY_SelectOnlinePay {
    
    enum fromViewType {
        /// 未设置
        case noType
        /// 充值购物金页面
        case shoppingMoney
    }
    
    var supplyIdList: [Any] = [] // 父订单供应商列表
    //MARK: - Property
    
    // 上个界面传来的值
    var supplyId: String?           // 供应商id
    var orderId: String?            // 订单号
    var orderType: String?          // 订单类型 1:一起购
    var orderMoney: String?         // 订单金额
    var countTime: String?          // 订单失效时间间隔...<订单入口会传时间间隔>
    var invalidTime: String?        // 订单失效时间...<购物车/检查订单入口只传失效时间戳,需手动取手机时间来计算
    var flagFromCO: Bool = false    // 判断是否从检查订单界面跳转过来...<默认为否>
    var fromePage:fromViewType = .noType
    // 默认用户在当前界面没有支付操作
    fileprivate var hasPayAction = false
    // 用户有绑卡操作返回的时候刷新支付列表
    fileprivate var hasBlindCardAction = false
    
    // viewmodel
    fileprivate lazy var viewModel: COOnlinePayViewModel = {
        let vm = COOnlinePayViewModel()
        vm.supplyId = self.supplyId
        vm.orderId = self.orderId
        vm.orderType = self.orderType
        vm.orderMoney = self.orderMoney
        vm.flagFromCO = self.flagFromCO
        vm.supplyIdList = self.supplyIdList
        return vm
    }()
    
    // 支付service
    fileprivate lazy var payService: FKYPayManage = {
        let service = FKYPayManage()
        return service
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
        view.backgroundView = nil
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.estimatedRowHeight = WH(58)
        view.tableHeaderView = self.infoView
        view.tableFooterView = UIView.init(frame: CGRect.zero)
        view.register(COOnlinePayTypeCell.self, forCellReuseIdentifier: "COOnlinePayTypeCell")
        view.register(COOnlinePayUnfoldCell.self, forCellReuseIdentifier: NSStringFromClass(COOnlinePayUnfoldCell.self))
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    // 订单信息视图...<table-header>
    fileprivate lazy var infoView: COPayInfoView = {
        var height = WH(111)
        if self.fromePage != .shoppingMoney {
            height += WH(15)
        }
        let view = COPayInfoView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height))
        return view
    }()
    // 底部视图...<确定>
    fileprivate lazy var viewBottom: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(62)))
        view.backgroundColor = RGBColor(0xFFFFFF)
        // 按钮
        view.addSubview(self.btnPay)
        self.btnPay.snp.makeConstraints { (make) in
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
    fileprivate lazy var btnPay: UIButton = {
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
        btn.setTitle("立即支付", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(3)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.payAction()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    // 花呗分期选择视图
    fileprivate lazy var instalmentView: COInstalmentPayView = {
        let view = COInstalmentPayView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(0)))
        // 选中项回调
        view.selectBlock = { [weak self] (indexSelected) in
            guard let strongSelf = self else {
                return
            }
            print("当前选中索引:" + "\(indexSelected)")
            // 保存
            strongSelf.viewModel.selectedAlipayIndex = indexSelected
            // 刷新
            strongSelf.tableview.reloadData()
        }
        return view
    }()
    //上海银行快捷支付方式银行卡选择按钮
    fileprivate lazy var bankQuickPayView: COBankQuickPayView = {
        let view = COBankQuickPayView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(0)))
        // 绑定新卡或者更换银行卡 1绑定银行卡 2 换卡
        view.quickPayCardChangeBlock = { [weak self] (type)in
            guard let strongSelf = self else {
                return
            }
            strongSelf.hasBlindCardAction = true
            if type == 1 {
                FKYNavigator.shared()?.openScheme(FKY_AddBankCard.self, setProperty: { (vc) in
                    let bandingCardVC = vc as! FKYAddBankCardVC
                    bandingCardVC.editerType = type
                })
            }else if type == 2{
                FKYNavigator.shared()?.openScheme(FKY_AddBankCard.self, setProperty: { (vc) in
                    let bandingCardVC = vc as! FKYAddBankCardVC
                    bandingCardVC.editerType = type
                    bandingCardVC.realName = strongSelf.viewModel.realName  //真实姓名必传
                    bandingCardVC.idCardNo = strongSelf.viewModel.idCardNo  //身份证号必传
                })
            }
            
        }
        //协议选中操作
        view.aggreeSelectBlock = { [weak self] in
            guard let _ = self else {
                return
            }
            //strongSelf.viewModel.aggreementSelectState =  !strongSelf.viewModel.aggreementSelectState
        }
        //查看协议
        view.checkAggrementBlock = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            (UIApplication.shared.delegate as! AppDelegate).p_openPriveteSchemeString("https://m.yaoex.com/web/h5/maps/index.html?pageId=101511&type=release")
        }
        return view
    }()
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupData()
        setupRequest()
        self.saveOrderID()
        // 前台进入后台
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackgroundAfterPayAction), name: UIApplication.didEnterBackgroundNotification, object: nil)
        // 后台进入前台
        NotificationCenter.default.addObserver(self, selector: #selector(enterAppAfterPayAction), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.hasBlindCardAction == true{
            self.hasBlindCardAction = false
            setupRequest()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dismissLoading()
        //removeCheckOrderController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    deinit {
        print("COSelectOnlinePayController deinit~!#")
        
        // 中止倒计时timer
        infoView.stopCount()
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 事件响应
extension COSelectOnlinePayController {
    
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == COOnlinePayUnfoldCell.FKY_ShowHidePayWayAction {// 展开隐藏支付方式事件
            self.viewModel.isUnfoldHidePayWay = true
            self.viewModel.organizeHideOrShowPayList()
            self.tableview.reloadData()
        }
    }
}

// MARK: - UI
extension COSelectOnlinePayController {
    // UI绘制
    fileprivate func setupView() {
        setupNavigationBar()
        setupContentView()
    }
    
    // 导航栏
    fileprivate func setupNavigationBar() {
        // 标题
        fky_setupTitleLabel("选择在线支付方式")
        // 分隔线
        fky_hiddedBottomLine(false)
        
        // 返回
        fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            // 弹框
            let alert = COAlertView.init(frame: CGRect.zero)
            alert.configView("当前订单未支付完成，您是否仍要退出当前页面？", "退出", "继续支付", "", .twoBtn)
            alert.showAlertView()
            //weak var weakSelf = self
            alert.leftBtnActionBlock = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                print("退出")
                strongSelf.backAction()
                //FKYNavigator.shared().pop()
            }
            alert.rightBtnActionBlock = {
                // 继续
                print("继续支付")
            }
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
        
        view.addSubview(viewBottom)
        viewBottom.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(WH(62) + margin)
        }
        
        tableview.reloadData()
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(viewBottom.snp.top)
            make.top.equalTo(self.navBar!.snp.bottom)
        }
    }
}


// MARK: - Data
extension COSelectOnlinePayController {
    // 保存
    fileprivate func setupData() {
        // 保存到vm中
        viewModel.supplyId = supplyId
        viewModel.orderId = orderId
        viewModel.orderType = orderType
        viewModel.orderMoney = orderMoney
        viewModel.flagFromCO = flagFromCO
        viewModel.supplyIdList = supplyIdList
        // 显示金额与倒计时
        infoView.configView(money: orderMoney, time: invalidTime, count: countTime)
        if self.fromePage == .shoppingMoney {
            self.infoView.needPayDes()
            self.infoView.isHideTipsLB(true)
        }
    }
}


// MARK: - Request
extension COSelectOnlinePayController {
    // 请求
    fileprivate func setupRequest() {
        requestForOnlinePayList()
    }
    
    // 请求在线支付方式列表
    fileprivate func requestForOnlinePayList() {
        showLoading()
        viewModel.requestForOnlinePayList { [weak self] (success, message, data) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                strongSelf.toast(message ?? "请求失败")
                return
            }
            // 成功
            print("获取成功")
            // 刷新列表
            strongSelf.tableview.reloadData()
            // 请求上次支付方式
            strongSelf.requestForSavedOnlinePay()
        }
    }
    // 请求上次保存的在线支付方式...<失败不弹toast>
    fileprivate func requestForSavedOnlinePay() {
        showLoading()
        viewModel.requestForSavedOnlinePayType { [weak self] (success, message, data) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                //strongSelf.toast(message ?? "请求失败")
                strongSelf.showQuickPayTypeSaved()
                return
            }
            // 成功
            print("查询成功")
            // 查询
            strongSelf.showOnlinePayTypeSaved()
            // 刷新列表
            strongSelf.tableview.reloadData()
            // 判断已勾选的是否为花呗分期
            strongSelf.checkPayTypeForAlipayInstalment()
            // 判断已勾选的是否为银行快捷支付
            strongSelf.checkPayTypeForBankQuickPay()
        }
    }
    
    // 请求花呗分期列表数据
    fileprivate func requestForAlipayInstalmentList() {
        showLoading()
        viewModel.requestForAlipayInstalmentList { [weak self] (success, message, data) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                strongSelf.toast(message ?? "请求失败")
                return
            }
            // 成功
            print("获取成功")
            // 显示花呗分期详情数据
            strongSelf.instalmentView.configView(strongSelf.viewModel.alipayList)
            let height = strongSelf.instalmentView.getContentHeight()
            strongSelf.instalmentView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height)
            // 刷新列表
            strongSelf.tableview.reloadData()
        }
    }
    // 快捷支付获取流水号并且自动发送短信
    fileprivate func requestForBankQuickPayFlowId() {
        showLoading()
        viewModel.requestForBankQuickPayFlowId { [weak self] (success, message, data) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                strongSelf.toast(message ?? "请求失败")
                return
            }
            
            // strongSelf.confirmForBankQuickPay()
            //获取流水号和短信验证码，弹出验证码窗口
            strongSelf.popVerificationView()
        }
    }
    
    /// 弹出验证码页面
    func popVerificationView(){
        if self.viewModel.quickPayPhoneNum.isEmpty == true{
            self.toast("获取手机号码失败")
            return
        }
        if let orderId = self.orderId,orderId.isEmpty == true{
            self.toast("订单为空")
            return
        }
        let verificationVC = FKYAddBankCardVerificationCodeVC()
        verificationVC.modalPresentationStyle = .overFullScreen
        verificationVC.fromViewType = .selectPayView
        verificationVC.orderID = self.orderId ?? ""
        verificationVC.phoneNumber = self.viewModel.quickPayPhoneNum
        /// 验证成功的回调
        /// isSuccess是否验证成功
        /// inputVeridicationCode用户输入的验证码
        /// codeRequestNo短信验证码下发请求流水号 绑卡界面用的
        /// quickPayFlowId快捷支付流水号 选择支付方式界面用的
        /// errorMsg错误信息
        verificationVC.verificationResult = {[weak self] (isSuccess,inputVeridicationCode,codeRequestNo,quickPayFlowId,errorMsg) in
            guard let strongSelf = self else {
                return
            }
            if isSuccess == true{
                strongSelf.viewModel.quickPaySmsCode = inputVeridicationCode
                if quickPayFlowId.isEmpty == false{
                    strongSelf.viewModel.quickPayFlowId = quickPayFlowId
                }
                //确认支付
                strongSelf.confirmForBankQuickPay()
            }else{
                strongSelf.toast(errorMsg)
            }
        }
        self.present(verificationVC, animated: false) {}
    }
    
    //快捷支付 支付确认接口
    fileprivate func confirmForBankQuickPay() {
        //判断验证码是否正确
        if viewModel.quickPaySmsCode.isEmpty == true{
            self.toast("短信验证码为空")
            return
        }
        if !(viewModel.quickPaySmsCode.count == 6 || viewModel.quickPaySmsCode.count == 4){
            self.toast("输入短信验证码错误")
            return
        }
        let reg = "^[0-9]+$"
        let pre = NSPredicate(format: "SELF MATCHES %@", reg)
        if !pre.evaluate(with: viewModel.quickPaySmsCode) {
            self.toast("输入短信验证码错误")
            return
        }
        //判断是否有流水号
        if viewModel.quickPayFlowId.isEmpty == true{
            self.toast("快捷支付流水号为空")
            return
        }
        showLoading()
        viewModel.confirmForBankQuickPay { [weak self] (success, message, data) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                if strongSelf.fromePage == .shoppingMoney {// 从购物金充值界面进来
                    return
                }
                strongSelf.toast(message ?? "支付失败")
                strongSelf.jumpToOrderList()
                return
            }
            // 成功
            print("支付成功")
            strongSelf.quickPaySuccess()
        }
    }
}
//strongSelf.dismissLoading()
//          strongSelf.logicForPaysuccess()
//      }) { [weak self] (msg) in
//          // 失败
//          guard let strongSelf = self else {
//              return
//          }
//          strongSelf.dismissLoading()
//          strongSelf.toast(msg)
//          strongSelf.jumpToOrderList()
// MARK: - Notification
extension COSelectOnlinePayController {
    // 前台进入后台
    @objc func enterBackgroundAfterPayAction() {
        if hasPayAction {
            //jumpToOrderList()
        }
    }
    
    // 后台进入前台时，若之前有支付操作，则不管是成功还是失败，均pop当前vc
    @objc func enterAppAfterPayAction() {
        // 解决用户选择支付宝支付跳转到支付宝app后，不通过支付宝app返回应用，而是手动进入应用，从而导致loading不消失的bug
        // 根本原因是调支付宝支付时，不会走回调block，故loading一直显示
        dismissLoading()
    }
}


// MARK: - Private
extension COSelectOnlinePayController {
    // 返回...<统一跳转到订单列表>
    fileprivate func backAction() {
        //FKYNavigator.shared().pop()
        //jumpToOrderList()
        
        // 从个人中心之订单列表入口进入
        guard flagFromCO == true else {
            // 直接返回(订单列表)...<全部 or 待付款>
            FKYNavigator.shared().pop()
            return
        }
        
        // 初始化订单列表界面vc
        let controller = FKYAllOrderViewController.init()
        controller.status = "1"
        
        // 先移除当前vc，再跳转到下个vc
        if self.navigationController != nil{
            var vcs = Array.init(self.navigationController!.viewControllers)
            vcs.removeLast()
            vcs.append(controller)
            self.navigationController!.setViewControllers(vcs, animated: true)
        }
        
    }
    
    // 支付
    fileprivate func payAction() {
        // 支付时必须要有订单号
        guard let oid = orderId, oid.isEmpty == false else {
            toast("订单号为空，无法支付")
            return
        }
        
        // 若支付方式列表获取失败，则需要再次请求
        guard viewModel.payList.count > 0 else {
            requestForOnlinePayList()
            return
        }
        
        guard let type = viewModel.selectedPayType else {
            toast("请选择支付方式")
            return
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName: nil, itemId: "I9400", itemPosition: "0", itemName: "立即支付", itemContent: orderId, itemTitle: nil, extendParams: nil, viewController: self)
        /// 当前为花呗支付 花呗和花呗分期是两种不同的支付方式
//        if type == .HuaBei{
//
//        }
        
        // 当前为花呗分期支付方式
        if type == .instalmentPay {
            // 花呗分期数据获取失败，则需要再次请求
            guard viewModel.alipayList.count > 0 else {
                requestForAlipayInstalmentList()
                return
            }
            
            // 未选择分期类型，则不可支付
            guard let index = viewModel.selectedAlipayIndex, index >= 0, index < viewModel.alipayList.count else {
                toast("请选择花呗分期方式")
                return
            }
        }
        
        // 当前为微信支付
        if type == .wechatPay {
            // 判断微信是否已安装
            guard payService.isWXAppInstall() else {
                toast("未安装微信")
                return
            }
        }
        
        // 当前为银行快捷支付
        if type == .shBankQuickPay {
            // 判断是否已经绑定过银行卡
            guard viewModel.blindQuickPayBankCard == true else {
                //没有绑定过银行卡 跳到榜卡页面
                self.hasBlindCardAction = true
                FKYNavigator.shared()?.openScheme(FKY_AddBankCard.self, setProperty: { (vc) in
                    let bandingCardVC = vc as! FKYAddBankCardVC
                    bandingCardVC.editerType = 1
                })
                return
            }
            //            guard viewModel.aggreementSelectState == true else {
            //                //没有同意支付协议
            //                toast("请阅读并勾选《上海银行电商资金管理业务服务协议》")
            //                return
            //            }
        }
        /********************************/
        
        // 开始支付
        switch type {
        // 花呗支付 花呗和花呗分期是两种不同的支付方式
        case .HuaBei:
            print("花呗支付")
            self.AlipayHuaBei(oid)
        case .aliPay:
            // 支付宝支付
            print("支付宝支付")
            alipayAction(oid)
        case .wechatPay:
            // 微信支付
            print("微信支付")
            wechatPayAction(oid)
        case .loanPay:
            // 1药贷
            print("1药贷")
            loanPayAction(oid)
        case .instalmentPay:
            // 花呗分期
            print("花呗分期")
            alipayInstalmentPayAction(oid)
        case .agentPay:
            // 找人代付
            print("找人代付")
            agentPayAction(oid)
        case .unionPay:
            // 银联支付
            print("银联支付")
            unionPayAction(oid)
        case .shBankQuickPay:
            // 银联支付
            print("快捷支付")
            bankQuickPayAction(oid)
        default:
            print("其它支付类型")
            toast("暂不支持当前支付方式")
        }
    }
    // 若上次支付方式没得，则看是有有选择过，然后更新选中信息,主要针对快捷支付
    fileprivate func showQuickPayTypeSaved() {
        guard let selectedIndex = viewModel.selectedIndex else {
            return
        }
        //没有绑定过银行卡
        viewModel.blindQuickPayBankCard = false
        viewModel.idCardNo = ""
        viewModel.realName = ""
        for (index, value) in viewModel.payList.enumerated() {
            let item = value as PayTypeItemModel
            if let pid = item.payTypeId {
                if index == selectedIndex{
                    // 保存选中的支付方式
                    if pid.intValue == 26 {
                        //快捷支付 银行卡支付
                        //btnPay.setTitle("使用快捷支付", for: .normal)
                        btnPay.setTitle("使用\(item.payTypeDesc ?? "")", for: .normal)
                        if let payTypeExcDesc = item.payTypeExcDesc,payTypeExcDesc.isEmpty == false{
                            //绑定过银行卡
                            viewModel.blindQuickPayBankCard = true
                            viewModel.idCardNo = item.idCardNo ?? ""
                            viewModel.realName = item.realName ?? ""
                        }
                    }else if pid.intValue == 20 {
                        //花呗分期支付
                        //btnPay.setTitle("使用花呗分期支付", for: .normal)
                        btnPay.setTitle("使用\(item.payTypeDesc ?? "")", for: .normal)
                    }else{
                        btnPay.setTitle("使用\(item.payTypeDesc ?? "")", for: .normal)
                    }
                    viewModel.selectedPayType = viewModel.getOnlinePayTypeForSaved(pid.intValue)
                    break
                }
            }
        } // for
    }
    // 若请求到上次在线支付方式，则遍历搜索并保存
    fileprivate func showOnlinePayTypeSaved() {
        guard let type = viewModel.payTypeId, type > 0 else {
            return
        }
        guard viewModel.payList.count > 0 else {
            return
        }
        for (index, value) in viewModel.payList.enumerated() {
            let item = value as PayTypeItemModel
            if let pid = item.payTypeId, pid.intValue == type {
                // 保存选中的索引
                viewModel.selectedIndex = index
                // 保存选中的支付方式
                if type == 26 {
                    //快捷支付
                    //btnPay.setTitle("使用快捷支付", for: .normal)
                    btnPay.setTitle("使用\(item.payTypeDesc ?? "")", for: .normal)
                }else if type == 20 {
                    //花呗分期支付
                    //btnPay.setTitle("使用花呗分期支付", for: .normal)
                    btnPay.setTitle("使用\(item.payTypeDesc ?? "")", for: .normal)
                }else{
                    btnPay.setTitle("使用\(item.payTypeDesc ?? "")", for: .normal)
                }
                viewModel.selectedPayType = viewModel.getOnlinePayTypeForSaved(type)
                break
            }
        } // for
    }
    // 若上次支付方式为上海银行，则需要实时请求银行数据
    fileprivate func checkPayTypeForBankQuickPay() {
        viewModel.showQuickPay = false
        //没有绑定过银行卡
        viewModel.blindQuickPayBankCard = false
        viewModel.idCardNo = ""
        viewModel.realName = ""
        guard let index = viewModel.selectedIndex, index >= 0 else {
            return
        }
        guard let type = viewModel.selectedPayType, type == .shBankQuickPay else {
            return
        }
        if viewModel.payList.count <= index{
            return
        }
        let item: PayTypeItemModel = viewModel.payList[index]
        // 是快捷支付
        viewModel.showQuickPay = true
        if let payTypeExcDesc = item.payTypeExcDesc,payTypeExcDesc.isEmpty == false{
            //绑定过银行卡
            viewModel.blindQuickPayBankCard = true
            viewModel.idCardNo = item.idCardNo ?? ""
            viewModel.realName = item.realName ?? ""
        }else{
            //没有绑定过银行卡
            viewModel.blindQuickPayBankCard = false
        }
        tableview.reloadData()
    }
    // 若上次支付方式为花呗分期，则需要实时请求花呗分期数据
    fileprivate func checkPayTypeForAlipayInstalment() {
        viewModel.showInstalment = false
        
        guard let index = viewModel.selectedIndex, index >= 0 else {
            return
        }
        guard let type = viewModel.selectedPayType, type == .instalmentPay else {
            return
        }
        
        // 是花呗分期
        viewModel.showInstalment = true
        tableview.reloadData()
        
        // 有数据
        guard viewModel.alipayList.count == 0 else {
            return
        }
        
        // 无数据
        requestForAlipayInstalmentList()
    }
    
    // 保存选中的支付类型及索引
    fileprivate func saveSelectedPayType(_ type: COOnlinePayType, _ index: Int) {
        //设置btn 的选择文字
        if viewModel.payList.count <= index{
            return
        }
        let item: PayTypeItemModel = viewModel.payList[index]
        if type == .shBankQuickPay {
            //btnPay.setTitle("使用快捷支付", for: .normal)
            btnPay.setTitle("使用\(item.payTypeDesc ?? "")", for: .normal)
        }else if type == .instalmentPay {
            //花呗分期支付
            //btnPay.setTitle("使用花呗分期支付", for: .normal)
            btnPay.setTitle("使用\(item.payTypeDesc ?? "")", for: .normal)
        }else{
            btnPay.setTitle("使用\(item.payTypeDesc ?? "")", for: .normal)
        }
        // 保存选中索引
        viewModel.selectedIndex = index
        // 保存选中支付方式类型
        viewModel.selectedPayType = type
        viewModel.idCardNo = ""
        viewModel.realName = ""
        if type == .shBankQuickPay {
            //选中为上海银行快捷支付
            viewModel.showQuickPay = true
            if let payTypeExcDesc = item.payTypeExcDesc,payTypeExcDesc.isEmpty == false{
                //绑定过银行卡
                viewModel.blindQuickPayBankCard = true
                viewModel.idCardNo = item.idCardNo ?? ""
                viewModel.realName = item.realName ?? ""
            }else{
                //没有绑定过银行卡
                viewModel.blindQuickPayBankCard = false
            }
        }else{
            viewModel.showQuickPay = false
            //没有绑定过银行卡
            viewModel.blindQuickPayBankCard = false
        }
        guard type == .instalmentPay else {
            // 非花呗分期
            viewModel.showInstalment = false
            return
        }
        
        // 花呗分期
        viewModel.showInstalment = true
        
        // 判断有无花呗分期列表数据...
        if viewModel.alipayList.count == 0 {
            // 无花呗分期详情数据，需实时请求
            requestForAlipayInstalmentList()
        }
        else {
            // 有花呗分期数据
            if let index = viewModel.selectedAlipayIndex, index >= 0, index < viewModel.alipayList.count {
                // 传递之前已选中的分期索引
                instalmentView.indexSelected = index
                instalmentView.reloadAllInstallmentData()
            }
        }
    }
    
    // 支付成功后的业务逻辑
    fileprivate func logicForPaysuccess() {
        if self.fromePage == .shoppingMoney {// 从购物金充值界面进来
            FKYNavigator.shared()?.pop(toScheme: FKY_ShoppingMoneyBalanceVC.self, setProperty: { (vc) in
                let shoppingMoneyInfoVC = vc as! FKYshoppingMoneyBalanceVC
                shoppingMoneyInfoVC.isNeedRefrash = true
            })
            return
        }
        // 从个人中心之订单列表入口进入
        guard flagFromCO == true else {
            FKYNavigator.shared().pop()
            return
        }
        
        // 从检查订单入口进入
        FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
            let v = vc as! FKY_TabBarController
            v.index = 4
            // 订单列表...<全部>
            FKYNavigator.shared().openScheme(FKY_AllOrderController.self, setProperty: { (vc) in
                let controller = vc as! FKYAllOrderViewController
                controller.status = "0"
            }, isModal: false)
        }, isModal: false)
    }
    
    //快捷支付成功跳到支付成功页面
    fileprivate func quickPaySuccess(){
        //FKYNavigator.shared()?.popWithoutAnimation()
        if self.fromePage == .shoppingMoney {// 从购物金充值界面进来
            FKYNavigator.shared()?.pop(toScheme: FKY_ShoppingMoneyBalanceVC.self, setProperty: { (vc) in
                let shoppingMoneyInfoVC = vc as! FKYshoppingMoneyBalanceVC
                shoppingMoneyInfoVC.isNeedRefrash = true
            })
            return
        }
        FKYNavigator.shared()?.openScheme(FKY_QuickPayOrderPayStatus.self, setProperty: { (vc) in
            let drawVC = vc as! QuickPOrderWaitPayVC
            drawVC.orderNO = self.orderId ?? ""
            drawVC.orderMoney = self.orderMoney ?? "0.0"
        })
    }
    // 支付失败后跳转订单列表界面
    // 1. 若是从检查订单入口进入当前在线支付方式界面，则需要先进入个人中心界面，再进入订单列表之待付款
    // 2. 若本身就是从订单列表（包括全部or待付款）进入当前在线支付方式界面，则直接返回
    fileprivate func jumpToOrderList() {
        // 进入个人中心之订单列表
        //        if let url = URL(string: "fky://account/allorders") {
        //            if #available(iOS 10.0, *) {
        //                UIApplication.shared.open(url, options: [:], completionHandler: nil)
        //            } else {
        //                UIApplication.shared.openURL(url)
        //            }
        //        }
        if self.fromePage == .shoppingMoney {// 从购物金充值界面进来
            FKYNavigator.shared()?.pop(toScheme: FKY_ShoppingMoneyBalanceVC.self, setProperty: { (vc) in
                let shoppingMoneyInfoVC = vc as! FKYshoppingMoneyBalanceVC
                shoppingMoneyInfoVC.isNeedRefrash = true
            })
            return
        }
        // 从个人中心之订单列表入口进入
        guard flagFromCO == true else {
            // 直接返回(订单列表)...<全部 or 待付款>
            FKYNavigator.shared().pop()
            return
        }
        
        // 从检查订单入口进入
        FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
            let v = vc as! FKY_TabBarController
            v.index = 4
            // 订单列表...<待付款>
            FKYNavigator.shared().openScheme(FKY_AllOrderController.self, setProperty: { (vc) in
                let controller = vc as! FKYAllOrderViewController
                controller.status = "1"
            }, isModal: false)
        }, isModal: false)
    }
    
    // 移除检查订单页vc...<不使用>
    fileprivate func removeCheckOrderController() {
        // 从个人中心之订单列表入口进入
        guard flagFromCO == true else {
            return
        }
        
        // 从检查订单入口进入
        guard let navController = self.navigationController else {
            return
        }
        guard navController.viewControllers.count > 0 else {
            return
        }
        var flagFind = false
        var list = [UIViewController]()
        let controllers = navController.viewControllers
        for item: UIViewController in controllers {
            if item is CheckOrderController {
                // 找到检查订单vc
                flagFind = true
                break
            }
            else {
                list.append(item)
            }
        }
        if flagFind == true, list.count > 0 {
            navController.setViewControllers(list, animated: false)
        }
    }
}


// MARK: - Online Pay
extension COSelectOnlinePayController {
    /// 花呗支付
    fileprivate func AlipayHuaBei(_ oid: String){

        // 有支付操作
        hasPayAction = true
        var orderType = ""
        if self.orderType == "2" {
            orderType = self.orderType ?? ""
        }
        
        showLoading()
        payService.alipayHuaBeiPay(withPayflowId: oid,andOrderType: orderType, successBlock: { [weak self] in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.logicForPaysuccess()
        }) { [weak self] (msg) in
            // 失败
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.toast(msg)
            if strongSelf.fromePage == .shoppingMoney {// 从购物金充值界面进来
                return
            }
            strongSelf.jumpToOrderList()
        }
    
    }
    /*
    fileprivate func alipayInstalmentPayAction(_ oid: String) {
        // 有支付操作
        hasPayAction = true
        var orderType = ""
        if self.orderType == "2" {
            orderType = self.orderType ?? ""
        }
        // 必须选择花呗分期支付方式、且分期项也已选择
        guard let index = viewModel.selectedAlipayIndex, index >= 0, viewModel.alipayList.count > 0, index < viewModel.alipayList.count else {
            toast("请选择花呗分期方式")
            return
        }
        
        // 分期model
        let model: COAlipayInstallmentItemModel = viewModel.alipayList[index]
        // 分期数
        var instalmentNumber: String = ""
        if let number = model.hbFqNum {
            instalmentNumber = "\(number)"
        }
        
        showLoading()
        payService.huaBeiPay(withPayflowId: oid, andInstallmentNum: instalmentNumber, andOrderType: orderType, successBlock: { [weak self] in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.logicForPaysuccess()
        }) { [weak self] (msg) in
            // 失败
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.toast(msg)
            strongSelf.jumpToOrderList()
        }
    }
    */
    
    //快捷支付
    fileprivate func bankQuickPayAction(_ oid: String) {
        // 有支付操作
        hasPayAction = true
        self.requestForBankQuickPayFlowId()
    }
    // 银联支付
    fileprivate func unionPayAction(_ oid: String) {
        // 有支付操作
        hasPayAction = true
        
        // 金额
        var amount: Float = 0.0
        if let money = orderMoney, money.isEmpty == false, let value = Float(money), value > 0 {
            amount = value
        }
        
        showLoading()
        payService.unionPay(withPayflowId: oid, andTotalMoney: CGFloat(amount), successBlock: { [weak self] in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.logicForPaysuccess()
        }) { [weak self] (msg) in
            // 失败
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.toast(msg)
            strongSelf.jumpToOrderList()
        }
    }
    
    // 微信支付...<跳微信App>
    fileprivate func wechatPayAction(_ oid: String) {
        // 有支付操作
        hasPayAction = true
        var orderType = ""
        if self.orderType == "2" {
            orderType = self.orderType ?? ""
        }
        showLoading()
        payService.weixinPay(withPayflowId: oid, andOrderType: orderType, successBlock: { [weak self] in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.logicForPaysuccess()
        }) { [weak self] (msg) in
            // 失败
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.toast(msg)
            strongSelf.jumpToOrderList()
        }
    }
    
    // 支付宝支付...<跳支付宝App>
    fileprivate func alipayAction(_ oid: String) {
        // 有支付操作
        hasPayAction = true
        var orderType = ""
        if self.orderType == "2" {
            orderType = self.orderType ?? ""
        }
        // 金额
        var amount: Float = 0.0
        if let money = orderMoney, money.isEmpty == false, let value = Float(money), value > 0 {
            amount = value
        }
        
        showLoading()
        // 说明：若支付宝已被调起（跳转支付宝成功），则不管用户支付是否成功，均不会走下面的成功or失败block～！@
        payService.alipay(withPayflowId: oid, andTotalMoney: CGFloat(amount),andOrderType:orderType, successBlock: { [weak self] in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.logicForPaysuccess()
        }) { [weak self] (msg) in
            // 失败
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.toast(msg)
            strongSelf.jumpToOrderList()
        }
        
        // 需实时移除当前支付方式界面~!@
        // todo
    }
    
    // 花呗分期...<跳支付宝App>
    fileprivate func alipayInstalmentPayAction(_ oid: String) {
        // 有支付操作
        hasPayAction = true
        var orderType = ""
        if self.orderType == "2" {
            orderType = self.orderType ?? ""
        }
        // 必须选择花呗分期支付方式、且分期项也已选择
        guard let index = viewModel.selectedAlipayIndex, index >= 0, viewModel.alipayList.count > 0, index < viewModel.alipayList.count else {
            toast("请选择花呗分期方式")
            return
        }
        
        // 分期model
        let model: COAlipayInstallmentItemModel = viewModel.alipayList[index]
        // 分期数
        var instalmentNumber: String = ""
        if let number = model.hbFqNum {
            instalmentNumber = "\(number)"
        }
        
        showLoading()
        payService.huaBeiPay(withPayflowId: oid, andInstallmentNum: instalmentNumber, andOrderType: orderType, successBlock: { [weak self] in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.logicForPaysuccess()
        }) { [weak self] (msg) in
            // 失败
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.toast(msg)
            strongSelf.jumpToOrderList()
        }
    }
    
    // 1药贷支付
    fileprivate func loanPayAction(_ oid: String) {
        showLoading()
        payService.loanPay(withPayflowId: oid, enterpriseId: (supplyId ?? ""), successBlock: { [weak self] (data) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            
            // 请求成功，且1药贷支付可用
            /*
             {
             "data": {
             "businessCode": "0",
             "msg": "调用成功",
             "url": "http://uat.fosuntech.cn/transfer-mng//wap/yyw/pay/pay-apply.html?accesss_token=566e1ae592c0459fba1b68555428dbe4"
             },
             "rtn_code": "0",
             "rtn_ext": "",
             "rtn_ftype": "0",
             "rtn_msg": "",
             "rtn_tip": ""
             }
             */
            
            // 请求成功，但1药贷支付不可用
            /*
             {
             "data": {
             "businessCode": "-1",
             "msg": "很抱歉，暂时无法获取您的1药贷额度信息，您可以先选择其它的支付方式",
             "url": ""
             },
             "rtn_code": "0",
             "rtn_ext": "",
             "rtn_ftype": "0",
             "rtn_msg": "",
             "rtn_tip": ""
             }
             */
            
            if let dic: NSDictionary = data as NSDictionary? {
                // 有数据返回
                guard let code = dic["businessCode"] else {
                    strongSelf.toast("支付结果异常")
                    return
                }
                
                // 状态值...<默认2:不可识别>
                var status = 2
                if code is NSString {
                    let value: NSString = code as! NSString
                    status = Int(value.intValue)
                }
                else if code is NSNumber {
                    let value: NSNumber = code as! NSNumber
                    status = value.intValue
                }
                
                //let status = dic["businessCode"].intValue
                if status == 0 {
                    // 允许支付，解析url
                    
                    // 有支付操作...<放在里面>
                    strongSelf.hasPayAction = false
                    
                    var url = ""
                    if let content: String = dic["url"] as? String, content.isEmpty == false {
                        url = content
                    }
                    
                    // 直接跳转到复星支付H5页面
                    FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                        let v = vc as! FKY_Web
                        v.urlPath = url
                        v.fromFuson = true  // 修复进入复星支付H5后，无法返回的问题
                    })
                }
                else if status == 1 || status == -1 {
                    // 1:额度不足 -1:额度查询异常
                    
                    var tip = "支付失败"
                    if let content: String = dic["msg"] as? String, content.isEmpty == false {
                        tip = content
                    }
                    
                    let alert = COAlertView.init(frame: CGRect.zero)
                    alert.configView(tip, "", "", "重新选择", .oneBtn)
                    alert.showAlertView()
                    alert.doneBtnActionBlock = {
                        // 不做操作
                    }
                }
                else {
                    // 支付结果异常
                    strongSelf.toast("支付结果异常")
                }
            }
            else {
                // 无数据返回
                strongSelf.toast("支付结果异常")
            }
        }) { [weak self] (msg) in
            // 失败
            guard let strongSelf = self else {
                return
            }
            
            // 请求失败
            /*
             {
             "data": null,
             "rtn_code": "-3",
             "rtn_ext": "",
             "rtn_ftype": "0",
             "rtn_msg": "出问题了",
             "rtn_tip": "出问题了"
             }
             */
            
            strongSelf.dismissLoading()
            strongSelf.toast(msg)
        }
    }
    
    // 找人代付
    fileprivate func agentPayAction(_ oid: String) {
        //         跳转到找人代付界面
        //                FKYNavigator.shared().openScheme(FKY_FindPeoplePay.self, setProperty: { (vc) in
        //                    //let controller: FKY_FindPeoplePay = vc as! FKY_FindPeoplePay
        //                    let controller: FKY_FindPeoplePay = vc as! FKYFindPeoplePayViewController
        //                    controller.enterpriseId = self.supplyId
        //                    controller.orderid = self.orderId
        //                    controller.orderMoney = Float(self.orderMoney ?? "0.0") ?? 0.0
        //                    controller.flagFromCO = self.flagFromCO
        //                    //controller.schemeString = NSStringFromProtocol(FKY_FindPeoplePay.self)
        //                }, isModal: false, animated: true)
        
        // 默认用户在当前界面没有支付操作
        hasPayAction = false
        
        // 初始化找人代付界面vc
        let controller: FKYFindPeoplePayViewController = FKYFindPeoplePayViewController()
        controller.enterpriseId = self.supplyId ?? ""
        controller.orderid = self.orderId
        controller.orderMoney = Float(self.orderMoney ?? "0.0") ?? 0.0
        controller.flagFromCO = self.flagFromCO
        
        // 先移除当前vc，再跳转到下个vc
        if let navControl = self.navigationController{
            var vcs = Array.init(navControl.viewControllers)
            vcs.removeLast()
            vcs.append(controller)
            navControl.setViewControllers(vcs, animated: true)
        }else{
            //  跳转到找人代付界面
            FKYNavigator.shared().openScheme(FKY_FindPeoplePay.self, setProperty: { (vc) in
                //let controller: FKY_FindPeoplePay = vc as! FKY_FindPeoplePay
                let controller: FKY_FindPeoplePay = vc as! FKYFindPeoplePayViewController
                controller.enterpriseId = self.supplyId
                controller.orderid = self.orderId
                controller.orderMoney = Float(self.orderMoney ?? "0.0") ?? 0.0
                controller.flagFromCO = self.flagFromCO
                //controller.schemeString = NSStringFromProtocol(FKY_FindPeoplePay.self)
            }, isModal: false, animated: true)
        }
    }
}


// MARK: - UITableViewDelegate
extension COSelectOnlinePayController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard viewModel.payList.count > 0 else {
            return 0
        }
        return viewModel.payList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard viewModel.payList.count > 0 else {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(50)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModel.payList.count > 0 else {
            return UITableViewCell.init(style: .default, reuseIdentifier: "error")
        }
        guard viewModel.payList.count > indexPath.section else {
            return UITableViewCell.init(style: .default, reuseIdentifier: "error")
        }
        // 当前支付model
        let item: PayTypeItemModel = self.viewModel.payList[indexPath.section]
        
        if item.cellType == .hideCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(COOnlinePayUnfoldCell.self), for: indexPath) as! COOnlinePayUnfoldCell
            cell.selectionStyle = .none
            return cell
        }
        
        // 判断当前支付类型是否已选中...<默认未选中>
        var selected = false
        if let selectIndex = viewModel.selectedIndex, selectIndex >= 0, selectIndex == indexPath.section {
            selected = true
        }
        
        // cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "COOnlinePayTypeCell", for: indexPath) as! COOnlinePayTypeCell
        cell.selectionStyle = .default
        // 设置
        cell.configCell(item, selected)
        if let pid = item.payTypeId, pid.intValue == 20 {
            // 仅针对花呗分期
            cell.showAlipayInstalmentInfo(viewModel.getAlipayIntalmentDetail())
        }
        // 顶部分隔线设置
        cell.showBottomLine(indexPath.section == 0 ? false : true)
        // 选择在线支付方式
        cell.selectClosure = { [weak self] (type) in
            guard let strongSelf = self else {
                return
            }
            // 保存
            strongSelf.saveSelectedPayType(type, indexPath.section)
            // 刷新
            strongSelf.tableview.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return WH(11)
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let headView =  UIView.init()
            headView.backgroundColor = .white
            return headView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard viewModel.payList.count > 0, viewModel.payList.count  > section else {
            return CGFloat.leastNormalMagnitude
        }
        
        // 支付model
        let item: PayTypeItemModel = viewModel.payList[section]
        
        // 折叠展开cell
        if item.cellType == .hideCell {
            return 0.00001
        }
        
        // 花呗分期
        if let type = item.payTypeId, type == 20 {
            if viewModel.showInstalment {
                // 显示
                return instalmentView.getContentHeight()
            }
        }
        //上海银行快捷支付
        if let type = item.payTypeId, type == 26 {
            if viewModel.showQuickPay {
                // 显示
                //是否是第一次使用快捷支付
                if let payTypeExcDesc = item.payTypeExcDesc,payTypeExcDesc.isEmpty == false{
                    //绑过银行卡
                    //                    if let firstPay = item.firstPay ,firstPay == true{
                    //                        return WH(80)
                    //                    }else{
                    if item.limitDesc.isEmpty == false{// 有限额提示
                        return WH(62)
                    }
                    return WH(44)
                    //}
                }else{
                    return WH(44)
                }
                
                
            }
        }
        //底部的空白 当没有快捷支付和花呗的时候
        if section == (viewModel.payList.count - 1){
            return WH(9)
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard viewModel.payList.count > 0, viewModel.payList.count > section else {
            return nil
        }
        
        // 支付model
        let item: PayTypeItemModel = viewModel.payList[section]
        // 花呗分期
        if let type = item.payTypeId, type == 20 {
            if viewModel.showInstalment {
                // 显示
                let height = instalmentView.getContentHeight()
                return height > 0 ? instalmentView : nil
            }
        }
        //上海银行快捷支付
        if let type = item.payTypeId, type == 26 {
            if viewModel.showQuickPay {
                // 显示
                bankQuickPayView.configView(item)
                return bankQuickPayView
            }
        }
        //底部的空白 当没有快捷支付和花呗的时候
        if section == (viewModel.payList.count - 1){
            let footView =  UIView.init()
            footView.backgroundColor = .white
            return footView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 索引
        let index = indexPath.section
        // 支付model
        if viewModel.payList.count <= index{
            return
        }
        let item: PayTypeItemModel = viewModel.payList[index]
        
        // error
        guard let type = item.payTypeId, type.intValue > 0 else {
            return
        }
        
        // 不可用
        if let status = item.payTypeStatus, status.intValue == 1 {
            return
        }
        
        // 可用
        if let selectedIndex = viewModel.selectedIndex, selectedIndex == index {
            // 已选中
            return
        }
        if type.intValue == 26 {
            //快捷支付
            //btnPay.setTitle("使用快捷支付", for: .normal)
            btnPay.setTitle("使用\(item.payTypeDesc ?? "")", for: .normal)
        }else if type.intValue == 20 {
            //花呗分期支付
            //btnPay.setTitle("使用花呗分期支付", for: .normal)
            btnPay.setTitle("使用\(item.payTypeDesc ?? "")", for: .normal)
        }else{
            btnPay.setTitle("使用\(item.payTypeDesc ?? "")", for: .normal)
        }
        // 未选中...<保存>
        saveSelectedPayType(viewModel.getOnlinePayTypeForSaved(type.intValue), index)
        // 刷新
        tableview.reloadData()
    }
}

// MARK: - 将订单号存到本地
//let FKY_NewestPayOrderID = "NewestPayOrderID"
extension COSelectOnlinePayController {
    func saveOrderID(){
        let userDefault = UserDefaults.standard
        userDefault.set(self.orderId ?? "", forKey: "NewestPayOrderID")
    }
}
