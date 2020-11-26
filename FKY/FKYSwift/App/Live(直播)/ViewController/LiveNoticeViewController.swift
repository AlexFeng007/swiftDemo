//
//  LiveNoticeViewController.swift
//  FKY
//
//  Created by 寒山 on 2020/8/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  直播预告

import UIKit

class LiveNoticeViewController: UIViewController {
    
    var scrollBlock: ScrollViewDidScrollBlock?
    var hasLoad = false //是否加载过
    fileprivate lazy var viewModel: LiveViewModel = {
        let viewModel = LiveViewModel()
        return viewModel
    }()
    // 下拉刷新
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.loadAllProductFirstPage()
        })
        header?.backgroundColor = RGBColor(0xF4F4F4)
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
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
        footer?.backgroundColor = RGBColor(0xF4F4F4)
        return footer!
    }()
    fileprivate lazy var emptyView: LiveListEmptyView = {
        let view = LiveListEmptyView()
        view.isHidden = true
        view.configTips("暂无预告内容")
        return view
    }()
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = RGBColor(0xF4F4F4)
        // tableV.estimatedRowHeight = WH(250)
        tableV.showsVerticalScrollIndicator = false
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(LiveListInfoCell.self, forCellReuseIdentifier: "LiveListInfoCell")
        tableV.mj_header = self!.mjheader
        tableV.mj_footer = self!.mjfooter
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
            tableV.estimatedRowHeight = 0
            tableV.estimatedSectionHeaderHeight = 0
            tableV.estimatedSectionFooterHeight = 0
        }
        return tableV
        }()
    deinit {
        print("LiveNoticeViewController deinit~!@")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = RGBColor(0xF4F4F4)
        setupView()
        // Do any additional setup after loading the view.
    }
    func shouldFirstLoadData() -> Void {
        guard hasLoad else {
            hasLoad = true
            self.loadAllProductFirstPage()
            return
        }
    }
    func setupView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        self.view.sendSubviewToBack(emptyView)
    }
}
//MARK:UITableViewDataSource,UITableViewDelegate UIScrollViewDelegate
extension LiveNoticeViewController: UITableViewDataSource,UITableViewDelegate {
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
        cell.configLiveInfoCell(liveModel,.LIVE_INFO_TYPE_NOTICE)
        //开播提醒
        cell.liveStartTipBlock = { [weak self] in
            if let strongSelf = self{
                strongSelf.tipsActionCellBI_Record(liveModel,indexPath.row)
                strongSelf.liveStartTipsAction(indexPath)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.liveActivityList.count < indexPath.row{
            return
        }
        let model = self.viewModel.liveActivityList[indexPath.row]
        //0：直播中，1：回放，2：预告
        clickListCellBI_Record(model,indexPath.row)
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
extension LiveNoticeViewController: UIScrollViewDelegate {
    //重新设置contentoffy
    func updateContentOffY(){
        if let block = self.scrollBlock {
            block(tableView)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            if let block = self.scrollBlock {
                block(scrollView)
            }
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == tableView {
            if let block = self.scrollBlock {
                block(scrollView)
            }
        }
    }
}
//MARK:网络请求
extension LiveNoticeViewController{
    //直播列表
    func loadAllProductFirstPage(){
        viewModel.hasNextPage = true
        viewModel.currentPage = 1
        getAllLiveInfoList()
    }
    //获取直播列表
    func getAllLiveInfoList(){
        showLoading()
        viewModel.getLiveActivityList("2"){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.refreshAllLiveListTableView()
            strongSelf.refreshDismiss()
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
        showLoading()
        let liveModel = self.viewModel.liveActivityList[indexPath.row]
        viewModel.setLiveActivityNotice(liveModel.hasSetNotice == 0 ? 1:2, liveModel.id ?? ""){ [weak self] (success, msg, status) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
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
    func refreshAllLiveListTableView(){
        if self.viewModel.liveActivityList.isEmpty == false{
            self.view.sendSubviewToBack(emptyView)
            emptyView.isHidden = true
            self.tableView.reloadData()
            
        }else{
            self.view.bringSubviewToFront(emptyView)
            emptyView.isHidden = false
        }
    }
    func refreshDismiss() {
        self.dismissLoading()
        if self.tableView.mj_header.isRefreshing() {
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.resetNoMoreData()
        }
        if  self.viewModel.hasNextPage {
            self.tableView.mj_footer.endRefreshing()
        }else{
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    
}
//MARK:埋点
extension LiveNoticeViewController{
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
    func tipsActionCellBI_Record(_ product: LiveInfoListModel, _ indexRow:Int) {
        var sectionName = ""
        var sectionId = ""
       // S9601 设置提醒
        if product.hasSetNotice == 0 {
            sectionName = "S9601"
            sectionId = "设置提醒"
        }else if product.hasSetNotice == 1{
            sectionName = "S9602"
            sectionId = "取消提醒"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record("F9603", floorPosition: "\(indexRow + 1)", floorName: "直播预告", sectionId: sectionId, sectionPosition:nil, sectionName: sectionName, itemId: nil, itemPosition: nil, itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    }
}
