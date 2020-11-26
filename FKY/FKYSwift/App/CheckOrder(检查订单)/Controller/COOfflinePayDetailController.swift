//
//  COOfflinePayDetailController.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/25.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [生成订单成功后]线下支付详情...<前提是提交订单时选择的一级支付类型为线下转账方式>

import UIKit

class COOfflinePayDetailController: UIViewController, FKY_OfflinePayInfo {
    //MARK: - Property
    
    // 上个界面传来的值
    var supplyId: String?           // 供应商id
    var orderId: String?            // 订单号
    var orderType: String?          // 订单类型 1:一起购???
    var orderMoney: String?         // 订单金额
    var flagFromCO: Bool = false    // 判断是否从检查订单界面跳转过来...<默认为否>
    
    /// 订单支付状态/抽奖 的viewModel
    var OrderPayStatusModel = FKYOrderPayStatusViewModel()
    
    // 银行信息model...<请求后的model>
    fileprivate var bankInfo: FKYBankInfoModel?
    // 订单分享加密签名...<分享链接>
    fileprivate var orderShareSign: String?
    
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
        view.tableHeaderView = self.infoView
        view.tableFooterView = UIView.init(frame: CGRect.zero)
        view.estimatedRowHeight = WH(34) // 动态适配cell高度
        view.rowHeight = UITableView.automaticDimension
        view.register(FKYDrawEntranceCell.self, forCellReuseIdentifier: NSStringFromClass(FKYDrawEntranceCell.self))
        view.register(COOfflinePayInfoCell.self, forCellReuseIdentifier: "COOfflinePayInfoCell")
        view.register(COOfflinePayTipCell.self, forCellReuseIdentifier: "COOfflinePayTipCell")
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    // 订单信息视图1...<table-header>...<购物车/检查订单入口>
    fileprivate lazy var infoView: COOfflinePaySuccessView = {
        let view = COOfflinePaySuccessView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(164)))
        view.backgroundColor = .white
        // 查看订单
        view.showOrder = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.jumpToOrderList()
            // 个人中心
            //                        FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
            //                            let v = vc as! FKY_TabBarController
            //                            v.index = 4
            //                            // 订单列表...<待付款>
            //                            FKYNavigator.shared().openScheme(FKY_AllOrderController.self, setProperty: { (vc) in
            //                                let controller = vc as! FKYAllOrderViewController
            //                                controller.status = "1"
            //                            }, isModal: false)
            //                        }, isModal: false)
        }
        // 继续购买
        view.buyAgain = {
            // 首页
            FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                let v = vc as! FKY_TabBarController
                v.index = 0
            }, isModal: false)
            self.addNewBIRec(itemId: "I9421", itemName: "继续购买", itemPosition: "2")
        }
        return view
    }()
    // 订单信息视图2...<table-header>...<订单入口>
    fileprivate lazy var tipView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(80)))
        view.backgroundColor = .clear
        
        let viewContent = UIView.init(frame: CGRect.zero)
        viewContent.backgroundColor = .white
        view.addSubview(viewContent)
        viewContent.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(WH(12))
        })
        
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .left
        lbl.text = "此订单为线下转账订单，请您根据下面的银行账户进行线下打款，商家确认收到您的货款后，会对您的订单进行发货!"
        lbl.numberOfLines = 3
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        viewContent.addSubview(lbl)
        lbl.snp.makeConstraints({ (make) in
            make.left.equalTo(viewContent).offset(WH(10))
            make.right.equalTo(viewContent).offset(-WH(10))
            make.top.equalTo(viewContent).offset(WH(5))
            make.bottom.equalTo(viewContent).offset(-WH(5))
        })
        
        return view
    }()
    // 分享视图
    fileprivate lazy var shareView: ShareView4Pay = {
        let view = ShareView4Pay.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        // 微信分享
        view.WeChatShareClourse = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.shareForWechat()
        }
        // QQ分享
        view.QQShareClourse = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.shareForQQ()
        }
        // 复制链接
        view.CopyLinkShareClourse = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.shareForCopy()
        }
        return view
    }()
    
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupData()
        setupRequest()
        self.requestDrawInfo()
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
        print("COOfflinePayDetailController deinit~!@")
    }
}


// MARK: - UI
extension COOfflinePayDetailController {
    // UI绘制
    fileprivate func setupView() {
        setupNavigationBar()
        setupContentView()
    }
    
    // 导航栏
    fileprivate func setupNavigationBar() {
        // 标题
        fky_setupTitleLabel("线下支付详情")
        // 分隔线
        fky_hiddedBottomLine(false)
        
        // 返回
        fky_setupLeftImage("icon_back_new_red_normal") {
            // 从检查订单界面过来，且检查订单vc已从导航栈中移除
            FKYNavigator.shared().pop()
            self.addNewBIRec(itemId: "I9420", itemName: "返回", itemPosition: "1")
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
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-margin)
        }
        
        view.addSubview(shareView)
        shareView.isHidden = true
    }
}


