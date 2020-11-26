//
//  FKYStationMsgVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/9/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYStationMsgVC: UIViewController{

    var viewModel:FKYStationMsgVM = FKYStationMsgVM()
    
    fileprivate var navBar: UIView?
    
    lazy var mainTable:UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 200
        tb.estimatedSectionHeaderHeight = 0
        tb.estimatedSectionFooterHeight = 0
        tb.separatorStyle = .none
        tb.register(FKYStationMsgCellType1.self, forCellReuseIdentifier: NSStringFromClass(FKYStationMsgCellType1.self))
        tb.register(FKYStationMsgCellType2.self, forCellReuseIdentifier: NSStringFromClass(FKYStationMsgCellType2.self))
        tb.register(FKYStationMsgSectionHeader.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(FKYStationMsgSectionHeader.self))
        tb.backgroundColor = RGBColor(0xF4F4F4)
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(FKYStationMsgVC.loadMore))
        footer?.setTitle("--没有更多啦！--", for: .noMoreData)
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(FKYStationMsgVC.refrash))
        tb.mj_header = header
        tb.mj_footer = footer
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainTable.mj_header.beginRefreshing()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - 事件响应
extension FKYStationMsgVC{
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKYStationMsgCellType1ItemView.itemClickAction {// item点击
            let dic = userInfo[FKYUserParameterKey] as! [String:Any]
            let type:String = dic["itemType"] as! String
            if type == "1"{
                self.addBi(sectionName: "固定板块", itemId: "I6501", itemName: "交易物流", itemPosition: "")
                // 交易物流消息
                FKYNavigator.shared()?.openScheme(FKY_OrderLogisticsMsgVC.self, setProperty: { (vc) in
                    
                }, isModal: false)
            }else if type == "2"{
                self.addBi(sectionName: "固定板块", itemId: "I6502", itemName: "活动优惠", itemPosition: "")
                // 活动优惠
                FKYNavigator.shared()?.openScheme(FKY_HomePromotionMsgListInfoVC.self, setProperty: { (vc) in
                    
                }, isModal: false)
            }
        }
    }
    
    // 删除某个消息
    func deleteMsg(_ indexPath:IndexPath){
        let section = self.viewModel.sectionList[indexPath.section]
        section.cellList.remove(at: indexPath.row)
        if section.cellList.count<1 {
            self.viewModel.sectionList.remove(at: indexPath.section)
            self.mainTable.deleteSections(IndexSet.init(integer: indexPath.section), with: .automatic)
        }else{
            self.mainTable.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // 上拉加载
    @objc func loadMore(){
        if self.viewModel.isHaveNextPage == false {
            self.mainTable.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        self.requestMsgList()
    }
    
    // 下拉刷新
    @objc func refrash(){
        self.viewModel.resetData()
        self.requestMsgList()
    }
}

//MARK: - 网络请求
extension FKYStationMsgVC{
    func requestMsgList(){
        self.viewModel.getMsgList {[weak self] (isSuccess, msg) in
            guard let weakSelf  = self else{
                return
            }
            if weakSelf.viewModel.isHaveNextPage == false{
                weakSelf.mainTable.mj_footer.endRefreshingWithNoMoreData()
            }else{
                weakSelf.mainTable.mj_footer.endRefreshing()
            }
            weakSelf.mainTable.mj_header.endRefreshing()
            
            guard isSuccess else {
                weakSelf.toast(msg)
                return
            }
            
            weakSelf.mainTable.reloadData()
        }
    }
}

//MARK: - UI
extension FKYStationMsgVC{
    func setupUI(){
        self.configNaviBar()
        
        self.view.addSubview(self.mainTable)
        
        self.mainTable.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.navBar!.snp_bottom)
        }
    }
    
    
    /// 配置导航栏
    func configNaviBar() {
        self.navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            } else {
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
            }()
        self.fky_setupTitleLabel("消息中心")
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") { () in
            FKYNavigator.shared().pop()
        }
    }
    
}

//MARK: - tableviewDelegate
extension FKYStationMsgVC:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sectionList[section].cellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionModel = self.viewModel.sectionList[indexPath.section]
        let cellModel = sectionModel.cellList[indexPath.row]
        if cellModel.type == .type1Cell{
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYStationMsgCellType1.self)) as! FKYStationMsgCellType1
            cell.showCellData(cellModel: cellModel)
            return cell
        }else if cellModel.type == .type2Cell {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYStationMsgCellType2.self)) as! FKYStationMsgCellType2
            cell.showCellData(cellModel:cellModel)
            return cell
        }
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.sectionList.count <= indexPath.section{
            return
        }
        let sectionModel = self.viewModel.sectionList[indexPath.section]
        let cellModel = sectionModel.cellList[indexPath.row]
        if cellModel.data.type == 8 {
            //资质过期消息列表
            self.addBi(sectionName: "固定板块", itemId: "I6504", itemName: "资质证照", itemPosition: "")
            FKYNavigator.shared().openScheme(FKY_ExpiredTipsMessageVC.self, setProperty: { (vc) in
            }, isModal: false)
        }else if cellModel.data.type == 12{
            // 中奖纪录
            self.addBi(sectionName: "固定板块", itemId: "I6503", itemName: "中奖记录", itemPosition: "")
            let app = UIApplication.shared.delegate as! AppDelegate
            app.p_openPriveteSchemeString(cellModel.data.jumpUrl)
        }else if cellModel.data.type == 0{
            self.addBi(sectionName: "IM聊天", itemId: "I6505", itemName: "与商家沟通", itemPosition: "\(indexPath.row)")
            // IM消息
            let app = UIApplication.shared.delegate as! AppDelegate
            app.p_openPriveteSchemeString(cellModel.data.jumpUrl)
            /*
            FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                let v = vc as! GLWebVC
                v.urlPath = model.jumpUrl
                v.navigationController?.isNavigationBarHidden = true
            }, isModal: true)
            */
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = self.viewModel.sectionList[section]
        if sectionModel.type == .lastWeakMsg {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(FKYStationMsgSectionHeader.self)) as! FKYStationMsgSectionHeader
            headerView.showTestData()
            return headerView
        }
        
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = self.viewModel.sectionList[section]
        if sectionModel.type == .currentMsg {
            return WH(10)
        }else if sectionModel.type == .lastWeakMsg{
            return WH(32)
        }
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //第一行固定有，不允许删除 如果后期要针对固定消息则按照cellType区分
        /*6801默认不允许侧滑删除，需求变更
        if indexPath.section == 0{
            return false
        }
        return true
        */
        return false
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.deleteMsg(indexPath)
        }
    }
    
    
    
}

//MARK: - BI埋点
extension FKYStationMsgVC{
    
    func addBi(sectionName:String,itemId:String,itemName:String,itemPosition:String){
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: sectionName, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self);
    }
}



