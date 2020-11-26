//
//  AccountViewController.swift
//  FKY
//
//  Created by 寒山 on 2020/6/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import UIKit

let disposeBag = DisposeBag()

class AccountViewController: UIViewController {
    var topMargin:CGFloat = 0.0  //顶部安全区高度
    var maxheadContentHeight:CGFloat = 0.0  //顶部用户名距底部高度
    // viewModel
    public lazy var viewModel: AccountViewModel = {
        let vm = AccountViewModel()
        return vm
    }()
    //头部渐变背景
    fileprivate lazy var contentLayer: CALayer = {
        let bgLayer1 = CAGradientLayer()
        bgLayer1.backgroundColor = UIColor.clear.cgColor
        bgLayer1.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor,UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor, UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor]
        bgLayer1.locations = [0,0.6,1]
        //bgLayer1.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(170))
        bgLayer1.startPoint = CGPoint(x: 0.5, y: 0)
        bgLayer1.endPoint = CGPoint(x: 0.5, y: 1.0)
        //        bgLayer1.shouldRasterize = true
        //        bgLayer1.rasterizationScale = UIScreen.main.scale
        return bgLayer1
    }()
    // 背景
    public lazy var headBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    //店铺选择视图
    fileprivate lazy var viewEnterprise: FKYEnterpriseListView = {
        let view = FKYEnterpriseListView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        // 选择
        view.selectEnterpriseBlock = {[weak self] (index,data)in
            if let strongSelf = self{
                if let shopName = data as? String{
                    strongSelf.changeEnterprise(index,shopName)
                }
                strongSelf.hideEnterpriseListView()
            }
        }
        // 隐藏
        view.dismissBlock = {[weak self] in
            if let strongSelf = self{
                strongSelf.hideEnterpriseListView()
            }
        }
        
        return view
    }()
    
    fileprivate lazy var maskView: UserGuideMaskInAccountView = {
        let view = UserGuideMaskInAccountView()
        view.enterCredentialInfoBlock = {[weak self] in
            if let _ = self{
                FKYNavigator.shared().openScheme(FKY_CredentialsController.self, setProperty: nil)
            }
        }
        return view
    }()
    //一键入库的蒙版
    fileprivate lazy var treasuryMaskView: UserGuideMaskForEnterTreasuryView = {
        let view = UserGuideMaskForEnterTreasuryView()
        view.enterTreasuryViewBlock = {[weak self] in
            if let strongSelf = self{
                if let toolsArray = strongSelf.viewModel.accountInfoModel?.tools,toolsArray.count >= 3{
                    if let stockModel:AccountToolsModel = toolsArray[2] as AccountToolsModel?,(stockModel.toolId == "899089"||stockModel.title == "智能采购"){
                        if let app = UIApplication.shared.delegate as? AppDelegate {
                            if let url = stockModel.jumpInfo, url.isEmpty == false {
                                app.p_openPriveteSchemeString(url)
                            }
                        }
                    }
                }
            }
        }
        return view
    }()
    //滑动显示的视图
    fileprivate lazy var headHideView: AccountHideHeadView = {
        let view = AccountHideHeadView()
        view.settingBlock = {[weak self] in
            //设置
            if let strongSelf = self {
                strongSelf.addBIRecordForHeadAction("设置",4)
                FKYNavigator.shared()?.openScheme(FKY_SetUpController.self, setProperty: nil, isModal: false)
            }
        }
        view.loginBlock = {[weak self] in
            //登录
            if let strongSelf = self {
                strongSelf.addBIRecordForHeadAction("登录/注册",1)
                FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            }
        }
        view.switchShopBlock = {[weak self] in
            //切换店铺
            if let strongSelf = self {
                strongSelf.addBIRecordForHeadAction("切换企业",3)
                strongSelf.swiftShopAction()
            }
        }
        return view
    }()
    
    // table
    fileprivate lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: CGRect.null, style: .plain)
        tb.delegate = self
        tb.dataSource = self
        tb.backgroundColor = .clear
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.register(AccountUserInfoCell.self, forCellReuseIdentifier: "AccountUserInfoCell")
        tb.register(AccountOrderInfoCell.self, forCellReuseIdentifier: "AccountOrderInfoCell")
        tb.register(AccountUserWalletCell.self, forCellReuseIdentifier: "AccountUserWalletCell")
        tb.register(AcountToolsListCell.self, forCellReuseIdentifier: "AcountToolsListCell")
        if #available(iOS 11, *) {
            tb.contentInsetAdjustmentBehavior = .never
            tb.estimatedRowHeight = 0//WH(213)
            tb.estimatedSectionHeaderHeight = 0
            tb.estimatedSectionFooterHeight = 0
        }
        return tb
    }()
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 获取常用工具列表 & 请求用户基本信息
        setupData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FKYLoginAPI.loginStatus() != .unlogin {
            if let user: FKYUserInfoModel = FKYLoginAPI.currentUser() {
                self.viewModel.userInfoModel = user
            }
        }
        self.maxheadContentHeight = configUserNameHeight()
        setupView()
        // Do any additional setup after loading the view.
        bindViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.p_syncLoginStatus(_:)), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.p_syncLoginStatus(_:)), name: NSNotification.Name.FKYLogoutComplete, object: nil)
    }
    // 数据绑定
    func bindViewModel() -> () {
        //未完善资料蒙版
        _ = self.viewModel.rx.observeWeakly(Bool.self, "isNotPerfectInformation").subscribe(onNext: { [weak self] (isNotPerfectInformation) in
            guard let strongSelf = self else {
                return
            }
            if FKYLoginAPI.loginStatus() != .unlogin, isNotPerfectInformation == true{
                if let isHandelUserGuideMask = UserDefaults.standard.value(forKey: "isHandelUserGuideMask") {
                    if let _ = isHandelUserGuideMask as? Bool,isHandelUserGuideMask as! Bool == false{
                        strongSelf.view.isUserInteractionEnabled = false
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:{[weak self] in
                            guard let strongSelf = self else {
                                return
                            }
                            strongSelf.view.isUserInteractionEnabled = true
                            strongSelf.showViewMask()
                        })
                    }
                }
            }
        })
        //显示一键入库
        _ = self.viewModel.rx.observeWeakly(Bool.self, "isShowEnterTreasury").subscribe(onNext: { [weak self] (isShowEnterTreasury) in
            guard let strongSelf = self else {
                return
            }
            if FKYLoginAPI.loginStatus() != .unlogin, isShowEnterTreasury == true{
                if let showEnterTreasury = UserDefaults.standard.value(forKey: "showEnterTreasury") {
                    if let _ = showEnterTreasury as? Bool,showEnterTreasury as! Bool == false{
                        strongSelf.view.isUserInteractionEnabled = false
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:{[weak self] in
                            guard let strongSelf = self else {
                                return
                            }
                            strongSelf.view.isUserInteractionEnabled = true
                            strongSelf.showTreasuryViewMask()
                        })
                    }
                }
            }
        })
    }
    fileprivate func setupView() {
        self.view.backgroundColor = RGBColor(0xF4F4F4)
        topMargin = CGFloat(SKPhotoBrowser.getScreenTopMargin())
        self.view.addSubview(headBgView)
        headBgView.frame =  CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:WH(170))
        headBgView.layer.addSublayer(contentLayer)
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view)
        })
        
        self.view.addSubview(headHideView)
        headHideView.alpha =  0.0
        headHideView.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(WH(76) + topMargin)
        })
        
        configAccountView()
    }
    func configAccountView(){
        var baseHeight = WH(136)
        if FKYLoginAPI.loginStatus() != .unlogin {
            if let _ = self.viewModel.accountInfoModel{
                baseHeight = AccountUserInfoCell.configAccountUserInfoCellH(self.viewModel.accountInfoModel as Any)
            }else{
                baseHeight = AccountUserInfoCell.configAccountUserInfoCellH(self.viewModel.userInfoModel as Any)
            }
        }
        headHideView.configViewByUserInfo(self.viewModel.userInfoModel)
        //顶部的白色渐变，比头部高度多30
        headBgView.frame =  CGRect.init(x: 0, y: -(tableView.contentOffset.y), width: SCREEN_WIDTH, height:baseHeight + WH(30))
        contentLayer.frame =  CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:baseHeight + WH(30))
        contentLayer.layoutIfNeeded()
    }
    //显示蒙版
    func showViewMask(){
        if let userInfo = self.viewModel.accountInfoModel,let tools =  userInfo.tools,tools.count > 0{
            if self.isViewLoaded && (self.view.window != nil){
                maskView.showInUserGuide()
            }
        }
    }
    func showTreasuryViewMask(){
        if let userInfo = self.viewModel.accountInfoModel{
            if self.isViewLoaded && (self.view.window != nil){
                treasuryMaskView.showInUserGuide(userInfo)
            }
        }
       
    }
    
    //计算用户名距离顶部的高度 滑动到这个高度刚好隐藏店铺名
    func configUserNameHeight()-> CGFloat{
        if FKYLoginAPI.loginStatus() != .unlogin {
            if let user: FKYUserInfoModel = FKYLoginAPI.currentUser() {
                var contentSizeHeight  = WH(18)
                var enterpriseNameStr = ""
                if let enterpriseName = user.enterpriseName,enterpriseName.isEmpty == false{
                    // 企业名称
                    enterpriseNameStr  = enterpriseName
                    contentSizeHeight = enterpriseNameStr.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(16) - WH(43) - WH(10) - WH(74) - WH(24), height: WH(40)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(16))], context: nil).size.height
                    contentSizeHeight = ((contentSizeHeight > WH(40)) ? WH(40):contentSizeHeight)
                }
                return WH(63.5) + contentSizeHeight + WH(10) + WH(13) - WH(76)
            }
            return  WH(63.5) + WH(18) + WH(10) + WH(13) - WH(76)
            
        }else{
            return  WH(63.5) + WH(18) + WH(10) + WH(13) - WH(76)
        }
    }
}

