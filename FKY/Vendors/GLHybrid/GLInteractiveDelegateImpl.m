//
//  GLInteractiveDelegateImpl.m
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLInteractiveDelegateImpl.h"
#import "GLViewController.h"
#import <objc/message.h>

@interface GLInteractiveDelegateImpl ()

@property (nonatomic, weak) GLViewController *viewController;         /* <视图控制器 */

@end

@implementation GLInteractiveDelegateImpl

#pragma mark - life cycle

- (instancetype)initWithViewController:(GLViewController *)viewController
{
    self = [super init];
    if (self != nil) {
        _viewController = viewController;
    }
    return self;
}

#pragma mark - GLInteractiveDelegate

- (void)executeJsRequestFromURL:(NSURL *)url
{
    GLJsRequest *request = [GLJsRequest jsRequestFromURL:url];

    if (![self execute:request]) {
        NSLog(@"\n【GLHybrid】ERROR: native方法执行失败, callbackId: %@: method: %@\n\n", request.callbackId, request.methodName);
    }
}

- (void)sendBridgeResponseToJs:(GLBridgeResponse *)response callbackId:(NSString *)callbackId
{
    if (![self isValidCallbackId:callbackId]) {
        NSLog(@"\n【GLHybrid】ERROR: callbackId无效\n\n");
        return;
    }

    NSString *parameterAsJSON = [response callBackParamAsJSONWithId:callbackId];
    NSString *js = [NSString stringWithFormat:@"callback(%@)", parameterAsJSON];
    [self evaluateJs:js];
}

- (void)evaluateJs:(NSString *)js
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(evaluateJsOnMainThread:) withObject:js waitUntilDone:NO];
    }
    else {
        [self evaluateJsOnMainThread:js];
    }
}

- (void)evaluateJsOnMainThread:(NSString *)js
{
    NSLog(@"\n【GLHybrid】即将执行js: %@\n\n", [js substringToIndex:MIN([js length], 160)]);
    [_viewController.webViewEngine evaluateJavaScript:js
                                    completionHandler:^(id obj, NSError *error) {
                                        if ([obj isKindOfClass:[NSString class]]) {
                                            NSString *returnJSON = (NSString *) obj;
                                            if ([returnJSON length] > 0) {
                                                NSLog(@"\n【GLHybrid】执行js结束, 收到responseJSON: %@\n\n", returnJSON);
                                            }
                                        }
                                    }];
}

#pragma mark - private

- (BOOL)isValidCallbackId:(NSString *)callbackId
{
    if (callbackId == nil || [callbackId length] == 0) {
        return NO;
    }

    return YES;
}

- (BOOL)execute:(GLJsRequest *)cmd
{
    if (cmd.methodName == nil) {
        NSLog(@"\n【GLHybrid】ERROR: JS请求method未找到\n\n");
        return NO;
    }

    GLBridge *obj = [_viewController nativeAPI];
    if (!([obj isKindOfClass:[GLBridge class]])) {
        return NO;
    }
    
    BOOL exeResult = YES;
    double started = [[NSDate date] timeIntervalSince1970] * 1000.0;

    NSString *methodName = [NSString stringWithFormat:@"%@:", cmd.methodName];
    SEL normalSelector = NSSelectorFromString(methodName);
    if ([obj respondsToSelector:normalSelector]) {
        NSLog(@"\n【GLHybrid】支持: method '%@' \n\n", methodName);
        ((void (*)(id, SEL, id)) objc_msgSend)(obj, normalSelector, cmd);
    }
    else {
        NSLog(@"\n【GLHybrid】ERROR: method '%@' 不在支持接口列表之中\n\n", methodName);
        exeResult = NO;
    }
    double elapsed = [[NSDate date] timeIntervalSince1970] * 1000.0 - started;
    if (elapsed > 100) {
        NSLog(@"\n【GLHybrid】线程警告: ['%@'] 执行耗费 '%f' ms. 请考虑在多线程内执行.\n\n", methodName, elapsed);
    }
    return exeResult;
}

@end
