//
//  LiveCouponsListView.swift
//  FKY
//
//  Created by yyc on 2020/8/26.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

let COUPONS_LIST_HEIGHT = WH(422) //优惠券高度
class LiveCouponsListView: UIView {
    
    var dataSource = [CommonCouponNewModel]()
    var clickGetCouponsBlock :((CommonCouponNewModel)->(Void))? //领取优惠券
    var clickTypeAction :((Int)->(Void))? //1:可用商品 2:可用商家
    fileprivate var selectedIndex:IndexPath? //记录点击的优惠券
    fileprivate lazy var bgView: UIView = {
        let iv = UIView()
        iv.backgroundColor = RGBAColor(0x000000,alpha: 0.32)
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.hideCouponsListView()
        }).disposed(by: disposeBag)
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    fileprivate lazy var contentView: UIView = {
        let iv = UIView()
        iv.backgroundColor = RGBAColor(0xffffff,alpha: 1)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    //头部
    fileprivate lazy var headView: UIView = {
        let iv = UIView()
        iv.backgroundColor = .clear
        return iv
    }()
    //标签|
    fileprivate lazy var tagLabel : UILabel = {
        let label = UILabel.init()
        label.backgroundColor = RGBColor(0xFF6247)
        return label
    }()
    //优惠券数量
    fileprivate lazy var couponNumLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.systemFont(ofSize: WH(16))
        return label
    }()
    
    //关闭按钮
    fileprivate lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "btn_pd_group_close"), for: UIControl.State())
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.hideCouponsListView()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    //分割线
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBAColor(0xE5E5E5, alpha: 1)
        return view
    }()
    
    // 上拉加载更多
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            //            if let block = strongSelf.loadMoreDataBlock{
            //                block()
            //            }
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    //列表
    fileprivate lazy var couponsTab: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.backgroundColor = .white
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(FKYComCouponTableViewCell.self, forCellReuseIdentifier: "FKYComCouponTableViewCell_live")
        tableV.mj_footer =   mjfooter
        tableV.tableHeaderView = {
            let bgView = UIView.init(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(8)))
            bgView.backgroundColor = RGBColor(0xFFFFFF)
            return bgView
        }()
        if #available(iOS 11, *) {
            tableV.estimatedRowHeight = 0//WH(213)
            tableV.estimatedSectionHeaderHeight = 0
            tableV.estimatedSectionFooterHeight = 0
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .clear
        self.addSubview(bgView)
        self.addSubview(contentView)
        contentView.addSubview(headView)
        headView.addSubview(tagLabel)
        headView.addSubview(couponNumLabel)
        headView.addSubview(closeBtn)
        headView.addSubview(lineView)
        
        contentView.addSubview(couponsTab)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        headView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(WH(58))
        }
        tagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headView).offset(WH(10))
            make.top.equalTo(headView).offset(WH(25))
            make.height.equalTo(WH(11))
            make.width.equalTo(WH(3))
        }
        couponNumLabel.snp.makeConstraints { (make) in
            make.height.equalTo(WH(12))
            make.left.equalTo(tagLabel.snp.right).offset(WH(6))
            make.centerY.equalTo(tagLabel)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(WH(30))
            make.right.equalTo(headView.snp.right).offset(-WH(10))
            make.top.equalTo(headView.snp.top).offset(WH(14))
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(headView)
            make.height.equalTo(0.5)
        }
        
        couponsTab.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(headView.snp.bottom)
        }
        
        self.contentView.frame =   CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height:  COUPONS_LIST_HEIGHT)
        contentView.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), radius: WH(20))
        self.layoutIfNeeded()
    }
    func showCouponListView(){
        self.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.contentView.frame =   CGRect(x: 0, y: SCREEN_HEIGHT -  COUPONS_LIST_HEIGHT, width: SCREEN_WIDTH, height:  COUPONS_LIST_HEIGHT)
        }) { [weak self] (isFinished) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isHidden = false
        }
    }
    func hideCouponsListView(){
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.contentView.frame =   CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height:  COUPONS_LIST_HEIGHT)
        }) { [weak self] (isFinished) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isHidden = true
        }
    }
    func configView(_ couponsList:[CommonCouponNewModel]?,_ hasMoreData:Bool){
        if hasMoreData == true {
            couponsTab.mj_footer.resetNoMoreData()
        }else {
            couponsTab.mj_footer.endRefreshingWithNoMoreData()
        }
        if let arr = couponsList{
            self.dataSource = arr
            let allContent = "共 \(arr.count) 张优惠券"
            let numRange = (allContent as NSString).range(of: "\(arr.count)")
            let attribute: NSMutableAttributedString = NSMutableAttributedString.init(string: allContent)
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0xFF2D5C), range: numRange)
            couponNumLabel.attributedText = attribute
            self.couponsTab.reloadData()
        }
    }
    //刷新点击领取的优惠券
    func reloadCouponsView() {
        if let index = self.selectedIndex {
            self.couponsTab.reloadRows(at: [index], with: .none)
        }
    }
}
// MARK:UITableViewDataSource,UITableViewDelegate代理相关
extension LiveCouponsListView : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.dataSource.count{
            let couponModel = self.dataSource[indexPath.row]
            let cell: FKYComCouponTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FKYComCouponTableViewCell_live", for: indexPath) as! FKYComCouponTableViewCell
            cell.configLiveCouponViewCell(couponModel)
            cell.clickInteractButtonBlock = { [weak self] (typeIndex) in
                if let strongSelf = self {
                    //(1:可用商品,2:立即领取,3:可用商家)
                    if typeIndex == 1 {
                        FKYNavigator.shared().openScheme(FKY_ShopCouponProductController.self, setProperty: { (vc) in
                            let viewController = vc as! CouponProductListViewController
                            if let str = couponModel.couponTempCode ,str.count > 0 {
                                viewController.couponTemplateId = str
                            }
                            if let str = couponModel.templateCode ,str.count > 0 {
                                viewController.couponTemplateId = str
                            }
                            viewController.shopId = couponModel.enterpriseId ?? ""
                            viewController.couponName = couponModel.couponFullName ?? ""
                            viewController.couponCode = couponModel.couponCode ?? ""
                            viewController.sourceType = "1"
                        })
                        if let block = strongSelf.clickTypeAction {
                            block(1)
                        }
                    }else if typeIndex == 2 {
                        if  let block = strongSelf.clickGetCouponsBlock{
                            strongSelf.selectedIndex = indexPath
                            block(couponModel)
                        }
                    }else if typeIndex == 3 {
                        couponModel.showShopNameList = !couponModel.showShopNameList
                        strongSelf.couponsTab.reloadData()
                    }
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FKYComCouponTableViewCell.getLiveCouponCellHeight(self.dataSource[indexPath.row])
    }
}

