//
//  CheckOrderController.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  检查订单

import UIKit

class CheckOrderController: UIViewController, FKY_CheckOrder {
    
    
    // MARK: - Property
    
    // [一起购来源 "1":立即认购 "2":购物车]...<普通商品默认传0> 5:包邮秒杀-立即下单
    var fromWhere: Int32 = 0
    // 购物车中各商品id列表
    var shoppingCartIds: [Any]?
    // 判断是否为[一起购]
    var productArray: [Any]?
    // 立即下单商品列表
    var orderProductArray: [Any]?
    
    //本地记录，使用购物金时是否弹过短信验证
    var buyMoneyKey: String?{
        get{
            if FKYLoginAPI.loginStatus() != .unlogin {
                if let user: FKYUserInfoModel = FKYLoginAPI.currentUser(), let userId = user.userId {
                    return "\(userId)" + "FKY_SHOP_BUY_MONENY_TAG"
                }
            }
            return "FKY_SHOP_BUY_MONENY_TAG"
        }
    }
    // viewmodel
    fileprivate lazy var viewModel: CheckOrderViewModel = {
        let vm = CheckOrderViewModel()
        vm.fromWhere = Int(self.fromWhere)
        vm.productArray = self.productArray
        vm.orderProductArray = self.orderProductArray
        vm.isGroupBuy = self.isGroupBuyOrder()
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
        view.backgroundView = nil
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        //view.estimatedRowHeight = WH(44)
        view.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(0.1)))
        //view.tableFooterView = UIView.init(frame: CGRect.zero)
        view.tableFooterView = {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
            view.backgroundColor = .clear
            return view
        }()
        view.register(COAddressView.self, forCellReuseIdentifier: "COAddressView")
        view.register(CODetailSelectCell.self, forCellReuseIdentifier: "CODetailSelectCell")
        view.register(COShopNameCell.self, forCellReuseIdentifier: "COShopNameCell")
        view.register(COProductListCell.self, forCellReuseIdentifier: "COProductListCell")
        view.register(COLeaveMessageCell.self, forCellReuseIdentifier: "COLeaveMessageCell")
        view.register(COProductGiftCell.self, forCellReuseIdentifier: "COProductGiftCell")
        view.register(COProductCouponCell.self, forCellReuseIdentifier: "COProductCouponCell")
        view.register(COPlatformCouponCell.self, forCellReuseIdentifier: "COPlatformCouponCell")
        view.register(COCouponCodeCell.self, forCellReuseIdentifier: "COCouponCodeCell")
        view.register(CORebateInputCell.self, forCellReuseIdentifier: "CORebateInputCell")
        view.register(COMoneyTypeCell.self, forCellReuseIdentifier: "COMoneyTypeCell")
        view.register(COPayAmountCell.self, forCellReuseIdentifier: "COPayAmountCell")
        view.register(COPayTypeSingleCell.self, forCellReuseIdentifier: "COPayTypeSingleCell")
        view.register(COPayTypeDoubleCell.self, forCellReuseIdentifier: "COPayTypeDoubleCell")
        view.register(COProductInfoCell.self, forCellReuseIdentifier: "COProductInfoCell")
        view.register(COSectionTextView.self, forCellReuseIdentifier: "COSectionTextView")
        view.register(COSaleAgreementWithProductCell.self, forCellReuseIdentifier: "COSaleAgreementWithProductCell")
        view.register(COFollowQualificationSelCell.self, forCellReuseIdentifier: "COFollowQualificationSelCell")
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    // table底部共享库存提示视图
    fileprivate lazy var viewTip: COShareStockTipView = {
        let view = COShareStockTipView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(32)))
        return view
    }()
    
    //活的返利金提示
    lazy var rebateTipView: COGetRebateTipView = {
        let view = COGetRebateTipView(frame: CGRect.zero)
        view.isHidden = true
        return view
    }()
    
    //资质过期提示
    lazy var expiredeTipView: COCredentialsExpiredHeadView = {
        let view = COCredentialsExpiredHeadView(frame: CGRect.zero)
        view.isHidden = true
        view.isUserInteractionEnabled = true
        let tapGestureMsg = UITapGestureRecognizer()
        tapGestureMsg.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            // 埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName:nil, itemId: ITEMCODE.CHECKORDER_UPDATE_CERTIFICATION_INFO.rawValue, itemPosition: "1", itemName: "更新过期证照", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            strongSelf.jumpToDataManagerForExpire()
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGestureMsg)
        return view
    }()
    
    // (底部)提交订单视图
    fileprivate lazy var viewSubmit: COSubmitView = {
        let view = COSubmitView.init(frame: CGRect.zero)
        // 提交订单
        view.submitOrder = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            // (提交订单)条件判断
            strongSelf.checkSubmitOrderStatus()
            // 埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.CHECKORDER_SUBMIT_ORDER.rawValue, itemPosition: "1", itemName: "提交订单", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        }
        view.isHidden = true
        return view
    }()
    
    // 弹出视图对应的controller...<商家的赠品列表>
    fileprivate lazy var giftListPopVC: RCPopController = {
        let vc = RCPopController.init()
        vc.popType = .showGiftList                  // 类型
        vc.popTitle = "赠品列表"                      // 标题
        vc.contentHeight = SCREEN_HEIGHT * 2 / 4    // 内容高度
        vc.cellHeight = WH(45)                      // cell高度
        vc.showBtn = false                          // 显示底部按钮
        vc.requestBySelf = false                    // 自已请求数据
        //vc.dataList = ["", "", ""]                  // 商品列表数组
        vc.viewParent = self.view                   // 父视图
        vc.updateViewStyle()                        // 更新部分UI样式
        return vc
    }()
    // 运费规则列表视图
    fileprivate lazy var frightVC: COFrightRuleListController = {
        let vc = COFrightRuleListController()
        vc.popTitle = "运费规则"                      // 标题
        vc.contentHeight = SCREEN_HEIGHT * 3 / 5    // 内容高度
        vc.cellHeight = WH(45)                      // cell高度
        vc.viewParent = self.view                   // 父视图
        return vc
    }()
    // 弹出输入视图
    fileprivate lazy var inputVC: COInputController = {
        let vc = COInputController()
        vc.viewParent = self.view
        // 输入完成回调
        vc.inputOverBlock = { [weak self] (content: String?, type: COInputType, data: Any?) in
            guard let strongSelf = self else {
                return
            }
            print("inputOverBlock")
            // 键盘隐藏
            strongSelf.view.endEditing(true)
            // 更新
            let index = strongSelf.inputVC.shopIndex
            print("当前商家索引：" + "\(index)")
            switch type {
            case .leaveMessage:
                // 留言
                print("留言:" + (content ?? ""))
                // 保存
                strongSelf.viewModel.saveLeaveMessageContent(index, content)
                strongSelf.tableview.reloadData()
            case .couponCode:
                // 优惠券码
                print("优惠券码:" + (content ?? ""))
                
                // 获取商家id
                let shopIndex = strongSelf.inputVC.shopIndex
                guard let model = strongSelf.viewModel.modelCO, let list = model.orderSupplyCartVOs, list.count > 0, list.count > shopIndex else {
                    return
                }
                let shopModel: COSupplyOrderModel = list[shopIndex]
                guard let sid = shopModel.supplyId else {
                    return
                }
                
                //优惠券码关闭
                if let closeCoupon = data as? Bool, closeCoupon == true, let closeStr = content, closeStr == "close" {
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.CHECKORDER_ACTION_LIST.rawValue, sectionPosition: "\(shopIndex+1)", sectionName: shopModel.supplyName, itemId: ITEMCODE.CHECKORDER_ORDER_COUPON_CODE.rawValue, itemPosition: "2", itemName: "关闭弹窗", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
                    return
                }
                
                // 埋点 优惠券码确定
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.CHECKORDER_ACTION_LIST.rawValue, sectionPosition: "\(shopIndex+1)", sectionName: shopModel.supplyName, itemId: ITEMCODE.CHECKORDER_ORDER_COUPON_CODE.rawValue, itemPosition: "3", itemName: "确定", itemContent: (content ?? ""), itemTitle: nil, extendParams: nil, viewController: self)
                
                // 保存
                if let code = content, code.isEmpty == false {
                    // 使用/更新...<当前返回优惠券码不为空>
                    //                    strongSelf.viewModel.saveCouponCodeContent(code, sid)
                    //                    // 实时保存用户输入的优惠码...<不论对错>...<若码错，则刷新后需立即清除>
                    //                    strongSelf.viewModel.saveLastInputCouponCodeContent(code)
                    
                    if let codeSave = strongSelf.viewModel.getCouponCodeContent(sid), codeSave.isEmpty == false {
                        // 之前的优惠券码不为空...
                        if codeSave == code {
                            // (当前用户输入的优惠券码与之前保存的优惠券码)两者相同...<不刷新>
                            strongSelf.viewModel.saveCouponCodeContent(code, sid)
                            // 实时保存用户输入的优惠码...<不论对错>...<若码错，则刷新后需立即清除>
                            strongSelf.viewModel.saveLastInputCouponCodeContent(code)
                            //return //修改逻辑不管想不相同都刷新
                        }
                        else {
                            // 两者不相同...<需要刷新>
                            strongSelf.viewModel.saveCouponCodeContent(code, sid)
                            // 实时保存用户输入的优惠码...<不论对错>...<若码错，则刷新后需立即清除>
                            strongSelf.viewModel.saveLastInputCouponCodeContent(code)
                        }
                    }
                    else {
                        // 之前的优惠券码为空...<需要刷新>
                        strongSelf.viewModel.saveCouponCodeContent(code, sid)
                        // 实时保存用户输入的优惠码...<不论对错>...<若码错，则刷新后需立即清除>
                        strongSelf.viewModel.saveLastInputCouponCodeContent(code)
                    }
                }
                else {
                    // 删除（不使用）...<当前返回优惠券码为空>
                    //strongSelf.viewModel.removeCouponCodeContent(sid)
                    
                    if let codeSave = strongSelf.viewModel.getCouponCodeContent(sid), codeSave.isEmpty == false {
                        // 之前的优惠券码不为空...<需要刷新>
                        strongSelf.viewModel.removeCouponCodeContent(sid)
                    }
                    else {
                        // 之前的优惠券码为空...<不刷新>
                        strongSelf.viewModel.removeCouponCodeContent(sid)
                        return
                    }
                }
                
                // 刷新
                strongSelf.requestForCheckOrder(true)
                
                
            case .rebateNumber:
                // 返利抵扣金额
                print("返利抵扣金额:" + (content ?? ""))
                
                // 商家索引
                let shopIndex = strongSelf.inputVC.shopIndex
                // 获取当前商家已使用(保存)的返利金数额
                let valueSave = strongSelf.viewModel.getRebateInputContent(shopIndex)
                let valueRebateSave = String(format: "%.2f", valueSave) // 用于字符串对比...<直接使用double有时会精度丢失>
                
                //strongSelf.viewModel.updateRebateInputContent(shopIndex, content)
                
                // 保存
                if let rebate = content, rebate.isEmpty == false, let value = Double(rebate), value > 0 {
                    // 用户输入不为空...<数量不为0>
                    if valueSave > 0 {
                        // 之前有保存(使用)的返利金
                        let valueRebate = String(format: "%.2f", value) // 用于字符串对比...<直接使用double有时会精度丢失>
                        if valueRebateSave == valueRebate {
                            // (当前用户输入的返利金与之前保存的返利金)两者相等...<不刷新>
                            strongSelf.viewModel.updateRebateInputContent(shopIndex, content)
                            return
                        }
                        else {
                            // 两者不相等...<需要刷新>
                            strongSelf.viewModel.updateRebateInputContent(shopIndex, content)
                        }
                    }
                    else {
                        // 之前无保存(使用)的返利金...<需要刷新>
                        strongSelf.viewModel.updateRebateInputContent(shopIndex, content)
                    }
                }
                else {
                    // 用户输入为空...<数量为0>
                    if valueSave > 0 {
                        // 之前有保存(使用)的返利金...<需要刷新>
                        strongSelf.viewModel.updateRebateInputContent(shopIndex, content)
                    }
                    else {
                        // 之前无保存(使用)的返利金...<不刷新>
                        strongSelf.viewModel.updateRebateInputContent(shopIndex, content)
                        return
                    }
                }
                // 刷新
                strongSelf.requestForCheckOrder(true)
            case .shopBuyMoney:
                // 获取当前商家已使用(保存)的返利金数额
                let valueSave = strongSelf.viewModel.getShopBuyMoneyInputContent()
                let valueBuyMoneySave = String(format: "%.2f", valueSave) // 用于字符串对比...<直接使用double有时会精度丢失>
                // 保存
                if let buyMoney = content, buyMoney.isEmpty == false, let value = Double(buyMoney), value > 0 {
                    // 用户输入不为空...<数量不为0>
                    if valueSave > 0 {
                        let valueBuyMoney = String(format: "%.2f", value) // 用于字符串对比...<直接使用double有时会精度丢失>
                        if valueBuyMoneySave == valueBuyMoney {
                            // (当前用户输入的返利金与之前保存的返利金)两者相等...<不刷新>
                            strongSelf.viewModel.updateShopBuyMoneyInputContent(content)
                            return
                        }
                        else {
                            // 两者不相等...<需要刷新>
                            strongSelf.viewModel.updateShopBuyMoneyInputContent(content)
                        }
                    }
                    else {
                        // 之前无保存(使用)的返利金...<需要刷新>
                        strongSelf.viewModel.updateShopBuyMoneyInputContent(content)
                    }
                }
                else {
                    // 用户输入为空...<数量为0>
                    if valueSave > 0 {
                        // 之前有保存(使用)的返利金...<需要刷新>
                        strongSelf.viewModel.updateShopBuyMoneyInputContent(content)
                    }
                    else {
                        // 之前无保存(使用)的返利金...<不刷新>
                        strongSelf.viewModel.updateShopBuyMoneyInputContent(content)
                        return
                    }
                }
                // 刷新
                strongSelf.requestForCheckOrder(true)
            default:break
            }
        }
        return vc
    }()
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print(">>>CheckOrderController deinit~!@")
    }
}


