//
//  HomeSecKillRecommCell.swift
//  FKY
//
//  Created by 寒山 on 2020/4/22.
//  Copyright © 2020 yiyaowang. All rights reserved.
// 首页商家优惠和秒杀推荐活动

import UIKit

class HomeSecKillRecommCell: UITableViewCell {
    ///查看推荐的楼层 String 商品ID
    var checkRecommendBlock: ((HomeRecommendProductItemModel?,HomeSecdKillProductModel,Int,String)->())? //查看推荐的楼层
    //大背景区域
    fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        //        view.layer.masksToBounds = true
        //        view.layer.cornerRadius = WH(8)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    func setupView() {
        self.backgroundColor =  RGBColor(0xF4F4F4)
        contentView.addSubview(contentBgView)
        contentBgView.frame = CGRect.init(x: WH(10), y: 0, width: SCREEN_WIDTH - WH(20), height: WH(145))
    }
}

//MARK: - 数据展示
extension HomeSecKillRecommCell{
    
    /// 展示cell数据
    func configCellData(_ cellData:HomeBaseCellProtocol){
        let cellData_t = cellData as! HomeFloorModel
        if cellData_t.hasBtttom == true{
            self.setMutiBorderRoundingCorners(contentBgView,WH(8),[UIRectCorner.topLeft, UIRectCorner.topRight])
        }else{
            self.setMutiBorderRoundingCorners(contentBgView,WH(8),[UIRectCorner.allCorners])
        }
        for subview in self.contentBgView.subviews {
            if subview.isKind(of: HomeComboInfoTypeView.self) || subview.isKind(of: HomeSecKillInfoView.self) || subview.isKind(of: HomeBusinesssRecomView.self){
                subview.removeFromSuperview()
            }
        }
        if cellData.cellType == .HomeCellTypeOneComponents {// 一行两个相同组件
            for item in cellData_t.modelList ?? [HomeSecdKillProductModel]() {
                self.showOneComponents(component: item, hasBtttom: cellData_t.hasBtttom)
            }
        }else if cellData.cellType == .HomeCellTypeTwoComponents {// 一行两个不同组件
            // 先都隐藏
            for (index,item) in (cellData_t.modelList ?? [HomeSecdKillProductModel]()).enumerated() {
                self.showTwoComponentsData(component: item, hasBtttom: cellData_t.hasBtttom, index: index+1)
            }
        }
    }
    
    /// 一行两个不同组件的展示 index 标识组件的前后顺序，小的在前大的在后
    func showTwoComponentsData(component:HomeSecdKillProductModel,hasBtttom:Bool,index:Int){
        if component.type == 26 {
            // 秒杀栈一行
            let secKillInfoView = HomeSecKillInfoView()
            secKillInfoView.backgroundColor = .white
            secKillInfoView.clickProductBlock = {[weak self] (productModel,model) in
                //点击推荐的楼层
                if let strongSelf = self {
                    if let closure = strongSelf.checkRecommendBlock {
                        closure(productModel,model,0,"")
                    }
                }
            }
            contentBgView.addSubview(secKillInfoView)
            self.layoutSecKillComponent(secKillInfoView,index: index)
            self.showSecKillComponentData(secKillInfoView,data: component, Type: 2)
        }
        else if component.type == 27 {
           // 商家特惠占一行
            let recomInfoView = HomeBusinesssRecomView()
            recomInfoView.backgroundColor = .white
            recomInfoView.clickProductBlock = {[weak self] (productModel,model) in
                //点击推荐的楼层
                if let strongSelf = self {
                    if let closure = strongSelf.checkRecommendBlock {
                        closure(productModel,model,1,"")
                    }

                }
            }
            contentBgView.addSubview(recomInfoView)
            self.layoutShopRecommComponent(recomInfoView,index: index)
             self.recomInfoViewData(recomInfoView,data: component, Type: 2)
        }
        else if component.type == 39 {
            // 搭配套餐占一行
            let comboInfoView = HomeComboInfoTypeView()
            comboInfoView.backgroundColor = .white
            comboInfoView.clickProductBlock = {[weak self] (productModel,model,productID) in
                //点击推荐的楼层
                if let strongSelf = self {
                    if let closure = strongSelf.checkRecommendBlock {
                        closure(productModel,model,1,productID)
                    }
                }
            }
            contentBgView.addSubview(comboInfoView)
            self.layoutPackageComponent(comboInfoView,index: index)
            self.comboInfoViewData(comboInfoView,data: component, Type: 2)
        }
        else if component.type == 40 {
            // 固定套餐
            let GDcomboInfoView = HomeComboInfoTypeView()
            GDcomboInfoView.backgroundColor = .white
            GDcomboInfoView.clickProductBlock = {[weak self] (productModel,model,productID) in
                //点击推荐的楼层
                if let strongSelf = self {
                    if let closure = strongSelf.checkRecommendBlock {
                        closure(productModel,model,2,productID)
                    }
                }
            }
            contentBgView.addSubview(GDcomboInfoView)
            self.layoutGDPackageComponent(GDcomboInfoView,index: index)
            self.GDcomboInfoViewData(GDcomboInfoView,data: component, Type: 2)
        }
    }
    
