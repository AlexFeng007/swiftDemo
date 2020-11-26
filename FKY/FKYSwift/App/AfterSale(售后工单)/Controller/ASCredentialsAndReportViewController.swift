//
//  ASCredentialsAndReportViewController.swift
//  FKY
//
//  Created by hui on 2019/5/8.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class ASCredentialsAndReportViewController: UIViewController {
    //ui属性
    fileprivate lazy var navBar: UIView = {
        if let _ = self.NavigationBar {
            //
        }
        else {
            self.fky_setupNavBar()
        }
        self.NavigationBar?.backgroundColor = bg1
        return self.NavigationBar!
    }()
    // 底部视图...<提交>
    fileprivate lazy var viewBottom: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(62)))
        view.backgroundColor = RGBColor(0xF2F2F2)
        // 按钮
        view.addSubview(self.btnDone)
        self.btnDone.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(WH(10))
            make.right.equalTo(view.snp.right).offset(-WH(10))
            make.top.equalTo(view.snp.top).offset(WH(10))
            make.height.equalTo(WH(42))
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
            strongSelf.submitAsWorkOrderForB2BTypeDetail()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    fileprivate lazy var reportTableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .grouped)
        tableV.backgroundColor = RGBColor(0xF4F4F4)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(ASProblemListCell.self, forCellReuseIdentifier: "ASProblemListCell_report")
        tableV.register(ASProductReportTableViewCell.self, forCellReuseIdentifier: "ASProductReportTableViewCell_report")
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    //MARK:传入属性
    var soNo: String?
    var typeId: Int?
    var typeName :String? //上个界面的标题
    var asBaseInfo: ASAplyBaseInfoModel? //工单基本信息
    // 当前默认选择索引...<默认选中>
    var selectedIndex = -1
    //MARK:生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.queryDataList()
    }
    deinit {
        print("ASCredentialsAndReportViewController deinit")
    }
}
//MARK:UI初始化
extension ASCredentialsAndReportViewController{
    func setupView(){
        view.backgroundColor = RGBColor(0xF4F4F4)
        if self.typeId == ASTypeECode.ASType_DrugReport.rawValue {
            fky_setupTitleLabel("选择药检报告服务")
        }else{
            fky_setupTitleLabel("选择首营资质服务")
        }
        fky_hiddedBottomLine(false)
        fky_setupLeftImage("icon_back_new_red_normal"){
            FKYNavigator.shared().pop()
        }
        self.view.addSubview(viewBottom)
        viewBottom.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(WH(62)+bootSaveHeight())
        })
        self.view.addSubview(reportTableView)
        reportTableView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.navBar.snp.bottom)
            make.bottom.equalTo(viewBottom.snp.top)
        })
    }
}
//MARK:请求数据
extension ASCredentialsAndReportViewController {
    func submitAsWorkOrderForB2BTypeDetail(){
        var param = Dictionary<String, Any>()
        param["soNo"] = self.soNo
        param["customerId"] = FKYLoginAPI.currentUser().ycenterpriseId ?? ""
        if self.selectedIndex == -1 {
            self.toast("请选择\(typeName ?? "")售后服务类型")
            return
        }
        var productTitleStr = ""
        if self.selectedIndex != -1, let typeModel = self.asBaseInfo?.typeList?[self.selectedIndex] {
            param["serviceTypeId"] = typeModel.typeId
            productTitleStr = typeModel.typeName ?? ""
        }
        var goodsInfoStr = ""
        if let arr =  self.asBaseInfo?.productList {
            for productModel in arr {
                if productModel.isSelected == true {
                    if goodsInfoStr.count > 0 {
                        goodsInfoStr = goodsInfoStr + ",\(productModel.orderDetailId ?? 0)"
                    }else{
                        goodsInfoStr = "\(productModel.orderDetailId ?? 0)"
                    }
                }
            }
        }
        if goodsInfoStr.count == 0 {
            self.toast("请选择\(productTitleStr)的商品")
            return
        }else{
            param["goodsInfo"] = goodsInfoStr
        }
        
        self.showLoading()
        FKYRequestService.sharedInstance()?.saveAsWorkOrderForB2BTypeDetail(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                strongSelf.toast(msg)
                return
            }
            let alert = COAlertView.init(frame: CGRect.zero)
            alert.configView("您申请的售后服务已提交，我们会在1-2个工作日为您处理完成并将结果反馈给您。再次感谢您的支持！", "", "", "确定", .oneBtn)
            alert.showAlertView()
            alert.doneBtnActionBlock = {
                NotificationCenter.default.post(name: NSNotification.Name.FKYRefreshAS, object: self, userInfo: nil)
                FKYNavigator.shared().pop()
            }
        })
    }
    
    func queryDataList() {
        var param = Dictionary<String, Any>()
        param["orderNo"] = self.soNo
        param["typeId"] = self.typeId
        
        self.showLoading()
        FKYRequestService.sharedInstance()?.getAsWorkOrderBaseInfo(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                strongSelf.toast(msg)
                return
            }
            // 请求成功
            if let data = response as? NSDictionary {
                strongSelf.asBaseInfo = data.mapToObject(ASAplyBaseInfoModel.self)
                strongSelf.reportTableView.reloadData()
            }
        })
    }
}