//MARK: - Notification和网络请求
extension  AccountViewController{
    @objc fileprivate func p_syncLoginStatus(_ nty: Notification){
        if FKYLoginAPI.loginStatus() != .unlogin {
            if let user: FKYUserInfoModel = FKYLoginAPI.currentUser() {
                self.viewModel.userInfoModel = user
            }
        }
        self.maxheadContentHeight = configUserNameHeight()
        headHideView.configViewByUserInfo(self.viewModel.userInfoModel)
        setupData()
    }
    func setupData(){
        // 请求用户信息
        self.showLoading()
        self.viewModel.getUserBaseInfo({ [weak self] (success, message) in
            guard let strongSelf = self else {
                return
            }
            if let vipSymbol = strongSelf.viewModel.accountInfoModel?.vipInfo?.vipSymbol{
                if vipSymbol == 1{
                    (UIApplication.shared.delegate as! AppDelegate).tabBarController.setTabbarVipBadgeValueForAcount(true)
                }else{
                    (UIApplication.shared.delegate as! AppDelegate).tabBarController.setTabbarVipBadgeValueForAcount(false)
                }
                
            }
            strongSelf.dismissLoading()
            if success {
                strongSelf.configAccountView()
                strongSelf.tableView.reloadData()
            }
            else {
                strongSelf.configAccountView()
                strongSelf.tableView.reloadData()
                strongSelf.toast(message)
            }
        })
    }
    //切换店铺请求
    // 切换企业
    func changeEnterprise(_ index:NSInteger ,_ shopName:String?){
        // 当前登录账号...<不需要再进行切换操作>
        if index == 0{
            return;
        }
        // 账号名称为空
        if shopName != nil , shopName!.isEmpty ==  true{
            return;
        }
        self.showLoading()
        self.viewModel.requestForChangeUserAction(shopName!, index,{ [weak self] (success, message) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if success {
                // 切换(企业)成功
                NotificationCenter.default.post(name: NSNotification.Name.FKYLoginSuccess, object: self)
                // 清缓存...<企业信息>
                ZZModel.removeHistoryData()
                // 清缓存...<上传资制质>
                ZZModelQCListInfoPartInfo.removeQCList()
                strongSelf.configAccountView()
                if FKYLoginAPI.loginStatus() != .unlogin {
                    if let user: FKYUserInfoModel = FKYLoginAPI.currentUser() {
                        strongSelf.viewModel.userInfoModel = user
                    }
                }
                strongSelf.maxheadContentHeight = strongSelf.configUserNameHeight()
                strongSelf.headHideView.configViewByUserInfo(strongSelf.viewModel.userInfoModel)
                strongSelf.tableView.reloadData()
            }
            else {
                strongSelf.tableView.reloadData()
                strongSelf.configAccountView()
                strongSelf.toast(message)
            }
        })
        
    }
}
//MARK: - UITableViewDataSource & UITableViewDelegate
extension  AccountViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            //用户信息
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountUserInfoCell", for: indexPath) as!   AccountUserInfoCell
            cell.selectionStyle = .none
            if let _ = self.viewModel.accountInfoModel{
                cell.configCell(self.viewModel.accountInfoModel,self.viewModel.isNotPerfectInformation)
            }else{
                cell.configCellByUserInfo(self.viewModel.userInfoModel)
            }
            
            cell.settingBlock = {[weak self] in
                //设置
                if let strongSelf = self {
                    strongSelf.addBIRecordForHeadAction("设置",4)
                    FKYNavigator.shared()?.openScheme(FKY_SetUpController.self, setProperty: nil, isModal: false)
                }
            }
            cell.loginBlock = {[weak self] in
                //登录
                if let strongSelf = self {
                    strongSelf.addBIRecordForHeadAction("登录/注册",1)
                    FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: nil, isModal: true)
                }
            }
            cell.vipRulesOrVipListBlock = {[weak self] in
                //进入vip专区或者了解会员
                if let strongSelf = self {
                    strongSelf.vipRulesOrVipList()
                }
            }
            cell.enterComplentInfoBlock = {[weak self] in
                //完善资料
                if let strongSelf = self {
                    strongSelf.addBIRecordForHeadAction("完善基本资料",2)
                    if strongSelf.viewModel.isNotPerfectInformation == true{
                        FKYNavigator.shared().openScheme(FKY_CredentialsController.self, setProperty: nil)
                    }
                }
            }
            cell.switchShopBlock = {[weak self] in
                //切换店铺
                if let strongSelf = self {
                    strongSelf.addBIRecordForHeadAction("切换企业",3)
                    strongSelf.swiftShopAction()
                }
            }
            cell.vipRulesBlock = {[weak self] in
                //了解会员
                if let strongSelf = self {
                    strongSelf.addBIRecordForHeadAction("会员icon",6)
                    FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: {[weak self] (vc) in
                        let controller = vc as! FKY_Web
                        if let _ = self {
                            controller.urlPath =  API_VIP_INTRODUCTION_H5
                        }
                    })
                }
            }
            return cell
        }
        if indexPath.section == 1{
            //订单模块信息
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountOrderInfoCell", for: indexPath) as!   AccountOrderInfoCell
            cell.selectionStyle = .none
            cell.configCell(self.viewModel.accountInfoModel)
            cell.clickOrderCellTypeAction = { [weak self] (cellType)in
                if let strongSelf = self {
                    strongSelf.clickOrderCellTypeAction(cellType)
                }
            }
            return cell
        }
        
        if indexPath.section == 3{
            //工具栏信息
            let cell = tableView.dequeueReusableCell(withIdentifier: "AcountToolsListCell", for: indexPath) as!   AcountToolsListCell
            cell.selectionStyle = .none
            cell.configCell(self.viewModel.accountInfoModel,self.viewModel.isNotPerfectInformation)
            cell.clickToolsListAction = { [weak self] (model,index)in
                //点击工具栏
                if let strongSelf = self {
                    
                    let newKey = "(tools_\(model?.toolId ?? "")_isNew)"
                    
                    if let newFlag = UserDefaults.standard.value(forKey: newKey) as? Bool,newFlag == true{
                        UserDefaults.standard.set(false, forKey: newKey)
                        UserDefaults.standard.synchronize()
                    }
                    
                    strongSelf.addBIRecordForToolAction(model?.title ?? "",index)
                    if let url = model?.jumpInfo, url.isEmpty == false,url.hasPrefix("fky://account/invoice") == true{
                        //发票管理进入逻辑
                        guard FKYLoginAPI.loginStatus() != .unlogin else {// 未登录
                            FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: nil, isModal: true)
                            return
                        }
                        strongSelf.viewModel.requestForEnterpriseInfoFromErp({ [weak self] (success, message) in
                            guard let strongSelf = self else {
                                return
                            }
                            if success {
                                if let app = UIApplication.shared.delegate as? AppDelegate {
                                    app.p_openPriveteSchemeString(url)
                                }
                            }
                            else {
                                strongSelf.toast("通过电子审核之后才可维护发票信息")
                            }
                        })
                        return
                    }
                    if let app = UIApplication.shared.delegate as? AppDelegate {
                        if let url = model?.jumpInfo, url.isEmpty == false {
                            app.p_openPriveteSchemeString(model?.jumpInfo)
                        }
                    }
                }
            }
            return cell
        }
        //用户钱包优惠券等信息
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountUserWalletCell", for: indexPath) as!   AccountUserWalletCell
        cell.selectionStyle = .none
        cell.configCell(self.viewModel.accountInfoModel)
        cell.clickWallteCellTypeAction = { [weak self] (cellType)in
            if let strongSelf = self {
                strongSelf.clickWallteCellTypeAction(cellType)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            //还没请前 可以使用当前用户先赋值
            if let _ = self.viewModel.accountInfoModel{
                return AccountUserInfoCell.configAccountUserInfoCellH(self.viewModel.accountInfoModel as Any )
            }else{
                return AccountUserInfoCell.configAccountUserInfoCellH(self.viewModel.userInfoModel as Any)
            }
        }
        if indexPath.section == 1 {
            return WH(10) + WH(123)
        }
        if indexPath.section == 2 {
            if let model = self.viewModel.accountInfoModel, model.cellTypeArr.count > 4 {
                return WH(10) + WH(123) + WH(8)
            }
            return WH(10) + WH(123)
        }
        if indexPath.section == 3{
            return AcountToolsListCell.configAccountToolsCellH(self.viewModel.accountInfoModel)
        }
        return WH(0)
    }
}
//让渐变和table一起滚动
extension AccountViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headBgView.hd_y =  -(tableView.contentOffset.y)
        changeHideHeadViewAlpha()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        headBgView.hd_y =  -(tableView.contentOffset.y)
        changeHideHeadViewAlphaEndScrol()
        
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        headBgView.hd_y =  -(tableView.contentOffset.y)
        changeHideHeadViewAlphaEndScrol()
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        headBgView.hd_y =  -(tableView.contentOffset.y)
        changeHideHeadViewAlphaEndScrol()
    }
    func changeHideHeadViewAlpha(){
        if tableView.contentOffset.y >= maxheadContentHeight{
            headHideView.alpha = 1.0
        }else if  tableView.contentOffset.y <= 0{
            headHideView.alpha = 0.0
        }else{
            headHideView.alpha = tableView.contentOffset.y/maxheadContentHeight
        }
    }
    func changeHideHeadViewAlphaEndScrol(){
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.tableView.contentOffset.y >= strongSelf.maxheadContentHeight{
                strongSelf.headHideView.alpha = 1.0
            }else {
                strongSelf.headHideView.alpha = 0.0
                strongSelf.tableView.contentOffset.y = 0
            }
        })
    }
}
//MARK: - 点击事件
extension  AccountViewController{
    // 显示企业列表视图
    func showEnterpriseListView(){
        if let user: FKYUserInfoModel = FKYLoginAPI.currentUser() {
            if let nameList = user.nameList,nameList.count > 1 {
                self.viewEnterprise.setEnterpriseList(user.nameList, withCurrentEnterprise: user.userName)
                self.viewEnterprise.showOrHide(true, withAnimation: true)
            }
        }
    }
    