    /// 一行两个相同组件的展示  cellData 组件列表
    func showOneComponents(component:HomeSecdKillProductModel,hasBtttom:Bool){
        guard component.type != -199 else{
            return
        }
        if component.type == 26 {
            // 秒杀栈一行
            let secKillInfoView = HomeSecKillInfoView()
            secKillInfoView.backgroundColor = .white
            secKillInfoView.clickProductBlock = {[weak self] (productModel,model) in
                //点击推荐的楼层
                if let strongSelf = self {
                    if let closure = strongSelf.checkRecommendBlock {
                        closure(productModel,model,0,"")
                    }
                }
            }
            contentBgView.addSubview(secKillInfoView)
            secKillInfoView.snp.remakeConstraints { (make) in
                make.top.equalTo(contentBgView)
                make.left.equalTo(contentBgView)
                make.right.equalTo(contentBgView)
                make.bottom.equalTo(contentBgView)
            }
             self.showSecKillComponentData(secKillInfoView,data: component, Type: 1)
        }
        else if component.type == 27 {
           // 商家特惠占一行
            let recomInfoView = HomeBusinesssRecomView()
            recomInfoView.backgroundColor = .white
            recomInfoView.clickProductBlock = {[weak self] (productModel,model) in
                //点击推荐的楼层
                if let strongSelf = self {
                    if let closure = strongSelf.checkRecommendBlock {
                        closure(productModel,model,1,"")
                    }

                }
            }
            contentBgView.addSubview(recomInfoView)
            recomInfoView.snp.remakeConstraints { (make) in
                make.top.equalTo(contentBgView)
                make.left.equalTo(contentBgView)
                make.right.equalTo(contentBgView)
                make.bottom.equalTo(contentBgView)
            }
             self.recomInfoViewData(recomInfoView,data: component, Type: 1)
        }
        else if component.type == 39 {
            // 搭配套餐占一行
            let comboInfoView = HomeComboInfoTypeView()
            comboInfoView.backgroundColor = .white
            comboInfoView.clickProductBlock = {[weak self] (productModel,model,productID) in
                //点击推荐的楼层
                if let strongSelf = self {
                    if let closure = strongSelf.checkRecommendBlock {
                        closure(productModel,model,1,productID)
                    }
                }
            }
            contentBgView.addSubview(comboInfoView)
            comboInfoView.snp.remakeConstraints { (make) in
                make.top.equalTo(contentBgView)
                make.left.equalTo(contentBgView)
                make.right.equalTo(contentBgView)
                make.bottom.equalTo(contentBgView)
            }
            self.comboInfoViewData(comboInfoView,data: component, Type: 1)
        }
        else if component.type == 40 {
            // 固定套餐
            let GDcomboInfoView = HomeComboInfoTypeView()
            GDcomboInfoView.backgroundColor = .white
            GDcomboInfoView.clickProductBlock = {[weak self] (productModel,model,productID) in
                //点击推荐的楼层
                if let strongSelf = self {
                    if let closure = strongSelf.checkRecommendBlock {
                        closure(productModel,model,2,productID)
                    }
                }
            }
            contentBgView.addSubview(GDcomboInfoView)
            GDcomboInfoView.snp.remakeConstraints { (make) in
                make.top.equalTo(contentBgView)
                make.left.equalTo(contentBgView)
                make.right.equalTo(contentBgView)
                make.bottom.equalTo(contentBgView)
            }
            self.GDcomboInfoViewData(GDcomboInfoView,data: component, Type: 1)
        }
    }
    
    /// 展示秒杀模块数据 Type 1 代表一个秒杀模块沾满一行 2代表用两个秒杀模块沾满一行
    func showSecKillComponentData(_ contentView:HomeSecKillInfoView,data:HomeSecdKillProductModel,Type:Int){
        // 中间用这个方法隔一层是为了以后加type方便 下同
        contentView.configCell(data, Type)
    }
    
    /// 展示商家特惠组件数据 Type 1 代表一个商家特惠模块沾满一行 2代表用两个商家特惠模块沾满一行
    func recomInfoViewData(_ contentView:HomeBusinesssRecomView,data:HomeSecdKillProductModel,Type:Int){
        contentView.configCell(data, Type)
    }
    