// MARK: - UI
extension CheckOrderController {
    // UI绘制
    fileprivate func setupView() {
        setupNavigationBar()
        setupContentView()
    }
    
    // 导航栏
    fileprivate func setupNavigationBar() {
        // 标题
        fky_setupTitleLabel("检查订单")
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
        
        view.addSubview(viewSubmit)
        viewSubmit.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-CheckOrderController.getScreenBottomMargin())
            make.height.equalTo(WH(62))
        }
        
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(WH(10));
            make.right.equalTo(view).offset(-WH(10));
            make.bottom.equalTo(viewSubmit.snp.top)
            make.top.equalTo(self.navBar!.snp.bottom)
        }
        
        // 共享库存提示视图
        view.addSubview(viewTip)
        viewTip.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(viewSubmit.snp.top)
            make.height.equalTo(WH(32))
        }
        // 默认隐藏
        viewTip.isHidden = true
        
        
        view.addSubview(rebateTipView)
        rebateTipView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(viewSubmit.snp.top)
            make.height.equalTo(WH(32))
        }
        
        view.addSubview(expiredeTipView)
        expiredeTipView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(navBar!.snp.bottom)
            make.height.equalTo(WH(0))
        }
        
    }
    
    
    // 更新table布局...<判断底部是否展示共享库存提示视图>
    fileprivate func updateTableLayout() {
        // 无数据
        guard let model = viewModel.modelCO else {
            return
        }
        //资质过期提示
        if let tip = model.qualificationMark, tip.isEmpty == false {
            expiredeTipView.isHidden = false
            let height  = COCredentialsExpiredHeadView.configTipViewHeight(tip)
            expiredeTipView.configTipView(tip)
            expiredeTipView.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            tableview.tableHeaderView?.hd_height = height
        }else{
            expiredeTipView.isHidden = true
            expiredeTipView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            tableview.tableHeaderView?.hd_height = 0
        }
        
        if let amount = model.allOrdersGetRebateMoney, amount.doubleValue > 0 {
            //返利金优先级高
            rebateTipView.isHidden = false
            rebateTipView.showTip(String(format: "¥ %.2f", amount.doubleValue))
            tableview.snp.updateConstraints { (make) in
                make.bottom.equalTo(viewSubmit.snp.top).offset(-WH(32))
            }
            return
        }else {
            rebateTipView.isHidden = true
            tableview.snp.updateConstraints { (make) in
                make.bottom.equalTo(viewSubmit.snp.top)
            }
        }
        
        
        if let txt = model.allShareStockDesc, txt.isEmpty == false {
            // 显示
            viewTip.isHidden = false
            viewTip.setTitle(txt)
            // 计算高度
            let height = COShareStockTipView.calculateTxtHeight(txt)
            // 更新
            viewTip.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            tableview.snp.updateConstraints { (make) in
                make.bottom.equalTo(viewSubmit.snp.top).offset(-height)
            }
        }
        else {
            // 隐藏
            viewTip.isHidden = true
            // 更新
            tableview.snp.updateConstraints { (make) in
                make.bottom.equalTo(viewSubmit.snp.top).offset(WH(0))
            }
        }
        view.layoutIfNeeded()
    }
}


