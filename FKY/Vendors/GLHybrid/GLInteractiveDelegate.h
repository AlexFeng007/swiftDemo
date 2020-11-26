//
//  GLInteractiveDelegate.h
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLJsRequest.h"

@class GLBridgeResponse;

@protocol GLInteractiveDelegate <NSObject>

/**
 执行js请求

 @param url 被拦截的符合约定规则的url
 */
- (void)executeJsRequestFromURL:(NSURL *)url;

/**
 发送Native处理结果给js

 @param response 处理结果
 @param callbackId js发送过来的request附带的callid
 */
- (void)sendBridgeResponseToJs:(GLBridgeResponse *)response callbackId:(NSString *)callbackId;
/**
 在主线程执行js语句

 @param js 被执行语句
 */
- (void)evaluateJs:(NSString *)js;

@end
