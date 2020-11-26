//
//  YQGCartViewController.swift
//  FKY
//
//  Created by 寒山 on 2018/10/18.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  一起购购物车

import UIKit
import RxSwift
import RxCocoa
import Foundation

class YQGCartViewController: UIViewController {
    //MARK: - Property
    var cellHeightsDictionary =  [IndexPath:CGFloat]()
    // closure
    @objc var switchBlock: (()->())? // 切换购物车
    
    // 默认不可返回
    @objc var canBack: Bool = false
    // 默认不隐藏顶部类型选择视图
    @objc var hideTypeView: Bool = false
    
    // 导航栏
    fileprivate lazy var navBar: UIView? = {
        if let _ = self.NavigationBar {
            //
        }
        else {
            self.fky_setupNavBar()
        }
        self.NavigationBar?.backgroundColor = .white
        return self.NavigationBar
    }()
    //商品异常弹框
    fileprivate lazy var exceptionDetailVC : FKYPopExceptionDetailVC = {
        let vc = FKYPopExceptionDetailVC()
        vc.clickFuntionBtn = { [weak self] (indexSection ,typeIndex) in
            guard let strongSelf = self else {
                return
            }
            if indexSection == -4 {
                //直接结算
                strongSelf.submitPartMerchanetOrder()
            }else if indexSection >= 0 , indexSection < strongSelf.tableView.numberOfSections {
                strongSelf.tableView.scrollToRow(at: IndexPath(row: 0, section: indexSection), at: .top, animated: false)
                let deadline = DispatchTime.now() + 0.5 //刷新数据的时候有延迟，所以推后1S刷新
                DispatchQueue.global().asyncAfter(deadline: deadline) {
                    DispatchQueue.main.async { [weak self] in
                        if let strongSelf = self {
                            strongSelf.tableView.scrollToRow(at: IndexPath.init(row: 0, section: indexSection), at: .top, animated: false)
                        }
                    }
                }
                if typeIndex == 3 {
                    //商品信息变化弹框才刷新
                    strongSelf.requestForCartData()
                }
            }
        }
        return vc
    }()
    //优惠明细列表弹框
    fileprivate lazy var preferentialDetailVC : FKYPopPreferentialDeatillVC = {
        let vc = FKYPopPreferentialDeatillVC()
        vc.canBack = self.canBack
        //关闭明细弹框
        vc.closePopView = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.bottomView!.setArrowDirType(.BottomArrowDir_Up)
        }
        return vc
    }()
    // 编辑btn
    fileprivate lazy var btnEdit: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.titleLabel?.font = FKYSystemFont(WH(16))
        btn.setTitleColor(RGBColor(0x333333), for: UIControlState())
        btn.setTitle("编辑", for: UIControlState())
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self,weak btn] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.showLoading()
            strongSelf.cartProvider.isEditing = !(strongSelf.cartProvider.isEditing)
            if strongSelf.cartProvider.isEditing {
                btn?.setTitle("完成", for: UIControlState())
            }
            else {
                btn?.setTitle("编辑", for: UIControlState())
            }
            //
            strongSelf.cartProvider.updateCartListForIsEdit(isEdit: strongSelf.cartProvider.isEditing, handler: { [weak self](success,message) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableView.reloadData()
                strongSelf.dismissLoading()
            })
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 返回btn
    fileprivate lazy var btnBack: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.setImage(UIImage(named: "icon_back_new_red_normal"), for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            FKYNavigator.shared().pop()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 分类选择视图
    fileprivate lazy var viewType: FKYCartTypeView = {
        let view = FKYCartTypeView.init(frame: CGRect.zero)
        view.setSelectedIndex(1)
        view.selectBlock = { [weak self] (index) in
            guard let strongSelf = self else {
                return
            }
            if index == 1 {
                return
            }
            guard let closure = strongSelf.switchBlock else {
                return
            }
            closure()
        }
        return view
    }()
    
    // table
    fileprivate lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: CGRect.zero, style: .grouped)
        tb.delegate = self
        tb.dataSource = self
        tb.backgroundColor = RGBColor(0xF2F2F2)
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.tableHeaderView = {
            let bgView = UIView.init(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
            bgView.backgroundColor = RGBColor(0xF2F2F2)
            return bgView
        }()
        tb.tableFooterView = {
            let view = UIView.init(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(62)))
            view.backgroundColor = RGBColor(0xF2F2F2)
            return view
        }()
        tb.register(FKYShoppingCarProductTableViewCell.self, forCellReuseIdentifier: "FKYShoppingCarProductTableViewCell")
        tb.register(FKYProductActivityCell.self, forCellReuseIdentifier:"FKYProductActivityCell")
        tb.register(FKYProductActivityGroupFooterCell.self, forCellReuseIdentifier: "FKYProductActivityGroupFooterCell")
        tb.register(CartSpaceCell.self, forCellReuseIdentifier: "CartSpaceCell")
        if #available(iOS 11, *) {
            tb.contentInsetAdjustmentBehavior = .never
        }
        return tb
    }()
    
    // 底部结算视图
    // 底部结算视图
    fileprivate lazy var bottomView: NewCartBottomView? = {
        let view = NewCartBottomView()
        view.shadow(with: RGBAColor(0x000000,alpha: 0.1), offset: CGSize(width: 0, height: -4), opacity: 1, radius: 4)
        // 全选
        view.tappedStatusImageBlock = { [weak self,weak view] (isSelected) in
            guard let strongSelf = self else {
                return
            }
            //关闭优惠明细弹框
            view?.setArrowDirType(.BottomArrowDir_Up)
            strongSelf.preferentialDetailVC.showOrHideCouponPopView(false)
            if strongSelf.cartProvider.isEditing {
                // 编辑状态
                strongSelf.showLoading()
                strongSelf.cartProvider.setSelectAllProductForEdit(selectAll: !(strongSelf.cartProvider.isAllProductSelectedForEdit()) , handler: { (success, msg) in
                    strongSelf.tableView.reloadData()
                    strongSelf.dismissLoading()
                })
            }
            else {
                // 非编辑状态
                strongSelf.showLoading()
                let isAllSelected = strongSelf.cartProvider.isAllProductSelected()
                var jsonParam = [String: Any]()
                var contentArray: [Any] = []
                for sectionModel in (strongSelf.cartProvider.sectionArray){
                    if sectionModel.productGroupList != nil{
                        for item in sectionModel.productGroupList! {
                            if item.groupItemList != nil{
                                for object in item.groupItemList! {
                                    if object.checkStatus == isAllSelected {
                                        contentArray.append(object.shoppingCartId ?? "")
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
                
                jsonParam["checkStatus"] = !isAllSelected
                jsonParam["shoppingCartIdList"] = contentArray
                jsonParam["fromwhere"] = 2
                //分享者ID
                if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                    jsonParam["shareUserId"] = cpsbd
                }
                strongSelf.cartProvider.updateYQGCartGoodsSelectState(withParameter: jsonParam as NSDictionary, handler: { [weak self] (success, msg) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.tableView.reloadData()
                    strongSelf.dismissLoading()
                })
            }
        }
        // 结算 or 删除
        view.submitBlock = { [weak self,weak view] in
            guard let strongSelf = self else {
                return
            }
            //关闭优惠明细弹框
            view?.setArrowDirType(.BottomArrowDir_Up)
            strongSelf.preferentialDetailVC.showOrHideCouponPopView(false)
            strongSelf.toSettleAccounts()
        }
        //查看优惠详细
        view.checkDetailPromotionBlock = { [weak self,weak view] in
            guard let strongSelf = self else {
                return
            }
            view?.setArrowDirType(.BottomArrowDir_Down)
            strongSelf.preferentialDetailVC.configPreferentialViewController(strongSelf.cartProvider.preferetialArr)
        }
        return view
    }()
    
    // 空态视图
    fileprivate lazy var emptyView: FKYStaticView = {
        let view = FKYStaticView()
        // 跳转首页
        view.actionBlock = {
            FKYNavigator.shared().openScheme(FKY_TabBarController.self) { (vc) in
                let v = vc as! FKY_TabBarController
                v.index = 0
            }
        }
        return view
    }()
    
    //
    fileprivate lazy var cartProvider: FKYYQGCartProvider = {
        return FKYYQGCartProvider()
    }()
    
    
    //MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FKYLoginAPI.loginStatus() != .unlogin  && FKYLoginAPI.shareInstance().loginUser != nil{
            self.fky_setUpNavigationBarBottomTitle(FKYLoginAPI.shareInstance().loginUser.enterpriseName,RGBColor(0x666666),UIFont.systemFont(ofSize: WH(14)))
        }else{
            self.fky_setUpNavigationBarBottomTitle(nil)
        }
        self.setupRequest()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //关闭优惠明细弹框
        self.preferentialDetailVC.showOrHideCouponPopView(false)
        self.bottomView!.setArrowDirType(.BottomArrowDir_Up)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.dismissLoading()
        print("YQGCartViewController deinit~!@")
    }
    
    
    //MARK: - UI
    
    fileprivate func setupView() {
        setupNavBar()
        setupContentView()
    }
    
    // 导航栏
    fileprivate func setupNavBar() {
        // self.fky_setNavigationBarTitle("购物车")
        self.fky_setupTitleLabel("购物车")
        self.fky_hiddedBottomLine(true)
        
        // 导航栏分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        self.navBar!.addSubview(viewLine)
        viewLine.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(self.navBar!)
            make.height.equalTo(0.5)
        })
        
        self.navBar!.addSubview(btnEdit)
        btnEdit.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.navBar!)
            make.right.equalTo(self.navBar!).offset(WH(-10))
            make.width.height.equalTo(WH(44))
        })
        
        // 需要返回时，显示返回btn
        if canBack {
            self.navBar!.addSubview(btnBack)
            btnBack.snp.makeConstraints({ (make) in
                make.bottom.equalTo(self.navBar!)
                make.left.equalTo(self.navBar!).offset(0)
                make.width.height.equalTo(WH(44))
            })
        }
    }
    
    // 内容视图
    func setupContentView() {
        // 底部margin
        var marginBottom: CGFloat = 0.0
        // 有返回按钮
        if (self.canBack) {
            // iPhoneX适配
            if #available(iOS 11, *) {
                let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
                if (insets?.bottom)! > CGFloat.init(0) {
                    // iPhone X
                    marginBottom = iPhoneX_SafeArea_BottomInset
                }
            }
        }
        
        // 底部填充视图
        if marginBottom > 0 {
            let viewTemp = UIView()
            viewTemp.backgroundColor = RGBColor(0xf3f3f3)
            view.addSubview(viewTemp)
            viewTemp.snp.makeConstraints({ (make) in
                make.bottom.left.right.equalTo(self.view)
                make.height.equalTo(marginBottom)
            })
        }
        
        view.addSubview(emptyView)
        view.addSubview(viewType)
        view.addSubview(tableView)
        view.addSubview(bottomView!)
        
        emptyView.isHidden = true
        emptyView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navBar!.snp.bottom).offset(WH(44))
            make.left.right.equalTo(self.view)
            //make.bottom.equalTo(self.view).offset(-marginBottom)
            make.bottom.equalTo(self.view)
        })
        
        viewType.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(WH(44))
        })
        
        tableView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navBar!.snp.bottom).offset(WH(44))
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-marginBottom)
        })
        
        bottomView!.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(WH(62))
            make.bottom.equalTo(self.view).offset(-marginBottom)
        })
        
        if hideTypeView {
            // 隐藏类型选择视图
            viewType.isHidden = true
            emptyView.snp.updateConstraints({ (make) in
                make.top.equalTo(self.navBar!.snp.bottom).offset(0)
            })
            tableView.snp.updateConstraints({ (make) in
                make.top.equalTo(self.navBar!.snp.bottom).offset(0)
            })
            view.layoutIfNeeded()
        }
    }
    
    
    //MARK: - Bind
    
    // 数据绑定
    func bindViewModel() -> () {
        _ = self.cartProvider.rx.observe(Bool.self, "selectedAll").subscribe(onNext: { [weak self] (selectAll) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.bottomView?.selectedAll = selectAll!
        })
        
        _ = self.cartProvider.rx.observe(Int.self, "selectedTypeCount").subscribe(onNext: { [weak self] goodsNum in
            guard let strongSelf = self else {
                return
            }
            strongSelf.bottomView?.selectedTypeCount = goodsNum!
        })
        
        _ = self.cartProvider.rx.observe(Double.self, "cartPaySum").subscribe(onNext: { [weak self] totalPrice in
            guard let strongSelf = self else {
                return
            }
            strongSelf.bottomView?.configBottomView(strongSelf.cartProvider.cartPaySum, strongSelf.cartProvider.discountAmount,strongSelf.cartProvider.canUseCouponPrice,strongSelf.cartProvider.selMerchantCount)
            //strongSelf.bottomView?.totalPrice = String(format: "%.2f", totalPrice!)
        })
        
        _ = self.cartProvider.rx.observe(Bool.self, "isEditing").subscribe(onNext: { [weak self] isEditing in
            guard let strongSelf = self else {
                return
            }
            if isEditing! {
                strongSelf.bottomView?.setRightBarTitle("删除")
                strongSelf.bottomView?.setBottonViewNormal()
                strongSelf.bottomView?.setIsShowPriceAndCount(false)
                strongSelf.btnEdit.setTitle("完成", for: UIControlState())
            }
            else {
                
                strongSelf.bottomView?.setRightBarTitle(String(format:"去结算(%d)",strongSelf.cartProvider.selectedTypeCount))
                strongSelf.bottomView?.configBottomView(strongSelf.cartProvider.cartPaySum, strongSelf.cartProvider.discountAmount,strongSelf.cartProvider.canUseCouponPrice,strongSelf.cartProvider.selMerchantCount)
                strongSelf.bottomView?.setIsShowPriceAndCount(true)
                strongSelf.btnEdit.setTitle("编辑", for: UIControlState())
            }
        })
        
        _ = self.cartProvider.rx.observe(Int.self, "sectionCount").subscribe(onNext: { [weak self] sectionCount in
            guard let strongSelf = self else {
                return
            }
            if sectionCount! <= 0 {
                // 显示空态视图
                strongSelf.view.bringSubviewToFront(strongSelf.emptyView)
                strongSelf.emptyView.isHidden = false
            }
            else {
                // 隐藏空态视图
                strongSelf.view.insertSubview(strongSelf.emptyView, belowSubview: strongSelf.tableView)
                strongSelf.emptyView.isHidden = true
            }
            strongSelf.btnEdit.isHidden = (sectionCount! <= 0)
        })
    }
    
    
    //MARK: - Request
    
    // 接口请求
    fileprivate func setupRequest() {
        //        requestAddressList()
        requestForCartData()
    }
    
    // 请求购物车数据
    fileprivate func requestForCartData() {
        // 先隐藏
        self.dismissLoading()
        
        // 未登录
        if FKYLoginAPI.loginStatus() == .unlogin {
            self.cartProvider.selectedAll = false
            self.cartProvider.totalPrice = 0
            self.cartProvider.goodsNum = 0
            self.cartProvider.isEditing = false
            self.cartProvider.sectionArray.removeAll()
            return
        }
        
        self.showLoading()
        var jsonParam = [String: Any]()
        jsonParam["fromwhere"] = 2
        //分享者ID
        if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
            jsonParam["shareUserId"] = cpsbd
        }
        // 请求购物车商品列表数据
        self.cartProvider.getYQGCartInfoList(withParameter: jsonParam as NSDictionary, handler: { [weak self] (success, message) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if success {
                strongSelf.tableView.reloadData()
            }
            else {
                strongSelf.toast(message)
            }
        })
    }
    
    
    //MARK: - Public
    
    // 分段控件索引固定为1
    @objc func resetTypeIndex() {
        self.viewType.setSelectedIndex(1)
    }
}