// MARK: - Data
extension CheckOrderController {
    // 判断是否为一起购
    fileprivate func isGroupBuyOrder() -> Bool {
        if let list = productArray, list.count > 0 {
            return true
        }
        return false
    }
}


// MARK: - Request
extension CheckOrderController {
    // 进入界面时的相关接口调用
    fileprivate func setupRequest() {
        // 检查订单初始化
        requestForCheckOrder(false)
    }
    
    // 检查订单...<需判断是初始化，还是刷新>
    fileprivate func requestForCheckOrder(_ freshFlag: Bool) {
        showLoading()
        viewModel.requestForCheckOrder(freshFlag) { [weak self] (success, msg, failType) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                strongSelf.toast(msg ?? "请求失败")
                // 返回...<特殊情况>
                if let type: CORefreshFailType = failType {
                    // 不为空,需处理
                    strongSelf.handleAction4RefreshFailed(type)
                }
                return
            }
            // 成功
            strongSelf.setupShowStatus()
        }
    }
    
    // MARK:提交订单...<普通>
    fileprivate func requestForSubmitOrder() {
        showLoading()
        viewModel.requestForSubmitOrder() { [weak self] (success, message, data) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                print("提交失败")
                if let flag: Bool = data, flag == true {
                    // alert...<需返回购物车>
                    var tip = "提交失败，请返回购物车重试"
                    if let msg = message, msg.isEmpty == false {
                        tip = msg
                    }
                    let alert = COAlertView.init(frame: CGRect.zero)
                    alert.configView(tip, "", "", "确定", .oneBtn)
                    alert.showAlertView()
                    alert.doneBtnActionBlock = {
                        FKYNavigator.shared().pop()
                    }
                }
                else {
                    // toast...<不返回>
                    strongSelf.toast(message ?? "提交失败")
                }
                return
            }
            // 成功
            print("提交成功")
            strongSelf.handleSubmitOrder()
        }
    }
    
    // MARK:提交订单...<一起购>
    fileprivate func requestForSubmitGroupBuyOrder() {
        showLoading()
        viewModel.requestForSubmitGroupBuyOrder() { [weak self] (success, message, data) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                print("提交失败")
                if let flag: Bool = data, flag == true {
                    // alert...<需返回购物车>
                    var tip = "提交失败，请返回购物车重试"
                    if let msg = message, msg.isEmpty == false {
                        tip = msg
                    }
                    let alert = COAlertView.init(frame: CGRect.zero)
                    alert.configView(tip, "", "", "确定", .oneBtn)
                    alert.showAlertView()
                    alert.doneBtnActionBlock = {
                        FKYNavigator.shared().pop()
                    }
                }
                else {
                    // toast...<不返回>
                    strongSelf.toast(message ?? "提交失败")
                }
                return
            }
            // 成功
            print("提交成功")
            NotificationCenter.default.post(name:NSNotification.Name.FKYRefreshProductDetail, object: self, userInfo: nil)
            strongSelf.handleSubmitOrder()
        }
    }
    
    // 资质状态检查
    fileprivate func requestForCheckQualificationStatus(_ block: @escaping (Bool)->()) {
        showLoading()
        viewModel.requestForCheckEnterpriseQualification { [weak self] (bSuccess, message, rSuccess) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard bSuccess else {
                // 失败...<请求失败 or (请求成功)审核不通过>
                print("请求失败or审核不通过")
                if rSuccess {
                    // (请求成功)审核不通过
                    let alert = COAlertView.init(frame: CGRect.zero)
                    alert.configView("您的资料状态是审核不通过或待审核，无法提交订单，必须等待审核通过后才可以提交订单。", "", "", "确定", .oneBtn)
                    alert.showAlertView()
                    alert.doneBtnActionBlock = { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        // 跳转到资料管理页面
                        strongSelf.jumpToDataManager()
                    }
                }
                else {
                    // 请求失败
                    strongSelf.toast(message)
                }
                block(false)
                return
            }
            // 成功...<审核通过>
            print("审核通过")
            block(true)
        }
    }
}


// MARK: - Private
extension CheckOrderController {
    // 显示赠品列表
    fileprivate func showGiftList(_ giftList: [String]) {
        view.endEditing(true)
        guard giftList.count > 1 else {
            return
        }
        // 标题
        giftListPopVC.popTitle = "赠品信息"
        // 数据源
        giftListPopVC.dataList = giftList
        // 显示
        giftListPopVC.showOrHidePopView(true)
        // 传递之前已经选中项的索引，并滑到选中项
        giftListPopVC.showSelectedItem(-1)
    }
    
    // 弹出内容输入视图
    fileprivate func showInputView(_ content: String?, _ type: COInputType, _ shopIndex: Int) {
        // 个性参数
        switch type {
        case .leaveMessage:
            // 留言
            inputVC.heightContentView = WH(185)
            inputVC.maxInputNum = 50
            inputVC.popTitle = "留言"
        case .couponCode:
            // 优惠券码
            inputVC.heightContentView = WH(135)
            inputVC.maxInputNum = 30
            inputVC.popTitle = "优惠码"
        case .rebateNumber:
            // 返利金额
            inputVC.heightContentView = WH(135)
            inputVC.maxInputNum = 13
            inputVC.popTitle = "返利抵扣金额"
            inputVC.maxRebateValue = viewModel.getMaxRebateUseValue(shopIndex) // 最大可用返利金抵扣
        case .shopBuyMoney:
            // 购物金额
            inputVC.heightContentView = WH(135)
            inputVC.maxInputNum = 13
            inputVC.popTitle = "购物金"
            inputVC.maxRebateValue = viewModel.getMaxShopBuyMoneyUseValue() // 最大可用购物金抵扣
        default :break
        }
        // 公共参数
        inputVC.shopIndex = shopIndex   // 店铺索引
        inputVC.inputContent = content  // 已输入内容
        inputVC.inputType = type        // cell输入类型
        inputVC.showOrHidePopView(true) // 显示
    }
    
    // 选择发票类型
    fileprivate func selectInvoiceType() {
        view.endEditing(true)
        guard let model = self.viewModel.modelCO,let arr = model.invoiceTypeList ,arr.count > 0 else {
            self.toast("发票信息获取错误")
            return
        }
        
        // 跳转到发票编辑/选择界面
        FKYNavigator.shared().openScheme(FKY_BillTypeController.self, setProperty: { [weak self] (vc) in
            guard let strongSelf = self else {
                return
            }
            // 是否可编辑
            //let canEdit = strongSelf.viewModel.getInvoiceEditStatus()
            // 是否支持电子发票
            // let supportEdit = strongSelf.viewModel.getSupportEinvoiceStatu()
            // 发票vc
            let controller = vc as! SelectInvoiceViewController
            if let model = strongSelf.viewModel.modelCO  {
                if let typeArr = model.invoiceTypeList,typeArr.count > 0 {
                    if typeArr.contains(2) {
                        controller.invoiceDataArr.append(2)
                    }
                    if typeArr.contains(3) {
                        controller.invoiceDataArr.append(3)
                    }
                    if typeArr.contains(1) {
                        controller.invoiceDataArr.append(1)
                    }
                    if let infoModel = strongSelf.viewModel.invoiceModel, let billNum = infoModel.billType, let billInt = Int(billNum) {
                        controller.selectedIndexNum = controller.invoiceDataArr.index(of:billInt) ?? 0
                    }
                }
                if let str = model.invoiceTip {
                    controller.desTip = str
                }
            }
            controller.isSelfShop = strongSelf.viewModel.checkHasSelfShop()
            //回调保存发票
            controller.saveInvoiceModelSuccessBlock = { [weak self] (invoice) in
                guard let strongSelf = self else {
                    return
                }
                // 保存发票类型
                strongSelf.viewModel.invoiceModel = invoice
                strongSelf.tableview.reloadData()
            }
            }, isModal: false, animated: true)
    }
    
    // 更新界面显示状态
    fileprivate func setupShowStatus() {
        updateSubmitInfo()
        updateTableLayout()
        tableview.reloadData()
    }
    
