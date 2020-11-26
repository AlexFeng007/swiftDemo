//
//  GLBridge.m
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLBridge.h"
#import "GLViewController.h"
#import <objc/message.h>

@interface GLBridge ()

@property (nonatomic, readwrite, weak) id<GLWebViewEngineProtocol> webViewEngine;

@end

@implementation GLBridge

@synthesize webViewEngine, viewController, interactiveDelegate;
@dynamic webView;

#pragma mark - life cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithWebViewEngine:(id<GLWebViewEngineProtocol>)glWebViewEngine
{
    self = [super init];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(appWillTerminate)
//                                                     name:UIApplicationWillTerminateNotification
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(appDidReceiveMemoryWarning)
//                                                     name:UIApplicationDidReceiveMemoryWarningNotification
//                                                   object:nil];
        self.webViewEngine = glWebViewEngine;
    }
    return self;
}

- (void)initialization
{
    // 子类覆写此方法
}

#pragma mark - public

- (void)sendOkRespToJSWithData:(NSDictionary *)data callbackid:(NSString *)callbackId
{
    GLBridgeResponse *reponse = [GLBridgeResponse reponseWithErrCode:GLBridgeRespCode_OK data:data];
    [self.interactiveDelegate sendBridgeResponseToJs:reponse callbackId:callbackId];
}

- (void)sendWrongParamRespToJSWithCallbackid:(NSString *)callbackId
{
    GLBridgeResponse *reponse = [GLBridgeResponse reponseWithErrCode:GLBridgeRespCode_WRONG_PARAM data:nil];
    [self.interactiveDelegate sendBridgeResponseToJs:reponse callbackId:callbackId];
}

- (void)sendUnloginRespToJSWithCallbackid:(NSString *)callbackId
{
    GLBridgeResponse *reponse = [GLBridgeResponse reponseWithErrCode:GLBridgeRespCode_UNLOGIN data:nil];
    [self.interactiveDelegate sendBridgeResponseToJs:reponse callbackId:callbackId];
}

#pragma mark - notification

//- (void)appWillTerminate
//{
//}

//- (void)appDidReceiveMemoryWarning
//{
//}

#pragma mark - property

- (UIView *)webView
{
    if (self.webViewEngine) {
        return self.webViewEngine.engineWebView;
    }
    return nil;
}

@end
