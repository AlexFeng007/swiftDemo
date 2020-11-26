//
//  FKYHotSalePageFlowLayout.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  自定义横向滚动的分页FlowLayout...<支持多section，每个section均作为单独的一个page页面，可左右滑动切换>

import UIKit

class FKYHotSalePageFlowLayout: UICollectionViewFlowLayout {
    // MARK: - Property
    
    // 行间距
    var rowSpacing: CGFloat = 0
    
    // 列间距
    var columnSpacing: CGFloat = 0
    
    // CollectionView内边距
    var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    // 行高度...<默认固定高度>
    var rowHeight = HomeConstant.HOME_HOTSALE_CCELL_HEIGHT
    
    // 行宽度...<默人为屏宽>
    var rowWidth = SCREEN_WIDTH
    
    // 所有item的属性数组
    var arrayAttributes = [[UICollectionViewLayoutAttributes]]()

    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        let widthFinal = widthContent * CGFloat(totalSections!)
        return CGSize.init(width: widthFinal, height: heightContent)
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
        widthContent = max(0, widthContent)
        
        let numberX = CGFloat(indexPath.section) * widthContent
        let numberY = CGFloat(indexPath.row) * rowHeight
        
        let attributes = super.layoutAttributesForItem(at: indexPath)
        attributes?.frame = CGRect.init(x: numberX, y: numberY, width: widthContent, height: rowHeight)
        return attributes
    }
}
