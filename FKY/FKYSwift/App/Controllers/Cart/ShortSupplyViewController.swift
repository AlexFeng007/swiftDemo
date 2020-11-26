//
//  ShortSupplyViewController.swift
//  FKY
//
//  Created by Rabe on 11/08/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  缺货提醒...<全部缺货/部分缺货>

import Foundation
import UIKit

// 全部缺货
class ShortSupplyAllViewController: UIViewController {
    // MARK: - Properties
    
    var virturalInventoryModel: FKYVirtualInventoryModel?
    
    var navBar : UIView?
    
    fileprivate lazy var headerView: ShortSupplyHeaderView! = {
        return ShortSupplyHeaderView()
    }()
    
    fileprivate lazy var orderButton: UIButton! = {
        let button = UIButton()
        button.setTitle("订单中心", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = RGBColor(0xfe5050)
        button.layer.cornerRadius = 2
        button.layer.masksToBounds = true
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                let v = vc as! FKY_TabBarController
                v.index = 4
                FKYNavigator.shared().openScheme(FKY_AllOrderController.self, setProperty: { (vc) in
                }, isModal: false)
            }, isModal: false)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBar = {
            if let _ = self.NavigationBar {
            } else {
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        
        self.navBar!.backgroundColor = bg1
        self.fky_setupTitleLabel("缺货提醒")
        self.NavigationTitleLabel!.fontTuple = t14
        self.fky_hiddedBottomLine(true)
        self.setupView()
        self.bindViewModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Action
    
    // MARK: - UI
    
    func setupView() -> () {
        self.view.backgroundColor = bg5
        self.view.addSubview(headerView)
        self.view.addSubview(orderButton)
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo((navBar?.snp.bottom)!)
            make.left.right.equalTo(self.view)
        }
        
        orderButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(WH(16))
            make.right.equalTo(self.view).offset(WH(-16))
            make.centerX.equalTo(self.view)
            make.top.equalTo(headerView.snp.bottom).offset(WH(23))
            make.height.equalTo(WH(44))
        }
    }
    
    // MARK: - Private Method
    
    func bindViewModel() {
        headerView.configData(withSupplyNames: self.virturalInventoryModel!.supplyNames! as NSArray, shortOfStockAll: true)
        self.view.layoutIfNeeded()
    }
}


// 部分缺货
class ShortSupplyViewController: UIViewController {
    
    // MARK: - Properties
    
    var virturalInventoryModel: FKYVirtualInventoryModel?
    
    // tableview主内容视图...<cell高度自适应>
    fileprivate lazy var tableView : UITableView! = {
        let tb = UITableView.init(frame: CGRect.zero, style: .plain)
        tb.delegate = self
        tb.dataSource = self
        tb.backgroundColor = bg1
        //tb.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(52)))
        tb.tableFooterView = self.tipView
        tb.register(ShortSupplyHeaderTableViewCell.self, forCellReuseIdentifier: "ShortSupplyHeaderTableViewCell")
        tb.register(ShortSupplyATableViewCell.self, forCellReuseIdentifier: "ShortSupplyATableViewCell")
        tb.register(ShortSupplyBTableViewCell.self, forCellReuseIdentifier: "ShortSupplyBTableViewCell")
        tb.estimatedRowHeight = WH(100)
        tb.rowHeight = UITableViewAutomaticDimension
        return tb
    }()
    
    // section headerview of tableview
    fileprivate lazy var header: ShortSupplySectionHeaderView! = {
        let view = ShortSupplySectionHeaderView()
        view.delegate = self
        return view
    }()
    
    // 底部提交栏
    fileprivate lazy var footerView: ShortSupplyFooterView! = {
        let footer = ShortSupplyFooterView()
        footer.delegate = self
        return footer
    }()
    
    // 订单详情视图
    fileprivate lazy var panel: ShortSupplyPanelView! = {
        return ShortSupplyPanelView(withModel: self.virturalInventoryModel!.priceModel)
    }()
    
