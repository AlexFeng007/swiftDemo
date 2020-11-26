//
//  FKYCartSubmitService.h
//  FKY
//
//  Created by yangyouyong on 15/9/29.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  有三个地方用到该service：编辑地址、检查订单、线下支付
//  todo: 待后续修改后删除

#import "FKYBaseService.h"
#import "FKYReCheckCouponModel.h"


@interface FKYCartSubmitService : FKYBaseService

// 优惠券列表
@property (nonatomic, strong) NSArray<FKYReCheckCouponModel *> *couponListArray;

// 已选优惠券
@property (nonatomic, strong) NSString *checkCouponCodeStr;

// 优惠券使用规则
@property (nonatomic, strong) NSString *couponRuleContent;
// 优惠券使用规则
@property (nonatomic, strong) NSString *couponRuleTitle;

// 选中优惠券的总体提示
@property (nonatomic, strong) NSString *showTxt;


/**
 *  勾选优惠券/跳页展示优惠券
 *
 *  @param successBlock success
 *  @param failureBlock failure
 */
- (void)recheckCouponListPageInfo:(NSMutableDictionary *)reCheckDic
                          Success:(FKYSuccessBlock)successBlock
                          failure:(FKYFailureBlock)failureBlock;

/**
 *    @brief    获取订单支付分享签名
 *
 *    @param     orderid     订单id
 *    @param     payType     支付类型 1-线上支付 3-线下支付
 *    @param     successBlock     成功回调block
 *    @param     failureBlock     失败回调block
 */
- (void)getOrderShareSign:(NSString *)orderid
                  payType:(NSString *)payType
                  success:(FKYRequestSuccessBlock)successBlock
                  failure:(FKYRequestFailureBlock)failureBlock;

@end
