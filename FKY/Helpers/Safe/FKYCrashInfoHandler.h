//
//  FKYCrashInfoHandler.h
//  FKY
//
//  Created by 夏志勇 on 2019/10/24.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  将捕获和处理的crash信息上报到bugly...<防止本地对crash处理后bugly上无记录>

#import <Foundation/Foundation.h>
#import <Bugly/Bugly.h>

NS_ASSUME_NONNULL_BEGIN

@interface FKYCrashInfoHandler : NSObject

// bugly上报
+ (void)uploadCrashInfo:(NSString *)crashInfo;
+ (void)uploadBuglyWithError:(NSError *)aError info:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
