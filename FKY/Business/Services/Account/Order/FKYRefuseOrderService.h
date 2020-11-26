//
//  FKYRefuseOrderService.h
//  FKY
//
//  Created by yangyouyong on 2016/9/20.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYBaseService.h"

@interface FKYRefuseOrderService : FKYBaseService

@property (nonatomic, strong, readonly) NSMutableArray *refuseOrderArray;
@property (nonatomic, strong, readonly) NSMutableArray *addOrderArray;

// status: 800 拒收 900 补货
- (void)getOrderList:(NSString *)status
             Success:(FKYSuccessBlock)success
             failure:(FKYFailureBlock)failure;

- (BOOL)hasNext:(NSString *)status;

- (void)getNext:(NSString *)status Success:(FKYSuccessBlock)success
        failure:(FKYFailureBlock)failure;

// 补货确认收货
- (void)commitOrder:(NSString *)exceptionOrderId
            success:(FKYSuccessBlock)success
            failure:(FKYFailureBlock)failure;

@end
