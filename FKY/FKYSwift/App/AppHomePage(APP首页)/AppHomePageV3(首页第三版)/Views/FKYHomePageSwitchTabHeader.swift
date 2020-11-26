//
//  FKYHomePageSwitchTabHeader.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  tab切换视图

import UIKit

class FKYHomePageSwitchTabHeader: UITableViewHeaderFooterView {
    
    /// 切换item
    static let switchItemAction = "FKYHomePageSwitchTabHeader-switchItemAction"
    
    //4个item
    lazy var item1:FKYHomePageSwitchItemView = FKYHomePageSwitchItemView()
    lazy var item2:FKYHomePageSwitchItemView = FKYHomePageSwitchItemView()
    lazy var item3:FKYHomePageSwitchItemView = FKYHomePageSwitchItemView()
    lazy var item4:FKYHomePageSwitchItemView = FKYHomePageSwitchItemView()
    
    /// 容器视图
    lazy var contaierView:UIView = UIView()
    
    /// 4个item的list
    var itemViewList:[FKYHomePageSwitchItemView] = [FKYHomePageSwitchItemView]()
    
    var headerData:[FKYHomePageV3SwitchTabModel] = [FKYHomePageV3SwitchTabModel]()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        itemViewList = [item1,item2,item3,item4]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 数据展示
extension FKYHomePageSwitchTabHeader{
    func configData(headerData:[FKYHomePageV3SwitchTabModel]){
        self.headerData = headerData
        showItem()
    }
    
    func showItem(){
        for (index,itemData) in headerData.enumerated() {
            guard index < itemViewList.count else {
                return
            }
            let itemView = itemViewList[index]
            itemView.showData(itemData: itemData)
        }
    }
}

//MARK: - 事件响应
extension FKYHomePageSwitchTabHeader{
    
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKYHomePageSwitchItemView.itemClicked{// 切换item
            let itemData = userInfo[FKYUserParameterKey] as! FKYHomePageV3SwitchTabModel
            guard itemData.isSelected != true else {// 点击的是已经选中过的item不做响应
                return
            }
            var index_t = 0
            for (index,itemData_t) in headerData.enumerated(){
                if  itemData == itemData_t{
                    itemData_t.isSelected = true
                    index_t = index
                }else{
                    itemData_t.isSelected = false
                }
                
                guard index < itemViewList.count else {
                    continue
                }
                let itemView = itemViewList[index]
                itemView.showData(itemData: itemData_t)
            }
            super.routerEvent(withName: FKYHomePageSwitchTabHeader.switchItemAction, userInfo: [FKYUserParameterKey:index_t])
        }
    }
    
}

//MARK: - UI
extension FKYHomePageSwitchTabHeader{
    func setupUI(){
        
        backgroundColor = .clear
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        backgroundView?.backgroundColor = .clear
        contaierView.backgroundColor = RGBColor(0xF4F4F4)
        
        contentView.addSubview(contaierView)
        contaierView.addSubview(item1)
        contaierView.addSubview(item2)
        contaierView.addSubview(item3)
        contaierView.addSubview(item4)
        
        let itemWidth = (SCREEN_WIDTH-WH(20))/4
        
        item4.rightMarginLine.isHidden = true
        
        contaierView.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
            make.top.bottom.equalToSuperview()
        }
        
        item1.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(0))
            make.top.bottom.equalToSuperview()
            make.height.equalTo(WH(60))
            make.width.equalTo(itemWidth)
        }
        
        item2.snp_makeConstraints { (make) in
            make.left.equalTo(item1.snp_right).offset(0)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(WH(60))
            make.width.equalTo(itemWidth)
        }
        
        item3.snp_makeConstraints { (make) in
            make.left.equalTo(item2.snp_right).offset(0)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(WH(60))
            make.width.equalTo(itemWidth)
        }
        
        item4.snp_makeConstraints { (make) in
            make.left.equalTo(item3.snp_right).offset(0)
            make.right.equalToSuperview().offset(0)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(WH(60))
            make.width.equalTo(itemWidth)
        }
    }
    
    /// 展示多少个item 将不需要展示的item删除
    /// - Parameter count: 展示的数量
    func showItemCount(count:Int){
        installAllItemView()
        if count<4 {
            item4.isHidden = true
            item4.snp_updateConstraints { (make) in
                make.width.equalTo(0)
            }
            item3.rightMarginLine.isHidden = true
        }
        
        if count < 3 {
            item3.isHidden = true
            item3.snp_updateConstraints { (make) in
                make.width.equalTo(0)
            }
            item2.rightMarginLine.isHidden = true
        }
        
        if count < 2 {
            item2.isHidden = true
            item2.snp_updateConstraints { (make) in
                make.width.equalTo(0)
            }
            item1.rightMarginLine.isHidden = true
        }
        
        if count < 1 {
            item1.snp_updateConstraints { (make) in
                make.width.equalTo(0)
            }
            item1.isHidden = true
        }
    }
    
    func installAllItemView(){
        let itemWidth = (SCREEN_WIDTH-WH(20))/4
        item1.snp_updateConstraints { (make) in
            make.width.equalTo(itemWidth)
        }
        item2.snp_updateConstraints { (make) in
            make.width.equalTo(itemWidth)
        }
        item3.snp_updateConstraints { (make) in
            make.width.equalTo(itemWidth)
        }
        item4.snp_updateConstraints { (make) in
            make.width.equalTo(itemWidth)
        }
        item1.rightMarginLine.isHidden = false
        item2.rightMarginLine.isHidden = false
        item3.rightMarginLine.isHidden = false
        item4.rightMarginLine.isHidden = true
    }
}
