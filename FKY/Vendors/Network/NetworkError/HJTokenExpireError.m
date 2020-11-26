//
//  HJTokenExpireError.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "HJTokenExpireError.h"
#import "HJNetworkManager.h"
//#import "HJGlobalValue.h"
#import "HJOperationParam.h"
#import "HJOperationManager.h"

@interface HJOperationParam ()

@property(nonatomic, assign) BOOL rerunForTokenExpire;                  //是否token过期自动登录后再次执行，默认为NO
@property(nonatomic, copy) NSString *usedToken;                         //记录当前请求使用的token

@end

@interface HJOperationManager()

/**
 *  功能:token过期时将operation暂存
 */
- (void)cacheOperationForTokenExpire:(HJOperationParam *)aParam;

@end

@interface HJNetworkManager()

/**
 *  功能:登录成功后执行所有暂存的operation
 */
- (void)performAllCachedOperationsForTokenExpire;

/**
 *  功能:登录失败后清除所有暂存的operation
 */
- (void)clearAllCachedOperationsForTokenExpire;

@end

@interface HJTokenExpireError()

@property(nonatomic, strong) NSMutableSet *tokenExpireRtnCodes;//所有token过期错误码,set<NSString>类型

@end

@implementation HJTokenExpireError

DEF_SINGLETON(HJTokenExpireError)

- (NSMutableSet *)tokenExpireRtnCodes
{
    if (_tokenExpireRtnCodes == nil) {
        _tokenExpireRtnCodes = [NSMutableSet set];
    }
    return _tokenExpireRtnCodes;
}

/**
 *  功能:添加token过期rtn_code
 */
- (void)addTokenExpireRtnCode:(NSString *)aRtnCode
{
    [self.tokenExpireRtnCodes addObject:aRtnCode];
}

/**
 *  功能:aRtnCode是否是token过期错误码
 */
- (BOOL)tokenExpiredForRtnCode:(NSString *)aRtnCode
{
    if([self.tokenExpireRtnCodes containsObject:aRtnCode]) {
        return YES;
    } 
    return NO;
}

/**
 *  功能:token过期的错误处理
 *  返回:是否需要继续执行call back
 */
- (BOOL)dealWithManager:(HJOperationManager *)aManager
                  param:(HJOperationParam *)aParam
              operation:(NSURLSessionDataTask *)aOperation
         responseObject:(id)aResponseObject
                  error:(NSError *)aError
{
    if (aParam.rerunForTokenExpire) {
        return YES;
    }
    
//    if ((![aParam.usedToken isEqualToString:[HJGlobalValue sharedInstance].token])
//        && [HJGlobalValue sharedInstance].token) {//新老token不一致并且新token存在
//        aParam.rerunForTokenExpire = YES;
//        [aManager requestWithParam:aParam];
//    } else {
        [aManager cacheOperationForTokenExpire:aParam];
        
        if (!self.handling && self.errorHandleBlock != nil) {
            self.handling = YES;
            @weakify(self);
            self.errorHandleBlock(^(BOOL success) {
                @strongify(self);
                self.handling = NO;
                if (success) {
                    [[HJNetworkManager sharedInstance] performAllCachedOperationsForTokenExpire];
                } else {
                    [[HJNetworkManager sharedInstance] clearAllCachedOperationsForTokenExpire];
                }
            });
        }
//    }
    
    return NO;
}

@end
