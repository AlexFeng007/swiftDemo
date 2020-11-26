//
//  WUMonitorConfiguration.h
//  FKY
//
//  Created by Rabe on 31/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WUMonitorConfiguration : NSObject

/// 数据库配置
/* 数据库中允许存放的最多条数，默认2000条 */
@property (nonatomic, readwrite, assign) NSInteger maxItemsInDatabase;

/// 业务配置
/* 不需要配置该属性，会通过userId来判断 */
@property (nonatomic, readwrite, assign, getter=isLogin) BOOL login;
/* 在每次app启动、用户登录成功、用户登出 必须重新配置用户id */
@property (nonatomic, readwrite, copy) NSString *userId;
/* 在每次app启动重新定位时、用户登录成功 必须重新配置城市名 */
@property (nonatomic, readwrite, copy) NSString *cityName;

/// 接口联调配置
/* 上传服务器文件名app标识 yw / yaoex */
@property (nonatomic, readwrite, copy) NSString *appPrefix;
/* 上传服务器时签名所需私钥 */
@property (nonatomic, readwrite, copy) NSString *signatureKey;
/* 上传服务器的url 默认 http://upload.111.com.cn/uploadfilelog */
@property (nonatomic, readwrite, copy) NSString *uploadUrl;

+ (WUMonitorConfiguration *) defaultConfiguration;
- (NSString *)tempFileNameWithFileType:(WUMonitorFileType)fileType;

@end
