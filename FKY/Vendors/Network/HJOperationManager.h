//
//  HJOperationManager.h
//  HJFramework
//  功能:重写AFHTTPSessionManager
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "HJOperationParam.h"

// error != nil 时从 userInfo 里面取错误码（含 HTTP status code 和服务自定义的业务错误码）的 key
UIKIT_EXTERN NSString * const HJErrorCodeKey;
UIKIT_EXTERN NSString * const HJErrorTipKey;
typedef NS_ENUM(NSInteger, ForceTip)
{
    kShowAWhile = 0,             //显示一会提示
    kForceShow,                  //强制显示
    kForceJump,                  //强行跳转
    KForceUpdate                 //强制更新模块
};


@interface HJOperationManager : AFHTTPSessionManager

/**
 *  功能:取消当前manager queue中所有网络请求
 */
- (void)cancelAllOperations;

/**
 *  功能:发送请求
 */
- (NSURLSessionDataTask *)requestWithParam:(HJOperationParam *)aParam;

/**
 *  初始化函数,宿主owner
 */
+ (instancetype)managerWithOwner:(id)owner;

@end
