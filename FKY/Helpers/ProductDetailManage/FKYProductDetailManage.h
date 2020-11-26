//
//  FKYProductDetailManage.h
//  FKY
//
//  Created by mahui on 2017/2/15.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  商详之基本信息之cell布局

#import <Foundation/Foundation.h>
@class FKYDiscountPackageModel ;

// 商详之楼层类型
typedef NS_ENUM(NSUInteger, PDCellType) {
    PDCellTypeBanner,           // 图片轮播
    PDCellTypePrice,            // 价格
    PDCellTypeNoBuy,            // 不可购买之缺少经营范围
    PDCellTypeName,             // 名称
    PDCellTypeTitle,            // 标题(描述)
    PDCellTypeLimit,            // 限购
    PDCellTypeDate,             // 基本信息...<包括生产厂家、批准文号、有效期至、生产日期>
    PDCellTypeCosmetics,        // 化妆品说明
    PDCellTypeStock,            // 库存
    PDCellTypeCoupon,           // 优惠券
    PDCellTypePromotionTitle,   // 促销标题
    PDCellTypeSlowPayOrHoldPrice, //慢必赔or保价
    PDCellTypeVip,              // 促销之vip特权
    PDCellTypeFullReduce,       // 促销之满减
    PDCellTypeFullGift,         // 促销之满赠
    PDCellTypeRebate,           // 促销之返利
    PDCellTypeCombo,            // 促销之套餐
    PDCellTypeFullDiscount,     // 促销之满折
    PDCellTypeProtocolRebate,   // 促销之协议奖励金
    PDCellTypePackageRate,     // 促销之单品包邮
    PDCellTypeGroup,            // 套餐
    PDCellTypeBounty,           // 奖励金
    PDCellTypeShop,             // 店铺(供应商)
    PDCellTypeRecommend,        // 同品热卖
    PDCellTypeEmpty,            // (通用分隔)空行
    PDCellTypeEmptyCoupon,      // (优惠券上方)空行
    PDCellTypeEmptyPromotion,   // (促销上方)空行
    PDCellTypeEmptyGroup,       // (套餐上方)空行
    PDCellTypeEmptyHotSale,     // (同品热卖上方)空行
    PDCellTypeWhiteEmpty,       // 白底空行
    PDCellTypeWhiteEmptyNoPrice // 白底空行之无价格时展示
};

// 商详之促销类型
typedef NS_ENUM(NSUInteger, PDPromotionType) {
    PDPromotionTypeFullReduce,      // 满减
    PDPromotionTypeFullGift,        // 满赠
    PDPromotionTypeRebate,          // 返利
    PDPromotionTypeCombo,           // 套餐
    PDPromotionTypeVip,             // vip
    PDPromotionTypeSlowPayOrHoldPrice, //慢必赔or保价
    PDPromotionTypeProtocolRebate,  // 协议返利金
    PDPromotionTypeFullDiscount,    // 满折
    PDPromotionTypeBounty,           // 奖励金
    PDPromotionTypePackageRate,           // 单品包邮
    PDPromotionTypeOther,           // 其它
};


@interface FKYProductDetailManage : NSObject

// cell类型数组
+ (NSArray *)getListForCellType;


#pragma mark - ShowOrHide

