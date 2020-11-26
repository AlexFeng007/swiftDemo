//
//  FKYEnvironment.m
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import "FKYCore.h"
#import "FKYEnvironment.h"

static FKYEnvironment *__eHJ = nil;

void FKYInternalSetDefaultEnvironment(FKYEnvironment *eHJ) {
    __eHJ = eHJ;
}


@interface FKYEnvironment() {
    NSString *channel;
    NSString *source;
    NSString *sessionId;
    NSString *userAgent;
    NSString *userToken;
}
@end


@implementation FKYEnvironment

+ (FKYEnvironment *)defaultEnvironment
{
    NSAssert(__eHJ != nil, @"!!!!! 请配置FKYEnviroment");
    return __eHJ;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ChannelAndSource" ofType:@"plist"];
        NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:path];
        channel = config[@"channel"];
        source = config[@"source"];
    }
    return self;
}

/**
 Http Header "User-Agent"和"pragma-os"
 */
- (NSString *)userAgent
{
    if (userAgent == nil) {
//        userAgent = [NSString localizedStringWithFormat:@"YYWApp 1.0/IOS/%@/%@/%@/%@/%@/%@/",
//                     [[UIDevice currentDevice] model],
//                     [self deviceId],
//                     [UIDevice currentDevice].systemVersion,
//                     [[NSBundle mainBundle] bundleIdentifier],
//                     [NSString stringWithFormat:@"%@.%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]],
//                     @"AppStore"];
    }
    return userAgent;
}

- (NSString *)baseUrl
{
    return nil;
}

- (BOOL)isDebug
{
    return YES;
}

- (NSString *)platformString
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

- (NSString *)deviceId
{
    // 设备UDID
    return [UIDevice readIdfvForDeviceId];
}

- (NSString *)sessionId
{
    if(!sessionId) {
        CFUUIDRef uuidObj = CFUUIDCreate(nil);
        sessionId = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
        CFRelease(uuidObj);
    }
    return sessionId;
}

- (NSString *)version
{
    return @"v1.2";
}

- (NSString *)channel {
    if (channel) {
        return channel;
    } else {
        return @"AppStore";
    }
}

- (NSString *)source
{
    if (source) {
        return source;
    } else {
        return nil;
    }
}

- (NSString *)deviceModel
{
    NSString *modelName = [[UIDevice currentDevice] model];
    if ([modelName hasPrefix:@"iPhone"])
        return @"iPhone";
    else if ([modelName hasPrefix:@"iPod"])
        return @"iPod";
    else if ([modelName hasPrefix:@"iPad"])
        return @"iPad";
    return @"iOS";
}

- (NSString *)appId
{
    return nil;
}

- (NSString *)bundleId
{
    return nil;
}

- (NSString *)userToken
{
    //
    if (UD_OB(@"user_token")) {
        return UD_OB(@"user_token");
    }
    return @"";
}

- (NSString *)scheme
{
    return nil;
}

- (NSString *)os
{
    return @"ios";
}

- (NSString *)station
{
    if (UD_OB(@"currentStation")) {
        return UD_OB(@"currentStation");
    }
    return @"000000";
}


#pragma mark - 网络相关配置

- (NSTimeInterval)HTTPRequestTimeoutInterval
{
    // 设置超时时间
    return 30;
}


#pragma mark 配置网络的HTTPHeaderField

- (NSString *)userTokenForHTTPHeaderField
{
    return @"token";
}

- (NSString *)userAgentForHTTPHeaderField
{
    return @"User-Agent";
}

- (NSString *)deviceIdForHTTPHeaderField
{
    return @"Device-Id";
}

@end
