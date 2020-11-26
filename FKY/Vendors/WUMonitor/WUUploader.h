//
//  WUUploader.h
//  FKY
//
//  Created by Rabe on 01/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WUUploaderHandler)(BOOL ret, NSString *msg, NSError *error);

@interface WUUploader : NSObject
/**
 上传错入日志到服务器

 @param requestParams 请求体
 @param filePath 文件临时路径
 @param handler 回调方法
 */
+ (void)uploadWithParameters:(NSDictionary *)requestParams filePath:(NSString *)filePath handler:(WUUploaderHandler)handler;

@end
