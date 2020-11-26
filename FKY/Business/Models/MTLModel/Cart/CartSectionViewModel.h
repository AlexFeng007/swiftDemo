//
//  CartSectionViewModel.h
//  FKY
//
//  Created by airWen on 2017/6/7.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//
#import "FKYCartMerchantInfoModel.h"
#import "FKYPromationInfoModel.h"

@class CartProductModel;
@class FKYIncreasePriceGiftsProductModel;
@class CartPromotionModel;
@class FKYPromotionHGInfo;
@class FKYHgOptionItemModel;
@class FKYProductGroupListInfoModel;
@class FKYCartGroupInfoModel;


typedef enum : NSUInteger {
    CartTabelCellTypeSeparateTopLine,               // 顶部分隔线
    CartTabelCellTypeSeparateBottomLine,            // 底部分隔线
    CartTabelCellTypeSeparateSpace,                 // 套餐和普通商品的分隔
    CartTabelCellTypeTaoCanName,                    // 套餐名
    CartTabelCellTypeFixedTaoCanNumber,             // 固定套餐之数量cell  无用
    CartTabelCellTypeRebate,                        // 返利
    CartTabelCellTypePromotion,                     // 促销
    CartTabelCellTypeIncreasePriceGiftsPromotion,   // 加价购(换购)类型的活动cell //x无用
    CartTabelCellTypeProduction,                    // 商品
    CartTabelCellTypeIncreasePriceGiftsProduct,     // 换购 //无用
    CartTabelCellTypeSectionTips,                   // 商家 运费 和 起售门槛等提示
    CartTabelCellTypeMuliRebate,                   // 多品返利
    CartTabelCellTypeMuliProtocolRebate,                   // 协议返利
} CartTabelCellType;


@protocol FKYBaseCellProtocol <NSObject>
@property (nonatomic, assign) CartTabelCellType cellType;
@end


// 分隔线
@interface SeparateLineCellModel : NSObject <FKYBaseCellProtocol>
@property (nonatomic, assign) CartTabelCellType cellType;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@end

// 空行
@interface SeparateSpaceCellModel : NSObject <FKYBaseCellProtocol>
@property (nonatomic, assign) CartTabelCellType cellType;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@end

//促销信息
@interface PromotionCellModel : NSObject <FKYBaseCellProtocol>
@property (nonatomic, strong) NSString *shopId;//vendorId
@property (nonatomic, strong) NSString *promotionDes;
@property (nonatomic, strong) CartPromotionModel *promotionModel;
@property (nonatomic, strong) FKYPromationInfoModel *promotionInfo;
@property (nonatomic, assign) CartTabelCellType cellType;
- (CGFloat)getCellHeight;
@end

//多品返利
@interface MuliRebateCellModel : NSObject <FKYBaseCellProtocol>
@property (nonatomic, strong) NSString *shopId;//vendorId
@property (nonatomic, strong) NSString *rebateDesc;
@property (nonatomic, strong) NSString *groupId;
//@property (nonatomic, strong) CartPromotionModel *promotionModel;
//@property (nonatomic, strong) FKYPromationInfoModel *promotionInfo;
@property (nonatomic, assign) CartTabelCellType cellType;

@end
// 返利金
@interface RebateCellModel : NSObject <FKYBaseCellProtocol>
@property (nonatomic, assign) CartTabelCellType cellType;
@property (nonatomic, strong) NSString *rebateDesc;//返利金描述
@end

//
@interface IncreasePriceGiftsPromotionCellModel : PromotionCellModel
@property (nonatomic, assign) BOOL isCanHuanGou;//针对换购是否显示去换购显示
@property (nonatomic, strong) NSString *canHuanGouDesc;//针对换购是否显示去换购显示
@property (nonatomic, strong) NSNumber *shoppingCartId;//vendorId
@property (nonatomic, strong) NSString *unitForMainProduct;//主品的单位
@property (nonatomic, strong) FKYPromotionHGInfo *promotionHGInfo;;//换购的信息

@end

// 套餐名称
@interface CartTaoCanNameCellModel : NSObject <FKYBaseCellProtocol>
@property (nonatomic, assign) CartTabelCellType cellType;
//@property (nonatomic, strong) NSArray<CartProductModel *> *taoCanItemList;  // 套餐内的商品数据列表
@property (nonatomic, strong) NSArray<FKYCartGroupInfoModel *> *taoCanGroudItemList;  // 套餐内的商品数据列表
@property (nonatomic, strong) FKYProductPromotionModel *promotionModel;     // 活动model???
//@property (nonatomic, strong) TaoCanItemsListModel *combo;                  // 搭配套餐model
//@property (nonatomic, strong) CartFixedComboItemModel *comboFixed;          // 固定套餐model
@property (nonatomic, strong) FKYProductGroupListInfoModel *taocanModel;    // 固定套餐model
@property (nonatomic, assign) ComboType comboType;                          // 套餐类型：搭配套餐、固定套餐
@end

// 固定套餐之套餐数量
@interface FixedComboNumberCellModel : NSObject <FKYBaseCellProtocol>
@property (nonatomic, assign) CartTabelCellType cellType;
@property (nonatomic, strong) FKYProductGroupListInfoModel *taocanModel;          // 套餐model
@end

// 提示
@interface SectionTipsCellModel : NSObject <FKYBaseCellProtocol>
@property (nonatomic, assign) CartTabelCellType cellType;
@property (nonatomic, retain) FKYCartMerchantInfoModel *cartMerchantInfoModel;
@end

// 商品
@interface CartProductCellModel : NSObject <FKYBaseCellProtocol>
@property (nonatomic, assign) CartTabelCellType cellType;
//@property (nonatomic, strong) CartProductModel *product;
@property (nonatomic, strong) FKYCartGroupInfoModel *productModel;
@property (nonatomic, assign) ComboType comboType; // 商品类型：普通商品、搭配套餐商品、固定套餐商品
@end

//
@interface FKYIncreasePriceGiftsProductCellModel : NSObject <FKYBaseCellProtocol>
@property (nonatomic, assign) CartTabelCellType cellType;
@property (nonatomic, strong) FKYHgOptionItemModel *hgItemModel;
@property (nonatomic, strong) FKYIncreasePriceGiftsProductModel *product;
@end
