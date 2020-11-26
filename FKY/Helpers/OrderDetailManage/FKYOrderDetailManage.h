//
//  FKYOrderDetailManage.h
//  FKY
//
//  Created by mahui on 2017/1/5.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FKYOrderModel;

typedef NS_ENUM(NSUInteger, CellType) {
    OrderNumber,       // 正常订单号
    OrderStatus,       // 订单状态
    OrderTime,         // 下单时间
    OriginOrderNumber, // 异常订单号
    OtherBHStatus,     // 剩余商品补货状态
    OtherTKStatus,     // 剩余商品退款状态
    BHStatus,          // 补货状态
    JSStatus,          // 拒收状态
    SellerName,        // 销售顾问
    BankInfo,           // 银行账户
    CancelOrderReason,           // 取消订单原因
    CancelOrderTime,           //取消订单时间
    
//    FreightMoney,       // 运费金额
};

typedef NS_ENUM(NSUInteger, SectionType) {
    OrderInfo = 0,       // 订单信息
    ShipInfo,            // 收货地址信息
    ProductInfo,         // 商品信息
    PaySectionType,      // 支付类型
    DeliverySectionType, // 配送类型
    BillSectionType,     // 发票类型
    ShipListType,        //电子随货同行单
    TotalMoney,          // 商品金额
    CouponType,          // 优惠券...<老版优惠券逻辑，不再显示；现在细分为店铺券和平台券>
    PayMoney,            // 支付金额
    Gifts,               // 赠品
    Score,               // 积分
    ReduceMoney,         // 满减金额
    FreightMoneyType,    // 运费金额
    shopCouponType,      // 店铺优惠券
    shopBuyMoneyType,    //购物金
    platformCouponType,  // 平台优惠券
    rebateDeductibleMoneyType,//店铺返利金抵扣金额
    rebatePlatformDeductibleMoneyType,//平台返利金抵扣金额
    rebateObtainMoneyType,//获得返利金金额
    mpLeaveMsgType,//商家给买家留言
    saleAgreement, //销售合同随货
    drawCell// 抽奖活动入口cell
};

typedef NS_ENUM(NSUInteger, RowType) {
    ChildTotalMoney,          // 商品金额1
    ChildPayMoney,            // 支付金额1
    ChildReduceMoney,         // 满减金额1
    ChildFreightMoneyType,    // 运费金额1
    ChildShopCouponType,      // 店铺优惠券1
    ChildPlatformCouponType,  // 平台优惠券1
    ChildRebateDeductibleMoneyType,//店铺使用返利金抵扣金额1
    childRebatePlatformDeductibleMoneyType, //平台使用返利金抵扣金额
    ChildRebateObtainMoneyType,//获得返利金金额1
    ChildRebateGiftType,// 赠品
    ChildShopBuyMoneyType //购物金
};

@interface FKYOrderDetailManage : NSObject

+ (instancetype)shareManage;
- (NSArray *)defaultCellType;
- (NSArray *)orderDetailSectionType;
- (NSArray *)orderDetailSectionNoneMsgType;
- (NSArray *)orderDetailSectionTypeWithOrderModel:(FKYOrderModel *)model;
- (NSArray *)orderDetailCellTypeWithOrderModel:(FKYOrderModel *)model;
- (NSArray *)sectionTypeWithOrderModel:(FKYOrderModel *)model;
- (NSArray *)childOrderFooterRowTye;
@end


