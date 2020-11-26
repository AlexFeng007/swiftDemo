//
//  RCTypeSelController.swift
//  FKY
//
//  Created by 寒山 on 2018/11/26.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退换货类型选择界面

import UIKit

class RCTypeSelController: UIViewController {
    //商铺
    var orderModel: FKYOrderModel?
    var paytype: Int32 = 0  //支付类型(上个界面传过来的)
    var rcType = 2 //1:mp退货 2:自营的退换货 3:自营的极速理赔
    var amountLimit: String?     //额度<极速理赔需要传入字段>
    var showReplace = false //true 只显示退货
    // viewmodel
    fileprivate lazy var viewModel: RCTypeSelViewModel = {
        let vm = RCTypeSelViewModel()
        vm.orderModel = self.orderModel
        return vm
    }()
    
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
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.register(RCTypeSelProductCell.self, forCellReuseIdentifier: "RCTypeSelProductCell")
        tableV.register(RCTypeSelectHeadView.self, forHeaderFooterViewReuseIdentifier: "RCTypeSelectHeadView")
        tableV.register(RCTypeSelectFooterView.self, forHeaderFooterViewReuseIdentifier: "RCTypeSelectFooterView")
        tableV.register(RCSpaceCell.self, forCellReuseIdentifier: "RCSpaceCell")
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.backgroundColor = RGBColor(0xf7f7f7)
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    
    // MARK: - LifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        if orderModel?.payTypeId == 31 {
            //上银金融只显示退货
            showReplace = true
        }
        setupView()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 防止键盘与输入位置不对
        IQKeyboardManager.shared().keyboardDistanceFromTextField = WH(119) + 10
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 隐藏切换
        IQKeyboardManager.shared().keyboardDistanceFromTextField =  10
    }
    
    // MARK: -
    func setupView() {
        view.backgroundColor = RGBColor(0xf7f7f7)
        
        fky_setupTitleLabel("选择售后类型")
        fky_hiddedBottomLine(false)
        fky_setupLeftImage("icon_back_new_red_normal"){
            FKYNavigator.shared().pop()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo((navBar?.snp.bottom)!)
            make.bottom.equalTo(self.view.snp.bottom).offset(-bootSaveHeight())
        }
    }
    
    func setupData() {
        self.viewModel.initPooductStatus()
        showLoading()
        //请求最大可以退换货数量
        if self.rcType == 1 {
            //mp退货
            viewModel.requestForGetMPProductListInfo() {[weak self] (success, msg) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.dismissLoading()
                if success{
                    strongSelf.tableView.reloadData()
                } else {
                    // 失败
                    strongSelf.toast(msg ?? "请求失败")
                    return
                }
            }
            
        }else {
            //自营退换货
            viewModel.requestForQueryOrderIdInfo(orderModel!.orderId) { [weak self] (success, msg) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.dismissLoading()
                strongSelf.tableView.reloadData()
                if success{
                    strongSelf.viewModel.requestForGetCountsInfo() {(success, msg) in
                        strongSelf.dismissLoading()
                        if success{
                            strongSelf.tableView.reloadData()
                        } else {
                            // 失败
                            strongSelf.toast(msg ?? "请求失败")
                            return
                        }
                    }
                } else {
                    // 失败
                    strongSelf.toast(msg ?? "请求失败")
                    return
                }
            }
        }
    }
    //判断总金额
    func showAlertLargeNum() {
        if self.rcType == 3 {
             //极速退换货-需要判断（极速理赔最大可选的商品总金额不大于500） ->张震
            if let maxNum = Double(self.amountLimit ?? "0"), maxNum>0 {
                if self.viewModel.getAllSelectProductMoneyNum() > maxNum {
                    self.toast("商品总金额不大于\(maxNum)")
                }
            }
        }
    }
}

