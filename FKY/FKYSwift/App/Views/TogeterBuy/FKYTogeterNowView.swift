//
//  FKYTogeterNowView.swift
//  FKY
//
//  Created by hui on 2018/10/22.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYTogeterNowView: UIView {
    
    fileprivate lazy var mjheader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 下拉刷新
            if let block = self?.refreshTogeterNowViewData {
                block()
            }
        })
        header?.arrowView.image = nil
        header?.lastUpdatedTimeLabel.isHidden = true
        return header!
    }()
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            if let block = self?.reloadMoreTogeterNowViewData {
                block()
            }
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    //向上按钮
    fileprivate lazy var topButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "btn_back_top"), for: .normal)
        btn.isHidden = true
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self]  (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            strongSelf.lblPageCount.text = String.init(format: "1/%zi",strongSelf.pageTotalNum ?? 1)
            strongSelf.topButton.isHidden = true
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    //页码
    fileprivate lazy var lblPageCount: FKYCornerRadiusLabel = {
        let label = FKYCornerRadiusLabel()
        label.initBaseInfo()
        label.isHidden = true
        return label
    }()
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .grouped)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.estimatedRowHeight = WH(208)
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(FKYTogeterNowTabCell.self, forCellReuseIdentifier: "FKYTogeterNowTabCell")
        tableV.register(ShopSecondKillCell.self, forCellReuseIdentifier: "ShopSecondKillCell")
        tableV.register(FKYTogeterNoDataCell.self, forCellReuseIdentifier: "FKYTogeterNoDataCell")
        tableV.mj_header = self?.mjheader
        tableV.mj_footer = self?.mjfooter
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    
    var updateStepCountBlock: ((_ product: FKYTogeterBuyModel ,_ row: Int)->())?
    var toastBlock: ((_ msg: String)->())?//加车提示
    var refreshTogeterNowViewData : (()->())? //刷新
    var reloadMoreTogeterNowViewData : (()->())? //加载更多
    var refreshDataWithNextTypeOver : (()->())? //下期预告时间结束
    var clickCellBlock : ((_ product: FKYTogeterBuyModel ,_ row: Int,_ nowLocalTime:Int64)->())? //点击cell
    
    fileprivate var selectedRow : Int?
    fileprivate var desRect : CGRect? //点击cell的图片rect
    fileprivate var desImageView : UIImageView? //点击cell的图片
    fileprivate var nowLocalTime : Int64 = 0 //记录当前系统时间
    fileprivate var nowGetLocalTime : Int64 = 0 //记录当前请求的系统时间
    var dataArr : [FKYTogeterBuyModel]? //请求的数据
    fileprivate var timer: Timer!
    fileprivate var isCheck:String?//是否资质认证了
    fileprivate var enterpriseId:String?//自营的id
    fileprivate var pageTotalNum : Int? //页码数量
    fileprivate var pageCurrentNum : Int = 1 //当前页码
    fileprivate var hasMoreData : Bool = true //有更多数据
    //显示页码相关
    fileprivate var isScrollDown : Bool = true
    var lastOffsetY : CGFloat = 0.0
    var isSearchResultView :Bool = false //默认非搜索界面,true表示搜索结果界面
    var typeIndex :String = "1" //1表示本期 3下期预告
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        self.addSubview(topButton)
        topButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-WH(17))
            make.height.width.equalTo(WH(44))
            make.bottom.equalTo(self.snp.bottom).offset(-WH(30)-bootSaveHeight())
        }
        self.addSubview(lblPageCount)
        lblPageCount.snp.makeConstraints({(make) in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).offset(-WH(30)-bootSaveHeight())
            make.height.equalTo(LBLABEL_H)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-100)
            
        })
    }
    
    //刷新
    func refreshNowViewDate(_ arr:[FKYTogeterBuyModel]?,_ isCheck:String?,_ enterpriseId:String?,_ isFresh:Bool,_ hasMoreData:Bool,_ pageTotal:Int) {
        if isFresh == true {
            self.isCheck = isCheck
            self.enterpriseId = enterpriseId
            self.pageTotalNum = pageTotal
            self.hasMoreData = hasMoreData
            self.lblPageCount.isHidden = true
            self.stopTimer()
            self.dataArr?.removeAll()
        }
        if let getDataArr = arr,getDataArr.count > 0 {
            self.isCheck = isCheck
            self.pageTotalNum = pageTotal
            self.hasMoreData = hasMoreData
            //初始化页码显示
            self.lblPageCount.text = String.init(format: "%zi/%zi", 1,self.pageTotalNum ?? 1)
            self.lblPageCount.isHidden = false
            if isFresh == true {
                //刷新
                self.dataArr = getDataArr
                let togeterMoel = getDataArr[0]
                self.stopTimer()
                self.nowLocalTime = togeterMoel.nowTime ?? 0
                self.tableView.reloadData()
                // 启动timer...<1.s后启动>
                let date = NSDate.init(timeIntervalSinceNow: 1.0)
                timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(calculateCount), userInfo: nil, repeats: true)
                RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
            }else {
                self.dataArr = (self.dataArr ?? []) + getDataArr
                self.tableView.reloadData()
                //加载更多后，第一次触发willDisplay代理更新页码
                self.lblPageCount.text = String.init(format: "%zi/%zi", self.pageCurrentNum+1, self.pageTotalNum ?? 1)
                if self.pageCurrentNum+1 > 1 {
                    self.topButton.isHidden = false
                }
            }
        }else {
           self.hasMoreData = hasMoreData
           self.tableView.reloadData()
        }
        if hasMoreData == true {
            self.tableView.mj_footer.resetNoMoreData()
        }else {
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        }
        self.tableView.mj_header.endRefreshing()
        self.isHidden = false
    }
    
    @objc func calculateCount() {
        self.nowLocalTime = self.nowLocalTime+1
        //根据判断views所属的控制器被销毁了，销毁定时器
        guard (self.getFirstViewController()) != nil else{
            self.stopTimer()
            return
        }
    }
    
    func stopTimer()  {
        if timer != nil {
            timer.invalidate()
            timer = nil
            self.nowLocalTime = 0
        }
    }
}

