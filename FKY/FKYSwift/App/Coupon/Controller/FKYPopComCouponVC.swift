//
//  FKYPopComCouponVC.swift
//  FKY
//
//  Created by hui on 2019/8/26.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit
//优惠券弹框
let CONTENT_COUPON_VIEW_H = WH(531) + bootSaveHeight() //内容视图的高度

@objc
class FKYPopComCouponVC: UIViewController {
    
    //MARK: - Property
    // 响应视图
    fileprivate lazy var viewDismiss: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = "优惠券"
        lbl.textColor = RGBColor(0x000000)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(18))
        lbl.textAlignment = .center
        return lbl
    }()
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = WH(200)
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(18)))
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(14)))
        tableView.register(FKYComCouponTableViewCell.self, forCellReuseIdentifier: "FKYComCouponTableViewCell")
        
        return tableView
        }()
    
    // 内容视图...<包含所有内容的容器视图>
    fileprivate lazy var viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        // top
        view.addSubview(self.viewTop)
        self.viewTop.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(WH(56))
        }
        
        // tableview
        view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(self.viewTop.snp.bottom)
            make.bottom.equalTo(view.snp.bottom).offset(-bootSaveHeight())
        }
        
        return view
    }()
    
    // 顶部视图...<标题、关闭>
    fileprivate lazy var viewTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        // 标题
        view.addSubview(self.lblTitle)
        self.lblTitle.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        // 关闭
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.clear
        btn.alpha = 1.0
        btn.setImage(UIImage.init(named: "btn_pd_group_close"), for: .normal)
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.view.superview != nil {
                strongSelf.showOrHideCouponPopView(false)
            }
        }).disposed(by: disposeBag)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.left.equalTo(view)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(50))
        }
        
        // 分隔线
        let viewLine = UIView.init(frame: CGRect.zero)
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        view.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(0.5)
        }
        
        return view
    }()
    
    //不赋值则使用keyWindow
    var bgView: UIView?
    // 优惠券是否弹出是否已弹出
    var viewShowFlag: Bool = false
    var couponArr = [CommonCouponNewModel]() //优惠券列表
    //MARK:入参数
    fileprivate  var spuCode : String? //商品spu
    fileprivate  var enterpriseId : String? //供应商id
    var typeNum = 1 //1表示商品详情中的优惠券弹框 2:表示购物车中的优惠券弹框
    //购物车优惠券弹框埋点用
    var shopNameStr = "" //商家名称
    var shopSectionIndex = 0 //商家
    //MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.showOrHideCouponPopView(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>FKYPopComCouponVC deinit~!@")
    }
}

extension FKYPopComCouponVC {
    //MARK: - SetupView
    func setupView() {
        self.setupSubview()
    }
    
    // 设置整体子容器视图
    func setupSubview() {
        self.view.backgroundColor = UIColor.clear
        self.view.isUserInteractionEnabled = true
        self.view.addSubview(self.viewDismiss)
        self.viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.viewDismiss.bk_(whenTapped:  { [weak self] in
            if let strongSelf = self {
                strongSelf.showOrHideCouponPopView(false)
            }
        })
        self.view.addSubview(self.viewContent)
        self.viewContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(CONTENT_COUPON_VIEW_H)
            make.height.equalTo(CONTENT_COUPON_VIEW_H)
        }
    }
}

//MARK: - Public(弹框)
extension FKYPopComCouponVC {
    // 显示or隐藏套餐弹出视图
    @objc func showOrHideCouponPopView(_ show: Bool) {
        //防止弹两次
        if show == viewShowFlag {
            return
        }
        viewShowFlag = show
        if show {
            // 显示
            if let iv = self.bgView {
                iv.addSubview(self.view)
                self.view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(iv)
                })
            }else {
                //添加在根视图上面
                let window = UIApplication.shared.keyWindow
                if let rootView = window?.rootViewController?.view {
                    window?.rootViewController?.addChild(self)
                    rootView.addSubview(self.view)
                    self.view.snp.makeConstraints({ (make) in
                        make.edges.equalTo(rootView)
                    })
                }
            }
            
