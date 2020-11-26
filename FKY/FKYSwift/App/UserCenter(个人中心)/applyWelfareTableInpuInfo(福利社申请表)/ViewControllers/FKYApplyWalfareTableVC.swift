//
//  FKYApplyWalfareTableVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYApplyWalfareTableVC: UIViewController {

    /// viewModel
    var viewModel = FKYApplyWalfareTableViewModel()
    
//    /// 选择的地址model
//    fileprivate var editAddress = ZZReceiveAddressModel()
    
    /// 总店管理员姓名
    var adminName = ""
    
    /// 总店管理员手机号
    var adminPhoneNum = ""
    
    // 地址选择视图
    fileprivate lazy var addressPickerView: FKYDeliveryAddressPickerView! = {
        // 默认使用读取本地db文件的方式来获取数据源
        let pickView = FKYDeliveryAddressPickerView(Provider: FKYAddressLocalProvider())
        pickView.titleLable.text = "开户行所在省市选择"
        //let pickView = FKYDeliveryAddressPickerView(Provider: FKYAddressRemoteProvider())
        // 若是编辑，而非新增，则需要传递对应的地址model
//        if let addr = self.address {
//            // 将省市区数据保存到pickerview中，便于视图弹出时自动显示当前保存的地区信息
//            pickView.province = FKYAddressItemModel.init(code: addr.provinceCode, name: addr.provinceName, level: "1", parentCode: nil)
//            pickView.city = FKYAddressItemModel(code: addr.cityCode, name: addr.cityName, level: "2", parentCode: nil)
//            pickView.district = FKYAddressItemModel(code: addr.districtCode, name: addr.districtName, level: "3", parentCode: nil)
//            pickView.town = FKYAddressItemModel(code: addr.avenu_code, name: addr.avenu_name, level: "4", parentCode: nil)
//        }
        // 选择完成
        pickView.selectOverClosure = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.editAddress.provinceName = pickView.province?.name
            strongSelf.viewModel.editAddress.provinceCode = pickView.province?.code
            strongSelf.viewModel.editAddress.cityName = pickView.city?.name
            strongSelf.viewModel.editAddress.cityCode = pickView.city?.code
            strongSelf.viewModel.editAddress.districtName = pickView.district?.name
            strongSelf.viewModel.editAddress.districtCode = pickView.district?.code
            strongSelf.viewModel.editAddress.avenu_name = pickView.town?.name
            strongSelf.viewModel.editAddress.avenu_code = pickView.town?.code
            
            strongSelf.viewModel.submitParam["bankProvinceId"] = strongSelf.viewModel.editAddress.provinceCode ?? ""
            strongSelf.viewModel.submitParam["bankProvince"] = strongSelf.viewModel.editAddress.provinceName ?? ""
            strongSelf.viewModel.submitParam["bankCity"] = strongSelf.viewModel.editAddress.cityName ?? ""
            strongSelf.viewModel.submitParam["bankCityId"] = strongSelf.viewModel.editAddress.cityCode ?? ""
            
            strongSelf.viewModel.ProcessingData()
            strongSelf.mainTableView.reloadData()
        }
        // loading
        pickView.showLoadingClosure = { [weak self] showFlag in
            guard let strongSelf = self else {
                return
            }
            if showFlag {
                strongSelf.showLoading()
            }
            else {
                strongSelf.dismissLoading()
            }
        }
        // toast
        pickView.showToastClosure = { [weak self] (tip: String?) in
            guard let strongSelf = self else {
                return
            }
            guard let msg = tip, !msg.isEmpty else {
                return
            }
            strongSelf.toast(msg)
        }
        return pickView
    }()
    
    /// 主table
    lazy var mainTableView:UITableView = {
        let tb = UITableView(frame: CGRect.null, style: .grouped)
        tb.delegate = self
        tb.dataSource = self
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 50
        tb.estimatedSectionHeaderHeight = 40
        tb.estimatedSectionFooterHeight = 0
        //tb.separatorStyle = .none
        tb.register(FKYApplyWalfareTableTipCell.self, forCellReuseIdentifier: NSStringFromClass(FKYApplyWalfareTableTipCell.self))
        tb.register(FKYApplyWalfareTableInputCell.self, forCellReuseIdentifier: NSStringFromClass(FKYApplyWalfareTableInputCell.self))
        tb.register(FKYApplyWalfareTableDisplayInfoCell.self, forCellReuseIdentifier: NSStringFromClass(FKYApplyWalfareTableDisplayInfoCell.self))
        tb.register(FKYApplyWalfareSectionHeader.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(FKYApplyWalfareSectionHeader.self))
        tb.backgroundColor = RGBColor(0xF4F4F4)
        return tb
    }()
    
    /// 提交按钮
    lazy var submitView = FKYApplyWalfareTableSubmitView()
    
    /// 导航栏
    fileprivate var navBar: UIView?
    var yflModel : FKYYflInfoModel? //传入模型
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.viewModel.inputInfoModel = self.yflModel ?? FKYYflInfoModel()
        self.viewModel.installData()
        self.viewModel.ProcessingData()
        self.mainTableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
}