    // 遮罩视图
    fileprivate lazy var mask: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0x000000).withAlphaComponent(0.4)
        view.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        return view
    }()
    
    // 底部文字提示视图 section footerview of tableview
    fileprivate lazy var tipView: ShortSupplyBottomTipView! = {
        return ShortSupplyBottomTipView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
    }()
    
    // 自定义弹框视图
    fileprivate lazy var alertView: ShortSupplyAlertView! = {
        let alert = ShortSupplyAlertView.init(frame: self.view.bounds)
        alert.delegate = self
        return alert
    }()
    
    var navBar : UIView?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBar = {
            if let _ = self.NavigationBar {
            } else {
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        
        self.navBar!.backgroundColor = bg1
        self.fky_setupTitleLabel("缺货提醒")
        self.NavigationTitleLabel!.fontTuple = t14
        self.fky_hiddedBottomLine(true)
        self.setupView()
        self.bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 隐藏键盘
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Action
    
    func tapGestureAction() {
        footerView.dismissPanelIfneeded()
    }
    
    // MARK: - UI
    
    func setupView() -> () {
        self.view.backgroundColor = bg1
        self.view.addSubview(tableView)
        self.view.addSubview(mask)
        self.view.addSubview(panel)
        self.view.addSubview(footerView)
        
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                let bottomMask = UIView()
                bottomMask.backgroundColor = .white
                self.view.addSubview(bottomMask)
                
                bottomMask.snp.makeConstraints({ (make) in
                    make.left.right.bottom.equalTo(self.view)
                    make.top.equalTo(footerView.snp.bottom)
                })
            }
        }

        // 底部栏
        footerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(WH(52))
            if #available(iOS 11, *) {
                let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
                if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                    make.bottom.equalTo(self.view).offset(WH(-iPhoneX_SafeArea_BottomInset))
                } else {
                    make.bottom.equalTo(self.view)
                }
            } else {
                make.bottom.equalTo(self.view)
            }
        }
        
        // 内容视图
        tableView.snp.makeConstraints({ (make) in
            make.top.equalTo((navBar?.snp.bottom)!)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.footerView.snp.top)
        })
        
        mask.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo((navBar?.snp.bottom)!)
            make.bottom.equalTo(panel.snp.top)
        }
        
        panel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(footerView.snp.top).offset(WH(200))
        }
    }
    
    // MARK: - Data
    
    func updatePanelPrice(withList list: NSArray, handler: @escaping (_ success: Bool)->()) {
        let oldList = self.virturalInventoryModel?.productModels
        self.virturalInventoryModel?.productModels = list as! [Any]
        self.showLoading()
        ShortSupplyProvider.shared.recheckOrderMoney(withParameter: virturalInventoryModel!.changeOrderURL2Dic() as NSDictionary, handler: { (success, virturalInventoryPriceModel) in
            self.dismissLoading()
            guard success && (virturalInventoryPriceModel != nil) else {
                self.toast("金额刷新失败，请稍后重试!")
                self.virturalInventoryModel?.productModels = oldList
                handler(false)
                return
            }
            // 金额更新
            self.virturalInventoryModel?.priceModel = virturalInventoryPriceModel
            handler(true)
            self.bindViewModel()
        })
    }
    
    // MARK: - Private Method
    
    func bindViewModel() {
        footerView.bind(withText: String(format: "%.2f", (virturalInventoryModel?.priceModel.orderPayMoney)!))
        panel.update(withModel: self.virturalInventoryModel!.priceModel)
    }
}

