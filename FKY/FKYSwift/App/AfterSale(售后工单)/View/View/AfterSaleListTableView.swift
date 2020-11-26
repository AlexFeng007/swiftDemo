//
//  AfterSaleListTableView.swift
//  FKY
//
//  Created by 寒山 on 2019/5/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class AfterSaleListTableView: UIView {
    var calcelRCOrderBlock: ((ASApplyListInfoModel)->())?// 取消申请
    var inputSendInfoBlock: ((ASApplyListInfoModel)->())?// 填写回寄信息
    var dataSource: Array<ASApplyListInfoModel> = []  //数据
    var orderModel: FKYOrderModel?
    //空视图
    fileprivate lazy var emptyView: ASListEmptyView = { [weak self] in
        let view = ASListEmptyView()
        view.isHidden = true
        return view
        }()
    public lazy var tableView: UITableView  = { [weak self] in
        var tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(RCListProductListCell.self, forCellReuseIdentifier: "RCListProductListCell")
        tableView.register(RCListProductSingleCell.self, forCellReuseIdentifier: "RCListProductSingleCell")
        tableView.register(RCListHeaderViewCell.self, forCellReuseIdentifier: "RCListHeaderViewCell")
        tableView.register(RCLFooterViewCell.self, forCellReuseIdentifier: "RCLFooterViewCell")
        tableView.register(ASListStatusHeaderCell.self, forCellReuseIdentifier: "ASListStatusHeaderCell")
        tableView.register(ASOrderStatusDetailCell.self, forCellReuseIdentifier: "ASOrderStatusDetailCell")
        tableView.register(ASListStatusFooterCell.self, forCellReuseIdentifier: "ASListStatusFooterCell")
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0//WH(213)
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
        }()
    
    init() {
        super.init(frame: CGRect.null)
        backgroundColor =  RGBColor(0xF4F4F4)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpView(){
        self.addSubview(tableView)
        self.addSubview(emptyView)
        
        emptyView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(self)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-bootSaveHeight())
        }
        tableView.reloadData()
    }
    func configData(_ viewModel:AfterSaleViewModel) {
        self.dataSource.removeAll()
        self.dataSource = viewModel.applyList
        self.tableView.reloadData()
        if self.dataSource.isEmpty == true{
            self.tableView.isHidden = true
            self.emptyView.isHidden = false
        }else{
            self.tableView.isHidden = false
            self.emptyView.isHidden = true
        }
    }
}
extension AfterSaleListTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model:ASApplyListInfoModel = self.dataSource[section]
        if model.firstTypeId == ASTypeECode.ASType_Bill.rawValue || model.firstTypeId == ASTypeECode.ASType_EnterpriceReport.rawValue{
            return 2
        }else if model.firstTypeId == ASTypeECode.ASType_RC.rawValue || model.firstTypeId == ASTypeECode.ASType_RC.rawValue || model.firstTypeId == ASTypeECode.ASType_WrongNum.rawValue || model.firstTypeId == ASTypeECode.ASType_DrugReport.rawValue || model.firstTypeId == ASTypeECode.ASType_ProductReport.rawValue{
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model:ASApplyListInfoModel = self.dataSource[indexPath.section]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ASListStatusHeaderCell", for: indexPath) as! ASListStatusHeaderCell
            cell.selectionStyle = .none
            cell.configView(model)
            return cell
        }
        if model.firstTypeId == ASTypeECode.ASType_RC.rawValue || model.firstTypeId == ASTypeECode.ASType_R.rawValue {
            if indexPath.row == 1 {
                guard let list = model.productList, list.count > 0 else {
                    return UITableViewCell.init()
                }
                if list.count == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RCListProductSingleCell", for: indexPath) as! RCListProductSingleCell
                    cell.selectionStyle = .none
                    cell.configASView(model.productList![0])
                    return cell
                } else if list.count > 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RCListProductListCell", for: indexPath) as! RCListProductListCell
                    cell.selectionStyle = .none
                    cell.configASCell(model)
                    return cell
                }
            }else if indexPath.row == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "RCLFooterViewCell", for: indexPath) as! RCLFooterViewCell
                cell.selectionStyle = .none
                cell.configASView(model)
                // 撤消申请
                cell.cancelHandle = { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    FKYProductAlertView.showNewAlertView(withTitle: nil, leftTitle: "是", rightTitle: "否", message: "是否撤销该申请？", dismiss: false, handler: { (_, isRight) in
                        if !isRight {
                            if strongSelf.calcelRCOrderBlock != nil{
                                strongSelf.calcelRCOrderBlock!(model)
                            }
                        }
                    })
                }
                // 回寄信息（按钮已被屏蔽）
                cell.jumpHandle = { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    if strongSelf.inputSendInfoBlock != nil{
                        strongSelf.inputSendInfoBlock!(model)
                    }
                }
                return cell
            }
        }else  if model.firstTypeId == ASTypeECode.ASType_WrongNum.rawValue || model.firstTypeId == ASTypeECode.ASType_DrugReport.rawValue || model.firstTypeId == ASTypeECode.ASType_ProductReport.rawValue{
            if indexPath.row == 1 {
                guard let list = model.productList, list.count > 0 else {
                    return UITableViewCell.init()
                }
                if list.count == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RCListProductSingleCell", for: indexPath) as! RCListProductSingleCell
                    cell.selectionStyle = .none
                    if model.firstTypeId == ASTypeECode.ASType_WrongNum.rawValue{
                        cell.configWrongNumView(model.productList![0])
                    }else{
                        cell.configASView(model.productList![0])
                    }
                    return cell
                } else if list.count > 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RCListProductListCell", for: indexPath) as! RCListProductListCell
                    cell.selectionStyle = .none
                    cell.configASCell(model)
                    return cell
                }
            }else if indexPath.row == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ASOrderStatusDetailCell", for: indexPath) as! ASOrderStatusDetailCell
                cell.selectionStyle = .none
                cell.configView(model)
                return cell
            }
        }else if model.firstTypeId == ASTypeECode.ASType_Bill.rawValue || model.firstTypeId == ASTypeECode.ASType_EnterpriceReport.rawValue{
            if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ASListStatusFooterCell", for: indexPath) as! ASListStatusFooterCell
                cell.selectionStyle = .none
                cell.configView(model)
                return cell
            }
        }
        return UITableViewCell.init()
    }
}

