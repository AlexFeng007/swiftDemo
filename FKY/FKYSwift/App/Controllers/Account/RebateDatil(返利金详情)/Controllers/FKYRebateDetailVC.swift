//
//  FKYRebateDetailVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/2/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYRebateDetailVC: UIViewController {
    
    /// viewModel 数据对象
    var rebateDetailViewModel = FKYRebateDetailViewModel()
    
    /// 导航栏
    fileprivate lazy var navBar: UIView? = {
        if let _ = self.NavigationBar {
            //
        }
        else {
            self.fky_setupNavBar()
        }
        self.NavigationBar?.backgroundColor = .white
        return self.NavigationBar
    }()
    
    /// 上方容器视图
    lazy var titleContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    
    /// 商家标签
    lazy var sellerLB:UILabel = {
        let lb = UILabel()
        lb.text = "商家"
        lb.font = UIFont.boldSystemFont(ofSize: WH(14))
        lb.textColor = RGBColor(0x333333)
        return lb
    }()
    
    /// 返利金额
    lazy var moneyLB:UILabel = {
        let lb = UILabel()
        lb.text = "返利金额"
        lb.font = UIFont.boldSystemFont(ofSize: WH(14))
        lb.textColor = RGBColor(0x333333)
        return lb
    }()
    
    /// 分割线
    lazy var titleContainerViewMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xEBEDEC)
        return view
    }()
    
    lazy var mainTableView:UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = RGBColor(0xFFFFFF)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.estimatedRowHeight = 200
        table.rowHeight = UITableView.automaticDimension
        table.register(FKYRebateDetailCell.self, forCellReuseIdentifier: NSStringFromClass(FKYRebateDetailCell.self))
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return table
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.requestRebateList()
    }
    

}

//MARK: - UI
extension FKYRebateDetailVC{
    func setupUI(){
        
        self.view.backgroundColor = RGBColor(0xFFFFFF)
        
        setupNavBar()
        self.view.addSubview(self.titleContainerView)
        self.view.addSubview(self.mainTableView)
        self.titleContainerView.addSubview(self.sellerLB)
        self.titleContainerView.addSubview(self.moneyLB)
        self.titleContainerView.addSubview(self.titleContainerViewMarginLine)
        
        /// ----------------
        self.titleContainerView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.navBar!.snp_bottom)
            make.height.equalTo(WH(41))
        }
        
        /// ----------------
        self.sellerLB.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleContainerView).offset(WH(30))
            make.centerY.equalTo(self.titleContainerView)
        }
        self.moneyLB.snp_makeConstraints { (make) in
            make.right.equalTo(self.titleContainerView).offset(WH(-41))
            make.centerY.equalTo(self.titleContainerView)
        }
        self.titleContainerViewMarginLine.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.titleContainerView)
            make.height.equalTo(0.5)
        }
        
        /// ----------------
        self.mainTableView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.titleContainerView.snp_bottom).offset(WH(16))
        }
        
    }
    
    fileprivate func setupNavBar() {
        self.fky_setupTitleLabel("返利金明细")
        self.fky_hiddedBottomLine(true)
        self.NavigationTitleLabel!.fontTuple = (color:RGBColor(0x000000),font:UIFont.boldSystemFont(ofSize: WH(18)))
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        // 导航栏分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        self.navBar!.addSubview(viewLine)
        viewLine.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(self.navBar!)
            make.height.equalTo(0.5)
        })
    }
}

//MARK: - 事件响应
extension FKYRebateDetailVC{
    
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKY_RebateFoldACtion {// 折叠展开事件
            self.mainTableView.reloadData()
        }else if eventName == FKY_JumpTofStoreHomePage{//跳转到店铺首页
            FKYNavigator.shared().openScheme(FKY_ShopItem.self) { (vc) in
                let v = vc as! FKYNewShopItemViewController
                let sellerModel = userInfo[FKYUserParameterKey] as! FKYRebteSellerModel
                v.shopId = sellerModel.seller_code
            }
        }else if eventName == FKY_MPJumpTofStoreHomePage{// MP商家跳转店铺首页
            FKYNavigator.shared().openScheme(FKY_ShopItem.self) { (vc) in
                let v = vc as! FKYNewShopItemViewController
                let sellerModel = userInfo[FKYUserParameterKey] as! FKYRebateSellerTypeModel
                v.shopId = sellerModel.sellerId
            }
        }
    }
}

extension FKYRebateDetailVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rebateDetailViewModel.sellerTypeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYRebateDetailCell.self)) as! FKYRebateDetailCell
        cell.showData(data: self.rebateDetailViewModel.sellerTypeList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FKYRebateDetailCell.getCellHeight(self.rebateDetailViewModel.sellerTypeList[indexPath.row])
//        return 10
    }
    
}

//MARK: - 网络请求
extension FKYRebateDetailVC{
    func requestRebateList(){
        self.rebateDetailViewModel.requestRebateInfo { (isSuccess, msg) in
            guard isSuccess else{
                self.toast(msg)
                return
            }
            
            self.mainTableView.reloadData()
        }
    }
}
