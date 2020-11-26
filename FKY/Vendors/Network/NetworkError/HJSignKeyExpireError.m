//
//  HJSignKeyExpireError.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2014 HJ. All rights reserved.
//

#import "HJSignKeyExpireError.h"
#import "HJNetworkManager.h"
#import "HJOperationParam.h"
#import "HJOperationManager.h"

@interface HJOperationParam ()

@property(nonatomic, assign) BOOL rerunForSignKeyExpire;                //是否重新调用获取密钥接口后再次执行，默认为NO

@end

@interface HJOperationManager()

/**
 *  功能:密钥过期时将operation暂存
 */
- (void)cacheOperationForSignKeyExpire:(HJOperationParam *)aParam;

@end

@interface HJNetworkManager()

/**
 *  功能:获取密钥成功后执行所有暂存的operation
 */
- (void)performAllCachedOperationsForSignKeyExpire;

/**
 *  功能:获取密钥失败后清除所有暂存的operation
 */
- (void)clearAllCachedOperationsForSignKeyExpire;

@end

@interface HJSignKeyExpireError()

@property(nonatomic, strong) NSMutableArray *signKeyExpireRtnCodes;//所有密钥过期错误码,list<NSString>类型

@end

@implementation HJSignKeyExpireError

DEF_SINGLETON(HJSignKeyExpireError)

- (NSMutableArray *)signKeyExpireRtnCodes
{
    if (_signKeyExpireRtnCodes == nil) {
        _signKeyExpireRtnCodes = [NSMutableArray array];
    }
    return _signKeyExpireRtnCodes;
}

/**
 *  功能:添加密钥过期rtn_code
 */
- (void)addSignKeyExpireRtnCode:(NSString *)aRtnCode
{
    [self.signKeyExpireRtnCodes addObject:aRtnCode];
}

/**
 *  功能:aRtnCode是否是密钥过期错误码
 */
- (BOOL)signKeyExpiredForRtnCode:(NSString *)aRtnCode
{
    for (NSString *rtnCode in self.signKeyExpireRtnCodes) {
        if ([rtnCode isEqualToString:aRtnCode]) {
            return YES;
        }
    }
    return NO;
}

/**
 *  功能:密钥过期的错误处理
 *  返回:是否需要继续执行call back
 */
- (BOOL)dealWithManager:(HJOperationManager *)aManager
                  param:(HJOperationParam *)aParam
              operation:(NSURLSessionDataTask *)aOperation
         responseObject:(id)aResponseObject
                  error:(NSError *)aError
{
    if (aParam.rerunForSignKeyExpire) {
        return YES;
    }
    
    [aManager cacheOperationForSignKeyExpire:aParam];
    
    if (!self.handling && self.errorHandleBlock != nil) {
        self.handling = YES;
        @weakify(self);
        self.errorHandleBlock(^(BOOL success) {
            @strongify(self);
            self.handling = NO;
            if (success) {
                [[HJNetworkManager sharedInstance] performAllCachedOperationsForSignKeyExpire];
            } else {
                [[HJNetworkManager sharedInstance] clearAllCachedOperationsForSignKeyExpire];
            }
        });
    }
    
    return NO;
}

@end
