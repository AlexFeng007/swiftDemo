//
//  FKYAccountService.h
//  FKY
//
//  Created by yangyouyong on 15/12/3.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseService.h"

/**
 *  个人中心页面service
 */
@interface FKYAccountService : FKYBaseService

@property (nonatomic, assign, readonly) NSInteger payCount;
@property (nonatomic, assign, readonly) NSInteger sendCount;
@property (nonatomic, assign, readonly) NSInteger receiveCount;
@property (nonatomic, assign, readonly) NSInteger refuseCount;

@property (nonatomic, strong, readonly)  NSMutableArray *unuseCouponArray;
@property (nonatomic, strong, readonly)  NSMutableArray *outDateCouponArray;
@property (nonatomic, strong, readonly)  NSMutableArray *useCouponArray;
@property (nonatomic, strong, readonly)  NSArray *couponArray;

@property (nonatomic, strong)  NSString *unuseCouponStr;
@property (nonatomic, strong)  NSString *outDateCouponStr;
@property (nonatomic, strong)  NSString *useCouponStr;


/**
 *  资质状态查询
 *
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)getUserAuditStatusSuccess:(void(^)(BOOL isNotPerfect))callBack
                          failure:(FKYFailureBlock)failureBlock;
/**
 *  查询正式表企业信息
 *
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)getEnterpriseInfoSuccess:(void(^)(BOOL isComplented))callBack
                          failure:(FKYFailureBlock)failureBlock;
/**
 *  获取个人中心数量提示
 *
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
- (void)getUserTipsInfoSuccess:(FKYSuccessBlock)successBlock
                       failure:(FKYFailureBlock)failureBlock;

- (void)getUnusedCouponInfoSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock;
- (void)getUsedCouponInfoSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock;
- (void)getOutDateCouponInfoSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock;

- (BOOL) hasNextForStatus:(FKYCouponStatus)status;
- (BOOL) hasNextPageForUnusedCoupon;
- (BOOL) hasNextPageForUsedCoupon;
- (BOOL) hasNextPageForOutDateCoupon;

- (NSArray *)couponArrayForStatus:(FKYCouponStatus)status;

- (void)getNextPageForStatus:(FKYCouponStatus)status
                     success:(FKYSuccessBlock)successBlock
                     failure:(FKYFailureBlock)failureBlock;

- (void)getNextPageForUnusedCouponInfoSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock;
- (void)getNextPageForUsedCouponInfoSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock;
- (void)getNextPageForOutDateCouponInfoSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock;


@end
