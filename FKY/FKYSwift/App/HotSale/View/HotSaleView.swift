//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

import UIKit
import MJRefresh

protocol HotSaleViewOperation {
    func onTableViewRefreshAction() -> Void
    func onTableViewLoadNextPageAction() -> Void
    func onClickRowProduct(withAction action: TemplateAction)
}


class HotSaleView: UIView, HotSaleViewInterface {
    
    // MARK: - properties
    var operation: HotSaleViewOperation?
    var value: HotSaleViewModelInterface?
    var viewModel: HotSaleViewModelInterface? {
        get { return value }
        set {
            value = newValue
            if tableView.mj_header.isRefreshing() {
                tableView.mj_header.endRefreshing()
//                tableView.mj_footer.resetNoMoreData()
            }
//            if value?.hasNextPage == false {
//                tableView.mj_footer.endRefreshingWithNoMoreData()
//            } else {
//                tableView.mj_footer.endRefreshing()
//            }
            // 若在此处调用reloadData，则用xcode9.3打包后运行，tableview不显示数据
            //tableView.reloadData()
        }
    }
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = WH(91)
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(HotSaleCell.self, forCellReuseIdentifier: "HotSaleCell")
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            self?.operation?.onTableViewRefreshAction()
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
//        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
//            [weak self] in
//            // 上拉加载更多
//            self?.operation?.onTableViewLoadNextPageAction()
//        })
//        tableView.mj_footer.isAutomaticallyHidden = true
        return tableView
        }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - HotSaleViewInterface
    func toast(_ msg: String?) {
        if msg != nil {
            makeToast(msg)
        }
    }
    
    func showLoading() {
        makeToastActivity()
    }
    
    func hideLoading() {
        hideToastActivity()
    }
    
    // 刷新
    func updateHotSaleContent() {
        tableView.reloadData()
    }
}

extension HotSaleView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.models.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel?.models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotSaleCell") as? HotSaleCell
        cell?.config(withModel: model!, atIndexPath: indexPath)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "以近7天销售数额数据进行排名"
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.backgroundColor = RGBColor(0xf4f4f4)
        label.textAlignment = .center
        return label
    }
}

extension HotSaleView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = viewModel?.models[indexPath.row]
        let height = tableView.fd_heightForCell(withIdentifier: "HotSaleCell", cacheBy: indexPath) { (cell) in
            let c = cell as! HotSaleCell
            c.config(withModel: model!, atIndexPath: indexPath)
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(24)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = viewModel?.models[indexPath.row]
        let index = indexPath.row + 1
        let action = TemplateAction()
        action.actionParams = [HomeString.ACTION_KEY: model!]
        action.sectionCode = "\(SECTIONCODE.TOP_SEARCH_APP_Category.rawValue)\(self.index)"
        if viewModel?.type == .week {
            action.itemCode = "\(ITEMCODE.TOP_SEARCH_APP_Topsellfield.rawValue)\(self.index)"
            action.itemPosition = "\(ITEMCODE.TOP_SEARCH_APP_Topsellfield.rawValue)\(index)"
        } else {
            action.itemCode = "\(ITEMCODE.TOP_SEARCH_APP_Topsearchfield.rawValue)\(self.index)"
            action.itemPosition = "\(ITEMCODE.TOP_SEARCH_APP_Topsearchfield.rawValue)\(index)"
        }
        operation?.onClickRowProduct(withAction: action)
    }
}

extension HotSaleView: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [ NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: RGBColor(0x5c5c5c)]
        return NSAttributedString.init(string: "暂无数据哦", attributes: attributes)
    }
}

// MARK: - action
extension HotSaleView {

}

// MARK: - private methods
extension HotSaleView {
    
}
