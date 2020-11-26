//
//  GLCookieSyncManager.m
//  YYW
//
//  Created by Rabe on 2017/2/24.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLCookieSyncManager.h"
#import "GLHybrid.h"
#import "GLHybridSettings.h"

static NSString *FKY_HYBRID_DOMAIN;
static NSString *const COOKIES_ARCHIVER_KEY = @"com.yaocheng.cookieArchiver";

@interface GLCookieSyncManager ()

@end

@implementation GLCookieSyncManager

#pragma mark - life cycle

+ (GLCookieSyncManager *)sharedManager
{
    static dispatch_once_t onceToken;
    static GLCookieSyncManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        FKY_HYBRID_DOMAIN = [GLHybridSettings settingForKey:@"Hybrid-domain" class:NSString.class defaultVal:@""];
    });
    return manager;
}

#pragma mark - public

- (NSMutableString *)documentCookieJavaScript
{
    NSMutableString *script = [[NSMutableString alloc] init];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if ([cookie.domain isEqualToString:FKY_HYBRID_DOMAIN]) {
            NSString *cookieString = [NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value];
            BOOL isLogin = [FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin;
            NSTimeInterval validTime = 24 * 60 * 60 * (isLogin ? 7 : -1);
            if ([cookie.name isEqualToString:@"ycstationName"] || [cookie.name isEqualToString:@"yccity_id"]) {
                validTime = 24 * 60 * 60 * 7;
            }
            NSDate *date = [[NSDate date] initWithTimeIntervalSinceNow: + validTime];
            NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:@"GMT"];
            [NSTimeZone setDefaultTimeZone:tzGMT];
            NSDateFormatter *iosDateFormater=[[NSDateFormatter alloc]init];
            iosDateFormater.dateFormat=@"EEE, d MMM yyyy HH:mm:ss 'GMT'";
            iosDateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            NSString *dateStr = [iosDateFormater stringFromDate:date];
            [script appendString:[NSString stringWithFormat:@"document.cookie='%@;path=/;expires=%@;domain=.yaoex.com';", cookieString, dateStr]];
        }
    }
    return script;
}

- (void)loadSavedCookies
{
    [self updateAllCookies];
}

- (void)updateAllCookies
{
    for (NSHTTPCookie *cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    NSArray *names = @[
                       @"ycuserType",
                       @"yctoken",
                       @"ycgltoken",
                       @"ycusername",
                       @"ycuserId",
                       @"ycnameList",
                       @"yccity_id",
                       @"ycavatarUrl",
                       @"ycenterpriseName",
                       @"ycstationName",
                       @"ycroleId",
                       @"ycuserinfo",
                       @"deviceId",
                       @"version",
                       @"versionCode",
                       @"ycenterpriseId",
                       @"mobile",
                       @"channelname",
                       @"channelId",
                       @"operator",
                       @"os",
                       @"os_version"];
    FKYUserInfoModel *user = [FKYLoginAPI currentUser];
    NSArray *values = @[
                        [self safeValue:user.userType],
                        [self safeValue:user.token],
                        [self safeValue:user.gltoken],
                        [self safeValue:user.userName],
                        [self safeValue:user.userId],
                        [self safeValue:user.nameList],
                        [self safeValue:user.city_id],
                        [self safeValue:user.avatarUrl],
                        [self safeValue:user.enterpriseName],
                        [self safeValue:user.stationName],
                        [self safeValue:user.roleId],
                        [self safeValue:user.ycuserinfo],
                        [self safeValue:[UIDevice readIdfvForDeviceId]],
                        [self safeValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]],
                        [self safeValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]],
                        [self safeValue:user.ycenterpriseId],
                        [self safeValue:UD_OB(@"user_mobile")],
                        @"App Store",
                        @"1051",
                        [self safeValue:[FKYAnalyticsUtility getDeviceOperator]],
                        [self safeValue:[FKYAnalyticsUtility getDevicePlatform]],
                        [self safeValue:[FKYAnalyticsUtility getDeviceSystemVersion]]
                        ];
    
    [self updateCookieNames:names values:values domainUrl:FKY_HYBRID_DOMAIN originUrl:FKY_HYBRID_DOMAIN];
}

- (NSDictionary *)hybridCookieDictionary
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    for (NSHTTPCookie *cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        if ([cookie.domain isEqualToString:FKY_HYBRID_DOMAIN]) {
            [mDict setObject:cookie.value forKey:cookie.name];
        }
    }
    return mDict;
}

- (void)updateCookieName:(NSString *)name value:(NSString *)value domainUrl:(NSString *)domainUrl originUrl:(NSString *)originUrl
{
    value = [value urlEncodingUTF8];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    cookieProperties[NSHTTPCookieDomain] = domainUrl;
    cookieProperties[NSHTTPCookieName] = name;
    cookieProperties[NSHTTPCookieValue] = value;
    cookieProperties[NSHTTPCookiePath] = @"/";
    cookieProperties[NSHTTPCookieVersion] = @"0";
    cookieProperties[NSHTTPCookieOriginURL] = originUrl.length ? originUrl : domainUrl;

    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

- (void)updateCookieName:(NSString *)name value:(NSString *)value
{
    value = [value urlEncodingUTF8];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    cookieProperties[NSHTTPCookieDomain] = FKY_HYBRID_DOMAIN;
    cookieProperties[NSHTTPCookieName] = name;
    cookieProperties[NSHTTPCookieValue] = value;
    cookieProperties[NSHTTPCookiePath] = @"/";
    cookieProperties[NSHTTPCookieVersion] = @"0";
    cookieProperties[NSHTTPCookieOriginURL] = FKY_HYBRID_DOMAIN;
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

- (void)deleteCookieName:(NSString *)name
{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]
            .cookies.copy enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSHTTPCookie *cookie = obj;
        if ([cookie.properties[NSHTTPCookieName] isEqualToString:name]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:obj];
            *stop = YES;
        }
    }];
}

#pragma mark - private

- (void)updateCookieNames:(NSArray *)names values:(NSArray *)values domainUrl:(NSString *)domainUrl originUrl:(NSString *)originUrl
{
    for (NSUInteger i = 0; i < names.count; i++) {
        NSString *name = names[i];
        id value = values[i];
        [self updateCookieName:name value:value domainUrl:domainUrl originUrl:originUrl];
    }
    // cookie发生改变后，发广播
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GLCookiesDidChangedNotification" object:nil];
}

+ (void)saveCookies
{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:cookiesData forKey:COOKIES_ARCHIVER_KEY];
    [defaults synchronize];
}

- (NSString *)safeValue:(id)value
{
    if (!value) {
        return @"";
    }
    if ([value isKindOfClass:NSString.class]) {
        return (NSString *)value;
    }
    else if ([value isKindOfClass:NSNumber.class]) {
        return [value stringValue];
    }
    else {
        return @"";
    }
}

@end