// MARK: - Data
extension COOfflinePayDetailController {
    // 顶部信息视图展示
    fileprivate func setupData() {
        if flagFromCO {
            // 购物车/检查订单入口
            tableview.tableHeaderView = self.infoView
        }
        else {
            // 订单入口
            tableview.tableHeaderView = self.tipView
        }
        
        tableview.reloadData()
    }
}


// MARK: - Private
extension COOfflinePayDetailController {
    // 跳转到订单列表
    fileprivate func jumpToOrderList() {
        // 初始化订单列表界面vc
        let controller = FKYAllOrderViewController.init()
        controller.status = "1"
        
        // 先移除当前vc，再跳转到下个vc
        if let navControl = self.navigationController{
            var vcs = Array.init(navControl.viewControllers)
            vcs.removeLast()
            vcs.append(controller)
            navControl.setViewControllers(vcs, animated: true)
            self.addNewBIRec(itemId: "I9421", itemName: "查看订单", itemPosition: "1")
        }else{
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
        
    }
}


// MARK: - Request
extension COOfflinePayDetailController {
    //
    fileprivate func setupRequest() {
        requestForEnterpriseBankInfo()
    }
    
    /// 请求抽奖信息
    func requestDrawInfo(){
        if (self.orderId ?? "").isEmpty == true {
            //self.toast("订单号为空")
            return
        }
        self.OrderPayStatusModel.requestDrawInfo(fromPage: "", orderNo: self.orderId ?? "") { [weak self] (isSuccess, Msg) in
            guard let weakSelf = self else{
                return
            }
            
            if isSuccess == false {
                weakSelf.toast(Msg)
                return
            }
            weakSelf.tableview.reloadData()
        }
    }
    
