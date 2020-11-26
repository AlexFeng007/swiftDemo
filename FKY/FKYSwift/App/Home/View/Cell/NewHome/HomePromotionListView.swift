//
//  HomePromotionListView.swift
//  FKY
//
//  Created by hui on 2019/7/3.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class HomePromotionListView: UIView {
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
        view.register(HomePrdouctItmeViewCell.self, forCellWithReuseIdentifier: "HomePrdouctItmeListViewCell")
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
    var productDetailCallback: ((Int, HomeRecommendProductItemModel?)->())?   // 查看商品详情
    var updateProductIndexCallback: ((Int)->())?    // 更新当前itemindex
    // 每页行数
    var rowNumber = 2
    // 每行单元格item个数（列数）
    var columnNumber = 3
    var killModel : HomeSecdKillProductModel? //数据源
    // 数据源
    var productDataSource = [HomeRecommendProductItemModel]() {
        didSet {
            showListContent()
            autoScrollLogic()
        }
    }
    
    // 当前item索引
    var itemIndex = 0
    
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
    fileprivate var currentPageIndex: Int {
        get {
            guard productDataSource.count > 0 else {
                return 0
            }
            
            var index: Int = Int( (collectionView.contentOffset.x + SCREEN_WIDTH * 0.5) / SCREEN_WIDTH )
            index = index % pageNumber
            return max(0, index)
        }
    }
    
    // 是否自动滑动
    var autoScroll = false
    
    // 自动滑动间隔时间...<默认3s>
    var autoScrollTimeInterval: TimeInterval = 3
    
    // 是否无限轮播
    var infiniteLoop = false
    
    // 分区section大小...<默认3个分区>
    var maxSecitons = 3
    
    // 轮播定时器
    fileprivate var timer: Timer!
    
    // 判断是否需要使用多分区特性，以便用于无限轮播...<若无限轮播属性关闭，则不使用多分区>
    var needToSetMultiSections: Bool {
        get {
            // 必须有商品，且item个数超过一页
            guard productDataSource.count > 0, productDataSource.count > rowNumber * columnNumber else {
                return false
            }
            // 必须开启自动滑动
            guard autoScroll else {
                return false
            }
            // 必须开启无限轮播
            guard infiniteLoop else {
                return false
            }
            return true
        }
    }
    
    // 当前状态下的分区个数
    var currentTotalSection: Int {
        get {
            if needToSetMultiSections {
                return maxSecitons
            }
            return 1
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
extension HomePromotionListView {
    // 显示图片内容
    fileprivate func showListContent() {
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
        pageControl.pages = pageNumber
        pageControl.setPageDotsView()
        
        // 滑动到(初始)指定位置
        if self.itemIndex >= self.productDataSource.count {
            self.itemIndex = 0
        }
        pageControl.setCurrectPage(self.itemIndex / (self.rowNumber * self.columnNumber))
        
        self.collectionView.scrollToItem(at: IndexPath.init(row: self.itemIndex, section: self.currentTotalSection / 2), at: .left, animated: false)
    }
    
    // 轮播相关
    fileprivate func autoScrollLogic() {
        // 取消timer
        stopAutoScroll()
        
        // 自动滑动属性必须开启，且图片个数必须大于0(item超过1页)
        guard autoScroll == true, productDataSource.count > 0, productDataSource.count > rowNumber * columnNumber else {
            return
        }
        
        // 启动timer
        beginAutoScroll()
    }
    
    // 开始轮播
    fileprivate func beginAutoScroll() {
        // 取消timer
        stopAutoScroll()
        // 启动timer
        timer = Timer.init(timeInterval: autoScrollTimeInterval, target: self, selector: #selector(autoScrollAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    // 停止轮播
    fileprivate func stopAutoScroll() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    // 定时器方法
    @objc fileprivate func autoScrollAction() {
        print("autoScrollAction")
        
        // 有多分区属性
        if needToSetMultiSections {
            scrollKeyMethod()
        }
        
        // 计算indexpath
        var nextPage = currentPageIndex + 1
        var nextSection = currentTotalSection / 2
        if nextPage >= pageNumber {
            nextPage = 0
            nextSection = nextSection + 1
            if nextSection >= currentTotalSection {
                nextSection = currentTotalSection / 2
            }
        }
        // item索引
        itemIndex = nextPage * (rowNumber * columnNumber)
        // 滑动到指定索引的图片处
        collectionView.scrollToItem(at: IndexPath.init(row: itemIndex, section: nextSection), at: .left, animated: true)
    }
    
    // 每次 (自动)滑动 or (手动)拖动 结束后均需要执行此方法
    fileprivate func scrollKeyMethod() {
        // 有多分区属性
        if needToSetMultiSections {
            collectionView.scrollToItem(at: IndexPath.init(row: itemIndex, section: currentTotalSection / 2), at: .left, animated: false)
        }
    }
    
    // 实时展示当前图片索引
    fileprivate func showPageIndex() {
        // 必须有商品
        guard productDataSource.count > 0 else {
            return
        }
        pageControl.setCurrectPage(currentPageIndex)
        itemIndex = currentPageIndex * (rowNumber * columnNumber)
    }
    
}


// MARK: - UIScrollViewDelegate
extension HomePromotionListView: UIScrollViewDelegate {
    // 已开始滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        showPageIndex()
    }
    
    // 定时器方法滑动结束后调用此方法
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        showPageIndex()
        scrollKeyMethod()
        
        if let closure = updateProductIndexCallback {
            closure(itemIndex)
        }
    }
    
    // 用户手动滑动结束后调用此方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        showPageIndex()
        scrollKeyMethod()
        if let closure = updateProductIndexCallback {
            closure(itemIndex)
        }
    }
    
    // 用户手动滑动开始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if autoScroll == true, productDataSource.count > 0, productDataSource.count > rowNumber & columnNumber {
            stopAutoScroll()
        }
    }
    
    // 用户手动滑动结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoScroll == true, productDataSource.count > 0, productDataSource.count > rowNumber & columnNumber {
            beginAutoScroll()
        }
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension HomePromotionListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentTotalSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //商品
        return CGSize(width:HOME_PROMOTION_THREE_W, height:HOME_PROMOTION_H)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePrdouctItmeListViewCell", for: indexPath) as! HomePrdouctItmeViewCell
        cell.configCell(productDataSource[indexPath.item],self.killModel,.HomeCellTypeOther)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let closure = productDetailCallback {
            closure(indexPath.item, productDataSource[indexPath.item])
        }
    }
}

