//
//  GLBridge.h
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GLBridgeResponse.h"
#import "GLInteractiveDelegate.h"
#import "GLWebViewEngineProtocol.h"

@interface GLBridge : NSObject

@property (nonatomic, readonly, weak) UIView *webView;                           /* <WebView容器 */
@property (nonatomic, readonly, weak) id<GLWebViewEngineProtocol> webViewEngine; /* <webView引擎 */

@property (nonatomic, weak) UIViewController *viewController;              /* <ViewController实例 */
@property (nonatomic, weak) id<GLInteractiveDelegate> interactiveDelegate; /* <交互内核 */

/**
 初始化

 @param glWebViewEngine vc控制器中的webView引擎
 @return 实例对象
 */
- (instancetype)initWithWebViewEngine:(id<GLWebViewEngineProtocol>)glWebViewEngine;

/**
 提供给子类覆写该方法的机会
 */
- (void)initialization;

/**
 发送交互结果给js便捷方法

 @param data 交互业务内容
 @param callbackId 回调id
 */
- (void)sendOkRespToJSWithData:(NSDictionary *)data callbackid:(NSString *)callbackId;
- (void)sendWrongParamRespToJSWithCallbackid:(NSString *)callbackId;
- (void)sendUnloginRespToJSWithCallbackid:(NSString *)callbackId;

@end
