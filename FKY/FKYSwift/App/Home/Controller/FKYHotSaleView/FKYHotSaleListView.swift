//
//  FKYHotSaleListView.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/11.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  (首页)热销商品之商品列表视图

import UIKit

class FKYHotSaleListView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    // MARK: - Property
    
    // closure
    var productDetailCallback: ((Int, Int, Any?)->())?  // 查看商品详情
    var scrollTypeCallback: ((Int, Bool)->())?          // 切换类型
    
    fileprivate lazy var collectionView: UICollectionView! = {
        let layout = FKYHotSalePageFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.rowSpacing = 0
        layout.columnSpacing = 0
        layout.edgeInsets = UIEdgeInsets.zero
        layout.rowHeight = HomeConstant.HOME_HOTSALE_CCELL_HEIGHT
        layout.rowWidth = SCREEN_WIDTH
        
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.dataSource = self
        view.isScrollEnabled = true
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = true
        view.register(FKYHotSaleProductCCell.self, forCellWithReuseIdentifier: "FKYHotSaleProductCCell")
        return view
    }()
    
    // 数据源
    var productDataSource = [HomeHotSaleTypeItemModel]() {
        didSet {
            //showListContent()
        }
    }
    
    // 类型索引（pageindex）
    var typeIndex = 0
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = UIColor.white
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }

    
    // MARK: - Public
    
    // 获取内容高度
//    func getContentHeight() -> CGFloat {
//        collectionView.reloadData()
//        return collectionView.collectionViewLayout.collectionViewContentSize.height
//    }
    
    // 更新页索引...<展示指定索引处的类型商品列表>
    func updatePageIndex(_ index: Int) {
        typeIndex = index
        scrollToPageIndex(true)
    }
    
    // 展示数据
    func configData(_ arrProduct: [HomeHotSaleTypeItemModel], _ index: Int, _ showReload: Bool) {
        guard arrProduct.count > 0 else {
            typeIndex = 0
            productDataSource = [HomeHotSaleTypeItemModel]()
            collectionView.reloadData()
            return
        }
        
        typeIndex = (index >= arrProduct.count ? 0 : index)
        productDataSource = arrProduct
        
//        if showReload {
//            self.collectionView.reloadData()
//        }
        
        self.collectionView.reloadData()
        self.scrollToPageIndex(false)
    }
    
    
    // MARK: - Private
    
    // 显示商品内容列表
    fileprivate func showListContent() {
        // 每次cell展示时都执行一次collectionView.reloadData，导致滑动卡顿
        //collectionView.reloadData()
        scrollToPageIndex(false)
    }
    
    // 滑动到指定pageindex
    fileprivate func scrollToPageIndex(_ animation: Bool) {
        guard productDataSource.count > 0 else {
            return
        }
        
        if typeIndex >= productDataSource.count {
            typeIndex = 0
        }
        collectionView.scrollToItem(at: IndexPath.init(row: 0, section: typeIndex), at: .left, animated: animation)
    }
    
    // 获取当前typeindex
    fileprivate func getCurrentTypeIndex() -> Int {
        let itemWidth = SCREEN_WIDTH
        var index: Int = Int( (collectionView.contentOffset.x + itemWidth * 0.5) / itemWidth )
        if productDataSource.count > 0  {
            index = index % productDataSource.count
        }
        return max(0, index)
    }
    
    // 判断当前typeindex是否有改变
    fileprivate func needToUpdateTypeIndex() -> Bool {
        return (typeIndex == getCurrentTypeIndex() ? false : true)
    }
    
    // 判断切换类型后，当前类型下的商品个数与之前类型下的商品个数是否相同
    // 若不相同，则需要更新cell高度
    fileprivate func needToUpdateCellHeight() -> Bool {
        // 当前typeindex
        let index = getCurrentTypeIndex()
        // 判断
        let itemBefore = productDataSource[typeIndex]
        let itemCurrent = productDataSource[index]
        var countBefore = 0
        var countCurrent = 0
        if let list = itemBefore.catagoryList, list.count > 0 {
            countBefore = list.count
        }
        if let list = itemCurrent.catagoryList, list.count > 0 {
            countCurrent = list.count
        }
        return (countBefore == countCurrent ? false : true)
    }
    
    // 更新pageindex
    fileprivate func updateTypeIndex() {
        guard needToUpdateTypeIndex() else {
            return
        }
        
        // 判断是否需要更新cell高度
        let needUpdateHeight = needToUpdateCellHeight()
        // 更新typeIndex
        typeIndex = getCurrentTypeIndex()
        
        if let closure = scrollTypeCallback {
            closure(typeIndex, needUpdateHeight)
        }
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return productDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let totalItems: HomeHotSaleTypeItemModel = productDataSource[section]
        if let list = totalItems.catagoryList, list.count > 0 {
            return list.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: HomeConstant.HOME_HOTSALE_CCELL_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYHotSaleProductCCell", for: indexPath) as! FKYHotSaleProductCCell
        
        let totalItems: HomeHotSaleTypeItemModel = productDataSource[indexPath.section]
        if let list = totalItems.catagoryList, list.count > 0 {
            let item = list[indexPath.row]
            cell.configCell(item)
            cell.viewLine.isHidden = (indexPath.row == list.count - 1 ? true : false)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let totalItems = productDataSource[indexPath.section]
        if let list = totalItems.catagoryList, list.count > 0 {
            let item = list[indexPath.row]
            if let closure = productDetailCallback {
                closure(indexPath.section, indexPath.row, item)
            }
        }
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    // 用户手动滑动结束后调用此方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateTypeIndex()
    }
}
