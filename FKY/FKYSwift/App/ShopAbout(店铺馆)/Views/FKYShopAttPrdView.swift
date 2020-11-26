//
//  FKYShopAttPrdView.swift
//  FKY
//
//  Created by yyc on 2020/11/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopAttPrdView: UIView {
    // MARK: - UI属性
    fileprivate lazy var recommendLayout: FKYHorizontalPageFlowLayout = {
        let layout = FKYHorizontalPageFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.rowCount = self.rowNumber
        layout.itemCountPerRow = self.columnNumber
        layout.rowSpacing = 0
        layout.columnSpacing = 0
        layout.edgeInsets = UIEdgeInsets.zero
        return layout
    }()
    //商品列表
    fileprivate lazy var collectionView: UICollectionView = {
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.recommendLayout)
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.dataSource = self
        view.isPagingEnabled = true
        view.isUserInteractionEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.register(HomePrdouctItmeViewCell.self, forCellWithReuseIdentifier: "HomePrdouctItmeViewCell")
        return view
    }()
    //显示当前页
    fileprivate lazy var pageControl: NewCirclePageControl = {
        let view = NewCirclePageControl.init(frame: CGRect.zero)
        view.currentPageColor = RGBColor(0xFF2D5C)
        view.normalPageColor = RGBColor(0xECE6E7)
        view.dotNomalSize = CGSize(width:WH(6),height:WH(3))
        view.dotBigSize = CGSize(width:WH(14),height:WH(3))
        return view
    }()
    
    // MARK: - Property
    
    // closure
    var productDetailCallback: ((Int, Any?)->())?   // 查看商品详情
    // 每页行数
    var rowNumber = 2
    // 每行单元格item个数（列数）
    var columnNumber = 3
    // 数据源
    var productDataSource = [Any]() {
        didSet {
            showListContent()
        }
    }
    
    // 总页数
    fileprivate var pageNumber: Int {
        get {
            guard productDataSource.count > 0 else {
                return 0
            }
            
            let count = rowNumber * columnNumber
            let page = productDataSource.count / count
            let remain = productDataSource.count % count
            return remain > 0 ? page + 1 : page
        }
    }
    
    // 当前页索引
    fileprivate var currentPageIndex = 0
    
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
        
        addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-WH(7))
            make.centerX.equalTo(self)
            make.height.equalTo(WH(3))
            make.width.equalTo(WH(0))
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(pageControl.snp.top).offset(-WH(10))
        }
    }


}
// MARK: - Private
extension FKYShopAttPrdView {
    // 显示图片内容
    fileprivate func showListContent() {
        pageControl.isHidden = true
        // 必须有商品
        guard productDataSource.count > 0 else {
            return
        }
        // pageControl高度设置
        if productDataSource.count > 6 {
            let pageControl_w = WH(CGFloat((pageNumber-1)*11)) +  pageControl.dotBigSize.width
            // 多页
            pageControl.snp.updateConstraints { (make) in
                make.height.equalTo(WH(3))
                make.bottom.equalTo(self).offset(-WH(7))
                make.width.equalTo(pageControl_w)
            }
            collectionView.snp.updateConstraints { (make) in
                make.bottom.equalTo(pageControl.snp.top).offset(-WH(10))
            }
            pageControl.pages = pageNumber
            pageControl.setPageDotsView()
            pageControl.isHidden = false
        }
        else {
            // 单页
            pageControl.isHidden = true
            pageControl.snp.updateConstraints { (make) in
                make.height.equalTo(0)
                make.bottom.equalTo(self).offset(-WH(0))
                make.width.equalTo(0)
            }
            collectionView.snp.updateConstraints { (make) in
                make.bottom.equalTo(pageControl.snp.top).offset(-WH(0))
            }
        }
        recommendLayout.setRowCountAndColumnCount(self.rowNumber, self.columnNumber)
        collectionView.reloadData()
        currentPageIndex = 0
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
}

// MARK: - UIScrollViewDelegate
extension FKYShopAttPrdView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(scrollView.contentOffset.x / pageWidth)
        currentPageIndex = page
        pageControl.setCurrectPage(currentPageIndex)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension FKYShopAttPrdView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //商品
        return CGSize(width:HOME_PROMOTION_THREE_W, height:HOME_PROMOTION_H)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePrdouctItmeViewCell", for: indexPath) as! HomePrdouctItmeViewCell
        if let prdModel = productDataSource[indexPath.item] as? FKYSpecialPriceModel{
            cell.configShopAttentionProductCell(prdModel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let closure = productDetailCallback {
            closure(indexPath.item, productDataSource[indexPath.item])
        }
    }
}
