//
//  FKYRecommendPageView.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/9.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  (首页)首推特价（药城精选）之商品分页列表视图

import UIKit

class FKYRecommendPageView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    // MARK: - Property
    
    // closure
    var productDetailCallback: ((Int, Any?)->())?   // 查看商品详情
    var updateProductIndexCallback: ((Int)->())?    // 更新当前itemindex
    
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
    
    fileprivate lazy var collectionView: UICollectionView! = {
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.recommendLayout)
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.dataSource = self
        view.isPagingEnabled = true
        view.isUserInteractionEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.register(FKYRecommendProductCCell.self, forCellWithReuseIdentifier: "FKYRecommendProductCCell")
        return view
    }()
    
    fileprivate lazy var pageControl: FKYPageControl! = {
        let view = FKYPageControl.init(frame: CGRect.zero)
        view.numberOfPages = self.pageNumber
        view.currentPage = 0
        view.hidesForSinglePage = true
        view.currentPageIndicatorTintColor = RGBColor(0xC2C2C2)
        view.pageIndicatorTintColor = RGBColor(0xEDEDED)
        view.replaceDot = true // 使用图片替代默认小圆点...<若替换失败，则继续使用小圆点>
        view.setImageToReplaceDot(color: RGBColor(0xEDEDED), currentColor: RGBColor(0xC2C2C2), size: CGSize.init(width: view.dotWidth, height: view.dotHeight))
        return view
    }()
    
    // 每页行数
    var rowNumber = 2
    // 每行单元格item个数（列数）
    var columnNumber = 3
    
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
            
//            let currentIndexpath = collectionView.indexPathsForVisibleItems.first
//            if let indexpath = currentIndexpath {
//                let count = rowNumber * columnNumber
//                return indexpath.item / count
//            }
//            return 0
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
            // 必须有图片，且item个数超过一页
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
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = UIColor.clear
        
        addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.equalTo(self).offset(j1)
            make.right.equalTo(self).offset(-j1)
            make.height.equalTo(WH(27))
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(pageControl.snp.top)
        }
        
        bringSubviewToFront(pageControl)
    }
    
    
    // MARK: - Private
    
    // 显示图片内容
    fileprivate func showListContent() {
        if productDataSource.count > 6 {
            //有两页才显示pageControl
            pageControl.snp.updateConstraints { (make) in
                make.height.equalTo(WH(27))
            }
        } else {
            pageControl.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }
        recommendLayout.setRowCountAndColumnCount(self.rowNumber, self.columnNumber)
        collectionView.reloadData()
        pageControl.numberOfPages = pageNumber
        
        // 必须有商品
        guard productDataSource.count > 0 else {
            return
        }

        // 滑动到(初始)指定位置
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.itemIndex >= self.productDataSource.count {
                self.itemIndex = 0
            }
            self.pageControl.currentPage = self.itemIndex / (self.rowNumber * self.columnNumber)
            self.collectionView.scrollToItem(at: IndexPath.init(row: self.itemIndex, section: self.currentTotalSection / 2), at: .left, animated: false)
//        }
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
        //print("autoScrollAction")
        
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
        
        pageControl.currentPage = currentPageIndex
        itemIndex = currentPageIndex * (rowNumber * columnNumber)
    }
    
    
    // MARK: - UIScrollViewDelegate
    
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
    
    
    // MARK: - UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentTotalSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDataSource.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: SCREEN_WIDTH / 3, height: WH(150))
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYRecommendProductCCell", for: indexPath) as! FKYRecommendProductCCell
        cell.configCell(productDataSource[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let closure = productDetailCallback {
            closure(indexPath.item, productDataSource[indexPath.item])
        }
    }
}
