//
//  FKYShoppingMoneyRechargeCollectionContianerView.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShoppingMoneyRechargeCollectionContianerView: UIView {

    /// 选中了某一个充值金额
    static let FKY_selectedRechargeItem = "selectedRechargeItem"

    /// 金额列表滚动了
    static let FKY_itemIsScrolled = "itemIsScrolled"

    /// 数据源
    var dataList: [FKYShoppingMoneyRechargeCellModel] = []

    /// 列表
    lazy var collectionView: UICollectionView = self.creatCollectionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - 数据展示
extension FKYShoppingMoneyRechargeCollectionContianerView {

    func showData(cellList: [FKYShoppingMoneyRechargeCellModel]) {
        self.dataList = cellList
        self.collectionView.reloadData()
    }
}

//MARK: - UICollectionView代理
extension FKYShoppingMoneyRechargeCollectionContianerView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item: FKYShoppingMoneyRechargeItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FKYShoppingMoneyRechargeItemCell.self), for: indexPath) as! FKYShoppingMoneyRechargeItemCell
        let cellModel = self.dataList[indexPath.row]
        item.showData(data: cellModel)
        return item
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellModel = self.dataList[indexPath.row]
        self.routerEvent(withName: FKYShoppingMoneyRechargeCollectionContianerView.FKY_selectedRechargeItem, userInfo: [FKYUserParameterKey: cellModel])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.routerEvent(withName: FKYShoppingMoneyRechargeCollectionContianerView.FKY_itemIsScrolled, userInfo: [FKYUserParameterKey: scrollView.contentOffset.y])
    }
}


//MARK: - UI
extension FKYShoppingMoneyRechargeCollectionContianerView {

    func setupUI() {

        self.addSubview(self.collectionView)

        self.collectionView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }

    func getContentHeight() -> CGFloat {
        self.collectionView.layoutIfNeeded()
        return self.collectionView.contentSize.height
    }
}

//MARK: - 属性对应的生成方法
extension FKYShoppingMoneyRechargeCollectionContianerView {
    func creatCollectionView() -> UICollectionView {
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = WH(24)
        flow.minimumInteritemSpacing = WH(13)
        flow.maximunInteritemSpacing = WH(13)
        flow.scrollDirection = .vertical
        flow.itemSize = CGSize.init(width: WH(152), height: WH(62))
        flow.sectionInset = UIEdgeInsets.init(top: WH(20), left: WH(24), bottom: WH(15), right: WH(24))
        let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flow)
        collection.backgroundColor = RGBColor(0xFFFFFF)
        collection.delegate = self
        collection.dataSource = self
        collection.register(FKYShoppingMoneyRechargeItemCell.self, forCellWithReuseIdentifier: NSStringFromClass(FKYShoppingMoneyRechargeItemCell.self))
        return collection
    }

}

