//
//  FKYSearchAssociateView.swift
//  FKY
//
//  Created by 油菜花 on 2020/8/31.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  搜索联想词

import UIKit

class FKYSearchAssociateView: UIView {

    /// 点击了某一个联想
    static let selectedAssociateItem = "selectedAssociateItem"
    
    /// 结束编辑收起键盘
    static let endEditing = "FKYSearchAssociateView-endEditing"
    
    /// 联想词modelLIst
    var modelList:[FKYSearchRemindModel] = [FKYSearchRemindModel]()
    
    /// 联想词table
    lazy var searchRemindView:UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .none
        tb.backgroundColor = .white
        tb.register(FKYSearchRemindCell.self, forCellReuseIdentifier: NSStringFromClass(FKYSearchRemindCell.self))
        tb.tableHeaderView = UIView.init(frame: CGRect.zero)
        tb.tableFooterView = UIView.init(frame: CGRect.zero)
        if #available(iOS 11.0, *) {
            tb.contentInsetAdjustmentBehavior = .never
        }
        return tb
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//MARK: - 数据显示
extension FKYSearchAssociateView{
    func showData(dataList:[FKYSearchRemindModel]){
        self.modelList = dataList;
        self.searchRemindView.reloadData()
    }
}

//MARK: - UITableView代理
extension FKYSearchAssociateView: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYSearchRemindCell.self)) as! FKYSearchRemindCell
        let cellModel:FKYSearchRemindModel = self.modelList[indexPath.row]
        cellModel.index = NSNumber(value: indexPath.row+1)
        cell.configCell(cellModel)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < self.modelList.count,self.modelList.count>0 else{
            return;
        }
        let cellModel = self.modelList[indexPath.row]
        self.routerEvent(withName: FKYSearchAssociateView.selectedAssociateItem, userInfo: [FKYUserParameterKey:cellModel])
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.routerEvent(withName: FKYSearchAssociateView.endEditing, userInfo: [FKYUserParameterKey:""])
    }
}

//MARK: - UI
extension FKYSearchAssociateView{
    func setupUI(){
        self.addSubview(self.searchRemindView)
        
        self.searchRemindView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
    }
}
