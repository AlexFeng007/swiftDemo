//
//  HJNetworkManager.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "HJNetworkManager.h"
#import "HJOperationManager.h"
#import <AFNetworking/AFNetworking.h>

@interface HJOperationManager()

#pragma mark - Token Expire
/**
 *  功能:登录成功后执行所有暂存的operation
 */
- (void)performCachedOperationsForTokenExpire;

/**
 *  功能:登录失败后清除所有暂存的operation
 */
- (void)clearCachedOperationsForTokenExpire;

#pragma mark - Sign Key Expire
/**
 *  功能:获取密钥接口成功后执行所有暂存的operation
 */
- (void)performCachedOperationsForSignKeyExpire;

/**
 *  功能:获取密钥接口失败后清除所有暂存的operation
 */
- (void)clearCachedOperationsForSignKeyExpire;

#pragma mark - Launch Fail
/**
 *  功能:relaunch成功后执行所有暂存的operation
 */
- (void)performCachedOperationsForLaunchFail;

/**
 *  功能:relaunch失败后清除所有暂存的operation
 */
- (void)clearCachedOperationsForLaunchFail;

@end

@interface HJNetworkManager()

@property(nonatomic, strong) NSMutableArray *operationManagers;

@end

@implementation HJNetworkManager

DEF_SINGLETON(HJNetworkManager)

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (NSMutableArray *)operationManagers
{
    if (_operationManagers == nil) {
        _operationManagers = [NSMutableArray array];
    }
    
    return _operationManagers;
}

/**
 *  功能:产生一个operation manager
 */
- (HJOperationManager *)generateOperationMangerWithOwner:(id)owner
{
    HJOperationManager *operationManager = [HJOperationManager managerWithOwner:owner];
    [self.operationManagers addObject:operationManager];
    
    return operationManager;
}

/**
 *  功能:移除operation manager
 */
- (void)removeOperationManger:(HJOperationManager *)aOperationManager
{
    [self.operationManagers removeObject:aOperationManager];
}

/**
 *  功能:取消所有operation
 */
- (void)cancelAllOperations
{
    NSArray *copyArray = self.operationManagers.copy;
    for (HJOperationManager *operationManger in copyArray) {
        [operationManger.tasks makeObjectsPerformSelector:@selector(cancel)];
        [self.operationManagers removeObject:operationManger];
    }
}

#pragma mark - Token Expire
/**
 *  功能:登录成功后执行所有暂存的operation
 */
- (void)performAllCachedOperationsForTokenExpire
{
    NSArray *copyArray = self.operationManagers.copy;
    for (HJOperationManager *manager in copyArray) {
        [manager performCachedOperationsForTokenExpire];
    }
}

/**
 *  功能:登录失败后清除所有暂存的operation
 */
- (void)clearAllCachedOperationsForTokenExpire
{
    NSArray *copyArray = self.operationManagers.copy;
    for (HJOperationManager *manager in copyArray) {
        [manager clearCachedOperationsForTokenExpire];
    }
}

#pragma mark - Sign Key Expire
/**
 *  功能:获取密钥成功后执行所有暂存的operation
 */
- (void)performAllCachedOperationsForSignKeyExpire
{
    NSArray *copyArray = self.operationManagers.copy;
    for (HJOperationManager *manager in copyArray) {
        [manager performCachedOperationsForSignKeyExpire];
    }
}

/**
 *  功能:获取密钥失败后清除所有暂存的operation
 */
- (void)clearAllCachedOperationsForSignKeyExpire
{
    NSArray *copyArray = self.operationManagers.copy;
    for (HJOperationManager *manager in copyArray) {
        [manager clearCachedOperationsForSignKeyExpire];
    }
}

#pragma mark - Launch Fail
/**
 *  功能:执行所有暂存的operation
 */
- (void)performAllCachedOperationsForLaunchFail
{
    NSArray *copyArray = self.operationManagers.copy;
    for (HJOperationManager *manager in copyArray) {
        [manager performCachedOperationsForLaunchFail];
    }
}

/**
 *  功能:清除所有暂存的operation
 */
- (void)clearAllCachedOperationsForLaunchFail
{
    NSArray *copyArray = self.operationManagers.copy;
    for (HJOperationManager *manager in copyArray) {
        [manager clearCachedOperationsForLaunchFail];
    }
}

@end
