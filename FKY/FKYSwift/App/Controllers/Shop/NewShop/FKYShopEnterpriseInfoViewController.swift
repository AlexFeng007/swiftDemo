//
//  FKYShopEnterpriseInfoViewController.swift
//  FKY
//
//  Created by hui on 2019/11/1.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
//企业信息
class FKYShopEnterpriseInfoViewController: UIViewController {
    fileprivate var navBar: UIView?
    // tableview头部视图
    fileprivate lazy var enterInfoHeadView : FKYShopMainHeadView = {
        let view = FKYShopMainHeadView()
        view.haveNoShopIconLayout()
        return view
    }()
    //
    fileprivate lazy var enterInfoTableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.backgroundColor = RGBColor(0xF4F4F4)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.estimatedRowHeight = WH(500)
        tableV.rowHeight = UITableView.automaticDimension // 设置高度自适应
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.tableHeaderView = self?.enterInfoHeadView
        tableV.register(FKYShopMainContentsTableViewCell.self, forCellReuseIdentifier: "FKYShopMainContentsTableViewCell_enterpriseInfo")
        tableV.register(FKYEnterBaseInfoTableViewCell.self, forCellReuseIdentifier: "FKYEnterBaseInfoTableViewCell_enterpriseInfo")
        tableV.register(FKYEnterBasequalificationTableViewCell.self, forCellReuseIdentifier: "FKYEnterBasequalificationTableViewCell")
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: "emptyCell")
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        tableV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 67, right: 0)
        return tableV
        }()
    //MARK: - Property
    //上个界面传入数据
    @objc dynamic var shopId: String? //店铺id
    var enterBaseInfoModel : FKYShopEnterInfoModel? //头部基本信息
    var scrolleToBottom: Bool? //滚动到最下面
    //网络数据
    var qualificationInfoModel : FKYEnterQualificationModel? //优惠券及促销活动
    //MARK: 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.setupView()
        self.setContentView()
        self.getEnterPriseInfomation()
    }
    deinit {
        print("FKYShopEnterpriseInfoViewController deinit>>>>>>>")
    }
}
//MARK: ui相关
extension FKYShopEnterpriseInfoViewController {
    //设置导航栏
    fileprivate func setupView() {
        self.navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            }else{
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
            }()
        
