//
//  CartViewController.swift
//  FKY
//
//  Created by 寒山 on 2019/12/2.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class  CartViewController: UIViewController {
    //MARK: - Property
    var cellHeightsDictionary =  [IndexPath:CGFloat]()
    // closure
    @objc var switchBlock: (()->())? // 切换购物车
    
    // 默认不可返回
    @objc var canBack: Bool = false
    
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
    
    // 编辑btn
    fileprivate lazy var btnEdit: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.titleLabel?.font = FKYSystemFont(WH(16))
        btn.setTitleColor(RGBColor(0x333333), for: UIControl.State())
        btn.setTitle("编辑", for: UIControl.State())
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self,weak btn] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.showLoading()
            strongSelf.cartProvider.isEditing = !(strongSelf.cartProvider.isEditing)
            if strongSelf.cartProvider.isEditing {
                btn?.setTitle("完成", for: UIControl.State())
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "批量编辑商品", itemId: "I5001", itemPosition: "1", itemName:"编辑", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            }
            else {
                btn?.setTitle("编辑", for: UIControl.State())
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
        view.setSelectedIndex(0)
        view.selectBlock = { [weak self] (index) in
            guard let strongSelf = self else {
                return
            }
            if index == 0 {
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
                let selectAll = strongSelf.cartProvider.isAllProductSelectedForEdit()
                if  selectAll == false{
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "批量编辑商品", itemId: "I5001", itemPosition: "2", itemName:"全选商品", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
                }
                strongSelf.cartProvider.setSelectAllProductForEdit(selectAll: !(selectAll) , handler: { (success, msg) in
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
                if  isAllSelected == false{
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I5005", itemPosition: "1", itemName:"全选商品", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
                }
                jsonParam["checkStatus"] = !isAllSelected
                jsonParam["shoppingCartIdList"] = contentArray
                if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                    jsonParam["shareUserId"] = cpsbd
                }
                strongSelf.cartProvider.updateCartGoodsSelectState(withParameter: jsonParam as NSDictionary, handler: { [weak self] (success, msg) in
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
            strongSelf.preferentialDetailVC.showOrHideCouponPopView(false)
            view?.setArrowDirType(.BottomArrowDir_Up)
            strongSelf.toSettleAccounts()
        }
        //查看优惠详细
        view.checkDetailPromotionBlock = { [weak self,weak view] in
            guard let strongSelf = self else {
                return
            }
            if view?.arrowDirType == .BottomArrowDir_Down{
                strongSelf.preferentialDetailVC.showOrHideCouponPopView(false)
                view?.setArrowDirType(.BottomArrowDir_Up)
            }else{
                view?.setArrowDirType(.BottomArrowDir_Down)
                strongSelf.preferentialDetailVC.configPreferentialViewController(strongSelf.cartProvider.preferetialArr)
            }
            
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I5005", itemPosition: "2", itemName:"查看明细", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            
        }
        return view
    }()
    
    // 空态视图
    fileprivate lazy var emptyView: FKYStaticView = {
        let view = FKYStaticView()
        // 跳转首页
        view.actionBlock = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            FKYNavigator.shared().openScheme(FKY_TabBarController.self) {[weak self] (vc) in
                guard let strongSelf = self else {
                    return
                }
                if let v = vc as? FKYTabBarController{
                    v.index = 0
                }
                
            }
        }
        return view
    }()
    //视图容器
    fileprivate lazy var viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    //优惠券弹框
    fileprivate lazy var couponVC : FKYPopComCouponVC = {
        let vc = FKYPopComCouponVC()
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
    
    //viewModel
    fileprivate lazy var cartProvider: CartServiceProvider = {
        return CartServiceProvider()
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
        print(" CartViewController deinit~!@")
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
        view.addSubview(self.viewContent)
        
        emptyView.isHidden = true
        
        self.viewContent.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navBar!.snp.bottom).offset(WH(44))
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        })
        
        emptyView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.viewContent.snp.top)
            make.left.right.equalTo(self.view)
            //make.bottom.equalTo(self.view).offset(-marginBottom)
            make.bottom.equalTo(self.view)
        })
        
        viewType.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(WH(44))
        })
        
        self.viewContent.addSubview(tableView)
        self.viewContent.addSubview(bottomView!)
        
        tableView.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(self.viewContent);
            make.bottom.equalTo(self.view).offset(-marginBottom)
        })
        
        bottomView!.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.viewContent)
            make.height.equalTo(WH(62))
            make.bottom.equalTo(self.viewContent).offset(-marginBottom)
        })
        
        // 优先显示内容视图
        self.view.bringSubviewToFront(self.viewContent)
        self.view.bringSubviewToFront(self.viewType)
    }
    
    
    //MARK: - Bind
    
    // 数据绑定
    func bindViewModel() -> () {
        //是否全选
        _ = self.cartProvider.rx.observeWeakly(Bool.self, "selectedAll").subscribe(onNext: { [weak self] (selectAll) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.bottomView?.selectedAll = selectAll!
        })
        //商品种类
        _ = self.cartProvider.rx.observeWeakly(Int.self, "selectedTypeCount").subscribe(onNext: { [weak self] goodsNum in
            guard let strongSelf = self else {
                return
            }
            strongSelf.bottomView?.selectedTypeCount = goodsNum!
        })
        //应付金额
        _ = self.cartProvider.rx.observeWeakly(Double.self, "cartPaySum").subscribe(onNext: { [weak self] totalPrice in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.bottomView?.configBottomView(strongSelf.cartProvider.cartPaySum, strongSelf.cartProvider.discountAmount,strongSelf.cartProvider.canUseCouponPrice,strongSelf.cartProvider.selMerchantCount)
        })
        //编辑状态
        _ = self.cartProvider.rx.observeWeakly(Bool.self, "isEditing").subscribe(onNext: { [weak self] isEditing in
            guard let strongSelf = self else {
                return
            }
            if isEditing! {
                strongSelf.bottomView?.setRightBarTitle("删除")
                strongSelf.bottomView?.setBottonViewNormal()
                strongSelf.bottomView?.setIsShowPriceAndCount(false)
                strongSelf.btnEdit.setTitle("完成", for: UIControl.State())
            }
            else {
                strongSelf.bottomView?.setRightBarTitle(String(format:"去结算(%d)",strongSelf.cartProvider.selectedTypeCount))
                strongSelf.bottomView?.setIsShowPriceAndCount(true)
                strongSelf.bottomView?.configBottomView(strongSelf.cartProvider.cartPaySum, strongSelf.cartProvider.discountAmount,strongSelf.cartProvider.canUseCouponPrice,strongSelf.cartProvider.selMerchantCount)
                strongSelf.btnEdit.setTitle("编辑", for: UIControl.State())
            }
        })
        //商家数量
        _ = self.cartProvider.rx.observeWeakly(Int.self, "sectionCount").subscribe(onNext: { [weak self] sectionCount in
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
            self.cartProvider.cartPaySum = 0
            self.cartProvider.selectedTypeCount = 0
            self.cartProvider.isEditing = false
            self.cartProvider.sectionArray.removeAll()
            self.cartProvider.sectionCount = 0
            return
        }
        
        self.showLoading()
        // 请求购物车商品列表数据
        self.cartProvider.getCartInfoList(block: { [weak self] (success, message) in
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
        self.viewType.setSelectedIndex(0)
    }
    // 显示or隐藏顶部类型切换视图
    @objc func showTypeView(_ showFlag:Bool) {
        if showFlag == true{
            self.viewType.isHidden = false
            self.viewContent.snp.updateConstraints({ (make) in
                make.top.equalTo(self.navBar!.snp.bottom).offset(WH(44))
            })
        }else{
            self.viewType.isHidden = true
            self.viewContent.snp.updateConstraints({ (make) in
                make.top.equalTo(self.navBar!.snp.bottom).offset(WH(0))
            })
        }
    }
    @objc func resetForUnLogin() {
        if FKYLoginAPI.loginStatus() == .unlogin {
            self.cartProvider.selectedAll = false
            self.cartProvider.cartPaySum = 0
            self.cartProvider.selectedTotalPrice = 0
            self.cartProvider.discountAmount = 0
            self.cartProvider.selectedTypeCount = 0
            self.cartProvider.selectedTotalRebate = 0
            self.cartProvider.isEditing = false
            self.cartProvider.sectionArray.removeAll()
            self.cartProvider.sectionCount = 0
        }
    }
}
//MARK: - UITableViewDataSource & UITableViewDelegate
extension  CartViewController: UITableViewDataSource, UITableViewDelegate {
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
        if indexPath.section < self.cartProvider.sectionArray.count{
            let sectionModel:CartMerchantInfoModel = self.cartProvider.sectionArray[indexPath.section]
            let cellModel:BaseCartCellProtocol = sectionModel.rowDataForShow[indexPath.row]
            if sectionModel.foldStatus == false{
                //展开
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
                        var contentArray:[Any] = []
                        contentArray.append(jsonParam)
                        var jsonInfo = [String: Any]()
                        jsonInfo["itemList"] = contentArray
                        if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                            jsonInfo["shareUserId"] = cpsbd
                        }
                        // 更新购物车商品数量
                        strongSelf.showLoading()
                        strongSelf.addCartActionBIRecord(indexPath.section,sectionModel.supplyName ?? "",productModel,cellData.productType ?? .CartCellProductTypeNormal)
                        strongSelf.cartProvider.getCartuUpdateNum(withParameter: jsonInfo as NSDictionary, handler: {[weak self,weak cell] (success, message) in
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
                            if (productModel.checkStatus)! == false{
                                strongSelf.checkProductActionBIRecord(indexPath.section,sectionModel.supplyName ?? "",productModel,cellData.productType ?? .CartCellProductTypeNormal)
                            }
                            jsonParam["checkStatus"] = !((productModel.checkStatus)!)
                            jsonParam["shoppingCartIdList"] = contentArray
                            if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                                jsonParam["shareUserId"] = cpsbd
                            }
                            strongSelf.showLoading()
                            strongSelf.cartProvider.updateCartGoodsSelectState(withParameter: jsonParam as NSDictionary, handler: {[weak self] (success, msg) in
                                guard let strongSelf = self else {
                                    return
                                }
                                strongSelf.tableView.reloadData()
                                strongSelf.dismissLoading()
                            })
                        }
                    }
                    return cell
                    
                case .CartCellTypePromotion,.CartCellTypeFixTaoCanName,.CartCellTypeTaoCanName://优惠信息
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FKYProductActivityCell", for: indexPath) as! FKYProductActivityCell
                    cell.selectionStyle = .none
                    cell.clipsToBounds = true
                    cell.showData(cellModel: cellModel)
                    cell.stepper.updateProductBlock = { [weak self,weak cell] (count,typeIndex) in
                        guard let strongSelf = self else {
                            return
                        }
                        if typeIndex == 2 || typeIndex == 3{
                            return
                        }
                        FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(indexPath.section + 1)", floorName: sectionModel.supplyName ?? "", sectionId: "S5001", sectionPosition: "3", sectionName: "套餐活动",  itemId: "I9999", itemPosition: "0", itemName:"加车", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: strongSelf)
                        // 入参
                        if cellModel.cellType == .CartCellTypeFixTaoCanName{
                            let cellData:CartCellFixTaoCanProtocol = cellModel as! CartCellFixTaoCanProtocol
                            var jsonParam = strongSelf.cartProvider.getFixedComboRequestParams(cellData.modelInfo!,count)
                            //分享者ID
                            if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                                jsonParam["shareUserId"] = cpsbd
                            }
                            // 更新购物车商品数量
                            strongSelf.showLoading()
                            strongSelf.cartProvider.getCartuUpdateNum(withParameter: jsonParam as NSDictionary, handler: {[weak self,weak cell] (success, message) in
                                guard let strongSelf = self else {
                                    return
                                }
                                if success {
                                    strongSelf.tableView.reloadData()
                                    strongSelf.dismissLoading()
                                }
                                else {
                                    strongSelf.dismissLoading()
                                    strongSelf.toast((message.isEmpty) ? message : "更新套餐数量失败")
                                    cell?.stepper.resetStepperToLastCount()
                                    strongSelf.requestForCartData()
                                }
                            })
                        }
                        
                        
                        
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
                        
                        if strongSelf.cartProvider.isEditing == true{
                            if cellModel.cellType == .CartCellTypeFixTaoCanName{
                                let cellData:CartCellFixTaoCanProtocol = cellModel as! CartCellFixTaoCanProtocol
                                let infoModel = cellData.modelInfo!
                                // 固定套餐...<看作一个整体商品>
                                infoModel.editStatus = infoModel.editStatus == 1 ? 2 : 1;
                                for item in infoModel.groupItemList! {
                                    item.editStatus = item.editStatus == 1 ? 2 : 1
                                }
                            }else if cellModel.cellType == .CartCellTypeTaoCanName{
                                let cellData: CartCellTaoCanProtocol = cellModel as!  CartCellTaoCanProtocol
                                let infoModel = cellData.modelInfo!
                                infoModel.editStatus = infoModel.editStatus == 1 ? 2 : 1;
                                for item in infoModel.groupItemList! {
                                    item.editStatus = item.editStatus == 1 ? 2 : 1
                                }
                            }
                            strongSelf.cartProvider.updateProductForEditing(sectionModel: sectionModel, handler: {[weak self] (success, message) in
                                guard let strongSelf = self else {
                                    return
                                }
                                strongSelf.tableView.reloadData()
                                strongSelf.dismissLoading()
                            })
                        }else{
                            var jsonParam = [String: Any]()
                            var contentArray:[Any] = []
                            var comboInfoModel = ProductGroupListInfoModel()
                            if cellModel.cellType == .CartCellTypeFixTaoCanName{
                                let cellData:CartCellFixTaoCanProtocol = cellModel as! CartCellFixTaoCanProtocol
                                comboInfoModel = cellData.modelInfo!
                            }else if cellModel.cellType == .CartCellTypeTaoCanName{
                                let cellData: CartCellTaoCanProtocol = cellModel as!  CartCellTaoCanProtocol
                                comboInfoModel = cellData.modelInfo!
                            }
                            for item in comboInfoModel.groupItemList!{
                                jsonParam["checkStatus"] = !(item.checkStatus ?? true)
                                contentArray.append(item.shoppingCartId as Any)
                            }
                            jsonParam["shoppingCartIdList"] = contentArray
                            if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                                jsonParam["shareUserId"] = cpsbd
                            }
                            FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(indexPath.section + 1)", floorName: sectionModel.supplyName ?? "", sectionId: "S5001", sectionPosition: "3", sectionName: "勾选商品",  itemId: "I5004", itemPosition: "1", itemName:"加车", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: strongSelf)
                            
                            strongSelf.showLoading()
                            strongSelf.cartProvider.updateCartGoodsSelectState(withParameter: jsonParam as NSDictionary, handler: {[weak self] (success, msg) in
                                guard let strongSelf = self else {
                                    return
                                }
                                strongSelf.tableView.reloadData()
                                strongSelf.dismissLoading()
                            })
                        }
                    }
                    return cell
                    
                case .CartCellTypeTaoCanPromotion://商品组尾部小计
                    let cellData:CartCellTaocanPromationInfoProtocol = cellModel as! CartCellTaocanPromationInfoProtocol
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FKYProductActivityGroupFooterCell", for: indexPath) as! FKYProductActivityGroupFooterCell
                    cell.selectionStyle = .none
                    cell.clipsToBounds = true
                    cell.showData(cellData: cellData)
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
        }
        
        let cell = UITableViewCell.init()
        cell.selectionStyle = .none
        cell.clipsToBounds = true
        return cell
        
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
            
        case .CartCellTypePromotion,.CartCellTypeFixTaoCanName,.CartCellTypeTaoCanName://优惠信息
            let height = FKYProductActivityCell.getCellHeight(cellModel)
            return height
            
        case .CartCellTypeTaoCanPromotion://商品组尾部小计
            return FKYProductActivityGroupFooterCell.getCellHeight()
            
        case .CartCellTypeSeparateSpace:
            return WH(6)
        default:
            return 80.0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cellHeightsDictionary[indexPath] = cell.frame.size.height
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
            
        case .CartCellTypePromotion,.CartCellTypeFixTaoCanName,.CartCellTypeTaoCanName://优惠信息
            let height = FKYProductActivityCell.getCellHeight(cellModel)
            return height
            
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
        //商品折叠
        headerView.foldItemBlock = {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.addMerchantHeadBIRecord(5,section,sectionModel.supplyName ?? "")
            strongSelf.sectionClick(section)
        }
        //优惠券点击
        headerView.tappedCouponBlock = { [weak self](model) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.addMerchantHeadBIRecord(3,section,sectionModel.supplyName ?? "")
            // 弹出优惠券面板
            strongSelf.couponVC.shopNameStr = sectionModel.supplyName ?? ""
            strongSelf.couponVC.shopSectionIndex = section+1
            strongSelf.couponVC.configCouponViewController("\(sectionModel.supplyId ?? 0)", spuCode: nil)
        }
        //去凑单后者商家名点击
        headerView.tappedNameBlock = { [weak self](model,clickType) in
            guard let strongSelf = self else {
                return
            }
            if clickType == CartSupplyNameClickType{
                strongSelf.addMerchantHeadBIRecord(2,section,sectionModel.supplyName ?? "")
            }else{
                strongSelf.addMerchantHeadBIRecord(4,section,sectionModel.supplyName ?? "")
            }
            
            FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                let controller = vc as! FKYNewShopItemViewController
                controller.shopId = "\(model.supplyId ?? 0)"
            }, isModal: false)
        }
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
                if (sectionModel.checkedAll ?? false) == false{
                    strongSelf.addMerchantHeadBIRecord(1,section,sectionModel.supplyName ?? "")
                }
                
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
                if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                    jsonParam["shareUserId"] = cpsbd
                }
                //
                strongSelf.showLoading()
                strongSelf.cartProvider.updateCartGoodsSelectState(withParameter: jsonParam as NSDictionary, handler: {[weak self] (success,msg) in
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
                        jsonParam["deleteType"] = "0"
                        if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                            jsonParam["shareUserId"] = cpsbd
                        }
                        // 删除
                        strongSelf.showLoading()
                        strongSelf.deleteProductActionBIRecord(indexPath.section,sectionModel.supplyName ?? "",product!,type!)
                        strongSelf.cartProvider.deleteCartGoods(withParameter: jsonParam as NSDictionary, handler: { [weak self] (success,msg) in
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
        //展开关闭
        if sectionModel.foldStatus == true{
            return
        }
        let cellData :BaseCartCellProtocol = sectionModel.rowDataForShow[indexPath.row]
        switch cellData.cellType {
        case .CartCellTypeProduct:
            //跳到商详
            let cellDatatype :CartCellProductProtocol = (sectionModel.rowDataForShow[indexPath.row]) as! CartCellProductProtocol
            let model = cellDatatype.productModel
            self.itemDetailActionBIRecord(indexPath.section,sectionModel.supplyName ?? "",model!,cellDatatype.productType ?? .CartCellProductTypeNormal)
            FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                let v = vc as! FKY_ProdutionDetail
                v.productionId = model!.spuCode
                v.vendorId = "\(model!.supplyId ?? 0)"
            }, isModal: false)
            break
        case .CartCellTypePromotion:
            //跳到促销专区页面
            let cellDatatype :CartCellPromotionInfoProtocol = (sectionModel.rowDataForShow[indexPath.row]) as! CartCellPromotionInfoProtocol
            if let promotionModel = cellDatatype.promationInfoModel{
                if promotionModel.type == 15{
                    //单品满折不跳
                    return
                }
                self.enterPromotionShop(indexPath.section,sectionModel.supplyName ?? "",cellDatatype.promotionType!)
                FKYNavigator.shared().openScheme(FKY_ShopItemOld.self) { (vc) in
                    let shopVC = vc as! ShopItemOldViewController
                    if cellDatatype.promotionType == .CartPromotionTypeMZ{
                        //满折
                        shopVC.type = 5
                        //shopVC.promotionModel = promotionModel
                    }else if cellDatatype.promotionType == .CartPromotionTypeMJ{
                        //满减
                        shopVC.type = 2
                        //shopVC.promotionModel = promotionModel
                    }
                    shopVC.promotionId = cellDatatype.promotionId
                    shopVC.shopId = cellDatatype.supplyId
                }
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
        
        if sectionModel.foldStatus == false{
            //展开
            self.cartProvider.deleteFoldSection(sectionModel.supplyId ?? 0)
            self.tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: UITableView.RowAnimation.automatic)
        }else{
            //关闭
            self.cartProvider.addFoldSection(sectionModel.supplyId ?? 0)
            self.tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: UITableView.RowAnimation.automatic)
        }
    }
}
//MARK: - Private
extension  CartViewController {
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
                        }else{
                            FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ (success) in
                            }, failure: { (reason) in
                            })
                            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "批量编辑商品", itemId: "I5001", itemPosition: "3", itemName:"删除", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
                        }
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
    // 结算
    fileprivate func checkSubmitOrder() {
        
        // 入参
        var jsonParam = [String: Any]()
        jsonParam["shoppingcartid"] = self.cartProvider.getSelectedShoppingCartList()
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
                        controller.fromWhere = 0 // 购物车
                        controller.shoppingCartIds = strongSelf.cartProvider.getSelectedShoppingProductList()
                        
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
//MARK: - 埋点
extension  CartViewController {
    //头部事件
    func addMerchantHeadBIRecord(_ recodrdType:Int,_ sectionIndex:Int,_ sectionName:String){
        if recodrdType == 1{
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(sectionIndex + 1)", floorName: sectionName, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I5002", itemPosition: "1", itemName:"全选商家全部商品", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        }else if recodrdType == 2{
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(sectionIndex + 1)", floorName: sectionName, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I5002", itemPosition: "2", itemName:"点进商家首页", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        }else if recodrdType == 3{
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(sectionIndex + 1)", floorName: sectionName, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I5002", itemPosition: "3", itemName:"优惠券", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        }else if recodrdType == 4{
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(sectionIndex + 1)", floorName: sectionName, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I5002", itemPosition: "4", itemName:"去凑单", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        }else if recodrdType == 5{
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(sectionIndex + 1)", floorName: sectionName, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I5002", itemPosition: "5", itemName:"收起/展开", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        }
    }
    //加车
    func addCartActionBIRecord(_ merchantIndex:Int,_ merchantName:String,_ productModel:CartProdcutnfoModel,_ productType:CartCellProductType){
        let itemContent = "\(productModel.supplyId ?? 0)|\(productModel.spuCode ?? "0")"
        if productType == .CartCellProductTypePromotion {
            //促销
            if let _ = productModel.promotionManzhe{
                //满折
                let extendParams:[String :AnyObject] = ["storage" : productModel.storage! as AnyObject,"pm_price" : productModel.pm_price! as AnyObject,"pm_pmtn_type" : productModel.pm_pmtn_type! as AnyObject]
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(merchantIndex + 1)", floorName: merchantName, sectionId: "S5001", sectionPosition: "2", sectionName: "满折活动",  itemId: "I9999", itemPosition: "0", itemName:"加车", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
            }else if let _ = productModel.promotionMJ{
                //满减
                let extendParams:[String :AnyObject] = ["storage" : productModel.storage! as AnyObject,"pm_price" : productModel.pm_price! as AnyObject,"pm_pmtn_type" : productModel.pm_pmtn_type! as AnyObject]
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(merchantIndex + 1)", floorName: merchantName, sectionId: "S5001", sectionPosition: "1", sectionName: "满减活动",  itemId: "I9999", itemPosition: "0", itemName:"加车", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
            }
        }else if productType == .CartCellProductTypeNormal{
            //普通
            let extendParams:[String :AnyObject] = ["storage" : productModel.storage! as AnyObject,"pm_price" : productModel.pm_price! as AnyObject,"pm_pmtn_type" : productModel.pm_pmtn_type! as AnyObject]
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(merchantIndex + 1)", floorName: merchantName, sectionId: nil, sectionPosition: nil, sectionName: "普通商品", itemId: "I9999", itemPosition: "0", itemName:"加车", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
        }
    }
    //删除商品
    func deleteProductActionBIRecord(_ merchantIndex:Int,_ merchantName:String,_ productModel:CartProdcutnfoModel,_ productType:CartCellProductType){
        let itemContent = "\(productModel.supplyId ?? 0)|\(productModel.spuCode ?? "0")"
        if productType == .CartCellProductTypePromotion {
            //促销
            if let _ = productModel.promotionManzhe{
                //满折
                let extendParams:[String :AnyObject] = ["storage" : productModel.storage! as AnyObject,"pm_price" : productModel.pm_price! as AnyObject,"pm_pmtn_type" : productModel.pm_pmtn_type! as AnyObject]
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(merchantIndex + 1)", floorName: merchantName, sectionId: "S5001", sectionPosition: "2", sectionName: "满折活动", itemId: "I5004", itemPosition: "3", itemName:"删除商品", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
            }else if let _ = productModel.promotionMJ{
                //满减
                let extendParams:[String :AnyObject] = ["storage" : productModel.storage! as AnyObject,"pm_price" : productModel.pm_price! as AnyObject,"pm_pmtn_type" : productModel.pm_pmtn_type! as AnyObject]
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(merchantIndex + 1)", floorName: merchantName, sectionId: "S5001", sectionPosition: "1", sectionName: "满减活动", itemId: "I5004", itemPosition: "3", itemName:"删除商品", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
            }
        }else if productType == .CartCellProductTypeNormal{
            //普通
            let extendParams:[String :AnyObject] = ["storage" : productModel.storage! as AnyObject,"pm_price" : productModel.pm_price! as AnyObject,"pm_pmtn_type" : productModel.pm_pmtn_type! as AnyObject]
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(merchantIndex + 1)", floorName: merchantName, sectionId: nil, sectionPosition: nil, sectionName: "普通商品", itemId: "I5004", itemPosition: "3", itemName:"删除商品", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
        }
    }
    //进入商详
    func itemDetailActionBIRecord(_ merchantIndex:Int,_ merchantName:String,_ productModel:CartProdcutnfoModel,_ productType:CartCellProductType){
        let itemContent = "\(productModel.supplyId ?? 0)|\(productModel.spuCode ?? "0")"
        if productType == .CartCellProductTypePromotion {
            //促销
            if let _ = productModel.promotionManzhe{
                //满折
                let extendParams:[String :AnyObject] = ["storage" : productModel.storage! as AnyObject,"pm_price" : productModel.pm_price! as AnyObject,"pm_pmtn_type" : productModel.pm_pmtn_type! as AnyObject]
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(merchantIndex + 1)", floorName: merchantName, sectionId: "S5001", sectionPosition: "2", sectionName: "满折活动", itemId: "I5004", itemPosition: "2", itemName:"点进商详", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
            }else if let _ = productModel.promotionMJ{
                //满减
                let extendParams:[String :AnyObject] = ["storage" : productModel.storage! as AnyObject,"pm_price" : productModel.pm_price! as AnyObject,"pm_pmtn_type" : productModel.pm_pmtn_type! as AnyObject]
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(merchantIndex + 1)", floorName: merchantName, sectionId: "S5001", sectionPosition: "1", sectionName: "满减活动", itemId: "I5004", itemPosition: "2", itemName:"点进商详", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
            }
        }else if productType == .CartCellProductTypeTaoCan{
            //套餐
            let extendParams:[String :AnyObject] = ["storage" : productModel.storage! as AnyObject,"pm_price" : productModel.pm_price! as AnyObject,"pm_pmtn_type" : productModel.pm_pmtn_type! as AnyObject]
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(merchantIndex + 1)", floorName: merchantName, sectionId: "S5001", sectionPosition: "3", sectionName: "套餐活动", itemId: "I5004", itemPosition: "2", itemName:"点进商详", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
        }else if productType == .CartCellProductTypeNormal{
            //普通
            let extendParams:[String :AnyObject] = ["storage" : productModel.storage! as AnyObject,"pm_price" : productModel.pm_price! as AnyObject,"pm_pmtn_type" : productModel.pm_pmtn_type! as AnyObject]
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(merchantIndex + 1)", floorName: merchantName, sectionId: nil, sectionPosition: nil, sectionName: "普通商品", itemId: "I5004", itemPosition: "2", itemName:"点进商详", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
        }
    }
    //勾选商品
    func checkProductActionBIRecord(_ merchantIndex:Int,_ merchantName:String,_ productModel:CartProdcutnfoModel,_ productType:CartCellProductType){
        let itemContent = "\(productModel.supplyId ?? 0)|\(productModel.spuCode ?? "0")"
        if productType == .CartCellProductTypePromotion {
            //促销
            if let _ = productModel.promotionManzhe{
                //满折
                let extendParams:[String :AnyObject] = ["storage" : productModel.storage! as AnyObject,"pm_price" : productModel.pm_price! as AnyObject,"pm_pmtn_type" : productModel.pm_pmtn_type! as AnyObject]
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(merchantIndex + 1)", floorName: merchantName, sectionId: "S5001", sectionPosition: "2", sectionName: "满折活动", itemId: "I5004", itemPosition: "1", itemName:"勾选商品", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
            }else if let _ = productModel.promotionMJ{
                //满减
                let extendParams:[String :AnyObject] = ["storage" : productModel.storage! as AnyObject,"pm_price" : productModel.pm_price! as AnyObject,"pm_pmtn_type" : productModel.pm_pmtn_type! as AnyObject]
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(merchantIndex + 1)", floorName: merchantName, sectionId: "S5001", sectionPosition: "1", sectionName: "满减活动", itemId: "I5004", itemPosition: "1", itemName:"勾选商品", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
            }
        }else if productType == .CartCellProductTypeNormal{
            //普通
            let extendParams:[String :AnyObject] = ["storage" : productModel.storage! as AnyObject,"pm_price" : productModel.pm_price! as AnyObject,"pm_pmtn_type" : productModel.pm_pmtn_type! as AnyObject]
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(merchantIndex + 1)", floorName: merchantName, sectionId: nil, sectionPosition: nil, sectionName: "普通商品", itemId: "I5004", itemPosition: "1", itemName:"勾选商品", itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
        }
    }
    //进入专区
    func enterPromotionShop(_ merchantIndex:Int,_ merchantName:String,_ promotionType:CartPromotionType){
        if  promotionType == .CartPromotionTypeMZ{
            //满折
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(merchantIndex + 1)", floorName: merchantName, sectionId: "S5001", sectionPosition: "2", sectionName: "满折活动", itemId: "I5004", itemPosition: "0", itemName:"进入满折专区", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        }else if  promotionType == .CartPromotionTypeMJ{
            //满减
            FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(merchantIndex + 1)", floorName: merchantName, sectionId: "S5001", sectionPosition: "1", sectionName: "满减活动", itemId: "I5004", itemPosition: "0", itemName:"进入满减专区", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        }
    }
}
