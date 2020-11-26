//
//  ExpiredTipsMessageVC.swift
//  FKY
//
//  Created by 寒山 on 2020/2/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class ExpiredTipsMessageVC: UIViewController,FKY_ExpiredTipsMessageVC {
    
    fileprivate var viewModel: HomeMesageViewModel = {
        let vm = HomeMesageViewModel()
        vm.type = 8
        return vm
    }()
    
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            self?.getFirstPageShopProductFuc()
            
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
    }()
    
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            self?.getALLExpiredTipsInfo()
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    //文件和描述区域
    fileprivate lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.shadow(with: RGBAColor(0x000000,alpha: 0.1), offset: CGSize(width: 0, height: -4), opacity: 1, radius: 4)
        return view
    }()
    // 资质文件
    fileprivate lazy var btnRegister: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .white
        btn.setTitleColor(RGBColor(0x333333), for: .normal)
        btn.setTitleColor(RGBColor(0x333333), for: .highlighted)
        btn.setTitleColor(RGBColor(0x333333), for: .disabled)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        btn.setTitle("资质文件", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.borderColor = RGBColor(0xE5E5E5).cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = WH(4)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            FKYNavigator.shared().openScheme(FKY_CredentialsController.self, setProperty: { (vc) in
                let v = vc as! CredentialsViewController
                v.fromType = "expireData"
            }, isModal: false)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
         FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I2013", itemPosition:"1", itemName: "资质文件", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: self)
        return btn
    }()
    
    fileprivate lazy var messageTab: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.rowHeight = WH(70)
        tableV.backgroundColor = RGBColor(0xF4F4F4)
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(ExpiredMessageInfoCell.self, forCellReuseIdentifier: "ExpiredMessageInfoCell")
        tableV.mj_header = self?.mjheader
        tableV.mj_footer = self?.mjfooter
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    fileprivate var navBar: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
         self.getFirstPageShopProductFuc()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    deinit {
        print("ExpiredTipsMessageVC deinit~!@")
    }

}
// MARK:ui相关
extension ExpiredTipsMessageVC {
    //MARK: 导航栏
    fileprivate func setupNavigationBar() {
        navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        fky_setupTitleLabel("资质证照")
        self.NavigationTitleLabel?.font = UIFont.boldSystemFont(ofSize:WH(18))
        self.navBar?.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        self.view.addSubview(messageTab)
        self.view.addSubview(bottomView)
        bottomView.addSubview(btnRegister)
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(WH(62))
        }
        
        messageTab.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(bottomView.snp.top)
            make.top.equalTo(self.navBar!.snp.bottom)
        }
        
        btnRegister.snp.makeConstraints { (make) in
            make.center.equalTo(bottomView)
            make.left.equalTo(bottomView).offset(WH(19))
            make.height.equalTo(WH(42))
        }
    }
    func refreshDismiss() {
        self.dismissLoading()
        if self.messageTab.mj_header.isRefreshing() {
            self.messageTab.mj_header.endRefreshing()
            self.messageTab.mj_footer.resetNoMoreData()
        }
        if  self.viewModel.hasNextPage {
            self.messageTab.mj_footer.endRefreshing()
        }else{
            self.messageTab.mj_footer.endRefreshingWithNoMoreData()
        }
    }
}
// MARK:数据请求相关
extension ExpiredTipsMessageVC {
    //获取全部商品
    @objc func getALLExpiredTipsInfo(){
        showLoading()
        viewModel.getExpiredTipsInfo(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.messageTab.mj_header.endRefreshing()
            strongSelf.refreshDismiss()
            if success{
                strongSelf.messageTab.reloadData()
            } else {
                // 失败
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    //请求第一页商品
    @objc func getFirstPageShopProductFuc(){
        self.viewModel.currentIndex = 1
        self.viewModel.hasNextPage = true
        self.getALLExpiredTipsInfo()
    }
}
// MARK:UITableViewDataSource,UITableViewDelegate代理相关
extension ExpiredTipsMessageVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ExpiredMessageInfoCell = tableView.dequeueReusableCell(withIdentifier: "ExpiredMessageInfoCell", for: indexPath) as! ExpiredMessageInfoCell
        let model = self.viewModel.dataSource[indexPath.row]
        cell.configCell(model)
        //        if let arr = self.viewModel.dataSource {
        //           // cell.configCell(arr[indexPath.row])
        //        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.viewModel.dataSource[indexPath.row]
        return ExpiredMessageInfoCell.calculateHeight(model)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let model = self.viewModel.dataSource[indexPath.row]
        FKYNavigator.shared().openScheme(FKY_CredentialsController.self, setProperty: { (vc) in
            let v = vc as! CredentialsViewController
            v.fromType = "expireData"
        }, isModal: false)
        
        infoSelBI( model,indexPath.row)
    }
    
}
extension ExpiredTipsMessageVC{
    //8：资质证照   9：交易物流  10：退换货售后  0：im
    func infoSelBI(_ model:ExpiredTipsInfoModel,_ rowIndex:Int){
         FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "点进过期证照", itemId: "I2014", itemPosition:"\(rowIndex + 1)", itemName: nil, itemContent: nil, itemTitle: model.showTime ?? "", extendParams:nil, viewController: self)
    }
}