extension ShortSupplyViewController: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        let productModels = virturalInventoryModel!.productModels as NSArray
        return productModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        if indexPath.section == 0 {
            // 顶部文字说明cell...<非自营&自营>
            let cell = ShortSupplyHeaderTableViewCell(style: .default, reuseIdentifier: "ShortSupplyHeaderTableViewCell")
            cell.configData(withSupplyNames: self.virturalInventoryModel!.supplyNames! as NSArray, shortOfStockAll: false)
            return cell
        }
        
        let productModels = virturalInventoryModel!.productModels as NSArray
        let productModel = productModels[indexPath.row] as! FKYVirtualInventoryProductModel
        if productModel.state.rawValue == 0 {
            // 无库存
            let cell = ShortSupplyBTableViewCell(style: .default, reuseIdentifier: "ShortSupplyBTableViewCell")
            let lineHidden = (indexPath.row == productModels.count - 1)
            cell.bind(withModel: productModel, lineHidden: lineHidden)
            return cell
        }
        
        /*************************************************************/
        
        // 库存不足 or 库存充足
        let cell = ShortSupplyATableViewCell(style: .default, reuseIdentifier: "ShortSupplyATableViewCell")
        cell.bind(withModel: productModel)
        
        let max = productModel.stockAmount              // 库存
        let minPacking = productModel.minimumPacking    // 最小起批量
        
        // 限购相关
        var limitFlag = false // 默认不考虑限购
        let limitProduct = productModel.limitProduct    // 是否限购
        let limitType = productModel.limitType          // 限购类型
        let limitNum = productModel.limitNum            // 限购数
        let limitBuyNum = productModel.limitCanBuyNum   // 限购之剩余可购买数量
        // 限购相关判断~!@
        if limitProduct == true
            && (limitType == 2 || limitType == 3)
            && limitNum > 0 {
            // 有限购
            limitFlag = true
        }
        
        // 加
        cell.addCallback = { (currentCount: Int) -> Void in
            // 实际采购数量默认为现有库存数量，可以在小于等于现有库存数量的范围内修改
            var result = (currentCount + minPacking) > max ? max : (currentCount + minPacking)
            // 限购逻辑
            if limitFlag == true && result >= limitBuyNum {
                // 当前商品有限购，且用户选择的商品数量大于等于限购数量
                let flag = result > limitBuyNum ? true : false
                // 购买数量需小于等于限购剩余购买数量
                result = limitBuyNum
                if productModel.isItemSelected {
                    // 当前商品已选中
                    if flag {
                        self.toast("超过限购数量！")
                    }
                    // 更新商品购买数量，并实时请求总价
                    self.tableViewCellDidTriggerUpdatePanelNew(cell, originProductModel: productModel, newCount: result, limitCount: limitBuyNum)
                } else {
                    // 当前商品未选中
                    productModel.productCount = result
                    cell.updateStepperNumberNew(withCount: result, andLimit: limitBuyNum)
                }
                return
            }
            // 若当前商品未选中 or 数量未改变，则不请求总价，只更新购买数量
            guard productModel.isItemSelected && result - currentCount > 0 else {
                productModel.productCount = result
                cell.updateStepperNumber(withCount: result)
                return
            }
            // 更新商品购买数量，并实时请求总价
            self.tableViewCellDidTriggerUpdatePanel(cell, originProductModel: productModel, newCount: result)
        }
        // 减
        cell.minusCallback = { (currentCount: Int) -> Void in
            var result = (currentCount - minPacking) > minPacking ? (currentCount - minPacking) : minPacking
            if currentCount - minPacking <= 0 {
                // 数量改为0，自动取消勾选
                if productModel.isItemSelected {
                    cell.willChangeSelState!(false)
                    return
                }
                result = 0
            } else if result > max {
                result = max
            }
            // 限购逻辑
            if limitFlag == true && result >= limitBuyNum {
                // 当前商品有限购，且用户选择的商品数量大于等于限购数量
                let flag = result > limitBuyNum ? true : false
                // 购买数量需小于等于限购剩余购买数量
                result = limitBuyNum
                if productModel.isItemSelected {
                    // 当前商品已选中
                    if flag {
                        self.toast("超过限购数量！")
                    }
                    // 更新商品购买数量，并实时请求总价
                    self.tableViewCellDidTriggerUpdatePanelNew(cell, originProductModel: productModel, newCount: result, limitCount: limitBuyNum)
                } else {
                    // 当前商品未选中
                    productModel.productCount = result
                    cell.updateStepperNumberNew(withCount: result, andLimit: limitBuyNum)
                }
                return
            }
            // 若当前商品未选中，则不请求总价，只更新购买数量
            guard productModel.isItemSelected else {
                productModel.productCount = result
                cell.updateStepperNumber(withCount: result)
                return
            }
            // 更新商品购买数量，并实时请求总价
            self.tableViewCellDidTriggerUpdatePanel(cell, originProductModel: productModel, newCount: result)
        }
        // 输入
        cell.validateTextinputCallback = { (currentCount: Int) -> Void in
            var result = currentCount
            //
            if currentCount <= 0 {
                // 数量改为0，自动取消勾选
                cell.willChangeSelState!(false)
                return
            } else if currentCount < minPacking {
                result = minPacking
            } else if currentCount >= minPacking && currentCount <= max {
                result = currentCount
            } else {
                result = max
            }
//            if currentCount >= minPacking && currentCount <= max {
//                //
//                result = currentCount
//            } else if currentCount <= 0 {
//                // 数量改为0，自动取消勾选
//                cell.willChangeSelState!(false)
//                return
//            } else {
//                result = max
//            }
            
            // 限购逻辑
            if limitFlag == true && result >= limitBuyNum {
                // 当前商品有限购，且用户选择的商品数量大于等于限购数量
                let flag = result > limitBuyNum ? true : false
                // 购买数量需小于等于限购剩余购买数量
                result = limitBuyNum
                if productModel.isItemSelected {
                    // 当前商品已选中
                    if flag {
                        self.toast("超过限购数量！")
                    }
                    // 更新商品购买数量，并实时请求总价
                    self.tableViewCellDidTriggerUpdatePanelNew(cell, originProductModel: productModel, newCount: result, limitCount: limitBuyNum)
                } else {
                    // 当前商品未选中
                    productModel.productCount = result
                    cell.updateStepperNumberNew(withCount: result, andLimit: limitBuyNum)
                }
                return
            }
            // 若当前商品未选中，则不请求总价，只更新购买数量
            guard productModel.isItemSelected else {
                productModel.productCount = result
                cell.updateStepperNumber(withCount: result)
                return
            }
            // 更新商品购买数量，并实时请求总价
            self.tableViewCellDidTriggerUpdatePanel(cell, originProductModel: productModel, newCount: result)
        }
        // 选中状态修改
        cell.willChangeSelState = { (selectState: Bool) -> Void in
            let newProductModels = productModels.mutableCopy() as! NSArray
            var isFlagAllSame = true
            for product in newProductModels {
                let item = product as! FKYVirtualInventoryProductModel
                if item.productCodeCompany == productModel.productCodeCompany && item.promotionId == productModel.promotionId {
                    item.isItemSelected = selectState
                    if item.productCount == 0 && selectState {
                        // 未选->选中 商品数量为0 取计划采购数&现有库存数最小值做商品数量
                        //item.productCount = min(item.stockAmount, item.productNormalCount)
                        
                        // 限购逻辑
                        if limitFlag == true {
                            // 有限购
                            item.productCount = min(item.stockAmount, item.productNormalCount, limitBuyNum)
                        } else {
                            // 无限购
                            item.productCount = min(item.stockAmount, item.productNormalCount)
                        }
                    }
                    if !selectState {
                        // 取消选中，则购买数量置0
                        item.productCount = 0
                    }
                }
                if item.stockAmount > 0 && item.isItemSelected != selectState {
                    isFlagAllSame = false
                }
            }
            // 更新金额
            self.updatePanelPrice(withList: newProductModels, handler: { (success) in
                guard success else {
                    return
                }
                if isFlagAllSame { // 标识全部一致 使用每行当前状态作为全选标识
                    self.header.didChangeSelectState(withState: selectState)
                } else { // 标识不一致 则全选标识一定为未选
                    self.header.didChangeSelectState(withState: false)
                }
                tableView.reloadRows(at: [indexPath], with: .none)
            })
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? UIView() : header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : WH(40)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //return section == 0 ? CGFloat.leastNormalMagnitude : WH(10)
        return CGFloat.leastNormalMagnitude
    }
    
    // MARK - Private
    
    // 更新数量及金额
    func tableViewCellDidTriggerUpdatePanel(_ cell: ShortSupplyATableViewCell, originProductModel: FKYVirtualInventoryProductModel, newCount: Int) {
        // 更新可购买数量
        let productModels = virturalInventoryModel!.productModels as NSArray
        let newProductModels = productModels.mutableCopy() as! NSArray
        for product in newProductModels {
            let item = product as! FKYVirtualInventoryProductModel
            if item.productCodeCompany == originProductModel.productCodeCompany && item.promotionId == originProductModel.promotionId {
                // 重置当前商品的可购买数量
                item.productCount = newCount
            }
        }
        // (request)更新价格
        self.updatePanelPrice(withList: newProductModels, handler: { (success) in
            guard success else {
                return
            }
            // 更新数量输入控件状态
            cell.updateStepperNumber(withCount: newCount)
        })
    }
    
    // 更新数量及金额...<针对商品有限购属性>
    func tableViewCellDidTriggerUpdatePanelNew(_ cell: ShortSupplyATableViewCell, originProductModel: FKYVirtualInventoryProductModel, newCount: Int, limitCount: Int) {
        // 更新可购买数量
        let productModels = virturalInventoryModel!.productModels as NSArray
        let newProductModels = productModels.mutableCopy() as! NSArray
        for product in newProductModels {
            let item = product as! FKYVirtualInventoryProductModel
            if item.productCodeCompany == originProductModel.productCodeCompany && item.promotionId == originProductModel.promotionId {
                // 重置当前商品的可购买数量
                item.productCount = newCount
            }
        }
        // (request)更新价格
        self.updatePanelPrice(withList: newProductModels, handler: { (success) in
            guard success else {
                return
            }
            // 更新数量输入控件状态
            cell.updateStepperNumberNew(withCount: newCount, andLimit: limitCount)
        })
    }
    
    // 获取最终可购买数量
    // <最终数量>应该为<最小折零包装>的整数倍，且小于等于库存数，小于等于限购剩余可购买数量
    func getFinalBuyNumber4(miniPacking: NSInteger, maxBuy: NSInteger, currentNum: NSInteger) -> NSInteger {
        //
        return currentNum
    }
}

