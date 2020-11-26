//
//  UseCouponView.swift
//  FKY
//
//  Created by zengyao on 2018/1/19.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  检查订单之使用优惠券内容列表view

import UIKit

class UseCouponView: UIView {
    var couponList: NSMutableArray?
    var showTxt:String?
    var usageType: CouponItemUsageType?
    
    typealias requestBlock = (FKYReCheckCouponModel)->()
    var block:requestBlock?
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = WH(91)
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(UseCouponCell.self, forCellReuseIdentifier: "UseCouponCell")
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
    
    func reloadDataList() {
        tableView.reloadSections(IndexSet.init(integer: 0) , with: .fade)
        tableView.reloadEmptyDataSet()
    }
    
    func callBlock(block:@escaping requestBlock) {
        self.block = block
    }
}

extension UseCouponView: ShopCouponItemViewOperation, PlatformCouponItemViewOperation {
    func onClickSearchProductAction(_ model: AnyObject) {
        FKYNavigator.shared().openScheme(FKY_ShopCouponProductController.self, setProperty: { (vc) in
                   let viewController = vc as! CouponProductListViewController
                   if let vo = model as? FKYReCheckCouponModel {
                      viewController.couponTemplateId = vo.templateId ?? ""
                      if let id = vo.sellerCode {
                          viewController.shopId = id
                      }
                     viewController.couponName = vo.getCouponFullName()
                  }else {
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

extension UseCouponView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.couponList != nil else {
            return 0
        }
        return self.couponList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard couponList != nil, (couponList?.count)! > indexPath.row else {
            return UITableViewCell.init()
        }
        let model: FKYReCheckCouponModel = (self.couponList![indexPath.row] as! FKYReCheckCouponModel)
        let cell = UseCouponCell(style: .default, reuseIdentifier: "UseCouponCell")
        cell.config(withModel: model, self)
        cell.callBlock{[weak self] (model:FKYReCheckCouponModel) in
            if let strongSelf = self {
                if strongSelf.usageType == .USE_COUPON_ENABLED {
                    strongSelf.block!(model)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard couponList != nil, (couponList?.count)! > indexPath.row else {
            return 0
        }
        tableView.register(UseCouponCell.self, forCellReuseIdentifier: "UseCouponCell")
        let model: FKYReCheckCouponModel = (self.couponList![indexPath.row] as! FKYReCheckCouponModel)
        let height = tableView.fd_heightForCell(withIdentifier: "UseCouponCell", cacheBy: indexPath) { (cell) in
            let c = cell as! UseCouponCell
            c.config(withModel: model, self)
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard couponList != nil, (couponList?.count)! > indexPath.row else {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        let model: AnyObject = (self.couponList![indexPath.row] as! FKYReCheckCouponModel)
        if self.usageType == .USE_COUPON_ENABLED {
            self.block!(model as! FKYReCheckCouponModel)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 42))
        headView.backgroundColor = RGBColor(0xFFFAE8)
        let label = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: SCREEN_WIDTH-40, height: 42))
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = RGBColor(0xB88A43)
        label.text = self.showTxt
        headView.addSubview(label)
        if self.showTxt != nil {
            return headView
        }
        return UIView.init(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.showTxt != nil {
            return 42
        }
        return 0.01
    }
}

extension UseCouponView: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if self.usageType == .USE_COUPON_ENABLED {
            return UIImage.init(named: "img_coupon_emptypage")
        }
        return UIImage.init(named: "")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if self.usageType == .USE_COUPON_ENABLED {
            if let text = self.usageType?.emptyPageTitle() {
                let font = UIFont.systemFont(ofSize: 14)
                let attributes = [ NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: RGBColor(0x5c5c5c)]
                return NSAttributedString.init(string: text, attributes: attributes)
            }
        }
        return NSAttributedString.init(string: "")
    }
}