//MARK: - Private
extension YQGCartViewController {
    //提交部分商家信息订单
    fileprivate func submitPartMerchanetOrder(){
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            
            var  aryShoppinCartId:[String] = []
            let arr = strongSelf.cartProvider.sectionArray.filter({ (value) -> Bool in
                value.products = value.productGroupList!.filter({ (prod) -> Bool in
                    for item in prod.groupItemList! {
                        if item.checkStatus == true && item.productStatus == 0 {
                            return true
                        }
                    }
                    return false
                })
                if value.products.count > 0 && value.needAmount!.floatValue <= 0{
                    aryShoppinCartId.append(contentsOf: value.getSelectedProductShoppingIds())
                    
                }
                return value.needAmount!.floatValue <= 0 && value.products.count > 0
                
            })
            DispatchQueue.main.async(execute: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                if arr.count <= 0 {
                    // error...<按道理如果所有商家均无法结算，就不应该走到这里>
                    NSLog("无可结算商家");
                    return;
                }
                // 跳转到检查订单界面
                strongSelf.checkSubmitOrder()
            })
        }
    }
    // 结算校验
    fileprivate func toSettleAccounts() {
        if self.cartProvider.isAllProductUnSelected() {
            self.toast("您还没有选择商品哟")
            return
        }
        
        if self.cartProvider.isEditing {
            // 编辑状态下的删除操作
            FKYProductAlertView.show(withTitle: nil, leftTitle: "取消", rightTitle: "确定", message: "真的要删除选中的商品？", handler: { [weak self] (_, isRight) in
                guard let strongSelf = self else {
                    return
                }
                if isRight {
                    strongSelf.showLoading()
                    strongSelf.cartProvider.deleteSelectedShopCartSuccess(handler2:{ (success, msg) in
                        strongSelf.tableView.reloadData()
                        strongSelf.dismissLoading()
                        if success == false {
                            strongSelf.toast(msg.isEmpty ?  "删除失败，请重试":msg)
                        }
                        FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ (success) in
                        }, failure: { (reason) in
                        })
                    })
                }
            })
        }
        else {
            let (typeIndex,arr) = self.cartProvider.getNeedacountMerchantInfo()
            if typeIndex != 0 {
                self.exceptionDetailVC.configExceptionDetailViewController(typeIndex,arr,nil)
                return
            }
            self.checkSubmitOrder()
        }
    }
    
    // 结算
    fileprivate func checkSubmitOrder() {
        
        //        // 起批价校验
        //        // 用户选择的所有商品均未达对应卖家的起售门槛时
        //        if self.cartProvider.allStepPriceUnValid() {
        //            let alert = COAlertView.init(frame: CGRect.zero)
        //            alert.configView("你有部分商品金额低于供货商的起送门槛，此商品无法结算", "", "", "确定", .oneBtn)
        //            alert.showAlertView()
        //            alert.doneBtnActionBlock = {
        //            }
        //            return
        //        }
        // 入参
        var jsonParam = [String: Any]()
        jsonParam["shoppingcartid"] = self.cartProvider.getSelectedShoppingCartList()
        jsonParam["fromwhere"] = 2
        //分享者ID
        if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
            jsonParam["shareUserId"] = cpsbd
        }
        self.showLoading()
        self.cartProvider.checkCartSumbit(withParameter: jsonParam as NSDictionary, handler: { [weak self] (success, message) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if success {
                // 成功
                if strongSelf.cartProvider.changedArray.isEmpty == false {
                    strongSelf.exceptionDetailVC.configExceptionDetailViewController(3,strongSelf.cartProvider.changedArray,strongSelf.cartProvider.sectionArray)
                }
                else {
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I5000", itemPosition: "0", itemName:"去结算", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
                    FKYNavigator.shared().openScheme(FKY_CheckOrder.self, setProperty: { [weak self] (svc) in
                        guard let strongSelf = self else {
                            return
                        }
                        let controller = svc as! CheckOrderController
                        controller.productArray = strongSelf.cartProvider.getSelectedShoppingProductList()
                        controller.fromWhere = 2 // 一起购之购物车
                        }, isModal: false, animated: true)
                }
            }
            else {
                // 失败
                strongSelf.toast(message)
                strongSelf.requestForCartData()
            }
        })
    }
}


