//
//  AppDelegate+OpenPrivateScheme.h
//  FKY
//
//  Created by Rabe on 11/09/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "AppDelegate.h"

@class FKYSplashModel;

@interface AppDelegate (OpenPrivateScheme)

- (void)p_openPriveteSchemeString:(NSString *)urlStr; //app中统一调整h5或者可配置的fky链接
- (BOOL)p_openPriveteScheme:(NSURL *)url;
- (BOOL)openUrlFromWidget:(NSURL *)url;

- (void)jumpSplash:(FKYSplashModel *)model;

@end
