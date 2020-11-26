//
//  FKYAccountLaunchLogic.h
//  FKY
//
//  Created by Lily on 2018/2/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "HJLogic.h"

@interface FKYAccountLaunchLogic : HJLogic

/**
 *  发送短信验证码
 *
 *  @param aCompletionBlock
 */
- (void)sendSmsWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  数据处理...<注册、登录、切换账号>
 *
 *  @param data 接口返回值
 *  @param param  接口入参
 *  @param flagChange  是否为切换账号
 */
+ (void)handleResponseData:(NSDictionary *)data forRequest:(NSDictionary *)param withFlag:(BOOL)flagChange;

/**
 *  注册
 *
 *  @param aCompletionBlock
 */
- (void)registWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  登录
 *
 *  @param aCompletionBlock
 */
- (void)loginWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  切换用户
 *
 *  @param aCompletionBlock
 */
- (void)changeUserWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  刷新token
 *
 *  @param aCompletionBlock
 */
- (void)refreshTokenWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  获取用户信息
 *
 *  @param aCompletionBlock
 */
- (void)getUserInfoCompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *   版本检查 
 *
 *  @param aCompletionBlock
 */
- (void)checkAppVersionWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *   手机关键日志上传
 *
 *  @param aCompletionBlock
 */
- (void)addLogWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  获取站点列表
 *
 *  @param aCompletionBlock
 */
- (void)getStationListCompletionBlock:(HJCompletionBlock)aCompletionBlock;


/**
 *  获取常用工具列表
 *
 *  @param aCompletionBlock
 */
- (void)getCommonToolsListCompletionBlock:(HJCompletionBlock)aCompletionBlock;

@end