extension ShortSupplyViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.footerView.dismissPanelIfneeded()
    }
}

extension ShortSupplyViewController: ShortSupplySectionHeaderViewDelegate {
    func supplySectionHeaderView(willChangeSelectState selectState: Bool) {
        let productModels = self.virturalInventoryModel!.productModels as NSArray
        let newProductModels = productModels.mutableCopy() as! NSArray
        for product in newProductModels {
            let item = product as! FKYVirtualInventoryProductModel
            item.isItemSelected = selectState
            if item.productCount == 0 && selectState {
                // 未选->选中 商品数量为0 取计划采购数&现有库存数最小值做商品数量
                item.productCount = min(item.stockAmount, item.productNormalCount)
            }
            if !selectState {
                item.productCount = 0
            }
        }
        self.updatePanelPrice(withList: newProductModels, handler: { (success) in
            guard success else {
                return
            }
            self.header.didChangeSelectState(withState: selectState)
            self.tableView.reloadData()
        })
    }
}

extension ShortSupplyViewController: ShortSupplyFooterViewDelegate {
    //
    func footerView(shouldOpenPanel flag: Bool) {
        self.panel.snp.updateConstraints({ (make) in
            if flag {
                make.bottom.equalTo(self.footerView.snp.top)
            } else {
                make.bottom.equalTo(self.footerView.snp.top).offset(WH(200))
            }
        })
        UIView.animate(withDuration: 0.35) {
            self.mask.alpha = flag ? 1 : 0
            self.view.layoutIfNeeded()
        }
    }
    