    // 实时请求商家银行账户信息
    fileprivate func requestForEnterpriseBankInfo() {
        // 入参
        var param = Dictionary<String, Any>()
        if let token: String = UserDefaults.standard.value(forKey: "user_token") as? String, token.isEmpty == false {
            param["ycToken"] = token
        }
        if let sid = supplyId, sid.isEmpty == false {
            param["enterpriseId"] = sid
        }
        else {
            param["enterpriseId"] = "12800"
        }
        
        // 请求
        showLoading()
        FKYRequestService.sharedInstance()?.requestForEnterpriseBankInfo(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            // 请求失败
            guard success else {
                var msg = error?.localizedDescription ?? "请求失败"
                if let err = error {
                    let e = err as NSError
                    // token过期
                    if e.code == 2 {
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                // 失败回调
                strongSelf.toast(msg)
                return
            }
            // 请求成功
            //if let data = response as? NSDictionary {
            if let obj = model as? FKYBankInfoModel {
                // 获取商家银行账户信息成功
                
                // 保存
                strongSelf.bankInfo = obj
                
                // 成功回调
                strongSelf.tableview.reloadData()
                return
            }
            // 获取商家银行账户信息失败
            strongSelf.toast("请求失败")
        })
    }
    
    // 实时请求订单分享签名
    fileprivate func requestForOrderShareSign() {
        // 入参
        var param = Dictionary<String, Any>()
        if let token: String = UserDefaults.standard.value(forKey: "user_token") as? String, token.isEmpty == false {
            param["ycToken"] = token
        }
        if let oid = orderId, oid.isEmpty == false {
            param["flowId"] = oid
        }
        param["payType"] = "3" // 固定为线下转账3
        
        // 请求
        showLoading()
        FKYRequestService.sharedInstance()?.requestForOrderShareSign(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            // 请求失败
            guard success else {
                var msg = error?.localizedDescription ?? "获取分享链接失败"
                if let err = error {
                    let e = err as NSError
                    // token过期
                    if e.code == 2 {
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                // 失败回调
                strongSelf.toast(msg)
                return
            }
            // 请求成功
            if let obj = response as? String {
                // 获取分享链成功
                
                // 保存
                strongSelf.orderShareSign = obj
                
                // 成功回调
                strongSelf.showShareView()
                return
            }
            // 获取分享链失败
            strongSelf.toast("获取分享链接失败")
        })
    }
}


// MARK: - Share
extension COOfflinePayDetailController {
    //
    fileprivate func shareAction() {
        // 分享签名为空，需实时请求
        guard let sign = orderShareSign, sign.isEmpty == false else {
            requestForOrderShareSign()
            return
        }
        
        // 显示分享视图...<已获取签名>
        showShareView()
        self.addNewBIRec(itemId: "I9422", itemName: "支付信息分享", itemPosition: "1")
    }
    
    // 显示分享视图
    fileprivate func showShareView() {
        shareView.isHidden = false
        //shareView.appearClourse!()
        if let closure = shareView.appearClourse {
            closure()
        }
        else {
            shareView.showShareView()
        }
    }
    
    // 微信好友分享
    fileprivate func shareForWechat() {
        FKYShareManage.shareToWX(withOpenUrl: shareUrl(), title: shareTitle(), andMessage: nil, andImage: shareImage())
        //BI_Record("product_yc_share_wechat")
    }
    
    // QQ好友分享
    fileprivate func shareForQQ() {
        FKYShareManage.shareToQQ(withOpenUrl: shareUrl(), title: shareTitle(), andMessage: nil, andImage: shareImage())
        //BI_Record("product_yc_qq")
    }
    
    // 复制链接
    fileprivate func shareForCopy() {
        // 保存支付链接
        UIPasteboard.general.string = shareUrl()
        toast("支付链接自动复制成功，请立即粘贴支付信息发送给贵司财务！")
    }
    
    /*
     线下转账支付信息分享链接：http://m.yaoex.com/repay/offline_pay.html?orderid=XXX&sign=XXX
     找人代付支付信息分享链接：http://m.yaoex.com/bind/repay_pay.html?orderid=XXX&sign=XXX
     */
    
    // 分享链接
    fileprivate func shareUrl() -> String {
        if let url = orderShareSign, url.isEmpty == false {
            return url
        }
        
        return "http://m.yaoex.com"
    }
    
    // 分享标题
    fileprivate func shareTitle() -> String {
        if let amount = orderMoney, amount.isEmpty == false, let value = Float(amount), value > 0 {
            return String(format: "我在1药城采购了一批商品，总金额为￥%.2f，点击链接帮我支付吧！", value)
        }
        
        return "我在1药城采购了一批商品，点击链接帮我支付吧！"
    }
    
    // 分享图片...<使用本地默认图片>
    fileprivate func shareImage() -> String? {
        return nil
    }
}


// MARK: - UITableViewDelegate
extension COOfflinePayDetailController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.OrderPayStatusModel.drawRawData.drawPic.isEmpty == false || self.OrderPayStatusModel.drawRawData.orderDrawRecordDto.drawPic.isEmpty == false{
            return 5
        }else{
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "COOfflinePayTipCell", for: indexPath) as! COOfflinePayTipCell
            // 配置
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYDrawEntranceCell.self), for: indexPath) as! FKYDrawEntranceCell
            var imgUrl = ""
            if self.OrderPayStatusModel.drawRawData.drawPic.isEmpty == false {
                imgUrl = self.OrderPayStatusModel.drawRawData.drawPic
            }else if self.OrderPayStatusModel.drawRawData.orderDrawRecordDto.drawPic.isEmpty == false {
                imgUrl = self.OrderPayStatusModel.drawRawData.orderDrawRecordDto.drawPic
            }
            cell.configCellData(cellData: imgUrl)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "COOfflinePayInfoCell", for: indexPath) as! COOfflinePayInfoCell
            // 配置
            var name: String?
            var account: String?
            var bank: String?
            if let model: FKYBankInfoModel = bankInfo {
                name = model.accountName
                account = model.account
                bank = model.bankName
            }
            if indexPath.row == 0 {
                cell.setTitle(nil, .name)
                cell.setContent(name)
            }
            else if indexPath.row == 1 {
                cell.setTitle(nil, .account)
                cell.setContent(account)
            }
            else if indexPath.row == 2 {
                cell.setTitle(nil, .bank)
                cell.setContent(bank)
            }
            // 分享
            cell.sharePayInfoBlock = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.shareAction()
            }
            if !flagFromCO {
                // 订单入口隐藏分享
                cell.hideShareBtn()
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {// 抽奖活动入口
            return FKYDrawEntranceCell.getCellHeight()
        }
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(22)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //return nil
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(22)))
        view.backgroundColor = .clear
        
        let viewBottom = UIView.init(frame: CGRect.init(x: 0, y: WH(12), width: SCREEN_WIDTH, height: WH(10)))
        viewBottom.backgroundColor = .white
        view.addSubview(viewBottom)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 4 {
            FKYNavigator.shared()?.openScheme(FKY_OrderPayStatus.self, setProperty: { (vc) in
                let drawVC = vc as! FKYOrderPayStatusVC
                drawVC.orderNO = self.orderId ?? ""
                drawVC.fromePage = 5
            })
            self.addNewBIRec(itemId: "I9303", itemName: "点击抽奖", itemPosition: "1")
        }
    }
}

// MARK: - BI埋点
extension COOfflinePayDetailController {
    /// 第一种类型BI
    func addNewBIRec(itemId:String,itemName:String,itemPosition:String){
        self.addNewType2BIRec(sectionId: "", sectionName: "", sectionPosition: "", itemId: itemId, itemName: itemName, itemPosition: itemPosition, itemTitle: "", itemContent: "", storage: "", pm_price: "", pm_pmtn_type: "")
    }
    
    /// 第三种类型BI
    func addNewType2BIRec(sectionId:String,sectionName:String,sectionPosition:String,itemId:String,itemName:String,itemPosition:String,itemTitle:String,itemContent:String,storage:String,pm_price:String,pm_pmtn_type:String){
        let extendDic = ["storage":storage,
                         "pm_price":pm_price,
                         "pm_pmtn_type":pm_pmtn_type]
        FKYAnalyticsManager.sharedInstance.BI_New_Record("", floorPosition: "", floorName: "", sectionId: sectionId, sectionPosition: sectionPosition, sectionName: sectionName, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: itemContent, itemTitle: itemTitle, extendParams: extendDic as [String : AnyObject], viewController: self)
    }
}
