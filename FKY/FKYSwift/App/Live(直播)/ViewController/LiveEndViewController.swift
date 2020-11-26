//
//  LiveEndViewController.swift
//  FKY
//
//  Created by 寒山 on 2020/8/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  直播结束页面

import UIKit

class LiveEndViewController: UIViewController {
    @objc  var activityId: String?//活动ID
    fileprivate lazy var viewModel: LiveViewModel = {
        let viewModel = LiveViewModel()
        return viewModel
    }()
    // 上拉加载更多
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.getAllLiveInfoList()
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    fileprivate lazy var endHeadView: LiveEndHeadView = {
        let headView = LiveEndHeadView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: (SKPhotoBrowser.getScreenTopMargin() + WH(197) + WH(35))))
        //点击退出
        headView.clickExitBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.exitAction()
            }
        }
        //重放
        headView.replayLiveBlock = {[weak self] in
            if let _ = self {
                // strongSelf.exitAction()
            }
        }
        return headView
        
    }()
    
//    fileprivate lazy var emptyView: LiveListEmptyView = {
//        let view = LiveListEmptyView()
//        view.isHidden = true
//        return view
//    }()
    
    fileprivate lazy var navView: LiveEndNavView = {
        let view = LiveEndNavView()
        //点击退出
        view.clickExitBlock = {[weak self] in
            if let strongSelf = self {
                strongSelf.exitAction()
            }
        }
        return view
    }()
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = RGBColor(0xF4F4F4)
        tableV.showsVerticalScrollIndicator = false
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(LiveListInfoCell.self, forCellReuseIdentifier: "LiveListInfoCell")
        tableV.tableHeaderView = endHeadView
        tableV.mj_footer = self!.mjfooter
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
            tableV.estimatedRowHeight = 0
            tableV.estimatedSectionHeaderHeight = 0
            tableV.estimatedSectionFooterHeight = 0
        }
        return tableV
        }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = RGBColor(0xF4F4F4)
        setupView()
        setupData()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
