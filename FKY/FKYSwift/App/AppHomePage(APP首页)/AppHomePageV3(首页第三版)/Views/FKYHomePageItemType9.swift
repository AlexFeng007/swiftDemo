//
//  FKYHomePageItemType9.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/27.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  超值套餐模块 固定套餐 搭配套餐 一行4个商品的组件 固定套餐/搭配套餐沾满一整行的情况

import UIKit

class FKYHomePageItemType9: UIView {
    
    /// 商品点击事件
    static let productClickedAction = "FKYHomePageItemType9-productClickedAction"
    
    /// 套餐1
    var packageView1:FKYHomePageItemType1 = FKYHomePageItemType1()
    /// 套餐2
    var packageView2:FKYHomePageItemType1 = FKYHomePageItemType1()
    
    var itemModel:FKYHomePageV3ItemModel = FKYHomePageV3ItemModel()
    var packageList:[FKYHomePageItemType1] = [FKYHomePageItemType1]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        packageList = [packageView1,packageView2]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 展示数据
extension FKYHomePageItemType9{
    func showData(itemModel:FKYHomePageV3ItemModel){
        self.itemModel = itemModel
        packageView1.titleLB.text = self.itemModel.name
        packageView1.tagView.configTitle(title: self.itemModel.title)
        for (index,package) in self.itemModel.dinnerVOList.enumerated() {
            configPackageData(index: index, packageModel: package)
        }
    }
    
    func configPackageData(index:Int,packageModel:FKYHomePageV3PackageModel){
        guard index < packageList.count else {
            return
        }
        let package = packageList[index]
        package.showProductData(pakcageModel: packageModel)
    }
}

//MARK: - 事件响应
extension FKYHomePageItemType9{
    
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKYHomePageItemType1.productClickedAction {// 拦截item的点击事件
            let product = userInfo[FKYUserParameterKey] as! FKYHomePageV3FloorProductModel
            let param = ["itemData":self.itemModel,"product":product]
            super.routerEvent(withName: FKYHomePageItemType9.productClickedAction, userInfo: [FKYUserParameterKey:param])
        }else{
            super.routerEvent(withName: eventName, userInfo: userInfo)
        }
    }
}

//MARK: - UI
extension FKYHomePageItemType9{
    func setupUI(){
        packageView1.tagView.configType(iconName: "home_shop_dir_violet", borderColor: RGBColor(0x8D56EF), cornerRadius: WH(16/2), textColor: RGBColor(0x8D56EF))
        addSubview(packageView1)
        addSubview(packageView2)
        packageView2.titleLB.isHidden = true
        packageView2.tagView.isHidden = true
        packageView2.rightMarginLine.isHidden = true
        packageView1.snp_makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(self.snp_centerX)
        }
        
        packageView2.snp_makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.snp_centerX)
        }
        
    }
}
