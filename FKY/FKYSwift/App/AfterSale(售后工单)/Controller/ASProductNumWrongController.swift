//
//  ASProductNumWrongController.swift
//  FKY
//
//  Created by 寒山 on 2019/5/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商品错发 漏发 列表

import UIKit

class ASProductNumWrongController: UIViewController {
    var soNo: String?
    var typeId: Int?
    fileprivate var asViewModel: AfterSaleViewModel = AfterSaleViewModel()
    // 当前默认选择索引...<不默认选择>
    var selectedIndex = 0
    
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
    
    fileprivate lazy var tableView: UITableView = {
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.dataSource = self
        tableV.delegate = self
        tableV.tableHeaderView = UIView.init(frame: .zero)
        tableV.tableFooterView = UIView.init(frame: .zero)
        tableV.register(ASProblemListCell.self, forCellReuseIdentifier: "ASProblemListCell")
        tableV.register(ASProductNumWrongInfoCell.self, forCellReuseIdentifier: "ASProductNumWrongInfoCell")
        tableV.register(RCSpaceCell.self, forCellReuseIdentifier: "RCSpaceCell")
        tableV.register(FKYWrongNumHeaderCell.self, forCellReuseIdentifier: "FKYWrongNumHeaderCell")
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.backgroundColor = RGBColor(0xf7f7f7)
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
    }()
    
