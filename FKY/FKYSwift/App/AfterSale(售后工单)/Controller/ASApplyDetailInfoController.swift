//
//  ASApplyDetailController.swift
//  FKY
//
//  Created by 寒山 on 2019/5/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  售后详情界面

import UIKit

class ASApplyDetailController: UIViewController {
    // MARK: - Property
    
    // 上个界面传递过来的值~!@
    var soNo: String?       // 订单号
    var typeId: Int?        // 售后类型
    
    // viewModel
    fileprivate var asViewModel: AfterSaleViewModel = AfterSaleViewModel()
    
    // nav
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
    // header
    fileprivate var statusView: RCDHeaderView = {
        let gradientColors: [CGColor] = [RGBColor(0xFF5A9B).cgColor, RGBColor(0xFF2D5C).cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        //渲染的起始位置
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        //渲染的终止位置
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        //设置frame和插入view的layer
        let headView = RCDHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(70)))
        headView.backgroundColor = UIColor.clear
        gradientLayer.frame = headView.bounds
        headView.layer.insertSublayer(gradientLayer, at: 0)
        return headView
    }()
    // table
    fileprivate lazy var tableView: UITableView = {
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.tableHeaderView = self.statusView
        tableV.backgroundColor = RGBColor(0xf7f7f7)
        tableV.separatorStyle = UITableViewCellSeparatorStyle.none
        tableV.register(ASApplyProductInfoCell.self, forCellReuseIdentifier: "ASApplyProductInfoCell")
        tableV.register(ASApplyInfoCell.self, forCellReuseIdentifier: "ASApplyInfoCell")
        tableV.register(ASApplyDealWayInfoCell.self, forCellReuseIdentifier: "ASApplyDealWayInfoCell")
        tableV.register(ASApplyInfoDescCell.self, forCellReuseIdentifier: "ASApplyInfoDescCell")
        tableV.register(RCSpaceCell.self, forCellReuseIdentifier: "RCSpaceCell")
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
    }()
    
    
    // MARK: - LifeCircle
    
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
        print("ASApplyDetailController deinit")
    }
    
    
    // MARK: - Private
    
    fileprivate func setupView() {
        view.backgroundColor = RGBColor(0xf7f7f7)
        
        fky_setupTitleLabel("售后处理详情")
        fky_hiddedBottomLine(false)
        fky_setupLeftImage("icon_back_new_red_normal"){
            FKYNavigator.shared().pop()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo((navBar?.snp.bottom)!)
        }
    }
    
    func setupData() {
        showLoading()
        //获取详情
//        let dic: [String: Any] = [
//            "applyid":rcLModel?.id as Any,
//            "orderid":rcLModel?.orderId as Any
//        ]
        self.asViewModel.getASApplyDetailInfo(self.soNo,self.typeId){[weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if success{
               strongSelf.statusView.configASView(stutusCode: (strongSelf.asViewModel.asDetailModel?.status)!)
               strongSelf.tableView.reloadData()
            } else {
                strongSelf.toast(msg ?? "请求失败")
                strongSelf.tableView.reloadData()
                return
            }
        }
//self.asViewModel.getASApplyDetailInfo(withParams: "3",typeId:"1", callback:{[weak self] _ in
//            guard let strongSelf = self else {
//                return
//            }
//            strongSelf.dismissLoading()
//           // strongSelf.bgView.configView(stutusCode: (strongSelf.viewModel.rcDetail?.status)!)
//          //  strongSelf.dataSource = (strongSelf.viewModel.rcDetail?.rmaDetailList)!
////            if strongSelf.viewModel.rcDetail!.backWay == "MIC" && strongSelf.viewModel.rcDetail!.sendExpress != nil && !(strongSelf.viewModel.rcDetail!.sendExpress?.expressNo?.isEmpty)! && !(strongSelf.viewModel.rcDetail!.sendExpress?.expressId?.isEmpty)! {
////                let expressDic: [String: Any] = [
////                    "carrierCode":strongSelf.viewModel.rcDetail!.sendExpress?.expressId as Any,
////                    "waybillCode":strongSelf.viewModel.rcDetail!.sendExpress?.expressNo as Any,
////                    "orderId":strongSelf.rcLModel!.orderId as Any
////                ]
////                var expresslist  = [Any]()
////                expresslist.append(expressDic)
////                let expresslistDic: [String: Any] = [
////                    "subscribeKD100DtoList":expresslist as Any
////                ]
////                //获取物流
////                strongSelf.viewModel.requestForqueryLogisticsList(withParams: expresslistDic) {(success, msg) in
////                    strongSelf.dismissLoading()
////                    if success{
////                        strongSelf.tableView.reloadData()
////                    } else {
////                        // 失败 在订阅 在获取
////                        //self.toast(msg ?? "请求失败")
////                        strongSelf.setupLogisticsData()
////                        return
////                    }
////                }
////            }
//            strongSelf.tableView.reloadData()
//            }, fail: { [weak self] (msg) in
//                guard let strongSelf = self else {
//                    return
//                }
//                strongSelf.dismissLoading()
//                strongSelf.toast(msg)
//                strongSelf.tableView.reloadData()
//        })
    }
    
    
}

