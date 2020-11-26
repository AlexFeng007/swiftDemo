//
//  FKYHorizontalPageFlowLayout.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/10.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  自定义横向滚动的分页FlowLayout...<目前只支持1个section的情况；若后期需要多section，需对应的修改布局代码>
//  [Change] 新增支持多section特性 XiaZhiyong 2018.03.08

import UIKit

class FKYHorizontalPageFlowLayout: UICollectionViewFlowLayout {
    // MARK: - Property
    
    // 行间距
    var rowSpacing: CGFloat = 0
    
    // 列间距
    var columnSpacing: CGFloat = 0
    
    // CollectionView内边距
    var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    // 行数
    var rowCount: Int = 2
    
    // 列数...<每行item个数>
    var itemCountPerRow: Int = 3
    
    // 所有item的属性数组
    //var arrayAttributes = [UICollectionViewLayoutAttributes]()      // 仅支持单个section
    var arrayAttributes = [[UICollectionViewLayoutAttributes]]()    // 支持多个section
    
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public
    
    func setRowCountAndColumnCount(_ row: Int, _ column: Int) {
        rowCount = row
        itemCountPerRow = column
    }
    
    
    // MARK: - Override
    
    // 布局前的一些准备工作
    override func prepare() {
        super.prepare()
        
        // 先清空
        arrayAttributes.removeAll()
        
        // 当前CollectionView中包含的所有section个数
        let totalSections = collectionView?.numberOfSections
        guard totalSections != nil, totalSections! > 0 else {
            return
        }
        
        // 保存
        for section in 0 ..< totalSections! {
            // 当前section的布局数组
            var arrTemp = [UICollectionViewLayoutAttributes]()
            // 当前section中包含的所有item个数
            let totalItems = collectionView?.numberOfItems(inSection: section)
            //
            if totalItems != nil, totalItems! > 0 {
                // 当前section有数据
                for index in 0 ..< totalItems! {
                    let indexPath = IndexPath.init(item: index, section: section)
                    let attributes = layoutAttributesForItem(at: indexPath)
                    arrTemp.append(attributes!)
                } // for
                arrayAttributes.append(arrTemp)
            }
            else {
                // 当前section无数据
                arrayAttributes.append(arrTemp)
            }
        } // for
    }
    
    // 内容区域总大小(不仅仅是可见区域)...<CollectionView的滚动范围>
    override var collectionViewContentSize: CGSize {
        var widthContent = (collectionView?.frame.size.width)! - edgeInsets.left - edgeInsets.right
        var heightContent = (collectionView?.frame.size.height)! - edgeInsets.top - edgeInsets.bottom
        widthContent = max(0, widthContent)
        heightContent = max(0, heightContent)
        
        // 当前CollectionView中的section个数
        let totalSections = collectionView?.numberOfSections
        guard totalSections != nil, totalSections! > 0 else {
            return CGSize.init(width: widthContent, height: heightContent)
        }
        
        var totalWidth: CGFloat = 0.0
        for index in 0..<totalSections! {
            let width = getContentWidthForCurrentSection(index)
            totalWidth += width
        }
        return CGSize.init(width: totalWidth, height: heightContent)
    }
    