extension RCTypeSelController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return  1
        }
        return self.viewModel.orderModel!.productList.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 || (indexPath.section == 1&&indexPath.row == self.viewModel.orderModel!.productList.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "RCSpaceCell", for: indexPath) as! RCSpaceCell
            cell.selectionStyle = .none
            return cell
        }
        let model:FKYOrderProductModel = self.viewModel.orderModel!.productList![indexPath.row] as! FKYOrderProductModel
        let cell = tableView.dequeueReusableCell(withIdentifier: "RCTypeSelProductCell", for: indexPath) as! RCTypeSelProductCell
        cell.selectionStyle = .none
        let maxNum = self.viewModel.getMaxCount(model.orderDetailId)
        if maxNum == 0 && self.viewModel.maxCountCountList != nil{
            model.checkStatus = true
        }
        cell.configView(model,maxNum,self.rcType)
        cell.stepper.updateProductBlock = { [weak self] (count : Int,typeIndex : Int) in
            guard let strongSelf = self else {
                return
            }
            model.steperCount =  count
            strongSelf.showAlertLargeNum()
        }
        cell.checkStausChange = { [weak self] in
            if model.steperCount == 0{
                if self!.viewModel.getMaxCount(model.orderDetailId) == 0{
                    model.checkStatus = true
                }else{
                    model.steperCount =  1
                    model.checkStatus = !model.checkStatus
                }
            }else{
                model.checkStatus = !model.checkStatus
            }
            
            self?.viewModel.allSelect = self?.viewModel.isAllProductSelected()
            self?.tableView.reloadData()
            self?.showAlertLargeNum()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || (indexPath.section == 1&&indexPath.row == self.viewModel.orderModel!.productList.count){
            return WH(10)
        }
        return WH(122)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return  0
        }
        return WH(42)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return  0
        }
        if self.rcType == 2 {
            if self.showReplace == true {
                return WH(59.5)
            }else {
                return WH(119)
            }
        }else if self.rcType == 3 {
            return WH(44)
        }else {
            return WH(59.5)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return  UIView.init()
        }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RCTypeSelectHeadView") as! RCTypeSelectHeadView
        view.configView(self.viewModel.childOrderId,self.viewModel.allSelect)
        view.allCheckStausChange = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let isAllSelected:Bool = strongSelf.viewModel.isAllProductSelected()
            strongSelf.viewModel.setAllProductCheckSatte(!isAllSelected){(success) in
                strongSelf.tableView.reloadData()
                strongSelf.showAlertLargeNum()
            }
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return  UIView.init()
        }
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RCTypeSelectFooterView") as! RCTypeSelectFooterView
        view.configSelectFooterView(self.rcType,self.showReplace)
        
        // 申请退货
        view.applyReturnGoodAction = { [weak self] in
            // 隐藏键盘
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.endEditing(true)
            
            let childOrderId = strongSelf.viewModel.childOrderId
            let returnGoodsList = strongSelf.viewModel.getAllSelectProduct()
            if returnGoodsList.count == 0 {
                strongSelf.toast("退换货选择商品不能为空")
                return
            }
            if strongSelf.rcType == 3 {
                 //极速退换货-需要判断（极速理赔最大可选的商品总金额不大于500） ->张震
                if let maxNum = Double(strongSelf.amountLimit ?? "0"), maxNum>0 {
                    if strongSelf.viewModel.getAllSelectProductMoneyNum() > maxNum {
                        strongSelf.toast("商品总金额不大于\(maxNum)")
                        return
                    }
                }
            }
            
            //判断是否是医药贷贷对公支付的
            if strongSelf.orderModel!.payTypeId.intValue == 24 && strongSelf.viewModel.judgeHasFixComobProduct() == true{
                FKYProductAlertView.showNewAlertView(withTitle: nil, leftTitle: "确定", rightTitle: nil, message: "使用1药贷-对公购买固定套餐的订单，不允许退货。感谢您的理解。", dismiss: false, handler: { (_, isRight) in
                })
                return
            }
            
            //
            if strongSelf.orderModel!.payTypeId.intValue == 24 {
                if strongSelf.viewModel.judgeAllSelectProductIsMax() == false{
                    FKYProductAlertView.showNewAlertView(withTitle: nil, leftTitle: "确定", rightTitle: nil, message: "使用1药贷-对公支付方式的订单，只允许全部退货。感谢您的配合。", dismiss: false, handler: { (_, isRight) in
                        strongSelf.viewModel.setAllProductCheckSatteAndIsMax(){(success) in
                            strongSelf.tableView.reloadData()
                        }
                    })
                    return
                }
            }
            
            //判断是否包含固定套餐
            if strongSelf.viewModel.judgeHasFixComobProduct() == true{
                FKYProductAlertView.showNewAlertView(withTitle: nil, leftTitle: "确定", rightTitle: nil, message: "选中商品包含固定套餐商品，不允许退货。感谢您的理解。", dismiss: false, handler: { (_, isRight) in
                    strongSelf.viewModel.setFixComobProductUnCheck(){(success) in
                        strongSelf.tableView.reloadData()
                    }
                })
                return
            }
            
            // jump
            FKYNavigator.shared().openScheme(FKY_RCSubmitInfoController.self, setProperty: { (vc) in
                let controller = vc as! RCSubmitInfoController
                controller.returnFlag = true                // 退货
                controller.orderId = childOrderId           // 子订单号
                controller.productList = returnGoodsList    // 订单中商品列表
                controller.paytype = strongSelf.paytype
                controller.rcType = strongSelf.rcType
            }, isModal: false, animated: true)
        }
        
        // 申请换货
        view.applyChangeGoodAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            // 隐藏键盘
            strongSelf.view.endEditing(true)
            
            let childOrderId = strongSelf.viewModel.childOrderId
            let changeGoodsList = strongSelf.viewModel.getAllSelectProduct()
            if  changeGoodsList.count == 0 {
                self?.toast("退换货选择商品不能为空")
                return
            }
            
            // jump
            FKYNavigator.shared().openScheme(FKY_RCSubmitInfoController.self, setProperty: { (vc) in
                let controller = vc as! RCSubmitInfoController
                controller.returnFlag = false               // 换货
                controller.orderId = childOrderId           // 子订单号
                controller.productList = changeGoodsList    // 订单中商品列表
                controller.paytype = strongSelf.paytype
            }, isModal: false, animated: true)
        }
        
        return view
    }
}
