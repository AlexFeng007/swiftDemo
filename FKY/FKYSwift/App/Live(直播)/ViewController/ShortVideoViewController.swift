//
//  ShortVideoViewController.swift
//  FKY
//
//  Created by 寒山 on 2020/8/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class ShortVideoViewController: UIViewController {
    
    var scrollBlock: ScrollViewDidScrollBlock?
    // var rccViewModel = ReceiveCouponCenterViewModel()
    var hasLoad = false //是否加载过
    var pageIndex = 1
    // 下拉刷新
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.pageIndex = 1
            strongSelf.setupData(true)
        })
        header?.backgroundColor = RGBColor(0xEEEEEE)
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
    fileprivate lazy var emptyView: UIView = {
        let view = UIView()
        //view.isHidden = true
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = RGBColor(0xF4F4F4)
        setupView()
        // Do any additional setup after loading the view.
    }
    func shouldFirstLoadData() -> Void {
        guard hasLoad else {
            hasLoad = true
            setupData(true)
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
extension ShortVideoViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(189)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 商品cell
        let cell: LiveListInfoCell = tableView.dequeueReusableCell(withIdentifier: "LiveListInfoCell", for: indexPath) as! LiveListInfoCell
        cell.selectionStyle = .none
       // cell.configLiveInfoCell(.LIVE_INFO_TYPE_VIDEO)
        return cell
    }
}
extension ShortVideoViewController: UIScrollViewDelegate {
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
extension ShortVideoViewController{
    fileprivate func setupData(_ refresh: Bool) {
        //showLoading()
    }
}