    // 所有单元格item的位置属性...<返回CollectionView视图中所有单元格的属性数组>
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var arrFinal = [UICollectionViewLayoutAttributes]()
        for index in 0 ..< arrayAttributes.count {
            let arrTemp = arrayAttributes[index]
            arrFinal.append(contentsOf: arrTemp)
        }
        return arrFinal
    }
    
    // 每个单元格item的位置和大小...<设置每个item的属性(主要是frame)>
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var widthContent = (collectionView?.frame.size.width)! - edgeInsets.left - edgeInsets.right
        var heightContent = (collectionView?.frame.size.height)! - edgeInsets.top - edgeInsets.bottom
        widthContent = max(0, widthContent)
        heightContent = max(0, heightContent)
        
        // 行
        if rowCount == 0 {
            rowCount = 1
        }
        // 列
        if itemCountPerRow == 0 {
            itemCountPerRow = 1
        }
        
        let itemWidth = (widthContent - CGFloat(itemCountPerRow - 1) * columnSpacing) / CGFloat(itemCountPerRow)
        let itemHeight = (heightContent - CGFloat(rowCount - 1) * rowSpacing) / CGFloat(rowCount)
        
        // 每页item个数
        let itemNumberInPage = rowCount * itemCountPerRow
        // 当前item的索引
        let itemIndex = indexPath.item
        // 当前item所处的页索引
        let pageIndex = itemIndex / itemNumberInPage
        // 当前item在当前页中所处的索引
        let remainNumber = itemIndex - pageIndex * (itemNumberInPage)
        // 计算当前item在当前页中的x与y索引
        let indexX = remainNumber % itemCountPerRow
        let indexY = remainNumber / itemCountPerRow
        
        // 当前item的x
        var numberX: CGFloat = 0
        // 当前item的y
        var numberY: CGFloat = 0
        //  每页内容宽度
        let pageWidth = itemWidth * CGFloat(itemCountPerRow) + CGFloat(itemCountPerRow - 1) * columnSpacing + edgeInsets.left + edgeInsets.right
        
        numberX = pageWidth * CGFloat(pageIndex) + (itemWidth + columnSpacing) * CGFloat(indexX) + edgeInsets.left
        numberY = (itemHeight + rowSpacing) * CGFloat(indexY) + edgeInsets.top
        
        // 当前section之前的所有section内容宽度之和
        var widthBefore: CGFloat = 0.0
        let sectionCurrent = indexPath.section
        for index in 0..<sectionCurrent {
            widthBefore += getContentWidthForCurrentSection(index)
        }
        
        let attributes = super.layoutAttributesForItem(at: indexPath)
        attributes?.frame = CGRect.init(x: numberX + widthBefore, y: numberY, width: itemWidth, height: itemHeight)
        return attributes
    }
    
    // 以上为多section
    /********************************************************/
    // 以下为单section
    
    /*
    // 布局前的一些准备工作
    override func prepare() {
        super.prepare()
        
        // 当前CollectionView中的section个数
        let totalSections = collectionView?.numberOfSections
        guard totalSections != nil, totalSections! > 0 else {
            arrayAttributes.removeAll()
            return
        }
        
        // 当前CollectionView中的item个数...<默认仅一个section>
        let totalItems = collectionView?.numberOfItems(inSection: 0)
        guard totalItems != nil, totalItems! > 0 else {
            arrayAttributes.removeAll()
            return
        }
        
        for index in 0 ..< totalItems!  {
            let indexPath = IndexPath.init(item: index, section: 0)
            let attributes = layoutAttributesForItem(at: indexPath)
            arrayAttributes.append(attributes!)
        }
    }
    
    // 内容区域总大小(不仅仅是可见区域)...<CollectionView的滚动范围>
    override var collectionViewContentSize: CGSize {
        var widthContent = (collectionView?.frame.size.width)! - edgeInsets.left - edgeInsets.right
        var heightContent = (collectionView?.frame.size.height)! - edgeInsets.top - edgeInsets.bottom
        widthContent = max(0, widthContent)
        heightContent = max(0, heightContent)

        // 当前CollectionView中的section个数
        let totalSections = collectionView?.numberOfSections
        guard totalSections != nil, totalSections! > 0 else {
            return CGSize.init(width: widthContent, height: heightContent)
        }

        // 当前CollectionView中的item个数...<默认仅一个section>
        let totalItems = collectionView?.numberOfItems(inSection: 0)
        guard totalItems != nil, totalItems! > 0 else {
            return CGSize.init(width: widthContent, height: heightContent)
        }

        // 行
        if rowCount == 0 {
            rowCount = 1
        }
        // 列
        if itemCountPerRow == 0 {
            itemCountPerRow = 1
        }

        // item宽度
        let itemWidth = (widthContent - columnSpacing * CGFloat(itemCountPerRow - 1)) / CGFloat(itemCountPerRow)

        // (理论上)每页的item个数
        let numbersPerPage = rowCount * itemCountPerRow
        // 除数（用于判断页数）
        var pageNumber = totalItems! / numbersPerPage
        // 余数（用于确定最后一页展示的item个数）
        let remain = totalItems! % numbersPerPage

        if totalItems! <= numbersPerPage {
            // item总数不足一页 or 刚好一页
            pageNumber = 1
        }
        else {
            // item总数超过一页
            if remain > 0 {
                pageNumber = pageNumber + 1
            }
        }

        let widthPage = CGFloat(itemCountPerRow) * itemWidth + CGFloat(itemCountPerRow - 1) * columnSpacing
        return CGSize.init(width: widthPage * CGFloat(pageNumber), height: heightContent)
    }
    
    // 所有单元格item的位置属性...<返回CollectionView视图中所有单元格的属性数组>
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return arrayAttributes
    }
    
    // 每个单元格item的位置和大小...<设置每个item的属性(主要是frame)>
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var widthContent = (collectionView?.frame.size.width)! - edgeInsets.left - edgeInsets.right
        var heightContent = (collectionView?.frame.size.height)! - edgeInsets.top - edgeInsets.bottom
        widthContent = max(0, widthContent)
        heightContent = max(0, heightContent)
        
        // 行
        if rowCount == 0 {
            rowCount = 1
        }
        // 列
        if itemCountPerRow == 0 {
            itemCountPerRow = 1
        }
        
        let itemWidth = (widthContent - CGFloat(itemCountPerRow - 1) * columnSpacing) / CGFloat(itemCountPerRow)
        let itemHeight = (heightContent - CGFloat(rowCount - 1) * rowSpacing) / CGFloat(rowCount)
        
        // 每页item个数
        let itemNumberInPage = rowCount * itemCountPerRow
        // 当前item的索引
        let itemIndex = indexPath.item
        // 当前item所处的页索引
        let pageIndex = itemIndex / itemNumberInPage
        // 当前item在当前页中所处的索引
        let remainNumber = itemIndex - pageIndex * (itemNumberInPage)
        // 计算当前item在当前页中的x与y索引
        let indexX = remainNumber % itemCountPerRow
        let indexY = remainNumber / itemCountPerRow
        
        // 当前item的x
        var numberX: CGFloat = 0
        // 当前item的y
        var numberY: CGFloat = 0
        //  每页内容宽度
        let pageWidth = itemWidth * CGFloat(itemCountPerRow) + CGFloat(itemCountPerRow - 1) * columnSpacing
        
        numberX = pageWidth * CGFloat(pageIndex) + (itemWidth + columnSpacing) * CGFloat(indexX)
        numberY = (itemHeight + rowSpacing) * CGFloat(indexY)
        
        let attributes = super.layoutAttributesForItem(at: indexPath)
        attributes?.frame = CGRect.init(x: numberX, y: numberY, width: itemWidth, height: itemHeight)
        return attributes
    }
    */
}

