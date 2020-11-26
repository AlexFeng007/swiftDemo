//
//  FKYNewPrdSetHisListViewController.swift
//  FKY
//
//  Created by yyc on 2020/3/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYNewPrdSetHisListViewController: UIViewController {
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            if let strongSelf = self {
                strongSelf.getNewPrdSetList(true)
            }
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
    }()
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            if let strongSelf = self {
                strongSelf.getNewPrdSetList(false)
            }
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    
    fileprivate lazy var newPrdListTableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .grouped)
        tableV.backgroundColor = RGBColor(0xF4F4F4)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.estimatedRowHeight = WH(150) //最多
        tableV.rowHeight = UITableView.automaticDimension // 设置高度自适应
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(FKYNewPrdSetListTableViewCell.self, forCellReuseIdentifier: "FKYNewPrdSetListTableViewCell")
        tableV.mj_header = self?.mjheader
        tableV.mj_footer = self?.mjfooter
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    fileprivate lazy var emptyView : FKYNoNewPrdListDataView = {
        let view = FKYNoNewPrdListDataView()
        view.resetNewPrdListEmpty()
        view.isHidden = true
        return view
    }()
    //请求工具类
    fileprivate lazy var newPrdServiece : FKYNewPrdSetServiece = {
        let serviece = FKYNewPrdSetServiece()
        return serviece
    }()
    var navBar : UIView?
    var itemArr = [FKYNewPrdSetItemModel]() //请求数据
    //MARK:生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationView()
        self.setContentView()
        self.getNewPrdSetList(true)
    }
    deinit {
        print(" FKYNewPrdSetHisListViewController deinit~!@")
    }
    
}
//MARK:ui相关
extension FKYNewPrdSetHisListViewController {
    func setNavigationView() {
        self.navBar = {
            if let _ = self.NavigationBar {
            } else {
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            if let strongSelf = self {
                FKYNavigator.shared().pop()
                // 埋点
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName:nil, itemId: ITEMCODE.NEW_PRODUCT_REGISTER_LIST_BACK_CODE.rawValue, itemPosition: "1", itemName: "返回", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            }
        }
        self.navBar!.backgroundColor = bg1
        self.fky_setupTitleLabel("登记历史")
        self.fky_hiddedBottomLine(false)
    }
    func setContentView() {
        self.view.backgroundColor = bg2
        self.view.addSubview(self.newPrdListTableView)
        self.newPrdListTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        self.view.addSubview(self.emptyView)
        self.emptyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
}
//MARK:网络请求相关
extension FKYNewPrdSetHisListViewController {
    fileprivate func getNewPrdSetList(_ isFresh:Bool) {
        if isFresh == true {
            self.showLoading()
            self.mjfooter.resetNoMoreData()
        }
        self.newPrdServiece.getNewProductList(isFresh) {[weak self] (hasMoreData,dataArr, tip) in
            guard let strongSelf = self else{
                return
            }
            if isFresh == true {
                strongSelf.dismissLoading()
                strongSelf.mjheader.endRefreshing()
            }
            if hasMoreData == true {
                strongSelf.mjfooter.endRefreshing()
            }else {
                strongSelf.mjfooter.endRefreshingWithNoMoreData()
            }
            if let msg = tip {
                strongSelf.toast(msg)
            }else {
                //请求成功
                if let arr = dataArr, arr.count > 0 {
                    if isFresh == true {
                        strongSelf.itemArr.removeAll()
                        strongSelf.itemArr = arr
                    }else {
                        strongSelf.itemArr = strongSelf.itemArr + arr
                    }
                    strongSelf.newPrdListTableView.reloadData()
                }
                //判断是否显示空态页面
                if strongSelf.itemArr.count == 0 {
                    strongSelf.emptyView.isHidden = false
                }else {
                    strongSelf.emptyView.isHidden = true
                }
            }
        }
    }
}
//MARK:UITableViewDataSource,UITableViewDelegate代理相关
extension FKYNewPrdSetHisListViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.itemArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FKYNewPrdSetListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYNewPrdSetListTableViewCell", for: indexPath) as! FKYNewPrdSetListTableViewCell
        cell.configNewPrdSetListTableViewCellData(self.itemArr[indexPath.section])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(10)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spaceView = UIView()
        spaceView.backgroundColor = RGBColor(0xF4F4F4)
        return spaceView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.itemArr[indexPath.section]
        FKYNavigator.shared().openScheme(FKY_New_Product_Set_Detail.self, setProperty: { (vc) in
            let controller = vc as! FKYNewPrdSetDeatilViewController
            controller.increateId = "\(model.increateId ?? 0)"
        }, isModal: false)
        // 埋点
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName:nil, itemId: ITEMCODE.NEW_PRODUCT_REGISTER_LIST_CLICK_CODE.rawValue, itemPosition: "\(indexPath.section+1)", itemName: "点进登记详情", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    }
}

