//
//  FKYEnvironment.h
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 App的运行环境
 提供基本的信息，如deviceId, userAgent等
 具体由不同的App来定义。一般在业务层中需要重载以提供自定义的FKYEnvironment（使用FKYInternal.h FKYInternalSetDefaultEnvironment）
 */
@interface FKYEnvironment : NSObject

/**
 FKYEnvironment以单例模式运行
 具体的App运行环境需要复写defaultEnvironment入口
 */
+ (FKYEnvironment *)defaultEnvironment;

/**
 调试开关是否已打开
 */
- (BOOL)isDebug;

/**
 硬件版本
 */
- (NSString *)platformString;

/**
 统一采用OPENUDID
 */
- (NSString *)deviceId;

/**
 一次session代表一次进程
 置为后台不会导致sessionId改变
 */
- (NSString *)sessionId;

/**
 Http Header "User-Agent"和"pragma-os"
 */
- (NSString *)userAgent;

/**
 App的版本
 */
- (NSString *)version;

/**
 发布渠道
 */
- (NSString *)channel;

/**
 *  统计的source
 *
 *  @return
 */
- (NSString *)source;

/**
 设备的型号
 iPhone, iPad, iPod, iOS (is unknown)
 */
- (NSString *)deviceModel;

/**
 AppStore中的AppId
 */
- (NSString *)appId;

/**
 Info.plist中定义
 如"com.dianping.dpscope"
 */
- (NSString *)bundleId;

/**
 *  用户Token
 */
- (NSString *)userToken;

/**
 *  App的url scheme
 */
- (NSString *)scheme;

- (NSString *)os;
- (NSString *)station;


#pragma mark - 网络相关配置

/**
 *  默认的网络请求超时时间
 *
 *  @return
 */
- (NSTimeInterval)HTTPRequestTimeoutInterval;


#pragma mark 配置网络的HTTPHeaderField

- (NSString *)userTokenForHTTPHeaderField;
- (NSString *)userAgentForHTTPHeaderField;
- (NSString *)deviceIdForHTTPHeaderField;


@end
