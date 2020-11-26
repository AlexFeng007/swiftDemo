//
//  FKYAccountNILaunch.h
//  FKY
//
//  Created by Lily on 2018/2/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJOperationParam.h"

@interface FKYAccountNILaunch : NSObject

/**
 *  发送短信验证码
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)sendSmsWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  注册
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)registWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  登录
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)loginWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  刷新token
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)refreshTokenWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  切换用户
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)changeUserWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  用户详细信息
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)checkDetailInfoAndCompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  版本检查
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)checkAppVersionWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  手机关键日志上传
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)addAppLogWithParam:(NSDictionary *)param CompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  获取站点列表
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getStationListCompletionBlock:(HJCompletionBlock)aCompletionBlock;

/**
 *  获取常用工具列表
 *
 *  @param aCompletionBlock
 */
+ (HJOperationParam *)getCommonToolsListCompletionBlock:(HJCompletionBlock)aCompletionBlock;

@end
