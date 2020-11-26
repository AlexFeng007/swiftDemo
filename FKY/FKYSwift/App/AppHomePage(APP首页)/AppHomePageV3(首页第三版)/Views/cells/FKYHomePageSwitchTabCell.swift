//
//  FKYHomePageSwitchTabCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/14.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePageSwitchTabCell: UITableViewCell {

    var headerView:HomePageV3SwitchTabView = HomePageV3SwitchTabView()
    
    var tabView:FKYHomePageV3ContainerTabView = FKYHomePageV3ContainerTabView()
    
    /// 当前显示的tab序号
    var currentDisplayIndex:Int = 0
    
    var cellData:FKYHomePageV3CellModel = FKYHomePageV3CellModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: - 数据展示
extension FKYHomePageSwitchTabCell{
    func configCell(cellData:FKYHomePageV3CellModel){
        self.cellData = cellData
        for (tabIndex,tabData) in self.cellData.switchTabHeaderData.enumerated(){
            if tabIndex == currentDisplayIndex {
                tabData.isSelected = true
            }else{
                tabData.isSelected = false
            }
        }
        headerView.configData(headerData: self.cellData.switchTabHeaderData)
        tabView.configTabData(tabList: self.cellData.flowTabModelList, currentTab: currentDisplayIndex)
        //print("传进来的高度:\(self.cellData.switchCellHeight)")
        //print("计算后的高度:\(self.cellData.switchCellHeight-WH(60))")
        tabView.updataCollectionViewHeight(height: self.cellData.switchCellHeight-WH(60))
    }
}

//MARK: - 事件响应
extension FKYHomePageSwitchTabCell{
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == HomePageV3SwitchTabView.switchItemAction {// 点击切换tab
            let index = userInfo[FKYUserParameterKey] as! Int
            currentDisplayIndex = index
            tabView.scrollTopPage(page: index)
        }else if eventName == FKYHomePageV3ContainerTabView.scrollSwitchTab {// 滑动切换
            let index = userInfo[FKYUserParameterKey] as! Int
            currentDisplayIndex = index
            for (index_t,itemData) in cellData.switchTabHeaderData.enumerated(){
                if index == index_t {
                    itemData.isSelected = true
                }else{
                    itemData.isSelected = false
                }
            }
            //headerView.switchToTab(index: index)
            headerView.configData(headerData: cellData.switchTabHeaderData)
        }
        else{
            super.routerEvent(withName: eventName, userInfo: userInfo)
        }
    }

    /// 标志位
    func isSupperScrollToBottom(isBottom:Bool){
        tabView.isSupperScrollToBottom = isBottom
    }
    
    func isSupperScrollToTop(isTop:Bool){
        tabView.isSupperScrollToTop = isTop
    }
    
}

//MARK: - UI
extension FKYHomePageSwitchTabCell{
    
    func setupUI(){
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(headerView)
        contentView.addSubview(tabView)
        
        headerView.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        headerView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        
        headerView.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
            make.top.equalToSuperview()
            make.height.equalTo(WH(60))
        }
        
        tabView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(headerView.snp_bottom)
        }
    }
}
