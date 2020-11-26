//
//  FKYSelfShopPinkageViewController.swift
//  FKY
//
//  Created by 寒山 on 2020/10/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSelfShopPinkageViewController: UIViewController {
    var scrollBlock: ScrollViewDidScrollBlock?
    var navTitleChange: ((String)->())?
    fileprivate var selectIndexPath: IndexPath = IndexPath.init(row: 0, section: 0) //选中cell 位置
    fileprivate var dataArr = [FKYPackageRateModel]()
    
    fileprivate var timer: Timer!
    fileprivate var nowLocalTime : Int64 = 0 //记录当前系统时间
    var hasLoad = false //是否加载过
    @objc var keyWordStr : String? //搜索关键词
    //请求工具类
    fileprivate lazy var packageService : FKYPackageRateService = {
        let serviece = FKYPackageRateService()
        serviece.isSelfTag = true
        return serviece
    }()
    //行高管理器
    fileprivate var cellHeightManager:ContentHeightManager = {
        let heightManager = ContentHeightManager()
        return heightManager
    }()
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        var tableView = UITableView(frame: CGRect.null, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = RGBColor(0xF4F4F4)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(FKYComPreKillCell.self, forCellReuseIdentifier: "FKYComPreKillCell_package")
        tableView.register(HomeOneAdPageCell.self, forCellReuseIdentifier: "HomePreOneAdPageCell_package")
        tableView.mj_header = self?.mjheader
        tableView.mj_footer = self?.mjfooter
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            if let strongSelf = self {
                strongSelf.getPreferetialProductList(true)
            }
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
    }()
    
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            if let strongSelf = self {
                strongSelf.getPreferetialProductList(false)
            }
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        footer!.mj_h = WH(67)
        return footer!
    }()
    //商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        addView.immediatelyOrderAddCarSuccess = {[weak self] (isSuccess ,productNum, productModel) in
            if let strongSelf = self {
                strongSelf.goOrderCheckViewController()
                if let model = productModel as? FKYPackageRateModel {
                    strongSelf.add_NEW_BI(3, model, nil)
                }
            }
        }
        return addView
    }()
    
    fileprivate lazy var emptyView : FKYNoNewPrdListDataView = {
        let view = FKYNoNewPrdListDataView()
        view.resetPreferentialData()
        view.isHidden = true
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // 登录成功后刷新界面数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataWithLoginSuccess), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        // Do any additional setup after loading the view.
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
        // self.view.sendSubviewToBack(emptyView)
    }
}
//MARK:加车相关的处理
extension FKYSelfShopPinkageViewController {
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        //let sourceType = HomeString.SHOPITEM_ALL_ADD_SOURCE_TYPE
        self.addCarView.addBtnType = 2
        self.addCarView.configAddCarViewController(productModel,nil)
        if let bgView = self.parent?.view {
            self.addCarView.showOrHideAddCarPopView(true,bgView)
        }else{
            self.addCarView.showOrHideAddCarPopView(true,self.view)
        }
    }
    //检查订单页
    fileprivate func goOrderCheckViewController() {
        self.addCarView.removeMySelf()
        FKYNavigator.shared().openScheme(FKY_CheckOrder.self, setProperty: {(svc) in
            let controller = svc as! CheckOrderController
            controller.fromWhere = 5 // 购物车
        }, isModal: false, animated: true)
    }
}
extension FKYSelfShopPinkageViewController: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomePreOneAdPageCell_package", for: indexPath) as!  HomeOneAdPageCell
            if let urlStr = self.packageService.imgUrl ,urlStr.count > 0 {
                cell.configPreferentialShopAdView(urlStr)
            }
            return cell
        }else {
            let model =  self.dataArr[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "FKYComPreKillCell_package", for: indexPath) as! FKYComPreKillCell
            cell.selectionStyle = .none
            cell.configPackageCell(model, nowLocalTime: self.nowLocalTime,self.packageService.isCheck,true)
            //更新加车数量
            cell.addUpdateProductNum = { [weak self] in
                if let strongSelf = self {
                    strongSelf.selectIndexPath = indexPath
                    strongSelf.popAddCarView(model)
                    strongSelf.add_NEW_BI(2, model, indexPath.row)
                }
            }
            //登录
            cell.loginClosure = {
                FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            }
            cell.refreshDataWithTimeOut = { [weak self] typeTimer in
                if let strongSelf = self {
                    strongSelf.getPreferetialProductList(true)
                }
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            if let str = self.packageService.imgUrl ,str.count > 0 {
                //有返回广告图片地址
                return WH(97)
            }
            return WH(0)
            
        } else {
            let model =  self.dataArr[indexPath.row-1]
            let cellHeight = cellHeightManager.getContentCellHeight((model.spuCode ?? ""),"\(model.enterpriseId ?? 0)",self.ViewControllerPageCode() ?? "")
            
            if  cellHeight == 0{
                let conutCellHeight = FKYComPreKillCell.getCellContentHeight(model,self.nowLocalTime)
                cellHeightManager.addContentCellHeight((model.spuCode ?? ""),"\(model.enterpriseId ?? 0)",self.ViewControllerPageCode()!, conutCellHeight)
                return conutCellHeight
            }else{
                return cellHeight
            }
        }
    }
}
extension FKYSelfShopPinkageViewController: UIScrollViewDelegate {
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
//MARK:网络请求相关的处理
extension FKYSelfShopPinkageViewController{
    func shouldFirstLoadData() -> Void {
        guard hasLoad else {
            hasLoad = true
            self.getPreferetialProductList(true)
            return
        }
    }
    @objc func reloadDataWithLoginSuccess() {
        self.getPreferetialProductList(true)
    }
    fileprivate func getPreferetialProductList(_ isFresh:Bool) {
        if isFresh == true {
            self.showLoading()
            self.mjfooter.resetNoMoreData()
        }
        self.packageService.getSinglePackageRateWithProductList(self.keyWordStr,isFresh) {[weak self] (hasMoreData,dataArr, tip) in
            guard let strongSelf = self else{
                return
            }
            if isFresh == true {
                strongSelf.dismissLoading()
                strongSelf.mjheader.endRefreshing()
                //删除存储高度
                strongSelf.cellHeightManager.removeAllContentCellHeight()
                if let block = strongSelf.navTitleChange{
                    block(strongSelf.packageService.packageTitle ?? "单品包邮")
                }
            }
            if hasMoreData == true {
                strongSelf.mjfooter.endRefreshing()
            }else {
                strongSelf.mjfooter.endRefreshingWithNoMoreData()
            }
            if let msg = tip {
                strongSelf.toast(msg)
            }else {
                //请求成功
                if let arr = dataArr, arr.count > 0 {
                    if isFresh == true {
                        strongSelf.dataArr.removeAll()
                        strongSelf.dataArr = arr
                        strongSelf.beginSystemTimeOut()
                    }else {
                        strongSelf.dataArr = strongSelf.dataArr + arr
                        strongSelf.tableView.reloadData()
                    }
                }
                //判断是否显示空态页面
                if strongSelf.dataArr.count == 0 {
                    strongSelf.emptyView.isHidden = false
                }else {
                    strongSelf.emptyView.isHidden = true
                }
            }
        }
    }
}
extension FKYSelfShopPinkageViewController {
    fileprivate func beginSystemTimeOut(){
        //刷新
        if self.dataArr.count > 0 {
            let preModel = self.dataArr[0]
            self.stopTimer()
            self.nowLocalTime = preModel.systemTime ?? 0
            self.tableView.reloadData()
            // 启动timer...<1.s后启动>
            let date = NSDate.init(timeIntervalSinceNow: 1.0)
            timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(calculateCount), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        }
    }
    @objc fileprivate func calculateCount() {
        self.nowLocalTime = self.nowLocalTime+1000
    }
    fileprivate func stopTimer()  {
        if timer != nil {
            timer.invalidate()
            timer = nil
            self.nowLocalTime = 0
        }
    }
}
//MARK:bi埋点相关
extension FKYSelfShopPinkageViewController{
    func add_NEW_BI(_ biType:Int,_ prdModel:FKYPackageRateModel?,_ index:Int?){
        var sectionId:String?//
        var sectionName:String? //
        var sectionPosition:String? //
        var itemId:String? //
        var itemName:String? //
        var itemPosition:String? //
        var itemContent:String? //
        var extendParams = [String:String]()//
        if biType == 2 {
            //单品包邮列表加车
            sectionId = "S7806"
            sectionName = "药城自营"
            if let prd = prdModel {
                itemContent = "\(prd.enterpriseId ?? 0)|\(prd.spuCode ?? "")"
                extendParams = ["storage":prd.storage ?? "","pm_price":prd.pm_price ?? ""];
            }
            
            sectionPosition = "0"
            itemId = ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue
            itemName = "加车（马上抢）"
            itemPosition = "\(index ?? 0)"
            
        }else if biType == 3 {
            
            //单品包邮列表立即购买
            sectionId = "S7806"
            sectionName = "药城自营"
            if let prd = prdModel {
                itemContent = "\(prd.enterpriseId ?? 0)|\(prd.spuCode ?? "")"
                extendParams = ["storage":prd.storage ?? "","pm_price":prd.pm_price ?? ""];
            }
            
            sectionPosition = "0"
            itemId = "I5000"
            itemName = "立即下单"
            itemPosition = "0"
            
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: sectionId, sectionPosition: sectionPosition, sectionName: sectionName, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: itemContent, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: self)
    }
}