// MARK: - UITableViewDelegate
extension  ASApplyDetailController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.asViewModel.asDetailModel != nil {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            //处理状态 1:待分配 2:处理中 3:处理完成
            if self.asViewModel.asDetailModel!.status == ASApplyStatus.ASApplyStatus_Dealing.rawValue{
                 return 1
            }else if self.asViewModel.asDetailModel!.status == ASApplyStatus.ASApplyStatus_Complent.rawValue{
                 return 2
            }
            return 0
        }else{
            if Int(self.asViewModel.asDetailModel!.typeId1!) == ASTypeECode.ASType_WrongNum.rawValue || Int(self.asViewModel.asDetailModel!.typeId1!) == ASTypeECode.ASType_DrugReport.rawValue ||  Int(self.asViewModel.asDetailModel!.typeId1!) == ASTypeECode.ASType_ProductReport.rawValue{
                return (self.asViewModel.asDetailModel!.goodsInfo?.count)!
            }
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 固定高度
        if indexPath.section == 0{
            if indexPath.row == 0{
                return WH(73)
            }else if indexPath.row == 1{
                return WH(75)
            }
        }else if indexPath.section == 1{
             if Int(self.asViewModel.asDetailModel!.typeId1!) == ASTypeECode.ASType_WrongNum.rawValue || Int(self.asViewModel.asDetailModel!.typeId1!) == ASTypeECode.ASType_DrugReport.rawValue ||  Int(self.asViewModel.asDetailModel!.typeId1!) == ASTypeECode.ASType_ProductReport.rawValue{
                return WH(93)
            }else if Int((self.asViewModel.asDetailModel?.typeId1)!) == ASTypeECode.ASType_Bill.rawValue {
                if indexPath.row == 0{
                     return WH(10)
                }
                return WH(156)
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ASApplyInfoCell", for: indexPath) as! ASApplyInfoCell
                // 配置cell
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ASApplyDealWayInfoCell", for: indexPath) as! ASApplyDealWayInfoCell
                // 配置cell
                cell.selectionStyle = .none
                return cell
            }
        }else if indexPath.section == 1{
            if Int(self.asViewModel.asDetailModel!.typeId1!) == ASTypeECode.ASType_WrongNum.rawValue || Int(self.asViewModel.asDetailModel!.typeId1!) == ASTypeECode.ASType_DrugReport.rawValue ||  Int(self.asViewModel.asDetailModel!.typeId1!) == ASTypeECode.ASType_ProductReport.rawValue{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ASApplyProductInfoCell", for: indexPath) as! ASApplyProductInfoCell
                // 配置cell
                cell.selectionStyle = .none
                return cell
             }else if Int((self.asViewModel.asDetailModel?.typeId1)!) == ASTypeECode.ASType_Bill.rawValue {
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RCSpaceCell", for: indexPath) as! RCSpaceCell
                    cell.selectionStyle = .none
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "ASApplyInfoDescCell", for: indexPath) as! ASApplyInfoDescCell
                // 配置cell
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
