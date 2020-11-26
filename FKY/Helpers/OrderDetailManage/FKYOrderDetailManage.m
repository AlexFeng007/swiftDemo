//
//  FKYOrderDetailManage.m
//  FKY
//
//  Created by mahui on 2017/1/5.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYOrderDetailManage.h"

@implementation FKYOrderDetailManage

+ (instancetype)shareManage{
    FKYOrderDetailManage *m = [[FKYOrderDetailManage alloc] init];
    return m;
}

- (NSArray *)defaultCellType{
    // 订单编号、订单状态、下单时间、销售顾问
    NSArray *arr = [NSArray arrayWithObjects:@(OrderNumber), @(OrderStatus), @(OrderTime), @(SellerName), nil];
    return arr;
}

- (NSArray *)orderDetailCellType:(NSString *)orderStatus{
    // 订单编号、订单状态、下单时间
    NSArray *arr = [NSArray arrayWithObjects:@(OrderNumber), @(OrderStatus), @(OrderTime), nil];
    return arr;
}

- (NSArray *)orderDetailSectionType{
    // 订单信息、收货地址信息,留言、商品信息、支付类型、配送类型、发票类型、赠品、积分、商品金额、优惠券、满减金额、运费金额、店铺优惠券、平台优惠券、支付金额
//    NSArray *arr = [NSArray arrayWithObjects:@(OrderInfo), @(ShipInfo), @(ProductInfo), @(PaySectionType), @(DeliverySectionType), @(BillSectionType), @(Gifts), @(Score), @(TotalMoney), @(CouponType), @(ReduceMoney), @(FreightMoneyType), @(shopCouponType), @(platformCouponType), @(PayMoney), nil];
    
    // 移除老版CouponType优惠券类型入口
    NSArray *arr = [NSArray arrayWithObjects:@(OrderInfo), @(ShipInfo),@(mpLeaveMsgType), @(ProductInfo), @(PaySectionType), @(DeliverySectionType), @(BillSectionType),@(ShipListType),@(saleAgreement), @(Gifts), @(Score), @(TotalMoney), @(ReduceMoney), @(FreightMoneyType), @(shopCouponType),@(shopBuyMoneyType), @(platformCouponType),@(rebateDeductibleMoneyType),@(rebatePlatformDeductibleMoneyType),@(rebateObtainMoneyType), @(PayMoney), nil];
    return arr;
}
- (NSArray *)sectionTypeWithOrderModel:(FKYOrderModel *)model{
    // 订单信息、收货地址信息,留言、商品信息、支付类型、配送类型、发票类型、赠品、积分、商品金额、优惠券、满减金额、运费金额、店铺优惠券、平台优惠券、支付金额
    NSMutableArray *section = [NSMutableArray array];
    if (model.hasSellerRemark == 1){
        //增加留言
        [section addObjectsFromArray:[NSArray arrayWithObjects:@(OrderInfo), @(ShipInfo),@(mpLeaveMsgType), nil]];
    }else{
         [section addObjectsFromArray:[NSArray arrayWithObjects:@(OrderInfo), @(ShipInfo), nil]];
    }
    if (model.parentOrderFlag == 1){
        //有子订单
        for (int i=0; i<model.childOrderBeans.count; i++) {
             [section addObject:@(ProductInfo)];
        }
    }else{
        //没有子订单
        [section addObject:@(ProductInfo)];
    }
    [section addObjectsFromArray:[NSArray arrayWithObjects:@(PaySectionType), @(DeliverySectionType), @(BillSectionType),@(ShipListType),@(saleAgreement), @(Gifts), @(Score), @(TotalMoney), @(ReduceMoney), @(FreightMoneyType), @(shopCouponType),@(shopBuyMoneyType), @(platformCouponType),@(rebateDeductibleMoneyType),@(rebatePlatformDeductibleMoneyType),@(rebateObtainMoneyType), @(PayMoney), nil]];
    return section;
}
//没有留言类型
- (NSArray *)orderDetailSectionNoneMsgType{
    // 订单信息、收货地址信息、商品信息、支付类型、配送类型、发票类型、赠品、积分、商品金额、优惠券、满减金额、运费金额、店铺优惠券、平台优惠券、支付金额
    //    NSArray *arr = [NSArray arrayWithObjects:@(OrderInfo), @(ShipInfo), @(ProductInfo), @(PaySectionType), @(DeliverySectionType), @(BillSectionType), @(Gifts), @(Score), @(TotalMoney), @(CouponType), @(ReduceMoney), @(FreightMoneyType), @(shopCouponType), @(platformCouponType), @(PayMoney), nil];
    
    // 移除老版CouponType优惠券类型入口
    NSArray *arr = [NSArray arrayWithObjects:@(OrderInfo), @(ShipInfo), @(ProductInfo), @(PaySectionType), @(DeliverySectionType), @(BillSectionType),@(ShipListType),@(saleAgreement), @(Gifts), @(Score), @(TotalMoney), @(ReduceMoney), @(FreightMoneyType), @(shopCouponType),@(shopBuyMoneyType), @(platformCouponType),@(rebateDeductibleMoneyType),@(rebatePlatformDeductibleMoneyType),@(rebateObtainMoneyType), @(PayMoney), nil];
    return arr;
}
//子订单的商品展示信息
- (NSArray *)childOrderFooterRowTye{
    NSArray *arr = [NSArray arrayWithObjects:@(ChildRebateGiftType),@(ChildTotalMoney), @(ChildReduceMoney), @(ChildFreightMoneyType), @(ChildShopCouponType), @(ChildPlatformCouponType),@(ChildRebateDeductibleMoneyType),@(ChildShopBuyMoneyType),@(childRebatePlatformDeductibleMoneyType),@(ChildRebateObtainMoneyType), @(ChildPayMoney), nil];
    return arr;
}
//插入多个商品数据

- (NSArray *)orderDetailSectionTypeWithOrderModel:(FKYOrderModel *)model{
    NSArray *arr = [NSArray array];
    return arr;
}
- (NSArray *)orderDetailCellTypeWithOrderModel:(FKYOrderModel *)model{
    NSMutableArray *arr = [self defaultCellType].mutableCopy;
    if ([model.orderStatus isEqualToString:@"10"]){
        //取消订单增加原因和时间
        [arr insertObject:@(CancelOrderTime) atIndex:3];
        [arr insertObject:@(CancelOrderReason) atIndex:3];
    }
    if (model.partDeliveryType.integerValue == 2) {
        // 剩余商品退款状态
        [arr insertObject:@(OtherTKStatus) atIndex:2];
    }
    if (model.partDeliveryType.integerValue == 1) {
        // 剩余商品补货状态
        [arr insertObject:@(OtherBHStatus) atIndex:2];
    }
    if ([model.payName isEqualToString:payType_xxzz]) {
        // 银行账户
        [arr insertObject:@(BankInfo) atIndex:arr.count -1];
    }
    
    // bug fix: 运费不放在订单信息section中，而是与底部的金额放在一起
    return arr;
}

@end
