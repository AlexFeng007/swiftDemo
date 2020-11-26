//
//  GLHybridEnvironment.m
//  FKY
//
//  Created by Rabe on 23/08/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "GLHybridEnvironment.h"

@implementation GLHybridEnvironment
@synthesize openLocalWeb = _openLocalWeb, openRemoteDev = _openRemoteDev;

+ (instancetype)shared
{
    static dispatch_once_t once;
    static GLHybridEnvironment *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[GLHybridEnvironment alloc] init];
    });
    return sharedInstance;
}

#pragma mark hybrid框架H5加载环境配置

- (void)setOpenLocalWeb:(BOOL)openLocalWeb
{
    _openLocalWeb = openLocalWeb;
    UD_ADD_OB(@(openLocalWeb), @"openLocalWeb");
}

- (BOOL)openLocalWeb
{
    if (!_openLocalWeb) { // 实际并不能在值为no的状态下阻止再次取值
        NSNumber *flag = UD_OB(@"openLocalWeb");
        if (flag) {
            _openLocalWeb = [flag boolValue];
        }
        else {
            _openLocalWeb = YES; // 默认值
        }
    }
    
    return _openLocalWeb;
}

- (void)setOpenRemoteDev:(BOOL)openRemoteDev
{
    _openRemoteDev = openRemoteDev;
    UD_ADD_OB(@(openRemoteDev), @"openRemoteDev");
}

- (BOOL)openRemoteDev
{
    if (!_openRemoteDev) {//实际并不能在值为no的状态下阻止再次取值
        NSNumber *flag = UD_OB(@"openRemoteDev");
        if (flag) {
            _openRemoteDev = [flag boolValue];
        }
        else {
            _openRemoteDev = YES; // 默认值
        }
    }
    
    return _openRemoteDev;
}

@end
