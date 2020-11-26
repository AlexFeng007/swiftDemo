//
//  HomePromotionMsgListInfoVC.swift
//  FKY
//
//  Created by 寒山 on 2020/9/17.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class HomePromotionMsgListInfoVC: UIViewController {
    
    fileprivate var viewModel: HomeMesageViewModel = {
        let vm = HomeMesageViewModel()
        vm.type = 11
        return vm
    }()
    
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            self?.getFirstPageShopProductFuc()
            
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
    }()
    
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            self?.getALLMsgInfo()
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    
    fileprivate lazy var messageTab: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.rowHeight = WH(130)
        tableV.backgroundColor = RGBColor(0xF4F4F4)
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(HomePromotionMsgInfoCell.self, forCellReuseIdentifier: "HomePromotionMsgInfoCell")
        tableV.mj_header = self?.mjheader
        tableV.mj_footer = self?.mjfooter
        tableV.estimatedRowHeight = WH(130)
        tableV.estimatedSectionHeaderHeight = 0
        tableV.estimatedSectionFooterHeight = 0
        //WH(130)
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    fileprivate var navBar: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.getFirstPageShopProductFuc()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    deinit {
        print("HomePromotionMsgListInfoVC deinit~!@")
    }
    
}
// MARK:ui相关
extension HomePromotionMsgListInfoVC {
    //MARK: 导航栏
    fileprivate func setupNavigationBar() {
        navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        fky_setupTitleLabel("活动优惠")
        self.NavigationTitleLabel?.font = UIFont.boldSystemFont(ofSize:WH(18))
        self.navBar?.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        self.view.addSubview(messageTab)
        
        messageTab.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.navBar!.snp.bottom)
        }
    }
    func refreshDismiss() {
        self.dismissLoading()
        if self.messageTab.mj_header.isRefreshing() {
            self.messageTab.mj_header.endRefreshing()
            self.messageTab.mj_footer.resetNoMoreData()
        }
        if  self.viewModel.hasNextPage {
            self.messageTab.mj_footer.endRefreshing()
        }else{
            self.messageTab.mj_footer.endRefreshingWithNoMoreData()
        }
    }
}
// MARK:数据请求相关
extension HomePromotionMsgListInfoVC {
    //获取全部信息
    @objc func getALLMsgInfo(){
        showLoading()
        viewModel.getExpiredTipsInfo(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.messageTab.mj_header.endRefreshing()
            strongSelf.refreshDismiss()
            if success{
                strongSelf.messageTab.reloadData()
            } else {
                // 失败
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    //请求第一页商品
    @objc func getFirstPageShopProductFuc(){
        self.viewModel.currentIndex = 1
        self.viewModel.hasNextPage = true
        self.getALLMsgInfo()
    }
}

//MARK: - 私有方法
extension HomePromotionMsgListInfoVC{
    /// 向后台更新pushid的状态
    /// @param status 1就是有效  2就是失效
    func upLoadPushIdStatus(status:Int){
        if FKYPush.sharedInstance()?.pushID == nil || FKYPush.sharedInstance()?.pushID.isEmpty == true {
            return
        }
        
        if FKYLoginAPI.loginStatus() != .unlogin && status == 1 {
            let param = ["pushId":FKYPush.sharedInstance()?.pushID! ?? "","buyerCode":FKYLoginAPI.currentUserId(),"status":status] as [String : Any]
            FKYPush.sharedInstance()?.pushEntryVCName = FKYNavigator.shared()?.topNavigationController.topViewController?.className ?? ""
            UserDefaults.standard.setValue(FKYPush.sharedInstance()?.pushID!, forKey: "BUSINESS_PUSH_ID")
            FKYRequestService.sharedInstance()?.upLoadPushIdStatus(param, completionBlock: { (isSuccess, error, response, model) in
                
            })
        }else if status == 2 {
            let param = ["pushId":FKYPush.sharedInstance()?.pushID! ?? "","buyerCode":FKYLoginAPI.currentUserId(),"status":status] as [String : Any]
            UserDefaults.standard.setValue(FKYPush.sharedInstance()?.pushID!, forKey: "BUSINESS_PUSH_ID")
            FKYRequestService.sharedInstance()?.upLoadPushIdStatus(param, completionBlock: { (isSuccess, error, response, model) in
                
            })
            UserDefaults.standard.setValue("", forKey: "BUSINESS_PUSH_ID")
            FKYPush.sharedInstance()?.pushID = ""
            FKYPush.sharedInstance()?.pushEntryVCName = ""
        }
    }
}
// MARK:UITableViewDataSource,UITableViewDelegate代理相关
extension HomePromotionMsgListInfoVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomePromotionMsgInfoCell = tableView.dequeueReusableCell(withIdentifier: "HomePromotionMsgInfoCell", for: indexPath) as! HomePromotionMsgInfoCell
        cell.selectionStyle = .none
        let model = self.viewModel.dataSource[indexPath.row]
        cell.configCell(model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(130)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.viewModel.dataSource[indexPath.row]
        self.infoSelBI(model,indexPath.row)
        if let app = UIApplication.shared.delegate as? AppDelegate {
            if let url = model.url, url.isEmpty == false {
                app.p_openPriveteSchemeString(url)
                if model.type == "26" {// 是商业化推送才做pushID的逻辑
                    FKYPush.sharedInstance()?.pushID = model.pushId ?? ""
                    upLoadPushIdStatus(status: 1)
                }
            }
        }
    }
    
}
extension HomePromotionMsgListInfoVC{
    func infoSelBI(_ model:ExpiredTipsInfoModel,_ rowIndex:Int){
        var itemPosition = "0"
        var itemName = ""
        if model.type == "4"{
            //点进商详
            itemPosition = "1"
            itemName = "点进商详"
        }else if model.type == "23"{
            //特价专区
            itemPosition = "2"
            itemName = "特价专区"
        }else if model.type == "21"{
            //降价专区
            itemPosition = "3"
            itemName = "降价专区"
        }else if model.type == "24"{
            //满折专区
            itemPosition = "4"
            itemName = "满折专区"
        }else if model.type == "22"{
           //优惠券到期提醒
            itemPosition = "5"
            itemName = "优惠券到期提醒"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: model.pushId ?? "", sectionPosition: nil, sectionName: "活动优惠", itemId: "I6510", itemPosition:itemPosition, itemName: itemName, itemContent: nil, itemTitle: model.createTime ?? "", extendParams:nil, viewController: self)
    }
}
