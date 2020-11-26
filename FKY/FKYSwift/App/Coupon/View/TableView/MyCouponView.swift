//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//  我的优惠券列表 

import UIKit
import MJRefresh

protocol MyCouponViewOperation {
    func onTableViewRefreshAction() -> Void
    func onTableViewLoadNextPageAction() -> Void
}
class MyCouponView: UIView, MyCouponViewInterface {
    
    // MARK: - properties
    var operation: MyCouponViewOperation?
    var value: MyCouponViewModelInterface?
    var viewModel: MyCouponViewModelInterface? {
        
        get { return value }
        set {
            value = newValue
            if tableView.mj_header.isRefreshing() {
                tableView.mj_header.endRefreshing()
                tableView.mj_footer.resetNoMoreData()
            }
            if value?.hasNextPage! == false {
                tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                tableView.mj_footer.endRefreshing()
            }
            tableView.reloadData()
        }
    }
    
    fileprivate lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = WH(91)
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 20))
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(ShopCouponCell.self, forCellReuseIdentifier: "ShopCouponCell")
        tableView.register(PlatformCouponCell.self, forCellReuseIdentifier: "PlatformCouponCell")
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            guard let strongSelf = self else {
                return
            }
            strongSelf.operation?.onTableViewRefreshAction()
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            // 上拉加载更多
            strongSelf.operation?.onTableViewLoadNextPageAction()
        })
        tableView.mj_footer.isAutomaticallyHidden = true
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
    
    // MARK: - MyCouponViewInterface
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
}

extension MyCouponView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.models.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model: CouponModel = (viewModel?.models[indexPath.row])!
        if model.tempType == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCouponCell") as? ShopCouponCell
            cell?.config(withModel: model, usageType: (self.viewModel?.usageType)!, operation: self)
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlatformCouponCell") as? PlatformCouponCell
            cell?.config(withModel: model, usageType: (self.viewModel?.usageType)!, operation: self)
            return cell!
        }
    }
}

extension MyCouponView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model: CouponModel = (viewModel?.models[indexPath.row])!
        if model.tempType == 0 {
            let height = tableView.fd_heightForCell(withIdentifier: "ShopCouponCell", cacheBy: indexPath) { [weak self](cell) in
                guard let strongSelf = self else {
                    return
                }
                let c = cell as! ShopCouponCell
                c.config(withModel: model, usageType: (strongSelf.viewModel?.usageType)!, operation: strongSelf)
            }
            return height
        } else {
            let height = tableView.fd_heightForCell(withIdentifier: "PlatformCouponCell", cacheBy: indexPath) { [weak self](cell) in
                guard let strongSelf = self else {
                    return
                }
                let c = cell as! PlatformCouponCell
                c.config(withModel: model, usageType: (strongSelf.viewModel?.usageType)!, operation: strongSelf)
            }
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MyCouponView: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if let _ = self.viewModel?.usageType.emptyPageTitle() {
            return UIImage.init(named: "img_coupon_emptypage")
        }
        return UIImage.init(named: "")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if let text = self.viewModel?.usageType.emptyPageTitle() {
            let font = UIFont.systemFont(ofSize: 14)
            let attributes = [ NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: RGBColor(0x5c5c5c)]
            return NSAttributedString.init(string: text, attributes: attributes)
        }
        return NSAttributedString.init(string: "")
    }
}

// MARK: - action
extension MyCouponView: ShopCouponItemViewOperation, PlatformCouponItemViewOperation {
    func onClickSearchProductAction(_ model: AnyObject) {
        FKYNavigator.shared().openScheme(FKY_ShopCouponProductController.self, setProperty: {[weak self] (vc) in
            guard let strongSelf = self else {
                return
            }
            let viewController = vc as! CouponProductListViewController
            if let vo = model as? CouponTempModel {
                viewController.couponTemplateId = vo.templateCode ?? ""
                if let id = vo.enterpriseId {
                    viewController.shopId = id
                }
                viewController.couponName = vo.couponFullName ?? ""
            } else if let vo = model as? CouponModel {
                viewController.couponTemplateId = vo.couponTempCode ?? ""
                viewController.shopId = (vo.tempEnterpriseId ?? "0")
                viewController.couponName = vo.couponFullName ?? ""
                viewController.couponCode = vo.couponCode ?? ""
            } else {
                print("未知优惠券item对象！")
            }
        })
    }
    
    func onClickReceiveCouponAction(_ model: AnyObject) {
        
    }
    
    func onClickUseShopAction(_ model: AnyObject){
        self.tableView.reloadData()
    }
    
    
}

// MARK: - private methods
extension MyCouponView {
    
}
