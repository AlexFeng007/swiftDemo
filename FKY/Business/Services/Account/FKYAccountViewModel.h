//
//  FKYAccountViewModel.h
//  FKY
//
//  Created by yangyouyong on 15/12/3.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseService.h"
#import "FKYAccountBaseInfoModel.h"

@interface FKYAccountViewModel : FKYBaseService

@property (nonatomic, assign, readonly) NSInteger payCount;
@property (nonatomic, assign, readonly) NSInteger sendCount;
@property (nonatomic, assign, readonly) NSInteger receiveCount;
@property (nonatomic, assign, readonly) NSInteger refuseCount;
@property (nonatomic, strong)  NSString *unusedCouponCount;
@property (nonatomic, assign, readonly) BOOL isNotPerfectInformation;//用户资料审核状态
@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, strong) RACCommand *getServiceDataCommand;
@property (nonatomic, strong) FKYAccountBaseInfoModel *baseInfoModel;

// 重置数据
- (void)resetBaseInfo;
// 获取用户聚合信息
- (void)getUserBaseInfo:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock;

@end
