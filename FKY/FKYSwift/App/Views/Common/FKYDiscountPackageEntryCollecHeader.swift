//
//  FKYDiscountPackageEntryCollecHeader.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/29.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYDiscountPackageEntryCollecHeader: UICollectionReusableView {
    
    ///套餐入口model
    var discountModel:FKYDiscountPackageModel = FKYDiscountPackageModel()
    
    /// 套餐入口按钮
    lazy var discountEntryBtn:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYDiscountPackageEntryCollecHeader.entryBtnClicked), for: .touchUpInside)
        //bt.layer.cornerRadius = WH(8)
        //bt.layer.masksToBounds = true
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 数据显示
extension FKYDiscountPackageEntryCollecHeader{
    func configItem(discountModel:FKYDiscountPackageModel){
        self.discountModel = discountModel
        self.discountEntryBtn.sd_setBackgroundImage(with: URL(string: self.discountModel.imgPath), for: .normal)
    }
}

//MARK: - 事件响应
extension FKYDiscountPackageEntryCollecHeader{
    
    /// 优惠套餐活动入口事件
    @objc func entryBtnClicked(){
        self.routerEvent(withName: FKY_goInDiscountPackage, userInfo: [FKYUserParameterKey:self.discountModel])
    }
}

//MARK: - UI
extension FKYDiscountPackageEntryCollecHeader{
    func setupUI(){
        self.addSubview(self.discountEntryBtn)
        
        self.discountEntryBtn.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
            make.top.equalToSuperview().offset(WH(10))
            make.height.equalTo(176.0*SCREEN_WIDTH/710.0)
        }
    }
    
    static func getHeight() -> CGFloat{
        return 176.0*SCREEN_WIDTH/710.0 + WH(10) + WH(10)// 上下间隔10
    }
}