    // 隐藏企业列表视图
    func hideEnterpriseListView(){
        self.viewEnterprise.showOrHide(false, withAnimation: true)
    }
    //了解会员或者进入会员专区
    func vipRulesOrVipList(){
        var vipUrl = ""
        if let vipInfo = self.viewModel.accountInfoModel?.vipInfo{
            if let vipSymbol = vipInfo.vipSymbol,vipSymbol == 1{
                //会员专区
                self.addBIRecordForHeadAction("会员专区",7)
                if let url = vipInfo.url,url.isEmpty == false{
                    vipUrl = url
                }else{
                    vipUrl = API_VIP_PRODUCT_LIST_H5
                }
            }else if let vipSymbol = vipInfo.vipSymbol,vipSymbol == 0{
                //了解会员
                self.addBIRecordForHeadAction("了解会员",5)
                vipUrl = API_VIP_INTRODUCTION_H5
            }
        }
        FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: {[weak self] (vc) in
            let controller = vc as! FKY_Web
            if let _ = self {
                controller.urlPath = vipUrl
            }
        })
    }
    //切换店铺
    func swiftShopAction(){
        showEnterpriseListView()
    }
    //点击钱包信息
    func clickWallteCellTypeAction(_ cellType:AccountWallteCellType){
        if cellType == .AccountWallteCellTypeShoppingMoney{
            //购物金
            guard FKYLoginAPI.loginStatus() != .unlogin else {// 未登录
                FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: nil, isModal: true)
                return
            }
            if self.viewModel.isNotPerfectInformation == true{
                //未完善信息
                self.toast("资质未认证")
                return
            }
            if let accountModel = self.viewModel.accountInfoModel,let enterpriseName = accountModel.enterpriseName,enterpriseName.isEmpty == false{
                self.addBIRecordForWalletAction("购物金",5)
                FKYNavigator.shared()?.openScheme(FKY_ShoppingMoneyBalanceVC.self, setProperty: { (vc) in
                    
                })
                return
            }
            self.toast("资质未认证")
            return;
        }else if cellType == .AccountWallteCellTypeRebate{
            //返利金
            if FKYLoginAPI.loginStatus() == .unlogin {
                FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            }else{
                // 跳转我的资产页面
                self.addBIRecordForWalletAction("返利金",1)
                FKYNavigator.shared()?.openScheme(FKY_RebateInfoController.self, setProperty: nil, isModal: false)
            }
        }else if cellType == .AccountWallteCellTypeCounple{
            //优惠券
            if FKYLoginAPI.loginStatus() == .unlogin {
                FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            }else{
                //优惠券
                self.addBIRecordForWalletAction("优惠券",3)
                FKYNavigator.shared()?.openScheme(FKY_MyCoupon.self, setProperty: nil, isModal: false)
            }
        }else if cellType == .AccountWallteCellTypeBanking{
            //上海金融
            if FKYLoginAPI.loginStatus() == .unlogin {
                FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            }else{
                if let shModel = self.viewModel.accountInfoModel?.shBankModel ,let url = shModel.url ,url.count > 0 {
                    FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                        let controller = vc as! FKY_Web
                        controller.urlPath = url
                    })
                }
            }
        }else if cellType == .AccountWallteCellTypeLoan{
            //            FKYNavigator.shared()?.openScheme(FKY_LiveContentListViewController.self, setProperty: nil, isModal: false)
            //            return
            //1药贷
            if FKYLoginAPI.loginStatus() == .unlogin {
                FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            }else{
                self.addBIRecordForWalletAction("{1药贷/1药贷-对公}",2)
                if let yydInfo = self.viewModel.accountInfoModel?.yydInfo{
                    if let loanDesc = yydInfo.loanDesc,loanDesc.isEmpty == false,loanDesc == "暂停申请"{
                        //暂停申请目前1药贷 不可点击
                        return
                    }
                    if let isAuditIng = yydInfo.isAudit ,(isAuditIng == 1 || isAuditIng == 5) { //质管审核通过或资质过期
                        if let isCheckIng = yydInfo.isCheck, (isCheckIng == 1 || isCheckIng == 3) {
                            // BD状态为审核通过或变更
                            if (yydInfo.yydShow ?? 0) == 1{
                                if yydInfo.status == "-1"{
                                    self.toast("服务器正在打盹，请稍后再试。")
                                }else{
                                    if let returnUrl = yydInfo.returnUrl,returnUrl.isEmpty == false{
                                        FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                                            let controller = vc as! FKY_Web
                                            controller.urlPath = String(format:"%@?limitOverdue=\(yydInfo.limitOverdue ?? 0)", returnUrl)
                                        })
                                    }
                                }
                            }
                        }
                        else{
                            if let yydTitle = yydInfo.yydTitle,yydTitle.isEmpty == false{
                                self.toast(String(format:"资质审核通过后才能申请开通%@", yydTitle))
                            }else{
                                self.toast("资质审核通过后才能申请开通1药贷。")
                            }
                        }
                    }else{
                        self.toast("尊敬的客户，您尚未完成药城自营发货审核，请通过审核后再来申请。")
                    }
                }
            }
        }
    }
    //点击订单信息
    func clickOrderCellTypeAction(_ cellType:AccountOrderCellType){
        if FKYLoginAPI.loginStatus() == .unlogin {
            FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            return
        }
        if cellType == .WaitPay{
            //待支付
            self.addBIRecordForOrderAction("待付款",2)
            FKYNavigator.shared()?.openScheme(FKY_AllOrderController.self, setProperty: { (vc) in
                let allOrderVC = vc as! FKYAllOrderViewController
                allOrderVC.status = "1"
            })
        }else if cellType == .WaitSend{
            //待发货
            self.addBIRecordForOrderAction("待发货",3)
            FKYNavigator.shared()?.openScheme(FKY_AllOrderController.self, setProperty: { (vc) in
                let allOrderVC = vc as! FKYAllOrderViewController
                allOrderVC.status = "2"
            })
        }else if cellType == .Sending{
            //待收货
            self.addBIRecordForOrderAction("待收货",4)
            FKYNavigator.shared()?.openScheme(FKY_AllOrderController.self, setProperty: { (vc) in
                let allOrderVC = vc as! FKYAllOrderViewController
                allOrderVC.status = "3"
            })
        }else if cellType == .RCType{
            //退换货售后
            self.addBIRecordForOrderAction("退换货/售后",5)
            FKYNavigator.shared().openScheme(FKY_RefuseOrder.self, setProperty: {  (vc) in
                let v = vc as! FKYRefuseListViewController
                v.listType = .DEFAULT
            }, isModal: false)
        }else if cellType == .ALL{
            //全部订单
            self.addBIRecordForOrderAction("查看全部订单",1)
            FKYNavigator.shared()?.openScheme(FKY_AllOrderController.self, setProperty: { (vc) in
                let allOrderVC = vc as! FKYAllOrderViewController
                allOrderVC.status = "0"
            })
        }
    }
}

//MARK: - 埋点
extension  AccountViewController{
    // 为头部位置埋点
    fileprivate func addBIRecordForHeadAction(_ itemName:String, _ index:Int) {
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I6021", itemPosition: "\(index)", itemName:itemName, itemContent: nil, itemTitle: nil, extendParams:nil, viewController: self)
    }
    // 为我的钱包埋点
    fileprivate func addBIRecordForWalletAction(_ itemName:String, _ index:Int) {
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I6022", itemPosition: "\(index)", itemName:itemName, itemContent: nil, itemTitle: nil, extendParams:nil, viewController: self)
    }
    // 为订单点击埋点
    fileprivate func addBIRecordForOrderAction(_ itemName:String, _ index:Int) {
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "全部订单", itemId: "I6023", itemPosition: "\(index)", itemName:itemName, itemContent: nil, itemTitle: nil, extendParams:nil, viewController: self)
    }
    // 为工具列表埋点
    fileprivate func addBIRecordForToolAction(_ itemName:String, _ index:Int) {
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "常用工具", itemId: "I6024", itemPosition: "\(index)", itemName:itemName, itemContent: nil, itemTitle: nil, extendParams:nil, viewController: self)
    }
}
