//
//  CartCellTypeInfo.swift
//  FKY
//
//  Created by 寒山 on 2019/12/2.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  进货单cell  类型

import UIKit
//商品组类型
//enum CartGroupType: Int {
//    case CartGroupTypeSpace = 0    // 空格
//    case CartGroupTypePromation = 1        // 活动类型的商品组
//    case CartGroupTypeNormal = 2   // 普通商品类型的商品组
//}
// cell类型
enum CartCellType: Int {
    case CartCellTypeBase = 0    // 商品
    case CartCellTypeFixTaoCanName = 1        // 固定套餐名
    case CartCellTypeTaoCanName = 2   // 搭配套餐名
   // case CartCellTypeBottomView = 3   // 底部栏目 可以显示可用券金额 和 小计
    case CartCellTypePromotion = 4      // 促销信息
   // case CartCellTypeSectionTips = 5      // 商家 运费 和 起售门槛等提示
    case CartCellTypeSeparateSpace = 6   //分隔栏目
    case CartCellTypeTaoCanPromotion = 7   //套餐优惠信息 可以显示可用套餐优惠金额 和 小计
    case CartCellTypeProduct = 8   // 商品
}
//展示商品类型
enum CartCellProductType: Int {
    case CartCellProductTypeNormal = 0    // 普通商品
    case CartCellProductTypeFixTaoCan = 1        // 固定套餐名
    case CartCellProductTypeTaoCan = 2   // 搭配套餐名
    case CartCellProductTypePromotion = 3   // 促销类型
}
//展示商品类型
enum CartPromotionType: Int {
    case CartPromotionTypeMJ = 0    //满减
    case CartPromotionTypeMZ = 1        // 满折
}

////商品组定义
//class BaseCartGroupProtocol: NSObject {
//    var cartGroupType:CartGroupType = .CartGroupTypeSpace
//    var cellTypeList:[BaseCartCellProtocol] = [] // 自定义楼层展示model
//}
//基础的cell
class BaseCartCellProtocol: NSObject {
    var cellType:CartCellType?
    var cellHeight:CGFloat?
    override init() {
        cellType = .CartCellTypeBase
        cellHeight = 0.0
    }
}
// 商品
class CartCellProductProtocol: BaseCartCellProtocol {
    //需不需要顶部圆角
    var firstObject = false
    //需不需要底部圆角
    var lastObject = false
    //固定套餐或者搭配套餐
    var productType:CartCellProductType?
    //商品信息
    var productModel:CartProdcutnfoModel?
    
    override init() {
        super.init()
        cellType = .CartCellTypeProduct
        cellHeight = WH(0)
    }
}
// 固定套餐名
class CartCellFixTaoCanProtocol: BaseCartCellProtocol {
    //需不需要顶部圆角
    var firstObject = true
    var fixComobLimitFlag = false  //固定套餐书否限购
    var fixComobLimitNum = 0  //固定套餐限购数目
    var taoCanName = "" //套餐名
    var modelInfo:ProductGroupListInfoModel? //固定套餐信息
    override init() {
        super.init()
        cellType = .CartCellTypeFixTaoCanName
        cellHeight = WH(45)
    }
}
// 搭配套餐名
class CartCellTaoCanProtocol: BaseCartCellProtocol {
    //需不需要顶部圆角
    var firstObject = true
    var taoCanName = ""
    var modelInfo:ProductGroupListInfoModel? //固定套餐信息
    override init() {
        super.init()
        cellType = .CartCellTypeTaoCanName
        cellHeight = WH(33)
    }
}
//套餐优惠信息
class CartCellTaocanPromationInfoProtocol: BaseCartCellProtocol {
    //需不需要顶部圆角
    var firstObject = false
    //需不需要底部圆角
    var lastObject = true
    
    var comboAmount:NSNumber? //套餐金额
    var shareMoney:NSNumber? //优惠金额
    override init() {
        super.init()
        cellType = .CartCellTypeTaoCanPromotion
        cellHeight = WH(33)
    }
}
//// 底部栏目 可以显示可用券金额 和 小计
//class CartCellBottomInfoProtocol: BaseCartCellProtocol {
//    var canUseCouponMoney:NSNumber? //所有可用卷金额
//    var allTotalMoney:NSNumber? //供应商下所有商品金额
//    override init() {
//        super.init()
//        cellType = .CartCellTypeBottomView
//    }
//}
// 促销信息
class CartCellPromotionInfoProtocol: BaseCartCellProtocol {
    //需不需要顶部圆角
    var firstObject = true
    var promotionType:CartPromotionType? //促销类型
    var promotionId:String? //促销id
    var promotionName:String? //促销名字
    var supplyId:String? //供应商
    var promationInfoModel:FKYPromationInfoModel?
    override init() {
        super.init()
        cellType = .CartCellTypePromotion
        cellHeight = WH(33)
    }
}
//// 商家 运费 和 起售门槛等提示
//class CartCellSectionTipsInfoProtocol: BaseCartCellProtocol {
//    var sectionInfo:CartMerchantInfoModel? //商家信息
//    override init() {
//        super.init()
//        cellType = .CartCellTypeSectionTips
//    }
//}
//分隔栏目
class CartCellSeparateSpaceProtocol: BaseCartCellProtocol {
    override init() {
        super.init()
        cellType = .CartCellTypeSeparateSpace
        cellHeight = WH(6)
    }
}

