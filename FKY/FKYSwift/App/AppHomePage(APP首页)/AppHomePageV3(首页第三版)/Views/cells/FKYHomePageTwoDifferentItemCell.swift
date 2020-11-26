//
//  FKYHomePageTwoDifferentItemCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/26.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePageTwoDifferentItemCell: UITableViewCell {

    /// 商品点击
    static let productClickedAction = "FKYHomePageTwoDifferentItemCell-productClickedAction"
    
    /// 埋点事件
    static let ItemBIAction = "FKYHomePageTwoDifferentItemCell-ItemBIAction"
    
    /// 容器视图
    var containerView:UIView = UIView()
    
    var cellModel:FKYHomePageV3CellModel = FKYHomePageV3CellModel()
    
    /// 第一个模块
    var firstView:UIView = UIView()
    
    /// 第二个模块
    var secondView:UIView = UIView()
    
    /// 距离底部的距离
    var bottomMargin:CGFloat = WH(8)
    
    var centerMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.isHidden = true
        return view
    }()
    
    /// 底部分割线
    var bottomMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.isHidden = true
        return view
    }()
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
extension FKYHomePageTwoDifferentItemCell{
    func configCell(cellModel:FKYHomePageV3CellModel){
        self.cellModel = cellModel
        
        for (index,itemModel) in self.cellModel.cellModel.contents.recommendDinnerList.enumerated(){
            addItemView(itemModel: itemModel, index: index)
        }
        
        if cellModel.cellModel.contents.recommendDinnerList.count < 2 {
            centerMarginLine.isHidden = true
        }else{
            centerMarginLine.isHidden = false
        }
        
        layoutItemView()
    }
    
    /// 添加item 并展示
    func addItemView(itemModel:FKYHomePageV3ItemModel,index:Int){
//        guard itemModel.floorProductDtos.count > 0 ||  else {
//            return
//        }
        
        if itemModel.type == 26 {// 当前是秒杀组件
            
            var tempView = UIView()
            if itemModel.floorProductDtos.count == 1{// 只有一个商品
                let temp_t = FKYHomaPageSeckillView()
                temp_t.showData(itemModel: itemModel)
                tempView = temp_t
                
            }else if itemModel.floorProductDtos.count == 2{// 只有两个商品
                let temp_t = FKYHomePageItemType6()
                temp_t.showData(itemModel:itemModel)
                tempView = temp_t
            }
            
            if index == 0{// 在左边
                firstView = tempView
            }else if index == 1{// 在右边
                secondView = tempView
            }
            
        }else if itemModel.type == 27{// 当前是商家特惠组件
            
            if index == 0{// 在左边
                let temp_t = FKYHomePageItemType4()
                temp_t.showData(itemModel:itemModel)
                firstView = temp_t
            }else if index == 1{// 在右边
                let temp_t = FKYHomePageItemType4()
                temp_t.showData(itemModel:itemModel)
                secondView = temp_t
            }
            
        }else if itemModel.type == 39{// 当前是搭配套餐
            
            if index == 0{// 在左边
                let temp_t = FKYHomePageItemType1()
                temp_t.showItemData(itemModel:itemModel)
                firstView = temp_t
            }else if index == 1{// 在右边
                let temp_t = FKYHomePageItemType1()
                temp_t.showItemData(itemModel:itemModel)
                secondView = temp_t
            }
            
        }else if itemModel.type == 40{// 固定套餐
            
            if index == 0{// 在左边
                let temp_t = FKYHomePageItemType1()
                temp_t.showItemData(itemModel:itemModel)
                firstView = temp_t
            }else if index == 1{// 在右边
                let temp_t = FKYHomePageItemType1()
                temp_t.showItemData(itemModel:itemModel)
                secondView = temp_t
            }
            
        }
        
    }
}

//MARK: - 事件响应
extension FKYHomePageTwoDifferentItemCell{
    
    /// 拦截整合
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKYHomaPageSeckillView.seckillClickAction {// 一个商品秒杀点击
            
            super.routerEvent(withName: FKYHomePageTwoDifferentItemCell.productClickedAction, userInfo: userInfo)
            
        }else if eventName == FKYHomePageItemType6.productClickedAction {// 两个商品秒杀点击
            
            super.routerEvent(withName: FKYHomePageTwoDifferentItemCell.productClickedAction, userInfo: userInfo)
            
        }else if eventName == FKYHomePageItemType4.productClickedAction{// 商家特惠点击
            
            super.routerEvent(withName: FKYHomePageTwoDifferentItemCell.productClickedAction, userInfo: userInfo)
            
        }else if eventName == FKYHomePageItemType1.productClickedAction {// 固定搭配套餐点击
            
            super.routerEvent(withName: FKYHomePageTwoDifferentItemCell.productClickedAction, userInfo: userInfo)
            
        }else if eventName ==  FKYHomaPageSeckillView.ItemBIAction ||
                    eventName == FKYHomePageItemType6.ItemBIAction ||
                    eventName == FKYHomePageItemType4.ItemBIAction ||
                    eventName == FKYHomePageItemType1.ItemBIAction {// BI事件拦击
            let dic = userInfo[FKYUserParameterKey] as! [String:Any]
            let view = dic["view"] as! UIView
            let itemData = dic["itemData"]
            var index = 0
            if view == firstView {
                index = 0
            }else if view == secondView {
                index = 1
            }
            
            super.routerEvent(withName: FKYHomePageTwoDifferentItemCell.ItemBIAction, userInfo: [FKYUserParameterKey:["index":index,"itemData":itemData]])
        }
        else{
            super.routerEvent(withName: eventName, userInfo: userInfo)
        }
    }
}

//MARK: - UI
extension FKYHomePageTwoDifferentItemCell{
    
    override func configCellDisplayInfo() {
        super.configCellDisplayInfo()
        setCorners()
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
            containerView.setRoundedCorners([UIRectCorner.bottomLeft, UIRectCorner.bottomRight,UIRectCorner.topLeft, UIRectCorner.topRight], radius: WH(8))
        }
    }
    
    /// 配置底部的空白距离
    func configBottomMargin(){
        containerView.snp_updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottomMargin)
        }
    }
    
    func setupUI(){
        selectionStyle = .none
        backgroundColor = .clear
        containerView.backgroundColor = RGBColor(0xFFFFFF)
        
        contentView.addSubview(containerView)
        
        containerView.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(WH(0))
        }
        
    }
    
    func layoutItemView(){
        
        
        
        containerView.subviews.forEach { (view:UIView) in
            view.removeFromSuperview()
        }
        
        
        containerView.addSubview(firstView)
        containerView.addSubview(secondView)
        containerView.addSubview(bottomMarginLine)
        containerView.addSubview(centerMarginLine)
        
        firstView.snp_remakeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(10))
            make.top.bottom.equalToSuperview()
            make.right.equalTo(containerView.snp_centerX).offset(WH(-7))
        }
        
        secondView.snp_remakeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(containerView.snp_centerX).offset(WH(7))
            make.right.equalToSuperview().offset(WH(-10))
        }
        
        centerMarginLine.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1)
        }

        bottomMarginLine.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
}