    /// 展示搭配套餐组件数据 Type 1 代表一个搭配套餐/固定套餐模块沾满一行 2代表用两个搭配套餐/固定套餐模块沾满一行
    func comboInfoViewData(_ contentView:HomeComboInfoTypeView,data:HomeSecdKillProductModel,Type:Int){
        contentView.configCell(data, Type)
    }
    
    /// 展示固定套餐组件数据 Type 1 代表一个搭配套餐/固定套餐模块沾满一行 2代表用两个搭配套餐/固定套餐模块沾满一行
    func GDcomboInfoViewData(_ contentView:HomeComboInfoTypeView,data:HomeSecdKillProductModel,Type:Int){
        contentView.configCell(data, Type)
    }
}

extension  HomeSecKillRecommCell{
    //设置圆角
    func setMutiBorderRoundingCorners(_ view:UIView,_ corner:CGFloat,_ corners: UIRectCorner){
        
        let maskPath = UIBezierPath.init(roundedRect: view.bounds,
                                         
                                         byRoundingCorners: corners,
                                         
                                         cornerRadii: CGSize(width: corner, height: corner))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = view.bounds
        
        maskLayer.path = maskPath.cgPath
        
        view.layer.mask = maskLayer
        
    }
    
}

//MARK: - UI
extension HomeSecKillRecommCell{
    
    /// 约束秒杀组件是在左边还是右边 1 左边2右 防止以后出现多个方位，所以用int
    func layoutSecKillComponent(_ secKillInfoView:HomeSecKillInfoView,index:Int){
        if index == 1 {//左
            secKillInfoView.snp.remakeConstraints { (make) in
                make.top.equalTo(contentBgView)
                make.left.equalTo(contentBgView)
                make.right.equalTo(contentBgView.snp.centerX).offset(-0.5)
                make.bottom.equalTo(contentBgView)
            }
        }
        else if index == 2 {// 右
            secKillInfoView.snp.remakeConstraints { (make) in
                make.top.equalTo(contentBgView)
                make.right.equalTo(contentBgView)
                make.left.equalTo(contentBgView.snp.centerX).offset(0.5)
                make.bottom.equalTo(contentBgView)
            }
        }
    }
    
    /// 约束商家特惠组件是在左边还是右边 1 左边2右 防止以后出现多个方位，所以用int
    func layoutShopRecommComponent(_ recomInfoView:HomeBusinesssRecomView,index:Int){
        if index == 1 {//左
            recomInfoView.snp.remakeConstraints { (make) in
                make.top.equalTo(contentBgView)
                make.left.equalTo(contentBgView)
                make.right.equalTo(contentBgView.snp.centerX).offset(-0.5)
                make.bottom.equalTo(contentBgView)
            }
        }
        else if index == 2 {// 右
            recomInfoView.snp.remakeConstraints { (make) in
                make.top.equalTo(contentBgView)
                make.right.equalTo(contentBgView)
                make.left.equalTo(contentBgView.snp.centerX).offset(0.5)
                make.bottom.equalTo(contentBgView)
            }
        }
    }
    
    /// 约束搭配套餐组件是在左边还是右边 1 左边2右 防止以后出现多个方位，所以用int
    func layoutPackageComponent(_ comboInfoView:HomeComboInfoTypeView,index:Int){
        if index == 1 {//左
            comboInfoView.snp.remakeConstraints { (make) in
                make.top.equalTo(contentBgView)
                make.left.equalTo(contentBgView)
                make.right.equalTo(contentBgView.snp.centerX).offset(-0.5)
                make.bottom.equalTo(contentBgView)
            }
        }
        else if index == 2 {// 右
            comboInfoView.snp.remakeConstraints { (make) in
                make.top.equalTo(contentBgView)
                make.right.equalTo(contentBgView)
                make.left.equalTo(contentBgView.snp.centerX).offset(0.5)
                make.bottom.equalTo(contentBgView)
            }
        }
    }
    
    /// 约束固定套餐组件是在左边还是右边 1 左边2右 防止以后出现多个方位，所以用int
    func layoutGDPackageComponent(_ GDcomboInfoView:HomeComboInfoTypeView,index:Int){
        if index == 1 {//左
            GDcomboInfoView.snp.remakeConstraints { (make) in
                make.top.equalTo(contentBgView)
                make.left.equalTo(contentBgView)
                make.right.equalTo(contentBgView.snp.centerX).offset(-0.5)
                make.bottom.equalTo(contentBgView)
            }
        }
        else if index == 2 {// 右
            GDcomboInfoView.snp.remakeConstraints { (make) in
                make.top.equalTo(contentBgView)
                make.right.equalTo(contentBgView)
                make.left.equalTo(contentBgView.snp.centerX).offset(0.5)
                make.bottom.equalTo(contentBgView)
            }
        }
    }
}