//MARK:UITableViewDelegate and UITableViewDataSource代理
extension ASCredentialsAndReportViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = self.asBaseInfo {
            if self.selectedIndex == -1 {
                return 1
            }
            return 3
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let arr = self.asBaseInfo?.typeList {
                return arr.count
            }else{
                return 0
            }
        }else if section == 1  {
            return 1
        }else{
            if let arr = self.asBaseInfo?.productList {
                return arr.count
            }else{
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //原因和标题
        if indexPath.section == 0 || indexPath.section == 1 {
            let cell: ASProblemListCell = tableView.dequeueReusableCell(withIdentifier: "ASProblemListCell_report", for: indexPath) as! ASProblemListCell
            cell.resetBottomLineLayout()
            if indexPath.section == 0 {
                if let typeModel = self.asBaseInfo?.typeList?[indexPath.row] {
                    cell.configCell(typeModel.typeName)
                    cell.setSelectedStatus(indexPath.row == self.selectedIndex)
                    cell.selectBlock = { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.selectedIndex = indexPath.row
                        strongSelf.reportTableView.reloadData()
                    }
                }
                if indexPath.row == 0 {
                    cell.showTopLine(true)
                }else{
                    cell.showTopLine(false)
                }
            }else{
                //标题
                if self.selectedIndex != -1, let typeModel = self.asBaseInfo?.typeList?[self.selectedIndex] {
                    cell.configTitleCell("选择\(typeModel.typeName ?? "")的商品")
                    cell.showTopLine(true)
                }
            }
            return cell
        }else{
            //商品
            let cell: ASProductReportTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ASProductReportTableViewCell_report", for: indexPath) as! ASProductReportTableViewCell
            if let productModel = self.asBaseInfo?.productList?[indexPath.row] {
                cell.configCell(productModel)
                cell.setSelectedStatus(productModel.isSelected)
                cell.selectBlock = { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    productModel.isSelected = !productModel.isSelected
                    strongSelf.reportTableView.reloadData()
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.selectedIndex = indexPath.row
        }
        if indexPath.section == 2 {
            if let productModel = self.asBaseInfo?.productList?[indexPath.row] {
                productModel.isSelected = !productModel.isSelected
            }
        }
        self.reportTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return WH(44)
        }else if indexPath.section == 1  {
            return WH(42)
        }else{
            return WH(100)
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 0.0001
        }
        return WH(11)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = RGBColor(0xf4f4f4)
        return view
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = RGBColor(0xf4f4f4)
        return view
    }
}