// 轮播图片cell是否显示
+ (BOOL)showBannerCell:(FKYProductObject *)model;
// 价格cell是否显示
+ (BOOL)showPriceCell:(FKYProductObject *)model;
// 不可购买之缺少经营范围cell是否显示
+ (BOOL)showNoBuyCell:(FKYProductObject *)model;
// 名称cell是否显示
+ (BOOL)showNameCell:(FKYProductObject *)model;
// 标题cell是否显示
+ (BOOL)showTitleCell:(FKYProductObject *)model;
// 规格cell是否显示
+ (BOOL)showSpecificationCell:(FKYProductObject *)model;
// 限购cell是否显示
+ (BOOL)showLimitCell:(FKYProductObject *)model;
// 基本信息cell是否显示
+ (BOOL)showBaseInfoCell:(FKYProductObject *)model;
// 化妆品说明cell是否显示
+ (BOOL)showCosmeticsCell:(FKYProductObject *)model;
// 库存cell是否显示
+ (BOOL)showStockCell:(FKYProductObject *)model;
// 优惠券cell是否显示
+ (BOOL)showCouponCell:(FKYProductObject *)model;
// 促销cell是否显示
+ (BOOL)showPromotionCell:(FKYProductObject *)model;
// 促销之vip-cell是否显示
+ (BOOL)showPromotionVipCell:(FKYProductObject *)model;
// 促销之满减cell是否显示
+ (BOOL)showPromotionFullReduceCell:(FKYProductObject *)model;
// 促销之满赠cell是否显示
+ (BOOL)showPromotionFullGiftCell:(FKYProductObject *)model;
// 促销之返利cell是否显示
+ (BOOL)showPromotionRebateCell:(FKYProductObject *)model;
// 促销之套餐cell是否显示
+ (BOOL)showPromotionComboCell:(FKYProductObject *)model;
//判断是搭配套餐还是固定套餐
+ (BOOL)isFixedComboView:(FKYProductObject *)model;
// 促销之满折cell是否显示
+ (BOOL)showPromotionFullDiscountCell:(FKYProductObject *)model;
// 促销之协议返利金cell是否显示
+ (BOOL)showPromotionProtocolRebateCell:(FKYProductObject *)model;
// 套餐cell是否显示
+ (BOOL)showGroupCell:(FKYProductObject *)model;
// 其它信息cell是否显示
+ (BOOL)showOtherInfoCell:(FKYProductObject *)model;
// 供应商cell是否显示
//+ (BOOL)showSupplierCell:(FKYProductObject *)model;
// 店铺(供应商)cell是否显示
+ (BOOL)showShopCell:(FKYProductObject *)model;
// 同品热卖cell是否显示
+ (BOOL)showRecommendCell:(FKYProductObject *)model;
// 没有更多cell是否显示
+ (BOOL)showNoMoreCell:(FKYProductObject *)model;
// 促销之奖励金cell是否显示
+ (BOOL)showPromotionBountyCell:(FKYProductObject *)model;
// 促销之单品包邮或者其他类型的入口列表cell是否显示
+ (BOOL)showPromotionEntranceInfoCell:(FKYProductObject *)model entranceType:(NSNumber *)entranceType;

#pragma mark - CellHeight

// 计算轮播图高度
+ (CGFloat)getBannerCellHeight:(FKYProductObject *)model;
// 计算价格高度
+ (CGFloat)getPriceCellHeight:(FKYProductObject *)model;
// 计算不可购买之缺少经营范围高度
+ (CGFloat)getNoBuyCellHeight:(FKYProductObject *)model;
// 计算名称高度
+ (CGFloat)getNameCellHeight:(FKYProductObject *)model;
// 计算标题高度
+ (CGFloat)getTitleCellHeight:(FKYProductObject *)model;
// 计算规格高度
+ (CGFloat)getSpecificationCellHeight:(FKYProductObject *)model;
// 计算限购高度
+ (CGFloat)getLimitCellHeight:(FKYProductObject *)model;
// 计算基本信息高度
+ (CGFloat)getBaseInfoCellHeight:(FKYProductObject *)model;
// 计算化妆品说明高度
+ (CGFloat)getCosmeticsCellHeight:(FKYProductObject *)model;
// 计算库存高度
+ (CGFloat)getStockCellHeight:(FKYProductObject *)model;
// 计算优惠券高度
+ (CGFloat)getCouponCellHeight:(FKYProductObject *)model;
// 计算促销高度
//+ (CGFloat)getPromotionCellHeight:(FKYProductObject *)model;
// 计算套餐高度
+ (CGFloat)getGroupCellHeight:(FKYProductObject *)model;
// 计算其它信息高度
//+ (CGFloat)getOtherInfoCellHeight:(FKYProductObject *)model;
// 计算供应商高度
//+ (CGFloat)getSupplierCellHeight:(FKYProductObject *)model;
// 计算店铺(供应商)高度
+ (CGFloat)getShopCellHeight:(FKYProductObject *)model withDiscountModel:(FKYDiscountPackageModel *)discountModel;
// 计算同品热卖高度
+ (CGFloat)getRecommendCellHeight:(FKYProductObject *)model;
// 计算没有更多高度
+ (CGFloat)getNoMoreCellHeight:(FKYProductObject *)model;


#pragma mark - CouponCellHeight

// 计算优惠券高度
+ (CGFloat)calculateCouponCellHeight:(FKYProductObject *)model;

@end
