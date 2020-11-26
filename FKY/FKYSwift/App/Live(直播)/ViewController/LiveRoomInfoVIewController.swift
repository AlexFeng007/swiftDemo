//
//  LiveRoomInfoVIewController.swift
//  FKY
//
//  Created by yyc on 2020/8/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//   直播间主页

import UIKit

class LiveRoomInfoVIewController: UIViewController {
    fileprivate var navBar : UIView?
    
    // 直播间icon
    fileprivate lazy var liveIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.isHidden = true
        iv.layer.cornerRadius = WH(12)
        iv.layer.masksToBounds = true
        iv.layer.borderColor = RGBColor(0xE7E7E7).cgColor
        iv.layer.borderWidth = 0.5
        return iv
    }()
    //直播间名称
    fileprivate lazy var liveNameLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = t31.color
        label.font = t21.font
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    //头部信息
    fileprivate lazy var headInfoView : LiveRoomInfoHeadView = {
        let view = LiveRoomInfoHeadView()
        return view
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
    
    fileprivate lazy var bgScrollView: UIScrollView = {
        let sv = UIScrollView.init(frame: CGRect(x: 0, y: naviBarHeight(), width: SCREEN_WIDTH, height: SCREEN_HEIGHT - naviBarHeight()))
        sv.delegate = self
        sv.bounces = false
        sv.isScrollEnabled = false
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = UIColor.clear
        sv.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - naviBarHeight() + self.headHeight)
        return sv
    }()
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = UIColor.clear
        tableV.showsVerticalScrollIndicator = false
        tableV.estimatedRowHeight = WH(300)
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(LiveListInfoCell.self, forCellReuseIdentifier: "LiveListInfoCell")
        tableV.mj_footer = mjfooter
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    
    //获取主播列表
    fileprivate lazy var anchorViewModel: LiveAnchorInfoViewModel = {
        let viewModel = LiveAnchorInfoViewModel()
        viewModel.roomId = self.roomId
        return viewModel
    }()
    //设置提醒
    fileprivate lazy var viewModel: LiveViewModel = {
        let viewModel = LiveViewModel()
        return viewModel
    }()
    //入参数
    @objc var roomId = ""
    var headHeight = WH(117)
    deinit {
        print("LiveRoomInfoVIewController deinit~!@")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.loadAllProductFirstPage()
    }
}
extension LiveRoomInfoVIewController {
    //设置导航栏
    fileprivate func setupView() {
        self.view.backgroundColor = RGBColor(0xF4F4F4)
        
        self.navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            }else{
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
            }()
        self.fky_setupTitleLabel("直播间主页")
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared()?.pop()
        }
        //调整左右按钮
        self.NavigationBarLeftImage?.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self.NavigationTitleLabel!.snp.centerY)
            make.left.equalTo(self.navBar!.snp.left).offset(WH(9))
            make.width.height.equalTo(WH(30))
        })
        
        self.navBar!.addSubview(liveNameLabel)
        liveNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.NavigationTitleLabel!.snp.centerY)
            make.centerX.equalTo(self.navBar!.snp.centerX).offset(WH(24))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-WH(100))
        }
        
        self.navBar!.addSubview(liveIconImageView)
        liveIconImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.NavigationTitleLabel!.snp.centerY)
            make.right.equalTo(liveNameLabel.snp.left).offset(-WH(6))
            make.width.height.equalTo(WH(24))
        }
        
        self.view.addSubview(bgScrollView)
        bgScrollView.addSubview(headInfoView)
        headInfoView.snp.makeConstraints { (make) in
            make.left.top.equalTo(bgScrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(headHeight+WH(37))
        }
        bgScrollView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headInfoView.snp.bottom).offset(-WH(37))
            make.left.equalTo(bgScrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT-naviBarHeight())
        }
    }
}
extension LiveRoomInfoVIewController{
    //设置标题栏
    fileprivate func congfigTitleView(_ roomName:String,_ roomLogo:String){
        self.liveNameLabel.text = roomName
        let defalutImage = UIImage.init(named: "live_author_icon")
        if let strProductPicUrl = roomLogo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.liveIconImageView.sd_setImage(with: urlProductPic , placeholderImage: defalutImage)
        }else{
            self.liveIconImageView.image = defalutImage
        }
    }
    //动态设置标题栏显示（false 显示直播间头像及名称）
    fileprivate func resetTitleViewHide(_ hideView:Bool){
        if hideView == false {
            self.liveNameLabel.isHidden = true
            self.liveIconImageView.isHidden = true
            self.NavigationTitleLabel?.isHidden = false
        }else {
            self.liveNameLabel.isHidden = false
            self.liveIconImageView.isHidden = false
            self.NavigationTitleLabel?.isHidden = true
        }
    }
}