extension AfterSaleListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model:ASApplyListInfoModel = self.dataSource[indexPath.section]
        if indexPath.row == 0 {
            return WH(51)
        }
        if model.firstTypeId == ASTypeECode.ASType_RC.rawValue{
            if indexPath.row == 1 {
                guard let list = model.productList, list.count > 0 else {
                    return 0.0
                }
                return WH(95)
            }else if indexPath.row == 2{
                if Int(model.status!) == 0 {
                    return WH(41+54)
                }
                return WH(41)
            }
        }else if model.firstTypeId == ASTypeECode.ASType_RC.rawValue || model.firstTypeId == ASTypeECode.ASType_WrongNum.rawValue || model.firstTypeId == ASTypeECode.ASType_DrugReport.rawValue || model.firstTypeId == ASTypeECode.ASType_ProductReport.rawValue{
            if indexPath.row == 1 {
                guard let list = model.productList, list.count > 0 else {
                    return 0.0
                }
                return WH(95)
            }else if indexPath.row == 2{
                return WH(41)
            }
        }else if model.firstTypeId == ASTypeECode.ASType_Bill.rawValue || model.firstTypeId == ASTypeECode.ASType_EnterpriceReport.rawValue{
            if indexPath.row == 1 {
                if model.status == ASApplyStatus.ASApplyStatus_Complete.rawValue{
                    let str = model.completeContent
                    let mjContentLabelH =  str!.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(36), height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t23.font], context: nil).height
                    return mjContentLabelH + WH(78)
                }else if model.status == ASApplyStatus.ASApplyStatus_Dealing.rawValue || model.status == ASApplyStatus.ASApplyStatus_Wait.rawValue{
                    return WH(36)
                }
            }
        }
        
        return 0.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model:ASApplyListInfoModel = self.dataSource[indexPath.section]
        var urlStr = ""
        if let orderM = self.orderModel , orderM.isZiYingFlag == 1{
            if model.firstTypeId == ASTypeECode.ASType_RC.rawValue{
                // 1 售后（退换货）
                urlStr = " https://m.yaoex.com/h5/rma/index.html#/getOcsRmaDetail?applyId=\(model.assId ?? 0)&orderId=\(model.orderChildNo ?? "")"
            }else{
                //2 工单
                urlStr = "https://m.yaoex.com/h5/rma/index.html#/workOrderDetail?assId=\(model.assId ?? 0)"
            }
        }else {
            // 1 mp退货
            urlStr = " https://m.yaoex.com/h5/rma/index.html#/getMpOcsRmaDetail?orderId=\(model.rmaNo ?? "")"
        }
        
        FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
            let v = vc as! GLWebVC
            v.urlPath = urlStr
        }, isModal: false)
    }
}
