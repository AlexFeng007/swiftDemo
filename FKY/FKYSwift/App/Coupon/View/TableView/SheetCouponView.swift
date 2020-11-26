//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//  优惠券弹窗 

import UIKit

typealias CouponSheetShouldReopenClousre = ()->()

class FKYCouponSheetView: WUPopView {
    @objc static var CART_REOPEN_FLAG_INDEX = -1
    @objc static var PRODUCTDETAIL_REOPEN_FLAG_INDEX = -1
    
    // MARK: - properties
    var reopenHandler: CouponSheetShouldReopenClousre?
    fileprivate var viewModel: FKYCouponSheetViewModel? = FKYCouponSheetViewModel()
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = WH(99)
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        tableView.register(ShopCouponCell.self, forCellReuseIdentifier: "ShopCouponCell")
        return tableView
        }()
    
    fileprivate lazy var titleLabel: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0x5c5c5c)
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.text = "优惠券"
        return label
    }()
    
    fileprivate lazy var receiveAbleButton: UIButton! = {
        let button = UIButton()
        button.setTitleColor(RGBColor(0xf75f5d), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        button.setTitle("可领取的优惠券", for: .normal)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](_) in
            guard (self?.viewModel?.resultOfSwitchUsageTypeToReceive())! else { return }
            button.setTitleColor(RGBColor(0xf75f5d), for: .normal)
            self?.alreadyReceivedButton.setTitleColor(RGBColor(0x979797), for: .normal)
            self?.adapterView()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    fileprivate lazy var alreadyReceivedButton: UIButton! = {
        let button = UIButton()
        button.setTitleColor(RGBColor(0x979797), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        button.setTitle("已领取的优惠券", for: .normal)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard (self?.viewModel?.resultOfSwitchUsageTypeToReceived())! else { return }
            button.setTitleColor(RGBColor(0xf75f5d), for: .normal)
            self?.receiveAbleButton.setTitleColor(RGBColor(0x979797), for: .normal)
            self?.adapterView()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // MARK: - life cycle
    /// 提供给商品详情页的类初始化方法
    @objc static func show(withEnterpriseId enterpriseId: String, spuCode: String, reopenHandler: @escaping CouponSheetShouldReopenClousre) {
        resetReopenFlag()
        let sheet = FKYCouponSheetView(withSpuCode: spuCode, enterpriseId: enterpriseId)
        sheet.tapDismissEnabled = true
        sheet.show()
        sheet.reopenHandler = reopenHandler
    }
    
    /// 提供给购物车页的类初始化方法
    @objc static func show(withEnterpriseId enterpriseId: String, reopenHandler: @escaping CouponSheetShouldReopenClousre) {
        resetReopenFlag()
        let sheet = FKYCouponSheetView(withEnterpriseId: enterpriseId)
        sheet.tapDismissEnabled = true
        sheet.show()
        sheet.reopenHandler = reopenHandler
    }
    
    convenience init() {
        fatalError("不可调用此方法初始化本类!")
    }
    
    convenience init(withSpuCode spuCode: String, enterpriseId: String) {
        self.init(frame: .zero)
        viewModel?.usageType = .PRODUCTDETAIL_GET_COUPON_RECEIVE
        viewModel?.spuCode = spuCode
        viewModel?.enterpriseId = enterpriseId
        adapterView()
    }
    
    convenience init(withEnterpriseId enterpriseId: String) {
        self.init(frame: .zero)
        viewModel?.usageType = .CART_GET_COUPON_RECEIVE
        viewModel?.enterpriseId = enterpriseId
        adapterView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override
extension FKYCouponSheetView {

}

// MARK: - delegates
extension FKYCouponSheetView: ShopCouponItemViewOperation {
    /// 查看更多商品
    func onClickSearchProductAction(_ model: AnyObject) {
        FKYNavigator.shared().openScheme(FKY_ShopCouponProductController.self, setProperty: { (vc) in
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
           } else {
               print("未知优惠券item对象！")
           }
        })
        if (self.reopenHandler != nil) {
            self.reopenHandler!()
        }
        self.hide()
    }
    
    /// 领取优惠券
    func onClickReceiveCouponAction(_ model: AnyObject) {
        guard let m = model as? CouponTempModel else {
            return
        }
        viewModel?.receiveCoupon(m, { (msg) in
            self.makeToast(msg)
            self.tableView.reloadData()
        })
    }
}

extension FKYCouponSheetView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.models.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ShopCouponCell(style: .default, reuseIdentifier: "ShopCouponCell")
        let models: Array<AnyObject> = (viewModel?.models)!
        let model: AnyObject? = models[indexPath.row]
        if (model != nil) {
            cell.config(withModel: model!, usageType: (self.viewModel?.usageType)!, operation: self)
        }
        return cell
    }
}

extension FKYCouponSheetView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.register(ShopCouponCell.self, forCellReuseIdentifier: "ShopCouponCell")
        let models: Array<AnyObject> = (viewModel?.models)!
        let model: AnyObject? = models[indexPath.row]
        let height = tableView.fd_heightForCell(withIdentifier: "ShopCouponCell", cacheBy: indexPath) { [weak self](cell) in
            let c = cell as! ShopCouponCell
            if (model != nil) {
                c.config(withModel: model!, usageType: (self?.viewModel?.usageType)!, operation: self!)
            }
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FKYCouponSheetView: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "img_coupon_emptypage")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = self.viewModel?.usageType?.emptyPageTitle()
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [ NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: RGBColor(0x5c5c5c)]
        return NSAttributedString.init(string: text!, attributes: attributes)
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return WH(-10)
    }
}