        self.navBar!.backgroundColor = bg1
        fky_setupTitleLabel("采购须知")
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            // 返回
            if let strongSelf = self {
                FKYNavigator.shared().pop()
            }
        }
        self.NavigationBarLeftImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationTitleLabel!.snp.centerY)
            make.left.equalTo(self.navBar!.snp.left).offset(WH(12))
            make.height.width.equalTo(WH(30))
        })
        
    }
    //设置内容视图
    fileprivate func setContentView (){
        self.view.addSubview(self.enterInfoTableView)
        self.enterInfoTableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalToSuperview()
            make.top.equalTo(self.navBar!.snp.bottom)
        }
    }
}
//MARK: 网络请求
extension FKYShopEnterpriseInfoViewController {
    //刷新头部视图
    fileprivate func resetEnterpriseInfoHeaderViewData(){
        self.enterInfoHeadView.configShopMainHeadViewData(baseModel: self.enterBaseInfoModel,2)
        let sectionHeadOne_h = self.enterInfoHeadView.getShopMainHeadViewHeight(baseModel: self.enterBaseInfoModel, 2)
        self.enterInfoHeadView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sectionHeadOne_h)
    }
    func getEnterPriseInfomation(){
        FKYRequestService.sharedInstance()?.requestForGetShopQualificationInfo(withParam: ["enterpriseId":self.shopId ?? ""], completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                strongSelf.toast(msg)
                return
            }
            if let infoModel = model as? FKYEnterQualificationModel {
                strongSelf.qualificationInfoModel = infoModel
                strongSelf.enterInfoTableView.reloadData()
                strongSelf.resetEnterpriseInfoHeaderViewData()
                if strongSelf.scrolleToBottom == true {
                    if let str = infoModel.accountProcess,str.count > 0 {
                        strongSelf.enterInfoTableView.scrollToRow(at: IndexPath.init(row: 0, section: 5), at: .top, animated: false)
                    }
                }
            }
        })
    }
}
//MARK: UITableViewDelegate,UITableViewDataSource代理
extension FKYShopEnterpriseInfoViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let infoModel = self.qualificationInfoModel else{// 没有数据
            return CGFloat.leastNormalMagnitude
        }
        
        guard let baseModel = self.enterBaseInfoModel else{// 没有数据
            return CGFloat.leastNormalMagnitude
        }
        
        if indexPath.section == 0{//企业介绍
            if indexPath.row == 0 {
                return tableView.rowHeight
            }
        }else if indexPath.section == 1{//公告
            if let infoModel = self.enterBaseInfoModel, let notice = infoModel.notice, notice.count == 0{
                return CGFloat.leastNormalMagnitude
            }
            if indexPath.row == tableView.numberOfRows(inSection: 1)-1{
                return WH(9)
            }else{
                return tableView.rowHeight
            }
        }else if indexPath.section == 2{// 企业基本信息 -企业名称 -法定代表 -注册地址 -邮编 -企业网址 -入驻时间 -起售金额
            if indexPath.row == 0{
                return WH(15)
            }else if indexPath.row < (tableView.numberOfRows(inSection: 2) - 1){
                return tableView.rowHeight
            }else{
                return WH(9)
            }
        }else if indexPath.section == 3{// 服务相关信息 -开户 -发票 -物流 -售后
            if indexPath.row == 1 {// 开户
                if infoModel.account.isEmpty == false{
                    return tableView.rowHeight
                }else{
                    return CGFloat.leastNormalMagnitude
                }
            }else if indexPath.row == 2 {// 发票
                if infoModel.invoice.isEmpty == false {
                    return tableView.rowHeight
                }else{
                    return CGFloat.leastNormalMagnitude
                }
            }else if indexPath.row == 3 {// 物流
                if infoModel.deliveryInstruction.isEmpty == false {
                    return tableView.rowHeight
                }else{
                    return CGFloat.leastNormalMagnitude
                }
            }else if indexPath.row == 4 {// 售后
                if infoModel.afterSale.isEmpty == false {
                    return tableView.rowHeight
                }else{
                    return CGFloat.leastNormalMagnitude
                }
            }else if indexPath.row == 0 {// 白色空行
                return WH(13)
            }
        }else if indexPath.section == 4{// 开户流程与说明
            if indexPath.row == 0 {
                return tableView.rowHeight
            }
        }else if indexPath.section == 5{//经营范围
            if indexPath.row == 0 {
                return tableView.rowHeight
            }
        }else if indexPath.section == 6{// 销售区域
            if indexPath.row == 0 {
                return tableView.rowHeight
            }
        }else if indexPath.section == 7{// 企业资质
            if indexPath.row == 0 {
                return  FKYEnterBasequalificationTableViewCell.configEnterBaseQualificationCellH(infoModel.picArr)
            }
        }
        return WH(9)
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = self.qualificationInfoModel {
            return 8
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let infoModel = self.qualificationInfoModel {
            
            if section == 0 {//企业介绍
                if let str = infoModel.introduce,str.count > 0 {
                    return 2
                }
            }else if section == 1{//公告
                if let _ = self.enterBaseInfoModel{
                    return 2
                }
            }else if section == 2{// 企业基本信息 -企业名称 -法定代表 -注册地址 -邮编 -企业网址 -入驻时间 -起售金额
                if infoModel.contentArr.count > 0 {
                    return infoModel.contentArr.count+2
                }
            }else if section == 3{// 服务相关信息 -开户 -发票 -物流 -售后
                if self.isHaveOneOrMoreEnterpriseInfo() == false{
                    return 0
                }
                if let _ = self.qualificationInfoModel{
                    return 6
                }
            }else if section == 4{// 开户流程与说明
                if let str = infoModel.accountProcess,str.count > 0 {
                    return 2
                }
            }else if section == 5{//经营范围
                if let str = infoModel.businessScope,str.count > 0 {
                    return 2
                }
            }else if section == 6{// 销售区域
                if let str = infoModel.saleArea,str.count > 0 {
                    return 2
                }
            }else if section == 7{// 企业资质
                if let arr = infoModel.picArr,arr.count > 0 {
                    return 2
                }
            }
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {//企业介绍
            if indexPath.row == 0 {
                let cell: FKYShopMainContentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYShopMainContentsTableViewCell_enterpriseInfo", for: indexPath) as! FKYShopMainContentsTableViewCell
                if let infoModel = self.qualificationInfoModel {
                    cell.configEnterpriseInfomationTabelCellData("",infoModel.introduce ?? "",0)
                }
                return cell
            }
        }else if indexPath.section == 1{//公告
            if indexPath.row < tableView.numberOfRows(inSection: 1) - 1{
                let cell: FKYShopMainContentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYShopMainContentsTableViewCell_enterpriseInfo", for: indexPath) as! FKYShopMainContentsTableViewCell
                if let infoModel = self.enterBaseInfoModel {
                    cell.configEnterpriseInfomationTabelCellData("公告",infoModel.notice ?? "",1)
                    return cell
                }
            }
        }else if indexPath.section == 2{// 企业基本信息 -企业名称 -法定代表 -注册地址 -邮编 -企业网址 -入驻时间 -起售金额
            let cell = tableView.dequeueReusableCell(withIdentifier: "FKYEnterBaseInfoTableViewCell_enterpriseInfo", for: indexPath) as! FKYEnterBaseInfoTableViewCell
            if let infoModel = self.qualificationInfoModel {
                if indexPath.row < tableView.numberOfRows(inSection: 2) - 1 {
                    if indexPath.row == 0{
                        cell.configEnterBaseInfo("", "")
                        return cell
                    }else{
                        cell.configEnterBaseInfo(infoModel.titleArr[indexPath.row-1],infoModel.contentArr[indexPath.row-1])
                        cell.configTextColor(color: RGBColor(0x333333))
                        return cell
                    }
                }else{
                    cell.configEnterBaseInfo("", "")
                    cell.backgroundColor =  RGBColor(0xF4F4F4)
                    return cell
                }
            }
        }else if indexPath.section == 3{// 服务相关信息 -开户 -发票 -物流 -售后
            if indexPath.row == 1 , let baseModel = self.qualificationInfoModel{// 开户
                let cell = tableView.dequeueReusableCell(withIdentifier: "FKYEnterBaseInfoTableViewCell_enterpriseInfo", for: indexPath) as! FKYEnterBaseInfoTableViewCell
                cell.configEnterBaseInfo("开        户", baseModel.account,true )
                return cell
            }else if indexPath.row == 2 , let baseModel = self.qualificationInfoModel{// 发票
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "FKYEnterBaseInfoTableViewCell_enterpriseInfo", for: indexPath) as! FKYEnterBaseInfoTableViewCell
                cell.configEnterBaseInfo("发        票",baseModel.invoice,true )
                return cell
            }else if indexPath.row == 3 , let baseModel = self.qualificationInfoModel{// 物流
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "FKYEnterBaseInfoTableViewCell_enterpriseInfo", for: indexPath) as! FKYEnterBaseInfoTableViewCell
                cell.configEnterBaseInfo("物        流",baseModel.deliveryInstruction,true )
                return cell
            }else if indexPath.row == 4 , let baseModel = self.qualificationInfoModel{// 售后
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "FKYEnterBaseInfoTableViewCell_enterpriseInfo", for: indexPath) as! FKYEnterBaseInfoTableViewCell
                cell.configEnterBaseInfo("售        后",baseModel.afterSale,true )
                return cell
            }else if indexPath.row == 0 , let _ = self.enterBaseInfoModel{// 白色空行
                let cell = UITableViewCell.init(style: .default, reuseIdentifier: "error")
                cell.backgroundColor =  RGBColor(0xFFFFFF)
                cell.selectionStyle = .none
                return cell
            }
        }else if indexPath.section == 4{// 开户流程与说明
            if indexPath.row == 0 ,let infoModel = self.qualificationInfoModel {
                let cell: FKYShopMainContentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYShopMainContentsTableViewCell_enterpriseInfo", for: indexPath) as! FKYShopMainContentsTableViewCell
                cell.configEnterpriseInfomationTabelCellData("开户流程与说明",infoModel.accountProcess ?? "",1)
                return cell
            }
        }else if indexPath.section == 5{//经营范围
            if indexPath.row == 0 ,let infoModel = self.qualificationInfoModel {
                let cell: FKYShopMainContentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYShopMainContentsTableViewCell_enterpriseInfo", for: indexPath) as! FKYShopMainContentsTableViewCell
                cell.configEnterpriseInfomationTabelCellData("经营范围",infoModel.businessScope ?? "",1)
                return cell
            }
        }else if indexPath.section == 6{// 销售区域
            if indexPath.row == 0 ,let infoModel = self.qualificationInfoModel {
                let cell: FKYShopMainContentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYShopMainContentsTableViewCell_enterpriseInfo", for: indexPath) as! FKYShopMainContentsTableViewCell
                cell.configEnterpriseInfomationTabelCellData("销售区域",infoModel.saleArea ?? "",1)
                return cell
            }
        }else if indexPath.section == 7{// 企业资质
            if indexPath.row == 0 {
                //企业资质图片
                let cell = tableView.dequeueReusableCell(withIdentifier: "FKYEnterBasequalificationTableViewCell", for: indexPath) as! FKYEnterBasequalificationTableViewCell
                if let infoModel = self.qualificationInfoModel,let arr = infoModel.picArr {
                    cell.cofigEnterBaseQualificationViewData(arr)
                    cell.clickPicView = { [weak self] (itemIndex) in
                        if let strongSelf = self {
                            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "企业信息", itemId: ITEMCODE.SHOP_DETAIL_ETERPRISE_INFOMATION_CODE.rawValue, itemPosition: "1", itemName: "查看大图", itemContent: nil, itemTitle: nil, extendParams: ["pageValue":strongSelf.shopId ?? ""] as [String : AnyObject], viewController: self)
                        }
                    }
                }
                return cell
            }
        }
        
        //空白分割行
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "error")
        cell.backgroundColor =  RGBColor(0xF4F4F4)
        cell.selectionStyle = .none
        return cell
        
        
        
        
        /*
        if indexPath.section == 1 {
            //企业名称/法定代表/注册地址/邮编/企业网址/入住时间/起售金额
            if indexPath.row == 0 {
                //空白分割行
                let cell = UITableViewCell.init(style: .default, reuseIdentifier: "error")
                cell.backgroundColor =  RGBColor(0xFFFFFF)
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row < (tableView.numberOfRows(inSection: 1) - 1)  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FKYEnterBaseInfoTableViewCell_enterpriseInfo", for: indexPath) as! FKYEnterBaseInfoTableViewCell
                if let infoModel = self.qualificationInfoModel {
                    cell.configEnterBaseInfo(infoModel.titleArr[indexPath.row-1],infoModel.contentArr[indexPath.row-1])
                }
                return cell
            }
        }else if indexPath.section == 4 {
            if indexPath.row == 0 {
                //企业资质图片
                let cell = tableView.dequeueReusableCell(withIdentifier: "FKYEnterBasequalificationTableViewCell", for: indexPath) as! FKYEnterBasequalificationTableViewCell
                if let infoModel = self.qualificationInfoModel,let arr = infoModel.picArr {
                    cell.cofigEnterBaseQualificationViewData(arr)
                    cell.clickPicView = { [weak self] (itemIndex) in
                        if let strongSelf = self {
                            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "企业信息", itemId: ITEMCODE.SHOP_DETAIL_ETERPRISE_INFOMATION_CODE.rawValue, itemPosition: "1", itemName: "查看大图", itemContent: nil, itemTitle: nil, extendParams: ["pageValue":strongSelf.shopId ?? ""] as [String : AnyObject], viewController: self)
                        }
                    }
                }
                return cell
            }
        }else {
            if indexPath.row == 0 {
                //介绍/经营范围/销售区域/开户流程与说明
                let cell: FKYShopMainContentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYShopMainContentsTableViewCell_enterpriseInfo", for: indexPath) as! FKYShopMainContentsTableViewCell
                if let infoModel = self.qualificationInfoModel {
                    if indexPath.section == 0 {
                        //介绍
                        cell.configEnterpriseInfomationTabelCellData("",infoModel.introduce ?? "",0)
                    }else if indexPath.section == 2 {
                        cell.configEnterpriseInfomationTabelCellData("经营范围",infoModel.businessScope ?? "",1)
                    }else if indexPath.section == 3 {
                        cell.configEnterpriseInfomationTabelCellData("销售区域",infoModel.saleArea ?? "",1)
                    }else if indexPath.section == 5 {
                        cell.configEnterpriseInfomationTabelCellData("开户流程与说明",infoModel.accountProcess ?? "",1)
                    }
                }
                return cell
            }
        }
        */
    }
    
    /// -开户 -发票 -物流 -售后 是否至少有一个信息
    func isHaveOneOrMoreEnterpriseInfo() -> Bool{
        var ishave = false
        guard let baseModel = self.qualificationInfoModel else{
            return ishave
        }
        
        if baseModel.account.isEmpty == false {
            ishave = true
        }
        
        if baseModel.invoice.isEmpty == false {
            ishave = true
        }
        
        if baseModel.deliveryInstruction.isEmpty == false {
            ishave = true
        }
        
        if baseModel.afterSale.isEmpty == false {
            ishave = true
        }
        
        return ishave
    }
}