    // 返回购物车
    func footerViewOnClickGiveUp() {
//        let parameter = ["list": virturalInventoryModel!.shopCartIdList()] as NSDictionary
//        ShortSupplyProvider.shared.cancelDemandOrder(withParameter: parameter) { (success, message) in
//            FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
//                let v = vc as! FKY_TabBarController
//                v.index = 2
//            }, isModal: false)
//        }
        
        // 隐藏键盘
        self.view.endEditing(true)
        
        // 弹出alert，让用户再确认一次是否返回
        self.view.addSubview(self.alertView)
    }
    
    // 提交订单
    func footerViewOnClickSubmit() {
        let productModels = virturalInventoryModel!.productModels as NSArray
        var itemSelected = false
        for product in productModels {
            let item = product as! FKYVirtualInventoryProductModel
            if item.isItemSelected {
                itemSelected = true
                break
            }
        }
        guard itemSelected else {
            self.toast("请您选择商品后再提交!")
            return
        }
        
        self.showLoading()
        ShortSupplyProvider.shared.submitShortSupplyOrder(withParameter: virturalInventoryModel!.changeOrderURL2Dic() as NSDictionary, handler: { (success, virturalInventoryModel, message) in
            self.dismissLoading()
            let supplyNames = self.virturalInventoryModel!.supplyNames! as NSArray
            virturalInventoryModel?.supplyNames = supplyNames.copy() as! [Any]
            if virturalInventoryModel?.submitStatus == 1 {
                // 提交成功
                FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                    let v = vc as! FKY_TabBarController
                    v.index = 4
                    FKYNavigator.shared().openScheme(FKY_AllOrderController.self, setProperty: { (vc) in
                    }, isModal: false)
                }, isModal: false)
                return
            }
            if virturalInventoryModel?.submitStatus == 3 {
                // 全部缺货了,跳转全部缺货界面
                FKYNavigator.shared().openScheme(FKY_ShortSupplyAllController.self, setProperty: { (vc) in
                    let v = vc as! ShortSupplyAllViewController
                    v.virturalInventoryModel = virturalInventoryModel;
                }, isModal: false)
                return
            }
            guard success && (virturalInventoryModel != nil) else {
                self.toast(message)
                return
            }
            // 库存更新-再次更新界面
            self.toast("现有库存数量有更新")
            self.virturalInventoryModel = virturalInventoryModel
            self.tableView.reloadData()
            self.bindViewModel()
        })
    }
}

extension ShortSupplyViewController: ShortSupplyAlertViewDelegate {
    // 确定
    func doneActon4Alert() {
        // 返回购物车
        let parameter = ["list": virturalInventoryModel!.shopCartIdList()] as NSDictionary
        ShortSupplyProvider.shared.cancelDemandOrder(withParameter: parameter) { (success, message) in
            FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                let v = vc as! FKY_TabBarController
                v.index = 3
            }, isModal: false)
        }
    }
}



