//
//  FKYShoppingMoneySingleTebView.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShoppingMoneySingleTebView: UIView {

    /// 下拉刷新
    static let FKY_ShoppingMoneyRefreshAction = "ShoppingMoneyRefreshAction"

    /// 上拉加载
    static let FKY_ShoppingMoneyLoadMoreAction = "ShoppingMoneyLoadMoreAction"

    /// cell点击
    static let FKY_ShoppingMoneyCellClickedAction = "ShoppingMoneyCellClickedAction"

    /// 外层可以开始滚动事件
    static let FKY_ShoppingMoneyOutsideCanScrollAction = "ShoppingMoneyOutsideCanScrollAction"

    /// 记录上一次的偏移量用来判断是向上滑动还是向下滑动
    var lastOffsetY: CGFloat = 0

    /// 是否允许滚动
    var isCanScroll = false

    /// 是否允许下拉刷新
    var isCanRefrash = true

    /// 是否允许上拉加载
    var isCanLoadMore = false

    /// table是否正在滚动
    var isTableScrolling = false

    /// cell列表
    var cellList: [FKYShoppingMoneyRecorderCellModel] = []

    /// 数据源
    var dataList: [FKYShoppingMoneyRecordModel] = []

    /// 记录table
    lazy var mainTableView: UITableView = self.creatMainTableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 数据展示
extension FKYShoppingMoneySingleTebView {

    func showData(data: [FKYShoppingMoneyRecordModel]) {
        self.dataList = data
        self.processingData()
        self.mainTableView.reloadData()
    }
}

//MARK: - 私有方法
extension FKYShoppingMoneySingleTebView {

    /// 整理数据
    func processingData() {
        self.cellList.removeAll()
        guard self.dataList.count > 0 else {
            let cellModel: FKYShoppingMoneyRecorderCellModel = FKYShoppingMoneyRecorderCellModel()
            cellModel.cellType = .emptyCell
            self.cellList.append(cellModel)
            return
        }
        for model in self.dataList {
            let cellModel: FKYShoppingMoneyRecorderCellModel = FKYShoppingMoneyRecorderCellModel()
            cellModel.recorderModel = model
            self.cellList.append(cellModel)
        }
    }
}

//MARK: - 事件响应
extension FKYShoppingMoneySingleTebView {

    /// 下拉刷新
    @objc func refrash() {
        self.routerEvent(withName: FKYShoppingMoneySingleTebView.FKY_ShoppingMoneyRefreshAction, userInfo: [FKYUserParameterKey: ""])
    }

    /// 上拉加载
    @objc func loadMore() {
        self.routerEvent(withName: FKYShoppingMoneySingleTebView.FKY_ShoppingMoneyLoadMoreAction, userInfo: [FKYUserParameterKey: ""])
    }
}


//MARK: - UITableView 代理
extension FKYShoppingMoneySingleTebView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel: FKYShoppingMoneyRecorderCellModel = self.cellList[indexPath.row]
        if cellModel.cellType == .recorderType { // 记录cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYShoppingMoneyRecordCell.self)) as! FKYShoppingMoneyRecordCell
            cell.showCellData(cellData: cellModel.recorderModel)
            return cell
        } else if cellModel.cellType == .emptyCell { // 空态cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYShoppingMoneyEmptyCell.self)) as! FKYShoppingMoneyEmptyCell
            return cell
        }
        let cell = UITableViewCell()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel: FKYShoppingMoneyRecorderCellModel = self.cellList[indexPath.row]
        if cellModel.cellType == .recorderType { // 记录cell
            return tableView.rowHeight
        } else if cellModel.cellType == .emptyCell { // 空态cell
            return WH(400)
        }
        return 0.0001
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel: FKYShoppingMoneyRecorderCellModel = self.cellList[indexPath.row]
        if cellModel.cellType == .recorderType { // 记录cell
            self.routerEvent(withName: FKYShoppingMoneySingleTebView.FKY_ShoppingMoneyCellClickedAction, userInfo: [FKYUserParameterKey: cellModel.recorderModel])
        } else if cellModel.cellType == .emptyCell { // 空态cell

        }
    }
}

