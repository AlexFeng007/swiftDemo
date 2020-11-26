//
//  HomeCellViewModel.swift
//  FKY
//
//  Created by 寒山 on 2019/3/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
//21：单行秒杀；22：单行商家精选；23：一行两个秒杀商家精选
//
//24：1个系统推荐；25：2个系统推荐；26：3个系统推荐；
enum HomeCellType: Int {
    case HomeCellTypeCommonProduct = 0  //普品
    case HomeCellTypeBanner = 1 //banner
    case HomeCellTypeYQG = 3   //一起购
    case HomeCellTypeAD = 4   //一栏广告
    case HomeCellTypeTwoAD = 5   //二栏广告
    case HomeCellTypeThreeAD = 6 //三栏广告
    case HomeCellTypeOther = 8   //毛利  一起返等
    case HomeCellTypeNotice = 13 //广播
    case HomeCellTypeNavFunc = 14 //导航按钮
    case HomeCellTypeSecKill = 16   //秒杀
    case HomeCellTypeBrand = 17 //品牌
    case HomeCellTypeSingleSecKill = 18   //单品秒杀
//    case HomeCellTypeOnlySecKill = 21   //单行秒杀
//    case HomeCellTypeOnlyShopRecomm = 22 //单行商家精选
//    case HomeCellTypeSecKillAndShopRecomm = 23   //一行两个秒杀商家精选
    case HomeCellTypeOneSystemRecomm = 24   //1个系统推荐
    case HomeCellTypeTwoSystemRecomm = 25 //2个系统推荐
    case HomeCellTypeThreeSystemRecomm = 26 //3个系统推荐
//    case HomeCellTypeOnlyCombo = 27 //单行套餐
//    case HomeCellTypeSecKillAndCombo = 28   //一行两个秒杀套餐
//    case HomeCellTypeComboAndShopRecomm = 29  //一行两个套餐商家精选
    /// 一行两个相同组件 这个30并不和templateType对应
    case HomeCellTypeOneComponents = 30
    /// 一行两个不同组件 这个31并不和templateType对应
    case HomeCellTypeTwoComponents = 31
}

enum HomeHotSellFloorCellType: Int {
    case HomeHotSellFloorCellNewArrive = 0  //新品上架
    case HomeHotSellFloorCellSoldOut = 1 //即将售罄
    case HomeHotSellFloorCellHotSell = 2   //热销
    case HomeHotSellFloorCellTag = 3   //标签
    case HomeHotSellFloorCellOther = 4  //其他
}
class HomeBaseCellProtocol: NSObject {
    var cellType:HomeCellType?
}
//普品
class HomeCommonProductCellModel: HomeBaseCellProtocol {
    var model:HomeCommonProductModel?
    override init(){
        super.init()
        cellType = .HomeCellTypeCommonProduct
    }
}
//广告
class HomeADCellModel: HomeBaseCellProtocol {
    var model:HomeADInfoModel?
    override init(){
        super.init()
        cellType = .HomeCellTypeAD
    }
}
//二栏广告
class HomeTwoADCellModel: HomeBaseCellProtocol {
    var model:HomeADInfoModel?
    override init(){
        super.init()
        cellType = .HomeCellTypeTwoAD
    }
}
//三栏广告
class HomeThreeADCellModel: HomeBaseCellProtocol {
    var model:HomeADInfoModel?
    override init(){
        super.init()
        cellType = .HomeCellTypeThreeAD
    }
}
//秒杀
class HomeSecKillCellModel: HomeBaseCellProtocol {
    var model:HomeSecdKillProductModel?
    override init(){
        super.init()
        cellType = .HomeCellTypeSecKill
    }
}
//一起购
class HomeYQGCellModel: HomeBaseCellProtocol {
    var model:HomeSecdKillProductModel?
    override init(){
        super.init()
        cellType = .HomeCellTypeYQG
    }
}
//毛利  一起返等
class HomeOtherProductCellModel: HomeBaseCellProtocol {
    var model:HomeSecdKillProductModel?
    override init(){
        super.init()
        cellType = .HomeCellTypeOther
    }
}
//品牌
class HomeBrandCellModel: HomeBaseCellProtocol {
    var model:HomeBrandModel?
    override init(){
        super.init()
        cellType = .HomeCellTypeBrand
    }
}
//BANNER
class HomeBannerCellModel: HomeBaseCellProtocol {
    var model:HomeCircleBannerModel?
    override init(){
        super.init()
        cellType = .HomeCellTypeBanner
    }
}
//导航
class HomeNavFucCellModel: HomeBaseCellProtocol {
    var model:HomeFucButtonModel?
    override init(){
        super.init()
        cellType = .HomeCellTypeNavFunc
    }
}
//广播
class HomeNoticeCellModel: HomeBaseCellProtocol {
    var model:HomePublicNoticeModel?
    override init(){
        super.init()
        cellType = .HomeCellTypeNotice
    }
}

//单品秒杀
class HomeSingleSecKillCellModel: HomeBaseCellProtocol {
    var model:HomeSecdKillProductModel?
    override init(){
        super.init()
        cellType = .HomeCellTypeSingleSecKill
    }
}

class HomeFloorModel:HomeBaseCellProtocol{
    var modelList:[HomeSecdKillProductModel]?
    var hasBtttom:Bool = false //有新品、热销底部
    override init(){
        super.init()
        //cellType = .HomeCellTypeSecKillAndShopRecomm
    }
}

//case HomeCellTypeOneSystemRecomm = 24   //1个系统推荐
class HomeOneSystemRecommCellModel: HomeBaseCellProtocol {
    var modelList:[HomeSecdKillProductModel]?
    var hasTop:Bool = false //有商家热销在顶部
    override init(){
        super.init()
        cellType = .HomeCellTypeOneSystemRecomm
    }
}
//case HomeCellTypeTwoSystemRecomm = 25 //2个系统推荐
class HomeTwoSystemRecommCellModel: HomeBaseCellProtocol {
    var modelList:[HomeSecdKillProductModel]?
    var hasTop:Bool = false //有商家热销在顶部
    override init(){
        super.init()
        cellType = .HomeCellTypeTwoSystemRecomm
    }
}
//case HomeCellTypeThreeSystemRecomm = 26 //3个系统推荐
class HomeThreeSystemRecommCellModel: HomeBaseCellProtocol {
    var modelList:[HomeSecdKillProductModel]?
    var hasTop:Bool = false //有商家热销在顶部
    override init(){
        super.init()
        cellType = .HomeCellTypeThreeSystemRecomm
    }
}