    // 更新底部提交信息
    fileprivate func updateSubmitInfo() {
        // 无数据
        guard let model = viewModel.modelCO else {
            // 隐藏底部操作栏
            viewSubmit.isHidden = true
            return
        }
        
        // 有数据...<显示底部操作栏>
        viewSubmit.isHidden = false
        
        // 商品总数
        var number = 0
        if let count = model.allProductCount, count > 0 {
            number = count
        }
        // 实(应)付金额
        var amount = "¥ 0.00"
        if let pay = model.payAmount, pay.doubleValue > 0 {
            amount = String(format: "¥ %.2f", pay.doubleValue)
        }
        // 更新
        viewSubmit.configView(amount: amount, number: number)
    }
    
    // 接口请求失败时的特殊情况处理
    fileprivate func handleAction4RefreshFailed(_ failType: CORefreshFailType) {
        switch failType {
        case .shouldBackToCart:
            print("返回")
            let alert = COAlertView.init(frame: CGRect.zero)
            alert.configView("购物车中商品信息发生变化，请返回重新结算", "", "", "确定", .oneBtn)
            alert.showAlertView()
            alert.doneBtnActionBlock = {
                FKYNavigator.shared().pop()
            }
        case .couponCodeError:
            print("优惠码错误")
            // 删除所有本地保存的错误优惠码
            viewModel.deleteLastInputCouponCodeContent()
        default:
            print("不做处理")
        }
    }
}


// MARK: - Submit Order
extension CheckOrderController {
    // 判断是否可以提交订单
    fileprivate func checkSubmitOrderStatus() {
        // 判断是否有地址
        guard let model = viewModel.modelCO, let address: COAddressModel = model.receiveInfoVO, let aId = address.id, aId > 0 else {
            // 无地址
            let alert = COAlertView.init(frame: CGRect.zero)
            alert.configView("暂无收货地址，请前往资料管理维护地址，提交审核", "", "", "确定", .oneBtn)
            alert.showAlertView()
            alert.doneBtnActionBlock = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                // 跳转到资料管理页面
                strongSelf.jumpToDataManager()
            }
            return
        }
        guard address.addressIsValid() == true else {
            // 地址信息不全
            toast("收货地址中省/市/区/详细地址/联系人/手机号等不完善，请完善收货地址！")
            return
        }
        guard address.hasPurchaser() == true else {
            // 采购员信息不全
            toast("采购人员相关信息不全，请完善！")
            return
        }
        
        // 判断是否全部选择了支付方式
        let payFlag = viewModel.checkAllPayTypeSelectedStatus()
        guard payFlag else {
            toast("请选择支付方式")
            return
        }
        
        
        // 校验发票信息
        let invoice: (Bool, String?) = viewModel.checkInvoiceStatus()
        if !invoice.0 {
            toast(invoice.1 ?? "请选择发票信息")
            return
        }
        
        // 订单实付金额异常
        if let price = model.payAmount, price.doubleValue < 0 {
            toast("订单金额异常，请联系平台客服4009215767")
            return
        }
        
        // 判断是否可以提交订单...<查看用户资质审核状态>
        requestForCheckQualificationStatus() { [weak self] (success) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                // 失败
                return
            }
            // 提交订单
            strongSelf.submitOrder()
        }
    }
    
    // 提交订单
    fileprivate func submitOrder() {
        view.endEditing(true)
        
        if isGroupBuyOrder() {
            // 一起购
            requestForSubmitGroupBuyOrder()
        }
        else {
            // 普通(非一起购)
            requestForSubmitOrder()
        }
    }
    
    // 提交订单成功后的逻辑处理
    fileprivate func handleSubmitOrder() {
        guard let model = viewModel.modelSO, let list = model.orderIdList, list.count > 0 else {
            toast("订单提交失败")
            return
        }
        
        guard list.count == 1 else {
            // 不止一单...<需拆单>
            jumpToOrderListForMultiOrder(list.count)
            return
        }
        
        guard let obj = viewModel.modelCO, let pay = obj.payAmount, pay.doubleValue > 0 else {
            //0元支付-直接跳转到支付成功界面
            FKYNavigator.shared()?.openScheme(FKY_OrderPayStatus.self, setProperty: { (vc) in
                let drawVC = vc as! FKYOrderPayStatusVC
                drawVC.orderNO = list[0]
                drawVC.fromePage = 7
            })
            return
        }
        
        // 支付方式...<默认线上>
        var payType: Int = 1
        // 订单号
        let orderId: String = list.first ?? ""
        // 获取一级支付方式
        if let map: [String: String] = model.payType, let value = map[orderId], value.isEmpty == false {
            if let type = Int(value), type == 3 {
                // 线下转账
                payType = 3
            }
        }
        else {
            // 若未返回，则自已本地取
            let type = viewModel.getPayTypeForFirstShop()
            if type == 1 || type == 3 {
                payType = type
            }
        }
        
        // 仅一单
        payForSigleOrder(payType)
    }
    
    // 仅一单时立即支付
    // 1.线上支付：跳转到线上支付列表界面
    // 2.线下转账：跳转到线下支付详情界面
    fileprivate func payForSigleOrder(_ payType: Int) {
        if payType == 1 {
            // 1-线上
            jumpToOnlinePay()
        }
        else {
            // 3-线下
            jumpToOfflinePay()
        }
    }
    
    // 多单时的拆单：直接跳转到订单列表之待付款
    fileprivate func jumpToOrderListForMultiOrder(_ count: Int) {
        // 拆单个数提示
        var content = ""
        if isGroupBuyOrder() {
            content = "订单提交成功！您的订单被拆分成【\(count)单】，请在待付款中逐一支付！"
        }else {
            content = "您的订单被拆分成【\(count)单】，根据您的返利金金额已为您部分支付，您可在待付款列表支付剩余订单。"
        }
        // 提框
        let alert = COAlertView.init(frame: CGRect.zero)
        alert.configView(content, "", "", "确定", .oneBtn)
        alert.showAlertView()
        alert.doneBtnActionBlock = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            // 跳转到订单列表
            strongSelf.jumpToOrderList()
        }
    }
}


// MARK: - PopView
extension CheckOrderController {
    // 展示运费规则视图
    fileprivate func showFrightRoleView(_ sectionType: FKYCOSectionType, _ section: Int) {
        // 埋点
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.CHECKORDER_FRIGHT_TIP.rawValue, itemPosition: "1", itemName: "运费提示", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        
        let list = viewModel.getRuleList(sectionType, section)
        guard let rules = list, rules.count > 0 else {
            // 提示
            toast("暂无运费规则说明")
            return
        }
        frightVC.dataList = rules
        frightVC.showOrHidePopView(true)
    }
    
    
    
    // 展示返利金计算规则视图
    fileprivate func showRebateRoleView() {
        let vc = CartRebateInfoVC()
        vc.viewParent = self.view
        vc.showOrHidePopView(true)
        self.addChild(vc)
    }
    //展示平台券或者店铺优惠券
    fileprivate func showShopOrPlatformCouponView(_ typeIndex:Int,_ shopIndex:Int?,_ shopOrderObj: COSupplyOrderModel?){
        let userCouponVC = UseCouponController()
        userCouponVC.typeIndex = typeIndex
        userCouponVC.couponDicModel = self.viewModel.getProductCouponData(shopOrderObj)
        userCouponVC.configUseCouponViewController()
        // 选择优惠券后回调
        userCouponVC.callToblock = { [weak self] (cartService: FKYCartSubmitService) in
            guard let strongSelf = self else {
                return
            }
            if let desShopModel = shopOrderObj,let shopId = desShopModel.supplyId {
                //选择店铺优惠券
                // 当前保存的优惠券code
                let codeSave: String? = strongSelf.viewModel.getProductCouponContent(shopId)
                // 判断当前选择的优惠券code跟之前已选的是否相同
                if codeSave == nil, cartService.checkCouponCodeStr == nil {
                    // 不刷新...<两者都为空nil>
                    return
                }
                if let codeS = codeSave, let codeC = cartService.checkCouponCodeStr, codeS == codeC {
                    // 不刷新...<两者都不为空，则值相同>
                    return
                }
                if codeSave == nil, let content = cartService.checkCouponCodeStr, content == "" {
                    // 不刷新...<前者为空；后者不为空，但为空字符串>
                    return
                }
                if let codeS = codeSave, codeS == "", cartService.checkCouponCodeStr == nil {
                    // 不刷新...<前者不为空，但为空字符串；后者为空>
                    return
                }
                
                // 若为空，表示不使用商品优惠券； 若不为空，表示使用商品优惠券；
                guard let content = cartService.checkCouponCodeStr, content.isEmpty == false else {
                    // 删除当前商家的商品优惠券内容
                    strongSelf.viewModel.removeProductCouponContent(shopId)
                    // 清除当前商家使用平台优惠券状态
                    // strongSelf.viewModel.removeUsePlatformCouponStatus(shopId)
                    // 刷新
                    strongSelf.requestForCheckOrder(true)
                    return
                }
                
                // 保存当前商家的商品优惠券code内容
                strongSelf.viewModel.saveProductCouponContent(content, shopId)
                // 删除当前商家保存的优惠券码code内容
                strongSelf.viewModel.removeCouponCodeContent(shopId)
                // 更新是否使用平台券状态
                //strongSelf.viewModel.updateUsePlatformCouponStatus(content, shopIndex ?? 0)
                // 刷新
                strongSelf.requestForCheckOrder(true)
            }else {
                //选择平台优惠券
                if let codeC = cartService.checkCouponCodeStr {
                    //前后不同
                    if strongSelf.viewModel.platformCouponCode != codeC {
                        strongSelf.viewModel.platformCouponCode = codeC
                        strongSelf.requestForCheckOrder(true)
                    }
                }else {
                    //选择为nil ,前者不为空字符
                    if strongSelf.viewModel.platformCouponCode.count > 0 {
                        strongSelf.viewModel.platformCouponCode = ""
                        strongSelf.requestForCheckOrder(true)
                    }
                }
            }
        }
    }
}


