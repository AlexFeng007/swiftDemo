//
//  WUMonitor.h
//  FKY
//
//  Created by Rabe on 29/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WUDBLogger.h"
#import "WUErrorMessage.h"
#import "WUMonitorConfiguration.h"

#define WUMonitorInstance [WUMonitor sharedMonitor]
typedef void(^WUMonitorUploadCallback)(BOOL ret, NSString *msg);

@interface WUMonitor : NSObject

/**
 当前网络环境是否是WiFi
 */
@property (nonatomic, readonly, assign, getter=isWiFiMode) BOOL wiFiMode;

+ (WUMonitor *)sharedMonitor;

/**
 拦截记录api, h5, img加载错误到日志中
 */
- (void)saveApiError:(NSString *)method error:(NSError *)error;
- (void)saveImageDownloadError:(NSString *)imageUrl;
- (void)saveWebLoadingError:(NSString *)url error:(NSError *)error;
/**
 上传错误监控日志文档到服务器
 */
- (void)uploadErrorFileWithCallback:(WUMonitorUploadCallback)callback;

@end
