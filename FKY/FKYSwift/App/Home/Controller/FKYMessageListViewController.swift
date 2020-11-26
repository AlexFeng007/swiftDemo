//
//  FKYMessageListViewController.swift
//  FKY
//
//  Created by hui on 2019/3/13.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYMessageListViewController: UIViewController {
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            self?.getMessageList(true)
            
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
    }()
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            self?.getMessageList(false)
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
        tableV.register(FKYMessageTableViewCell.self, forCellReuseIdentifier: "FKYMessageTableViewCell")
        tableV.mj_header = self?.mjheader
        tableV.mj_footer = self?.mjfooter
        tableV.tableHeaderView = {
            let bgView = UIView.init(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
            bgView.backgroundColor = RGBColor(0xF4F4F4)
            return bgView
        }()
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    fileprivate var navBar: UIView?
    //请求类
    fileprivate lazy var messageListProvider : FKYMessageProvider = {
        return FKYMessageProvider()
    }()
    //消息list
    fileprivate var messageListModel:[FKYMessageModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMessageList(true)
    }
    
}
// MARK:ui相关
extension FKYMessageListViewController {
    //MARK: 导航栏
    fileprivate func setupNavigationBar() {
        navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        fky_setupTitleLabel("消息中心")
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
}
// MARK:数据请求相关
extension FKYMessageListViewController {
    func getMessageList(_ isFresh:Bool) {
        if isFresh == true,self.messageListModel==nil {
            self.showLoading()
        }
        messageListProvider.getMessageList(isFresh) { [weak self] (data, msg) in
            if isFresh == true ,self?.messageListModel==nil{
                self?.dismissLoading()
            }
            if self?.messageListProvider.hasNext() == true {
                self?.mjfooter.resetNoMoreData()
            }else {
                self?.mjfooter.endRefreshingWithNoMoreData()
            }
            self?.mjheader.endRefreshing()
            if let list = data {
                if isFresh == true {
                    self?.messageListModel = list
                }else{
                    self?.messageListModel = self?.messageListModel ?? [] + list
                }
                self?.messageTab.reloadData()
            }else {
                self?.toast(msg)
            }
        }
    }
}
// MARK:UITableViewDataSource,UITableViewDelegate代理相关
extension FKYMessageListViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = self.messageListModel ,arr.count > 0 {
            return arr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FKYMessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYMessageTableViewCell", for: indexPath) as! FKYMessageTableViewCell
        if let arr = self.messageListModel {
            cell.configCell(arr[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let arr = self.messageListModel {
            return FKYMessageTableViewCell.configCellHeight(arr[indexPath.row])
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //fky://product/productionDetail?productId=8353YCYW371215&sellerId=8353&pushType=x
        if let arr = self.messageListModel {
            let model = arr[indexPath.row]
            infoSelBI(model)
            if model.type == "8"{
                //资质过期消息列表
                FKYNavigator.shared().openScheme(FKY_ExpiredTipsMessageVC.self, setProperty: { (vc) in
                }, isModal: false)
            }else if model.type == "4"{
               // 商品降价消息列表
                FKYNavigator.shared().openScheme(FKY_PriceChangeNoticeVC.self, setProperty: { (vc) in
                }, isModal: false)
            }else{
                FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                    let v = vc as! GLWebVC
                    v.urlPath = model.jumpUrl
                    v.navigationController?.isNavigationBarHidden = true
                }, isModal: true)
                model.unreadCount = 0
                tableView.reloadRows(at:[indexPath], with: .none)
            }
        }
         
    }
}
extension FKYMessageListViewController{
    //8：资质证照   9：交易物流  10：退换货售后  0：im
    func infoSelBI(_ model:FKYMessageModel){
        var messsageName = ""
        var messageIndex = "0"
        var sectionName = ""
        var itemId = ""
        var itemTitle = ""
        if  model.type ==  "8"{
            messsageName = "资质证照"
            messageIndex = "3"
            sectionName = "固定板块"
            itemId = "I2011"
        }else if  model.type ==  "4"{
            messsageName = "服务通知"
            messageIndex = "4"
            sectionName = "固定板块"
            itemId = "I2011"
        }else if  model.type ==  "9"{
            messsageName = "退换货/售后"
            messageIndex = "2"
            sectionName = "固定板块"
            itemId = "I2011"
        }else if  model.type ==  "10"{
            messsageName = "交易物流"
            messageIndex = "1"
            sectionName = "固定板块"
            itemId = "I2011"
        }else if  model.type ==  "0"{
            messsageName = "与商家沟通"
            messageIndex = model.imPosition ?? "0"
            sectionName = "IM聊天"
            itemId = "I2012"
            itemTitle = model.title ?? "0"
        }
         FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: sectionName, itemId: itemId, itemPosition: messageIndex, itemName: messsageName, itemContent: nil, itemTitle:itemTitle, extendParams:nil, viewController: self)
    }
}