//        self.view.addSubview(emptyView)
//        emptyView.snp.makeConstraints({ (make) in
//            make.edges.equalTo(self.view)
//        })
//        self.view.sendSubviewToBack(emptyView)
        
        self.view.addSubview(navView)
        navView.alpha = 0.0
        navView.snp.makeConstraints({ (make) in
            make.height.equalTo(WH(67) + SKPhotoBrowser.getScreenTopMargin())
            make.left.right.top.equalTo(self.view)
        })
    }
    func setupData() {
        self.loadAllProductFirstPage()
    }
    
}
extension LiveEndViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.liveActivityList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let liveModel = self.viewModel.liveActivityList[indexPath.row]
        //0：直播中，1：回放，2：预告
        if liveModel.status == 2{
            let descContentSize =  (liveModel.liveDescription ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(142), height: WH(32)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(12))], context: nil).size
            return WH(189 + 24) + descContentSize.height + 1
        }
        return WH(189)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 商品cell
        let liveModel = self.viewModel.liveActivityList[indexPath.row]
        let cell: LiveListInfoCell = tableView.dequeueReusableCell(withIdentifier: "LiveListInfoCell", for: indexPath) as! LiveListInfoCell
        cell.selectionStyle = .none
        cell.configLiveInfoCell(liveModel,.LIVE_INFO_TYPE_REPLAY)
        //开播提醒
        cell.liveStartTipBlock = { [weak self] in
            if let strongSelf = self{
                strongSelf.liveStartTipsAction(indexPath)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.viewModel.liveActivityList[indexPath.row]
        clickListCellBI_Record(model,indexPath.row)
        //0：直播中，1：回放，2：预告
        if model.status == 0 {
            LiveManageObject.shareInstance.enterLiveViewController(model.id ?? "", "1")
        }else if model.status == 1{
            FKYNavigator.shared()?.openScheme(FKY_FKYVodPlayerViewController.self, setProperty: { (vc) in
                let liveVC = vc as! FKYVodPlayerViewController
                liveVC.activityId = model.id ?? ""
                liveVC.source = "1"
                liveVC.liveInfoModel = model
            }, isModal: false)
        }else if model.status == 2{
            FKYNavigator.shared().openScheme(FKY_LiveNticeDetailViewController.self, setProperty: { (vc) in
                let v = vc as! LiveNticeDetailViewController
                v.activityId = model.id ?? ""
                v.changeNoticeTipStatus = { [weak self] typeStatus in
                    if let strongSelf = self {
                        if model.hasSetNotice != typeStatus {
                            model.hasSetNotice = typeStatus
                            strongSelf.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            }, isModal: false)
        }
    }
}
extension LiveEndViewController: UIScrollViewDelegate {
    //重新设置contentoffy
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentY = tableView.contentOffset.y
        self.setNavAlpha(contentY)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let contentY = tableView.contentOffset.y
        self.setNavAlpha(contentY)
        //        let contentY = tableView.contentOffset.y
        //        if contentY >= (SKPhotoBrowser.getScreenTopMargin() + WH(197) + WH(35)){
        //            navView.alpha = 1.0
        //        }else if  contentY < ((WH(197) + WH(35)) - WH(67)){
        //            navView.alpha = 0.0
        //        }else{
        //            navView.alpha = (contentY - ((WH(197) + WH(35)) - WH(67)))/(WH(67) + SKPhotoBrowser.getScreenTopMargin())
        //        }
    }
    func setNavAlpha(_ contentY:CGFloat){
        if contentY >= ((WH(197) + WH(44)) - WH(67)){
            navView.alpha = 1.0
        }else if  contentY < ((WH(197) + WH(44)) - WH(67) - (WH(67) + SKPhotoBrowser.getScreenTopMargin())){
            navView.alpha = 0.0
        }else{
            navView.alpha = (contentY - ((WH(197) + WH(44)) - WH(67) - (WH(67) + SKPhotoBrowser.getScreenTopMargin())))/(WH(67) + SKPhotoBrowser.getScreenTopMargin())
        }
    }
}
extension LiveEndViewController{
    //退出直播
    func exitAction(){
        FKYNavigator.shared().pop()
    }
}
//MARK:网络请求
extension LiveEndViewController{
    //直播列表
    func loadAllProductFirstPage(){
        viewModel.hasNextPage = true
        viewModel.currentPage = 1
        getAllLiveInfoList()
    }
    //获取直播列表
    func getAllLiveInfoList(){
        showLoading()
        viewModel.getLiveActivityList("3"){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.refreshDismiss()
            strongSelf.tableView.reloadData()
            if success{
                
            } else {
                // 失败
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    //开播提醒获取取消提醒
    func liveStartTipsAction(_ indexPath:IndexPath){
        let liveModel = self.viewModel.liveActivityList[indexPath.row]
        viewModel.setLiveActivityNotice(liveModel.hasSetNotice == 0 ? 1:2, liveModel.id ?? ""){ [weak self] (success, msg, status) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            //status 0：成功 1失败
            if success{
                if status == 0{
                    liveModel.hasSetNotice =  liveModel.hasSetNotice == 0 ? 1:0
                    if liveModel.hasSetNotice  == 1{
                        strongSelf.toast("设置直播提醒成功")
                    }else{
                        strongSelf.toast("取消直播提醒成功")
                    }
                }else{
                    strongSelf.toast("设置失败")
                }
                strongSelf.tableView.reloadRows(at: [indexPath], with: .none)
            } else {
                // 失败
                strongSelf.toast(msg ?? "设置失败")
                return
            }
        }
    }
    func refreshDismiss() {
        self.dismissLoading()
        if  self.viewModel.hasNextPage {
            self.tableView.mj_footer.endRefreshing()
        }else{
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    
}
//MARK:埋点
extension LiveEndViewController{
    //列表点击埋点
    func clickListCellBI_Record(_ product: LiveInfoListModel, _ indexRow:Int) {
        //0：直播中，1：回放，2：预告
        var floorName = ""
        var floorId = ""
        if product.status == 0 {
            floorName = "直播列表"
            floorId = "F9602"
        }else if product.status == 1{
           floorName = "直播回放"
            floorId = "F9604"
        }else if product.status == 2{
            floorName = "直播预告"
            floorId = "F9603"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(floorId, floorPosition: "\(indexRow + 1)", floorName: floorName, sectionId: nil, sectionPosition:nil, sectionName: nil, itemId: nil, itemPosition: nil, itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    }
    //退出
    func exitBI_Record(){
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition:nil, sectionName: nil, itemId: "I9621", itemPosition: nil, itemName: "关闭按钮", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    }
}
