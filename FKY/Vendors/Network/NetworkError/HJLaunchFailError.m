//
//  HJLaunchFailError.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "HJLaunchFailError.h"
#import "HJNetworkManager.h"
#import "HJOperationParam.h"
#import "HJOperationManager.h"

@interface HJOperationParam ()

@property(nonatomic, assign) BOOL rerunForLaunchFail;                   //是否重新调用启动接口后再次执行，默认为NO

@end

@interface HJOperationManager()

/**
 *  功能:launch接口调用失败时将operation暂存
 */
- (void)cacheOperationForLaunchFail:(HJOperationParam *)aParam;

@end

@interface HJNetworkManager()

/**
 *  功能:relaunch成功后执行所有暂存的operation
 */
- (void)performAllCachedOperationsForLaunchFail;

/**
 *  功能:relaunch失败后清除所有暂存的operation
 */
- (void)clearAllCachedOperationsForLaunchFail;

@end

@implementation HJLaunchFailError

DEF_SINGLETON(HJLaunchFailError)

/**
 *  功能:启动接口调用失败的错误处理
 *  返回:是否需要继续执行call back
 */
- (BOOL)dealWithManager:(HJOperationManager *)aManager
                  param:(HJOperationParam *)aParam
              operation:(NSURLSessionDataTask *)aOperation
         responseObject:(id)aResponseObject
                  error:(NSError *)aError
{
    if (aParam.rerunForLaunchFail) {
        return YES;
    }
    
    [aManager cacheOperationForLaunchFail:aParam];
    
    if (!self.handling && self.errorHandleBlock != nil) {
        self.handling = YES;
        @weakify(self);
        self.errorHandleBlock(^(BOOL success) {
            @strongify(self);
            self.handling = NO;
            if (success) {
                [[HJNetworkManager sharedInstance] performAllCachedOperationsForLaunchFail];
            } else {
                [[HJNetworkManager sharedInstance] clearAllCachedOperationsForLaunchFail];
            }
        });
    }
    
    return NO;
}

@end
