//
//  GLCookieSyncManager.h
//  YYW
//
//  Created by Rabe on 2017/2/24.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLCookieSyncManager : NSObject

/**
 单例
 */
+ (GLCookieSyncManager *)sharedManager;
/**
 更新存储于NSHTTPCookieStorage的Cookie
 */
- (void)updateAllCookies;
/**
 app启动时将存储于本地的cookie设置到NSHTTPCookieStorage中
 */
- (void)loadSavedCookies;
/**
 返回存储到WebView中的Cookie
 */
- (NSDictionary *)hybridCookieDictionary;
/**
 更新某个特定cookie，若无则插入
 */
- (void)updateCookieName:(NSString *)name value:(NSString *)value domainUrl:(NSString *)domainUrl originUrl:(NSString *)originUrl;
/**
 更新某个特定cookie，若无则插入
 */
- (void)updateCookieName:(NSString *)name value:(NSString *)value;
/**
 set document-cookie
 */
- (NSMutableString *)documentCookieJavaScript;

@end
