//
//  WUMonitor.m
//  FKY
//
//  Created by Rabe on 31/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "WUMonitor.h"
#import "WUUploader.h"
#import "WUDeviceInfo.h"
#import "WUSignatureHelper.h"

@interface WUMonitor ()

@property (nonatomic, strong) WUDBLogger *logger;

@end

@implementation WUMonitor

+ (void)load {
#if FKY_ENVIRONMENT_MODE == 1   // 线上环境
    // app启动时判断wifi，若是则自动上传日志，成功后删除
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if ([WUMonitorInstance isWiFiMode]) {
            [WUMonitorInstance uploadErrorFileWithCallback:nil];
        }
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
        observer = nil;
    }];
#endif
}

+ (WUMonitor *)sharedMonitor {
    static WUMonitor *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)saveApiError:(NSString *)method error:(NSError *)error {
    if (method.length == 0 || method == nil) {
        return;
    }
    NSString *errName = method;
    NSInteger errCode = error ? error.code : 404;
    NSString *errDes = error ? [error localizedDescription] : @"未知错误描述";
    [self saveErrorName:errName errorType:WUMonitorErrorApi errorCode:errCode errorDes:errDes];
}

- (void)saveWebLoadingError:(NSString *)url error:(NSError *)error {
    if (url.length == 0 || url == nil) {
        return;
    }
    NSString *errName = url;
    NSInteger errCode = error ? error.code : 404;
    NSString *errDes = error ? [error localizedDescription] : @"未知错误描述";
    [self saveErrorName:errName errorType:WUMonitorErrorWeb errorCode:errCode errorDes:errDes];
}

- (void)saveImageDownloadError:(NSString *)imageUrl {
    if (imageUrl.length == 0 || imageUrl == nil) {
        return;
    }
    NSString *errName = imageUrl;
    [self saveErrorName:errName errorType:WUMonitorErrorImageLoading errorCode:404 errorDes:@"图片下载失败"];
}

- (void)saveErrorName:(NSString *)errName errorType:(WUMonitorError)errType errorCode:(NSInteger)errCode errorDes:(NSString *)errDes {
#if FKY_ENVIRONMENT_MODE == 1   // 线上环境
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
        BOOL islogin = [WUMonitorConfiguration defaultConfiguration].isLogin;
        // 1.生成message对象
        WUErrorMessage *message = [WUErrorMessage errorMessageWithErrName:errName errType:errType errCode:@(errCode).stringValue errDes:errDes];
        // 2.将message写入数据库
        [self.logger saveErrorMessage:message fileType:islogin ? WUMonitorFileTypeLogin : WUMonitorFileTypeLogout];
   // });
#endif
}

- (void)uploadErrorFileWithCallback:(WUMonitorUploadCallback)callback {
    NSString *tmpDir = NSTemporaryDirectory();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    __block BOOL result = YES;
    BOOL queueOnGoing = NO;
    WUMonitorUploadCallback block = ^(BOOL ret, NSString *msg) {
        CFRunLoopStop(CFRunLoopGetMain());
        result = ret;
    };
    if ([self.logger hasErrorReportWithFileType:WUMonitorFileTypeLogin]) {
        // 上传登录状态错误日志
        queueOnGoing = YES;
        NSString *fileName = [[WUMonitorConfiguration defaultConfiguration] tempFileNameWithFileType:WUMonitorFileTypeLogin];
        NSString *filePath = [tmpDir stringByAppendingString:fileName];
        if ([fileManager createFileAtPath:filePath contents:nil attributes:nil]) {
            [self uploadErrorFileWithFilePath:filePath fileName:fileName fileType:WUMonitorFileTypeLogin callback:callback == nil ? nil : block];
        }
    }
    if ([self.logger hasErrorReportWithFileType:WUMonitorFileTypeLogout]) {
        // 上传未登录状态h错误日志
        queueOnGoing = YES;
        NSString *fileName = [[WUMonitorConfiguration defaultConfiguration] tempFileNameWithFileType:WUMonitorFileTypeLogout];
        NSString *filePath = [tmpDir stringByAppendingString:fileName];
        if ([fileManager createFileAtPath:filePath contents:nil attributes:nil]) {
            [self uploadErrorFileWithFilePath:filePath fileName:fileName fileType:WUMonitorFileTypeLogout callback:callback == nil ? nil : block];
        }
    }
    // 以上任务执行后继续执行
    if (queueOnGoing && callback) {
        CFRunLoopRun();
    }
    if (callback) {
        if (!queueOnGoing) {
            callback(result, @"您的设备中暂无错误日志哦");
        } else {
            callback(result, result ? @"上传成功" : @"上传失败");
        }
    }
}

- (void)uploadErrorFileWithFilePath:(NSString *)filePath fileName:(NSString *)fileName fileType:(WUMonitorFileType)fileType callback:(void(^)(BOOL ret, NSString *msg))callback
{
    // 1.将数据库文件转换成临时用于上传的txt文件
    [self.logger writeTempFileAtPath:filePath fileType:fileType];
    // 2.签名 & 拼装接口入参
    NSString *timeStamp = [WUSignatureHelper getLocalTimeStamp];
    NSDictionary *params = @{ @"requesttime": @(timeStamp.integerValue), @"tradername": [WUMonitorConfiguration defaultConfiguration].appPrefix };
    NSMutableDictionary *signDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [signDict setValue:fileName forKey:@"filename"];
    NSString *signature = [WUSignatureHelper getSignature:signDict secretKey:[WUMonitorConfiguration defaultConfiguration].signatureKey];
    NSMutableDictionary *requestParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [requestParams setValue:signature forKey:@"sign"];
    // 3.调接口上传文件
    @weakify(self);
    [WUUploader uploadWithParameters:requestParams filePath:filePath handler:^(BOOL ret, NSString *msg, NSError *error) {
        @strongify(self);
        if (ret) {
            // 4.上传成功，删除数据库内所有数据，删除临时用于上传的txt文件
            [self.logger eraseErrorReportWithFileType:fileType];
            [self.logger removeTempFileAtPath:filePath];
            if (callback) {
                callback(YES, nil);
            }
        } else {
            // 5.上传失败，记录失败
            [self saveErrorName:[WUMonitorConfiguration defaultConfiguration].uploadUrl errorType:WUMonitorErrorApi errorCode:error ? error.code : 0 errorDes:msg];
            if (callback) {
                callback(NO, nil);
            }
        }
    }];
}

- (BOOL)isWiFiMode {
    return [WUDeviceInfo isReachableViaWiFi];
}

- (WUDBLogger *)logger {
    if (_logger == nil) {
        _logger = [[WUDBLogger alloc] initWithBundle:[NSBundle mainBundle] configuration:[WUMonitorConfiguration defaultConfiguration]];
    }
    return _logger;
}

@end
