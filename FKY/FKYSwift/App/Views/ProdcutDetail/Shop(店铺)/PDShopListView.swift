//
//  PDShopListView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/6/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class PDShopListView: UIView {
    // MARK: - Property
    
    // closure
    var productDetailClosure: ((Int, FKYProductItemModel?)->())?   // 查看商品详情
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        // 设置滚动的方向
        flowLayout.scrollDirection = .horizontal
        // 设置item的大小
        flowLayout.itemSize = CGSize(width: (SCREEN_WIDTH - WH(40)) / 3, height: WH(160))
        // 设置同一组当中，行与行之间的最小行间距
        flowLayout.minimumLineSpacing = WH(0)
        // 设置同一行的cell中互相之间的最小间隔
        flowLayout.minimumInteritemSpacing = WH(0)
        // 设置section距离边距的距离
        flowLayout.sectionInset = UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
        
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.isScrollEnabled = true
        view.isUserInteractionEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.register(PDRecommendItemCCell.self, forCellWithReuseIdentifier: "PDRecommendItemCCell")
        return view
    }()
    
    // 数据源
    var productList = [FKYProductItemModel]() {
        didSet {
            // 刷新
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.invalidateIntrinsicContentSize()
            collectionView.reloadData()
//            if productList.count > 0 {
//                // 有数据
//                if collectionView.superview == nil {
//                    addSubview(collectionView)
//                    collectionView.snp.makeConstraints { (make) in
//                        make.edges.equalTo(self).inset(UIEdgeInsets(top: WH(2), left: WH(0), bottom: WH(2), right: WH(0)))
//                    }
//                }
//                if #available(iOS 11.0, *) {
//                    collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
//                } else {
//                    // Fallback on earlier versions
//                }
//                collectionView.isHidden = false
//                collectionView.collectionViewLayout.invalidateLayout()
//                collectionView.invalidateIntrinsicContentSize()
//                collectionView.reloadData()
//            }
//            else {
//                // 无数据
//                if collectionView.superview != nil {
//                    collectionView.removeFromSuperview()
//                }
//                collectionView.isHidden = true
//            }
        }
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = UIColor.clear
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets.zero)
        }
        collectionView.reloadData()
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        collectionView.collectionViewLayout.invalidateLayout()
//        collectionView.reloadData()
//    }
}


// MARK: - Private
extension PDShopListView {
    
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PDShopListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (SCREEN_WIDTH - WH(40)) / 3, height: WH(160))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return WH(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PDRecommendItemCCell", for: indexPath) as! PDRecommendItemCCell
        cell.configCell(productList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let block = productDetailClosure else {
            return
        }
        block(indexPath.item, productList[indexPath.row])
    }
}
