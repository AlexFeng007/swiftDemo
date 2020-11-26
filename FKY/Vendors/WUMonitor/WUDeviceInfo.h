//
//  WUDeviceInfo.h
//  FKY
//
//  Created by Rabe on 31/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WUDeviceInfo : NSObject
/**
 是否是wifi模式
 */
+ (BOOL)isReachableViaWiFi;
/**
 获取手机网络状态
 */
+ (NSString *)netTypeStatus;
/**
 获取手机运营商名称
 */
+ (NSString *)carrierName;
/**
 设备uuid
 */
+ (NSString *)UUIDString;
+ (NSString *)UUIDMD5String;
/**
 设备类型
 */
+ (NSString *)systemName;
/**
 app版本号
 */
+ (NSString *)bundleMarketingVersion;
/**
 系统版本号
 */
+ (NSString *)systemVersion;
/**
 当前时间(年月日时分秒)
 */
+ (NSString *)currentTimestamp;

@end