// MARK: - Jump
extension CheckOrderController {
    // 跳转到资料管理
    fileprivate func jumpToDataManager() {
        // 先返回个人中心
        FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
            let v = vc as! FKY_TabBarController
            v.index = 4
            // 再去填写基本信息 FKY_CredentialsController / FKY_CredentialsBaseInfo
            FKYNavigator.shared().openScheme(FKY_CredentialsController.self, setProperty: nil)
        }, isModal: false)
    }
    // 跳转到资料管理 因为资质过期
    fileprivate func jumpToDataManagerForExpire() {
        // 先返回个人中心
        FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
            let v = vc as! FKY_TabBarController
            v.index = 4
            // 再去填写基本信息 FKY_CredentialsController / FKY_CredentialsBaseInfo
            FKYNavigator.shared().openScheme(FKY_CredentialsController.self, setProperty: { (vc) in
                let v = vc as! CredentialsViewController
                v.fromType = "expireData"
            }, isModal: false)
        }, isModal: false)
    }
    
    // 跳转到订单列表
    fileprivate func jumpToOrderList() {
        // 初始化订单列表界面vc
        let controller = FKYAllOrderViewController.init()
        if isGroupBuyOrder() {
            controller.status = "1"
        }else {
            controller.status = "0"
        }
        // 先移除当前vc，再跳转到下个vc
        if let navController = self.navigationController {
            var vcs = Array.init(navController.viewControllers)
            vcs.removeLast()
            vcs.append(controller)
            navController.setViewControllers(vcs, animated: true)
        }
    }
    
    // 跳转到在线支付界面...<先移除当前界面vc>
    fileprivate func jumpToOnlinePay() {
        guard let model = viewModel.modelSO, let list = model.orderIdList, list.count > 0 else {
            toast("提交订单失败")
            return
        }
        
        // 订单号
        let orderId: String = list.first ?? ""
        // 订单类型...[普通订单传空，一起购传1 ???]
        let orderType: String = (self.isGroupBuyOrder() ? "1" : "")
        // 订单实(应)付金额
        var orderMoney = "0.00"
        // 供应商id
        var supplyId: String? = nil
        // 供应商id列表
        var supplyIds: [Any] = []
        
        // 订单失效时间
        var time: String? = nil
        
        if let obj = viewModel.modelCO, let pay = obj.payAmount, pay.doubleValue > 0 {
            orderMoney = String(format: "%.2f", pay.doubleValue)
        }
        if let obj = viewModel.modelCO, let arr = obj.orderSupplyCartVOs, arr.count > 0, let order: COSupplyOrderModel = arr.first {
            if let sid = order.supplyId, sid > 0 {
                supplyId = "\(sid)"
            }
        }
        //多商家合并支付
        if let obj = viewModel.modelCO, let arr = obj.orderSupplyCartVOs, arr.count > 1 {
            for order in arr{
                if let sid = order.supplyId, sid > 0 {
                    supplyIds.append("\(sid)")
                }
            }
        }
        
        
        if let map: [String: String] = model.noPayCancelTime, let value = map[orderId], value.isEmpty == false {
            time = value
        }
        
        // error
        guard let navController = self.navigationController else {
            // 跳转选择在线支付方式界面
            FKYNavigator.shared().openScheme(FKY_SelectOnlinePay.self, setProperty: { (vc) in
                let controller = vc as! COSelectOnlinePayController
                controller.orderId = orderId
                controller.orderType = orderType
                controller.orderMoney = orderMoney
                controller.supplyId = supplyId
                controller.supplyIdList = supplyIds
                controller.invalidTime = time
                controller.flagFromCO = true
            }, isModal: false, animated: true)
            return
        }
        // error
        guard navController.viewControllers.count > 0 else {
            // 跳转选择在线支付方式界面
            FKYNavigator.shared().openScheme(FKY_SelectOnlinePay.self, setProperty: { (vc) in
                let controller = vc as! COSelectOnlinePayController
                controller.orderId = orderId
                controller.orderType = orderType
                controller.orderMoney = orderMoney
                controller.supplyId = supplyId
                controller.supplyIdList = supplyIds
                controller.invalidTime = time
                controller.flagFromCO = true
            }, isModal: false, animated: true)
            return
        }
        
        // 初始化支付列表界面vc
        let controller = COSelectOnlinePayController.init()
        controller.orderId = orderId
        controller.orderType = orderType
        controller.orderMoney = orderMoney
        controller.supplyId = supplyId
        controller.invalidTime = time
        controller.flagFromCO = true
        controller.supplyIdList = supplyIds
        // 先移除当前vc，再跳转到下个vc
        var vcs = Array.init(navController.viewControllers)
        vcs.removeLast()
        vcs.append(controller)
        navController.setViewControllers(vcs, animated: true)
    }
    
    // 跳转到线下支付详情...<先移除当前界面vc>
    fileprivate func jumpToOfflinePay() {
        guard let model = viewModel.modelSO, let list = model.orderIdList, list.count > 0 else {
            toast("提交订单失败")
            return
        }
        
        // 订单号
        let orderId: String = list.first ?? ""
        // 订单类型...[普通订单传空，一起购传1 ???]
        let orderType: String = (self.isGroupBuyOrder() ? "1" : "")
        // 订单实(应)付金额
        var orderMoney = "0.00"
        // 供应商id
        var supplyId: String? = nil
        
        if let obj = viewModel.modelCO, let pay = obj.payAmount, pay.doubleValue > 0 {
            orderMoney = String(format: "%.2f", pay.doubleValue)
        }
        if let obj = viewModel.modelCO, let arr = obj.orderSupplyCartVOs, arr.count > 0, let order: COSupplyOrderModel = arr.first {
            if let sid = order.supplyId, sid > 0 {
                supplyId = "\(sid)"
            }
        }
        
        // error
        guard let navController = self.navigationController else {
            FKYNavigator.shared().openScheme(FKY_OfflinePayInfo.self, setProperty: { (vc) in
                let controller = vc as! COOfflinePayDetailController
                controller.orderId = orderId
                controller.orderType = orderType
                controller.orderMoney = orderMoney
                controller.supplyId = supplyId
                controller.flagFromCO = true
            }, isModal: false, animated: true)
            return
        }
        // error
        guard navController.viewControllers.count > 0 else {
            FKYNavigator.shared().openScheme(FKY_OfflinePayInfo.self, setProperty: { (vc) in
                let controller = vc as! COOfflinePayDetailController
                controller.orderId = orderId
                controller.orderType = orderType
                controller.orderMoney = orderMoney
                controller.supplyId = supplyId
                controller.flagFromCO = true
            }, isModal: false, animated: true)
            return
        }
        
        // 初始化支付列表界面vc
        let controller = COOfflinePayDetailController.init()
        controller.orderId = orderId
        controller.orderType = orderType
        controller.orderMoney = orderMoney
        controller.supplyId = supplyId
        controller.flagFromCO = true
        
        // 先移除当前vc，再跳转到下个vc
        var vcs = Array.init(navController.viewControllers)
        vcs.removeLast()
        vcs.append(controller)
        navController.setViewControllers(vcs, animated: true)
    }
}


