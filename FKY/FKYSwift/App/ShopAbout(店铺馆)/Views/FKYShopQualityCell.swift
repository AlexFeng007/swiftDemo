//
//  FKYShopQualityCell.swift
//  FKY
//
//  Created by yyc on 2020/10/23.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopQualityCell: UITableViewCell {
    
    fileprivate lazy var collectionView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: SCREEN_WIDTH/2.0, height: WH(90))
        flowLayout.scrollDirection = .vertical
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(HighQualityShopsItemCell.self, forCellWithReuseIdentifier: "HighQualityShopsItemCell")
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    var shopQualityArr:[HighQualityShopsItemModel]?
    var clickQualityShopBlock:((Int,HighQualityShopsItemModel)->(Void))? //点击优质商家
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
extension FKYShopQualityCell{
    fileprivate func setupView() {
        contentView.backgroundColor = RGBColor(0xf4f4f4)
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(10))
        }
    }
    func configCell(_ arr: [HighQualityShopsItemModel]?) {
        self.shopQualityArr = arr
        self.collectionView.reloadData()
    }
    
    static func getQualityShopListCellHeight(_ arr: [HighQualityShopsItemModel]?) -> CGFloat {
        if let shopArr = arr ,shopArr.count > 0 {
            var lines = shopArr.count/2
            if shopArr.count%2 > 0 {
                lines += 1
            }
            return CGFloat(lines)*WH(90) + WH(10)
        }
        return  WH(0)
    }
    
}
extension FKYShopQualityCell: UICollectionViewDelegate, UICollectionViewDataSource {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let arr = self.shopQualityArr ,arr.count > 0 {
            return arr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HighQualityShopsItemCell", for: indexPath) as! HighQualityShopsItemCell
        if let arr = self.shopQualityArr ,arr.count > 0 ,indexPath.item < arr.count{
            cell.config(model: arr[indexPath.item])
        }
        return cell
    }
    
    //选中item会触发的方法  豆腐块广告 点击埋点
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let arr = self.shopQualityArr ,arr.count > 0 ,indexPath.item < arr.count{
            if let block = self.clickQualityShopBlock {
                block(indexPath.item,arr[indexPath.item])
            }
        }
    }
}
