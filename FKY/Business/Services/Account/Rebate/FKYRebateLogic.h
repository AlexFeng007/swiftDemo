//
//  FKYRebateLogic.h
//  FKY
//
//  Created by Joy on 2018/7/6.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "HJLogic.h"

@interface FKYRebateLogic : HJLogic

/**
 *  返利金数据
 *
 *  @param enterpriseId 企业ID
 *  @param successBlock 成功
 *  @param failureBlock 失败
 */
-(void)getRebateData:(NSNumber *)enterpriseId
             success:(void(^)(NSMutableArray *rebateList,NSNumber *totalAmount))successBlock failure:(void(^)(NSString *reason))failureBlock;

@end
