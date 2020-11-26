//
//  HJLaunch.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2014 HJ. All rights reserved.
//

#import "HJLaunch.h"
//net
#import "HJTokenExpireError.h"
#import "HJSignKeyExpireError.h"
#import "HJLaunchFailError.h"
#import "HJTimeOutError.h"
#import "HJNetworkManager.h"

//io
//#import "HJKeychain.h"

//logic
#import "HJLaunchLogic.h"

#import "HJGlobalValue.h"

@interface HJLaunch ()

@property (nonatomic, strong) HJLaunchLogic *launchLogic;



@end

@implementation HJLaunch

DEF_SINGLETON(HJLaunch)

#pragma mark - action
/**
 *  功能:window显示之前调用
 */
- (void)launchBeforeShowWindowWithOptions:(NSDictionary *)launchOptions
{
    //注册启动接口失败处理block
    [self registSignatureFailHandleBlock];
    
    //注册密钥过期处理block
    [self registSignKeyExpireHandleBlock];
}

/**
 *  功能:window显示之后调用
 */
- (void)launchAfterShowWindowWithOptions:(NSDictionary *)launchOptions
{
    //主线程调用启动接口
    [self getSignKeyWithCompletionBlock:^(BOOL success){
        
    }];
}

/**
 *  功能:从后台到前台
 */
- (void)launchAfterEnterForeground
{
}

#pragma mark - data
/**
 *  功能:获取密钥
 */
- (void)getSignKeyWithCompletionBlock:(HJErrorHandleCompleteBlock)aBlock
{
    [self.launchLogic getMySecretKey:^(id aResponseObject, NSError *anError) {
        if (aBlock) {
            aBlock(anError == nil);
        }
    }];
}

#pragma mark - private

/**
 *  功能:注册密钥过期处理block(重新获取密钥)
 */
- (void)registSignKeyExpireHandleBlock
{
    //签名验证失败
    [[HJSignKeyExpireError sharedInstance] addSignKeyExpireRtnCode:@"000000000003"];
    // 时间戳验证失败
    [[HJSignKeyExpireError sharedInstance] addSignKeyExpireRtnCode:@"000000000004"];
    
    [[HJSignKeyExpireError sharedInstance] setErrorHandleBlock:^(HJErrorHandleCompleteBlock errorHandleCompleteBlock) {
        [self getSignKeyWithCompletionBlock:errorHandleCompleteBlock];
    }];
}

/**
 *  功能:注册启动接口失败处理block
 */
- (void)registSignatureFailHandleBlock
{
    @weakify(self);
    [[HJLaunchFailError sharedInstance] setErrorHandleBlock:^(HJErrorHandleCompleteBlock errorHandleCompleteBlock) {
        @strongify(self);
        [self getSignKeyWithCompletionBlock:errorHandleCompleteBlock];
    }];
}

#pragma mark - Property
/**
 *  功能:启动logic
 *
 *  @return 启动logic
 */
- (HJLaunchLogic *)launchLogic
{
    if (_launchLogic == nil) {
        _launchLogic = [HJLaunchLogic logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _launchLogic;
}

@end
