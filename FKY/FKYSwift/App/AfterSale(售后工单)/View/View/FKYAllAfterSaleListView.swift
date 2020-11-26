//
//  FKYAllAfterSaleListView.swift
//  FKY
//
//  Created by hui on 2019/8/2.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYAllAfterSaleListView: UIView {
    @objc var calcelRCOrderBlock: ((FKYAllAfterSaleModel)->())?// 取消申请
    @objc var reloadMoreSaleListData : ((_ typeIndex:Int)->())? //加载更多 <1刷新2加载更多>
    @objc var viewControllerToast : ((_ toastStr:String)->())? //加载更多 <1刷新2加载更多>
    var dataSource: Array<FKYAllAfterSaleModel> = []  //数据
    //空视图
    fileprivate lazy var emptyView: ASListEmptyView = { [weak self] in
        let view = ASListEmptyView()
        view.isHidden = true
        return view
    }()
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            if let strongSelf = self {
                // 下拉刷新
                if let block = strongSelf.reloadMoreSaleListData {
                    block(1)
                }
            }
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
    }()
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            if let strongSelf = self {
                // 上拉加载更多
                if let block = strongSelf.reloadMoreSaleListData {
                    block(2)
                }
            }
            
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    public lazy var tableView: UITableView  = { [weak self] in
        var tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = WH(300)
        tableView.backgroundColor = RGBColor(0xf2f2f2)
        tableView.showsVerticalScrollIndicator = false
        //头部
        tableView.register(FKYAllSaleHeaderTableViewCell.self, forCellReuseIdentifier: "FKYAllSaleHeaderTableViewCell")
        //当个商品cell
        tableView.register(RCListProductSingleCell.self, forCellReuseIdentifier: "RCListProductSingleCell")
        //多个商品cell
        tableView.register(RCListProductListCell.self, forCellReuseIdentifier: "RCListProductListCell")
        //尾部
        tableView.register(FKYAllSaleListTableViewCell.self, forCellReuseIdentifier: "FKYAllSaleListTableViewCell")
        //分割线（wh(10)）
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FKYAllSaleTableViewCell")
        tableView.mj_footer = self?.mjfooter
        tableView.mj_header = self?.mjheader
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0//WH(213)
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
        }()
    
    init() {
        super.init(frame: CGRect.null)
        backgroundColor =  RGBColor(0xF2F2F2)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpView(){
        self.addSubview(tableView)
        self.addSubview(emptyView)
        
        emptyView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(self)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        tableView.reloadData()
    }
    //全部订单的售后列表
    @objc func configDataWithArr(_ arr :Array<FKYAllAfterSaleModel>, _ hasMore:Bool) {
        self.dataSource.removeAll()
        self.dataSource = arr
        self.tableView.reloadData()
        if self.dataSource.isEmpty == true{
            self.tableView.isHidden = true
            self.emptyView.isHidden = false
        }else{
            self.tableView.isHidden = false
            self.emptyView.isHidden = true
        }
        
        self.tableView.mj_header.endRefreshing()
        if hasMore == false {
            tableView.mj_footer.endRefreshingWithNoMoreData()
        }else{
            tableView.mj_footer.resetNoMoreData()
        }
    }
    
    @objc func endFreshView(_ hasMore:Bool){
        self.tableView.mj_header.endRefreshing()
        if hasMore == false {
            tableView.mj_footer.endRefreshingWithNoMoreData()
        }else{
            tableView.mj_footer.resetNoMoreData()
        }
    }
}

extension FKYAllAfterSaleListView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model:FKYAllAfterSaleModel = self.dataSource[indexPath.section]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FKYAllSaleHeaderTableViewCell", for: indexPath) as! FKYAllSaleHeaderTableViewCell
            cell.selectionStyle = .none
            cell.configAllSaleHeaderCell(model)
            return cell
        }else if indexPath.row == 1 {
            guard let list = model.productList, list.count > 0 else {
                return UITableViewCell.init()
            }
            if list.count == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RCListProductSingleCell", for: indexPath) as! RCListProductSingleCell
                cell.selectionStyle = .none
                cell.configAllSaleProduct(model.productList![0])
                return cell
            } else if list.count > 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RCListProductListCell", for: indexPath) as! RCListProductListCell
                cell.selectionStyle = .none
                cell.configAllSaleCell(model)
                return cell
            }
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FKYAllSaleListTableViewCell", for: indexPath) as! FKYAllSaleListTableViewCell
            cell.selectionStyle = .none
            cell.configAllSaleListCell(model)
            // 撤消申请
            cell.cancelHandle = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                FKYProductAlertView.showNewAlertView(withTitle: nil, leftTitle: "是", rightTitle: "否", message: "是否撤销该申请？", dismiss: false, handler: { (_, isRight) in
                    if !isRight {
                        if strongSelf.calcelRCOrderBlock != nil{
                            strongSelf.calcelRCOrderBlock!(model)
                        }
                    }
                })
            }
            cell.copyIdAction = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                UIPasteboard.general.string = model.orderId ?? ""
                if let block = strongSelf.viewControllerToast{
                    block("复制成功")
                }
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "FKYAllSaleTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor =  RGBColor(0xF2F2F2)
        return cell
    }
}

extension FKYAllAfterSaleListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model:FKYAllAfterSaleModel = self.dataSource[indexPath.section]
        if indexPath.row == 0 {
            return WH(41)
        }else if indexPath.row == 1 {
            guard let list = model.productList, list.count > 0 else {
                return 0.00001
            }
            return WH(95)
        }else if indexPath.row == 2 {
            return FKYAllSaleListTableViewCell.configCellHeight(model)
        }else if indexPath.row == 3{
            return WH(10)
        }
        return 0.00001
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model:FKYAllAfterSaleModel = self.dataSource[indexPath.section]
        var urlStr = ""
        if model.popFlag == "3" {
            // 1 mp退货
            urlStr = " https://m.yaoex.com/h5/rma/index.html#/getMpOcsRmaDetail?orderId=\(model.asAndWorkOrderNo ?? "")"
        }else {
            if model.easOrderType == "1" {
                // 1 售后（退换货）
                urlStr = " https://m.yaoex.com/h5/rma/index.html#/getOcsRmaDetail?applyId=\(model.asAndWorkOrderId ?? "")&orderId=\(model.childOrderId ?? "")"
            }else {
                //2 工单
                urlStr = "https://m.yaoex.com/h5/rma/index.html#/workOrderDetail?assId=\(model.asAndWorkOrderId ?? "")"
            }
        }
        FKYNavigator.shared()?.openScheme(FKY_Web.self, setProperty: { (vc) in
            let v = vc as! GLWebVC
            v.urlPath = urlStr
        })
    }
}
