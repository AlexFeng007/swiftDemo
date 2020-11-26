//
//  PriceChangeNoticeVC.swift
//  FKY
//
//  Created by 寒山 on 2020/3/12.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  消息中心 商品降价

import UIKit

class PriceChangeNoticeVC: UIViewController,FKY_PriceChangeNoticeVC{
    
    fileprivate var viewModel: HomeMesageViewModel = {
        let vm = HomeMesageViewModel()
        vm.type = 4
        return vm
    }()
    
    fileprivate lazy var mjheader: MJRefreshNormalHeader = { [weak self] in
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            // 下拉刷新
            strongSelf.getFirstPageShopProductFuc()
            
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
        }()
    
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = { [weak self] in
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            // 上拉加载更多
            strongSelf.getALLExpiredTipsInfo()
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
        tableV.rowHeight = WH(70)
        tableV.backgroundColor = RGBColor(0xF4F4F4)
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(ChangePriceInfoCell.self, forCellReuseIdentifier: "ChangePriceInfoCell")
        if let strongSelf = self {
            tableV.mj_header = strongSelf.mjheader
            tableV.mj_footer = strongSelf.mjfooter
        }
        
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
        print("PriceChangeNoticeVC deinit~!@")
    }
}
// MARK:ui相关
extension PriceChangeNoticeVC {
    //MARK: 导航栏
    fileprivate func setupNavigationBar() {
        navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        fky_setupTitleLabel("服务通知")
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
extension PriceChangeNoticeVC {
    //获取全部商品
    @objc func getALLExpiredTipsInfo(){
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
        self.getALLExpiredTipsInfo()
    }
}
// MARK:UITableViewDataSource,UITableViewDelegate代理相关
extension PriceChangeNoticeVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChangePriceInfoCell = tableView.dequeueReusableCell(withIdentifier: "ChangePriceInfoCell", for: indexPath) as! ChangePriceInfoCell
        let model = self.viewModel.dataSource[indexPath.row]
        cell.selectionStyle = .none
        cell.configCell(model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //  let model = self.viewModel.dataSource[indexPath.row]
        return WH(140)//ChangePriceInfoCell.calculateHeight(model)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.viewModel.dataSource[indexPath.row]
        if let app = UIApplication.shared.delegate as? AppDelegate {
            if let url = model.url, url.isEmpty == false {
                app.p_openPriveteSchemeString(url)
            }
        }
         infoSelBI( model,indexPath.row)
    }
    
}
extension PriceChangeNoticeVC{
    //8：资质证照   9：交易物流  10：退换货售后  0：im
    func infoSelBI(_ model:ExpiredTipsInfoModel,_ rowIndex:Int){
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "点进服务通知", itemId: "I2015", itemPosition:"\(rowIndex + 1)", itemName: model.title ?? "", itemContent: nil, itemTitle: model.showTime ?? "", extendParams:nil, viewController: self)
    }
}