            self.viewContent.snp.updateConstraints({ (make) in
                make.bottom.equalTo(self.view).offset(CONTENT_COUPON_VIEW_H)
            })
            self.view.layoutIfNeeded()
            self.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(strongSelf.view).offset(WH(0))
                    })
                    strongSelf.view.layoutIfNeeded()
                }
                
                }, completion: { (_) in
                    //
            })
        }
        else {
            self.view.endEditing(true)
            // 隐藏
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(strongSelf.view).offset(CONTENT_COUPON_VIEW_H)
                    })
                    strongSelf.view.layoutIfNeeded()
                }
                
                }, completion: { [weak self] (_) in
                    if let strongSelf = self {
                        strongSelf.view.removeFromSuperview()
                        strongSelf.removeFromParent()
                        // 移除通知
                    }
            })
        }
    }
    
    //视图赋值
    @objc func configCouponViewController(_ enterpriseId :String?, spuCode : String?) {
        self.enterpriseId = enterpriseId
        self.spuCode = spuCode
        if spuCode == nil {
            self.typeNum = 2
        }else {
            self.typeNum = 1
        }
        self.couponArr.removeAll()
        self.tableView.reloadData()
        self.showOrHideCouponPopView(true)
        self.getCommonCouponsList()
    }
}

extension FKYPopComCouponVC {
    //获取优惠券列表
    func getCommonCouponsList() {
        var params :[String : Any] = [:]
        params["enterprise_id"] = self.enterpriseId
        params["mode"] = "0"
        self.showLoading()
        if let desCode = self.spuCode {
            //商品详情查看优惠券列表
            params["spu_code"] = desCode
            FKYRequestService.sharedInstance()?.getCommonCouponListInfo(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.dismissLoading()
                guard success else {
                    // 失败
                    let msg = error?.localizedDescription ?? "获取失败"
                    strongSelf.toast(msg)
                    return
                }
                if let arr = model as? [CommonCouponNewModel] {
                    strongSelf.couponArr = arr
                    strongSelf.tableView.reloadData()
                }
            })
        }else {
            //购物车查看优惠券列表
            FKYRequestService.sharedInstance()?.getCommonCouponListInfoInEnterpriseId(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.dismissLoading()
                guard success else {
                    // 失败
                    let msg = error?.localizedDescription ?? "获取失败"
                    strongSelf.toast(msg)
                    return
                }
                if let arr = model as? [CommonCouponNewModel] {
                    strongSelf.couponArr = arr
                    strongSelf.tableView.reloadData()
                }
            })
        }
    }
    
    func receiveCommonCouponView(_ couponModel : CommonCouponNewModel?) {
        if let commonModel = couponModel {
            let parameters = [ "template_code": commonModel.templateCode ?? ""] as [String : Any]
            FKYRequestService.sharedInstance()?.postReceiveCommonCouponInfo(withParam: parameters, completionBlock: { [weak self] (success, error, response, model) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.dismissLoading()
                guard success else {
                    // 失败
                    let msg = error?.localizedDescription ?? "获取失败"
                    strongSelf.toast(msg)
                    return
                }
                if let couModel = model as? CouponModel {
                    commonModel.received = true
                    commonModel.couponTempCode = commonModel.templateCode
                    commonModel.couponCode = couModel.couponCode
                    if let endStr = couModel.endDate {
                        commonModel.endDate = endStr
                    }
                    if let beginStr = couModel.begindate {
                        commonModel.begindate = beginStr
                    }
                    couponModel?.enterpriseId = couModel.enterpriseId ?? ""
                    couponModel?.tempEnterpriseId = couModel.tempEnterpriseId ?? ""
                    strongSelf.tableView.reloadData()
                    strongSelf.toast("领取成功")
                }
            })
        }
    }
}

