//
//  FKYVersionCheckService.h
//  FKY
//
//  Created by yangyouyong on 15/10/9.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseService.h"

@interface FKYVersionCheckService : FKYBaseService

@property (nonatomic, assign) BOOL hasNewVersion;
@property (nonatomic, assign) BOOL mustUpdate;
@property (nonatomic, strong) NSString *updateMessage;

+ (FKYVersionCheckService *)shareInstance;

// 版本检查
- (void)checkAppVersionSuccess:(FKYSuccessBlock)successBlock
                       failure:(FKYFailureBlock)failureBlock;

//获取一起购购物车商品数量
- (void)syncTogeterBuyCartNumberSuccess:(FKYSuccessBlock)successBlock
                                failure:(FKYFailureBlock)failureBlock;

// 获取购物车商品数量 更新购物车商品列表
- (void)syncCartNumberSuccess:(FKYSuccessBlock)successBlock
                      failure:(FKYFailureBlock)failureBlock;

// 获取混合商品数量
- (void)syncMixCartNumberSuccess:(FKYSuccessBlock)successBlock
                      failure:(FKYFailureBlock)failureBlock;

// 新增的用于提审的接口
//- (void)checkVersionSuccess:(FKYSuccessBlock)successBlock
//                      failure:(FKYFailureBlock)failureBlock;

// 保存推送信息接口
//- (void)savePushWithClientid:(NSString *)clientid
//                 devicetoken:(NSString *)devicetoken
//                     success:(FKYSuccessBlock)successBlock
//                     failure:(FKYFailureBlock)failureBlock;

// 保存推送(设备)信息接口
- (void)saveDeviceInfoWithClientid:(NSString *)clientid
                       devicetoken:(NSString *)devicetoken
                           success:(FKYSuccessBlock)successBlock
                           failure:(FKYFailureBlock)failureBlock;

@end
