//
//  GLMediator+WebViewActions.m
//  YYW
//
//  Created by Rabe on 23/03/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "GLMediator+WebViewActions.h"

NSString *const kGLMediatorTargetWebView = @"webView";

NSString *const kGLMediatorActionJsFetchWebViewController = @"jsFetchWebViewController";
NSString *const kGLMediatorActionNativeFetchHybridTestWebViewController = @"nativeFetchHybridTestWebViewController"; 

@implementation GLMediator (WebViewActions)

- (UIViewController *)glMediator_webviewViewControllerWithParams:(NSDictionary *)params
{
    return [self performTarget:kGLMediatorTargetWebView
                        action:kGLMediatorActionJsFetchWebViewController
                        params:params
             shouldCacheTarget:NO];
}

- (UIViewController *)glMediator_hybridTestPage
{
    return [self performTarget:kGLMediatorTargetWebView
                        action:kGLMediatorActionNativeFetchHybridTestWebViewController
                        params:nil
             shouldCacheTarget:NO];
}

@end