extension FKYPopComCouponVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FKYComCouponTableViewCell(style: .default, reuseIdentifier: "FKYComCouponTableViewCell")
        let model = couponArr[indexPath.row]
        cell.configCouponViewCell(model)
        cell.clickInteractButtonBlock = { [weak self] (typeIndex) in
            if let strongSelf = self {
                //(1:可用商品,2:立即领取,3:可用商家)
                if typeIndex == 1 {
                    if strongSelf.typeNum == 1 {
                        let extendParams = ["pageValue":(strongSelf.enterpriseId ?? "")+"|"+(strongSelf.spuCode ?? "")]
                        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "优惠券", itemId: "I6112", itemPosition: "3", itemName: "可用商品", itemContent:model.couponCode , itemTitle: nil, extendParams:extendParams as [String : AnyObject], viewController: UIApplication.shared.keyWindow?.currentViewController)
                    }else {
                       // let extendParams = ["storage":(model.couponCode ?? "")]
                        FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(strongSelf.shopSectionIndex)", floorName: strongSelf.shopNameStr, sectionId: nil, sectionPosition: nil, sectionName: "优惠券", itemId: "I5003", itemPosition: "3", itemName: "可用商品", itemContent:model.couponCode , itemTitle: nil, extendParams:nil, viewController: UIApplication.shared.keyWindow?.currentViewController)
                    }
                    FKYNavigator.shared().openScheme(FKY_ShopCouponProductController.self, setProperty: { (vc) in
                        let viewController = vc as! CouponProductListViewController
                        viewController.couponTemplateId = model.couponTempCode ?? ""
                        viewController.shopId = model.tempEnterpriseId ?? ""
                        viewController.couponName = model.couponFullName ?? ""
                        viewController.couponCode = model.couponCode ?? ""
                    })
                }else if typeIndex == 2 {
                    //
                    if strongSelf.typeNum == 1 {
                        let extendParams = ["pageValue":(strongSelf.enterpriseId ?? "")+"|"+(strongSelf.spuCode ?? "")]
                        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "优惠券", itemId: "I6112", itemPosition: "1", itemName: "立即领取", itemContent:model.templateCode , itemTitle: nil, extendParams:extendParams as [String : AnyObject], viewController: UIApplication.shared.keyWindow?.currentViewController)
                    }else {
                       // let extendParams = ["storage":(model.templateCode ?? "")]
                        FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(strongSelf.shopSectionIndex)", floorName: strongSelf.shopNameStr, sectionId: nil, sectionPosition: nil, sectionName: "优惠券", itemId: "I5003", itemPosition: "1", itemName: "立即领取", itemContent:model.templateCode ?? "" , itemTitle: nil, extendParams:nil, viewController: UIApplication.shared.keyWindow?.currentViewController)
                    }
                    strongSelf.receiveCommonCouponView(model)
                    
                }else if typeIndex == 3 {
                    //
                    if strongSelf.typeNum == 1 {
                        let extendParams = ["pageValue":(strongSelf.enterpriseId ?? "")+"|"+(strongSelf.spuCode ?? "")]
                        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "优惠券", itemId: "I6112", itemPosition: "2", itemName: "可用商家", itemContent:model.couponCode , itemTitle: nil, extendParams:extendParams as [String : AnyObject], viewController: UIApplication.shared.keyWindow?.currentViewController)
                    }else {
                       // let extendParams = ["storage":(model.couponCode ?? "")]
                        FKYAnalyticsManager.sharedInstance.BI_New_Record("F5001", floorPosition: "\(strongSelf.shopSectionIndex)", floorName: strongSelf.shopNameStr, sectionId: nil, sectionPosition: nil, sectionName: "优惠券", itemId: "I5003", itemPosition: "2", itemName: "可用商家", itemContent:model.couponCode , itemTitle: nil, extendParams:nil, viewController: UIApplication.shared.keyWindow?.currentViewController)
                    }
                    model.showShopNameList = !model.showShopNameList
                    strongSelf.tableView.reloadData()
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FKYComCouponTableViewCell.getCouponCellHeight(couponArr[indexPath.row])
    }
}

extension FKYPopComCouponVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "img_coupon_emptypage")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "暂无可领取优惠券"
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [ NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: RGBColor(0x5c5c5c)]
        return NSAttributedString.init(string: text, attributes: attributes)
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return WH(-10)
    }
}