extension FKYTogeterNowView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let arr = self.dataArr ,arr.count > 0 {
            let model = arr[indexPath.row]
            // cell.configCell(arr[indexPath.row], nowLocalTime: self.nowLocalTime,self.isCheck)
            return ShopSecondKillCell.getCellContentYQGHeight(model,nowLocalTime: self.nowLocalTime,self.isCheck)
//            var rowH = WH(208) //默认取本期的一起购活动cell高度
//            if let beginInterval = model.beginTime, beginInterval > self.nowLocalTime {
//                rowH = WH(195) //未开始活动
//            }
//            //显示日期
//            if let time = model.deadLine, time.isEmpty == false {
//                return rowH
//            }else {
//                return rowH - WH(12+11)
//            }
        }else {
            return WH(261)
        }
//        if indexPath.section == 0 {
//
//        }else {
//            if indexPath.row == 0 {
//                return FKYTogeterBuyIntroCell.configCellHeight(1)
//            }else{
//                return FKYTogeterBuyQuestionCell.configCellHeight()
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if self.hasMoreData == false && section == 0 && self.isSearchResultView == false {
//            return WH(11)
//        }
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = RGBColor(0xf4f4f4)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = RGBColor(0xf4f4f4)
        return view
    }
}

extension FKYTogeterNowView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        if self.hasMoreData == true || self.isSearchResultView == true {
//           return 1
//        }
//        return 2
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = self.dataArr ,arr.count > 0 {
            return arr.count
        }else {
            return 1
        }
//        if section == 0{
//
//        }else {
//            return 2
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let arr = self.dataArr ,arr.count > 0 {
            // 商品cell
            let cell: ShopSecondKillCell = tableView.dequeueReusableCell(withIdentifier: "ShopSecondKillCell", for: indexPath) as! ShopSecondKillCell
            cell.selectionStyle = .none
//            let cell: FKYTogeterNowTabCell = tableView.dequeueReusableCell(withIdentifier: "FKYTogeterNowTabCell", for: indexPath) as! FKYTogeterNowTabCell
//            cell.selectionStyle = .none
//            //本期认购
            if self.typeIndex == typeNowIndex {
                //更新加车
                cell.addUpdateProductNum = { [weak self]  in
                    if let strongSelf = self {
                        if let block = strongSelf.updateStepCountBlock {
                            strongSelf.selectedRow = indexPath.row
                            block(arr[indexPath.row],indexPath.row)
                        }
                    }
                }
            }
//            //本期认购or下期预告共用部分
            // 登录
            cell.loginClosure = {
                FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
            }
            cell.refreshDataWithTimeOut  = { [weak self] typeTimer in
                if let strongSelf = self {
                    // typeTimer 为1代表未开始的活动时间到了
                    if typeTimer == 1 {
                        //搜索或者下期预告
                        let nowCurrentTime = Int64(Date().timeIntervalSince1970)
                        let spaceTime = nowCurrentTime - strongSelf.nowGetLocalTime
                        if strongSelf.isSearchResultView == true || strongSelf.typeIndex == typeNextIndex ,spaceTime > 5 {
                            //print("+++\(strongSelf.typeIndex)++\(spaceTime)")
                            strongSelf.nowGetLocalTime = nowCurrentTime
                            if let block = strongSelf.refreshDataWithNextTypeOver {
                                block()
                            }
                        }
                    }else{
                        let maxRow = strongSelf.tableView.numberOfRows(inSection: 0)
                        if indexPath.row < maxRow {
                            strongSelf.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            }
            cell.configCell(arr[indexPath.row], nowLocalTime: self.nowLocalTime,self.isCheck)
            return cell
        }
        else {
            //无商品
            let cell: FKYTogeterNoDataCell = tableView.dequeueReusableCell(withIdentifier: "FKYTogeterNoDataCell", for: indexPath) as! FKYTogeterNoDataCell
            cell.selectionStyle = .none
            if self.typeIndex == typeNowIndex {
                cell.configCell("本期认购活动还未开始",self.enterpriseId)
            } else {
                cell.configCell("下期还没有认购活动",self.enterpriseId)
            }
            return cell
        }
//        if indexPath.section == 0 {
//
//        }else {
//            if indexPath.row == 0 {
//                // 介绍
//                let cell: FKYTogeterBuyIntroCell = tableView.dequeueReusableCell(withIdentifier: "FKYTogeterBuyIntroCell", for: indexPath) as! FKYTogeterBuyIntroCell
//                cell.selectionStyle = .none
//                cell.configCell(1)
//                return cell
//            }else {
//                // 问答
//                let cell: FKYTogeterBuyQuestionCell = tableView.dequeueReusableCell(withIdentifier: "FKYTogeterBuyQuestionCell", for: indexPath) as! FKYTogeterBuyQuestionCell
//                cell.selectionStyle = .none
//                return cell
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if let arr = self.dataArr ,arr.count > 0 {
                let model = arr[indexPath.row]
                if let block = self.clickCellBlock {
                    block(model,indexPath.row,self.nowLocalTime)
                }
                weak var weakSelf = self
                FKYNavigator.shared().openScheme(FKY_Togeter_Detail_Buy.self, setProperty: { (vc) in
                    let v = vc as! FKYTogeterBuyDetailViewController
                    v.typeIndex = "1"
                    v.productId = model.togeterBuyId
                    v.updateCarNum = { (carId , prdCount) in
                        let maxRow = self.tableView.numberOfRows(inSection: 0)
                        if indexPath.row < maxRow {
                            weakSelf?.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                })
            }
        }
    }
    //显示页码及回到顶部按钮
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if (tableView.isDragging || tableView.isDecelerating) && isScrollDown {
                //上滑处理
                let scrollIndex = indexPath.row / 20
                self.lblPageCount.text = String.init(format: "%zi/%zi", scrollIndex+1, self.pageTotalNum ?? 1)
                self.pageCurrentNum = scrollIndex+1
                if scrollIndex+1 > 1 {
                    self.topButton.isHidden = false
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if (tableView.isDragging || tableView.isDecelerating) && !isScrollDown {
                //下滑处理
                let scrollIndex = (indexPath.row-1) / 20
                self.lblPageCount.text = String.init(format: "%zi/%zi", scrollIndex+1, self.pageTotalNum ?? 1)
                self.pageCurrentNum = scrollIndex+1
                if scrollIndex+1 < 2 {
                    self.topButton.isHidden = true
                }
            }
        }
    }
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isScrollDown = lastOffsetY < scrollView.contentOffset.y
        lastOffsetY = scrollView.contentOffset.y
    }
}

extension FKYTogeterNowView {
    //进入界面即刷新
    func reloadViewWithBackFromCart() {
        if let arr = self.dataArr , arr.count > 0 {
            for product in self.dataArr! {
                if FKYCartModel.shareInstance().togeterBuyProductArr.count > 0 {
                    for cartModel  in FKYCartModel.shareInstance().togeterBuyProductArr {
                        if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                            if cartOfInfoModel.supplyId != nil && cartOfInfoModel.promotionId != nil && cartOfInfoModel.spuCode as String == product.spuCode! && cartOfInfoModel.supplyId.intValue == Int(product.enterpriseId!) && cartOfInfoModel.promotionId.intValue == Int(product.togeterBuyId ?? "0") {
                                product.carOfCount = cartOfInfoModel.buyNum.intValue
                                product.carId = cartOfInfoModel.cartId.intValue
                                break
                            }else{
                                product.carOfCount = 0
                                product.carId = 0
                            }
                        }
                    }
                }else {
                    product.carOfCount = 0
                    product.carId = 0
                }
            }
            self.tableView.reloadData()
        }
    }
    
    //刷新点击的cell
    func refreshDataSelectedSection() {
        if let seletedNum = self.selectedRow {
            let maxRow = self.tableView.numberOfRows(inSection: 0)
            if seletedNum < maxRow {
                self.tableView.reloadRows(at: [IndexPath.init(row: seletedNum, section: 0)], with: .none)
            }
        }
    }
    
    //加车动画
    func addCarAnimation(callback: @escaping (_ imgView: UIImageView ,_ imgRect: CGRect)->())  {
        if let imgRect = self.desRect {
            callback(self.desImageView!, imgRect)
        }
    }
}

