//
//  FKYShoppingMoneyRechargeItemCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShoppingMoneyRechargeItemCell: UICollectionViewCell {

    /// 单独封装的内容View
    lazy var itemView: FKYShoppingMoneyRechargeItemView = FKYShoppingMoneyRechargeItemView()

    /// 数据
    var cellData: FKYShoppingMoneyRechargeCellModel = FKYShoppingMoneyRechargeCellModel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - 数据展示
extension FKYShoppingMoneyRechargeItemCell {

    func showData(data: FKYShoppingMoneyRechargeCellModel) {
        self.cellData = data
        self.itemView.showData(data: self.cellData)
    }
}

//MARK: - UI
extension FKYShoppingMoneyRechargeItemCell {
    func setupUI() {
        self.contentView.addSubview(self.itemView)

        self.itemView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}
