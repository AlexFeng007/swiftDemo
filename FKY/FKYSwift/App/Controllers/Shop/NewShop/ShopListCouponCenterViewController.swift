//
//  ShopListCouponCenterViewController.swift
//  FKY
//
//  Created by 乔羽 on 2018/12/4.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  领券中心

import UIKit

class ShopListCouponCenterViewController: UIViewController {

    // MARK: - properties
    fileprivate lazy var viewModel: ShopListCouponCenterViewModel = ShopListCouponCenterViewModel()
    
    fileprivate var navBar: UIView?
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableView = UITableView(frame: CGRect.null, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = WH(101)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ShopListCouponCenterCell.self, forCellReuseIdentifier: "ShopListCouponCenterCell")
        tableView.mj_header = self?.mjheader
        tableView.mj_footer = self?.mjfooter
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()
    
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.page = 1
            strongSelf.getCouponListData(.header)
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
    }()
    
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.page += 1
            strongSelf.getCouponListData(.footer)
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    
    // 无数据展示时的空态视图
    fileprivate lazy var tipView: ShopListCouponCenterEmptyView = {
        let view = ShopListCouponCenterEmptyView()
        return view
    }()
    
    // 返回顶部按钮
    fileprivate lazy var btnBackTop: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setBackgroundImage(UIImage.init(named: "btn_back_top"), for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    
    //MARK: Life Style
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        getZzStatus()
    }
    
    func setupView() {
        navBar = {
            if let _ = self.NavigationBar {
            } else {
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        navBar?.backgroundColor = UIColor.white
        fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        fky_setupTitleLabel("领券中心")
        NavigationTitleLabel!.fontTuple = t14
        NavigationTitleLabel!.textColor = RGBColor(0x333333)
        NavigationTitleLabel!.font = UIFont.boldSystemFont(ofSize: WH(18))
        fky_hiddedBottomLine(false)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        
        view.addSubview(btnBackTop)
        btnBackTop.isHidden = true
        btnBackTop.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-17)
            make.bottom.equalTo(self.view).offset(-30)
            make.height.equalTo(44)
            make.width.equalTo(44)
        }
    }
    
    // 查询资质
    fileprivate func getZzStatus() {
        showLoading()
        viewModel.requestZzStatus { [weak self] (status) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            switch status {
            case 1,3,4,6: // 资质审核通过
                // 请求数据
                strongSelf.getCouponListData(.loading)
                break
            case -1,11,12,13,14: // 资质未提交审核
                strongSelf.showTipView()
                strongSelf.tipView.type = .noSubmitAudit
            case 2,7: // 资质提交审核未通过
                strongSelf.showTipView()
                strongSelf.tipView.type = .noAudit
            case 0,5: // 资质提交审核中
                strongSelf.showTipView()
                strongSelf.tipView.type = .auditing
            default:
                strongSelf.toast("请求失败")
            }
        }
    }
    
    // 显示空态视图
    fileprivate func showTipView() {
        view.addSubview(tipView)
        tipView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo((navBar?.snp.bottom)!)
        }
        tipView.isHidden = false
        tableView.isHidden = true
    }
    
    // 若请求成功，但无数据，则显示空态视图
    fileprivate func checkProductListStatus() {
        let nodata = viewModel.dataSource.count <= 0
        if nodata {
            // 无数据
            tableView.isHidden = true
            tipView.isHidden = false
            
            showTipView()
            tipView.type = .noData
        }
        else {
            // 有数据
            tableView.isHidden = false
            tipView.isHidden = true
        }
    }
    
    fileprivate func getCouponListData(_ type: RefreshType) {
        switch type {
        case .loading:
            showLoading()
        default:
            break
        }
        viewModel.getCouponListData(success: { [weak self] in
            // 成功
            guard let strongSelf = self else {
                return
            }
            switch type {
            case .loading:
                strongSelf.dismissLoading()
            case .header:
                strongSelf.mjheader.endRefreshing()
            case .footer:
                if strongSelf.viewModel.hasMore {
                    strongSelf.mjfooter.endRefreshing()
                } else {
                    strongSelf.mjfooter.endRefreshingWithNoMoreData()
                }
            }
            strongSelf.tableView.reloadData()
            strongSelf.checkProductListStatus()
        }) { [weak self] (msg) in
            // 失败
            guard let strongSelf = self else {
                return
            }
            switch type {
            case .loading:
                strongSelf.dismissLoading()
            case .header:
                strongSelf.mjheader.endRefreshing()
            case .footer:
                strongSelf.viewModel.page -= 1
                if strongSelf.viewModel.hasMore {
                    strongSelf.mjfooter.endRefreshing()
                } else {
                    strongSelf.mjfooter.endRefreshingWithNoMoreData()
                }
            }
            strongSelf.toast(msg)
        }
    }
    
    func getCoupon(_ model: ShopListCouponModel) {
        showLoading()
        viewModel.receiveCoupon(model) { [weak self] (isSuccess, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if isSuccess {
                strongSelf.tableView.reloadData()
            } else {
                strongSelf.toast(msg)
            }
        }
    }
}

extension ShopListCouponCenterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(101)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(15)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
}

extension ShopListCouponCenterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopListCouponCenterCell", for: indexPath) as! ShopListCouponCenterCell
        let model = viewModel.dataSource[indexPath.section]
        cell.configView(model)
        cell.clickBlock = { [weak self] (isGet, isLimit) in
            if isGet {
                //去下单
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.SHOPLIST_COUPON_SECTION_CODE.rawValue, sectionPosition: "\(indexPath.section+1)", sectionName: "优惠券\(indexPath.section+1)", itemId: ITEMCODE.SHOPLIST_COUPON_CLICK_CODE.rawValue, itemPosition: "2", itemName: "去下单", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
                if isLimit {
                    //部分单品
                    FKYNavigator.shared().openScheme(FKY_ShopCouponProductController.self, setProperty: { (vc) in
                       let viewController = vc as! CouponProductListViewController
                       viewController.couponTemplateId = model.templateCode ?? ""
                         if let id = model.enterpriseId {
                            viewController.shopId  = id
                        }
                       viewController.couponName = model.couponFullName ?? ""
                   })
                } else {
                    //店铺通用
                    FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                        let viewController = vc as! FKYNewShopItemViewController
                        viewController.shopId = model.enterpriseId
                    })
                }
            } else {
                //立即领取
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: SECTIONCODE.SHOPLIST_COUPON_SECTION_CODE.rawValue, sectionPosition: "\(indexPath.section+1)", sectionName: "优惠券\(indexPath.section+1)", itemId: ITEMCODE.SHOPLIST_COUPON_CLICK_CODE.rawValue, itemPosition: "1", itemName: "立即领取", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
                
                self?.getCoupon(model)
            }
        }
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset_y = scrollView.contentOffset.y
        if offset_y >= SCREEN_HEIGHT/2 {
            self.btnBackTop.isHidden = false
        }
        else {
            self.btnBackTop.isHidden = true
        }
    }
}