//MARK: - 事件响应
extension FKYApplyWalfareTableVC{
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKY_seeMoreBtnClicked {// 查看更多响应事件
            let type = userInfo[FKYUserParameterKey] as! String
            if type == "1" {// 选择收款银行
                let vc = FKYApplyWalfareTableSelectBankVC()
                vc.modalPresentationStyle = .overFullScreen
                vc.selectBankCallBack = {[weak self] (bankName:String,bankID:String) in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.viewModel.submitParam["bankCodeName"] = bankName
                    weakSelf.viewModel.submitParam["bankCode"] = bankID
                    weakSelf.viewModel.inputInfoModel.bankCodeName = bankName
                    weakSelf.viewModel.inputInfoModel.bankCode = bankID
                    weakSelf.viewModel.ProcessingData()
                    weakSelf.mainTableView.reloadData()
                }
                self.present(vc, animated: false) {
                    
                }
            }else if type == "2" {// 选择开户行所在省市
                // 显示地址选择视图
                self.view.bringSubviewToFront(self.addressPickerView!)
                self.addressPickerView!.isHidden = false
                self.addressPickerView!.showWithAnimation()
                self.addressPickerView!.showSelectStatus()
            }
        }else if eventName == FKY_applyWalfareTableEndEditing {// 结束输入
            let inputKeyValue = userInfo[FKYUserParameterKey] as! [String:String]
            let submitKey = inputKeyValue["submitKey"] ?? ""
            let submitValue = inputKeyValue["submitValue"] ?? ""
            if submitKey.isEmpty{// 没有提交的参数
                
            }else if submitKey == "bankUserName" {//银行账户名
                self.viewModel.inputInfoModel.bankUserName = submitValue
                self.viewModel.submitParam[submitKey] = submitValue
            }else if submitKey == "bankNum" {// 收款卡号
                self.viewModel.inputInfoModel.bankNum = submitValue
                self.viewModel.submitParam[submitKey] = submitValue
            }else if submitKey == "bankName" {// 开户支行
                self.viewModel.inputInfoModel.bankName = submitValue
                self.viewModel.submitParam[submitKey] = submitValue
            }else if submitKey == "userName" {// 总店名称
                self.viewModel.inputInfoModel.userName = submitValue
                self.viewModel.submitParam[submitKey] = submitValue
            }else if submitKey == "addr" {// 总店地址
                self.viewModel.inputInfoModel.addr = submitValue
                self.viewModel.submitParam[submitKey] = submitValue
            }else if submitKey == "storeName" {// 总店管理员姓名
                self.viewModel.inputInfoModel.storeName = submitValue
                self.viewModel.submitParam[submitKey] = submitValue
            }else if submitKey == "mobilePhone" {// 总店管理员手机
                self.viewModel.inputInfoModel.mobilePhone = submitValue
                self.viewModel.submitParam[submitKey] = submitValue
            }
            self.viewModel.ProcessingData()
        }else if eventName == FKY_applyWalfareSubmitBtnClicked {// 确定按钮点击
            self.view.endEditing(true)
            self.submitInfo()
            FKYAnalyticsManager.sharedInstance.BI_New_Record("", floorPosition: "", floorName: "", sectionId: "", sectionPosition: "", sectionName: "", itemId: "I6702", itemPosition: "1", itemName:"提交申请", itemContent:"", itemTitle: "", extendParams: ["pageValue":"药福利信息填写"] as [String : AnyObject], viewController: self)
        }
    }
}




