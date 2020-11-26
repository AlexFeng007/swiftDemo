//
//  WUUploader.m
//  FKY
//
//  Created by Rabe on 01/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "WUUploader.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@implementation WUUploader

+ (void)uploadWithParameters:(NSDictionary *)requestParams filePath:(NSString *)filePath handler:(WUUploaderHandler)handler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    NSString *url = [WUMonitorConfiguration defaultConfiguration].uploadUrl;
    BOOL valid = url.length && [url hasPrefix:@"http"];
    if (!valid) {
        return;
    }
    
    [manager POST:url parameters:requestParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" error:nil];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        BOOL success = [dict[@"result"] boolValue];
        NSString *msg = dict[@"msg"];
        if (success) {
            handler(YES, msg, nil);
        } else {
            if (msg.length) {
                NSLog(@"\n【WUMonitor DEBUG】传输监控日志文件到服务器 失败，原因：%@\n", msg);
                handler(NO, msg, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"\n【WUMonitor DEBUG】传输监控日志文件到服务器 失败，原因：%@\n", [error localizedDescription]);
        handler(NO, [error localizedDescription], error);
    }];
}

@end