    // 底部视图...<确定>
    fileprivate lazy var viewBottom: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(62)))
        view.backgroundColor = RGBColor(0xF7F7F7)
        // 按钮
        view.addSubview(self.btnDone)
        self.btnDone.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: WH(10), left: WH(30), bottom: WH(10), right: WH(30)))
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
    fileprivate lazy var btnDone: UIButton = {
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
            //
            strongSelf.saveAsWorkOrderInfo()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("ASProductNumWrongController deinit")
    }
    
    
    // MARK: - Private
    
    fileprivate func setupView() {
        view.backgroundColor = RGBColor(0xf7f7f7)
        
        fky_setupTitleLabel("商品错漏发")
        fky_hiddedBottomLine(false)
        fky_setupLeftImage("icon_back_new_red_normal"){
            FKYNavigator.shared().pop()
        }
        
        view.addSubview(viewBottom)
        view.addSubview(tableView)
        
        viewBottom.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self.view)
            make.height.equalTo(WH(62))
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo((navBar?.snp.bottom)!)
            make.bottom.equalTo(viewBottom.snp.top)
        }
    }
    
    fileprivate func setupData() {
        showLoading()
        var jsonParams = Dictionary<String, Any>()
        jsonParams["orderNo"] = self.soNo
        jsonParams["typeId"] = self.typeId
        self.asViewModel.getWorkOrderBaseInfo(withParams: jsonParams){ [weak self] (success, model, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if success {
                strongSelf.tableView.reloadData()
            } else {
                strongSelf.toast(msg ?? "请求失败")
            }
        }
    }
    
    //提交工单
    fileprivate func saveAsWorkOrderInfo() {
        // mmType    Integer    是    商品错漏发类型: 1-错发 2-漏发
        if selectedIndex == 0 {
            self.toast("请选择商品错漏发售后服务类型")
            return
        }
        // 入参
        var jsonParams = Dictionary<String, Any>()
        var productTitleStr = ""
        if self.selectedIndex != 0 {
             let model:ASApplyTypeModel = (self.asViewModel.asBaseInfo?.typeList![selectedIndex - 1])!
             jsonParams["serviceTypeId"] = model.typeId
             productTitleStr = model.typeName ?? ""
        }
        let asGoodsList = self.asViewModel.getAllSelectProduct()
        if  asGoodsList.count == 0 {
            self.toast("请选择\(productTitleStr)的商品")
            return
        }
        
        var goodsStrArray:Array<String> = []  //商品列表
        for model in asGoodsList {
            let goodsStr =  NSString(format: "%d", model.orderDetailId!) as String  + "-" +  (NSString(format: "%d", model.steperCount! ) as String) as String
            goodsStrArray.append(goodsStr)
        }
        let allGoodsStr = goodsStrArray.joined(separator: ",")
        
        if  self.selectedIndex == 1{
             //错发
             jsonParams["mmType"] = 1
        }else{
            //漏发
             jsonParams["mmType"] = 2
        }
        //订单ID
        jsonParams["soNo"] = self.soNo
        //商品信息
        jsonParams["goodsInfo"] = allGoodsStr
        //企业ID
        jsonParams["customerId"] = FKYLoginAPI.currentUser().ycenterpriseId ?? ""
        
        showLoading()
        AfterSaleViewModel.saveAsWorkOrder(withParams: jsonParams){ [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if success {
                let alert = COAlertView.init(frame: CGRect.zero)
                alert.configView("您申请的售后服务已提交，我们会在1-2个工作日为您处理完成并将结果反馈给您。再次感谢您的支持！", "", "", "确定", .oneBtn)
                alert.showAlertView()
                alert.doneBtnActionBlock = {
                    //刷新工单
                    NotificationCenter.default.post(name: NSNotification.Name.FKYRefreshAS, object: self, userInfo: nil)
                    FKYNavigator.shared().pop()
                }
            } else {
                strongSelf.toast(msg ?? "请求失败")
            }
        }
    }
}

extension ASProductNumWrongController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.asViewModel.asBaseInfo != nil {
            //进来没选择 不展示商品
            if self.selectedIndex != 0{
                 return 2
            }else{
                 return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return (self.asViewModel.asBaseInfo?.typeList!.count)! + 1
        }
        return (self.asViewModel.asBaseInfo?.productList?.count)! + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            if (indexPath.section == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "RCSpaceCell", for: indexPath) as! RCSpaceCell
                cell.selectionStyle = .none
                return cell
            }else if indexPath.section == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "FKYWrongNumHeaderCell", for: indexPath) as! FKYWrongNumHeaderCell
                cell.selectionStyle = .none
                cell.configTitleCell("请选择错发的商品")
                return cell
            }
         
        }
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ASProblemListCell", for: indexPath) as! ASProblemListCell
            // 配置cell
            let model:ASApplyTypeModel = (self.asViewModel.asBaseInfo?.typeList![indexPath.row - 1])!
            cell.configCell(model.typeName)
           
            // 是否选中
            cell.setSelectedStatus(indexPath.row == selectedIndex)
            // 底部分隔线设置
            cell.showBottomLine(indexPath.row == 2 ? false : true)
            // 点击btn后选中
            cell.selectBlock = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.selectedIndex != indexPath.row{
                    //重设数据
                    strongSelf.asViewModel.resetAllSelectProduct()
                    strongSelf.selectedIndex = indexPath.row
                    strongSelf.tableView.reloadData()
                }
            }
            cell.selectionStyle = .default
            return cell
        }
        let model:ASApplyBaseProductModel = (self.asViewModel.asBaseInfo?.productList![indexPath.row - 1])!
        let cell = tableView.dequeueReusableCell(withIdentifier: "ASProductNumWrongInfoCell", for: indexPath) as! ASProductNumWrongInfoCell
        cell.selectionStyle = .none
        //最大选择商品数量
        let maxNum = model.productCount
        
        let typeModel:ASApplyTypeModel = (self.asViewModel.asBaseInfo?.typeList![selectedIndex - 1])!
        
        if maxNum == 0{
            model.checkStatus = true
        }
        cell.configView(model,maxNum!,typeModel)
        cell.stepper.updateProductBlock = { (count : Int,typeIndex : Int) in
            model.steperCount =  count
        }
        cell.checkStausChange = { [weak self] in
            if model.steperCount == 0{
                if model.productCount == 0{
                    model.checkStatus = true
                }else{
                    model.steperCount =  1
                    model.checkStatus = !model.checkStatus!
                }
            }else{
                model.checkStatus = !model.checkStatus!
            }
            self?.tableView.reloadData()
        }
        return cell
    }
}

extension ASProductNumWrongController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            if (indexPath.section == 0){
                return WH(10)
            }else if indexPath.section == 1{
                 return WH(54)
            }
            
        }
        if indexPath.section == 0{
            return WH(44)
        }else{
            return WH(122)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0{
            if self.selectedIndex != indexPath.row{
                  //重设数据
                self.asViewModel.resetAllSelectProduct()
                self.selectedIndex = indexPath.row
                self.tableView.reloadData()
            }
        }
    }
}