//MARK: - UITableView代理
extension FKYApplyWalfareTableVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sectionList[section].cellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = self.viewModel.sectionList[indexPath.section].cellList[indexPath.row]
        if cellModel.cellType == .tipCel{// 提示信息cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYApplyWalfareTableTipCell.self)) as! FKYApplyWalfareTableTipCell
            return cell
        }else if cellModel.cellType == .inputCell{// 输入信息cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYApplyWalfareTableInputCell.self)) as! FKYApplyWalfareTableInputCell
            cell.configCell(cellModel: cellModel)
            return cell
        }else if cellModel.cellType == .displayInfoCell{//展示信息cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYApplyWalfareTableDisplayInfoCell.self)) as! FKYApplyWalfareTableDisplayInfoCell
            cell.configCell(cellModel: cellModel)
            return cell
        }else if cellModel.cellType == .moreSelectCell{// 选择更多cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYApplyWalfareTableInputCell.self)) as! FKYApplyWalfareTableInputCell
            cell.configCell(cellModel: cellModel)
            return cell
        }
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.viewModel.sectionList[section].isHaveSectionHeader{
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(FKYApplyWalfareSectionHeader.self)) as! FKYApplyWalfareSectionHeader
            headerView.configCell(sectionModel: self.viewModel.sectionList[section])
            return headerView
        }
        let view = UIView.init(frame: CGRect.zero)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.viewModel.sectionList[section].isHaveSectionHeader{
            return WH(40)
        }
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
}

//MARK: - 网络请求
extension FKYApplyWalfareTableVC{
    func submitInfo(){
        self.viewModel.submitApplyWalfareTableInfo {[weak self] (isSuccess, Msg) in
            guard let weakSelf = self else{
                return
            }
            
            guard isSuccess else{
                weakSelf.toast(Msg)
                return
            }
            weakSelf.toast("提交成功")
            FKYNavigator.shared()?.pop(toScheme: FKY_RebateInfoController.self)
        }
    }
    
}

//MARK: - UI
extension FKYApplyWalfareTableVC {
    
    func setupUI(){
        self.configNaviBar()
        self.view.backgroundColor = RGBColor(0xFFFFFF)
        self.view.addSubview(self.mainTableView)
        self.view.addSubview(self.submitView)
        
        self.mainTableView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.navBar!.snp_bottom)
            make.bottom.equalTo(self.submitView.snp_top)
        }
        
        var bottomMargin:CGFloat = 0
        if IS_IPHONEX || IS_IPHONEXR || IS_IPHONEXS_MAX{
            bottomMargin = iPhoneX_SafeArea_BottomInset
        }
        
        self.submitView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottomMargin)
        }
        
        self.view.addSubview(self.addressPickerView)
        self.addressPickerView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        self.view.sendSubviewToBack(self.addressPickerView)
        self.addressPickerView.isHidden = true
    }
    
    /// 配置导航栏
    func configNaviBar() {
        self.navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            }else{
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
            }()
        self.fky_setupTitleLabel("药店福利社申请单")
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") {[weak self] () in
            guard self != nil else {
                return
            }
            FKYNavigator.shared().pop()
        }
    }
}