extension LiveRoomInfoVIewController: UITableViewDataSource,UITableViewDelegate ,UIScrollViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.anchorViewModel.liveActivityList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let liveModel = self.anchorViewModel.liveActivityList[indexPath.row]
        //0：直播中，1：回放，2：预告
        if liveModel.status == 2{
            let descContentSize =  (liveModel.liveDescription ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(142), height: WH(32)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(12))], context: nil).size
            return WH(189 + 24) + descContentSize.height + 1
        }
        return WH(189)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LiveListInfoCell = tableView.dequeueReusableCell(withIdentifier: "LiveListInfoCell", for: indexPath) as! LiveListInfoCell
        cell.selectionStyle = .none
        
        let liveModel = self.anchorViewModel.liveActivityList[indexPath.row]
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
        if self.anchorViewModel.liveActivityList.count < indexPath.row{
            return
        }
        let model = self.anchorViewModel.liveActivityList[indexPath.row]
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
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.changeScolllView(scrollView)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.changeScolllView(scrollView)
    }
    func changeScolllView(_ scrollView: UIScrollView) {
        if scrollView == self.bgScrollView {
            //滑动底部滚动视图
            let y = self.bgScrollView.contentOffset.y
            if y <= 0 {
                self.bgScrollView.contentOffset.y = 0
            }
        }else if scrollView == self.tableView {
            //滑动tableview
            let y = self.tableView.contentOffset.y
            if y > 0 {
                if Int(self.bgScrollView.contentOffset.y) < Int(self.headHeight) {
                    if Int(bgScrollView.contentOffset.y + y) >= Int(self.headHeight) {
                        bgScrollView.contentOffset.y = self.headHeight
                        self.tableView.contentOffset.y = 0
                    }else{
                        bgScrollView.contentOffset.y += y
                        self.tableView.contentOffset.y = 0
                    }
                }
            } else {
                if self.bgScrollView.contentOffset.y > 0 {
                    bgScrollView.contentOffset.y += y
                    self.tableView.contentOffset.y = 0
                }
            }
        }
        if self.bgScrollView.contentOffset.y > WH(126-30) {
            self.resetTitleViewHide(true)
        }else {
            self.resetTitleViewHide(false)
        }
    }
}

//MARK:网络请求
extension LiveRoomInfoVIewController{
    //开播提醒获取取消提醒
    func liveStartTipsAction(_ indexPath:IndexPath){
        let liveModel = self.anchorViewModel.liveActivityList[indexPath.row]
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
    
    //直播列表
    func loadAllProductFirstPage(){
        anchorViewModel.hasNextPage = true
        anchorViewModel.currentPage = 1
        getAllLiveInfoList()
    }
    func getAllLiveInfoList(){
        showLoading()
        anchorViewModel.getLiveActivityListWithAnchorInfo{ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if strongSelf.anchorViewModel.hasNextPage == true {
                strongSelf.tableView.mj_footer.resetNoMoreData()
                strongSelf.tableView.mj_footer.endRefreshing()
            }else {
                strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            if success{
                strongSelf.headInfoView.configLiveRoomInfoViewData(strongSelf.anchorViewModel.roomName, strongSelf.anchorViewModel.roomLogo)
                strongSelf.congfigTitleView(strongSelf.anchorViewModel.roomName, strongSelf.anchorViewModel.roomLogo)
                strongSelf.tableView.reloadData()
            } else {
                // 失败
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
}
//MARK:埋点
extension LiveRoomInfoVIewController{
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