// MARK: Multi Sections
extension FKYHorizontalPageFlowLayout {
    // 获取指定section的内容宽度
    fileprivate func getContentWidthForCurrentSection(_ section: Int) -> CGFloat {
        var widthContent = (collectionView?.frame.size.width)! - edgeInsets.left - edgeInsets.right
        widthContent = max(0, widthContent)
        
        // 当前section中的item个数
        let totalItems = collectionView?.numberOfItems(inSection: section)
        guard totalItems != nil, totalItems! > 0 else {
            return widthContent
        }
        
        // 行
        if rowCount == 0 {
            rowCount = 1
        }
        // 列
        if itemCountPerRow == 0 {
            itemCountPerRow = 1
        }
        
        // item宽度
        let itemWidth = (widthContent - columnSpacing * CGFloat(itemCountPerRow - 1)) / CGFloat(itemCountPerRow)
        
        // (理论上)每页的item个数
        let numbersPerPage = rowCount * itemCountPerRow
        // 除数（用于判断页数）
        var pageNumber = totalItems! / numbersPerPage
        // 余数（用于确定最后一页展示的item个数）
        let remain = totalItems! % numbersPerPage
        
        if totalItems! <= numbersPerPage {
            // item总数不足一页 or 刚好一页
            pageNumber = 1
        }
        else {
            // item总数超过一页
            if remain > 0 {
                pageNumber = pageNumber + 1
            }
        }
        
        let widthPage = CGFloat(itemCountPerRow) * itemWidth + CGFloat(itemCountPerRow - 1) * columnSpacing + edgeInsets.left + edgeInsets.right
        return widthPage * CGFloat(pageNumber)
    }
}

