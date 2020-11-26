//
//  DelayRebateDetailController.swift
//  FKY
//
//  Created by 寒山 on 2019/2/19.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  待返回返利金详情列表

import UIKit

class DelayRebateDetailController: UIViewController {
    
    var pageIndex = 1
    var rebateRecordType: FKYRebateRecordType = .FKYRebateRecordTypeAll
    
    fileprivate var emptyView : DealyRebateEmptyView?
    
    var hasLoad = false
    var rebateRecordBlock:((_ balance: Double) -> ())?
    var scrollBlock: ScrollViewDidScrollBlock?
    // 下拉刷新
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.pageIndex = 1
            strongSelf.setupData(true)
        })
        header?.backgroundColor = RGBColor(0xffffff)
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
            strongSelf.setupData(false)
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    
    fileprivate lazy var viewModel: RebateDetailProvider = {
        let vm = RebateDetailProvider()
        return vm
    }()
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.fky_registerCell(cell: FKYRebateRecordInfoCell.self)
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.backgroundColor = RGBColor(0xF2F2F2)
        tableV.mj_header = self!.mjheader
        tableV.mj_footer = self!.mjfooter
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        
        return tableV
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    func shouldFirstLoadData() -> Void {
        guard hasLoad else {
            hasLoad = true
            setupData(true)
            return
        }
    }
    
    fileprivate func setupView() {
        view.backgroundColor = RGBColor(0xffffff)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let viewEmpty = DealyRebateEmptyView()
        self.view.addSubview(viewEmpty)
        viewEmpty.snp.makeConstraints({(make) in
            make.edges.equalToSuperview()
        })
        self.view.sendSubviewToBack(viewEmpty)
        emptyView =  viewEmpty
    }
    
    fileprivate func setupData(_ refresh: Bool) {
        showLoading()
        viewModel.requestRebateRecord(pageIndex: pageIndex, rebateRecordType: rebateRecordType) { [weak self,weak viewModel] (success,msg,needLoadMore) in
            guard let strongSelf = self else {
                return
            }
            guard let strongViewModel = viewModel else {
                return
            }
            strongSelf.dismissLoading()
            
            if success{
                if refresh {
                    // 刷新
                    strongSelf.tableView.mj_header.endRefreshing()
                }
                else {
                    // 加载更多
                    strongSelf.tableView.mj_footer.endRefreshing()
                }
                
                if !needLoadMore {
                    // 加载完毕
                    strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                else {
                    // 需加载更多
                    strongSelf.pageIndex += 1
                    strongSelf.tableView.mj_footer.resetNoMoreData()
                }
                strongSelf.tableView.reloadData()
                if let model = strongViewModel.mRebateRecordModel {
                    if(strongSelf.rebateRecordType == .FKYRebateRecordTypeTotal) {
                        strongSelf.rebateRecordBlock?(model.totalRebate ?? 0.00)
                    }else if(strongSelf.rebateRecordType == .FKYRebateRecordTypePending){
                        strongSelf.rebateRecordBlock?(model.pendingRebate ?? 0.00)
                    }
                }
            } else {
                if refresh {
                    // 刷新
                    strongSelf.tableView.mj_header.endRefreshing()
                }
                else {
                    // 加载更多
                    strongSelf.tableView.mj_footer.endRefreshing()
                }
                // 失败
                strongSelf.toast(msg ?? "请求失败")
                //return
            }
            if  strongViewModel.rebateRecordArray.count > 0{
                strongSelf.view.sendSubviewToBack(strongSelf.emptyView!)
            }else{
                // view.in
                strongSelf.view.bringSubviewToFront(strongSelf.emptyView!)
            }
        }
    }
}
extension DelayRebateDetailController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rebateRecordArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.rebateRecordArray[indexPath.row]
        let cell = tableView.fky_dequeueReusableCell(indexPath: indexPath) as FKYRebateRecordInfoCell
        cell.bindRebateRecordModel(
            model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = viewModel.rebateRecordArray[indexPath.row]
        if let type = model.rebateType, type == 1 {
            return WH(108)+WH(24)
        }
        return WH(86)+WH(24)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.rebateRecordArray[indexPath.row]
        if let type = model.rebateType, type == 1 {
            FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                let controller = vc as! FKY_Web
                controller.urlPath = model.protocolDetailUrl
            })
            return
        }
        
        if (model.orderId?.isEmpty == true || model.orderId == "-"){
            return
        }
        
        FKYNavigator.shared().openScheme(FKY_OrderDetailController.self, setProperty: { (svc) in
            let RCDVC = svc as! FKYOrderDetailViewController
            let orderModel = FKYOrderModel.init()
            orderModel!.orderId = model.orderId
            RCDVC.orderModel = orderModel
        }, isModal: false, animated: true)
    }
}

extension DelayRebateDetailController: UIScrollViewDelegate {
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
