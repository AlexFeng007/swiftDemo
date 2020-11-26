//
//  SelectInvoiceViewController.swift
//  FKY
//
//  Created by Rabe on 2016/11/10.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  选择发票类型

import Foundation
import RxSwift
import RxCocoa


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class SelectInvoiceViewController: UIViewController {
    //ui属性
    //顶部提示文字
    fileprivate lazy var topTipLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xE8772A)
        label.font = t11.font
        label.textAlignment = .left
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    //顶部提示view
    fileprivate lazy var topTipView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = RGBColor(0xFFFCF1)
        view.isHidden = true
        let topLine = UILabel()
        topLine.backgroundColor = RGBColor(0xFFE1CC)
        view.addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(WH(1))
        }
        
        let bottomLine = UILabel()
        bottomLine.backgroundColor = RGBColor(0xFFE1CC)
        view.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(WH(1))
        }
        
        view.addSubview(self.topTipLabel)
        self.topTipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(WH(10))
            make.right.equalTo(view.snp.right).offset(-WH(10))
            make.top.equalTo(topLine.snp.bottom).offset(WH(9))
            make.bottom.equalTo(bottomLine.snp.top).offset(-WH(9))
        }
        return view
    }()
    //确定按钮
    fileprivate lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("确定", for: UIControlState())
        button.backgroundColor = t73.color
        button.titleLabel?.textColor = t45.color
        button.titleLabel?.font = t73.font
        button.layer.cornerRadius = WH(4)
        button.layer.masksToBounds = true
        _ = button.rx.tap.subscribe({ [weak self] _ in
            if let strongSelf = self {
                strongSelf.saveInVoiceInfoWithParams()
            }
        })
        return button
    }()
    //底部功能按钮
    fileprivate lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = t45.color
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        view.addSubview(viewLine)
        viewLine.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(WH(1))
        })
        return view
    }()
    fileprivate lazy var selectTableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .grouped)
        tableV.backgroundColor = RGBColor(0xF4F4F4)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.estimatedRowHeight = WH(150) //最多五行促销商品
        tableV.rowHeight = UITableView.automaticDimension // 设置高度自适应
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(FKYInvoiceTypeTableViewCell.self, forCellReuseIdentifier: "FKYInvoiceTypeTableViewCell")
        tableV.register(FKYShopMainContentsTableViewCell.self, forCellReuseIdentifier: "FKYShopMainContentsTableViewCell_invoice")
        tableV.register(FKYOpenInvoiceMoreTableViewCell.self, forCellReuseIdentifier: "FKYOpenInvoiceMoreTableViewCell")
        tableV.register(FKYInvoiceInputTableViewCell.self, forCellReuseIdentifier: "FKYInvoiceInputTableViewCell")
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    var navBar : UIView?
    //需要上个界面传入
    var saveInvoiceModelSuccessBlock : ((InvoiceModel)->(Void))? //保存发票成功
    //属性
    var selectedIndexNum = 0 //选择第几个按钮
    // 2-增值税普通发票 3-增值税电子普通发票 1-增值税专用发票
    var invoiceDataArr = [Int]()
    var desTip = "" //发票头部提示
    var isSelfShop = false //默认不是自营(mp商家不请求接口，只有类型)
    var canChangeNameAndNum = true //判断是否能修改企业名称或者纳税号
    var canChangeOtherNum = true //判断是否能修其他信息
    //当前发票类型
    fileprivate var invoiceTypeIndex:Int{
        get {
            if self.invoiceDataArr.count > 0 {
                return self.invoiceDataArr[self.selectedIndexNum]
            }
            return 2
        }
    }
    fileprivate var isOpenList = false //普通发票是否展开了注册地址
    fileprivate var commonInvoiceModel : FKYInvoiceModel? // 纸质普通发票和电子普通发票
    fileprivate var professionInvoiceModel : FKYInvoiceModel? // 专用发票
    fileprivate var isNotInputInfo = false
    //生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationView()
        self.setContentView()
        self.requestInvoiceInfoWihtTypeNum()
    }
    deinit {
        print(" SelectInvoiceViewController deinit~!@")
    }
}
//ui相关
extension SelectInvoiceViewController {
    func setNavigationView() {
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
        self.fky_setupTitleLabel("选择发票类型")
        self.fky_hiddedBottomLine(false)
    }
    func setContentView() {
        self.view.backgroundColor = bg5
        if isSelfShop == true {
            //自营商家
            self.view.addSubview(self.bottomView)
            self.bottomView.snp.makeConstraints { (make) in
                make.bottom.right.left.equalTo(self.view)
                make.height.equalTo(WH(62)+bootSaveHeight())
            }
            self.bottomView.addSubview(self.confirmButton)
            self.confirmButton.snp.makeConstraints { (make) in
                make.left.equalTo(self.bottomView.snp.left).offset(WH(30))
                make.right.equalTo(self.bottomView.snp.right).offset(-WH(30))
                make.top.equalTo(self.bottomView.snp.top).offset(WH(10))
                make.height.equalTo(WH(42))
            }
            self.view.addSubview(self.topTipView)
            self.topTipView.snp.makeConstraints { (make) in
                make.top.equalTo(self.navBar!.snp.bottom)
                make.right.left.equalTo(self.view)
                make.height.equalTo(0)
            }
            self.view.addSubview(self.selectTableView)
            self.selectTableView.snp.makeConstraints { (make) in
                make.top.equalTo(self.topTipView.snp.bottom)
                make.right.left.equalTo(self.view)
                make.bottom.equalTo(self.bottomView.snp.top)
            }
        }else {
            //mp商家
            self.view.addSubview(self.selectTableView)
            self.selectTableView.snp.makeConstraints { (make) in
                make.top.equalTo(self.navBar!.snp.bottom)
                make.bottom.right.left.equalTo(self.view)
            }
        }
    }
}
extension SelectInvoiceViewController {
    
}
//MARK:数据请求相关
extension SelectInvoiceViewController {
    //请求发票信息接口
    fileprivate func requestInvoiceInfoWihtTypeNum() {
        if isSelfShop == false{
            return
        }
        //如果有数据了，就不再重复请求
        if self.invoiceTypeIndex == 1 {
            if let model = self.professionInvoiceModel {
                self.resetTopviewTipDes(model)
                self.selectTableView.reloadData()
                return
            }
        }else {
            if let model = self.commonInvoiceModel {
                self.resetTopviewTipDes(model)
                model.billType = self.invoiceTypeIndex
                self.selectTableView.reloadData()
                return
            }
        }
        let params = ["type":"\(self.invoiceTypeIndex)","source":"2"]
        FKYRequestService.sharedInstance()?.requestForInvoiceInfo(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                strongSelf.toast(msg)
                return
            }
            if let infoModel = model as? FKYInvoiceModel {
                //电子普票与纸质普票共用模型
                if strongSelf.invoiceTypeIndex == 1 {
                    strongSelf.professionInvoiceModel = infoModel
                }else {
                    strongSelf.commonInvoiceModel = infoModel
                    if infoModel.registeredAddress.count > 0 {
                        strongSelf.isOpenList = true
                    }
                }
                strongSelf.resetTopviewTipDes(infoModel)
            }
            strongSelf.selectTableView.reloadData()
        })
    }
    //保存发票信息业务处理
    fileprivate func saveInVoiceInfoWithParams()  {
        var infoDesModel : FKYInvoiceModel?
        if self.invoiceTypeIndex == 1 {
            //专用发票
            if let infoModel = self.professionInvoiceModel {
                infoDesModel = infoModel
            }
        }else {
            //电子普票和纸质普票
            if let infoModel = self.commonInvoiceModel {
                infoDesModel = infoModel
            }
        }
        if let infoModel = infoDesModel {
            //设置是否能修改的条件
            self.getSatusWithCanChange(infoModel)
            if self.canChangeNameAndNum == true {
                //企业名称和纳税人识别号能修改(每次都请求)
                if self.valitedParam(infoModel) == true {
                    return
                }
                self.saveRequestData(infoModel)
            }else {
                if self.canChangeOtherNum == false {
                    //企业名称和纳税人识别号,基本信息不能修改
                    let desModel = InvoiceModel.changeModelWithOtherModel(infoModel)
                    if let block = self.saveInvoiceModelSuccessBlock {
                        block(desModel)
                    }
                    FKYNavigator.shared().pop()
                }else{
                    if self.invoiceTypeIndex == 1 {
                        //专票
                        if self.valitedParam(infoModel) == true {
                            return
                        }
                        self.saveRequestData(infoModel)
                    }else {
                        //普票
                        if self.isOpenList == false {
                            let desModel = InvoiceModel.changeModelWithOtherModel(infoModel)
                            if let block = self.saveInvoiceModelSuccessBlock {
                                block(desModel)
                            }
                            FKYNavigator.shared().pop()
                        }else {
                            if self.valitedParam(infoModel) == true {
                                return
                            }
                            //展开了，但是未输入任何信息
                            if self.isNotInputInfo == true {
                                let desModel = InvoiceModel.changeModelWithOtherModel(infoModel)
                                if let block = self.saveInvoiceModelSuccessBlock {
                                    block(desModel)
                                }
                                FKYNavigator.shared().pop()
                            }else {
                                self.saveRequestData(infoModel)
                            }
                        }
                    }
                }
            }
        }else {
            self.toast("发票信息不存在")
        }
    }
    //请求数据
    fileprivate func saveRequestData(_ infoModel:FKYInvoiceModel ) {
        let params = infoModel.reverseSaveJSON()
        self.showLoading()
        FKYRequestService.sharedInstance()?.requestForSaveInvoiceInfo(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "保存失败"
                strongSelf.toast(msg)
                return
            }
            let desModel = InvoiceModel.changeModelWithOtherModel(infoModel)
            if let block = strongSelf.saveInvoiceModelSuccessBlock {
                block(desModel)
            }
            FKYNavigator.shared().pop()
        })
    }
}
//MARK:弹框及更新逻辑相关
extension SelectInvoiceViewController {
    fileprivate func popTipDes() {
        let alert = COAlertView.init(frame: CGRect.zero)
        alert.configView("订单完成后商家会分别单独开具发票，如果开票类型不一致，请单独提交结算。", "", "", "知道了", .oneBtn)
        alert.showAlertView()
        //        alert.doneBtnActionBlock = {
        //            // 确定
        //        }
    }
    //刷新顶部提示文字
    fileprivate func resetTopviewTipDes(_ model :FKYInvoiceModel?) {
        if let desModel = model ,desModel.topMsg.count > 0 {
            //有提示
            UIView.animate(withDuration: 0.3) { [weak self] in
                if let strongSelf = self {
                    strongSelf.topTipView.isHidden = false
                    strongSelf.topTipView.snp.remakeConstraints { (make) in
                        make.top.equalTo(strongSelf.navBar!.snp.bottom)
                        make.right.left.equalTo(strongSelf.view)
                    }
                }
            }
            self.topTipLabel.text = desModel.topMsg
            self.fky_hiddedBottomLine(true)
        }else {
            UIView.animate(withDuration: 0.3) { [weak self] in
                if let strongSelf = self {
                    strongSelf.topTipView.isHidden = true
                    strongSelf.topTipView.snp.remakeConstraints { (make) in
                        make.top.equalTo(strongSelf.navBar!.snp.bottom)
                        make.right.left.equalTo(strongSelf.view)
                        make.height.equalTo(0)
                    }
                }
            }
            self.fky_hiddedBottomLine(false)
            self.topTipLabel.text = ""
        }
    }
    fileprivate func valitedParam(_ model:FKYInvoiceModel) -> Bool {
        if self.canChangeNameAndNum == true {
            if model.enterpriseName.count == 0 {
                self.toast("企业名称不能为空")
                return true
            }
            if model.enterpriseName.count > 200 {
                self.toast("企业名称最长200个字符")
                return true
            }
            if model.taxpayerIdentificationNumber.count == 0 {
                self.toast("纳税人识别号不能为空")
                return true
            }
            if model.taxpayerIdentificationNumber.count != 15 && model.taxpayerIdentificationNumber.count != 18 && model.taxpayerIdentificationNumber.count != 20 {
                self.toast("纳税人识别号只能是15或18或20位字符")
                return true
            }
        }
        if self.invoiceTypeIndex == 1 {
            if model.registeredAddress.count == 0 {
                self.toast("注册地址不能为空")
                return true
            }
            if model.registeredAddress.count > 200 {
                self.toast("注册地址最长200个字符")
                return true
            }
            if model.registeredTelephone.count == 0 {
                self.toast("注册电话不能为空")
                return true
            }
            if model.registeredTelephone.count > 30 {
                self.toast("注册电话最长30个字符")
                return true
            }
            if model.bankTypeVO.name.count == 0 {
                self.toast("银行类型不能为空")
                return true
            }
            if model.openingBank.count == 0 {
                self.toast("开户银行不能为空")
                return true
            }
            if model.openingBank.count > 100 {
                self.toast("开户银行最长100个字符")
                return true
            }
            if model.bankAccount.count == 0 {
                self.toast("银行账号不能为空")
                return true
            }
            if model.bankAccount.count > 50 {
                self.toast("银行账号最长50个字符")
                return true
            }
        }else {
            if isOpenList == true {
                var tipArr = [String]()
                if model.registeredAddress.count == 0 {
                    tipArr.append("注册地址")
                }
                if model.registeredTelephone.count == 0 {
                    tipArr.append("注册电话")
                }
                if model.bankTypeVO.name.count == 0 {
                    tipArr.append("银行类型")
                }
                if model.openingBank.count == 0 {
                    tipArr.append("开户银行")
                }
                if model.bankAccount.count == 0 {
                    tipArr.append("银行账号")
                }
                if tipArr.count > 0 && tipArr.count != 5 {
                    let tipStr = tipArr.joined(separator: "、")
                    self.popParamtipStr(tipStr, model)
                    return true
                }
                self.isNotInputInfo = (tipArr.count == 5 ? true : false)
                if tipArr.count != 5 {
                    if model.registeredAddress.count > 200 {
                        self.toast("注册地址最长200个字符")
                        return true
                    }
                    if model.registeredTelephone.count > 30 {
                        self.toast("注册电话最长30个字符")
                        return true
                    }
                    if model.openingBank.count > 100 {
                        self.toast("开户银行最长100个字符")
                        return true
                    }
                    if model.bankAccount.count > 50 {
                        self.toast("银行账号最长50个字符")
                        return true
                    }
                }
            }
        }
        return false
    }
    fileprivate func popParamtipStr(_ str:String,_ infoModel:FKYInvoiceModel) {
        let alert = COAlertView.init(frame: CGRect.zero)
        alert.configView("您的\(str)尚未维护，普票上将无法打印地址、电话，开户行及账号。", "取消", "确定", "", .twoBtn)
        alert.showAlertView()
        alert.rightBtnActionBlock = { [weak self] in
            // 确定
            guard let strongSelf = self else {
                return
            }
            if strongSelf.canChangeNameAndNum == true {
                strongSelf.saveRequestData(infoModel)
            }else{
                let desModel = InvoiceModel.changeModelWithOtherModel(infoModel)
                if let block = strongSelf.saveInvoiceModelSuccessBlock {
                    block(desModel)
                }
                FKYNavigator.shared().pop()
            }
        }
    }
    ///弹出银行选择框
    fileprivate func presentBankVC(){
        let bankVC = FKYSelectBankVC()
        bankVC.modalPresentationStyle = .overCurrentContext;
        bankVC.selectBank = { [weak self] (bank) in
            guard let strongSelf = self else{
                return
            }
            if strongSelf.invoiceTypeIndex == 1 {
                //专用发票
                if let infoModel = strongSelf.professionInvoiceModel {
                    infoModel.bankTypeVO = bank
                }
            }else {
                //电子普票和纸质普票
                if let infoModel = strongSelf.commonInvoiceModel {
                    infoModel.bankTypeVO = bank
                }
            }
            strongSelf.selectTableView.reloadData()
        }
        self.present(bankVC, animated: true) {
            
        }
    }
    //判断是否能修改
    fileprivate func getSatusWithCanChange(_ model :FKYInvoiceModel){
        //质管发货审核审核通过
        if model.deliverStatus == 1 {
            //判断企业名称和纳税人识别号
            if model.branchSwitch == 1 {
                //能修改
                self.canChangeNameAndNum = true
            }else {
                //不能修改
                self.canChangeNameAndNum = false
            }
            //判断基本信息是否能修改（除企业名称和纳税人识别号）
            if model.billStatus == 1 {
                //都不允许更改
                self.canChangeOtherNum = false
            }else {
                //都允许修改
                self.canChangeOtherNum = true
            }
        }else {
            //质管发货审核审核未通过
            //判断企业名称和纳税人识别号，基本信息是否能修改
            if model.billStatus == 1 {
                //都不允许更改
                self.canChangeNameAndNum = false
                self.canChangeOtherNum = false
            }else {
                //都允许修改
                self.canChangeNameAndNum = true
                self.canChangeOtherNum = true
            }
        }
    }
}
//MARK:UITableViewDataSource,UITableViewDelegate代理相关
extension SelectInvoiceViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.rowHeight
        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                return WH(38)
            }else if indexPath.row == 1 {
                return WH(42)
            }else if indexPath.row == 2 {
                if self.invoiceTypeIndex != 1  {
                    //纸质普通发票
                    if self.isOpenList == false {
                        return WH(22)
                    }
                }
            }else if indexPath.row == 3 {
                if self.invoiceTypeIndex != 1 ,let infoModel = self.commonInvoiceModel, infoModel.midMsg.count > 0 {
                    //电子普通发票
                    return tableView.rowHeight
                }
            }else {
                return WH(40)
            }
        }else if indexPath.section == 2{
            if self.invoiceTypeIndex == 1 {
                //专用发票
                if let infoModel = self.professionInvoiceModel,infoModel.bottomMsg.count > 0 {
                    return tableView.rowHeight
                }
            }else {
                //电子普票和纸质普票
                if let infoModel = self.commonInvoiceModel,infoModel.bottomMsg.count > 0 {
                    return tableView.rowHeight
                }
            }
        }
        return WH(0.001)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSelfShop == false{
            return 1
        }
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            if self.invoiceTypeIndex != 1 {
                //纸质普通发票
                if self.isOpenList == false {
                    return 3
                }
            }
            return 9
        }else if section == 2 {
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: FKYInvoiceTypeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYInvoiceTypeTableViewCell", for: indexPath) as! FKYInvoiceTypeTableViewCell
            if isSelfShop == false || self.invoiceTypeIndex == 1 {
                cell.configInvoiceTypeData(self.invoiceDataArr,self.selectedIndexNum,"")
            }else {
                cell.configInvoiceTypeData(self.invoiceDataArr,self.selectedIndexNum,self.desTip)
            }
            //选择发票类型回调
            cell.clickTypeBtnBlock = {[weak self] indexNum in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.selectedIndexNum = indexNum
                if  strongSelf.isSelfShop == false {
                    //mp商家只有类型，选择后直接回去
                    let desModel = InvoiceModel.init(billType: "\(strongSelf.invoiceTypeIndex)")
                    if let block = strongSelf.saveInvoiceModelSuccessBlock {
                        block(desModel)
                    }
                    FKYNavigator.shared().pop()
                }else {
                    //自营商家逻辑
                    strongSelf.requestInvoiceInfoWihtTypeNum()
                }
            }
            //选择提示回调
            cell.clickTipBlock = {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.popTipDes()
            }
            return cell
        }else if indexPath.section == 2 {
            let cell: FKYShopMainContentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYShopMainContentsTableViewCell_invoice", for: indexPath) as! FKYShopMainContentsTableViewCell
            if self.invoiceTypeIndex == 1 {
                //专用发票
                if let infoModel = self.professionInvoiceModel {
                    cell.configInvoiceAttentionTabelCellData(infoModel.bottomMsg)
                }else {
                    cell.configInvoiceAttentionTabelCellData("")
                }
            }else {
                //电子普票和纸质普票
                if let infoModel = self.commonInvoiceModel {
                    cell.configInvoiceAttentionTabelCellData(infoModel.bottomMsg)
                }else {
                    cell.configInvoiceAttentionTabelCellData("")
                }
            }
            return cell
        }else{
            if indexPath.row == 2 {
                //填写其他信息
                let cell: FKYOpenInvoiceMoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYOpenInvoiceMoreTableViewCell", for: indexPath) as! FKYOpenInvoiceMoreTableViewCell
                cell.clickOpenBlock = {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.isOpenList = true
                    strongSelf.selectTableView.reloadData()
                }
                cell.isHidden = true
                if self.invoiceTypeIndex != 1  {
                    //纸质普通发票
                    if self.isOpenList == false {
                        cell.isHidden = false
                    }
                }
                return cell
                
            }else if indexPath.row == 3 {
                //相关法规
                let cell: FKYShopMainContentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYShopMainContentsTableViewCell_invoice", for: indexPath) as! FKYShopMainContentsTableViewCell
                if self.invoiceTypeIndex != 1 {
                    if let infoModel = self.commonInvoiceModel {
                        cell.configInvoiceRuleTabelCellData(infoModel.midMsg)
                    }else {
                        cell.configInvoiceRuleTabelCellData("")
                    }
                }else {
                    cell.configInvoiceRuleTabelCellData("")
                }
                return cell
            }else{
                let cell: FKYInvoiceInputTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYInvoiceInputTableViewCell", for: indexPath) as! FKYInvoiceInputTableViewCell
                //银行类型选择
                cell.clickTapBlock = {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.presentBankVC()
                }
                var infoDesModel : FKYInvoiceModel?
                if self.invoiceTypeIndex == 1 {
                    //专用发票
                    if let infoModel = self.professionInvoiceModel {
                        infoDesModel = infoModel
                    }
                }else {
                    //电子普票和纸质普票
                    if let infoModel = self.commonInvoiceModel {
                        infoDesModel = infoModel
                    }
                }
                if indexPath.row == 0 {
                    //企业名称
                    cell.configInvoiceInput("*企业名称", indexPath.row, infoDesModel)
                }else if  indexPath.row == 1 {
                    //纳税人识别号
                    cell.configInvoiceInput("*纳税人识别号", indexPath.row, infoDesModel)
                }else if indexPath.row == 4 {
                    //注册地址
                    let titleStr = (self.invoiceTypeIndex == 1 ? "*注册地址" : "注册地址")
                    cell.configInvoiceInput(titleStr, indexPath.row, infoDesModel)
                }else if indexPath.row == 5 {
                    //注册电话
                    let titleStr = (self.invoiceTypeIndex == 1 ? "*注册电话" : "注册电话")
                    cell.configInvoiceInput(titleStr, indexPath.row, infoDesModel)
                }else if indexPath.row == 6 {
                    //银行类型
                    let titleStr = (self.invoiceTypeIndex == 1 ? "*银行类型" : "银行类型")
                    cell.configInvoiceInput(titleStr, indexPath.row, infoDesModel)
                }else if indexPath.row == 7 {
                    //开户银行
                    let titleStr = (self.invoiceTypeIndex == 1 ? "*开户银行" : "开户银行")
                    cell.configInvoiceInput(titleStr, indexPath.row, infoDesModel)
                }else if indexPath.row == 8 {
                    //银行账号
                    let titleStr = (self.invoiceTypeIndex == 1 ? "*银行账号" : "银行账号")
                    cell.configInvoiceInput(titleStr, indexPath.row, infoDesModel)
                }
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return WH(10)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spaceView = UIView()
        spaceView.backgroundColor = RGBColor(0xF4F4F4)
        return spaceView
    }
}