//MARK: - UITableViewDataSource & UITableViewDelegate
extension YQGCartViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.cartProvider.sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= self.cartProvider.sectionArray.count {
            return 0;
        }
        let model:CartMerchantInfoModel = self.cartProvider.sectionArray[section]
        if model.rowDataForShow.count > 0 && model.productGroupList!.count > 0 {
            return model.rowDataForShow.count
        }
        else {
            return 0;
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionModel:CartMerchantInfoModel = self.cartProvider.sectionArray[indexPath.section]
        let cellModel:BaseCartCellProtocol = sectionModel.rowDataForShow[indexPath.row]
        switch cellModel.cellType{
        case .CartCellTypeProduct:
            let cellData:CartCellProductProtocol = cellModel as! CartCellProductProtocol
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FKYShoppingCarProductTableViewCell", for: indexPath) as! FKYShoppingCarProductTableViewCell
            cell.cellModel = cellData
            cell.selectionStyle = .none
            let productModel:CartProdcutnfoModel = cellData.productModel!
            cell.clipsToBounds = true
            cell.stepper.updateProductBlock = { [weak self,weak cell] (count,typeIndex) in
                guard let strongSelf = self else {
                    return
                }
                if typeIndex == 2 || typeIndex == 3{
                    return
                }
                // 入参
                var jsonParam = [String: Any]()
                jsonParam["productNum"] = count
                jsonParam["shoppingCartId"] = productModel.shoppingCartId
                if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                    jsonParam["pushId"] = FKYPush.sharedInstance().pushID ?? ""
                }
                var contentArray:[Any] = []
                contentArray.append(jsonParam)
                var jsonInfo = [String: Any]()
                jsonInfo["itemList"] = contentArray
                jsonInfo["fromwhere"] = 2
                //分享者ID
                if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                    jsonInfo["shareUserId"] = cpsbd
                }
                // 更新购物车商品数量
                strongSelf.showLoading()
                strongSelf.cartProvider.getYQGCartuUpdateNum(withParameter: jsonInfo as NSDictionary, handler: {[weak self,weak cell] (success, message) in
                    guard let strongSelf = self else {
                        return
                    }
                    if success {
                        strongSelf.tableView.reloadData()
                        strongSelf.dismissLoading()
                    }
                    else {
                        strongSelf.dismissLoading()
                        strongSelf.toast((message.isEmpty) ? message : "操作失败，请重试")
                        cell?.stepper.resetStepperToLastCount()
                    }
                })
            }
            cell.stepper.toastBlock = { [weak self] (msg) in
                //加减空间toast
                if msg != nil && !(msg?.isEmpty)! {
                    self?.toast(msg)
                }
            }
            //商品状态改变
            cell.selectItemBlock = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                //商品选择状态改变
                if strongSelf.cartProvider.isEditing {
                    productModel.editStatus = productModel.editStatus == 1 ? 2 : 1;
                    
                    strongSelf.showLoading()
                    strongSelf.cartProvider.updateProductForEditing(sectionModel: sectionModel, handler: {[weak self] (success, message) in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.tableView.reloadData()
                        strongSelf.dismissLoading()
                    })
                }
                else {
                    var jsonParam = [String: Any]()
                    var contentArray:[Any] = []
                    contentArray.append(productModel.shoppingCartId as Any)
                    jsonParam["checkStatus"] = !((productModel.checkStatus)!)
                    jsonParam["shoppingCartIdList"] = contentArray
                    jsonParam["fromwhere"] = 2
                    //分享者ID
                    if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                        jsonParam["shareUserId"] = cpsbd
                    }
                    strongSelf.showLoading()
                    strongSelf.cartProvider.updateYQGCartGoodsSelectState(withParameter: jsonParam as NSDictionary, handler: {[weak self] (success, msg) in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.tableView.reloadData()
                        strongSelf.dismissLoading()
                    })
                }
            }
            return cell
        case .CartCellTypeSeparateSpace:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartSpaceCell", for: indexPath) as! CartSpaceCell
            cell.selectionStyle = .none
            cell.clipsToBounds = true
            return cell
        default:
            let cell = UITableViewCell.init()
            cell.selectionStyle = .none
            cell.clipsToBounds = true
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section >= self.cartProvider.sectionArray.count {
            return 0
        }
        let sectionModel:CartMerchantInfoModel = self.cartProvider.sectionArray[indexPath.section]
        if sectionModel.foldStatus == true{
            //关闭
            return 0
        }
        let cellModel:BaseCartCellProtocol = sectionModel.rowDataForShow[indexPath.row]
        switch cellModel.cellType{
        case .CartCellTypeProduct:
            let cellData:CartCellProductProtocol = cellModel as! CartCellProductProtocol
            return  FKYShoppingCarProductTableViewCell.getCellContentHeight(cellData.productModel!)
        case .CartCellTypeTaoCanPromotion://商品组尾部小计
            return FKYProductActivityGroupFooterCell.getCellHeight()
            
        case .CartCellTypeSeparateSpace:
            return WH(6)
        default:
            return 80.0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // cellHeightsDictionary[indexPath] = cell.frame.size.height
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat  {
        if indexPath.section >= self.cartProvider.sectionArray.count {
            return 0
        }
        let sectionModel:CartMerchantInfoModel = self.cartProvider.sectionArray[indexPath.section]
        if sectionModel.foldStatus == true{
            //关闭
            return 0
        }
        let cellModel:BaseCartCellProtocol = sectionModel.rowDataForShow[indexPath.row]
        switch cellModel.cellType{
        case .CartCellTypeProduct:
            let cellData:CartCellProductProtocol = cellModel as! CartCellProductProtocol
            return  FKYShoppingCarProductTableViewCell.getCellContentHeight(cellData.productModel!)
        case .CartCellTypeTaoCanPromotion://商品组尾部小计
            return FKYProductActivityGroupFooterCell.getCellHeight()
            
        case .CartCellTypeSeparateSpace:
            return WH(6)
        default:
            return 80.0
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return WH(73.0)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return  WH(35)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = FKYcarProductSectionHeader()
        let sectionModel = self.cartProvider.sectionArray[section];
        headerView.showData(data: sectionModel)
        //编辑状态不显示失效
        headerView.configSelectView(sectionModel,self.cartProvider.isEditing == true ? false: sectionModel.isectionProductUnValidForSection())
        headerView.configYQGCartvView()
        //商品折叠
        headerView.foldItemBlock = {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.sectionClick(section)
        }
        //        //去凑单后者商家名点击
        //        headerView.tappedNameBlock = { [weak self](model,clickType) in
        //            guard let strongSelf = self else {
        //                return
        //            }
        //            FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
        //                let controller = vc as! FKYNewShopItemViewController
        //                controller.shopId = "\(model.supplyId ?? 0)"
        //            }, isModal: false)
        //        }
        //商品勾选
        headerView.tappedStatusImageBlock = { [weak self](isSelect) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.cartProvider.isEditing {
                // 编辑中
                strongSelf.showLoading()
                strongSelf.cartProvider.updateSectionModelForEditing(sectionModel: sectionModel, handler: {[weak self] (success,msg) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.tableView.reloadData()
                    strongSelf.dismissLoading()
                })
            }
            else {
                // 非编辑状态
                var jsonParam = [String: Any]()
                var contentArray:[Any] = []
                jsonParam["checkStatus"] = !(sectionModel.checkedAll ?? false)
                if sectionModel.productGroupList != nil{
                    for object in sectionModel.productGroupList!{
                        if object.groupItemList != nil{
                            for item in object.groupItemList!{
                                if item.checkStatus == sectionModel.checkedAll{
                                    contentArray.append(item.shoppingCartId as Any)
                                }
                            }
                        }
                        
                    }
                }
                
                jsonParam["shoppingCartIdList"] = contentArray
                jsonParam["fromwhere"] = 2
                //分享者ID
                if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                    jsonParam["shareUserId"] = cpsbd
                }
                //
                strongSelf.showLoading()
                strongSelf.cartProvider.updateYQGCartGoodsSelectState(withParameter: jsonParam as NSDictionary, handler: {[weak self] (success,msg) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.tableView.reloadData()
                    strongSelf.dismissLoading()
                    if msg.isEmpty {
                        strongSelf.toast(msg)
                    }
                })
            }
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(73.0)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return FKYcarProductSectionFooter.getFooterHeight()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = FKYcarProductSectionFooter()
        let sectionModel = self.cartProvider.sectionArray[section];
        footerView.footerModel = sectionModel
        //        let view = UIView.init(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height:WH(15)))
        //        view.backgroundColor = RGBColor(0xf3f3f3)
        return footerView
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section >= self.cartProvider.sectionArray.count {
            return false
        }
        
        let sectionModel = self.cartProvider.sectionArray[indexPath.section];
        if indexPath.row >= sectionModel.rowDataForShow.count{
            return false
        }
        
        let cellData :BaseCartCellProtocol = sectionModel.rowDataForShow[indexPath.row]
        switch cellData.cellType{
        case .CartCellTypeBase:
            return false
        case .CartCellTypeFixTaoCanName:
            return false
        case .CartCellTypeTaoCanName:
            return false
        case .CartCellTypePromotion:
            return false
        case .CartCellTypeSeparateSpace:
            return false
        case .CartCellTypeTaoCanPromotion :
            return false
        case .CartCellTypeProduct:
            let cellDatatype :CartCellProductProtocol = (sectionModel.rowDataForShow[indexPath.row]) as! CartCellProductProtocol
            let type =  cellDatatype.productType
            if type == .CartCellProductTypeNormal || type == .CartCellProductTypePromotion {
                return true
            }else{
                return false
            }
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section >= self.cartProvider.sectionArray.count {
                return
            }
            
            let sectionModel = self.cartProvider.sectionArray[indexPath.section]
            if indexPath.row >= sectionModel.rowDataForShow.count {
                return
            }
            
            let cellData :BaseCartCellProtocol = sectionModel.rowDataForShow[indexPath.row]
            switch cellData.cellType {
            case .CartCellTypeProduct:
                let cellDatatype :CartCellProductProtocol = (sectionModel.rowDataForShow[indexPath.row]) as! CartCellProductProtocol
                let type =  cellDatatype.productType
                if type == .CartCellProductTypeFixTaoCan || type == .CartCellProductTypeTaoCan {
                    //不可删除套餐
                    return
                }
                
                FKYProductAlertView.show(withTitle: nil, leftTitle: "取消", rightTitle: "确定", message: "真的要删除选中的商品？", handler: { [weak self] (_, isRight) in
                    guard let strongSelf = self else {
                        return
                    }
                    if isRight {
                        // 入参
                        let product = cellDatatype.productModel
                        var contentArray: [Any] = []
                        contentArray.append(product?.shoppingCartId as Any)
                        var jsonParam = [String: Any]()
                        jsonParam["shoppingcartid"] = contentArray
                        jsonParam["fromwhere"] = 2
                        //分享者ID
                        if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                            jsonParam["shareUserId"] = cpsbd
                        }
                        // 删除
                        strongSelf.showLoading()
                        strongSelf.cartProvider.deleteYQGCartGoods(withParameter: jsonParam as NSDictionary, handler: { [weak self] (success,msg) in
                            guard let strongSelf = self else {
                                return
                            }
                            strongSelf.tableView.reloadData()
                            strongSelf.dismissLoading()
                            if success == false {
                                strongSelf.toast(msg.isEmpty ? "删除失败，请重试" : msg)
                            }
                            FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ (success) in
                            }, failure: { (reason) in
                            })
                        })
                    }
                })
                break
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt  indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section >= self.cartProvider.sectionArray.count {
            return
        }
        
        let sectionModel = self.cartProvider.sectionArray[indexPath.section];
        if indexPath.row >= sectionModel.rowDataForShow.count{
            return
        }
        
        let cellData :BaseCartCellProtocol = sectionModel.rowDataForShow[indexPath.row]
        switch cellData.cellType {
        case .CartCellTypeProduct:
            //跳到商详
            let cellDatatype :CartCellProductProtocol = (sectionModel.rowDataForShow[indexPath.row]) as! CartCellProductProtocol
            if let model = cellDatatype.productModel{
                FKYNavigator.shared().openScheme(FKY_Togeter_Detail_Buy.self, setProperty: { (vc) in
                    let v = vc as! FKYTogeterBuyDetailViewController
                    v.typeIndex = "1"
                    if let productId = model.promotionId {
                        v.productId = productId.stringValue
                    }
                })
            }
            break
        default:
            break
        }
    }
    //section 展开折叠操作
    func sectionClick(_ section:Int){
        if section >= self.cartProvider.sectionArray.count {
            return
        }
        let sectionModel = self.cartProvider.sectionArray[section];
        sectionModel.foldStatus = !sectionModel.foldStatus
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                if sectionModel.foldStatus == false{
                    //展开
                    strongSelf.cartProvider.deleteFoldSection(sectionModel.supplyId ?? 0)
                    strongSelf.tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: UITableView.RowAnimation.automatic)
                }else{
                    //关闭
                    strongSelf.cartProvider.addFoldSection(sectionModel.supplyId ?? 0)
                    strongSelf.tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: UITableView.RowAnimation.automatic)
                }
                
            }
        }
    }
    
}