// MARK: - action
extension FKYCouponSheetView {

}

// MARK: - private methods
extension FKYCouponSheetView {
    func adapterView() {
        func dynamicBinding() {
            self.makeToastActivity()
            self.viewModel?.dynamicBinding { [weak self] (msg) in
                if (msg != nil) {
                    self?.makeToast(msg)
                }
                self?.hideToastActivity()
                self?.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
                self?.tableView.reloadData()
            }
        }; dynamicBinding()
    }
    
    static func resetReopenFlag() {
        CART_REOPEN_FLAG_INDEX = -1
        PRODUCTDETAIL_REOPEN_FLAG_INDEX = -1
    }
}

// MARK: - ui
extension FKYCouponSheetView {
    func setupView() {
        self.type = .sheet
        self.backgroundColor = RGBColor(0xf9f9f9)
        self.isUserInteractionEnabled = true
        
        setContentCompressionResistancePriority(UILayoutPriority.required , for: .horizontal)
        setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .vertical)
        
        let padding = CGFloat(10.0)
        let lineWH = CGFloat(0.5)
        
        /// 优惠券标题
        addSubview(titleLabel)
        /// 标题下方细线
        let lineColor = RGBColor(0x979797).withAlphaComponent(0.3)
        let lineUnderTitleLabel = UIView()
        lineUnderTitleLabel.backgroundColor = lineColor
        addSubview(lineUnderTitleLabel)
        /// 可领取的优惠券标签
        addSubview(receiveAbleButton)
        /// 可领取优惠券标签右边细线
        let lineOnReceiveLabelRight = UIView()
        lineOnReceiveLabelRight.backgroundColor = lineColor
        addSubview(lineOnReceiveLabelRight)
        /// 已领取的优惠券标签
        addSubview(alreadyReceivedButton)
        /// 优惠券列表
        addSubview(tableView)

        snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(WH(padding))
            make.centerX.equalTo(self)
        }
        
        lineUnderTitleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(lineWH)
            make.left.right.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(padding))
        }
        
        receiveAbleButton.snp.makeConstraints { (make) in
            make.width.equalTo((SCREEN_WIDTH-lineWH)/2)
            make.left.equalTo(self)
            make.top.equalTo(lineUnderTitleLabel.snp.bottom).offset(WH(padding))
        }

        lineOnReceiveLabelRight.snp.makeConstraints { (make) in
            make.width.equalTo(lineWH)
            make.left.equalTo(receiveAbleButton.snp.right)
            make.centerY.equalTo(receiveAbleButton)
            make.height.equalTo(receiveAbleButton)
        }
        
        alreadyReceivedButton.snp.makeConstraints { (make) in
            make.width.equalTo(receiveAbleButton)
            make.left.equalTo(lineOnReceiveLabelRight.snp.right)
            make.centerY.equalTo(receiveAbleButton)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.height.equalTo(WH(312))
            make.left.right.equalTo(self)
            make.top.equalTo(receiveAbleButton.snp.bottom).offset(padding)
        }
        
        /// iPhoneX设备底部间隙
        var bottomSafeAreaInsets = CGFloat.init(0)
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                bottomSafeAreaInsets = (insets?.bottom)!
            }
        }
        let needBottomView = bottomSafeAreaInsets > CGFloat.init(0)
        let bottomInsetView = UIView()
        if needBottomView {
            bottomInsetView.backgroundColor = .white
            addSubview(bottomInsetView)
            bottomInsetView.snp.makeConstraints({ (make) in
                make.left.right.equalTo(self)
                make.top.equalTo(tableView.snp.bottom)
                make.height.equalTo(bottomSafeAreaInsets)
            })
        }
        
        snp.makeConstraints { (make) in
            make.bottom.equalTo(needBottomView ? bottomInsetView.snp.bottom :  tableView.snp.bottom)
        }
    }
}
