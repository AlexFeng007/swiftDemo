//
//  FKYHomePageTwoSameItemCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/26.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  一行两个相同组件

import UIKit

class FKYHomePageTwoSameItemCell: UITableViewCell {

    
    /// 商品点击
    static let productClickedAction = "FKYHomePageTwoSameItemCell-productClickedAction"
    
    static let itemBIAction = "FKYHomePageTwoSameItemCell-itemBIAction"
    
    var cellModel:FKYHomePageV3CellModel = FKYHomePageV3CellModel()
    
    /// 秒杀占一行的组件 4个商品
    var seckillView:FKYHomePageItemType7 = FKYHomePageItemType7()
    
    /// 商家特惠占一行的组件 4个商品
    var businessSpecialView:FKYHomePageItemType8 = FKYHomePageItemType8()
    
    /// 搭配套餐/固定套餐占一行 的组件 搭配套餐和固定套餐展示样式一样
    var packageView:FKYHomePageItemType9 = FKYHomePageItemType9()
    
    /// 底部分割线
    var bottomMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.isHidden = true
        return view
    }()
    
    /// 容器视图
    var containerView:UIView = UIView()
    
    /// 距离底部的距离
    var bottomMargin:CGFloat = WH(8)
    
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

//MARK: - 数据显示
extension FKYHomePageTwoSameItemCell{
    func configCell(cellModel:FKYHomePageV3CellModel){
        self.cellModel = cellModel
        
        guard self.cellModel.cellModel.contents.recommendDinnerList.count > 0 else {
            return
        }
        let floor = cellModel.cellModel.contents.recommendDinnerList[0]
        if floor.type == 26 {// 秒杀栈一行
            showViewIndex(index: 1)
            configSecKillData(model: floor)
        }else if floor.type == 27{// 商家特惠占一行
            showViewIndex(index: 2)
            configBusinessData(model: floor)
        }else if floor.type == 39{// 搭配套餐占一行
            showViewIndex(index: 3)
            showPackageData(model: floor)
        }else if floor.type == 40 {// 固定套餐占一行
            showViewIndex(index: 4)
            showPackageData(model: floor)
        }
    }
    
    /// 显示秒杀数据
    func configSecKillData(model:FKYHomePageV3ItemModel){
        seckillView.showData(itemModel: model)
    }
    
    /// 显示商家特惠数据
    func configBusinessData(model:FKYHomePageV3ItemModel){
        businessSpecialView.showData(itemModel: model)
    }
    
    /// 显示套餐数据
    func showPackageData(model:FKYHomePageV3ItemModel){
        packageView.showData(itemModel: model)
    }
}

//MARK: - 事件响应
extension FKYHomePageTwoSameItemCell{
    
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKYHomePageItemType8.productClickedAction {
            
            super.routerEvent(withName: FKYHomePageTwoSameItemCell.productClickedAction, userInfo: userInfo)
            guard cellModel.cellModel.contents.recommendDinnerList.count > 0 else{
                return
            }
            let floor = cellModel.cellModel.contents.recommendDinnerList[0]
            super.routerEvent(withName: FKYHomePageTwoSameItemCell.itemBIAction, userInfo: [FKYUserParameterKey:["index":0,"itemData":floor]])
            
        }else if eventName == FKYHomePageItemType7.productClickedAction {
            
            super.routerEvent(withName: FKYHomePageTwoSameItemCell.productClickedAction, userInfo: userInfo)
            guard cellModel.cellModel.contents.recommendDinnerList.count > 0 else{
                return
            }
            let floor = cellModel.cellModel.contents.recommendDinnerList[0]
            super.routerEvent(withName: FKYHomePageTwoSameItemCell.itemBIAction, userInfo: [FKYUserParameterKey:["index":0,"itemData":floor]])
            
        }else if eventName == FKYHomePageItemType9.productClickedAction {
            
            super.routerEvent(withName: FKYHomePageTwoSameItemCell.productClickedAction, userInfo: userInfo)
            guard cellModel.cellModel.contents.recommendDinnerList.count > 0 else{
                return
            }
            let floor = cellModel.cellModel.contents.recommendDinnerList[0]
            super.routerEvent(withName: FKYHomePageTwoSameItemCell.itemBIAction, userInfo: [FKYUserParameterKey:["index":0,"itemData":floor]])
            
        }else{
            super.routerEvent(withName: eventName, userInfo: userInfo)
        }
    }
    
}

//MARK: - UI
extension FKYHomePageTwoSameItemCell{
    override func configCellDisplayInfo() {
        super.configCellDisplayInfo()
        setCorners()
    }
    
    /// 设置圆角
    /// - Parameter type: 1 只设置上左上右  2 只设置下左 下右  3上下左右全设置 0啥也不设置
    func configCorners(type:Int){
        containerView.layoutIfNeeded()
        containerView.layer.mask = nil
        if type == 1{
            containerView.setRoundedCorners([UIRectCorner.topLeft, UIRectCorner.topRight], radius: WH(8))
        }else if type == 2{
            containerView.setRoundedCorners([UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radius: WH(8))
        }else if type == 3{
            containerView.setRoundedCorners(UIRectCorner.allCorners, radius: WH(8))
        }
    }
    
    /// 配置底部的空白距离
    func configBottomMargin(){
        containerView.snp_updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottomMargin)
        }
    }
    
    /// 展示那个view
    /// - Parameter index: 1秒杀  2 商家特惠 3搭配套餐 4固定套餐
    func showViewIndex(index:Int){
        /*
        seckillView.isHidden = true
        businessSpecialView.isHidden = true
        packageView.isHidden = true
        */
        if index == 1{
            seckillView.isHidden = false
            businessSpecialView.isHidden = true
            packageView.isHidden = true
        }else if index == 2{
            seckillView.isHidden = true
            businessSpecialView.isHidden = false
            packageView.isHidden = true
        }else if index == 3{
            seckillView.isHidden = true
            businessSpecialView.isHidden = true
            packageView.isHidden = false
        }else if index == 4{
            seckillView.isHidden = true
            businessSpecialView.isHidden = true
            packageView.isHidden = false
        }
    }
    
    func setCorners(){
        var flag = 0
        if self.cellModel.isNeedTopCorner {
            flag += 1
        }
        
        if self.cellModel.isNeedBottomCorner{
            flag += 2
            bottomMarginLine.isHidden = true
            self.bottomMargin = WH(8)
        }else{
            bottomMarginLine.isHidden = false
            self.bottomMargin = WH(0)
        }
        configBottomMargin()
        configCorners(type: flag)
        
    }
    
    func setupUI(){
        selectionStyle = .none
        backgroundColor = .clear
        containerView.backgroundColor = RGBColor(0xFFFFFF)
        
        contentView.addSubview(containerView)
        containerView.addSubview(seckillView)
        containerView.addSubview(businessSpecialView)
        containerView.addSubview(packageView)
        containerView.addSubview(bottomMarginLine)
        
        containerView.snp_makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
            make.bottom.equalToSuperview().offset(WH(0))
        }
        
        seckillView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        businessSpecialView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        packageView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        bottomMarginLine.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