//MARK: - UIScrollView 代理
extension FKYShoppingMoneySingleTebView: UIScrollViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            self.isTableScrolling = false
        } else {

        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.isTableScrolling = false
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isTableScrolling = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > 0 ,self.isCanScroll == true{// 向上滑动是一直都可以滑动的。
//            self.isCanScroll = true
//            return
//        }+
        if scrollView.contentOffset.y > self.lastOffsetY { // 向上滑动

        }
        if scrollView.contentOffset.y < 0, self.isCanRefrash == true { // 下拉刷新
            self.isCanScroll = true
            self.lastOffsetY = scrollView.contentOffset.y
            return
        } else if scrollView.contentOffset.y < 0, self.isCanRefrash == false { // 不允许下拉刷新
            scrollView.contentOffset.y = 0
            self.lastOffsetY = 0
            return
        }
        if self.isCanLoadMore, scrollView.contentOffset.y > self.lastOffsetY { // 上拉加载
            self.isCanScroll = true
            self.lastOffsetY = scrollView.contentOffset.y
            return
        }
        if self.isCanScroll {
            self.lastOffsetY = scrollView.contentOffset.y
            if scrollView.contentOffset.y == 0 {
                self.isCanScroll = false
                self.routerEvent(withName: FKYShoppingMoneySingleTebView.FKY_ShoppingMoneyOutsideCanScrollAction, userInfo: [FKYUserParameterKey: ""])
            }
        } else {
            self.lastOffsetY = 0
            scrollView.contentOffset.y = 0
        }
    }
}



//MARK: - UI
extension FKYShoppingMoneySingleTebView {

    func setupUI() {
        self.addSubview(self.mainTableView)

        self.mainTableView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}

//MARK: - 属性对应的生成方法
extension FKYShoppingMoneySingleTebView {
    func creatMainTableView() -> UITableView {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 50
        tb.estimatedSectionHeaderHeight = 0
        tb.estimatedSectionFooterHeight = 0
        tb.separatorStyle = .none
//        tb.register(FKYOrderPayStatusInfocell.self, forCellReuseIdentifier: NSStringFromClass(FKYOrderPayStatusInfocell.self))
//        tb.register(FKYLotteryCell.self, forCellReuseIdentifier: NSStringFromClass(FKYLotteryCell.self))
//        tb.register(FKYLotteryVirtualPrizeCell.self, forCellReuseIdentifier: NSStringFromClass(FKYLotteryVirtualPrizeCell.self))
//        tb.register(FKYLotteryEntityPrizeCell.self, forCellReuseIdentifier: NSStringFromClass(FKYLotteryEntityPrizeCell.self))
//        tb.register(ProductInfoListCell.self, forCellReuseIdentifier: NSStringFromClass(ProductInfoListCell.self))
//        tb.register(FKYLotteryRecommendTipCell.self, forCellReuseIdentifier: NSStringFromClass(FKYLotteryRecommendTipCell.self))
        tb.register(FKYShoppingMoneyEmptyCell.self, forCellReuseIdentifier: NSStringFromClass(FKYShoppingMoneyEmptyCell.self))
        tb.register(FKYShoppingMoneyRecordCell.self, forCellReuseIdentifier: NSStringFromClass(FKYShoppingMoneyRecordCell.self))
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(FKYShoppingMoneySingleTebView.loadMore))
        footer?.setTitle("--没有更多啦！--", for: .noMoreData)
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(FKYShoppingMoneySingleTebView.refrash))
        tb.mj_header = header
        tb.mj_footer = footer
        //tb.backgroundColor = RGBColor(0xF2F2F2)
        tb.backgroundColor = RGBColor(0xFFFFFF)
        return tb
    }
}

//MARK: - cell模型
class FKYShoppingMoneyRecorderCellModel: NSObject {
    enum cellType {
        /// 记录cell
        case recorderType
        /// 空态cell
        case emptyCell
    }

    /// cell类型
    var cellType: cellType = .recorderType

    /// 记录模型
    var recorderModel: FKYShoppingMoneyRecordModel = FKYShoppingMoneyRecordModel()

}

//MARK: - 空态cell
class FKYShoppingMoneyEmptyCell: UITableViewCell {
    var emptyView: DealyRebateEmptyView = DealyRebateEmptyView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension FKYShoppingMoneyEmptyCell {

    func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.addSubview(self.emptyView)
        self.emptyView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}


