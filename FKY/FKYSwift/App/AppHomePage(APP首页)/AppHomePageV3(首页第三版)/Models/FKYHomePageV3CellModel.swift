//
//  FKYHomePageV3CellModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePageV3CellModel: NSObject {
    enum CellType {
        /// 无意义默认值
        case notSet
        /// 轮播图cell
        case bannerCell
        /// tab切换cell
        case switchTabCell
        /// 导航cell
        case naviCell
        /// 单行广告栏
        case singleAdCell
        /// 一行一个系统推荐
        case singleSysRecommend
        /// 一行两个系统推荐
        case doubleSysRecommend
        /// 一行3个系统推荐
        case threeSysRecommend
        /// 一行两个套餐
        case twoPackage
        /// 一行两个不同模块
        case twoDifferentModule
        /// 常搜词
        case hotSearchKeyWord
    }
    
    enum CellDisplayType {
        /// 无意义默认值
        case notSet
        /// 有背景图时候的样式
        case haveBackImageType
        /// 正常的时候的样式
        case normalType
    }
    
    var cellType:CellType = .notSet
    var cellDisplayType:CellDisplayType = .notSet
    var cellModel:FKYHomePageV3FloorModel = FKYHomePageV3FloorModel()
    var itemModel:FKYHomePageV3ItemModel = FKYHomePageV3ItemModel()
    /// 常搜词列表
    var hotSearchKeyWordList:[String] = [String]()
    
    /// 常搜词显示类型
    var hotSearchKeyWordDisplayType:Int = 1
    
    /// 常搜词背景色
    var hotSearchKeyWordBgColor:UIColor = RGBColor(0xFFFFFF)
    /// 上方的切换头部视图List
    var switchTabHeaderData:[FKYHomePageV3SwitchTabModel] = [FKYHomePageV3SwitchTabModel]()
    /// 下方4个tab的list
    var flowTabModelList:[FKYHomePageV3FlowTabModel] = [FKYHomePageV3FlowTabModel]()
    
    /// 当前展示的第几个tab tab切换cell专用的属性
    var currentDisplayIndex:Int = 0
    
    /// 此楼层是否需要上方的左右两个圆角
    var isNeedTopCorner:Bool = true
    /// 此楼层是否需要下方的左右两个圆角
    var isNeedBottomCorner:Bool = true
    /// 切换视图的cell高度
    //var switchCellHeight:CGFloat = WH(450)
    var switchCellHeight:CGFloat = WH(0)
}
