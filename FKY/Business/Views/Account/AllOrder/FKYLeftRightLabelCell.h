//
//  FKYLeftRightLabelCell.h
//  FKY
//
//  Created by mahui on 15/11/23.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FKYOrderModel;

typedef NS_ENUM(NSUInteger, FKYLeftRightLabelCellType) {
    PayType,                // 支付方式
    BillTagType,            // 发票类型
    DeliveryType,           // 配送方式
    PayMoneyType,           // 应付金额
    ProductsMoneyType,      // 商品金额
    CouponMoneyType,        // 优惠券
    PromotionMoneyType,     // 立减金额
    ReduceMoneyType,        // 优惠抵扣
    ScoreType,              // 积分
    FreightMoneyTypes,      // 运费
    CouponShopType,         // 店铺优惠券
    BuyMoneyType,               //购物金
    CouponPlatformType,     // 平台优惠券
    RebateDeductibleType,   // 返利金抵扣
    RebateShopDeductibleType,   // 店铺返利金抵扣
    RebatePlatformDeductibleType,   // 平台返利金抵扣
    RebateObtainType ,       // 获得返利金
    saleContract            //销售合同随货
};


@interface FKYLeftRightLabelCell : UITableViewCell
@property (nonatomic, copy) void(^showRebateDescBlock)(void);
- (void)configCellWithModel:(FKYOrderModel *)model andType:(FKYLeftRightLabelCellType)cellType;

@end