// MARK: - UITableViewDelegate
extension CheckOrderController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard viewModel.coSections.count > indexPath.section else {
            return UITableViewCell.init(style: .default, reuseIdentifier: "error")
        }
        
        let container = viewModel.coSections[indexPath.section]
        guard let items = container.items, items.count > indexPath.row else {
            return UITableViewCell.init(style: .default, reuseIdentifier: "error")
        }
        
        let item = items[indexPath.row]
        
        let section = indexPath.section
        let row = indexPath.row
        
        // 商家（商品列表）
        var shopIndex = 0// 商家索引
        var shopOrderObj: COSupplyOrderModel?
        if let type = item.sectionType, type == .sectionShop {
            shopIndex = section - 1
            shopOrderObj = viewModel.getShopOrder(shopIndex) // 商家订单model
        }
        
        
        switch item.cellType {
        case .address:
            //MARK:地址
            let cell = tableView.dequeueReusableCell(withIdentifier: "COAddressView", for: indexPath) as! COAddressView
            
            if let address = viewModel.modelCO?.receiveInfoVO {
                cell.configView(name: (address.receiverName ?? address.purchaser), phone: (address.contactPhone ?? address.purchaserPhone), address: address.printAddress)
            }
            return cell
            
        case .shopName:
            //MARK: 店铺名称
            let cell = tableView.dequeueReusableCell(withIdentifier: "COShopNameCell", for: indexPath) as! COShopNameCell
            cell.configCell(shopOrderObj!)
            return cell
            
        case .productMore:
            // MARK:多商品
            let cell = tableView.dequeueReusableCell(withIdentifier: "COProductListCell", for: indexPath) as! COProductListCell
            cell.configCell(shopOrderObj!)
            return cell
            
        case .productSingle:
            //MARK: 单品
            let cell = tableView.dequeueReusableCell(withIdentifier: "COProductInfoCell", for: indexPath) as! COProductInfoCell
            let productIndex = row - 1 // 商品索引
            let productObj = viewModel.getProductObj(productIndex, shopOrderObj!) // 商品model
            cell.configCell(productObj, false)
            return cell
        case .leaveMessage:
            // MARK:留言
            let cell = tableView.dequeueReusableCell(withIdentifier: "COLeaveMessageCell", for: indexPath) as! COLeaveMessageCell
            let message = viewModel.getLeaveMessageContent(shopIndex)
            cell.configCell(message)
            // 输入框激活回调
            cell.inputMessageClosure = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.view.endEditing(true)
                strongSelf.showInputView(message, .leaveMessage, shopIndex)
                // 埋点
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.CHECKORDER_ACTION_LIST.rawValue, sectionPosition: "\(shopIndex+1)", sectionName:shopOrderObj!.supplyName, itemId: ITEMCODE.CHECKORDER_ORDER_PRODUCT_ALL.rawValue, itemPosition: "2", itemName: "留言", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            }
            return cell
            
            
        case .gift:
            // MARK:赠品
            let cell = tableView.dequeueReusableCell(withIdentifier: "COProductGiftCell", for: indexPath) as! COProductGiftCell
            cell.configCell(item.data as! [String])
            return cell
            
            
        case .productCoupon:
            // MARK:商品优惠券
            let cell = tableView.dequeueReusableCell(withIdentifier: "COProductCouponCell", for: indexPath) as! COProductCouponCell
            var selected: Bool = false
            if let sid = shopOrderObj!.supplyId {
                // 获取本地保存的选中状态
                selected = viewModel.getProductCouponSelectStatus(sid)
            }
            cell.configCell(shopOrderObj!,selected)
            // 勾选
            cell.selectClosure = { [weak self] (selected) in
                guard let strongSelf = self else {
                    return
                }
                // error
                guard let shopId = shopOrderObj!.supplyId else {
                    return
                }
                
                if selected {
                    // 选中
                    // 埋点
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.CHECKORDER_ACTION_LIST.rawValue, sectionPosition: "\(shopIndex+1)", sectionName: shopOrderObj!.supplyName, itemId: ITEMCODE.CHECKORDER_OREDR_PRODUCT_COUPON.rawValue, itemPosition: "1", itemName: "商品优惠券 勾选", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
                    
                    // 需判断是否已使用优惠码
                    //if let shopId = shopOrderObj.supplyId, let couponCode = strongSelf.viewModel.dicCouponCode[shopId], couponCode.isEmpty == false {
                    if let coupon = shopOrderObj!.showCouponCode, coupon.isEmpty == false {
                        // 已使用...<有优惠码code，需刷新(即：取消优惠码使用)>
                        print("刷新")
                        // 删除当前商家的商品优惠码内容
                        strongSelf.viewModel.removeCouponCodeContent(shopId)
                        // 保存当前商家优惠券/码勾选状态
                        strongSelf.viewModel.updateCouponCodeSelectStatus(false, shopId)
                        strongSelf.viewModel.updateProductCouponSelectStatus(true, shopId)
                        // 刷新
                        strongSelf.requestForCheckOrder(true)
                    }
                    else {
                        // 未使用...<直接展开>
                        strongSelf.viewModel.updateCouponCodeSelectStatus(false, shopId)
                        strongSelf.viewModel.updateProductCouponSelectStatus(true, shopId)
                        strongSelf.tableview.reloadData()
                    }
                }
                else {
                    // 取消选中
                    
                    // 判断当前有无使用优惠券
                    //if let number = shopOrderObj.checkCouponNum, number > 0 {
                    if let code = shopOrderObj!.checkCouponCodeStr, code.isEmpty == false {
                        // 当前已使用优惠券...<直接调接口刷新>
                        print("刷新")
                        
                        // 删除当前商家的商品优惠券内容
                        strongSelf.viewModel.removeProductCouponContent(shopId)
                        // 清除当前商家使用平台优惠券状态
                        //strongSelf.viewModel.removeUsePlatformCouponStatus(shopId)
                        // 保存当前商家优惠券勾选状态
                        strongSelf.viewModel.updateProductCouponSelectStatus(false, shopId)
                        // 刷新
                        strongSelf.requestForCheckOrder(true)
                    }
                    else {
                        // 当前未使用优惠券...<不展开>
                        strongSelf.viewModel.updateProductCouponSelectStatus(false, shopId)
                        strongSelf.tableview.reloadData()
                    }
                }
            }
            // 选择/使用优惠券
            cell.useCouponClosure = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.showShopOrPlatformCouponView(0, shopIndex, shopOrderObj)
                // 埋点
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.CHECKORDER_ACTION_LIST.rawValue, sectionPosition: "\(shopIndex+1)", sectionName: shopOrderObj!.supplyName, itemId: ITEMCODE.CHECKORDER_OREDR_PRODUCT_COUPON.rawValue, itemPosition: "3", itemName: "点开商品优惠券", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            }
            // (无可用优惠券时)跳转优惠券列表界面
            cell.seeCouponDetailClosure = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.showShopOrPlatformCouponView(0, shopIndex, shopOrderObj)
                // 埋点
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.CHECKORDER_ACTION_LIST.rawValue, sectionPosition: "\(shopIndex+1)", sectionName: shopOrderObj!.supplyName, itemId: ITEMCODE.CHECKORDER_OREDR_PRODUCT_COUPON.rawValue, itemPosition: "3", itemName: "点开商品优惠券", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            }
            return cell
            
            
        case .couponCode:
            // 优惠券码
            let cell = tableView.dequeueReusableCell(withIdentifier: "COCouponCodeCell", for: indexPath) as! COCouponCodeCell
            var selected: Bool = false
            if let sid = shopOrderObj!.supplyId {
                // 获取本地保存的选中状态
                selected = viewModel.getCouponCodeSelectStatus(sid)
            }
            cell.configCell(shopOrderObj!, selected)
            // 弹出提示
            cell.couponDetailClosure = { [weak self] in
                let alert = COAlertView.init(frame: CGRect.zero)
                alert.configView("单笔订单中店铺优惠券和优惠码互斥，结算中仅支持使用其中一种优惠方式。", "", "", "确定", .oneBtn)
                alert.showAlertView()
                alert.doneBtnActionBlock = {
                    // 确定
                    print("确定")
                }
                
                // 埋点
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.CHECKORDER_ACTION_LIST.rawValue, sectionPosition: "\(shopIndex+1)", sectionName: shopOrderObj!.supplyName, itemId: ITEMCODE.CHECKORDER_OREDR_PRODUCT_COUPON.rawValue, itemPosition: "2", itemName: "商品优惠券 i提示", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            }
            // 输入框激活回调
            cell.inputClosure = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.view.endEditing(true)
                strongSelf.showInputView(shopOrderObj!.showCouponCode, .couponCode, shopIndex)
                // 埋点
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.CHECKORDER_ACTION_LIST.rawValue, sectionPosition: "\(shopIndex+1)", sectionName: shopOrderObj!.supplyName, itemId: ITEMCODE.CHECKORDER_ORDER_COUPON_CODE.rawValue, itemPosition: "1", itemName: "优惠券码", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            }
            // 勾选
            cell.selectClosure = { [weak self] (selected) in
                guard let strongSelf = self else {
                    return
                }
                // error
                guard let shopId = shopOrderObj!.supplyId else {
                    return
                }
                
                if selected {
                    // 选中
                    
                    // 需判断是否已使用优惠券
                    //if let shopId = shopOrderObj.supplyId, let couponCode = strongSelf.viewModel.dicProductCoupon[shopId], couponCode.isEmpty == false {
                    if let code = shopOrderObj!.checkCouponCodeStr, code.isEmpty == false {
                        // 已使用...<有优惠券code，需刷新(即：取消优惠券使用)>
                        print("刷新")
                        // 删除当前商家的商品优惠券code内容
                        strongSelf.viewModel.removeProductCouponContent(shopId)
                        // 清除当前商家使用平台优惠券状态
                        //strongSelf.viewModel.removeUsePlatformCouponStatus(shopId)
                        // 保存当前商家优惠券/码勾选状态
                        strongSelf.viewModel.updateCouponCodeSelectStatus(true, shopId)
                        strongSelf.viewModel.updateProductCouponSelectStatus(false, shopId)
                        // 刷新
                        strongSelf.requestForCheckOrder(true)
                    }
                    else {
                        // 未使用...<直接展开>
                        strongSelf.viewModel.updateCouponCodeSelectStatus(true, shopId)
                        strongSelf.viewModel.updateProductCouponSelectStatus(false, shopId)
                        strongSelf.tableview.reloadData()
                    }
                }
                else {
                    // 取消选中
                    
                    // 判断当前有无使用优惠券码
                    if let coupon = shopOrderObj!.showCouponCode, coupon.isEmpty == false {
                        // 当前已使用优惠码...<直接调接口刷新>
                        print("刷新")
                        // error
                        guard let shopId = shopOrderObj!.supplyId else {
                            return
                        }
                        // 删除当前商家的商品优惠码内容
                        strongSelf.viewModel.removeCouponCodeContent(shopId)
                        // 保存当前商家优惠码勾选状态
                        strongSelf.viewModel.updateCouponCodeSelectStatus(false, shopId)
                        // 刷新
                        strongSelf.requestForCheckOrder(true)
                    }
                    else {
                        // 当前未使用优惠码...<不展开>
                        strongSelf.viewModel.updateCouponCodeSelectStatus(false, shopId)
                        strongSelf.tableview.reloadData()
                    }
                }
            }
            return cell
        //MARK:店铺返利金or平台返利金or购买金
        case .useRebate,.shopBuyMoney:
            // 使用返利抵扣
            let cell = tableView.dequeueReusableCell(withIdentifier: "CORebateInputCell", for: indexPath) as! CORebateInputCell
            // 配置cell
            if let checkModel = self.viewModel.modelCO {
                if item.cellType == .shopBuyMoney {
                    //购买金
                    cell.configShopBuyMoneyCell(checkModel,self.viewModel.isGroupBuy,self.viewModel.fromWhere)
                }else {
                    //店铺返利金or平台返利金
                    if checkModel.shareRebate == "1" {
                        //共享返利金
                        cell.configCell(self.viewModel.modelCO)
                    }else {
                        cell.configCell(shopOrderObj!)
                    }
                }
                // 输入框激活回调
                cell.inputClosure = { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.view.endEditing(true)
                    if item.cellType == .shopBuyMoney {
                        strongSelf.showInputView(nil, .shopBuyMoney, 0)
                    }else {
                        if checkModel.shareRebate == "1" {
                            //共享返利金
                            strongSelf.showInputView(nil, .rebateNumber, 0)
                            // 埋点
                            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName:"使用返利优惠", itemId: ITEMCODE.CHECKORDER_SHARE_ORDER_REBATE_INPUT.rawValue, itemPosition: "2", itemName: "修改返利金金额", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
                        }else {
                            strongSelf.showInputView(nil, .rebateNumber, shopIndex)
                            // 埋点
                            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.CHECKORDER_ACTION_LIST.rawValue, sectionPosition: "\(shopIndex+1)", sectionName:shopOrderObj!.supplyName, itemId: ITEMCODE.CHECKORDER_ORDER_REBATE_INPUT.rawValue, itemPosition: "2", itemName: "修改返利金金额", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
                        }
                    }
                    
                }
                // 返利金使用开关
                cell.changeClosure = { [weak self] (openFlag) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.view.endEditing(true)
                    if item.cellType == .shopBuyMoney {
                        strongSelf.popVerificationVc(openFlag)
                    }else {
                        if checkModel.shareRebate == "1" {
                            //共享返利金
                            // 埋点
                            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName:"使用返利优惠", itemId: ITEMCODE.CHECKORDER_SHARE_ORDER_REBATE_INPUT.rawValue, itemPosition: "1", itemName: "返利金开关", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
                            // 最大可用返利金抵扣
                            let rebate = (openFlag ? strongSelf.viewModel.getMaxRebateUseValue(0) : 0)
                            // 更新
                            strongSelf.viewModel.updateRebateInputContent(0, "\(rebate)")
                        }else {
                            // 埋点
                            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.CHECKORDER_ACTION_LIST.rawValue, sectionPosition: "\(shopIndex+1)", sectionName:shopOrderObj!.supplyName, itemId: ITEMCODE.CHECKORDER_ORDER_REBATE_INPUT.rawValue, itemPosition: "1", itemName: "返利金开关", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
                            // 最大可用返利金抵扣
                            let rebate = (openFlag ? strongSelf.viewModel.getMaxRebateUseValue(shopIndex) : 0)
                            // 更新
                            strongSelf.viewModel.updateRebateInputContent(shopIndex, "\(rebate)")
                        }
                        // 刷新
                        strongSelf.requestForCheckOrder(true)
                    }
                }
            }
            return cell
        case .platform:
            //平台优惠券
            let cell = tableView.dequeueReusableCell(withIdentifier: "COPlatformCouponCell", for: indexPath) as! COPlatformCouponCell
            cell.useCouponClosure = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                // 埋点
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName:"使用平台优惠券", itemId: ITEMCODE.CHECKORDER_SHARE_ORDER_PLARFORM_COUPON_INPUT.rawValue, itemPosition: "1", itemName: "点开平台优惠券", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
                strongSelf.showShopOrPlatformCouponView(1, shopIndex, nil)
            }
            cell.configCOPlatformCouponCellData(self.viewModel.modelCO,self.viewModel.platformCouponCode)
            return cell
        case .followQualification:
            //平台优惠券
            let cell = tableView.dequeueReusableCell(withIdentifier: "COFollowQualificationSelCell", for: indexPath) as! COFollowQualificationSelCell
            cell.configCOPlatformQualificationCellData(self.viewModel.followQualityCOModel,"\(shopOrderObj!.supplyId ?? 0)")
            return cell
            
        case .invoice:
            // 发票 billType
            let cell = tableView.dequeueReusableCell(withIdentifier: "CODetailSelectCell", for: indexPath) as! CODetailSelectCell
            // 配置cell
            let content = viewModel.getInvoiceContent()
            cell.configCell(content)
            return cell
        case .invoiceTip:
            // 发票 提示
            let cell = tableView.dequeueReusableCell(withIdentifier: "COSectionTextView", for: indexPath) as! COSectionTextView
            return cell
            
        case .payTypeSingle:
            // 线上支付
            let cell = tableView.dequeueReusableCell(withIdentifier: "COPayTypeSingleCell", for: indexPath) as! COPayTypeSingleCell
            cell.configCellStatus(shopOrderObj!.payType, (row == items.count-1))
            cell.selectedPayTypeClosure = { [weak self](payType) in
                if let strongSelf = self {
                    strongSelf.viewModel.updatePayTypeForAllShopOrder(shopOrderObj!, payType)
                }
            }
            cell.payTypeBIClosure = { (itemPosition) in
                // 埋点
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.CHECKORDER_ACTION_LIST.rawValue, sectionPosition: "\(indexPath.section)", sectionName:shopOrderObj!.supplyName, itemId: ITEMCODE.CHECKORDER_SELECT_PAY_TYPE.rawValue, itemPosition: "\(itemPosition)", itemName: "选择支付方式", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            }
            return cell
            
        case .payTypeDouble:
            // 线上 + 线下
            let cell = tableView.dequeueReusableCell(withIdentifier: "COPayTypeDoubleCell", for: indexPath) as! COPayTypeDoubleCell
            cell.configCellStatus(shopOrderObj!.payType, (row == items.count-1))
            cell.selectedPayTypeClosure = { [weak self](payType) in
                if let strongSelf = self {
                    strongSelf.viewModel.updatePayTypeForAllShopOrder(shopOrderObj!, payType)
                }
            }
            cell.payTypeBIClosure = { (itemPosition) in
                // 埋点
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.CHECKORDER_ACTION_LIST.rawValue, sectionPosition: "\(indexPath.section)", sectionName:shopOrderObj!.supplyName, itemId: ITEMCODE.CHECKORDER_SELECT_PAY_TYPE.rawValue, itemPosition: "\(itemPosition)", itemName: "选择支付方式", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            }
            return cell
            
        case .productAmount:
            //商品金额
            let cell = tableView.dequeueReusableCell(withIdentifier: "COMoneyTypeCell", for: indexPath) as! COMoneyTypeCell
            cell.configCell((item.data as! String), .productAmount, self.isGroupBuyOrder())
            if let type = item.sectionType, type == .sectionTotal {
                cell.addCellCorners()
            }
            return cell
            
        case .discountAmount,//立减
        .rebateMoney,//返利金抵扣
        .rebatePlatformMoney,
        .shopCouponMoney,//店铺优惠券
        .allShopBuyMoney, //购物金
        .platformCouponMoney,//平台优惠券,
        .freight,//运费
        .getRebate://可获返利金
            let cell = tableView.dequeueReusableCell(withIdentifier: "COMoneyTypeCell", for: indexPath) as! COMoneyTypeCell
            cell.configCell((item.data as! String), item.cellType!,  self.isGroupBuyOrder())
            // 查看运费规则/返利金计算规则
            cell.detailClosure = { [weak self] (type) in
                guard let strongSelf = self else {
                    return
                }
                if type == .freight {
                    strongSelf.showFrightRoleView(item.sectionType!, shopIndex)
                }else if type == .getRebate {
                    strongSelf.showRebateRoleView()
                }
            }
            return cell
        case .payAmount:
            //应付金额
            let cell = tableView.dequeueReusableCell(withIdentifier: "COPayAmountCell", for: indexPath) as! COPayAmountCell
            if let infos = item.data as? [String: String] {
                cell.configCell(infos)
            }
            return cell
        case .saleAgreement:
            //销售单随货
            let cell = tableView.dequeueReusableCell(withIdentifier: "COSaleAgreementWithProductCell", for: indexPath) as! COSaleAgreementWithProductCell
            cell.configCellStatus(self.viewModel.getRebateInputContent())
            cell.selectedFollowTypeClosure = { [weak self] (type) in
                guard let strongSelf = self else {
                    return
                }
                //1 - 随货  0 - 不随货
                var itemName = ""
                var itemPosition = ""
                if type == 0 {
                    itemName = "不随货"
                    itemPosition = "2"
                }else {
                    itemName = "随货"
                    itemPosition = "1"
                }
                // 埋点
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName:"销售合同是否随货", itemId: ITEMCODE.CHECKORDER_SALE_INFO.rawValue, itemPosition: itemPosition, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
                strongSelf.viewModel.updateSaleContactType(type)
            }
            return cell
        default:
            break
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: "error")
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            if let model  = self.viewModel.modelCO,let tip = model.qualificationMark, tip.isEmpty == false {
                return WH(0)
            }else{
                return WH(10)
            }
        }
        return WH(10)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.coSections.count > indexPath.section else {
            return
        }
        
        let container = viewModel.coSections[indexPath.section]
        guard let items = container.items, items.count > indexPath.row else {
            return
        }
        let item = items[indexPath.row]
        
        switch item.cellType {
            
        case .gift:
            showGiftList(item.data as! [String])
            break
        case .productMore:
            let  shopOrderObj = viewModel.getShopOrder(indexPath.section - 1) // 商家订单model
            FKYNavigator.shared()?.openScheme(FKY_COProductsListController.self, setProperty: { (vc) in
                let listVC = vc as! COProductsListController
                listVC.supplyShop = shopOrderObj
            })
            // 埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.CHECKORDER_ACTION_LIST.rawValue, sectionPosition: "\(indexPath.section)", sectionName:shopOrderObj!.supplyName, itemId: ITEMCODE.CHECKORDER_ORDER_PRODUCT_ALL.rawValue, itemPosition: "1", itemName: "展开全部商品", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            break
        case .followQualification:
            let  shopOrderObj = viewModel.getShopOrder(indexPath.section - 1) // 商家订单model
            FKYNavigator.shared()?.openScheme(FKY_COFollowQualificaViewController.self, setProperty: {[weak self] (vc) in
                guard let strongSelf = self else {
                    return
                }
                let followQualificaVC = vc as! COFollowQualificaViewController
                followQualificaVC.suppluId = "\(shopOrderObj?.supplyId ?? 0)"
                if let _ = strongSelf.viewModel.followQualityCOModel{
                    followQualificaVC.modelCO = strongSelf.viewModel.followQualityCOModel
                }else{
                    followQualificaVC.modelCO = strongSelf.viewModel.modelCO
                }
                followQualificaVC.followQualitySelAction = {[weak self] checkOrderModel in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.viewModel.followQualityCOModel = checkOrderModel
                    strongSelf.tableview.reloadData()
                }
            })
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.CHECKORDER_ACTION_LIST.rawValue, sectionPosition: "\(indexPath.section)", sectionName: shopOrderObj?.supplyName ?? "", itemId: "I9120", itemPosition: nil, itemName: "首营资质", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            break
        case .invoice:
            // 发票
            selectInvoiceType()
            // 埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.CHECKORDER_ORDER_INVOICE.rawValue, itemPosition: "1", itemName: "发票信息", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
            break
            
        default:
            break
        }
    }
}


