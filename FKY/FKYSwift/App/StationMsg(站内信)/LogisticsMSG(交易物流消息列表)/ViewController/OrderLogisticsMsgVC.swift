//
//  OrderLogisticsMsgVC.swift
//  FKY
//
//  Created by 寒山 on 2020/9/17.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class OrderLogisticsMsgVC: UIViewController {
    
    fileprivate var viewModel: HomeMesageViewModel = {
        let vm = HomeMesageViewModel()
        vm.type = 9
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
            self?.getALLogisticsInfo()
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
        tableV.rowHeight = WH(167)
        tableV.estimatedRowHeight = WH(167)
        tableV.estimatedSectionHeaderHeight = 0
        tableV.estimatedSectionFooterHeight = 0
        tableV.backgroundColor = RGBColor(0xF4F4F4)
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(HomeLogisticsMsgInfoCell.self, forCellReuseIdentifier: "HomeLogisticsMsgInfoCell")
        tableV.mj_header = self?.mjheader
        tableV.mj_footer = self?.mjfooter
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
        print("OrderLogisticsMsgVC deinit~!@")
    }
    
}
// MARK:ui相关
extension OrderLogisticsMsgVC {
    //MARK: 导航栏
    fileprivate func setupNavigationBar() {
        navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        fky_setupTitleLabel("交易物流")
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
extension OrderLogisticsMsgVC {
    //获取全部商品
    @objc func getALLogisticsInfo(){
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
        self.getALLogisticsInfo()
    }
}
// MARK:UITableViewDataSource,UITableViewDelegate代理相关
extension OrderLogisticsMsgVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   self.viewModel.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeLogisticsMsgInfoCell = tableView.dequeueReusableCell(withIdentifier: "HomeLogisticsMsgInfoCell", for: indexPath) as! HomeLogisticsMsgInfoCell
        cell.selectionStyle = .none
        let model = self.viewModel.dataSource[indexPath.row]
        cell.configCell(model)
        //进入店铺
        cell.enterShopBlock = {[weak self] in
            if let strongSelf = self {
               // let model = strongSelf.viewModel.dataSource[indexPath.row]
                strongSelf.infoSelBI(model,0)
                FKYNavigator.shared().openScheme(FKY_ShopItem.self) { (vc) in
                    let v = vc as! FKYNewShopItemViewController
                    if let _ = model.sellerInfo?.seller_code {
                        v.shopId = "\(model.sellerInfo?.seller_code ?? "")"
                    }
                }
            }
        }
        //查看物流
        cell.checkLogisticsBlock = {[weak self] in
            if let strongSelf = self {
                //let model = strongSelf.viewModel.dataSource[indexPath.row]
                strongSelf.infoSelBI(model,1)
                if let app = UIApplication.shared.delegate as? AppDelegate {
                    if let url = model.url, url.isEmpty == false {
                        app.p_openPriveteSchemeString(url)
                    }
                }
               
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(167)
    }
    
}
extension OrderLogisticsMsgVC{
    func infoSelBI(_ model:ExpiredTipsInfoModel,_ rowIndex:Int){
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I6509", itemPosition:"\(rowIndex + 1)", itemName: "物流订单消息", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: self)
    }
}
