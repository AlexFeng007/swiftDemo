//
//  FKYCrashInfoHandler.m
//  FKY
//
//  Created by 夏志勇 on 2019/10/24.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

#import "FKYCrashInfoHandler.h"
#import "Foundation+Safe.h"

@implementation FKYCrashInfoHandler

+ (void)uploadCrashInfo:(NSString *)crashInfo {
    NSError *error = [NSError errorWithDomain:crashInfo code:0 userInfo:nil];
    NSMutableDictionary *info = @{}.mutableCopy;
    [info safeSetObject:[NSThread callStackSymbols] forKey:@"callStack"];
    [FKYCrashInfoHandler uploadBuglyWithError:error info:info];
}

+ (void)uploadBuglyWithError:(NSError *)aError info:(NSDictionary *)info {
    #if FKY_ENVIRONMENT_MODE == 1 // 线上环境(正式版)
    #if FKY_BUGLY_MODE == 1 // 提审版
        NSMutableDictionary *extendInfo = aError.userInfo.mutableCopy;
        [extendInfo safeSetObject:info forKey:@"extendInfo"];
        aError = [NSError errorWithDomain:aError.domain code:aError.code userInfo:extendInfo];
        [Bugly reportError:aError];
    #endif
    #endif
    
    BLYLogError(@"%@\n%@", aError.domain, info);
}

@end