// MARK: - Class
extension CheckOrderController {
    // 屏幕底部margin...<适配iPhone X系列>
    class func getScreenBottomMargin() -> CGFloat {
        var margin: CGFloat = 0
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                margin = iPhoneX_SafeArea_BottomInset
            }
        }
        return margin
    }
}
//MARK:弹出验证码视图
extension CheckOrderController {
    fileprivate func popVerificationVc(_ openFlag:Bool) {
        //第一次使用购物金的时候，弹出验证信息
        if let boolValue = UserDefaults.standard.value(forKey:self.buyMoneyKey ?? "") as? Bool, boolValue == true  {
            // 最大可用购物金
            let buyMoney = (openFlag ? self.viewModel.getMaxShopBuyMoneyUseValue():0)
            // 更新
            self.viewModel.updateShopBuyMoneyInputContent("\(buyMoney)")
            // 刷新
            self.requestForCheckOrder(true)
            return
        }
        if let mobileStr = UserDefaults.standard.value(forKey: "user_mobile") as? String ,mobileStr.count>0{
            var params :[String : Any] = [:]
            params["type"] = "4"
            params["mobile"] = mobileStr
            self.showLoading()
            FKYRequestService.sharedInstance()?.requestForGetSMSCodeDataInPassword(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.dismissLoading()
                guard success else {
                    // 失败
                    let msg = error?.localizedDescription ?? "获取失败"
                    strongSelf.toast(msg)
                    return
                }
                strongSelf.showVerfication(mobileStr,openFlag)
            })
        }else {
            self.toast("请在药城PC端买家中心-修改密码里添加安全手机")
        }
    }
    //显示验证码弹框
    fileprivate func showVerfication(_ mobileStr:String ,_ openFlag:Bool ){
        let verificationVC = FKYAddBankCardVerificationCodeVC()
        verificationVC.modalPresentationStyle = .overFullScreen
        verificationVC.fromViewType = .buyMoney
        verificationVC.phoneNumber = mobileStr
        verificationVC.verificationResult = {[weak self] (isSuccess,inputVeridicationCode,codeRequestNo,quickPayFlowId,errorMsg) in
            guard let strongSelf = self else {
                return
            }
            UserDefaults.standard.set(true, forKey: strongSelf.buyMoneyKey ?? "")
            // 最大可用购物金
            let buyMoney = (openFlag ? strongSelf.viewModel.getMaxShopBuyMoneyUseValue():0)
            // 更新
            strongSelf.viewModel.updateShopBuyMoneyInputContent("\(buyMoney)")
            // 刷新
            strongSelf.requestForCheckOrder(true)
        }
        self.present(verificationVC, animated: false) {}
    }
}
